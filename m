From: gaoxiang25@huawei.com (Gao Xiang)
Date: Mon, 5 Nov 2018 18:45:01 +0800
Subject: [PATCH 4.20-rc1 rebased 08/10] staging: erofs: separate into
 init_once / always
In-Reply-To: <20181105104503.45627-1-gaoxiang25@huawei.com>
References: <20181105104503.45627-1-gaoxiang25@huawei.com>
Message-ID: <20181105104503.45627-8-gaoxiang25@huawei.com>

`z_erofs_vle_workgroup' is heavily generated in the decompression,
for example, it resets 32 bytes redundantly for 64-bit platforms
even through Z_EROFS_VLE_INLINE_PAGEVECS + Z_EROFS_CLUSTER_MAX_PAGES,
default 4, pages are stored in `z_erofs_vle_workgroup'.

As an another example, `struct mutex' takes 72 bytes for our kirin
64-bit platforms, it's unnecessary to be reseted at first and
be initialized each time.

Let's avoid filling all `z_erofs_vle_workgroup' with 0 at first
since most fields are reinitialized to meaningful values later,
and pagevec is no need to initialized at all.

Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>
---
 drivers/staging/erofs/unzip_vle.c | 34 +++++++++++++++++++++++++++++-----
 1 file changed, 29 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/erofs/unzip_vle.c b/drivers/staging/erofs/unzip_vle.c
index 94ceb391f607..a71e699774dc 100644
--- a/drivers/staging/erofs/unzip_vle.c
+++ b/drivers/staging/erofs/unzip_vle.c
@@ -42,12 +42,38 @@ static inline int init_unzip_workqueue(void)
 	return z_erofs_workqueue != NULL ? 0 : -ENOMEM;
 }
 
+static void init_once(void *ptr)
+{
+	struct z_erofs_vle_workgroup *grp = ptr;
+	struct z_erofs_vle_work *const work =
+		z_erofs_vle_grab_primary_work(grp);
+	unsigned int i;
+
+	mutex_init(&work->lock);
+	work->nr_pages = 0;
+	work->vcnt = 0;
+	for (i = 0; i < Z_EROFS_CLUSTER_MAX_PAGES; ++i)
+		grp->compressed_pages[i] = NULL;
+}
+
+static void init_always(struct z_erofs_vle_workgroup *grp)
+{
+	struct z_erofs_vle_work *const work =
+		z_erofs_vle_grab_primary_work(grp);
+
+	atomic_set(&grp->obj.refcount, 1);
+	grp->flags = 0;
+
+	DBG_BUGON(work->nr_pages);
+	DBG_BUGON(work->vcnt);
+}
+
 int __init z_erofs_init_zip_subsystem(void)
 {
 	z_erofs_workgroup_cachep =
 		kmem_cache_create("erofs_compress",
 		Z_EROFS_WORKGROUP_SIZE, 0,
-		SLAB_RECLAIM_ACCOUNT, NULL);
+		SLAB_RECLAIM_ACCOUNT, init_once);
 
 	if (z_erofs_workgroup_cachep != NULL) {
 		if (!init_unzip_workqueue())
@@ -369,10 +395,11 @@ z_erofs_vle_work_register(const struct z_erofs_vle_work_finder *f,
 	BUG_ON(grp != NULL);
 
 	/* no available workgroup, let's allocate one */
-	grp = kmem_cache_zalloc(z_erofs_workgroup_cachep, GFP_NOFS);
+	grp = kmem_cache_alloc(z_erofs_workgroup_cachep, GFP_NOFS);
 	if (unlikely(grp == NULL))
 		return ERR_PTR(-ENOMEM);
 
+	init_always(grp);
 	grp->obj.index = f->idx;
 	grp->llen = map->m_llen;
 
@@ -380,7 +407,6 @@ z_erofs_vle_work_register(const struct z_erofs_vle_work_finder *f,
 		(map->m_flags & EROFS_MAP_ZIPPED) ?
 			Z_EROFS_VLE_WORKGRP_FMT_LZ4 :
 			Z_EROFS_VLE_WORKGRP_FMT_PLAIN);
-	atomic_set(&grp->obj.refcount, 1);
 
 	/* new workgrps have been claimed as type 1 */
 	WRITE_ONCE(grp->next, *f->owned_head);
@@ -393,8 +419,6 @@ z_erofs_vle_work_register(const struct z_erofs_vle_work_finder *f,
 	work = z_erofs_vle_grab_primary_work(grp);
 	work->pageofs = f->pageofs;
 
-	mutex_init(&work->lock);
-
 	if (gnew) {
 		int err = erofs_register_workgroup(f->sb, &grp->obj, 0);
 
-- 
2.14.4
