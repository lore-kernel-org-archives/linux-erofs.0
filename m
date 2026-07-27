Return-Path: <linux-erofs+bounces-4012-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2B3C6C53219
	for <linux-erofs@archiver.kernel.org>; Mon, 27 Jul 2026 10:31:15 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4h7vyT5yYRz2ygn;
	Mon, 27 Jul 2026 20:31:13 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2a00:1450:4864:20::331"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1785148273;
	cv=none; b=MEnuNFuNxHdkCjd2w5hJ+Wh7l9yYqTmkdShxfYxO43EVApARu5FRP/G9k7dvQ4kL9ktv1O9xkd1zg3nHZSkfWgLcygJzRDx/k2eAFcrZxSGtWouUTj8NGjaNWHM6WqZdP1ZgOgNVJ719I7jgi1+6w9kxw7XfaU60UF6tpMyndficXMFzlMHjwjbJEyGeuyH9JLHnHrbtACHqWZ1zUILh17Kghop53Uz3gSV5dkwbDsMOwGGeZJvVWtVGoqlBVDA0dcUQvLrTMZuzszPjG08p4Ps8JRzjqN25cHJErig4ySGBZfjobbMRnw68yQBu1hIExsYEsG1TBzqzLX8sUOH3yw==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1785148273; c=relaxed/relaxed;
	bh=4+ZEgHulxWHuwHPHorxyrYnvV0LUKlyF4fm6PY9N2wQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kO/+d+zZaAM/hYYkdF/hfg+hxYOag9CAjeqWvbOqeijXC5i/rri+gk1Adqy4aCRvla9jb+HXVDOhzxeEOYoeDXEPaCzvmKXQVOvIKduhGb874nY/mPQhlaTm1kfEHsAxZKBK8C+eumB1ReNml7e2GnZORjahRSnZm1eKsGGYzDmVAeHuHozXDQ7UL/Y0NRQNL7Cd92r8jYdR7CymLjmxTvzzcyqNWYajIjwpuIIl7hMNN8S0rDEcGE+XFaZ8S7KFRbdx29cZfW+1b5H5flNH+mPTjEZ/IUoahK1RCPiTCl8pRvocJRkiR2wGNYNdt6PBBLmeZ+MHJBp9ZqLculEmpQ==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=gmail.com; dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=HQzgrFhK; dkim-atps=neutral; spf=pass (client-ip=2a00:1450:4864:20::331; helo=mail-wm1-x331.google.com; envelope-from=ericcurtin17@gmail.com; receiver=lists.ozlabs.org) smtp.mailfrom=gmail.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=HQzgrFhK;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=gmail.com (client-ip=2a00:1450:4864:20::331; helo=mail-wm1-x331.google.com; envelope-from=ericcurtin17@gmail.com; receiver=lists.ozlabs.org)
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4h7vyS1Y3Vz2xll
	for <linux-erofs@lists.ozlabs.org>; Mon, 27 Jul 2026 20:31:11 +1000 (AEST)
Received: by mail-wm1-x331.google.com with SMTP id 5b1f17b1804b1-495635a85d2so21308845e9.0
        for <linux-erofs@lists.ozlabs.org>; Mon, 27 Jul 2026 03:31:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785148267; x=1785753067; darn=lists.ozlabs.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=4+ZEgHulxWHuwHPHorxyrYnvV0LUKlyF4fm6PY9N2wQ=;
        b=HQzgrFhKlUbJl6Fv/NBOFOC0iirQwC2AMJLO55CO/TKBeIhdEohYJDE/02+a0DW8kg
         8hFGVUi8B+VtCom66B9ngnUXnphR/iitln+N59LsrlevjwqR3WtcfeN6a3X++VFVfXBU
         BOk7IVFXIySh/yIwN5CZ+nX2ljXuNhoCD5ku9pkX1HDFtwwd1dDyiLvK7mLM1Qr1MNnd
         QyCVfWChSOThptkxfv7gVCC6Q5pxmlVMxeLjAn2EFDGS05yF5S+QJ8xUtjB4rbhCs9by
         Aoq5ayWaczlVQx8zO7ZUOQ/SWidXm43YibwbIUNW4jEvTyjcl1p2iZ/XMfXM0mM0SKVR
         DIFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785148267; x=1785753067;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=4+ZEgHulxWHuwHPHorxyrYnvV0LUKlyF4fm6PY9N2wQ=;
        b=IOGzWRYl1rYcTqh5n5mda3bKvxXBSnHI4RgaIqYkwzr+Dua9OUDWfZFQNTfWzBzKqp
         9yA1vrwya+GDUK9sMGSCPGj4Kirr944GAQEUx2CTj8vKA8eEoPXlHq9w2LaTbf68rI+t
         kvzqgHSsLiQNqk1vHyI8UVgQCDIouYAp0yTeTHgrSOizpj2Mquhd/oBZSEXpfAlDYv+v
         3RNRCgAowl+HHW9yGwPwJVQotp1QZkSa1JLQQk2R4ZqZvfk+lSc7dPrI9EqVi+X1Vs61
         wk67fofZuMy7C2LYTcZIS8RvqCBoj2TDSES42OlWkwobkGW2VUwC219fpY92eplcnrFy
         tq2A==
X-Forwarded-Encrypted: i=1; AHgh+RrNZqncRNLMWvLadBosWdD1dn9xcy4tn3nSJa2PjMGVfgMFuU8C3GQiucUxXJSP/zbCtODak2aNXhUXvA==@lists.ozlabs.org
X-Gm-Message-State: AOJu0Yw/FHjjorak3v/wy9IfIFlyFIXGVLLMp9p+/dthVDnDyd9XMqZR
	O+e52qy3yr2tocwRRfgfVHNmtcohi3cMLke0HFTsn1lGDQapiQM5GD/P
X-Gm-Gg: AR+sD11HeOp0QTKnDh2/oVv7/VSZnrcjC2rW8M+NyydrCBbjAn5yxgnJk16iQHe7Hl9
	ap3yYJVowyFrq76LF0KyZQ2lIQcJ2hIeVJqQ7l5Akigbz6eT4ZhJRDIaiLNXSe8upenBX2ZziYo
	mPCP97/49YQ+VqO/Iuen6xnAxJOOVh7vPVRUlaDnjdiXlNYXxdHzttMxZco+T5MCTo12+ZWqdjs
	K2eZIPEjHcoTE+7rsiAOBZTbcZp4BLl2Q6fp7Ms6EPdY4FRUUqdluxwwMRG4J26JDr97mAe3Ela
	Z9bzoHUmKZM3Zr/6UL9Mv7AUnhQJvtODmm3kqF+PtzDAD35FkKtrKCOvveEbr68C4XAvKlnGEI7
	5BdWdDos9LWN/7wZ65I62BDtmyuWMQJuqOrLMb6hnuitTBp9kn05OcHCM+mtsoskE7spcNb2VNK
	gkyY7sjg==
X-Received: by 2002:a05:600c:19c9:b0:492:4a50:41fe with SMTP id 5b1f17b1804b1-496b56ff171mr106409805e9.22.1785148267024;
        Mon, 27 Jul 2026 03:31:07 -0700 (PDT)
Received: from spark.Home ([2001:8a0:7280:4000:53fe:effd:424:fa7e])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-496b49a6e17sm204884765e9.13.2026.07.27.03.31.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jul 2026 03:31:06 -0700 (PDT)
From: Eric Curtin <ericcurtin17@gmail.com>
To: Christian Brauner <brauner@kernel.org>
Cc: Eric Curtin <ericcurtin17@gmail.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Jan Kara <jack@suse.cz>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Eric Biggers <ebiggers@kernel.org>,
	"Theodore Y . Ts'o" <tytso@mit.edu>,
	Gao Xiang <xiang@kernel.org>,
	Chao Yu <chao@kernel.org>,
	fsverity@lists.linux.dev,
	linux-erofs@lists.ozlabs.org,
	linux-fsdevel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 0/2] init: boot image-based systems without an initramfs (rootimage=)
Date: Mon, 27 Jul 2026 11:31:04 +0100
Message-ID: <20260727103104.2531937-1-ericcurtin17@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260727-gepaukt-eislauf-waran-7c03f0e47609@brauner>
References: <20260718191551.1703670-1-ericcurtin17@gmail.com> <20260727-gepaukt-eislauf-waran-7c03f0e47609@brauner>
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
Content-Transfer-Encoding: 8bit

On 2026-07-27 10:55 +0200, Christian Brauner wrote:
> So I have several structual and design issues with this.
[...]
> You're embedding a whole deployment topology into the core code here as
> well... There are _five_ interacting __setup parameters. Every real
> deployment immediately wants a sixth knob: A/B fallback inside the
> mechanism. Because in your current model every failure is a panic().
>
> But that also means image selection must live in the bootloader anyway:
> composefs/overlay stacking, LUKS-encrypted state partitions as command
> lines can't do crypto secrets, fsck of the carrier, directory-based
> deployments yadayadayada.
>
> This is just turning do_mounts.c into policy it shouldn't be involved
> in.

Thanks for the detailed review. Let me state the goal plainly, since I
think it explains the choices even though several of your specific
findings below are real bugs I should just fix rather than defend.

The goal is A/B image updates from a *single* partition, without
paying for a second userspace spin-up at boot.

Today there are basically two ways to do A/B on Linux:

 1. N partitions/dm-verity volumes, each a full root image, selected
    by the bootloader (dm-mod.create= + a GPT attribute flip). This
    is the ChromeOS/Android model. It costs Nx the storage/partition
    budget up front and the slot count is fixed at provisioning time.

 2. A single filesystem holding N image files (what bootc/ostree/
    composefs already do), where something picks which file becomes
    root. Far more space- and slot-count-flexible, but "pick a file
    and expose it as root" is currently dracut/initramfs's job, so
    you pay for a whole extra userspace stage whose only work is the
    five steps in the cover letter.

rootimage= targets (2): keep single-partition flexibility, drop the
"spin up a second userspace just to switch_root" cost. On fast-boot
targets that first userspace (loading dracut/busybox, forking,
possibly loading modules) isn't free and is pure overhead for five
mechanical steps.

To be clear, I'm not trying to relitigate "no bootloader spec in the
kernel" - I agree with that call, and A/B slot selection/fallback
bookkeeping is meant to stay in the bootloader, exactly as it does
with dm-mod.create= today. rootimage= is only meant to do the same
mechanical "resolve the one path the bootloader already chose, verify
it, make it root" step dm-mod.create() does for partitions - just for
the file-backed case, where there's no dm table to describe it. So
the "sixth knob" is intentionally out of scope; where you're right is
that I haven't specified what happens when this step fails (currently
panic()), and that needs a real answer, not "bootloader's problem".

On the rest, these read like real bugs, not disagreements, and I'd
rather fix them than defend the current code:

 - filp_open()/fput() unused, and no guaranteed relationship between
   the fsverity-checked file and the path/inode init_mount() and
   erofs's own filp_open(fc->source) resolve independently - agreed,
   this needs a real "mount from an already-open fd" path.
 - multi-device erofs / rootimageflags=device= meaning the digest
   only covers the primary image - agreed, real gap.
 - the carrier fs being fully parsed, including reading the fsverity
   descriptor itself, before anything is verified - agreed, that
   ordering defeats the point.
 - zombie superblock / dangling source path / no loop-style
   backing-file equivalent after detach - agreed, needs fixing.

I'll rework this into a v2 that only tries to solve the "take an
already-resolved, already-open file and make it root, verified"
problem, drop the multi-knob framing, and either fix the fd-vs-path
lookup properly or wait for the generic "mount from fd" infra you
mentioned.

Thanks for going through this in such detail.

Eric

