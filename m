Return-Path: <linux-erofs+bounces-4547-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 833ACC88E45
	for <linux-erofs@archiver.kernel.org>; Sat, 12 Sep 2026 02:57:26 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hhbg83QQtz2xkr;
	Sat, 12 Sep 2026 12:57:24 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2607:f8b0:4864:39::11"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1789181844;
	cv=none; b=MzmkAvkpl06rk+qliNQ6ekx9Np1l0Jq17NB3IEf94UxQkm4Pps8a640fLeAFMKXskGumktA1UOxys9vk4FNLN9RYF9ER8ksYiyQarwTSoVglTDCftQDdypCZhNQPCVsiNNT24yO3mGKpEBE2DadUORJUDcpJx7HavMvKTsvTCUHIkalvsbYFwUBLWTwKJRBdXvlCSmf1wDq+QOUXTAdKZaGrU4kA9kOm4LrTs91NrcWTyZvu1Zp60VWqQCmASyaMFCp4H41h/cU+Il+Hfi+n/G1h5TyEvdiWM20PvPF7qCPn3ds+5R4adW8QAHCD0K0m6z4pvgXmOivU4n6j38GeBg==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1789181844; c=relaxed/relaxed;
	bh=ZChHh/4B9HUVQ4ZUWlKc1VE04E7v5RYeUYSFt/vXmVc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=T5bQ+e8K62ONFbHNYHP9JqV0dIxN2X3/5uX9rRFZXknmHPfs2Sp+zcxFpeipxAeylo80bi+Xsmb0xPzasSzvAXCAIB1mHCHeIcd153pNngFRiJxSnVGESo1UJLUipEytrFA80jOIZYDhiBHyxV6vKuyEf2tR82hz2KZPqiwCMBKZIi76jQV0N0Ux0jr4DHIv5lfjZgp7NohqgGftnTHocnWxhuW35oY5VdWAuWY4HuwRXPwYz3sDcN3YfMvjHwX7n33LeE7OCfMxucOmvFg9RJ0aR0e5xYmZrKAH9kHBQUjXHv9G00UmcS0rsJ8l+Rb2wfWaE58zDNKjceun/PU+Vg==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=gmail.com; dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=b4RDgfYL; dkim-atps=neutral; spf=pass (client-ip=2607:f8b0:4864:39::11; helo=mail-pj2-x11.google.com; envelope-from=l3b2w1@gmail.com; receiver=lists.ozlabs.org) smtp.mailfrom=gmail.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=b4RDgfYL;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=gmail.com (client-ip=2607:f8b0:4864:39::11; helo=mail-pj2-x11.google.com; envelope-from=l3b2w1@gmail.com; receiver=lists.ozlabs.org)
Received: from mail-pj2-x11.google.com (mail-pj2-x11.google.com [IPv6:2607:f8b0:4864:39::11])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hhbg641qMz2xdb
	for <linux-erofs@lists.ozlabs.org>; Sat, 12 Sep 2026 12:57:21 +1000 (AEST)
Received: by mail-pj2-x11.google.com with SMTP id 98e67ed59e1d1-39dbdfaef3cso158077a91.1
        for <linux-erofs@lists.ozlabs.org>; Fri, 11 Sep 2026 19:57:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789181839; x=1789786639; darn=lists.ozlabs.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=ZChHh/4B9HUVQ4ZUWlKc1VE04E7v5RYeUYSFt/vXmVc=;
        b=b4RDgfYLGxD2Rf/4mM86r6yyM7H1vGZgZ6QIo9YdOuLWrNEemhNFTex8JW6Nrk+Rp7
         7ughPwZp0iq4rVX6Bs1+MbtDMjOAE/ag8pQXGQnK83Ai4sFwauM8k5oQc5DDsTzm23LE
         DWvmVi7Qcq84l/3yB6uXSOKHCosStyd9ghYVqgplZST+SA79YQNohLgWcS+/hA2ERCgn
         0EiqRUc/bvSxeWLiuYLnuPEmdoILpEbf9DaZaRGRlcBi1bsLLGUcb3WQGzpmaF6fABAM
         zuOgb3twXNpMue/1u+28fVmfFyPAscpG0GYoVveyeTjnt53qCjG7JLRq4yXJkQm0Gnij
         Ryhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789181839; x=1789786639;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ZChHh/4B9HUVQ4ZUWlKc1VE04E7v5RYeUYSFt/vXmVc=;
        b=XCrXHjhy5Rq2UfPmXCW+SmOL1YE2JVCiyoI9OFr/0wM3imgrc31uPnr1p9kLlWR9JW
         NYaQBCFpKoqvXrb/dsxIu1ZmO5p8BX1ORGMdfPKRZ34fpUSV5uXoFLaBjjBKYY9LGhRG
         fnncT7VLq05x30YKxyFUrWGPa3hQs2zYlqDn9bfUl4YmA9AE6DeiCd3lvxe5euS9AcLr
         iD90G4AwM2SVPCNteZJ33ZrsS6CpBo7D2CnfMGW/A90IPsc/Cd+38VJP5eoRNyTLa9xS
         HpZaklyVCXK6NAow5wcJpcA2gYu7IxrJPtGpQ/hZ5Ab1mTP2Y2VohXBjUqUi1zMUv5Py
         ZJzQ==
X-Gm-Message-State: AFuF++kZ4gSIupWTIfhuO5YdyFOhvW372zAKeZIE6QSqjZqErC4kG0bE
	Te6H/tlfV3/FbxupkEJGbP3X0eSbJlBV+21ZFT3i1YsJVuN6F+sm5P1Wds/Xvqi+GCmyZg==
X-Gm-Gg: AYBFou2WWGLvlpRyT2axEo7AsttBx2MiCPrzhysaG9mkkcCplFMUHgMn+EETBxEoMcl
	oaFFTXuUgt8Z7yhLkBmJKZS4BN3jdGl56UzCoA1/iW1PxnUc0lNsDOm8ttTwJmFJK43UNTsbc3A
	0hTqn9pU09GHT0ELwgmMAeUJ+VnL+NGA/fxEo6BqQbgbfKzDaph5xJrtQesL2/8RVWN403tQfE5
	r1SLozPS+0m0qHeuC9t82RyK8EAuyT/+3Qh+5zj4ZPsrEqToCnzdKMIFsim01XF3istuj2LHQMX
	ZtLoRWATee7y8wGRNwh/U6Au+FfMCSKXmQiyRDrDTfGscQueY/zZRK+YqsrFcp+lHBpD6BHtAb0
	a6cPRRkzOsb/Yb9QtQBSn9PxhAYIK4ZFgp6+tbbV9kcbBx7IL8u508zHuvuNqmzvUpP1LnMvB+o
	d7J/hMInFTBK8BWQoInOvU8IBXaoPawUKQJCgxkshWdHQTVV3IZjy0
X-Received: by 2002:a17:90b:57ce:b0:396:b918:c2a with SMTP id 98e67ed59e1d1-39d9c1dbb3emr12783798a91.12.1789181838654;
        Fri, 11 Sep 2026 19:57:18 -0700 (PDT)
Received: from linux.. ([2409:8a28:a63:d170:c5de:2f75:4ae3:11de])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39d9d554220sm2344737a91.2.2026.09.11.19.57.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Sep 2026 19:57:18 -0700 (PDT)
From: Binglei Wang <l3b2w1@gmail.com>
X-Google-Original-From: Binglei Wang
To: linux-erofs@lists.ozlabs.org
Cc: xiang@kernel.org,
	chao@kernel.org,
	shengyong1@xiaomi.com,
	linux-kernel@vger.kernel.org,
	Binglei Wang <l3b2w1@gmail.com>,
	stable@vger.kernel.org
Subject: [PATCH] erofs: fix unbalanced buf->off handling in erofs_bread()
Date: Sat, 12 Sep 2026 10:57:09 +0800
Message-ID: <20260912025709.25604-1-l3b2w1@gmail.com>
X-Mailer: git-send-email 2.43.0
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

From: Binglei Wang <l3b2w1@gmail.com>

erofs_bread() locates the target folio with

	index = (buf->off + offset) >> PAGE_SHIFT;

but computes the in-folio offset without taking buf->off into account:

	return buf->base + (offset & ~PAGE_MASK);

If buf->off is not page-aligned, the returned pointer misses the in-page
component of buf->off, so callers end up fetching data from a wrong
offset.

buf->off is set to sbi->dif0.fsoff in erofs_init_metabuf(), and fsoff can
be specified via the "fsoffset=" mount option, which only requires
block-size alignment.  Therefore, on an image with a sub-page block size
(e.g. 512 bytes), a non-page-aligned fsoff (e.g. 512) triggers the issue,
since 512 is a multiple of the block size but not of PAGE_SIZE.

It can be reproduced by mounting an image that is placed at a
non-page-aligned offset:

	mkfs.erofs -b512 -zlz4hc sub.erofs src/
	# prepend 512 bytes of padding to the image
	mount -t erofs -o loop,fsoffset=512 padded.erofs /mnt

which fails with

	erofs (device loop0): cannot find valid erofs superblock

because the on-disk superblock (at offset 1024 within the image, i.e.
1536 within the padded file) is read from a wrong in-folio offset.  With
this fixed, the very same image mounts successfully and its file contents
match those read from the unpadded image.

Fix it by including buf->off in the in-folio offset calculation, so that
it is consistent with the folio index calculation.

Fixes: c36ec00d7f67 ("erofs: add 'fsoffset' mount option to specify filesystem offset")
Cc: <stable@vger.kernel.org> # 6.16+
Signed-off-by: Binglei Wang <l3b2w1@gmail.com>
---
 fs/erofs/data.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/erofs/data.c b/fs/erofs/data.c
index 0885b1f2fc92..be63b89f0862 100644
--- a/fs/erofs/data.c
+++ b/fs/erofs/data.c
@@ -48,7 +48,7 @@ void *erofs_bread(struct erofs_buf *buf, erofs_off_t offset, bool need_kmap)
 		return NULL;
 	if (!buf->base)
 		buf->base = kmap_local_page(buf->page);
-	return buf->base + (offset & ~PAGE_MASK);
+	return buf->base + ((buf->off + offset) & ~PAGE_MASK);
 }

 int erofs_init_metabuf(struct erofs_buf *buf, struct super_block *sb,
--
2.33.0


