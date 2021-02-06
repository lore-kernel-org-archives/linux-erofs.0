Return-Path: <SRS0=+o4z=HI=lists.ozlabs.org=linux-erofs-bounces+linux-erofs=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.4 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2533FC433E0
	for <linux-erofs@archiver.kernel.org>; Sat,  6 Feb 2021 15:30:21 +0000 (UTC)
Received: from lists.ozlabs.org (lists.ozlabs.org [203.11.71.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 66B3964E86
	for <linux-erofs@archiver.kernel.org>; Sat,  6 Feb 2021 15:30:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 66B3964E86
Authentication-Results: mail.kernel.org; dmarc=pass (p=none dis=none) header.from=lists.ozlabs.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Received: from bilbo.ozlabs.org (lists.ozlabs.org [IPv6:2401:3900:2:1::3])
	by lists.ozlabs.org (Postfix) with ESMTP id 4DXx7G3xr4zDwjq
	for <linux-erofs@archiver.kernel.org>; Sun,  7 Feb 2021 02:30:18 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=lists.ozlabs.org;
	s=201707; t=1612625418;
	bh=yg1dV7vSEKAMvtNJJkgGEa4ha64J9Qj3xjU27/21hRM=;
	h=Subject:To:References:Date:In-Reply-To:List-Id:List-Unsubscribe:
	 List-Archive:List-Post:List-Help:List-Subscribe:From:Reply-To:
	 From;
	b=Qw7RrTB78CO5PDZzopX249KVkub5CTpAcmrMux/0zidemX+Z14aK/EPbazD1LKDIv
	 WVTTIDxODZkNrqFNm+WCHd0dyNTzxtHxcNif1m83/KRDy9Kd8EcJtUJF+AdO0mRRLY
	 VgEtkb2DZ1vzd+PmD5LoyPN/Yn6DHav+eNp4IzQcTXAQ9eZ97I5LXl0WjzCQeG/Vlu
	 merr++53Qr9a87cbothQx/8O2X6TJTr6XwjZAi0jZGmMjZKqiOQ7nWQsV7LQUk7mSh
	 +4NMCv7BaeVkamGVpIdqhtJH8PwiafVWGaW2xhcU6ckUoXrkjgrfCDXesdLqu9/q9V
	 PuzEXcihXZKAg==
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized)
 smtp.mailfrom=aliyun.com (client-ip=115.124.30.17;
 helo=out30-17.freemail.mail.aliyun.com; envelope-from=bluce.lee@aliyun.com;
 receiver=<UNKNOWN>)
Authentication-Results: lists.ozlabs.org; dkim=pass (1024-bit key;
 unprotected) header.d=aliyun.com header.i=@aliyun.com header.a=rsa-sha256
 header.s=s1024 header.b=a2JR2vpH; dkim-atps=neutral
Received: from out30-17.freemail.mail.aliyun.com
 (out30-17.freemail.mail.aliyun.com [115.124.30.17])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by lists.ozlabs.org (Postfix) with ESMTPS id 4DXx702jgszDwjS
 for <linux-erofs@lists.ozlabs.org>; Sun,  7 Feb 2021 02:30:03 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=aliyun.com; s=s1024;
 t=1612625383; h=Subject:To:From:Message-ID:Date:MIME-Version:Content-Type;
 bh=LroNBf1Bjy0E9vJha6Zm/rb4peQvkW5VG7hEmuGmTSc=;
 b=a2JR2vpHJrGEhY9u0kxoPTu9apuGIlLFw4ksPjSpZT19yfd++/v1+2Xh1wELv2UOVe3VhHbdEugnayqXv2FTDGSFE7s0lrzth8L7fXyJk+j++Pxa6rEUJZSV86pX8srjfOjomT2MO9iBEGBlMRA1Ktm/6IVk67Hw3HsMNKaO9yY=
X-Alimail-AntiSpam: AC=CONTINUE; BC=0.08008137|-1; CH=green;
 DM=|CONTINUE|false|;
 DS=CONTINUE|ham_enroll_verification|0.00565184-0.00050276-0.993845;
 FP=0|0|0|0|0|-1|-1|-1; HT=e01e04423; MF=bluce.lee@aliyun.com; NM=1; PH=DS;
 RN=2; RT=2; SR=0; TI=SMTPD_---0UO0KAK3_1612625380; 
Received: from 192.168.3.32(mailfrom:bluce.lee@aliyun.com
 fp:SMTPD_---0UO0KAK3_1612625380) by smtp.aliyun-inc.com(127.0.0.1);
 Sat, 06 Feb 2021 23:29:40 +0800
Subject: Re: [PATCH v7 3/3] erofs-utils: optimize buffer allocation logic
To: Gao Xiang <hsiangkao@aol.com>, linux-erofs@lists.ozlabs.org
References: <20210122171153.27404-1-hsiangkao@aol.com>
 <20210122171153.27404-4-hsiangkao@aol.com>
Message-ID: <fc43d559-4067-8897-6c39-7c69b9748066@aliyun.com>
Date: Sat, 6 Feb 2021 23:29:40 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <20210122171153.27404-4-hsiangkao@aol.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-BeenThere: linux-erofs@lists.ozlabs.org
X-Mailman-Version: 2.1.29
Precedence: list
List-Id: Development of Linux EROFS file system <linux-erofs.lists.ozlabs.org>
List-Unsubscribe: <https://lists.ozlabs.org/options/linux-erofs>,
 <mailto:linux-erofs-request@lists.ozlabs.org?subject=unsubscribe>
List-Archive: <http://lists.ozlabs.org/pipermail/linux-erofs/>
List-Post: <mailto:linux-erofs@lists.ozlabs.org>
List-Help: <mailto:linux-erofs-request@lists.ozlabs.org?subject=help>
List-Subscribe: <https://lists.ozlabs.org/listinfo/linux-erofs>,
 <mailto:linux-erofs-request@lists.ozlabs.org?subject=subscribe>
From: Li GuiFu via Linux-erofs <linux-erofs@lists.ozlabs.org>
Reply-To: Li GuiFu <bluce.lee@aliyun.com>
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs"
 <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>



On 2021/1/23 1:11, Gao Xiang via Linux-erofs wrote:
> From: Hu Weiwen <sehuww@mail.scut.edu.cn>
> 
> When using EROFS to pack our dataset which consists of millions of
> files, mkfs.erofs is very slow compared with mksquashfs.
> 
> The bottleneck is `erofs_balloc' and `erofs_mapbh' function, which
> iterate over all previously allocated buffer blocks, making the
> complexity of the algrithm O(N^2) where N is the number of files.
> 
> With this patch:
> 
> * global `last_mapped_block' is mantained to avoid full scan in
> `erofs_mapbh` function.
> 
> * global `mapped_buckets' maintains a list of already mapped buffer
> blocks for each type and for each possible used bytes in the last
> EROFS_BLKSIZ. Then it is used to identify the most suitable blocks in
> future `erofs_balloc', avoiding full scan. Note that not-mapped (and the
> last mapped) blocks can be expended, so we deal with them separately.
> 
> When I test it with ImageNet dataset (1.33M files, 147GiB), it takes
> about 4 hours. Most time is spent on IO.
> 
> Cc: Huang Jianan <jnhuang95@gmail.com>
> Signed-off-by: Hu Weiwen <sehuww@mail.scut.edu.cn>
> Signed-off-by: Gao Xiang <hsiangkao@aol.com>
> ---
>  include/erofs/cache.h |   1 +
>  lib/cache.c           | 105 ++++++++++++++++++++++++++++++++++++------
>  2 files changed, 93 insertions(+), 13 deletions(-)
> 

It looks good
Reviewed-by: Li Guifu <bluce.lee@aliyun.com>

Thanks,
