From: hsiangkao@aol.com (Gao Xiang)
Date: Mon,  1 Oct 2018 12:32:55 +0800
Subject: [PREVIEW][PATCH v2 chao/erofs-dev] staging: erofs: harden inode
 lookup for 32-bit platforms
In-Reply-To: <9db17a38-8f62-2057-e040-5b0d5dd579bb@aol.com>
References: <9db17a38-8f62-2057-e040-5b0d5dd579bb@aol.com>
Message-ID: <1538368375-847-1-git-send-email-hsiangkao@aol.com>

From: Gao Xiang <gaoxiang25@huawei.com>

This patch introduces inode hash function, test and set callbacks,
and iget5_locked to find the right inode for 32-bit platforms.

Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>
---
 drivers/staging/erofs/inode.c    | 37 ++++++++++++++++++++++++++++++++++++-
 drivers/staging/erofs/internal.h |  9 +++++++++
 2 files changed, 45 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/erofs/inode.c b/drivers/staging/erofs/inode.c
index da8693a..04c61a9 100644
--- a/drivers/staging/erofs/inode.c
+++ b/drivers/staging/erofs/inode.c
@@ -232,10 +232,45 @@ static int fill_inode(struct inode *inode, int isdir)
 	return err;
 }
 
+/*
+ * erofs nid is 64bits, but i_ino is 'unsigned long', therefore
+ * we should do more for 32-bit platform to find the right inode.
+ */
+#if BITS_PER_LONG == 32
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
+	const unsigned long hashval = erofs_inode_hash(nid);
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
index c2cc4a016..0e85aae 100644
--- a/drivers/staging/erofs/internal.h
+++ b/drivers/staging/erofs/internal.h
@@ -511,6 +511,15 @@ erofs_get_inline_page(struct inode *inode,
 }
 
 /* inode.c */
+static inline unsigned long erofs_inode_hash(erofs_nid_t nid)
+{
+#if BITS_PER_LONG == 32
+	return (nid >> 32) ^ (nid & 0xffffffff);
+#else
+	return nid;
+#endif
+}
+
 extern struct inode *erofs_iget(struct super_block *sb,
 	erofs_nid_t nid, bool dir);
 
-- 
2.7.4
