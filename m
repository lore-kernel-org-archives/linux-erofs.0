From: aaron.strahlberger@posteo.de (Aaron Strahlberger)
Date: Tue, 11 Dec 2018 11:54:41 +0100
Subject: [PATCH 3/5] drivers: staging: erofs: Fix spelling issue
In-Reply-To: <20181211105443.21826-1-aaron.strahlberger@posteo.de>
References: <0ed9f3e7-9081-4a8a-06b0-e5ad14e2c872@huawei.com>
 <20181211105443.21826-1-aaron.strahlberger@posteo.de>
Message-ID: <20181211105443.21826-4-aaron.strahlberger@posteo.de>

Changed "stoped" to "stopped".

Signed-off-by: Aaron Strahlberger <aaron.strahlberger at posteo.de>
Signed-off-by: Julius Wiedmann <julius.wiedmann at fau.de>
Signed-off-by: Dominik Huber <domi250 at gmx.de>
---
 drivers/staging/erofs/dir.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/erofs/dir.c b/drivers/staging/erofs/dir.c
index 49a4e7730df0..e83475260106 100644
--- a/drivers/staging/erofs/dir.c
+++ b/drivers/staging/erofs/dir.c
@@ -66,8 +66,8 @@ static int erofs_fill_dentries(struct dir_context *ctx,
 #endif
 
 		if (!dir_emit(ctx, de_name, de_namelen,
-					le64_to_cpu(de->nid), d_type))
-			/* stoped by some reason */
+			      le64_to_cpu(de->nid), d_type))
+			/* stopped by some reason */
 			return 1;
 		++de;
 		*ofs += sizeof(struct erofs_dirent);
-- 
2.19.2
