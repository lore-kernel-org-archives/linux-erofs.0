Return-Path: <linux-erofs+bounces-4715-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DE10CCC6B03
	for <linux-erofs@archiver.kernel.org>; Tue, 13 Oct 2026 03:30:47 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4j3fxL2gbhz30V0;
	Tue, 13 Oct 2026 14:30:46 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=pass smtp.remote-ip="2a00:1450:4864:20::533" arc.chain=google.com
ARC-Seal: i=2; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1791862246;
	cv=pass; b=TxMtjZderYs+hnp2UNoemxFdXrjmPVMlHMdAiRYoYcngulMc+BUfkxpJ9jExeijRD4FOIiboQoR0DFvojDJi0F2sjnCBGOoEdKy7sAoGcJKqsENIsehxzrZRpYKuR1GjIMgwKXf8dPGJiPG7dhxgLLBnH5zgiBJkcxw4HkqXOOkv5+qt2mIq9apUPb4quevjRvsYkLcIRpRLJZKfeNtJM+pcQzknl8kBYnJhBWTF+OH1b6SWlvjrTDlOD6xUUq9/gVA191zTo4o4JpSJzguzXZMWP6Kom4zXiZQH0ErSkpnZdpzA9KhAeMOXRjkZLXZ+QAzvakQcMSE2aW/S/AU/+w==
ARC-Message-Signature: i=2; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1791862246; c=relaxed/relaxed;
	bh=5+myLxei0DrwpchrD7vPBT2X99/j9b3NLQSDp+UZF+k=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=W8DkUn2v+z2nVZTDTT+Z61dhMpsEImhnSGClaqumNQXnDTsBH8f4NfoX+xpEEvvTmBqrhl/G5ido+eBa8lvb+mZLVsBZIF6VDe02eVYbYTohgOeMOlteJPFl2wKfvWoJufPnGtG2kOIZz51vMcZyhXfVhdsuP7AHVxbdE8GOl3qmcYQXPTrC/wESf6YuM8P4Jc6kNtOOCzOuHMjW8k7lW0F8ITx3n5Mc+qgw4fGYeg2tdD88rXVD/Aofn/j5U6SdJMkQT1UxSpo1GdugqXLq/46V8q0din2lNYp2zLVTtYF36iCmRcOFqtanquztDTvVX5jl/pzTuG3B13ny2I5TMw==
ARC-Authentication-Results: i=2; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=chromium.org; dkim=pass (1024-bit key; unprotected) header.d=chromium.org header.i=@chromium.org header.a=rsa-sha256 header.s=google header.b=ezNtUGlP; dkim-atps=neutral; spf=pass (client-ip=2a00:1450:4864:20::533; helo=mail-ed1-x533.google.com; envelope-from=sjg@chromium.org; receiver=lists.ozlabs.org) smtp.mailfrom=chromium.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=chromium.org header.i=@chromium.org header.a=rsa-sha256 header.s=google header.b=ezNtUGlP;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=chromium.org (client-ip=2a00:1450:4864:20::533; helo=mail-ed1-x533.google.com; envelope-from=sjg@chromium.org; receiver=lists.ozlabs.org)
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4j3fxK2vbyz30Tf
	for <linux-erofs@lists.ozlabs.org>; Tue, 13 Oct 2026 14:30:45 +1100 (AEDT)
Received: by mail-ed1-x533.google.com with SMTP id 4fb4d7f45d1cf-6b1afcd2d23so2153390a12.1
        for <linux-erofs@lists.ozlabs.org>; Mon, 12 Oct 2026 20:30:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1791862241; cv=none;
        d=google.com; s=arc-20260327;
        b=qTXVa64FV7U2+4sr6272Dep6Kl1sUCKk+nGKRwgH2zc3JCRJoRBgNTawpaM9NL2d9D
         67AdsbZW5AOHBWeN7hfkTjPAK84pX1RqCFcg6oWpoqvu5vHJ9JMeGyZMXnDEsp5eTNYA
         zp/5vt3Z27dazEq4+dmM07ZHY0I1ih618qxlxXLLgsTQYrzL2m7I7TucdwrPfZCQ4z0m
         WiiE1ZkFjXobtQ2BfHkv4pkYS1U8oJxJLtEzuo3o0CrwHAr9PJtyxarmcqGULOcQDxp/
         9Uz3Xa4mSthn1WPFhRqhC6+D6CJoMj9iwD7xwSSkja7TqV+iNZ82noPXEkEE9vQDaf9W
         3+lw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=5+myLxei0DrwpchrD7vPBT2X99/j9b3NLQSDp+UZF+k=;
        fh=Ec211N/4l86UBpvRyPTtmgdZyWOVR3cGpvM6ZQV4tz4=;
        b=QjLiRa/0NKInTQKQPGUJAv66dPMnbKREt4xnPe/wHxes2QFrAKuqnmGcPnZDBvyB95
         XlAY1k/Rk0+ezIWmYvJZDfO8W8TCdi7Z66+sC7Q88u0hzi4nye3F91gKOaiP+zZNexXn
         eEwSxNF61YUz3vnAGs2OxqNqYbg/dgkzH4T3HGf8jKpqXk8V9gehnkLbMMi0DPV/TsYJ
         D5TW0iI+fRao8mA/gOs4rFX1xYRXdupar/zAgSXE4wNDjTyphZ8QSER5ka/LK4S3NelE
         tLXwoQeaPpZz9HI7kOYh8+x9oyzb30Q28hFn4EWgjibtPRX9pUaEsJiqshMEioMQt6NM
         4v1A==;
        darn=lists.ozlabs.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1791862241; x=1792467041; darn=lists.ozlabs.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=5+myLxei0DrwpchrD7vPBT2X99/j9b3NLQSDp+UZF+k=;
        b=ezNtUGlPeRDSSy7iRtO8GrloKJ+w8WS/XCed4rQMbt27APEISI8Odz/gVfSuL/C56X
         0V4gHCW25JA8tr0LgjbWqNYiabRYtqObPahXB3H+LXnM1VGU57y/24ZT3VCcHLpYEuIV
         3h0mSsAahK7pAd12aVz2E8vOAcBe0mmP/4eKE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791862241; x=1792467041;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=5+myLxei0DrwpchrD7vPBT2X99/j9b3NLQSDp+UZF+k=;
        b=pNf54S3nRptco+88THe2FzGOwjbp7WAjld9d7tM6AjV7aJLxTMbPIF2ywaUt5j1EgT
         3ipmZJeoGuWD3ff1eNm/t+T4i2KX4Q4aByAo1f13gKb91ttyEy1w07iDiblw+lAXOXJw
         NwXw1OrsLVw4/9jlEhx9dtRDCmJGtdqpZ6clMLsRLljJVxuLxusZVbRhUk8E9A8cgb9f
         lAMRYt6Llodsap7T+WTxYfxJIUSxYOZS71XC7fK3WRfi2fODOpCFvaAgEZAJqK8Blf7o
         7LvLoTd+mdsWhH7J9m1JJdOz64IsxU68kWZ3KY2FeahPzfDo0evrSgOKxsMaJn5Yu+b+
         qh0g==
X-Forwarded-Encrypted: i=1; AKwUvBw6GPkPJyt9YlIjz6W0AXmceF/ZgczKEr3JkPvnOdmDPb1nPhRag84rOKHEbYk21U+dMDsr/x8CDsnOmA==@lists.ozlabs.org
X-Gm-Message-State: AFq9FYIQeQx2bB3jJRYpubZBhCWC2/AbD1i47U6ZDhy+IXZMDDmyCg2w
	XeKTaDKmCbSb0ZLY9ZdgbX6GqqYFBgdlvfR1fOLkxjZEHpVyAZBpW3uR1qbgrGor7pvTidV8biY
	L8wlB2Z5/Plu0a5xiVe5kwcFGbswsUI81fno8ATgc
X-Gm-Gg: AYBFou33DCmDs55iqH72qwtotV1xfXOWsORw4v8uKC/3CgPDfx5nVJ9zMoNZhyUwIjq
	Yp2LEgui/GVvi0i6g0l27rFBtv19oXBJ9dZMkvPEgqYVU06axO3/rI3AJ6L3W38oO9wKmSZausb
	1nAJhtImUweCvBEDICzdUl7vTayYVH92QUr8JfyhfADcq9Hs0D/yIjshJxiWYGy7t0DMR8Xd2b6
	OkL6ck1E00IgPjI6g4r79Zx8jlu0JUDfYgqcjxIGmTHCADBJQAfiZzPqLN6rIoD5BDSQsjNnFj3
	qPDJa71STyamIEeM5GZwQ0HfK13Rx8lWShomPHsWM+de+bQclhvpMYfp
X-Received: by 2002:a05:6402:a0d6:b0:6ac:a862:d8ce with SMTP id
 4fb4d7f45d1cf-6b17c2389e0mr8370776a12.7.1791862235262; Mon, 12 Oct 2026
 20:30:35 -0700 (PDT)
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
References: <20261012140048.214059-1-heinrich.schuchardt@canonical.com> <20261012140048.214059-4-heinrich.schuchardt@canonical.com>
In-Reply-To: <20261012140048.214059-4-heinrich.schuchardt@canonical.com>
From: Simon Glass <sjg@chromium.org>
Date: Tue, 13 Oct 2026 04:30:19 +0100
X-Gm-Features: AclHuK9VPHxmBMUsd70OuKT1C4KOL3Hvezn-GuCiz0_ZVhQam8yovIHjrzsHRKU
Message-ID: <CAFLszTgHzLZrr_2orNJFiCwG+Gp_g2=doSPEan5z3CxsSh4wRw@mail.gmail.com>
Subject: Re: [PATCH 3/9] fs: ext4: print change date in directory listing
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
> fs: ext4: print change date in directory listing
>
> Declare FS_CAP_DATE in the ext4 fstype_info entry so that fs_ls_generic()
> displays the modification date alongside the file size:

>
>  4096 2024-03-15 09:30 filename.txt

The subject says 'change date' but the body says 'modification date'.
For ext4 these are different fields: i_ctime is the inode change time
and i_mtime is the modification time, as you explain in patch 5. The
code uses mtime, so please can you say 'modification date' in the
subject too? Also, the example does not match the output.
fs_ls_generic() prints ' %8lld ', so the size is padded to eight
columns.

>
>  4096 2024-03-15 09:30 filename.txt
>
> Signed-off-by: Heinrich Schuchardt <heinrich.schuchardt@canonical.com>
>
> fs/fs.c | 3 +++
>  1 file changed, 3 insertions(+)

> diff --git a/fs/fs.c b/fs/fs.c
> @@ -261,6 +261,9 @@ static struct fstype_info fstypes[] = {
> +#if !IS_ENABLED(CONFIG_XPL_BUILD)
> +             .caps = FS_CAP_DATE,
> +#endif

At this point in the series ext4fs_readdir() still does:

    rtc_to_tm(fdiro.inode.mtime, &dent->change_time);

Without le32_to_cpu(), this patch prints garbage dates on big-endian
machines until patch 4. It might be worth moving le32_to_cpu() fix
into this patch, or into one before it, so that the data is correct
before it is shown?

In any case:

Reviewed-by: Simon Glass <sjg@chromium.org>

Regards,
Simon

