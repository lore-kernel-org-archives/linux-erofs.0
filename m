From: gaoxiang25@huawei.com (Gao Xiang)
Date: Tue, 9 Oct 2018 22:07:13 +0800
Subject: [PATCH] staging: erofs: harden inode lookup for 32-bit platforms
Message-ID: <20181009140713.29629-1-gaoxiang25@huawei.com>

This patch introduces inode hash function, test and set callbacks,
and iget5_locked to find the right inode for 32-bit platforms.

Reviewed-by: Chao Yu <yuchao0 at huawei.com>
Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>
---

The patch has been previewed in the linux-erofs mailing list, submit to
the staging mailing list for linux-4.20.

Thanks,
Gao Xiang

 drivers/staging/erofs/inode.c    | 37 ++++++++++++++++++++++++++++++++++++-
 drivers/staging/erofs/internal.h |  9 +++++++++
 2 files changed, 45 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/erofs/inode.c b/drivers/staging/erofs/inode.c
index da8693a7c3d3..04c61a9d7b76 100644
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
index 5096b27bcf0d..57575c7f5635 100644
--- a/drivers/staging/erofs/internal.h
+++ b/drivers/staging/erofs/internal.h
@@ -517,6 +517,15 @@ erofs_get_inline_page(struct inode *inode,
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
2.14.4
