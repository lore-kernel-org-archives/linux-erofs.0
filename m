From: gaoxiang25@huawei.com (Gao Xiang)
Date: Tue, 13 Aug 2019 10:30:52 +0800
Subject: [PATCH 1/3] staging: erofs: inline erofs_inode_is_data_compressed()
Message-ID: <20190813023054.73126-1-gaoxiang25@huawei.com>

As a helper in erofs_fs.h, erofs_inode_is_data_compressed()
should be inlined.

Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>
---
 drivers/staging/erofs/erofs_fs.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/erofs/erofs_fs.h b/drivers/staging/erofs/erofs_fs.h
index e82e833985e4..8dc2a75e478f 100644
--- a/drivers/staging/erofs/erofs_fs.h
+++ b/drivers/staging/erofs/erofs_fs.h
@@ -62,7 +62,7 @@ enum {
 	EROFS_INODE_LAYOUT_MAX
 };
 
-static bool erofs_inode_is_data_compressed(unsigned int datamode)
+static inline bool erofs_inode_is_data_compressed(unsigned int datamode)
 {
 	if (datamode == EROFS_INODE_FLAT_COMPRESSION)
 		return true;
-- 
2.17.1
