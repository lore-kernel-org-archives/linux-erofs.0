Return-Path: <linux-erofs+bounces-4675-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 20BA8CA6002
	for <linux-erofs@archiver.kernel.org>; Wed,  7 Oct 2026 20:15:53 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4j0PWq3Jl6z30Tf;
	Thu, 08 Oct 2026 07:15:51 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2600:3c04:e001:324:0:1991:8:25"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1791404151;
	cv=none; b=DLWpJ6pU5A/YKJYMiIwJMFK5bRTc3moOxB4XlkwQHiiYTi7lluYb+pYF0JI8mXL91Z5YvSU7wnbF6iZhLuFNOB+vmTXy+5dymjvE8Yio9mQ+qM7O6a0+RlZMgd/cMBejpCarUpicozOI3jrE0zHLznBnzn9scAnmjfMk7B50ILzCbLTusEzbK1oUSwRgtT+i8yT6YRNVY8+L9mLXitlfVG5j2oCQ3rx33hq1gZB/dTIefiy2x3hNCHFeI3cfHE2pvY41qZmsrTMlulF4Vw/t1QDNZaDTVZUNRR7n14rmY4WxuPNREemxxB87K02fA8o+QTGahPeVUEgi1Ujed7oG6g==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1791404151; c=relaxed/relaxed;
	bh=qKs64xtmOKP8DA86oeWCetpjtn9GhO1kQ50FOWAwO/M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KeW3oV2QMgzYWM5E5nKF9ZYUFrvMrocrWX+vimQXHvFYqMNGMC5NQEYjNs2ji4ifem5VJHjwG5Uflx0uBO7naQ2BcgxPZcJVF7qtRrZbBgB97C7elP3d8kF5f1W7kLAP7rjHDuJNYew1L2Obf96zDKAAVq2ZKNjVWX8jwPKs7xEEgNYfljq7XrVhYE2Vb03UT7206F5DrS9SvKDilgx7N/QVMbLfyzo9+umVOZymxsS1zoavJWMRYmakN79PTj35M2kGWH87qV26xXH0Qok7bhKr+b0ojXg1FIAcPT/1jgC21h9TPoKkFf9ae/JMl6YORk23Y5Zi/9E8seD7YgUPcw==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Wo+xrLLY; dkim-atps=neutral; spf=pass (client-ip=2600:3c04:e001:324:0:1991:8:25; helo=tor.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Wo+xrLLY;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=2600:3c04:e001:324:0:1991:8:25; helo=tor.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org)
Received: from tor.source.kernel.org (tor.source.kernel.org [IPv6:2600:3c04:e001:324:0:1991:8:25])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4j0PWp3xmsz30Nl
	for <linux-erofs@lists.ozlabs.org>; Thu, 08 Oct 2026 07:15:50 +1100 (AEDT)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 8BE0C60A90;
	Wed,  7 Oct 2026 20:15:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DBD61F000FF;
	Wed,  7 Oct 2026 20:15:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791404147;
	bh=qKs64xtmOKP8DA86oeWCetpjtn9GhO1kQ50FOWAwO/M=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Wo+xrLLYZiD/JLP0RxoSl+JsNEDRdlFCVDcLquG+7DOEV8RHZ2V+3yA5pQAKV9P+U
	 yC5aOUiRiK5PGUnQlpE2uv1SU26agrCqmARhU3iE7GhTTpWJTZoM67RtEYNoT4AZZx
	 eMwCSbv2/odg/9jXhPgTvFpPZC7nw7PteU15+WuDEsIjxkEc2rR03XLSVCmKD5pHlw
	 EVwp5UF10Y25LSLmj/yDrB3ofEfw5ft+dgPjZBZUB4yoJYVEgHF2OmnCPY1d08bnTo
	 CTt6BdYWtctwM1FAbcc0wpxPjsVtFyY0WRLs6fjjibtJk6LGIn82yOF65AhNWXohwa
	 0um1ehOqrHhUQ==
Date: Wed, 7 Oct 2026 22:15:40 +0200
From: Gao Xiang <xiang@kernel.org>
To: sadmanf@meta.com
Cc: linux-erofs@lists.ozlabs.org, Gao Xiang <xiang@kernel.org>,
	Chao Yu <chao@kernel.org>
Subject: Re: [PATCH v2] erofs-utils: lib: fail instead of hanging on short
 reads in erofs_io_xcopy()
Message-ID: <asaobA7u4wcb1jxV@XiangdeMacBook-Pro.local>
Mail-Followup-To: sadmanf@meta.com, linux-erofs@lists.ozlabs.org,
	Gao Xiang <xiang@kernel.org>, Chao Yu <chao@kernel.org>
References: <20261006-round1-v1-0-f46b13e11de5@meta.com>
 <20261007-round1-v2-1-3ffc17bb9028@meta.com>
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
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20261007-round1-v2-1-3ffc17bb9028@meta.com>

On Wed, Oct 07, 2026 at 03:15:26PM -0400, Sadman Fahmid via B4 Relay wrote:
> From: Sadman Fahmid <sadmanf@meta.com>
> 
> erofs_io_xcopy() falls back to a read/pwrite loop for whatever
> copy_file_range() and sendfile() did not copy.  If the source reaches
> EOF before `len` bytes have been copied, erofs_io_read() returns 0,
> `len` never shrinks and mkfs spins forever instead of reporting the
> error.
> 
> This is easy to hit with a damaged source, e.g. rebuilding with
> `mkfs.erofs --clean=data out.img src.img` where src.img is truncated
> in the middle of a file's data, or when a source file shrinks while
> mkfs runs.  Return -EIO instead.
> 
> While at it, keep calling copy_file_range() until it has copied the
> whole range or fails.  A single call may copy less than requested
> (e.g. the kernel caps each call at MAX_RW_COUNT, just under 2 GiB,
> while callers pass chunks of up to 4 GiB), and the remainder was
> previously copied by sendfile() instead of being reflinked.
> 
> Signed-off-by: Sadman Fahmid <sadmanf@meta.com>
> ---
> Changes in v2:
> - Use min_t(s64, len, sizeof(buf)) and int read/write result
>   variables, as suggested by Gao Xiang. Each request is bounded
>   to 32 KiB.
> - Resend only the short-read fix. Gao Xiang already applied
>   the fd-leak fix (patch 2 from v1).
> - Link to v1:
>   https://lore.kernel.org/r/20261006-round1-v1-0-f46b13e11de5@meta.com

Hi Sadman,

I applied your patch with minor changes (mainly avoid short
erofs_io_pwrite() ...) If there is any problem, kindly help
feedback.

Thanks,
Gao Xiang

From f4a027130ad7842bfa7b7c29a7226c1181281e50 Mon Sep 17 00:00:00 2001
From: Sadman Fahmid <sadmanf@meta.com>
Date: Wed, 7 Oct 2026 15:15:26 -0400
Subject: [PATCH] erofs-utils: lib: fail instead of hanging on short reads in
 erofs_io_xcopy()

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
Link: https://patch.msgid.link/20261007-round1-v2-1-3ffc17bb9028@meta.com
[ Gao Xiang: let's avoid short erofs_io_pwrite(). ]
Signed-off-by: Gao Xiang <xiang@kernel.org>
---
 lib/io.c | 34 ++++++++++++++++++----------------
 1 file changed, 18 insertions(+), 16 deletions(-)

diff --git a/lib/io.c b/lib/io.c
index 5c5449ff..4bb40ab1 100644
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
@@ -660,21 +664,19 @@ int erofs_io_xcopy(struct erofs_vfile *vout, off_t pos,
 #endif
 	}
 
-	do {
+	while (len) {
 		char buf[32768];
-		int ret = min_t(unsigned int, len, sizeof(buf));
-
-		ret = erofs_io_read(vin, buf, ret);
-		if (ret < 0)
-			return ret;
-		if (ret > 0) {
-			ret = erofs_io_pwrite(vout, buf, pos, ret);
-			if (ret < 0)
-				return ret;
-			pos += ret;
-		}
-		len -= ret;
-	} while (len);
+		int ret, nread;
+
+		nread = erofs_io_read(vin, buf, min_t(s64, len, sizeof(buf));
+		if (nread <= 0)
+			return nread < 0 ? nread : -EIO;
+		ret = erofs_io_pwrite(vout, buf, pos, nread);
+		if (ret != nread)
+			return ret < 0 ? ret : -EIO;
+		pos += nread;
+		len -= nread;
+	}
 	return 0;
 }
 


