Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8269A606A320
	for <linux-erofs@archiver.kernel.org>; Sun, 22 Nov 2026 03:12:22 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4jXDdT2nkTz2yMl;
	Sun, 22 Nov 2026 14:12:13 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=159.226.251.21
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1795317133;
	cv=none; b=nRL5DGCWxPJGp0qLGEaQMxV8+LYkCYDOaopkhCwMF6+SbyJphVLTHA67P0XlZahbYqf3EqxSNw4M/1+b+/0dutXuTtxTmJY0bFushSodm3HeByX8jtbvPcOM1kfnOeD7WwUtnIC5U3ECE8BJiPRIdYP0othXcBUw2Yn3VrCaeVXKSdC9rbCWQxqGE1R/dVffKBT/yoZb4yDpPqZIhlqiqJvlyU91IpPEvXF9ZqX9pVMe7VxQsX33UKWOw67Efgz3o65+1bnLnWaUyVg0zSKOl+SnSYLjkWyPug/ig+JwAPFiZaxQ6q4L7GtS9WGNipvFMJlETRmHCrNMU7q8rY9luA==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1795317133; c=relaxed/relaxed;
	bh=XbTIAwp3EEPaKU6OZXBmIhBJ88glNIL4+8MAgDME9Rk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eFh5LIYYFUUwT/laovA5saHGWiN6akuomEoaR7cSl/EFEsnoZUu/VMUs6pZBg7mxv/UCc8ywQG9iZMkubqdLPXaC5gP6XqWImj/ZbQ4Sr6/n5/uKSNX/553Ci+Zdl1dE4lbpPhzE6FMJE6X+t9tB2CJ/5xXzdwaQmcLW11QACg0X0bzsRd9iGNmEslwzQq32qo99+zpYiLSanDk8jsoCmsxxRW7nk9hISd/OhcR3dvh1KAvnuyqqesIReBEumPce3QN/7A0Sf0HULB1IsJ0PHm1fBgpBfyEFtbvXA2Dn0aA7PyIk2kM6IizwDQpknX6VIcuNhjNYO1dA+NtQ2pcrGQ==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=none (p=none dis=none) header.from=mails.ucas.ac.cn; spf=pass (client-ip=159.226.251.21; helo=cstnet.cn; envelope-from=yanmengdie24@mails.ucas.ac.cn; receiver=lists.ozlabs.org) smtp.mailfrom=mails.ucas.ac.cn
Authentication-Results: lists.ozlabs.org; dmarc=none (p=none dis=none) header.from=mails.ucas.ac.cn
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=mails.ucas.ac.cn (client-ip=159.226.251.21; helo=cstnet.cn; envelope-from=yanmengdie24@mails.ucas.ac.cn; receiver=lists.ozlabs.org)
Received: from cstnet.cn (smtp21.cstnet.cn [159.226.251.21])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4jXDdL4R4Nz2xnn
	for <linux-erofs@lists.ozlabs.org>; Sun, 22 Nov 2026 14:12:05 +1100 (AEDT)
Received: from localhost.localdomain (unknown [36.110.52.2])
	by APP-01 (Coremail) with SMTP id qwCowAAnUvy6WwJrpQZzAQ--.19540S3;
	Sun, 22 Nov 2026 11:04:33 +0800 (CST)
From: Mengdie Yan <yanmengdie24@mails.ucas.ac.cn>
To: linux-erofs@lists.ozlabs.org
Cc: Mengdie Yan <yanmengdie24@mails.ucas.ac.cn>,
	Gao Xiang <xiang@kernel.org>,
	Chengyu Zhu <hudsonzhu@tencent.com>
Subject: [PATCH 1/4] erofs-utils: mkfs: prioritize hot files in directory sources
Date: Sun, 22 Nov 2026 11:04:20 +0800
Message-ID: <3e11093451131ec715f28ce5459c13a85c7d0852.1795283997.git.yanmengdie24@mails.ucas.ac.cn>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <cover.1795283997.git.yanmengdie24@mails.ucas.ac.cn>
References: <cover.1795283997.git.yanmengdie24@mails.ucas.ac.cn>
X-Mailing-List: linux-erofs@lists.ozlabs.org
List-Id: <linux-erofs.lists.ozlabs.org>
List-Help: <mailto:linux-erofs+help@lists.ozlabs.org>
List-Owner: <mailto:linux-erofs+owner@lists.ozlabs.org>
List-Post: <mailto:linux-erofs@lists.ozlabs.org>
List-Subscribe: <mailto:linux-erofs+subscribe@lists.ozlabs.org>,
  <mailto:linux-erofs+subscribe-digest@lists.ozlabs.org>,
  <mailto:linux-erofs+subscribe-nomail@lists.ozlabs.org>
Precedence: list
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qwCowAAnUvy6WwJrpQZzAQ--.19540S3
X-Coremail-Antispam: 1UD129KBjvAXoWfArW3CFWrWr1xtrW5CrWxJFb_yoW5Aw18Co
	WxZanxWw1FgF15JF4UCF17Xa4xu398Cw1xCrZxCrWqgF9rWr15G3s7W3WYq34fXr4rKrWf
	A3s7ZasxJFW8tr1rn29KB7ZKAUJUUUU8529EdanIXcx71UUUUU7v73VFW2AGmfu7bjvjm3
	AaLaJ3UjIYCTnIWjp_UUUYR7AC8VAFwI0_Gr0_Xr1l1xkIjI8I6I8E6xAIw20EY4v20xva
	j40_Wr0E3s1l1IIY67AEw4v_Jr0_Jr4l82xGYIkIc2x26280x7IE14v26r18M28IrcIa0x
	kI8VCY1x0267AKxVWUXVWUCwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK021l84AC
	jcxK6xIIjxv20xvE14v26ryj6F1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4j6F4UM2
	8EF7xvwVC2z280aVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gr1j6F4U
	JwAac4AC62xK8xCEY4vEwIxC4wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0V
	AKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWUtVWrXwAv7VC2z280aVAFwI0_Gr1j6F4U
	JwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI20V
	AGYxC7MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAF
	wI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUAVWUtwCIc4
	0Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AK
	xVWUJVW8JwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr
	1lIxAIcVC2z280aVCY1x0267AKxVWUJVW8JbIYCTnIWIevJa73UjIFyTuYvjfUOKZXUUUU
	U
X-CM-SenderInfo: 51dqzv5qjgxvysu6ztxlovh3xfdvhtffof0/
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Add an ordered hot-file list for uncompressed directory builds. Resolve
paths inside the image root and aggregate the earliest rank across
hardlinks before scheduling hot files and their path metadata.

Keep the earliest descendant rank when a directory is also listed
directly. Reuse the common directory traversal while preserving the
relative order of unlisted cold files, link counts and complete directory
extents. Reject incremental builds because existing allocations cannot
satisfy this ordering contract. Document the file-level layout guarantees.

Signed-off-by: Mengdie Yan <yanmengdie24@mails.ucas.ac.cn>
---
 include/erofs/hotfile.h  |  22 ++
 include/erofs/internal.h |  11 +
 lib/Makefile.am          |   2 +
 lib/hotfile.c            | 532 +++++++++++++++++++++++++++++++++++++++
 lib/inode.c              | 202 ++++++++++++++-
 man/mkfs.erofs.1         |  20 ++
 mkfs/main.c              |  39 +++
 7 files changed, 821 insertions(+), 7 deletions(-)
 create mode 100644 include/erofs/hotfile.h
 create mode 100644 lib/hotfile.c

diff --git a/include/erofs/hotfile.h b/include/erofs/hotfile.h
new file mode 100644
index 0000000..3fcdc1a
--- /dev/null
+++ b/include/erofs/hotfile.h
@@ -0,0 +1,22 @@
+/* SPDX-License-Identifier: GPL-2.0+ OR MIT */
+#ifndef __EROFS_HOTFILE_H
+#define __EROFS_HOTFILE_H
+
+#ifdef __cplusplus
+extern "C"
+{
+#endif
+
+#include "defs.h"
+
+int erofs_hotfile_load(const char *path);
+void erofs_hotfile_exit(void);
+bool erofs_hotfile_enabled(void);
+
+unsigned int erofs_hotfile_rank(const char *path, bool isdir);
+
+#ifdef __cplusplus
+}
+#endif
+
+#endif
diff --git a/include/erofs/internal.h b/include/erofs/internal.h
index 87c7b9a..ad8a1ee 100644
--- a/include/erofs/internal.h
+++ b/include/erofs/internal.h
@@ -273,6 +273,8 @@ struct erofs_inode {
 	/* OVL: non-merge dir that may contain whiteout entries */
 	bool whiteouts;
 	bool dot_omitted;
+	/* position in --hot-file-list, or EROFS_HOT_RANK_NONE if not hot */
+	unsigned int hot_rank;
 
 	unsigned int xattr_isize;
 	unsigned int extent_isize;
@@ -358,6 +360,7 @@ static inline struct erofs_inode *erofs_parent_inode(struct erofs_inode *inode)
 
 #define EROFS_DENTRY_FLAG_VALIDNID	0x01
 #define EROFS_DENTRY_FLAG_FIXUP_PNID	0x02
+#define EROFS_DENTRY_FLAG_NLINK_COUNTED	0x04
 struct erofs_dentry {
 	struct list_head d_child;	/* child of parent list */
 	union {
@@ -569,6 +572,14 @@ static inline bool erofs_is_packed_inode(struct erofs_inode *inode)
 		inode->nid == inode->sbi->packed_nid;
 }
 
+#define EROFS_HOT_RANK_NONE	UINT_MAX
+
+static inline bool erofs_inode_is_hotfile(struct erofs_inode *inode)
+{
+	return !S_ISDIR(inode->i_mode) &&
+		inode->hot_rank != EROFS_HOT_RANK_NONE;
+}
+
 int erofs_packedfile_init(struct erofs_sb_info *sbi, bool fragments_mkfs);
 void erofs_packedfile_exit(struct erofs_sb_info *sbi);
 
diff --git a/lib/Makefile.am b/lib/Makefile.am
index 8177c52..d6394ef 100644
--- a/lib/Makefile.am
+++ b/lib/Makefile.am
@@ -10,6 +10,7 @@ noinst_HEADERS = $(top_srcdir)/include/erofs_fs.h \
       $(top_srcdir)/include/erofs/diskbuf.h \
       $(top_srcdir)/include/erofs/err.h \
       $(top_srcdir)/include/erofs/exclude.h \
+      $(top_srcdir)/include/erofs/hotfile.h \
       $(top_srcdir)/include/erofs/inode.h \
       $(top_srcdir)/include/erofs/internal.h \
       $(top_srcdir)/include/erofs/io.h \
@@ -47,6 +48,7 @@ liberofs_la_SOURCES = config.c io.c cache.c super.c inode.c xattr.c exclude.c \
 		      compress_hints.c sha256.c blobchunk.c dir.c \
 		      fragments.c dedupe.c uuid_unparse.c uuid.c tar.c \
 		      block_list.c rebuild.c diskbuf.c bitops.c dedupe_ext.c \
+		      hotfile.c \
 		      vmdk.c metabox.c global.c importer.c base64.c
 
 liberofs_la_CFLAGS = -Wall ${libuuid_CFLAGS} -I$(top_srcdir)/include
diff --git a/lib/hotfile.c b/lib/hotfile.c
new file mode 100644
index 0000000..777117a
--- /dev/null
+++ b/lib/hotfile.c
@@ -0,0 +1,532 @@
+// SPDX-License-Identifier: GPL-2.0+ OR MIT
+#define _GNU_SOURCE
+
+#include <errno.h>
+#include <limits.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <sys/stat.h>
+#include <sys/types.h>
+#include <unistd.h>
+#include "erofs/config.h"
+#include "erofs/hotfile.h"
+#include "erofs/inode.h"
+#include "erofs/print.h"
+
+struct erofs_hotfile_manifest {
+	struct erofs_hotfile_entry {
+		char *path;
+		unsigned int rank;
+	} *file_paths;
+	unsigned int nr_files;
+	unsigned int cap_files;
+	struct erofs_hotfile_entry *dir_paths;
+	unsigned int nr_dirs;
+	unsigned int cap_dirs;
+};
+
+static struct erofs_hotfile_manifest hotfile_manifest;
+static const char *hotfile_root;
+
+/*
+ * Cache successful local directory lookups only while reading the hot list.
+ * Regular files and symlinks are still checked normally.  A bounded cache
+ * avoids building an extra tree for a potentially small hot list.
+ */
+#define EROFS_HOTFILE_DIR_CACHE_SIZE 256
+static struct erofs_hotfile_cached_dir {
+	char *path;
+	mode_t mode;
+} *hotfile_dir_cache;
+
+static void erofs_hotfile_drop_dir_cache(void)
+{
+	unsigned int i;
+
+	if (!hotfile_dir_cache)
+		return;
+	for (i = 0; i < EROFS_HOTFILE_DIR_CACHE_SIZE; ++i)
+		free(hotfile_dir_cache[i].path);
+	free(hotfile_dir_cache);
+	hotfile_dir_cache = NULL;
+}
+
+static int erofs_hotfile_cmp(const void *a, const void *b)
+{
+	const struct erofs_hotfile_entry *lhs = a;
+	const struct erofs_hotfile_entry *rhs = b;
+
+	return strcmp(lhs->path, rhs->path);
+}
+
+static int erofs_hotfile_path_cmp(const void *a, const void *b)
+{
+	const char *lhs = a;
+	const struct erofs_hotfile_entry *rhs = b;
+
+	return strcmp(lhs, rhs->path);
+}
+
+static char *erofs_hotfile_normalize(const char *path)
+{
+	const unsigned char *src = (const unsigned char *)path;
+	const unsigned char *end;
+	char *out;
+	size_t len = 0;
+
+	end = src + strlen((const char *)src);
+
+	out = malloc((end - src) + 1);
+	if (!out)
+		return NULL;
+
+	/* Use the same image-relative spelling for manifests and tar paths. */
+	while (src < end) {
+		const unsigned char *component;
+		size_t n;
+
+		while (src < end && *src == '/')
+			++src;
+		component = src;
+		while (src < end && *src != '/')
+			++src;
+		n = src - component;
+		if (!n || (n == 1 && component[0] == '.'))
+			continue;
+		if (len)
+			out[len++] = '/';
+		memcpy(out + len, component, n);
+		len += n;
+	}
+	out[len] = '\0';
+	return out;
+}
+
+static int erofs_hotfile_add_file(char *path, unsigned int rank);
+static int erofs_hotfile_add_dir(char *path, unsigned int rank);
+
+static int erofs_hotfile_add_plain_path(const char *path, bool dir_entry,
+					unsigned int rank)
+{
+	char *dup;
+	int err;
+
+	if (!path[0])
+		return 0;
+	dup = strdup(path);
+	if (!dup)
+		return -ENOMEM;
+	err = dir_entry ? erofs_hotfile_add_dir(dup, rank) :
+		erofs_hotfile_add_file(dup, rank);
+	if (err)
+		free(dup);
+	return err;
+}
+
+/* Prefixes passed here contain neither symlinks nor dot components. */
+static int erofs_hotfile_lookup(const char *path, mode_t *mode, char **target)
+{
+	struct erofs_hotfile_cached_dir *cached = NULL;
+	erofs_os_stat_t st;
+	char *full;
+	int err;
+
+	*mode = 0;
+	*target = NULL;
+	if (hotfile_dir_cache) {
+		u32 hash = erofs_crc32c(~0U, (const u8 *)path, strlen(path));
+
+		hash %= EROFS_HOTFILE_DIR_CACHE_SIZE;
+		cached = &hotfile_dir_cache[hash];
+		if (cached->path && !strcmp(cached->path, path)) {
+			*mode = cached->mode;
+			return 0;
+		}
+	}
+	if (asprintf(&full, "%s/%s", hotfile_root, path) < 0)
+		return -ENOMEM;
+	if (erofs_os_lstat(full, &st)) {
+		err = -errno;
+		free(full);
+		return err;
+	}
+	*mode = st.st_mode;
+	if (cached && S_ISDIR(*mode)) {
+		char *dup = strdup(path);
+
+		/* failing to cache must not fail the lookup itself */
+		if (dup) {
+			free(cached->path);
+			cached->path = dup;
+			cached->mode = *mode;
+		}
+	}
+	if (S_ISLNK(*mode)) {
+		size_t size = st.st_size + 1;
+		ssize_t len;
+
+		*target = malloc(size + 1);
+		if (!*target) {
+			free(full);
+			return -ENOMEM;
+		}
+		len = erofs_os_readlink(full, *target, size);
+		if (len < 0 || (size_t)len == size) {
+			err = len < 0 ? -errno : -EAGAIN;
+			free(*target);
+			*target = NULL;
+			free(full);
+			return err;
+		}
+		(*target)[len] = '\0';
+	}
+	free(full);
+	return 0;
+}
+
+/* Apply .. only after preceding symlinks, anchored at the image root. */
+static int erofs_hotfile_resolve(const char *path, unsigned int rank,
+				 char **resolved)
+{
+	char *pending = strdup(path), *prefix = strdup("");
+	unsigned int links = 0;
+	int err = 0;
+
+	*resolved = NULL;
+	if (!pending || !prefix) {
+		err = -ENOMEM;
+		goto out;
+	}
+	while (*pending) {
+		char *part = pending, *end, *suffix, *next, *target;
+		mode_t mode;
+		size_t parentlen = strlen(prefix);
+		bool has_slash;
+
+		while (*part == '/')
+			++part;
+		if (!*part)
+			break;
+		end = strchr(part, '/');
+		if (!end)
+			end = part + strlen(part);
+		has_slash = *end != '\0';
+		suffix = strdup(*end ? end + 1 : end);
+		if (!suffix) {
+			err = -ENOMEM;
+			goto out;
+		}
+		*end = '\0';
+		if (!strcmp(part, ".") || !strcmp(part, "..")) {
+			/* ".." of the image root is the root itself */
+			if (part[1]) {
+				char *slash = strrchr(prefix, '/');
+
+				prefix[slash ? slash - prefix : 0] = '\0';
+			}
+			free(pending);
+			pending = suffix;
+			continue;
+		}
+		if (asprintf(&next, "%s%s%s", prefix,
+			     parentlen ? "/" : "", part) < 0) {
+			free(suffix);
+			err = -ENOMEM;
+			goto out;
+		}
+		free(prefix);
+		prefix = next;
+		err = erofs_hotfile_lookup(prefix, &mode, &target);
+		if (err) {
+			free(suffix);
+			goto out;
+		}
+		if (S_ISLNK(mode)) {
+			if (!*target) {
+				free(target);
+				free(suffix);
+				err = -ENOENT;
+				goto out;
+			}
+			err = erofs_hotfile_add_plain_path(prefix, false, rank);
+			if (!err && ++links > 40)
+				err = -ELOOP;
+			if (!err && asprintf(&next, "%s%s%s", target,
+					     has_slash ? "/" : "", suffix) < 0)
+				err = -ENOMEM;
+			prefix[target[0] == '/' ? 0 : parentlen] = '\0';
+			free(target);
+			free(suffix);
+			if (err)
+				goto out;
+			free(pending);
+			pending = next;
+			continue;
+		}
+		/* A trailing slash also requires a directory. */
+		if (has_slash && !S_ISDIR(mode)) {
+			free(suffix);
+			err = -ENOTDIR;
+			goto out;
+		}
+		if (!S_ISREG(mode) && !S_ISDIR(mode)) {
+			free(suffix);
+			err = -ENOENT;
+			goto out;
+		}
+		if (S_ISDIR(mode)) {
+			err = erofs_hotfile_add_plain_path(prefix, true, rank);
+			if (err) {
+				free(suffix);
+				goto out;
+			}
+		}
+		free(pending);
+		pending = suffix;
+	}
+	*resolved = prefix;
+	prefix = NULL;
+out:
+	free(prefix);
+	free(pending);
+	return err;
+}
+
+static int erofs_hotfile_add_resolved_path(const char *path, unsigned int rank)
+{
+	char *resolved;
+	size_t len = strlen(path);
+	unsigned int nr_files = hotfile_manifest.nr_files;
+	unsigned int nr_dirs = hotfile_manifest.nr_dirs;
+	int err = erofs_hotfile_resolve(path, rank, &resolved);
+
+	if (!err) {
+		err = erofs_hotfile_add_plain_path(resolved,
+					len && path[len - 1] == '/', rank);
+		free(resolved);
+	} else {
+		struct erofs_hotfile_manifest *m = &hotfile_manifest;
+
+		while (m->nr_files > nr_files)
+			free(m->file_paths[--m->nr_files].path);
+		while (m->nr_dirs > nr_dirs)
+			free(m->dir_paths[--m->nr_dirs].path);
+		/* a stale or broken entry should not fail the whole build */
+		if (err != -ENOENT && err != -ENOTDIR && err != -ELOOP)
+			return err;
+		erofs_warn("ignoring hot path %s: %s", path, strerror(-err));
+		err = 0;
+	}
+	return err;
+}
+
+static int erofs_hotfile_add(struct erofs_hotfile_entry **paths,
+			     unsigned int *nr, unsigned int *cap,
+			     char *path, unsigned int rank)
+{
+	struct erofs_hotfile_entry *npaths;
+
+	if (*nr >= *cap) {
+		unsigned int ncap;
+
+		if (*cap > UINT_MAX / 2 ||
+		    *cap > SIZE_MAX / 2 / sizeof(*npaths))
+			return -ENOMEM;
+		ncap = *cap ? *cap * 2 : 64;
+		npaths = realloc(*paths, ncap * sizeof(*npaths));
+		if (!npaths)
+			return -ENOMEM;
+		*paths = npaths;
+		*cap = ncap;
+	}
+	(*paths)[*nr].path = path;
+	(*paths)[*nr].rank = rank;
+	++(*nr);
+	return 0;
+}
+
+static int erofs_hotfile_add_file(char *path, unsigned int rank)
+{
+	return erofs_hotfile_add(&hotfile_manifest.file_paths,
+				 &hotfile_manifest.nr_files,
+				 &hotfile_manifest.cap_files,
+				 path, rank);
+}
+
+static int erofs_hotfile_add_dir(char *path, unsigned int rank)
+{
+	return erofs_hotfile_add(&hotfile_manifest.dir_paths,
+				 &hotfile_manifest.nr_dirs,
+				 &hotfile_manifest.cap_dirs,
+				 path, rank);
+}
+
+static unsigned int erofs_hotfile_sort_dedupe(struct erofs_hotfile_entry *paths,
+					      unsigned int nr)
+{
+	unsigned int i, out = 0;
+
+	if (!nr)
+		return 0;
+
+	qsort(paths, nr, sizeof(paths[0]), erofs_hotfile_cmp);
+	for (i = 0; i < nr; ++i) {
+		if (out && !strcmp(paths[out - 1].path, paths[i].path)) {
+			if (paths[i].rank < paths[out - 1].rank) {
+				free(paths[out - 1].path);
+				paths[out - 1] = paths[i];
+			} else {
+				free(paths[i].path);
+			}
+			continue;
+		}
+		paths[out++] = paths[i];
+	}
+	return out;
+}
+
+static void erofs_hotfile_sort(void)
+{
+	hotfile_manifest.nr_files = erofs_hotfile_sort_dedupe(
+		hotfile_manifest.file_paths, hotfile_manifest.nr_files);
+	hotfile_manifest.nr_dirs = erofs_hotfile_sort_dedupe(
+		hotfile_manifest.dir_paths, hotfile_manifest.nr_dirs);
+}
+
+int erofs_hotfile_load(const char *path)
+{
+	FILE *fp;
+	char *line = NULL;
+	size_t linesz = 0;
+	ssize_t nread;
+	erofs_os_stat_t st;
+	int err = 0;
+	unsigned int nr_input = 0;
+
+	fp = fopen(path, "r");
+	if (!fp)
+		return -errno;
+	if (cfg.c_src_path && !erofs_os_stat(cfg.c_src_path, &st) &&
+	    S_ISDIR(st.st_mode))
+		hotfile_root = cfg.c_src_path;
+	if (hotfile_root)
+		hotfile_dir_cache = calloc(EROFS_HOTFILE_DIR_CACHE_SIZE,
+					   sizeof(*hotfile_dir_cache));
+	while ((nread = getline(&line, &linesz, fp)) >= 0) {
+		if (memchr(line, '\0', nread)) {
+			err = -EINVAL;
+			break;
+		}
+		if (nread && line[nread - 1] == '\n')
+			line[--nread] = '\0';
+		if (nread && line[nread - 1] == '\r')
+			line[--nread] = '\0';
+		/* a leading # starts a comment, use ./#name for such files */
+		if (!nread || line[0] == '#')
+			continue;
+		err = erofs_hotfile_add_resolved_path(line, nr_input++);
+		if (err)
+			break;
+	}
+	if (!err && ferror(fp))
+		err = -EIO;
+	free(line);
+	fclose(fp);
+	erofs_hotfile_drop_dir_cache();
+	if (err) {
+		erofs_hotfile_exit();
+		return err;
+	}
+	erofs_hotfile_sort();
+	erofs_info("loaded %u hot paths from %s", nr_input, path);
+	return 0;
+}
+
+bool erofs_hotfile_enabled(void)
+{
+	return hotfile_manifest.nr_files || hotfile_manifest.nr_dirs;
+}
+
+static unsigned int erofs_hotfile_find_rank(const char *path,
+				  const struct erofs_hotfile_entry *paths,
+				  unsigned int nr)
+{
+	const struct erofs_hotfile_entry *found;
+
+	found = nr ? bsearch(path, paths, nr, sizeof(*paths),
+			     erofs_hotfile_path_cmp) : NULL;
+	return found ? found->rank : EROFS_HOT_RANK_NONE;
+}
+
+static bool erofs_hotfile_path_normalized(const char *path)
+{
+	while (*path) {
+		size_t len = strcspn(path, "/");
+
+		if (!len || (len == 1 && path[0] == '.'))
+			return false;
+		path += len;
+		if (*path && !*++path)
+			return false;
+	}
+	return true;
+}
+
+static unsigned int erofs_hotfile_get_rank(const char *path,
+				 const struct erofs_hotfile_entry *paths,
+				 unsigned int nr)
+{
+	char *normalized;
+	unsigned int rank;
+
+	if (!nr || !erofs_hotfile_enabled())
+		return EROFS_HOT_RANK_NONE;
+	path = erofs_fspath(path);
+	if (erofs_hotfile_path_normalized(path))
+		return erofs_hotfile_find_rank(path, paths, nr);
+	normalized = erofs_hotfile_normalize(path);
+	if (!normalized)
+		return EROFS_HOT_RANK_NONE;
+	rank = erofs_hotfile_find_rank(normalized, paths, nr);
+	free(normalized);
+	return rank;
+}
+
+/* Return the hot-file-list position of @path or EROFS_HOT_RANK_NONE */
+unsigned int erofs_hotfile_rank(const char *path, bool isdir)
+{
+	struct erofs_hotfile_manifest *m = &hotfile_manifest;
+	unsigned int rank;
+
+	rank = erofs_hotfile_get_rank(path, m->file_paths, m->nr_files);
+	if (isdir)
+		rank = min(rank, erofs_hotfile_get_rank(path, m->dir_paths,
+							m->nr_dirs));
+	return rank;
+}
+
+static void erofs_hotfile_clear_paths(void)
+{
+	unsigned int i;
+
+	for (i = 0; i < hotfile_manifest.nr_files; ++i)
+		free(hotfile_manifest.file_paths[i].path);
+	for (i = 0; i < hotfile_manifest.nr_dirs; ++i)
+		free(hotfile_manifest.dir_paths[i].path);
+	free(hotfile_manifest.file_paths);
+	free(hotfile_manifest.dir_paths);
+	hotfile_manifest.file_paths = NULL;
+	hotfile_manifest.nr_files = 0;
+	hotfile_manifest.cap_files = 0;
+	hotfile_manifest.dir_paths = NULL;
+	hotfile_manifest.nr_dirs = 0;
+	hotfile_manifest.cap_dirs = 0;
+}
+
+void erofs_hotfile_exit(void)
+{
+	erofs_hotfile_clear_paths();
+	hotfile_manifest = (struct erofs_hotfile_manifest){};
+	hotfile_root = NULL;
+}
diff --git a/lib/inode.c b/lib/inode.c
index b8ca8f4..fa56509 100644
--- a/lib/inode.c
+++ b/lib/inode.c
@@ -23,6 +23,7 @@
 #include "erofs/exclude.h"
 #include "erofs/block_list.h"
 #include "erofs/compress_hints.h"
+#include "erofs/hotfile.h"
 #include "erofs/importer.h"
 #include "liberofs_cache.h"
 #include "liberofs_chunk.h"
@@ -655,13 +656,16 @@ static int erofs_write_unencoded_data(struct erofs_inode *inode,
 	inode->idata_size = inode->i_size % erofs_blksiz(sbi);
 	remaining = inode->i_size - inode->idata_size;
 
-	ret = erofs_allocate_inode_bh_data(inode, remaining >> sbi->blkszbits,
-					   device_id);
-	if (ret)
-		return ret;
+	/* Reuse data reserved while scheduling a hot directory. */
+	if (!inode->bh_data) {
+		ret = erofs_allocate_inode_bh_data(inode,
+				remaining >> sbi->blkszbits, device_id);
+		if (ret)
+			return ret;
+	}
 
 	bh = inode->bh_data;
-	if (bh) {
+	if (bh && remaining) {
 		bmgr = (struct erofs_bufmgr *)bh->block->buffers.fsprivate;
 		pos = erofs_btell(bh, false);
 		if (__erofs_unlikely(pos == EROFS_NULL_ADDR))
@@ -1372,6 +1376,9 @@ static int erofs_fill_inode(struct erofs_importer *im, struct erofs_inode *inode
 		if (!inode->i_srcpath)
 			return -ENOMEM;
 	}
+	if (!erofs_is_special_identifier(path))
+		inode->hot_rank = erofs_hotfile_rank(path,
+						     S_ISDIR(inode->i_mode));
 
 	if (erofs_should_use_inode_extended(im, inode, path)) {
 		if (params->force_inodeversion == EROFS_FORCE_INODE_COMPACT) {
@@ -1407,6 +1414,7 @@ struct erofs_inode *erofs_new_inode(struct erofs_sb_info *sbi)
 	inode->i_count = 1;
 	inode->datalayout = EROFS_INODE_FLAT_PLAIN;
 	inode->nid = EROFS_NID_UNALLOCATED;
+	inode->hot_rank = EROFS_HOT_RANK_NONE;
 
 	init_list_head(&inode->i_hash);
 	init_list_head(&inode->i_subdirs);
@@ -1434,8 +1442,12 @@ static struct erofs_inode *erofs_iget_from_local(struct erofs_importer *im,
 	 */
 	if (!S_ISDIR(st.st_mode) && !params->hard_dereference) {
 		inode = erofs_iget(st.st_dev, st.st_ino);
-		if (inode)
+		if (inode) {
+			/* take the earliest rank among all hardlinks */
+			inode->hot_rank = min(inode->hot_rank,
+					      erofs_hotfile_rank(path, false));
 			return inode;
+		}
 	}
 
 	/* cannot find in the inode cache */
@@ -1636,6 +1648,28 @@ static int erofs_mkfs_create_directory(const struct erofs_mkfs_btctx *ctx,
 	if (ret)
 		return ret;
 	inode->bh->op = &erofs_skip_write_bhops;
+
+	/*
+	 * Reserve data blocks for hot directories now, before hot files
+	 * advance the allocator.  Non-inline tails get their block here too
+	 * since they cannot be ballooned into place later.
+	 */
+	if (inode->hot_rank != EROFS_HOT_RANK_NONE &&
+	    (inode->datalayout == EROFS_INODE_FLAT_INLINE ||
+	     inode->datalayout == EROFS_INODE_FLAT_PLAIN)) {
+		erofs_blk_t nblocks = inode->i_size >> inode->sbi->blkszbits;
+
+		if (inode->datalayout == EROFS_INODE_FLAT_PLAIN &&
+		    inode->idata_size)
+			++nblocks;
+		if (!nblocks)
+			return 0;
+		ret = erofs_allocate_inode_bh_data(inode, nblocks,
+				ctx->im->params->dirdata_in_metazone ? -1 : 0);
+		if (ret)
+			return ret;
+		inode->lazy_tailblock = false;
+	}
 	return 0;
 }
 
@@ -2176,6 +2210,143 @@ static void erofs_mark_parent_inode(struct erofs_inode *inode,
 	inode->i_parent = (void *)((uintptr_t)dir | 1);
 }
 
+/*
+ * Hot inodes are dumped before the regular traversal.  Directories and
+ * symlinks come first so that hot metadata and dirent blocks are allocated
+ * up front, then regular files follow in --hot-file-list order.  Ties are
+ * broken by enqueue order to keep the result deterministic.
+ */
+struct erofs_mkfs_hot_item {
+	struct erofs_inode *dir;
+	struct erofs_dentry *d;
+	bool regular;
+	unsigned int rank;
+	u64 seq;
+};
+
+struct erofs_mkfs_hot_queue {
+	struct erofs_mkfs_hot_item *items;
+	size_t nr, cap;
+	u64 seq;
+};
+
+static bool erofs_mkfs_hot_before(const struct erofs_mkfs_hot_item *a,
+				  const struct erofs_mkfs_hot_item *b)
+{
+	if (a->regular != b->regular)
+		return !a->regular;
+	if (a->rank != b->rank)
+		return a->rank < b->rank;
+	return a->seq < b->seq;
+}
+
+static int erofs_mkfs_hot_push(struct erofs_mkfs_hot_queue *q,
+			       struct erofs_inode *dir, struct erofs_dentry *d)
+{
+	struct erofs_mkfs_hot_item item = {
+		.dir = dir,
+		.d = d,
+		.regular = !S_ISDIR(d->inode->i_mode) &&
+			   !S_ISLNK(d->inode->i_mode),
+		.rank = d->inode->hot_rank,
+		.seq = q->seq++,
+	};
+	size_t i, parent;
+
+	if (q->nr >= q->cap) {
+		size_t cap;
+		void *items;
+
+		if (q->cap > SIZE_MAX / 2 / sizeof(*q->items))
+			return -ENOMEM;
+		cap = q->cap ? q->cap << 1 : 64;
+		items = realloc(q->items, cap * sizeof(*q->items));
+		if (!items)
+			return -ENOMEM;
+		q->items = items;
+		q->cap = cap;
+	}
+
+	for (i = q->nr++; i; i = parent) {
+		parent = (i - 1) / 2;
+		if (!erofs_mkfs_hot_before(&item, &q->items[parent]))
+			break;
+		q->items[i] = q->items[parent];
+	}
+	q->items[i] = item;
+	return 0;
+}
+
+static struct erofs_mkfs_hot_item
+erofs_mkfs_hot_pop(struct erofs_mkfs_hot_queue *q)
+{
+	struct erofs_mkfs_hot_item top = q->items[0];
+	struct erofs_mkfs_hot_item last = q->items[--q->nr];
+	size_t i = 0, child;
+
+	while ((child = 2 * i + 1) < q->nr) {
+		if (child + 1 < q->nr &&
+		    erofs_mkfs_hot_before(&q->items[child + 1],
+					  &q->items[child]))
+			++child;
+		if (!erofs_mkfs_hot_before(&q->items[child], &last))
+			break;
+		q->items[i] = q->items[child];
+		i = child;
+	}
+	if (q->nr)
+		q->items[i] = last;
+	return top;
+}
+
+static int erofs_mkfs_hot_push_children(struct erofs_mkfs_hot_queue *q,
+					struct erofs_inode *dir)
+{
+	struct erofs_dentry *d;
+	int err;
+
+	list_for_each_entry(d, &dir->i_subdirs, d_child) {
+		if (is_dot_dotdot(d->name) ||
+		    (d->flags & EROFS_DENTRY_FLAG_VALIDNID) ||
+		    d->inode->hot_rank == EROFS_HOT_RANK_NONE)
+			continue;
+		err = erofs_mkfs_hot_push(q, dir, d);
+		if (err)
+			return err;
+	}
+	return 0;
+}
+
+static int erofs_mkfs_dump_hot_tree(const struct erofs_mkfs_btctx *ctx)
+{
+	struct erofs_mkfs_hot_queue q = {};
+	int err;
+
+	err = erofs_mkfs_hot_push_children(&q, ctx->im->root);
+	while (!err && q.nr) {
+		struct erofs_mkfs_hot_item item = erofs_mkfs_hot_pop(&q);
+		struct erofs_inode *inode = item.d->inode;
+
+		if (erofs_inode_visited(inode))
+			continue;
+		erofs_mark_parent_inode(inode, item.dir);
+		err = erofs_mkfs_handle_inode(ctx, inode);
+		if (err)
+			break;
+
+		/*
+		 * The cold entries of hot directories are dumped later in the
+		 * regular traversal; i_nlink already covers this first name.
+		 */
+		if (S_ISDIR(inode->i_mode))
+			err = erofs_mkfs_hot_push_children(&q, inode);
+		else if (!ctx->rebuild)
+			item.d->flags |= EROFS_DENTRY_FLAG_NLINK_COUNTED;
+	}
+	free(q.items);
+	return err;
+}
+
 static int erofs_mkfs_dump_tree(const struct erofs_mkfs_btctx *ctx)
 {
 	struct erofs_importer *im = ctx->im;
@@ -2183,11 +2354,14 @@ static int erofs_mkfs_dump_tree(const struct erofs_mkfs_btctx *ctx)
 	struct erofs_sb_info *sbi = root->sbi;
 	struct erofs_inode *dumpdir = erofs_igrab(root);
 	bool grouped_dirdata = im->params->grouped_dirdata;
+	bool hot = erofs_hotfile_enabled();
 	LIST_HEAD(pending_dirs);
 	int err, err2;
 
 	erofs_mark_parent_inode(root, root);	/* rootdir mark */
 	root->next_dirwrite = NULL;
+	if (hot)
+		root->hot_rank = 0;
 	/* update dev/i_ino[1] to keep track of the base image */
 	if (ctx->incremental) {
 		root->dev = root->sbi->dev;
@@ -2215,6 +2389,14 @@ static int erofs_mkfs_dump_tree(const struct erofs_mkfs_btctx *ctx)
 		sbi->root_nid = root->nid;
 	}
 
+	if (hot) {
+		err = erofs_mkfs_dump_hot_tree(ctx);
+		if (err) {
+			erofs_iput(dumpdir);
+			return err;
+		}
+	}
+
 	do {
 		struct erofs_inode *dir = dumpdir;
 		/* used for adding sub-directories in reverse order due to FIFO */
@@ -2243,7 +2425,13 @@ static int erofs_mkfs_dump_tree(const struct erofs_mkfs_btctx *ctx)
 					last = &inode->next_dirwrite;
 					(void)erofs_igrab(inode);
 				}
-			} else if (!ctx->rebuild) {
+			} else if (hot && S_ISDIR(inode->i_mode)) {
+				/* hot pass dumped it, walk cold entries now */
+				*last = inode;
+				last = &inode->next_dirwrite;
+				(void)erofs_igrab(inode);
+			} else if (!ctx->rebuild && !(d->flags &
+					EROFS_DENTRY_FLAG_NLINK_COUNTED)) {
 				++inode->i_nlink;
 			}
 		}
diff --git a/man/mkfs.erofs.1 b/man/mkfs.erofs.1
index 65ec807..f8157b4 100644
--- a/man/mkfs.erofs.1
+++ b/man/mkfs.erofs.1
@@ -310,6 +310,26 @@ random gzip access. Source file must be a gzip-compressed tarball.
 .BI "\-\-hard-dereference"
 Dereference hardlinks and add links as separate inodes.
 .TP
+.BI "\-\-hot-file-list=" path
+Read a newline-delimited list of image-relative hot file paths for local
+directory sources.
+Leading slashes refer to the image root.  Empty lines and lines starting
+with # are ignored; other spaces are part of the filename.  Use ./ to list
+a filename beginning with #.
+Hot regular files are scheduled in list order before cold files.
+Unlisted files retain their relative traversal order.
+Hardlink aliases share the earliest matching rank.
+Symlinks are resolved within the image root, including intermediate components.
+Parent directories are also prioritized.  Entries ending in \fI/\fR prioritize
+the directory without recursively marking its children hot.
+This option currently requires uncompressed builds.
+Data deduplication and chunk sharing are kept, so hot files may still
+share physical extents with other files.
+This is file-level data ordering: directory compression, metadata zones and
+metadata allocation can place metadata elsewhere in the image, so a complete,
+independently usable hot prefix is not guaranteed.
+This option cannot be combined with \fB--incremental\fR.
+.TP
 .B "\-\-ignore-mtime"
 Ignore the file modification time whenever it would cause \fBmkfs.erofs\fR to
 use extended inodes over compact inodes. When not using a fixed timestamp, this
diff --git a/mkfs/main.c b/mkfs/main.c
index f75225b..f5044ba 100644
--- a/mkfs/main.c
+++ b/mkfs/main.c
@@ -23,6 +23,7 @@
 #include "erofs/xattr.h"
 #include "erofs/exclude.h"
 #include "erofs/block_list.h"
+#include "erofs/hotfile.h"
 #include "erofs/compress_hints.h"
 #include "../lib/compressor.h"
 #include "../lib/liberofs_chunk.h"
@@ -105,9 +106,12 @@ static struct option long_options[] = {
 	{"MZ", optional_argument, NULL, 537},
 	{"xattr-prefix", required_argument, NULL, 538},
 	{"xattr-inode-digest", optional_argument, NULL, 539},
+	{"hot-file-list", required_argument, NULL, 540},
 	{0, 0, 0, 0},
 };
 
+static char *hotfile_list_path;
+
 static void print_available_compressors(FILE *f, const char *delim)
 {
 	int i = 0;
@@ -210,6 +214,8 @@ static void usage(int argc, char **argv)
 		" --uid-offset=#         add offset # to all file uids (# = id offset)\n"
 		" --gid-offset=#         add offset # to all file gids (# = id offset)\n"
 		" --hard-dereference     dereference hardlinks, add links as separate inodes\n"
+		" --hot-file-list=X      specify newline-separated hot file paths for\n"
+		"                        local directory sources\n"
 		" --ignore-mtime         use build time instead of strict per-file modification time\n"
 		" --max-extent-bytes=#   set maximum decompressed extent size # in bytes\n"
 		" --mount-point=X        X=prefix of target fs path (default: /)\n"
@@ -1497,6 +1503,12 @@ static int mkfs_parse_options_cfg(struct erofs_importer_params *params,
 				return err;
 			}
 			break;
+		case 540:
+			free(hotfile_list_path);
+			hotfile_list_path = strdup(optarg);
+			if (!hotfile_list_path)
+				return -ENOMEM;
+			break;
 		case 'V':
 			version();
 			exit(0);
@@ -1552,6 +1564,15 @@ static int mkfs_parse_options_cfg(struct erofs_importer_params *params,
 			return err;
 	}
 
+	if (hotfile_list_path && incremental_mode) {
+		erofs_err("--hot-file-list conflicts with --incremental");
+		return -EINVAL;
+	}
+	if (hotfile_list_path && source_mode != EROFS_MKFS_SOURCE_LOCALDIR) {
+		erofs_err("--hot-file-list requires a local directory source");
+		return -EOPNOTSUPP;
+	}
+
 	if (quiet) {
 		cfg.c_dbg_lvl = EROFS_ERR;
 		cfg.c_showprogress = false;
@@ -1789,6 +1810,15 @@ int main(int argc, char **argv)
 		goto exit;
 	}
 
+	if (hotfile_list_path) {
+		err = erofs_hotfile_load(hotfile_list_path);
+		if (err) {
+			erofs_err("failed to load hot-file list %s: %s",
+				  hotfile_list_path, erofs_strerror(err));
+			goto exit;
+		}
+	}
+
 	err = parse_source_date_epoch();
 	if (err) {
 		fprintf(stderr, "Try '%s --help' for more information.\n", argv[0]);
@@ -1910,6 +1940,12 @@ int main(int argc, char **argv)
 	if (err)
 		goto exit;
 
+	if (erofs_hotfile_enabled() && g_sbi.available_compr_algs) {
+		erofs_err("--hot-file-list requires uncompressed output");
+		err = -EOPNOTSUPP;
+		goto exit;
+	}
+
 	if (importer_params.dedupe == EROFS_DEDUPE_FORCE_ON &&
 	    g_sbi.available_compr_algs) {
 		err = z_erofs_dedupe_init(erofs_blksiz(&g_sbi));
@@ -2084,6 +2120,9 @@ exit:
 		fclose(blklst);
 	erofs_cleanup_compress_hints();
 	erofs_cleanup_exclude_rules();
+	erofs_hotfile_exit();
+	free(hotfile_list_path);
+	hotfile_list_path = NULL;
 	erofs_xattr_cleanup_name_prefixes();
 	erofs_rebuild_cleanup();
 	erofs_diskbuf_exit();
-- 
2.50.1 (Apple Git-155)


