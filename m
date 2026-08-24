Return-Path: <linux-erofs+bounces-4294-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 26B7EC5DF97
	for <linux-erofs@archiver.kernel.org>; Mon, 24 Aug 2026 00:46:48 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hSsgB2xq4z2y2P;
	Mon, 24 Aug 2026 10:46:46 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2600:3c0a:e001:78e:0:1991:8:25"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1787532406;
	cv=none; b=XSpU9R/8xaxKJpwyNSMPQFP/7mhsrFNPiWuQqgXBZgSvR8MEwNM/gg/6wUbvEZWap5TcaPFY09Ndyy1+rLSMxhp4QjU91q7h+OkSTXOqTdqu+9Jn8GQ10LuN6LUvOuxDC6ot/fmT7H7S1zJF+kBm5e9yELmbu6cS/j5CTaKXNmgvZhuMaAFb9uK/uH0mf/R/J8Q2rlzOzrm92enmebCvlJ5BnqJRki1YiN3JGSTNlTrPFXbXpjY/LWDQoO+6+ceeQ/dCewPBA6nZAxXsP8O4pkZh/8qaCcgYyZQFtxM7hBGY2MajTUHjQ76GvhYg9MfuXF50ocUhS/zN1OyEIETjEA==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1787532406; c=relaxed/relaxed;
	bh=R/3OWfaIF1a/3j0UN2xNBi9yIyeiwvp1Q+6gqCJ7gQQ=;
	h=Message-ID:Date:MIME-Version:Cc:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=MwxV1V2Fp6hTmXzfYCvb6QINj4Yh1PeKlmdJIxBMdMnf6NCd/Z16XTMlVW9nyBpqK6B9Uy7kE3qu4e3usxK5HLzttRPVU0oxqNLHNXjrMB18Ss1UyMPq1/+810xGOB/7mNkFk524PT1jIC0J17rNmskkFEnGuhmL0ZjTT1HZkc0U1Ubh6OqDG/nssFbZ4jHaRTZEmi78uG4xgc01CBBckB/ZePlxo4AH7KPtZmGw9sIjx+NoSqobrri/SZjzRwshN3gGcf9L+pTzrDE5hv2Rfexyplj9mZBhLhDTXgpDkknECWcptHUzyUhuSllMgYPoWxLpMHp8V0fr2/p3RF1W9Q==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Z4jbfSSB; dkim-atps=neutral; spf=pass (client-ip=2600:3c0a:e001:78e:0:1991:8:25; helo=sea.source.kernel.org; envelope-from=chao@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Z4jbfSSB;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=2600:3c0a:e001:78e:0:1991:8:25; helo=sea.source.kernel.org; envelope-from=chao@kernel.org; receiver=lists.ozlabs.org)
Received: from sea.source.kernel.org (sea.source.kernel.org [IPv6:2600:3c0a:e001:78e:0:1991:8:25])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hSsg959kgz2xns
	for <linux-erofs@lists.ozlabs.org>; Mon, 24 Aug 2026 10:46:45 +1000 (AEST)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 625274323B;
	Mon, 24 Aug 2026 00:46:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B46521F000E9;
	Mon, 24 Aug 2026 00:46:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787532403;
	bh=R/3OWfaIF1a/3j0UN2xNBi9yIyeiwvp1Q+6gqCJ7gQQ=;
	h=Date:Cc:Subject:To:References:From:In-Reply-To;
	b=Z4jbfSSB8+JFnf8woci6zxuz5eiJ2W6ZQ8ye3NMmlH07CkJHnpNzCaXDIq+bAFzve
	 KAj12r2yjfkLY7Kr62Q9HAA/7MVcGrTMhcuS/SEkcxwU/ufOjkMF4d/GiZnJhP1NiG
	 3b7f7Sv6v+Oj1wQ9vcZT+C9cva88/jr3yhSONzuv1nlCvK0fd8NQ6Z2Itf2Al63t5G
	 pjcRM0yQGHeNP8oZv8ZsClQcAZti4K3zI1Kllu6HzDJWYlQ87hCZvB9He544oR3mx+
	 l9fiMkT+BA5M8L6P2mlLwII5+N2iW91PbhTSR9sOkbrjmYYnE4tvILl7+AGHBxS4on
	 8W8RmKq46KPDg==
Message-ID: <db054464-072a-4246-810f-07385606725e@kernel.org>
Date: Mon, 24 Aug 2026 08:46:39 +0800
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
Cc: chao@kernel.org, Jingbo Xu <jefflexu@linux.alibaba.com>,
 zhanxusheng@xiaomi.com, linux-erofs@lists.ozlabs.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] erofs: support splice() in inode_share mode
To: Zhan Xusheng <zhanxusheng1024@gmail.com>, Gao Xiang <xiang@kernel.org>
References: <20260821015641.1936276-1-zhanxusheng@xiaomi.com>
Content-Language: en-US
From: Chao Yu <chao@kernel.org>
In-Reply-To: <20260821015641.1936276-1-zhanxusheng@xiaomi.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/21/26 09:56, Zhan Xusheng wrote:
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
>    before   own 2048   shared 0
>    after    own 0      shared 2048
> 
> "own" is cachestat(fd), which reports the file's own mapping; "shared" is
> mmap()+mincore(), which erofs_ishare_mmap() redirects to the backing file.
> 
> Read through the backing file, as read_iter already does.
> 
> Link: https://lore.kernel.org/all/b7dc7192-d586-45a2-bc4a-b41dc681c9bb@linux.alibaba.com/
> Signed-off-by: Zhan Xusheng <zhanxusheng@xiaomi.com>

Reviewed-by: Chao Yu <chao@kernel.org>

Thanks,

