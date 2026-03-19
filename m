Return-Path: <linux-erofs+bounces-2851-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6145B1090220
	for <linux-erofs@archiver.kernel.org>; Thu, 19 Mar 2026 13:43:02 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4fc6Mn0PpSz2ynW;
	Fri, 20 Mar 2026 00:43:01 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=115.124.30.111
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1773927780;
	cv=none; b=GcwHsE2Pl668zlWkWh3l4V3OIqI+0Uwxb/UTRvYK8UleCTnxnrgGzoW0byrN9rc/LnQX47tmH7ZYG6wiBfzvoN9NpOZbP2gPmsjq0A/+QNltbi5XimJS6yM/oRmfocCDAt5saMalV3HaGOusjD2iMsHh78XhKqTGVb84gPMhsRxOZL4ESdQBdMModgy1DyIpaP8WbEPNGUFWkvOoNaMzi9Vmy8GQNxdfnuSXv35ynOOFEyqN/RbMT4CFvkWMXWqyL6TodJqAJkDk6mQ42m79hEOimL3NWqcjyEnI96X5a0c156WwxfD72RX3wQswVmdq23TZQTJxvCxgAz0boFcYYg==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1773927780; c=relaxed/relaxed;
	bh=tmfaX+gDo7jzv0Fa7nRG9vE80MkzupGDtgs730OOnF4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=j+XtP0W3V2J5rXzEMHY9Nzz3y66C5e1P5RQQprLkHp4Pv34Z9/rY60VeocvixBX4apTiAbl1FHXLRZ12mE+59JRc6rbWwRLayKVadyJyLwkgufz8Ph36RGMDl+939J8XiuummQS7hZQQk3h3pQfoFxdUmhsiMcW7357UtKjomcxLqKPjNs4Tm1+JDpfxUvOGSLcfsk6Lg+K37XtB9hYqks8nVS1erK1rW7BMdsXQGR59WfYhC6m5Vt6zyogObryuTzlkIloFf2TnJjZ6YiRJytseHj9hsTWu6rwHvuVWOEA8GDUAvizDWAheq5U50vnpYiacvfHD5zG5C4Qqw7FUQQ==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=Plcs1AZy; dkim-atps=neutral; spf=pass (client-ip=115.124.30.111; helo=out30-111.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org) smtp.mailfrom=linux.alibaba.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=Plcs1AZy;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=linux.alibaba.com (client-ip=115.124.30.111; helo=out30-111.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org)
Received: from out30-111.freemail.mail.aliyun.com (out30-111.freemail.mail.aliyun.com [115.124.30.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4fc6Mk4yC8z2yLG
	for <linux-erofs@lists.ozlabs.org>; Fri, 20 Mar 2026 00:42:57 +1100 (AEDT)
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1773927773; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=tmfaX+gDo7jzv0Fa7nRG9vE80MkzupGDtgs730OOnF4=;
	b=Plcs1AZyrB3gMP+/ds6MoO9+suWXURDehhzVvihaTC+vxRMJUTbAo34MZvXH3GffripoAvc03zk+lpZ6+ZAn0RMGAXokePpIfWPRzuX77ZDGbuZjlj7NN+Tpwp4eVbtPeU4YToP1IomtYhR1NnsiNhSaFWTBzFgEczZ3bDZz5LM=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R201e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037026112;MF=hsiangkao@linux.alibaba.com;NM=1;PH=DS;RN=3;SR=0;TI=SMTPD_---0X.InFKp_1773927770;
Received: from 30.170.14.2(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0X.InFKp_1773927770 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 19 Mar 2026 21:42:50 +0800
Message-ID: <66b9d19a-4022-4110-a15f-da31845caad9@linux.alibaba.com>
Date: Thu, 19 Mar 2026 21:42:49 +0800
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
Subject: Re: [PATCH 1/2] erofs-utils: lib: replace bool locked with
 erofs_mutex_t for MT safety
To: Ajay Rajera <newajay.11r@gmail.com>, linux-erofs@lists.ozlabs.org
Cc: xiang@kernel.org
References: <20260319133948.396-1-newajay.11r@gmail.com>
From: Gao Xiang <hsiangkao@linux.alibaba.com>
In-Reply-To: <20260319133948.396-1-newajay.11r@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Ajay,

On 2026/3/19 21:39, Ajay Rajera wrote:
> Replace the bool locked field in erofs_diskbufstrm with erofs_mutex_t lock to provide proper mutual exclusion for multi-threaded disk buffer operations. This addresses the TODO comment 'need a real lock for MT' by using the erofs mutex API (erofs_mutex_lock/erofs_mutex_unlock/erofs_mutex_init) instead of a simple boolean flag that provided no actual synchronization.

The commit message should be 72-char at maximum each line.

Otherwise it seems a good improvement.

> 
> Signed-off-by: Ajay Rajera <newajay.11r@gmail.com>
> ---
>   lib/diskbuf.c | 8 +++++---
>   1 file changed, 5 insertions(+), 3 deletions(-)
> 
> diff --git a/lib/diskbuf.c b/lib/diskbuf.c
> index 0bf42da..4218df8 100644
> --- a/lib/diskbuf.c
> +++ b/lib/diskbuf.c
> @@ -3,6 +3,7 @@
>   #include "erofs/internal.h"
>   #include "erofs/print.h"
>   #include <stdio.h>
> +#include "erofs/lock.h"
>   #include <errno.h>
>   #include <sys/stat.h>
>   #include <unistd.h>
> @@ -14,7 +15,7 @@ static struct erofs_diskbufstrm {
>   	u64 tailoffset, devpos;
>   	int fd;
>   	unsigned int alignsize;
> -	bool locked;
> +	erofs_mutex_t lock;
>   } *dbufstrm;
>   
>   int erofs_diskbuf_getfd(struct erofs_diskbuf *db, u64 *fpos)
> @@ -34,6 +35,7 @@ int erofs_diskbuf_reserve(struct erofs_diskbuf *db, int sid, u64 *off)
>   {
>   	struct erofs_diskbufstrm *strm = dbufstrm + sid;
>   
> +	erofs_mutex_lock(&strm->lock);
>   	if (strm->tailoffset & (strm->alignsize - 1)) {
>   		strm->tailoffset = round_up(strm->tailoffset, strm->alignsize);
>   	}
> @@ -42,7 +44,6 @@ int erofs_diskbuf_reserve(struct erofs_diskbuf *db, int sid, u64 *off)
>   		*off = db->offset + strm->devpos;
>   	db->sp = strm;
>   	(void)erofs_atomic_inc_return(&strm->count);
> -	strm->locked = true;	/* TODO: need a real lock for MT */
>   	return strm->fd;
>   }
>   
> @@ -51,9 +52,9 @@ void erofs_diskbuf_commit(struct erofs_diskbuf *db, u64 len)
>   	struct erofs_diskbufstrm *strm = db->sp;
>   
>   	DBG_BUGON(!strm);
> -	DBG_BUGON(!strm->locked);
>   	DBG_BUGON(strm->tailoffset != db->offset);
>   	strm->tailoffset += len;
> +	erofs_mutex_unlock(&strm->lock);
>   }
>   
>   void erofs_diskbuf_close(struct erofs_diskbuf *db)
> @@ -115,6 +116,7 @@ int erofs_diskbuf_init(unsigned int nstrms)
>   setupone:
>   		strm->tailoffset = 0;
>   		erofs_atomic_set(&strm->count, 1);
> +		erofs_mutex_init(&strm->lock);
>   		if (fstat(strm->fd, &st))
>   			return -errno;
>   		strm->alignsize = max_t(u32, st.st_blksize, getpagesize());


