Return-Path: <linux-erofs+bounces-3236-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A76CBE98FDD
	for <linux-erofs@archiver.kernel.org>; Thu,  9 Apr 2026 09:53:17 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4frwH00dB6z2yfs;
	Thu, 09 Apr 2026 19:53:16 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=pass smtp.remote-ip="2a00:1450:4864:20::32b" arc.chain=google.com
ARC-Seal: i=2; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1775728396;
	cv=pass; b=jXK9Vr0mkU+5aQXWWWzXbfSVfxY3QzjXyvhk2taG2l2uCuNMpY38SJCHLFgQN9pizWs3sgnjGBokd9UY4zQ0VIePKXAWqlxm01Qaz0yvAlSD27lrk41cAkiMVaKoQwx50U8egXxeDJWaEOLO4RN/nrRgH7guEtwH3qBufB1tLnzeyEaQb2+9oIM52PpJhKkRCDVTe4QqEUcCtqclHYFXVVA65tN0fGQc+daropzDahaf5T0CfzKetUYAT4NeeIjzM7V0/jY27T+/7oIU9N7QuClY3NzYr6SzfIQSdYyw/9bV5B6bAfqIkS6aclev5bAXWyTks2A5xyenzW2s1zYWcQ==
ARC-Message-Signature: i=2; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1775728396; c=relaxed/relaxed;
	bh=CTPYncyKZolL6jpIdp1XebiQ4K/bzzFgRLqz6dusg0Q=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=iaInGufvkaSitFH+zcUPPNdgB8PqQcX3+TmANABuY/syIrv0KoDGs82kNsfcwUWX6nPuktd0s7cm2iCab5IPnNCRSbzuZoLCX3dKJC2xlb4G00TnBsjv8MZTIXDcms9K6+5/BhiS093mfN1i/Zb0D+Z3Ut1Pn1EAzXHJYX8+tOZBLJqizyMp3eL6cj6RbBiA7TOb//EJGY1D6krwoSVYdxF/UgyP2FIZTzgUutdLgNVfNcI8GeOGvlxITgjkjA3Z6tWCAzV4fcRgd6KWqg/OGowDChm/OxN4bkIijh87EZZQD6DO2jp8ZgCvDX2OJsUez8qUhvkzc+vAeKDO/zlJdg==
ARC-Authentication-Results: i=2; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=gmail.com; dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=VcJksDcC; dkim-atps=neutral; spf=pass (client-ip=2a00:1450:4864:20::32b; helo=mail-wm1-x32b.google.com; envelope-from=newajay.11r@gmail.com; receiver=lists.ozlabs.org) smtp.mailfrom=gmail.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=VcJksDcC;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=gmail.com (client-ip=2a00:1450:4864:20::32b; helo=mail-wm1-x32b.google.com; envelope-from=newajay.11r@gmail.com; receiver=lists.ozlabs.org)
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4frwGx72ZBz2xNT
	for <linux-erofs@lists.ozlabs.org>; Thu, 09 Apr 2026 19:53:12 +1000 (AEST)
Received: by mail-wm1-x32b.google.com with SMTP id 5b1f17b1804b1-488c21c636dso3877225e9.2
        for <linux-erofs@lists.ozlabs.org>; Thu, 09 Apr 2026 02:53:12 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1775728387; cv=none;
        d=google.com; s=arc-20240605;
        b=GTi571hjHMgucWDJu0v6UcUtHiAw5jxp3yrqoQkF26I1rhJeax5Ul4Xh3fmOLetR43
         6MbGPWY5qicXFfNfRZXCgHBK2zuvl/wJlNOsXzszhQFFYn4Kz3Vqz5dYJm673QTAypqq
         +s0fu36Lbuwauv1cRWVUNQjWzEvbwdTn8egROQPTahMSewpJLmaUCZjMLCj7SfQ2fYSD
         YrBmwWpxDOX4NFvOLuGAFx5w4ZLrapnnqYx9pjfkUL1X4ahTzZ4jZMjaaUmM7obJEWQy
         h19jDMzadye0Qga0XUaeqOna7wK6IRVvrU1zKgsOn3lIYbzqzwCJUHomnJ8uxaih0iJJ
         RM0w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=CTPYncyKZolL6jpIdp1XebiQ4K/bzzFgRLqz6dusg0Q=;
        fh=IXUVGgdsPonhrRyfqHPIGZbYkXTk0l2AbSi8dhhBlEk=;
        b=O2o4UfbEbF0mcgYv13kOANZU456Q1r8CAXsQqJEyr/2TQJAX+dRidBtMd1RCzSw1SP
         XN+3dxCGtMu30rJV6BB0Zx/j5WP1caB77L25RnkD5F7BETgUvleacjRajmSPZSHdUhD6
         4zTx3KQiNjYX08RemQGkZjOsWV9YVGwmBvW+nMPB3RUiYWyEpAr5Vr4QFiMr2gA1Wibj
         /uTNYjXy7njt7H2Ro5wiZIZcarXyxQK6cvAr7HrVrUFXoWhw/rD1TTPxZPug0Mx+my9E
         93BfFjEYq8PGbsvcwlBxXs3Ua6W8tNuyMeVWnAo+ZAuQPbW1Smr0a0QipNdUvIr1bSkb
         WsSw==;
        darn=lists.ozlabs.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775728387; x=1776333187; darn=lists.ozlabs.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=CTPYncyKZolL6jpIdp1XebiQ4K/bzzFgRLqz6dusg0Q=;
        b=VcJksDcC0liURpdAeA+na3Ckso2/7d6PAt9cRVwoTAS924PQApRV8tSyLkWztQMHHB
         MDSq0HfCEgMEwgg08J+Po6tD1GzxQTGtTCz/PBBZ6ZpANEQi8/Swmc5sqSColpEXAFyX
         qKGsaV7p3e2+7e78Ot2z4C9Ttg2bmttOy2yVz+STE0kzQE6SIa0Cy50JwM08QQBH2dSS
         nCWL/OjkXdm0bQ6GBFdGysfAMYyc0snL6FnolgLEd9fpYk2Gv9Maqai+budDLB8R26Lx
         s7wYGYmROc/Wd8I9lD0b2GCEYo2l44QJcx426TUroWBJk6xAPemDHHy584zRfa4NKVMS
         8eSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775728387; x=1776333187;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CTPYncyKZolL6jpIdp1XebiQ4K/bzzFgRLqz6dusg0Q=;
        b=CKg86zkxtziXS7SSF1hnFT11VgajvJgH5HW3M98YdyWC8sGCxtbsD7/FotdNFI9par
         eM3O88i52We1wWk/+3wQpf57uYPGFiqxrJiN0C7H80Iww3FqcUKu3TQj53lRHiwYgomu
         Y3Q59t7e6naFTNjot6rUwo2dg4uhujn32i/nKyW0Emd0l4J1sWSCkQ+i23cyIMNalkf6
         MufOZAJ3BLp8Oqgt/SzR9XokB4QmWgOIVmvfOEsqdU3b3HawP3CgyJVqzyeUbpscROK9
         1O6jLoHQAGKXEIZU5I6qN/LOwGUz2V+0/+zgG5zA2FRi1ozNVHNkGe0G9jOg0K68IO7m
         81RA==
X-Gm-Message-State: AOJu0Yw6gdNgHkYLIR0QDuSbf6oebqVjCOX4CcFb4l7FOzLrmbDoWbKD
	EKRKBywW6V2qR2VF+OTTQr9l5bzmsBa6WPD+jgBUqL5ezoCAL/hh8hlmXPHV0Zja8x0H/QPclKP
	xOo0cKlrHpyYhXVSZiha+2+mumkGlQ8E=
X-Gm-Gg: AeBDietIzuNL8C3v+CUc8GquatBjHWhrSgVUnVz29d/RL2nWFw10MfsC9Zi1U37K4dQ
	BnTnl9LPN0ZTKkQZN2v7P2KFI8ufRAFfEOC6KpG59w8p3Nl9qlM19aZM2eEdP9zlsiuAPWBA8+r
	6hSRRt9cwxmkgSYdSvn5c0g52ihgpdDDBnd81n7h5dPOA7GyVMsSDM5YNwIHH5N/DAllNJgVjNi
	HVglvzyp7dfo5+RnCS8633wKwNvpzs/xHp0xzFQD/jzybbJErZc0Pj80bJxetvM+ne+A1vtNHQd
	lyaAsVQGibqP/JdGMn3vsUENB/GmJrwkelINxW5tgA==
X-Received: by 2002:a05:600c:3b99:b0:485:4453:401d with SMTP id
 5b1f17b1804b1-488996b0125mr357086025e9.2.1775728387374; Thu, 09 Apr 2026
 02:53:07 -0700 (PDT)
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
References: <20260409084834.147-1-newajay.11r@gmail.com> <20260409090713.51262-1-nithurshen.dev@gmail.com>
In-Reply-To: <20260409090713.51262-1-nithurshen.dev@gmail.com>
From: Ajay Rajera <newajay.11r@gmail.com>
Date: Thu, 9 Apr 2026 15:22:53 +0530
X-Gm-Features: AQROBzDVYGZhHe84s3xM631-BkBygeQlyB-sYpNv9KggloFPUiwqoIzbiPjUU9s
Message-ID: <CAMhhD9hyDgkHEFA-Bt8WSa0S8kc83EEbsQr47zOV-vE3MrZqfA@mail.gmail.com>
Subject: Re: [PATCH] erofs-utils: support --blobdev with block map
To: Nithurshen <nithurshen.dev@gmail.com>
Cc: linux-erofs@lists.ozlabs.org
Content-Type: text/plain; charset="UTF-8"

I apologize, I didn't know about it.

Thanks,
Ajay

On Thu, 9 Apr 2026 at 14:37, Nithurshen <nithurshen.dev@gmail.com> wrote:
>
> Hi Ajay,
>
> Thanks for looking into this, but this patch is redundant. I already
> addressed this exact TODO item last month.
>
> My initial patch was sent on March 7th. After discussing the
> implementation with the maintainers, specifically addressing Yifan
> Zhao's feedback regarding the 32-bit address limits for block map
> entries and the necessary fix to reset m_deviceid in erofs_map_dev(),
> I submitted a finalized v2 on March 9th.
>
> Additionally, following Gao Xiang's guidance, I have already written
> and submitted the corresponding test case to theexperimental-tests
> branch as of March 19th.
>
> I strongly suggest checking the recent mailing list archives or the
> pending patch queue before picking up a TODO item to avoid stepping
> on ongoing work and duplicating effort.
>
> Regards,
> Nithurshen

