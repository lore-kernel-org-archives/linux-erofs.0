Return-Path: <SRS0=k3n5=PJ=lists.ozlabs.org=linux-erofs-bounces+linux-erofs=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0DA2C433EF
	for <linux-erofs@archiver.kernel.org>; Thu, 21 Oct 2021 08:30:33 +0000 (UTC)
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 58FAC61056
	for <linux-erofs@archiver.kernel.org>; Thu, 21 Oct 2021 08:30:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 58FAC61056
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.ozlabs.org
Received: from boromir.ozlabs.org (localhost [IPv6:::1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4HZgfG5z2Tz2yg3
	for <linux-erofs@archiver.kernel.org>; Thu, 21 Oct 2021 19:30:30 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized)
 smtp.mailfrom=linux.alibaba.com (client-ip=115.124.30.57;
 helo=out30-57.freemail.mail.aliyun.com;
 envelope-from=hsiangkao@linux.alibaba.com; receiver=<UNKNOWN>)
Received: from out30-57.freemail.mail.aliyun.com
 (out30-57.freemail.mail.aliyun.com [115.124.30.57])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
 (No client certificate requested)
 by lists.ozlabs.org (Postfix) with ESMTPS id 4HZgfB3hPWz2yMy
 for <linux-erofs@lists.ozlabs.org>; Thu, 21 Oct 2021 19:30:24 +1100 (AEDT)
X-Alimail-AntiSpam: AC=PASS; BC=-1|-1; BR=01201311R661e4; CH=green; DM=||false|;
 DS=||; FP=0|-1|-1|-1|0|-1|-1|-1; HT=e01e04394; MF=hsiangkao@linux.alibaba.com;
 NM=1; PH=DS; RN=6; SR=0; TI=SMTPD_---0Ut7VYXz_1634805007; 
Received: from B-P7TQMD6M-0146.local(mailfrom:hsiangkao@linux.alibaba.com
 fp:SMTPD_---0Ut7VYXz_1634805007) by smtp.aliyun-inc.com(127.0.0.1);
 Thu, 21 Oct 2021 16:30:08 +0800
Date: Thu, 21 Oct 2021 16:30:06 +0800
From: Gao Xiang <hsiangkao@linux.alibaba.com>
To: Huang Jianan <huangjianan@oppo.com>
Subject: Re: [PATCH] erofs-utils: add dump.erofs to .gitignore
Message-ID: <YXElDpc9tv8SsR9g@B-P7TQMD6M-0146.local>
References: <20211021025847.1136-1-huangjianan@oppo.com>
 <YXEVgiqy6AOZdzLE@B-P7TQMD6M-0146.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <YXEVgiqy6AOZdzLE@B-P7TQMD6M-0146.local>
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
Cc: yh@oppo.com, guoweichao@oppo.com, linux-erofs@lists.ozlabs.org,
 zhangshiming@oppo.com, guanyuwei@oppo.com
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs"
 <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>

On Thu, Oct 21, 2021 at 03:23:46PM +0800, Gao Xiang wrote:
> On Thu, Oct 21, 2021 at 10:58:46AM +0800, Huang Jianan via Linux-erofs wrote:
> 
> Reviewed-by: Gao Xiang <hsiangkao@linux.alibaba.com>

In addition, lack of "Signed-off-by:", please help add in the next
version.

(It'd be better to add some commit message in general, even the
 modification is quite small....)

> 
> Thanks,
> Gao Xiang
> 
> > ---
> >  .gitignore | 1 +
> >  1 file changed, 1 insertion(+)
> > 
> > diff --git a/.gitignore b/.gitignore
> > index 7bc3f58..27403d4 100644
> > --- a/.gitignore
> > +++ b/.gitignore
> > @@ -29,3 +29,4 @@ stamp-h
> >  stamp-h1
> >  /mkfs/mkfs.erofs
> >  /fuse/erofsfuse
> > +/dump/dump.erofs
> > -- 
> > 2.25.1
