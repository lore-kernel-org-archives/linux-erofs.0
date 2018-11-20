From: gaoxiang25@huawei.com (Gao Xiang)
Date: Tue, 20 Nov 2018 22:14:47 +0800
Subject: [PATCH v3 chao/erofs-dev 13/14] staging: erofs: redefine where
 `owned_workgrp_t' points
In-Reply-To: <20181120141448.29483-1-gaoxiang25@huawei.com>
References: <20181120141448.29483-1-gaoxiang25@huawei.com>
Message-ID: <20181120141448.29483-13-gaoxiang25@huawei.com>

By design, workgroups are queued in the form of linked lists.

Previously, it points to the next `z_erofs_vle_workgroup', which
isn't flexible enough to simplify `z_erofs_vle_submit_all' logic.

Let's fix it pointing to the next `owned_workgrp_t' and use
container_of to get its coresponding `z_erofs_vle_workgroup'.

Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>
---
 drivers/staging/erofs/unzip_vle.c | 12 +++++++-----
 drivers/staging/erofs/unzip_vle.h |  4 ++--
 2 files changed, 9 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/erofs/unzip_vle.c b/drivers/staging/erofs/unzip_vle.c
index aed426230860..f0f2367c1131 100644
--- a/drivers/staging/erofs/unzip_vle.c
+++ b/drivers/staging/erofs/unzip_vle.c
@@ -331,7 +331,7 @@ static inline bool try_to_claim_workgroup(
 			    *owned_head) != Z_EROFS_VLE_WORKGRP_NIL)
 			goto retry;
 
-		*owned_head = grp;
+		*owned_head = &grp->next;
 		*hosted = true;
 	} else if (grp->next == Z_EROFS_VLE_WORKGRP_TAIL) {
 		/*
@@ -485,7 +485,8 @@ z_erofs_vle_work_register(const struct z_erofs_vle_work_finder *f,
 		}
 	}
 
-	*f->owned_head = *f->grp_ret = grp;
+	*f->owned_head = &grp->next;
+	*f->grp_ret = grp;
 	return work;
 }
 
@@ -1076,7 +1077,7 @@ static void z_erofs_vle_unzip_all(struct super_block *sb,
 		/* no possible that 'owned' equals NULL */
 		DBG_BUGON(owned == Z_EROFS_VLE_WORKGRP_NIL);
 
-		grp = owned;
+		grp = container_of(owned, struct z_erofs_vle_workgroup, next);
 		owned = READ_ONCE(grp->next);
 
 		z_erofs_vle_unzip(sb, grp, page_pool);
@@ -1311,7 +1312,8 @@ static bool z_erofs_vle_submit_all(struct super_block *sb,
 		DBG_BUGON(owned_head == Z_EROFS_VLE_WORKGRP_TAIL_CLOSED);
 		DBG_BUGON(owned_head == Z_EROFS_VLE_WORKGRP_NIL);
 
-		grp = owned_head;
+		grp = container_of(owned_head,
+				   struct z_erofs_vle_workgroup, next);
 
 		/* close the main owned chain at first */
 		owned_head = cmpxchg(&grp->next, Z_EROFS_VLE_WORKGRP_TAIL,
@@ -1369,7 +1371,7 @@ static bool z_erofs_vle_submit_all(struct super_block *sb,
 				WRITE_ONCE(lstgrp_io->next, iogrp_next);
 
 			if (!lstgrp_noio)
-				ios[0]->head = grp;
+				ios[0]->head = &grp->next;
 			else
 				WRITE_ONCE(lstgrp_noio->next, grp);
 
diff --git a/drivers/staging/erofs/unzip_vle.h b/drivers/staging/erofs/unzip_vle.h
index 6f4c7440aeb1..3fb44f1bd8f0 100644
--- a/drivers/staging/erofs/unzip_vle.h
+++ b/drivers/staging/erofs/unzip_vle.h
@@ -76,7 +76,7 @@ struct z_erofs_vle_work {
 #define Z_EROFS_VLE_WORKGRP_FMT_LZ4          1
 #define Z_EROFS_VLE_WORKGRP_FMT_MASK         1
 
-typedef struct z_erofs_vle_workgroup *z_erofs_vle_owned_workgrp_t;
+typedef void *z_erofs_vle_owned_workgrp_t;
 
 /* compressed page tagptr (bit 0 - justfound, with an extra reference) */
 typedef tagptr1_t z_erofs_ctptr_t;
@@ -88,7 +88,7 @@ struct z_erofs_vle_workgroup {
 	struct erofs_workgroup obj;
 	struct z_erofs_vle_work work;
 
-	/* next owned workgroup */
+	/* point to next owned_workgrp_t */
 	z_erofs_vle_owned_workgrp_t next;
 
 	/* compressed pages (including multi-usage pages) */
-- 
2.14.4
