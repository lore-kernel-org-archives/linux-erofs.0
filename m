Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A248606A319
	for <linux-erofs@archiver.kernel.org>; Wed, 21 Oct 2026 11:13:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=raspberrypi.com header.i=@raspberrypi.com header.a=rsa-sha256 header.s=google header.b=TnvI/MaH
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4j8mqV1FJ6z2xbN;
	Wed, 21 Oct 2026 22:13:26 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=pass smtp.remote-ip="2607:f8b0:4864:20::234" arc.chain=google.com
ARC-Seal: i=2; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1792581206;
	cv=pass; b=abk0RRWcwUumlX1rVG5F3/zdjEJAiBLE5aWwQFIYAxP/iMQYw/ODiqIAJnzBZpOABx0aQlYQt1469d8WLoVVPkuQXSoL02QGW/reb3qX7NjBYRZCbcIE9Xi2wfBhPTI8bppPkwekTz0LswP4pwSv9/tMzJiUKl92evabFyKOnSIwLKR4Ifl7MYIHRN9c47m/Ymf5lHw3NAxTgQTQu4L93eiwdt1oOpSZtH0mfPoXN8JfZahApScPO57ZR046QCqxyHagBRHj2+feaqNYQ0ndJoOjViV0iihFwKHkJ2Yx42oOsaCeh/yytISMI1ZeK1Ab5Q5ph5P61hDZyywSkvxyNg==
ARC-Message-Signature: i=2; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1792581206; c=relaxed/relaxed;
	bh=kFbBv6KaAF56ARAdsMlSPfR4+M2Bdd/eIPH1CMzioTg=;
	h=From:MIME-Version:Date:Message-ID:Subject:To:Content-Type; b=NHbxV+CJSvnqAwji/gO4PHyGxyhyrQiRmvreGW65TAGPMU3mnEoR8l01+BHKTqMKUk9r+IeSTZDpEPsrrlSzO08YkoSO6Q4U0n5DNf2uMI/0yrAKG535ajsWe51VEIUdzIbnoNCzrafhvFlv93rTs04BnbbzDva8gh6t1QhJnqFl+lAkQZwBfXSwTMAIm+TmKKh1PBiL74a3ORzU+armQxGDpoEX+Ntxvq/pW9n9l4iSGbExJyERzg4pB8vX5TZYowQu8n6Ezm7ICd3WiDLze56svCwvuEYWZpalGnNk1uK6eqMTyuxc8cqg1C55CkJPgUKi2LbOxodcjb67JP7OWA==
ARC-Authentication-Results: i=2; lists.ozlabs.org; dmarc=pass (p=reject dis=none) header.from=raspberrypi.com; dkim=pass (2048-bit key; unprotected) header.d=raspberrypi.com header.i=@raspberrypi.com header.a=rsa-sha256 header.s=google header.b=TnvI/MaH; dkim-atps=neutral; spf=pass (client-ip=2607:f8b0:4864:20::234; helo=mail-oi1-x234.google.com; envelope-from=matthew.lear@raspberrypi.com; receiver=lists.ozlabs.org) smtp.mailfrom=raspberrypi.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=reject dis=none) header.from=raspberrypi.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=raspberrypi.com header.i=@raspberrypi.com header.a=rsa-sha256 header.s=google header.b=TnvI/MaH;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=raspberrypi.com (client-ip=2607:f8b0:4864:20::234; helo=mail-oi1-x234.google.com; envelope-from=matthew.lear@raspberrypi.com; receiver=lists.ozlabs.org)
Received: from mail-oi1-x234.google.com (mail-oi1-x234.google.com [IPv6:2607:f8b0:4864:20::234])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4j8mqR4Kb8z2xSD
	for <linux-erofs@lists.ozlabs.org>; Wed, 21 Oct 2026 22:13:21 +1100 (AEDT)
Received: by mail-oi1-x234.google.com with SMTP id 5614622812f47-4e4a4d77e5bso1010262b6e.0
        for <linux-erofs@lists.ozlabs.org>; Wed, 21 Oct 2026 04:13:21 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792581199; cv=none;
        d=google.com; s=arc-20260327;
        b=I+WVt32B8CAu64WWltyitX5RQN2rHFM5T2gob+nL2IVsZNE+cQm7dL+FPGHDDtPEN1
         jGC8+cG7Rwb/9i9C2dnz0mM3NTmhjFRXvSQxGW2JQ+TOOHw7lxMj8+YdFZ1bDqb5QcAd
         LYXtfyq3ptb2PB/6VHtqblcvJz8TmXQ8Ri46tLqEy++Cdu7+SKmBX+JOxM0EBON+EXgr
         0ePzjBxLpKaXmRAOgglO2kfB77uQiHR2WYWHTVyrzZJ78WfliaeMj87pV4DTy80hRiXh
         6bIiIUNr0NCNzCXn5rBLsSss/sCLuGCufvou5DBJc5Y7Dsi3a7ItsMnLIG08JWQJClrP
         yvyg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=to:subject:message-id:date:mime-version:user-agent:from
         :dkim-signature;
        bh=kFbBv6KaAF56ARAdsMlSPfR4+M2Bdd/eIPH1CMzioTg=;
        fh=wOhGMmq2KH+KOElLlPuS8ws9o9ArjDb4wH58JVHh4Vg=;
        b=EVTQK+sux93clOaouSTba3L9thmwGoSj090ZeZoLThyvtwPL5F5fkMpyBFopCewGgf
         d+HPoRWQAPqwnkS6lY794tPKNjpp8jfq3PDaMSIyoJJuBC3FfbgZhzJUjiBOkmAXld/M
         l3t3ghP47P7I1BwsJeQX7vW/1uOJoP9EO2dDiblOZ0MEETet0pkD1cAFZcDJU6f4koXg
         6MC+LawsmrqXQvQTkyUnxfbHuBxr7CnPJiwuWI0eSaGKZJn6elN5wgYulNrA5RjZmnVu
         uB8NqUmnKQSPsCVx34mcqb65VVy1GeOKDELoSXM/vlXA9jTkXkZnqx9ApGURpRz6ddwd
         yHGQ==;
        darn=lists.ozlabs.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=raspberrypi.com; s=google; t=1792581199; x=1793185999; darn=lists.ozlabs.org;
        h=content-type:to:subject:message-id:date:mime-version:user-agent
         :from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=kFbBv6KaAF56ARAdsMlSPfR4+M2Bdd/eIPH1CMzioTg=;
        b=TnvI/MaHSbDdBLOQ0Ec7JpANoACydu4mBV3uJ2Swv24639PRJVYwFbzC5PSUsxG1m2
         IfN3DtoXVcpvcdrbLEAGY6xw4K/marvtUafNN85usFTHITMd/zZTo08nb0QiB2NTeoJa
         Oa03/c4tCYbKJjz8eYFPG7FS8bUG1O7g/pBnZd9VimbfEXb5AROdNOkqw9ZcuYZkheWx
         rXE+onSyUr1Tm4zZFgUHNrLfVGc0EPmkiOlMQPF6oGa+ZwOOVooss48WvnMAIwEOq6tm
         9IUJyrsFSFmS6BkX3RCPpQ1EMGsn5QpJHrICR1cQqQtpoiZNmtxJFbGLS71n6vkFKvTG
         cr/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792581199; x=1793185999;
        h=content-type:to:subject:message-id:date:mime-version:user-agent
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=kFbBv6KaAF56ARAdsMlSPfR4+M2Bdd/eIPH1CMzioTg=;
        b=oNJvZHjXRsJklobJGPD0xI1tDC+V0jZdMneuuSk8yNWF3I4CJdWH+9bomjw+qCTyoT
         8yC4Iu+yVIJuhkndbbiP5JPA5/5bh7mF8x1fiqx+EHtoUU+qd4gkhtWLW0inZuqROG7O
         U/t2R/redkejzyvC+QHPu0atq2EA0vj18CIfUUXHZyc9dfuo2zI1XzGCDRuIbPsJGU5B
         BGs7g0QtKxsVdiH/8Q0odjKhSp7aOLEB2LZb3DNK5H4Z099dRi1JPryqmqu7sEN/foWM
         WiaIyLQ+iq0zMY7k8uK40S4Dl6rLsvdme4Fg6ON6uTK9XhsdNNgKeyedV74ZS+PB6N77
         R1pQ==
X-Gm-Message-State: AFq9FYLBxZKoDrcdUcHeKd1EOubYmhGtfzKlanTTg6FexpOcCIHepwh+
	kgl1bqFKiXBcvjEos5JX67PMj4gY9l4O8xCdXUBDBuDOwFVJA0TjxuaSuOpdmcmqHlNo0MTwWz2
	fGNt+vb4SsyuToyjPvFhhMEDxGg1FO727pEvVOpUwRRzYqJ7Uf+LWxsQ=
X-Gm-Gg: AYBFou1jbF8JsQXmY3GymxsP1xzk4MgpVdnpC4ZC2avJhMuDP5s6J3uc8chbErG+HqH
	ShzfYgO0T4eVWXdsfOf44dd60Oj/uLJKcY1rjruit1nJAXW44vv8y4wpYuPGWHwtzQK6nifVKTq
	el/Nbj5GS01ZZ6Pf+u9qwaFFz4cgLvJ1mWcAS4zyiuWslB5v9OIKH6Y4OPDkqJph6BkWhqG2knq
	9YxI9WH2ndEAuUbcchPh3dXy3dwTd6f6rdXP1kiHnwnB83WDj5GuCt3gmg+Y1MGvKfBUKaQtImJ
	nHyrekIj2LRBJTYumRGRe8RphTVYBjfYBYd7TpU2rn7Yz7o8bkhkbAfhuD0thReL64aI1J7TGNx
	BtvkkmS3QlgNNxc6tpGk2mZ7K7/rhvBHFUnZH+H6LGEyUWB93PA9HaYhIJaLvHZU3vCxV
X-Received: by 2002:a05:6808:c298:b0:4f0:2d60:f0f4 with SMTP id
 5614622812f47-54d90fa814fmr3031571b6e.17.1792581199321; Wed, 21 Oct 2026
 04:13:19 -0700 (PDT)
Received: from 753933720722 named unknown by gmailapi.google.com with
 HTTPREST; Wed, 21 Oct 2026 07:13:18 -0400
Received: from 753933720722 named unknown by gmailapi.google.com with
 HTTPREST; Wed, 21 Oct 2026 07:13:18 -0400
From: Matthew Lear <matthew.lear@raspberrypi.com>
User-Agent: Notmuch/0.38.3 (https://notmuchmail.org)
X-Mailing-List: linux-erofs@lists.ozlabs.org
List-Id: <linux-erofs.lists.ozlabs.org>
List-Help: <mailto:linux-erofs+help@lists.ozlabs.org>
List-Owner: <mailto:linux-erofs+owner@lists.ozlabs.org>
List-Post: <mailto:linux-erofs@lists.ozlabs.org>
List-Subscribe: <mailto:linux-erofs+subscribe@lists.ozlabs.org>,
  <mailto:linux-erofs+subscribe-digest@lists.ozlabs.org>,
  <mailto:linux-erofs+subscribe-nomail@lists.ozlabs.org>
Precedence: list
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Date: Wed, 21 Oct 2026 07:13:18 -0400
X-Gm-Features: AclHuK_BRSRjgm2vmTyt9rPf52BHkO4MjmuoqyBVzoKzfC5obmiembngTubYXVU
Message-ID: <CAPrOGNCUbo82kEnriuO1UAn+EA5+xZS6EMkAZYgRbgW8afb9eg@mail.gmail.com>
Subject: mkfs.erofs: --incremental=data segfaults when appending without -z to
 compressed image
To: linux-erofs@lists.ozlabs.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi,
I've been experimenting with appending to a base erofs image to try and
optimise for in-place updates. By appending 'volatile' paths (which are
anticipated to change more frequently between updates) at the end of
the image, the amount of write IO the device will sustain when applying
the update is reduced. I've noticed that if appending an erofs image
created without -z to a base that was created with -z, mkfs.erofs
segfaults. The compression scheme does not matter (I tested zstd, lzma
and deflate).

The reverse is not true - an uncompressed base with a -z append is successful.
In that case, fsck passes, contents seem intact, the superblock gains
the compression feature and the appended files appear to be stored
compressed. The failure only happens one-way.

I've seen this on an arm64 box (Raspberry Pi 5) but it also happens on
my x86 box, too:

Versions
- erofs-utils 1.9.4
- dev at 27a171f (1.9.4-g27a171f5)

Environment: x86_64, Ubuntu 24.04, gcc 13.3.0, libzstd 1.5.5, liblzma
5.4.5

Configured with:
--with-libzstd --without-selinux --enable-multithreading
--disable-static --disable-fuse MAX_BLOCK_SIZE=16384

plus --disable-lzma for the zstd and deflate runs (LZMA enabled for the
lzma runs).

Reproduce with:

mkdir -p b a
echo base > b/f
head -c 4097 /dev/zero > a/g

mkfs.erofs -zzstd i.erofs b
mkfs.erofs --incremental=data i.erofs a

Backtrace below:

Thread 2 "mkfs.erofs" received signal SIGSEGV, Segmentation fault.
#0  erofs_compress_destsize (c=0x555556177390, src=..., srcsize=...,
dst=<g_dstbuf+4096>, dstsize=4096) at compressor.c:82
#1  __z_erofs_compress_one (e=<optimised out>, ctx=<sctx>) at compress.c:634
#2  z_erofs_compress_one (ctx=<sctx>) at compress.c:796
#3  z_erofs_compress_segment (ctx=<sctx>, offset=18446744073709551615,
pstart=4096) at compress.c:1379
#4  erofs_write_compressed_file (ictx=<optimised out>) at compress.c:2172
#5  erofs_mkfs_job_write_file (...) at inode.c:1534
#6  erofs_mkfs_handle_nondirectory (...) at inode.c:1594
#7  erofs_mkfs_jobfn (...) at inode.c:1666
#8  z_erofs_mt_dfops_worker (...) at inode.c:1741

It occurs with zstd, lzma and deflate bases, and with both -b 4096 and
-b 16384.
Appending with a different compression algo fails cleanly, eg:

zstd base + -zlzma append:  <E> erofs: unavailable algorithms 0x2 on
incremental builds
lzma base + -zzstd append:  <E> erofs: unavailable algorithms 0x8 on
incremental builds

Regards,
--  Matt

