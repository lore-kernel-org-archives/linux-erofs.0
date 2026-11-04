Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9424B606A31B
	for <linux-erofs@archiver.kernel.org>; Wed,  4 Nov 2026 04:12:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=deepseek.com header.i=@deepseek.com header.a=rsa-sha256 header.s=default header.b=d2etfBbZ
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4jKBqh4fsNz2x9N;
	Wed, 04 Nov 2026 15:12:48 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=156.224.81.78
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1793765568;
	cv=none; b=JeNET2qREnuYKBCJgd7Z/ijJC7f/cnd+DHpgMOna0mUin31CVgmZQS5KnWcw/cr82AHsfpNvoXrRH9fxZXpq3nZLVFFbUsqITjyn5OUkx6TH1b7xIR6ezp2xMepqIdC6XKzj6xXheDcQBsdEawxxiD7wFnI47RgxQKciQlv1W9EJZGRCvAcDhCc0jfsFDoiBwILTU8KI2FSEZ4G7ZaOloiBCa2fW5RNjGdpLrU2UKXPLfgOsekxTMd5qEnWFoHYGie6gpF0+805HWjWs4/y5w7MWXVBGnPNA8Q70E46XS0oRGoTBziRloof+KO7DVaUJ+c/THWJSk4JUERnaPfIQrA==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1793765568; c=relaxed/relaxed;
	bh=zUkhU3MmZwI8EStmGcnZpYdp1kMvLhmST5/PAfkA4P8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MBMkp/1lFi1W4ryMX/Yv73nHlD/GbzEiQ0U8a5vaWU/mAEwlf0s1EXtWY7vknYA7xBARKpctmXmJL41NRuy0zcpMrervsATM7uZML1NO1ACYhQAkOomWgov82A8ejhsCB7ihcCQ5ej/KMGcSF22fbz3bu/xB+AyD8oruuHRYlapiWCAxnFG3taiKooEhuYC+EjUxCXnaABWt2IMUBu60evQKLcuSpg0FE5F/6cEVHLfn+oWeL+VqB39Gub1PMQXSvGCOgJS3vOob4NdDCsB+JZyZqiZkaxbDQ3bOpZKqncCfQMbx/RvinZ68MK9rm3rarJgEmlaAlnE3ePL3NIE00Q==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=deepseek.com; dkim=pass (1024-bit key; unprotected) header.d=deepseek.com header.i=@deepseek.com header.a=rsa-sha256 header.s=default header.b=d2etfBbZ; dkim-atps=neutral; spf=pass (client-ip=156.224.81.78; helo=mail-m8178.xmail.ntesmail.com; envelope-from=sereno.xu@deepseek.com; receiver=lists.ozlabs.org) smtp.mailfrom=deepseek.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=deepseek.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=deepseek.com header.i=@deepseek.com header.a=rsa-sha256 header.s=default header.b=d2etfBbZ;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=deepseek.com (client-ip=156.224.81.78; helo=mail-m8178.xmail.ntesmail.com; envelope-from=sereno.xu@deepseek.com; receiver=lists.ozlabs.org)
X-Greylist: delayed 303 seconds by postgrey-1.37 at boromir; Wed, 04 Nov 2026 15:12:43 AEDT
Received: from mail-m8178.xmail.ntesmail.com (mail-m8178.xmail.ntesmail.com [156.224.81.78])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4jKBqb0LjBz2xB1
	for <linux-erofs@lists.ozlabs.org>; Wed, 04 Nov 2026 15:12:42 +1100 (AEDT)
Received: from localhost.localdomain (unknown [124.243.154.173])
	by smtp.qiye.163.com (Hmail) with ESMTP id 536bdc6e9;
	Wed, 4 Nov 2026 12:07:35 +0800 (GMT+08:00)
From: Wenyuan Xu <sereno.xu@deepseek.com>
To: xiang@kernel.org,
	linux-erofs@lists.ozlabs.org
Cc: sereno.xu@deepseek.com
Subject: [RFC 4/7] erofs-utils: mkfs: add manifest input mode
Date: Wed,  4 Nov 2026 04:07:22 +0000
Message-ID: <20261104040725.2473313-5-sereno.xu@deepseek.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261104040725.2473313-1-sereno.xu@deepseek.com>
References: <20261104040725.2473313-1-sereno.xu@deepseek.com>
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
X-HM-Tid: 0aa1a4bdaa6c03a3kunma3fc75f17e07a
X-HM-MType: 1
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFITzdXWRgWCB1ZQUpXWS1ZQUlXWQ8JGhUIEh9ZQVlCSR0dVkoZTElOGRlOQkNNSlYVFA
	kWGhdVEwETFhoSFyQUDg9ZV1kYEgtZQVlKSU9VSU9IVUpOT1VKTEhZV1kWGg8SFR0UWUFZS1VLVU
	tVS1kG
DKIM-Signature: a=rsa-sha256;
	b=d2etfBbZjPKZmzL0+h5E3S122a9R8T1Dz/JUYoxrr4xBv8L52+hvgmyH7j7jvthHuy7Y2h9u7WLzMqxORJ0SZjvnDf9ZRy7yVbGfRyTJ+MnwV+n9AOs7ZhPQRg+s8ClpWTBKBzr7xBEwPLFm9D+oe/dHfq3uTfdgu5Ix8/vXqpg=; s=default; c=relaxed/relaxed; d=deepseek.com; v=1;
	bh=zUkhU3MmZwI8EStmGcnZpYdp1kMvLhmST5/PAfkA4P8=;
	h=date:mime-version:subject:message-id:from;
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Add --manifest=FILE to build an inode tree from explicit path, payload,
metadata and xattr records without scanning the source directory.
Regular file payloads are resolved relative to the source directory.

Support escaped strings, binary xattr values, hard links and special
files. Reject duplicate paths and xattr keys, require parents before
children, and report malformed records with their line and field.

Build shared xattrs from the loaded tree and mark directories containing
whiteouts before passing the tree to the importer.

Assisted-by: LLM
Signed-off-by: Wenyuan Xu <sereno.xu@deepseek.com>
---
 include/erofs/manifest.h |  17 ++
 lib/Makefile.am          |   3 +-
 lib/manifest.c           | 443 +++++++++++++++++++++++++++++++++++++++
 mkfs/main.c              |  35 ++++
 4 files changed, 497 insertions(+), 1 deletion(-)
 create mode 100644 include/erofs/manifest.h
 create mode 100644 lib/manifest.c

diff --git a/include/erofs/manifest.h b/include/erofs/manifest.h
new file mode 100644
index 0000000..dce87d3
--- /dev/null
+++ b/include/erofs/manifest.h
@@ -0,0 +1,17 @@
+/* SPDX-License-Identifier: GPL-2.0+ OR MIT */
+#ifndef __EROFS_MANIFEST_H
+#define __EROFS_MANIFEST_H
+
+#ifdef __cplusplus
+extern "C"
+{
+#endif
+
+struct erofs_importer;
+int erofs_manifest_load(struct erofs_importer *im, const char *filename);
+
+#ifdef __cplusplus
+}
+#endif
+
+#endif
diff --git a/lib/Makefile.am b/lib/Makefile.am
index 0a82915..eb44d67 100644
--- a/lib/Makefile.am
+++ b/lib/Makefile.am
@@ -20,6 +20,7 @@ noinst_HEADERS = $(top_srcdir)/include/erofs_fs.h \
       $(top_srcdir)/include/erofs/xattr.h \
       $(top_srcdir)/include/erofs/compress_hints.h \
       $(top_srcdir)/include/erofs/importer.h \
+      $(top_srcdir)/include/erofs/manifest.h \
       $(top_srcdir)/lib/liberofs_base64.h \
       $(top_srcdir)/lib/liberofs_cache.h \
       $(top_srcdir)/lib/liberofs_chunk.h \
@@ -44,7 +45,7 @@ liberofs_la_SOURCES = config.c io.c cache.c super.c inode.c xattr.c exclude.c \
 		      compress_hints.c sha256.c blobchunk.c dir.c \
 		      fragments.c dedupe.c uuid_unparse.c uuid.c tar.c \
 		      block_list.c rebuild.c diskbuf.c bitops.c dedupe_ext.c \
-		      vmdk.c metabox.c global.c importer.c base64.c
+		      vmdk.c metabox.c global.c importer.c base64.c manifest.c
 
 liberofs_la_CFLAGS = -Wall ${libuuid_CFLAGS} -I$(top_srcdir)/include
 liberofs_la_LIBADD = $(LIBEROFS_LIBS)
diff --git a/lib/manifest.c b/lib/manifest.c
new file mode 100644
index 0000000..bf8eb8c
--- /dev/null
+++ b/lib/manifest.c
@@ -0,0 +1,443 @@
+// SPDX-License-Identifier: GPL-2.0+ OR MIT
+#define _GNU_SOURCE
+#include <config.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <fcntl.h>
+#include <unistd.h>
+#include <limits.h>
+#ifdef HAVE_SYS_SYSMACROS_H
+#include <sys/sysmacros.h>
+#endif
+#include "erofs/importer.h"
+#include "erofs/inode.h"
+#include "erofs/xattr.h"
+#include "erofs/print.h"
+#include "erofs/manifest.h"
+
+static int erofs_manifest_hex(unsigned char c)
+{
+	if (c >= '0' && c <= '9')
+		return c - '0';
+	if (c >= 'a' && c <= 'f')
+		return c - 'a' + 10;
+	if (c >= 'A' && c <= 'F')
+		return c - 'A' + 10;
+	return -1;
+}
+
+/* Decode in place, retaining the length for binary xattr values. */
+static int erofs_manifest_decode(char *s, bool binary, size_t *len)
+{
+	char *p = s, *q = s;
+	int a, b;
+
+	while (*p) {
+		unsigned char c = *p++;
+
+		if (c == '\\') {
+			/*
+			 * A space terminates the token before decoding, so
+			 * \x or \xX immediately followed by a space is invalid.
+			 */
+			if (p[0] != 'x' || !p[1] || !p[2])
+				return -EINVAL;
+			a = erofs_manifest_hex(p[1]);
+			b = erofs_manifest_hex(p[2]);
+			if (a < 0 || b < 0)
+				return -EINVAL;
+			c = (a << 4) | b;
+			p += 3;
+		} else if (c <= ' ' || c == 127) {
+			return -EINVAL;
+		}
+		/* \x00 is invalid except in binary xattr values. */
+		if (!c && !binary)
+			return -EINVAL;
+		*q++ = c;
+	}
+	*len = q - s;
+	*q = '\0';
+	return 0;
+}
+
+static int erofs_manifest_number(const char *s, unsigned int base,
+				 u64 max, u64 *v)
+{
+	u64 n = 0;
+
+	if (!*s)
+		return -EINVAL;
+	for (; *s; ++s) {
+		unsigned int d = (unsigned char)*s - '0';
+
+		if (d >= base || n > (max - d) / base)
+			return -EINVAL;
+		n = n * base + d;
+	}
+	*v = n;
+	return 0;
+}
+
+/*
+ * Validate and resolve each component once, without modifying the path.
+ * Return NULL for a missing final entry, or an error for a missing parent.
+ * The empty component under sentinel represents the root directory.
+ */
+static struct erofs_inode *erofs_manifest_lookup(struct erofs_inode *sentinel,
+		const char *path, struct erofs_inode **parent, char *name)
+{
+	struct erofs_inode *dir = sentinel;
+	const char *p = path, *component = "";
+	size_t len = 0;
+
+	if (*p != '/')
+		return ERR_PTR(-EINVAL);
+	while (*p == '/')
+		++p;
+	for (;;) {
+		struct erofs_dentry *d;
+		struct erofs_inode *next = NULL;
+
+		list_for_each_entry(d, &dir->i_subdirs, d_child) {
+			if (d->namelen == len && !memcmp(d->name, component, len)) {
+				next = d->inode;
+				break;
+			}
+		}
+		if (!*p) {
+			if (parent)
+				*parent = dir;
+			if (name) {
+				memcpy(name, component, len);
+				name[len] = '\0';
+			}
+			return next;
+		}
+		if (!next)
+			return ERR_PTR(-ENOENT);
+		if (!S_ISDIR(next->i_mode))
+			return ERR_PTR(-ENOTDIR);
+		dir = next;
+		component = p;
+		while (*p && *p != '/')
+			++p;
+		len = p - component;
+		if (len > EROFS_NAME_LEN ||
+		    (len == 1 && component[0] == '.') ||
+		    (len == 2 && component[0] == '.' && component[1] == '.'))
+			return ERR_PTR(-EINVAL);
+		while (*p == '/')
+			++p;
+	}
+}
+
+static int erofs_manifest_xattrs(struct erofs_inode *inode, char *rest)
+{
+	char *token;
+	int ret;
+
+	while ((token = strsep(&rest, " "))) {
+		char *eq;
+		size_t len, size;
+		unsigned int index, prefixlen;
+
+		if (!*token)
+			continue;
+		eq = strchr(token, '=');
+		if (!eq || strchr(eq + 1, '='))
+			return -EINVAL;
+		*eq++ = '\0';
+		if (erofs_manifest_decode(token, false, &len) || !len || len > 255 ||
+		    erofs_manifest_decode(eq, true, &size) || size > UINT16_MAX)
+			return -EINVAL;
+		if (erofs_inode_has_xattr(inode, token))
+			return -EEXIST;
+		if (!erofs_xattr_prefix_matches(token, &index, &prefixlen))
+			return -EOPNOTSUPP;
+		ret = erofs_vfs_setxattr(inode, token, eq, size);
+		if (ret)
+			return ret;
+	}
+	return 0;
+}
+
+enum erofs_manifest_field {
+	EROFS_MANIFEST_PATH,
+	EROFS_MANIFEST_PAYLOAD,
+	EROFS_MANIFEST_SIZE,
+	EROFS_MANIFEST_MODE,
+	EROFS_MANIFEST_UID,
+	EROFS_MANIFEST_GID,
+	EROFS_MANIFEST_RDEV,
+	EROFS_MANIFEST_MTIME,
+	EROFS_MANIFEST_FIELD_COUNT,
+};
+
+static int erofs_manifest_parse_record(struct erofs_importer *im,
+				 struct erofs_inode *sentinel, char *line)
+{
+	const char *basedir = im->params->source;
+	struct erofs_inode *inode = NULL, *parent = NULL;
+	struct erofs_dentry *d;
+	char *f[EROFS_MANIFEST_FIELD_COUNT], *token, *dot;
+	char name[EROFS_NAME_LEN + 1];
+	bool hardlink, is_root;
+	u64 mode, size = 0, uid, gid, rdev = 0, sec, nsec;
+	size_t len;
+	int i, ret = -EINVAL;
+
+	for (i = 0; i < EROFS_MANIFEST_FIELD_COUNT; ++i) {
+		/*
+		 * strsep() yields empty tokens for leading or repeated spaces.
+		 * skip in this case.
+		 */
+		do {
+			token = strsep(&line, " ");
+		} while (token && !*token);
+		if (!token)
+			return -EINVAL;
+		f[i] = token;
+	}
+
+	/* PATH */
+	if (erofs_manifest_decode(f[EROFS_MANIFEST_PATH], false, &len))
+		return -EINVAL;
+	inode = erofs_manifest_lookup(sentinel, f[EROFS_MANIFEST_PATH],
+				      &parent, name);
+	if (IS_ERR(inode))
+		return PTR_ERR(inode);
+	if (inode)
+		return -EEXIST;
+	is_root = parent == sentinel;
+
+	/* MODE */
+	hardlink = f[EROFS_MANIFEST_MODE][0] == '@';
+	if (hardlink) {
+		if (is_root)
+			return -EINVAL;
+
+		/* PAYLOAD */
+		if (erofs_manifest_decode(f[EROFS_MANIFEST_PAYLOAD], false, &len))
+			return -EINVAL;
+
+		inode = erofs_manifest_lookup(sentinel, f[EROFS_MANIFEST_PAYLOAD],
+					      NULL, NULL);
+		if (IS_ERR(inode))
+			return PTR_ERR(inode);
+		if (!inode || S_ISDIR(inode->i_mode))
+			return -EINVAL;
+		if (inode->i_nlink == UINT_MAX)
+			return -EOVERFLOW;
+
+		inode = erofs_igrab(inode);
+		++inode->i_nlink;
+		goto link;
+	}
+
+	/* MODE */
+	if (erofs_manifest_number(f[EROFS_MANIFEST_MODE], 8, UINT16_MAX, &mode))
+		return -EINVAL;
+	if (is_root && !S_ISDIR(mode))
+		return -EINVAL;
+	switch (mode & S_IFMT) {
+	case S_IFREG:
+	case S_IFLNK:
+		/* SIZE */
+		if (erofs_manifest_number(f[EROFS_MANIFEST_SIZE], 10,
+					  INT64_MAX, &size))
+			return -EINVAL;
+		break;
+	case S_IFCHR:
+	case S_IFBLK:
+	case S_IFIFO:
+	case S_IFSOCK:
+		/* RDEV */
+		if (erofs_manifest_number(f[EROFS_MANIFEST_RDEV], 10,
+					  UINT64_MAX, &rdev) ||
+		    (u64)(dev_t)rdev != rdev ||
+		    major((dev_t)rdev) > 0xfff || minor((dev_t)rdev) > 0xfffff)
+			return -EINVAL;
+		break;
+	case S_IFDIR:
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	/* UID */
+	if (erofs_manifest_number(f[EROFS_MANIFEST_UID], 10, UINT32_MAX, &uid))
+		return -EINVAL;
+
+	/* GID */
+	if (erofs_manifest_number(f[EROFS_MANIFEST_GID], 10, UINT32_MAX, &gid))
+		return -EINVAL;
+
+	/* MTIME */
+	dot = strchr(f[EROFS_MANIFEST_MTIME], '.');
+	if (!dot)
+		return -EINVAL;
+	*dot++ = '\0';
+	if (erofs_manifest_number(f[EROFS_MANIFEST_MTIME], 10, INT64_MAX, &sec) ||
+	    erofs_manifest_number(dot, 10, 999999999, &nsec))
+		return -EINVAL;
+
+	inode = erofs_new_inode(im->sbi);
+	if (IS_ERR(inode))
+		return PTR_ERR(inode);
+	inode->dev = sentinel->dev;
+	inode->i_mode = mode;
+	inode->i_uid = uid;
+	inode->i_gid = gid;
+	inode->i_size = size;
+	inode->i_mtime = sec;
+	inode->i_mtime_nsec = nsec;
+	inode->i_nlink = S_ISDIR(mode) ? 2 : 1;
+	inode->i_parent = parent;
+	if (S_ISCHR(mode) || S_ISBLK(mode) || S_ISFIFO(mode) || S_ISSOCK(mode))
+		inode->u.i_rdev = erofs_new_encode_dev(rdev);
+
+	/* PAYLOAD */
+	if (S_ISREG(mode)) {
+		struct stat st;
+		int fd;
+
+		if (erofs_manifest_decode(f[EROFS_MANIFEST_PAYLOAD], false, &len))
+			goto out;
+		if (f[EROFS_MANIFEST_PAYLOAD][0] != '/')
+			goto out;
+		if (asprintf(&inode->i_srcpath, "%s%s", basedir,
+			     f[EROFS_MANIFEST_PAYLOAD]) < 0) {
+			ret = -ENOMEM;
+			goto out;
+		}
+		fd = open(inode->i_srcpath, O_RDONLY | O_NONBLOCK | O_BINARY);
+		if (fd < 0) {
+			ret = -errno;
+			goto out;
+		}
+		ret = fstat(fd, &st) ? -errno : 0;
+		close(fd);
+		if (ret)
+			goto out;
+		ret = -EINVAL;
+		if (!S_ISREG(st.st_mode))
+			goto out;
+		if (st.st_size != size)
+			goto out;
+		inode->datasource = EROFS_INODE_DATA_SOURCE_LOCALPATH;
+	} else {
+		/* Use the image path for progress reporting and diagnostics. */
+		if (asprintf(&inode->i_srcpath, "%s%s", basedir,
+			     f[EROFS_MANIFEST_PATH]) < 0) {
+			ret = -ENOMEM;
+			goto out;
+		}
+
+		if (S_ISLNK(mode)) {
+			if (erofs_manifest_decode(f[EROFS_MANIFEST_PAYLOAD], false, &len))
+				goto out;
+			if (len != size)
+				goto out;
+			inode->i_link = strdup(f[EROFS_MANIFEST_PAYLOAD]);
+			if (!inode->i_link) {
+				ret = -ENOMEM;
+				goto out;
+			}
+		}
+	}
+
+	/* XATTR */
+	ret = erofs_manifest_xattrs(inode, line);
+	if (ret)
+		goto out;
+link:
+	/* PATH */
+	d = erofs_d_alloc(parent, name);
+	if (IS_ERR(d)) {
+		ret = PTR_ERR(d);
+		goto out;
+	}
+	d->inode = inode;
+	d->type = erofs_mode_to_ftype(inode->i_mode);
+	if (erofs_inode_is_whiteout(inode))
+		parent->whiteouts = true;
+	return 0;
+out:
+	erofs_iput(inode);
+	return ret;
+}
+
+/* The importer has not taken ownership of the tree on a parse error. */
+static void erofs_manifest_drop_children(struct erofs_inode *dir)
+{
+	struct erofs_dentry *d, *next;
+
+	list_for_each_entry_safe(d, next, &dir->i_subdirs, d_child) {
+		if (S_ISDIR(d->inode->i_mode))
+			erofs_manifest_drop_children(d->inode);
+		erofs_iput(d->inode);
+		list_del(&d->d_child);
+		free(d);
+	}
+}
+
+int erofs_manifest_load(struct erofs_importer *im, const char *filename)
+{
+	struct erofs_inode sentinel = { .i_mode = S_IFDIR };
+	struct erofs_dentry *d;
+	struct stat st;
+	FILE *fp = fopen(filename, "r");
+	char *line = NULL;
+	size_t capacity = 0;
+	unsigned long lineno = 0;
+	ssize_t len;
+	int ret = 0;
+
+	if (!fp) {
+		ret = -errno;
+		erofs_err("%s: cannot open manifest: %s", filename, strerror(errno));
+		return ret;
+	}
+	if (stat(im->params->source, &st)) {
+		ret = -errno;
+		erofs_err("%s: cannot stat base directory: %s",
+			  im->params->source, erofs_strerror(ret));
+		fclose(fp);
+		return ret;
+	}
+	sentinel.dev = st.st_dev;
+	init_list_head(&sentinel.i_subdirs);
+
+	while ((len = getline(&line, &capacity, fp)) >= 0) {
+		++lineno;
+		if (memchr(line, '\0', len)) {
+			ret = -EINVAL;
+			break;
+		}
+		if (len && line[len - 1] == '\n')
+			line[--len] = '\0';
+		ret = erofs_manifest_parse_record(im, &sentinel, line);
+		if (ret)
+			break;
+	}
+	if (!ret && ferror(fp))
+		ret = -EIO;
+	if (!ret && !lineno)
+		ret = -EINVAL;
+	if (ret) {
+		erofs_manifest_drop_children(&sentinel);
+		erofs_err("%s:%lu: %s", filename, lineno, erofs_strerror(ret));
+	} else {
+		/* Transfer the root out of sentinel before it leaves scope. */
+		d = list_first_entry(&sentinel.i_subdirs, struct erofs_dentry, d_child);
+		im->root = d->inode;
+		im->root->i_parent = im->root;
+		list_del(&d->d_child);
+		free(d);
+	}
+	free(line);
+	fclose(fp);
+	return ret;
+}
diff --git a/mkfs/main.c b/mkfs/main.c
index d8706d7..6686c5a 100644
--- a/mkfs/main.c
+++ b/mkfs/main.c
@@ -24,6 +24,7 @@
 #include "erofs/exclude.h"
 #include "erofs/block_list.h"
 #include "erofs/compress_hints.h"
+#include "erofs/manifest.h"
 #include "../lib/compressor.h"
 #include "../lib/liberofs_chunk.h"
 #include "../lib/liberofs_gzran.h"
@@ -105,6 +106,7 @@ static struct option long_options[] = {
 	{"MZ", optional_argument, NULL, 537},
 	{"xattr-prefix", required_argument, NULL, 538},
 	{"xattr-inode-digest", optional_argument, NULL, 539},
+	{"manifest", required_argument, NULL, 540},
 	{0, 0, 0, 0},
 };
 
@@ -212,6 +214,7 @@ static void usage(int argc, char **argv)
 		" --hard-dereference     dereference hardlinks, add links as separate inodes\n"
 		" --ignore-mtime         use build time instead of strict per-file modification time\n"
 		" --max-extent-bytes=#   set maximum decompressed extent size # in bytes\n"
+		" --manifest=FILE        build an uncompressed image from a manifest and basedir\n"
 		" --mount-point=X        X=prefix of target fs path (default: /)\n"
 		" --preserve-mtime       keep per-file modification time strictly\n"
 		" --offset=#             skip # bytes at the beginning of IMAGE.\n"
@@ -324,8 +327,10 @@ static enum {
 	EROFS_MKFS_SOURCE_S3,
 	EROFS_MKFS_SOURCE_OCI,
 	EROFS_MKFS_SOURCE_REBUILD,
+	EROFS_MKFS_SOURCE_MANIFEST,
 } source_mode;
 
+static const char *manifest_file;
 static unsigned int rebuild_src_count;
 static LIST_HEAD(rebuild_src_list);
 static u8 fixeduuid[16];
@@ -971,6 +976,7 @@ static int mkfs_parse_sources(int argc, char *argv[], int optind)
 	char *s;
 
 	switch (source_mode) {
+	case EROFS_MKFS_SOURCE_MANIFEST:
 	case EROFS_MKFS_SOURCE_LOCALDIR:
 		err = lstat((s = argv[optind++]), &st);
 		if (err) {
@@ -986,6 +992,8 @@ static int mkfs_parse_sources(int argc, char *argv[], int optind)
 				return -ENOENT;
 			}
 			erofs_set_fs_root(cfg.c_src_path);
+		} else if (source_mode == EROFS_MKFS_SOURCE_MANIFEST) {
+				return -ENOTDIR;
 		} else {
 			cfg.c_src_path = strdup(s);
 			if (!cfg.c_src_path)
@@ -1497,6 +1505,14 @@ static int mkfs_parse_options_cfg(struct erofs_importer_params *params,
 				return err;
 			}
 			break;
+		case 540:
+			if (manifest_file) {
+				erofs_err("duplicate manifest file");
+				return -EINVAL;
+			}
+			manifest_file = optarg;
+			source_mode = EROFS_MKFS_SOURCE_MANIFEST;
+			break;
 		case 'V':
 			version();
 			exit(0);
@@ -1970,6 +1986,14 @@ int main(int argc, char **argv)
 			err = PTR_ERR(root);
 			goto exit;
 		}
+	} else if (source_mode == EROFS_MKFS_SOURCE_MANIFEST)  {
+		err = erofs_xattr_flush_name_prefixes(&importer,
+						      mkfs_plain_xattr_pfx);
+		if (err) {
+			erofs_err("failed to flush long xattr prefixes: %s",
+				  erofs_strerror(err));
+			goto exit;
+		}
 	} else {
 		err = erofs_xattr_flush_name_prefixes(&importer,
 						      mkfs_plain_xattr_pfx);
@@ -1993,6 +2017,17 @@ int main(int argc, char **argv)
 		err = lstat(cfg.c_src_path, &st);
 		if (!err)
 			err = erofs_fill_inode(&importer, importer.root, &st, cfg.c_src_path);
+	} else if (source_mode == EROFS_MKFS_SOURCE_MANIFEST) {
+		err = erofs_manifest_load(&importer, manifest_file);
+		if (err)
+			goto exit;
+		root = importer.root;
+
+		err = erofs_build_shared_xattrs(&g_sbi, mkfscfg.inlinexattr_tolerance);
+		if (err) {
+			erofs_err("failed to build shared xattrs: %s", erofs_strerror(err));
+			goto exit;
+		}
 	} else if (source_mode == EROFS_MKFS_SOURCE_TAR) {
 		while (!(err = tarerofs_parse_tar(&importer, &erofstar)))
 			;
-- 
2.43.0


