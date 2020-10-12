Return-Path: <SRS0=Po1J=DT=lists.ozlabs.org=linux-erofs-bounces+linux-erofs=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	NICE_REPLY_A,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C1E8C433E7
	for <linux-erofs@archiver.kernel.org>; Mon, 12 Oct 2020 15:21:08 +0000 (UTC)
Received: from lists.ozlabs.org (lists.ozlabs.org [203.11.71.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 383BE2087E
	for <linux-erofs@archiver.kernel.org>; Mon, 12 Oct 2020 15:21:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=lists.ozlabs.org header.i=@lists.ozlabs.org header.b="lGCtlpSD";
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=aliyun.com header.i=@aliyun.com header.b="NWEGwAV5"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 383BE2087E
Authentication-Results: mail.kernel.org; dmarc=pass (p=none dis=none) header.from=lists.ozlabs.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Received: from bilbo.ozlabs.org (lists.ozlabs.org [IPv6:2401:3900:2:1::3])
	by lists.ozlabs.org (Postfix) with ESMTP id 4C92Sd1kw8zDqlB
	for <linux-erofs@archiver.kernel.org>; Tue, 13 Oct 2020 02:21:05 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=lists.ozlabs.org;
	s=201707; t=1602516065;
	bh=zIV6FIuXugnwfZ2FZVbX3n0NqDI0EV7D2LmrhEqBgBA=;
	h=Subject:To:References:Date:In-Reply-To:List-Id:List-Unsubscribe:
	 List-Archive:List-Post:List-Help:List-Subscribe:From:Reply-To:
	 From;
	b=lGCtlpSD5uJfntYxogz86CtmZEJHWfVw9xssh13j9rcEU6o6/aSfdRb2lM/RpEiL8
	 mHOTiiSCs9PfV0xmASoHhamz9nc2nWaVmJR0ObdvNLUTDnxJ/QwVav4gGwvwawRkb3
	 goKubJta7yYMbZkfdXoOxj/A6Hxlao26C1c8yApWxuqHUzE8rndQQ+Y9cQNgpEnVwM
	 4SZ99ipwfZ5F30z8Jqj+M1j0jKMVZ+kE+qYMONQm4K0WHfqCRddONHNFnNt3XGyYc0
	 QPyMMN1euQCbyBEEJnJeTYRxi8vYtwhC2RUO3G94kEkEg3rrPVltRazVXz9eXIFuJ1
	 T1ybtbGTr6N1Q==
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized)
 smtp.mailfrom=aliyun.com (client-ip=115.124.30.38;
 helo=out30-38.freemail.mail.aliyun.com; envelope-from=bluce.lee@aliyun.com;
 receiver=<UNKNOWN>)
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none)
 header.from=aliyun.com
Authentication-Results: lists.ozlabs.org; dkim=pass (1024-bit key;
 unprotected) header.d=aliyun.com header.i=@aliyun.com header.a=rsa-sha256
 header.s=s1024 header.b=NWEGwAV5; dkim-atps=neutral
Received: from out30-38.freemail.mail.aliyun.com
 (out30-38.freemail.mail.aliyun.com [115.124.30.38])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by lists.ozlabs.org (Postfix) with ESMTPS id 4C92SQ1jRjzDqjn
 for <linux-erofs@lists.ozlabs.org>; Tue, 13 Oct 2020 02:20:52 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=aliyun.com; s=s1024;
 t=1602516041; h=Subject:To:From:Message-ID:Date:MIME-Version:Content-Type;
 bh=rOO131ZfLkoFRXi6YSHnmBw4bAP8M3BY+EHDNIy7h3M=;
 b=NWEGwAV5KFKXOK5SpYAgVoXlohC4D/o6JPqtFwrMhL0yvOiIQ4pfAcZdGVcdD60EapCgHSwux7LZt8mlqzxG7DWTTBeu4nfZ9F0/p2OqBS1Zs8O4wnwSy6mD4FDF2OBYVTtKboYq7IifmJ+jIDhxN6DeGWJax5x8bPO513mDZVE=
X-Alimail-AntiSpam: AC=CONTINUE; BC=0.2456468|-1; CH=green; DM=|CONTINUE|false|;
 DS=CONTINUE|ham_news_journal|0.00228289-0.00168713-0.99603;
 FP=0|0|0|0|0|-1|-1|-1; HT=e01e04395; MF=bluce.lee@aliyun.com; NM=1; PH=DS;
 RN=3; RT=3; SR=0; TI=SMTPD_---0UBrEMYt_1602516040; 
Received: from 192.168.3.5(mailfrom:bluce.lee@aliyun.com
 fp:SMTPD_---0UBrEMYt_1602516040) by smtp.aliyun-inc.com(127.0.0.1);
 Mon, 12 Oct 2020 23:20:40 +0800
Subject: Re: [PATCH] AOSP: erofs-utils: update usage due to fs_config
To: Gao Xiang <hsiangkao@aol.com>, linux-erofs@lists.ozlabs.org
References: <20201012002227.1882-1-hsiangkao@aol.com>
 <20201012003805.4068-1-hsiangkao@aol.com>
Message-ID: <84da8356-d6a9-8f9e-74d2-c703ec58f72d@aliyun.com>
Date: Mon, 12 Oct 2020 23:20:40 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.2
MIME-Version: 1.0
In-Reply-To: <20201012003805.4068-1-hsiangkao@aol.com>
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



On 2020/10/12 8:38, Gao Xiang wrote:
> After fs_config support is added, usage() should
> be updated together as well.
> 
> Fixes: 8a9e8046f170 ("AOSP: erofs-utils: add fs_config support")
> Cc: Li Guifu <bluce.lee@aliyun.com>
> Signed-off-by: Gao Xiang <hsiangkao@aol.com>

Reviewed-by: Li Guifu <bluce.lee@aliyun.com>
