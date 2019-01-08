From: realwakka@gmail.com (Sidong Yang)
Date: Tue,  8 Jan 2019 13:24:54 +0000
Subject: [PATCH v2] staging: erofs: Add identifier for function definition
 arguments
Message-ID: <20190108132454.20513-1-realwakka@gmail.com>

Add identifier for function definition arguments in xattr_iter_handlers,
this change clears the checkpatch.pl issue and make code more explicit.

Signed-off-by: Sidong Yang <realwakka at gmail.com>
---
 drivers/staging/erofs/xattr.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/erofs/xattr.c b/drivers/staging/erofs/xattr.c
index 80dca6a4adbe..59bc5641c4e7 100644
--- a/drivers/staging/erofs/xattr.c
+++ b/drivers/staging/erofs/xattr.c
@@ -117,10 +117,12 @@ static int init_inode_xattrs(struct inode *inode)
  *                            and need to be handled
  */
 struct xattr_iter_handlers {
-	int (*entry)(struct xattr_iter *, struct erofs_xattr_entry *);
-	int (*name)(struct xattr_iter *, unsigned int, char *, unsigned int);
-	int (*alloc_buffer)(struct xattr_iter *, unsigned int);
-	void (*value)(struct xattr_iter *, unsigned int, char *, unsigned int);
+	int (*entry)(struct xattr_iter *_it, struct erofs_xattr_entry *entry);
+	int (*name)(struct xattr_iter *_it, unsigned int processed, char *buf,
+		    unsigned int len);
+	int (*alloc_buffer)(struct xattr_iter *_it, unsigned int value_sz);
+	void (*value)(struct xattr_iter *_it, unsigned int processed, char *buf,
+		      unsigned int len);
 };
 
 static inline int xattr_iter_fixup(struct xattr_iter *it)
-- 
2.17.1
