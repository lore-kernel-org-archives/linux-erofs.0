From: hsiangkao@aol.com (Gao Xiang)
Date: Tue, 14 Aug 2018 12:36:05 +0800
Subject: [PREVIEW] [PATCH 1/2] staging: erofs: add some comments for xattr
 subsystem
Message-ID: <1534221366-1093-1-git-send-email-hsiangkao@aol.com>

As Dan Carpenter pointed out, it is better to document what
return values of these callbacks in `struct xattr_iter_handlers'
mean and why it->ofs is increased regardless of success or
failure in `xattr_foreach'.

Suggested-by: Dan Carpenter <dan.carpenter at oracle.com>
Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>
---
 drivers/staging/erofs/xattr.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/erofs/xattr.c b/drivers/staging/erofs/xattr.c
index 2eca6ed..4bb7d9e 100644
--- a/drivers/staging/erofs/xattr.c
+++ b/drivers/staging/erofs/xattr.c
@@ -109,6 +109,13 @@ static int init_inode_xattrs(struct inode *inode)
 	return 0;
 }
 
+/*
+ * the general idea for these return values is
+ * if    0 is returned, go on processing the current xattr;
+ *       1 (> 0) is returned, skip this round to process the next xattr;
+ *    -err (< 0) is returned, an error (maybe ENOXATTR) occurred
+ *                            and need to be handled
+ */
 struct xattr_iter_handlers {
 	int (*entry)(struct xattr_iter *, struct erofs_xattr_entry *);
 	int (*name)(struct xattr_iter *, unsigned, char *, unsigned);
@@ -164,6 +171,10 @@ static int inline_xattr_iter_begin(struct xattr_iter *it,
 	return vi->xattr_isize - xattr_header_sz;
 }
 
+/*
+ * Regardless of success or failure, `xattr_foreach' will end up with
+ * `ofs' pointing to the next xattr item rather than an arbitrary position.
+ */
 static int xattr_foreach(struct xattr_iter *it,
 	const struct xattr_iter_handlers *op, unsigned *tlimit)
 {
@@ -255,7 +266,7 @@ static int xattr_foreach(struct xattr_iter *it,
 	}
 
 out:
-	/* we assume that ofs is aligned with 4 bytes */
+	/* xattrs should be 4-byte aligned (on-disk constraint) */
 	it->ofs = EROFS_XATTR_ALIGN(it->ofs);
 	return err;
 }
-- 
2.7.4
