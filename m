From: linux.bhar@gmail.com (Bharath Vedartham)
Date: Sat, 16 Mar 2019 16:47:08 +0530
Subject: No subject
Message-ID: <20190316111708.GA28708@bharath12345-Inspiron-5559>

linux-kernel at vger.kernel.org 
Bcc: 
Subject: [PATCH] staging: erofs: Add whitespace after declaration
Reply-To: 

Fix the checkpatch.pl warning to add a whitespace after declaration
statements.

Signed-off-by: Bharath Vedartham <linux.bhar at gmail.com>
---
 drivers/staging/erofs/inode.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/staging/erofs/inode.c b/drivers/staging/erofs/inode.c
index 924b8df..9a36a1f 100644
--- a/drivers/staging/erofs/inode.c
+++ b/drivers/staging/erofs/inode.c
@@ -270,8 +270,8 @@ struct inode *erofs_iget(struct super_block *sb,
 	if (inode->i_state & I_NEW) {
 		int err;
 		struct erofs_vnode *vi = EROFS_V(inode);
-		vi->nid = nid;
 
+		vi->nid = nid;
 		err = fill_inode(inode, isdir);
 		if (likely(!err))
 			unlock_new_inode(inode);
@@ -305,4 +305,3 @@ const struct inode_operations erofs_fast_symlink_iops = {
 #endif
 	.get_acl = erofs_get_acl,
 };
-
-- 
2.7.4
