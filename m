Return-Path: <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9858AC433F5
	for <linux-erofs@archiver.kernel.org>; Mon, 20 Dec 2021 01:45:08 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [IPv6:::1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4JHMpp6mpSz2ywg
	for <linux-erofs@archiver.kernel.org>; Mon, 20 Dec 2021 12:45:06 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized)
 smtp.mailfrom=linux.alibaba.com (client-ip=115.124.30.42;
 helo=out30-42.freemail.mail.aliyun.com;
 envelope-from=hsiangkao@linux.alibaba.com; receiver=<UNKNOWN>)
Received: from out30-42.freemail.mail.aliyun.com
 (out30-42.freemail.mail.aliyun.com [115.124.30.42])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
 (No client certificate requested)
 by lists.ozlabs.org (Postfix) with ESMTPS id 4JHMpk5CJKz2xDY
 for <linux-erofs@lists.ozlabs.org>; Mon, 20 Dec 2021 12:44:59 +1100 (AEDT)
X-Alimail-AntiSpam: AC=PASS; BC=-1|-1; BR=01201311R141e4; CH=green; DM=||false|;
 DS=||; FP=0|-1|-1|-1|0|-1|-1|-1; HT=e01e04426; MF=hsiangkao@linux.alibaba.com;
 NM=1; PH=DS; RN=5; SR=0; TI=SMTPD_---0V.48Llw_1639964689; 
Received: from B-P7TQMD6M-0146.local(mailfrom:hsiangkao@linux.alibaba.com
 fp:SMTPD_---0V.48Llw_1639964689) by smtp.aliyun-inc.com(127.0.0.1);
 Mon, 20 Dec 2021 09:44:51 +0800
Date: Mon, 20 Dec 2021 09:44:49 +0800
From: Gao Xiang <hsiangkao@linux.alibaba.com>
To: Kelvin Zhang <zhangkelvin@google.com>
Subject: Re: [PATCH v7 2/2] erofs-utils: lib: add API to iterate dirs in EROFS
Message-ID: <Yb/gEbfCDlg1Y3Rk@B-P7TQMD6M-0146.local>
References: <YboyJ1udT7fpz5I7@B-P7TQMD6M-0146.local>
 <20211217194720.3219630-1-zhangkelvin@google.com>
 <20211217194720.3219630-2-zhangkelvin@google.com>
 <CAOSmRzgMu1otsZomU3dfLdu=N4jJLKB=MBgp5viHLCg5fub68g@mail.gmail.com>
 <Yb0tBHPnP/XF6eKK@B-P7TQMD6M-0146.local>
 <CAOSmRzh0OEQuSM8zcQSBrc=Fbbs5ad_am2_4Ga98mD76ZR22Hw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAOSmRzh0OEQuSM8zcQSBrc=Fbbs5ad_am2_4Ga98mD76ZR22Hw@mail.gmail.com>
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
Cc: Miao Xie <miaoxie@huawei.com>,
 linux-erofs mailing list <linux-erofs@lists.ozlabs.org>
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs"
 <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>

On Sun, Dec 19, 2021 at 07:53:00PM -0500, Kelvin Zhang wrote:
> I don't understand why re-using the context struct(<50 bytes) helps prevent
> stack overflow, when the current implementation of erofs_iterate_dir holds
> a 4096 bytes buffer on stack. If is erofs_iterate_dir called recursively,
> it's probably the char buf[EROFS_BLKSIZ]; who's using up stack space.

For two reasons,
1) I'd like dir_context totally allocated by callers, rather
   than introduce another on-stack context, pass together, and
   long arguments.

2) As I said, there can be a non-recursive version, which has
   only one level to iterate dir and chain them together in
   the DFS/BFS approach. Actually I really don't tend to add
   recursive feature to erofs_iterate_dir().

As for buf[EROFS_BLKSIZ], it can be moved into dir_context with a
pointer as well if later needed, so it can be allocated on heap
for all recursive versions.

I (and Igor Ostapenko) already converts all use cases (fsck, dump,
fsck, including get_pathname and Igor's image extraction) to the
unique API these days. I do think it can be easily used by Android
upgrade use cases As well.

btw, I have switched to new ztailpacking feature urgently since I'd
really like to get it ready for 5.17 cycle, which is more important
to the whole ecosystem for us.

Thanks,
Gao Xiang 
