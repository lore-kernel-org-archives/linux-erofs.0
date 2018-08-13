From: hsiangkao@aol.com (Gao Xiang)
Date: Tue, 14 Aug 2018 03:41:46 +0800
Subject: [PREVIEW] [PATCH RESEND staging-next 5/8] staging: erofs: rearrange
 vle clustertype definitions
In-Reply-To: <1534189309-924-1-git-send-email-hsiangkao@aol.com>
References: <1534189309-924-1-git-send-email-hsiangkao@aol.com>
Message-ID: <1534189309-924-5-git-send-email-hsiangkao@aol.com>

From: Gao Xiang <gaoxiang25@huawei.com>

This patch moves vle clustertype definitions to erofs_fs.h
since they are part of on-disk format.

It also adds compile time check for Z_EROFS_VLE_DI_CLUSTER_TYPE_BITS

Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>
Reviewed-by: Chao Yu <yuchao0 at huawei.com>
Signed-off-by: Chao Yu <yuchao0 at huawei.com>
---
 drivers/staging/erofs/erofs_fs.h  | 11 +++++++++++
 drivers/staging/erofs/unzip_vle.c |  8 --------
 2 files changed, 11 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/erofs/erofs_fs.h b/drivers/staging/erofs/erofs_fs.h
index 2f8e2bf..d4bffa2 100644
--- a/drivers/staging/erofs/erofs_fs.h
+++ b/drivers/staging/erofs/erofs_fs.h
@@ -202,6 +202,14 @@ struct erofs_extent_header {
  *        di_u.delta[1] = distance to its corresponding tail cluster
  *                (di_advise could be 0, 1 or 2)
  */
+enum {
+	Z_EROFS_VLE_CLUSTER_TYPE_PLAIN,
+	Z_EROFS_VLE_CLUSTER_TYPE_HEAD,
+	Z_EROFS_VLE_CLUSTER_TYPE_NONHEAD,
+	Z_EROFS_VLE_CLUSTER_TYPE_RESERVED,
+	Z_EROFS_VLE_CLUSTER_TYPE_MAX
+};
+
 #define Z_EROFS_VLE_DI_CLUSTER_TYPE_BITS        2
 #define Z_EROFS_VLE_DI_CLUSTER_TYPE_BIT         0
 
@@ -260,6 +268,9 @@ static inline void erofs_check_ondisk_layout_definitions(void)
 	BUILD_BUG_ON(sizeof(struct erofs_extent_header) != 16);
 	BUILD_BUG_ON(sizeof(struct z_erofs_vle_decompressed_index) != 8);
 	BUILD_BUG_ON(sizeof(struct erofs_dirent) != 12);
+
+	BUILD_BUG_ON(BIT(Z_EROFS_VLE_DI_CLUSTER_TYPE_BITS) <
+		     Z_EROFS_VLE_CLUSTER_TYPE_MAX - 1);
 }
 
 #endif
diff --git a/drivers/staging/erofs/unzip_vle.c b/drivers/staging/erofs/unzip_vle.c
index 5032b3b..f597f07 100644
--- a/drivers/staging/erofs/unzip_vle.c
+++ b/drivers/staging/erofs/unzip_vle.c
@@ -1416,14 +1416,6 @@ const struct address_space_operations z_erofs_vle_normalaccess_aops = {
 #define __vle_cluster_type(advise) __vle_cluster_advise(advise, \
 	Z_EROFS_VLE_DI_CLUSTER_TYPE_BIT, Z_EROFS_VLE_DI_CLUSTER_TYPE_BITS)
 
-enum {
-	Z_EROFS_VLE_CLUSTER_TYPE_PLAIN,
-	Z_EROFS_VLE_CLUSTER_TYPE_HEAD,
-	Z_EROFS_VLE_CLUSTER_TYPE_NONHEAD,
-	Z_EROFS_VLE_CLUSTER_TYPE_RESERVED,
-	Z_EROFS_VLE_CLUSTER_TYPE_MAX
-};
-
 #define vle_cluster_type(di)	\
 	__vle_cluster_type((di)->di_advise)
 
-- 
2.7.4
