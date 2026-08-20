Return-Path: <linux-erofs+bounces-4256-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8D63EC5DF81
	for <linux-erofs@archiver.kernel.org>; Thu, 20 Aug 2026 06:17:52 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hQYC213bSz2xGZ;
	Thu, 20 Aug 2026 16:17:50 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=115.124.30.101
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1787206670;
	cv=none; b=om7Q9NYpA5yjT2ipxCu/lYEFMNxqMeCbQdIXeudl1wc92k3nH8M3jV426kiy6nSPrP49/ta2VmoqYTYoTOA3BIa4JjDh+cf/ZclU56ZBBc8RHBL1JeyDn+/Y2tPH6Ux1wKC93bmAsmD7YbMOdnTvFEg9TqQHBvwu2RJzS5/oNFSJqBmElq0DK/jYMNpj0fHK9DJ8jIHn1MXv5GykrHxj2rFh0/r0xiuH75Qtaj07/Khwgmu3g+O9ls7pGkRh1DwXE5GSJM1p+qMpLPp+AEFZpQkAvPAAYwTggheMhtUbWKPrvE21PU4A/Wd1h66KhWm8FtfsYDkM/QjENanwlws1bw==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1787206670; c=relaxed/relaxed;
	bh=VW39S+Y9ewsWHglPkMQpttpscTWd37fCKvdYbG2Mvl0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=P8sfQRfkc2pIs1ayvwlXwEoLTEX/5CMbfmSHav9oU4vmaAWXNQ8jT3OX0R/dT0QV9tB8km2u8i1KNGDqE092TTDY7d75Mvl0fDOb9pU3zFubcM+TYLeKKuXzNbZao+V5oxPFa1cQbH6XAaRPf2oaqUr7lsRdfy5mRcy+h9d8nV3D6nkSnRqaIRZL/yF9rGfqrtRGEJLRMmHNjZ4Akr2NlhJd7AsICVcpGOWC+ULmWPAF5agz6/5paVE0/pBGvrxq6OmYQk3ywRrLkWFFXDEUX8hQgrLT8evT38KWj86bE6tEthEVSLuyXv1Vp7hco3a+ZCkOqDTIKJ6nELjO0VHIYw==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=Nj7LWb9z; dkim-atps=neutral; spf=pass (client-ip=115.124.30.101; helo=out30-101.freemail.mail.aliyun.com; envelope-from=jefflexu@linux.alibaba.com; receiver=lists.ozlabs.org) smtp.mailfrom=linux.alibaba.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=Nj7LWb9z;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=linux.alibaba.com (client-ip=115.124.30.101; helo=out30-101.freemail.mail.aliyun.com; envelope-from=jefflexu@linux.alibaba.com; receiver=lists.ozlabs.org)
Received: from out30-101.freemail.mail.aliyun.com (out30-101.freemail.mail.aliyun.com [115.124.30.101])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hQYBz1Brdz2xBK
	for <linux-erofs@lists.ozlabs.org>; Thu, 20 Aug 2026 16:17:44 +1000 (AEST)
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1787206658; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=VW39S+Y9ewsWHglPkMQpttpscTWd37fCKvdYbG2Mvl0=;
	b=Nj7LWb9zIzG00N+bow/q8Y+rM/ER5/UdUfGfpO7VGcFFj1w0t9Kas/gVt8KG6PImBLf0ffSJXLj0QdmEzbXjIPKCkpWRhefGHeI2mOHYpNcHQsMEAwxiBzgTuLTi9Say1LVM9wyOUNpdOhk1IFpUlANGW2/Ea+R3LWQaMQcQmBs=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R201e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037009110;MF=jefflexu@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0X9IboZw_1787206656;
Received: from 30.221.151.40(mailfrom:jefflexu@linux.alibaba.com fp:SMTPD_---0X9IboZw_1787206656 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 20 Aug 2026 14:17:37 +0800
Message-ID: <b7dc7192-d586-45a2-bc4a-b41dc681c9bb@linux.alibaba.com>
Date: Thu, 20 Aug 2026 14:17:36 +0800
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
Subject: Re: [PATCH] erofs: support SEEK_HOLE/SEEK_DATA in inode_share mode
To: Zhan Xusheng <zhanxusheng1024@gmail.com>, xiang@kernel.org,
 chao@kernel.org, linux-erofs@lists.ozlabs.org
Cc: Zhan Xusheng <zhanxusheng@xiaomi.com>, linux-kernel@vger.kernel.org
References: <20260818113713.116849-1-jefflexu@linux.alibaba.com>
 <20260820031100.1038753-1-zhanxusheng@xiaomi.com>
Content-Language: en-US
From: Jingbo Xu <jefflexu@linux.alibaba.com>
In-Reply-To: <20260820031100.1038753-1-zhanxusheng@xiaomi.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 8/20/26 11:10 AM, Zhan Xusheng wrote:
> On Tue, 18 Aug 2026 19:37:13 +0800, Jingbo Xu wrote:
>> - .llseek   = generic_file_llseek,
>> + .llseek   = erofs_file_llseek,
> 
> No objection to the change.  While in that table, .splice_read is the entry
> left that touches the page cache without going through ->private_data:
> 
>   .read_iter   kiocb_clone() onto private_data, then filemap_read()
>   .mmap        vma_set_file(vma, realfile)
>   .fadvise     vfs_fadvise(file->private_data, ...)
>   .splice_read filemap_splice_read
> 
> filemap_splice_read() does init_sync_kiocb(&iocb, in), and
> filemap_get_pages() then takes iocb->ki_filp->f_mapping (mm/filemap.c:2686),
> so it works on the user file's mapping, which after your patch is confirmed
> to be the real inode's.  erofs_fill_inode() sets that mapping's a_ops
> unconditionally, so the data splice() and sendfile() return is correct, but
> they populate the per-file page cache from disk rather than the shared one
> read() and mmap() use, caching the same content twice.

Right.  I think that would be another patch to fix that.

-- 
Thanks,
Jingbo


