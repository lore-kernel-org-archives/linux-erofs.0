From: gaoxiang25@huawei.com (Gao Xiang)
Date: Thu, 21 Jun 2018 21:55:12 +0800
Subject: [erofs-dev] [RFC PATCH RESEND 08/12] erofs: definitions for the
 various kernel version temporarily
In-Reply-To: <1529589316-114929-1-git-send-email-gaoxiang25@huawei.com>
References: <1529588426-111662-1-git-send-email-gaoxiang25@huawei.com>
 <1529589316-114929-1-git-send-email-gaoxiang25@huawei.com>
Message-ID: <1529589316-114929-2-git-send-email-gaoxiang25@huawei.com>

the erofs file system is designed for 3.1x ~ latest kernel,
staging.h is introduced for compatibility.

This _should_ be avoided in the near future after we fork
the needed kernel version public trees.

Signed-off-by: Miao Xie <miaoxie at huawei.com>
Signed-off-by: Chao Yu <yuchao0 at huawei.com>
Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>
---
 fs/erofs/staging.h | 83 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 83 insertions(+)
 create mode 100644 fs/erofs/staging.h

diff --git a/fs/erofs/staging.h b/fs/erofs/staging.h
new file mode 100644
index 0000000..7712a7b
--- /dev/null
+++ b/fs/erofs/staging.h
@@ -0,0 +1,83 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+
+/* should be avoid in the future */
+#include <linux/version.h>
+
+#if (LINUX_VERSION_CODE < KERNEL_VERSION(3, 14, 31))
+__SETPAGEFLAG(Referenced, referenced)
+#endif
+
+#if (LINUX_VERSION_CODE < KERNEL_VERSION(3, 18, 0))
+#define d_inode(d) ((d)->d_inode)
+#endif
+
+#if (LINUX_VERSION_CODE < KERNEL_VERSION(4, 1, 0))
+#define d_really_is_negative(d) (d_inode(d) == NULL)
+#endif
+
+#if (LINUX_VERSION_CODE < KERNEL_VERSION(4, 4, 0))
+/* Restricts the given gfp_mask to what the mapping allows. */
+static inline gfp_t mapping_gfp_constraint(
+	struct address_space *mapping,
+	gfp_t gfp_mask)
+{
+	return mapping_gfp_mask(mapping) & gfp_mask;
+}
+#endif
+
+#if (LINUX_VERSION_CODE < KERNEL_VERSION(4, 4, 116))
+static inline void inode_nohighmem(struct inode *inode)
+{
+	mapping_set_gfp_mask(inode->i_mapping, GFP_USER);
+}
+#endif
+
+#if (LINUX_VERSION_CODE < KERNEL_VERSION(4, 8, 0))
+
+/* bio stuffs */
+#define REQ_OP_READ    READ
+#define REQ_OP_WRITE   WRITE
+#define bio_op(bio)    ((bio)->bi_rw & 1)
+
+static inline void bio_set_op_attrs(struct bio *bio,
+	unsigned op, unsigned op_flags) {
+	bio->bi_rw = op | op_flags;
+}
+
+static inline gfp_t readahead_gfp_mask(struct address_space *x)
+{
+	return mapping_gfp_mask(x) |  __GFP_COLD |
+	                              __GFP_NORETRY | __GFP_NOWARN;
+}
+#endif
+
+#if (LINUX_VERSION_CODE < KERNEL_VERSION(3, 18, 13))
+#define READ_ONCE(x)		ACCESS_ONCE(x)
+#define WRITE_ONCE(x, val)	(ACCESS_ONCE(x) = (val))
+#endif
+
+#if (LINUX_VERSION_CODE < KERNEL_VERSION(3, 18, 40))
+static inline int lockref_put_return(struct lockref *lockref)
+{
+	return -1;
+}
+#endif
+
+#ifndef WQ_NON_REENTRANT
+#define WQ_NON_REENTRANT 0
+#endif
+
+#if (LINUX_VERSION_CODE >= KERNEL_VERSION(4, 6, 0))
+#define page_cache_get(page)            get_page(page)
+#define page_cache_release(page)        put_page(page)
+#endif
+
+#if (LINUX_VERSION_CODE < KERNEL_VERSION(4, 14, 0))
+static inline bool sb_rdonly(const struct super_block *sb) {
+	return sb->s_flags & MS_RDONLY;
+}
+
+#define bio_set_dev(bio, bdev)	((bio)->bi_bdev = (bdev))
+
+#endif
+
-- 
1.9.1
