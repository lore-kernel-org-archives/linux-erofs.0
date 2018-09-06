From: gaoxiang25@huawei.com (Gao Xiang)
Date: Thu, 6 Sep 2018 17:01:47 +0800
Subject: [PATCH 1/2 dhowells/mount-api] staging: erofs: rename superblock
 flags (MS_xyz -> SB_xyz)
Message-ID: <1536224508-66168-1-git-send-email-gaoxiang25@huawei.com>

This patch follows commit 1751e8a6cb93 ("Rename superblock
flags (MS_xyz -> SB_xyz)") and after commit ("vfs: Suppress
MS_* flag defs within the kernel unless explicitly enabled"),
there is no MS_RDONLY and MS_NOATIME at all.

Reported-by: Stephen Rothwell <sfr at canb.auug.org.au>
Reviewed-by: Chao Yu <yuchao0 at huawei.com>
Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>
---

Once used MS_RDONLY, MS_NOATIME for the compatibility of older kernels,
which are removed in ("vfs: Suppress MS_* flag defs within the kernel
unless explicitly enabled").

 drivers/staging/erofs/super.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/erofs/super.c b/drivers/staging/erofs/super.c
index 1aec509..2df9768 100644
--- a/drivers/staging/erofs/super.c
+++ b/drivers/staging/erofs/super.c
@@ -340,7 +340,7 @@ static int erofs_read_super(struct super_block *sb,
 		goto err_sbread;
 
 	sb->s_magic = EROFS_SUPER_MAGIC;
-	sb->s_flags |= MS_RDONLY | MS_NOATIME;
+	sb->s_flags |= SB_RDONLY | SB_NOATIME;
 	sb->s_maxbytes = MAX_LFS_FILESIZE;
 	sb->s_time_gran = 1;
 
@@ -627,7 +627,7 @@ static int erofs_remount(struct super_block *sb, int *flags, char *data)
 {
 	BUG_ON(!sb_rdonly(sb));
 
-	*flags |= MS_RDONLY;
+	*flags |= SB_RDONLY;
 	return 0;
 }
 
-- 
1.9.1
