Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E81060A2612
	for <linux-erofs@archiver.kernel.org>; Fri, 20 Nov 2026 10:46:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=docker.com header.i=@docker.com header.a=rsa-sha256 header.s=google header.b=GTjs4a7w
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4jWBpP6pqHz2yST;
	Fri, 20 Nov 2026 21:46:21 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2a00:1450:4864:20::430"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1795171581;
	cv=none; b=SMDfyU7tMv7nk+28fItkqh21Waoltw8BSgAokZ91MlkRzMxZzzK9fc7QNhAU2XgweBsncRPSw6+avJTDn2UkLSVU07mtHWJjNk2spBcUmHKuRtBx8Ob/CK3ZCBlICju2BcGiB3tzevl9QBruuCu5qUfuTxrLt58Z7bKHJgddZ3hwdzV6+/7man1lqG/21V+zG9K7To1CguuRPDaiNENo5i4LP0++vlydSui11oOCm5uoYYkV+pgWwnGUdtXC88869sES2WNTIhPkZXMj+MB5+J/fxVRHVmdxVgnfmqZCaCLZg9krniCBgwxryfogRNIMvU7RK5zL3q8pAvlRL+Vbdw==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1795171581; c=relaxed/relaxed;
	bh=nSglD7UjiEtZyBo0Tko5d68wE3cgOWQcpHJc8btvU6M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CH2K13rMhm6uiA6+EwQbvh43M/Lghuh+xxsJEGSfiWI0+QgDklW/yu5e/45QK6sUfcAUwj9EzhI+kaFfIT7xd2d17I2GRSmAJKJJii4AUxMaT2laM4rIkcA5StTMy1px4nnsDxi6UfJSs/W8/OI+QTzNoIMq4TlmlEUAp+lGHnrhv80EbL7ejTFMSF8vGv0DeUpnrzVVf/VVmYmjzIhDD9NYqtu4rJMhw3Xqo6X6pKfZ6RvAjlwxNXNcsjFNjyBsvF/McZdljVmoduI8LPidUxYkclsN/j5Jp+/M48unzMijhjwP1pjA1/2YrjICcEvHdOXlwhC99OkNNPZ+9lu1jg==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=docker.com; dkim=pass (2048-bit key; unprotected) header.d=docker.com header.i=@docker.com header.a=rsa-sha256 header.s=google header.b=GTjs4a7w; dkim-atps=neutral; spf=pass (client-ip=2a00:1450:4864:20::430; helo=mail-wr1-x430.google.com; envelope-from=xiang.gao@docker.com; receiver=lists.ozlabs.org) smtp.mailfrom=docker.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=docker.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=docker.com header.i=@docker.com header.a=rsa-sha256 header.s=google header.b=GTjs4a7w;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=docker.com (client-ip=2a00:1450:4864:20::430; helo=mail-wr1-x430.google.com; envelope-from=xiang.gao@docker.com; receiver=lists.ozlabs.org)
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4jWBpM1t21z2xpt
	for <linux-erofs@lists.ozlabs.org>; Fri, 20 Nov 2026 21:46:19 +1100 (AEDT)
Received: by mail-wr1-x430.google.com with SMTP id ffacd0b85a97d-4a3e706b5dfso456031f8f.2
        for <linux-erofs@lists.ozlabs.org>; Fri, 20 Nov 2026 02:46:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=docker.com; s=google; t=1795171576; x=1795776376; darn=lists.ozlabs.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=nSglD7UjiEtZyBo0Tko5d68wE3cgOWQcpHJc8btvU6M=;
        b=GTjs4a7w13hH8MxExnoCK34upm4YUeUOYnHn8t0utW7Ax9BtePnEs0TSgOG29mKiQ1
         fO5Bf1WbYBxB+COQiRQ8/xoju434YLhFL82nXWzv8jZdM1BDOjmQzBpbJKHM1Pfe7FUK
         mIu+C4NOBAqW3ctjOPP4zc2so/D+XGf9CJWkESkNm/yMNpILZNE6biBgCF62miZRVfpd
         Fb4m0DcIfmXeeeXOZedH4YxVU0BFK9poQ/afheSwHGsqJ9xRosgUf3zfs+CgQ0xYYcR0
         VjGY4NqGDYOdxwwBdJDzatWFKeSiZSto4jKbD/WcaxfItn7Px/bqF2LI0Rml+k/7wY4U
         A7fQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795171576; x=1795776376;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=nSglD7UjiEtZyBo0Tko5d68wE3cgOWQcpHJc8btvU6M=;
        b=gn/kivZx0H0Otzpx5vSIuseBmQAJCy56bpbRnp+gL3dhlTZ39QaWwJz2bbkSrfP0rt
         wHML0pdO8EE4qeNssXvVHEVnHOscZ5qYb65FVDEjd0pZ0A8Il7BuFTLCtNGWpkglDf/D
         OUew6VdTnh679vEQKTS/daOXGDthd9fhdsLB3EpRbNwbyEK4J7smogI5BuxvPuNeYwjM
         EDu7nOR0Ak4T/mYfREkqLqNVyT5lAlMr55ZnKnWTjV86JlM5vdyUpVaTeH2pMmuFXSMD
         SV2ZeZOVp4uHgRY9oJR7mjlmPA430BFVaXEkjnK3GG53HBrDWIaXNf97y3iATKDMjlTZ
         8bXg==
X-Gm-Message-State: APuU4Z/cHqZy3uzYdlG8+VZJa8MKpLyvYbvn6WZYF0RbiNjzMfd0By2a
	cfPEbZ73gSUTCLJQLEOnG7Wjeto3x1xt2LW8JESSHTKYQy1OkWgZcsknOQtYDnQYanfLXvQC5SS
	mrLE3gE8=
X-Gm-Gg: AZFdTZdpCuSNIV9z+LlfGiPcOllAnaaYwrcsQ3IyLUbOMPA8K5Rxkj4/Ik47CIJBXzL
	G82S1jH3ZYJvBPVEKQ6u4QBbwVKWJ9FelMPi9SWhVyoUYpkSDM19+jWIGNLpQJRpBWzpfzEzIjB
	lESfX5OCEjv8BzQQiAYPVe7SPqL4LFl2hklf9Lm3fNadoLOObDBu++3XJJzwF2dlZ8fFXx5o7tW
	3W4h/3/jKPw6AtQ4FV/aIrd/OeAqQOm9Y1yh9TuS5Udx82WeyAmdKjFfsk02Mbw3ohTRi2VN1j0
	RUixw7vnCida9TnbEiYU5AlDdvn0y6npzUTUd251+o7JQ9SRmd/seejUz8qoXWzCwGLm+K2UxW7
	lQpuuKD/HqmD9sgz+xL+uqXpUkQwoAX9bD0TVDlcJNe0qV+BPFcoj34JoMm4VbApQsaU0uFm1Zz
	LJgd1WAXcQCIJrs1TqAbPfkXJjhoz3KBTjDtiQ2/AKHSR9KDwOm0tWCtOciWGc9uLOdPAkeicpY
	tl/CgGwDg2eiSFLN/s5b2n8r1WvBBX/lcLSQTvDJx3fyPpDyRImN5QqARnbD4hFcwhBGQrSQFKf
	gyrneNIfAeOj0RPSk5Grl58OzFcwDHKA12FTHqsEZLEyVw9P/3+4cXFiAKPIDRipCCV06l24DjL
	Z5N/xnVs=
X-Received: by 2002:a05:6000:1788:b0:4a9:1649:9eaf with SMTP id ffacd0b85a97d-4abb86e5099mr5064793f8f.57.1795171575702;
        Fri, 20 Nov 2026 02:46:15 -0800 (PST)
Received: from F7R9GP321C.fritz.box ([2a02:8108:8388:6600:5888:55e8:d901:aec])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4ab6b110d56sm4795522f8f.40.2026.11.20.02.46.14
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 20 Nov 2026 02:46:15 -0800 (PST)
From: Gao Xiang <xiang.gao@docker.com>
To: linux-erofs@lists.ozlabs.org
Cc: Wenyuan Xu <sereno.xu@deepseek.com>,
	Gao Xiang <xiang.gao@docker.com>
Subject: [PATCH v2 4/5] erofs-utils: mkfs: add manifest build mode
Date: Fri, 20 Nov 2026 11:46:05 +0100
Message-ID: <20261120104606.25056-4-xiang.gao@docker.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261120104606.25056-1-xiang.gao@docker.com>
References: <20261120104606.25056-1-xiang.gao@docker.com>
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
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Wenyuan Xu <sereno.xu@deepseek.com>

Add --manifest=FILE to build an image from selected source entries
without preparing a matching staging directory:

    mkfs.erofs --manifest=FILE IMAGE DATADIR

Starting with a simple two-field format: each record contains an image
path beginning with '/' and a backing file path relative to DATADIR:

    /usr/bin/bash objects/ab/cdef...
    /usr/bin/ls objects/12/3456...

File records import contents and metadata from the backing file.
Directory records import metadata only; children are specified by
separate records.  Missing parent directories are created automatically.

Support for extended attributes is left for a follow-up.

Assisted-by: LLM
Signed-off-by: Wenyuan Xu <sereno.xu@deepseek.com>
[ Gao Xiang: It also prepares for the upcoming diff updates for VM snapshots. ]
Signed-off-by: Gao Xiang <xiang.gao@docker.com>
---
 configure.ac             |   2 +
 include/erofs/manifest.h |  19 +++
 lib/Makefile.am          |   3 +-
 lib/inode.c              |   1 +
 lib/manifest.c           | 294 +++++++++++++++++++++++++++++++++++++++
 mkfs/main.c              |  40 +++++-
 6 files changed, 355 insertions(+), 4 deletions(-)
 create mode 100644 include/erofs/manifest.h
 create mode 100644 lib/manifest.c

diff --git a/configure.ac b/configure.ac
index 0333f9c..24a3dd9 100644
--- a/configure.ac
+++ b/configure.ac
@@ -300,6 +300,7 @@ AC_CHECK_FUNCS(m4_flatten([
 	copy_file_range
 	fallocate
 	getrandom
+	getline
 	getrlimit
 	gettid
 	gettimeofday
@@ -317,6 +318,7 @@ AC_CHECK_FUNCS(m4_flatten([
 	strdup
 	strerror
 	strrchr
+	strsep
 	strtoull
 	sysconf
 	utimensat]))
diff --git a/include/erofs/manifest.h b/include/erofs/manifest.h
new file mode 100644
index 0000000..c1fa281
--- /dev/null
+++ b/include/erofs/manifest.h
@@ -0,0 +1,19 @@
+/* SPDX-License-Identifier: GPL-2.0+ OR MIT */
+#ifndef __EROFS_MANIFEST_H
+#define __EROFS_MANIFEST_H
+
+#include <stdio.h>
+
+#ifdef __cplusplus
+extern "C"
+{
+#endif
+
+struct erofs_importer;
+int erofs_manifest_load(struct erofs_importer *im, FILE *fp);
+
+#ifdef __cplusplus
+}
+#endif
+
+#endif
diff --git a/lib/Makefile.am b/lib/Makefile.am
index 8177c52..8654479 100644
--- a/lib/Makefile.am
+++ b/lib/Makefile.am
@@ -23,6 +23,7 @@ noinst_HEADERS = $(top_srcdir)/include/erofs_fs.h \
       $(top_srcdir)/include/erofs/windows_compat.h \
       $(top_srcdir)/include/erofs/compress_hints.h \
       $(top_srcdir)/include/erofs/importer.h \
+      $(top_srcdir)/include/erofs/manifest.h \
       $(top_srcdir)/lib/liberofs_base64.h \
       $(top_srcdir)/lib/liberofs_cache.h \
       $(top_srcdir)/lib/liberofs_chunk.h \
@@ -47,7 +48,7 @@ liberofs_la_SOURCES = config.c io.c cache.c super.c inode.c xattr.c exclude.c \
 		      compress_hints.c sha256.c blobchunk.c dir.c \
 		      fragments.c dedupe.c uuid_unparse.c uuid.c tar.c \
 		      block_list.c rebuild.c diskbuf.c bitops.c dedupe_ext.c \
-		      vmdk.c metabox.c global.c importer.c base64.c
+		      vmdk.c metabox.c global.c importer.c base64.c manifest.c
 
 liberofs_la_CFLAGS = -Wall ${libuuid_CFLAGS} -I$(top_srcdir)/include
 liberofs_la_LIBADD = $(LIBEROFS_LIBS)
diff --git a/lib/inode.c b/lib/inode.c
index 2099d38..ad6f081 100644
--- a/lib/inode.c
+++ b/lib/inode.c
@@ -98,6 +98,7 @@ void erofs_remove_ihash(struct erofs_inode *inode)
 {
 	erofs_down_write(&erofs_ihashlock);
 	list_del(&inode->i_hash);
+	init_list_head(&inode->i_hash);
 	erofs_up_write(&erofs_ihashlock);
 }
 
diff --git a/lib/manifest.c b/lib/manifest.c
new file mode 100644
index 0000000..3242b3f
--- /dev/null
+++ b/lib/manifest.c
@@ -0,0 +1,294 @@
+// SPDX-License-Identifier: GPL-2.0+ OR MIT
+#define _GNU_SOURCE
+#include <config.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <unistd.h>
+#include "erofs/importer.h"
+#include "erofs/inode.h"
+#include "erofs/print.h"
+#include "erofs/manifest.h"
+#include "liberofs_rebuild.h"
+
+#ifndef HAVE_STRSEP
+static char *__erofs_strsep(char **stringp, const char *delim)
+{
+	char *token = *stringp, *end;
+
+	if (!token)
+		return NULL;
+	end = token + strcspn(token, delim);
+	if (*end)
+		*end++ = '\0';
+	else
+		end = NULL;
+	*stringp = end;
+	return token;
+}
+#define strsep __erofs_strsep
+#endif
+
+#ifndef HAVE_GETLINE
+static ssize_t __erofs_getline(char **line, size_t *capacity, FILE *fp)
+{
+	size_t len = 0;
+	int c;
+
+	while ((c = fgetc(fp)) != EOF) {
+		size_t size;
+
+		if (len + 1 >= *capacity) {
+			char *buf;
+
+			size = *capacity ? *capacity * 2 : 256;
+			if (size <= *capacity || size > (size_t)PTRDIFF_MAX) {
+				errno = EOVERFLOW;
+				return -1;
+			}
+			buf = realloc(*line, size);
+			if (!buf)
+				return -1;
+			*line = buf;
+			*capacity = size;
+		}
+		(*line)[len++] = c;
+		if (c == '\n')
+			break;
+	}
+	if (ferror(fp) || !len)
+		return -1;
+	(*line)[len] = '\0';
+	return len;
+}
+#define getline __erofs_getline
+#endif
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
+/* Decode hexadecimal byte escapes in place. */
+static int erofs_manifest_decode(char *s)
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
+		/* NUL is invalid in paths. */
+		if (!c)
+			return -EINVAL;
+		*q++ = c;
+	}
+	*q = '\0';
+	return 0;
+}
+
+static int erofs_manifest_load_local(struct erofs_importer *im,
+		struct erofs_inode *root, char *imagepath, const char *srcpath)
+{
+	struct erofs_inode *inode, *parent;
+	struct erofs_dentry *d;
+	erofs_os_stat_t st;
+	bool dumb, existing;
+	int ret;
+
+	ret = erofs_os_lstat(srcpath, &st) ? -errno : 0;
+	if (ret)
+		return ret;
+
+	d = erofs_rebuild_get_dentry(root, imagepath, false,
+				      &dumb, &dumb, false);
+	if (IS_ERR(d))
+		return PTR_ERR(d);
+	existing = !d || d->type != EROFS_FT_UNKNOWN;
+	if (existing) {
+		inode = d ? d->inode : root;
+		/* Allow updating directory meta while preserving existing children */
+		if (!S_ISDIR(st.st_mode) || !S_ISDIR(inode->i_mode))
+			return -ENOTDIR;
+		parent = inode->i_parent;
+		free(inode->i_srcpath);
+		inode->i_srcpath = NULL;
+		erofs_remove_ihash(inode);
+	} else {
+		parent = d->inode;
+		if (!S_ISDIR(st.st_mode) && !im->params->hard_dereference) {
+			inode = erofs_iget(st.st_dev, st.st_ino);
+			if (inode) {
+				if (check_add_overflow(inode->i_nlink, 1U,
+						       &inode->i_nlink)) {
+					erofs_iput(inode);
+					ret = -EOVERFLOW;
+					goto out_dentry;
+				}
+				d->inode = inode;
+				d->type = erofs_mode_to_ftype(inode->i_mode);
+				goto out;
+			}
+		}
+		inode = erofs_new_inode(im->sbi);
+		if (IS_ERR(inode)) {
+			ret = PTR_ERR(inode);
+			goto out_dentry;
+		}
+		inode->i_parent = parent;
+	}
+
+	ret = erofs_fill_inode(im, inode, &st, srcpath);
+	if (ret)
+		goto out_inode;
+	inode->datasource = EROFS_INODE_DATA_SOURCE_LOCALPATH;
+	if (S_ISLNK(inode->i_mode)) {
+		ssize_t len;
+
+		inode->i_link = malloc(st.st_size + 1);
+		if (!inode->i_link) {
+			ret = -ENOMEM;
+			goto out_inode;
+		}
+		len = erofs_os_readlink(srcpath, inode->i_link, st.st_size);
+		if (len < 0) {
+			ret = -errno;
+			goto out_inode;
+		}
+		inode->i_link[len] = '\0';
+		inode->i_size = len;
+	}
+
+	if (!existing) {
+		d->inode = inode;
+		d->type = erofs_mode_to_ftype(inode->i_mode);
+	}
+out:
+	if (erofs_inode_is_whiteout(inode))
+		parent->whiteouts = true;
+	return 0;
+out_inode:
+	if (existing)
+		return ret;
+	erofs_iput(inode);
+out_dentry:
+	list_del(&d->d_child);
+	free(d);
+	return ret;
+}
+
+static int erofs_manifest_parse_record(struct erofs_importer *im,
+				 struct erofs_inode *root, char *line)
+{
+	char *fields[2], *token, *path;
+	int i, ret;
+
+	for (i = 0; i < ARRAY_SIZE(fields); ++i) {
+		do {
+			token = strsep(&line, " ");
+		} while (token && !*token);
+		if (!token)
+			return -EINVAL;
+		fields[i] = token;
+	}
+	while ((token = strsep(&line, " ")))
+		if (*token)
+			return -EINVAL;
+
+	if (erofs_manifest_decode(fields[0]) || *fields[0] != '/' ||
+	    erofs_manifest_decode(fields[1]))
+		return -EINVAL;
+	if (asprintf(&path, "%s/%s", im->params->source, fields[1]) < 0)
+		return -ENOMEM;
+	ret = erofs_manifest_load_local(im, root, fields[0], path);
+	free(path);
+	return ret;
+}
+
+/* The importer has not taken ownership of the tree on a parse error. */
+static void erofs_manifest_drop_children(struct erofs_inode *dir)
+{
+	struct erofs_dentry *d, *next;
+
+	list_for_each_entry_safe(d, next, &dir->i_subdirs, d_child) {
+		if (d->type != EROFS_FT_UNKNOWN) {
+			if (S_ISDIR(d->inode->i_mode))
+				erofs_manifest_drop_children(d->inode);
+			erofs_iput(d->inode);
+		}
+		list_del(&d->d_child);
+		free(d);
+	}
+}
+
+int erofs_manifest_load(struct erofs_importer *im, FILE *fp)
+{
+	struct erofs_inode *root;
+	char *line = NULL;
+	size_t capacity = 0;
+	unsigned long lineno = 0;
+	ssize_t len;
+	int ret = 0;
+
+	root = erofs_make_empty_root_inode(im, im->sbi);
+	if (IS_ERR(root))
+		return PTR_ERR(root);
+	/* Synthesized directories do not belong to the base image. */
+	root->dev = im->sbi->dev + 1;
+
+	while ((len = getline(&line, &capacity, fp)) >= 0) {
+		++lineno;
+		if (line[0] == '#')
+			continue;
+		if (memchr(line, '\0', len)) {
+			ret = -EINVAL;
+			break;
+		}
+		if (len && line[len - 1] == '\n') {
+			line[--len] = '\0';
+			if (len && line[len - 1] == '\r')
+				line[--len] = '\0';
+		}
+		ret = erofs_manifest_parse_record(im, root, line);
+		if (ret)
+			break;
+	}
+	if (!ret && ferror(fp))
+		ret = -EIO;
+	if (!ret && len < 0 && !feof(fp))
+		ret = errno ? -errno : -EIO;
+	if (!ret && !lineno)
+		ret = -EINVAL;
+	if (ret) {
+		erofs_manifest_drop_children(root);
+		erofs_iput(root);
+		erofs_err("failed to parse manifest at line %lu: %s",
+			  lineno, erofs_strerror(ret));
+	} else {
+		im->root = root;
+	}
+	free(line);
+	return ret;
+}
diff --git a/mkfs/main.c b/mkfs/main.c
index dbda00e..fe996c2 100644
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
+		" --manifest=X           build an image from a manifest file X and DATADIR\n"
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
 		err = erofs_os_lstat((s = argv[optind++]), &st);
 		if (err) {
@@ -985,7 +991,10 @@ static int mkfs_parse_sources(int argc, char *argv[], int optind)
 					  erofs_strerror(-errno));
 				return -ENOENT;
 			}
-			erofs_set_fs_root(cfg.c_src_path);
+			if (source_mode == EROFS_MKFS_SOURCE_LOCALDIR)
+				erofs_set_fs_root(cfg.c_src_path);
+		} else if (source_mode == EROFS_MKFS_SOURCE_MANIFEST) {
+			return -ENOTDIR;
 		} else {
 			cfg.c_src_path = strdup(s);
 			if (!cfg.c_src_path)
@@ -1497,6 +1506,14 @@ static int mkfs_parse_options_cfg(struct erofs_importer_params *params,
 				return err;
 			}
 			break;
+		case 540:
+			if (manifest_file) {
+				erofs_err("duplicated manifest %s", optarg);
+				return -EOPNOTSUPP;
+			}
+			manifest_file = optarg;
+			source_mode = EROFS_MKFS_SOURCE_MANIFEST;
+			break;
 		case 'V':
 			version();
 			exit(0);
@@ -1534,6 +1551,9 @@ static int mkfs_parse_options_cfg(struct erofs_importer_params *params,
 			erofs_err("--blobdev is currently incompatible with rebuild mode");
 			return -EINVAL;
 		}
+	} else if (source_mode == EROFS_MKFS_SOURCE_MANIFEST) {
+		erofs_err("missing argument: DATADIR");
+		return -EINVAL;
 	} else if (source_mode != EROFS_MKFS_SOURCE_TAR) {
 		erofs_err("missing argument: SOURCE(s)");
 		return -EINVAL;
@@ -1981,7 +2001,7 @@ int main(int argc, char **argv)
 		err = erofs_fill_inode(&importer, root, &st, cfg.c_src_path);
 		if (err)
 			goto exit;
-	} else {
+	} else if (source_mode != EROFS_MKFS_SOURCE_MANIFEST) {
 		err = erofs_xattr_flush_name_prefixes(&importer,
 						      mkfs_plain_xattr_pfx);
 		if (err) {
@@ -1998,7 +2018,21 @@ int main(int argc, char **argv)
 	}
 
 	importer.root = root;
-	if (source_mode == EROFS_MKFS_SOURCE_TAR) {
+	if (source_mode == EROFS_MKFS_SOURCE_MANIFEST) {
+		FILE *fp = fopen(manifest_file, "r");
+
+		if (!fp) {
+			err = -errno;
+			erofs_err("cannot open manifest %s: %s",
+				  manifest_file, erofs_strerror(err));
+			goto exit;
+		}
+		err = erofs_manifest_load(&importer, fp);
+		fclose(fp);
+		if (err)
+			goto exit;
+		root = importer.root;
+	} else if (source_mode == EROFS_MKFS_SOURCE_TAR) {
 		while (!(err = tarerofs_parse_tar(&importer, &erofstar)))
 			;
 	} else if (source_mode == EROFS_MKFS_SOURCE_REBUILD) {
-- 
2.54.0 (Apple Git-157)


