Return-Path: <linux-erofs+bounces-3457-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 93F78CD4F54
	for <linux-erofs@archiver.kernel.org>; Tue, 19 May 2026 20:00:09 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4gKlrl6RNJz2xRw;
	Wed, 20 May 2026 06:00:07 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=pass smtp.remote-ip="2a00:1450:4864:20::632" arc.chain=google.com
ARC-Seal: i=2; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1779220807;
	cv=pass; b=m9xCSd+pi4uoaE2MsTnLGdVT7LdwMCzpLNsNdxYgt9neamAbTUcKOIQpDnJkjNXVGiykfZs8/VeyMYYvyJKhYU/GRcMmanc9llLquYZ003mGF2PD3fgBwINI73wc1vvkIjWlc56P5gY5SdCp7fqcL2az6Tbf1u9NHLpOulhpKezjcHjwq5D4jwcEyI4M2n59rL/NNIRYVu6XdhtKjDUr735ghI2g3qI7JXHLXDs/eg3KByZ9cCMynZG2bjJ1AcT84IxnjXqvgsJfMSielYI45B0XXA1448ZCFEJgwTqEJCAEJy2VMrYWILZ7g7r4pcsawPj5zsyzaV4Y+sE7Es9qVA==
ARC-Message-Signature: i=2; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1779220807; c=relaxed/relaxed;
	bh=lXqkBgBHWHlFsx8yNZ4rQdprriQHQw/FDVzH+CX72Ho=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=LmmbM/1Mbbt5alt7CkVroCRRbRCIIx1hF0By4v9ygKmKDKqt5IVMY9xpjbjhzjHzRRPE2TFXjwSdwOjQgV/qPCpVWWo6dwQkPGcLRbfhMALIyVxRtx5uvTeaK0nehfbIdjKkido1IY8KGR0yqOcxCs9ejSG9kwmh9I/B9csOn5HGNoi3j1CXGJka2D90Hxg5II9AW5Se+Q+IsSX2HHYUxolYCjtN64KBHWQKyzaw6pntcOPegx4jk/lRc/p5QZzUZEjl+15P5XTG6zaL0xnn5Pj33+feruwLgdYNtp1N/35p0YSMFS0RAQ0Ky+gHSwkqa3xtPJ5eaaYbLJzsIva3Sw==
ARC-Authentication-Results: i=2; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=chromium.org; dkim=pass (1024-bit key; unprotected) header.d=chromium.org header.i=@chromium.org header.a=rsa-sha256 header.s=google header.b=FkkgUTp6; dkim-atps=neutral; spf=pass (client-ip=2a00:1450:4864:20::632; helo=mail-ej1-x632.google.com; envelope-from=sjg@chromium.org; receiver=lists.ozlabs.org) smtp.mailfrom=chromium.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=chromium.org header.i=@chromium.org header.a=rsa-sha256 header.s=google header.b=FkkgUTp6;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=chromium.org (client-ip=2a00:1450:4864:20::632; helo=mail-ej1-x632.google.com; envelope-from=sjg@chromium.org; receiver=lists.ozlabs.org)
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4gKlrj3bMQz2yD6
	for <linux-erofs@lists.ozlabs.org>; Wed, 20 May 2026 06:00:04 +1000 (AEST)
Received: by mail-ej1-x632.google.com with SMTP id a640c23a62f3a-bd2d8bb1068so821410066b.1
        for <linux-erofs@lists.ozlabs.org>; Tue, 19 May 2026 13:00:04 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1779220799; cv=none;
        d=google.com; s=arc-20240605;
        b=jOLvyvzclYP8/N95QLP3XYyxgttJEUkq+yI1AfoMn8w8Fib5JqW6tXImGWpna6zFAP
         +TPlxkVEE7A/L4sE6YPaEIUfrfuvHdEmD/CKeaNqiCX2VnwYQuB23i93Fn+bl5Zc5+Af
         jL5Sxc1tax4HRN7LwOaapr+fL+RKH029J0XRP1qk+9aZV+MbxyRJN0wlps7LQLOsh/PV
         yyB3giSnbCpLUxlXkX4XgI5784fgoAt5Z4aYvgSU8CNixDZ4OZoyWdW5xqiOHFm88xcY
         0/zBIgFWFmwTul9ynS8ZVmY0J6G3wekNR6R5IAUyfaJ6ZPYuzeZe3N3XN0ECObyTbw7e
         hOTw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=lXqkBgBHWHlFsx8yNZ4rQdprriQHQw/FDVzH+CX72Ho=;
        fh=rxZAwnwZXk8OtYzXFyrrzCTKy3PRzcMLJ/cP7K76XVI=;
        b=W1IPrFFqAbM324DhtotoV9NImiNc0cSa5d5+g6soTSIEl/O8CNGrXGLAkVKgt3N19z
         BH1kYk34jGNNGM9gcihOQzNLg28YHCCbUcEy/7TIgCnVIIZ5yK10UxTyoR1yjn1xDnd0
         SpTVN1NZUMWNG/2pFM5wCaazfrtQuCTVWM+esbHWsCYfxzXHIJDTdvTob7++lFjNjUEe
         SCXrN5UlniPF6NyYmWwmCBV9cMi6MV8a0JLR8AH+6YoUoN02fxM755pN/yE535uMFcg3
         zJkq3l4YRh/pZQZ3SE5/DueX7oqs6j/pubPmTGJJ2yXhQHpCo5sd+GrxUkrjvcucDygu
         nPwQ==;
        darn=lists.ozlabs.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1779220799; x=1779825599; darn=lists.ozlabs.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=lXqkBgBHWHlFsx8yNZ4rQdprriQHQw/FDVzH+CX72Ho=;
        b=FkkgUTp6xvZ9Dht3kfunwBJ1xhMiO5sEgMOnRAMWlOB4b0AhQbwAVzdKejqgziNewa
         Tyqk6Pdk4hhHIhnLl7mcNyKNGhK4ybSiXy4RhccM+w68nq9TiVpLoEqc5sYMq8oi8L8F
         /5HBeauP3i9qjkHisJknU7pnPEnxDmZiDcJ6g=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779220799; x=1779825599;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lXqkBgBHWHlFsx8yNZ4rQdprriQHQw/FDVzH+CX72Ho=;
        b=BM2FTn0G7upbdDI/3NmRdwTo4gGlghzAu6Fls2nyusCmJRqmziWGJfbTzrEvaW20vx
         cu65b0iI5DgMpP8AeaBPmVEbVMUCYPBFKeTbGkCHNDAmLKWdk7Eixroimrr+rou9H7+O
         m56YqTBcpejyWUwVdwsFz3lk0EXh2GG0V9anQS6RgkqvXJHyGuYHBG8kL4bFALJ72aT2
         P6T9o4t/YxgTyCFJMPGkVIx9uXXI+0nS7DJUMVpJTy0P413++msdi9eT0lN/mLBaObbq
         ghjZBEkmq6+CA+ne7Nm79NIwa9nBBDYZ0p1dN9vw0h+fP9vwqzDsuP4BeqFTWHsl/IqI
         cWZQ==
X-Forwarded-Encrypted: i=1; AFNElJ/kDYE8SZeHkv9c8AKcSpukE0l9gilt8TET4CbXhncEYBbA4oDRtk1kRrXMiDEQQo9Ix6T57pKWJAJSCg==@lists.ozlabs.org
X-Gm-Message-State: AOJu0YyQApvIwlmDYkgS7mVE6zJWq2nUMMI0v55TToJypKU4hUVgoPdg
	D8tnU7IjQnwx+66ljkHt6l+iHtvo9g/dEXqgySZEUuQqpqC/zZC6hgabeNas5BfEFB3ahCTfJC/
	T1Ld4u9QiTDxeFETG/PD555fngwUBjZ31Gbn57bYx
X-Gm-Gg: Acq92OH0D8aX4bGClnUoSvRib2Ec0BvY6KOVMgQ1/0i2DOyCpYY2SoYJKcFB87SZOtr
	arAD/qCHRTaF/sksfc4w95Xa8dFchDZwhxHvsfbAVLCqL2Po9SMIUzErGZLw1D91uytOMfH2j6M
	q4N4/tpMW4lulC9GaUUPf5miI8E0nMC0Tdx4YYYlUB5wQAT358HSbMdCq1GFZW5+TRzL+GvLLoJ
	ZqQuBsADLW2QZ7SnP01Npbdw+TamCI8lJZaZi10kAnw56vvXgyOn15BxMHTfuGVFKRcXiZ+bhJI
	ULFLpQ==
X-Received: by 2002:a17:907:9453:b0:bd5:28e0:239c with SMTP id
 a640c23a62f3a-bd8caf01170mr447957466b.30.1779220799140; Tue, 19 May 2026
 12:59:59 -0700 (PDT)
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
References: <20260518055728.178507-1-heinrich.schuchardt@canonical.com> <20260518055728.178507-3-heinrich.schuchardt@canonical.com>
In-Reply-To: <20260518055728.178507-3-heinrich.schuchardt@canonical.com>
From: Simon Glass <sjg@chromium.org>
Date: Tue, 19 May 2026 13:59:48 -0600
X-Gm-Features: AVHnY4J1NxSRZ1DLlaK8cbYb-0YapjfPgHvlgSlKTXiSqHGxHFAYWvr8vAKi88s
Message-ID: <CAFLszTieLo3iVU2PqDUbX5oOeoRGT2A2fCH8R_utrbjDLsuEUA@mail.gmail.com>
Subject: Re: [PATCH 2/9] fs: print change date in directory listing for FAT
To: heinrich.schuchardt@canonical.com
Cc: Tom Rini <trini@konsulko.com>, Simon Glass <sjg@chromium.org>, 
	Huang Jianan <jnhuang95@gmail.com>, Quentin Schulz <quentin.schulz@cherry.de>, 
	Tony Dinh <mibodhi@gmail.com>, =?UTF-8?Q?Timo_tp_Prei=C3=9Fl?= <t.preissl@proton.me>, 
	Francois Berder <fberder@outlook.fr>, Andrew Goodbody <andrew.goodbody@linaro.org>, 
	Daniel Palmer <daniel@thingy.jp>, 
	Varadarajan Narayanan <varadarajan.narayanan@oss.qualcomm.com>, 
	Sughosh Ganu <sughosh.ganu@arm.com>, Ilias Apalodimas <ilias.apalodimas@linaro.org>, 
	Peng Fan <peng.fan@nxp.com>, Marek Vasut <marek.vasut+renesas@mailbox.org>, u-boot@lists.denx.de, 
	linux-erofs@lists.ozlabs.org
Content-Type: text/plain; charset="UTF-8"

Hi Heinrich,

On 2026-05-18T05:57:19, Heinrich Schuchardt
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

> diff --git a/fs/fat/fat.c b/fs/fat/fat.c
> @@ -1539,7 +1539,7 @@ int fat_readdir(struct fs_dir_stream *dirs, struct fs_dirent **dentp)
>
>       memset(dent, 0, sizeof(*dent));
>       strcpy(dent->name, dir->itr.name);
> -     if (CONFIG_IS_ENABLED(EFI_LOADER)) {
> +     if (!IS_ENABLED(CONFIG_XPL_BUILD)) {
>               dent->attr = dir->itr.dent->attr;

The commit message says fat2rtc() loses __maybe_unused, but the diff
does not touch fat2rtc()

> diff --git a/fs/fs.c b/fs/fs.c
> @@ -38,6 +38,11 @@ static int fs_dev_part;
>  static struct disk_partition fs_partition;
>  static int fs_type = FS_TYPE_ANY;
>
> +/*
> + * define FS_CAP_DATE - readdir() populates fs_dirent::change_time
> + */
> +#define FS_CAP_DATE  BIT(0)

The leading 'define' reads like a half-finished kernel-doc. Please
make this a plain comment:

   /* FS_CAP_DATE: readdir() populates fs_dirent::change_time */

> diff --git a/fs/fs.c b/fs/fs.c
> @@ -98,10 +107,19 @@ static inline int fs_ls_unsupported(const char *dirname)
>       return -1;
>  }
>
> +/* Forward declaration - defined after fstypes[] */
> +static struct fstype_info *fs_get_info(int fstype);
> +

Patch 1 moved struct fstype_info to the top precisely to avoid this.
Please move fs_get_info() up next to the struct (or just before
fs_ls_generic()) and drop the forward decl.

> diff --git a/fs/fs.c b/fs/fs.c
> @@ -112,15 +130,26 @@ static int fs_ls_generic(const char *dirname)
>       while ((dent = fs_readdir(dirs))) {
>               if (dent->type == FS_DT_DIR) {
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
>                       nfiles++;
>               }

This silently narrows the gap between size and name from three spaces
to one for every filesystem, not only the ones opting into FS_CAP_DATE

That is why patch 9 has to fix up the erofs test, but ubifs, sandbox
etc. get the same churn for no functional gain. How about keeping the
original layout when has_date is false?

> diff --git a/fs/fs.c b/fs/fs.c
> @@ -112,15 +130,26 @@ static int fs_ls_generic(const char *dirname)
> +             if (has_date)
> +                     printf("%04d-%02d-%02d %02d:%02d ",
> +                            dent->change_time.tm_year,
> +                            dent->change_time.tm_mon,
> +                            dent->change_time.tm_mday,
> +                            dent->change_time.tm_hour,
> +                            dent->change_time.tm_min);

If the date was never set, this presumably prints '0000-00-00 00:00
filename', which is more misleading than no date at all. It is is
unset it would be better to show nothing.

Regards,
Simon

