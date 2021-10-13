Return-Path: <SRS0=QbHY=PB=lists.ozlabs.org=linux-erofs-bounces+linux-erofs=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1937C433EF
	for <linux-erofs@archiver.kernel.org>; Wed, 13 Oct 2021 16:03:22 +0000 (UTC)
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id E7F5D611AE
	for <linux-erofs@archiver.kernel.org>; Wed, 13 Oct 2021 16:03:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org E7F5D611AE
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.ozlabs.org
Received: from boromir.ozlabs.org (localhost [IPv6:::1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4HTy4S2ZXzz2ypf
	for <linux-erofs@archiver.kernel.org>; Thu, 14 Oct 2021 03:03:20 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized)
 smtp.mailfrom=linux.alibaba.com (client-ip=115.124.30.44;
 helo=out30-44.freemail.mail.aliyun.com;
 envelope-from=hsiangkao@linux.alibaba.com; receiver=<UNKNOWN>)
Received: from out30-44.freemail.mail.aliyun.com
 (out30-44.freemail.mail.aliyun.com [115.124.30.44])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
 (No client certificate requested)
 by lists.ozlabs.org (Postfix) with ESMTPS id 4HTy4M0SPFz2xXN
 for <linux-erofs@lists.ozlabs.org>; Thu, 14 Oct 2021 03:03:11 +1100 (AEDT)
X-Alimail-AntiSpam: AC=PASS; BC=-1|-1; BR=01201311R151e4; CH=green; DM=||false|;
 DS=||; FP=0|-1|-1|-1|0|-1|-1|-1; HT=e01e04395; MF=hsiangkao@linux.alibaba.com;
 NM=1; PH=DS; RN=8; SR=0; TI=SMTPD_---0Uri.wud_1634140982; 
Received: from B-P7TQMD6M-0146.local(mailfrom:hsiangkao@linux.alibaba.com
 fp:SMTPD_---0Uri.wud_1634140982) by smtp.aliyun-inc.com(127.0.0.1);
 Thu, 14 Oct 2021 00:03:04 +0800
Date: Thu, 14 Oct 2021 00:03:02 +0800
From: Gao Xiang <hsiangkao@linux.alibaba.com>
To: Yue Hu <zbestahu@163.com>
Subject: Re: [PATCH] erofs: fix the per-CPU buffer decompression for small
 output size
Message-ID: <YWcDNrHBYTQIq6x+@B-P7TQMD6M-0146.local>
References: <20211013092906.1434-1-zbestahu@gmail.com>
 <YWbIWydks+wpuNij@B-P7TQMD6M-0146.local>
 <20211013211005.7bd9fc08.zbestahu@163.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20211013211005.7bd9fc08.zbestahu@163.com>
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
Cc: linux-kernel@vger.kernel.org, huyue2@yulong.com,
 linux-erofs@lists.ozlabs.org, zhangwen@yulong.com
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs"
 <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>

On Wed, Oct 13, 2021 at 09:10:05PM +0800, Yue Hu wrote:
> Hi Xiang,
> 
> On Wed, 13 Oct 2021 19:51:55 +0800
> Gao Xiang <hsiangkao@linux.alibaba.com> wrote:
> 
> > Hi Yue,
> > 
> > On Wed, Oct 13, 2021 at 05:29:05PM +0800, Yue Hu wrote:
> > > From: Yue Hu <huyue2@yulong.com>
> > > 
> > > Note that z_erofs_lz4_decompress() will return a positive value if
> > > decompression succeeds. However, we do not copy_from_pcpubuf() due
> > > to !ret. Let's fix it.
> > > 
> > > Signed-off-by: Yue Hu <huyue2@yulong.com>  
> > 
> > Thanks for catching this. This is a valid issue, but it has no real
> > impact to the current kernels since such pcluster in practice will be
> > !inplace_io and trigger "if (nrpages_out == 1 && !rq->inplace_io) {"
> > above for upstream strategies.
> > 
> > Our customized lz4 implementation will return 0 if success instead, so
> > it has no issue to our previous products as well.
> 
> Yes, i just find the issue when i try to implement a new feature of
> tail-packing inline compressed data. No problem in my current version.

Yeah, please help update the return value of z_erofs_lz4_decompress()
and get rid of such unneeded fast path.

Thanks,
Gao Xiang

> 
> Thanks.
> 
> > 
> > For such cases, how about updating z_erofs_lz4_decompress() to return
> > 0 if success instead rather than outputsize. Since I'll return 0 if
> > success for LZMA as well.
> > 
> > Thanks,
> > Gao Xiang
> 
