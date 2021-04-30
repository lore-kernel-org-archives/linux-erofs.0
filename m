Return-Path: <SRS0=6/AP=J3=lists.ozlabs.org=linux-erofs-bounces+linux-erofs=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4054DC433ED
	for <linux-erofs@archiver.kernel.org>; Fri, 30 Apr 2021 16:17:09 +0000 (UTC)
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 9229D6109E
	for <linux-erofs@archiver.kernel.org>; Fri, 30 Apr 2021 16:17:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9229D6109E
Authentication-Results: mail.kernel.org; dmarc=pass (p=none dis=none) header.from=lists.ozlabs.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Received: from boromir.ozlabs.org (localhost [IPv6:::1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4FWyDz1Rzhz2yyF
	for <linux-erofs@archiver.kernel.org>; Sat,  1 May 2021 02:17:07 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=lists.ozlabs.org;
	s=201707; t=1619799427;
	bh=1av70SqJ8TRTwkjgUH1DTcaHezUYSTwhFt95PLWV/Gc=;
	h=Subject:To:References:Date:In-Reply-To:List-Id:List-Unsubscribe:
	 List-Archive:List-Post:List-Help:List-Subscribe:From:Reply-To:
	 From;
	b=RjexVlEGat3EcWnvVxOpdqZaX3YlV+CXAjXUMVywsH6kJDCm+YPiub2bdUvdqJyfp
	 UyKYGmcwH8rx2VIAnL4f6mgeiwXP1VgumHCjCrsaWUkbuAcpPMCBoBUv7uPsdxSNTA
	 WUyOEhpr1tLuo+sQAxF+AZdF/QXhpz4flRbkV0kww79M7s66fzfLVZ2erzFbnju4s1
	 XbgytQ8okBp0bww2iL9QfWGdeXowVVdVcyc+Y/xT/9OOWmB/RGCkN+Z/1e1fBG+76o
	 3o9YPWsyORRBAVjtRRFNU2ikwoy9l7GfvlgKE78b+9qjdi3hF3KPd7HX8N218Umqhu
	 3KljQb63HrEdg==
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized)
 smtp.mailfrom=aliyun.com (client-ip=115.124.30.53;
 helo=out30-53.freemail.mail.aliyun.com; envelope-from=bluce.lee@aliyun.com;
 receiver=<UNKNOWN>)
Authentication-Results: lists.ozlabs.org; dkim=pass (1024-bit key;
 unprotected) header.d=aliyun.com header.i=@aliyun.com header.a=rsa-sha256
 header.s=s1024 header.b=mImjgfeU; dkim-atps=neutral
Received: from out30-53.freemail.mail.aliyun.com
 (out30-53.freemail.mail.aliyun.com [115.124.30.53])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
 (No client certificate requested)
 by lists.ozlabs.org (Postfix) with ESMTPS id 4FWyDw0gv3z2xfk
 for <linux-erofs@lists.ozlabs.org>; Sat,  1 May 2021 02:17:03 +1000 (AEST)
X-Alimail-AntiSpam: AC=CONTINUE; BC=0.1982603|-1; CH=green; DM=|CONTINUE|false|;
 DS=CONTINUE|ham_enroll_verification|0.0243805-0.0018705-0.973749;
 FP=0|0|0|0|0|-1|-1|-1; HT=alimailimapcm10staff010182156082;
 MF=bluce.lee@aliyun.com; NM=1; PH=DS; RN=3; RT=3; SR=0;
 TI=SMTPD_---0UXHjxXv_1619799418; 
Received: from 192.168.3.32(mailfrom:bluce.lee@aliyun.com
 fp:SMTPD_---0UXHjxXv_1619799418) by smtp.aliyun-inc.com(127.0.0.1);
 Sat, 01 May 2021 00:16:58 +0800
Subject: Re: [PATCH v4 3/5] erofs-utils: manpage: add missing -C option for
 big pcluster
To: Gao Xiang <xiang@kernel.org>, linux-erofs@lists.ozlabs.org,
 Li Guifu <bluce.liguifu@huawei.com>
References: <20210430040345.17120-1-xiang@kernel.org>
 <20210430040345.17120-3-xiang@kernel.org>
Message-ID: <57518166-05a4-ccee-27f8-e02539eaafdd@aliyun.com>
Date: Sat, 1 May 2021 00:16:58 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210430040345.17120-3-xiang@kernel.org>
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



On 2021/4/30 12:03, Gao Xiang wrote:
> Update the manpage as well.
> 
> Signed-off-by: Gao Xiang <xiang@kernel.org>
It looks good
Reviewed-by: Li Guifu <bluce.lee@aliyun.com>

Thanks,

