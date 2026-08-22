Return-Path: <linux-erofs+bounces-4287-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F1608C5DF97
	for <linux-erofs@archiver.kernel.org>; Sat, 22 Aug 2026 08:59:19 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hRrhP6HH6z2xWt;
	Sat, 22 Aug 2026 18:59:17 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2a00:1450:4864:20::62a"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1787389157;
	cv=none; b=jDREAmHfdKoA1zSEbJDsYmaL9zXaaZUg3z9bdmBuKQ0O0fs12DSg1wreXP0N+qKUzGgo18H/ltjko4dN1Te8vedWo3oFT7aThsmVXpAXvK8J2H5s8ZRRqDKLjc+i4DFbQQ3fDVeAjFuzFQFKdg5dKQysHB+BOHt5yX87YwdEMbOh9QVyUeFziqCkxUnBRKfaOTpT3o91dk3qd+B5i9KVtfJ3+NtzJcos5x5xFWhS1R4hOLWLRuhIlpiv+kWtUKB9s9suQWDzXOLc6/b2sd3KgrZU3n4bpO4J3Xdxcv8bDlLMRsPc51QJQejZdoRTWskUrd6cQWajhw5mvhmNZuxHTg==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1787389157; c=relaxed/relaxed;
	bh=XWFw7oVAD56uhvJj/kmMbZYxkDNC94ZtuxOoToJYGmY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OYOlRlW0AQd8982uBEhtileXpJET7p7+pTp+cu1On4Z3hpnq+1oLdAjwV/URkK34G/DOenLNVBvAPQTGaf46qJbQ8Ebr4w6tR67UOeF0adhBvDT5dHiM6yVzOQiGKv4yO5WR5NtY3CvzRTpj56kpqouXRPM16Hqpujz2AHQJJQlnxwtuGv1TVFAt1FgtgmX46tNFQ1RwoUHsDkPsxqRacHdEpwMvWv5GHYsfqLzpy2cf163GRhOzKR3kwJuM4jNr60FkDlwa7zimmTrN+Di+0vaIGvA8QYYeE4YSmZ+J1RewgPElEAkHQgrDqIvedMVffG2ZWKOWPQk7zYWe8dCBMQ==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=gmail.com; dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=plsx8jRs; dkim-atps=neutral; spf=pass (client-ip=2a00:1450:4864:20::62a; helo=mail-ej1-x62a.google.com; envelope-from=mike.malyshev@gmail.com; receiver=lists.ozlabs.org) smtp.mailfrom=gmail.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=plsx8jRs;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=gmail.com (client-ip=2a00:1450:4864:20::62a; helo=mail-ej1-x62a.google.com; envelope-from=mike.malyshev@gmail.com; receiver=lists.ozlabs.org)
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hRrhN1zrhz2xKh
	for <linux-erofs@lists.ozlabs.org>; Sat, 22 Aug 2026 18:59:15 +1000 (AEST)
Received: by mail-ej1-x62a.google.com with SMTP id a640c23a62f3a-c20e70a0962so271839166b.2
        for <linux-erofs@lists.ozlabs.org>; Sat, 22 Aug 2026 01:59:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787389151; x=1787993951; darn=lists.ozlabs.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=XWFw7oVAD56uhvJj/kmMbZYxkDNC94ZtuxOoToJYGmY=;
        b=plsx8jRs/fl/Kmp3fitNysDZA+OQo1KUh+O90fKKA9/cbRO6oTSqSQgUhsxOlIn4HL
         sEqjIscWVSQJid93rb4dHvWbdH2c/LstzHclYy4PyYXTTCuKW8bSKFzWZSmGOsrMvLzw
         zffGftvoc7Cm/kNBK7UrcX08VDG8Mpaeznshx82kSsoQJKLgAjSum37FXwks5KxctOht
         H9mKt4ylq4ZTHDKoalhefR+u1nGcrRrrLoBy/umkrArm9YEu+Of5NmSmwvSqreutzw16
         J2MoCFx2Hk+6Al1JpDdESMV+5P2Ob6Sq1YJ2zKX45lzVd6y9g7+6HHEtiFRx9biwEF9T
         RzDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787389151; x=1787993951;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=XWFw7oVAD56uhvJj/kmMbZYxkDNC94ZtuxOoToJYGmY=;
        b=OsT6eqsMv8KqJ4C6Zcuq1eiqsiSi+SVkT6uUPmDRVjKArsKvPecGirvFrUM/kKrYjm
         4/l9gjuQlQ/ESApg3H98aTf11pIs+ZjPLrwo2Fon+ZFbOrtFctCqAQ/HWEgyF7PQ1V/E
         BsogvOULEu7yD5ByEIW0K972ZU16olKGu9ER2naoREY4Tu4gJXQF3nhlLLc/E2e4f75y
         tQnP4HyJA8gtxHuyxMOs8hnU+e7t7VhffLNvlwjdIASFI5UB50AuFbxz0J3XTseSD65l
         2XSPnVpywiJA7t93sGWrkJoTkNmC2Lhz4uiepm4laCpGxNVoCY0KySlhwHbiO9X0kIVO
         EBFQ==
X-Forwarded-Encrypted: i=1; AHgh+RqiJqbYeADtc4PbRpqnUxg0bMMyvljBZ3FnX6KyxCRDQQ8qinwvX80PBbn1cE+VZP3iU9X97UwtZBG29w==@lists.ozlabs.org
X-Gm-Message-State: AFuF++kH0er/a+2oe+4G6V4NJgu9qK2KxKA6uNbtjqp6jfmzEFo+dCvU
	KOUftQKA7RKVEvB9a+Waifp8ZpcwDTMrgqVyumht7y0HrRU7dsD8Q25iXQZxTg==
X-Gm-Gg: AR+sD10A/6OjZf2lH6CLozk7uu1jhnrbg9pfcDHGbdF00+EKu7AM1jo63zEADbjvy8l
	rnFa7g349t8SL38/010JTfOJaruk0gLloGwgu95q4kxfX6pj9zRWZAD+7gmiImkpdhwwStu+g2Z
	f2JmcEKlF3yaW1+Fddc/92aqGxSIxR+yVBOwc2/YqdRWPwAO5G5SI9at13tcaxGUA6avjlnjFhG
	zKF6b4/JRvPq6/gibRA5WhZHynOhLnzd/BK1VFl1/WnHK/pqrDSMRz8lFzNtgchRTrLMUELLj6z
	ahkybNX80o2kAQAmmklwpj7g85yjdhNjHZXNV4tH3qljKnQzpfVVTL+SGUBNsJyWPaBs/fPBif2
	coIz6c5KSgkB5eM+5djmzWnWDlRwk9KQOSVjoz9rlBG/RPsH0VDpEwLcztNfJKWFKXYvYZLMoN5
	3FeSXZptG28VX+DdrJbj5yswqoBySZZvm/xe43GkLUTHbBIbSz4l9CxtdZxVCMY/4M6w==
X-Received: by 2002:a17:906:9f8e:b0:c19:5572:d234 with SMTP id a640c23a62f3a-c246a4ac801mr1521541266b.1.1787389151203;
        Sat, 22 Aug 2026 01:59:11 -0700 (PDT)
Received: from build-server.. ([62.96.37.222])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c249606a8fasm268297966b.8.2026.08.22.01.59.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 22 Aug 2026 01:59:10 -0700 (PDT)
From: mike.malyshev@gmail.com
To: Gao Xiang <xiang@kernel.org>
Cc: Mikhail Malyshev <mike.malyshev@gmail.com>,
	linux-erofs@lists.ozlabs.org
Subject: Re: [PATCH] erofs-utils: lib: follow symlinks on intermediate tar path components
Date: Sat, 22 Aug 2026 08:59:09 +0000
Message-ID: <20260822085909.2781141-1-mike.malyshev@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <am8_iD0g9yTj2B1m@XiangdeMacBook-Pro.local>
References: <20260725150920.1900298-1-mike.malyshev@gmail.com> <am8_iD0g9yTj2B1m@XiangdeMacBook-Pro.local>
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

From: Mikhail Malyshev <mike.malyshev@gmail.com>

On Sun, Aug 02, 2026 at 09:00:56PM +0800, Gao Xiang wrote:
> Thanks for the patch and sorry for late reply.

No worries at all -- and sorry for _my_ slow reply, I was on vacation
and only just got back to this.

> Yes, I assume containerd will resolve the directories like this, but as
> a quick reference, could you give some pointer how `tar` utility works
> and `posix` documents this behavior?

Good question, I dug into it a bit.

On the tar side, I tried the exact case (a "lib64 -> usr/lib64" symlink
followed by a "lib64/foo" entry). GNU tar (1.35) and busybox tar (1.37)
both follow the symlink and write the file to usr/lib64/foo, leaving
lib64 as a symlink -- the same result as this patch. bsdtar/libarchive
is the odd one out: it refuses with "Cannot extract through symlink,"
but that is its ARCHIVE_EXTRACT_SECURE_SYMLINKS anti-symlink-attack
default, not a different idea of what the path means.

POSIX-wise it is really just pathname resolution (IEEE Std 1003.1-2017
Base Definitions, 4.13): a symlink in a non-final path component is
followed. GNU/busybox tar create the entry with a plain open(2), so the
kernel resolves lib64/foo to usr/lib64/foo for them; the patch just does
that same resolution by hand, since the tar tree builder has no kernel
to do it.

What really pushed me to fix it, though, is matching the runtime that
actually consumes these images. containerd's walking differ does exactly
this -- it resolves each entry's parent with fs.RootPath ("evaluating and
bounding any symlink to the root directory") and writes to the resolved
target. So today mkfs.erofs --tar and containerd disagree: containerd
converts these layers fine, while mkfs.erofs bails out with -ENOTDIR and
produces the ~2 TiB image, which makes RHEL/UBI/Fedora usr-merge base
layers unconvertible. And since the builder works on an in-memory tree
(with absolute links re-rooted), following them cannot escape the image.

> I plan to release erofs-utils 1.9.3 without this patch soon, and it can
> be addressed in erofs-utils 1.9.4 version.

1.9.4 is totally fine by me. Would you like me to fold these references
(the tar behavior, the POSIX section, and the containerd fs.RootPath
pointer) into the commit message? I am happy to send a v2 with them if
that is easier for you to pick up.

Thanks!
Mikhail

