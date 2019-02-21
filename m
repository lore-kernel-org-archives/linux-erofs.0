From: tsu.yubo@gmail.com (Bo YU)
Date: Thu, 21 Feb 2019 09:28:45 -0500
Subject: [PATCH] staging/erofs: fix sparse's warnings on undeclared symbols in
 erofs
Message-ID: <20190221142845.13604-1-tsu.yubo@gmail.com>

From: Bo Yu <tsu.yubo@gmail.com>

Fix sparse warnings:

drivers/staging/erofs/utils.c:134:6: warning: symbol
'erofs_try_to_release_workgroup' was not declared. Should it be static?

Fixes: 51232df5e4b26("staging: erofs: fix race when the managed cache is enabled")
Cc: Gao Xiang <gaoxiang25 at huawei.com>
Cc: Chao Yu <yuchao0 at huawei.com>
CC: Greg Kroah-Hartman <gregkh at linuxfoundation.org>
Signed-off-by: Bo Yu <tsu.yubo at gmail.com>
---
 drivers/staging/erofs/utils.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/erofs/utils.c b/drivers/staging/erofs/utils.c
index b535898ca753..33cd5ad55cb8 100644
--- a/drivers/staging/erofs/utils.c
+++ b/drivers/staging/erofs/utils.c
@@ -131,7 +131,7 @@ static void erofs_workgroup_unfreeze_final(struct erofs_workgroup *grp)
 	__erofs_workgroup_free(grp);
 }
 
-bool erofs_try_to_release_workgroup(struct erofs_sb_info *sbi,
+static bool erofs_try_to_release_workgroup(struct erofs_sb_info *sbi,
 				    struct erofs_workgroup *grp,
 				    bool cleanup)
 {
-- 
2.11.0
