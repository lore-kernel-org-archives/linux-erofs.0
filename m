From: gaoxiang25@huawei.com (Gao Xiang)
Date: Thu, 6 Dec 2018 20:46:59 +0800
Subject: [PREVIEW] [PATCH chao/erofs-dev] staging: erofs: introduce
 .migratepage for managed cache
Message-ID: <20181206124659.40866-1-gaoxiang25@huawei.com>

It's awkward for managed cache to use the default
migration path since the default approach will fall
back to try_to_release_page for all PG_private pages.

Let's create a customized method to handle this more
effectively.

Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>
---
 drivers/staging/erofs/internal.h  |   7 +++
 drivers/staging/erofs/super.c     |   3 ++
 drivers/staging/erofs/unzip_vle.c | 107 ++++++++++++++++++++++++++++++++++++++
 drivers/staging/erofs/unzip_vle.h |   4 ++
 4 files changed, 121 insertions(+)

diff --git a/drivers/staging/erofs/internal.h b/drivers/staging/erofs/internal.h
index 892944355867..4b3b686c3569 100644
--- a/drivers/staging/erofs/internal.h
+++ b/drivers/staging/erofs/internal.h
@@ -295,6 +295,13 @@ extern int erofs_try_to_free_all_cached_pages(struct erofs_sb_info *sbi,
 	struct erofs_workgroup *egrp);
 extern int erofs_try_to_free_cached_page(struct address_space *mapping,
 	struct page *page);
+
+#ifdef CONFIG_MIGRATION
+int erofs_migrate_cached_page(struct address_space *mapping,
+			      struct page *newpage,
+			      struct page *page,
+			      enum migrate_mode mode);
+#endif
 #endif
 
 #define DEFAULT_MAX_SYNC_DECOMPRESS_PAGES	3
diff --git a/drivers/staging/erofs/super.c b/drivers/staging/erofs/super.c
index 1c2eb69682ef..354671496971 100644
--- a/drivers/staging/erofs/super.c
+++ b/drivers/staging/erofs/super.c
@@ -329,6 +329,9 @@ static void managed_cache_invalidatepage(struct page *page,
 static const struct address_space_operations managed_cache_aops = {
 	.releasepage = managed_cache_releasepage,
 	.invalidatepage = managed_cache_invalidatepage,
+#ifdef CONFIG_MIGRATION
+	.migratepage = erofs_migrate_cached_page,
+#endif
 };
 
 static struct inode *erofs_init_managed_cache(struct super_block *sb)
diff --git a/drivers/staging/erofs/unzip_vle.c b/drivers/staging/erofs/unzip_vle.c
index f5d088fdf7f2..0865e67d472c 100644
--- a/drivers/staging/erofs/unzip_vle.c
+++ b/drivers/staging/erofs/unzip_vle.c
@@ -12,6 +12,7 @@
  */
 #include "unzip_vle.h"
 #include <linux/prefetch.h>
+#include <linux/migrate.h>
 
 #include <trace/events/erofs.h>
 
@@ -228,6 +229,106 @@ int erofs_try_to_free_cached_page(struct address_space *mapping,
 	}
 	return ret;
 }
+
+#ifdef CONFIG_MIGRATION
+int erofs_migrate_cached_page(struct address_space *mapping,
+			      struct page *newpage,
+			      struct page *page,
+			      enum migrate_mode mode)
+{
+	struct erofs_sb_info *const sbi = EROFS_SB(mapping->host->i_sb);
+	const unsigned int clusterpages = erofs_clusterpages(sbi);
+
+	struct z_erofs_vle_workgroup *grp;
+	int rc;
+	unsigned int i;
+
+	if (!PagePrivate(page))
+		return migrate_page(mapping, newpage, page, mode);
+
+	/* the workgroup will not be freed with compressed page locked */
+	grp = (void *)READ_ONCE(page_private(page));
+	DBG_BUGON(!grp);
+
+	/* optimistically freeze the workgroup at first */
+	if (!erofs_workgroup_try_to_freeze(&grp->obj, 1)) {
+		wait_queue_head_t *wq;
+		struct z_erofs_vle_work *primary_work;
+		bool locked;
+		DEFINE_WAIT_BIT(wait, &grp->flags,
+				Z_EROFS_WG_WAIT_COMPLETION_BIT);
+
+		if (mode != MIGRATE_SYNC && mode != MIGRATE_SYNC_NO_COPY)
+			return -EAGAIN;
+
+		wq = bit_waitqueue(&grp->flags,
+				   Z_EROFS_WG_WAIT_COMPLETION_BIT);
+
+		/* let's take or sleep on the primary work lock */
+		primary_work = z_erofs_vle_grab_primary_work(grp);
+		mutex_lock(&primary_work->lock);
+		locked = true;
+
+		while (!erofs_workgroup_try_to_freeze(&grp->obj, 1)) {
+			prepare_to_wait(wq, &wait.wq_entry,
+					TASK_UNINTERRUPTIBLE);
+
+			grp->flags |= Z_EROFS_WG_WAIT_COMPLETION;
+			mutex_unlock(&primary_work->lock);
+
+			schedule();
+
+			if (erofs_workgroup_try_to_freeze(&grp->obj, 1)) {
+				locked = false;
+				break;
+			}
+			mutex_lock(&primary_work->lock);
+		}
+		finish_wait(wq, &wait.wq_entry);
+
+		if (locked)
+			mutex_unlock(&primary_work->lock);
+	}
+
+	rc = -EAGAIN;
+	for (i = 0; i < clusterpages; ++i) {
+		if (grp->compressed_pages[i] == page) {
+			WRITE_ONCE(grp->compressed_pages[i], newpage);
+			rc = 0;
+			break;
+		}
+	}
+
+	/*
+	 * Note that the new page is still locked, it's safe to
+	 * unfreeze right after updating compressed_pages[].
+	 */
+	erofs_workgroup_unfreeze(&grp->obj, 1);
+
+	if (rc) {
+		DBG_BUGON(1);
+		return rc;
+	}
+
+	rc = migrate_page_move_mapping(mapping, newpage, page, NULL, mode, 0);
+	if (rc != MIGRATEPAGE_SUCCESS)
+		return rc;
+
+	ClearPagePrivate(page);
+	set_page_private(page, 0);
+	put_page(page);
+
+	get_page(newpage);
+	set_page_private(newpage, (unsigned long)grp);
+	__SetPagePrivate(newpage);
+
+	if (mode != MIGRATE_SYNC_NO_COPY)
+		migrate_page_copy(newpage, page);
+	else
+		migrate_page_states(newpage, page);
+	return MIGRATEPAGE_SUCCESS;
+}
+#endif
 #endif
 
 /* page_type must be Z_EROFS_PAGE_TYPE_EXCLUSIVE */
@@ -993,6 +1094,12 @@ static int z_erofs_vle_unzip(struct super_block *sb,
 	work->nr_pages = 0;
 	work->vcnt = 0;
 
+	/* wake up the migrate task which waits on it */
+	if (grp->flags & Z_EROFS_WG_WAIT_COMPLETION) {
+		grp->flags ^= Z_EROFS_WG_WAIT_COMPLETION;
+		wake_up_bit(&grp->flags, Z_EROFS_WG_WAIT_COMPLETION_BIT);
+	}
+
 	/* all work locks MUST be taken before the following line */
 
 	WRITE_ONCE(grp->next, Z_EROFS_VLE_WORKGRP_NIL);
diff --git a/drivers/staging/erofs/unzip_vle.h b/drivers/staging/erofs/unzip_vle.h
index 3316bc36965d..71cf4839897b 100644
--- a/drivers/staging/erofs/unzip_vle.h
+++ b/drivers/staging/erofs/unzip_vle.h
@@ -67,6 +67,10 @@ struct z_erofs_vle_work {
 #define Z_EROFS_VLE_WORKGRP_FMT_LZ4          1
 #define Z_EROFS_VLE_WORKGRP_FMT_MASK         1
 
+/* used to wait decompression for this workgroup */
+#define Z_EROFS_WG_WAIT_COMPLETION_BIT  3
+#define Z_EROFS_WG_WAIT_COMPLETION      BIT(Z_EROFS_WG_WAIT_COMPLETION_BIT)
+
 typedef struct z_erofs_vle_workgroup *z_erofs_vle_owned_workgrp_t;
 
 struct z_erofs_vle_workgroup {
-- 
2.14.4
