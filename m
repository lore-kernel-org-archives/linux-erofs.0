Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01F48606D4C5
	for <linux-erofs@archiver.kernel.org>; Wed,  4 Nov 2026 21:05:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=docker.com header.i=@docker.com header.a=rsa-sha256 header.s=google header.b=H7u+2pn2
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4jKdHw0nYtz2xSR;
	Thu, 05 Nov 2026 08:05:16 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2a00:1450:4864:20::435"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1793826316;
	cv=none; b=nEblXzLMBJzxXoPKrh7chIix4So3EnpLtD6L1qjUJhcUp6ZOPTdY5vnXRpbyJ8DUSmQ2CBjTGgX5EALkD1aS2uew71862BG2WNA43LImLXRmjMcOO9WpV0C3/2R6vuJfhv+K604fCyYikagCp/RsLFpXflZXxhAClf3cYbs554Zy/OV4tDoE4CU33g4QbLTNmwajWME4Z/hLyHcKF8g6i+BJnG4CgyUWMkZobAjJgG8hrYUkcqjunJkc3uVk4koTU6JkkYm26YIgkEj6/sZRICl6RrTYVOHiKsdgbtI2BdpfQQg1kfdVoppZ+4fnUUGswO3op8+F8GpkgtMHKRgB/A==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1793826316; c=relaxed/relaxed;
	bh=BfohedrRRY/nU8oAj1rgWtqVlSjG8VPTI81s0s5Z0rQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=PulWnNy42O4V49fb3+qfzR7w9qdsDc17x3vtxhQhUZnKu64keJVIoYz/EnZHSKWQ+nV5okJbyXculG/eozRUArrZkHSlK25Qr940ePKo9vrftPv9yPqRjX+0/8Tj7YKFrL6qhaeAl/yZ0bWo20rB2WIb2R/H7N1Hug+mpmNFUlQ6tbFn6Di8OeQmDMnLsl28UFzA7u73y/lXr0ZpUzUBeEbcHpm03VZcdNZQwXovhrE9B1fnTf3xfIk9snJTxF0E7W8zAdzhBaVHHwptGZ3Blh6iqDGYK6UVAFa5os29/fcoMVXVc86EtSPO5vi7ORvCiZIc+/TEQAV3PjzrLKmW3g==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=docker.com; dkim=pass (2048-bit key; unprotected) header.d=docker.com header.i=@docker.com header.a=rsa-sha256 header.s=google header.b=H7u+2pn2; dkim-atps=neutral; spf=pass (client-ip=2a00:1450:4864:20::435; helo=mail-wr1-x435.google.com; envelope-from=xiang.gao@docker.com; receiver=lists.ozlabs.org) smtp.mailfrom=docker.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=docker.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=docker.com header.i=@docker.com header.a=rsa-sha256 header.s=google header.b=H7u+2pn2;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=docker.com (client-ip=2a00:1450:4864:20::435; helo=mail-wr1-x435.google.com; envelope-from=xiang.gao@docker.com; receiver=lists.ozlabs.org)
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4jKdHt1Dqtz2xRv
	for <linux-erofs@lists.ozlabs.org>; Thu, 05 Nov 2026 08:05:12 +1100 (AEDT)
Received: by mail-wr1-x435.google.com with SMTP id ffacd0b85a97d-48fd2e38825so817401f8f.2
        for <linux-erofs@lists.ozlabs.org>; Wed, 04 Nov 2026 13:05:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=docker.com; s=google; t=1793826309; x=1794431109; darn=lists.ozlabs.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=BfohedrRRY/nU8oAj1rgWtqVlSjG8VPTI81s0s5Z0rQ=;
        b=H7u+2pn2rvIKXJWGUjGnzUCf7sReNEP2vsOCD0rJppUPrvNzkMVX9WfwhqiYzGlptm
         ATdDjMFkFEZah9KWxXMlIMFlTPTsiyqTCQDXG8G22z4CVfanB9MPMdX3lOQY+at8N9Vp
         QB7plqG7RpdcvswJa53f+08QRpef3+jahgKNPmYpN5njMP2wR7BpHrUDbaqufvDJDwCN
         HFaQT5xzyQrgWKU72thXvZp4NTmlACSfmu0uB3uYER9XIGOq/F/7MJdn1QlfKZ4OlJ0R
         5nyTKdLi9xlgJ3DwG3ljdO+GoL5PCoTbqBa2igEalP2T+TyLwFNnHrAfR5/TrkulNp+F
         S3Yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793826309; x=1794431109;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=BfohedrRRY/nU8oAj1rgWtqVlSjG8VPTI81s0s5Z0rQ=;
        b=ubcs4TJ+fP94moqxYI7s9CmH4s6HVQeuYOJsFos9N5Qr6hW5oCGbdOb/3E+jH+GDpr
         xy0nhE/IgfGWZ7vqkm9WUTjUYDiPQ7oNUjVPGhe+o8UblBzp/ibtAz5CNFyTWHCRgPJF
         atmTCngAhhunU7W6Nn813dRcoNO0bOAemp/9V20QqWSKpSLrnuszdVqi9Ch4yRsf+BWz
         j/bqJh2rg2AgpkF1Q9x2DEeXJfrYW5I2w3tA4nWlu1G6pDeDgtDcpScL9c9ZLfyOmVT3
         FBIjX0KgH4ZVQb8HAW5MzUkCXboFnqOq/uMsak0dH2r4tInajvYKYJvftncrEpj8ZQuX
         AAcw==
X-Gm-Message-State: APuU4Z/JJSTw4rnydBcjR3WsE8eOrpPLYJMrYmh+9GubcQY35ffch3wh
	bN5B8DQ4h4kaQqvKPmUTwekuzifoa9U4EAMuE3Z93wtBkZIGEPsaM5HSXrWAC9n6OyOnePhn9/X
	BdQ1lSlM=
X-Gm-Gg: AYBFou0X8S7pdrp0IxQmb59iOO2o6yqh/9N0AoQl75j3j7VkWVbEX993VxJPrLuDAZy
	G9UwKT+2XbMkgyTh1hrSyRSN+OBEvyq3aHN2+H4JJAnzX+hRU0gCDzp6fZsKlm4vQMSpBJBYFX3
	i69bmEp4G2aLVV2rLRZP29J5bfkvyFqt6eGVddNiFSMev01W/Avuk2ZlzXAwO9dCpHiYaavASn5
	UYRYgjgQwcWI50B1zs2UHFYOGKP94oGTKb9Fwir1vswBmyPdkEoBCfi0NBs5Iqm2I4y1aCl7TOP
	WSrVbd9uAy2rvb+psNKkCWJEikhSdU5qgrkCUCRBNinjqVdYA0dWR+Pt9UtzIU5YSV/G1g/xTcb
	+M7sbA8cqeS3ZUNbOKtGAVjesqDgq73ubY0B+KeL3Kb4HXjGq1w+SMIXJmz2kFyK3W9caik3ROf
	cHM5vm9JEIHUrmJTDlATxcbSDPgOTm1GYvRZiu8QArpTBq1DxL32Hd9I+3AM7BEMindO7Jarlai
	y+dVA3akRJ1gfSadnksrdN0RDab7FJcVr0tEiGP5DtdVvFaQE15DqXKQJn7QMVbmChO3X0pRP9K
	KM57NwgdKdjNGWKZ9XV01EgBU7EO4HOJtw/lSxnvFB0OvuHkd4rrF5qRTmLMUxdjFKK1JArfpXH
	g3DYP5ezGxWNv
X-Received: by 2002:a05:6000:4712:b0:491:4e13:fdd7 with SMTP id ffacd0b85a97d-4914e140631mr136119f8f.6.1793826309555;
        Wed, 04 Nov 2026 13:05:09 -0800 (PST)
Received: from F7R9GP321C.fritz.box ([2a02:8108:8388:6600:8992:1f57:3c9d:21f])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48feda20935sm5629579f8f.54.2026.11.04.13.05.07
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 04 Nov 2026 13:05:08 -0800 (PST)
From: Gao Xiang <xiang.gao@docker.com>
To: linux-erofs@lists.ozlabs.org
Cc: Gao Xiang <xiang.gao@docker.com>
Subject: [PATCH] erofs-utils: lib: create Windows temporary files atomically
Date: Wed,  4 Nov 2026 22:05:04 +0100
Message-ID: <20261104210504.57739-1-xiang.gao@docker.com>
X-Mailer: git-send-email 2.54.0
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

GetTempFileNameA() creates and closes a file before it is reopened
with FILE_FLAG_DELETE_ON_CLOSE. Exiting between these calls leaves
the temporary file behind.

Use CREATE_NEW with FILE_FLAG_DELETE_ON_CLOSE to create temporary
files with cleanup enabled from the start. Generate random names
and retry collisions without opening existing files.

Also honor TMPDIR and preserve errors on descriptor allocation failure.
Since erofs_os_tmpfile() returns negative errors directly, propagate
its return value in the OCI caller rather than relying on errno.

Fixes: f9ceb52fa646 ("erofs-utils: add native Windows support")
Signed-off-by: Gao Xiang <xiang.gao@docker.com>
---
 lib/remotes/oci.c    |  8 ++++--
 lib/windows_compat.c | 67 +++++++++++++++++++++++++++-----------------
 2 files changed, 47 insertions(+), 28 deletions(-)

diff --git a/lib/remotes/oci.c b/lib/remotes/oci.c
index 3243ccc..948d699 100644
--- a/lib/remotes/oci.c
+++ b/lib/remotes/oci.c
@@ -1260,12 +1260,14 @@ static int ocierofs_extract_layer(struct ocierofs_ctx *ctx,
 
 	stream = (struct ocierofs_stream) {
 		.digest = digest,
-		.blobfd = erofs_os_tmpfile(),
 	};
-	if (stream.blobfd < 0) {
+
+	ret = erofs_os_tmpfile();
+	if (ret < 0) {
 		erofs_err("failed to create temporary file for %s", digest);
-		return -errno;
+		return ret;
 	}
+	stream.blobfd = ret;
 
 	ret = ocierofs_download_blob_to_fd(ctx, digest, auth_header, stream.blobfd);
 	if (ret)
diff --git a/lib/windows_compat.c b/lib/windows_compat.c
index 1582fd3..d5e3fb3 100644
--- a/lib/windows_compat.c
+++ b/lib/windows_compat.c
@@ -277,38 +277,55 @@ int erofs_win_random(void *buf, unsigned int len)
 int erofs_os_tmpfile(void)
 {
 	char path[MAX_PATH], name[MAX_PATH];
-	HANDLE h;
-	DWORD len;
+	const char *tmpdir, *sep = "";
+	HANDLE h = INVALID_HANDLE_VALUE;
+	unsigned int retries;
 	int fd;
 
-	len = GetTempPathA(sizeof(path), path);
-	if (!len) {
-		errno = erofs_err_win_to_posix(GetLastError());
-		return -errno;
+	tmpdir = getenv("TMPDIR");
+	if (tmpdir && *tmpdir) {
+		/* A trailing backslash may be part of a multibyte character. */
+		sep = "/";
+	} else {
+		DWORD len = GetTempPathA(sizeof(path), path);
+
+		if (!len)
+			return -erofs_err_win_to_posix(GetLastError());
+		if (len >= sizeof(path))
+			return -ENAMETOOLONG;
+		tmpdir = path;
 	}
-	if (len >= sizeof(path)) {
-		errno = ENAMETOOLONG;
-		return -errno;
-	}
-	if (!GetTempFileNameA(path, "ero", 0, name)) {
-		errno = erofs_err_win_to_posix(GetLastError());
-		return -errno;
-	}
-	h = CreateFileA(name, GENERIC_READ | GENERIC_WRITE,
-		FILE_SHARE_READ | FILE_SHARE_WRITE | FILE_SHARE_DELETE, NULL,
-		OPEN_EXISTING, FILE_ATTRIBUTE_TEMPORARY |
-		FILE_FLAG_DELETE_ON_CLOSE, NULL);
-	if (h == INVALID_HANDLE_VALUE) {
-		DWORD error = GetLastError();
-
-		DeleteFileA(name);
-		errno = erofs_err_win_to_posix(error);
-		return -errno;
+	/* Arm cleanup when creating the file, with no close-and-reopen gap. */
+	for (retries = 128; retries; --retries) {
+		unsigned int nonce[2];
+		DWORD error;
+		int n;
+
+		if (erofs_win_random(nonce, sizeof(nonce)) < 0)
+			return -errno;
+		n = snprintf(name, sizeof(name), "%s%sEROFS_%08x%08x.TMP",
+			     tmpdir, sep, nonce[0], nonce[1]);
+		if (n < 0 || (size_t)n >= sizeof(name))
+			return -ENAMETOOLONG;
+		h = CreateFileA(name, GENERIC_READ | GENERIC_WRITE,
+			FILE_SHARE_READ | FILE_SHARE_WRITE | FILE_SHARE_DELETE,
+			NULL, CREATE_NEW, FILE_ATTRIBUTE_TEMPORARY |
+			FILE_FLAG_DELETE_ON_CLOSE, NULL);
+		if (h != INVALID_HANDLE_VALUE)
+			break;
+		error = GetLastError();
+		if (error == ERROR_FILE_EXISTS || error == ERROR_ALREADY_EXISTS)
+			continue;
+		return -erofs_err_win_to_posix(error);
 	}
+	if (h == INVALID_HANDLE_VALUE)
+		return -EEXIST;
 	fd = _open_osfhandle((intptr_t)h, O_RDWR | O_BINARY);
 	if (fd < 0) {
+		int err = -errno;
+
 		CloseHandle(h);
-		return -errno;
+		return err;
 	}
 	return fd;
 }
-- 
2.54.0 (Apple Git-157)


