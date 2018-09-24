From: cgxu519@gmx.com (Chengguang Xu)
Date: Tue, 25 Sep 2018 07:41:36 +0800
Subject: [PATCH] staging: erofs: change inode related info in erofs_statfs()
Message-ID: <20180924234136.19465-1-cgxu519@gmx.com>

As a read only filesystem, it's better to show available
inode num as 0 in statfs.

Signed-off-by: Chengguang Xu <cgxu519 at gmx.com>
---
 drivers/staging/erofs/super.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/erofs/super.c b/drivers/staging/erofs/super.c
index 51b076255988..6601a242071f 100644
--- a/drivers/staging/erofs/super.c
+++ b/drivers/staging/erofs/super.c
@@ -627,8 +627,8 @@ static int erofs_statfs(struct dentry *dentry, struct kstatfs *buf)
 	buf->f_blocks = sbi->blocks;
 	buf->f_bfree = buf->f_bavail = 0;
 
-	buf->f_files = ULLONG_MAX;
-	buf->f_ffree = ULLONG_MAX - sbi->inos;
+	buf->f_files = sbi->inos;
+	buf->f_ffree = 0;
 
 	buf->f_namelen = EROFS_NAME_LEN;
 
-- 
2.17.1
