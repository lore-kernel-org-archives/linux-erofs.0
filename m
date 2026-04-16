Return-Path: <linux-erofs+bounces-3317-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C469DF8A146
	for <linux-erofs@archiver.kernel.org>; Thu, 16 Apr 2026 09:44:26 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4fxClY1Cn2z2yhP;
	Thu, 16 Apr 2026 19:44:25 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=115.124.30.100
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1776332665;
	cv=none; b=KKMnazadsGMoLpPaK5p3HK0FRRk3jeMu4KZQlo91aTcbl+lgZST4LwTmYgzWtzBGBIli9mypRJSgJlmEW+Ajtc8rr0Gh5FW6Ohzeg0i4G5F9Gu3MMR1sonGxHrZKQVe3oXSF/KOgvREwUs9ylmKIh7dAeMyES+G4P5aWKxr4HmQV35GETE9Wn+NTeg2vpSpR2Kd8EOMdAivJqtDj2618Yt65I8dZDkWVIuwEyblAnD43CQh3tsgv5m27LqVOw7aT8aVCh9OnUGY+0yJEsyy9xMm08YbZ/cb0In8ZNzkXYpz0z6i5YhtuD/7AZeyhgz/H3mOvts+fmt/VeRgxCLxxxQ==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1776332665; c=relaxed/relaxed;
	bh=F4BgXkYYCfQlBiwTGUFItd9HWrXBftk1iLmFLyvaXPk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TG2lvcCYn9qjyIcUiHswqSMncVfA/RhLTK+LQSG6nePB67u4ThUAL11ty8a67686klwqQvmbstrZNc/3u79nveVf+aT8KAA/zqHBzkXFsNFuVPtcQgPEKngxALFc8ertqR3QXheyF2GAiZqSFo8teXZKs6TkEDceD7dxLDBM6ry2aSbWM2e1RbOnY1OiRCiEs5CIW244TBeQ3gS8sAdXbXiHniPC1CVrvplC6qGZjjjuGBXgoyIJzXzVUcSeslgBulpbRchfQuc51swsj90+Y+Gdsn/GalXg0zYAw35KI+K97UUfNK64iwaTyLoGST+7IuN3xxYVa2mVdV1WFk+4bg==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=eIjOm1iO; dkim-atps=neutral; spf=pass (client-ip=115.124.30.100; helo=out30-100.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org) smtp.mailfrom=linux.alibaba.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=eIjOm1iO;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=linux.alibaba.com (client-ip=115.124.30.100; helo=out30-100.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org)
Received: from out30-100.freemail.mail.aliyun.com (out30-100.freemail.mail.aliyun.com [115.124.30.100])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4fxClV2wlWz2yYq
	for <linux-erofs@lists.ozlabs.org>; Thu, 16 Apr 2026 19:44:20 +1000 (AEST)
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1776332655; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=F4BgXkYYCfQlBiwTGUFItd9HWrXBftk1iLmFLyvaXPk=;
	b=eIjOm1iO2/zAL3VrOF9bP3ThLJLt04ZKMilGsxQ2qP+ljmYWuBbgg632Qai+fWoBib71uqQQLWtAy/Eqfq2ULYn6ej0U9GIaHMUy9rt7mj282gs85b4PLK82atKw9mOE41pcR1+nrqtEuEylQUuMkgD8ZG3YCG3fl6G6hESk2k0=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R101e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037026112;MF=hsiangkao@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0X182qz7_1776332649;
Received: from x31i01179.sqa.na131.tbsite.net(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0X182qz7_1776332649 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 16 Apr 2026 17:44:13 +0800
From: Gao Xiang <hsiangkao@linux.alibaba.com>
To: linux-erofs@lists.ozlabs.org
Cc: LKML <linux-kernel@vger.kernel.org>,
	Gao Xiang <hsiangkao@linux.alibaba.com>,
	Yuhao Jiang <danisjiang@gmail.com>,
	Junrui Luo <moonafterrain@outlook.com>,
	stable@vger.kernel.org
Subject: [PATCH v3] erofs: fix the out-of-bounds nameoff handling for trailing dirents
Date: Thu, 16 Apr 2026 17:44:08 +0800
Message-ID: <20260416094408.3466613-1-hsiangkao@linux.alibaba.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20260416063511.3173774-1-hsiangkao@linux.alibaba.com>
References: <20260416063511.3173774-1-hsiangkao@linux.alibaba.com>
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
Content-Transfer-Encoding: 8bit

Currently we already have boundary-checks for nameoffs, but the trailing
dirents are special since the namelens are calculated with strnlen()
with unchecked nameoffs.

If a crafted EROFS has a trailing dirent with nameoff >= maxsize,
maxsize - nameoff can underflow, causing strnlen() to read past the
directory block.

nameoff0 should also be verified to be a multiple of
`sizeof(struct erofs_dirent)` as well [1].

[1] https://sashiko.dev/#/patchset/20260416063511.3173774-1-hsiangkao%40linux.alibaba.com
Fixes: 3aa8ec716e52 ("staging: erofs: add directory operations")
Fixes: 33bac912840f ("staging: erofs: keep corrupted fs from crashing kernel in erofs_readdir()")
Reported-by: Yuhao Jiang <danisjiang@gmail.com>
Reported-by: Junrui Luo <moonafterrain@outlook.com>
Closes: https://lore.kernel.org/r/A0FD7E0F-7558-49B0-8BC8-EB1ECDB2479A@outlook.com
Cc: stable@vger.kernel.org
Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
---
v3:
 - Disallow unaligned nameoff0 to avoid petential oob reads as well.

 fs/erofs/dir.c | 29 ++++++++++++++++-------------
 1 file changed, 16 insertions(+), 13 deletions(-)

diff --git a/fs/erofs/dir.c b/fs/erofs/dir.c
index e5132575b9d3..d074fded1577 100644
--- a/fs/erofs/dir.c
+++ b/fs/erofs/dir.c
@@ -19,20 +19,18 @@ static int erofs_fill_dentries(struct inode *dir, struct dir_context *ctx,
 		const char *de_name = (char *)dentry_blk + nameoff;
 		unsigned int de_namelen;
 
-		/* the last dirent in the block? */
-		if (de + 1 >= end)
-			de_namelen = strnlen(de_name, maxsize - nameoff);
-		else
+		/* non-trailing dirent in the directory block? */
+		if (de + 1 < end)
 			de_namelen = le16_to_cpu(de[1].nameoff) - nameoff;
+		else if (maxsize <= nameoff)
+			goto err_bogus;
+		else
+			de_namelen = strnlen(de_name, maxsize - nameoff);
 
-		/* a corrupted entry is found */
-		if (nameoff + de_namelen > maxsize ||
-		    de_namelen > EROFS_NAME_LEN) {
-			erofs_err(dir->i_sb, "bogus dirent @ nid %llu",
-				  EROFS_I(dir)->nid);
-			DBG_BUGON(1);
-			return -EFSCORRUPTED;
-		}
+		/* a corrupted entry is found (including negative namelen) */
+		if (!in_range32(de_namelen, 1, EROFS_NAME_LEN) ||
+		    nameoff + de_namelen > maxsize)
+			goto err_bogus;
 
 		if (!dir_emit(ctx, de_name, de_namelen,
 			      erofs_nid_to_ino64(EROFS_SB(dir->i_sb),
@@ -42,6 +40,10 @@ static int erofs_fill_dentries(struct inode *dir, struct dir_context *ctx,
 		ctx->pos += sizeof(struct erofs_dirent);
 	}
 	return 0;
+err_bogus:
+	erofs_err(dir->i_sb, "bogus dirent @ nid %llu", EROFS_I(dir)->nid);
+	DBG_BUGON(1);
+	return -EFSCORRUPTED;
 }
 
 static int erofs_readdir(struct file *f, struct dir_context *ctx)
@@ -88,7 +90,8 @@ static int erofs_readdir(struct file *f, struct dir_context *ctx)
 		}
 
 		nameoff = le16_to_cpu(de->nameoff);
-		if (nameoff < sizeof(struct erofs_dirent) || nameoff >= bsz) {
+		if (nameoff < sizeof(struct erofs_dirent) || nameoff >= bsz ||
+		    (nameoff % sizeof(struct erofs_dirent))) {
 			erofs_err(sb, "invalid de[0].nameoff %u @ nid %llu",
 				  nameoff, EROFS_I(dir)->nid);
 			err = -EFSCORRUPTED;
-- 
2.43.5


