From: aaron.strahlberger@posteo.de (Aaron Strahlberger)
Date: Tue, 11 Dec 2018 11:54:43 +0100
Subject: [PATCH 5/5] drivers: staging: erofs: Add blank line after function
In-Reply-To: <20181211105443.21826-1-aaron.strahlberger@posteo.de>
References: <0ed9f3e7-9081-4a8a-06b0-e5ad14e2c872@huawei.com>
 <20181211105443.21826-1-aaron.strahlberger@posteo.de>
Message-ID: <20181211105443.21826-6-aaron.strahlberger@posteo.de>

Fix of checkpatch.pl issue:

CHECK: Please use a blank line after ... declarations

Signed-off-by: Aaron Strahlberger <aaron.strahlberger at posteo.de>
Signed-off-by: Julius Wiedmann <julius.wiedmann at fau.de>
Signed-off-by: Dominik Huber <domi250 at gmx.de>
---
 drivers/staging/erofs/erofs_fs.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/staging/erofs/erofs_fs.h b/drivers/staging/erofs/erofs_fs.h
index 892c913960c3..6a8c51d6ad61 100644
--- a/drivers/staging/erofs/erofs_fs.h
+++ b/drivers/staging/erofs/erofs_fs.h
@@ -58,6 +58,7 @@ enum {
 	EROFS_INODE_LAYOUT_INLINE,
 	EROFS_INODE_LAYOUT_MAX
 };
+
 #define EROFS_I_VERSION_BITS            1
 #define EROFS_I_DATA_MAPPING_BITS       3
 
-- 
2.19.2
