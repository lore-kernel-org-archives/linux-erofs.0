From: huanglianjun@vivo.com (Lianjun Huang)
Date: Thu, 23 May 2019 12:57:17 +0800
Subject: [PATCH] erofs-utils: fix an uninitialized variable
Message-ID: <20190523045717.GA15346@hlj.localdomain>

This fixes a building failure caused by using a variable before initialization.

Signed-off-by: Lianjun Huang <huanglianjun at vivo.com>
---
 mkfs/erofs_cache.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mkfs/erofs_cache.c b/mkfs/erofs_cache.c
index 5bb293b..0d7acf7 100644
--- a/mkfs/erofs_cache.c
+++ b/mkfs/erofs_cache.c
@@ -142,7 +142,7 @@ int erofs_flush_all_blocks(void)
 	char *erofs_blk_buf;
 	char *pbuf;
 	int count;
-	int ret;
+	int ret = 0;
 
 	erofs_blk_buf = malloc(EROFS_BLKSIZE);
 	if (!erofs_blk_buf)
-- 
1.7.9.5
