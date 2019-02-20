From: gaoxiang25@huawei.com (Gao Xiang)
Date: Wed, 20 Feb 2019 17:18:54 +0800
Subject: [PATCH for-4.19 12/12] staging: erofs: unzip_vle_lz4.c,
 utils.c: rectify BUG_ONs
In-Reply-To: <20190220091854.19242-1-gaoxiang25@huawei.com>
References: <20190220091854.19242-1-gaoxiang25@huawei.com>
Message-ID: <20190220091854.19242-13-gaoxiang25@huawei.com>

commit b8e076a6ef253e763bfdb81e5c72bcc828b0fbeb upstream.

remove all redundant BUG_ONs, and turn the rest
useful usages to DBG_BUGONs.

Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>
Reviewed-by: Chao Yu <yuchao0 at huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh at linuxfoundation.org>
Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>
---
 drivers/staging/erofs/unzip_vle_lz4.c |  2 +-
 drivers/staging/erofs/utils.c         | 12 ++++++------
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/erofs/unzip_vle_lz4.c b/drivers/staging/erofs/unzip_vle_lz4.c
index f5b665f15be5..9cb35cd33365 100644
--- a/drivers/staging/erofs/unzip_vle_lz4.c
+++ b/drivers/staging/erofs/unzip_vle_lz4.c
@@ -57,7 +57,7 @@ int z_erofs_vle_plain_copy(struct page **compressed_pages,
 			if (compressed_pages[j] != page)
 				continue;
 
-			BUG_ON(mirrored[j]);
+			DBG_BUGON(mirrored[j]);
 			memcpy(percpu_data + j * PAGE_SIZE, dst, PAGE_SIZE);
 			mirrored[j] = true;
 			break;
diff --git a/drivers/staging/erofs/utils.c b/drivers/staging/erofs/utils.c
index 389f6182721e..ceee288fbe90 100644
--- a/drivers/staging/erofs/utils.c
+++ b/drivers/staging/erofs/utils.c
@@ -23,9 +23,6 @@ struct page *erofs_allocpage(struct list_head *pool, gfp_t gfp)
 		list_del(&page->lru);
 	} else {
 		page = alloc_pages(gfp | __GFP_NOFAIL, 0);
-
-		BUG_ON(page == NULL);
-		BUG_ON(page->mapping != NULL);
 	}
 	return page;
 }
@@ -60,7 +57,7 @@ struct erofs_workgroup *erofs_find_workgroup(
 		/* decrease refcount added by erofs_workgroup_put */
 		if (unlikely(oldcount == 1))
 			atomic_long_dec(&erofs_global_shrink_cnt);
-		BUG_ON(index != grp->index);
+		DBG_BUGON(index != grp->index);
 	}
 	rcu_read_unlock();
 	return grp;
@@ -73,8 +70,11 @@ int erofs_register_workgroup(struct super_block *sb,
 	struct erofs_sb_info *sbi;
 	int err;
 
-	/* grp->refcount should not < 1 */
-	BUG_ON(!atomic_read(&grp->refcount));
+	/* grp shouldn't be broken or used before */
+	if (unlikely(atomic_read(&grp->refcount) != 1)) {
+		DBG_BUGON(1);
+		return -EINVAL;
+	}
 
 	err = radix_tree_preload(GFP_NOFS);
 	if (err)
-- 
2.14.4
