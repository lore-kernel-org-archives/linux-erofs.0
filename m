From: chao@kernel.org (Chao Yu)
Date: Tue,  3 Jul 2018 23:59:37 +0800
Subject: [PATCH v2 11/11] erofs: support tracepoint
Message-ID: <20180703155937.10549-1-chao@kernel.org>

From: Chao Yu <yuchao0@huawei.com>

Add tracepoints for ->readpage{,s}, ->lookup.

Reviewed-by: Gao Xiang <gaoxiang25 at huawei.com>
Signed-off-by: Chao Yu <yuchao0 at huawei.com>
---
v2: remove in-loop page defination.
 fs/erofs/data.c              |   8 ++++
 fs/erofs/namei.c             |   5 ++
 fs/erofs/super.c             |   2 +
 fs/erofs/unzip.c             |   6 +++
 include/trace/events/erofs.h | 109 +++++++++++++++++++++++++++++++++++++++++++
 5 files changed, 130 insertions(+)
 create mode 100644 include/trace/events/erofs.h

diff --git a/fs/erofs/data.c b/fs/erofs/data.c
index e76de71c85ff..401b79a6ecd9 100644
--- a/fs/erofs/data.c
+++ b/fs/erofs/data.c
@@ -13,6 +13,9 @@
 #include "internal.h"
 #include <linux/prefetch.h>
 
+#define CREATE_TRACE_POINTS
+#include <trace/events/erofs.h>
+
 #if (LINUX_VERSION_CODE < KERNEL_VERSION(4, 3, 0))
 static inline void read_endio(struct bio *bio, int err)
 #else
@@ -337,6 +340,8 @@ static int erofs_raw_access_readpage(struct file *file, struct page *page)
 	erofs_off_t last_block;
 	struct bio *bio;
 
+	trace_erofs_readpage(page, true);
+
 	bio = erofs_read_raw_page(NULL, page->mapping,
 		page, &last_block, 1, false);
 
@@ -354,6 +359,9 @@ static int erofs_raw_access_readpages(struct file *filp,
 	erofs_off_t last_block;
 	struct bio *bio = NULL;
 	gfp_t gfp = readahead_gfp_mask(mapping);
+	struct page *page = list_last_entry(pages, struct page, lru);
+
+	trace_erofs_readpages(mapping->host, page, nr_pages, true);
 
 	for (; nr_pages; --nr_pages) {
 		struct page *page = list_entry(pages->prev, struct page, lru);
diff --git a/fs/erofs/namei.c b/fs/erofs/namei.c
index e30294b279d1..b701d9ba52a6 100644
--- a/fs/erofs/namei.c
+++ b/fs/erofs/namei.c
@@ -10,9 +10,12 @@
  * License.  See the file COPYING in the main directory of the Linux
  * distribution for more details.
  */
+
 #include "internal.h"
 #include "xattr.h"
 
+#include <trace/events/erofs.h>
+
 /* based on the value of qn->len is accurate */
 static inline int dirnamecmp(struct qstr *qn,
 	struct qstr *qd, unsigned *matched)
@@ -209,6 +212,8 @@ struct dentry *erofs_lookup(struct inode *dir,
 	/* dentry must be unhashed in lookup, no need to worry about */
 	BUG_ON(!d_unhashed(dentry));
 
+	trace_erofs_lookup(dir, dentry, flags);
+
 	/* file name exceeds fs limit */
 	if (unlikely(dentry->d_name.len > EROFS_NAME_LEN))
 		return ERR_PTR(-ENAMETOOLONG);
diff --git a/fs/erofs/super.c b/fs/erofs/super.c
index d6046d4d787b..8b52f08fabe9 100644
--- a/fs/erofs/super.c
+++ b/fs/erofs/super.c
@@ -17,6 +17,8 @@
 #include <linux/parser.h>
 #include "internal.h"
 
+#define CREATE_TRACE_POINTS
+
 static struct kmem_cache *erofs_inode_cachep __read_mostly;
 
 static void init_once(void *ptr)
diff --git a/fs/erofs/unzip.c b/fs/erofs/unzip.c
index 66ee5579d2c3..58b3b2bf9e15 100644
--- a/fs/erofs/unzip.c
+++ b/fs/erofs/unzip.c
@@ -929,6 +929,8 @@ static int z_erofs_vle_normalaccess_readpage(struct file *file,
 	};
 	LIST_HEAD(pagepool);
 
+	trace_erofs_readpage(page, false);
+
 	int err = z_erofs_vle_do_read_page(page, &z_pvec,
 		&z_iter, &m_iter, &pagepool, &collector);
 
@@ -1027,6 +1029,10 @@ static int z_erofs_vle_normalaccess_readpages(
 	struct address_space *mapping,
 	struct list_head *pages, unsigned nr_pages)
 {
+	struct page *page = list_last_entry(pages, struct page, lru);
+
+	trace_erofs_readpages(mapping->host, page, nr_pages, false);
+
 	return __z_erofs_vle_normalaccess_readpages(filp,
 		mapping, pages, nr_pages,
 		nr_pages < 4 /* sync */);
diff --git a/include/trace/events/erofs.h b/include/trace/events/erofs.h
new file mode 100644
index 000000000000..54d38282ba6a
--- /dev/null
+++ b/include/trace/events/erofs.h
@@ -0,0 +1,109 @@
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
+#define show_dev_ino(entry)	show_dev(entry->dev), (unsigned long)entry->ino
+
+#define show_file_type(type)						\
+	__print_symbolic(type,						\
+		{ 0,		"FILE" },				\
+		{ 1,		"DIR" })
+
+TRACE_EVENT(erofs_lookup,
+
+	TP_PROTO(struct inode *dir, struct dentry *dentry, unsigned int flags),
+
+	TP_ARGS(dir, dentry, flags),
+
+	TP_STRUCT__entry(
+		__field(dev_t,	dev)
+		__field(ino_t,	ino)
+		__field(const char *,	name)
+		__field(unsigned int, flags)
+	),
+
+	TP_fast_assign(
+		__entry->dev	= dir->i_sb->s_dev;
+		__entry->ino	= dir->i_ino;
+		__entry->name	= dentry->d_name.name;
+		__entry->flags	= flags;
+	),
+
+	TP_printk("dev = (%d,%d), pino = %lu, name:%s, flags:%u",
+		show_dev_ino(__entry),
+		__entry->name,
+		__entry->flags)
+);
+
+TRACE_EVENT(erofs_readpage,
+
+	TP_PROTO(struct page *page, bool raw),
+
+	TP_ARGS(page, raw),
+
+	TP_STRUCT__entry(
+		__field(dev_t,	dev)
+		__field(ino_t,	ino)
+		__field(int, dir)
+		__field(pgoff_t, index)
+		__field(int, uptodate)
+		__field(bool, raw)
+	),
+
+	TP_fast_assign(
+		__entry->dev	= page->mapping->host->i_sb->s_dev;
+		__entry->ino	= page->mapping->host->i_ino;
+		__entry->dir	= S_ISDIR(page->mapping->host->i_mode);
+		__entry->index	= page->index;
+		__entry->uptodate = PageUptodate(page);
+		__entry->raw = raw;
+	),
+
+	TP_printk("dev = (%d,%d), ino = %lu, %s, index = %lu, uptodate = %d "
+		"raw = %d",
+		show_dev_ino(__entry),
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
+		__field(dev_t,	dev)
+		__field(ino_t,	ino)
+		__field(pgoff_t,	start)
+		__field(unsigned int,	nrpage)
+		__field(bool,		raw)
+	),
+
+	TP_fast_assign(
+		__entry->dev	= inode->i_sb->s_dev;
+		__entry->ino	= inode->i_ino;
+		__entry->start	= page->index;
+		__entry->nrpage	= nrpage;
+		__entry->raw	= raw;
+	),
+
+	TP_printk("dev = (%d,%d), ino = %lu, start = %lu nrpage = %u raw = %d",
+		show_dev_ino(__entry),
+		(unsigned long)__entry->start,
+		__entry->nrpage,
+		__entry->raw)
+);
+#endif /* _TRACE_EROFS_H */
+
+ /* This part must be outside protection */
+#include <trace/define_trace.h>
-- 
2.16.2.17.g38e79b1fd
