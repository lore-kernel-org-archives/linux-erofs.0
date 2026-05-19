Return-Path: <linux-erofs+bounces-3463-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CB321CD4F54
	for <linux-erofs@archiver.kernel.org>; Tue, 19 May 2026 20:04:13 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4gKlxS1GL4z2xwH;
	Wed, 20 May 2026 06:04:12 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=pass smtp.remote-ip="2a00:1450:4864:20::631" arc.chain=google.com
ARC-Seal: i=2; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1779221052;
	cv=pass; b=NdSzSwNm4o1Z6rMC1bC0LpKZ8KZZ/jyg+ld9syshN/3I6kGdYNnqjgkgTPSIAjMr67FSy9j4TmsOPOTGO9IbON7oqC5tnXZtzx3TZgBhdjmDOzmCKBbZPpDxMcGeBt21RA/s3l9C9vZdn/Vao9J9p2pz/WyZ/0Y+U0QnG6ViMpccqxGcyrn4UQX0FDV6pl4OnXIMfzbPpsqNFHMkcvfXVZMHViwyzKCE7hDc0mn7uNkkFp69TrYiPeztqeOH0l4fESbI0U1HITo++BTvGFmGoYf42TpC1rLeC2xboJHOnNG8i7uXVALn++tpwdu86Nx3mvLgk/G7xwk7G/fYTFKIwA==
ARC-Message-Signature: i=2; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1779221052; c=relaxed/relaxed;
	bh=yTPTI2psMEWp4a1n1BamC1BC0M+zxkzs3hcoRXtiIUc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=jeetAth5+YYaRndTE2ZCM2mA6eiULGub6bTpX6t4vmiqM5oGsDOPz0cZospn5Yl3h473Ea4f/KSLcshXDh9YvWTiwefG0oIo6w5GLLq1OOIQ/TCVxf8r+mugi3vcxQ7tDnFWWnFQCjaPF15CL+BcqTPcINkRGb7X9ZJqhfiOlBFC2bEX8vDJM6jM1A8JvRj6Jo5oDZ6f2TcGbVU6WrYOmKG8Jotl7qbiXDVSXEEWQQm5Nf8yNBQixp2ftmjzjuCOh9Rjmj8Y2pNSH+PygVCkER4//1bBC/mwD0oRyPuO0jWR9B4lrO5MEWGrcQ35Cpcg4bZkeqgIqodDrWnh2NB8cA==
ARC-Authentication-Results: i=2; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=chromium.org; dkim=pass (1024-bit key; unprotected) header.d=chromium.org header.i=@chromium.org header.a=rsa-sha256 header.s=google header.b=V4wjoex5; dkim-atps=neutral; spf=pass (client-ip=2a00:1450:4864:20::631; helo=mail-ej1-x631.google.com; envelope-from=sjg@chromium.org; receiver=lists.ozlabs.org) smtp.mailfrom=chromium.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=chromium.org header.i=@chromium.org header.a=rsa-sha256 header.s=google header.b=V4wjoex5;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=chromium.org (client-ip=2a00:1450:4864:20::631; helo=mail-ej1-x631.google.com; envelope-from=sjg@chromium.org; receiver=lists.ozlabs.org)
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4gKlxQ71F0z2xRw
	for <linux-erofs@lists.ozlabs.org>; Wed, 20 May 2026 06:04:10 +1000 (AEST)
Received: by mail-ej1-x631.google.com with SMTP id a640c23a62f3a-bd4f8260e4eso824556966b.1
        for <linux-erofs@lists.ozlabs.org>; Tue, 19 May 2026 13:04:10 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1779221048; cv=none;
        d=google.com; s=arc-20240605;
        b=aKy+NUO+BDh+G+KjZlp0NAzekmwwpSBKUCpzlCvcLV2AgmKeDGEEzCAUvSMLs3SogU
         En0Xr1FXo21Y4Nhu0AvOQoPhFlrmIvOaUVapoqHpbuZaEg9fPxRgtZlOGLni0w7Vc4BZ
         +2oNWW4LVj8e/5xwM7D4OxQHXyxP4b5010906qRJMBsHzoBLAM1nzjfvb+sH2iWn96cc
         vc4O9cez+rIODLnbBl6MNysSXazNtvehI/OeSDNaUU8t016zDMx5S3YcaMVQDtBYD1ae
         NMBd6fQ2mgNfMLEEBLK4kOMUL/LAGF2FkRhxJD56Wu2aJepbnwiGeNsZKF747p7nVHXO
         8cpw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=yTPTI2psMEWp4a1n1BamC1BC0M+zxkzs3hcoRXtiIUc=;
        fh=w5ayNOX3/ZLvf5UXb+yqqvYHhEjlTMC83lFhzjFzGVA=;
        b=kCQEXAhXI3Hle44eyQ96zYm2wQrhqxE/DXoOHFpJuYnjG0Ds3gGdoaALKMuHx6n5GO
         NFFyTVM0BaXXpklxcW+eIe7NwzzhrnvdMQmEP29SUSAxANWyleh5nFNry6/EmKEg/nnm
         SgIbBaAos9qyvrlmLPYiLT94uPINVwiNvU92gXIRSfvImPqUB8sq5oA/VmO08TeEBKvZ
         FWQHSnF8rGYdTe0VkLm0gb+mA+8T/nnXXYRAZDrEC026ImpL0FqTcTB4jpYAsaFbsdX3
         3G3u8qRqa8zOlUCTk0OyP67wVhGEn9NxbmGdFVSiCtJeMHHqAiR//mcqYedIrgRlyug8
         cOxw==;
        darn=lists.ozlabs.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1779221048; x=1779825848; darn=lists.ozlabs.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=yTPTI2psMEWp4a1n1BamC1BC0M+zxkzs3hcoRXtiIUc=;
        b=V4wjoex5g43WB2zV323nZyCTtWbzfP3IupTeRvcwBjYUP78kVltPjV0XLsIZU+R3g4
         KXiyCO9HaJMvb0HgMbkFOg98X/82PKHmeBPNqUOMJtMbpnpDke3kLz597PeHzaduJVSC
         sDSR5dvNqyY4eaWb2hBUHkqxCikXcYYxw+YTc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779221048; x=1779825848;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yTPTI2psMEWp4a1n1BamC1BC0M+zxkzs3hcoRXtiIUc=;
        b=nsh4AasJtSJ5ovV+GghlR8Th2yeQclvfW7m0aa2FRZ17ApV6SK3vnsXNtcIBWsLZaj
         Ma1MPCClbrpG1Y3pgAWRceraMNRR7CBpeFZGKBuyZqTcMlBvN7ED1OVSuBYEqPnFwp3P
         YTTxduAIXBRIyVRs1sgG22nizD9AjKeOGNp5XQXK8VcqaHSqE6QWk856jQ0Ij5kpf7S6
         wIEkli/+4tQhSRj75MNXvMXQ52OeG914SveoQ7Jr5fK0ofG7o5RRieKYUQrujUaudWlj
         YLZimxltguhFgNKQnzuQKAZOA6kcLaNMz2fu5f9lTmYlWs18s3nuT+yPy+p3vnV4kfyl
         1DOQ==
X-Forwarded-Encrypted: i=1; AFNElJ9g50v14GdHO2xfJHM1dvBT+2NodjNgLd+qoaUPXUKTSe00KcsEPFvLFmM9TUhW/PtUEk+4lYZ9V1veaQ==@lists.ozlabs.org
X-Gm-Message-State: AOJu0YyUFjbQHDzjME6snJxbJzyS2OMp7aJrrkv27RD3aZgIgCwd6lHI
	65fhHrmPWKZbL9vzMPf1/yvJlMM8KhYUpLf64d88sEpK+r9VsqIcMoPiVvKmFIkWU3jPmvLoCqB
	UsYnmdQFyl1/EHkAP58QVNUAKMn/9060tIAuDahrG
X-Gm-Gg: Acq92OFZXUh9+7dIyty5SIzWXr0poIbJ/yV2odo/GNptTmoOfJUTp98BNg2DvszwKkZ
	fETioeVUjewVs1ESnEsUEDoSWbMDeIm5bvC1CxACJOsKhZhdixf9LNakGOuBiasG6i96aDPHmcD
	id6gHQ5V/9KbasRVP0Gs/h/zrUqjaqnrF//V8XnU2IJFBQCfjM+0Ywfpr7uljkkkETO1y774kbg
	ssqRoThpE8K02sf+5UGIWbmWUnGy99xdcXbANmlNDWrzWctDDurhVDnM1KMcH4qV3ujjjlNPfTz
	cZ23hw==
X-Received: by 2002:a17:907:93d4:b0:bd4:c6be:5f2e with SMTP id
 a640c23a62f3a-bd51777c81fmr866607266b.3.1779221047779; Tue, 19 May 2026
 13:04:07 -0700 (PDT)
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
References: <20260518055728.178507-1-heinrich.schuchardt@canonical.com> <20260518055728.178507-5-heinrich.schuchardt@canonical.com>
In-Reply-To: <20260518055728.178507-5-heinrich.schuchardt@canonical.com>
From: Simon Glass <sjg@chromium.org>
Date: Tue, 19 May 2026 14:03:56 -0600
X-Gm-Features: AVHnY4J-5Cslh3TMp-KY-sWqlxb2CJgZq_WdxDPFvN5BPPf6v7zAc8rA9tE7s6I
Message-ID: <CAFLszTgSmMSKzocWFkAMcq4tHb3ZbbjJ=Ouby=iuSnfAHBmmzQ@mail.gmail.com>
Subject: Re: [PATCH 4/9] fs: ext4: don't read time fields in XPL
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
> fs: ext4: don't read time fields in XPL
>
> The ext4 readdir implementation populates dent time fields in XML
> builds though that information is never used.
>
> Guard the three rtc_to_tm() calls with !IS_ENABLED(CONFIG_XPL_BUILD),
> consistent with the FAT driver.
>
> Signed-off-by: Heinrich Schuchardt <heinrich.schuchardt@canonical.com>
>
> fs/ext4/ext4fs.c | 8 +++++---
>  1 file changed, 5 insertions(+), 3 deletions(-)

> diff --git a/fs/ext4/ext4fs.c b/fs/ext4/ext4fs.c
> @@ -319,9 +319,11 @@ int ext4fs_readdir(struct fs_dir_stream *fs_dirs, struct fs_dirent **dentp)
> -     rtc_to_tm(fdiro.inode.atime, &dent->access_time);
> -     rtc_to_tm(fdiro.inode.ctime, &dent->create_time);
> -     rtc_to_tm(fdiro.inode.mtime, &dent->change_time);
> +     if (!IS_ENABLED(CONFIG_XPL_BUILD)) {
> +             rtc_to_tm(le32_to_cpu(fdiro.inode.atime), &dent->access_time);
> +             rtc_to_tm(le32_to_cpu(fdiro.inode.ctime), &dent->create_time);
> +             rtc_to_tm(le32_to_cpu(fdiro.inode.mtime), &dent->change_time);
> +     }

The le32_to_cpu() addition is a separate fix from the XPL guard,
right? Please mention the endianness fix in the commit message, or
better, split it into its own patch that can be backported
independently.

BTW dent->size on the next line has the same problem, doesn't it?

>     fs: ext4: don't read time fields in XPL
>
>     The ext4 readdir implementation populates dent time fields in XML
>     builds though that information is never used.

Typo: XML should be xPL

Regards,
Simon

