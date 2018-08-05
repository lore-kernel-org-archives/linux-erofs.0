From: kristaps.civkulis@gmail.com (=?UTF-8?q?Kristaps=20=C4=8Civkulis?=)
Date: Sun,  5 Aug 2018 18:21:01 +0300
Subject: [PATCH] staging: erofs: fix if assignment style issue
Message-ID: <20180805152101.11657-1-kristaps.civkulis@gmail.com>

Fix coding style issue "do not use assignment in if condition"
detected by checkpatch.pl.

Signed-off-by: Kristaps ?ivkulis <kristaps.civkulis at gmail.com>
---
 drivers/staging/erofs/unzip_vle.c |  3 ++-
 drivers/staging/erofs/xattr.c     | 16 ++++++++--------
 2 files changed, 10 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/erofs/unzip_vle.c b/drivers/staging/erofs/unzip_vle.c
index 1030ca5c2dc3..45b1255f5a22 100644
--- a/drivers/staging/erofs/unzip_vle.c
+++ b/drivers/staging/erofs/unzip_vle.c
@@ -702,7 +702,8 @@ static int z_erofs_do_read_page(struct z_erofs_vle_frontend *fe,
 	/* can be used for verification */
 	map->m_llen = offset + cur - map->m_la;
 
-	if ((end = cur) > 0)
+	end = cur;
+	if (end > 0)
 		goto repeat;
 
 	/* FIXME! avoid the last relundant fixup & endio */
diff --git a/drivers/staging/erofs/xattr.c b/drivers/staging/erofs/xattr.c
index 6b9685fa601c..0e9cfeccdf99 100644
--- a/drivers/staging/erofs/xattr.c
+++ b/drivers/staging/erofs/xattr.c
@@ -288,8 +288,8 @@ static int inline_getxattr(struct inode *inode, struct getxattr_iter *it)
 
 	remaining = ret;
 	while (remaining) {
-		if ((ret = xattr_foreach(&it->it,
-			&find_xattr_handlers, &remaining)) >= 0)
+		ret = xattr_foreach(&it->it, &find_xattr_handlers, &remaining);
+		if (ret >= 0)
 			break;
 	}
 	xattr_iter_end(&it->it, true);
@@ -321,8 +321,8 @@ static int shared_getxattr(struct inode *inode, struct getxattr_iter *it)
 			it->it.blkaddr = blkaddr;
 		}
 
-		if ((ret = xattr_foreach(&it->it,
-			&find_xattr_handlers, NULL)) >= 0)
+		ret = xattr_foreach(&it->it, &find_xattr_handlers, NULL);
+		if (ret >= 0)
 			break;
 	}
 	if (vi->xattr_shared_count)
@@ -512,8 +512,8 @@ static int inline_listxattr(struct listxattr_iter *it)
 
 	remaining = ret;
 	while (remaining) {
-		if ((ret = xattr_foreach(&it->it,
-			&list_xattr_handlers, &remaining)) < 0)
+		ret = xattr_foreach(&it->it, &list_xattr_handlers, &remaining);
+		if (ret < 0)
 			break;
 	}
 	xattr_iter_end(&it->it, true);
@@ -544,8 +544,8 @@ static int shared_listxattr(struct listxattr_iter *it)
 			it->it.blkaddr = blkaddr;
 		}
 
-		if ((ret = xattr_foreach(&it->it,
-			&list_xattr_handlers, NULL)) < 0)
+		ret = xattr_foreach(&it->it, &list_xattr_handlers, NULL);
+		if (ret < 0)
 			break;
 	}
 	if (vi->xattr_shared_count)
-- 
2.18.0
