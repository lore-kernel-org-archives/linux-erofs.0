From: gaoxiang25@huawei.com (Gao Xiang)
Date: Wed, 20 Feb 2019 17:18:48 +0800
Subject: [PATCH for-4.19 06/12] staging: erofs: fix race when the managed
 cache is enabled
In-Reply-To: <20190220091854.19242-1-gaoxiang25@huawei.com>
References: <20190220091854.19242-1-gaoxiang25@huawei.com>
Message-ID: <20190220091854.19242-7-gaoxiang25@huawei.com>

commit 51232df5e4b268936beccde5248f312a316800be upstream.

When the managed cache is enabled, the last reference count
of a workgroup must be used for its workstation.

Otherwise, it could lead to incorrect (un)freezes in
the reclaim path, and it would be harmful.

A typical race as follows:

Thread 1 (In the reclaim path)  Thread 2
workgroup_freeze(grp, 1)                                refcnt = 1
...
workgroup_unfreeze(grp, 1)                              refcnt = 1
                                workgroup_get(grp)      refcnt = 2 (x)
workgroup_put(grp)                                      refcnt = 1 (x)
                                ...unexpected behaviors

* grp is detached but still used, which violates cache-managed
  freeze constraint.

Reviewed-by: Chao Yu <yuchao0 at huawei.com>
Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh at linuxfoundation.org>
Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>

Conflicts:
	drivers/staging/erofs/utils.c
Updates:
	include/linux/xarray.h:
		add xa_untag_pointer,xa_tag_pointer,xa_pointer_tag
		from upstream 3159f943aafd in order to reduce
		conflicts.

Cc: Matthew Wilcox <willy at infradead.org>
Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>
---
 drivers/staging/erofs/internal.h |   1 +
 drivers/staging/erofs/utils.c    | 138 +++++++++++++++++++++++++++------------
 include/linux/xarray.h           |  48 ++++++++++++++
 3 files changed, 145 insertions(+), 42 deletions(-)

diff --git a/drivers/staging/erofs/internal.h b/drivers/staging/erofs/internal.h
index e6313c54e3ad..122ea5016f3b 100644
--- a/drivers/staging/erofs/internal.h
+++ b/drivers/staging/erofs/internal.h
@@ -240,6 +240,7 @@ static inline bool erofs_workgroup_get(struct erofs_workgroup *grp, int *ocnt)
 }
 
 #define __erofs_workgroup_get(grp)	atomic_inc(&(grp)->refcount)
+#define __erofs_workgroup_put(grp)	atomic_dec(&(grp)->refcount)
 
 extern int erofs_workgroup_put(struct erofs_workgroup *grp);
 
diff --git a/drivers/staging/erofs/utils.c b/drivers/staging/erofs/utils.c
index 595cf90af9bb..389f6182721e 100644
--- a/drivers/staging/erofs/utils.c
+++ b/drivers/staging/erofs/utils.c
@@ -87,12 +87,21 @@ int erofs_register_workgroup(struct super_block *sb,
 		grp = (void *)((unsigned long)grp |
 			1UL << RADIX_TREE_EXCEPTIONAL_SHIFT);
 
-	err = radix_tree_insert(&sbi->workstn_tree,
-		grp->index, grp);
+	/*
+	 * Bump up reference count before making this workgroup
+	 * visible to other users in order to avoid potential UAF
+	 * without serialized by erofs_workstn_lock.
+	 */
+	__erofs_workgroup_get(grp);
 
-	if (!err) {
-		__erofs_workgroup_get(grp);
-	}
+	err = radix_tree_insert(&sbi->workstn_tree,
+				grp->index, grp);
+	if (unlikely(err))
+		/*
+		 * it's safe to decrease since the workgroup isn't visible
+		 * and refcount >= 2 (cannot be freezed).
+		 */
+		__erofs_workgroup_put(grp);
 
 	erofs_workstn_unlock(sbi);
 	radix_tree_preload_end();
@@ -101,19 +110,94 @@ int erofs_register_workgroup(struct super_block *sb,
 
 extern void erofs_workgroup_free_rcu(struct erofs_workgroup *grp);
 
+static void  __erofs_workgroup_free(struct erofs_workgroup *grp)
+{
+	atomic_long_dec(&erofs_global_shrink_cnt);
+	erofs_workgroup_free_rcu(grp);
+}
+
 int erofs_workgroup_put(struct erofs_workgroup *grp)
 {
 	int count = atomic_dec_return(&grp->refcount);
 
 	if (count == 1)
 		atomic_long_inc(&erofs_global_shrink_cnt);
-	else if (!count) {
-		atomic_long_dec(&erofs_global_shrink_cnt);
-		erofs_workgroup_free_rcu(grp);
-	}
+	else if (!count)
+		__erofs_workgroup_free(grp);
 	return count;
 }
 
+#ifdef EROFS_FS_HAS_MANAGED_CACHE
+/* for cache-managed case, customized reclaim paths exist */
+static void erofs_workgroup_unfreeze_final(struct erofs_workgroup *grp)
+{
+	erofs_workgroup_unfreeze(grp, 0);
+	__erofs_workgroup_free(grp);
+}
+
+bool erofs_try_to_release_workgroup(struct erofs_sb_info *sbi,
+				    struct erofs_workgroup *grp,
+				    bool cleanup)
+{
+	/*
+	 * for managed cache enabled, the refcount of workgroups
+	 * themselves could be < 0 (freezed). So there is no guarantee
+	 * that all refcount > 0 if managed cache is enabled.
+	 */
+	if (!erofs_workgroup_try_to_freeze(grp, 1))
+		return false;
+
+	/*
+	 * note that all cached pages should be unlinked
+	 * before delete it from the radix tree.
+	 * Otherwise some cached pages of an orphan old workgroup
+	 * could be still linked after the new one is available.
+	 */
+	if (erofs_try_to_free_all_cached_pages(sbi, grp)) {
+		erofs_workgroup_unfreeze(grp, 1);
+		return false;
+	}
+
+	/*
+	 * it is impossible to fail after the workgroup is freezed,
+	 * however in order to avoid some race conditions, add a
+	 * DBG_BUGON to observe this in advance.
+	 */
+	DBG_BUGON(xa_untag_pointer(radix_tree_delete(&sbi->workstn_tree,
+						     grp->index)) != grp);
+
+	/*
+	 * if managed cache is enable, the last refcount
+	 * should indicate the related workstation.
+	 */
+	erofs_workgroup_unfreeze_final(grp);
+	return true;
+}
+
+#else
+/* for nocache case, no customized reclaim path at all */
+bool erofs_try_to_release_workgroup(struct erofs_sb_info *sbi,
+				    struct erofs_workgroup *grp,
+				    bool cleanup)
+{
+	int cnt = atomic_read(&grp->refcount);
+
+	DBG_BUGON(cnt <= 0);
+	DBG_BUGON(cleanup && cnt != 1);
+
+	if (cnt > 1)
+		return false;
+
+	DBG_BUGON(xa_untag_pointer(radix_tree_delete(&sbi->workstn_tree,
+						     grp->index)) != grp);
+
+	/* (rarely) could be grabbed again when freeing */
+	erofs_workgroup_put(grp);
+	return true;
+}
+
+#endif
+
 unsigned long erofs_shrink_workstation(struct erofs_sb_info *sbi,
 				       unsigned long nr_shrink,
 				       bool cleanup)
@@ -130,44 +214,14 @@ unsigned long erofs_shrink_workstation(struct erofs_sb_info *sbi,
 		batch, first_index, PAGEVEC_SIZE);
 
 	for (i = 0; i < found; ++i) {
-		int cnt;
-		struct erofs_workgroup *grp = (void *)
-			((unsigned long)batch[i] &
-				~RADIX_TREE_EXCEPTIONAL_ENTRY);
+		struct erofs_workgroup *grp = xa_untag_pointer(batch[i]);
 
 		first_index = grp->index + 1;
 
-		cnt = atomic_read(&grp->refcount);
-		BUG_ON(cnt <= 0);
-
-		if (cleanup)
-			BUG_ON(cnt != 1);
-
-#ifndef EROFS_FS_HAS_MANAGED_CACHE
-		else if (cnt > 1)
-#else
-		if (!erofs_workgroup_try_to_freeze(grp, 1))
-#endif
+		/* try to shrink each valid workgroup */
+		if (!erofs_try_to_release_workgroup(sbi, grp, cleanup))
 			continue;
 
-		if (radix_tree_delete(&sbi->workstn_tree,
-			grp->index) != grp) {
-#ifdef EROFS_FS_HAS_MANAGED_CACHE
-skip:
-			erofs_workgroup_unfreeze(grp, 1);
-#endif
-			continue;
-		}
-
-#ifdef EROFS_FS_HAS_MANAGED_CACHE
-		if (erofs_try_to_free_all_cached_pages(sbi, grp))
-			goto skip;
-
-		erofs_workgroup_unfreeze(grp, 1);
-#endif
-		/* (rarely) grabbed again when freeing */
-		erofs_workgroup_put(grp);
-
 		++freed;
 		if (unlikely(!--nr_shrink))
 			break;
diff --git a/include/linux/xarray.h b/include/linux/xarray.h
index 2dfc8006fe64..1053785830c7 100644
--- a/include/linux/xarray.h
+++ b/include/linux/xarray.h
@@ -21,4 +21,52 @@
 #define xa_unlock_irqrestore(xa, flags) \
 				spin_unlock_irqrestore(&(xa)->xa_lock, flags)
 
+/**
+ * xa_tag_pointer() - Create an XArray entry for a tagged pointer.
+ * @p: Plain pointer.
+ * @tag: Tag value (0, 1 or 3).
+ *
+ * If the user of the XArray prefers, they can tag their pointers instead
+ * of storing value entries.  Three tags are available (0, 1 and 3).
+ * These are distinct from the xa_mark_t as they are not replicated up
+ * through the array and cannot be searched for.
+ *
+ * Context: Any context.
+ * Return: An XArray entry.
+ */
+static inline void *xa_tag_pointer(void *p, unsigned long tag)
+{
+	return (void *)((unsigned long)p | tag);
+}
+
+/**
+ * xa_untag_pointer() - Turn an XArray entry into a plain pointer.
+ * @entry: XArray entry.
+ *
+ * If you have stored a tagged pointer in the XArray, call this function
+ * to get the untagged version of the pointer.
+ *
+ * Context: Any context.
+ * Return: A pointer.
+ */
+static inline void *xa_untag_pointer(void *entry)
+{
+	return (void *)((unsigned long)entry & ~3UL);
+}
+
+/**
+ * xa_pointer_tag() - Get the tag stored in an XArray entry.
+ * @entry: XArray entry.
+ *
+ * If you have stored a tagged pointer in the XArray, call this function
+ * to get the tag of that pointer.
+ *
+ * Context: Any context.
+ * Return: A tag.
+ */
+static inline unsigned int xa_pointer_tag(void *entry)
+{
+	return (unsigned long)entry & 3UL;
+}
+
 #endif /* _LINUX_XARRAY_H */
-- 
2.14.4
