Return-Path: <linux-erofs+bounces-4717-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 20431CA9EDE
	for <linux-erofs@archiver.kernel.org>; Tue, 13 Oct 2026 03:31:25 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4j3fy32fRHz30VT;
	Tue, 13 Oct 2026 14:31:23 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=pass smtp.remote-ip="2607:f8b0:4864:20::102b" arc.chain=google.com
ARC-Seal: i=2; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1791862283;
	cv=pass; b=VC5lb3d6fnXYJvbUZLwxNPfvnYvVTTRnqF3oVdwxgIgVwItMnNoosbm4JpkCa+jmCY3W6tiLY9PGWIc3mROlyBDGX//0csHHm79kW6xGbXrGhNLqDdmFO9HClBoUnr9w4+pyQvdmyuonbj9KPyUf76MMsh6OTfmNXWdTXhFzJImCUljCKYkxyFapZeBYk2dcHsxa/jhVgILAw8kOWsOwXWE84U/AUrOZhk9N7yF6ZTVOjWo6HAqHXlFWXOa6E5GdVeCkXMpL6RNL6WPN94SmFOUor2GbhIA/vxE/2901yngoxv5iytyQD7PR5ct6uKDJn7xaPw65YjOuuS0vRU7zYA==
ARC-Message-Signature: i=2; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1791862283; c=relaxed/relaxed;
	bh=vcbZqrGBsK7o8arezNi7wMlzSqOMC0gjg9LpaUiRj/I=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=AmUcxcW1SDuIggiOCONdv41qN0mcAyuVKEIAyZjhc2gNG7ibv8N09VR8tPCSlZ4PPDKPBoIuOxur9nafKrxprUEN0bLeBOv1FcyRydYYuiYTIHit6bLt2/b/ZRZMZZSE1ytss4N5oA5jm7Mq/wJpYwnpwaXW3g+/pIlQWdsIKTLsW8QGHvsxooE+v/aYpCixh+JkOZIVzeUQkbOSc2+vgmBRPiYTQDZ9m21f0lsCyyymtVU4lzDwNtRyanQyn8oxVfjqeEAA8hlkgMjjDkWO/pEMTXmeW8dkgdZR4IjGVysukaR/zKNgkWR/UIMLOIm/x2Ka/qhE6fxL480A5vIA5Q==
ARC-Authentication-Results: i=2; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=chromium.org; dkim=pass (1024-bit key; unprotected) header.d=chromium.org header.i=@chromium.org header.a=rsa-sha256 header.s=google header.b=aGZaKCUc; dkim-atps=neutral; spf=pass (client-ip=2607:f8b0:4864:20::102b; helo=mail-pj1-x102b.google.com; envelope-from=sjg@chromium.org; receiver=lists.ozlabs.org) smtp.mailfrom=chromium.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=chromium.org header.i=@chromium.org header.a=rsa-sha256 header.s=google header.b=aGZaKCUc;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=chromium.org (client-ip=2607:f8b0:4864:20::102b; helo=mail-pj1-x102b.google.com; envelope-from=sjg@chromium.org; receiver=lists.ozlabs.org)
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4j3fy24M1wz30Tf
	for <linux-erofs@lists.ozlabs.org>; Tue, 13 Oct 2026 14:31:22 +1100 (AEDT)
Received: by mail-pj1-x102b.google.com with SMTP id 98e67ed59e1d1-3ac397836fbso317251a91.1
        for <linux-erofs@lists.ozlabs.org>; Mon, 12 Oct 2026 20:31:22 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1791862280; cv=none;
        d=google.com; s=arc-20260327;
        b=n+78zi7uzXykiZXbeBeHcEFbhPK/x3nq0Jngrv5nBFRXK7m4CkmoIhhi7Kzwh6ZC6i
         o+dXIfLjUmQrU13/WRAr0xkFBC+2P6wdLtWFsOSmUcfufBKe9ZQo3V98sklOSh4SJHV6
         +9J/2WzrCxES9helMduXTwG5iOYM1QPbbwZuhpz6k1BOzJhPleFNTk0fBQBrjQ1IYl3j
         J1Sak/B8lD8b+rd0ND1EbFrqE9QyoAvxzSPej+UdFILG46KGuuksF24kJ53Mh2SWmU5j
         dY5RdVSVbLUOWATB7Yx0oWjirwMpzaqDKNtsd2wwBp61dgXaDA1qOhRxfZfPT09vUGbm
         gXJA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=vcbZqrGBsK7o8arezNi7wMlzSqOMC0gjg9LpaUiRj/I=;
        fh=1lIeWPKeIVYQidnFZRyBW1IXel4rYKMfOznfWHcqSM8=;
        b=J1D+s7sfSJJ9g7CWgJYSiLc+9CbwkmOAOnik+P4LAaddnu8y6rVTFpR6zZeegGcqn3
         wzfWyUw2a109Wo2ysZvfB0lVv8fQ97W5/6GthoniohTtlgjmqScJkxE3SDghL3NDLtv1
         eH7O//q9oav8IOpv4/yY5gCwH0c42EP0fNF63rbYpEQ+JhTesN128trFWotGL5LtQLgD
         XqD+idoWHFwbfRiyVJctH6Kz4IPv053QzGvjIsC8LWidZE+gLdokrRe7m2SOvVMT07ng
         p3vLY2Uv+FL+PxhKeIQ2KgUaK9136C0lUdXBQMkTAV7YARueIjYYgfcMK+4ek8ZcVt9r
         2JyQ==;
        darn=lists.ozlabs.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1791862280; x=1792467080; darn=lists.ozlabs.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=vcbZqrGBsK7o8arezNi7wMlzSqOMC0gjg9LpaUiRj/I=;
        b=aGZaKCUco/wB1drXCQEXMPyQ5HaBL5bjZfWLd9Yk+2BO+XLCt/xlQEw+3iLrFGqYoH
         NpTbuppRc1lrglCl711s3E+EbEuaIChqtliNhIk/22z/4BXwOphxXA92I2HIsl54bvAZ
         iX5sR508mEOTzDTWFjKzUuQ4jiTVi6pHhZTNY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791862280; x=1792467080;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=vcbZqrGBsK7o8arezNi7wMlzSqOMC0gjg9LpaUiRj/I=;
        b=LjM46U/i9Q20Mk1FWyTPtQuZRRCRtqIMImq94d6KvoDUZA3ayf6w6a5Szeamm+UThc
         sbxEQwnY6+J88rDIV2hoaaxjmIP2BfRSepHWhMhskKJCFkl7JG2KGhHfqo/paSWZY5zk
         T3HOpvC3o6/pOHz1MNzwbaUfc5rVSAR9drC2+darmRdZx2ezxNG73Nm1UcsFB6Go1b31
         Nq6Okb28Mhctshxls5NI2Ue5Xfvc/0KBuVecoAnw8GGVRPZ6+Oy8dsSQ5mJsk0J//wip
         Dafu+JEt70efSttXUbGXnQyyFFMoMhxSVUm0MIKqyVOvFG+5axjj0HvDhpm76Zm1dptf
         WgJA==
X-Forwarded-Encrypted: i=1; AKwUvByJ+uSt+DstoqH7yUvLaI7qNCUXDfIrWTF1mAcshKE/ZK8mJE0SJrdYADmzCuhhVfKY87PiDWQ+G7Z+Nw==@lists.ozlabs.org
X-Gm-Message-State: AFq9FYJLFW79B9QAA/cDaiDeClLxeNiisFu4KQObnI7rrEUKOQgoMxuH
	b0ZHNoH6Cr55Ob3AdrKqfqJ8guDswrKmEi5mTeeJk6RSpcpMR83U51GxBX8b2HIbpBErXGaeCnu
	0Mz4u7iH00BS0kehT8G4v8uLWV5IjeMa2EPv0vgSV
X-Gm-Gg: AYBFou29AX2LlU/z/PEkU3eX/wxsX/44KfP4s9RB+mE/5n0k/ZKxnACGLqApr9PRbJX
	V0BDRCtSKhx8fujYbvTP6X9RKtrzwiCpLPSuOkcAHw7ZtMaj54jmQBg3k854RrcTLPPA04wRCa5
	20WrsEllTWCQ9ezLquIBuwfyBFutBS0gAe6aq0kuVhG5geCPxxMZdqBqObnoCQH7joLc9OTkkvu
	Q2IU3e+SIa2w/nNybgGmZMVOU1l7vdVEF41emsW2t+20oogjV2JaiNcgq48RKMPzX8uoexpYvHc
	G7qD0rouEc/B0b7nWUgj5c9uk1A4afQWY7pXU5F4qEnhORaJ5IEKQxAu
X-Received: by 2002:a17:90a:e7cb:b0:3aa:ee81:a62d with SMTP id
 98e67ed59e1d1-3ab3a7480f9mr10165350a91.35.1791862280010; Mon, 12 Oct 2026
 20:31:20 -0700 (PDT)
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
References: <20261012140048.214059-1-heinrich.schuchardt@canonical.com> <20261012140048.214059-6-heinrich.schuchardt@canonical.com>
In-Reply-To: <20261012140048.214059-6-heinrich.schuchardt@canonical.com>
From: Simon Glass <sjg@chromium.org>
Date: Tue, 13 Oct 2026 04:31:00 +0100
X-Gm-Features: AclHuK929FrbUR7aOcQqwDw6f1SfnayjkyunAH_oU9aSTpiArx2EkM6gq1U84-k
Message-ID: <CAFLszTirBLO+T=SCyPpuNAV9KmDbwxYd2fois5trtYOERZUBpw@mail.gmail.com>
Subject: Re: [PATCH 5/9] fs: ext4: set inode timestamps on write
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
> fs: ext4: set inode timestamps on write
>
> Replace the hardcoded zero timestamp in ext4fs_write() with the actual
> current time obtained from the RTC when CONFIG_DM_RTC is enabled.
>
> Per the ext2/3/4 specification (ext2 design document, section 4.2):
>   i_mtime  last data modification time
>   i_ctime  last inode change time (the 'c' stands for 'change', not
>            'create'; this is not a creation timestamp)
>   i_atime  last access time
>
> All three fields are set to the same value since writing data modifies
> both the file content (mtime) and the inode metadata (ctime), and any
> write also constitutes an access (atime).  If no RTC is available, the
> timestamp falls back to 2000-01-01 00:00:00 UTC, matching the FAT
> write driver behaviour.
>
> The ext4 i_crtime field (true file creation time, added in ext4) is
> stored in the extra inode area beyond the base 128-byte inode and is
> not modelled by struct ext2_inode, so it cannot be set here.
> [...]
>
> fs/ext4/ext4_write.c | 45 +++++++++++++++++++++++++++++++++++++++++++--
>  1 file changed, 43 insertions(+), 2 deletions(-)

> diff --git a/fs/ext4/ext4_write.c b/fs/ext4/ext4_write.c
> @@ -21,14 +21,47 @@
> +/**
> + * ext4_current_timestamp() - get current time as a POSIX timestamp
> + *
> + * Returns the current time as seconds since the Unix epoch.
> + * Falls back to 2000-01-01 00:00:00 UTC if the RTC is unavailable,
> + * matching the behaviour of the FAT write driver.
> + */
> +static time_t ext4_current_timestamp(void)
> +{
> +     if (CONFIG_IS_ENABLED(DM_RTC)) {
> +             struct udevice *dev;
> +             struct rtc_time tm;
> +
> +             uclass_first_device(UCLASS_RTC, &dev);
> +             if (!dev)
> +                     goto fallback;
> +             if (dm_rtc_get(dev, &tm))
> +                     goto fallback;
> +             return rtc_mktime(&tm);
> +     }
> +fallback:
> +     return EXT4_TIMESTAMP_Y2K;
> +}

This copies the RTC lookup from dentry_set_time() in fat_write.c, and
patch 6 adds a third copy in test/dm/host.c. I suggest a small common
helper, e.g. in rtc-uclass.c, that returns the current time in seconds
(or -ENODEV). FAT could convert that to its date/time format and ext4
could use it directly. Then the Y2K fallback, and the RTC
memory-allocation issue that 6/9 works around, are handled in one
place, and the next filesystem that wants timestamps can use the
helper too. What do you think?

For kernel-doc, please use a 'Return:' section rather than 'Returns'
in the body.

> diff --git a/fs/ext4/ext4_write.c b/fs/ext4/ext4_write.c
> @@ -979,7 +1012,15 @@ int ext4fs_write(const char *fname, const char *buffer,
> -     /* ToDo: Update correct time */
> +     /*
> +      * mtime: last data modification time (ext2/3/4 spec 4.2)
> +      * ctime: last inode change time - NOT creation time despite the name
> +      * atime: last access time - set to now since we are writing data
> +      *
> +      * Note: ext4 i_crtime (true creation time) lives in the extended
> +      * inode area beyond the base 128-byte inode and is not modelled
> +      * by struct ext2_inode, so it cannot be set here.
> +      */

ext4fs_update_parent_dentry() changes the parent directory but does
not update its mtime/ctime. That could be a follow-up, but please can
you mention it in the commit message so it is clear that only the file
inode is handled?

Regards,
Simon

