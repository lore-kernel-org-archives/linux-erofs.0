From: gaoxiang25@huawei.com (Gao Xiang)
Date: Wed, 14 Aug 2019 18:37:05 +0800
Subject: [PATCH v2 3/3] staging: erofs: correct all misused ENOTSUPP
In-Reply-To: <20190814103705.60698-1-gaoxiang25@huawei.com>
References: <20190814103705.60698-1-gaoxiang25@huawei.com>
Message-ID: <20190814103705.60698-3-gaoxiang25@huawei.com>

As Chao pointed out [1], ENOTSUPP is used for NFS
protocol only, we should use EOPNOTSUPP instead...

[1] https://lore.kernel.org/lkml/108ee2f9-75dd-b8ab-8da7-b81c17bafbf6 at huawei.com/

Reported-by: Chao Yu <yuchao0 at huawei.com>
Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>
---
 drivers/staging/erofs/decompressor.c | 2 +-
 drivers/staging/erofs/internal.h     | 6 +++---
 drivers/staging/erofs/xattr.c        | 2 +-
 drivers/staging/erofs/xattr.h        | 4 ++--
 drivers/staging/erofs/zmap.c         | 8 ++++----
 5 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/staging/erofs/decompressor.c b/drivers/staging/erofs/decompressor.c
index 5361a2bbedb6..32a811ac704a 100644
--- a/drivers/staging/erofs/decompressor.c
+++ b/drivers/staging/erofs/decompressor.c
@@ -124,7 +124,7 @@ static int lz4_decompress(struct z_erofs_decompress_req *rq, u8 *out)
 	int ret;
 
 	if (rq->inputsize > PAGE_SIZE)
-		return -ENOTSUPP;
+		return -EOPNOTSUPP;
 
 	src = kmap_atomic(*rq->in);
 	inputmargin = 0;
diff --git a/drivers/staging/erofs/internal.h b/drivers/staging/erofs/internal.h
index 12f737cbc0c0..0e8d58546c52 100644
--- a/drivers/staging/erofs/internal.h
+++ b/drivers/staging/erofs/internal.h
@@ -403,12 +403,12 @@ int z_erofs_map_blocks_iter(struct inode *inode,
 			    struct erofs_map_blocks *map,
 			    int flags);
 #else
-static inline int z_erofs_fill_inode(struct inode *inode) { return -ENOTSUPP; }
+static inline int z_erofs_fill_inode(struct inode *inode) { return -EOPNOTSUPP; }
 static inline int z_erofs_map_blocks_iter(struct inode *inode,
 					  struct erofs_map_blocks *map,
 					  int flags)
 {
-	return -ENOTSUPP;
+	return -EOPNOTSUPP;
 }
 #endif	/* !CONFIG_EROFS_FS_ZIP */
 
@@ -516,7 +516,7 @@ void *erofs_get_pcpubuf(unsigned int pagenr);
 #else
 static inline void *erofs_get_pcpubuf(unsigned int pagenr)
 {
-	return ERR_PTR(-ENOTSUPP);
+	return ERR_PTR(-EOPNOTSUPP);
 }
 
 #define erofs_put_pcpubuf(buf) do {} while (0)
diff --git a/drivers/staging/erofs/xattr.c b/drivers/staging/erofs/xattr.c
index c5bfc9be412f..e7e5840e3f9d 100644
--- a/drivers/staging/erofs/xattr.c
+++ b/drivers/staging/erofs/xattr.c
@@ -71,7 +71,7 @@ static int init_inode_xattrs(struct inode *inode)
 	if (vi->xattr_isize == sizeof(struct erofs_xattr_ibody_header)) {
 		errln("xattr_isize %d of nid %llu is not supported yet",
 		      vi->xattr_isize, vi->nid);
-		ret = -ENOTSUPP;
+		ret = -EOPNOTSUPP;
 		goto out_unlock;
 	} else if (vi->xattr_isize < sizeof(struct erofs_xattr_ibody_header)) {
 		if (unlikely(vi->xattr_isize)) {
diff --git a/drivers/staging/erofs/xattr.h b/drivers/staging/erofs/xattr.h
index 63cc87e3d3f4..e20249647541 100644
--- a/drivers/staging/erofs/xattr.h
+++ b/drivers/staging/erofs/xattr.h
@@ -74,13 +74,13 @@ static inline int erofs_getxattr(struct inode *inode, int index,
 				 const char *name, void *buffer,
 				 size_t buffer_size)
 {
-	return -ENOTSUPP;
+	return -EOPNOTSUPP;
 }
 
 static inline ssize_t erofs_listxattr(struct dentry *dentry,
 				      char *buffer, size_t buffer_size)
 {
-	return -ENOTSUPP;
+	return -EOPNOTSUPP;
 }
 #endif	/* !CONFIG_EROFS_FS_XATTR */
 
diff --git a/drivers/staging/erofs/zmap.c b/drivers/staging/erofs/zmap.c
index 5551e615e8ea..b61b9b5950ac 100644
--- a/drivers/staging/erofs/zmap.c
+++ b/drivers/staging/erofs/zmap.c
@@ -68,7 +68,7 @@ static int fill_inode_lazy(struct inode *inode)
 	if (vi->z_algorithmtype[0] >= Z_EROFS_COMPRESSION_MAX) {
 		errln("unknown compression format %u for nid %llu, please upgrade kernel",
 		      vi->z_algorithmtype[0], vi->nid);
-		err = -ENOTSUPP;
+		err = -EOPNOTSUPP;
 		goto unmap_done;
 	}
 
@@ -79,7 +79,7 @@ static int fill_inode_lazy(struct inode *inode)
 	if (vi->z_physical_clusterbits[0] != LOG_BLOCK_SIZE) {
 		errln("unsupported physical clusterbits %u for nid %llu, please upgrade kernel",
 		      vi->z_physical_clusterbits[0], vi->nid);
-		err = -ENOTSUPP;
+		err = -EOPNOTSUPP;
 		goto unmap_done;
 	}
 
@@ -211,7 +211,7 @@ static int unpack_compacted_index(struct z_erofs_maprecorder *m,
 	else if (1 << amortizedshift == 2 && lclusterbits == 12)
 		vcnt = 16;
 	else
-		return -ENOTSUPP;
+		return -EOPNOTSUPP;
 
 	encodebits = ((vcnt << amortizedshift) - sizeof(__le32)) * 8 / vcnt;
 	base = round_down(eofs, vcnt << amortizedshift);
@@ -275,7 +275,7 @@ static int compacted_load_cluster_from_disk(struct z_erofs_maprecorder *m,
 	int err;
 
 	if (lclusterbits != 12)
-		return -ENOTSUPP;
+		return -EOPNOTSUPP;
 
 	if (lcn >= totalidx)
 		return -EINVAL;
-- 
2.17.1
