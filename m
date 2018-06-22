From: yuchao0@huawei.com (Chao Yu)
Date: Fri, 22 Jun 2018 10:01:26 +0800
Subject: [PATCH 06/11] erofs: fix to return correct value of alloc_inode
In-Reply-To: <20180622020131.65525-1-yuchao0@huawei.com>
References: <20180622020131.65525-1-yuchao0@huawei.com>
Message-ID: <20180622020131.65525-6-yuchao0@huawei.com>

We should return NULL value in error path of alloc_inode(), otherwise,
VFS will treat any non-null return value as value inode, result in
invalid pointer dereference.

Reviewed-by: Gao Xiang <gaoxiang25 at huawei.com>
Signed-off-by: Chao Yu <yuchao0 at huawei.com>
---
 fs/erofs/super.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/fs/erofs/super.c b/fs/erofs/super.c
index e6d4efd7c043..3fcb56fd988e 100644
--- a/fs/erofs/super.c
+++ b/fs/erofs/super.c
@@ -40,12 +40,12 @@ static struct inode *alloc_inode(struct super_block *sb)
 	struct erofs_vnode *vi =
 		kmem_cache_alloc(erofs_inode_cachep, GFP_KERNEL);
 
-	if (vi != NULL) {
-		/* zero out everything except vfs_inode */
-		memset(vi, 0, offsetof(struct erofs_vnode, vfs_inode));
-		return &vi->vfs_inode;
-	}
-	return ERR_PTR(-ENOMEM);
+	if (!vi)
+		return NULL;
+
+	/* zero out everything except vfs_inode */
+	memset(vi, 0, offsetof(struct erofs_vnode, vfs_inode));
+	return &vi->vfs_inode;
 }
 
 static void i_callback(struct rcu_head *head)
-- 
2.18.0.rc1
