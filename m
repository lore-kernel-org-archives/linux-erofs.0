From: hsiangkao@aol.com (Gao Xiang)
Date: Tue, 14 Aug 2018 12:36:06 +0800
Subject: [PREVIEW] [RFC PATCH 2/2] staging: erofs: simplify return value of
 xattr_foreach
In-Reply-To: <1534221366-1093-1-git-send-email-hsiangkao@aol.com>
References: <1534221366-1093-1-git-send-email-hsiangkao@aol.com>
Message-ID: <1534221366-1093-2-git-send-email-hsiangkao@aol.com>

As Dan Carpenter pointed out, there is no need to propagate positive
return values back to its callers.

Suggested-by: Dan Carpenter <dan.carpenter at oracle.com>
Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>
---

If some error, please help point out.
And any comments are welcomed. :)

Thanks,
Gao Xiang

 drivers/staging/erofs/xattr.c | 24 +++++++++---------------
 1 file changed, 9 insertions(+), 15 deletions(-)

diff --git a/drivers/staging/erofs/xattr.c b/drivers/staging/erofs/xattr.c
index 4bb7d9e..93a6559 100644
--- a/drivers/staging/erofs/xattr.c
+++ b/drivers/staging/erofs/xattr.c
@@ -268,7 +268,7 @@ static int xattr_foreach(struct xattr_iter *it,
 out:
 	/* xattrs should be 4-byte aligned (on-disk constraint) */
 	it->ofs = EROFS_XATTR_ALIGN(it->ofs);
-	return err;
+	return err < 0 ? err : 0;
 }
 
 struct getxattr_iter {
@@ -333,15 +333,12 @@ static int inline_getxattr(struct inode *inode, struct getxattr_iter *it)
 	remaining = ret;
 	while (remaining) {
 		ret = xattr_foreach(&it->it, &find_xattr_handlers, &remaining);
-		if (ret >= 0)
-			break;
-
-		if (ret != -ENOATTR)	/* -ENOMEM, -EIO, etc. */
+		if (ret != -ENOATTR)
 			break;
 	}
 	xattr_iter_end_final(&it->it);
 
-	return ret < 0 ? ret : it->buffer_size;
+	return ret ? ret : it->buffer_size;
 }
 
 static int shared_getxattr(struct inode *inode, struct getxattr_iter *it)
@@ -371,16 +368,13 @@ static int shared_getxattr(struct inode *inode, struct getxattr_iter *it)
 		}
 
 		ret = xattr_foreach(&it->it, &find_xattr_handlers, NULL);
-		if (ret >= 0)
-			break;
-
-		if (ret != -ENOATTR)	/* -ENOMEM, -EIO, etc. */
+		if (ret != -ENOATTR)
 			break;
 	}
 	if (vi->xattr_shared_count)
 		xattr_iter_end_final(&it->it);
 
-	return ret < 0 ? ret : it->buffer_size;
+	return ret ? ret : it->buffer_size;
 }
 
 static bool erofs_xattr_user_list(struct dentry *dentry)
@@ -567,11 +561,11 @@ static int inline_listxattr(struct listxattr_iter *it)
 	remaining = ret;
 	while (remaining) {
 		ret = xattr_foreach(&it->it, &list_xattr_handlers, &remaining);
-		if (ret < 0)
+		if (ret)
 			break;
 	}
 	xattr_iter_end_final(&it->it);
-	return ret < 0 ? ret : it->buffer_ofs;
+	return ret ? ret : it->buffer_ofs;
 }
 
 static int shared_listxattr(struct listxattr_iter *it)
@@ -601,13 +595,13 @@ static int shared_listxattr(struct listxattr_iter *it)
 		}
 
 		ret = xattr_foreach(&it->it, &list_xattr_handlers, NULL);
-		if (ret < 0)
+		if (ret)
 			break;
 	}
 	if (vi->xattr_shared_count)
 		xattr_iter_end_final(&it->it);
 
-	return ret < 0 ? ret : it->buffer_ofs;
+	return ret ? ret : it->buffer_ofs;
 }
 
 ssize_t erofs_listxattr(struct dentry *dentry,
-- 
2.7.4
