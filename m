Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 931C7606A335
	for <linux-erofs@archiver.kernel.org>; Wed, 18 Nov 2026 01:43:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=docker.com header.i=@docker.com header.a=rsa-sha256 header.s=google header.b=T+IN4/32
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4jTkrM2vnbz2xlY;
	Wed, 18 Nov 2026 12:42:59 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2a00:1450:4864:20::32b"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1794966179;
	cv=none; b=XkjgsAORYomGgIjqsLqd8bGvESF9sz6d3SsIHwZWndOXOZhn1N9yP8+HEsQahdgru9T+EekZnOn2MveELuNiTqFCOehCCDKR6PDko7vDESHDaE6HZZ7VeBkA2lMe58vUFl2rzDqKFat5fv2ELa0yX5XYYyRTBhMYXuXVV6jt0mt2jVDu8o0Qp72QxyCYKeuH+gq9yRQmZrrllJV1WWd8/i2EDmQij3Cm6zJhHgdnQq4YHbW2xgAKY/3+fJJWzf0KUmgN5O4d+CYXUJyI0Qd8Z+GN98HBiKf1QVxIVYl2mNjh4nU+XyMRl4zEQwrSyisu+OHMIRneBQJBJVu4DroaLA==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1794966179; c=relaxed/relaxed;
	bh=muqddS/pnYKnfFXiFvZNxoIqINLUe2ZX3pIwYboS0Fw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L4C/OZDBiNu5yEUdAJSiJOHVO2sCgBq3Mey7Ch4rYUI1qlpqbyINCPJ2ST/V2+hQotXQGiKziv1GuAchXIhF199CYWNq+xgXI8zSw586tCRoZmfpe/ID8r/RnDZcqIHa/h3N7cZYApr0MAZi0zQX4ztW40nUExyuYaVKXybS0tLlb5MlswfPg00w5zyDpICyKJ3sXNVm0M9ura8PC+civ+OOKY+Kq+0N0zwUogN1NNKxHvgJFuXYJiflzcvkrXH2aLSq+6C8hA0b0Foc1DPToPNZS8sCJcx7cbkFeL339zFlws1NENXcyOLlYnEJMnDwz+IfKzEUmtobqTfx41z8cQ==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=docker.com; dkim=pass (2048-bit key; unprotected) header.d=docker.com header.i=@docker.com header.a=rsa-sha256 header.s=google header.b=T+IN4/32; dkim-atps=neutral; spf=pass (client-ip=2a00:1450:4864:20::32b; helo=mail-wm1-x32b.google.com; envelope-from=xiang.gao@docker.com; receiver=lists.ozlabs.org) smtp.mailfrom=docker.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=docker.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=docker.com header.i=@docker.com header.a=rsa-sha256 header.s=google header.b=T+IN4/32;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=docker.com (client-ip=2a00:1450:4864:20::32b; helo=mail-wm1-x32b.google.com; envelope-from=xiang.gao@docker.com; receiver=lists.ozlabs.org)
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4jTkrK3ChMz2y8m
	for <linux-erofs@lists.ozlabs.org>; Wed, 18 Nov 2026 12:42:57 +1100 (AEDT)
Received: by mail-wm1-x32b.google.com with SMTP id 5b1f17b1804b1-4a35d5d4a20so4565925e9.2
        for <linux-erofs@lists.ozlabs.org>; Tue, 17 Nov 2026 17:42:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=docker.com; s=google; t=1794966172; x=1795570972; darn=lists.ozlabs.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=muqddS/pnYKnfFXiFvZNxoIqINLUe2ZX3pIwYboS0Fw=;
        b=T+IN4/32QPOnuVxdciKHGKKDEb7UlJFkphz9UXPw0tCcQc6vh8G1WelPKsGORo+L17
         +YnlIOm1wLpmzsfkyygG0fn0zknyjaMUDt+Wi3JpYdvQ+xLQXz1d1FWui5gqAUWuSXil
         qnx8dkss1jlESxefpmelveCFmaApWg2BCS7n0UHyOOvZHsxUBoa6a5HfyOrSVNtQWDVS
         J7LwkPLyrbDum4acNmjxxYNQiWrHkRNxOA7HDDPR9vC5fSH8qrIOd5qxlKXucJdX1NmP
         gPr1t6/dW60q4STlUx5rZgr54mIBKHMI7qHuwcQt0XmusIpUet9LGJCl4I0RREwnoz1x
         qVUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794966172; x=1795570972;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=muqddS/pnYKnfFXiFvZNxoIqINLUe2ZX3pIwYboS0Fw=;
        b=lFyEsprpdV3k/XNYCXNpYh4xB6EMB0VGNc05Nrqob63EbJYI3z6RlcK1gMr9oRcqHG
         fXNBgMTpEtxVtK+vAySE5P6S/7r10ngPjfietCi1u+v+O15eUovkUu8g12NBddqnxsUd
         /bbOkQuXjDo5uLL3QWWYYQclr2rMiMzWtvYF7rsA9IqILc66Ysk0wgpeFlMHQYDwIsRi
         RL+5psxu26oQaS2Sgd1IiJ+tMyVonCVNTqOLzRHBTSe3NwR2+3p5uwKf+wmdXEERJkeB
         0B80IN51DtMRmYaVTi+9j5JUIEWmxy4gCHrZO2fMgTNBrohRVCVN7L+d1tcFeHF6Ue2S
         uoew==
X-Gm-Message-State: APuU4Z/YgulFmQ31kvkjAUYd+8lkVoHsoBuZXdnQnWHhiKiccu9Ro4vC
	OJIkB5+TFjDmad/nvwvfA2gH5T5WkskD0issj/XCD+CqW11gVli5FJtaW36bMblS1/8BW8P2Zcv
	n4ugGUOM=
X-Gm-Gg: AYBFou0S+ZW95oGMy2tQTjf6Xhw97tVas6CQgwbSqkFcrFX06IBuBCF2QUAADmTOtrd
	IEE4f/nIxCxn0Urq0+mg+tDfU3redwGc682FZteTvll+dBbz0+TOnOKu/nJ4tE7LDA8voZ0R0iZ
	fAR7gAm/1aSgllLU566HFtdYXFzdp6neD4KvVSGwFcAnVm89whUVLxifWYcAlmzLjNZu3Rh+4pl
	2IZLW2dIe9BX/L6HICL2XD76HDiIhusXvyiAKZYjRM63s5TirC8ZE4KoxlKT4uPccazqdlDANPf
	N0LLHHkZ0rC2/pRSoyNcDHbcLb+ElBozV+86Ycpv7Y5aeeOP27TwVB0pgkMurZHwKfj/v/1yZ3A
	UgR6AkNWgwjUwRzh415nlO5rGaQ5g2k4ZlggaEd65OKun5HsAKnldM0UBfqXCvN1S6cDVLju37R
	S5gWO+9ueNXnyezqHpyJBc2BvUhX6P+T3cHe2qNc4G7gQ3rpe0yOvh3FnuPOs00Kh4Dr9UgY5wr
	xqmeqf2ZJvHLcr20kNHVxDtmfBp5AP5Wb0bMChQD7eGYa8MJHNDjC5hcKRsA8ZS/J/9kT9mfRu3
	AWf1sy7W5AgGgshrI2MCRwviAx2Cj7XjiegMSbp5tFnV0gz4/YZbNh88ybqy4AAtJrQCfaZs
X-Received: by 2002:a05:600c:1d0f:b0:4bb:56bb:1196 with SMTP id 5b1f17b1804b1-4bb7da349e2mr20356845e9.23.1794966172464;
        Tue, 17 Nov 2026 17:42:52 -0800 (PST)
Received: from F7R9GP321C.tail0bfbd.ts.net ([2a02:8108:8388:6600:3844:e3ef:fe85:661a])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb7d2abfc4sm26929965e9.7.2026.11.17.17.42.51
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 17 Nov 2026 17:42:52 -0800 (PST)
From: Gao Xiang <xiang.gao@docker.com>
To: linux-erofs@lists.ozlabs.org
Cc: Wenyuan Xu <sereno.xu@deepseek.com>,
	Gao Xiang <xiang.gao@docker.com>
Subject: [PATCH v2 3/4] erofs-utils: mkfs: add manifest build mode
Date: Wed, 18 Nov 2026 02:42:44 +0100
Message-ID: <20261118014245.67917-3-xiang.gao@docker.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261118014245.67917-1-xiang.gao@docker.com>
References: <20261118014245.67917-1-xiang.gao@docker.com>
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
 include/erofs/manifest.h |  19 ++++
 lib/Makefile.am          |   3 +-
 lib/manifest.c           | 232 +++++++++++++++++++++++++++++++++++++++
 mkfs/main.c              |  40 ++++++-
 4 files changed, 290 insertions(+), 4 deletions(-)
 create mode 100644 include/erofs/manifest.h
 create mode 100644 lib/manifest.c

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
diff --git a/lib/manifest.c b/lib/manifest.c
new file mode 100644
index 0000000..775e462
--- /dev/null
+++ b/lib/manifest.c
@@ -0,0 +1,232 @@
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
+		if (S_ISDIR(d->inode->i_mode))
+			erofs_manifest_drop_children(d->inode);
+		erofs_iput(d->inode);
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
+
+	while ((len = getline(&line, &capacity, fp)) >= 0) {
+		++lineno;
+		if (line[0] == '#')
+			continue;
+		if (memchr(line, '\0', len)) {
+			ret = -EINVAL;
+			break;
+		}
+		if (len && line[len - 1] == '\n')
+			line[--len] = '\0';
+		ret = erofs_manifest_parse_record(im, root, line);
+		if (ret)
+			break;
+	}
+	if (!ret && ferror(fp))
+		ret = -EIO;
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


