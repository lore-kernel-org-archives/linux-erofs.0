From: gaoxiang25@huawei.com (Gao Xiang)
Date: Tue, 21 Aug 2018 14:50:57 +0800
Subject: [PREVIEW] [PATCH 2/3] staging: erofs: fold in __update_workgrp_llen
In-Reply-To: <1534834258-36401-1-git-send-email-gaoxiang25@huawei.com>
References: <1534834258-36401-1-git-send-email-gaoxiang25@huawei.com>
Message-ID: <1534834258-36401-2-git-send-email-gaoxiang25@huawei.com>

There is only one user to use __update_workgrp_llen, so
fold it in z_erofs_vle_work_iter_begin and cleanup related code.

Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>
---
 drivers/staging/erofs/unzip_vle.c | 20 +++++++-------------
 1 file changed, 7 insertions(+), 13 deletions(-)

diff --git a/drivers/staging/erofs/unzip_vle.c b/drivers/staging/erofs/unzip_vle.c
index 391277f..016c82d 100644
--- a/drivers/staging/erofs/unzip_vle.c
+++ b/drivers/staging/erofs/unzip_vle.c
@@ -422,18 +422,6 @@ struct z_erofs_vle_work_finder {
 	return work;
 }
 
-static inline void __update_workgrp_llen(struct z_erofs_vle_workgroup *grp,
-					 unsigned int llen)
-{
-	while (1) {
-		unsigned int orig_llen = grp->llen;
-
-		if (orig_llen >= llen || orig_llen ==
-			cmpxchg(&grp->llen, orig_llen, llen))
-			break;
-	}
-}
-
 #define builder_is_followed(builder) \
 	((builder)->role >= Z_EROFS_VLE_WORK_PRIMARY_FOLLOWED)
 
@@ -466,7 +454,13 @@ static int z_erofs_vle_work_iter_begin(struct z_erofs_vle_work_builder *builder,
 repeat:
 	work = z_erofs_vle_work_lookup(&finder);
 	if (work != NULL) {
-		__update_workgrp_llen(grp, map->m_llen);
+		unsigned int orig_llen;
+
+		/* increase workgroup `llen' if needed */
+		while ((orig_llen = READ_ONCE(grp->llen)) < map->m_llen &&
+		       orig_llen != cmpxchg_relaxed(&grp->llen,
+						    orig_llen, map->m_llen))
+			cpu_relax();
 		goto got_it;
 	}
 
-- 
1.9.1
