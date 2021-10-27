Return-Path: <SRS0=PKUw=PP=lists.ozlabs.org=linux-erofs-bounces+linux-erofs=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2382CC433F5
	for <linux-erofs@archiver.kernel.org>; Wed, 27 Oct 2021 20:54:46 +0000 (UTC)
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 9E624610CA
	for <linux-erofs@archiver.kernel.org>; Wed, 27 Oct 2021 20:54:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 9E624610CA
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.ozlabs.org
Received: from boromir.ozlabs.org (localhost [IPv6:::1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4HfgtD1wY9z2yw9
	for <linux-erofs@archiver.kernel.org>; Thu, 28 Oct 2021 07:54:44 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org;
	dkim=fail reason="signature verification failed" (2048-bit key; unprotected) header.d=intel-com.20210112.gappssmtp.com header.i=@intel-com.20210112.gappssmtp.com header.a=rsa-sha256 header.s=20210112 header.b=xAWE2Gs6;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized)
 smtp.mailfrom=intel.com (client-ip=2607:f8b0:4864:20::436;
 helo=mail-pf1-x436.google.com; envelope-from=dan.j.williams@intel.com;
 receiver=<UNKNOWN>)
Authentication-Results: lists.ozlabs.org; dkim=pass (2048-bit key;
 unprotected) header.d=intel-com.20210112.gappssmtp.com
 header.i=@intel-com.20210112.gappssmtp.com header.a=rsa-sha256
 header.s=20210112 header.b=xAWE2Gs6; dkim-atps=neutral
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com
 [IPv6:2607:f8b0:4864:20::436])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
 (No client certificate requested)
 by lists.ozlabs.org (Postfix) with ESMTPS id 4Hfgt73xnwz2xCB
 for <linux-erofs@lists.ozlabs.org>; Thu, 28 Oct 2021 07:54:39 +1100 (AEDT)
Received: by mail-pf1-x436.google.com with SMTP id m14so3857202pfc.9
 for <linux-erofs@lists.ozlabs.org>; Wed, 27 Oct 2021 13:54:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=intel-com.20210112.gappssmtp.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=MW2+yuOLdVC2FiYNaHWFO+PStoIyhupC83aZvNmdg00=;
 b=xAWE2Gs6elQhyFnpgWWwNUZcIIN+S0dTB23e1v1SGSkr3xAYgCO6FZbQyPbRQqQf23
 9I8Y78UczhWRyEynzMK/aUvy5wOw4Vy6/4LxJus/eHVGZMzDNjEAK+zx722FS9qK0he2
 1U1cd8YzY36X3CDASwjtuR6iKB/eUu6jn2zPH05rfMggNUg3QvABlXcipTgHgz3k7BuS
 H+rhb1Vq1z7S7EkZGdXP0ONpo163cZlk5BsINHv2ASIpi7dd31Nuhi/Qnq9EJvDvkYxw
 Pntfc80cc9CfDzJp6vju7flE64Efz7hVPlBsr/GGmt1WhUviknbfEb0n+v3Q2OiU1RqV
 8kaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=MW2+yuOLdVC2FiYNaHWFO+PStoIyhupC83aZvNmdg00=;
 b=XXHMzj5lbSxeU2FicMz9C8Ik86qkXcIeyLcj6z9BVz7n3YS04Q5MqwElrS8NRLSRxH
 p7JTBrUckNOR57gAs8bWq8HKS1av+nbgB3zc2iSI/E5/DMxEsR2ytaIbyNaL63E35HEG
 kQkSl68D6N5N0t83kjtVi58mi8QiSzX9ioMGGIGw5+7FYsyFUqklzkty6VD/nKwmcClb
 S8OdFAGDbRl0vcyUZGqN1l3ow8EpWpuMgFImEbd7HsUEcoZohqtOYRBFxWHc6MSNR9Vr
 0qva+trnbfbU//L56+qp0fyJ79jJKZQ1CQB1AvR/cpZm5xwThOwk66KcFV9++KIo3dsM
 qcrg==
X-Gm-Message-State: AOAM532s7sr1IBnjewVdxzpSWvm7d2trscmSoomdhdl7RtwTdi6g1uf1
 boss58MZqZc9ZGwgFFFYgnz8Vhn8w47Vk5/vOOluCQ==
X-Google-Smtp-Source: ABdhPJxqYRzrssHaaThSAQ3S9v6yHWHIiMadGqtNgSbRxpNG6jDSA2a4I6mJJqbjxV8Pnl8ItfliO9eaeQbTvv574gs=
X-Received: by 2002:a63:770e:: with SMTP id s14mr43824pgc.377.1635368076533;
 Wed, 27 Oct 2021 13:54:36 -0700 (PDT)
MIME-Version: 1.0
References: <20211018044054.1779424-1-hch@lst.de>
 <20211018044054.1779424-3-hch@lst.de>
In-Reply-To: <20211018044054.1779424-3-hch@lst.de>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 27 Oct 2021 13:54:25 -0700
Message-ID: <CAPcyv4jAd5O=keOkvtKzrnqpy21dfH0sJSk7Oo16wYrFfPnk=Q@mail.gmail.com>
Subject: Re: [PATCH 02/11] dax: remove CONFIG_DAX_DRIVER
To: Christoph Hellwig <hch@lst.de>
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
 linux-s390 <linux-s390@vger.kernel.org>, linux-erofs@lists.ozlabs.org,
 virtualization@lists.linux-foundation.org,
 linux-xfs <linux-xfs@vger.kernel.org>,
 device-mapper development <dm-devel@redhat.com>,
 linux-fsdevel <linux-fsdevel@vger.kernel.org>,
 linux-ext4 <linux-ext4@vger.kernel.org>, Ira Weiny <ira.weiny@intel.com>
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs"
 <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>

On Sun, Oct 17, 2021 at 9:41 PM Christoph Hellwig <hch@lst.de> wrote:
>
> CONFIG_DAX_DRIVER only selects CONFIG_DAX now, so remove it.

Looks good, I don't think an s390 ack is needed for this one.

> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  drivers/dax/Kconfig        | 4 ----
>  drivers/nvdimm/Kconfig     | 2 +-
>  drivers/s390/block/Kconfig | 2 +-
>  fs/fuse/Kconfig            | 2 +-
>  4 files changed, 3 insertions(+), 7 deletions(-)
>
> diff --git a/drivers/dax/Kconfig b/drivers/dax/Kconfig
> index d2834c2cfa10d..954ab14ba7778 100644
> --- a/drivers/dax/Kconfig
> +++ b/drivers/dax/Kconfig
> @@ -1,8 +1,4 @@
>  # SPDX-License-Identifier: GPL-2.0-only
> -config DAX_DRIVER
> -       select DAX
> -       bool
> -
>  menuconfig DAX
>         tristate "DAX: direct access to differentiated memory"
>         select SRCU
> diff --git a/drivers/nvdimm/Kconfig b/drivers/nvdimm/Kconfig
> index b7d1eb38b27d4..347fe7afa5830 100644
> --- a/drivers/nvdimm/Kconfig
> +++ b/drivers/nvdimm/Kconfig
> @@ -22,7 +22,7 @@ if LIBNVDIMM
>  config BLK_DEV_PMEM
>         tristate "PMEM: Persistent memory block device support"
>         default LIBNVDIMM
> -       select DAX_DRIVER
> +       select DAX
>         select ND_BTT if BTT
>         select ND_PFN if NVDIMM_PFN
>         help
> diff --git a/drivers/s390/block/Kconfig b/drivers/s390/block/Kconfig
> index d0416dbd0cd81..e3710a762abae 100644
> --- a/drivers/s390/block/Kconfig
> +++ b/drivers/s390/block/Kconfig
> @@ -5,7 +5,7 @@ comment "S/390 block device drivers"
>  config DCSSBLK
>         def_tristate m
>         select FS_DAX_LIMITED
> -       select DAX_DRIVER
> +       select DAX
>         prompt "DCSSBLK support"
>         depends on S390 && BLOCK
>         help
> diff --git a/fs/fuse/Kconfig b/fs/fuse/Kconfig
> index 40ce9a1c12e5d..038ed0b9aaa5d 100644
> --- a/fs/fuse/Kconfig
> +++ b/fs/fuse/Kconfig
> @@ -45,7 +45,7 @@ config FUSE_DAX
>         select INTERVAL_TREE
>         depends on VIRTIO_FS
>         depends on FS_DAX
> -       depends on DAX_DRIVER
> +       depends on DAX
>         help
>           This allows bypassing guest page cache and allows mapping host page
>           cache directly in guest address space.
> --
> 2.30.2
>
