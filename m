Return-Path: <linux-erofs+bounces-2267-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9DA03EB28D3
	for <linux-erofs@archiver.kernel.org>; Fri,  6 Feb 2026 07:11:43 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4f6ldB26B8z2yFc;
	Fri, 06 Feb 2026 18:11:42 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=115.124.30.97
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1770361902;
	cv=none; b=I1sOGBGvuPBm0mggcQFrb1RZ3EMlyyWjAelkDMqnazJF5PZ+BXuJAE6PwX4i+woQr4NHciH6sLrB1DRpo+IGRdx+6vnBwYju2ZjUFr2SQmh39xftdGgVptPjmKeLEtvQvv0xCOJruzj1HwyAW1O+bkLWW2ilcjEYj+Ls2fv/279xxeRSpZdsnsdw2Mqakq1CDmWGnev4wbaKPWh+zD0waisfpHeeEkrqMiuwt1JboZk649FMyTTWyY4iGAlWXkjhdfRt/BYldUup1RyexTTi30FIxnhfgALBJVrUR7gtr3v+JAdgz1iD5QgycBTXYhzJwmUYK3crpvmXrAT9pseXcg==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1770361902; c=relaxed/relaxed;
	bh=73E12KM7OPacSNBdFgE+X8jRF2V44mwSSiTiiiemsUQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ZjL+9MzIdAfbsMaKZRR+O0fBXZc6WfenmqVjKIsot2FNWxbvWanDdPpGYbofb8F5tcJFWRYdA/y9A9ysDxhFCrYr7+sFj/+0ROCFPFX2jBDT5+YNkd6rfId3VMX4ZtkCqhtE6BAJ2akR6FfqOzKfF5G6l1IieuVxKmn4Jp1J2ToheWdH98nuuOrSZalrHAH4xzU8dQ3N+rTg4iYqsfN64Q2Vr1l6D1MOYBNIglpoS+9tzcuLf5jjFKBvp4eWP1GuFUqbo1NMIQMrXQ/v3HPhY5clQ9YeAnUGmuPLTel6zzDm5sZ4u/ERFRCsN422k3rSCIXea8Dfbvg96h5BqNIsCQ==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=VfUIDzK8; dkim-atps=neutral; spf=pass (client-ip=115.124.30.97; helo=out30-97.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org) smtp.mailfrom=linux.alibaba.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=VfUIDzK8;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=linux.alibaba.com (client-ip=115.124.30.97; helo=out30-97.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org)
Received: from out30-97.freemail.mail.aliyun.com (out30-97.freemail.mail.aliyun.com [115.124.30.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4f6ld63fTlz2xqk
	for <linux-erofs@lists.ozlabs.org>; Fri, 06 Feb 2026 18:11:36 +1100 (AEDT)
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1770361890; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=73E12KM7OPacSNBdFgE+X8jRF2V44mwSSiTiiiemsUQ=;
	b=VfUIDzK81ft7hvmW9ROyxDcZOxPv5VyE8L6UY2vNqsh7SWbyQdr3DDNkRo37FgTqEP7F4Rg6gyqPa7/gVIwMvqBXaqvIkk10x1gQBYcnL3OAxnoC28X4m3NYlhoSytk5mM+nHp1MToKeKf4lmS1lAGxCQ2jLZ+UMFDKMf8dEGq4=
Received: from 30.221.130.105(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0WydhgzM_1770361887 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 06 Feb 2026 15:11:28 +0800
Message-ID: <9d70646b-ddf8-42b5-8015-fb54a6f24296@linux.alibaba.com>
Date: Fri, 6 Feb 2026 15:11:27 +0800
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
Subject: Re: [PATCH] erofs: fix UAF issue in erofs_fileio_rq_submit()
To: Chao Yu <chao@kernel.org>, xiang@kernel.org
Cc: linux-erofs@lists.ozlabs.org, linux-kernel@vger.kernel.org,
 stable@kernel.org
References: <20260205223005.72727-1-chao@kernel.org>
From: Gao Xiang <hsiangkao@linux.alibaba.com>
In-Reply-To: <20260205223005.72727-1-chao@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Chao,

On 2026/2/6 06:30, Chao Yu wrote:
> [    9.269940][ T3222] Call trace:
> [    9.269948][ T3222]  ext4_file_read_iter+0xac/0x108
> [    9.269979][ T3222]  vfs_iocb_iter_read+0xac/0x198
> [    9.269993][ T3222]  erofs_fileio_rq_submit+0x12c/0x180
> [    9.270008][ T3222]  erofs_fileio_submit_bio+0x14/0x24
> [    9.270030][ T3222]  z_erofs_runqueue+0x834/0x8ac
> [    9.270054][ T3222]  z_erofs_read_folio+0x120/0x220
> [    9.270083][ T3222]  filemap_read_folio+0x60/0x120
> [    9.270102][ T3222]  filemap_fault+0xcac/0x1060
> [    9.270119][ T3222]  do_pte_missing+0x2d8/0x1554
> [    9.270131][ T3222]  handle_mm_fault+0x5ec/0x70c
> [    9.270142][ T3222]  do_page_fault+0x178/0x88c
> [    9.270167][ T3222]  do_translation_fault+0x38/0x54
> [    9.270183][ T3222]  do_mem_abort+0x54/0xac
> [    9.270208][ T3222]  el0_da+0x44/0x7c
> [    9.270227][ T3222]  el0t_64_sync_handler+0x5c/0xf4
> [    9.270253][ T3222]  el0t_64_sync+0x1bc/0x1c0
> 
> erofs may encounter above panic when enabling file-backed mount w/ directio
> mount option, the root cause is it may suffer UAF in below race condition:
> 
> - z_erofs_read_folio                          wq s_dio_done_wq
>   - z_erofs_runqueue
>    - erofs_fileio_submit_bio
>     - erofs_fileio_rq_submit
>      - vfs_iocb_iter_read
>       - ext4_file_read_iter
>        - ext4_dio_read_iter
>         - iomap_dio_rw
>         : bio was submitted and return -EIOCBQUEUED
>                                                - dio_aio_complete_work
>                                                 - dio_complete
>                                                  - dio->iocb->ki_complete (erofs_fileio_ki_complete())
>                                                   - kfree(rq)
>                                                   : it frees iocb, iocb.ki_filp can be UAF in file_accessed().
>         - file_accessed
>         : access NULL file point
> 
> Introduce a reference count in struct erofs_fileio_rq, and initialize it
> as two, both erofs_fileio_ki_complete() and erofs_fileio_rq_submit() will
> decrease reference count, the last one decreasing the reference count
> to zero will free rq.
> 
> Cc: stable@kernel.org
> Fixes: fb176750266a ("erofs: add file-backed mount support")
> Signed-off-by: Chao Yu <chao@kernel.org>

Thanks for catching this:

I will update the subject as
"erofs: fix UAF issue for file-backed mounts w/ directio"

to make it more clear about the impacts.

Reviewed-by: Gao Xiang <hsiangkao@linux.alibaba.com>

Thanks,
Gao Xiang

