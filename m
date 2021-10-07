Return-Path: <SRS0=NUzf=O3=lists.ozlabs.org=linux-erofs-bounces+linux-erofs=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29317C433EF
	for <linux-erofs@archiver.kernel.org>; Thu,  7 Oct 2021 06:29:37 +0000 (UTC)
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 4B3CC6113E
	for <linux-erofs@archiver.kernel.org>; Thu,  7 Oct 2021 06:29:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 4B3CC6113E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.ozlabs.org
Received: from boromir.ozlabs.org (localhost [IPv6:::1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4HQ1dB72yqz2yKZ
	for <linux-erofs@archiver.kernel.org>; Thu,  7 Oct 2021 17:29:34 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized)
 smtp.mailfrom=linux.alibaba.com (client-ip=115.124.30.45;
 helo=out30-45.freemail.mail.aliyun.com;
 envelope-from=hsiangkao@linux.alibaba.com; receiver=<UNKNOWN>)
Received: from out30-45.freemail.mail.aliyun.com
 (out30-45.freemail.mail.aliyun.com [115.124.30.45])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
 (No client certificate requested)
 by lists.ozlabs.org (Postfix) with ESMTPS id 4HQ1d61dqXz2yKZ
 for <linux-erofs@lists.ozlabs.org>; Thu,  7 Oct 2021 17:29:26 +1100 (AEDT)
X-Alimail-AntiSpam: AC=PASS; BC=-1|-1; BR=01201311R171e4; CH=green; DM=||false|;
 DS=||; FP=0|-1|-1|-1|0|-1|-1|-1; HT=e01e04357; MF=hsiangkao@linux.alibaba.com;
 NM=1; PH=DS; RN=9; SR=0; TI=SMTPD_---0UqoCT-J_1633588156; 
Received: from B-P7TQMD6M-0146.local(mailfrom:hsiangkao@linux.alibaba.com
 fp:SMTPD_---0UqoCT-J_1633588156) by smtp.aliyun-inc.com(127.0.0.1);
 Thu, 07 Oct 2021 14:29:19 +0800
Date: Thu, 7 Oct 2021 14:29:16 +0800
From: Gao Xiang <hsiangkao@linux.alibaba.com>
To: Liu Bo <bo.liu@linux.alibaba.com>
Subject: Re: [PATCH v3 1/2] erofs: decouple basic mount options from fs_context
Message-ID: <YV6TvAPGYOMGxenU@B-P7TQMD6M-0146.local>
References: <20211006194453.130447-1-hsiangkao@linux.alibaba.com>
 <20211007061048.GA84859@rsjd01523.et2sqa>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20211007061048.GA84859@rsjd01523.et2sqa>
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
Cc: Yan Song <imeoer@linux.alibaba.com>, LKML <linux-kernel@vger.kernel.org>,
 Peng Tao <tao.peng@linux.alibaba.com>, Joseph Qi <joseph.qi@linux.alibaba.com>,
 Changwei Ge <chge@linux.alibaba.com>, Liu Jiang <gerry@linux.alibaba.com>,
 linux-erofs@lists.ozlabs.org
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs"
 <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>

Hi Bo,

On Thu, Oct 07, 2021 at 02:10:48PM +0800, Liu Bo wrote:
> On Thu, Oct 07, 2021 at 03:44:52AM +0800, Gao Xiang wrote:
> > Previously, EROFS mount options are all in the basic types, so
> > erofs_fs_context can be directly copied with assignment. However,
> > when the multiple device feature is introduced, it's hard to handle
> > multiple device information like the other basic mount options.
> > 
> > There is no need to allocate the whole sb info in advance, instead,
> > let's separate the basic mount options from fs_context, thus
> > multiple device information can be handled gracefully then.
> 
> This is a bit confusing, IIRC, currently erofs does not allocate the whole
> sb info in advance, does it?

No, it doesn't. I just mentioned there are 2 ways to pass fs private
contexts to fs_context:
 1) allocate sbi in advance by using fc->s_fs_info;
 2) allocate/pass a fs private fs_context by using fc->fs_private;

erofs uses the second way.... Actually I'm fine with getting rid of
such expression to avoid confusion for the next version...

Thanks,
Gao Xiang

> 
> thanks,
> liubo
