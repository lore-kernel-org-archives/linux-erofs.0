From: gaoxiang25@huawei.com (Gao Xiang)
Date: Wed, 31 Jul 2019 23:57:34 +0800
Subject: [PATCH v2 04/22] staging: erofs: keep up erofs_fs.h with
 erofs-outofstaging patchset
In-Reply-To: <20190731155752.210602-1-gaoxiang25@huawei.com>
References: <20190731155752.210602-1-gaoxiang25@huawei.com>
Message-ID: <20190731155752.210602-5-gaoxiang25@huawei.com>

The main change is to reserve all checksums except for superblock,
since it's more useful to do block-based verity for read-only fs.

Some comments change as well, which is minor.

Reviewed-by: Chao Yu <yuchao0 at huawei.com>
Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>
---
 drivers/staging/erofs/erofs_fs.h | 39 ++++++++++++++++----------------
 1 file changed, 19 insertions(+), 20 deletions(-)

diff --git a/drivers/staging/erofs/erofs_fs.h b/drivers/staging/erofs/erofs_fs.h
index 9cd749d56920..e82e833985e4 100644
--- a/drivers/staging/erofs/erofs_fs.h
+++ b/drivers/staging/erofs/erofs_fs.h
@@ -96,7 +96,7 @@ struct erofs_inode_v1 {
 /* 20 */__le32 i_ino;           /* only used for 32-bit stat compatibility */
 /* 24 */__le16 i_uid;
 /* 26 */__le16 i_gid;
-/* 28 */__le32 i_checksum;
+/* 28 */__le32 i_reserved2;
 } __packed;
 
 /* 32 bytes on-disk inode */
@@ -105,14 +105,14 @@ struct erofs_inode_v1 {
 #define EROFS_INODE_LAYOUT_V2   1
 
 struct erofs_inode_v2 {
-	__le16 i_advise;
+/*  0 */__le16 i_advise;
 
-	/* 1 header + n-1 * 4 bytes inline xattr to keep continuity */
-	__le16 i_xattr_icount;
-	__le16 i_mode;
-	__le16 i_reserved;      /* 8 bytes */
-	__le64 i_size;          /* 16 bytes */
-	union {
+/* 1 header + n-1 * 4 bytes inline xattr to keep continuity */
+/*  2 */__le16 i_xattr_icount;
+/*  4 */__le16 i_mode;
+/*  6 */__le16 i_reserved;
+/*  8 */__le64 i_size;
+/* 16 */union {
 		/* file total compressed blocks for data mapping 1 */
 		__le32 compressed_blocks;
 		__le32 raw_blkaddr;
@@ -122,16 +122,15 @@ struct erofs_inode_v2 {
 	} i_u __packed;
 
 	/* only used for 32-bit stat compatibility */
-	__le32 i_ino;           /* 24 bytes */
-
-	__le32 i_uid;
-	__le32 i_gid;
-	__le64 i_ctime;         /* 32 bytes */
-	__le32 i_ctime_nsec;
-	__le32 i_nlink;
-	__u8   i_reserved2[12];
-	__le32 i_checksum;      /* 64 bytes */
-} __packed;
+/* 20 */__le32 i_ino;
+
+/* 24 */__le32 i_uid;
+/* 28 */__le32 i_gid;
+/* 32 */__le64 i_ctime;
+/* 40 */__le32 i_ctime_nsec;
+/* 44 */__le32 i_nlink;
+/* 48 */__u8   i_reserved2[16];
+} __packed;                     /* 64 bytes */
 
 #define EROFS_MAX_SHARED_XATTRS         (128)
 /* h_shared_count between 129 ... 255 are special # */
@@ -149,9 +148,9 @@ struct erofs_inode_v2 {
  * for read-only fs, no need to introduce h_refcount
  */
 struct erofs_xattr_ibody_header {
-	__le32 h_checksum;
+	__le32 h_reserved;
 	__u8   h_shared_count;
-	__u8   h_reserved[7];
+	__u8   h_reserved2[7];
 	__le32 h_shared_xattrs[0];      /* shared xattr id array */
 } __packed;
 
-- 
2.17.1
