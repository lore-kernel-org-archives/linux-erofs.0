Return-Path: <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AE666C3DA4A
	for <linux-erofs@archiver.kernel.org>; Sun,  4 Aug 2024 01:48:01 +0000 (UTC)
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20201202 header.b=qnj4HQZW;
	dkim-atps=neutral
Received: from boromir.ozlabs.org (localhost [IPv6:::1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4Wc2Wz6r5tz3cjt
	for <linux-erofs@archiver.kernel.org>; Sun,  4 Aug 2024 11:47:59 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20201202 header.b=qnj4HQZW;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=2604:1380:40e1:4800::1; helo=sin.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org)
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4Wc2Wt6zx3z3cLj
	for <linux-erofs@lists.ozlabs.org>; Sun,  4 Aug 2024 11:47:54 +1000 (AEST)
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sin.source.kernel.org (Postfix) with ESMTP id A5F20CE08CA;
	Sun,  4 Aug 2024 01:47:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20329C116B1;
	Sun,  4 Aug 2024 01:47:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722736068;
	bh=T4dGFVaHUw/tNtX1nJBoZ1zueMgtuLGFlvFQ5m9fZJI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=qnj4HQZW+8UEnkuAXS/RlrPrECANEJ42fGNg3+sxy6FLvQQ6Q00uPrNVAocF2FrhR
	 l+Gn0vrPijeCaXAxA9I8/mKoJLD4j2HBeBM0leb7hRH0kMyHhv5vleXm0e/BnYdd05
	 uaRIlCPERVhem9mBAIl9I2OXbX0Ll6KajR7VBX9kCPkdsLAYpLunqgIH9OwcvptqlH
	 xNWJDGcvY30vtt1SFkzba2alhNnP4wIjobM7wlvffr0j2VWzg54B2poeieKSTSzUHd
	 ldAKb14X/SsAcpoRq1yf3CrNHSWMpUIfgjv4rwzlyfImWFlzZNwwkflXAmXe7h/xbz
	 61EZ9/EVm6geQ==
Date: Sun, 4 Aug 2024 09:47:44 +0800
From: Gao Xiang <xiang@kernel.org>
To: Sandeep Dhavale <dhavale@google.com>
Subject: Re: [PATCH 1/3] erofs-utils: fsck: fix fd leak on failure in
 erofs_extract_file()
Message-ID: <Zq7dwOGcOQEHOHyW@debian>
Mail-Followup-To: Sandeep Dhavale <dhavale@google.com>,
	Gao Xiang <hsiangkao@linux.alibaba.com>,
	linux-erofs@lists.ozlabs.org
References: <20240802015527.2113797-1-hsiangkao@linux.alibaba.com>
 <CAB=BE-QZog8YH8DckC5s2T1sU28p4vN60wd86CAeuuSv3XAhOQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAB=BE-QZog8YH8DckC5s2T1sU28p4vN60wd86CAeuuSv3XAhOQ@mail.gmail.com>
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
Cc: Gao Xiang <hsiangkao@linux.alibaba.com>, linux-erofs@lists.ozlabs.org
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs" <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>

On Fri, Aug 02, 2024 at 02:17:12PM -0700, Sandeep Dhavale via Linux-erofs wrote:
> Hi Gao,
> 
> On Thu, Aug 1, 2024 at 6:55 PM Gao Xiang <hsiangkao@linux.alibaba.com> wrote:
> >
> > Ignore the return values as other close()s instead.
> >
> > Coverity-id: 502331
> > Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
> > ---
> >  fsck/main.c | 4 +---
> >  1 file changed, 1 insertion(+), 3 deletions(-)
> >
> > diff --git a/fsck/main.c b/fsck/main.c
> > index fb66967..bbef645 100644
> > --- a/fsck/main.c
> > +++ b/fsck/main.c
> > @@ -702,11 +702,9 @@ again:
> >
> >         /* verify data chunk layout */
> >         ret = erofs_verify_inode_data(inode, fd);
> > +       close(fd);
> >         if (ret)
> >                 return ret;
> I think we can get rid of this if block and should be just
> return ret;

Yeah, agreed, let me revise that.

> > -
> > -       if (close(fd))
> > -               return -errno;
> >         return ret;
> >  }
> >
> > --
> > 2.43.5
> >
> You can just do that while applying,
> 
> Reviewed-by: Sandeep Dhavale <dhavale@google.com>
> 

Thanks for your review!

Thanks,
Gao Xiang

> Thanks,
> Sandeep.
