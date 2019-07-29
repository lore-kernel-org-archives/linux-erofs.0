From: gaoxiang25@huawei.com (Gao Xiang)
Date: Mon, 29 Jul 2019 14:51:52 +0800
Subject: [PATCH 15/22] staging: erofs: remove redundant braces in inode.c
In-Reply-To: <20190729065159.62378-1-gaoxiang25@huawei.com>
References: <20190729065159.62378-1-gaoxiang25@huawei.com>
Message-ID: <20190729065159.62378-16-gaoxiang25@huawei.com>

Remove redundant braces in inode.c since
these are all single statements.

Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>
---
 drivers/staging/erofs/inode.c | 18 ++++++++----------
 1 file changed, 8 insertions(+), 10 deletions(-)

diff --git a/drivers/staging/erofs/inode.c b/drivers/staging/erofs/inode.c
index c13d66ccc74a..286729143365 100644
--- a/drivers/staging/erofs/inode.c
+++ b/drivers/staging/erofs/inode.c
@@ -35,16 +35,15 @@ static int read_inode(struct inode *inode, void *data)
 
 		inode->i_mode = le16_to_cpu(v2->i_mode);
 		if (S_ISREG(inode->i_mode) || S_ISDIR(inode->i_mode) ||
-		    S_ISLNK(inode->i_mode)) {
+		    S_ISLNK(inode->i_mode))
 			vi->raw_blkaddr = le32_to_cpu(v2->i_u.raw_blkaddr);
-		} else if (S_ISCHR(inode->i_mode) || S_ISBLK(inode->i_mode)) {
+		else if (S_ISCHR(inode->i_mode) || S_ISBLK(inode->i_mode))
 			inode->i_rdev =
 				new_decode_dev(le32_to_cpu(v2->i_u.rdev));
-		} else if (S_ISFIFO(inode->i_mode) || S_ISSOCK(inode->i_mode)) {
+		else if (S_ISFIFO(inode->i_mode) || S_ISSOCK(inode->i_mode))
 			inode->i_rdev = 0;
-		} else {
+		else
 			return -EIO;
-		}
 
 		i_uid_write(inode, le32_to_cpu(v2->i_uid));
 		i_gid_write(inode, le32_to_cpu(v2->i_gid));
@@ -69,16 +68,15 @@ static int read_inode(struct inode *inode, void *data)
 
 		inode->i_mode = le16_to_cpu(v1->i_mode);
 		if (S_ISREG(inode->i_mode) || S_ISDIR(inode->i_mode) ||
-		    S_ISLNK(inode->i_mode)) {
+		    S_ISLNK(inode->i_mode))
 			vi->raw_blkaddr = le32_to_cpu(v1->i_u.raw_blkaddr);
-		} else if (S_ISCHR(inode->i_mode) || S_ISBLK(inode->i_mode)) {
+		else if (S_ISCHR(inode->i_mode) || S_ISBLK(inode->i_mode))
 			inode->i_rdev =
 				new_decode_dev(le32_to_cpu(v1->i_u.rdev));
-		} else if (S_ISFIFO(inode->i_mode) || S_ISSOCK(inode->i_mode)) {
+		else if (S_ISFIFO(inode->i_mode) || S_ISSOCK(inode->i_mode))
 			inode->i_rdev = 0;
-		} else {
+		else
 			return -EIO;
-		}
 
 		i_uid_write(inode, le16_to_cpu(v1->i_uid));
 		i_gid_write(inode, le16_to_cpu(v1->i_gid));
-- 
2.17.1
