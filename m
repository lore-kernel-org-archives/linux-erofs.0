Return-Path: <linux-erofs+bounces-4013-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8E355C531D0
	for <linux-erofs@archiver.kernel.org>; Mon, 27 Jul 2026 10:48:55 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4h7wLs5JPhz2yjN;
	Mon, 27 Jul 2026 20:48:53 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2a00:1450:4864:20::32b"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1785149333;
	cv=none; b=fIF4T5G9NPJWytzmdsLZG8+oIUXt0Ztgk1xiM/lrDF/Y7oDZxo0s9kp5NMP95le6b+Fgm4cVL5Prpye0AbfD/TBbdY48TWMMB5RDkDJ8E252LragVQr5q/5W0JuZ2M4GHNNw6rxP7wBxWgUprX9y/aXVCb92w1Hlg7JzncBFD+aFlqQSrRp1S9lEFQ/85hd1tYocnsg6FZTONKKz/iY0T8HsMAFV9EDA6z+XMRITE7ZPMgymojCvGk8/HlC89wiWvKhZGritY+of21F6tq6zf5kAaAZLYqZNjw96B9Cibu6w3N73xVXlLlK1+lUEIvCvCQcunXXxEXRLzmRnf7qqFw==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1785149333; c=relaxed/relaxed;
	bh=wl6olrm9zBlfcqm4vDgZbW7ZBUMwFpjsg4jq9Xu7B8Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SYQxeGIRBDln1y5Ol9M9qZx7E6C6ublkJTxKV5dHrz7KomxLwoyd0bhqcMqsLcuYSsmTNRuwIEMnxEfkg/fLEz1kbOwTh4zdCLDAFZsnStK5PolcHj7qLqyfG0W89E7VnCf03R++mCRxbn+F7c+ZlUtCs0wi5tUA37zvKz8pGnRVDPZL9ShB1uhVTYACIxKLE5l/iKe9w7ppRt/NUtqkgjXJgsQZyFZZyePxjR+K8BV5V8UTtu2kdqIkFKvXzrRIUnIkEbp/ibrFdmjA0NhIZ5GYxEwGG6lOQC+8rMBUPGvHujkgN4iEJ1DdAP3kaWPsrz29vLY9D6CPoIZWOad2KQ==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=gmail.com; dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=a3Eagvta; dkim-atps=neutral; spf=pass (client-ip=2a00:1450:4864:20::32b; helo=mail-wm1-x32b.google.com; envelope-from=ericcurtin17@gmail.com; receiver=lists.ozlabs.org) smtp.mailfrom=gmail.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=a3Eagvta;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=gmail.com (client-ip=2a00:1450:4864:20::32b; helo=mail-wm1-x32b.google.com; envelope-from=ericcurtin17@gmail.com; receiver=lists.ozlabs.org)
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4h7wLr1k10z2yhY
	for <linux-erofs@lists.ozlabs.org>; Mon, 27 Jul 2026 20:48:50 +1000 (AEST)
Received: by mail-wm1-x32b.google.com with SMTP id 5b1f17b1804b1-49548e01d02so12719155e9.0
        for <linux-erofs@lists.ozlabs.org>; Mon, 27 Jul 2026 03:48:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785149327; x=1785754127; darn=lists.ozlabs.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=wl6olrm9zBlfcqm4vDgZbW7ZBUMwFpjsg4jq9Xu7B8Q=;
        b=a3EagvtaIDmVMKHoEyXEIiHNVXZuaQ8YH/nBaY8ZhDIjIGZ3w7jqVrVkGSNjQQA7/d
         oDhI4hPSD+me78sK6U/aDNtIEHo18LQO4rL9vwboNmccTkaI/mlPE2ZJ/jvXQP6NAS26
         MN3BfixquvLyALKH1ol/SMgMnKVcMq0HOnUbWMYVsE0+IWkYnqVJyH/8OjSUDUWBFJIC
         V5GDKXpZ4CK4BIWx52PpW0OZWWEyUIm5MrIqzvz44hPPRwe9ek9OiPcDd1We5ZS0m8Yi
         0myLHhj/XBgZJV1sanpHO53xjpm8NQarMmV4/YSjoAg6FXtuekXS3+4R4mlC6beH/rHk
         jabg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785149327; x=1785754127;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=wl6olrm9zBlfcqm4vDgZbW7ZBUMwFpjsg4jq9Xu7B8Q=;
        b=C7ZB09uJFk4fmyDS+r0FlLDzRvcviLWlfOpMr8j2EpGuaRWRkXm4jTcXcdKF5p3R9U
         x4IBU1NlyfbW05+jrF9yDxZZzJaLCidOSHC1KbKDGk8SNy1aLaUNStzHAmdKrMt3uklz
         A8Kic8BCmVHv67Su0EQF5MD3WC5TR23FWBK6ECYeQiOZYHBxKmvr2rcZXIsgi7NgjAyS
         Xtb4WC9j+7Y5ll142crC3a7BCK6QeVgDHYrDFJUQyU/V0dHtYiT82eNzKhvQwD1WC8D5
         r6WJn8CJHxB/yvzIo7d+nsHGkvZWMQiQ3r8Lx1LMxIQu+aEKeLf+6BH8RfWEGS6m5kMp
         THMw==
X-Forwarded-Encrypted: i=1; AHgh+RrAidNoyiNKLkAjbXgMnEwQTUA9R9gFZ6amCp1yQuE4f/xw7CIXUUtr+pn23LgDwK4nH1xOU2ubRTHDKA==@lists.ozlabs.org
X-Gm-Message-State: AOJu0YwcsPAl1Xnv6RUenC8WvdNy3qbimvTbQ6InHuMV9iwz19n/3C4d
	DSrcGOv77W2EaoR0hMzJFl6Zid5hSFrxS6AhywrZeOBlU+/d3zW2cDcO
X-Gm-Gg: AR+sD107Xc9ItrzblevdzSGppoB77XxTAI7bNIxyFBAB/M1qniGmCIPOR8D6z6awUHL
	59mFApk6b6lWaq3ZLQIh9b2qy6tv7kCkD9PAH/O06JtlE542I6MLbCyKCQjFI7i5cCO3K4XYIky
	RLsoitVugxXBUFJt2NTv9G6arTfIFgnvU5cu1VtHec+vjI9CcnTw49L1QhicYBM5mEyCMOluZGf
	roq7yBWMbABUqiJeg1lHZarP8bIxa/kauNxn9Pbi1t9KKDXuir7ywYT5ZGDejBKjgA0BO+B20ff
	wKhxTL78SDfERaqZT5KbZbKwdW8ML8EzPG5jz1d9MtIVvdRzgAhanXXvE+/lQCSiN2RWJ1ECQIj
	27d+VM+47DJgLrwqJF4lsh4sPTSRlAbh0nixwjPH1i6xhdYfX8oxAXsRViFvuO5zmArMTgzRvbq
	trZ2AFLg==
X-Received: by 2002:a05:600c:19c8:b0:495:5205:86c with SMTP id 5b1f17b1804b1-496b5747d8dmr108835785e9.22.1785149327271;
        Mon, 27 Jul 2026 03:48:47 -0700 (PDT)
Received: from spark.Home ([2001:8a0:7280:4000:53fe:effd:424:fa7e])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47f85b9a659sm49056188f8f.6.2026.07.27.03.48.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jul 2026 03:48:46 -0700 (PDT)
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
Subject: [RFC PATCH v2 0/4] init: boot image-based systems without an initramfs (rootimage=)
Date: Mon, 27 Jul 2026 11:48:41 +0100
Message-ID: <20260727104845.2607444-1-ericcurtin17@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260727-gepaukt-eislauf-waran-7c03f0e47609@brauner>
References: <20260727-gepaukt-eislauf-waran-7c03f0e47609@brauner>
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

Changes since v1 (https://lore.kernel.org/all/20260718191551.1703670-1-ericcurtin17@gmail.com/),
following Christian Brauner's review
(https://lore.kernel.org/all/20260727-gepaukt-eislauf-waran-7c03f0e47609@brauner/):

The goal is unchanged: A/B image updates from a single partition,
without paying for a second userspace spin-up at boot. What changed is
how rootimage=/rootimageverity= get from "here is a path" to "here is
the verified, mounted root", which is what most of the v1 review was
about.

 - Patches 1-2 are new: they add generic, reusable VFS infrastructure
   (struct fs_context::source_file, path_mount_file()/
   init_mount_file(), vfs_parse_fs_param_file()) that lets an in-kernel
   caller hand a filesystem an already-open struct file as its mount
   source instead of a path, and convert erofs's existing file-backed
   mount support to use it when given. This is the "new infrastructure
   available to any fs" asked for, so that init/do_mounts.c never has
   to independently re-resolve a path that something else already
   opened and validated.

 - Patch 3 (rootimage=) now opens the image file exactly once and
   mounts that same struct file via the above, instead of opening it,
   doing nothing with the open, and separately handing erofs a path
   that it re-resolved on its own with no guaranteed relationship to
   what was checked - which is what v1 did, and which is where most of
   the "second lookup" / "weak assumptions" findings came from. There
   is no fd-vs-path race left because there is no second lookup left.

   rootimagesrcdir= is now mandatory (rootimagesrcdir=none opts out
   explicitly) instead of silently detaching the carrier by default,
   so there's no more zombie superblock/dangling mountpoint by
   default; you have to ask for that outcome by name.

 - Patch 4 (rootimageverity=) is mostly unchanged in what it checks,
   but now runs on the exact file patch 3 mounts, so the digest check
   and the mount are guaranteed to agree on what "the image" is. It
   also now refuses rootimageverity= together with rootimageflags=
   containing device= (multi-device erofs images), since the digest
   only ever covers the primary image file and silently ignoring the
   rest would be a false sense of integrity.

Not changed / not attempting to fix in this version, per the v1
discussion:

 - The carrier filesystem itself is still fully parsed (superblock,
   directory entries, extents) before rootimageverity= gets to check
   anything, since reaching the image file at all requires that. This
   is structural to a file-backed image sitting on a general-purpose
   writable filesystem, the same way a dm-verity root still needs a
   trusted block layer under it; rootimage=/rootimageverity= are meant
   to sit on top of an already-appropriately-trusted carrier (e.g.
   itself dm-verity/LUKS-backed, or a well-audited always-read-only
   fs), not conjure trust in an arbitrary writable one out of thin air.

 - A/B slot selection and fallback/rollback bookkeeping are still the
   bootloader's job, exactly as with dm-mod.create= today; this series
   only does the "resolve the one path the bootloader already chose,
   verify it, make it root" mechanical step for the file-backed case,
   not image-based deployment policy in general.

 - There is still no sysfs equivalent of
   /sys/block/loopX/loop/backing_file to discover which file backs the
   root after boot (the mandatory rootimagesrcdir= at least means the
   carrier itself stays reachable). This would need its own generic
   piece of infrastructure and is left for a follow-up.

Eric Curtin (4):
  fs: allow in-kernel mounters to hand filesystems an already-open
    source file
  erofs: use fs_context source_file for file-backed mounts when given
  init: support mounting the root filesystem from an image file
  init: support pinning the root image's fsverity digest

 .../admin-guide/kernel-parameters.txt         |  56 ++++
 Documentation/filesystems/mount_api.rst       |  18 ++
 fs/erofs/super.c                              |  19 ++
 fs/fs_context.c                               |  39 ++-
 fs/init.c                                     |  18 ++
 fs/internal.h                                 |   2 +
 fs/namespace.c                                |  96 ++++++-
 include/linux/fs_context.h                    |   4 +
 include/linux/init_syscalls.h                 |   2 +
 init/do_mounts.c                              | 269 +++++++++++++++++-
 10 files changed, 514 insertions(+), 9 deletions(-)

-- 
2.43.0


