Return-Path: <linux-erofs+bounces-2671-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 084D71125806
	for <linux-erofs@archiver.kernel.org>; Wed, 11 Mar 2026 13:22:03 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4fWBHG1kJ8z3cC9;
	Thu, 12 Mar 2026 00:22:02 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=209.85.221.181
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1773235322;
	cv=none; b=BM0SUp5XXBeLLIZ+poXX/LgpuX4w5jCVpQlNkl6EkMnM3BxZpb7adOtT6xcjesKmLLV0Fb32HOb3ry5998uF5KrLmeL0XSzdww1wM1nb2Hc9r1jZRMtrEFDuy0+846Wi5ymTyBiryVxlWWCU5A/JjocHPHhUSLz3v2pHnQxC909Go750Cjku0PDCxWqqzpb9l8eOEF7SUqBts0YiDNF4W67Je3wuwHArqFtJGLBE3P9NG1tGbL968XkKL9KvXWuxrweRQt6sBc6v99pDlBNBcE8RHj793xPzBVu26fR0ZiYhi4SmVC1g2Kx6vhpLfccIPkbon8tARRRwXksj4bTyjQ==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1773235322; c=relaxed/relaxed;
	bh=34DR94e/1PAvLLEaib58vFA4GW0m5SGe6jvxchEhMek=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ZpVXlnJ+zqAOvW+MVVVllUqlKL7O9YlIinVdu9lLkC5ja7DjIsisg+dwqjs8gMFL+bB8MmvRQfUEaXP1Kpj3/HPf34OYV+7lX6mey+30gk88ZtIIFD0v4mvW4LStAqEriPwbUQTSuhYvheTE+GHAV32ZVHEmX0T1W2Y5GK1s9JLgbNlI2AbHSnswBTBxJ7zx+z/Cc2f9Ln3mXClQBFVqkCgdocQXZKsfUtqbN1Zg/vFjFMy1k3APpxAng5prWFTcGxL/X6InXn0DWZvAaO3DQNnDflTaxmIpbFQmTjFAyz3479Pu4g5B4GMaS8hR/Fot8OzkCK2a++KF/ql1MaZL9Q==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org; spf=pass (client-ip=209.85.221.181; helo=mail-vk1-f181.google.com; envelope-from=geert.uytterhoeven@gmail.com; receiver=lists.ozlabs.org) smtp.mailfrom=gmail.com
Authentication-Results: lists.ozlabs.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=gmail.com (client-ip=209.85.221.181; helo=mail-vk1-f181.google.com; envelope-from=geert.uytterhoeven@gmail.com; receiver=lists.ozlabs.org)
Received: from mail-vk1-f181.google.com (mail-vk1-f181.google.com [209.85.221.181])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4fWBHD5ZYTz3cBW
	for <linux-erofs@lists.ozlabs.org>; Thu, 12 Mar 2026 00:22:00 +1100 (AEDT)
Received: by mail-vk1-f181.google.com with SMTP id 71dfb90a1353d-56739adfa1aso10528959e0c.0
        for <linux-erofs@lists.ozlabs.org>; Wed, 11 Mar 2026 06:22:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773235318; x=1773840118;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=34DR94e/1PAvLLEaib58vFA4GW0m5SGe6jvxchEhMek=;
        b=AHErG9BfpAm27uRcOha9I5LhVk2bP99RAKlc2T8QgkXLKuwRMYcMldXgFKsmj82RQ+
         h87RYz1p6YEV/7qp3cn4kA4XV0dvxT5MudovTv0wNFQRaB+ViMMawipQinJaReSjZRdI
         /QSqT7ZZf8BAPzYMF2ZspKn16CnfXX0BQnYBr6/gcEJ2XN9INqMlLfgd1pD/mh6RZsie
         Zg5FmIl146T5X55javHif2a21xuE32rRCOMBbCdZm8LQRDNjEA6n826KVOX6oILfIr7I
         XOCaYTmkefNQc/GoOM9Q5/VaABVZWP//VTzw0mZ6D9/gA8U3zKdYKV3DWIW/x7mUMAhR
         964w==
X-Forwarded-Encrypted: i=1; AJvYcCXkdg/6aC7JQmAE3QTeSgjQb9WfpKvNvlFF/dylWpXZG+pWAj3lqKdYc4AzROaj8HzuHlAEM2O1seUcdQ==@lists.ozlabs.org
X-Gm-Message-State: AOJu0YzS/ISezmId2b1GzIO61q7AU91ONnTEenFGu1fE5clh4HIWPNgE
	5z7U68/Pq4EicEoMDFdHRs32eQWxmr2BAh1KlMJoYURcBF99xL4fCGpK+bOo6fTrm+M=
X-Gm-Gg: ATEYQzwNgcB5lASKFqSDCgKy0Mip4DmdSrvBehqE5NsBhYt40ygEpNkDK4m1Ujzw2lN
	kKggR25WXpq1zpSCaTUoYcAMThv6rjdLSzOJxR5i6cGaARYR+JJIkhRsRC2CYJ5At7Kn+vb2Z6H
	7/S+0uT0g1Xn5EnyTa2X0uN4NOfTAidp+bkpTh7qqmrUdPjjT5/gvXOEFin51HtKbnNqIkqLZyL
	TUZbwAYnFn4F/LYUbtij776FGH65KE7JXAE4+Gss1XN0Cj2+yh39WUi5Jh+E2EeB1a351tEdUUM
	J49o+cZqT+6cMutxDQSFvJre7ICCRz9eWPpkA9ZcwZgmfdu32+53ODLzUHzptbN2LyAnb2ZoTbX
	pWPmOStEN0LuCsoq5dkIOxJeK8W6IIDN6Lw6lGoo+D4LxieBANI+whOT4NYTY/mxYGtZMJdN1EB
	BI8N8amq4hjWtEEgMqwMuwzkuWtHKcv2kes13kdLoXwRV4rVk31cmxM1fRr1be5GkN
X-Received: by 2002:a05:6122:1d05:b0:55b:7494:177b with SMTP id 71dfb90a1353d-56b4752d806mr930725e0c.10.1773235317826;
        Wed, 11 Mar 2026 06:21:57 -0700 (PDT)
Received: from mail-vk1-f175.google.com (mail-vk1-f175.google.com. [209.85.221.175])
        by smtp.gmail.com with ESMTPSA id 71dfb90a1353d-56b464c2924sm927370e0c.19.2026.03.11.06.21.57
        for <linux-erofs@lists.ozlabs.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 Mar 2026 06:21:57 -0700 (PDT)
Received: by mail-vk1-f175.google.com with SMTP id 71dfb90a1353d-56b18f05f49so2423036e0c.1
        for <linux-erofs@lists.ozlabs.org>; Wed, 11 Mar 2026 06:21:57 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCV6gaCP4v+FTpXAL74qGTGtltQhvQj6+Xrb3OnSHJEr2bla7zTWUMIVWZShfGjOsGh2Kafkamm1ixZESQ==@lists.ozlabs.org
X-Received: by 2002:a05:6122:1d05:b0:55b:7494:177b with SMTP id
 71dfb90a1353d-56b4752d806mr922396e0c.10.1773234967338; Wed, 11 Mar 2026
 06:16:07 -0700 (PDT)
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
References: <20260310-b4-is_err_or_null-v1-0-bd63b656022d@avm.de> <20260310-b4-is_err_or_null-v1-36-bd63b656022d@avm.de>
In-Reply-To: <20260310-b4-is_err_or_null-v1-36-bd63b656022d@avm.de>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Wed, 11 Mar 2026 14:15:56 +0100
X-Gmail-Original-Message-ID: <CAMuHMdXQ8Q4jvkgFRJYhghz2BZRDC-9Mk6DbXxuaOc6C9DFHZQ@mail.gmail.com>
X-Gm-Features: AaiRm52J84H77ROK64ZWWtJfaiCpnFeKyoSRmPbi-NC8CN6Ju1TJEFxJU9gZQQ8
Message-ID: <CAMuHMdXQ8Q4jvkgFRJYhghz2BZRDC-9Mk6DbXxuaOc6C9DFHZQ@mail.gmail.com>
Subject: Re: [PATCH 36/61] arch/sh: Prefer IS_ERR_OR_NULL over manual NULL check
To: Philipp Hahn <phahn-oss@avm.de>
Cc: amd-gfx@lists.freedesktop.org, apparmor@lists.ubuntu.com, 
	bpf@vger.kernel.org, ceph-devel@vger.kernel.org, cocci@inria.fr, 
	dm-devel@lists.linux.dev, dri-devel@lists.freedesktop.org, 
	gfs2@lists.linux.dev, intel-gfx@lists.freedesktop.org, 
	intel-wired-lan@lists.osuosl.org, iommu@lists.linux.dev, kvm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-block@vger.kernel.org, 
	linux-bluetooth@vger.kernel.org, linux-btrfs@vger.kernel.org, 
	linux-cifs@vger.kernel.org, linux-clk@vger.kernel.org, 
	linux-erofs@lists.ozlabs.org, linux-ext4@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-gpio@vger.kernel.org, 
	linux-hyperv@vger.kernel.org, linux-input@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-leds@vger.kernel.org, 
	linux-media@vger.kernel.org, linux-mips@vger.kernel.org, linux-mm@kvack.org, 
	linux-modules@vger.kernel.org, linux-mtd@lists.infradead.org, 
	linux-nfs@vger.kernel.org, linux-omap@vger.kernel.org, 
	linux-phy@lists.infradead.org, linux-pm@vger.kernel.org, 
	linux-rockchip@lists.infradead.org, linux-s390@vger.kernel.org, 
	linux-scsi@vger.kernel.org, linux-sctp@vger.kernel.org, 
	linux-security-module@vger.kernel.org, linux-sh@vger.kernel.org, 
	linux-sound@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com, 
	linux-trace-kernel@vger.kernel.org, linux-usb@vger.kernel.org, 
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org, ntfs3@lists.linux.dev, 
	samba-technical@lists.samba.org, sched-ext@lists.linux.dev, 
	target-devel@vger.kernel.org, tipc-discussion@lists.sourceforge.net, 
	v9fs@lists.linux.dev, Yoshinori Sato <ysato@users.sourceforge.jp>, 
	Rich Felker <dalias@libc.org>, John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Content-Type: text/plain; charset="UTF-8"

On Tue, 10 Mar 2026 at 12:56, Philipp Hahn <phahn-oss@avm.de> wrote:
> Prefer using IS_ERR_OR_NULL() over using IS_ERR() and a manual NULL
> check.
>
> Change generated with coccinelle.
>
> To: Yoshinori Sato <ysato@users.sourceforge.jp>
> To: Rich Felker <dalias@libc.org>
> To: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
> Cc: linux-sh@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> Signed-off-by: Philipp Hahn <phahn-oss@avm.de>

Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds

