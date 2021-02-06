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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F004C433DB
	for <linux-erofs@archiver.kernel.org>; Sat,  6 Feb 2021 14:05:01 +0000 (UTC)
Received: from lists.ozlabs.org (lists.ozlabs.org [203.11.71.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id B8D8A614A7
	for <linux-erofs@archiver.kernel.org>; Sat,  6 Feb 2021 14:05:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B8D8A614A7
Authentication-Results: mail.kernel.org; dmarc=pass (p=none dis=none) header.from=lists.ozlabs.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Received: from bilbo.ozlabs.org (lists.ozlabs.org [IPv6:2401:3900:2:1::3])
	by lists.ozlabs.org (Postfix) with ESMTP id 4DXvDp4z7JzDwlH
	for <linux-erofs@archiver.kernel.org>; Sun,  7 Feb 2021 01:04:58 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=lists.ozlabs.org;
	s=201707; t=1612620298;
	bh=ZRJ0auwkcfGgiru6qLRWi+bc58GtfJV2/u+CYYkDVPs=;
	h=Subject:To:References:Date:In-Reply-To:List-Id:List-Unsubscribe:
	 List-Archive:List-Post:List-Help:List-Subscribe:From:Reply-To:Cc:
	 From;
	b=FvRym4Earq4egaDYkuOO+eU/KcgXC0aKIgUAN+wseELpReEWNyZZR3/9fclwNQbve
	 I9zGK1jXosup6llMSBPW9kIKgt3CmlDIv9kevg8mo2QiiIxVVk/IHxa+kuZySLY1C5
	 wLvsJwTHgBBPZG5k3a5UZCu9Bv+d30/6YzzNEydzaUATsaea/pApnFqGipLrTprbNS
	 5BYtd2t9AV3b/udNM9xuaHQY4SFzHquTCprzZ9WL3+xZjpn1VD652Cukzmzn46aYxz
	 La0w8lhTtoz8tpXXGsmE3XLOzTJaJ0BC9q6mR8q9pa7BMml1lsiYcr1kIjDcSyGR/4
	 ItDuSnCcX6UqQ==
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized)
 smtp.mailfrom=aliyun.com (client-ip=115.124.30.39;
 helo=out30-39.freemail.mail.aliyun.com; envelope-from=bluce.lee@aliyun.com;
 receiver=<UNKNOWN>)
Authentication-Results: lists.ozlabs.org; dkim=pass (1024-bit key;
 unprotected) header.d=aliyun.com header.i=@aliyun.com header.a=rsa-sha256
 header.s=s1024 header.b=GOYjtFcN; dkim-atps=neutral
Received: from out30-39.freemail.mail.aliyun.com
 (out30-39.freemail.mail.aliyun.com [115.124.30.39])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by lists.ozlabs.org (Postfix) with ESMTPS id 4DXvDX42jWzDvZC
 for <linux-erofs@lists.ozlabs.org>; Sun,  7 Feb 2021 01:04:43 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=aliyun.com; s=s1024;
 t=1612620267; h=Subject:To:From:Message-ID:Date:MIME-Version:Content-Type;
 bh=HI3HQa1SAaX3Cv8r+JPShWIqDme0w4qtsIFNwDYoAb4=;
 b=GOYjtFcN+11DtMQutCrPtykSTO0Bgmmcho+Tzx9YXpdw0qnwqNIn5jZxDrioBSjvX1JfZ6o/wFckpkgRL0UQqzo17S0RnP3lROxj8XTrbgdpGtdic02t6gJO2CABw2fJFzTwN/52jp5hKcY1JDB4MJZL8ng02X8b3JLEQ7bJxUM=
X-Alimail-AntiSpam: AC=CONTINUE; BC=0.2854939|-1; CH=green; DM=|CONTINUE|false|;
 DS=CONTINUE|ham_enroll_verification|0.0276019-0.00121955-0.971179;
 FP=0|0|0|0|0|-1|-1|-1; HT=e01e01424; MF=bluce.lee@aliyun.com; NM=1; PH=DS;
 RN=3; RT=3; SR=0; TI=SMTPD_---0UO04YLA_1612620266; 
Received: from 192.168.3.32(mailfrom:bluce.lee@aliyun.com
 fp:SMTPD_---0UO04YLA_1612620266) by smtp.aliyun-inc.com(127.0.0.1);
 Sat, 06 Feb 2021 22:04:27 +0800
Subject: Re: [PATCH v3] erofs-utils: fix memory leak when erofs_fill_inode()
 fails
To: Hu Weiwen <sehuww@mail.scut.edu.cn>, hsiangkao@redhat.com
References: <20210119153620.GA2601261@xiangao.remote.csb>
 <20210121162101.7093-1-sehuww@mail.scut.edu.cn>
Message-ID: <cc084e55-3107-5439-9869-d6f7eaff2dd7@aliyun.com>
Date: Sat, 6 Feb 2021 22:04:26 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <20210121162101.7093-1-sehuww@mail.scut.edu.cn>
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
Cc: linux-erofs@lists.ozlabs.org
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs"
 <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>



On 2021/1/22 0:21, Hu Weiwen wrote:
> Signed-off-by: Hu Weiwen <sehuww@mail.scut.edu.cn>
> ---
>  lib/inode.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 

It looks good
Reviewed-by: Li Guifu <bluce.lee@aliyun.com>
