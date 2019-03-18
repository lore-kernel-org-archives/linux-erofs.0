From: linux.bhar@gmail.com (Bharath Vedartham)
Date: Mon, 18 Mar 2019 21:02:24 +0530
Subject: [PATCH v3] staging: erofs: Add whitespace after declaration
Message-ID: <20190318153224.GA3596@bharath12345-Inspiron-5559>

Add whitespace after declaration. Fixed the checkpatch.pl warning.

---
changes since v2
	- mutt gave me a lot of problems. Hence 3 patches for a really
	  small problem.
	- Fixed the extra missing line.

Signed-off-by: Bharath Vedartham <linux.bhar at gmail.com>
---
 drivers/staging/erofs/inode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/erofs/inode.c b/drivers/staging/erofs/inode.c
index 924b8df..e09d29f 100644
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
-- 
2.7.4
