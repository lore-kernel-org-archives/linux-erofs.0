From: gaoxiang25@huawei.com (Gao Xiang)
Date: Thu, 21 Feb 2019 10:34:10 +0800
Subject: [PATCH 1/2] staging: erofs: no need to take page lock in readdir
Message-ID: <20190221023411.2980-1-gaoxiang25@huawei.com>

VFS will take inode_lock for readdir, therefore no need to
take page lock in readdir at all just as the majority of
other generic filesystems.

Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>
---
 drivers/staging/erofs/dir.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/staging/erofs/dir.c b/drivers/staging/erofs/dir.c
index e1955703ab8f..8f8ac9675921 100644
--- a/drivers/staging/erofs/dir.c
+++ b/drivers/staging/erofs/dir.c
@@ -98,7 +98,6 @@ static int erofs_readdir(struct file *f, struct dir_context *ctx)
 		if (IS_ERR(dentry_page))
 			continue;
 
-		lock_page(dentry_page);
 		de = (struct erofs_dirent *)kmap(dentry_page);
 
 		nameoff = le16_to_cpu(de->nameoff);
@@ -128,7 +127,6 @@ static int erofs_readdir(struct file *f, struct dir_context *ctx)
 skip_this:
 		kunmap(dentry_page);
 
-		unlock_page(dentry_page);
 		put_page(dentry_page);
 
 		ctx->pos = blknr_to_addr(i) + ofs;
-- 
2.14.4
