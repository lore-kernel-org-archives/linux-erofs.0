From: gaoxiang25@huawei.com (Gao Xiang)
Date: Wed, 26 Dec 2018 11:34:11 +0800
Subject: [PATCH] staging: erofs: fix return type of erofs_workgroup_get
Message-ID: <20181226033411.13568-1-gaoxiang25@huawei.com>

There exists a return type misuse (`int'->`bool') since all
users assume it fails if only return value != 0, let's fix
the return type to `int' instead of confusing `bool'.

No logic changes.

Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>
---
 drivers/staging/erofs/internal.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/erofs/internal.h b/drivers/staging/erofs/internal.h
index e049d00c087a..49c587383315 100644
--- a/drivers/staging/erofs/internal.h
+++ b/drivers/staging/erofs/internal.h
@@ -252,7 +252,7 @@ static inline int erofs_wait_on_workgroup_freezed(struct erofs_workgroup *grp)
 }
 #endif
 
-static inline bool erofs_workgroup_get(struct erofs_workgroup *grp, int *ocnt)
+static inline int erofs_workgroup_get(struct erofs_workgroup *grp, int *ocnt)
 {
 	int o;
 
-- 
2.14.4
