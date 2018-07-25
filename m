From: gaoxiang25@huawei.com (Gao Xiang)
Date: Wed, 25 Jul 2018 10:26:28 +0800
Subject: [RFC PATCH v2 15/25] staging: erofs: add erofs_map_blocks_iter
In-Reply-To: <1532485598-63393-1-git-send-email-gaoxiang25@huawei.com>
References: <1532399805-65674-1-git-send-email-gaoxiang25@huawei.com>
 <1532485598-63393-1-git-send-email-gaoxiang25@huawei.com>
Message-ID: <1532485598-63393-16-git-send-email-gaoxiang25@huawei.com>

This patch introduces an iterable L2P mapping
operation 'erofs_map_blocks_iter'.
Compared with 'erofs_map_blocks', it avoids
a number of redundant 'release and regrab'
processes if they request the same meta page.

Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>
---
 drivers/staging/erofs/Kconfig     |  10 ++
 drivers/staging/erofs/Makefile    |   1 +
 drivers/staging/erofs/data.c      |  36 +++++-
 drivers/staging/erofs/internal.h  |  12 ++
 drivers/staging/erofs/unzip_vle.c | 236 ++++++++++++++++++++++++++++++++++++++
 5 files changed, 293 insertions(+), 2 deletions(-)
 create mode 100644 drivers/staging/erofs/unzip_vle.c

diff --git a/drivers/staging/erofs/Kconfig b/drivers/staging/erofs/Kconfig
index edda055..63bec70 100644
--- a/drivers/staging/erofs/Kconfig
+++ b/drivers/staging/erofs/Kconfig
@@ -77,3 +77,13 @@ config EROFS_FAULT_INJECTION
 	help
 	  Test EROFS to inject faults such as ENOMEM, EIO, and so on.
 	  If unsure, say N.
+
+config EROFS_FS_ZIP
+	bool "EROFS Data Compresssion Support"
+	depends on EROFS_FS
+	help
+	  Currently we support VLE Compression only.
+	  Play at your own risk.
+
+	  If you don't want to use compression feature, say N.
+
diff --git a/drivers/staging/erofs/Makefile b/drivers/staging/erofs/Makefile
index 977b7e0..8558c76 100644
--- a/drivers/staging/erofs/Makefile
+++ b/drivers/staging/erofs/Makefile
@@ -9,4 +9,5 @@ obj-$(CONFIG_EROFS_FS) += erofs.o
 ccflags-y += -I$(src)/include
 erofs-objs := super.o inode.o data.o namei.o dir.o
 erofs-$(CONFIG_EROFS_FS_XATTR) += xattr.o
+erofs-$(CONFIG_EROFS_FS_ZIP) += unzip_vle.o
 
diff --git a/drivers/staging/erofs/data.c b/drivers/staging/erofs/data.c
index a0f9d38..fd0dab8 100644
--- a/drivers/staging/erofs/data.c
+++ b/drivers/staging/erofs/data.c
@@ -157,12 +157,44 @@ static int erofs_map_blocks_flatmode(struct inode *inode,
 	return 0;
 }
 
+#ifdef CONFIG_EROFS_FS_ZIP
+extern int z_erofs_map_blocks_iter(struct inode *,
+	struct erofs_map_blocks *, struct page **, int);
+#endif
+
+int erofs_map_blocks_iter(struct inode *inode,
+	struct erofs_map_blocks *map,
+	struct page **mpage_ret, int flags)
+{
+	/* by default, reading raw data never use erofs_map_blocks_iter */
+	if (unlikely(!is_inode_layout_compression(inode))) {
+		if (*mpage_ret != NULL)
+			put_page(*mpage_ret);
+		*mpage_ret = NULL;
+
+		return erofs_map_blocks(inode, map, flags);
+	}
+
+#ifdef CONFIG_EROFS_FS_ZIP
+	return z_erofs_map_blocks_iter(inode, map, mpage_ret, flags);
+#else
+	/* data compression is not available */
+	return -ENOTSUPP;
+#endif
+}
+
 int erofs_map_blocks(struct inode *inode,
 	struct erofs_map_blocks *map, int flags)
 {
-	if (unlikely(is_inode_layout_compression(inode)))
-		return -ENOTSUPP;
+	if (unlikely(is_inode_layout_compression(inode))) {
+		struct page *mpage = NULL;
+		int err;
 
+		err = erofs_map_blocks_iter(inode, map, &mpage, flags);
+		if (mpage != NULL)
+			put_page(mpage);
+		return err;
+	}
 	return erofs_map_blocks_flatmode(inode, map, flags);
 }
 
diff --git a/drivers/staging/erofs/internal.h b/drivers/staging/erofs/internal.h
index ca22486..bea5ec4 100644
--- a/drivers/staging/erofs/internal.h
+++ b/drivers/staging/erofs/internal.h
@@ -72,6 +72,10 @@ struct erofs_sb_info {
 
 	/* inode slot unit size in bit shift */
 	unsigned char islotbits;
+#ifdef CONFIG_EROFS_FS_ZIP
+	/* cluster size in bit shift */
+	unsigned char clusterbits;
+#endif
 
 	u32 build_time_nsec;
 	u64 build_time;
@@ -284,6 +288,14 @@ struct erofs_map_blocks {
 extern struct page *erofs_get_meta_page(struct super_block *sb,
 	erofs_blk_t blkaddr, bool prio);
 extern int erofs_map_blocks(struct inode *, struct erofs_map_blocks *, int);
+extern int erofs_map_blocks_iter(struct inode *, struct erofs_map_blocks *,
+	struct page **, int);
+
+struct erofs_map_blocks_iter {
+	struct erofs_map_blocks map;
+	struct page *mpage;
+};
+
 
 static inline struct page *erofs_get_inline_page(struct inode *inode,
 	erofs_blk_t blkaddr)
diff --git a/drivers/staging/erofs/unzip_vle.c b/drivers/staging/erofs/unzip_vle.c
new file mode 100644
index 0000000..a9674a7
--- /dev/null
+++ b/drivers/staging/erofs/unzip_vle.c
@@ -0,0 +1,236 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * linux/drivers/staging/erofs/unzip_vle.c
+ *
+ * Copyright (C) 2018 HUAWEI, Inc.
+ *             http://www.huawei.com/
+ * Created by Gao Xiang <gaoxiang25 at huawei.com>
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License.  See the file COPYING in the main directory of the Linux
+ * distribution for more details.
+ */
+#include "internal.h"
+
+#define __vle_cluster_advise(x, bit, bits) \
+	((le16_to_cpu(x) >> (bit)) & ((1 << (bits)) - 1))
+
+#define __vle_cluster_type(advise) __vle_cluster_advise(advise, \
+	Z_EROFS_VLE_DI_CLUSTER_TYPE_BIT, Z_EROFS_VLE_DI_CLUSTER_TYPE_BITS)
+
+enum {
+	Z_EROFS_VLE_CLUSTER_TYPE_PLAIN,
+	Z_EROFS_VLE_CLUSTER_TYPE_HEAD,
+	Z_EROFS_VLE_CLUSTER_TYPE_NONHEAD,
+	Z_EROFS_VLE_CLUSTER_TYPE_RESERVED,
+	Z_EROFS_VLE_CLUSTER_TYPE_MAX
+};
+
+#define vle_cluster_type(di)	\
+	__vle_cluster_type((di)->di_advise)
+
+static inline unsigned
+vle_compressed_index_clusterofs(unsigned clustersize,
+	struct z_erofs_vle_decompressed_index *di)
+{
+	debugln("%s, vle=%pK, advise=%x (type %u), clusterofs=%x blkaddr=%x",
+		__func__, di, di->di_advise, vle_cluster_type(di),
+		di->di_clusterofs, di->di_u.blkaddr);
+
+	switch (vle_cluster_type(di)) {
+	case Z_EROFS_VLE_CLUSTER_TYPE_NONHEAD:
+		break;
+	case Z_EROFS_VLE_CLUSTER_TYPE_PLAIN:
+	case Z_EROFS_VLE_CLUSTER_TYPE_HEAD:
+		return di->di_clusterofs;
+	default:
+		BUG_ON(1);
+	}
+	return clustersize;
+}
+
+static inline erofs_blk_t
+vle_extent_blkaddr(struct inode *inode, pgoff_t index)
+{
+	struct erofs_sb_info *sbi = EROFS_I_SB(inode);
+	struct erofs_vnode *vi = EROFS_V(inode);
+
+	unsigned ofs = Z_EROFS_VLE_EXTENT_ALIGN(vi->inode_isize +
+		vi->xattr_isize) + sizeof(struct erofs_extent_header) +
+		index * sizeof(struct z_erofs_vle_decompressed_index);
+
+	return erofs_blknr(iloc(sbi, vi->nid) + ofs);
+}
+
+static inline unsigned int
+vle_extent_blkoff(struct inode *inode, pgoff_t index)
+{
+	struct erofs_sb_info *sbi = EROFS_I_SB(inode);
+	struct erofs_vnode *vi = EROFS_V(inode);
+
+	unsigned ofs = Z_EROFS_VLE_EXTENT_ALIGN(vi->inode_isize +
+		vi->xattr_isize) + sizeof(struct erofs_extent_header) +
+		index * sizeof(struct z_erofs_vle_decompressed_index);
+
+	return erofs_blkoff(iloc(sbi, vi->nid) + ofs);
+}
+
+/*
+ * Variable-sized Logical Extent (Fixed Physical Cluster) Compression Mode
+ * ---
+ * VLE compression mode attempts to compress a number of logical data into
+ * a physical cluster with a fixed size.
+ * VLE compression mode uses "struct z_erofs_vle_decompressed_index".
+ */
+static erofs_off_t vle_get_logical_extent_head(
+	struct inode *inode,
+	struct page **page_iter,
+	void **kaddr_iter,
+	unsigned lcn,	/* logical cluster number */
+	erofs_blk_t *pcn,
+	unsigned *flags)
+{
+	/* for extent meta */
+	struct page *page = *page_iter;
+	erofs_blk_t blkaddr = vle_extent_blkaddr(inode, lcn);
+	struct z_erofs_vle_decompressed_index *di;
+	unsigned long long ofs;
+	unsigned clustersize = 1 << EROFS_SB(inode->i_sb)->clusterbits;
+
+	if (page->index != blkaddr) {
+		kunmap_atomic(*kaddr_iter);
+		unlock_page(page);
+		put_page(page);
+
+		*page_iter = page = erofs_get_meta_page(inode->i_sb,
+			blkaddr, false);
+		*kaddr_iter = kmap_atomic(page);
+	}
+
+	di = *kaddr_iter + vle_extent_blkoff(inode, lcn);
+	switch (vle_cluster_type(di)) {
+	case Z_EROFS_VLE_CLUSTER_TYPE_NONHEAD:
+		BUG_ON(!di->di_u.delta[0]);
+		BUG_ON(lcn < di->di_u.delta[0]);
+
+		ofs = vle_get_logical_extent_head(inode,
+			page_iter, kaddr_iter,
+			lcn - di->di_u.delta[0], pcn, flags);
+		break;
+	case Z_EROFS_VLE_CLUSTER_TYPE_PLAIN:
+		*flags ^= EROFS_MAP_ZIPPED;
+	case Z_EROFS_VLE_CLUSTER_TYPE_HEAD:
+		ofs = (unsigned long long)lcn * clustersize +
+			(le16_to_cpu(di->di_clusterofs) & (clustersize - 1));
+		*pcn = le32_to_cpu(di->di_u.blkaddr);
+		break;
+	default:
+		BUG_ON(1);
+	}
+	return ofs;
+}
+
+int z_erofs_map_blocks_iter(struct inode *inode,
+	struct erofs_map_blocks *map,
+	struct page **mpage_ret, int flags)
+{
+	/* logicial extent (start, end) offset */
+	unsigned long long ofs, end;
+	struct z_erofs_vle_decompressed_index *di;
+	erofs_blk_t e_blkaddr, pcn;
+	unsigned lcn, logical_cluster_ofs;
+	struct page *mpage = *mpage_ret;
+	void *kaddr;
+	bool initial;
+	unsigned clustersize = 1 << EROFS_SB(inode->i_sb)->clusterbits;
+
+	/* if both m_(l,p)len are 0, regularize l_lblk, l_lofs, etc... */
+	initial = !map->m_llen;
+
+	/* when trying to read beyond EOF, leave it unmapped */
+	if (unlikely(map->m_la >= inode->i_size)) {
+		BUG_ON(!initial);
+		map->m_llen = map->m_la + 1 - inode->i_size;
+		map->m_la = inode->i_size - 1;
+		map->m_flags = 0;
+		goto out;
+	}
+
+	debugln("%s, m_la %llu m_llen %llu --- start", __func__,
+		map->m_la, map->m_llen);
+
+	ofs = map->m_la + map->m_llen;
+
+	lcn = ofs / clustersize;
+	e_blkaddr = vle_extent_blkaddr(inode, lcn);
+
+	if (mpage == NULL || mpage->index != e_blkaddr) {
+		if (mpage != NULL)
+			put_page(mpage);
+
+		mpage = erofs_get_meta_page(inode->i_sb, e_blkaddr, false);
+		*mpage_ret = mpage;
+	} else {
+		lock_page(mpage);
+		DBG_BUGON(!PageUptodate(mpage));
+	}
+
+	kaddr = kmap_atomic(mpage);
+	di = kaddr + vle_extent_blkoff(inode, lcn);
+
+	debugln("%s, lcn %u e_blkaddr %u e_blkoff %u", __func__, lcn,
+		e_blkaddr, vle_extent_blkoff(inode, lcn));
+
+	logical_cluster_ofs = vle_compressed_index_clusterofs(clustersize, di);
+	if (!initial) {
+		/* [walking mode] 'map' has been already initialized */
+		map->m_llen += logical_cluster_ofs;
+		goto unmap_out;
+	}
+
+	/* by default, compressed */
+	map->m_flags |= EROFS_MAP_ZIPPED;
+
+	end = (u64)(lcn + 1) * clustersize;
+
+	switch (vle_cluster_type(di)) {
+	case Z_EROFS_VLE_CLUSTER_TYPE_PLAIN:
+		if (ofs % clustersize >= logical_cluster_ofs)
+			map->m_flags ^= EROFS_MAP_ZIPPED;
+	case Z_EROFS_VLE_CLUSTER_TYPE_HEAD:
+		if (ofs % clustersize == logical_cluster_ofs) {
+			pcn = le32_to_cpu(di->di_u.blkaddr);
+			goto exact_hitted;
+		}
+
+		if (ofs % clustersize > logical_cluster_ofs) {
+			ofs = lcn * clustersize | logical_cluster_ofs;
+			pcn = le32_to_cpu(di->di_u.blkaddr);
+			break;
+		}
+
+		BUG_ON(!lcn);	/* logical cluster number >= 1 */
+		end = (lcn-- * clustersize) | logical_cluster_ofs;
+	case Z_EROFS_VLE_CLUSTER_TYPE_NONHEAD:
+		/* get the correspoinding first chunk */
+		ofs = vle_get_logical_extent_head(inode, mpage_ret,
+			&kaddr, lcn, &pcn, &map->m_flags);
+		mpage = *mpage_ret;
+	}
+
+	map->m_la = ofs;
+exact_hitted:
+	map->m_llen = end - ofs;
+	map->m_plen = clustersize;
+	map->m_pa = blknr_to_addr(pcn);
+	map->m_flags |= EROFS_MAP_MAPPED;
+unmap_out:
+	kunmap_atomic(kaddr);
+	unlock_page(mpage);
+out:
+	debugln("%s, m_la %llu m_pa %llu m_llen %llu m_plen %llu m_flags 0%o",
+		__func__, map->m_la, map->m_pa,
+		map->m_llen, map->m_plen, map->m_flags);
+	return 0;
+}
+
-- 
1.9.1
