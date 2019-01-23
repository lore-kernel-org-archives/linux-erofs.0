From: cgxu519@gmx.com (Chengguang Xu)
Date: Wed, 23 Jan 2019 14:12:25 +0800
Subject: [PATCH] staging: erofs: fix potential double iput in
 erofs_read_super()
Message-ID: <20190123061225.19860-1-cgxu519@gmx.com>

Some error cases like failing from d_make_root() will
cause double iput because d_make_root() also does iput
in its error path.

Signed-off-by: Chengguang Xu <cgxu519 at gmx.com>
---
Only compile tested.

 drivers/staging/erofs/super.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/erofs/super.c b/drivers/staging/erofs/super.c
index 1c2eb69682ef..bd97679aacfc 100644
--- a/drivers/staging/erofs/super.c
+++ b/drivers/staging/erofs/super.c
@@ -420,13 +420,14 @@ static int erofs_read_super(struct super_block *sb,
 		errln("rootino(nid %llu) is not a directory(i_mode %o)",
 			ROOT_NID(sbi), inode->i_mode);
 		err = -EINVAL;
-		goto err_isdir;
+		iput(inode);
+		goto err_iget;
 	}
 
 	sb->s_root = d_make_root(inode);
 	if (sb->s_root == NULL) {
 		err = -ENOMEM;
-		goto err_makeroot;
+		goto err_iget;
 	}
 
 	/* save the device name to sbi */
@@ -452,10 +453,6 @@ static int erofs_read_super(struct super_block *sb,
 	 */
 err_devname:
 	dput(sb->s_root);
-err_makeroot:
-err_isdir:
-	if (sb->s_root == NULL)
-		iput(inode);
 err_iget:
 #ifdef EROFS_FS_HAS_MANAGED_CACHE
 	iput(sbi->managed_cache);
-- 
2.20.1
