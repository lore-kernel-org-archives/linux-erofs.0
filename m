Return-Path: <linux-erofs+bounces-4011-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5C8B7C531D0
	for <linux-erofs@archiver.kernel.org>; Mon, 27 Jul 2026 08:55:14 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4h7sqh5ZcFz2yhD;
	Mon, 27 Jul 2026 18:55:12 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=172.105.4.254
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1785142512;
	cv=none; b=c7C8217biTrM7CTahi0iXMomE4JulHeWe0aSyfGHtqzi7IVhiTEktychJVpn0acmohNYu/84SGzWp0+nbPtpnUiIWH1AC29Br+zWLuNqdeBYswx5yj5zEOV6eDQcjv+mhfXiq3ZigasArMyoSOGXRFW88tjZU9X9o0R8dtI02kT/cIoMKT/QtOMjVfXX0UKcwQaI7pz8J2z2014K3XxLX4JefQ8hIXMAAg6mZaESQKoomdjM8rbxWU9ch+Mm5sURpOfyOIQyxbGgaZCAOEN4IV7s7T1Fq/33LKHogSMPJzemg9nA9X4Mkspn2xEv64Kbo4Ss8xUVEwvJrWDZaI73AQ==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1785142512; c=relaxed/relaxed;
	bh=wmpAzoIh2ygP1QxiJ0z6lzAFz+KkFkXT++K3Z7V9lFI=;
	h=MIME-Version:Content-Type:Subject:From:To:Cc:In-Reply-To:
	 References:Date:Message-Id; b=i/dQCN5gygMuJ+SRYQTn8ZEKA+tqoRkkaZgaeLJFBb021gWDH4mffiJkbbCf+ldxCU7KxJOsB9iH3968kAIEOUGOCwim6J4M6NsbdM4fNciy0svf16vFcAHiJvnLJVRWs9atwVPPnMdyvGrQlAVU8PcNYaSn9UiMfa+2BJuqDs92fZPS4edgPBypjmY+rD5gwXOQ1UNh+RW22fYjlJbpVQDer8nLIsjfhe9KkATjTawsf+cGjJa5JJZSrKv2wZQvhIMO04CHRJ5ki1DC7vn/0bHZwAY6O+m7bF00ifciKXpU1shykLzzdzF2Oz/TCfsgSjmvAvETOTy72EM61/aaSQ==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=nsgd1Pbv; dkim-atps=neutral; spf=pass (client-ip=172.105.4.254; helo=tor.source.kernel.org; envelope-from=brauner@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=nsgd1Pbv;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=172.105.4.254; helo=tor.source.kernel.org; envelope-from=brauner@kernel.org; receiver=lists.ozlabs.org)
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4h7sqg5gbRz2yRl
	for <linux-erofs@lists.ozlabs.org>; Mon, 27 Jul 2026 18:55:11 +1000 (AEST)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 751AB601EC;
	Mon, 27 Jul 2026 08:55:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20C3C1F000E9;
	Mon, 27 Jul 2026 08:55:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785142508;
	bh=wmpAzoIh2ygP1QxiJ0z6lzAFz+KkFkXT++K3Z7V9lFI=;
	h=Subject:From:To:Cc:In-Reply-To:References:Date;
	b=nsgd1Pbvsa+4SSMZehnETFGVhpGyLEzoKmBhd2uDuIV1WlMnjyi4qkFqsSGs66BLO
	 dIM9Nuvp9lUuuDS6BmeMMLAnjqfnvPu6fHYRKpHz7gdYfBEaA+wB5fPGCRnm16aV9Y
	 FlRfQt3zgWlxlX3sLYQRYXEOBCZwouSI4M8AmdXSg7OWGFShYInus70UUVgor6ndg/
	 M+b2EG/dBoiFO2NWZVgDPQKat3AcGYTrXgGJ5AYMgHs2siflaNyQc9oh95rVkbGJlU
	 liigB0DprAss5cAExm4Y8E4Fp6KvT+NtK463P3GnS6SehKUJiZOnYiVveigtNynuHv
	 bSbJI+vT1SCWQ==
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
Content-Transfer-Encoding: 8bit
Subject: Re: [RFC PATCH 0/2] init: boot image-based systems without an
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
In-Reply-To: <20260718191551.1703670-1-ericcurtin17@gmail.com>
References: <20260718191551.1703670-1-ericcurtin17@gmail.com>
Date: Mon, 27 Jul 2026 10:55:02 +0200
Message-Id: <20260727-gepaukt-eislauf-waran-7c03f0e47609@brauner>
X-Mailer: b4 0.16-dev-09492
X-Developer-Signature: v=1; a=openpgp-sha256; l=6395; i=brauner@kernel.org;
 h=from:subject:message-id; bh=VIUIcef0y8xYwHIZfq8XT5DSP1PTByonZZgZX4jYJjc=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWSly7zw7ZB7Kf+6ecWdBS1c69VMY7dZr7gS7rOJ5bN7W
 9TlXzYCHaUsDGJcDLJiiiwO7Sbhcst5KjYbZWrAzGFlAhnCwMUpABO5E8TIMDtn5qttv9rf8K2f
 tPnglW+CZzptLWcUPj1/6dbTQwJ7vGQZ/qmw1DswbnJ9uPXr1/kZ7ifDTOy/lPbdiNp9unKXvN9
 JezYA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624

On 2026-07-18 20:15 +0100, Eric Curtin wrote:
> Image-based Linux systems (bootc-style OS updaters, ChromeOS/Android-like
> A/B schemes, embedded appliances) keep one or more immutable root
> filesystem images as sealed files on a writable filesystem and pick one
> at boot.  Booting such a system today always requires an initramfs, even
> when that initramfs has nothing else to do; its only jobs are to parse
> the kernel command line, mount the state filesystem, verify the image,
> loop-mount it and switch_root into it.
> 
> This series teaches the kernel to do all of that directly:
> 
>   root=PARTUUID=... rootimage=/deploy/a/root.erofs rootimagefstype=erofs \
>       rootimageverity=sha256:a9548f4c... rootimagesrcdir=/var/state
> 
> Patch 1 adds rootimage= (plus rootimagefstype=/rootimageflags=/
> rootimagesrcdir=): root= then merely names the "carrier" filesystem.
> The image file on it is mounted read-only through the filesystem's
> file-backed mount support (available in erofs since v6.12), so no loop
> device is involved, and it becomes the root that prepare_namespace()
> pivots into.  The carrier mount is detached by default, or moved to
> rootimagesrcdir= inside the new root, which image-based systems
> practically always want since the carrier holds their writable state.
> 
> Patch 2 adds rootimageverity=, which requires the image to carry a
> specific fsverity file digest, reusing the fsverity_get_digest()
> interface that IMA and overlayfs already use for digest pinning.  With
> a signed or measured command line (e.g. a unified kernel image), the
> chain of trust extends to every byte of the root filesystem with no
> userspace boot stage: the pinned digest authenticates the image's
> Merkle tree root, and fsverity keeps verifying reads against it at
> runtime, so later tampering with the carrier is caught as well.
> 
> This is the file-backed analogue of dm-mod.create= (CONFIG_DM_INIT),
> which moved the equivalent block-device setup out of the initramfs for
> verity-partition layouts back in v5.1.  For file-based deployment
> layouts nothing similar exists, so distributions ship a dracut stack
> whose only purpose is the five steps above, and which remains the
> largest and most failure-prone moving part of an otherwise fully
> image-defined boot.

So I have several structual and design issues with this.

In the first pach the filp_open() and subsequent fput() are unused.
And that claim "the image cannot change between this open and the mount
below" is resting on very weak assumptions.

The second patch then checks the digest on the struct file from its own
filp_open(). But the mount goes through init_mount() with the path... so
erofs does a third lookup via filp_open(fc->source)...

Nothing guarantees that there's a relationship between the verified
inode and the path the superblock is created from. The only guarantee is
that no userspace yet exists but which can't really be enforced.

To support this properly we need new infrastructure such that you can
actually hand an already opened file as the source. I know that erofs is
intended to merge support for this at least but this should be generic
infra available to any fs.

Note also that the default detach mode creates a zombie superblock and
the image superblocks source string (/root/deploy/...) dangles after the
pivot. /proc/self/mounts names a path that doesn't exist in the final
namespace. And unlike loop there's no /sys/block/loopX/loop/backing_file
to recover which file backs the root.

The other claim is that the digest sufficiently guarantees the integrity
of the root filesystem. That's not correct per se...

An erofs multi-device filesystem blows this apart and
rootimageflags=device= would also add more. So that digest only cover
the primary image.

The bigger flaw is that the untrusted "carrier" (LLMs do pick the worst
terms for things...) is fully parsed before anything is verified.

In other words, mounting the carrier means running the ext4 (or
whatever) parsers and infra over attacker-writable data, and the
fsverity descriptor are themselves read from that untrusted fs. So
basically you're hosed before you ever got to the fsverity part.

This is also now the third fsverity-digest-pinning mechanism (IMA
appraisal, the IPE LSM and now rootimageverity=). With the least
expressive policy language of the three. No signature or keyring option
either and so the boot entry must be regenerated per image update.

You're embedding a whole deployment topology into the core code here as
well... There are _five_ interacting __setup parameters. Every real
deployment immediately wants a sixth knob: A/B fallback inside the
mechanism. Because in your current model every failure is a panic().

But that also means image selection must live in the bootloader anyway:
composefs/overlay stacking, LUKS-encrypted state partitions as command
lines can't do crypto secrets, fsck of the carrier, directory-based
deployments yadayadayada.

This is just turning do_mounts.c into policy it shouldn't be involved
in. We just refused pushing the bootloader spec into the initramfs for
the same reasons - and that one I'm much more sympathetic to since I was
involved in creating it. I'd love to see parts of that in the kernel but
I refuse it because I believe fundamentally the kernel is in the
business of keeping complexity in userspace not the other way around.

Also the users the cover letter touches on such as distro kernels ship
erofs and its decompressors, the block drivers, and the fs stack as
modules. Afaict, rootimage= needs all of it builtin:

- bootc/ostree: composefs — multi-mount + overlay + external objects.
  inexpressible here and partially unverifiable
- ChromeOS/Android-style A/B: dm-verity partitions already served by
  dm-mod.create= and a fallback story.
- embedded squashfs appliances: no file-backed mount support in squashfs

What remains are single-erofs-filesystems with fully-builtin kernels.
That's kinda what CONFIG_INITRAMFS_SOURCE embeds a five-line static
/init into the same signed/measured kernel image with identical trust
properties and full policy freedom.

UKI users likewise already sign and measure their initrd as part of the
PE. The series only really makes sense if you get rid of that.


