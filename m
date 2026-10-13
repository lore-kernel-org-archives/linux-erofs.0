Return-Path: <linux-erofs+bounces-4714-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 784CFCC6B03
	for <linux-erofs@archiver.kernel.org>; Tue, 13 Oct 2026 03:30:27 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4j3fwx5BrPz30TY;
	Tue, 13 Oct 2026 14:30:25 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=pass smtp.remote-ip="2a00:1450:4864:20::52a" arc.chain=google.com
ARC-Seal: i=2; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1791862225;
	cv=pass; b=bdIwI8MjHDf/bQJOthuMTW4INniPnEUzTclzhiinOAGnTVWDwk6SiNNeW8utSTbpmQyPxzVC7XgtL+JP7kKiYZWOiQ4r/Hub9fv06UyetCJB0etke2ii/esbDjXuyOa/w8XJ1V8bowRavZCr/c4jRnPZVvah4G8wdhjrsF4vyEL9x+FWa7p037o+FKvtF2Kv2gvL0RWnLdf5+JY1N2fMgpaSnC7N9ZHdhQgWJN0LjUWmm2R7rRKF3nEAbe1TVefDPWEVrREpOfW72GprEs+zcIh7H/7SCOIYWZpeyfE26/o8SA/hnnc7FZxl+T8mVyP7TbkVFRR3/ZhohcmqdVTExg==
ARC-Message-Signature: i=2; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1791862225; c=relaxed/relaxed;
	bh=Tn/NdyK5BTxWcTyyBOq7oPcWK+gK9kRnlQtxau9NqJ0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=TylBMy0VvzuNk1ItgTenAapE44yTHVppbOfisE4xoG41CfbS6iRquJOw+ZZkcdbWh3KrGEymKLIBHurhSoxLvor7lrfRLjo3f7XkyvmOF1FcgSV+RHBK0QEXfwEIUEdCvrHN0tqxbKH344RGoYMOuRv2cOploJiVybuUGAjtW6vrS8Og91LPfBy2/McjdVM9fpLtYNGGTuPa6f5nQPYUFNf8zw8y6Z2/SxaxCPratThjIqxBxldndv67uh83l09Kz1IHLlO+1YnZVd4mPu0F3ZHVgl0M0CqBI7GdY/W5hKvmj2++HVA3o8GBbWfCO9K3hEUIwPMaJhd8RF/XfKtgdA==
ARC-Authentication-Results: i=2; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=chromium.org; dkim=pass (1024-bit key; unprotected) header.d=chromium.org header.i=@chromium.org header.a=rsa-sha256 header.s=google header.b=YRxqQ7K6; dkim-atps=neutral; spf=pass (client-ip=2a00:1450:4864:20::52a; helo=mail-ed1-x52a.google.com; envelope-from=sjg@chromium.org; receiver=lists.ozlabs.org) smtp.mailfrom=chromium.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=chromium.org header.i=@chromium.org header.a=rsa-sha256 header.s=google header.b=YRxqQ7K6;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=chromium.org (client-ip=2a00:1450:4864:20::52a; helo=mail-ed1-x52a.google.com; envelope-from=sjg@chromium.org; receiver=lists.ozlabs.org)
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4j3fww05cLz2yLY
	for <linux-erofs@lists.ozlabs.org>; Tue, 13 Oct 2026 14:30:23 +1100 (AEDT)
Received: by mail-ed1-x52a.google.com with SMTP id 4fb4d7f45d1cf-6b1ec41d8e9so257102a12.0
        for <linux-erofs@lists.ozlabs.org>; Mon, 12 Oct 2026 20:30:23 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1791862220; cv=none;
        d=google.com; s=arc-20260327;
        b=hLyv1kwXUV5ibPxaCWcDCpdZ1fxm0wbZsAYMWCd4uuJWio8dRs6Q3MOR9pMX5lO5QR
         Bu9FXoGY3vMucuHDMWuerCvdbmyw4wD/THyz2GAMErLak8TYP5ylESlynzxT1zLocQha
         Pm+lFWEpRbiD2rzN5KC3IgXc/aQ/JsiCe+hmZ933FyT3cnCqGdVDunW3PD7Aulpn3ni+
         ykevAkOIezXH4GuFj2S5X1YidwUTZcVs40dzdk1IPIq6mScDRmfejGyf6ZbnePTHVmsv
         Hh+C/stDaAWFSdzXSaCiKiGhY1pOMR6B7LMTBs5/jjDra+n9e5hS7PgggHe6SqFzcGgk
         luBg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=Tn/NdyK5BTxWcTyyBOq7oPcWK+gK9kRnlQtxau9NqJ0=;
        fh=2BrvcFE+2sBiYUnJxmrKZn8f323DsHXQN7j8nPE3zUI=;
        b=fKIxqxwW8vmyeGlnv3JxLS17m7SwguE71l6vDfbS2uUKhc90WPoBlXHio4FZHaC+Ko
         dg/jDXdr9i02PNWoZSVHc+ZuekkpQn0O6QqAN0GQomTECc2pzB5MlaF95bAl/6k2iZh+
         wisB1SGOygk0EgMgopSE4ZkEnqEo2BOEnAcBScIdFNUY+qcMG3RPc2kvxZg3Q7Nf9wBk
         +5lOTTvR+5uViYKOUunq0zbBoscNzIOChLigTDIVFdDmrSnM9I1ThTz4Z3K15olHIv8D
         pxEkW0fMSsNJsm+z1EyzOia8j1+ho0cieGvlQpDxiORuxMg/kAIdYLXFZUtak44EZ5Tj
         DUsg==;
        darn=lists.ozlabs.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1791862220; x=1792467020; darn=lists.ozlabs.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Tn/NdyK5BTxWcTyyBOq7oPcWK+gK9kRnlQtxau9NqJ0=;
        b=YRxqQ7K69NomFovklAbH/HMuOhoUS8y+bWaFzu0+k1FngK+ZwgVLI+Uk59znLEncsH
         8nAhF6to1X3GeJb9q7v3bBHmz0T/9FLIX2y3L2GzKk3/0MBWK78gB5UwQz/qwnBQxuae
         Zyb5oJt43mQ36ed3HRrOk99O9l/PGReXG7n9k=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791862220; x=1792467020;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=Tn/NdyK5BTxWcTyyBOq7oPcWK+gK9kRnlQtxau9NqJ0=;
        b=p/c3aNV3QBxuJlUtjfas+O5YDxTWOn8qTSS4Zp3m9JCE8Ov0cvov4AErZHClTYT+gb
         koXJT3lXWknq/Q0bic+ITXmnFKMidGbGJs3a4V0aHw5HjpHEEJNwByZdcZ+C7m7ZkXCp
         1t0b5P5txwEYILBRyt7r5raBL6eDAMUbkQvKlKGBI411yy0VYBwxjrsMtyObXi/Mj8RK
         XCnktZfGBEfgGOq1sRFmBV/CZJug0IFvWPACciv1f+jI7gY4Y7qKSTwIvoMmysdN/dF6
         g/b1P8ITYIfkClawd/iyXdy+WhZJEFAqrx+YEBxgIR5GaDYnZx/LZFeH1/Rsyux2NzEY
         z4xA==
X-Forwarded-Encrypted: i=1; AKwUvBwpIMHg0pyMt/sN5gU3vorHDqzrVivGXc3f/osY9i5+HKaNeZUXBFmpl8Y0bpz5avbfTT96GZI1QP7oUQ==@lists.ozlabs.org
X-Gm-Message-State: AFq9FYIhTdUQKqvs4fIR+f3NtvzVZ43NDykY3qMmDRLrvcOADCjxb6PG
	L2PDvgv+j02xWpLA1l9+XX9UMs6wBrjWTsYL9tv0WXVIe7AoC1whxTfIuDy6op9numVX2xoAq1B
	rT1Uco8HMRdQMWd294y8Nioh+U6nhTptmSu1KrplG
X-Gm-Gg: AYBFou3nbQhHEiHhQPMLqE/WQDI+sV7kt0ycd+zqgDVUrQR6Q1LpIXC0JsLrP9c2OJO
	r+6vfTzdwpCdTovcFWR5Ler1n0tKZSIrKhR6hVyibEL+D3vk9e+QvyWzzWXaWyXgSrWdTB2qAbj
	i2IzJ+F6mnNL1JptV+Sqy6p+7z/9Ls3AEVUXgfbuqsqDWi3Ha1C/ugqvkRMFZ7GuB1FLhxFgtp+
	u86PO2f9kmRGzav8l1nHUWdrfAYSTTin75xMZSOCYiz9g099+yXZM+YmocaLfJwvgqtEGaP8FTX
	OAwl4FTLoxf0KYizKsMUmrHsYVhAeNxoEnuG5LySqMWMgIb+JHD7nU8ivqVpYdaj5VQ=
X-Received: by 2002:a05:6402:13c5:b0:6b1:e4a0:4848 with SMTP id
 4fb4d7f45d1cf-6b1e4a06a94mr1008303a12.43.1791862220634; Mon, 12 Oct 2026
 20:30:20 -0700 (PDT)
X-Mailing-List: linux-erofs@lists.ozlabs.org
List-Id: <linux-erofs.lists.ozlabs.org>
List-Help: <mailto:linux-erofs+help@lists.ozlabs.org>
List-Owner: <mailto:linux-erofs+owner@lists.ozlabs.org>
List-Post: <mailto:linux-erofs@lists.ozlabs.org>
List-Subscribe: <mailto:linux-erofs+subscribe@lists.ozlabs.org>,
  <mailto:linux-erofs+subscribe-digest@lists.ozlabs.org>,
  <mailto:linux-erofs+subscribe-nomail@lists.ozlabs.org>
List-Unsubscribe: <mailto:linux-erofs+unsubscribe@lists.ozlabs.org>
Precedence: list
MIME-Version: 1.0
References: <20261012140048.214059-1-heinrich.schuchardt@canonical.com> <20261012140048.214059-3-heinrich.schuchardt@canonical.com>
In-Reply-To: <20261012140048.214059-3-heinrich.schuchardt@canonical.com>
From: Simon Glass <sjg@chromium.org>
Date: Tue, 13 Oct 2026 04:30:06 +0100
X-Gm-Features: AclHuK85XHHL4dOHcWd1gaOP4pRG5xpuiofJ4oHwnQdsAmqfZNjAWH-eNIHW3cI
Message-ID: <CAFLszTjObAiHP2ND54aW-AvgvPm3D8t3F_grguCBLJcssuBLsw@mail.gmail.com>
Subject: Re: [PATCH 2/9] fs: print change date in directory listing for FAT
To: heinrich.schuchardt@canonical.com
Cc: Tom Rini <trini@konsulko.com>, Simon Glass <sjg@chromium.org>, 
	Huang Jianan <jnhuang95@gmail.com>, Daniel Munic <v-dmunic@microsoft.com>, 
	Tony Dinh <mibodhi@gmail.com>, Alexey Charkov <alchark@flipper.net>, 
	Vincent Jardin <vjardin@free.fr>, joaomarcos.costa@bootlin.com, 
	Aristo Chen <aristo.chen@canonical.com>, u-boot@lists.u-boot-project.org, 
	linux-erofs@lists.ozlabs.org
Content-Type: text/plain; charset="UTF-8"

Hi Heinrich,

On 2026-10-12T14:00:39, Heinrich Schuchardt
<heinrich.schuchardt@canonical.com> wrote:
> fs: print change date in directory listing for FAT
>
> fs_ls_generic() displays file sizes but no timestamps. The FAT
> filesystem stores a change date in every directory entry and already
> populates fs_dirent::change_time in fat_readdir(). Print the date
> alongside the file size for filesystems that provide it.
>
> Add a u32 capability bitmap (caps) to struct fstype_info. Each bit
> documents a property that the filesystem's readdir() implementation
> guarantees:
>
>   FS_CAP_DATE  BIT(0)  change_time in fs_dirent is valid
>
> fs_ls_generic() tests FS_CAP_DATE once before the loop to select a
> consistent output format for the entire listing:
>
>   12345678  2024-03-15 09:30  filename.txt    (FAT)
>   12345678   filename.txt                     (ext4, squashfs, ...)
>
> Set FS_CAP_DATE for FAT. fat2rtc() loses the __maybe_unused annotation
> [...]
>
> fs/fat/fat.c |  2 +-
>  fs/fs.c      | 38 +++++++++++++++++++++++++++++++++++---
>  2 files changed, 36 insertions(+), 4 deletions(-)

> Set FS_CAP_DATE for FAT. fat2rtc() loses the __maybe_unused annotation
> since it is now called unconditionally outside XPL builds.

This patch doesn't remove the annotation. fat2rtc() is still 'static
void __maybe_unused' in fat.c. Please can you either remove the
annotation or drop this sentence?

> diff --git a/fs/fs.c b/fs/fs.c
> @@ -38,6 +38,11 @@ static int fs_dev_part;
> +/*/
> + * define FS_CAP_DATE - readdir() populates fs_dirent::change_time
> + */

The opener '/*/' looks like a typo for '/**'

> diff --git a/fs/fs.c b/fs/fs.c
> @@ -50,6 +55,10 @@ struct fstype_info {
> +#if !IS_ENABLED(CONFIG_XPL_BUILD)
> +     /* Capability flags (FS_CAP_*) */
> +     u32 caps;
> +#endif

This #if leads to three #if blocks in this patch, plus one more for
each filesystem that gets the cap (patch 3 adds another). All of that
saves only 4 bytes per entry. I suggest always including caps and
doing this in fs_ls_generic():

   bool has_date = !IS_ENABLED(CONFIG_XPL_BUILD) &&
                   (fs_get_info(fs_type)->caps & FS_CAP_DATE);

The compiler still drops the date code in XPL builds, and fstypes[]
needs no #ifdefs. What do you think?

Even better IMO you could create an accessor in the header file as we
have done in global_data.h

> diff --git a/fs/fs.c b/fs/fs.c
> @@ -112,15 +130,26 @@ static int fs_ls_generic(const char *dirname)
> -                     printf("            %s/\n", dent->name);
> +                     printf("          ");
>                       ndirs++;
>               } else if (dent->type == FS_DT_LNK) {
> -                     printf("    <SYM>   %s\n", dent->name);
> +                     printf("    <SYM> ");
>                       nfiles++;
>               } else {
> -                     printf(" %8lld   %s\n", dent->size, dent->name);
> +                     printf(" %8lld ", dent->size);

This also changes the output for every filesystem without FS_CAP_DATE:
the name column moves from 12 to 10 characters. That is why patch 9
has to change the erofs test, and user scripts that parse ls output
could break too. Please can you keep the existing three-space gap when
has_date is false, e.g. by printing the separator after the optional
date? Then only FAT and ext4 output changes.

Regards,
Simon

