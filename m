Return-Path: <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A53BDC25B06
	for <linux-erofs@archiver.kernel.org>; Fri, 12 Aug 2022 01:30:14 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [IPv6:::1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4M3mM85gv1z3bYk
	for <linux-erofs@archiver.kernel.org>; Fri, 12 Aug 2022 11:30:12 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=linux.alibaba.com (client-ip=115.124.30.54; helo=out30-54.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=<UNKNOWN>)
Received: from out30-54.freemail.mail.aliyun.com (out30-54.freemail.mail.aliyun.com [115.124.30.54])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4M3mM236qcz2xX6
	for <linux-erofs@lists.ozlabs.org>; Fri, 12 Aug 2022 11:30:04 +1000 (AEST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R841e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045170;MF=hsiangkao@linux.alibaba.com;NM=1;PH=DS;RN=2;SR=0;TI=SMTPD_---0VM.hk43_1660267797;
Received: from B-P7TQMD6M-0146.local(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0VM.hk43_1660267797)
          by smtp.aliyun-inc.com;
          Fri, 12 Aug 2022 09:29:58 +0800
Date: Fri, 12 Aug 2022 09:29:56 +0800
From: Gao Xiang <hsiangkao@linux.alibaba.com>
To: Naoto Yamaguchi <wata2ki@gmail.com>
Subject: Re: RFC: erofs-utils:mkfs: add unprivileged container use-case
 support
Message-ID: <YvWtFDDXXG1RIvhU@B-P7TQMD6M-0146.local>
References: <CABBJnRbpAxGB644x=fBRK5GOrjxYawZE-zrhHnRHQbz5Lzp-CQ@mail.gmail.com>
 <YvKj8aZp/6bg/Nxv@debian>
 <CABBJnRaP8XWbKiYVxbtdiJ0ViFz0hhkwTPnBA004aetZx_5nhQ@mail.gmail.com>
 <YvKrs6J5zBPzFYpF@B-P7TQMD6M-0146.local>
 <CABBJnRYOHLX25FmB3rhmcqEHRS28NKwNAuEihi0JDj0NoQkoDg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CABBJnRYOHLX25FmB3rhmcqEHRS28NKwNAuEihi0JDj0NoQkoDg@mail.gmail.com>
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
Sender: "Linux-erofs" <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>

Hi Naoto,

On Fri, Aug 12, 2022 at 08:04:40AM +0900, Naoto Yamaguchi wrote:
> Hi Gao
> 
> I created patch for submit,  but it couldn't send using git
> send-email.   Google updated security, it blocked smtp based send
> email by git maybe....

I'm not a gmail heavy user, but I remember it has an `app password`?
Also you could use other email clients like mutt or thunderbird in plain
text (as long as such email clients don't break the patch.)

If none of these work, you could also submit a pull request with your
signed-off-by and I will cherry-pick this, yet I think most
linux-kernel related projects don't directly use github honestly.

Thanks,
Gao Xiang

> 
> Can I submit using github pull request to
> https://github.com/hsiangkao/erofs-utils ?
> 
> Thanks,
> Naoto Yamaguchi,
> a member of Automotive Grade Linux Instrument Cluster EG.
