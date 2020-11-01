Return-Path: <SRS0=WXO8=EH=lists.ozlabs.org=linux-erofs-bounces+linux-erofs=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	NICE_REPLY_A,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C19F7C2D0A3
	for <linux-erofs@archiver.kernel.org>; Sun,  1 Nov 2020 14:38:39 +0000 (UTC)
Received: from lists.ozlabs.org (lists.ozlabs.org [203.11.71.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id EBAD12158C
	for <linux-erofs@archiver.kernel.org>; Sun,  1 Nov 2020 14:38:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=lists.ozlabs.org header.i=@lists.ozlabs.org header.b="VvbN9GMP";
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=aliyun.com header.i=@aliyun.com header.b="hVAljx4g"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org EBAD12158C
Authentication-Results: mail.kernel.org; dmarc=pass (p=none dis=none) header.from=lists.ozlabs.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Received: from bilbo.ozlabs.org (lists.ozlabs.org [IPv6:2401:3900:2:1::3])
	by lists.ozlabs.org (Postfix) with ESMTP id 4CPJZP2Ft2zDqZB
	for <linux-erofs@archiver.kernel.org>; Mon,  2 Nov 2020 01:38:37 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=lists.ozlabs.org;
	s=201707; t=1604241517;
	bh=WsJC4CwVTgI7HwoKljo5e+m/jbXg9YYPPo2X9yt8XVU=;
	h=Subject:To:References:Date:In-Reply-To:List-Id:List-Unsubscribe:
	 List-Archive:List-Post:List-Help:List-Subscribe:From:Reply-To:
	 From;
	b=VvbN9GMPCdzY5v/vStGTk79E3Eojjdoxs/G4xGdUc9zevo1uMp2iPeWwliW+lEQCo
	 CRIsp/S8l8DN3E1gXJGkiHOcE4FNzgGXB39zm4+LyGSQIES/SLmU/L2Z14S6tlcQBx
	 o/jY12bXFGcWXdVZr8W2XHqFVCOa77SYogqn+KciZHeki2reyK/wMqhNeGuH/Gmnhm
	 EHBWYbunO8PF9NCvn4v9mdd0RhGYfjDHTs99m1Qvymm7ESBUu0rZHA/I+qzL4g6meG
	 tDYQ3owvcaqk60yZpKr2x+/Agh/Pqn295VNGI6m7ss+RQxSZ7nuvCOw5pzer4xvxhm
	 k6hLFeu0/jydw==
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized)
 smtp.mailfrom=aliyun.com (client-ip=115.124.30.38;
 helo=out30-38.freemail.mail.aliyun.com; envelope-from=bluce.lee@aliyun.com;
 receiver=<UNKNOWN>)
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none)
 header.from=aliyun.com
Authentication-Results: lists.ozlabs.org; dkim=pass (1024-bit key;
 unprotected) header.d=aliyun.com header.i=@aliyun.com header.a=rsa-sha256
 header.s=s1024 header.b=hVAljx4g; dkim-atps=neutral
Received: from out30-38.freemail.mail.aliyun.com
 (out30-38.freemail.mail.aliyun.com [115.124.30.38])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by lists.ozlabs.org (Postfix) with ESMTPS id 4CPJZD2CTwzDqXQ
 for <linux-erofs@lists.ozlabs.org>; Mon,  2 Nov 2020 01:38:27 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=aliyun.com; s=s1024;
 t=1604241489; h=Subject:To:From:Message-ID:Date:MIME-Version:Content-Type;
 bh=wiIKmCyRdLxM38Oyq8UxEVFcew5GG+ZLoIx/cYk3Rr0=;
 b=hVAljx4gB0P161DIbISZOb5swhcPjtwkKe0RL8OdkzYnMm0vqDOBbtWFS3hBy1PGAP+nrMlFmpl+GOac0obKEvyplO5SUn9c+3NYKTy7gJlZs6t2jp3z8XvDyl/LVKKBdveP8R7w5uJvt/lDsszn6X2n2cT9hgUgrM/33gsUOxg=
X-Alimail-AntiSpam: AC=CONTINUE; BC=0.1615965|-1; CH=green; DM=|CONTINUE|false|;
 DS=CONTINUE|ham_regular_dialog|0.00780324-0.000858712-0.991338;
 FP=0|0|0|0|0|-1|-1|-1; HT=e01e04407; MF=bluce.lee@aliyun.com; NM=1; PH=DS;
 RN=2; RT=2; SR=0; TI=SMTPD_---0UDposAJ_1604241488; 
Received: from 192.168.3.18(mailfrom:bluce.lee@aliyun.com
 fp:SMTPD_---0UDposAJ_1604241488) by smtp.aliyun-inc.com(127.0.0.1);
 Sun, 01 Nov 2020 22:38:08 +0800
Subject: Re: [PATCH 2/4] erofs-utils: support $SOURCE_DATE_EPOCH
To: Gao Xiang <hsiangkao@redhat.com>, linux-erofs@lists.ozlabs.org
References: <20201030123020.133084-1-hsiangkao@redhat.com>
 <20201030123020.133084-2-hsiangkao@redhat.com>
Message-ID: <1e58bbbf-8eda-bbe8-278e-442311cb4457@aliyun.com>
Date: Sun, 1 Nov 2020 22:38:08 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20201030123020.133084-2-hsiangkao@redhat.com>
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



On 2020/10/30 20:30, Gao Xiang wrote:
> Currently, we use -T to set a given UNIX timestamp for all
> files, yet reproducible builds [1] requires what is called
> "timestamp clamping", IOW, a timestamp must be used no later
> than the value of this variable.
> 
> Let's support $SOURCE_DATE_EPOCH as well.
> 
> [1] https://reproducible-builds.org/specs/source-date-epoch/
> Suggested-by: nl6720 <nl6720@gmail.com>
> Signed-off-by: Gao Xiang <hsiangkao@redhat.com>

It looks good
Reviewed-by: Li Guifu <bluce.lee@aliyun.com>
Thanks,
