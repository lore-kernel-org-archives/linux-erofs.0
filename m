From: shengyong1@huawei.com (Sheng Yong)
Date: Thu, 14 Feb 2019 09:37:54 +0000
Subject: [PATCH] erofs: fix memleak of node's shared xattr array
Message-ID: <20190214093754.14339-1-shengyong1@huawei.com>

If it fails to read a shared xattr page, the node's shared xattr array
is not freed. The next time the node's xattr is accessed, the previously
allocated array is leaked.

Signed-off-by: Sheng Yong <shengyong1 at huawei.com>
---
 drivers/staging/erofs/xattr.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/erofs/xattr.c b/drivers/staging/erofs/xattr.c
index 80dca6a4adbe..e3f8b904a680 100644
--- a/drivers/staging/erofs/xattr.c
+++ b/drivers/staging/erofs/xattr.c
@@ -92,8 +92,11 @@ static int init_inode_xattrs(struct inode *inode)
 
 			it.page = erofs_get_meta_page(sb,
 				++it.blkaddr, S_ISDIR(inode->i_mode));
-			if (IS_ERR(it.page))
+			if (IS_ERR(it.page)) {
+				kfree(vi->xattr_shared_xattrs);
+				vi->xattr_shared_xattrs = NULL;
 				return PTR_ERR(it.page);
+			}
 
 			it.kaddr = kmap_atomic(it.page);
 			atomic_map = true;
-- 
2.17.1
