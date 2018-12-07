From: gaoxiang25@huawei.com (Gao Xiang)
Date: Sat, 8 Dec 2018 00:19:17 +0800
Subject: [PATCH 6/7] staging: erofs: redefine where `owned_workgrp_t' points
In-Reply-To: <20181207161918.20747-1-gaoxiang25@huawei.com>
References: <20181207161918.20747-1-gaoxiang25@huawei.com>
Message-ID: <20181207161918.20747-7-gaoxiang25@huawei.com>

By design, workgroups are queued in the form of linked lists.

Previously, it points to the next `z_erofs_vle_workgroup',
which isn't flexible enough to simplify `z_erofs_vle_submit_all'.

Let's fix it by pointing to the next `owned_workgrp_t' and use
container_of to get its coresponding `z_erofs_vle_workgroup'.

Reviewed-by: Chao Yu <yuchao0 at huawei.com>
Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>
---
 drivers/staging/erofs/unzip_vle.c | 12 +++++++-----
 drivers/staging/erofs/unzip_vle.h |  4 ++--
 2 files changed, 9 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/erofs/unzip_vle.c b/drivers/staging/erofs/unzip_vle.c
index 2b494f29e2c2..a8cf324f0b9c 100644
--- a/drivers/staging/erofs/unzip_vle.c
+++ b/drivers/staging/erofs/unzip_vle.c
@@ -333,7 +333,7 @@ static inline bool try_to_claim_workgroup(
 			    *owned_head) != Z_EROFS_VLE_WORKGRP_NIL)
 			goto retry;
 
-		*owned_head = grp;
+		*owned_head = &grp->next;
 		*hosted = true;
 	} else if (grp->next == Z_EROFS_VLE_WORKGRP_TAIL) {
 		/*
@@ -488,7 +488,8 @@ z_erofs_vle_work_register(const struct z_erofs_vle_work_finder *f,
 		}
 	}
 
-	*f->owned_head = *f->grp_ret = grp;
+	*f->owned_head = &grp->next;
+	*f->grp_ret = grp;
 	return work;
 }
 
@@ -1084,7 +1085,7 @@ static void z_erofs_vle_unzip_all(struct super_block *sb,
 		/* no possible that 'owned' equals NULL */
 		DBG_BUGON(owned == Z_EROFS_VLE_WORKGRP_NIL);
 
-		grp = owned;
+		grp = container_of(owned, struct z_erofs_vle_workgroup, next);
 		owned = READ_ONCE(grp->next);
 
 		z_erofs_vle_unzip(sb, grp, page_pool);
@@ -1325,7 +1326,8 @@ static bool z_erofs_vle_submit_all(struct super_block *sb,
 		DBG_BUGON(owned_head == Z_EROFS_VLE_WORKGRP_TAIL_CLOSED);
 		DBG_BUGON(owned_head == Z_EROFS_VLE_WORKGRP_NIL);
 
-		grp = owned_head;
+		grp = container_of(owned_head,
+				   struct z_erofs_vle_workgroup, next);
 
 		/* close the main owned chain at first */
 		owned_head = cmpxchg(&grp->next, Z_EROFS_VLE_WORKGRP_TAIL,
@@ -1382,7 +1384,7 @@ static bool z_erofs_vle_submit_all(struct super_block *sb,
 				WRITE_ONCE(lstgrp_io->next, iogrp_next);
 
 			if (!lstgrp_noio)
-				ios[0]->head = grp;
+				ios[0]->head = &grp->next;
 			else
 				WRITE_ONCE(lstgrp_noio->next, grp);
 
diff --git a/drivers/staging/erofs/unzip_vle.h b/drivers/staging/erofs/unzip_vle.h
index 3316bc36965d..5a4e1b62c0d1 100644
--- a/drivers/staging/erofs/unzip_vle.h
+++ b/drivers/staging/erofs/unzip_vle.h
@@ -67,13 +67,13 @@ struct z_erofs_vle_work {
 #define Z_EROFS_VLE_WORKGRP_FMT_LZ4          1
 #define Z_EROFS_VLE_WORKGRP_FMT_MASK         1
 
-typedef struct z_erofs_vle_workgroup *z_erofs_vle_owned_workgrp_t;
+typedef void *z_erofs_vle_owned_workgrp_t;
 
 struct z_erofs_vle_workgroup {
 	struct erofs_workgroup obj;
 	struct z_erofs_vle_work work;
 
-	/* next owned workgroup */
+	/* point to next owned_workgrp_t */
 	z_erofs_vle_owned_workgrp_t next;
 
 	/* compressed pages (including multi-usage pages) */
-- 
2.14.4
