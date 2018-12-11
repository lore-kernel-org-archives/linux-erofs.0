From: bluce.liguifu@huawei.com (Li Guifu)
Date: Tue, 11 Dec 2018 22:27:18 +0800
Subject: [PREVIEW] [PATCH 2/5] erofs-mkfs: introduce mkfs basic framework
In-Reply-To: <20181211142721.24451-1-bluce.liguifu@huawei.com>
References: <20181211142721.24451-1-bluce.liguifu@huawei.com>
Message-ID: <20181211142721.24451-3-bluce.liguifu@huawei.com>

This patch adds basic code to generate erofs file systems and
empty images can be created properly.

Some parameters are also introduced in this patch, used for
setting the debugging level, whether to compress or not.

Signed-off-by: Li Guifu <bluce.liguifu at huawei.com>
Signed-off-by: Miao Xie <miaoxie at huawei.com>
Signed-off-by: Fang Wei <fangwei1 at huawei.com>
---
 erofs_config.c |  48 ++++++++++++++
 erofs_config.h |  44 +++++++++++++
 erofs_debug.h  |  80 +++++++++++++++++++++++
 erofs_error.h  |  25 +++++++
 erofs_io.c     | 172 +++++++++++++++++++++++++++++++++++++++++++++++++
 erofs_io.h     |  24 +++++++
 erofs_types.h  |  70 ++++++++++++++++++++
 list_head.h    | 109 +++++++++++++++++++++++++++++++
 mkfs_erofs.h   |  66 +++++++++++++++++++
 mkfs_main.c    | 161 +++++++++++++++++++++++++++++++++++++++++++++
 10 files changed, 799 insertions(+)
 create mode 100644 erofs_config.c
 create mode 100644 erofs_config.h
 create mode 100644 erofs_debug.h
 create mode 100644 erofs_error.h
 create mode 100644 erofs_io.c
 create mode 100644 erofs_io.h
 create mode 100644 erofs_types.h
 create mode 100644 list_head.h
 create mode 100644 mkfs_erofs.h
 create mode 100644 mkfs_main.c

diff --git a/erofs_config.c b/erofs_config.c
new file mode 100644
index 0000000..e77f7cd
--- /dev/null
+++ b/erofs_config.c
@@ -0,0 +1,48 @@
+// SPDX-License-Identifier: GPL-2.0+
+/*
+ * erofs_config.c
+ *
+ * Copyright (C) 2018 HUAWEI, Inc.
+ *             http://www.huawei.com/
+ * Created by Li Guifu <bluce.liguifu at huawei.com>
+ */
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include "erofs_config.h"
+#include "erofs_debug.h"
+
+struct erofs_configure erofs_cfg;
+
+void mkfs_init_configure(void)
+{
+	memset(&erofs_cfg, 0, sizeof(erofs_cfg));
+	erofs_cfg.c_alg_name = "none";
+	erofs_cfg.c_dbg_lvl  = 0;
+	erofs_cfg.c_version  = EROFS_MKFS_VERSION "   " __DATE__ " " __TIME__;
+}
+
+void mkfs_dump_config(void)
+{
+	const struct erofs_configure *c = &erofs_cfg;
+
+	erofs_dump("\tc_version:           [%8s]\n", c->c_version);
+	erofs_dump("\tc_img_path:          [%8s]\n", c->c_img_path);
+	erofs_dump("\tc_src_path:          [%8s]\n", c->c_src_path);
+	erofs_dump("\tc_dbg_lvl:           [%8d]\n", c->c_dbg_lvl);
+	erofs_dump("\tc_dry_run:           [%8d]\n", c->c_dry_run);
+	erofs_dump("\tc_alg_name:          [%8s]\n", c->c_alg_name);
+	erofs_dump("\tc_compr_maxsz:       [%8d]\n", c->c_compr_maxsz);
+	erofs_dump("\tc_compr_lvl:         [%8d]\n", c->c_compr_lvl);
+	erofs_dump("\tc_compr_boundary:    [%8d]\n", c->c_compr_boundary);
+	erofs_dump("\tc_compr_ratio_limit: [%8d]\n", c->c_compr_ratio_limit);
+}
+
+void mkfs_free_config(void)
+{
+	if (erofs_cfg.c_img_path)
+		free(erofs_cfg.c_img_path);
+
+	if (erofs_cfg.c_src_path)
+		free(erofs_cfg.c_src_path);
+}
diff --git a/erofs_config.h b/erofs_config.h
new file mode 100644
index 0000000..34b2dee
--- /dev/null
+++ b/erofs_config.h
@@ -0,0 +1,44 @@
+/* SPDX-License-Identifier: GPL-2.0+ */
+/*
+ * mkfs_config.h
+ *
+ * Copyright (C) 2018 HUAWEI, Inc.
+ *             http://www.huawei.com/
+ * Created by Li Guifu <bluce.liguifu at huawei.com>
+ */
+#ifndef __EROFS_CONFIG_H
+#define __EROFS_CONFIG_H
+
+/* workaround of a lz4 native compression issue, which can crash the program */
+/* #define EROFS_CONFIG_COMPR_MAX_SZ        (1024 * 1024) */
+#define EROFS_CONFIG_COMPR_MAX_SZ           (900  * 1024)
+#define EROFS_CONFIG_COMPR_MIN_SZ           (32   * 1024)
+#define EROFS_CONFIG_COMPR_DEF_BOUNDARY     (128)
+#define EROFS_CONFIG_COMPR_RATIO_MAX_LIMIT  (100)
+
+struct erofs_compr_alg;
+
+struct erofs_configure {
+	char        *c_version;
+	int         c_dry_run;
+	int         c_dbg_lvl;
+
+	struct erofs_compr_alg *c_compr_alg;
+	int         c_compr_maxsz;
+	int         c_compr_lvl;
+	int         c_compr_boundary;
+	int         c_compr_ratio_limit;
+
+	char        *c_src_path;
+	char        *c_img_path;
+	char        *c_label;
+	const char  *c_alg_name;
+};
+
+extern struct erofs_configure erofs_cfg;
+
+void mkfs_init_configure(void);
+void mkfs_dump_config(void);
+void mkfs_free_config(void);
+
+#endif
diff --git a/erofs_debug.h b/erofs_debug.h
new file mode 100644
index 0000000..89cc986
--- /dev/null
+++ b/erofs_debug.h
@@ -0,0 +1,80 @@
+/* SPDX-License-Identifier: GPL-2.0+ */
+/*
+ * erofs_debug.h
+ *
+ * Copyright (C) 2018 HUAWEI, Inc.
+ *             http://www.huawei.com/
+ * Created by Li Guifu <bluce.liguifu at huawei.com>
+ *
+ */
+#ifndef __EROFS_PRINT_H
+#define __EROFS_PRINT_H
+
+#include <stdio.h>
+#include <stdlib.h>
+#include <sys/time.h>
+#include <errno.h>
+#include <string.h>
+
+#include "erofs_config.h"
+#define FUNC_LINE_FMT "%s() Line[%d]"
+
+#ifdef DEBUG
+#define ASSERT(X) assert(x)
+#else
+#define ASSERT(X) ((void)0)
+#endif
+
+#ifndef pr_fmt
+#define pr_fmt(fmt) "EROFS: " FUNC_LINE_FMT fmt "\n"
+#endif
+
+#define erofs_dbg(fmt, ...)                                                    \
+	do {                                                                   \
+		if (erofs_cfg.c_dbg_lvl >= 7) {                                \
+			fprintf(stdout,                                        \
+				pr_fmt(fmt),                                   \
+				__func__,                                      \
+				__LINE__,                                      \
+				##__VA_ARGS__);                                \
+		}                                                              \
+	} while (0)
+
+#define erofs_info(fmt, ...)                                                   \
+	do {                                                                   \
+		if (erofs_cfg.c_dbg_lvl >= 3) {                                \
+			fprintf(stdout,                                        \
+				pr_fmt(fmt),                                   \
+				__func__,                                      \
+				__LINE__,                                      \
+				##__VA_ARGS__);                                \
+			fflush(stdout);                                        \
+		}                                                              \
+	} while (0)
+
+#define erofs_warn(fmt, ...)                                                   \
+	do {                                                                   \
+		if (erofs_cfg.c_dbg_lvl >= 2) {                                \
+			fprintf(stdout,                                        \
+				pr_fmt(fmt),                                   \
+				__func__,                                      \
+				__LINE__,                                      \
+				##__VA_ARGS__);                                \
+			fflush(stdout);                                        \
+		}                                                              \
+	} while (0)
+
+#define erofs_err(fmt, ...)                                                    \
+	do {                                                                   \
+		if (erofs_cfg.c_dbg_lvl >= 0) {                                \
+			fprintf(stderr,                                        \
+				"Err: " pr_fmt(fmt),                           \
+				__func__,                                      \
+				__LINE__,                                      \
+				##__VA_ARGS__);                                \
+		}                                                              \
+	} while (0)
+
+#define erofs_dump(fmt, ...) fprintf(stderr, fmt, ##__VA_ARGS__)
+
+#endif
diff --git a/erofs_error.h b/erofs_error.h
new file mode 100644
index 0000000..97693a2
--- /dev/null
+++ b/erofs_error.h
@@ -0,0 +1,25 @@
+/* SPDX-License-Identifier: GPL-2.0+ */
+/*
+ * erofs_error.h
+ *
+ * Copyright (C) 2018 HUAWEI, Inc.
+ *             http://www.huawei.com/
+ * Created by Li Guifu <bluce.liguifu at huawei.com>
+ */
+#ifndef __EROFS_ERROR_H
+#define __EROFS_ERROR_H
+
+#define MAX_ERRNO (4095)
+#define IS_ERR_VALUE(x)                                                        \
+	((unsigned long)(void *)(x) >= (unsigned long)-MAX_ERRNO)
+
+static inline void *ERR_PTR(long error)
+{
+	return (void *)error;
+}
+
+static inline int IS_ERR(const void *ptr)
+{
+	return IS_ERR_VALUE((unsigned long)ptr);
+}
+#endif
diff --git a/erofs_io.c b/erofs_io.c
new file mode 100644
index 0000000..8112ade
--- /dev/null
+++ b/erofs_io.c
@@ -0,0 +1,172 @@
+// SPDX-License-Identifier: GPL-2.0+
+/*
+ * erofs_io.c
+ *
+ * Copyright (C) 2018 HUAWEI, Inc.
+ *             http://www.huawei.com/
+ * Created by Li Guifu <bluce.liguifu at huawei.com>
+ */
+#define _LARGEFILE64_SOURCE
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <sys/types.h>
+#include <sys/stat.h>
+#include <unistd.h>
+#include <fcntl.h>
+#include <errno.h>
+
+#include "erofs_io.h"
+#include "mkfs_erofs.h"
+
+#define pr_fmt(fmt) "DEVICE IO: " FUNC_LINE_FMT fmt "\n"
+#include "erofs_debug.h"
+
+static char *erofs_devname;
+static int erofs_devfd = -1;
+static u64 erofs_devsz;
+
+void dev_close(void)
+{
+	close(erofs_devfd);
+	free(erofs_devname);
+	erofs_devname = NULL;
+	erofs_devfd   = -1;
+	erofs_devsz   = 0;
+}
+
+int dev_open(const char *devname)
+{
+	char *dev;
+	struct stat st;
+	int fd;
+	int ret;
+
+	dev = strdup(devname);
+	if (!dev)
+		return -ENOMEM;
+again:
+	fd = open(dev, O_RDWR);
+	if (fd < 0 && errno != ENOENT) {
+		erofs_err("Open device/file(%s) fail.", dev);
+		free(dev);
+		return -errno;
+	}
+
+	if (fd < 0) {
+		fd = open(dev, O_RDWR | O_CREAT | O_NOCTTY,
+			  S_IRUSR | S_IWUSR | S_IRGRP | S_IWGRP | S_IROTH);
+		if (fd < 0) {
+			if (errno != EEXIST) {
+				erofs_err("Create image file(%s) fail.", dev);
+				free(dev);
+				return -errno;
+			}
+
+			erofs_dbg("Image file(%s) existed, it might be created by the other users.",
+				  dev);
+			goto again;
+
+		}
+	}
+
+	ret = fstat(fd, &st);
+	if (ret) {
+		erofs_err("Get stat of device/file(%s) fail.", dev);
+		close(fd);
+		free(dev);
+		return -errno;
+	}
+
+	if (!S_ISBLK(st.st_mode) && !S_ISREG(st.st_mode)) {
+		erofs_err("File (%s) type is wrong.", dev);
+		close(fd);
+		free(dev);
+		return -EINVAL;
+	}
+
+	if (S_ISREG(st.st_mode)) {
+		ret = ftruncate(fd, 0);
+		if (ret) {
+			erofs_err("Truncate file(%s) fail.", dev);
+			close(fd);
+			free(dev);
+			return -errno;
+		}
+	}
+
+	erofs_devname = dev;
+	erofs_devfd   = fd;
+
+	if (S_ISBLK(st.st_mode)) {
+		erofs_devsz = st.st_size;
+	} else {
+		/* INT64_MAX is the limit of kernel vfs */
+		erofs_devsz = INT64_MAX;
+	}
+
+	erofs_devsz = round_down(erofs_devsz, EROFS_BLKSIZE);
+
+	erofs_info("Open device/file %s", erofs_devname);
+
+	return 0;
+}
+
+u64 dev_length(void)
+{
+	return erofs_devsz;
+}
+
+int dev_write(void *buf, u64 offset, size_t len)
+{
+	int ret;
+
+	if (erofs_cfg.c_dry_run)
+		return 0;
+
+	if (!buf) {
+		erofs_err("buf is NULL");
+		return -EINVAL;
+	}
+
+	if (offset >= erofs_devsz || len > erofs_devsz ||
+	    offset > erofs_devsz - len) {
+		erofs_err("Write posion[%" PRIu64 ", %zd] is too large beyond the end of device(%" PRIu64 ").",
+			  offset, len, erofs_devsz);
+		return -EINVAL;
+	}
+
+	ret = pwrite64(erofs_devfd, buf, len, (off64_t)offset);
+	if (ret != (int)len) {
+		if (ret < 0) {
+			erofs_err("Failed to write data into device - %s:[%" PRIu64 ", %zd].",
+				  erofs_devname, offset, len);
+			return -errno;
+		}
+
+		erofs_err("Writing data into device - %s:[%" PRIu64 ", %zd] - was truncated.",
+			  erofs_devname, offset, len);
+		return -ERANGE;
+	}
+	return 0;
+}
+
+int dev_write_block(void *buf, u32 blkaddr)
+{
+	erofs_info("Write data to block %u", blkaddr);
+
+	return dev_write(buf, ((off64_t)blkaddr) << EROFS_BLOCKSIZE_BITS,
+			 EROFS_BLKSIZE);
+}
+
+int dev_fsync(void)
+{
+	int ret;
+
+	ret = fsync(erofs_devfd);
+	if (ret) {
+		erofs_err("Could not fsync device!!!");
+		return -EIO;
+	}
+	return 0;
+}
diff --git a/erofs_io.h b/erofs_io.h
new file mode 100644
index 0000000..b447062
--- /dev/null
+++ b/erofs_io.h
@@ -0,0 +1,24 @@
+/* SPDX-License-Identifier: GPL-2.0+ */
+/*
+ * erofs_io.h
+ *
+ * Copyright (C) 2018 HUAWEI, Inc.
+ *             http://www.huawei.com/
+ * Created by Li Guifu <bluce.liguifu at huawei.com>
+ */
+#ifndef __EROFS_IO_H
+#define __EROFS_IO_H
+
+#include <sys/cdefs.h>
+#include "erofs_types.h"
+
+int dev_open(const char *devname);
+void dev_close(void);
+int dev_write(void *buf, u64 offset, size_t len);
+int dev_write_block(void *buf, u32 blkaddr);
+int dev_fsync(void);
+u64 dev_length(void);
+
+#endif
+
+
diff --git a/erofs_types.h b/erofs_types.h
new file mode 100644
index 0000000..11fa21b
--- /dev/null
+++ b/erofs_types.h
@@ -0,0 +1,70 @@
+/* SPDX-License-Identifier: GPL-2.0+ */
+/*
+ * erofs_types.h
+ *
+ * Copyright (C) 2018 HUAWEI, Inc.
+ *             http://www.huawei.com/
+ * Created by Li Guifu <bluce.liguifu at huawei.com>
+ */
+#ifndef __EROFS_TYPES_H
+#define __EROFS_TYPES_H
+#include <inttypes.h>
+#include <endian.h>
+#include <linux/types.h>
+#include <sys/types.h>
+#include <asm/types.h>
+#include <stdint.h>
+#include <sys/cdefs.h>
+#include <assert.h>
+#include <bits/byteswap.h>
+
+#define u8  uint8_t
+#define u16 uint16_t
+#define u32 uint32_t
+#define u64 uint64_t
+#define s8  int8_t
+#define s16 int16_t
+#define s32 int32_t
+#define s64 int64_t
+
+#if __BYTE_ORDER == __LITTLE_ENDIAN
+/*
+ * The host byte order is the same as network byte order,
+ * so these functions are all just identity.
+ */
+#define cpu_to_le16(x) ((__u16)(x))
+#define cpu_to_le32(x) ((__u32)(x))
+#define cpu_to_le64(x) ((__u64)(x))
+#define le16_to_cpu(x) ((__u16)(x))
+#define le32_to_cpu(x) ((__u32)(x))
+#define le64_to_cpu(x) ((__u64)(x))
+
+#else
+#if __BYTE_ORDER == __BIG_ENDIAN
+#define cpu_to_le16(x) (__builtin_bswap16(x))
+#define cpu_to_le32(x) (__builtin_bswap32(x))
+#define cpu_to_le64(x) (__builtin_bswap64(x))
+#define le16_to_cpu(x) (__builtin_bswap16(x))
+#define le32_to_cpu(x) (__builtin_bswap32(x))
+#define le64_to_cpu(x) (__builtin_bswap64(x))
+#else
+#pragma error
+#endif
+#endif
+
+#ifndef __OPTIMIZE__
+#define BUILD_BUG_ON(condition) ((void)sizeof(char[1 - 2 * !!(condition)]))
+#else
+#define BUILD_BUG_ON(condition) assert(condition)
+#endif
+
+#define BIT(nr)             (1UL << (nr))
+#define BIT_ULL(nr)         (1ULL << (nr))
+#define BIT_MASK(nr)        (1UL << ((nr) % BITS_PER_LONG))
+#define BIT_WORD(nr)        ((nr) / BITS_PER_LONG)
+#define BIT_ULL_MASK(nr)    (1ULL << ((nr) % BITS_PER_LONG_LONG))
+#define BIT_ULL_WORD(nr)    ((nr) / BITS_PER_LONG_LONG)
+#define BITS_PER_BYTE       8
+#define BITS_TO_LONGS(nr)   DIV_ROUND_UP(nr, BITS_PER_BYTE * sizeof(long))
+
+#endif
diff --git a/list_head.h b/list_head.h
new file mode 100644
index 0000000..adbf561
--- /dev/null
+++ b/list_head.h
@@ -0,0 +1,109 @@
+/* SPDX-License-Identifier: GPL-2.0+ */
+/*
+ * list_head.h
+ *
+ * Copyright (C) 2018 HUAWEI, Inc.
+ *             http://www.huawei.com/
+ * Created by Li Guifu <bluce.liguifu at huawei.com>
+ */
+#ifndef __CONFIG_LIST_H
+#define __CONFIG_LIST_H
+
+#include <assert.h>
+#include <stddef.h>
+
+struct list_head {
+	struct list_head *prev;
+	struct list_head *next;
+};
+
+#define container_of(ptr, type, member)                                        \
+	({                                                                     \
+		const typeof(((type *)0)->member) *__mptr = (ptr);             \
+		(type *)((char *)__mptr - offsetof(type, member));             \
+	})
+
+#define LIST_HEAD_INIT(name)                                                   \
+	{                                                                      \
+		&(name), &(name)                                               \
+	}
+
+#define LIST_HEAD(name) struct list_head name = LIST_HEAD_INIT(name)
+
+static inline void init_list_head(struct list_head *list)
+{
+	list->prev = list;
+	list->next = list;
+}
+
+static inline void __list_add(struct list_head *entry,
+			      struct list_head *prev,
+			      struct list_head *next)
+{
+	entry->prev = prev;
+	entry->next = next;
+	prev->next  = entry;
+	next->prev  = entry;
+}
+
+static inline void list_add(struct list_head *entry, struct list_head *head)
+{
+	__list_add(entry, head, head->next);
+}
+
+static inline void list_add_tail(struct list_head *entry,
+				 struct list_head *head)
+{
+	__list_add(entry, head->prev, head);
+}
+
+static inline void __list_del(struct list_head *prev, struct list_head *next)
+{
+	prev->next = next;
+	next->prev = prev;
+}
+
+static inline void list_del(struct list_head *entry)
+{
+	__list_del(entry->prev, entry->next);
+	entry->prev = entry->next = NULL;
+}
+
+static inline int list_empty(struct list_head *head)
+{
+	return head->next == head;
+}
+
+#define list_entry(ptr, type, member) container_of(ptr, type, member)
+
+#define list_first_entry(ptr, type, member)                                    \
+	list_entry((ptr)->next, type, member)
+
+#define list_next_entry(pos, member)                                           \
+	list_entry((pos)->member.next, typeof(*(pos)), member)
+
+#define list_prev_entry(pos, member)                                           \
+	list_entry((pos)->member.prev, typeof(*(pos)), member)
+
+#define list_for_each(pos, head)                                               \
+	for (pos = (head)->next; pos != (head); pos = pos->next)
+
+#define list_for_each_safe(pos, n, head)                                       \
+	for (pos = (head)->next, n = pos->next; pos != (head);                 \
+	     pos = n, n = pos->next)
+
+#define list_for_each_entry(pos, head, member)                                 \
+	for (pos = list_first_entry(head, typeof(*pos), member);               \
+	     &pos->member != (head);                                           \
+	     pos = list_next_entry(pos, member))
+
+#define list_for_each_entry_from(pos, head, member)                            \
+	for (; &pos->member != (head); pos = list_next_entry(pos, member))
+
+#define list_for_each_entry_safe(pos, n, head, member)                         \
+	for (pos = list_first_entry(head, typeof(*pos), member),               \
+	    n    = list_next_entry(pos, member);                               \
+	     &pos->member != (head);                                           \
+	     pos = n, n = list_next_entry(n, member))
+
+#endif
diff --git a/mkfs_erofs.h b/mkfs_erofs.h
new file mode 100644
index 0000000..be6305e
--- /dev/null
+++ b/mkfs_erofs.h
@@ -0,0 +1,66 @@
+/* SPDX-License-Identifier: GPL-2.0+ */
+/*
+ * mkfs_erofs.h
+ *
+ * Copyright (C) 2018 HUAWEI, Inc.
+ *             http://www.huawei.com/
+ * Created by Li Guifu <bluce.liguifu at huawei.com>
+ *
+ */
+#ifndef __EROFS_MKFS_H
+#define __EROFS_MKFS_H
+#include <linux/limits.h>
+#include "list_head.h"
+#include "erofs_types.h"
+
+typedef unsigned int __u32;
+
+#define __packed __attribute__((__packed__))
+
+#include "erofs_fs.h"
+
+#ifndef PAGE_SIZE
+#define PAGE_SIZE               (4096)
+#endif
+
+#ifndef EROFS_BLKSIZE
+#define EROFS_BLKSIZE           (4096)
+#define EROFS_BLOCKSIZE_BITS    (12)
+#endif
+
+#define EROFS_BLOCK_SIZE_SHIFT_BITS     (12)
+#define EROFS_SLOTSIZE_BITS             (5)
+#define EROFS_SLOTSIZE                  (32)
+#define MKFS_DIFF_SHIFT_8_BITS          (8)
+
+#define __round_mask(x, y)      ((__typeof__(x))((y)-1))
+#define round_up(x, y)          ((((x)-1) | __round_mask(x, y))+1)
+#define round_down(x, y)        ((x) & ~__round_mask(x, y))
+
+#define SIZE_ALIGN(val, size)   (((val) + (size) - 1) & (~(size-1)))
+#define SLOT_ALIGN(slots)       SIZE_ALIGN(slots, EROFS_SLOTSIZE)
+#define PAGE_ALIGN(pages)       SIZE_ALIGN(pages, PAGE_SIZE)
+#define BLK_ALIGN(blks)         SIZE_ALIGN(blks, EROFS_BLKSIZE)
+#define IS_SLOT_ALIGN(__ADDR)   (((__ADDR)%(EROFS_SLOTSIZE))?0:1)
+#define IS_BLK_ALIGN(__ADDR)    (((__ADDR)%(EROFS_BLKSIZE))?0:1)
+#define ADDR_TO_BLKNO(__ADDR)   ((__ADDR) >> EROFS_BLOCKSIZE_BITS)
+#define BLKNO_TO_ADDR(__ADDR)   ((u64)(__ADDR) << EROFS_BLOCKSIZE_BITS)
+#define MAX_NID_INDEX_PER_BLK   (EROFS_BLKSIZE / EROFS_SLOTSIZE)
+
+#define EROFS_INODE_V1_SIZE     sizeof(struct erofs_inode_v1)
+#define EROFS_INODE_V2_SIZE     sizeof(struct erofs_inode_v2)
+
+#define EROFS_DIRENT_SIZE       sizeof(struct erofs_dirent)
+
+#define EROFS_DECOMPR_IDX_SZ    sizeof(struct z_erofs_vle_decompressed_index)
+#define EROFS_DECOMPR_IDXS_PER_BLK  (EROFS_BLKSIZE / EROFS_DECOMPR_IDX_SZ)
+
+#define ondisk_extent_size(data_mapping_mode, count) \
+	((data_mapping_mode) == EROFS_INODE_LAYOUT_COMPRESSION ? \
+	(sizeof(struct erofs_extent_header) + \
+	sizeof(__u32) * le32_to_cpu(count)) : 0)
+
+#define EROFS_INLINE_GENERIC_ALIGN_SIZE     (4)
+#define EROFS_INLINE_INDEX_ALIGN_SIZE       (8)
+
+#endif
diff --git a/mkfs_main.c b/mkfs_main.c
new file mode 100644
index 0000000..c11c9b6
--- /dev/null
+++ b/mkfs_main.c
@@ -0,0 +1,161 @@
+// SPDX-License-Identifier: GPL-2.0+
+/*
+ * mkfs_main.c
+ *
+ * Copyright (C) 2018 HUAWEI, Inc.
+ *             http://www.huawei.com/
+ * Created by Li Guifu <bluce.liguifu at huawei.com>
+ */
+#include <stdio.h>
+#include <string.h>
+#include <sys/time.h>
+#include <time.h>
+#include <linux/fs.h>
+#include <unistd.h>
+#include <stdlib.h>
+#include <limits.h>
+#include <libgen.h>
+#include "mkfs_erofs.h"
+#include "erofs_io.h"
+#include "mkfs_inode.h"
+#include "erofs_compressor.h"
+#define pr_fmt(fmt) "MKFS: " FUNC_LINE_FMT fmt "\n"
+#include "erofs_debug.h"
+
+#define EROFS_SUPER_END (EROFS_SUPER_OFFSET + sizeof(struct erofs_super_block))
+#define ROOT_INODE_NUM                (0) /*always 0 match at rank inode */
+#define EROFS_META_BLK_ADDR_DEFAULT   (1)
+#define EROFS_XATTR_BLK_ADDR_DEFAULT  (0)
+
+static struct erofs_super_block erosb = {
+	.magic     = cpu_to_le32(EROFS_SUPER_MAGIC_V1),
+	.blkszbits = EROFS_BLOCK_SIZE_SHIFT_BITS,
+	.root_nid  = cpu_to_le16(ROOT_INODE_NUM),
+	.inos   = 0,
+	.blocks = 0,
+	.meta_blkaddr  = cpu_to_le32(EROFS_META_BLK_ADDR_DEFAULT),
+	.xattr_blkaddr = cpu_to_le32(EROFS_XATTR_BLK_ADDR_DEFAULT),
+
+};
+struct erofs_super_block *sb = &erosb;
+
+static void usage(char *path)
+{
+	fprintf(stderr, "%s %s\n", basename(path), erofs_cfg.c_version);
+	fprintf(stderr, "\nUsage:\n");
+	fprintf(stderr, "    [-z <compr_algri>] [-d <dbglvl>]\n");
+	fprintf(stderr, "    [target path] [source directory]\n");
+	exit(1);
+}
+
+u64 parse_num_from_str(const char *str)
+{
+	u64 num      = 0;
+	char *endptr = NULL;
+
+	num = strtoull(str, &endptr, 10);
+	ASSERT(num != ULLONG_MAX);
+	return num;
+}
+
+static void mkfs_parse_options_cfg(int argc, char *argv[])
+{
+	int opt;
+
+	while ((opt = getopt(argc, argv, "d:z::")) != -1) {
+		switch (opt) {
+		case 'z':
+			if (optarg)
+				erofs_cfg.c_alg_name = optarg;
+			else
+				erofs_cfg.c_alg_name = "lz4hc";
+			break;
+
+		case 'd':
+			erofs_cfg.c_dbg_lvl = parse_num_from_str(optarg);
+			break;
+
+		default: /* '?' */
+			usage(argv[0]);
+		}
+	}
+
+	if (optind >= argc)
+		usage(argv[0]);
+
+	erofs_cfg.c_img_path = strdup(argv[optind++]);
+	assert(erofs_cfg.c_img_path);
+
+	if (optind < argc) {
+		erofs_cfg.c_src_path = realpath(argv[optind++], NULL);
+		if (!erofs_cfg.c_src_path) {
+			perror("c_src_path realpath");
+			usage(argv[0]);
+		}
+	} else {
+		erofs_err("c_src_path is NULL");
+		usage(argv[0]);
+	}
+	assert(erofs_cfg.c_src_path);
+
+	if (optind < argc) {
+		erofs_err(" Unexpected argument: %s\n", argv[optind]);
+		usage(argv[0]);
+	}
+
+	mkfs_dump_config();
+
+	if (dev_open(erofs_cfg.c_img_path) < 0) {
+		erofs_err("dev_open is failed!!!");
+		usage(argv[0]);
+	}
+}
+
+void mkfs_update_erofs_header(u64 root_addr)
+{
+	int ret      = 0;
+	u64 size     = 0;
+	char *sb_buf = NULL;
+	struct timeval t;
+
+	size = BLK_ALIGN(EROFS_SUPER_END);
+
+	if (gettimeofday(&t, NULL) == 0) {
+		sb->build_time      = cpu_to_le64(t.tv_sec);
+		sb->build_time_nsec = cpu_to_le32(t.tv_usec);
+	}
+
+	sb->meta_blkaddr = cpu_to_le32(ADDR_TO_BLKNO(size));
+
+	sb_buf = calloc(size, 1);
+	if (!sb_buf) {
+		erofs_err("\tError: Failed to calloc [%s]!!!\n", strerror(errno));
+		exit(EXIT_FAILURE);
+	}
+
+	memcpy(sb_buf + EROFS_SUPER_OFFSET, sb, sizeof(*sb));
+
+	ret = dev_write(sb_buf, 0, size);
+	if (ret < 0) {
+		erofs_err("dev_write failed ret=%d", ret);
+		exit(EXIT_FAILURE);
+	}
+	free(sb_buf);
+}
+
+int main(int argc, char **argv)
+{
+	int err = 0;
+	struct erofs_node_info *proot_node = NULL;
+
+	mkfs_init_configure();
+	mkfs_parse_options_cfg(argc, argv);
+
+	mkfs_update_erofs_header(proot_node->i_base_addr);
+
+	dev_close();
+	mkfs_free_config();
+	erofs_info("done");
+
+	return err;
+}
-- 
2.17.1
