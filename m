From: hsiangkao@aol.com (Gao Xiang)
Date: Tue, 26 Feb 2019 01:58:08 +0800
Subject: [PATCH for-4.19 1/2] xarray: Replace exceptional entries
In-Reply-To: <20190225155120.GA12525@kroah.com>
References: <20190225155120.GA12525@kroah.com>
Message-ID: <20190225175809.13427-1-hsiangkao@aol.com>

From: Matthew Wilcox <willy@infradead.org>

commit 3159f943aafdbacb2f94c38fdaadabf2bbde2a14 upstream.

Introduce xarray value entries and tagged pointers to replace radix
tree exceptional entries.  This is a slight change in encoding to allow
the use of an extra bit (we can now store BITS_PER_LONG - 1 bits in a
value entry).  It is also a change in emphasis; exceptional entries are
intimidating and different.  As the comment explains, you can choose
to store values or pointers in the xarray and they are both first-class
citizens.

Signed-off-by: Matthew Wilcox <willy at infradead.org>
Reviewed-by: Josef Bacik <jbacik at fb.com>
[ take the minimum subset of tagged pointer support only. ]
Cc: Matthew Wilcox <willy at infradead.org>
Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>
---
 drivers/staging/erofs/utils.c | 18 ++++++----------
 include/linux/xarray.h        | 48 +++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 54 insertions(+), 12 deletions(-)

diff --git a/drivers/staging/erofs/utils.c b/drivers/staging/erofs/utils.c
index 595cf90af9bb..bdee9bd09f11 100644
--- a/drivers/staging/erofs/utils.c
+++ b/drivers/staging/erofs/utils.c
@@ -35,7 +35,6 @@ static atomic_long_t erofs_global_shrink_cnt;
 
 #ifdef CONFIG_EROFS_FS_ZIP
 
-/* radix_tree and the future XArray both don't use tagptr_t yet */
 struct erofs_workgroup *erofs_find_workgroup(
 	struct super_block *sb, pgoff_t index, bool *tag)
 {
@@ -47,9 +46,8 @@ struct erofs_workgroup *erofs_find_workgroup(
 	rcu_read_lock();
 	grp = radix_tree_lookup(&sbi->workstn_tree, index);
 	if (grp != NULL) {
-		*tag = radix_tree_exceptional_entry(grp);
-		grp = (void *)((unsigned long)grp &
-			~RADIX_TREE_EXCEPTIONAL_ENTRY);
+		*tag = xa_pointer_tag(grp);
+		grp = xa_untag_pointer(grp);
 
 		if (erofs_workgroup_get(grp, &oldcount)) {
 			/* prefer to relax rcu read side */
@@ -83,9 +81,7 @@ int erofs_register_workgroup(struct super_block *sb,
 	sbi = EROFS_SB(sb);
 	erofs_workstn_lock(sbi);
 
-	if (tag)
-		grp = (void *)((unsigned long)grp |
-			1UL << RADIX_TREE_EXCEPTIONAL_SHIFT);
+	grp = xa_tag_pointer(grp, tag);
 
 	err = radix_tree_insert(&sbi->workstn_tree,
 		grp->index, grp);
@@ -131,9 +127,7 @@ unsigned long erofs_shrink_workstation(struct erofs_sb_info *sbi,
 
 	for (i = 0; i < found; ++i) {
 		int cnt;
-		struct erofs_workgroup *grp = (void *)
-			((unsigned long)batch[i] &
-				~RADIX_TREE_EXCEPTIONAL_ENTRY);
+		struct erofs_workgroup *grp = xa_untag_pointer(batch[i]);
 
 		first_index = grp->index + 1;
 
@@ -150,8 +144,8 @@ unsigned long erofs_shrink_workstation(struct erofs_sb_info *sbi,
 #endif
 			continue;
 
-		if (radix_tree_delete(&sbi->workstn_tree,
-			grp->index) != grp) {
+		if (xa_untag_pointer(radix_tree_delete(&sbi->workstn_tree,
+			grp->index)) != grp) {
 #ifdef EROFS_FS_HAS_MANAGED_CACHE
 skip:
 			erofs_workgroup_unfreeze(grp, 1);
diff --git a/include/linux/xarray.h b/include/linux/xarray.h
index 2dfc8006fe64..6f5c380f2d80 100644
--- a/include/linux/xarray.h
+++ b/include/linux/xarray.h
@@ -9,6 +9,54 @@
 
 #include <linux/spinlock.h>
 
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
 #define xa_trylock(xa)		spin_trylock(&(xa)->xa_lock)
 #define xa_lock(xa)		spin_lock(&(xa)->xa_lock)
 #define xa_unlock(xa)		spin_unlock(&(xa)->xa_lock)
-- 
2.11.0
