Return-Path: <SRS0=VaLi=FJ=lists.ozlabs.org=linux-erofs-bounces+linux-erofs=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-22.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2BD68C4361A
	for <linux-erofs@archiver.kernel.org>; Sat,  5 Dec 2020 07:53:35 +0000 (UTC)
Received: from lists.ozlabs.org (lists.ozlabs.org [203.11.71.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 2021A22D0B
	for <linux-erofs@archiver.kernel.org>; Sat,  5 Dec 2020 07:53:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2021A22D0B
Authentication-Results: mail.kernel.org; dmarc=pass (p=none dis=none) header.from=lists.ozlabs.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Received: from bilbo.ozlabs.org (lists.ozlabs.org [IPv6:2401:3900:2:1::3])
	by lists.ozlabs.org (Postfix) with ESMTP id 4Cp1zJ3YlCzDqdP
	for <linux-erofs@archiver.kernel.org>; Sat,  5 Dec 2020 18:53:32 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=lists.ozlabs.org;
	s=201707; t=1607154812;
	bh=vkmqzZXtNtNss0/NQdL++psN4/UEGSSgrZVrsph6K4I=;
	h=Subject:To:References:Date:In-Reply-To:List-Id:List-Unsubscribe:
	 List-Archive:List-Post:List-Help:List-Subscribe:From:Reply-To:
	 From;
	b=DlcZLRgCRDpjDIRg1s97kyaTATH1Kn37mhm9H6j0t8+5ZXijvZnkEVWi9cM1yar+J
	 tyM9f+cOnTZtIDlWuiER9pQhA9Xc/42F71/0RXpfzVbyDNFE8CuJYHhMj0Rspf7n1V
	 yzbvqrJk1pgL/ZwjUD0YbToErGL6EY1D86eoT6/qhdPSGQpFxFOMzMv72SaJy8gSIU
	 DAQhRPV5V6aisJ4M6U7ZPRjVsO0a734FdyhQ14ZtgHuq0OH8lBO/bdQY9k90Tewi8v
	 rqEOGSjlAWycTVk4PY9Uyen91d1hoiNwNE3kEzJWitHm74SMfu6wWQG4QxyDjrAlG2
	 I/KEN385IpVrQ==
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized)
 smtp.mailfrom=aliyun.com (client-ip=115.124.30.40;
 helo=out30-40.freemail.mail.aliyun.com; envelope-from=bluce.lee@aliyun.com;
 receiver=<UNKNOWN>)
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none)
 header.from=aliyun.com
Authentication-Results: lists.ozlabs.org; dkim=pass (1024-bit key;
 unprotected) header.d=aliyun.com header.i=@aliyun.com header.a=rsa-sha256
 header.s=s1024 header.b=YsRdYN3x; dkim-atps=neutral
Received: from out30-40.freemail.mail.aliyun.com
 (out30-40.freemail.mail.aliyun.com [115.124.30.40])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by lists.ozlabs.org (Postfix) with ESMTPS id 4Cp1z63g62zDqVR
 for <linux-erofs@lists.ozlabs.org>; Sat,  5 Dec 2020 18:53:21 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=aliyun.com; s=s1024;
 t=1607154796; h=Subject:To:From:Message-ID:Date:MIME-Version:Content-Type;
 bh=2wKWlbVwRVCtVEIko+GLaTfgNEc7gesRKwbl14osIJI=;
 b=YsRdYN3xoeo3tZnH/H/HxDsJ+N/WtMStJ/hqjZanxCtQA+XiBDFi/23UNFtUDAQmZ+vOr/f2jQkuj1E+BmbCFGJXv2NiyXV15/yC9quPWnvo6np6pHMBHAdBvt7RO09otPby1V2ieK/4+CmyeSmw8yX7xkTxn9m9etz1lttf24k=
X-Alimail-AntiSpam: AC=CONTINUE; BC=0.1471251|-1; CH=green; DM=|CONTINUE|false|;
 DS=CONTINUE|ham_news_journal|0.00348758-0.00123026-0.995282;
 FP=0|0|0|0|0|-1|-1|-1; HT=e01e04400; MF=bluce.lee@aliyun.com; NM=1; PH=DS;
 RN=2; RT=2; SR=0; TI=SMTPD_---0UHZv2if_1607154794; 
Received: from 172.168.2.18(mailfrom:bluce.lee@aliyun.com
 fp:SMTPD_---0UHZv2if_1607154794) by smtp.aliyun-inc.com(127.0.0.1);
 Sat, 05 Dec 2020 15:53:14 +0800
Subject: Re: [PATCH 1/2] erofs-utils: don't create hardlinked directories
To: Gao Xiang <hsiangkao@aol.com>, linux-erofs@lists.ozlabs.org
References: <20201204172042.24180-1-hsiangkao.ref@aol.com>
 <20201204172042.24180-1-hsiangkao@aol.com>
Message-ID: <42b78052-d9e9-045b-1b23-6f736e01fd6d@aliyun.com>
Date: Sat, 5 Dec 2020 15:53:13 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <20201204172042.24180-1-hsiangkao@aol.com>
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



On 2020/12/5 1:20, Gao Xiang via Linux-erofs wrote:
> From: Gao Xiang <hsiangkao@redhat.com>
> 
> From: Gao Xiang <hsiangkao@aol.com>
> 
> Fix an issue which behaves the same as the following
> mkisofs BZ due to bindmount:
> https://bugzilla.redhat.com/show_bug.cgi?id=1749860
> 
> Fixes: a17497f0844a ("erofs-utils: introduce inode operations")
> Signed-off-by: Gao Xiang <hsiangkao@aol.com>
> ---
> regression testcases will be uploaded to:
> https://git.kernel.org/pub/scm/linux/kernel/git/xiang/erofs-utils.git/log/?h=experimental-tests
> for now (erofs-utils v1.3 will include testcases then.)
> 
>  lib/inode.c | 13 ++++++++++---
>  1 file changed, 10 insertions(+), 3 deletions(-)
> 

It looks good
Reviewed-by: Li Guifu <bluce.lee@aliyun.com>
Thanks,
