Return-Path: <linux-erofs+bounces-4535-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B1E8EC88E41
	for <linux-erofs@archiver.kernel.org>; Fri, 11 Sep 2026 04:19:04 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hh1Wq21dBz2y2b;
	Fri, 11 Sep 2026 14:19:03 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=172.105.4.254
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1789100343;
	cv=none; b=EYMRyXX5hoE9QMqEA2I21IU2OMeP+Ibr1klZrW7j7cteISxqFnLyhrQ0PJ+hg/2MDrwKuyRJrzwP5oWAFb7uY4Kz6ozPKGa0SumUEGYaGC0q15/Eha8ApsVXqB+xwpBHalfMpXirJAfWJbsLB2Ui6Cg1WRqTJDgpbiQ4AMNOdeAS5MejfbcObHGJY7nmzXdoFH6Rrh2MM75RKlRzXaSJFFAiNLgY1p56JwA7MRoopdNZt0bh6PDyv/ai+l/zSgCwidcP+MQIriAoS0tIp5gdtJk46+eaOxBp80SGTyIG3WuoPQWKqa0FMtu8m6aWdyXCJM81TG+9p9RGCOC5+qR1qQ==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1789100343; c=relaxed/relaxed;
	bh=2o3DVHftDSE7CLGmgVt/vw8zK49gWrUrqdVFHE/XEs8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iZevQ1s2IGyoSiJkdPOcJK1EWrveXTqZ7iAyDOgz1TbtGAcEt0Avt2tTI5z6pH5dd+FZXd4iC51TvRmVoPcIiWzlvf5HTZHqyGreYXdbPznwfptaUJ6rPadax3enu7XX2dko3Z04J9GfnXECOnLsQVRA+1w3aRO+gx3nMnWJ53wpHKdrhDh6dUQUZhECbFQCUcQOtNUlArxdEr7hmQKrkSlQ5Oxcajprv1ZPXvqTYpvvtG7SAeUt7HwmP3EJ3HFqEa1xMobJw98LUApaHbJ6RpXN/xWmaHJl1GLzz1dfCyw1+A2sydDGOgD6AHEJO1OlDrA//GBmsJAe9iLj3/fxGA==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jaPrpOKY; dkim-atps=neutral; spf=pass (client-ip=172.105.4.254; helo=tor.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jaPrpOKY;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=172.105.4.254; helo=tor.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org)
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hh1Wp2v35z2xRs
	for <linux-erofs@lists.ozlabs.org>; Fri, 11 Sep 2026 14:19:02 +1000 (AEST)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id DFB83601F0;
	Fri, 11 Sep 2026 04:18:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EBE11F000FF;
	Fri, 11 Sep 2026 04:18:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789100339;
	bh=2o3DVHftDSE7CLGmgVt/vw8zK49gWrUrqdVFHE/XEs8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=jaPrpOKYc8bC8hCPBbrmOgSckYrdSrelVHuV34ojXcpdKVbeS2SkxAiCfIcKUDj75
	 AOJcjYYh+pGfBDFsINPglUVNU/M9o+HPittXk4h7OSHSTY/87C5kD2pqSorTdA5ZIl
	 uJnKdetSkuzCDcLdnTseVWhQ9ktVw+S+tX28Dv1wTCqApt3utKYxrHYMKB2AYdKw71
	 jnI6ug4sLzUUfUrH26ogqXV5oh0aFH2Wo2VEQv06imsHGAXvHQf7TKQhIhlLoDnG86
	 RBvXDjwYQ7vU4nM1JWmGdc6Bky9gh+vsTZ4OMJrIU8k5l27DPP3CUy8l6Y6uqQmerj
	 bh0FIz7FuCB5w==
Date: Fri, 11 Sep 2026 12:18:53 +0800
From: Gao Xiang <xiang@kernel.org>
To: binglei wang <l3b2w1@gmail.com>
Cc: linux-erofs@lists.ozlabs.org, xiang@kernel.org, chao@kernel.org,
	shengyong1@xiaomi.com, zbestahu@gmail.com,
	jefflexu@linux.alibaba.com, dhavale@google.com,
	hongbohbli@tencent.com, guochunhai@vivo.com, wangshuai12@xiaomi.com,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] erofs: fix unbalanced buf->off handling in erofs_bread()
Message-ID: <aqOBLWQEkH7_3LSu@XiangdeMacBook-Pro.local>
Mail-Followup-To: binglei wang <l3b2w1@gmail.com>,
	linux-erofs@lists.ozlabs.org, xiang@kernel.org, chao@kernel.org,
	shengyong1@xiaomi.com, zbestahu@gmail.com,
	jefflexu@linux.alibaba.com, dhavale@google.com,
	hongbohbli@tencent.com, guochunhai@vivo.com, wangshuai12@xiaomi.com,
	linux-kernel@vger.kernel.org
References: <CAJ3C4KxqO2--RDZN7jCvYKOjwe-XSUcEj8w74ETeHV2ZUq_1dw@mail.gmail.com>
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
In-Reply-To: <CAJ3C4KxqO2--RDZN7jCvYKOjwe-XSUcEj8w74ETeHV2ZUq_1dw@mail.gmail.com>

Hi Binglei,

On Fri, Sep 11, 2026 at 12:01:48PM +0800, binglei wang wrote:
> erofs_bread() locates the target folio with
> 
>  index = (buf->off + offset) >> PAGE_SHIFT;
> 
> but computes the in-folio offset without taking buf->off into account:
> 
>  return buf->base + (offset & ~PAGE_MASK);
> 
> If buf->off is not page-aligned, the returned pointer misses the in-page
> component of buf->off, so callers end up fetching data from a wrong
> offset.
> 
> buf->off is set to sbi->dif0.fsoff in erofs_init_metabuf(), and fsoff can
> be specified via the "fsoffset=" mount option, which only requires
> block-size alignment. Therefore, on an image with a sub-page block size
> (e.g. 512 bytes), a non-page-aligned fsoff (e.g. 512) triggers the issue,
> since 512 is a multiple of the block size but not of PAGE_SIZE.
> 
> It can be reproduced by mounting an image that is placed at a
> non-page-aligned offset:
> 
>  mkfs.erofs -b512 -zlz4hc sub.erofs src/
>  # prepend 512 bytes of padding to the image
>  mount -t erofs -o loop,fsoffset=512 padded.erofs /mnt
> 
> which fails with
> 
>  erofs (device loop0): cannot find valid erofs superblock
> 
> because the on-disk superblock (at offset 1024 within the image, i.e.
> 1536 within the padded file) is read from a wrong in-folio offset. With
> this fixed, the very same image mounts successfully and its file contents
> match those read from the unpadded image.
> 
> Fix it by including buf->off in the in-folio offset calculation, so that
> it is consistent with the folio index calculation.
> 
> Fixes: c36ec00d7f67 ("erofs: add 'fsoffset' mount option to specify
> filesystem offset")
> Cc: <stable@vger.kernel.org> # 6.16+
> Signed-off-by: Binglei Wang <l3b2w1@gmail.com>

The fix looks fine, but the patch format is broken:
Reviewed-by: Gao Xiang <xiang@kernel.org>

I applied the following version manually with an updated
patch subject.

From 135d84c66f85426299db01a09d93a79a87af18ba Mon Sep 17 00:00:00 2001
From: Binglei Wang <l3b2w1@gmail.com>
Date: Fri, 11 Sep 2026 12:11:33 +0800
Subject: [PATCH] erofs: add missing buf->off in erofs_bread()

erofs_bread() locates the target folio with

 index = (buf->off + offset) >> PAGE_SHIFT;

but computes the in-folio offset without taking buf->off into account:

 return buf->base + (offset & ~PAGE_MASK);

If buf->off is not page-aligned, the returned pointer misses the in-page
component of buf->off, so callers end up fetching data from a wrong
offset.

buf->off is set to sbi->dif0.fsoff in erofs_init_metabuf(), and fsoff can
be specified via the "fsoffset=" mount option, which only requires
block-size alignment. Therefore, on an image with a sub-page block size
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
1536 within the padded file) is read from a wrong in-folio offset. With
this fixed, the very same image mounts successfully and its file contents
match those read from the unpadded image.

Fix it by including buf->off in the in-folio offset calculation, so that
it is consistent with the folio index calculation.

Fixes: c36ec00d7f67 ("erofs: add 'fsoffset' mount option to specify filesystem offset")
Signed-off-by: Binglei Wang <l3b2w1@gmail.com>
Reviewed-by: Gao Xiang <xiang@kernel.org>
Signed-off-by: Gao Xiang <xiang@kernel.org>
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
2.47.3


