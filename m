Return-Path: <SRS0=IMi0=PQ=lists.ozlabs.org=linux-erofs-bounces+linux-erofs=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 571B5C433F5
	for <linux-erofs@archiver.kernel.org>; Thu, 28 Oct 2021 01:33:25 +0000 (UTC)
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 9B0A361184
	for <linux-erofs@archiver.kernel.org>; Thu, 28 Oct 2021 01:33:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 9B0A361184
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.ozlabs.org
Received: from boromir.ozlabs.org (localhost [IPv6:::1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4Hfp3l0FDQz2yMN
	for <linux-erofs@archiver.kernel.org>; Thu, 28 Oct 2021 12:33:23 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org;
	dkim=fail reason="signature verification failed" (2048-bit key; unprotected) header.d=intel-com.20210112.gappssmtp.com header.i=@intel-com.20210112.gappssmtp.com header.a=rsa-sha256 header.s=20210112 header.b=pAV9PI3u;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized)
 smtp.mailfrom=intel.com (client-ip=2607:f8b0:4864:20::102c;
 helo=mail-pj1-x102c.google.com; envelope-from=dan.j.williams@intel.com;
 receiver=<UNKNOWN>)
Authentication-Results: lists.ozlabs.org; dkim=pass (2048-bit key;
 unprotected) header.d=intel-com.20210112.gappssmtp.com
 header.i=@intel-com.20210112.gappssmtp.com header.a=rsa-sha256
 header.s=20210112 header.b=pAV9PI3u; dkim-atps=neutral
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com
 [IPv6:2607:f8b0:4864:20::102c])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
 (No client certificate requested)
 by lists.ozlabs.org (Postfix) with ESMTPS id 4Hfp3b2pZhz2xgP
 for <linux-erofs@lists.ozlabs.org>; Thu, 28 Oct 2021 12:33:13 +1100 (AEDT)
Received: by mail-pj1-x102c.google.com with SMTP id
 n11-20020a17090a2bcb00b001a1e7a0a6a6so6678121pje.0
 for <linux-erofs@lists.ozlabs.org>; Wed, 27 Oct 2021 18:33:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=intel-com.20210112.gappssmtp.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=pAiaBNCk1xnEBH3C9EMpKzrgqAPJnlmXDrtIiJ0dt1I=;
 b=pAV9PI3uqSjbwl4ehA+e1fD0AmJsR9RObZKjbvBijn3hthsC3BOWhi8AwEhKayTbAn
 +kULxKOjbDPkdJvduTRaYnTinwRQ3sTGC3RmXxOu+ZBFQAZP2dCfU0u+xx+MyQD5sCXu
 juQ8/OlFDYxVdxNYORCgy1YjcIYTJ/VbxjTb7UxVpCGr1z8kM8Yws8W6G4x0NWwc6hyB
 NrmNiLX5o2T12KN42PUJoRgcExOicwbK7jy2OCO7u+1RAggFonc1ris6SaZqTakBedPe
 +KiIfancYaA+JSRyfWPQcobeLcn00lylDFmKvFb7FlRzM0bgeIYcMRtTDSe9GGiatzrv
 LAlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=pAiaBNCk1xnEBH3C9EMpKzrgqAPJnlmXDrtIiJ0dt1I=;
 b=hOmYtaltVGzg2rp2/tmQJXr06NoxSXEnyyBOi4EIlol0NKt4BHkAAWLAPSkvB0T44Q
 3T1qVFYC53ESTULe66NQ1aFdcXcldHzpXI9ibUH1ZNoo7HN4sJ//GZc2Psmjl7M6t63S
 GUV/ifwJVGiN6CMwg/2SATze1cg8LcOouefgGYxvnZ7NY5+FhgYvfGttXAtlq2gtMQix
 +HDApqJuPYCis2/yna8cai1q5wP+fgcMPOlZwdcAiqT/G12HMWtpsY7ijHabFdA7ocUu
 WphWamO2NYHG0aMsWd6k0pRTd2t6sKNDS8csnFG++zSKpQId3U8rCaTtsxHMxC6Ws2Yy
 V/vw==
X-Gm-Message-State: AOAM533RBYX2Jx14uliUvmP7uolWQnPMavMWXimqKLnX0CGODACuQ2TG
 zPiXe1NTyvqQ2J+/+QLJcA4geEq4nfgv/Dgke+UBVA==
X-Google-Smtp-Source: ABdhPJxm6eCpHzum4moJkAnlQxDuj0JlmT3Vix8IBxxMECN3GUzGEt1VHXlaU6FsHMYZFBw/KnWLJLzVXyU36Brr9pk=
X-Received: by 2002:a17:90b:3b88:: with SMTP id
 pc8mr1221700pjb.93.1635384790364; 
 Wed, 27 Oct 2021 18:33:10 -0700 (PDT)
MIME-Version: 1.0
References: <20211018044054.1779424-1-hch@lst.de>
 <20211018044054.1779424-9-hch@lst.de>
In-Reply-To: <20211018044054.1779424-9-hch@lst.de>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 27 Oct 2021 18:32:58 -0700
Message-ID: <CAPcyv4iK-Op9Nxoq91YLv0aRj6PkGF64UY0Z_kfovF0cpuJ_JQ@mail.gmail.com>
Subject: Re: [PATCH 08/11] dm-linear: add a linear_dax_pgoff helper
To: Christoph Hellwig <hch@lst.de>, Mike Snitzer <snitzer@redhat.com>
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
Cc: Linux NVDIMM <nvdimm@lists.linux.dev>,
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
> Add a helper to perform the entire remapping for DAX accesses.  This
> helper open codes bdev_dax_pgoff given that the alignment checks have
> already been done by the submitting file system and don't need to be
> repeated.

Looks good.

Mike, ack?

>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  drivers/md/dm-linear.c | 49 +++++++++++++-----------------------------
>  1 file changed, 15 insertions(+), 34 deletions(-)
>
> diff --git a/drivers/md/dm-linear.c b/drivers/md/dm-linear.c
> index 32fbab11bf90c..bf03f73fd0f36 100644
> --- a/drivers/md/dm-linear.c
> +++ b/drivers/md/dm-linear.c
> @@ -164,63 +164,44 @@ static int linear_iterate_devices(struct dm_target *ti,
>  }
>
>  #if IS_ENABLED(CONFIG_FS_DAX)
> +static struct dax_device *linear_dax_pgoff(struct dm_target *ti, pgoff_t *pgoff)
> +{
> +       struct linear_c *lc = ti->private;
> +       sector_t sector = linear_map_sector(ti, *pgoff << PAGE_SECTORS_SHIFT);
> +
> +       *pgoff = (get_start_sect(lc->dev->bdev) + sector) >> PAGE_SECTORS_SHIFT;
> +       return lc->dev->dax_dev;
> +}
> +
>  static long linear_dax_direct_access(struct dm_target *ti, pgoff_t pgoff,
>                 long nr_pages, void **kaddr, pfn_t *pfn)
>  {
> -       long ret;
> -       struct linear_c *lc = ti->private;
> -       struct block_device *bdev = lc->dev->bdev;
> -       struct dax_device *dax_dev = lc->dev->dax_dev;
> -       sector_t dev_sector, sector = pgoff * PAGE_SECTORS;
> -
> -       dev_sector = linear_map_sector(ti, sector);
> -       ret = bdev_dax_pgoff(bdev, dev_sector, nr_pages * PAGE_SIZE, &pgoff);
> -       if (ret)
> -               return ret;
> +       struct dax_device *dax_dev = linear_dax_pgoff(ti, &pgoff);
> +
>         return dax_direct_access(dax_dev, pgoff, nr_pages, kaddr, pfn);
>  }
>
>  static size_t linear_dax_copy_from_iter(struct dm_target *ti, pgoff_t pgoff,
>                 void *addr, size_t bytes, struct iov_iter *i)
>  {
> -       struct linear_c *lc = ti->private;
> -       struct block_device *bdev = lc->dev->bdev;
> -       struct dax_device *dax_dev = lc->dev->dax_dev;
> -       sector_t dev_sector, sector = pgoff * PAGE_SECTORS;
> +       struct dax_device *dax_dev = linear_dax_pgoff(ti, &pgoff);
>
> -       dev_sector = linear_map_sector(ti, sector);
> -       if (bdev_dax_pgoff(bdev, dev_sector, ALIGN(bytes, PAGE_SIZE), &pgoff))
> -               return 0;
>         return dax_copy_from_iter(dax_dev, pgoff, addr, bytes, i);
>  }
>
>  static size_t linear_dax_copy_to_iter(struct dm_target *ti, pgoff_t pgoff,
>                 void *addr, size_t bytes, struct iov_iter *i)
>  {
> -       struct linear_c *lc = ti->private;
> -       struct block_device *bdev = lc->dev->bdev;
> -       struct dax_device *dax_dev = lc->dev->dax_dev;
> -       sector_t dev_sector, sector = pgoff * PAGE_SECTORS;
> +       struct dax_device *dax_dev = linear_dax_pgoff(ti, &pgoff);
>
> -       dev_sector = linear_map_sector(ti, sector);
> -       if (bdev_dax_pgoff(bdev, dev_sector, ALIGN(bytes, PAGE_SIZE), &pgoff))
> -               return 0;
>         return dax_copy_to_iter(dax_dev, pgoff, addr, bytes, i);
>  }
>
>  static int linear_dax_zero_page_range(struct dm_target *ti, pgoff_t pgoff,
>                                       size_t nr_pages)
>  {
> -       int ret;
> -       struct linear_c *lc = ti->private;
> -       struct block_device *bdev = lc->dev->bdev;
> -       struct dax_device *dax_dev = lc->dev->dax_dev;
> -       sector_t dev_sector, sector = pgoff * PAGE_SECTORS;
> -
> -       dev_sector = linear_map_sector(ti, sector);
> -       ret = bdev_dax_pgoff(bdev, dev_sector, nr_pages << PAGE_SHIFT, &pgoff);
> -       if (ret)
> -               return ret;
> +       struct dax_device *dax_dev = linear_dax_pgoff(ti, &pgoff);
> +
>         return dax_zero_page_range(dax_dev, pgoff, nr_pages);
>  }
>
> --
> 2.30.2
>
