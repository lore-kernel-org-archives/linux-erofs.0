From: gaoxiang25@huawei.com (Gao Xiang)
Date: Tue, 24 Jul 2018 10:36:33 +0800
Subject: [RFC PATCH 13/25] staging: erofs: support tracepoint
In-Reply-To: <1532399805-65674-1-git-send-email-gaoxiang25@huawei.com>
References: <1532399805-65674-1-git-send-email-gaoxiang25@huawei.com>
Message-ID: <1532399805-65674-14-git-send-email-gaoxiang25@huawei.com>

From: Chao Yu <yuchao0@huawei.com>

Add basic tracepoints for ->readpage{,s}, ->lookup,
->destroy_inode, fill_inode and map_blocks.

Reviewed-by: Gao Xiang <gaoxiang25 at huawei.com>
Signed-off-by: Chao Yu <yuchao0 at huawei.com>
---
 drivers/staging/erofs/data.c                       |  13 +-
 drivers/staging/erofs/include/trace/events/erofs.h | 240 +++++++++++++++++++++
 drivers/staging/erofs/inode.c                      |   4 +
 drivers/staging/erofs/namei.c                      |   4 +
 drivers/staging/erofs/super.c                      |   3 +
 5 files changed, 261 insertions(+), 3 deletions(-)
 create mode 100644 drivers/staging/erofs/include/trace/events/erofs.h

diff --git a/drivers/staging/erofs/data.c b/drivers/staging/erofs/data.c
index 29703b9..554ba49 100644
--- a/drivers/staging/erofs/data.c
+++ b/drivers/staging/erofs/data.c
@@ -13,6 +13,8 @@
 #include "internal.h"
 #include <linux/prefetch.h>
 
+#include <trace/events/erofs.h>
+
 #if (LINUX_VERSION_CODE < KERNEL_VERSION(4, 3, 0))
 static inline void read_endio(struct bio *bio, int err)
 #else
@@ -128,6 +130,7 @@ static int erofs_map_blocks_flatmode(struct inode *inode,
 	u64 offset = map->m_la;
 	struct erofs_vnode *vi = EROFS_V(inode);
 
+	trace_erofs_map_blocks_flatmode_enter(inode, map, flags);
 	BUG_ON(is_inode_layout_compression(inode));
 
 	nblocks = DIV_ROUND_UP(inode->i_size, PAGE_SIZE);
@@ -165,8 +168,7 @@ static int erofs_map_blocks_flatmode(struct inode *inode,
 
 out:
 	map->m_llen = map->m_plen;
-	debugln("%s, m_la 0x%llx m_pa %llx m_len %llu",
-		__func__, map->m_la, map->m_pa, map->m_plen);
+	trace_erofs_map_blocks_flatmode_exit(inode, map, flags, 0);
 	return 0;
 }
 
@@ -320,6 +322,8 @@ static int erofs_raw_access_readpage(struct file *file, struct page *page)
 	erofs_off_t last_block;
 	struct bio *bio;
 
+	trace_erofs_readpage(page, true);
+
 	bio = erofs_read_raw_page(NULL, page->mapping,
 		page, &last_block, 1, false);
 
@@ -337,9 +341,12 @@ static int erofs_raw_access_readpages(struct file *filp,
 	erofs_off_t last_block;
 	struct bio *bio = NULL;
 	gfp_t gfp = readahead_gfp_mask(mapping);
+	struct page *page = list_last_entry(pages, struct page, lru);
+
+	trace_erofs_readpages(mapping->host, page, nr_pages, true);
 
 	for (; nr_pages; --nr_pages) {
-		struct page *page = list_entry(pages->prev, struct page, lru);
+		page = list_entry(pages->prev, struct page, lru);
 
 		prefetchw(&page->flags);
 		list_del(&page->lru);
diff --git a/drivers/staging/erofs/include/trace/events/erofs.h b/drivers/staging/erofs/include/trace/events/erofs.h
new file mode 100644
index 0000000..5aead93
--- /dev/null
+++ b/drivers/staging/erofs/include/trace/events/erofs.h
@@ -0,0 +1,240 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM erofs
+
+#if !defined(_TRACE_EROFS_H) || defined(TRACE_HEADER_MULTI_READ)
+#define _TRACE_EROFS_H
+
+#include <linux/tracepoint.h>
+
+#define show_dev(dev)		MAJOR(dev), MINOR(dev)
+#define show_dev_nid(entry)	show_dev(entry->dev), entry->nid
+
+#define show_file_type(type)						\
+	__print_symbolic(type,						\
+		{ 0,		"FILE" },				\
+		{ 1,		"DIR" })
+
+#define show_map_flags(flags) __print_flags(flags, "|",	\
+	{ EROFS_GET_BLOCKS_RAW,	"RAW" })
+
+#define show_mflags(flags) __print_flags(flags, "",	\
+	{ EROFS_MAP_MAPPED,	"M" },			\
+	{ EROFS_MAP_META,	"I" },			\
+	{ EROFS_MAP_ZIPPED,	"Z" })
+
+TRACE_EVENT(erofs_lookup,
+
+	TP_PROTO(struct inode *dir, struct dentry *dentry, unsigned int flags),
+
+	TP_ARGS(dir, dentry, flags),
+
+	TP_STRUCT__entry(
+		__field(dev_t,		dev	)
+		__field(erofs_nid_t,	nid	)
+		__field(const char *,	name	)
+		__field(unsigned int,	flags	)
+	),
+
+	TP_fast_assign(
+		__entry->dev	= dir->i_sb->s_dev;
+		__entry->nid	= EROFS_V(dir)->nid;
+		__entry->name	= dentry->d_name.name;
+		__entry->flags	= flags;
+	),
+
+	TP_printk("dev = (%d,%d), pnid = %llu, name:%s, flags:%x",
+		show_dev_nid(__entry),
+		__entry->name,
+		__entry->flags)
+);
+
+TRACE_EVENT(erofs_fill_inode,
+	TP_PROTO(struct inode *inode, int isdir),
+	TP_ARGS(inode, isdir),
+
+	TP_STRUCT__entry(
+		__field(dev_t,		dev	)
+		__field(erofs_nid_t,	nid	)
+		__field(erofs_blk_t,	blkaddr )
+		__field(unsigned int,	ofs	)
+		__field(int,		isdir	)
+	),
+
+	TP_fast_assign(
+		__entry->dev		= inode->i_sb->s_dev;
+		__entry->nid		= EROFS_V(inode)->nid;
+		__entry->blkaddr	= erofs_blknr(iloc(EROFS_I_SB(inode), __entry->nid));
+		__entry->ofs		= erofs_blkoff(iloc(EROFS_I_SB(inode), __entry->nid));
+		__entry->isdir		= isdir;
+	),
+
+	TP_printk("dev = (%d,%d), nid = %llu, blkaddr %u ofs %u, isdir %d",
+		  show_dev_nid(__entry),
+		  __entry->blkaddr, __entry->ofs,
+		  __entry->isdir)
+);
+
+TRACE_EVENT(erofs_readpage,
+
+	TP_PROTO(struct page *page, bool raw),
+
+	TP_ARGS(page, raw),
+
+	TP_STRUCT__entry(
+		__field(dev_t,		dev	)
+		__field(erofs_nid_t,    nid     )
+		__field(int,		dir	)
+		__field(pgoff_t,	index	)
+		__field(int,		uptodate)
+		__field(bool,		raw	)
+	),
+
+	TP_fast_assign(
+		__entry->dev	= page->mapping->host->i_sb->s_dev;
+		__entry->nid	= EROFS_V(page->mapping->host)->nid;
+		__entry->dir	= S_ISDIR(page->mapping->host->i_mode);
+		__entry->index	= page->index;
+		__entry->uptodate = PageUptodate(page);
+		__entry->raw = raw;
+	),
+
+	TP_printk("dev = (%d,%d), nid = %llu, %s, index = %lu, uptodate = %d "
+		"raw = %d",
+		show_dev_nid(__entry),
+		show_file_type(__entry->dir),
+		(unsigned long)__entry->index,
+		__entry->uptodate,
+		__entry->raw)
+);
+
+TRACE_EVENT(erofs_readpages,
+
+	TP_PROTO(struct inode *inode, struct page *page, unsigned int nrpage,
+		bool raw),
+
+	TP_ARGS(inode, page, nrpage, raw),
+
+	TP_STRUCT__entry(
+		__field(dev_t,		dev	)
+		__field(erofs_nid_t,	nid	)
+		__field(pgoff_t,	start	)
+		__field(unsigned int,	nrpage	)
+		__field(bool,		raw	)
+	),
+
+	TP_fast_assign(
+		__entry->dev	= inode->i_sb->s_dev;
+		__entry->nid	= EROFS_V(inode)->nid;
+		__entry->start	= page->index;
+		__entry->nrpage	= nrpage;
+		__entry->raw	= raw;
+	),
+
+	TP_printk("dev = (%d,%d), nid = %llu, start = %lu nrpage = %u raw = %d",
+		show_dev_nid(__entry),
+		(unsigned long)__entry->start,
+		__entry->nrpage,
+		__entry->raw)
+);
+
+DECLARE_EVENT_CLASS(erofs__map_blocks_enter,
+	TP_PROTO(struct inode *inode, struct erofs_map_blocks *map,
+		 unsigned int flags),
+
+	TP_ARGS(inode, map, flags),
+
+	TP_STRUCT__entry(
+		__field(	dev_t,		dev		)
+		__field(	erofs_nid_t,	nid		)
+		__field(	erofs_off_t,	la		)
+		__field(	u64,		llen		)
+		__field(	unsigned int,	flags		)
+	),
+
+	TP_fast_assign(
+		__entry->dev    = inode->i_sb->s_dev;
+		__entry->nid    = EROFS_V(inode)->nid;
+		__entry->la	= map->m_la;
+		__entry->llen	= map->m_llen;
+		__entry->flags	= flags;
+	),
+
+	TP_printk("dev = (%d,%d), nid = %llu, la %llu llen %llu flags %s",
+		  show_dev_nid(__entry),
+		  __entry->la, __entry->llen, show_map_flags(__entry->flags))
+);
+
+DEFINE_EVENT(erofs__map_blocks_enter, erofs_map_blocks_flatmode_enter,
+	TP_PROTO(struct inode *inode, struct erofs_map_blocks *map,
+		 unsigned flags),
+
+	TP_ARGS(inode, map, flags)
+);
+
+DECLARE_EVENT_CLASS(erofs__map_blocks_exit,
+	TP_PROTO(struct inode *inode, struct erofs_map_blocks *map,
+		 unsigned int flags, int ret),
+
+	TP_ARGS(inode, map, flags, ret),
+
+	TP_STRUCT__entry(
+		__field(	dev_t,		dev		)
+		__field(	erofs_nid_t,	nid		)
+		__field(        unsigned int,   flags           )
+		__field(	erofs_off_t,	la		)
+		__field(	erofs_off_t,	pa		)
+		__field(	u64,		llen		)
+		__field(	u64,		plen		)
+		__field(        unsigned int,	mflags		)
+		__field(	int,		ret		)
+	),
+
+	TP_fast_assign(
+		__entry->dev    = inode->i_sb->s_dev;
+		__entry->nid    = EROFS_V(inode)->nid;
+		__entry->flags	= flags;
+		__entry->la	= map->m_la;
+		__entry->pa	= map->m_pa;
+		__entry->llen	= map->m_llen;
+		__entry->plen	= map->m_plen;
+		__entry->mflags	= map->m_flags;
+		__entry->ret	= ret;
+	),
+
+	TP_printk("dev = (%d,%d), nid = %llu, flags %s "
+		  "la %llu pa %llu llen %llu plen %llu mflags %s ret %d",
+		  show_dev_nid(__entry), show_map_flags(__entry->flags),
+		  __entry->la, __entry->pa, __entry->llen, __entry->plen,
+		  show_mflags(__entry->mflags), __entry->ret)
+);
+
+DEFINE_EVENT(erofs__map_blocks_exit, erofs_map_blocks_flatmode_exit,
+	TP_PROTO(struct inode *inode, struct erofs_map_blocks *map,
+		 unsigned flags, int ret),
+
+	TP_ARGS(inode, map, flags, ret)
+);
+
+TRACE_EVENT(erofs_destroy_inode,
+	TP_PROTO(struct inode *inode),
+
+	TP_ARGS(inode),
+
+	TP_STRUCT__entry(
+		__field(	dev_t,		dev		)
+		__field(	erofs_nid_t,	nid		)
+	),
+
+	TP_fast_assign(
+		__entry->dev	= inode->i_sb->s_dev;
+		__entry->nid	= EROFS_V(inode)->nid;
+	),
+
+	TP_printk("dev = (%d,%d), nid = %llu", show_dev_nid(__entry))
+);
+
+#endif /* _TRACE_EROFS_H */
+
+ /* This part must be outside protection */
+#include <trace/define_trace.h>
diff --git a/drivers/staging/erofs/inode.c b/drivers/staging/erofs/inode.c
index a26ca5a..001ddb9 100644
--- a/drivers/staging/erofs/inode.c
+++ b/drivers/staging/erofs/inode.c
@@ -12,6 +12,8 @@
  */
 #include "xattr.h"
 
+#include <trace/events/erofs.h>
+
 /* no locking */
 static int read_inode(struct inode *inode, void *data)
 {
@@ -156,6 +158,8 @@ int fill_inode(struct inode *inode, int isdir)
 	erofs_blk_t blkaddr;
 	unsigned ofs;
 
+	trace_erofs_fill_inode(inode, isdir);
+
 	blkaddr = erofs_blknr(iloc(sbi, vi->nid));
 	ofs = erofs_blkoff(iloc(sbi, vi->nid));
 
diff --git a/drivers/staging/erofs/namei.c b/drivers/staging/erofs/namei.c
index caaa60b..376bfec 100644
--- a/drivers/staging/erofs/namei.c
+++ b/drivers/staging/erofs/namei.c
@@ -13,6 +13,8 @@
 #include "internal.h"
 #include "xattr.h"
 
+#include <trace/events/erofs.h>
+
 /* based on the value of qn->len is accurate */
 static inline int dirnamecmp(struct qstr *qn,
 	struct qstr *qd, unsigned *matched)
@@ -209,6 +211,8 @@ struct dentry *erofs_lookup(struct inode *dir,
 	/* dentry must be unhashed in lookup, no need to worry about */
 	DBG_BUGON(!d_unhashed(dentry));
 
+	trace_erofs_lookup(dir, dentry, flags);
+
 	/* file name exceeds fs limit */
 	if (unlikely(dentry->d_name.len > EROFS_NAME_LEN))
 		return ERR_PTR(-ENAMETOOLONG);
diff --git a/drivers/staging/erofs/super.c b/drivers/staging/erofs/super.c
index aee83dd..9561bca 100644
--- a/drivers/staging/erofs/super.c
+++ b/drivers/staging/erofs/super.c
@@ -17,6 +17,9 @@
 #include <linux/seq_file.h>
 #include "internal.h"
 
+#define CREATE_TRACE_POINTS
+#include <trace/events/erofs.h>
+
 static struct kmem_cache *erofs_inode_cachep __read_mostly;
 
 static void init_once(void *ptr)
-- 
1.9.1
