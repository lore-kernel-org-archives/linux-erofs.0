From: hsiangkao@aol.com (Gao Xiang)
Date: Mon, 24 Jun 2019 15:22:58 +0800
Subject: [PATCH v3 8/8] staging: erofs: integrate decompression inplace
In-Reply-To: <20190624072258.28362-1-hsiangkao@aol.com>
References: <20190624072258.28362-1-hsiangkao@aol.com>
Message-ID: <20190624072258.28362-9-hsiangkao@aol.com>

From: Gao Xiang <gaoxiang25@huawei.com>

Decompressor needs to know whether it's a partial
or full decompression since only full decompression
can be decompressed in-place.

On kirin980 platform, sequential read is finally
increased to 812MiB/s after decompression inplace
is enabled.

Reviewed-by: Chao Yu <yuchao0 at huawei.com>
Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>
---
 drivers/staging/erofs/internal.h  |  3 +++
 drivers/staging/erofs/unzip_vle.c | 15 +++++++++++----
 drivers/staging/erofs/unzip_vle.h |  1 +
 drivers/staging/erofs/zmap.c      |  1 +
 4 files changed, 16 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/erofs/internal.h b/drivers/staging/erofs/internal.h
index 6c8767d4a1d5..963cc1b8b896 100644
--- a/drivers/staging/erofs/internal.h
+++ b/drivers/staging/erofs/internal.h
@@ -441,6 +441,7 @@ extern const struct address_space_operations z_erofs_vle_normalaccess_aops;
  */
 enum {
 	BH_Zipped = BH_PrivateStart,
+	BH_FullMapped,
 };
 
 /* Has a disk mapping */
@@ -449,6 +450,8 @@ enum {
 #define EROFS_MAP_META		(1 << BH_Meta)
 /* The extent has been compressed */
 #define EROFS_MAP_ZIPPED	(1 << BH_Zipped)
+/* The length of extent is full */
+#define EROFS_MAP_FULL_MAPPED	(1 << BH_FullMapped)
 
 struct erofs_map_blocks {
 	erofs_off_t m_pa, m_la;
diff --git a/drivers/staging/erofs/unzip_vle.c b/drivers/staging/erofs/unzip_vle.c
index cb870b83f3c8..316382d33783 100644
--- a/drivers/staging/erofs/unzip_vle.c
+++ b/drivers/staging/erofs/unzip_vle.c
@@ -469,6 +469,9 @@ z_erofs_vle_work_register(const struct z_erofs_vle_work_finder *f,
 				    Z_EROFS_VLE_WORKGRP_FMT_LZ4 :
 				    Z_EROFS_VLE_WORKGRP_FMT_PLAIN);
 
+	if (map->m_flags & EROFS_MAP_FULL_MAPPED)
+		grp->flags |= Z_EROFS_VLE_WORKGRP_FULL_LENGTH;
+
 	/* new workgrps have been claimed as type 1 */
 	WRITE_ONCE(grp->next, *f->owned_head);
 	/* primary and followed work for all new workgrps */
@@ -901,7 +904,7 @@ static int z_erofs_vle_unzip(struct super_block *sb,
 	unsigned int i, outputsize;
 
 	enum z_erofs_page_type page_type;
-	bool overlapped;
+	bool overlapped, partial;
 	struct z_erofs_vle_work *work;
 	int err;
 
@@ -1009,10 +1012,13 @@ static int z_erofs_vle_unzip(struct super_block *sb,
 	if (unlikely(err))
 		goto out;
 
-	if (nr_pages << PAGE_SHIFT >= work->pageofs + grp->llen)
+	if (nr_pages << PAGE_SHIFT >= work->pageofs + grp->llen) {
 		outputsize = grp->llen;
-	else
+		partial = !(grp->flags & Z_EROFS_VLE_WORKGRP_FULL_LENGTH);
+	} else {
 		outputsize = (nr_pages << PAGE_SHIFT) - work->pageofs;
+		partial = true;
+	}
 
 	if (z_erofs_vle_workgrp_fmt(grp) == Z_EROFS_VLE_WORKGRP_FMT_PLAIN)
 		algorithm = Z_EROFS_COMPRESSION_SHIFTED;
@@ -1028,7 +1034,8 @@ static int z_erofs_vle_unzip(struct super_block *sb,
 					.outputsize = outputsize,
 					.alg = algorithm,
 					.inplace_io = overlapped,
-					.partial_decoding = true }, page_pool);
+					.partial_decoding = partial
+				 }, page_pool);
 
 out:
 	/* must handle all compressed pages before endding pages */
diff --git a/drivers/staging/erofs/unzip_vle.h b/drivers/staging/erofs/unzip_vle.h
index a2d9b60beebd..ab509d75aefd 100644
--- a/drivers/staging/erofs/unzip_vle.h
+++ b/drivers/staging/erofs/unzip_vle.h
@@ -46,6 +46,7 @@ struct z_erofs_vle_work {
 #define Z_EROFS_VLE_WORKGRP_FMT_PLAIN        0
 #define Z_EROFS_VLE_WORKGRP_FMT_LZ4          1
 #define Z_EROFS_VLE_WORKGRP_FMT_MASK         1
+#define Z_EROFS_VLE_WORKGRP_FULL_LENGTH      2
 
 typedef void *z_erofs_vle_owned_workgrp_t;
 
diff --git a/drivers/staging/erofs/zmap.c b/drivers/staging/erofs/zmap.c
index 1e75cef11db4..9c0bd65c46bf 100644
--- a/drivers/staging/erofs/zmap.c
+++ b/drivers/staging/erofs/zmap.c
@@ -424,6 +424,7 @@ int z_erofs_map_blocks_iter(struct inode *inode,
 			goto unmap_out;
 		}
 		end = (m.lcn << lclusterbits) | m.clusterofs;
+		map->m_flags |= EROFS_MAP_FULL_MAPPED;
 		m.delta[0] = 1;
 		/* fallthrough */
 	case Z_EROFS_VLE_CLUSTER_TYPE_NONHEAD:
-- 
2.17.1
