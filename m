From: aaron.strahlberger@posteo.de (Aaron Strahlberger)
Date: Wed, 12 Dec 2018 13:02:09 +0100
Subject: [PATCH v2] staging:erofs: Remove __EROFS_BIT macro
In-Reply-To: <9d324f50-e632-c020-04b9-57269ff7bdca@aol.com>
References: <9d324f50-e632-c020-04b9-57269ff7bdca@aol.com>
Message-ID: <20181212120209.16304-1-aaron.strahlberger@posteo.de>

The `__EROFS_BIT` macro is used only once, do define the
`EROFS_I_DATA_MAPPING_BIT` constant. This Patch removes this
macro and expands it in the place it is used.

Signed-off-by: Aaron Strahlberger <aaron.strahlberger at posteo.de>
Signed-off-by: Julius Wiedmann <julius.wiedmann at fau.de>
Signed-off-by: Dominik Huber <domi250 at gmx.de>
---
 drivers/staging/erofs/erofs_fs.h | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/erofs/erofs_fs.h b/drivers/staging/erofs/erofs_fs.h
index d4bffa2852b3..da5562df847b 100644
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
@@ -58,11 +54,14 @@ enum {
 	EROFS_INODE_LAYOUT_INLINE,
 	EROFS_INODE_LAYOUT_MAX
 };
+
 #define EROFS_I_VERSION_BITS            1
 #define EROFS_I_DATA_MAPPING_BITS       3
 
 #define EROFS_I_VERSION_BIT             0
-__EROFS_BIT(EROFS_I_, DATA_MAPPING, VERSION);
+enum {
+	EROFS_I_DATA_MAPPING_BIT = EROFS_I_VERSION_BIT + EROFS_I_VERSION_BITS
+}
 
 struct erofs_inode_v1 {
 /*  0 */__le16 i_advise;
-- 
2.19.2
