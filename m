From: gaoxiang25@huawei.com (Gao Xiang)
Date: Fri, 18 Jan 2019 11:36:59 +0800
Subject: [PATCH 2/2] erofs-utils: rename to erofs_mkfs_update_super_block
In-Reply-To: <20190118033659.46760-1-gaoxiang25@huawei.com>
References: <20190118033659.46760-1-gaoxiang25@huawei.com>
Message-ID: <20190118033659.46760-2-gaoxiang25@huawei.com>

From: Li Guifu <blucerlee@gmail.com>

Since the old name `mkfs_update_erofs_header' is weird.

Signed-off-by: Li Guifu <blucerlee at gmail.com>
Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>
---
 mkfs/mkfs_erofs.h |  2 +-
 mkfs/mkfs_main.c  | 46 +++++++++++++++++++++++-----------------------
 2 files changed, 24 insertions(+), 24 deletions(-)

diff --git a/mkfs/mkfs_erofs.h b/mkfs/mkfs_erofs.h
index e8b6f1b..86d8da8 100644
--- a/mkfs/mkfs_erofs.h
+++ b/mkfs/mkfs_erofs.h
@@ -37,7 +37,7 @@ typedef unsigned int __u32;
 #define MAX_NID_INDEX_PER_BLK   (EROFS_BLKSIZE / EROFS_SLOTSIZE)
 
 typedef u64 erofs_off_t;
-
+typedef u64 erofs_nid_t;
 /* data type for filesystem-wide blocks number */
 typedef u32 erofs_blk_t;
 
diff --git a/mkfs/mkfs_main.c b/mkfs/mkfs_main.c
index 87a8346..4d72bf7 100644
--- a/mkfs/mkfs_main.c
+++ b/mkfs/mkfs_main.c
@@ -109,44 +109,43 @@ static void mkfs_parse_options_cfg(int argc, char *argv[])
 	mkfs_dump_config();
 }
 
-void mkfs_update_erofs_header(u64 root_addr)
+int erofs_mkfs_update_super_block(erofs_nid_t root_nid)
 {
-	int ret      = 0;
-	u64 size     = 0;
-	char *sb_buf = NULL;
+	int ret;
+	char *sb_buf;
 	struct timeval t;
+	const unsigned sb_blksize = BLK_ALIGN(EROFS_SUPER_END);
 
-	size = BLK_ALIGN(EROFS_SUPER_END);
-
-	if (gettimeofday(&t, NULL) == 0) {
+	if (!gettimeofday(&t, NULL)) {
 		sb->build_time      = cpu_to_le64(t.tv_sec);
 		sb->build_time_nsec = cpu_to_le32(t.tv_usec);
 	}
-
-	sb->meta_blkaddr = cpu_to_le32(erofs_blknr(size));
+	sb->meta_blkaddr = cpu_to_le32(erofs_blknr(sb_blksize));
 	sb->blocks       = cpu_to_le32(erofs_get_total_blocks());
-	sb->root_nid     = cpu_to_le16(mkfs_addr_to_nid(root_addr));
+	sb->root_nid     = cpu_to_le16(root_nid);
 
-	sb_buf = calloc(size, 1);
+	sb_buf = calloc(sb_blksize, 1);
 	if (!sb_buf) {
-		erofs_err("\tError: Failed to calloc [%s]!!!\n", strerror(errno));
-		exit(EXIT_FAILURE);
+		erofs_err("failed to allocate super buffer: %s", strerror(errno));
+		return -ENOMEM;
 	}
 
 	memcpy(sb_buf + EROFS_SUPER_OFFSET, sb, sizeof(*sb));
 
-	ret = dev_write(sb_buf, 0, size);
+	ret = dev_write(sb_buf, 0, sb_blksize);
 	if (ret < 0) {
-		erofs_err("dev_write failed ret=%d", ret);
-		exit(EXIT_FAILURE);
+		erofs_err("failed to dev_write, ret=%d", ret);
+		return -EIO;
 	}
 	free(sb_buf);
+	return 0;
 }
 
 int main(int argc, char **argv)
 {
 	int err = 0;
-	struct erofs_inode *proot_node = NULL;
+	struct erofs_inode *root_inode;
+	erofs_nid_t root_nid;
 
 	mkfs_init_configure();
 	mkfs_parse_options_cfg(argc, argv);
@@ -157,10 +156,10 @@ int main(int argc, char **argv)
 		return -1;
 	}
 
-	proot_node = mkfs_prepare_root_inode(erofs_cfg.c_src_path);
-	if (!proot_node)
+	root_inode = mkfs_prepare_root_inode(erofs_cfg.c_src_path);
+	if (!root_inode)
 		goto exit;
-	err = erofs_create_files_list(proot_node);
+	err = erofs_create_files_list(root_inode);
 	if (err)
 		goto exit;
 
@@ -168,11 +167,11 @@ int main(int argc, char **argv)
 	if (err)
 		goto exit;
 
-	err = mkfs_relocate_sub_inodes(proot_node);
+	err = mkfs_relocate_sub_inodes(root_inode);
 	if (err)
 		goto exit;
 
-	err = mkfs_do_write_inodes_data(proot_node);
+	err = mkfs_do_write_inodes_data(root_inode);
 	if (err)
 		goto exit;
 
@@ -180,7 +179,8 @@ int main(int argc, char **argv)
 	if (err)
 		goto exit;
 
-	mkfs_update_erofs_header(proot_node->i_base_addr);
+	root_nid = mkfs_addr_to_nid(root_inode->i_base_addr);
+	err = erofs_mkfs_update_super_block(root_nid);
 
 	erofs_info("done");
 
-- 
2.14.4
