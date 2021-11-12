Return-Path: <SRS0=HUho=P7=lists.ozlabs.org=linux-erofs-bounces+linux-erofs=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A05B8C433EF
	for <linux-erofs@archiver.kernel.org>; Fri, 12 Nov 2021 06:32:41 +0000 (UTC)
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id D190E60240
	for <linux-erofs@archiver.kernel.org>; Fri, 12 Nov 2021 06:32:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org D190E60240
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.ozlabs.org
Received: from boromir.ozlabs.org (localhost [IPv6:::1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4Hr8072wpHz2ynr
	for <linux-erofs@archiver.kernel.org>; Fri, 12 Nov 2021 17:32:39 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized)
 smtp.mailfrom=linux.alibaba.com (client-ip=115.124.30.43;
 helo=out30-43.freemail.mail.aliyun.com;
 envelope-from=hsiangkao@linux.alibaba.com; receiver=<UNKNOWN>)
Received: from out30-43.freemail.mail.aliyun.com
 (out30-43.freemail.mail.aliyun.com [115.124.30.43])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
 (No client certificate requested)
 by lists.ozlabs.org (Postfix) with ESMTPS id 4Hr80169fqz2yQG
 for <linux-erofs@lists.ozlabs.org>; Fri, 12 Nov 2021 17:32:28 +1100 (AEDT)
X-Alimail-AntiSpam: AC=PASS; BC=-1|-1; BR=01201311R201e4; CH=green; DM=||false|;
 DS=||; FP=0|-1|-1|-1|0|-1|-1|-1; HT=e01e04407; MF=hsiangkao@linux.alibaba.com;
 NM=1; PH=DS; RN=4; SR=0; TI=SMTPD_---0Uw8EAmq_1636698741; 
Received: from B-P7TQMD6M-0146.local(mailfrom:hsiangkao@linux.alibaba.com
 fp:SMTPD_---0Uw8EAmq_1636698741) by smtp.aliyun-inc.com(127.0.0.1);
 Fri, 12 Nov 2021 14:32:22 +0800
Date: Fri, 12 Nov 2021 14:32:20 +0800
From: Gao Xiang <hsiangkao@linux.alibaba.com>
To: Huang Jianan <huangjianan@oppo.com>, Yue Hu <zbestahu@gmail.com>
Subject: Re: [PATCH] erofs-utils: mkfs: add block list support for chunked
 files
Message-ID: <YY4KdEIZiQWBuO5w@B-P7TQMD6M-0146.local>
References: <20211111053031.4002774-1-dvander@google.com>
 <YYy1Yr1cudpnqqfh@B-P7TQMD6M-0146.local>
 <5b16c1ae-f468-6dd9-1c11-f7fb8f6331cf@oppo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5b16c1ae-f468-6dd9-1c11-f7fb8f6331cf@oppo.com>
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
Cc: linux-erofs@lists.ozlabs.org
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs"
 <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>

On Fri, Nov 12, 2021 at 02:10:19PM +0800, Huang Jianan via Linux-erofs wrote:
> 在 2021/11/11 14:17, Gao Xiang 写道:
> > Hi David,
> > 
> > On Thu, Nov 11, 2021 at 05:30:31AM +0000, David Anderson via Linux-erofs wrote:
> > > When using the --block-list-file option, add block mapping lines for
> > > chunked files. The extent printing code has been slightly refactored to
> > > accommodate multiple extent ranges.
> > > 
> > > Signed-off-by: David Anderson <dvander@google.com>
> > Thanks for the patch. Currently. I don't have Android environment at hand.
> > 
> > Hi Yue and Jianan,
> > Could you help check this patch in your environments as well and add
> > "Tested-by:" tags on this? Many thanks!
> No impact on our build.
> Tested-by: Huang Jianan <huangjianan@oppo.com>

Thanks all for the confirmation! I'll apply this this evening.

Thanks,
Gao Xiang

