Return-Path: <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 392F6C3DA4A
	for <linux-erofs@archiver.kernel.org>; Thu,  8 Aug 2024 17:45:07 +0000 (UTC)
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20201202 header.b=b3BHh4nL;
	dkim-atps=neutral
Received: from boromir.ozlabs.org (localhost [IPv6:::1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4WfvZT69QCz2yGF
	for <linux-erofs@archiver.kernel.org>; Fri,  9 Aug 2024 03:45:05 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20201202 header.b=b3BHh4nL;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=2604:1380:40e1:4800::1; helo=sin.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org)
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4WfvZN0jM8z2xm5
	for <linux-erofs@lists.ozlabs.org>; Fri,  9 Aug 2024 03:45:00 +1000 (AEST)
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sin.source.kernel.org (Postfix) with ESMTP id 17E3DCE12FA;
	Thu,  8 Aug 2024 17:44:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DA58C32782;
	Thu,  8 Aug 2024 17:44:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1723139096;
	bh=IsgtgX3wIhOtF8O1vxxw4k2xBanCob3LBwTumscuvpI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=b3BHh4nLi2Y1oiS7ndlANyA6bdhKCFVteBmjIvL88Vcqhm/UrAa0zxW3GOzbcsFYV
	 WxjxcAE5Ft6/EENzfDVmzG/yVTKjSwIedVmd2qTJNVgr9eaFJ5qhra7TnYpwWV1vXG
	 H+Du9QhTRoJNUvwLzn8m7iOFspqeK28/CimIMCfW2IraYi9Lwjo9qqxFpYnB+ZOQDW
	 oh5lMMObMAaEGVos4VayToAqxw1dxaHqN9m+kzcEU9hiuvsOdp1KOeG/Lr694Y/og7
	 cbg+YoPCAUPAurrSCZPicOR9cDuQektTpYHqeaMAAMJ+F3tAIpUQXeScIodpvEb4nl
	 WZrTERxBqFwuQ==
Date: Fri, 9 Aug 2024 01:44:50 +0800
From: Gao Xiang <xiang@kernel.org>
To: Sandeep Dhavale <dhavale@google.com>
Subject: Re: [PATCH] erofs-utils: lib: fix global-buffer-overflow due to
 invalid device
Message-ID: <ZrUEEtnKg4N8DeDc@debian>
Mail-Followup-To: Sandeep Dhavale <dhavale@google.com>,
	Gao Xiang <hsiangkao@linux.alibaba.com>,
	linux-erofs@lists.ozlabs.org
References: <20240808160343.2544426-1-hsiangkao@linux.alibaba.com>
 <CAB=BE-T-d-vjad6Q1kLeQbSr5pcSQCfX15vKxYvQJOqPncG32A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAB=BE-T-d-vjad6Q1kLeQbSr5pcSQCfX15vKxYvQJOqPncG32A@mail.gmail.com>
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

Hi Sandeep,

On Thu, Aug 08, 2024 at 10:15:31AM -0700, Sandeep Dhavale via Linux-erofs wrote:
> On Thu, Aug 8, 2024 at 9:04 AM Gao Xiang <hsiangkao@linux.alibaba.com> wrote:
> >
> > Fuzzer generates an image with crafted chunks of some invalid device.
> > Also refine the printed message of EOD.
> >
> > Closes: https://github.com/erofs/erofsnightly/actions/runs/10172576269/job/28135408276
> > Closes: https://github.com/erofs/erofs-utils/issues/11
> > Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
> > ---
> >  lib/io.c | 7 ++++++-
> >  1 file changed, 6 insertions(+), 1 deletion(-)
> >
> > diff --git a/lib/io.c b/lib/io.c
> > index 6bfae69..fbeff03 100644
> > --- a/lib/io.c
> > +++ b/lib/io.c
> > @@ -342,6 +342,10 @@ ssize_t erofs_dev_read(struct erofs_sb_info *sbi, int device_id,
> >         ssize_t read;
> >
> >         if (device_id) {
> > +               if (device_id >= sbi->nblobs) {
> > +                       erofs_err("invalid device id %u", device_id);
> > +                       return -EIO;
> > +               }
> >                 read = erofs_io_pread(&((struct erofs_vfile) {
> >                                 .fd = sbi->blobfd[device_id - 1],
> >                         }), buf, offset, len);
> > @@ -352,7 +356,8 @@ ssize_t erofs_dev_read(struct erofs_sb_info *sbi, int device_id,
> >         if (read < 0)
> >                 return read;
> >         if (read < len) {
> > -               erofs_info("reach EOF of device, pading with zeroes");
> > +               erofs_info("reach EOF of device @ %llu, pading with zeroes",
> > +                          offset | 0ULL);
> nit: typo carried over from previous log. s/pading/padding

Thanks for catching this!

> 
> >                 memset(buf + read, 0, len - read);
> >         }
> >         return 0;
> > --
> > 2.43.5
> >
> 
> Reviewed-by: Sandeep Dhavale <dhavale@google.com>

I'm about to releasing erofs-utils 1.8 today (it already takes much
long time than expected, I don't want to hold it anymore), so the
code is freezed for now.

I will tag v1.8 soon, and write an announcement mail hours later.

Thanks,
Gao Xiang

> 
> Thanks,
> Sandeep.
