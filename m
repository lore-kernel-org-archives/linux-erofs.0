Return-Path: <linux-erofs+bounces-2459-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D3B02EA4E09
	for <linux-erofs@archiver.kernel.org>; Mon,  2 Mar 2026 14:31:48 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4fPhFv2hhVz3bkL;
	Tue, 03 Mar 2026 01:31:47 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=115.124.30.97
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1772461907;
	cv=none; b=bf0orJ+f5AtnYVmU5DjdwbbKL0IS1xfWA1w7YWKPNNIXPFWDW5Ikzzp71Y8Fe7IMH6I0TYxb7fxc+8IW+oH0Ye3iHpwM58QnCs3c9hrFnv8GqMaErqnalw0P3rH7aBBvvaEHVqxIe8BfQK/FUqWW07cSc0BbqaY9xvIWKrdyv1YjfI0xM+1zysOuEqc7KwphSwifZitYd90Gf0UkZ63bAqx4u4WCef8CtQ0FMevzBZa4GWppHv8RIGrzhKQbG32RFSieH0PSFE04MtmgP1Xqmm17il5EFtXQ4AbOf9aB6fXY7SmVu1ohw/w8OGWEJisp4qKX2PVNK+qjR15EdGnTDQ==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1772461907; c=relaxed/relaxed;
	bh=Xm4vXctV0FzuJ+WbTv3JqeE72Q00z0/K308lspoKlYE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lmEX5yl6vYA0rMGG+gaZ5EewVqi4PgFuyV8sFhZqioZlOBTtkqjyfjuCz963HczprsEOkErGKMBG9t21rumXZWJAiNVlrDllCRxHoZKub7Q2AzBsFl3lzD9MykhQuxa+sj6BoteaChVcom/6+Y0jHBHZpn7/98F6jIxdsnyfHM05/wFU+pDpPz69eHxtd3w+SOEiDvRIuFTey5IRrRepVho1N4y1argIgSNNRfiXhJptmf8nO2XOS/lvxYqdHF9oajow36lvoNfD04AveUBp9V/VwMrN06hrjD8DkdqkWrwRTjrD8vUOlA0JEJ0expz90wA/uWlOD7l1Tuuc2p6rMA==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=f5K1UzGF; dkim-atps=neutral; spf=pass (client-ip=115.124.30.97; helo=out30-97.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org) smtp.mailfrom=linux.alibaba.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=f5K1UzGF;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=linux.alibaba.com (client-ip=115.124.30.97; helo=out30-97.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org)
Received: from out30-97.freemail.mail.aliyun.com (out30-97.freemail.mail.aliyun.com [115.124.30.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4fPhFs0pPwz2xGF
	for <linux-erofs@lists.ozlabs.org>; Tue, 03 Mar 2026 01:31:43 +1100 (AEDT)
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1772461899; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=Xm4vXctV0FzuJ+WbTv3JqeE72Q00z0/K308lspoKlYE=;
	b=f5K1UzGFJS6vNs35BwDVnDRM7Tr3amBmmTqLxEDaHmUjtYV2u0/63cFWS9jbm22V186zxq2VR36HPXWPdtrNOXA6rnFD5GvJb0iyVCJLDkJfwXBuNKfelUKQwGrxHrJ93G6nlE8cU6iIycX/j5sq4VHi58HPfiRDzJ0927OWVqI=
Received: from 30.42.59.174(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0X-5IIfM_1772461896 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 02 Mar 2026 22:31:37 +0800
Message-ID: <d50a059a-afa1-4803-a570-127c62b6e154@linux.alibaba.com>
Date: Mon, 2 Mar 2026 22:31:36 +0800
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
Subject: Re: [PATCH] block: avoild hang when bio_list is non-NULL in
 submit_bio_wait()
To: Christoph Hellwig <hch@infradead.org>
Cc: jiucheng.xu@amlogic.com, Jens Axboe <axboe@kernel.dk>,
 linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
 jianxin.pan@amlogic.com, tuan.zhang@amlogic.com, Gao Xiang
 <xiang@kernel.org>, linux-erofs@lists.ozlabs.org
References: <20260302-for-next-v1-1-eb9339e8dc99@amlogic.com>
 <aaWVwH_Xna22DTAq@infradead.org>
 <dddf1754-d575-4f4b-a11c-09847d0d0475@linux.alibaba.com>
 <aaWe1PsmzYatc_zR@infradead.org>
From: Gao Xiang <hsiangkao@linux.alibaba.com>
In-Reply-To: <aaWe1PsmzYatc_zR@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 2026/3/2 22:29, Christoph Hellwig wrote:
> On Mon, Mar 02, 2026 at 10:23:04PM +0800, Gao Xiang wrote:
>>>> I've trimmed down the call stack, as follows:
>>>>
>>>> f2fs_submit_read_io
>>>>     submit_bio
>>>>       mmc_blk_mq_recovery
>>>>         z_erofs_endio
>>>>           vm_map_ram
>>>
>>> ->bi_end_io code really should not be having random in_atomic()
>>> checks that make it completely different, but even if they have
>>
>> Thanks for the head-up.
>>
>> For this part, I'm pretty sure we need this particular one
>> otherwise the scheduling performance (latency sensitive)
>> is unacceptable for all Android phone users.
> 
> Where do you regularly get user context calls to ->bi_end_io?

The obvious one is that dm-verity, it's actually in
the workqueue context.

Thanks,
Gao Xiang



