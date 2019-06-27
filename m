From: shobhitkukreti@gmail.com (Shobhit Kukreti)
Date: Wed, 26 Jun 2019 22:31:18 -0700
Subject: [PATCH] staging: erofs: Replace kzalloc(struct ..) with kzalloc(*ptr)
Message-ID: <20190627053115.GA20942@t-1000>

Resolve checkpatch warning:
Prefer kzalloc(sizeof(*ptr)...) over kzalloc(sizeof(struct ..)

Signed-off-by: Shobhit Kukreti <shobhitkukreti at gmail.com>
---
 drivers/staging/erofs/super.c     | 2 +-
 drivers/staging/erofs/unzip_vle.c | 3 +--
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/erofs/super.c b/drivers/staging/erofs/super.c
index cadbcc1..5449441 100644
--- a/drivers/staging/erofs/super.c
+++ b/drivers/staging/erofs/super.c
@@ -383,7 +383,7 @@ static int erofs_read_super(struct super_block *sb,
 		goto err;
 	}
 
-	sbi = kzalloc(sizeof(struct erofs_sb_info), GFP_KERNEL);
+	sbi = kzalloc(sizeof(*sbi), GFP_KERNEL);
 	if (unlikely(!sbi)) {
 		err = -ENOMEM;
 		goto err;
diff --git a/drivers/staging/erofs/unzip_vle.c b/drivers/staging/erofs/unzip_vle.c
index 316382d..f0dab81f 100644
--- a/drivers/staging/erofs/unzip_vle.c
+++ b/drivers/staging/erofs/unzip_vle.c
@@ -1263,8 +1263,7 @@ jobqueue_init(struct super_block *sb,
 		goto out;
 	}
 
-	iosb = kvzalloc(sizeof(struct z_erofs_vle_unzip_io_sb),
-			GFP_KERNEL | __GFP_NOFAIL);
+	iosb = kvzalloc(sizeof(*iosb), GFP_KERNEL | __GFP_NOFAIL);
 	DBG_BUGON(!iosb);
 
 	/* initialize fields in the allocated descriptor */
-- 
2.7.4
