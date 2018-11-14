From: gaoxiang25@huawei.com (Gao Xiang)
Date: Wed, 14 Nov 2018 23:25:41 +0800
Subject: [PATCH chao/erofs-dev rebased v2 02/12] staging: erofs: unzip_vle.c:
 Constant in comparison on right side
In-Reply-To: <20181114152548.37921-1-gaoxiang25@huawei.com>
References: <20181114152548.37921-1-gaoxiang25@huawei.com>
Message-ID: <20181114152548.37921-2-gaoxiang25@huawei.com>

From: Cristian Sicilia <sicilia.cristian@gmail.com>

Comparisons should place the constant
on the right side of the test.

Signed-off-by: Cristian Sicilia <sicilia.cristian at gmail.com>
---
 drivers/staging/erofs/unzip_vle.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/erofs/unzip_vle.c b/drivers/staging/erofs/unzip_vle.c
index 1ffeeaa6e976..35add4eb3057 100644
--- a/drivers/staging/erofs/unzip_vle.c
+++ b/drivers/staging/erofs/unzip_vle.c
@@ -250,8 +250,8 @@ static inline bool try_to_claim_workgroup(
 retry:
 	if (grp->next == Z_EROFS_VLE_WORKGRP_NIL) {
 		/* type 1, nil workgroup */
-		if (Z_EROFS_VLE_WORKGRP_NIL != cmpxchg(&grp->next,
-			Z_EROFS_VLE_WORKGRP_NIL, *owned_head))
+		if (cmpxchg(&grp->next, Z_EROFS_VLE_WORKGRP_NIL,
+			    *owned_head) != Z_EROFS_VLE_WORKGRP_NIL)
 			goto retry;
 
 		*owned_head = grp;
@@ -262,8 +262,8 @@ static inline bool try_to_claim_workgroup(
 		 * be careful that its submission itself is governed
 		 * by the original owned chain.
 		 */
-		if (Z_EROFS_VLE_WORKGRP_TAIL != cmpxchg(&grp->next,
-			Z_EROFS_VLE_WORKGRP_TAIL, *owned_head))
+		if (cmpxchg(&grp->next, Z_EROFS_VLE_WORKGRP_TAIL,
+			    *owned_head) != Z_EROFS_VLE_WORKGRP_TAIL)
 			goto retry;
 
 		*owned_head = Z_EROFS_VLE_WORKGRP_TAIL;
-- 
2.14.4
