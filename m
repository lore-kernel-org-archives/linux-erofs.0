Return-Path: <linux-erofs+bounces-4266-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 24ED0C5DF87
	for <linux-erofs@archiver.kernel.org>; Thu, 20 Aug 2026 13:29:40 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hQknG2319z2xT6;
	Thu, 20 Aug 2026 23:29:38 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2600:3c0a:e001:78e:0:1991:8:25"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1787232578;
	cv=none; b=J1cSiL6L9/hVcvVnjXLvZZUzIoAA8OoybFEnp+D6cGzpanwCCY2Ey0QjY1vJqFSNSDMZjI3/VUyAsxoSzLnXP2G4SmaOFHe2VykjUfXRj0Tw8Jklx6a8XJtnwc3lK78vwmm3V09Nhgpia6GAuoH+EFbx/VNU+Z1YYIjvtFX8/m8euYAOHx1iLaMaaJYglqkoanj2RiCpuXW7sdnGvMOp6xg9kRL8HzpWDMHe/4/qO/iWUMrjFJI7XVwEEozbxxu9Fy2CuadZOxkVFhuYDe/6XeGy9yoUn0Jy7/KkVJSvSjdvft88LLhXNWv2M+ZK3i5zHzUJ1VWCgiewa2YrkuVDwg==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1787232578; c=relaxed/relaxed;
	bh=9+xIvAivAkJoFwbhPgrhK0pKgw8dpD6Dl6gXNIdc8VM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZiBXv/ewoQc66glYb3irT742I7sDkfOHxeYMOcQZJTFTFo+P9gbtynryfbnYGfhP433c75FaWoZM2D+Y4iIGQFJAK5sCxojXOLrLxltnM2ss0NEYGLB9N+wZdu1ehYRh/cPI7I3Scx5GNaqSIGdjyAopY3V5Hl6Gi9RIWlnjIs2P9oXqwGXJk0vQhaQGRNCQDAn6dvCJcaI5A7h+r2eBwrUZAk1P+Vv0ujl0igJqGI6wp5HNa4+wiZ+FUV85T0wJrm6eC6i718fH1XIjki6RCRv4/C6PnjlCTzVY9isTmCb3ylsg0Bdr/t6d73TQ6Wr/+oRmVbuolEhXlcRYjjqzdg==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=oP2TIhGk; dkim-atps=neutral; spf=pass (client-ip=2600:3c0a:e001:78e:0:1991:8:25; helo=sea.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=oP2TIhGk;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=2600:3c0a:e001:78e:0:1991:8:25; helo=sea.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org)
Received: from sea.source.kernel.org (sea.source.kernel.org [IPv6:2600:3c0a:e001:78e:0:1991:8:25])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hQknD3Dcjz2xRw
	for <linux-erofs@lists.ozlabs.org>; Thu, 20 Aug 2026 23:29:36 +1000 (AEST)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id EB275409E2;
	Thu, 20 Aug 2026 13:29:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B12311F000E9;
	Thu, 20 Aug 2026 13:29:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787232572;
	bh=9+xIvAivAkJoFwbhPgrhK0pKgw8dpD6Dl6gXNIdc8VM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=oP2TIhGkYtlMKI0tJv5XkySJXP2D8XaR3Q89wvDUMrWZbL64F1bmqv2nlfFwVCaH7
	 RyHOZWhFcByUFSNHeVtQLIm5noQvlA0upTqJ9Y+rqOudAj+CuR/ER3FPFMttadnnVH
	 h5GI4OJLfcMwJDENvXJN7P4uRQ9E1nOwR2MAhP93SBpr7b8AwFxJa0+jPSuTTXa792
	 kVxbzfRpPteepw1h5/iqV6CUsiH+Q+eWUVS8WcZAhcpGy93Eh2wj13HVtz+Zwqt4Wv
	 9obE11m7vkN4krbMaJv3J/p1CMbsUm+/yp0FanFoKyc22tSWPXjFIdatLc8kL47JD1
	 jtx41w2wymj/A==
Date: Thu, 20 Aug 2026 21:29:23 +0800
From: Gao Xiang <xiang@kernel.org>
To: Zhan Xusheng <zhanxusheng1024@gmail.com>
Cc: Gao Xiang <xiang@kernel.org>, Chao Yu <chao@kernel.org>,
	Jingbo Xu <jefflexu@linux.alibaba.com>, zhanxusheng@xiaomi.com,
	linux-erofs@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] erofs: use the shared page cache for splice in
 inode_share mode
Message-ID: <aocBM-43e9Ea_vDK@XiangdeMacBook-Pro.local>
Mail-Followup-To: Zhan Xusheng <zhanxusheng1024@gmail.com>,
	Gao Xiang <xiang@kernel.org>, Chao Yu <chao@kernel.org>,
	Jingbo Xu <jefflexu@linux.alibaba.com>, zhanxusheng@xiaomi.com,
	linux-erofs@lists.ozlabs.org, linux-kernel@vger.kernel.org
References: <20260820064441.1083470-1-zhanxusheng@xiaomi.com>
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
In-Reply-To: <20260820064441.1083470-1-zhanxusheng@xiaomi.com>

Hi Xusheng,

On Thu, Aug 20, 2026 at 02:44:41PM +0800, Zhan Xusheng wrote:
> From: Zhan Xusheng <zhanxusheng1024@gmail.com>
> 
> From: Zhan Xusheng <zhanxusheng@xiaomi.com>
> 

the subject can be improved as "erofs: support splice() in inode_share mode"

> erofs_ishare_fops routes everything that touches the page cache to the
> backing file in ->private_data: read_iter clones the iocb onto it, mmap
> does vma_set_file(), fadvise calls vfs_fadvise() on it.  splice_read was
> left as filemap_splice_read(), which works on the user file's own mapping.
> 
> filemap_splice_read() does init_sync_kiocb(&iocb, in), and
> filemap_get_pages() then takes iocb->ki_filp->f_mapping, so splice() and
> sendfile() populate the per-file page cache from disk instead of using the
> shared one.  The data is correct, since erofs_fill_inode() sets that
> mapping's a_ops either way, but the same content ends up cached twice,
> which is what inode_share is there to avoid.
> 
> Pass the backing file, as read_iter already does.
> 
> Fixes: 5ef3208e3be5 ("erofs: introduce the page cache share feature")
> Link: https://lore.kernel.org/all/b7dc7192-d586-45a2-bc4a-b41dc681c9bb@linux.alibaba.com/
> Signed-off-by: Zhan Xusheng <zhanxusheng@xiaomi.com>

I observed the sashiko's report too:
https://sashiko.dev/#/patchset/20260818113713.116849-1-jefflexu%40linux.alibaba.com

Regardless of the implementation details, I don't think it is a fix
since this feature should be considered as a best-effort approach.

If it's an enhancement, please also write an erofs-utils test and
drop the fixes tag.

Thanks,
Gao Xiang

