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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E0EEC433E0
	for <linux-erofs@archiver.kernel.org>; Sat,  6 Feb 2021 14:01:36 +0000 (UTC)
Received: from lists.ozlabs.org (lists.ozlabs.org [203.11.71.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 588D764EBE
	for <linux-erofs@archiver.kernel.org>; Sat,  6 Feb 2021 14:01:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 588D764EBE
Authentication-Results: mail.kernel.org; dmarc=pass (p=none dis=none) header.from=lists.ozlabs.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Received: from bilbo.ozlabs.org (lists.ozlabs.org [IPv6:2401:3900:2:1::3])
	by lists.ozlabs.org (Postfix) with ESMTP id 4DXv8s3XyyzDwm8
	for <linux-erofs@archiver.kernel.org>; Sun,  7 Feb 2021 01:01:33 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=lists.ozlabs.org;
	s=201707; t=1612620093;
	bh=nGBqLU9t+qpNhjdYdlTTbBPDrU/Ctx5uoBMAZ3oNr8c=;
	h=Subject:To:References:Date:In-Reply-To:List-Id:List-Unsubscribe:
	 List-Archive:List-Post:List-Help:List-Subscribe:From:Reply-To:
	 From;
	b=PVSJkIdlynxowpGcZmqqLOpm63eCMLuOPaY65KBf1LZSsaBkMwKl7mjJbs0kiu0I4
	 NcYykPRI1AgJBlNqblHzxP3vLXMtb0OT1SNgRiUsnH7UNeIF8prq60S3Ad7As0V1HW
	 WVE65JNUdmBnj3GqQ5v442kRcyjjA8suj7t5Ra3eL2QmTkzV/qFKV48dJpiLdWMlrx
	 +VPxIqwrbv3YfQXvC/fwUfg294GIeIyHWsLoE3xV/w7V9CL5J58W2RXt6tybTz9P6v
	 DR67/OqmNdKP8+nrfl4vDVMGs+vnZUIpkMF3kdcpdWSwbtVl8tYm6k5I8ItkLqW5r8
	 YEUhkgWD1uIAA==
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized)
 smtp.mailfrom=aliyun.com (client-ip=115.124.30.38;
 helo=out30-38.freemail.mail.aliyun.com; envelope-from=bluce.lee@aliyun.com;
 receiver=<UNKNOWN>)
Authentication-Results: lists.ozlabs.org; dkim=pass (1024-bit key;
 unprotected) header.d=aliyun.com header.i=@aliyun.com header.a=rsa-sha256
 header.s=s1024 header.b=qcf2tPD1; dkim-atps=neutral
X-Greylist: delayed 311 seconds by postgrey-1.36 at bilbo;
 Sun, 07 Feb 2021 01:01:08 AEDT
Received: from out30-38.freemail.mail.aliyun.com
 (out30-38.freemail.mail.aliyun.com [115.124.30.38])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by lists.ozlabs.org (Postfix) with ESMTPS id 4DXv8N2r3zzDvYp
 for <linux-erofs@lists.ozlabs.org>; Sun,  7 Feb 2021 01:01:07 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=aliyun.com; s=s1024;
 t=1612620064; h=Subject:To:From:Message-ID:Date:MIME-Version:Content-Type;
 bh=1oWOdwAyAfgNXVfS5di6c7BlDz08WOmIyaU1hoEtytM=;
 b=qcf2tPD1TwLkAbkywK9TwrdZ9CXygXvW4WsVar89Y6XBdTRAGtfTjKGGX0nQIDfRJD3pL2Ot3ZXn37KVPgNKiYT4jvdYSTV0qK3AgwdhCBAuAdOs/x7iQXvJRXkUDSmj8HtCL2yOyU7K7w8tf6FJboszk7pq9X8k6yH5osaYGw0=
X-Alimail-AntiSpam: AC=CONTINUE; BC=0.2972864|-1; CH=green; DM=|CONTINUE|false|;
 DS=CONTINUE|ham_news_journal|0.00572088-0.000436984-0.993842;
 FP=0|0|0|0|0|-1|-1|-1; HT=e01e04420; MF=bluce.lee@aliyun.com; NM=1; PH=DS;
 RN=3; RT=3; SR=0; TI=SMTPD_---0UO04XcA_1612619738; 
Received: from 192.168.3.32(mailfrom:bluce.lee@aliyun.com
 fp:SMTPD_---0UO04XcA_1612619738) by smtp.aliyun-inc.com(127.0.0.1);
 Sat, 06 Feb 2021 21:55:38 +0800
Subject: Re: [PATCH] erofs-utils: fix BUILD_BUG_ON
To: Hu Weiwen <sehuww@mail.scut.edu.cn>, Gao Xiang <hsiangkao@redhat.com>,
 linux-erofs@lists.ozlabs.org
References: <20210131094732.168784-1-sehuww@mail.scut.edu.cn>
Message-ID: <109bf08e-d292-14b7-3217-dc43a8b334e1@aliyun.com>
Date: Sat, 6 Feb 2021 21:55:37 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <20210131094732.168784-1-sehuww@mail.scut.edu.cn>
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



On 2021/1/31 17:47, Hu Weiwen wrote:
> Signed-off-by: Hu Weiwen <sehuww@mail.scut.edu.cn>
> ---
>  include/erofs/defs.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 

It looks good
Reviewed-by: Li Guifu <bluce.lee@aliyun.com>

