From: juliobianco@gmail.com (Julio Bianco)
Date: Sat,  9 Mar 2019 14:08:53 -0300
Subject: [PATCH] staging: erofs: add a new line after variable declaration
Message-ID: <20190309170853.8297-1-juliobianco@gmail.com>

Add a new line after variable declaration

Signed-off-by: Julio Bianco <juliobianco at gmail.com>
---
 drivers/staging/erofs/inode.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/staging/erofs/inode.c b/drivers/staging/erofs/inode.c
index 924b8dfc7a8f..1cf1afe2d73a 100644
--- a/drivers/staging/erofs/inode.c
+++ b/drivers/staging/erofs/inode.c
@@ -270,6 +270,7 @@ struct inode *erofs_iget(struct super_block *sb,
 	if (inode->i_state & I_NEW) {
 		int err;
 		struct erofs_vnode *vi = EROFS_V(inode);
+
 		vi->nid = nid;
 
 		err = fill_inode(inode, isdir);
-- 
2.11.0
