Return-Path: <linux-erofs+bounces-2673-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 404D91125839
	for <linux-erofs@archiver.kernel.org>; Wed, 11 Mar 2026 14:14:07 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4fWCRK3cWlz30hP;
	Thu, 12 Mar 2026 01:14:05 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=209.85.218.45
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1773238445;
	cv=none; b=QoFxO6Hk9bkdO9OEBFlqdvY9rk/QkHlpYs1nwZJKHbm8ECeFD+eo5kOs3mjmK3/xfxCY+eUhwfxGmDGBAAWq2PV6/OarGXzZw96Su72zyfLmrmgNpZdYVUZVxIdko9z2H6HoolXJ/H4WjPrZYDDlefr5DkCgl1h0vbL1KOmUgBT0Zjog4HIcjVkMkQFzQZQCqaBZ3KZcQ3cbM7Y7tbLOsXnJhut9B1iYYrYzGSnVEH8Ne/L/NLO2ZoNQ9JUF3mnlnD/wqHwiuKNDYAyd4E4ylzHdnO/XxOmoHP4HAe/OQYs1wzB5PAD/dz94IVA6T4xDdr9IrzBxctAp7t958mMcHw==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1773238445; c=relaxed/relaxed;
	bh=wIz9Fr5w5J45ZN4rxwvT/0kjXMGfLP1VpB2aKPOax7k=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=nWN3+qttfNSBh6qZqht4wBuIcidel7wZcb2yZ9xj2tE4rtpN7DWgEONTI6Iu3xzELdPTZS+AXzZ62dXGQK/4eBIqkhxq3VdIKJqTU+oxZOXpGC+ew0URtTS/EpEQENTBMdlD3AJ8f4urYdmqW0UkK68xPua45fJ/HJ+V8YipRZzfzmsxa02sUF2BAri//VFY6lCanHsAagcMzoUUVvrm/Fec95PH7qD1evxe+/NBgcZM+9Xzej+xIqXaokgw9PAztysCoS7qC1JB5PZctyYCOlTa/Cjydt92OR5bCoSzRRo5/aq3U3HBWmgXBCnurYDLWMxE5KaccViAkWTnb7tnTg==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org; spf=pass (client-ip=209.85.218.45; helo=mail-ej1-f45.google.com; envelope-from=geert.uytterhoeven@gmail.com; receiver=lists.ozlabs.org) smtp.mailfrom=gmail.com
Authentication-Results: lists.ozlabs.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=gmail.com (client-ip=209.85.218.45; helo=mail-ej1-f45.google.com; envelope-from=geert.uytterhoeven@gmail.com; receiver=lists.ozlabs.org)
Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4fWCRJ2y41z303F
	for <linux-erofs@lists.ozlabs.org>; Thu, 12 Mar 2026 01:14:03 +1100 (AEDT)
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-b942b36de08so190809966b.1
        for <linux-erofs@lists.ozlabs.org>; Wed, 11 Mar 2026 07:14:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773238440; x=1773843240;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wIz9Fr5w5J45ZN4rxwvT/0kjXMGfLP1VpB2aKPOax7k=;
        b=kBercJHTyVcZhvHBtORZFmTSryDrRlR2KbEh3SZNgwYWlzlSnCnhbdkzc0qFyGcEJ7
         uzzcm88BEkO8fp3SOi8+P8qFUB08n285rsI4vYZsE51+UDMtG5/FEAVmJYQXWiu/1lSB
         qk+3bw+VuGO+sSU6m8fIVxUUcY84Ew9b1WZR4fbfNDIyUoLutydnBpS3O5lDb76Yn5jI
         2kC87p5uyivGpyw2YXk25uJMEMwOQFI+/RpQDZajsHQAEuph615E4JDEcuJ6h/FT8ce+
         9aqVCA6FM/2sAG3zwhBYsVWt3yA7GHjjjME/WSC5Z8jVUl2ipSfavOAEtmX/l+FHFpNp
         eq2g==
X-Forwarded-Encrypted: i=1; AJvYcCVo1HNEYuknS0LjLuhxGwgzU4Qi+e28VAr++EwrqkrcsF20o24yiVFnR/6A/Bcvgir+mSl4UTYt/bdaPQ==@lists.ozlabs.org
X-Gm-Message-State: AOJu0YzWF6e2rVis3A1hXVF17ZLJWjOgMLabp61CvXIAwCfPDZyyNoRd
	BIac0hyEl3t87Bm7oUVOyqmpMtbSHQ9qEXdc/yqR/nWA05BD/K8WNRNzHFI+lEWeERKuKQ==
X-Gm-Gg: ATEYQzycZPjcmuvfy8Aa+rCfdHZXNUU5HgAwMB8/QRO5FdjqFu84JxaleFLFXI8SMzg
	RmtJY24No/7yPYdnkaKiKmiSxu5z2ENTyODhrEgqCuPDksaN9Z6qMHuEoIHg09WBqNGQauQ38Pq
	8NMjaMQWHWzmhSmJwpmYtmwAjGBDFMVyCB87wICO17FAuG7bWa1HgG8z442PIrFPnpSuZqf9/K9
	7TebnBOgKsaJr6C8mE0KesOp3WrtWX+ZqTxyWrJw9DV8YHitNg5et5VXBVbzfoSeNDHct62qXZM
	PYxUd2yy6vhY5a4rWB17gX6uKI/Z/oIY5sWFx57yUbP5A+PdaHKwEn5Ztsh7OqAcgJQqFAkHOnJ
	jVLH9rktuu6oZpued/aHvl4J06UN/2zR47+78nP+KyGCyDOpd3wcxs2e/+uBtdMWlsoO4+oLHo3
	jPFbpJEfyM7Mpu1q6ISZxzSxhJfkIAPewdZUbNNhoHoWNqlC3uXJjpi3lJ27fVQm+2EIq+owo=
X-Received: by 2002:a17:907:72cd:b0:b96:e79f:194c with SMTP id a640c23a62f3a-b9711abc998mr445653166b.31.1773238440297;
        Wed, 11 Mar 2026 07:14:00 -0700 (PDT)
Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com. [209.85.218.43])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b972ddfde7dsm59175666b.8.2026.03.11.07.13.59
        for <linux-erofs@lists.ozlabs.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 Mar 2026 07:13:59 -0700 (PDT)
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-b96dc65b886so180283366b.0
        for <linux-erofs@lists.ozlabs.org>; Wed, 11 Mar 2026 07:13:59 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCWJmyYTzhJeu49AN06/B6eSWuCHjVRXQhrTK+OmBACnrXIe2R4OuI2czSubmK+mFe2hzIXwpKto2gUpoA==@lists.ozlabs.org
X-Received: by 2002:a17:907:6d16:b0:b88:4f25:81da with SMTP id
 a640c23a62f3a-b97113ff0b9mr462021166b.0.1773237981235; Wed, 11 Mar 2026
 07:06:21 -0700 (PDT)
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
References: <20260310-b4-is_err_or_null-v1-0-bd63b656022d@avm.de>
 <20260310-b4-is_err_or_null-v1-15-bd63b656022d@avm.de> <20260310100750.303af303@gandalf.local.home>
 <20260311141332.b611237d36b61b2409e66cb3@kernel.org> <20260311100332.6a2ce4b1@gandalf.local.home>
In-Reply-To: <20260311100332.6a2ce4b1@gandalf.local.home>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Wed, 11 Mar 2026 15:06:07 +0100
X-Gmail-Original-Message-ID: <CAMuHMdX4kRGLaKMzPuhS1Pmxh609eiqQW-cAS_jWBBbt-vE6SA@mail.gmail.com>
X-Gm-Features: AaiRm53WEGMMLW4z34e7P-lM1qFvsCJGZ_o4JNL5NPWbhJPKmcqz6k9bJcyL--8
Message-ID: <CAMuHMdX4kRGLaKMzPuhS1Pmxh609eiqQW-cAS_jWBBbt-vE6SA@mail.gmail.com>
Subject: Re: [PATCH 15/61] trace: Prefer IS_ERR_OR_NULL over manual NULL check
To: Steven Rostedt <rostedt@goodmis.org>
Cc: "Masami Hiramatsu (Google)" <mhiramat@kernel.org>, Philipp Hahn <phahn-oss@avm.de>, amd-gfx@lists.freedesktop.org, 
	apparmor@lists.ubuntu.com, bpf@vger.kernel.org, ceph-devel@vger.kernel.org, 
	cocci@inria.fr, dm-devel@lists.linux.dev, dri-devel@lists.freedesktop.org, 
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
	v9fs@lists.linux.dev, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Content-Type: text/plain; charset="UTF-8"

Hi Steven,

On Wed, 11 Mar 2026 at 15:03, Steven Rostedt <rostedt@goodmis.org> wrote:
> On Wed, 11 Mar 2026 14:13:32 +0900
> Masami Hiramatsu (Google) <mhiramat@kernel.org> wrote:
>
> > Hmm, now IS_ERR_OR_NULL() is an inline function, so it is safe.
> > But if you want to use IS_ERR_OR_NULL() here, it will be better something like
> >
> > node = rhashtable_walk_next(&iter);
> > while (!IS_ERR_OR_NULL(node)) {
> >       fprobe_remove_node_in_module(mod, node, &alist);
> >       node = rhashtable_walk_next(&iter);
> > }
>
> But now you need to have a duplicate code in order to acquire "node"
>
> I think the patch just makes the code worse.

Obviously we need a new for_each_*() helper hiding all the gory internals?

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds

