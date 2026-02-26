Return-Path: <linux-erofs+bounces-2435-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F0A86FC5910
	for <linux-erofs@archiver.kernel.org>; Thu, 26 Feb 2026 09:36:14 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4fM5tj2cvqz2yFc;
	Thu, 26 Feb 2026 20:36:13 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=115.124.30.113
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1772098573;
	cv=none; b=CHDRXHH5DFci74Y8LyXp6n4tGKV8tVQRPwQms4upPR2UBdIm2oYp1YAnxwODp237WDoY91h0wm4DygD7HtNqXtbaeEhD2ormyZMZfSoLL/v5luk9SUO9ovduxy/WlThPDoBThHMt1SscITIOv51qTr/M4pHzAsh61d1oAqvmWCsZQ3Gf+CB3o8K8+7O37ts4Vuo/hRVuHw5akBHdUXatwT406bBrvPYuzh5vOAnrKCwKYabRUgboBUagnVNQuniVlANuXPIx1mSx55nht0fSFCEnruYGBrm7hrB5k9XqdaPZIw5PqexdXQ2YCMvZerPAkyHFMM1y6V5JWaYKxdE/mg==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1772098573; c=relaxed/relaxed;
	bh=k1xZWv8rF1qnDWHGESp7AJtfk+gaqHurvr4VW+E1WoI=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:References:
	 In-Reply-To:Content-Type; b=Hnln/zIPw4GBQvPPLU6Y6Qrbyzbf9ufPbhdL2nUvYmqUBKeg+FRf5NPT5jkQsY/g6uFEsignX2wBuqbHYVRnkq003pCtuzkFrjPex1fivDU4k/ngFdjAdSy3twGi+rjC6EytmOvRL4M3SQmEoajGtmo1K/MGNWsifiKkCpeDMe456hMnd6+OFei4HBXxmpobKFE+8nMby9miOiMj+0nBnqYQrdZLSUltbFpkdP2ikQeZgTBW5JGUEmgVhFgj0PlhcmNZnZuHLyhGyiu6n3GWe/GE/Vy7JcV/DDbGjv0z7tDwTMMvn9cDvI4qODjTai6RnrchW+IZtj7sdk4KwhsRYQ==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=A3eWp+kd; dkim-atps=neutral; spf=pass (client-ip=115.124.30.113; helo=out30-113.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org) smtp.mailfrom=linux.alibaba.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=A3eWp+kd;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=linux.alibaba.com (client-ip=115.124.30.113; helo=out30-113.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org)
Received: from out30-113.freemail.mail.aliyun.com (out30-113.freemail.mail.aliyun.com [115.124.30.113])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4fM5tg2GTSz2xMt
	for <linux-erofs@lists.ozlabs.org>; Thu, 26 Feb 2026 20:36:09 +1100 (AEDT)
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1772098565; h=Message-ID:Date:MIME-Version:Subject:From:To:Content-Type;
	bh=k1xZWv8rF1qnDWHGESp7AJtfk+gaqHurvr4VW+E1WoI=;
	b=A3eWp+kdRt9yHNh7leEwd/ccZHYw5dPl8J7cpiU2oj5AB/wd49wYxUUzZ8Yrp1ogwNgCoCh4aOoF8IdVQKnzWRINvy4paGSvCriXPavUsocpTxnAzitkTrK7qRRB1SP+ON1M4ARwJ5zPfbkUZgbH06mmjs70FY0TdjI0g5xYRA8=
Received: from 30.221.131.221(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0WzqoUW2_1772098563 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 26 Feb 2026 17:36:03 +0800
Message-ID: <a87a74aa-3241-4c16-80cb-b8cc1ae6e271@linux.alibaba.com>
Date: Thu, 26 Feb 2026 17:36:01 +0800
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
Subject: Re: [PATCH] erofs: mark fileio folios uptodate based on the number of
 bytes read
From: Gao Xiang <hsiangkao@linux.alibaba.com>
To: Sheng Yong <shengyong2021@gmail.com>, linux-erofs@lists.ozlabs.org
References: <20260226090947.2808686-1-shengyong1@xiaomi.com>
 <f748ff61-043f-402a-b4a5-e285a4e5db99@linux.alibaba.com>
In-Reply-To: <f748ff61-043f-402a-b4a5-e285a4e5db99@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 2026/2/26 17:28, Gao Xiang wrote:
> Hi Yong,
> 
> On 2026/2/26 17:09, Sheng Yong wrote:
>> From: Sheng Yong <shengyong1@xiaomi.com>
>>
>> For file-backed mount, IO requests are handled by vfs_iocb_iter_read().
>> However, it can be interrupted by SIGKILL, returning the number of
>> bytes actually copied. Although unused folios are zero filled, they
>> are unexpectedly marked as uptodate.
>> This patch addresses this by setting folios uptodate based on the actual
>> number of bytes read for the plain backing file. And for the compressed
>> backing file, there may not have sufficient data for decompression,
>> in such case, the bio is marked with an error directly.
>>
>> Fixes: ce63cb62d794 ("erofs: support unencoded inodes for fileio")
>> Reported-by: chenguanyou <chenguanyou@xiaomi.com>
>> Signed-off-by: Yunlei He <heyunlei@xiaomi.com>
>> Signed-off-by: Sheng Yong <shengyong1@xiaomi.com>
> 
> Yes, it sounds possible. But can we just fail the
> whole I/O for both cases?
> 
> In principle, we should retry the remaining I/O once more
> for short read, but failing the whole I/O could be one
> short-term solution.

I wonder if we should simply:

diff --git a/fs/erofs/fileio.c b/fs/erofs/fileio.c
index abe873f01297..98cdaa1cd1a7 100644
--- a/fs/erofs/fileio.c
+++ b/fs/erofs/fileio.c
@@ -25,10 +25,8 @@ static void erofs_fileio_ki_complete(struct kiocb *iocb, long ret)
                         container_of(iocb, struct erofs_fileio_rq, iocb);
         struct folio_iter fi;

-       if (ret >= 0 && ret != rq->bio.bi_iter.bi_size) {
-               bio_advance(&rq->bio, ret);
-               zero_fill_bio(&rq->bio);
-       }
+       if (ret >= 0 && ret != rq->bio.bi_iter.bi_size)
+               ret = -EIO;

instead. IOWs, filling zeros means nothing for us.

Thanks,
Gao Xiang

> 
> Thanks,
> Gao Xiang
> 


