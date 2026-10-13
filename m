Return-Path: <linux-erofs+bounces-4721-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E21BFCC6B03
	for <linux-erofs@archiver.kernel.org>; Tue, 13 Oct 2026 03:37:10 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4j3g4j2tV8z3bps;
	Tue, 13 Oct 2026 14:37:09 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=pass smtp.remote-ip="2a00:1450:4864:20::532" arc.chain=google.com
ARC-Seal: i=2; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1791862629;
	cv=pass; b=WRkQEVBcAIOY938sPTbxxV+6KxLV10x526KuJaaPtzG8rgOLqCZfEDE7ceWvZl3rDr0VjJl/tJrBgdLsVFOl1BwWh751bfhBhfJxXsC9QccpQBTxOv34SKn6THSnQ1ZAOoCvnJ6v1OIr3AM5olBZ8aPJ49lxroxc7TlhVvD9twUTxaUQTjjYlV0MTnHhssnSOPWTCJLcoVkPNqrk20W/o3jZYoqYYEoySapZxXkVAZ18ZIsD5s/C2MxqW1S665akoLLlG+F0tR3p4731M5asZAoAPf9+y+9vnG6FpC2cBFHM8HJyHSvz/igyl+ovIre5kDE7IZ5H8w1tZozpq+It/g==
ARC-Message-Signature: i=2; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1791862629; c=relaxed/relaxed;
	bh=X3GG+uYhO4nEzSGQNAQJBdjtvebhRgodGTCjdtZrloI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=fXDD5M7+6bGUiBPZ/l/VFSpSHObgQrvONodstkFn8ToHTAEGF+x4KDqqyHDZd72IN/xi0EWtinEBhpb2nJqzCAtP5yLEdoyB7PZvIeEnqdNBfRELFx9FyIAGK3UJxXsxeeLaPJ5urzxIs/nfq5tX3v5YRZymDa+ZENTc3O3fbdhBap2SW3fsLV2ujHgNMLI6uIQ0TVzbZc0ckLmHuHlAdZI34jtdyXcOqYwxqGJ3IjIqWe5PvzUMU1NFpAZKwEG42+5ivL5MQWa4tDeUvVUNsJ0J4XAuIItC1ihSj62EqTuGB/7k9kmvSmyojhjZq8N1qXKFujfrSvFGw+hTnBpRMw==
ARC-Authentication-Results: i=2; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=chromium.org; dkim=pass (1024-bit key; unprotected) header.d=chromium.org header.i=@chromium.org header.a=rsa-sha256 header.s=google header.b=ipFSGirw; dkim-atps=neutral; spf=pass (client-ip=2a00:1450:4864:20::532; helo=mail-ed1-x532.google.com; envelope-from=sjg@chromium.org; receiver=lists.ozlabs.org) smtp.mailfrom=chromium.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=chromium.org header.i=@chromium.org header.a=rsa-sha256 header.s=google header.b=ipFSGirw;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=chromium.org (client-ip=2a00:1450:4864:20::532; helo=mail-ed1-x532.google.com; envelope-from=sjg@chromium.org; receiver=lists.ozlabs.org)
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4j3g4h2prkz30VV
	for <linux-erofs@lists.ozlabs.org>; Tue, 13 Oct 2026 14:37:08 +1100 (AEDT)
Received: by mail-ed1-x532.google.com with SMTP id 4fb4d7f45d1cf-6b1f4d8e09aso48772a12.1
        for <linux-erofs@lists.ozlabs.org>; Mon, 12 Oct 2026 20:37:08 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1791862625; cv=none;
        d=google.com; s=arc-20260327;
        b=K0s321uKSPFBnqhEIWZ4If4D0/ntQGBMlOG0qAJziJBCCCoKSbzV7jzqmBxawjU5o5
         ck9b/qYh1AVvOXAYnImfHqlN5eQrRDSiuGl67G5vrE6O1Ofr23GK801EKKelCMd/aciA
         dVa99MY1hogON34XeAv+uMVc4kSKuuj3EVckv150xPTtmDC+gcWf+lZVitzzCQSrLeF+
         NkHEu0pVNWOujK2qf8SJOtj7qxjFbqVgqYEgkE7Zbg6YS82ylFEcmMltRTMRAM3ZVY5Q
         892hOJGeg6EG7rL6fJhSyaOEeyqo2AwKZio9ZaPdiXKZE2zTT7nMsJX7ETj3WRpLh2Ez
         HCdQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=X3GG+uYhO4nEzSGQNAQJBdjtvebhRgodGTCjdtZrloI=;
        fh=MLn3ic09lXz7C4qfYJZK+Ts+dhCjX5y/Nsb1W3bDRtA=;
        b=O83u9HWStRxpdwFD7S8N1yGnL9xnV2ow0/RsqERp6ZQJ8wx9bVOTb2piWh94Wh3Svk
         79aRdsXJV01g3RFLgwLseOLGluYJD5axaER8rVs3uP9El6M2IEylkF2gMPZIu6hr5R5/
         fQ7b6gASYyzf2QXhzrJC3vlaXcElaV7MWEfXtvPmCDdXqS2nwpTMsSgl9UY2KiMIMd3w
         5dMisWBnCHVccdQWoTs6LwE1JquD2Gx7556AwJgFfCqEQr49/RK7jBVNTXu3OQ5pWQqF
         c0Ry4md6VyEsVrQZIeYYCbK16+4Jqwx56rq/pU7mF4gEGZhZhDYJYU+1pr2I6+Z3AC2G
         a0Bg==;
        darn=lists.ozlabs.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1791862625; x=1792467425; darn=lists.ozlabs.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=X3GG+uYhO4nEzSGQNAQJBdjtvebhRgodGTCjdtZrloI=;
        b=ipFSGirwkjcbwpVAhSUBfvDk9sLuwkeitASxkDAYAxn0Mj3/Sbo664sfLOzuj1xNRi
         FexJ3mdeqtPw9pDMvy1qJbA9kHNmc5EaWyMJMczkYeO+T2jTDJTfKkxk0hx9AxAD0bgd
         8cgq4JvnfMeOkO+a6Wd4GWJW+mROkC2ofttf8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791862625; x=1792467425;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=X3GG+uYhO4nEzSGQNAQJBdjtvebhRgodGTCjdtZrloI=;
        b=m8U6JKXZdA3Rx+SQr1HyxOPedJwIFVqXu/nP7CHqfWQQR/BqMcE/2tuLIA0GozndKK
         xU+cAc/37a4uYxxSxRZu4BNk/isM3RuuhYABjHUOy+qbWOT2BKolPSxdYeLzgKP3pi7a
         xlH6KIc8d6ddjsH5mAhC09XgT+f9Gg7dLm1zeRLf1WkHfeKfPQYEH1sZlkQrqttzWKny
         8K9BYd1K6AbdYxQn34GJ8vdmRoxDRVds4S0F8v9jnf92ImPJjBAbCVHqT500PtLTe3lQ
         HBsiwX427Z933Ps/MQo9+e18C3aFOG4LwWBCnWY80LCyd7/xF8MlTBbc453Li1lSWEqx
         Dh5A==
X-Forwarded-Encrypted: i=1; AKwUvBwzMRyJRHifKF1jFU2QG92j+XaFSz+kU0+ihxnG05/6G9svOAqnsvdKisnMv++Px1+BGzFLwJ0XSxEZRQ==@lists.ozlabs.org
X-Gm-Message-State: AFq9FYKa7FcCZBV+B7xkwY4pwAyBNrG7Rc5SRzd005NXz5o4UzKMOh4d
	Qqn+1lFVZ4nreWs0oQxpFaDMHvRXxWamfNPZdL3OgZtKlpFVMCHCUHN7fHgMhWcwUwGXzayY21h
	ISr/Jy6iHH88UjFreAMKzwPRiL855uwfAAWWKHr3+
X-Gm-Gg: AYBFou24QocwZQ5Vp6/yGPXfBHUopwKODnIzpR0DT8TBsbzRcDWR1ySZSOg/fKKo464
	z9jRPfrnUPkbF8leQJZF1HsXF5sNck1FvdM1fckmlsFDoOZa6G62zipIYik2ZM3OxKc/8ExbScg
	o88aEIzm6f3sjZuxIEYfqOU4okRBvyQBQOC+SPZF/qAuk6LR3rTYP3hHMc34ixQuuC81/Mmm44K
	Kdb3p2iLpUxRca7JimDud7H4VeZ4ONADgj2Fn44ag3yf5i2CzE7r8ZGbgqxifrfQMN84gjzRgTH
	ekbO+jgdsCmWeo72Twkc5z8preGK9mWP7Esf9AkHJetpWGBbjcNw8uOB
X-Received: by 2002:a05:6402:c522:20b0:6b1:abe7:825c with SMTP id
 4fb4d7f45d1cf-6b1abe7834bmr3415593a12.8.1791862625230; Mon, 12 Oct 2026
 20:37:05 -0700 (PDT)
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
References: <20261012140048.214059-1-heinrich.schuchardt@canonical.com> <20261012140048.214059-10-heinrich.schuchardt@canonical.com>
In-Reply-To: <20261012140048.214059-10-heinrich.schuchardt@canonical.com>
From: Simon Glass <sjg@chromium.org>
Date: Tue, 13 Oct 2026 04:36:49 +0100
X-Gm-Features: AclHuK99AxcR0B1aScRxiT6aFvpeO-qx10XUUW3g28qxq8QcOHLfMbNoi2UR99Q
Message-ID: <CAFLszThhOee8bQav3hyeyCL+mhNz+bC_+Yb9pOvKSea3rrF9eQ@mail.gmail.com>
Subject: Re: [PATCH 9/9] test: test_erofs: adjust expected ls output
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
> test: test_erofs: adjust expected ls output
>
> With the addition of the date field the space between columns in the ls
> output has been reduced. Reflect this in the expected lines of the erofs
> test.

erofs never prints a date, so the date field is not what changes this
output. Patch 2 changes the separator after the size and '<SYM>' from
three spaces to one for every filesystem that uses fs_ls_generic(),
whether or not FS_CAP_DATE is set. Please can you reword this to say
that?

> diff --git a/test/py/tests/test_fs/test_erofs.py b/test/py/tests/test_fs/test_erofs.py
> @@ -65,8 +65,8 @@ def erofs_ls_at_root(ubman):
> -    expected_lines = ['./', '../', '4096   f4096', '7812   f7812', 'subdir/',
> -                      '<SYM>   symdir', '<SYM>   symfile', '4 file(s), 3 dir(s)']
> +    expected_lines = ['./', '../', '4096 f4096', '7812 f7812', 'subdir/',
> +                      '<SYM> symdir', '<SYM> symfile', '4 file(s), 3 dir(s)']

squashfs needs the same fix. sqfsls also uses fs_ls_generic() and
CONFIG_CMD_SQUASHFS is enabled in sandbox_defconfig. Can you check
that test_sqfs_ls() passes with this series applied?

>
> Signed-off-by: Heinrich Schuchardt <heinrich.schuchardt@canonical.com>
>
> test/py/tests/test_fs/test_erofs.py | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)

Regards,
Simon

