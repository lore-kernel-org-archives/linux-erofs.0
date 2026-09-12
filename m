Return-Path: <linux-erofs+bounces-4548-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 85471C79FB6
	for <linux-erofs@archiver.kernel.org>; Sat, 12 Sep 2026 09:26:09 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hhmHg5wsBz2ynZ;
	Sat, 12 Sep 2026 19:26:07 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2600:3c04:e001:324:0:1991:8:25"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1789205167;
	cv=none; b=Cq46jPVc/o3DENR8LKkvbna1MJWxkXG2CJQcnuX6Db1B8xYg4aVRmXfUsREiDaueEMDviQgmYpRltHIEjyi4YC7DNjAdvGVAAjmdNipsgEfEnm62CueVFgf5jD2vjJZH2Z6gA1UuBDoPW0pZe3Kng/WmUyCVqsxUMI0+t6di1LV6vLQjEKyE756RYitesCzfRFvkfx9ZE9iDlg8ZbNAe9kZ0i2xb8ClPXluCkgisPFrp7PoFl9T0Xdp+IUOZsBPJVQCECS+LwSmqva8bSTzpjubj+YgKepFo7SJLLTiwpAb97d3eRVe48dnccDsT2OmwkfuNLNHFGn0Qx6Zs3NzsEg==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1789205167; c=relaxed/relaxed;
	bh=RcssxDcliU7vD3F+mu6uXNvjkcF5Kkz6UZoypW6r5jc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gk+2wxh9C9wPjYrPLjjKn8Il/szhSDR8N6eDH0K5V1e2qREkqIwkTVsxIFcWtfDkQ2UGp3tI9IS+8Umka41Gz9OpVfpD5wN1+LVJqxQ4X7k0S3cLnoIuHCh+DlUBEH6ykBPLMUU4FXhe/QqpFO3m+/V8DQ2jLsFVkuwYaanqj0V+ZrTYkZOkxuHgTzqIfuAlQi7/WP0PqdvtXVjwOueVR/b6d6W6Y7L4nWKSMeflyZkQGAoh6DjYWEbojmPe3oB/gVim1Qv99ZdhkVnjQiVKZBs0i1J0lANHqYlt8/pGn2FFxM6G+t/UJqFk/h6EfGk7MkvlJdrqqbD0k08brhcMRQ==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=D+QIGsAK; dkim-atps=neutral; spf=pass (client-ip=2600:3c04:e001:324:0:1991:8:25; helo=tor.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=D+QIGsAK;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=2600:3c04:e001:324:0:1991:8:25; helo=tor.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org)
Received: from tor.source.kernel.org (tor.source.kernel.org [IPv6:2600:3c04:e001:324:0:1991:8:25])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hhmHg1CF7z2yln
	for <linux-erofs@lists.ozlabs.org>; Sat, 12 Sep 2026 19:26:07 +1000 (AEST)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 12B6E601F1;
	Sat, 12 Sep 2026 09:26:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3F0A1F000FF;
	Sat, 12 Sep 2026 09:26:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789205164;
	bh=RcssxDcliU7vD3F+mu6uXNvjkcF5Kkz6UZoypW6r5jc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=D+QIGsAKeIU3e1n1EgW8EZSrtxXvyZFGHtxApR4t18y5GNG7qD5Mssh8ZLiPlJXNo
	 Xmedjs6S5jVpggf/YrwhL+YwLRzQ5IwTVLsga46jrB9++SqS3JI2EPInYLXY4xSyse
	 p0Iqkshow7wk6rpF+b8CUfbt0UMVFO7u1+ZkmwlAk55xQ9RTnvTnreIwX+BfjP/5qM
	 HJhhNYGr3Molvixaeyb3rCyXlxQw3bftpUgfYRtyTJKh3KdY5UgSmTNLQiH5gX5yPf
	 LrJsIW3rcCFDB+vfLn1ZCBHM1/I/+yWAtaQwjn5+SMOoShHNW2fodCegzj/JTFl5vT
	 tLvQd+XSDLzyQ==
Date: Sat, 12 Sep 2026 17:25:57 +0800
From: Gao Xiang <xiang@kernel.org>
To: Binglei Wang <l3b2w1@gmail.com>
Cc: linux-erofs@lists.ozlabs.org, xiang@kernel.org, chao@kernel.org,
	shengyong1@xiaomi.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] erofs: fix unbalanced buf->off handling in erofs_bread()
Message-ID: <aqUapQtNF7DK-A5J@XiangdeMacBook-Pro.local>
Mail-Followup-To: Binglei Wang <l3b2w1@gmail.com>,
	linux-erofs@lists.ozlabs.org, xiang@kernel.org, chao@kernel.org,
	shengyong1@xiaomi.com, linux-kernel@vger.kernel.org
References: <20260912025709.25604-1-l3b2w1@gmail.com>
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
In-Reply-To: <20260912025709.25604-1-l3b2w1@gmail.com>

On Sat, Sep 12, 2026 at 10:57:09AM +0800, Binglei Wang wrote:
> From: Binglei Wang <l3b2w1@gmail.com>
> 
> erofs_bread() locates the target folio with
> 
> 	index = (buf->off + offset) >> PAGE_SHIFT;
> 
> but computes the in-folio offset without taking buf->off into account:
> 
> 	return buf->base + (offset & ~PAGE_MASK);
> 
> If buf->off is not page-aligned, the returned pointer misses the in-page
> component of buf->off, so callers end up fetching data from a wrong
> offset.
> 
> buf->off is set to sbi->dif0.fsoff in erofs_init_metabuf(), and fsoff can
> be specified via the "fsoffset=" mount option, which only requires
> block-size alignment.  Therefore, on an image with a sub-page block size
> (e.g. 512 bytes), a non-page-aligned fsoff (e.g. 512) triggers the issue,
> since 512 is a multiple of the block size but not of PAGE_SIZE.
> 
> It can be reproduced by mounting an image that is placed at a
> non-page-aligned offset:
> 
> 	mkfs.erofs -b512 -zlz4hc sub.erofs src/
> 	# prepend 512 bytes of padding to the image
> 	mount -t erofs -o loop,fsoffset=512 padded.erofs /mnt
> 
> which fails with
> 
> 	erofs (device loop0): cannot find valid erofs superblock
> 
> because the on-disk superblock (at offset 1024 within the image, i.e.
> 1536 within the padded file) is read from a wrong in-folio offset.  With
> this fixed, the very same image mounts successfully and its file contents
> match those read from the unpadded image.
> 
> Fix it by including buf->off in the in-folio offset calculation, so that
> it is consistent with the folio index calculation.
> 
> Fixes: c36ec00d7f67 ("erofs: add 'fsoffset' mount option to specify filesystem offset")
> Cc: <stable@vger.kernel.org> # 6.16+
> Signed-off-by: Binglei Wang <l3b2w1@gmail.com>

As I said, I aiready applied a version before, please don't
send it again.

Thanks,
Gao Xiang

