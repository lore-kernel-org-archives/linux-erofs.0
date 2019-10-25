Return-Path: <SRS0=1OaB=YS=lists.ozlabs.org=linux-erofs-bounces+linux-erofs=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84862CA9EAF
	for <linux-erofs@archiver.kernel.org>; Fri, 25 Oct 2019 03:09:58 +0000 (UTC)
Received: from lists.ozlabs.org (lists.ozlabs.org [203.11.71.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 4000620867
	for <linux-erofs@archiver.kernel.org>; Fri, 25 Oct 2019 03:09:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4000620867
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Received: from bilbo.ozlabs.org (lists.ozlabs.org [IPv6:2401:3900:2:1::3])
	by lists.ozlabs.org (Postfix) with ESMTP id 46zpxw0dLqzDqmh
	for <linux-erofs@archiver.kernel.org>; Fri, 25 Oct 2019 14:09:56 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized)
 smtp.mailfrom=huawei.com (client-ip=45.249.212.187; helo=huawei.com;
 envelope-from=gaoxiang25@huawei.com; receiver=<UNKNOWN>)
Authentication-Results: lists.ozlabs.org;
 dmarc=none (p=none dis=none) header.from=huawei.com
Received: from huawei.com (szxga01-in.huawei.com [45.249.212.187])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by lists.ozlabs.org (Postfix) with ESMTPS id 46zpxj3KhpzDqlR
 for <linux-erofs@lists.ozlabs.org>; Fri, 25 Oct 2019 14:09:44 +1100 (AEDT)
Received: from DGGEMM402-HUB.china.huawei.com (unknown [172.30.72.54])
 by Forcepoint Email with ESMTP id 448C9DDE91490327202E;
 Fri, 25 Oct 2019 11:09:39 +0800 (CST)
Received: from dggeme762-chm.china.huawei.com (10.3.19.108) by
 DGGEMM402-HUB.china.huawei.com (10.3.20.210) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Fri, 25 Oct 2019 11:09:38 +0800
Received: from architecture4 (10.140.130.215) by
 dggeme762-chm.china.huawei.com (10.3.19.108) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1713.5; Fri, 25 Oct 2019 11:09:38 +0800
Date: Fri, 25 Oct 2019 11:12:29 +0800
From: Gao Xiang <gaoxiang25@huawei.com>
To: Guenter Roeck <groeck@google.com>
Subject: Re: [PATCH] squashfs: Migrate from ll_rw_block usage to BIO
Message-ID: <20191025031229.GB210047@architecture4>
References: <20191018010846.186484-1-pliard@google.com>
 <20191025004531.89978-1-pliard@google.com>
 <20191025025334.GA210047@architecture4>
 <CABXOdTeQTapfvKqGrqZME8JACeJhaHram_ZWk7ZZX2VWvYORaw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CABXOdTeQTapfvKqGrqZME8JACeJhaHram_ZWk7ZZX2VWvYORaw@mail.gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Originating-IP: [10.140.130.215]
X-ClientProxiedBy: dggeme708-chm.china.huawei.com (10.1.199.104) To
 dggeme762-chm.china.huawei.com (10.3.19.108)
X-CFilter-Loop: Reflected
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
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
 Philippe Liard <pliard@google.com>, Guenter Roeck <groeck@chromium.org>,
 phillip@squashfs.org.uk, linux-erofs@lists.ozlabs.org
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs"
 <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>

On Thu, Oct 24, 2019 at 08:02:14PM -0700, Guenter Roeck wrote:
> On Thu, Oct 24, 2019 at 7:51 PM Gao Xiang <gaoxiang25@huawei.com> wrote:
> 
> > On Fri, Oct 25, 2019 at 09:45:31AM +0900, Philippe Liard wrote:
> > > > Personally speaking, just for Android related use cases, I'd suggest
> > > > latest EROFS if you care more about system overall performance more
> > > > than compression ratio, even https://lkml.org/lkml/2017/9/22/814 is
> > > > applied (you can do benchmark), we did much efforts 3 years ago.
> > > >
> > > > And that is not only performance but noticable memory overhead (a lot
> > > > of extra memory allocations) and heavy page cache thrashing in low
> > > > memory scenarios (it's very common [1].)
> > >
> > > Thanks for the suggestion. EROFS is on our radar and we will
> > > (re)consider it once it goes out of staging. But we will most likely
> > > stay on squashfs until this happens.
> >
> > EROFS is already out of staging in mainline right now,
> >
> > https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/fs/erofs/
> >
> > If you agree on that, I'd suggest you try it right now
> > since it's widely (200+ million devices on the market)
> > deployed for our Android smartphones and fully open source
> > and open community. I think this is not a regrettable
> > attempt and we can response any question.
> >
> > https://lore.kernel.org/r/20191024033259.GA2513@hsiangkao-HP-ZHAN-66-Pro-G1
> >
> > In my personal opinion, just for Android use cases,
> > I think it is worth taking some time.
> >
> > All well said. The question, though, is if that is a reason to reject
> squashfs performance improvements. I argue that it is not. The decision to
> switch to erofs or not is completely orthogonal to squashfs performance
> improvements, and one doesn't preclude the other.

Note that I have no objection on this patch. And I'm happy to see any
improvements for other compression filesystems. And we are keeping on
boosting up our overall performance as well but I think I can give
some personal suggestions on given specific scenario since we already
did other solutions before. Just FYI to you.

Thanks,
Gao Xiang

> 
> Guenter
