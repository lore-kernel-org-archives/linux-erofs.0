From: gaoxiang25@huawei.com (Gao Xiang)
Date: Mon, 6 Aug 2018 21:25:06 +0800
Subject: [WIP] [PATCH] staging: erofs: cleanup z_erofs_vle_work_{lookup,
 register}
Message-ID: <1533561906-15381-1-git-send-email-gaoxiang25@huawei.com>

This patch introduces 'struct z_erofs_vle_work_finder' to clean up
arguments of z_erofs_vle_work_lookup and z_erofs_vle_work_register.

Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>
---
 drivers/staging/erofs/unzip_vle.c | 89 +++++++++++++++++++++------------------
 1 file changed, 47 insertions(+), 42 deletions(-)

diff --git a/drivers/staging/erofs/unzip_vle.c b/drivers/staging/erofs/unzip_vle.c
index 8721f0a..98d41b9 100644
--- a/drivers/staging/erofs/unzip_vle.c
+++ b/drivers/staging/erofs/unzip_vle.c
@@ -271,36 +271,42 @@ static inline bool try_to_claim_workgroup(
 	return true;	/* lucky, I am the followee :) */
 }
 
+struct z_erofs_vle_work_finder {
+	struct super_block *sb;
+	pgoff_t idx;
+	unsigned pageofs;
+
+	struct z_erofs_vle_workgroup **grp_ret;
+	enum z_erofs_vle_work_role *role;
+	z_erofs_vle_owned_workgrp_t *owned_head;
+	bool *hosted;
+};
+
 static struct z_erofs_vle_work *
-z_erofs_vle_work_lookup(struct super_block *sb,
-			pgoff_t idx, unsigned pageofs,
-			struct z_erofs_vle_workgroup **grp_ret,
-			enum z_erofs_vle_work_role *role,
-			z_erofs_vle_owned_workgrp_t *owned_head,
-			bool *hosted)
+z_erofs_vle_work_lookup(const struct z_erofs_vle_work_finder *f)
 {
 	bool tag, primary;
 	struct erofs_workgroup *egrp;
 	struct z_erofs_vle_workgroup *grp;
 	struct z_erofs_vle_work *work;
 
-	egrp = erofs_find_workgroup(sb, idx, &tag);
+	egrp = erofs_find_workgroup(f->sb, f->idx, &tag);
 	if (egrp == NULL) {
-		*grp_ret = NULL;
+		*f->grp_ret = NULL;
 		return NULL;
 	}
 
-	*grp_ret = grp = container_of(egrp,
-		struct z_erofs_vle_workgroup, obj);
+	grp = container_of(egrp, struct z_erofs_vle_workgroup, obj);
+	*f->grp_ret = grp;
 
 #ifndef CONFIG_EROFS_FS_ZIP_MULTIREF
-	work = z_erofs_vle_grab_work(grp, pageofs);
+	work = z_erofs_vle_grab_work(grp, f->pageofs);
 	primary = true;
 #else
 	BUG();
 #endif
 
-	DBG_BUGON(work->pageofs != pageofs);
+	DBG_BUGON(work->pageofs != f->pageofs);
 
 	/*
 	 * lock must be taken first to avoid grp->next == NIL between
@@ -340,29 +346,24 @@ static inline bool try_to_claim_workgroup(
 	 */
 	mutex_lock(&work->lock);
 
-	*hosted = false;
+	*f->hosted = false;
 	if (!primary)
-		*role = Z_EROFS_VLE_WORK_SECONDARY;
+		*f->role = Z_EROFS_VLE_WORK_SECONDARY;
 	/* claim the workgroup if possible */
-	else if (try_to_claim_workgroup(grp, owned_head, hosted))
-		*role = Z_EROFS_VLE_WORK_PRIMARY_FOLLOWED;
+	else if (try_to_claim_workgroup(grp, f->owned_head, f->hosted))
+		*f->role = Z_EROFS_VLE_WORK_PRIMARY_FOLLOWED;
 	else
-		*role = Z_EROFS_VLE_WORK_PRIMARY;
+		*f->role = Z_EROFS_VLE_WORK_PRIMARY;
 
 	return work;
 }
 
 static struct z_erofs_vle_work *
-z_erofs_vle_work_register(struct super_block *sb,
-			  struct z_erofs_vle_workgroup **grp_ret,
-			  struct erofs_map_blocks *map,
-			  pgoff_t index, unsigned pageofs,
-			  enum z_erofs_vle_work_role *role,
-			  z_erofs_vle_owned_workgrp_t *owned_head,
-			  bool *hosted)
+z_erofs_vle_work_register(const struct z_erofs_vle_work_finder *f,
+			  struct erofs_map_blocks *map)
 {
-	bool newgrp = false;
-	struct z_erofs_vle_workgroup *grp = *grp_ret;
+	bool gnew = false;
+	struct z_erofs_vle_workgroup *grp = *f->grp_ret;
 	struct z_erofs_vle_work *work;
 
 #ifndef CONFIG_EROFS_FS_ZIP_MULTIREF
@@ -376,7 +377,7 @@ static inline bool try_to_claim_workgroup(
 	if (unlikely(grp == NULL))
 		return ERR_PTR(-ENOMEM);
 
-	grp->obj.index = index;
+	grp->obj.index = f->idx;
 	grp->llen = map->m_llen;
 
 	z_erofs_vle_set_workgrp_fmt(grp,
@@ -386,13 +387,13 @@ static inline bool try_to_claim_workgroup(
 	atomic_set(&grp->obj.refcount, 1);
 
 	/* new workgrps have been claimed as type 1 */
-	WRITE_ONCE(grp->next, *owned_head);
+	WRITE_ONCE(grp->next, *f->owned_head);
 	/* primary and followed work for all new workgrps */
-	*role = Z_EROFS_VLE_WORK_PRIMARY_FOLLOWED;
+	*f->role = Z_EROFS_VLE_WORK_PRIMARY_FOLLOWED;
 	/* it should be submitted by ourselves */
-	*hosted = true;
+	*f->hosted = true;
 
-	newgrp = true;
+	gnew = true;
 #ifdef CONFIG_EROFS_FS_ZIP_MULTIREF
 skip:
 	/* currently unimplemented */
@@ -400,12 +401,12 @@ static inline bool try_to_claim_workgroup(
 #else
 	work = z_erofs_vle_grab_primary_work(grp);
 #endif
-	work->pageofs = pageofs;
+	work->pageofs = f->pageofs;
 
 	mutex_init(&work->lock);
 
-	if (newgrp) {
-		int err = erofs_register_workgroup(sb, &grp->obj, 0);
+	if (gnew) {
+		int err = erofs_register_workgroup(f->sb, &grp->obj, 0);
 
 		if (err) {
 			kmem_cache_free(z_erofs_workgroup_cachep, grp);
@@ -413,7 +414,7 @@ static inline bool try_to_claim_workgroup(
 		}
 	}
 
-	*owned_head = *grp_ret = grp;
+	*f->owned_head = *f->grp_ret = grp;
 
 	mutex_lock(&work->lock);
 	return work;
@@ -440,9 +441,16 @@ static int z_erofs_vle_work_iter_begin(struct z_erofs_vle_work_builder *builder,
 				       z_erofs_vle_owned_workgrp_t *owned_head)
 {
 	const unsigned clusterpages = erofs_clusterpages(EROFS_SB(sb));
-	const erofs_blk_t index = erofs_blknr(map->m_pa);
-	const unsigned pageofs = map->m_la & ~PAGE_MASK;
 	struct z_erofs_vle_workgroup *grp;
+	const struct z_erofs_vle_work_finder finder = {
+		.sb = sb,
+		.idx = erofs_blknr(map->m_pa),
+		.pageofs = map->m_la & ~PAGE_MASK,
+		.grp_ret = &grp,
+		.role = &builder->role,
+		.owned_head = owned_head,
+		.hosted = &builder->hosted
+	};
 	struct z_erofs_vle_work *work;
 
 	DBG_BUGON(builder->work != NULL);
@@ -454,16 +462,13 @@ static int z_erofs_vle_work_iter_begin(struct z_erofs_vle_work_builder *builder,
 	DBG_BUGON(erofs_blkoff(map->m_pa));
 
 repeat:
-	work = z_erofs_vle_work_lookup(sb, index,
-		pageofs, &grp, &builder->role, owned_head, &builder->hosted);
+	work = z_erofs_vle_work_lookup(&finder);
 	if (work != NULL) {
 		__update_workgrp_llen(grp, map->m_llen);
 		goto got_it;
 	}
 
-	work = z_erofs_vle_work_register(sb, &grp, map, index, pageofs,
-		&builder->role, owned_head, &builder->hosted);
-
+	work = z_erofs_vle_work_register(&finder, map);
 	if (unlikely(work == ERR_PTR(-EAGAIN)))
 		goto repeat;
 
-- 
1.9.1
