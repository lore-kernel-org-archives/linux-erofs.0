From: zbestahu@gmail.com (Yue Hu)
Date: Fri, 28 Jun 2019 11:42:34 +0800
Subject: [PATCH] staging: erofs: don't check special inode layout
Message-ID: <20190628034234.8832-1-zbestahu@gmail.com>

From: Yue Hu <huyue2@yulong.com>

Currently, we will check if inode layout is compression or inline if
the inode is special in fill_inode(). Also set ->i_mapping->a_ops for
it. That is pointless since the both modes won't be set for special
inode when creating EROFS filesystem image. So, let's avoid it.

Signed-off-by: Yue Hu <huyue2 at yulong.com>
---
 drivers/staging/erofs/inode.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/staging/erofs/inode.c b/drivers/staging/erofs/inode.c
index 1433f25..2fe0f6d 100644
--- a/drivers/staging/erofs/inode.c
+++ b/drivers/staging/erofs/inode.c
@@ -205,6 +205,7 @@ static int fill_inode(struct inode *inode, int isdir)
 			S_ISFIFO(inode->i_mode) || S_ISSOCK(inode->i_mode)) {
 			inode->i_op = &erofs_generic_iops;
 			init_special_inode(inode, inode->i_mode, inode->i_rdev);
+			goto out_unlock;
 		} else {
 			err = -EIO;
 			goto out_unlock;
-- 
1.9.1
