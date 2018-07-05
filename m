From: gaoxiang25@huawei.com (Gao Xiang)
Date: Thu, 5 Jul 2018 16:41:20 +0800
Subject: [WIP] [NOMERGE] [RFC PATCH v0.5 03/10] erofs: add
 erofs_map_blocks_iter
In-Reply-To: <1530780087-76872-1-git-send-email-gaoxiang25@huawei.com>
References: <1530109204-7321-1-git-send-email-gaoxiang25@huawei.com>
 <1530780087-76872-1-git-send-email-gaoxiang25@huawei.com>
Message-ID: <1530780087-76872-4-git-send-email-gaoxiang25@huawei.com>

Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>
---
 fs/erofs/Kconfig     |  10 +++
 fs/erofs/Makefile    |   1 +
 fs/erofs/internal.h  |   4 +
 fs/erofs/unzip_vle.c | 231 +++++++++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 246 insertions(+)
 create mode 100644 fs/erofs/unzip_vle.c

diff --git a/fs/erofs/Kconfig b/fs/erofs/Kconfig
index 9c8696e..ffbd5eb 100644
--- a/fs/erofs/Kconfig
+++ b/fs/erofs/Kconfig
@@ -75,3 +75,13 @@ config EROFS_FAULT_INJECTION
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
diff --git a/fs/erofs/Makefile b/fs/erofs/Makefile
index 9d7f90a..0b3db0a 100644
--- a/fs/erofs/Makefile
+++ b/fs/erofs/Makefile
@@ -5,4 +5,5 @@ EXTRA_CFLAGS += -Wall -DEROFS_VERSION=\"$(EROFS_VERSION)\"
 obj-$(CONFIG_EROFS_FS) += erofs.o
 erofs-objs := super.o inode.o data.o namei.o dir.o
 erofs-$(CONFIG_EROFS_FS_XATTR) += xattr.o
+erofs-$(CONFIG_EROFS_FS_ZIP) += unzip_vle.o
 
diff --git a/fs/erofs/internal.h b/fs/erofs/internal.h
index e52252f..2377cf4 100644
--- a/fs/erofs/internal.h
+++ b/fs/erofs/internal.h
@@ -73,6 +73,10 @@ struct erofs_sb_info {
 
 	/* inode slot unit size in bit shift */
 	unsigned char islotbits;
+#ifdef CONFIG_EROFS_FS_ZIP
+	/* cluster size in bit shift */
+	unsigned char clusterbits;
+#endif
 
 	u32 build_time_nsec;
 	u64 build_time;
diff --git a/fs/erofs/unzip_vle.c b/fs/erofs/unzip_vle.c
new file mode 100644
index 0000000..300f556
--- /dev/null
+++ b/fs/erofs/unzip_vle.c
@@ -0,0 +1,231 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * linux/fs/erofs/unzip_vle.c
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
+	EROFS_VLE_DI_CLUSTER_TYPE_BIT, EROFS_VLE_DI_CLUSTER_TYPE_BITS)
+
+enum {
+	EROFS_VLE_CLUSTER_TYPE_PLAIN,
+	EROFS_VLE_CLUSTER_TYPE_HEAD,
+	EROFS_VLE_CLUSTER_TYPE_NONHEAD,
+	EROFS_VLE_CLUSTER_TYPE_RESERVED,
+	EROFS_VLE_CLUSTER_TYPE_MAX
+};
+
+#define vle_cluster_type(di)	\
+	__vle_cluster_type((di)->di_advise)
+
+static inline unsigned
+vle_compressed_index_clusterofs(unsigned clustersize,
+	struct erofs_decompressed_index_vle *di)
+{
+	debugln("%s, vle=%pK, advise=%x (type %u), clusterofs=%x blkaddr=%x",
+		__func__, di, di->di_advise, vle_cluster_type(di),
+		di->di_clusterofs, di->di_u.blkaddr);
+
+	switch(vle_cluster_type(di)) {
+	case EROFS_VLE_CLUSTER_TYPE_NONHEAD:
+		break;
+	case EROFS_VLE_CLUSTER_TYPE_PLAIN:
+	case EROFS_VLE_CLUSTER_TYPE_HEAD:
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
+	unsigned ofs = EROFS_VLE_EXTENT_ALIGN(vi->inode_isize +
+		vi->xattr_isize) + sizeof(struct erofs_extent_header) +
+		index * sizeof(struct erofs_decompressed_index_vle);
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
+	unsigned ofs = EROFS_VLE_EXTENT_ALIGN(vi->inode_isize +
+		vi->xattr_isize) + sizeof(struct erofs_extent_header) +
+		index * sizeof(struct erofs_decompressed_index_vle);
+
+	return erofs_blkoff(iloc(sbi, vi->nid) + ofs);
+}
+
+/*
+ * Variable-sized Logical Extent (Fixed Physical Cluster) Compression Mode
+ * ---
+ * VLE compression mode attempts to compress a number of logical data into
+ * a physical cluster with a fixed size.
+ * VLE compression mode uses "struct erofs_decompressed_index_vle".
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
+	struct erofs_decompressed_index_vle *di;
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
+	switch(vle_cluster_type(di)) {
+	case EROFS_VLE_CLUSTER_TYPE_NONHEAD:
+		BUG_ON(!di->di_u.delta[0]);
+		BUG_ON(lcn < di->di_u.delta[0]);
+
+		ofs = vle_get_logical_extent_head(inode,
+			page_iter, kaddr_iter,
+			lcn - di->di_u.delta[0], pcn, flags);
+		break;
+	case EROFS_VLE_CLUSTER_TYPE_PLAIN:
+		*flags ^= EROFS_MAP_ZIPPED;
+	case EROFS_VLE_CLUSTER_TYPE_HEAD:
+		ofs = lcn * clustersize +
+			(le16_to_cpu(di->di_clusterofs) & (clustersize - 1));
+		*pcn = le32_to_cpu(di->di_u.blkaddr);
+		break;
+	default:
+		BUG_ON(1);
+	}
+	return ofs;
+}
+
+int erofs_map_blocks_iter(struct inode *inode,
+	struct erofs_map_blocks *map,
+	struct page **mpage_ret, int flags)
+{
+	/* logicial extent (start, end) offset */
+	unsigned long long ofs, end;
+	struct erofs_decompressed_index_vle *di;
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
+	if (unlikely(map->m_la >= inode->i_size)) {
+		BUG_ON(!initial);
+		map->m_la = inode->i_size - 1;
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
+		/* m_(l,p)blk, m_(l,p)ofs has been already initialized */
+		map->m_llen += logical_cluster_ofs;
+		goto out;
+	}
+
+	/* by default, compressed */
+	map->m_flags |= EROFS_MAP_ZIPPED;
+
+	end = (u64)(lcn + 1) * clustersize;
+
+	switch(vle_cluster_type(di)) {
+	case EROFS_VLE_CLUSTER_TYPE_PLAIN:
+		if (ofs % clustersize >= logical_cluster_ofs)
+			map->m_flags ^= EROFS_MAP_ZIPPED;
+	case EROFS_VLE_CLUSTER_TYPE_HEAD:
+		if (ofs % clustersize == logical_cluster_ofs) {
+			pcn = le32_to_cpu(di->di_u.blkaddr);
+			goto unneed;
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
+	case EROFS_VLE_CLUSTER_TYPE_NONHEAD:
+		/* get the correspoinding first chunk */
+		ofs = vle_get_logical_extent_head(inode, mpage_ret,
+			&kaddr, lcn, &pcn, &map->m_flags);
+		mpage = *mpage_ret;
+	}
+
+	map->m_la = ofs;
+unneed:
+	map->m_llen = end - ofs;
+	map->m_plen = clustersize;
+	map->m_pa = blknr_to_addr(pcn);
+	map->m_flags |= EROFS_MAP_MAPPED;
+	debugln("%s, m_la %llu m_pa %llu m_llen %llu m_plen %llu m_flags %u",
+		__func__, map->m_la, map->m_pa,
+		map->m_llen, map->m_plen, map->m_flags);
+out:
+	kunmap_atomic(kaddr);
+	unlock_page(mpage);
+	return 0;
+}
+
-- 
1.9.1
