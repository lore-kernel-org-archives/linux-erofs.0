Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D78CB606A324
	for <linux-erofs@archiver.kernel.org>; Tue,  3 Nov 2026 00:46:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=docker.com header.i=@docker.com header.a=rsa-sha256 header.s=google header.b=lSDxQduL
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4jJVHc2Q3Cz3c7K;
	Tue, 03 Nov 2026 11:46:04 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2a00:1450:4864:20::32a"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1793666764;
	cv=none; b=QdtJwl5wtIXTyIlBrzW5YG28ulCFEwUlnheVfKiVsyXcFNhpc/+wWEMeNlksGt/NV3DabpikYrlRdqxxgOHdaYIu9ebhk+oJ1gaDgI9RYmlDfYmMskK0tVrMKcw6EF6vDRlb8CxABHLtNslVfqJAAX0sdel5KyEaE169d+YykrYKv1eTzLNeTNwK4LFVBASdrbYIMUbJaVGoeG8ISaXDZyAxG4nqNP1ZzFZlsfcDGP+YlUdyzeNGk2NXgYYBU0wvUTnz6CPTi7KMSpY9YeVSpBSeIct6MDFwg2OjXwB0n7ygOqptB8zZIC+vF+/oh0yqvzNveMs6DOBC+5anYx8s+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1793666764; c=relaxed/relaxed;
	bh=6SnQzLwLKBEf7T8CZvGC0SD+Eiwk9p5lYM14UcSul98=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LCMPJx3zSQwLYWS7IYDTXn75xHpbWnP1vfuvcN1AKRPmFW3icIGc+Kcm73YezpcqhRVq/DgJwAOP34WQy5GEtIT9fsEyA7YZachYgk/FTTB9oIhXvjRfjTwKrWCMeRy2087dRgAeBJkV5lJF3SwiUEriOKdmYCV3RhEK0j9DFHDkcb22V0ohZSHaWgQxXkr00uUo3o1sva5OOV6tufParcjuXwEGL8M5kmM9GYV7amEDbG6p9gjnNQuAx1n4fMhUGDcm61WwdEV6J7ePlNPgaccGWxHEr42Sylwpc+0tr5ThL89jn1RkumQ8ZAyTsFsrNi+c51LIwNJc8vS6qDOcPw==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=docker.com; dkim=pass (2048-bit key; unprotected) header.d=docker.com header.i=@docker.com header.a=rsa-sha256 header.s=google header.b=lSDxQduL; dkim-atps=neutral; spf=pass (client-ip=2a00:1450:4864:20::32a; helo=mail-wm1-x32a.google.com; envelope-from=xiang.gao@docker.com; receiver=lists.ozlabs.org) smtp.mailfrom=docker.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=docker.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=docker.com header.i=@docker.com header.a=rsa-sha256 header.s=google header.b=lSDxQduL;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=docker.com (client-ip=2a00:1450:4864:20::32a; helo=mail-wm1-x32a.google.com; envelope-from=xiang.gao@docker.com; receiver=lists.ozlabs.org)
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4jJVHZ4wv4z3c2V
	for <linux-erofs@lists.ozlabs.org>; Tue, 03 Nov 2026 11:46:02 +1100 (AEDT)
Received: by mail-wm1-x32a.google.com with SMTP id 5b1f17b1804b1-4a215e64962so31909465e9.1
        for <linux-erofs@lists.ozlabs.org>; Mon, 02 Nov 2026 16:46:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=docker.com; s=google; t=1793666759; x=1794271559; darn=lists.ozlabs.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=6SnQzLwLKBEf7T8CZvGC0SD+Eiwk9p5lYM14UcSul98=;
        b=lSDxQduL1ezEzzxKjSvhdx9vlhno6nSy8haOJPKWo+OZj2Azmt1K4Fy5HCXyLVmNPG
         v2YAreomnW8K39PzD755VFioOAh8H5Zv/K6Blr5DqC502fN5pJ9n2d/LKnWszaPBqA2f
         yONfJ46R/Vt6Bvs6SUHSwx+BEDimhuqUvCA+mJyPJfR3rDzPnGNFXM465LMya+MpbP66
         xLmbQmV95YfitZ2AzZU9GlQK/IuLh583Vp2dyIpCNgxlkMukKqyBm20L/5eE7/2sukzJ
         E0FykOMseyhCKnB0qJbFnfGD8Mr4/CKe0OAWW3Erl+6Iycy6B2au2i4ADoeVYddPWIEJ
         GmqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793666759; x=1794271559;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=6SnQzLwLKBEf7T8CZvGC0SD+Eiwk9p5lYM14UcSul98=;
        b=PdsknaNtValPcMRaQftgfvzJLxatApQycKY4qcguSqJJrmOaVcUSEGzkYHPv9PcPHg
         0LKkP5dDmTua5aHQaIikoyuYJSHDAWyvLes0Kx7YLh+JVL+edsFD6UP7C1x1C6SIZl1E
         fLoek4kCLBFcDwRWG3DmlS00A/bGMOrc2SqRlVwePOyEDzcI85p/y7x8XDuKUNOWe4L8
         7VSW8rL0+OjGfDwF8hhoN0Ix6p11ewWsMtPcoEscKZ85aw/GfMP3ILZsH3iezbz8VTbx
         oBPuZl5FSuDfaeKJxsnsjIcGDubkxhK/U47YcB6PpxTG9Pj/a8DzilvnkqfkLIokjozf
         rgWQ==
X-Gm-Message-State: AFq9FYIF118CtJ7I1PrwNYiiU/zVyHZgESMuuHbxPiZ6vb6boR5hqKaT
	76M7IWpEn/mAY9kgQZWK4n8KqSNjE56ruiFSBhLpAugy10eKK2IC8saEdh7Vylh72d7GqG0VsD0
	UmTNGzdg=
X-Gm-Gg: AYBFou2YsQvhHGRaJmVOY6WZYigUtE85YpdZ8822yi17F0E1FeFE462YXM6vPlej2Yw
	GodRY0DKjD/tJxSQA6OUx/7gILjB1kQ1wxVFqZDzVTC8CrX+1Wy/WytNnbjLJGCkv6w9TV2z5n3
	5Bl7CqaP1q/y81bWW4/5S+kuG+e5Z+MUcXA9d1G88ir0I6mx6Bu0Xl4KzWUrTNa9zXW4OEcJaI2
	KJR2l6Odz+d/+oH0qgSR/JtmLFE3sOaZycQ+qCnYJIc9gIL487yOOUT50dW+xvFcQj3WIB0mF2J
	1Y2hdJ5SG7rx9IJVSk4uIBCdixvZ5t1S6JsdB47Xh7/GeclbpvcoNd+ZAvjLokcCEmggJSq1oUI
	41oDH41LunZcjvyEfMhw0luFvubWRENRT2xf7doXchP5R3uMw5smp9enRYfFNqK4M1U6FjyIe40
	TmbLAuqkJ2GCxCdvTAD2zH/ia3XccNTzqKHt8stmu96kCdF7BkMY/HXbiBwX96kZn1UNK+vcneB
	qxD+atuOPBN3zSubid5K9nCKQoCj4gz72JNPcssN8fSBZLYbrzYondjjo9KtSu/I5/OtOMCV4qZ
	/i6iLphgx3ebIH4Tp7naP8b7CoCW7nFvq1UtU38VmBqusVzNEsYneJoLDzedXvcpi8yE
X-Received: by 2002:a05:600c:34d4:b0:4a2:d7e:5ccb with SMTP id 5b1f17b1804b1-4ac182dca99mr292124195e9.15.1793666759450;
        Mon, 02 Nov 2026 16:45:59 -0800 (PST)
Received: from F7R9GP321C.fritz.box ([2a02:8108:8388:6600:3c00:331c:b5fa:ff22])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4b2a555e59dsm22078585e9.0.2026.11.02.16.45.57
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 02 Nov 2026 16:45:59 -0800 (PST)
From: Gao Xiang <xiang.gao@docker.com>
To: linux-erofs@lists.ozlabs.org
Cc: Gao Xiang <xiang.gao@docker.com>
Subject: [PATCH 5/5] erofs-utils: lib: reject seeks on Windows pipes
Date: Tue,  3 Nov 2026 01:45:47 +0100
Message-ID: <20261103004547.15053-5-xiang.gao@docker.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261103004547.15053-1-xiang.gao@docker.com>
References: <20261103004547.15053-1-xiang.gao@docker.com>
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
X-Spam-Status: No, score=-23.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=4.0.1
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

The Windows CRT can report successful seeks on pipes without
advancing the read position. This makes TAR input appear seekable
and corrupts parsing when skipped data is not consumed.

Adapt erofs_os_lseek() to return ESPIPE for Windows pipes and use
it throughout the library and tools. This keeps pipe input on the
read-and-discard path.

https://github.com/erofs/go-erofs/blob/main/.github/workflows/patches/erofs-utils/003-windows-pipe-lseek.patch

Assisted-by: ChatGPT:gpt-6.1-sol
Signed-off-by: Gao Xiang <xiang.gao@docker.com>
---
 fsck/main.c                    |  2 +-
 include/erofs/os.h             |  1 +
 include/erofs/windows_compat.h |  1 +
 lib/blobchunk.c                |  6 +++---
 lib/fragments.c                |  2 +-
 lib/inode.c                    |  8 ++++----
 lib/io.c                       |  4 ++--
 lib/remotes/oci.c              |  2 +-
 lib/tar.c                      |  4 ++--
 lib/windows_compat.c           | 14 ++++++++++++++
 lib/xattr.c                    |  4 ++--
 11 files changed, 32 insertions(+), 16 deletions(-)

diff --git a/fsck/main.c b/fsck/main.c
index 4e270a6..8e3ae52 100644
--- a/fsck/main.c
+++ b/fsck/main.c
@@ -571,7 +571,7 @@ static int erofs_verify_inode_data(struct erofs_inode *inode, int outfd,
 				}
 			}
 			if (outfd >= 0) {
-				if (lseek(outfd, map.m_llen, SEEK_CUR) < 0) {
+				if (erofs_os_lseek(outfd, map.m_llen, SEEK_CUR) < 0) {
 					ret = -errno;
 					goto out;
 				}
diff --git a/include/erofs/os.h b/include/erofs/os.h
index 0725239..82e0c5e 100644
--- a/include/erofs/os.h
+++ b/include/erofs/os.h
@@ -33,6 +33,7 @@ typedef struct stat erofs_os_stat_t;
 #define erofs_os_fstat		fstat
 #define erofs_os_open		open
 #define erofs_os_link		link
+#define erofs_os_lseek		lseek
 #define erofs_os_pread		pread
 #define erofs_os_pwrite		pwrite
 #define erofs_os_realpath	realpath
diff --git a/include/erofs/windows_compat.h b/include/erofs/windows_compat.h
index ce16f23..c850b3d 100644
--- a/include/erofs/windows_compat.h
+++ b/include/erofs/windows_compat.h
@@ -82,6 +82,7 @@ int erofs_os_lstat(const char *path, erofs_os_stat_t *st);
 int erofs_os_fstat(int fd, erofs_os_stat_t *st);
 int erofs_os_open(const char *path, int flags, ...);
 int erofs_os_link(const char *oldpath, const char *newpath);
+off_t erofs_os_lseek(int fd, off_t offset, int whence);
 ssize_t erofs_os_pread(int fd, void *buf, size_t len, off_t offset);
 ssize_t erofs_os_pwrite(int fd, const void *buf, size_t len, off_t offset);
 char *erofs_os_realpath(const char *path, char *resolved);
diff --git a/lib/blobchunk.c b/lib/blobchunk.c
index e985215..8217512 100644
--- a/lib/blobchunk.c
+++ b/lib/blobchunk.c
@@ -336,7 +336,7 @@ int erofs_blob_write_chunked_file(struct erofs_inode *inode, int fd,
 	ssize_t ret;
 
 	/* if the file is fully sparsed, use one big chunk instead */
-	if (lseek(fd, startoff, SEEK_DATA) < 0 && errno == ENXIO) {
+	if (erofs_os_lseek(fd, startoff, SEEK_DATA) < 0 && errno == ENXIO) {
 		chunkbits = ilog2(inode->i_size - 1) + 1;
 		if (chunkbits < sbi->blkszbits)
 			chunkbits = sbi->blkszbits;
@@ -369,14 +369,14 @@ int erofs_blob_write_chunked_file(struct erofs_inode *inode, int fd,
 	interval_start = 0;
 
 	for (pos = 0; pos < inode->i_size; pos += len) {
-		off_t offset = lseek(fd, pos + startoff, SEEK_DATA);
+		off_t offset = erofs_os_lseek(fd, pos + startoff, SEEK_DATA);
 
 		if (offset >= 0 && offset < startoff + inode->i_size) {
 			offset -= startoff;
 
 			if (offset != (offset & ~(chunksize - 1))) {
 				offset &= ~(chunksize - 1);
-				if (lseek(fd, offset + startoff, SEEK_SET) !=
+				if (erofs_os_lseek(fd, offset + startoff, SEEK_SET) !=
 					  startoff + offset) {
 					ret = -EIO;
 					goto err;
diff --git a/lib/fragments.c b/lib/fragments.c
index 637b1f6..61577d2 100644
--- a/lib/fragments.c
+++ b/lib/fragments.c
@@ -266,7 +266,7 @@ int erofs_pack_file_from_fd(struct erofs_inode *inode,
 		off_t pos = fpos;
 
 		memblock = NULL;
-		rc = lseek(epi->fd, offset, SEEK_SET);
+		rc = erofs_os_lseek(epi->fd, offset, SEEK_SET);
 		if (rc < 0) {
 			rc = -errno;
 			goto out;
diff --git a/lib/inode.c b/lib/inode.c
index b1f5b97..177d106 100644
--- a/lib/inode.c
+++ b/lib/inode.c
@@ -1525,7 +1525,7 @@ static int erofs_mkfs_job_write_file(const struct erofs_mkfs_btctx *btctx,
 	int ret;
 
 	if (inode->datasource == EROFS_INODE_DATA_SOURCE_DISKBUF &&
-	    lseek(ctx->fd, ctx->fpos, SEEK_SET) < 0) {
+	    erofs_os_lseek(ctx->fd, ctx->fpos, SEEK_SET) < 0) {
 		ret = -errno;
 		goto out;
 	}
@@ -1534,7 +1534,7 @@ static int erofs_mkfs_job_write_file(const struct erofs_mkfs_btctx *btctx,
 		ret = erofs_write_compressed_file(ctx->ictx);
 		if (ret != EROFS_RETVAL_FALLBACK)
 			goto out;
-		if (lseek(ctx->fd, ctx->fpos, SEEK_SET) < 0) {
+		if (erofs_os_lseek(ctx->fd, ctx->fpos, SEEK_SET) < 0) {
 			ret = -errno;
 			goto out;
 		}
@@ -2393,7 +2393,7 @@ struct erofs_inode *erofs_mkfs_build_special_from_fd(struct erofs_importer *im,
 	void *ictx;
 	int ret;
 
-	ret = lseek(fd, 0, SEEK_SET);
+	ret = erofs_os_lseek(fd, 0, SEEK_SET);
 	if (ret < 0)
 		return ERR_PTR(-errno);
 
@@ -2432,7 +2432,7 @@ struct erofs_inode *erofs_mkfs_build_special_from_fd(struct erofs_importer *im,
 		if (ret != EROFS_RETVAL_FALLBACK)
 			 return ERR_PTR(ret);
 
-		ret = lseek(fd, 0, SEEK_SET);
+		ret = erofs_os_lseek(fd, 0, SEEK_SET);
 		if (ret < 0)
 			return ERR_PTR(-errno);
 	}
diff --git a/lib/io.c b/lib/io.c
index ccec1fd..35da5bd 100644
--- a/lib/io.c
+++ b/lib/io.c
@@ -567,7 +567,7 @@ off_t erofs_io_lseek(struct erofs_vfile *vf, u64 offset, int whence)
 	if (vf->ops)
 		return vf->ops->lseek(vf, offset, whence);
 
-	ret = lseek(vf->fd, offset, whence);
+	ret = erofs_os_lseek(vf->fd, offset, whence);
 	return ret < 0 ? -errno : ret;
 }
 
@@ -643,7 +643,7 @@ int erofs_io_xcopy(struct erofs_vfile *vout, off_t pos,
 #endif
 #if defined(HAVE_SYS_SENDFILE_H) && defined(HAVE_SENDFILE)
 		if (len && !noseek) {
-			ret = lseek(vout->fd, pos, SEEK_SET);
+			ret = erofs_os_lseek(vout->fd, pos, SEEK_SET);
 			if (ret == pos) {
 				ret = sendfile(vout->fd, vin->fd, NULL, len);
 				if (ret > 0) {
diff --git a/lib/remotes/oci.c b/lib/remotes/oci.c
index e485c48..3243ccc 100644
--- a/lib/remotes/oci.c
+++ b/lib/remotes/oci.c
@@ -1271,7 +1271,7 @@ static int ocierofs_extract_layer(struct ocierofs_ctx *ctx,
 	if (ret)
 		goto out;
 
-	if (lseek(stream.blobfd, 0, SEEK_SET) < 0) {
+	if (erofs_os_lseek(stream.blobfd, 0, SEEK_SET) < 0) {
 		erofs_err("failed to seek to beginning of temp file: %s",
 			  strerror(errno));
 		ret = -errno;
diff --git a/lib/tar.c b/lib/tar.c
index 75a5752..72d867c 100644
--- a/lib/tar.c
+++ b/lib/tar.c
@@ -123,13 +123,13 @@ int erofs_iostream_open(struct erofs_iostream *ios, int fd, int decoder)
 			return PTR_ERR(ios->gb);
 	} else {
 		ios->vf.fd = fd;
-		fsz = lseek(fd, 0, SEEK_END);
+		fsz = erofs_os_lseek(fd, 0, SEEK_END);
 		if (fsz <= 0) {
 			ios->feof = !fsz;
 			ios->sz = 0;
 		} else {
 			ios->sz = fsz;
-			if (lseek(fd, 0, SEEK_SET))
+			if (erofs_os_lseek(fd, 0, SEEK_SET))
 				return -EIO;
 #ifdef HAVE_POSIX_FADVISE
 			if (posix_fadvise(fd, 0, 0, POSIX_FADV_SEQUENTIAL))
diff --git a/lib/windows_compat.c b/lib/windows_compat.c
index f998f21..1582fd3 100644
--- a/lib/windows_compat.c
+++ b/lib/windows_compat.c
@@ -186,6 +186,20 @@ int erofs_os_link(const char *oldpath, const char *newpath)
 	return -1;
 }
 
+off_t erofs_os_lseek(int fd, off_t offset, int whence)
+{
+	HANDLE h = (HANDLE)_get_osfhandle(fd);
+
+	if (h == INVALID_HANDLE_VALUE)
+		return -1;
+	/* The CRT can report a successful seek on a pipe without moving it. */
+	if (GetFileType(h) == FILE_TYPE_PIPE) {
+		errno = ESPIPE;
+		return -1;
+	}
+	return _lseeki64(fd, offset, whence);
+}
+
 static ssize_t erofs_win_pio(int fd, void *buf, size_t len, off_t offset,
 			    int writing)
 {
diff --git a/lib/xattr.c b/lib/xattr.c
index 4b68a61..93cfead 100644
--- a/lib/xattr.c
+++ b/lib/xattr.c
@@ -899,7 +899,7 @@ int erofs_xattr_flush_name_prefixes(struct erofs_importer *im, bool plain)
 			erofs_sb_set_fragments(sbi);
 			_vf = (struct erofs_vfile){ .fd = erofs_packedfile(sbi) };
 			vf = &_vf;
-			offset = lseek(vf->fd, 0, SEEK_CUR);
+			offset = erofs_os_lseek(vf->fd, 0, SEEK_CUR);
 			if (offset < 0)
 				return -errno;
 			bmgr = NULL;
@@ -960,7 +960,7 @@ int erofs_xattr_flush_name_prefixes(struct erofs_importer *im, bool plain)
 		erofs_bdrop(bh, false);
 	} else {
 		DBG_BUGON(bmgr);
-		if (lseek(vf->fd, offset, SEEK_SET) < 0)
+		if (erofs_os_lseek(vf->fd, offset, SEEK_SET) < 0)
 			return -errno;
 	}
 	erofs_sb_set_xattr_prefixes(sbi);
-- 
2.54.0 (Apple Git-157)


