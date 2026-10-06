Return-Path: <linux-erofs+bounces-4663-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DEB60CA5FED
	for <linux-erofs@archiver.kernel.org>; Tue,  6 Oct 2026 18:04:54 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hzkg86bmxz30P3;
	Wed, 07 Oct 2026 05:04:52 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=172.234.252.31
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1791309892;
	cv=none; b=cHSkMDfSmrsmGp5SvcUTy7Bd2vfZc6K/3Kludx2Z+c0tKTEO2tFZhu57s2iEfAc40H+IZgOWNVCMb2yYHI4VH/oU1WPw/meslBy/6LVi3HPQOpSrt1F4ycFy5Y1WI1v0ka9l5V/IoqUAwEyVXJGuPJxn+uQWUzrDRi4FIStX+f4odQZ2u7TluVuk4Nacoky7mzJJiSkkc6DwegtlfZoJ4AGdhtgNq+mrJLov3Ej6ZgG/FFqTHzvnpX97qPS01h7RdkDmSLoBHPEfwmZ+ACsCWHIrfBP1xKVzcAMTjVq1z2A7XxZ+A8B7Awqhb0FHVom3AhiiKfuHNDkOcefePF9ZDQ==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1791309892; c=relaxed/relaxed;
	bh=0sh7Afdkimw+1SFan23EfHEi03FZ0absjjJSw4jagXA=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=LFxcU2GVFYX+5d47lGCpUwUMkSJEgLSqoKWgX6M+NsqnJgsZn6ls37GWN0m3w1ednKQl9mfkQqIhuCdybW2/PPsADZO+dpHIOxlzqsO4P79e8DRieZluqdb+uKrxsUDwxdLJvtA8bVqGkTjK8CC95riIe/LBpCnbqTcl8cd36/leCc0Uvg8RqQEp35cQoHrBG7IAX6XakWzxVot2oC4GF9LBcREtKTQq3NOxdC32DP0ejys3uyvUImrc457jGegCYG+QPNlRm5FwzDHCgo2Okil58q4IXwViHS1kutpd1pAZ33vIvpc5MEiOedXc7raNBUkSuNdKkz2cnnbUNJzBdw==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20201202 header.b=kzC5ZKb3; dkim-atps=neutral; spf=pass (client-ip=172.234.252.31; helo=sea.source.kernel.org; envelope-from=devnull+sadmanf.meta.com@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20201202 header.b=kzC5ZKb3;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=172.234.252.31; helo=sea.source.kernel.org; envelope-from=devnull+sadmanf.meta.com@kernel.org; receiver=lists.ozlabs.org)
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hzkg75ZPlz2yd7
	for <linux-erofs@lists.ozlabs.org>; Wed, 07 Oct 2026 05:04:51 +1100 (AEDT)
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 66DFA43807;
	Tue,  6 Oct 2026 18:04:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 4AD28C4AF61;
	Tue,  6 Oct 2026 18:04:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1791309889;
	bh=5dWmhsjKLtpt4KslgMrptsx/ORVW/+WDdlyNQeOmRPc=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=kzC5ZKb3o2qi3Z3osLnsoo1t7CeSE2He9K4Hw7g4t1i80ez48ISr1F82CnKLYGOe8
	 CHrEp8/y/bM1rRegi4omZBaWTtTYyLYh8LPAu0Ka2lsYFnroBymQJlwx9ec3c0TZKl
	 qj9n1VZyxI8JCT9gmtsUXhq+HuzR+MfkLfPbyvS4y75jXLCn1kdumSTSf8+1qdyWIc
	 WAMRdu3NAmasvpUMaS6nu3lZXnQkwtKF8sazxSJ3lzGP6ZyFUg3eWNfQQcihYgXyPL
	 MvU/3OC3+5o+j0rxX8HnY4FD/Tml9/thGC85KyhYXYUIz6mr9CDsYWOJu3/xf2wvlF
	 U0m8RG7P+S0YA==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34B50CA5FED;
	Tue,  6 Oct 2026 18:04:49 +0000 (UTC)
From: Sadman Fahmid via B4 Relay <devnull+sadmanf.meta.com@kernel.org>
Date: Tue, 06 Oct 2026 14:04:47 -0400
Subject: [PATCH RESEND 1/2] erofs-utils: lib: fail instead of hanging on
 short reads in erofs_io_xcopy()
X-Mailing-List: linux-erofs@lists.ozlabs.org
List-Id: <linux-erofs.lists.ozlabs.org>
List-Help: <mailto:linux-erofs+help@lists.ozlabs.org>
List-Owner: <mailto:linux-erofs+owner@lists.ozlabs.org>
List-Post: <mailto:linux-erofs@lists.ozlabs.org>
List-Subscribe: <mailto:linux-erofs+subscribe@lists.ozlabs.org>,
  <mailto:linux-erofs+subscribe-digest@lists.ozlabs.org>,
  <mailto:linux-erofs+subscribe-nomail@lists.ozlabs.org>
List-Unsubscribe: <mailto:linux-erofs+unsubscribe@lists.ozlabs.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261006-round1-v1-1-f46b13e11de5@meta.com>
References: <20261006-round1-v1-0-f46b13e11de5@meta.com>
In-Reply-To: <20261006-round1-v1-0-f46b13e11de5@meta.com>
To: linux-erofs@lists.ozlabs.org
Cc: Gao Xiang <xiang@kernel.org>, Chao Yu <chao@kernel.org>, 
 Sadman Fahmid <sadmanf@meta.com>
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1791309888; l=2316;
 i=sadmanf@meta.com; s=20261006; h=from:subject:message-id;
 bh=MG1JVt9vDkGzgmziW91mbF0J45QsL9V9glXUQlVfwfM=;
 b=+Wk7c3nEWhH4GDZ3jTCS4POAXfxBn7Nh9hao7gxPKCKKLIA0VMg8IkfwmGvJxJqYPOGnE6Cw+
 XRcLZ8lGYj9CidHfB4Fb/mEsAFuyC8Abj9Hk6XWitiEE+txhZUY/FFt
X-Developer-Key: i=sadmanf@meta.com; a=ed25519;
 pk=Pc/arXJpm1RPef8qImFuHROn1p3XNX5MWSUxjZWNTa4=
X-Endpoint-Received: by B4 Relay for sadmanf@meta.com/20261006 with
 auth_id=1125
X-Original-From: Sadman Fahmid <sadmanf@meta.com>
Reply-To: sadmanf@meta.com

From: Sadman Fahmid <sadmanf@meta.com>

erofs_io_xcopy() falls back to a read/pwrite loop for whatever
copy_file_range() and sendfile() did not copy.  If the source reaches
EOF before `len` bytes have been copied, erofs_io_read() returns 0,
`len` never shrinks and mkfs spins forever instead of reporting the
error.

This is easy to hit with a damaged source, e.g. rebuilding with
`mkfs.erofs --clean=data out.img src.img` where src.img is truncated
in the middle of a file's data, or when a source file shrinks while
mkfs runs.  Return -EIO instead.

While at it, keep calling copy_file_range() until it has copied the
whole range or fails.  A single call may copy less than requested
(e.g. the kernel caps each call at MAX_RW_COUNT, just under 2 GiB,
while callers pass chunks of up to 4 GiB), and the remainder was
previously copied by sendfile() instead of being reflinked.

Signed-off-by: Sadman Fahmid <sadmanf@meta.com>
---
 lib/io.c | 29 ++++++++++++++++-------------
 1 file changed, 16 insertions(+), 13 deletions(-)

diff --git a/lib/io.c b/lib/io.c
index 5c5449f..038fa51 100644
--- a/lib/io.c
+++ b/lib/io.c
@@ -642,9 +642,13 @@ int erofs_io_xcopy(struct erofs_vfile *vout, off_t pos,
 		off_t ret __maybe_unused;
 
 #ifdef HAVE_COPY_FILE_RANGE
-		ret = copy_file_range(vin->fd, NULL, vout->fd, &pos, len, 0);
-		if (ret > 0)
+		while (len) {
+			ret = copy_file_range(vin->fd, NULL, vout->fd, &pos,
+					      len, 0);
+			if (ret <= 0)
+				break;
 			len -= ret;
+		}
 #endif
 #if defined(HAVE_SYS_SENDFILE_H) && defined(HAVE_SENDFILE)
 		if (len && !noseek) {
@@ -660,21 +664,20 @@ int erofs_io_xcopy(struct erofs_vfile *vout, off_t pos,
 #endif
 	}
 
-	do {
+	while (len) {
 		char buf[32768];
-		int ret = min_t(unsigned int, len, sizeof(buf));
+		ssize_t nread, ret;
 
-		ret = erofs_io_read(vin, buf, ret);
+		nread = erofs_io_read(vin, buf, min_t(unsigned int, len,
+						      sizeof(buf)));
+		if (nread <= 0)
+			return nread < 0 ? nread : -EIO;
+		ret = erofs_io_pwrite(vout, buf, pos, nread);
 		if (ret < 0)
 			return ret;
-		if (ret > 0) {
-			ret = erofs_io_pwrite(vout, buf, pos, ret);
-			if (ret < 0)
-				return ret;
-			pos += ret;
-		}
-		len -= ret;
-	} while (len);
+		pos += nread;
+		len -= nread;
+	}
 	return 0;
 }
 

-- 
2.53.0-Meta



