Return-Path: <linux-erofs+bounces-4673-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8DDD0CA6002
	for <linux-erofs@archiver.kernel.org>; Wed,  7 Oct 2026 19:15:34 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4j0NBD6Sh0z30MY;
	Thu, 08 Oct 2026 06:15:32 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2600:3c0a:e001:78e:0:1991:8:25"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1791400532;
	cv=none; b=HgjKiYFw5njEbuemf7v/HppWZbBVm1JuvGb1HUvwKhjF9Mova6arwS8Iowor5ahEH/8+O8cqXby67utt2jEZI07tHsRB1vGriEMMS45AcNHF0gIeqg4LHLch+SgncXfO2l+nOYtbtxu6sOkZm5jU/w3I5J5q7WTwvzwGUZdGFj4IrKTeVLhqPlaOmU5uPU6NIfQy+ANhyw3VETXvKJGsO/8dErBSPVj6VbMb62Fd7tTAFh5+dqbPd4ziRKJrF04Ug+Un8fHceS/QR264mSDGW1E0PNGtqfPyggt7wXSJ2AlEulG0ZU+5OOyJe+2effjwnCQo1SwhzJMk9Y1Arfd8bw==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1791400532; c=relaxed/relaxed;
	bh=nPgxNTwXW/PXIgysDTfXffYv1OJpwI3ARobFoOgvsGM=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:
	 In-Reply-To:References:To:Cc; b=VFRgMiFZqZFUYgz0sVbkUtRmEOr7S6EauIqTyB8kOPNn1ToR635wy4sy2dgVixof71blt5+ZC67X0oh7pUt08JDp9wE/pQIQuC/Bsay9qmaeCqIhTYRUJpzMmpILwAodgfiIAVeb5mYL02LAYXLkS2Zkzs3UvYaghZyLQPjCjV77/z7RTwjs6fpi1jWsTvwU8SJ+L1bRkzl5dhioO/VafW8Ta963lS/hEVDi1/GgEfFftvUcy3GL+eKUEd3rU3hhx5Z3iuFdoVWh5J/xyiveuIy/wflw1JzagXvygqfKOblEUEYH35qrdP5fw4OjSJ/y7Z2xZeYu+cFICer1/qWPGA==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20201202 header.b=nmXPjalW; dkim-atps=neutral; spf=pass (client-ip=2600:3c0a:e001:78e:0:1991:8:25; helo=sea.source.kernel.org; envelope-from=devnull+sadmanf.meta.com@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20201202 header.b=nmXPjalW;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=2600:3c0a:e001:78e:0:1991:8:25; helo=sea.source.kernel.org; envelope-from=devnull+sadmanf.meta.com@kernel.org; receiver=lists.ozlabs.org)
Received: from sea.source.kernel.org (sea.source.kernel.org [IPv6:2600:3c0a:e001:78e:0:1991:8:25])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4j0NBC5bhFz2yK7
	for <linux-erofs@lists.ozlabs.org>; Thu, 08 Oct 2026 06:15:31 +1100 (AEDT)
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 393EA43E98;
	Wed,  7 Oct 2026 19:15:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 17D39C2BCB9;
	Wed,  7 Oct 2026 19:15:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1791400528;
	bh=U31K9UQ5mSPFwiR6sMrKg1M6kgrjMQHYpgP+jHSY1Oc=;
	h=From:Date:Subject:In-Reply-To:References:To:Cc:Reply-To:From;
	b=nmXPjalWIXLS1DaLiNT4K9HDCCRYoc79Ksh89N7C3DV8hSA7JvfIq7KVH8s6nHZYl
	 xaWgtRlfchgstnEYHh5uz0SAPTEKjUvs5OOiwjKEMNXBr+HTKhWRUpV/aE5JBgfB1J
	 i2m9s7mo9hAWmDBC07ovZN75FxWXUmXWxL9SZKM1a3loasaXUC4M4BVAnof29ee9T7
	 HfHsEvcZCR5Sl6n3jyp+quxdJ6BXqqk5aLrjVC3OneJi5JdKH0dsUk8yqLFPld20Hh
	 ba2CDnendkboSZqHUliCYR1sFCQQqyscZjaqmCajtXRE60zZn9Pa9o/0CUUj96yTiH
	 qoA7/RvTaYBDA==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0720CA6002;
	Wed,  7 Oct 2026 19:15:27 +0000 (UTC)
From: Sadman Fahmid via B4 Relay <devnull+sadmanf.meta.com@kernel.org>
Date: Wed, 07 Oct 2026 15:15:26 -0400
Subject: [PATCH v2] erofs-utils: lib: fail instead of hanging on short
 reads in erofs_io_xcopy()
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
Message-Id: <20261007-round1-v2-1-3ffc17bb9028@meta.com>
X-B4-Tracking: v=1; b=H4sIAE2axmoC/2XMQQ7CIBCF4as0sxbDoCJx1XuYLigMdhYtBirRN
 Nxd7Nbl//LybZApMWW4dRskKpw5Li3UoQM32eVBgn1rUFJplFKLFF+LR2HJGKNGRcFdoZ2fiQK
 /d+g+tJ44rzF9drfgb/0jCgopwlmPeCJET5d+ptUeXZxhqLV+AR8zXUubAAAA
In-Reply-To: <20261006-round1-v1-0-f46b13e11de5@meta.com>
References: <20261006-round1-v1-0-f46b13e11de5@meta.com>
To: linux-erofs@lists.ozlabs.org
Cc: Gao Xiang <xiang@kernel.org>, Chao Yu <chao@kernel.org>, 
 Sadman Fahmid <sadmanf@meta.com>
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1791400527; l=2792;
 i=sadmanf@meta.com; s=20261006; h=from:subject:message-id;
 bh=TGlOZrYN1BFG0KcNzoiID2GMDIUwqHE0DArnbupBDYs=;
 b=KU3kb7pUkikuqdy3RGrl90IRL5z9+/Rk9Hr/k+Col/wwAuO8UWIjjVTc+JHssjtdiO7QFdPqD
 dDJpYpoY7aQAPYr9uvDk6MrtAI5hAICFBPzdxYfEV/KfkhW/jd0rNs5
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
Changes in v2:
- Use min_t(s64, len, sizeof(buf)) and int read/write result
  variables, as suggested by Gao Xiang. Each request is bounded
  to 32 KiB.
- Resend only the short-read fix. Gao Xiang already applied
  the fd-leak fix (patch 2 from v1).
- Link to v1:
  https://lore.kernel.org/r/20261006-round1-v1-0-f46b13e11de5@meta.com
---
 lib/io.c | 29 ++++++++++++++++-------------
 1 file changed, 16 insertions(+), 13 deletions(-)

diff --git a/lib/io.c b/lib/io.c
index 5c5449f..ea3bcbf 100644
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
+		int nread = min_t(s64, len, sizeof(buf));
+		int ret;
 
-		ret = erofs_io_read(vin, buf, ret);
+		nread = erofs_io_read(vin, buf, nread);
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
 

---
base-commit: 1c230a485f25837cb51d6fc79332f30758d9006c
change-id: 20261006-round1-ae8882b2efc7

Best regards,
-- 
Sadman Fahmid <sadmanf@meta.com>



