From: hsiangkao@aol.com (Gao Xiang)
Date: Mon, 30 Jul 2018 03:20:07 +0800
Subject: [RFC PATCH] staging: erofs: harden inode lookup for 32-bit platform
Message-ID: <20180729192007.87372-1-hsiangkao@aol.com>

This patch introduces inode hash function, test and set callbacks,
and iget5_locked to find the right inode for 32-bit platform.

Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>
---
 drivers/staging/erofs/inode.c    | 37 +++++++++++++++++++++++++++++++-
 drivers/staging/erofs/internal.h | 10 +++++++++
 2 files changed, 46 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/erofs/inode.c b/drivers/staging/erofs/inode.c
index fbf6ff25cd1b..5d7e8fc64548 100644
--- a/drivers/staging/erofs/inode.c
+++ b/drivers/staging/erofs/inode.c
@@ -231,10 +231,45 @@ static int fill_inode(struct inode *inode, int isdir)
 	return err;
 }
 
+/*
+ * erofs nid is 64bits, but i_ino is 'unsigned long', therefore
+ * we should do more for 32-bit platform to find the right inode.
+ */
+#if BITS_PER_LONG < 64
+static int erofs_ilookup_test_actor(struct inode *inode, void *opaque)
+{
+	const erofs_nid_t nid = *(erofs_nid_t *)opaque;
+
+	return EROFS_V(inode)->nid == nid;
+}
+
+static int erofs_iget_set_actor(struct inode *inode, void *opaque)
+{
+	const erofs_nid_t nid = *(erofs_nid_t *)opaque;
+
+	inode->i_ino = erofs_inode_hash(nid);
+	return 0;
+}
+#endif
+
+static inline struct inode *erofs_iget_locked(struct super_block *sb,
+					      erofs_nid_t nid)
+{
+	unsigned long hashval = erofs_inode_hash(nid);
+
+#if BITS_PER_LONG >= 64
+	/* it is safe to use iget_locked for >= 64-bit platform */
+	return iget_locked(sb, hashval);
+#else
+	return iget5_locked(sb, hashval, erofs_ilookup_test_actor,
+		erofs_iget_set_actor, &nid);
+#endif
+}
+
 struct inode *erofs_iget(struct super_block *sb,
 	erofs_nid_t nid, bool isdir)
 {
-	struct inode *inode = iget_locked(sb, nid);
+	struct inode *inode = erofs_iget_locked(sb, nid);
 
 	if (unlikely(inode == NULL))
 		return ERR_PTR(-ENOMEM);
diff --git a/drivers/staging/erofs/internal.h b/drivers/staging/erofs/internal.h
index 367b39fe46e5..b08df0a31ddd 100644
--- a/drivers/staging/erofs/internal.h
+++ b/drivers/staging/erofs/internal.h
@@ -473,6 +473,16 @@ static inline struct page *erofs_get_inline_page(struct inode *inode,
 }
 
 /* inode.c */
+static inline unsigned long erofs_inode_hash(erofs_nid_t nid)
+{
+	u64 h = nid;
+
+#if BITS_PER_LONG == 32
+	h = (h >> 32) ^ (h & 0xffffffff);
+#endif
+	return (unsigned long)h;
+}
+
 extern struct inode *erofs_iget(struct super_block *sb,
 	erofs_nid_t nid, bool dir);
 
-- 
2.17.1
