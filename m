Return-Path: <SRS0=IMi0=PQ=lists.ozlabs.org=linux-erofs-bounces+linux-erofs=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B296C433EF
	for <linux-erofs@archiver.kernel.org>; Thu, 28 Oct 2021 00:21:03 +0000 (UTC)
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id E9ED4610C7
	for <linux-erofs@archiver.kernel.org>; Thu, 28 Oct 2021 00:21:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org E9ED4610C7
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.ozlabs.org
Received: from boromir.ozlabs.org (localhost [IPv6:::1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4HfmSF4N4Zz2yKN
	for <linux-erofs@archiver.kernel.org>; Thu, 28 Oct 2021 11:21:01 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org;
	dkim=fail reason="signature verification failed" (2048-bit key; unprotected) header.d=intel-com.20210112.gappssmtp.com header.i=@intel-com.20210112.gappssmtp.com header.a=rsa-sha256 header.s=20210112 header.b=Bp5byUxx;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized)
 smtp.mailfrom=intel.com (client-ip=2607:f8b0:4864:20::633;
 helo=mail-pl1-x633.google.com; envelope-from=dan.j.williams@intel.com;
 receiver=<UNKNOWN>)
Authentication-Results: lists.ozlabs.org; dkim=pass (2048-bit key;
 unprotected) header.d=intel-com.20210112.gappssmtp.com
 header.i=@intel-com.20210112.gappssmtp.com header.a=rsa-sha256
 header.s=20210112 header.b=Bp5byUxx; dkim-atps=neutral
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com
 [IPv6:2607:f8b0:4864:20::633])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
 (No client certificate requested)
 by lists.ozlabs.org (Postfix) with ESMTPS id 4HfmS84XyCz2xlC
 for <linux-erofs@lists.ozlabs.org>; Thu, 28 Oct 2021 11:20:56 +1100 (AEDT)
Received: by mail-pl1-x633.google.com with SMTP id t21so3182920plr.6
 for <linux-erofs@lists.ozlabs.org>; Wed, 27 Oct 2021 17:20:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=intel-com.20210112.gappssmtp.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=thFpqdlxLVjcGfDZPprDTzPo9iTzt5bk9dqhDCzY+u0=;
 b=Bp5byUxxNEOGWx1LiYKcSiES+UNWDp5D/cMWZdjtl33fGWM9mdrZIzgn/KeGW66w48
 HLlosh7rVoB0KWLzJNIesUqmq7HyWnrZDWPZXtEInbmdYlimOId2CvHzX4NDal8E2jsZ
 NIOS1NWX2Og4zHktLs8Z73ffbx1VrB4tMgXBr+cAXsS3m4YEPwio+BMFFkGVGFDC70ho
 bg5uNNY9RzCmq9k8vu68K0vdjkKG8QMiqL+5O7IERSfZ90owTTf78IF/SLmMshLsv0gn
 algtrVwvBQo2E9HZ/GOG94ZMah+I89z5KkLKLbHkHit8m9WqG6x8NqMi8PHespkOBUpP
 20MA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=thFpqdlxLVjcGfDZPprDTzPo9iTzt5bk9dqhDCzY+u0=;
 b=IbOIpRv6lcJ0Smhi/ZmD3cKXiXQ2CpfSGnfP1w6CLnHpmsZilv+MtLy4FLdHaDj9GE
 DaZDsaCu0GLeT0VPsWv7tkhq0LzyE4PPnDr7Jc4IYrCfMxaLv0k4Lp/VcUIzf0xjuSi0
 iB+d4mAwqq0Qb7RbEXdZwnIG1BkmQBMnvqL4wKufmwJd1Owp8EtVMTUnq7EpzgB+7KG7
 vS2ZDvaQ/7/I9uyYzfrYQxr/dhC8isYtS1pn8E6XnbIjpTmFNuB/Xt0xQ+FDt3u6wrFi
 vSDeUu0Xo7vYia0bcZeTT0SnlFsb7hptu/Yb6YHKT8ArGXgjSzpCZKoRtxAM3tIhl7qT
 1mwQ==
X-Gm-Message-State: AOAM5337gx1zi39wJksxDMuryqR+Kg5zWaavQ/WrFwr665SosWuDiDst
 oUwHkE4iT8TCz01C3IsHY/EO7ZELqpYwkIkh27hujg==
X-Google-Smtp-Source: ABdhPJzDJ7G0OO0ihyu2DGXMx9nVI+vhdbJMigLbokXMw0jK9Xiqd7lMu/pWH/LSzIK1m8uglUBBOlGG+XCxTCXb4vQ=
X-Received: by 2002:a17:90b:350f:: with SMTP id
 ls15mr942901pjb.220.1635380451659; 
 Wed, 27 Oct 2021 17:20:51 -0700 (PDT)
MIME-Version: 1.0
References: <20211018044054.1779424-1-hch@lst.de>
 <20211018044054.1779424-8-hch@lst.de>
 <20211019154447.GL24282@magnolia>
In-Reply-To: <20211019154447.GL24282@magnolia>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 27 Oct 2021 17:20:40 -0700
Message-ID: <CAPcyv4g0yC3S8X6_DPtSjgFu3XFOHwu1KDy1HQP9eWk-EnDaxA@mail.gmail.com>
Subject: Re: [dm-devel] [PATCH 07/11] dax: remove dax_capable
To: "Darrick J. Wong" <djwong@kernel.org>
Content-Type: text/plain; charset="UTF-8"
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
Cc: Linux NVDIMM <nvdimm@lists.linux.dev>, Mike Snitzer <snitzer@redhat.com>,
 linux-s390 <linux-s390@vger.kernel.org>, Ira Weiny <ira.weiny@intel.com>,
 virtualization@lists.linux-foundation.org,
 linux-xfs <linux-xfs@vger.kernel.org>,
 device-mapper development <dm-devel@redhat.com>,
 linux-fsdevel <linux-fsdevel@vger.kernel.org>,
 linux-ext4 <linux-ext4@vger.kernel.org>, linux-erofs@lists.ozlabs.org,
 Christoph Hellwig <hch@lst.de>
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs"
 <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>

On Tue, Oct 19, 2021 at 8:45 AM Darrick J. Wong <djwong@kernel.org> wrote:
>
> On Mon, Oct 18, 2021 at 06:40:50AM +0200, Christoph Hellwig wrote:
> > Just open code the block size and dax_dev == NULL checks in the callers.
> >
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> > ---
> >  drivers/dax/super.c          | 36 ------------------------------------
> >  drivers/md/dm-table.c        | 22 +++++++++++-----------
> >  drivers/md/dm.c              | 21 ---------------------
> >  drivers/md/dm.h              |  4 ----
> >  drivers/nvdimm/pmem.c        |  1 -
> >  drivers/s390/block/dcssblk.c |  1 -
> >  fs/erofs/super.c             | 11 +++++++----
> >  fs/ext2/super.c              |  6 ++++--
> >  fs/ext4/super.c              |  9 ++++++---
> >  fs/xfs/xfs_super.c           | 21 ++++++++-------------
> >  include/linux/dax.h          | 14 --------------
> >  11 files changed, 36 insertions(+), 110 deletions(-)
> >
[..]               if (ext4_has_feature_inline_data(sb)) {
> > diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> > index d07020a8eb9e3..163ceafbd8fd2 100644
> > --- a/fs/xfs/xfs_super.c
> > +++ b/fs/xfs/xfs_super.c
[..]
> > +     if (mp->m_super->s_blocksize != PAGE_SIZE) {
> > +             xfs_alert(mp,
> > +                     "DAX not supported for blocksize. Turning off DAX.\n");
>
> Newlines aren't needed at the end of extX_msg/xfs_alert format strings.

Thanks Darrick, I fixed those up.
