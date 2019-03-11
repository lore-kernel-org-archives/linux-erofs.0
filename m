From: gaoxiang25@huawei.com (Gao Xiang)
Date: Mon, 11 Mar 2019 14:08:56 +0800
Subject: [PATCH 4.19 3/5] staging: erofs: fix memleak of inode's shared xattr
 array
In-Reply-To: <20190311060858.28654-1-gaoxiang25@huawei.com>
References: <20190311060858.28654-1-gaoxiang25@huawei.com>
Message-ID: <20190311060858.28654-3-gaoxiang25@huawei.com>

From: Sheng Yong <shengyong1@huawei.com>

commit 3b1b5291f79d040d549d7c746669fc30e8045b9b upstream.

If it fails to read a shared xattr page, the inode's shared xattr array
is not freed. The next time the inode's xattr is accessed, the previously
allocated array is leaked.

Signed-off-by: Sheng Yong <shengyong1 at huawei.com>
Fixes: b17500a0fdba ("staging: erofs: introduce xattr & acl support")
Cc: <stable at vger.kernel.org> # 4.19+
Reviewed-by: Gao Xiang <gaoxiang25 at huawei.com>
Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>
---
 drivers/staging/erofs/xattr.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/erofs/xattr.c b/drivers/staging/erofs/xattr.c
index ac2567576335..890fa06bbcbb 100644
--- a/drivers/staging/erofs/xattr.c
+++ b/drivers/staging/erofs/xattr.c
@@ -109,8 +109,11 @@ static int init_inode_xattrs(struct inode *inode)
 
 			it.page = erofs_get_meta_page(inode->i_sb,
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
2.14.5
