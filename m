From: aaron.strahlberger@posteo.de (Aaron Strahlberger)
Date: Tue, 11 Dec 2018 11:54:42 +0100
Subject: [PATCH 4/5] drivers: staging: erofs: Fix parentheses error in macro
In-Reply-To: <20181211105443.21826-1-aaron.strahlberger@posteo.de>
References: <0ed9f3e7-9081-4a8a-06b0-e5ad14e2c872@huawei.com>
 <20181211105443.21826-1-aaron.strahlberger@posteo.de>
Message-ID: <20181211105443.21826-5-aaron.strahlberger@posteo.de>

Fix of ERROR: Macros with complex values should be enclosed in parentheses
from checkpatch.pl

Signed-off-by: Aaron Strahlberger <aaron.strahlberger at posteo.de>
Signed-off-by: Julius Wiedmann <julius.wiedmann at fau.de>
Signed-off-by: Dominik Huber <domi250 at gmx.de>
---
 drivers/staging/erofs/erofs_fs.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/erofs/erofs_fs.h b/drivers/staging/erofs/erofs_fs.h
index d4bffa2852b3..892c913960c3 100644
--- a/drivers/staging/erofs/erofs_fs.h
+++ b/drivers/staging/erofs/erofs_fs.h
@@ -38,9 +38,9 @@ struct erofs_super_block {
 /* 80 */__u8 reserved2[48];     /* 128 bytes */
 } __packed;
 
-#define __EROFS_BIT(_prefix, _cur, _pre)	enum {	\
+#define __EROFS_BIT(_prefix, _cur, _pre)	(enum { \
 	_prefix ## _cur ## _BIT = _prefix ## _pre ## _BIT + \
-		_prefix ## _pre ## _BITS }
+	_prefix ## _pre ## _BITS })
 
 /*
  * erofs inode data mapping:
-- 
2.19.2
