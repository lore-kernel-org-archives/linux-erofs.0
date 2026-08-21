Return-Path: <linux-erofs+bounces-4281-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 798BAC5DF88
	for <linux-erofs@archiver.kernel.org>; Fri, 21 Aug 2026 06:33:56 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hR9W62hn5z2xnW;
	Fri, 21 Aug 2026 16:33:54 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=115.124.30.132
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1787294034;
	cv=none; b=Hu18hbrnXfuLt1G1SgydamdUqTbKdItdbeN9nY90rAXZDp47QvR9sL8JpE56hr4+wAUFntmvofDh/9XmMH9/cOqn0ovg6XU9+SfixaDXg3KCuM3xGP8e3CaIuGXhlwIQvIjZrsr/KwlftXcuK3LjnbkhmLY4lYJo9sYcysjO9a9dyC/PLdPff6nu6oYcjsUpAlIuZQR4EXlT+qNrgD1GV4g5S/+59Zz97gFmPHQvHRrTCK9lMVFpnl7fPmxkBE/tQlXhQQe9fLNbbqeTkABsBwVwtP+JuwgBtlc/pLR/z9hf+R2DGPA+nTui68jUkkeYfxcjSALLE8lgb8SySYrzGA==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1787294034; c=relaxed/relaxed;
	bh=A2dL1eEVT2+14dzzJ8BeskCqbSp+ITcLrJsYW8Szvuo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=W8P5OKJumuRrk69972YJPRf3xrd4kgdrl4yRKDc4nPJY686kQIPStVPL13W6NicD494bXE2k3rw8dF1ldocntkXcZ3Prn2BQsC3asOPhKMwGoaFOfp7gg3Cj0d4py2Cj8Sb+t6BHKKYX6JyahnEPO+JfvB/5ExiZcojlG6jL3Z0ljIiPxcbwml31oCwvDANXZvToudxl/+XtTChy6/bnNkv9E9GVBLgGE8EmclXK7jmxBSZOoiDUx4F9qe7C4EHyETekSsphNy3CL9cjQCx7xyF0WBOwwroncqHmxVRWog8yDGA9tpdPvETuHxkn8Th8lFfBCrXZ85K6RhnWpaTGTw==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=fUjiqSUU; dkim-atps=neutral; spf=pass (client-ip=115.124.30.132; helo=out30-132.freemail.mail.aliyun.com; envelope-from=jefflexu@linux.alibaba.com; receiver=lists.ozlabs.org) smtp.mailfrom=linux.alibaba.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=fUjiqSUU;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=linux.alibaba.com (client-ip=115.124.30.132; helo=out30-132.freemail.mail.aliyun.com; envelope-from=jefflexu@linux.alibaba.com; receiver=lists.ozlabs.org)
Received: from out30-132.freemail.mail.aliyun.com (out30-132.freemail.mail.aliyun.com [115.124.30.132])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hR9W30jhCz2xWt
	for <linux-erofs@lists.ozlabs.org>; Fri, 21 Aug 2026 16:33:47 +1000 (AEST)
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1787294022; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=A2dL1eEVT2+14dzzJ8BeskCqbSp+ITcLrJsYW8Szvuo=;
	b=fUjiqSUURl3B3YmzWVqW6J/gSG9hd3pgJZB+qQD7WW9Lr7Bsid6GfHwrRGgmwMWIMcF2qBjU3QfQ9FNl2Fsl+odkliHREkg1bE+ugion4f3mS9aYSjuNw9lc4bplicjcvi4JC04H5BwwYiS57LUMUCFEtPPRChf3f8Y8b4QW26E=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R151e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033032089153;MF=jefflexu@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0X9LOWQM_1787294017;
Received: from 30.221.150.0(mailfrom:jefflexu@linux.alibaba.com fp:SMTPD_---0X9LOWQM_1787294017 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 21 Aug 2026 14:33:37 +0800
Message-ID: <866a9563-70e3-444f-909c-bb8b85688657@linux.alibaba.com>
Date: Fri, 21 Aug 2026 14:33:36 +0800
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
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] erofs: support splice() in inode_share mode
To: Zhan Xusheng <zhanxusheng1024@gmail.com>, Gao Xiang <xiang@kernel.org>,
 Chao Yu <chao@kernel.org>
Cc: zhanxusheng@xiaomi.com, linux-erofs@lists.ozlabs.org,
 linux-kernel@vger.kernel.org
References: <20260821015641.1936276-1-zhanxusheng@xiaomi.com>
Content-Language: en-US
From: Jingbo Xu <jefflexu@linux.alibaba.com>
In-Reply-To: <20260821015641.1936276-1-zhanxusheng@xiaomi.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 8/21/26 9:56 AM, Zhan Xusheng wrote:
> From: Zhan Xusheng <zhanxusheng1024@gmail.com>
> 
> From: Zhan Xusheng <zhanxusheng@xiaomi.com>
> 
> erofs_ishare_fops routes everything that touches the page cache to the
> backing file in ->private_data: read_iter clones the iocb onto it, mmap
> does vma_set_file(), fadvise calls vfs_fadvise() on it.  splice_read was
> left as filemap_splice_read(), which works on the user file's own mapping:
> it does init_sync_kiocb(&iocb, in), and filemap_get_pages() then takes
> iocb->ki_filp->f_mapping.
> 
> So splice() and sendfile() fill the per-inode page cache rather than the
> shared one.  The content is the same either way, since erofs_fill_inode()
> sets a_ops on that mapping too, which is why this went unnoticed.  Two
> identical 8 MiB files under inode_share, reading one of them with splice(2)
> alone, in pages:
> 
>   before   own 2048   shared 0
>   after    own 0      shared 2048
> 
> "own" is cachestat(fd), which reports the file's own mapping; "shared" is
> mmap()+mincore(), which erofs_ishare_mmap() redirects to the backing file.
> 
> Read through the backing file, as read_iter already does.
> 
> Link: https://lore.kernel.org/all/b7dc7192-d586-45a2-bc4a-b41dc681c9bb@linux.alibaba.com/
> Signed-off-by: Zhan Xusheng <zhanxusheng@xiaomi.com>

LGTM.

Reviewed-by: Jingbo Xu \<jefflexu@linux.alibaba.com\>

> ---
> v1->v2:
> - Retitled and dropped the Fixes tag: the sharing is best effort, so
>   this is an enhancement rather than a fix.
> - Added the measured before/after.
> - Left file_accessed() alone, since it is a no-op under SB_NOATIME.
> - An erofs-utils test is sent separately against experimental-tests.
> 
> v1: https://lore.kernel.org/all/20260820064441.1083470-1-zhanxusheng@xiaomi.com
> 
>  fs/erofs/ishare.c | 9 ++++++++-
>  1 file changed, 8 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/erofs/ishare.c b/fs/erofs/ishare.c
> index fa7d4112dec5..01dc53e9e3ad 100644
> --- a/fs/erofs/ishare.c
> +++ b/fs/erofs/ishare.c
> @@ -148,6 +148,13 @@ static int erofs_ishare_mmap(struct file *file, struct vm_area_struct *vma)
>  	return generic_file_readonly_mmap(file, vma);
>  }
>  
> +static ssize_t erofs_ishare_splice_read(struct file *in, loff_t *ppos,
> +					struct pipe_inode_info *pipe,
> +					size_t len, unsigned int flags)
> +{
> +	return filemap_splice_read(in->private_data, ppos, pipe, len, flags);
> +}
> +
>  static int erofs_ishare_fadvise(struct file *file, loff_t offset,
>  				loff_t len, int advice)
>  {
> @@ -161,7 +168,7 @@ const struct file_operations erofs_ishare_fops = {
>  	.mmap		= erofs_ishare_mmap,
>  	.release	= erofs_ishare_file_release,
>  	.get_unmapped_area = thp_get_unmapped_area,
> -	.splice_read	= filemap_splice_read,
> +	.splice_read	= erofs_ishare_splice_read,
>  	.fadvise	= erofs_ishare_fadvise,
>  };
>  

-- 
Thanks,
Jingbo


