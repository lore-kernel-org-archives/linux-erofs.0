Return-Path: <linux-erofs+bounces-4268-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5E1DEC5DF81
	for <linux-erofs@archiver.kernel.org>; Thu, 20 Aug 2026 13:35:13 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hQkvg6X24z2xW5;
	Thu, 20 Aug 2026 23:35:11 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=115.124.30.101
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1787232911;
	cv=none; b=f4LvXzi4JFp+o7bep1gOTMCpKEMQ4ZoglAYNkk6q0amcuoG6BY9Y3s6wYRBt/AruUbJ7ht/E/VgbKtSaJgSdmii90XavhnF4ai/B5FsXPsnwyIpEWj5VKKYvltvO4vtTfv9RG9Lwyv7YQbQHqNYnUGAXLbe3eRDHDs054sDOQzR7V9sr0bYz+ES5cePCV20AwhHAvAUOKQcPNs18+Jhsy5Ks5F38YBcZYOoCj+pwLRhpwl9QEk4kvhTtzEYEf9MPz+TmjHIjQ9d1xvCeWwVh6kdccaSVAXFApMbsQBqzkD9ScG0FLJO+AMTfMZMIYOCk7xnKzzO3I7bSUAUh7QJMyw==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1787232911; c=relaxed/relaxed;
	bh=NQQfCWFU8lTMyB4kZpp1AQfeK0U34PKN96OHaEuI3NM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=iXm/xGUx70REtYh57PsYcy4HF5pOmgjC0RVjJCU74/2CdYGz05OD650fghkvRB+y7+PXd8mAAe83vGNJciogmObK6YcxtSPZ6LoyvYmvW/Pv/YIqdcgJ6ER6x/Dbs+maNGOcvai1p8LlbQZKgfNu62qekwlKR+9P1F4xBLTABrsYwWaQFZ1rcq4d5XGk+XOnGG7xhVufA9iazaJLu6Zvf8UIitKyQfinrM5+ejWfTHLva8jfOQWsKJxp3EcdryJYGEd2d51ZM/RHZ3AFWAwZHP+xRYLSlFK63OlabwPUaFdRln/zp72znWmjPKgGuvHwqawjn+gg5pgOiokeTosdTQ==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=w22PAIkr; dkim-atps=neutral; spf=pass (client-ip=115.124.30.101; helo=out30-101.freemail.mail.aliyun.com; envelope-from=jefflexu@linux.alibaba.com; receiver=lists.ozlabs.org) smtp.mailfrom=linux.alibaba.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=w22PAIkr;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=linux.alibaba.com (client-ip=115.124.30.101; helo=out30-101.freemail.mail.aliyun.com; envelope-from=jefflexu@linux.alibaba.com; receiver=lists.ozlabs.org)
Received: from out30-101.freemail.mail.aliyun.com (out30-101.freemail.mail.aliyun.com [115.124.30.101])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hQkvd0qD7z2xRw
	for <linux-erofs@lists.ozlabs.org>; Thu, 20 Aug 2026 23:35:07 +1000 (AEST)
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1787232895; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=NQQfCWFU8lTMyB4kZpp1AQfeK0U34PKN96OHaEuI3NM=;
	b=w22PAIkr9oIIXybbe3DbBV7xf0A+BT4Mu/TKdghh9H9Xrhbbc8gHzZlXoyfApOMVmx8+MtlhCUnQOKPAO9Y/hTMUvetKWYO+SwW5ByVGi17kp2HPvbbCeJ51b1wGIPtF+WJgGvwA6SvE0g8Vi4WLxwV86v6JBbLN1FW4dATGAhE=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R891e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033032089153;MF=jefflexu@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0X9JeZM._1787232889;
Received: from 30.42.155.165(mailfrom:jefflexu@linux.alibaba.com fp:SMTPD_---0X9JeZM._1787232889 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 20 Aug 2026 21:34:50 +0800
Message-ID: <76ee52de-1dcb-44da-b2cf-329864adca07@linux.alibaba.com>
Date: Thu, 20 Aug 2026 21:34:49 +0800
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
Subject: Re: [PATCH] erofs: use the shared page cache for splice in
 inode_share mode
To: Zhan Xusheng <zhanxusheng1024@gmail.com>, Gao Xiang <xiang@kernel.org>,
 Chao Yu <chao@kernel.org>
Cc: Zhan Xusheng <zhanxusheng@xiaomi.com>, linux-erofs@lists.ozlabs.org,
 linux-kernel@vger.kernel.org
References: <20260820064441.1083470-1-zhanxusheng@xiaomi.com>
 <3d735f18-2d26-4b4c-be68-b000742e9826@linux.alibaba.com>
 <20260820123705.1748738-1-zhanxusheng@xiaomi.com>
Content-Language: en-US
From: Jingbo Xu <jefflexu@linux.alibaba.com>
In-Reply-To: <20260820123705.1748738-1-zhanxusheng@xiaomi.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 8/20/26 8:37 PM, Zhan Xusheng wrote:
> On Thu, 20 Aug 2026 17:53:20 +0800, Jingbo Xu wrote:
>> Please refer to backing_file_splice_read() called from
>> ovl_splice_read(), file_accessed() needs to be called on the original
>> file (just as what .read_iter() i.e. filemap_read() does), and the input
>> @ppos needs to be updated accordingly.
> 
> Taking the file_accessed() one, thanks.  filemap_splice_read() calls it at
> mm/filemap.c:3155 on whatever file it was handed, so on the backing file,
> whereas backing_file_splice_read() ends in ctx->accessed(iocb->ki_filp),
> which for ovl_splice_read() is the original.  v2 adds file_accessed(in).
> 
> @ppos looks already handled to me.  filemap_splice_read() takes a loff_t *
> and advances it itself, at mm/filemap.c:3144; its internal kiocb is seeded
> from *ppos at 3083 and 3098, not the other way round.  ovl_splice_read()
> has to copy iocb.ki_pos back because backing_file_splice_read() takes a
> struct kiocb and hands &iocb->ki_pos to vfs_splice_read().  Say if I have
> that wrong.

Make sense.


> 
> One you may want for read_iter too: it clones the kiocb onto the backing
> file, so filemap_read() marks that one accessed rather than the user's
> file, which is the shape splice_read had.  Neither is observable today,
> since erofs_fc_fill_super() sets SB_RDONLY | SB_NOATIME and the backing
> file is opened O_NOATIME, so both reach a no-op.  That is why I left
> read_iter alone here.

Okay, it seems that file_accessed() shall also be added to
erofs_ishare_file_read_iter()?


-- 
Thanks,
Jingbo


