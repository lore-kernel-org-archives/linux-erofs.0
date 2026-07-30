Return-Path: <linux-erofs+bounces-4052-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8580FC54FD2
	for <linux-erofs@archiver.kernel.org>; Thu, 30 Jul 2026 10:58:20 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4h9mQL71x5z2yhb;
	Thu, 30 Jul 2026 20:58:18 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=172.105.4.254
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1785409098;
	cv=none; b=lfDPd/cMstSec9CHB/dfeLeKo16h3werBk89WH8tSv6SW9Ef6xT0DPo9E0KoLg2RkpsP9cAAjddPvQqpe0dzE9mFXcNzt649bhyvYlcEXyHeuKJhs3DHfWCoyK49Xzfe7hzgAWf0HStkNf/17A0K1DuhmFOoTbN6GK5olxjp0AqF59LnRP0thllogxc4qkrBy3FbVG3EFFHAAkmXYsPC2mT0mcBxJmni2cz965iXjTnzC29rXhmEXYSsBsiL5fcJfiFJd+950bg3PSt5igMGydkYJnToreJIjAG1zwg5D7doFUzH1RVJzSu05SbgQpOoKp3eq/42rl1vUcyWpD29sQ==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1785409098; c=relaxed/relaxed;
	bh=ho4YgyjQWyBPUtevx1zJhBR2CkmhZreF0QpyeyphzFE=;
	h=MIME-Version:Content-Type:Subject:From:To:Cc:In-Reply-To:
	 References:Date:Message-Id; b=jXS+Zm573CNvkvafLz58Kr1BaYlfd6jKG9D8zZFECOXr5sb3ZEd62OHzfhiSP9i6FaR1AK4wUHzKhluGxHVyyDKg/7RxX5gBGbiUAD4WphAVPo0l5pXwVSnL8YUXLgD19QJ1g3UJNBA6ir/8k3VC+PZqDHcmH4MfL2p3+Hm0CgKy2HaTkX4NyFRJ5iloySaCly2Re63SwJa+01Jl4jHXTgqkFyYKwwm9RbeQiwFxIW0+elF3i20aYDnZjZT5V/6mjdeyaLevA9EDCCZr3kQzqSX/1VTku9vXPHiRFT9u86Zx/KBZPuKtGQXeHL63IwTrYmQKeJC8OxAron/9J5I1dA==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=UAX9ljGG; dkim-atps=neutral; spf=pass (client-ip=172.105.4.254; helo=tor.source.kernel.org; envelope-from=brauner@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=UAX9ljGG;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=172.105.4.254; helo=tor.source.kernel.org; envelope-from=brauner@kernel.org; receiver=lists.ozlabs.org)
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4h9mQL0qQJz2yYd
	for <linux-erofs@lists.ozlabs.org>; Thu, 30 Jul 2026 20:58:18 +1000 (AEST)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id ADE54600B0;
	Thu, 30 Jul 2026 10:58:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 621801F000E9;
	Thu, 30 Jul 2026 10:58:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785409095;
	bh=ho4YgyjQWyBPUtevx1zJhBR2CkmhZreF0QpyeyphzFE=;
	h=Subject:From:To:Cc:In-Reply-To:References:Date;
	b=UAX9ljGGbRUS4xetzqrE0PMjPXbJNbJenYDiXH5cGCN/VkCypcrXMCijxjd794cE9
	 fslK+ToUhFiTYo+XgYYKyBh2jytb9MxmQYlrLivJW3iHab5A0j3l81greEEv6bAYFq
	 42xNk8lDButxsz0GTDUTshOJ5lgc7fy+kb/3uhbosCULe6SDNNNIXsBKU9Zx97m+RQ
	 El7k4S7cqLSw4Oh/MP5+kcBo3bZysZee8fXz7LxMYiv1KdYqTQiTMiZdrej+TK7M9J
	 3U6mg/VUT3EPyf2a3nCSvih3L/OIPuqk/wGS5RFiOzn8tqz4jX6L/f5l04BgmQPrFw
	 7ZvQq+Pj1+t5w==
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
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [RFC PATCH v2 0/4] init: boot image-based systems without an
 initramfs (rootimage=)
From: Christian Brauner <brauner@kernel.org>
To: Eric Curtin <ericcurtin17@gmail.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, 
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
 Eric Biggers <ebiggers@kernel.org>, "Theodore Y . Ts'o" <tytso@mit.edu>, 
 Gao Xiang <xiang@kernel.org>, Chao Yu <chao@kernel.org>, 
 fsverity@lists.linux.dev, linux-erofs@lists.ozlabs.org, 
 linux-fsdevel@vger.kernel.org, linux-doc@vger.kernel.org, 
 linux-kernel@vger.kernel.org
In-Reply-To: <20260727104845.2607444-1-ericcurtin17@gmail.com>
References: <20260727-gepaukt-eislauf-waran-7c03f0e47609@brauner>
 <20260727104845.2607444-1-ericcurtin17@gmail.com>
Date: Thu, 30 Jul 2026 12:58:09 +0200
Message-Id: <20260730-bachbett-erwarben-harmonie-e6b8ebf05969@brauner>
X-Mailer: b4 0.16-dev-3e0c3
X-Developer-Signature: v=1; a=openpgp-sha256; l=3650; i=brauner@kernel.org;
 h=from:subject:message-id; bh=o74o4MYrqkyTE9AOgcCDdL0OG8TudXVCYp0aA/sK8EE=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWRl67nst8uYLryqneFWZGz/Wb9dT6pv7Wj9Jpk2b3MJ0
 8a5m/XOdJSyMIhxMciKKbI4tJuEyy3nqdhslKkBM4eVCWQIAxenAEwk3Jzhfw3rr4RAec7519WD
 jRoYTSTetzge/LKyZslBNVbmKwHGsQx/hRx1Vri7hUb7t7VdP+34ccKpvGmx2zKcVp5W+m7eWx/
 PAAA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624

On 2026-07-27 11:48 +0100, Eric Curtin wrote:
> Changes since v1 (https://lore.kernel.org/all/20260718191551.1703670-1-ericcurtin17@gmail.com/),
> following Christian Brauner's review
> (https://lore.kernel.org/all/20260727-gepaukt-eislauf-waran-7c03f0e47609@brauner/):
> 
> The goal is unchanged: A/B image updates from a single partition,
> without paying for a second userspace spin-up at boot. What changed is
> how rootimage=/rootimageverity= get from "here is a path" to "here is
> the verified, mounted root", which is what most of the v1 review was
> about.
> 
>  - Patches 1-2 are new: they add generic, reusable VFS infrastructure
>    (struct fs_context::source_file, path_mount_file()/
>    init_mount_file(), vfs_parse_fs_param_file()) that lets an in-kernel
>    caller hand a filesystem an already-open struct file as its mount
>    source instead of a path, and convert erofs's existing file-backed
>    mount support to use it when given. This is the "new infrastructure
>    available to any fs" asked for, so that init/do_mounts.c never has
>    to independently re-resolve a path that something else already
>    opened and validated.
> 
>  - Patch 3 (rootimage=) now opens the image file exactly once and
>    mounts that same struct file via the above, instead of opening it,
>    doing nothing with the open, and separately handing erofs a path
>    that it re-resolved on its own with no guaranteed relationship to
>    what was checked - which is what v1 did, and which is where most of
>    the "second lookup" / "weak assumptions" findings came from. There
>    is no fd-vs-path race left because there is no second lookup left.
> 
>    rootimagesrcdir= is now mandatory (rootimagesrcdir=none opts out
>    explicitly) instead of silently detaching the carrier by default,
>    so there's no more zombie superblock/dangling mountpoint by
>    default; you have to ask for that outcome by name.
> 
>  - Patch 4 (rootimageverity=) is mostly unchanged in what it checks,
>    but now runs on the exact file patch 3 mounts, so the digest check
>    and the mount are guaranteed to agree on what "the image" is. It
>    also now refuses rootimageverity= together with rootimageflags=
>    containing device= (multi-device erofs images), since the digest
>    only ever covers the primary image file and silently ignoring the
>    rest would be a false sense of integrity.
> 
> Not changed / not attempting to fix in this version, per the v1
> discussion:
> 
>  - The carrier filesystem itself is still fully parsed (superblock,
>    directory entries, extents) before rootimageverity= gets to check
>    anything, since reaching the image file at all requires that. This
>    is structural to a file-backed image sitting on a general-purpose
>    writable filesystem, the same way a dm-verity root still needs a
>    trusted block layer under it; rootimage=/rootimageverity= are meant

dm-verity reads opaque sectors whereas this runs
superblock/extent/directory parsers running on attacker-writable data.

The mitigation mentioned below kinda defeats the feature... The
filesystem that contains the image files is writable and the whole
rootimagesrcdir= exists to keep it reachable. If you could dm-verity is
as stated below, you would just dm-verity the root and used
dm-mod.create=

All of the other issues:

* init suddenly becomes deployment policy
* things shipped as modules
* composefs can't use this
* the alternative to achieve the same thing via CONFIG_INITRAMFS_SOURCE
  / UKI signed initrd completely ignored

/me walks away from this LLM hell.


