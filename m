Return-Path: <linux-erofs+bounces-4267-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B4D40C5DF81
	for <linux-erofs@archiver.kernel.org>; Thu, 20 Aug 2026 13:34:01 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hQktJ1q5gz2xT6;
	Thu, 20 Aug 2026 23:34:00 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=172.234.252.31
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1787232840;
	cv=none; b=Z37NXPJMPr9d1aFr/KPzMbZt0/Bu527kgO+bmpgiH/bn15Hzj2ZQMrc9ysRwuhOtcIpsj042kh8RNOTMDMNr5c989H8e2QzCV1QK7QoOSlHNCEJ+XDAiAgUIkXodHmaeD47PxIgbhvRbGHxjwDHEAuPPevakraRM1RNyWX1fSVyDVJ5HSbsLN4cBSEdmYCN8qUGbjkR5dRqOijoOmwOf5bctcKzpBuJb8QblI1w2M7x+YNYQiz/e9Uf68g/GhVRpoZ4N5aB/Bz2yEdAl9JapL4f53Cyo/2WZa5exL2HsYguc7cZcoDyFDLzc+hyhSwg6REqCdvHGKo+0jAu/HYc+Cg==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1787232840; c=relaxed/relaxed;
	bh=LbGyTW7vRWPON5I5dgHRtEXadLVcIPrLH2urM6dqQ+Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bJor0CaJ6/V/XMIz0zUhfKD3EhiuPAX4jCSkCYgduW0kGuGvtjcvphNIYOz8kxfDZfbHsNnMPvCcFXrHOwriYvmhoBOo5eruxTzgoEeAm2i27hR6KpLHX+PA7wWJHMHFcITbQR6torm8SrndEu5XWRwaAXfkI4HthGtvNyen0k+7F7IMrwxXrWMc4YNM4kQLw3c/xe21GgwzCfnRk2lZPkw+Og6tC0QjCUf3Gq3KP7ZY96WBcpOmyGPu88E9XTnLbPhktWaNNIYmk+p7ENho2bu0Xtw+RHgfogkQAV22Lk1Atdh2LqOqozhbp5hpdrarE+YzPAHZ7hAD5mZufqwrow==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=k2zHofpj; dkim-atps=neutral; spf=pass (client-ip=172.234.252.31; helo=sea.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=k2zHofpj;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=172.234.252.31; helo=sea.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org)
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hQktH4Mjtz2xRw
	for <linux-erofs@lists.ozlabs.org>; Thu, 20 Aug 2026 23:33:59 +1000 (AEST)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 71A244233C;
	Thu, 20 Aug 2026 13:33:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EDD21F00A3A;
	Thu, 20 Aug 2026 13:33:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787232837;
	bh=LbGyTW7vRWPON5I5dgHRtEXadLVcIPrLH2urM6dqQ+Y=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=k2zHofpjD2dl+NpLakhmQTgFlJjH0Ca5WMR8Ozbcr4D55PS3/R558M+oS0OCYekDV
	 Y/czbLy5UnKT0NlWfwwV5CBpMtFutbenRetnCV7DgL0CvX/kj7JH4Tsw8BrQqfIOGQ
	 xqN/DLDcQRvO7VvUxMEbK3paBXCVkVOzOqd1BMIgXE/Svj8lnKr/XQpkVeaDVP/enB
	 KX5gB6zYIlCbFI8zzkTiqenrTZVdgLb7I1soKZ4aitgCqUOQXZ2XTATqwlaWy2KU/L
	 Ji8EGAYKcBYTlaW/UmhGYOIeybO30nONDxFhb+l8PH6j4EvKazeD52cTIRnhic8pKz
	 58PFj/4kqwnNw==
Date: Thu, 20 Aug 2026 21:33:49 +0800
From: Gao Xiang <xiang@kernel.org>
To: Jingbo Xu <jefflexu@linux.alibaba.com>
Cc: xiang@kernel.org, chao@kernel.org, linux-erofs@lists.ozlabs.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] erofs: support SEEK_HOLE/SEEK_DATA in inode_share mode
Message-ID: <aocCPbxFolZd_VIk@XiangdeMacBook-Pro.local>
Mail-Followup-To: Jingbo Xu <jefflexu@linux.alibaba.com>, xiang@kernel.org,
	chao@kernel.org, linux-erofs@lists.ozlabs.org,
	linux-kernel@vger.kernel.org
References: <20260818113713.116849-1-jefflexu@linux.alibaba.com>
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
In-Reply-To: <20260818113713.116849-1-jefflexu@linux.alibaba.com>

Hi Jingbo,

On Tue, Aug 18, 2026 at 07:37:13PM +0800, Jingbo Xu wrote:
> When inode_share is enabled, erofs_ishare_fops.llseek falls back to
> generic_file_llseek, which treats the whole file as data and always
> returns i_size for SEEK_HOLE, hiding real holes in sparse files.
> 
> Switch it to erofs_file_llseek instead.  For user files f_mapping->host
> is always the real erofs inode, so SEEK_HOLE/SEEK_DATA resolve the
> per-file on-disk layout via iomap_seek_hole()/iomap_seek_data().
> 
> Reported-by: Yuanhe Shu <xiangzao@linux.alibaba.com>
> Signed-off-by: Jingbo Xu <jefflexu@linux.alibaba.com>
> ---
>  fs/erofs/data.c     | 2 +-
>  fs/erofs/internal.h | 2 ++
>  fs/erofs/ishare.c   | 2 +-
>  3 files changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/erofs/data.c b/fs/erofs/data.c
> index d2f01245ee79..09d668deb86d 100644
> --- a/fs/erofs/data.c
> +++ b/fs/erofs/data.c
> @@ -509,7 +509,7 @@ static int erofs_file_mmap_prepare(struct vm_area_desc *desc)
>  #define erofs_file_mmap_prepare	generic_file_readonly_mmap_prepare
>  #endif
>  
> -static loff_t erofs_file_llseek(struct file *file, loff_t offset, int whence)
> +loff_t erofs_file_llseek(struct file *file, loff_t offset, int whence)
>  {
>  	struct inode *inode = file->f_mapping->host;
>  	const struct iomap_ops *ops = &erofs_iomap_ops;
> diff --git a/fs/erofs/internal.h b/fs/erofs/internal.h
> index 57bd21859c65..3263c11d714c 100644
> --- a/fs/erofs/internal.h
> +++ b/fs/erofs/internal.h
> @@ -528,6 +528,8 @@ static inline struct inode *erofs_real_inode(struct inode *inode, bool *need_ipu
>  }
>  #endif
>  
> +loff_t erofs_file_llseek(struct file *file, loff_t offset, int whence);
> +

Could you move this line below erofs_fiemap()? I hope all declarations
in data.c are closer.

Otherwise it looks good to me,
Reviewed-by: Gao Xiang <xiang@kernel.org>

Also could you help write a test for this functionality too?

Thanks,
Gao Xiang

