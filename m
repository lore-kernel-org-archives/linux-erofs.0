Return-Path: <SRS0=/Jxq=E3=lists.ozlabs.org=linux-erofs-bounces+linux-erofs=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF413C63697
	for <linux-erofs@archiver.kernel.org>; Sat, 21 Nov 2020 06:35:21 +0000 (UTC)
Received: from lists.ozlabs.org (lists.ozlabs.org [203.11.71.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 46E7E22206
	for <linux-erofs@archiver.kernel.org>; Sat, 21 Nov 2020 06:35:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=lists.ozlabs.org header.i=@lists.ozlabs.org header.b="MgfUeBZr";
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=aliyun.com header.i=@aliyun.com header.b="Jvz0Pym/"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 46E7E22206
Authentication-Results: mail.kernel.org; dmarc=pass (p=none dis=none) header.from=lists.ozlabs.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Received: from bilbo.ozlabs.org (lists.ozlabs.org [IPv6:2401:3900:2:1::3])
	by lists.ozlabs.org (Postfix) with ESMTP id 4CdNvW397JzDr1S
	for <linux-erofs@archiver.kernel.org>; Sat, 21 Nov 2020 17:35:19 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=lists.ozlabs.org;
	s=201707; t=1605940519;
	bh=AHsZOMZkXBhIH7JZ8jNgZkK95qJ/WNnLDa9m2+P4bnQ=;
	h=Subject:To:References:Date:In-Reply-To:List-Id:List-Unsubscribe:
	 List-Archive:List-Post:List-Help:List-Subscribe:From:Reply-To:
	 From;
	b=MgfUeBZr6leBJKUluDrB/C2AIKbVZBOSPYjbFjoZ2bkhozPf3O3B2D0HGKfRRUIba
	 qsliGsRYLVuvQmrG2MHCnrHIYQVg6IlU4Mlj4wE+xqftpJ440l8md3BouakumV1lcX
	 3bHcUdiKi0gvmWS7Y4CAZcfjvRvb0BAJ0RrITRe4Y1CLXsKq++n+TK1CxacY/MJ3Pp
	 Ur2tDZpdEktH5vd7XZW+XQ60q+bhPY3TGQRtZMGNzODVBi1iHzlLM8kDCfsQVeoVoL
	 xIQtQ3p+cFpG2rZQYeHXp7zsDdyRLKMYVsQT5KPQxWE9UbOvZPFrNrEy6RlAM8Sbq4
	 L8f8BVAY7PBkA==
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized)
 smtp.mailfrom=aliyun.com (client-ip=115.124.30.4;
 helo=out30-4.freemail.mail.aliyun.com; envelope-from=bluce.lee@aliyun.com;
 receiver=<UNKNOWN>)
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none)
 header.from=aliyun.com
Authentication-Results: lists.ozlabs.org; dkim=pass (1024-bit key;
 unprotected) header.d=aliyun.com header.i=@aliyun.com header.a=rsa-sha256
 header.s=s1024 header.b=Jvz0Pym/; dkim-atps=neutral
Received: from out30-4.freemail.mail.aliyun.com
 (out30-4.freemail.mail.aliyun.com [115.124.30.4])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by lists.ozlabs.org (Postfix) with ESMTPS id 4CdNvM65qRzDqwm
 for <linux-erofs@lists.ozlabs.org>; Sat, 21 Nov 2020 17:35:11 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=aliyun.com; s=s1024;
 t=1605940498; h=Subject:To:From:Message-ID:Date:MIME-Version:Content-Type;
 bh=LZj1EK6QUSpMSTzmc7xVvHm18jS2kb2Mihajo95bfQw=;
 b=Jvz0Pym//YYFAkfTDT+H3Fs6KintCnC1XdXr4Bfk9eU4/0WIjDutBaOcwXzJg1m/0v9Znl32tSNZCdMrJ0b0PoSEoIYXyDOaQDlTP33qbgn4OOni+ckpgS56sfURCszYHV6lxCppGqmpTTL12YpVnyyz2hWOe0jhZQABnVeIbhw=
X-Alimail-AntiSpam: AC=CONTINUE; BC=0.1964222|-1; CH=green; DM=|CONTINUE|false|;
 DS=CONTINUE|ham_enroll_verification|0.00474909-0.000776753-0.994474;
 FP=0|0|0|0|0|-1|-1|-1; HT=e01e04420; MF=bluce.lee@aliyun.com; NM=1; PH=DS;
 RN=2; RT=2; SR=0; TI=SMTPD_---0UG1TWol_1605940498; 
Received: from 192.168.3.30(mailfrom:bluce.lee@aliyun.com
 fp:SMTPD_---0UG1TWol_1605940498) by smtp.aliyun-inc.com(127.0.0.1);
 Sat, 21 Nov 2020 14:34:58 +0800
Subject: Re: [PATCH v3 2/2] erofs-utils: update README
To: Gao Xiang <hsiangkao@aol.com>, linux-erofs@lists.ozlabs.org
References: <20201121022623.3882-1-hsiangkao@aol.com>
 <20201121022623.3882-2-hsiangkao@aol.com>
Message-ID: <794ee690-5fe2-6078-d09d-351d603973e6@aliyun.com>
Date: Sat, 21 Nov 2020 14:34:58 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.3
MIME-Version: 1.0
In-Reply-To: <20201121022623.3882-2-hsiangkao@aol.com>
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



On 2020/11/21 10:26, Gao Xiang via Linux-erofs wrote:
> From: Gao Xiang <hsiangkao@aol.com>
> 
> Make it easier to understand...
> 
> Signed-off-by: Gao Xiang <hsiangkao@aol.com>
It looks good
Reviewed-by: Li Guifu <bluce.lee@aliyun.com>
Thanks,
