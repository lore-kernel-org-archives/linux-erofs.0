From: gaoxiang25@huawei.com (Gao Xiang)
Date: Fri, 18 Jan 2019 11:36:58 +0800
Subject: [PATCH 1/2] erofs-utils: rename erofs_node_info to erofs_inode
Message-ID: <20190118033659.46760-1-gaoxiang25@huawei.com>

From: Li Guifu <blucerlee@gmail.com>

In order to seperate erofs_dentry from it.

Signed-off-by: Li Guifu <blucerlee at gmail.com>
Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>
---
 mkfs/erofs_cache.c |  4 ++--
 mkfs/mkfs_file.c   | 36 ++++++++++++++++++------------------
 mkfs/mkfs_file.h   | 16 ++++++++--------
 mkfs/mkfs_inode.c  | 52 ++++++++++++++++++++++++++--------------------------
 mkfs/mkfs_inode.h  | 12 ++++++------
 mkfs/mkfs_main.c   |  2 +-
 6 files changed, 61 insertions(+), 61 deletions(-)

diff --git a/mkfs/erofs_cache.c b/mkfs/erofs_cache.c
index aecca98..573aa9c 100644
--- a/mkfs/erofs_cache.c
+++ b/mkfs/erofs_cache.c
@@ -137,7 +137,7 @@ int erofs_flush_all_blocks(void)
 {
 	struct block_buffer *blk;
 	struct erofs_meta_node *node;
-	struct erofs_node_info *inode;
+	struct erofs_inode *inode;
 	struct erofs_index_info *index;
 	char *erofs_blk_buf;
 	char *pbuf;
@@ -155,7 +155,7 @@ int erofs_flush_all_blocks(void)
 		list_for_each_entry(node, &blk->bb_metadata_list, m_node) {
 			switch (node->m_type) {
 			case EROFS_META_INODE:
-				inode = (struct erofs_node_info *)node;
+				inode = (struct erofs_inode *)node;
 
 				count = erofs_write_inode_buffer(inode, pbuf);
 				break;
diff --git a/mkfs/mkfs_file.c b/mkfs/mkfs_file.c
index 382e9b6..9cf7661 100644
--- a/mkfs/mkfs_file.c
+++ b/mkfs/mkfs_file.c
@@ -90,11 +90,11 @@ static inline u32 new_encode_dev(dev_t dev)
 	return (minor & 0xff) | (major << 8) | ((minor & ~0xff) << 12);
 }
 
-struct erofs_node_info *erofs_init_inode(char *full_path_name)
+struct erofs_inode *erofs_init_inode(char *full_path_name)
 {
 	int ret;
 	struct stat64 st;
-	struct erofs_node_info *inode = NULL;
+	struct erofs_inode *inode = NULL;
 	char *file_name		      = NULL;
 
 	file_name = strrchr(full_path_name, '/');
@@ -154,7 +154,7 @@ Err_alloc:
 	return NULL;
 }
 
-int erofs_create_files_list(struct erofs_node_info *inode)
+int erofs_create_files_list(struct erofs_inode *inode)
 {
 	int ret    = 0;
 	u64 d_size = 0;
@@ -163,7 +163,7 @@ int erofs_create_files_list(struct erofs_node_info *inode)
 	struct stat64 s;
 	struct dirent *dp;
 	struct list_head *pos;
-	struct erofs_node_info *dl;
+	struct erofs_inode *dl;
 
 	if (!strncmp(inode->i_name, "lost+found", strlen("lost+found")))
 		return 0;
@@ -221,8 +221,8 @@ int erofs_create_files_list(struct erofs_node_info *inode)
 	}
 
 	list_for_each(pos, &inode->i_subdir_head) {
-		struct erofs_node_info *d =
-			container_of(pos, struct erofs_node_info, i_list);
+		struct erofs_inode *d =
+			container_of(pos, struct erofs_inode, i_list);
 		if (((d_size & (EROFS_BLKSIZE - 1)) + EROFS_DIRENT_SIZE +
 		     strlen(d->i_name)) > EROFS_BLKSIZE) {
 			d_size = round_up(d_size, EROFS_BLKSIZE);
@@ -232,8 +232,8 @@ int erofs_create_files_list(struct erofs_node_info *inode)
 	inode->i_size = d_size;
 
 	list_for_each(pos, &inode->i_subdir_head) {
-		struct erofs_node_info *d =
-			container_of(pos, struct erofs_node_info, i_list);
+		struct erofs_inode *d =
+			container_of(pos, struct erofs_inode, i_list);
 		if (d->i_type == EROFS_FT_DIR) {
 			ret = erofs_create_files_list(d);
 			if (ret < 0)
@@ -247,7 +247,7 @@ error:
 	return ret;
 }
 
-int list_add_sort(struct list_head *head, struct erofs_node_info *inode)
+int list_add_sort(struct list_head *head, struct erofs_inode *inode)
 {
 	struct list_head *pos;
 
@@ -257,8 +257,8 @@ int list_add_sort(struct list_head *head, struct erofs_node_info *inode)
 	}
 
 	list_for_each(pos, head) {
-		struct erofs_node_info *d =
-			container_of(pos, struct erofs_node_info, i_list);
+		struct erofs_inode *d =
+			container_of(pos, struct erofs_inode, i_list);
 
 		if (strcmp(d->i_name, inode->i_name) <= 0)
 			continue;
@@ -271,9 +271,9 @@ int list_add_sort(struct list_head *head, struct erofs_node_info *inode)
 	return 0;
 }
 
-struct erofs_node_info *alloc_erofs_node(void)
+struct erofs_inode *alloc_erofs_node(void)
 {
-	struct erofs_node_info *f = calloc(sizeof(struct erofs_node_info), 1);
+	struct erofs_inode *f = calloc(sizeof(struct erofs_inode), 1);
 
 	if (!f) {
 		erofs_err("calloc failed!!!");
@@ -519,7 +519,7 @@ int erofs_write_compress_data(struct erofs_compr_ctx *cctx)
 	return 0;
 }
 
-int erofs_update_indexes(struct erofs_node_info *inode,
+int erofs_update_indexes(struct erofs_inode *inode,
 			 struct erofs_compr_ctx *cctx)
 {
 	u64 index = cctx->cc_pos / EROFS_BLKSIZE;
@@ -580,7 +580,7 @@ search_next_index_info:
 	return 0;
 }
 
-int erofs_compress_file(struct erofs_node_info *inode)
+int erofs_compress_file(struct erofs_inode *inode)
 {
 	int fd = -1;
 	size_t read_count;
@@ -764,7 +764,7 @@ close_file:
 	return ret;
 }
 
-int erofs_try_compress_file_once(struct erofs_node_info *inode,
+int erofs_try_compress_file_once(struct erofs_inode *inode,
 				 struct erofs_compr_info *cinfo,
 				 struct erofs_compr_ctx *cctx)
 {
@@ -838,7 +838,7 @@ close_file:
 	return ret;
 }
 
-static int erofs_get_node_compress_info(struct erofs_node_info *inode,
+static int erofs_get_node_compress_info(struct erofs_inode *inode,
 					struct erofs_compr_info *cinfo)
 {
 	/* Get specified compress algorithm which is set in the config file */
@@ -903,7 +903,7 @@ void erofs_reset_compress_context(struct erofs_compr_ctx *ctx)
 	       ctx->cc_buflen / EROFS_BLKSIZE * sizeof(struct erofs_compr_idx));
 }
 
-int erofs_check_compressible(struct erofs_node_info *inode)
+int erofs_check_compressible(struct erofs_inode *inode)
 {
 	struct erofs_compr_info cinfo;
 	struct erofs_compr_ctx ctx;
diff --git a/mkfs/mkfs_file.h b/mkfs/mkfs_file.h
index 852e92f..069a42d 100644
--- a/mkfs/mkfs_file.h
+++ b/mkfs/mkfs_file.h
@@ -62,16 +62,16 @@ struct erofs_compr_info {
 	int ci_lvl;
 };
 
-struct erofs_node_info;
+struct erofs_inode;
 
-struct erofs_node_info *alloc_erofs_node(void);
-struct erofs_node_info *erofs_init_inode(char *full_path_name);
-int list_add_sort(struct list_head *head, struct erofs_node_info *entry);
+struct erofs_inode *alloc_erofs_node(void);
+struct erofs_inode *erofs_init_inode(char *full_path_name);
+int list_add_sort(struct list_head *head, struct erofs_inode *entry);
 void dump_inode(struct erofs_inode_v1 *inode);
-int erofs_create_files_list(struct erofs_node_info *entry);
-u32 erofs_calc_inline_data_size(struct erofs_node_info *inode);
-int erofs_check_compressible(struct erofs_node_info *inode);
-int erofs_compress_file(struct erofs_node_info *inode);
+int erofs_create_files_list(struct erofs_inode *entry);
+u32 erofs_calc_inline_data_size(struct erofs_inode *inode);
+int erofs_check_compressible(struct erofs_inode *inode);
+int erofs_compress_file(struct erofs_inode *inode);
 void erofs_dump_compr_radio(void);
 int erofs_init_compress_context(struct erofs_compr_ctx *ctx);
 void erofs_deinit_compress_context(struct erofs_compr_ctx *ctx);
diff --git a/mkfs/mkfs_inode.c b/mkfs/mkfs_inode.c
index 86530c1..53599c5 100644
--- a/mkfs/mkfs_inode.c
+++ b/mkfs/mkfs_inode.c
@@ -33,7 +33,7 @@
 
 extern struct erofs_super_block *sb;
 
-u32 erofs_calc_inode_base_size(struct erofs_node_info *inode)
+u32 erofs_calc_inode_base_size(struct erofs_inode *inode)
 {
 	u32 size;
 
@@ -45,7 +45,7 @@ u32 erofs_calc_inode_base_size(struct erofs_node_info *inode)
 	return size;
 }
 
-u32 erofs_calc_inline_data_size(struct erofs_node_info *inode)
+u32 erofs_calc_inline_data_size(struct erofs_inode *inode)
 {
 	u32 size = erofs_calc_inode_base_size(inode);
 
@@ -55,12 +55,12 @@ u32 erofs_calc_inline_data_size(struct erofs_node_info *inode)
 		return (EROFS_BLKSIZE - size);
 }
 
-static inline u64 erofs_calc_compr_index_count(struct erofs_node_info *inode)
+static inline u64 erofs_calc_compr_index_count(struct erofs_inode *inode)
 {
 	return round_up(inode->i_size, EROFS_BLKSIZE) / EROFS_BLKSIZE;
 }
 
-static int erofs_calc_inline_compr_index_count(struct erofs_node_info *inode)
+static int erofs_calc_inline_compr_index_count(struct erofs_inode *inode)
 {
 	int size;
 
@@ -77,7 +77,7 @@ static int erofs_calc_inline_compr_index_count(struct erofs_node_info *inode)
 	return size / EROFS_DECOMPR_IDX_SZ;
 }
 
-u8 erofs_check_disk_inode_version(struct erofs_node_info *inode)
+u8 erofs_check_disk_inode_version(struct erofs_inode *inode)
 {
 #if 1
 	(void)inode;
@@ -95,7 +95,7 @@ u8 erofs_check_disk_inode_version(struct erofs_node_info *inode)
 #endif
 }
 
-static void erofs_init_compress_inode(struct erofs_node_info *inode)
+static void erofs_init_compress_inode(struct erofs_inode *inode)
 {
 	int inlined_nidxs;
 
@@ -122,7 +122,7 @@ static void erofs_init_compress_inode(struct erofs_node_info *inode)
 	inode->i_inline_align_size = EROFS_INLINE_INDEX_ALIGN_SIZE;
 }
 
-void mkfs_rank_inode(struct erofs_node_info *inode)
+void mkfs_rank_inode(struct erofs_inode *inode)
 {
 	block_buffer_t *blk;
 	block_buffer_t *next;
@@ -233,21 +233,21 @@ void mkfs_rank_inode(struct erofs_node_info *inode)
 	}
 }
 
-struct erofs_node_info *mkfs_prepare_root_inode(char *root)
+struct erofs_inode *mkfs_prepare_root_inode(char *root)
 {
 	if (!root)
 		return NULL;
 	return erofs_init_inode(root);
 }
 
-int mkfs_relocate_sub_inodes(struct erofs_node_info *inode)
+int mkfs_relocate_sub_inodes(struct erofs_inode *inode)
 {
 	int ret;
 	int compressible;
 	u32 blkaddr;
 	u32 nblocks;
 	u32 unaligned;
-	struct erofs_node_info *d = inode;
+	struct erofs_inode *d = inode;
 
 	switch (d->i_type) {
 	case EROFS_FT_REG_FILE:
@@ -327,8 +327,8 @@ static u32 write_dirents(char *buf, u32 sum, struct list_head *start,
 	base_nameoff = sum * EROFS_DIRENT_SIZE;
 	start_tmp    = start;
 	while (start_tmp != end) {
-		struct erofs_node_info *d =
-			container_of(start_tmp, struct erofs_node_info, i_list);
+		struct erofs_inode *d =
+			container_of(start_tmp, struct erofs_inode, i_list);
 		u32 name_len = strlen(d->i_name);
 
 		d->i_nameoff = base_nameoff;
@@ -339,8 +339,8 @@ static u32 write_dirents(char *buf, u32 sum, struct list_head *start,
 
 	start_tmp = start;
 	while (start_tmp != end) {
-		struct erofs_node_info *d =
-			container_of(start_tmp, struct erofs_node_info, i_list);
+		struct erofs_inode *d =
+			container_of(start_tmp, struct erofs_inode, i_list);
 		memset(&dirent, 0, EROFS_DIRENT_SIZE);
 
 		dirent.nid = cpu_to_le64(mkfs_addr_to_nid(d->i_base_addr));
@@ -354,7 +354,7 @@ static u32 write_dirents(char *buf, u32 sum, struct list_head *start,
 
 	return base_nameoff;
 }
-static int mkfs_write_inode_dir(struct erofs_node_info *inode)
+static int mkfs_write_inode_dir(struct erofs_inode *inode)
 {
 	struct list_head *pos;
 	struct list_head *start;
@@ -380,10 +380,10 @@ static int mkfs_write_inode_dir(struct erofs_node_info *inode)
 		}
 
 		list_for_each(pos, &inode->i_subdir_head) {
-			struct erofs_node_info *d;
+			struct erofs_inode *d;
 			u32 len;
 
-			d   = container_of(pos, struct erofs_node_info, i_list);
+			d   = container_of(pos, struct erofs_inode, i_list);
 			len = strlen(d->i_name);
 
 			if (dentrys_size + EROFS_DIRENT_SIZE + len >
@@ -432,10 +432,10 @@ static int mkfs_write_inode_dir(struct erofs_node_info *inode)
 		}
 
 		list_for_each(pos, &inode->i_subdir_head) {
-			struct erofs_node_info *d;
+			struct erofs_inode *d;
 			u32 len;
 
-			d   = container_of(pos, struct erofs_node_info, i_list);
+			d   = container_of(pos, struct erofs_inode, i_list);
 			len = strlen(d->i_name);
 			if (dentrys_size + EROFS_DIRENT_SIZE + len >
 			    EROFS_BLKSIZE) {
@@ -487,7 +487,7 @@ static int mkfs_write_inode_dir(struct erofs_node_info *inode)
 	return 0;
 }
 
-static int mkfs_write_inode_regfile(struct erofs_node_info *inode)
+static int mkfs_write_inode_regfile(struct erofs_inode *inode)
 {
 	char *pbuf     = NULL;
 	int ret	= 0;
@@ -620,7 +620,7 @@ static int mkfs_write_inode_regfile(struct erofs_node_info *inode)
 	return 0;
 }
 
-static int mkfs_write_inode_symfile(struct erofs_node_info *inode)
+static int mkfs_write_inode_symfile(struct erofs_inode *inode)
 {
 	char *pbuf = NULL;
 	int ret    = 0;
@@ -683,7 +683,7 @@ static int mkfs_write_inode_symfile(struct erofs_node_info *inode)
 	return 0;
 }
 
-int mkfs_do_write_inodes_data(struct erofs_node_info *inode)
+int mkfs_do_write_inodes_data(struct erofs_inode *inode)
 {
 	int ret;
 	struct list_head *pos;
@@ -714,9 +714,9 @@ int mkfs_do_write_inodes_data(struct erofs_node_info *inode)
 
 	if (!list_empty(&inode->i_subdir_head)) {
 		list_for_each(pos, &inode->i_subdir_head) {
-			struct erofs_node_info *d;
+			struct erofs_inode *d;
 
-			d   = container_of(pos, struct erofs_node_info, i_list);
+			d   = container_of(pos, struct erofs_inode, i_list);
 			ret = mkfs_do_write_inodes_data(d);
 			if (ret)
 				return ret;
@@ -726,7 +726,7 @@ int mkfs_do_write_inodes_data(struct erofs_node_info *inode)
 	return 0;
 }
 
-static int erofs_do_write_inode_buffer(struct erofs_node_info *inode, char *buf)
+static int erofs_do_write_inode_buffer(struct erofs_inode *inode, char *buf)
 {
 	struct erofs_inode_v1 *v1;
 	struct erofs_inode_v2 *v2;
@@ -801,7 +801,7 @@ static int erofs_do_write_inode_buffer(struct erofs_node_info *inode, char *buf)
 	return sizeof(*v2);
 }
 
-int erofs_write_inode_buffer(struct erofs_node_info *inode, char *buf)
+int erofs_write_inode_buffer(struct erofs_inode *inode, char *buf)
 {
 	char *pbuf = buf;
 	int count  = 0;
diff --git a/mkfs/mkfs_inode.h b/mkfs/mkfs_inode.h
index 8a9b81e..e83b335 100644
--- a/mkfs/mkfs_inode.h
+++ b/mkfs/mkfs_inode.h
@@ -28,7 +28,7 @@ struct erofs_index_info {
 	struct z_erofs_vle_decompressed_index i_idxs[0];
 };
 
-struct erofs_node_info {
+struct erofs_inode {
 	struct erofs_meta_node i_meta_node;
 
 	/* Original member */
@@ -72,12 +72,12 @@ struct erofs_node_info {
 	struct erofs_index_info *i_compr_cur_index_info;
 };
 
-struct erofs_node_info *mkfs_prepare_root_inode(char *root);
-int mkfs_relocate_sub_inodes(struct erofs_node_info *droot);
-int mkfs_do_write_inodes_data(struct erofs_node_info *droot);
+struct erofs_inode *mkfs_prepare_root_inode(char *root);
+int mkfs_relocate_sub_inodes(struct erofs_inode *droot);
+int mkfs_do_write_inodes_data(struct erofs_inode *droot);
 u64 mkfs_addr_to_nid(u64 addr);
-int erofs_write_inode_buffer(struct erofs_node_info *inode, char *buf);
+int erofs_write_inode_buffer(struct erofs_inode *inode, char *buf);
 int erofs_write_index_buffer(struct erofs_index_info *index, char *buf);
-u8 erofs_check_disk_inode_version(struct erofs_node_info *inode);
+u8 erofs_check_disk_inode_version(struct erofs_inode *inode);
 
 #endif
diff --git a/mkfs/mkfs_main.c b/mkfs/mkfs_main.c
index 30b0a22..87a8346 100644
--- a/mkfs/mkfs_main.c
+++ b/mkfs/mkfs_main.c
@@ -146,7 +146,7 @@ void mkfs_update_erofs_header(u64 root_addr)
 int main(int argc, char **argv)
 {
 	int err = 0;
-	struct erofs_node_info *proot_node = NULL;
+	struct erofs_inode *proot_node = NULL;
 
 	mkfs_init_configure();
 	mkfs_parse_options_cfg(argc, argv);
-- 
2.14.4
