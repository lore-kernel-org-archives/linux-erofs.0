Return-Path: <linux-erofs+bounces-4718-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B5110CC6B09
	for <linux-erofs@archiver.kernel.org>; Tue, 13 Oct 2026 03:32:19 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4j3fz61wQrz30VX;
	Tue, 13 Oct 2026 14:32:18 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=pass smtp.remote-ip="2a00:1450:4864:20::536" arc.chain=google.com
ARC-Seal: i=2; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1791862338;
	cv=pass; b=KuWSdvOemo4jdThww2HTV3uKTHjyEEnKxq7OVfO+uc8PltJQCFawKT8Hius0htXTyFEOWzj4yF0tyAeja7gkUwcptj0kJEWEZ92VOjPnlq3qLBh4+HGQNPiwVmtTtsBM1qvHJP0LQESx7KZnPGW7q+7fYz7geNddlu+qP7x7D7nmUc+8tl7DyL30N8RnohVpA43J3qBXpd+njuGmus8i1vjbnG/XRuknbJpdXKJ9i9NWYaK+p+U/3TJ2LoriP+vx9Dak6wnJtY7qTGrsjux9WV25HEh794wtsjYAtmeZlrnI6X8l6gtpqIekdLb9nYwxFHGzjOW/+OBImHircA3MNA==
ARC-Message-Signature: i=2; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1791862338; c=relaxed/relaxed;
	bh=2KQDHCfiTa5yOkgSKwvOiFHnzolwRmM2y44yFsjU8To=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=JPlB5OXs6yiQIF/8Tu7jibZyO9q3kixpZTW0aCXyPeqdSTS/fmkbKX4XZTom7s86BII2IyrR5m1ssH3VHOzYd3ThIkvcL8Z8G7ca71griQFglZ+xgOGtpJwJ+vt5Crcfdw1R5Gar/VJZmBXK/ZGc81vCF7mwIeIwWUN4BsrU7GeZ3XRZHKL43nTyFHVvURohYmNglHBwqulfek0ZZTVnp3HrkTyfLQQOdBH6yzyW+zgzSMSR1vX0SGpFPDlNISzTXn68FETSSwuxVWBgE1qAFLPGFTSlrq/AzDspYcJGAnwXFv2koD0s+9IGScXHQQpd9EuzmxrZp+fitwCgPSgFbg==
ARC-Authentication-Results: i=2; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=chromium.org; dkim=pass (1024-bit key; unprotected) header.d=chromium.org header.i=@chromium.org header.a=rsa-sha256 header.s=google header.b=QHsUu8o3; dkim-atps=neutral; spf=pass (client-ip=2a00:1450:4864:20::536; helo=mail-ed1-x536.google.com; envelope-from=sjg@chromium.org; receiver=lists.ozlabs.org) smtp.mailfrom=chromium.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=chromium.org header.i=@chromium.org header.a=rsa-sha256 header.s=google header.b=QHsUu8o3;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=chromium.org (client-ip=2a00:1450:4864:20::536; helo=mail-ed1-x536.google.com; envelope-from=sjg@chromium.org; receiver=lists.ozlabs.org)
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4j3fz51nqPz30VV
	for <linux-erofs@lists.ozlabs.org>; Tue, 13 Oct 2026 14:32:17 +1100 (AEDT)
Received: by mail-ed1-x536.google.com with SMTP id 4fb4d7f45d1cf-6a642495d81so3251861a12.2
        for <linux-erofs@lists.ozlabs.org>; Mon, 12 Oct 2026 20:32:17 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1791862334; cv=none;
        d=google.com; s=arc-20260327;
        b=JFWcY+waRjim/Xu/UaAhYSGYbpOdQQvuWhBTPf9ATkV0z57SUvb2y72zJ81V/SN0z+
         rnOaoqEHlbeewMxEfNi4BIv8MjwdwsgSzkt6WjnC6c4ZsCn5OR+SLc9+1hlR+ouYQBZG
         uSFDr618yvTOPymbnvpn4+5Xud0pRX7jZ2NazmOiUEO/jf5YV/S/oJP/wprZAuJy8s0x
         OL6htw3c3KWlZ5GuO523DV19ofY3Ra3Dx3jRAwT+RjMNra/aqj3wlISc7XYW3w4+f2LS
         Um8G48ESil6NT2btI5hIg2prHDSOWJZkFSvpVSJPBR+jVwgGMNFBHttEc74raHuPoqaI
         o87w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=2KQDHCfiTa5yOkgSKwvOiFHnzolwRmM2y44yFsjU8To=;
        fh=mpROjzr5hqyagr6Zzx7o5H3UfvxTBbo8noE6R7BhTPI=;
        b=iG/KbKCvoTZe0gZuLoI5Qdgx0zywZUxzXhyO+XhUgffaQZFjT9k9YYDmu0gpvbZ9Rs
         WX55BNGQ36gefp2T15KQGgoqZfZGDUlG3j6hdNkdfWMZHnnuCdu9w7DToCYQPKD0aZqQ
         xkLTDz9qLtnWcBkqNv4vw+E2IGIa7WwcTSjziNCNvPgls2KDr2k0UAp3HwnqjLT4l66h
         2sGbhSkKRW+mAHMSQIYT4aN+dVEppZj8x8hL3tLO1UyXIIVaDAZqc4hn5qbtrTSG4kGG
         5mqlPcErds55QUf0zHR7wvQk9ukpjr3Li3A3h2eUnVm3R8Gjmex6XRRLw6ol4CW84mBJ
         hSkQ==;
        darn=lists.ozlabs.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1791862334; x=1792467134; darn=lists.ozlabs.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=2KQDHCfiTa5yOkgSKwvOiFHnzolwRmM2y44yFsjU8To=;
        b=QHsUu8o38UBguvutWwP/IG7aDEQlope5tUG8GupaJQoB1dkSr1KAAsEQM3a2HVPAvx
         iG6toQ8z/8B7qBmuE0RU8qOv6ImPH0pATKB4wYxT14rfC05+C8XdrJ5VFGzj9q0uy1su
         l9UbSVytDr0qSpZLRAidl/aDfBoJy9wZGl31Q=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791862334; x=1792467134;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=2KQDHCfiTa5yOkgSKwvOiFHnzolwRmM2y44yFsjU8To=;
        b=kN6S+eQ20b3y1abBr2T8h7Tn9gbxwoHDEXp5a5dl0pTpwQXTs00Ap3uY3jk0/ff7Pp
         o52N6y1OLH/vyxhtCImQJwM5HSfGUlnS90VbKRz3t+i1OS1Nkc5+Xoa4U8hAiRM9bnD3
         lDgHW2CitlUuV+D0MTBdBOSpHIDJ68VEzPjvUGfuxaWUMvHDqd9qVjCE1a1xa+VC+0L0
         vAgxllxRhiuWL5QIj3fBDuqzpsmeR/SfPjPe/y5+udSEJZ56E+1NM/fz7SO9NCty0c2I
         aTy/UnkkWsY2I3s8jYlYW8pQVFKsYlDYEn03fuvogBzzz4ZvwQVlQjUt//3aCO0E74tw
         ypcw==
X-Forwarded-Encrypted: i=1; AKwUvBxnBEAjDDcxu3a2Nnx9jeVb2v8w2T/OdX15l6Xk5o14YblcF6up2Mvq0en7vpS8tnTdpDEVKqhRlwW6zA==@lists.ozlabs.org
X-Gm-Message-State: AFq9FYJmaSYQu1B7xUx0G5Jy0dJ37wBXm/guvXUM+Hvi6fEEZWSlNR7w
	dEHHzvoCVhljLVgptFbdBoFyrhhWakSyvaB/M9LfsZ6fCgbAgUfOw2BktI+JsdWv1knNhbz7qEk
	I/eEbasTtS2/sMgm00LjOOaNcOB5pfiATlCWYOgKG
X-Gm-Gg: AYBFou1ItmiHRJwZp90ojvycGC1a0sgOCixkmpvdBHav5QpYZLRCUWakAR24m5s6cAT
	ubOY0H+edRU0GsdRFv3O1iMc0TKY+fZBzwgHcFk7PbTqS0gWGAaLnGBS4vdZoKa4XFIFKag6m8n
	YtA36cWimgapgjvK2zRfkhr6EeMDRpaQoI1DrxsZiqiNEnBSlFbF43sNzZlZLrSuYM7vpifQGxb
	rPjWTJvBUQSvj5xUlc+5xtYZch5+mkge/5W4KONMgnYNLjpKUvTGADLfC2GvNQl8qbTpx28aR2s
	Q94i4iVzj67N5tObu0A1hE9rG4ACQXXsWxR9Otmm7oZajlTHuvsH//N3
X-Received: by 2002:a05:6402:f0c:b0:6b1:b176:73a9 with SMTP id
 4fb4d7f45d1cf-6b1b1767781mr2921849a12.27.1791862334113; Mon, 12 Oct 2026
 20:32:14 -0700 (PDT)
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
References: <20261012140048.214059-1-heinrich.schuchardt@canonical.com> <20261012140048.214059-8-heinrich.schuchardt@canonical.com>
In-Reply-To: <20261012140048.214059-8-heinrich.schuchardt@canonical.com>
From: Simon Glass <sjg@chromium.org>
Date: Tue, 13 Oct 2026 04:31:24 +0100
X-Gm-Features: AclHuK93UsWnw4l4HsOSneU_57XzcJX_zrn3nf-lZKVCFlaWuIPVVyBuQKXXI5c
Message-ID: <CAFLszTij68+3FG0yp905MeNAio-MZYGdRt0aYzrP43vwX1BYSQ@mail.gmail.com>
Subject: Re: [PATCH 7/9] test: fs: allow optional date field in ls output assertion
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
> test: fs: allow optional date field in ls output assertion
>
> fs_ls_generic() now prints a date between the file size and filename
> when the filesystem sets FS_CAP_DATE (currently FAT and ext4).  The
> two regex patterns in test_fs1 used ' *' (zero or more spaces) to
> match whitespace between the size and filename; this no longer matches
> when a date is present.
>
> Change ' *' to ' .*' so the pattern matches both the old format
> (size + spaces + name) and the new format (size + spaces + date + name).
>
> Signed-off-by: Heinrich Schuchardt <heinrich.schuchardt@canonical.com>
>
> test/py/tests/test_fs/test_basic.py | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

> diff --git a/test/py/tests/test_fs/test_basic.py b/test/py/tests/test_fs/test_basic.py
> @@ -26,8 +26,8 @@ class TestFsBasic(object):
> -            assert(re.search('2621440000 *%s' % BIG_FILE, ''.join(output)))
> -            assert(re.search('1048576 *%s' % SMALL_FILE, ''.join(output)))
> +            assert(re.search('2621440000 .*%s' % BIG_FILE, ''.join(output)))
> +            assert(re.search('1048576 .*%s' % SMALL_FILE, ''.join(output)))

The subject says 'optional date field', but ' .*' accepts anything
between the size and the name. A broken date would still pass, e.g. an
off-by-one month or a year-1900 bug, both easy to hit with struct
rtc_time. Since you are touching this line, the test could also check
the date's format, e.g. (as a raw string):

    '2621440000 +(\d{4}-\d\d-\d\d \d\d:\d\d +)?%s'

This keeps both formats working. What do you think?

Regards,
Simon

