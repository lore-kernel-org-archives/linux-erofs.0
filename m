From: gaoxiang25@huawei.com (Gao Xiang)
Date: Sat, 16 Feb 2019 16:46:50 +0800
Subject: [PATCH] staging: erofs: remove rcu_read_lock() in
 erofs_try_to_free_cached_page
Message-ID: <20190216084650.33841-1-gaoxiang25@huawei.com>

page_private(page) cannot be changed if page lock is taken.

Besides, the corresponding workgroup won't be freed
if the page is already protected by page lock, therefore
no need to take rcu read lock.

Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>
---
 drivers/staging/erofs/unzip_vle.c | 16 +++++-----------
 1 file changed, 5 insertions(+), 11 deletions(-)

diff --git a/drivers/staging/erofs/unzip_vle.c b/drivers/staging/erofs/unzip_vle.c
index 2b5951f233db..a127d8db76d8 100644
--- a/drivers/staging/erofs/unzip_vle.c
+++ b/drivers/staging/erofs/unzip_vle.c
@@ -238,14 +238,9 @@ int erofs_try_to_free_cached_page(struct address_space *mapping,
 {
 	struct erofs_sb_info *const sbi = EROFS_SB(mapping->host->i_sb);
 	const unsigned int clusterpages = erofs_clusterpages(sbi);
-
-	struct z_erofs_vle_workgroup *grp;
+	struct z_erofs_vle_workgroup *const grp = (void *)page_private(page);
 	int ret = 0;	/* 0 - busy */
 
-	/* prevent the workgroup from being freed */
-	rcu_read_lock();
-	grp = (void *)page_private(page);
-
 	if (erofs_workgroup_try_to_freeze(&grp->obj, 1)) {
 		unsigned int i;
 
@@ -257,12 +252,11 @@ int erofs_try_to_free_cached_page(struct address_space *mapping,
 			}
 		}
 		erofs_workgroup_unfreeze(&grp->obj, 1);
-	}
-	rcu_read_unlock();
 
-	if (ret) {
-		ClearPagePrivate(page);
-		put_page(page);
+		if (ret) {
+			ClearPagePrivate(page);
+			put_page(page);
+		}
 	}
 	return ret;
 }
-- 
2.14.4
