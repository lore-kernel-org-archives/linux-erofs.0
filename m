Return-Path: <SRS0=nH6/=GD=lists.ozlabs.org=linux-erofs-bounces+linux-erofs=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-20.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41CBDC433E0
	for <linux-erofs@archiver.kernel.org>; Thu, 31 Dec 2020 16:46:55 +0000 (UTC)
Received: from lists.ozlabs.org (lists.ozlabs.org [203.11.71.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 6809F20798
	for <linux-erofs@archiver.kernel.org>; Thu, 31 Dec 2020 16:46:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6809F20798
Authentication-Results: mail.kernel.org; dmarc=pass (p=none dis=none) header.from=lists.ozlabs.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Received: from bilbo.ozlabs.org (lists.ozlabs.org [IPv6:2401:3900:2:1::3])
	by lists.ozlabs.org (Postfix) with ESMTP id 4D6DZh5mHnzDqKH
	for <linux-erofs@archiver.kernel.org>; Fri,  1 Jan 2021 03:46:52 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=lists.ozlabs.org;
	s=201707; t=1609433212;
	bh=NXIuiTdjRvSZBsGZarhGLpwghG2wm4h2vKOgGvd9j2c=;
	h=Subject:To:References:Date:In-Reply-To:List-Id:List-Unsubscribe:
	 List-Archive:List-Post:List-Help:List-Subscribe:From:Reply-To:Cc:
	 From;
	b=jDzeEIDSsr8jHiXI1EChoz5ELfnh8p5KxacRouIA8SlHoSwIkR6e3r7zwXU296aWR
	 E4tBKQw+H42RC4N5/B0Aofxp75MPwBB/0Sm9FiuyXpMxcZfxjugMQc+7luel2Vbtcn
	 y8PSZeyXLciAfCS+I6NohyA4elcd4l6k5zNChMS2qgNIVKGuPzMhpTCBtMaX7GImil
	 UQxl/IBQ4n78gJ3BAQ5D+mZLzbZWe+7/hR22b2dyE/88qcV50DKu+bPPtLKYjGhog/
	 xxkM+AfFxpR7P3YTQ8VFNKO9AWfRvyNIR6GCQi0avqp6d/NeRdrW2wotDPrkVhAe5F
	 LlPHaQwh/Vpyw==
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized)
 smtp.mailfrom=aliyun.com (client-ip=115.124.30.4;
 helo=out30-4.freemail.mail.aliyun.com; envelope-from=bluce.lee@aliyun.com;
 receiver=<UNKNOWN>)
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none)
 header.from=aliyun.com
Authentication-Results: lists.ozlabs.org; dkim=pass (1024-bit key;
 unprotected) header.d=aliyun.com header.i=@aliyun.com header.a=rsa-sha256
 header.s=s1024 header.b=ZOfb9WHL; dkim-atps=neutral
Received: from out30-4.freemail.mail.aliyun.com
 (out30-4.freemail.mail.aliyun.com [115.124.30.4])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by lists.ozlabs.org (Postfix) with ESMTPS id 4D6DZY3D06zDqK1
 for <linux-erofs@lists.ozlabs.org>; Fri,  1 Jan 2021 03:46:43 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=aliyun.com; s=s1024;
 t=1609433199; h=Subject:To:From:Message-ID:Date:MIME-Version:Content-Type;
 bh=UJeyto4muqf+vOozHvSD7nTizC9qkfu+PXSyfhBjZFg=;
 b=ZOfb9WHLuZLgP/AmDfxnR1kOJrCrnP0zAL87SjnAh13Q7zqJiYawGHxtDsIho52RC9KOq8UMGYYP+XBbTQhyPkjVJdQFPSrMN1rMjKwAwtu/Aq0gOC1qFonKMvkjazlO/m7L8tRUXoQ6FhYHL3PhKQzxFi0AIt7rWfsl3+aABqE=
X-Alimail-AntiSpam: AC=CONTINUE; BC=0.1013719|-1; CH=green; DM=|CONTINUE|false|;
 DS=CONTINUE|ham_system_inform|0.0125803-0.0011931-0.986227;
 FP=0|0|0|0|0|-1|-1|-1; HT=e01e04394; MF=bluce.lee@aliyun.com; NM=1; PH=DS;
 RN=6; RT=6; SR=0; TI=SMTPD_---0UKKtMb5_1609433198; 
Received: from 192.168.3.32(mailfrom:bluce.lee@aliyun.com
 fp:SMTPD_---0UKKtMb5_1609433198) by smtp.aliyun-inc.com(127.0.0.1);
 Fri, 01 Jan 2021 00:46:38 +0800
Subject: Re: [PATCH v2] AOSP: erofs-utils: fix sub-directory prefix for canned
 fs_config
To: Gao Xiang <hsiangkao@redhat.com>, linux-erofs@lists.ozlabs.org,
 Yue Hu <zbestahu@gmail.com>, Huang Jianan <huangjianan@oppo.com>
References: <20201226062736.29920-1-hsiangkao@aol.com>
 <20201228105146.2939914-1-hsiangkao@redhat.com>
Message-ID: <37f07049-1cba-b398-5049-d76e543f9e02@aliyun.com>
Date: Fri, 1 Jan 2021 00:46:38 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.1
MIME-Version: 1.0
In-Reply-To: <20201228105146.2939914-1-hsiangkao@redhat.com>
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
Cc: Yue Hu <huyue2@yulong.com>
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs"
 <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>



On 2020/12/28 18:51, Gao Xiang wrote:
> From: Gao Xiang <hsiangkao@aol.com>
> 
> "failed to find [%s] in canned fs_config" was observed by using
> "--fs-config-file" option as reported by Yue Hu [1].
> 
> The root cause was that the mountpoint prefix to subdirectories is
> also needed if "--mount-point" presents. However, such prefix cannot
> be added by just using erofs_fspath().
> 
> One exception is that the root directory itself needs to be handled
> specially for canned fs_config. For such case, the prefix of the root
> directory has to be dropped instead.
> 
> [1] https://lkml.kernel.org/r/20201222020430.12512-1-zbestahu@gmail.com
> 
> Link: https://lore.kernel.org/r/20201226062736.29920-1-hsiangkao@aol.com
> Fixes: 8a9e8046f170 ("AOSP: erofs-utils: add fs_config support")
> Reported-by: Yue Hu <huyue2@yulong.com>
> Signed-off-by: Gao Xiang <hsiangkao@aol.com>
> ---
> changes since v2:
>  - fix IS_ROOT misuse reported by Jianan, very sorry about this since
>    I know little about canned fs_config.
> 
> (please kindly test again...)
> 
>  lib/inode.c | 39 +++++++++++++++++++++++++--------------
>  1 file changed, 25 insertions(+), 14 deletions(-)
> 

It looks good
Reviewed-by: Li Guifu <bluce.lee@aliyun.com>

Thanks,
