Return-Path: <linux-erofs+bounces-3935-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1AB31C4450A
	for <linux-erofs@archiver.kernel.org>; Sat, 18 Jul 2026 19:16:05 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4h2c2C2W8jz2xlZ;
	Sun, 19 Jul 2026 05:16:03 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2a00:1450:4864:20::32f"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1784402163;
	cv=none; b=k9vf5jptA38W4Df7WGGw9oAATWmhnrk5FmT0XN6AsjKCrXEZaPU6t/qUvXHjy+jOwx/BGlawpcHl0TdzMwa7LxquX53GaV/+BU0PRLgzvD3IF5MmrRXZwmmauZ9uVLvfXUS7w2bqzeZ0hl12vncMXqh7PauqLigTSwAxrZIR0W+se8gzNpkNYIRW5hA9CmfmlL1Iqtu2Gmj+s3ed5Cav+srSvWVVpGwJBUFuSCyu6E7x3nEWQJCvdoWaLmDiN5/4v4ASsgi1EVSOkYk95acupFZEb8bB3nmBJVB3MR7CvaCQaqeyQQv6Q5FFAMFVIxOWs2+Nkc4/paoaF5Pc8BdVEg==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1784402163; c=relaxed/relaxed;
	bh=iYUDcKkoJkhlHxJ16Bnz94ZFULLiEQmAk5z7Yu5ywFE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=dtfW+F5tNu8b0+vCHH8obpG0lXUNzKvkT5GZEnFasNGsHyWekMXIuEBOY434FJhgD6lwwd4je3OLqbeyVsIffqI2M0zm52yvI7BhEd0iJ21ifeeEgGhC8/X8NLgi6muHEInuVdUy0IdvjXUU83PQaEewk040MOKKYmf8HTurwdbadyAmfFQVC6sAginRiN8yfEYIzhMHF6S6JR5toLh5ppRBhpvHQtJa+k8YVPXaWirnAtZ49ly8u70HPrRSJQ1lsmzdcLDhwx2vRnFF7LnMcosbfAzyN8zNzG40BL+bRnlfTw0KAzGqdwnIKoINGapGKRD//WNUdTPRsgNwh9O39A==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=gmail.com; dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=be0WZTjU; dkim-atps=neutral; spf=pass (client-ip=2a00:1450:4864:20::32f; helo=mail-wm1-x32f.google.com; envelope-from=ericcurtin17@gmail.com; receiver=lists.ozlabs.org) smtp.mailfrom=gmail.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=be0WZTjU;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=gmail.com (client-ip=2a00:1450:4864:20::32f; helo=mail-wm1-x32f.google.com; envelope-from=ericcurtin17@gmail.com; receiver=lists.ozlabs.org)
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4h2c290sNqz2xRs
	for <linux-erofs@lists.ozlabs.org>; Sun, 19 Jul 2026 05:15:59 +1000 (AEST)
Received: by mail-wm1-x32f.google.com with SMTP id 5b1f17b1804b1-4954d29264cso6442185e9.2
        for <linux-erofs@lists.ozlabs.org>; Sat, 18 Jul 2026 12:15:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784402155; x=1785006955; darn=lists.ozlabs.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=iYUDcKkoJkhlHxJ16Bnz94ZFULLiEQmAk5z7Yu5ywFE=;
        b=be0WZTjUUoe78TOf0bCXwiTVii3QbTWbgL8sIzlcOzghxUqhM104Z6IFnhlfZL/pmi
         jBM1aGuRo06cHrR90i6wpPNUCjfAr+g724IVwdEOChxpUgJQ7lkOCFPSG/f4AG+XMZvt
         58Ks/OkgR58tvf3wE9HG1877Gf2jV3rUU0v6/wFhwS+NkSbqFKCpowiZXhW0FcZAa6Ab
         mCaIu0WUQMWqO/C6ygcAqVAFWk091LYpyMtjFR8ChjwqIFR8cPSNfyBuyOVBVSuNnMIj
         ULZOoCv8Q/oN9Pd5x1hy3hNxKXnYJti1ql9JmQmv0UvMpbPZQM72EuyLKI7hWy5fDiIr
         SH5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784402155; x=1785006955;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=iYUDcKkoJkhlHxJ16Bnz94ZFULLiEQmAk5z7Yu5ywFE=;
        b=Zm8MX+s51rZ7y5fq63suiDlpBiGNFxJAYMDZNpFW55+n6F0ll/zzcUIm1cj1JjxGJT
         6EhD/tll99Ro4radPEjQ035zceSI0gBQUvVYMROe/6q/XVcQBcIzhqBkvwCju/VjwdCa
         UA0vuGRbpV0XcdZ8QAl0ygib20pY2zOXaMqy95WwsvYKNc+QizDrZkb5XTlCEv5zWtQV
         HHybETYy5jVPR2jhSuzmve/itkTuU4RPSTn5+Xs8CXWIKIhnaBUYCrpeyPIIJ7GMaPDq
         zGT7MpALbca6D10eSdbM3oJXbUnpsHBa92hy1ZxAJiXWVEfQze5Sd69A2JnFzIaSXwyC
         V9NQ==
X-Forwarded-Encrypted: i=1; AHgh+RqGlrPSsiSSiQhe4pYN/WcliRQuT8Gk9A+/KWa6QF0FeRVoQpn1NO6lbWWqtF2zLqJ+BVJ/6KdNitw/vA==@lists.ozlabs.org
X-Gm-Message-State: AOJu0Yzr3DgBLemU0wnaVTKQGCSTJB26HJnUhtv/4Pj8XMr2G3pnO8n0
	5Exo8i3E/zKihP+Olnx78zvGXR+Bgf7eFQs9FkWxo8iZTMwUtGGbq+eT
X-Gm-Gg: AfdE7ckKEoyhFJ1WHuWMmWNKK4uk0AajTJq/SoeVJHDZaM/jDkZft+iHecaSo54Gow/
	FiXeNYkQOx0YSE5G1G4zg5Iz7k40peAwcmgJXIgK8LSWMrudAqQ1wRVXldgT/yzAPmRpTgugghC
	6aXzJUxe6KZoealFp5XHv+KMdZObA5V1BE537ADWCiqyXFkOpweu22HSdMLzGVzkWqmgrmW8hmj
	9LbfSEjfSOLWMEzGcazGSnbA5MJxzIEwE8rM6zBobbHJLZuXm0M9RNGaYHEsDc30pZiuFANrobP
	CG1IRKxOIj0F7crrLzCY9T5tgLe3lKuN/oBVaqT/UYig0k1chMBTO2gxN1AX5r/nXV+4EumU9uX
	4EX4Wc0tzbmTYpdpMBFqRjhDx+lDJNiSXfJGz9ytMn/Y7cS5Fmv1Y8FkeDBpxwd4hlaEA81YRFl
	vM5lFbkWvyAZcbGrqa
X-Received: by 2002:a05:600c:a42:b0:493:e983:806e with SMTP id 5b1f17b1804b1-4954a3ee98emr90669215e9.3.1784402154743;
        Sat, 18 Jul 2026 12:15:54 -0700 (PDT)
Received: from spark.Home ([2001:8a0:7280:4000:c2b:a5ab:a31c:e0a5])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4954a2e8529sm140037005e9.11.2026.07.18.12.15.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 18 Jul 2026 12:15:53 -0700 (PDT)
From: Eric Curtin <ericcurtin17@gmail.com>
To: Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>
Cc: Jan Kara <jack@suse.cz>,
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
	linux-kernel@vger.kernel.org,
	Eric Curtin <ericcurtin17@gmail.com>
Subject: [RFC PATCH 0/2] init: boot image-based systems without an initramfs (rootimage=)
Date: Sat, 18 Jul 2026 20:15:49 +0100
Message-ID: <20260718191551.1703670-1-ericcurtin17@gmail.com>
X-Mailer: git-send-email 2.43.0
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

Image-based Linux systems (bootc-style OS updaters, ChromeOS/Android-like
A/B schemes, embedded appliances) keep one or more immutable root
filesystem images as sealed files on a writable filesystem and pick one
at boot.  Booting such a system today always requires an initramfs, even
when that initramfs has nothing else to do; its only jobs are to parse
the kernel command line, mount the state filesystem, verify the image,
loop-mount it and switch_root into it.

This series teaches the kernel to do all of that directly:

  root=PARTUUID=... rootimage=/deploy/a/root.erofs rootimagefstype=erofs \
      rootimageverity=sha256:a9548f4c... rootimagesrcdir=/var/state

Patch 1 adds rootimage= (plus rootimagefstype=/rootimageflags=/
rootimagesrcdir=): root= then merely names the "carrier" filesystem.
The image file on it is mounted read-only through the filesystem's
file-backed mount support (available in erofs since v6.12), so no loop
device is involved, and it becomes the root that prepare_namespace()
pivots into.  The carrier mount is detached by default, or moved to
rootimagesrcdir= inside the new root, which image-based systems
practically always want since the carrier holds their writable state.

Patch 2 adds rootimageverity=, which requires the image to carry a
specific fsverity file digest, reusing the fsverity_get_digest()
interface that IMA and overlayfs already use for digest pinning.  With
a signed or measured command line (e.g. a unified kernel image), the
chain of trust extends to every byte of the root filesystem with no
userspace boot stage: the pinned digest authenticates the image's
Merkle tree root, and fsverity keeps verifying reads against it at
runtime, so later tampering with the carrier is caught as well.

This is the file-backed analogue of dm-mod.create= (CONFIG_DM_INIT),
which moved the equivalent block-device setup out of the initramfs for
verity-partition layouts back in v5.1.  For file-based deployment
layouts nothing similar exists, so distributions ship a dracut stack
whose only purpose is the five steps above, and which remains the
largest and most failure-prone moving part of an otherwise fully
image-defined boot.

Tested on arm64 (qemu -M virt with KVM), with no initrd= at any point:

 - control: plain ext4 root boots as before
 - rootimage=: an erofs image file on ext4 is mounted as /, the carrier
   ends up on /var/state, PID 1 runs from the image ~0.18s after kernel
   entry
 - rootimageverity= with the correct digest: boots, digest logged
 - rootimageverity= with a wrong digest: panics with expected-vs-got
 - build: defconfig and allnoconfig (!CONFIG_FS_VERITY, !CONFIG_BLOCK),
   both with W=1, no warnings

Open questions for review:

 - Should the carrier always be detached, dropping rootimagesrcdir=?
   The image mount pins the carrier superblock either way, so userspace
   can re-mount it, but a conflicting ro/rw state then needs a remount
   dance.
 - Should this be behind a Kconfig option like CONFIG_DM_INIT is?  All
   added code is __init and freed after boot.
 - Naming: rootimage= vs. extending root= syntax (e.g. root=image:...).

This series was developed with AI assistance (see the Assisted-by tags
and Documentation/process/coding-assistants.rst).

Eric Curtin (2):
  init: support mounting the root filesystem from an image file
  init: support pinning the root image's fsverity digest

 .../admin-guide/kernel-parameters.txt         |  42 ++++
 init/do_mounts.c                              | 221 ++++++++++++++++--
 2 files changed, 250 insertions(+), 13 deletions(-)

-- 
2.43.0


