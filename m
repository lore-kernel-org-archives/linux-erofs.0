From: hsiangkao@aol.com (Gao Xiang)
Date: Wed, 12 Dec 2018 01:57:30 +0800
Subject: [PATCH] staging: erofs: remove __EROFS_BIT
Message-ID: <20181211175730.3931-1-hsiangkao@aol.com>

It's better to use pre-calculated values to make
on-disk definition more straight-forward and human-readable.

Since there is the only one user, let's remove
__EROFS_BIT entirely.

Suggested-by: Joe Perches <joe at perches.com>
Signed-off-by: Gao Xiang <hsiangkao at aol.com>
---
 drivers/staging/erofs/erofs_fs.h | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/erofs/erofs_fs.h b/drivers/staging/erofs/erofs_fs.h
index d4bffa2852b3..fa52898df006 100644
--- a/drivers/staging/erofs/erofs_fs.h
+++ b/drivers/staging/erofs/erofs_fs.h
@@ -38,10 +38,6 @@ struct erofs_super_block {
 /* 80 */__u8 reserved2[48];     /* 128 bytes */
 } __packed;
 
-#define __EROFS_BIT(_prefix, _cur, _pre)	enum {	\
-	_prefix ## _cur ## _BIT = _prefix ## _pre ## _BIT + \
-		_prefix ## _pre ## _BITS }
-
 /*
  * erofs inode data mapping:
  * 0 - inode plain without inline data A:
@@ -58,11 +54,13 @@ enum {
 	EROFS_INODE_LAYOUT_INLINE,
 	EROFS_INODE_LAYOUT_MAX
 };
+
+/* bit definitions of inode i_advise */
 #define EROFS_I_VERSION_BITS            1
 #define EROFS_I_DATA_MAPPING_BITS       3
 
 #define EROFS_I_VERSION_BIT             0
-__EROFS_BIT(EROFS_I_, DATA_MAPPING, VERSION);
+#define EROFS_I_DATA_MAPPING_BIT        1
 
 struct erofs_inode_v1 {
 /*  0 */__le16 i_advise;
-- 
2.11.0
