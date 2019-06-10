From: gaoxiang25@huawei.com (Gao Xiang)
Date: Mon, 10 Jun 2019 17:36:39 +0800
Subject: [PATCH 1/2] staging: erofs: add requirements field in superblock
Message-ID: <20190610093640.96705-1-gaoxiang25@huawei.com>

There are some backward incompatible optimizations pending
for months, mainly due to on-disk format expensions.

However, we should ensure that it cannot be mounted with
old kernels. Otherwise, it will causes unexpected behaviors.

Fixes: ba2b77a82022 ("staging: erofs: add super block operations")
Cc: <stable at vger.kernel.org> # 4.19+
Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>
---
 drivers/staging/erofs/erofs_fs.h | 11 +++++++++--
 drivers/staging/erofs/super.c    |  8 ++++++++
 2 files changed, 17 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/erofs/erofs_fs.h b/drivers/staging/erofs/erofs_fs.h
index fa52898df006..531821757845 100644
--- a/drivers/staging/erofs/erofs_fs.h
+++ b/drivers/staging/erofs/erofs_fs.h
@@ -17,10 +17,16 @@
 #define EROFS_SUPER_MAGIC_V1    0xE0F5E1E2
 #define EROFS_SUPER_OFFSET      1024
 
+/*
+ * Any bits that aren't in EROFS_ALL_REQUIREMENTS should be
+ * incompatible with this kernel version.
+ */
+#define EROFS_ALL_REQUIREMENTS  0
+
 struct erofs_super_block {
 /*  0 */__le32 magic;           /* in the little endian */
 /*  4 */__le32 checksum;        /* crc32c(super_block) */
-/*  8 */__le32 features;
+/*  8 */__le32 features;        /* extra features for the image */
 /* 12 */__u8 blkszbits;         /* support block_size == PAGE_SIZE only */
 /* 13 */__u8 reserved;
 
@@ -34,8 +40,9 @@ struct erofs_super_block {
 /* 44 */__le32 xattr_blkaddr;
 /* 48 */__u8 uuid[16];          /* 128-bit uuid for volume */
 /* 64 */__u8 volume_name[16];   /* volume name */
+/* 80 */__le32 requirements;    /* all mandatory minimum requirements */
 
-/* 80 */__u8 reserved2[48];     /* 128 bytes */
+/* 84 */__u8 reserved2[44];     /* 128 bytes */
 } __packed;
 
 /*
diff --git a/drivers/staging/erofs/super.c b/drivers/staging/erofs/super.c
index f580d4ef77a1..815e5825db59 100644
--- a/drivers/staging/erofs/super.c
+++ b/drivers/staging/erofs/super.c
@@ -104,6 +104,14 @@ static int superblock_read(struct super_block *sb)
 		goto out;
 	}
 
+	/* check if the kernel meets all mandatory requirements */
+	if (le32_to_cpu(layout->requirements) & (~EROFS_ALL_REQUIREMENTS)) {
+		errln("too old to meet minimum requirements: %x supported: %x",
+		      le32_to_cpu(layout->requirements),
+		      EROFS_ALL_REQUIREMENTS);
+		goto out;
+	}
+
 	sbi->blocks = le32_to_cpu(layout->blocks);
 	sbi->meta_blkaddr = le32_to_cpu(layout->meta_blkaddr);
 #ifdef CONFIG_EROFS_FS_XATTR
-- 
2.17.1
