Return-Path: <linux-erofs+bounces-345-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E055CC2D0CD
	for <linux-erofs@archiver.kernel.org>; Mon, 19 May 2025 03:54:39 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4b13jB25VBz2xlP;
	Mon, 19 May 2025 13:54:38 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2604:1380:45d1:ec00::3"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1747626878;
	cv=none; b=d50sELycv/pNogVRa+vtF1+0W44/YHmKhNteTGiBVja2Zs+M+zZbBGm+Zs7+7QIjmxoC8915NtqkWoXkOIXXKJ5luWr4oywTDrACge60nsrENhkTKarnGYswDpcZTxMqqcBXutdzf5El9jpXq4qLhhmB7DuBd4A8f7flzaJuDGMkxAw9Y+Z/9XTCdWsqBB+OoxWO6zoSd0OK8/TCRX2k54BW447Gy5IMSWOnfTiR/ds/hpY95YQEIcRqvZzwkc8ORdJK0wiGbteM9FxyI7vNgdIEjdpecOCb0kmMIMZpBWfp+0JWTAVxYrx6YmYcmrvf2ljXxoVi6iBtI8acLDmp/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1747626878; c=relaxed/relaxed;
	bh=PJ7FNvj+HBi+FoF6KGA4+8Vh1rHpk+hU6C9/nFzFtls=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OI7HEaa6RHFG5lqGATrKs1ZJzmaAPb4+aS6dqsg3fq4g/JklGfP3SdEt1bWzleLbpyOppFxG1BjsmHIIAPmaFOjgiNIKigbGgM1ZibDKkAIR0pRL9nBHxPhfUd84qnph+8KH8mFhz5IvARcUaml2sCqLo1YLvm5qjmbcu8tk7Daotwd7SYdjG0KAl1bBR0iOOP+kImaPQqX5IrerJqzsynwDw56vFwDNgJsMfM4uBo3+Gyvn4ATabyEPNr4jvRFMl/Hyv50ZGQqGrdiDog0W68Wp4drc44OFmr0BkA0fy+t7zZLRCkKdjS68zsdGHaH8UII2KhRzXJ2/EQuNsZbZbA==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20201202 header.b=UlVJ2Ndr; dkim-atps=neutral; spf=pass (client-ip=2604:1380:45d1:ec00::3; helo=nyc.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20201202 header.b=UlVJ2Ndr;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=2604:1380:45d1:ec00::3; helo=nyc.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org)
Received: from nyc.source.kernel.org (nyc.source.kernel.org [IPv6:2604:1380:45d1:ec00::3])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4b13j90xHVz2xlL
	for <linux-erofs@lists.ozlabs.org>; Mon, 19 May 2025 13:54:37 +1000 (AEST)
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by nyc.source.kernel.org (Postfix) with ESMTP id 1D575A49D91;
	Mon, 19 May 2025 03:54:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8560C4CEE4;
	Mon, 19 May 2025 03:54:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1747626873;
	bh=bwGkZr4Chd/Kt6Yei9NegjbH4WXfuh+5CMBT2YhepHw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=UlVJ2NdrdPCWf+GkB/5Oa1wjn4J5ewiH6Z5LkgQ6UAb4+wEyIG1hZZDot2MhzdpAE
	 QblrLQr719nk/YWf8DjoF8j8TI+d7pzkCZcRDNByBrpWYDP4crSibeYesr5r/l48R0
	 6k4RUiLcpWAPe1aawpJm8q021EU9GsaJJ6I9UayKZQLyCvunbIb5nZynXnrCLr+3bK
	 QAM487GOhoY6S+3o05IWbwS5RUdvbLmv9nbB8dnF1KLch5goI1gGDnwYO8Ln7XC7N7
	 45Vprvp2YPGqjK29x7dhyS4VuUmH/I9ytty+FWTs1QmGkydmNP3t+xjBI9T0dO+/Sc
	 ApvpYMxPF1ypQ==
Date: Mon, 19 May 2025 11:54:25 +0800
From: Gao Xiang <xiang@kernel.org>
To: Sheng Yong <shengyong2021@gmail.com>
Cc: hsiangkao@linux.alibaba.com, chao@kernel.org, zbestahu@gmail.com,
	jefflexu@linux.alibaba.com, dhavale@google.com,
	lihongbo22@huawei.com, linux-erofs@lists.ozlabs.org,
	linux-kernel@vger.kernel.org, Sheng Yong <shengyong1@xiaomi.com>,
	Wang Shuai <wangshuai12@xiaomi.com>
Subject: Re: [PATCH v7] erofs: add 'fsoffset' mount option to specify
 filesystem offset
Message-ID: <aCqrceu67F3rh3JM@debian>
Mail-Followup-To: Sheng Yong <shengyong2021@gmail.com>,
	hsiangkao@linux.alibaba.com, chao@kernel.org, zbestahu@gmail.com,
	jefflexu@linux.alibaba.com, dhavale@google.com,
	lihongbo22@huawei.com, linux-erofs@lists.ozlabs.org,
	linux-kernel@vger.kernel.org, Sheng Yong <shengyong1@xiaomi.com>,
	Wang Shuai <wangshuai12@xiaomi.com>
References: <20250517090544.2687651-1-shengyong1@xiaomi.com>
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
In-Reply-To: <20250517090544.2687651-1-shengyong1@xiaomi.com>

Hi Yong,

On Sat, May 17, 2025 at 05:05:43PM +0800, Sheng Yong wrote:
> From: Sheng Yong <shengyong1@xiaomi.com>
> 
> When attempting to use an archive file, such as APEX on android,
> as a file-backed mount source, it fails because EROFS image within
> the archive file does not start at offset 0. As a result, a loop
> or a dm device is still needed to attach the image file at an
> appropriate offset first. Similarly, if an EROFS image within a
> block device does not start at offset 0, it cannot be mounted
> directly either.
> 
> To address this issue, this patch adds a new mount option `fsoffset=x'
> to accept a start offset for the primary device. The offset should be
> aligned to the block size. EROFS will add this offset before performing
> read requests.
> 
> Signed-off-by: Sheng Yong <shengyong1@xiaomi.com>
> Signed-off-by: Wang Shuai <wangshuai12@xiaomi.com>

I applied the following diff to fulfill the Hongbo's previous suggestion
and refine an error message:

diff --git a/Documentation/filesystems/erofs.rst b/Documentation/filesystems/erofs.rst
index 11b0f8635f04..d93b30287110 100644
--- a/Documentation/filesystems/erofs.rst
+++ b/Documentation/filesystems/erofs.rst
@@ -128,7 +128,7 @@ device=%s              Specify a path to an extra device to be used together.
 fsid=%s                Specify a filesystem image ID for Fscache back-end.
 domain_id=%s           Specify a domain ID in fscache mode so that different images
                        with the same blobs under a given domain ID can share storage.
-fsoffset=%lu           Specify image offset for the primary device.
+fsoffset=%lu           Specify block-aligned filesystem offset for the primary device.
 ===================    =========================================================
 
 Sysfs Entries
diff --git a/fs/erofs/super.c b/fs/erofs/super.c
index 3185bb90f549..e1e9f06e8342 100644
--- a/fs/erofs/super.c
+++ b/fs/erofs/super.c
@@ -654,9 +654,9 @@ static int erofs_fc_fill_super(struct super_block *sb, struct fs_context *fc)
 	}
 
 	if (sbi->dif0.fsoff) {
-		if (sbi->dif0.fsoff & ((1 << sbi->blkszbits) - 1))
-			return invalfc(fc, "fsoffset %llu not aligned to block size",
-				       sbi->dif0.fsoff);
+		if (sbi->dif0.fsoff & (sb->s_blocksize - 1))
+			return invalfc(fc, "fsoffset %llu is not aligned to block size %lu",
+				       sbi->dif0.fsoff, sb->s_blocksize);
 		if (erofs_is_fscache_mode(sb))
 			return invalfc(fc, "cannot use fsoffset in fscache mode");
 	}

