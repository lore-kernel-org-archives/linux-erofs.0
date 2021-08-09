Return-Path: <SRS0=JcAH=NA=lists.ozlabs.org=linux-erofs-bounces+linux-erofs=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB47DC4338F
	for <linux-erofs@archiver.kernel.org>; Mon,  9 Aug 2021 03:06:37 +0000 (UTC)
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 17E4C60FC2
	for <linux-erofs@archiver.kernel.org>; Mon,  9 Aug 2021 03:06:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 17E4C60FC2
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.ozlabs.org
Received: from boromir.ozlabs.org (localhost [IPv6:::1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4GjgwC5V12z30C7
	for <linux-erofs@archiver.kernel.org>; Mon,  9 Aug 2021 13:06:35 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized)
 smtp.mailfrom=linux.alibaba.com (client-ip=115.124.30.43;
 helo=out30-43.freemail.mail.aliyun.com;
 envelope-from=hsiangkao@linux.alibaba.com; receiver=<UNKNOWN>)
Received: from out30-43.freemail.mail.aliyun.com
 (out30-43.freemail.mail.aliyun.com [115.124.30.43])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
 (No client certificate requested)
 by lists.ozlabs.org (Postfix) with ESMTPS id 4Gjgw64mZ8z2xts
 for <linux-erofs@lists.ozlabs.org>; Mon,  9 Aug 2021 13:06:28 +1000 (AEST)
X-Alimail-AntiSpam: AC=PASS; BC=-1|-1; BR=01201311R141e4; CH=green; DM=||false|;
 DS=||; FP=0|-1|-1|-1|0|-1|-1|-1; HT=e01e01424; MF=hsiangkao@linux.alibaba.com;
 NM=1; PH=DS; RN=8; SR=0; TI=SMTPD_---0UiLXKxy_1628478382; 
Received: from B-P7TQMD6M-0146.local(mailfrom:hsiangkao@linux.alibaba.com
 fp:SMTPD_---0UiLXKxy_1628478382) by smtp.aliyun-inc.com(127.0.0.1);
 Mon, 09 Aug 2021 11:06:23 +0800
Date: Mon, 9 Aug 2021 11:06:22 +0800
From: Gao Xiang <hsiangkao@linux.alibaba.com>
To: "weiyongjun (A)" <weiyongjun1@huawei.com>
Subject: Re: [PATCH -next] erofs: make symbol 'erofs_iomap_ops' static
Message-ID: <YRCbrtHZjo9oZfol@B-P7TQMD6M-0146.local>
References: <20210808063343.255817-1-weiyongjun1@huawei.com>
 <YQ/ZxZkNCtWGO6X4@B-P7TQMD6M-0146.local>
 <4ddfb962-97fc-28b0-0006-197574a1ec00@kernel.org>
 <82bae76e-8811-22d4-0b75-f58df1153def@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <82bae76e-8811-22d4-0b75-f58df1153def@huawei.com>
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
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
 Hulk Robot <hulkci@huawei.com>, Gao Xiang <xiang@kernel.org>,
 linux-erofs@lists.ozlabs.org
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs"
 <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>

On Mon, Aug 09, 2021 at 10:49:31AM +0800, weiyongjun (A) wrote:
> 
> 在 2021/8/9 7:56, Chao Yu 写道:
> > On 2021/8/8 21:19, Gao Xiang wrote:
> > > On Sun, Aug 08, 2021 at 06:33:43AM +0000, Wei Yongjun wrote:
> > > > The sparse tool complains as follows:
> > > > 
> > > > fs/erofs/data.c:150:24: warning:
> > > >   symbol 'erofs_iomap_ops' was not declared. Should it be static?
> > > > 
> > > > This symbol is not used outside of data.c, so marks it static.
> > 
> > Thanks for the patch, I guess it will be better to fix in original patch
> > if you don't mind.
> 
> 
> Yes, better to fix in original patch.

Ok, I'll merge this into the original patch this tomorrow.
(Anyway, thanks for the report!)

Thanks,
Gao Xiang

> 
> Regards.
