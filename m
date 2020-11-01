Return-Path: <SRS0=WXO8=EH=lists.ozlabs.org=linux-erofs-bounces+linux-erofs=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	NICE_REPLY_A,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8F2CC2D0A3
	for <linux-erofs@archiver.kernel.org>; Sun,  1 Nov 2020 15:16:53 +0000 (UTC)
Received: from lists.ozlabs.org (lists.ozlabs.org [203.11.71.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id F3C292224E
	for <linux-erofs@archiver.kernel.org>; Sun,  1 Nov 2020 15:16:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=lists.ozlabs.org header.i=@lists.ozlabs.org header.b="YbU1ZjDl";
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=aliyun.com header.i=@aliyun.com header.b="sVN3C6D9"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org F3C292224E
Authentication-Results: mail.kernel.org; dmarc=pass (p=none dis=none) header.from=lists.ozlabs.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Received: from bilbo.ozlabs.org (lists.ozlabs.org [IPv6:2401:3900:2:1::3])
	by lists.ozlabs.org (Postfix) with ESMTP id 4CPKQW1RfmzDqZV
	for <linux-erofs@archiver.kernel.org>; Mon,  2 Nov 2020 02:16:51 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=lists.ozlabs.org;
	s=201707; t=1604243811;
	bh=1EeB8BXJCQLh7XDmAGclei5/aMXgYP0kr11bx+61nXE=;
	h=Subject:To:References:Date:In-Reply-To:List-Id:List-Unsubscribe:
	 List-Archive:List-Post:List-Help:List-Subscribe:From:Reply-To:
	 From;
	b=YbU1ZjDlODz0Gmf6bOygGSbIE1O8Aj6yiNMXo1Tqi6rtpmr7HwkN7HgzlOVa9ge8O
	 R8IJVb1yuYGxe68Bampw68MsbLEVkJj/XgbSQKwZb8Jro8wUuiBo63ah4ztthnt8Pj
	 S4FIlPIdZbFVQCsdYr+A0K1SrBcotqNR4nBmt0Y4vtt9y2rQxN5HS+KddfrDAh1ALE
	 dw+AktrmNkwYgnX2G1YDeo4MDRLaXu6agl+FsUE55ZxrA1u7BEK5qFEknCaXJaTGx/
	 /wRLFRC7pWGuXhq/clDvZQso6IPPp2RynQ5baIisjAEmeLA61mEPxbgbazxxGFX7Op
	 7sKSCs5f9dr+g==
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized)
 smtp.mailfrom=aliyun.com (client-ip=115.124.30.27;
 helo=out30-27.freemail.mail.aliyun.com; envelope-from=bluce.lee@aliyun.com;
 receiver=<UNKNOWN>)
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none)
 header.from=aliyun.com
Authentication-Results: lists.ozlabs.org; dkim=pass (1024-bit key;
 unprotected) header.d=aliyun.com header.i=@aliyun.com header.a=rsa-sha256
 header.s=s1024 header.b=sVN3C6D9; dkim-atps=neutral
Received: from out30-27.freemail.mail.aliyun.com
 (out30-27.freemail.mail.aliyun.com [115.124.30.27])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by lists.ozlabs.org (Postfix) with ESMTPS id 4CPKQK20pgzDqSq
 for <linux-erofs@lists.ozlabs.org>; Mon,  2 Nov 2020 02:16:40 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=aliyun.com; s=s1024;
 t=1604243785; h=Subject:To:From:Message-ID:Date:MIME-Version:Content-Type;
 bh=YPmBYMH1bjiMl8XQT0FD+ptD05nUA9E5JNV/XObqvD4=;
 b=sVN3C6D9hZy9zUrhEUo0xn9Q1skIrfkSfxKrSLHfAZVnNOMaJ9CeRzJpaicgf7p44q/wjYcdblHT1OTN2i9EqOW9PergoIs2kVgyiirakUEMExwXyWdbMfbQNevc8rd7SL0Bx+zGqIyBlue440z7cUJYdm0/kr11hgYB/3iXfHk=
X-Alimail-AntiSpam: AC=CONTINUE; BC=0.1835412|-1; CH=green; DM=|CONTINUE|false|;
 DS=CONTINUE|ham_enroll_verification|0.00461779-0.00110434-0.994278;
 FP=0|0|0|0|0|-1|-1|-1; HT=e01e04394; MF=bluce.lee@aliyun.com; NM=1; PH=DS;
 RN=2; RT=2; SR=0; TI=SMTPD_---0UDpoxaG_1604243785; 
Received: from 192.168.3.18(mailfrom:bluce.lee@aliyun.com
 fp:SMTPD_---0UDpoxaG_1604243785) by smtp.aliyun-inc.com(127.0.0.1);
 Sun, 01 Nov 2020 23:16:25 +0800
Subject: Re: [PATCH] erofs-utils: fix the project prefix to "erofs-utils"
To: Gao Xiang <hsiangkao@aol.com>, linux-erofs@lists.ozlabs.org
References: <20201024100516.14759-1-hsiangkao.ref@aol.com>
 <20201024100516.14759-1-hsiangkao@aol.com>
Message-ID: <fe7cd187-6e43-ee8e-e849-74c258488fc2@aliyun.com>
Date: Sun, 1 Nov 2020 23:16:24 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20201024100516.14759-1-hsiangkao@aol.com>
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



On 2020/10/24 18:05, Gao Xiang via Linux-erofs wrote:
> Some of them were "erofs_utils" in source headers by mistake.
> 
> Signed-off-by: Gao Xiang <hsiangkao@aol.com>
> ---

It looks good
Reviewed-by: Li Guifu <bluce.lee@aliyun.com>
Thanks,
