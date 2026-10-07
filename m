Return-Path: <linux-erofs+bounces-4669-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4D463CA6007
	for <linux-erofs@archiver.kernel.org>; Wed,  7 Oct 2026 14:58:29 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4j0GTb3FXGz2yVM;
	Thu, 08 Oct 2026 01:58:27 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=pass smtp.remote-ip="2001:4860:4864:20::2e" arc.chain=google.com
ARC-Seal: i=2; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1791385107;
	cv=pass; b=eUR7qFJnDyOA1bLH4/gc/upzrAT9naPxaDmK/jyxHe4sR30KchxVQyakH/U5puNyEYyn/SWMMHxzoadfuYiDJBIG7SpzEHdEPWk47IK6bNhl4KaIBjPFvZd8ahXvZDKfGhyPyq0v+No438uuHeLGbnIVcbhr4W0csTB5VFf5CCJdyySJ5n6fqTbP6wZnzppnZgsjqluE2Vwqc/6aBpVno6mkpR84qKEpjfasEZW3JNy5VNH1BTzFMfeDuEjstUeSzmpvdeQ/yPuVACm8NHCG1ssgptPO7CHhbw+LQQEyWfBGm5rhXdEH9GjZ8dJB015Slg2NxZ5VSFbxeOEPf1Y+ww==
ARC-Message-Signature: i=2; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1791385107; c=relaxed/relaxed;
	bh=rjACXNpXFIHU5vxxqqu3/indMtYVs8kP3jUUIRw+wfI=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=mWr2H+hNI7bHARYik1cu5IK92ihfMgGY8CppUsMHIp5d2Hhsf4MecH34coAgARDInvUL5V3txHo3jWp81W2qPZs69T0FSZsNrVsoqHFvSF6wexxr8CuWyj8DFYwmPdty4VFCNEm+4kDp3Yw0ISD1F9oyIeSi9jK0ksV2W51DEuRbVicdCDD39WNtBQLtVGNYYmddkEqF3gMXwuXlnUGKbaYUmADZkevRBwgtfhmicVaAl226wdoNoWl28cCIIaePu+XzertUZYuGCvxpNZqH51uI50ftpJvIoWuUH/CyJZTgMWzXQzOkEMdjXT4mkpu2MU03wKnzZr+m2Ykr+Hqe7A==
ARC-Authentication-Results: i=2; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=gmail.com; dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=dQyJKnOI; dkim-atps=neutral; spf=pass (client-ip=2001:4860:4864:20::2e; helo=mail-oa1-x2e.google.com; envelope-from=peacherwu969@gmail.com; receiver=lists.ozlabs.org) smtp.mailfrom=gmail.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=dQyJKnOI;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=gmail.com (client-ip=2001:4860:4864:20::2e; helo=mail-oa1-x2e.google.com; envelope-from=peacherwu969@gmail.com; receiver=lists.ozlabs.org)
Received: from mail-oa1-x2e.google.com (mail-oa1-x2e.google.com [IPv6:2001:4860:4864:20::2e])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4j0GTZ06cHz2yK7
	for <linux-erofs@lists.ozlabs.org>; Thu, 08 Oct 2026 01:58:24 +1100 (AEDT)
Received: by mail-oa1-x2e.google.com with SMTP id 586e51a60fabf-490d838b425so1049939fac.3
        for <linux-erofs@lists.ozlabs.org>; Wed, 07 Oct 2026 07:58:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1791385102; cv=none;
        d=google.com; s=arc-20260327;
        b=WoUaQ1o/+dcXAz0bIWyGmzTMXzJGJ/w/PMuWT9lrkmSUtSFrxcvfaHquCxsgExA5aD
         Fz3AFZyUKXU6T5sGnMpRRUHC2MI7euA8yIAKdlNt9AK7SOlF+7b6muIhYlK1f+GwMgOw
         vmvlnal3Yf8IcolPK4yLMunXmCL4dGiKter6USlmMJTi/7apqBbKDeXTRLLM0koRxrCJ
         PxGSEIZmpm/aRAWJ8kFAm9M9mt3dFuj28gB1l1o4sG4viOwtv3IEvcnSLyOxZUpPKbMe
         +wXl7TFwBKmb18sn24PCLpuBiSmJY0jHXu+XSKDDmR8VqcgULul4LqtaqGzaUcNWixG5
         BwUA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=rjACXNpXFIHU5vxxqqu3/indMtYVs8kP3jUUIRw+wfI=;
        fh=DskKVsJdOaxCQLgu8OUIVTo70erYeVegBhHB4RZU4pg=;
        b=E26hyEwSYimkeqQjLfCdqSMQ4TGP5tM/PCznsqa2w3VSUBufMhqWC8woxvhdupcJJW
         8laRygl3O6BJBjnpXoHPy/JnOjhYnpnt57R04RYEC4pQOQbZWuDbfpEFP/MSB07liVIf
         QDADaPYEQ/svAl46xcgswby6+zmTzMscqAfA56wFOn85vlidkh+OrAqyB2JippHlzI+x
         /DzI9cvZVzyjNDr2V4S+SoV6ugDwKWUjtDxdXDH2hsvDR6OwISjQvpHAeBeJgwLosbC9
         l6Clj7HXhSJ3NIE3xEaErjNskwdLPLeXs3P8wwvMnUdIRvHxJ9Z9s1DDgRr+DAinS8x8
         a/Tw==;
        darn=lists.ozlabs.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791385102; x=1791989902; darn=lists.ozlabs.org;
        h=content-type:cc:to:subject:message-id:date:from:mime-version:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=rjACXNpXFIHU5vxxqqu3/indMtYVs8kP3jUUIRw+wfI=;
        b=dQyJKnOIzQAsqQIbj0k9gAgkSMyL/L7AcIsvyG+yIKoYwOVeJEFRCF17f5NUoU1Tf5
         k1jhA1YyR/P80NCie9dUTFh2bDEC5A9OEPkYbthcUmo9CISl1k36GmIyOS+S4/+gcz2I
         JGdrTU/X/6o7/fGdukCa/ebZ59NSLEGTevNmjVbxQ7m6XNl2esQpIZvsUpHan9Tf8J1B
         aQ7+6R4zBTrdz2Hn5uMn4YBAWD1tOhUPN00TNxVyGWIn08d7ipPGK79t8IZL7ZWJ7wF9
         kN1J9i3FRwSqo4yWnqfbaZT8/zlB2Dy8QGONQ4TxWDZmISJfL5JnvZhEViKHhmcXf/mT
         kQCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791385102; x=1791989902;
        h=content-type:cc:to:subject:message-id:date:from:mime-version
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=rjACXNpXFIHU5vxxqqu3/indMtYVs8kP3jUUIRw+wfI=;
        b=MlAjlBEi6CjTc6RhwzGQRObsuYgPkPnMt7vxqZ47SqaIL3faYojK6jXyog9ZZq/OOj
         ONdcop9zx2onLp4IJoNEmyE5gMkBXH3MaEg44+KA+CFukZRQ5UVwf+JkLibQBobZDqW8
         IOAynyNPpUmsCyXKyRwSvLcOLyW3+kyqWl3Y9uo+ivbKxnXACuWEHzdHwds6Mx+3e1yg
         6BK7kiP7B96h+cwe4o+kndrRieYNCEi6vLuFt1urtcHsPEeAav+NKcDM/UKdV24T8nKt
         lzgrZWssd35f/oQ1Sl8EQgtFD5xPpfp+jnDqbCnCCsl67Tu5ZwT6NpJK5Yk6LvlK4trm
         nh4g==
X-Gm-Message-State: AFq9FYK24xxfuVhVsS0W5/BhdE0C3GGCZ2qfmx6WZ8GCY0/jhPARvZVE
	eoBL4EnhWmhlX93Ksr5BHP1JC0IX8H7nrij9p1v6xeY8vZhNNdhiNYxhDB1+JfOVII5/qZEHVmY
	Qc8BzHFXmhdb7I7OCMFbUH5iN65b7MxA0vQ6710Ui2wyf2Cc=
X-Gm-Gg: AYBFou0A1PwvmQgrwitIrcMWxSxNB4/6gKsh0QkLD/sTrPZROWwzWd4jPtyAlmGdAPv
	PEtuKWYWA2n7YJYdnU+447aTgOmKk1pZCOMzzeK4uMy1B9ZwZnvmvxQ7E5AF6EtopMO7to2O2ai
	mXakXT55uyWBsP75J4ePVqQs2amGO368p2UkIAx8Cr3VWMxMDkWc1MQLsAbaKnF3/I6izYBwF1c
	7rvZ0426fiEq4cfPMVrvLNMfqu4mEIEyf4LLxVTG/QT2Z2wDcK0Krx1yiu9nE3CQmB7n66OoreM
	D+WnHa1ublYnDyHfZeHbp4tRwUvAWQxOS/WkHBU6kAiKcKkjcXuHhQ6xd+r2ajLO4htgB6erSnb
	CbBji098/moW+
X-Received: by 2002:a05:6870:40c1:b0:48f:e107:3183 with SMTP id
 586e51a60fabf-4a259689edamr2404922fac.54.1791385102018; Wed, 07 Oct 2026
 07:58:22 -0700 (PDT)
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
From: peacherwu <peacherwu969@gmail.com>
Date: Wed, 7 Oct 2026 22:58:10 +0800
X-Gm-Features: AclHuK_YUtUfuxdOVlA6bz8zqDiYbbbPOvkxF3XZaXvdQJNOVR8Q3HUIjL83z0E
Message-ID: <CAOisCUPoZyE7TBoEW_O=06cJSCrMZSzBEzLaKMRKtvffB3pqdw@mail.gmail.com>
Subject: [RFC] AceDelta: OTA delta for EROFS images, 30-40% smaller than AOSP
 17 delta_generator
To: linux-erofs@lists.ozlabs.org
Cc: hsiangkao@linux.alibaba.com, chao@kernel.org
Content-Type: multipart/alternative; boundary="000000000000a96c33065d415872"

--000000000000a96c33065d415872
Content-Type: text/plain; charset="UTF-8"

Hi,

I'd like to share results of an alternative OTA delta generator/applier
for EROFS partition images.

AceDelta diffs whole EROFS partitions (system, vendor, odm, my_* etc.) at
file level, recompressing lz4 clusters on apply. Compared with AOSP 17
delta_generator (minor_version 10, -enable_lz4diff)
on seven real consecutive-build pairs from five phones:

  Device / builds                    AOSP MB  AceDelta MB  Reduction
  OnePlus 15      A.22 -> A.27        1152.6      683.7      40.7%
  OPPO Find X8 Pro C.76 -> C.79       1059.1      733.1      30.8%
  Xiaomi 15 Pro   2.0.105 -> 2.0.214  1038.6      655.6      36.9%
  Xiaomi 15 Pro   3.0.3 -> 3.0.7       833.4      490.4      41.2%
  Xiaomi 15 Pro   2.0.214 -> 3.0.3    2657.9     1685.8      36.6%
  Nubia Z80 Ultra 16.0.12 -> 16.0.16   767.9      514.7      33.0%
  Realme GT8 Pro  A.68 -> A.71        1268.9      878.1      30.8%

Generation is ~2.5x faster than delta_generator; apply time (on PC) is
about the same (single-thread 8% slower, multi-thread 20% faster using more
RAM). Hash tree and FEC are
regenerated at apply time by my own implementations. Detailed info, plus
Linux evaluation binaries:

  https://github.com/peacherwu969/acedelta

A question for EROFS people. Both AOSP (lz4diff) and AceDelta must
reproduce the lz4 compression exactly; mismatches are patched with small
fixups. Although AceDelta is doing better than AOSP in fixup sizes through
lots of experiments, it's still like shooting in the dark. Is there a more
systematic way that ensures exactness?

Is there an EROFS WeChat group I could join?

Thanks,
--Peacher

--000000000000a96c33065d415872
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Hi,<br><br>I&#39;d like to share results of an alternative=
 OTA delta generator/applier<br>for EROFS partition images.<br><br>AceDelta=
 diffs whole EROFS partitions (system, vendor, odm, my_* etc.) at file leve=
l, recompressing lz4 clusters on apply. Compared with AOSP 17 delta_generat=
or (minor_version 10, -enable_lz4diff)<br>on seven real consecutive-build p=
airs from five phones:<br><br><font face=3D"monospace">=C2=A0 Device / buil=
ds =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0AOS=
P MB =C2=A0AceDelta MB =C2=A0Reduction<br>=C2=A0 OnePlus 15 =C2=A0 =C2=A0 =
=C2=A0A.22 -&gt; A.27 =C2=A0 =C2=A0 =C2=A0 =C2=A01152.6 =C2=A0 =C2=A0 =C2=
=A0683.7 =C2=A0 =C2=A0 =C2=A040.7%<br>=C2=A0 OPPO Find X8 Pro C.76 -&gt; C.=
79 =C2=A0 =C2=A0 =C2=A0 1059.1 =C2=A0 =C2=A0 =C2=A0733.1 =C2=A0 =C2=A0 =C2=
=A030.8%<br>=C2=A0 Xiaomi 15 Pro =C2=A0 2.0.105 -&gt; 2.0.214 =C2=A01038.6 =
=C2=A0 =C2=A0 =C2=A0655.6 =C2=A0 =C2=A0 =C2=A036.9%<br>=C2=A0 Xiaomi 15 Pro=
 =C2=A0 3.0.3 -&gt; 3.0.7 =C2=A0 =C2=A0 =C2=A0 833.4 =C2=A0 =C2=A0 =C2=A049=
0.4 =C2=A0 =C2=A0 =C2=A041.2%<br>=C2=A0 Xiaomi 15 Pro =C2=A0 2.0.214 -&gt; =
3.0.3 =C2=A0 =C2=A02657.9 =C2=A0 =C2=A0 1685.8 =C2=A0 =C2=A0 =C2=A036.6%<br=
>=C2=A0 Nubia Z80 Ultra 16.0.12 -&gt; 16.0.16 =C2=A0 767.9 =C2=A0 =C2=A0 =
=C2=A0514.7 =C2=A0 =C2=A0 =C2=A033.0%<br>=C2=A0 Realme GT8 Pro =C2=A0A.68 -=
&gt; A.71 =C2=A0 =C2=A0 =C2=A0 =C2=A01268.9 =C2=A0 =C2=A0 =C2=A0878.1 =C2=
=A0 =C2=A0 =C2=A030.8%</font><br>=C2=A0 <br>Generation is ~2.5x faster than=
 delta_generator; apply time (on PC) is about the same (single-thread 8% sl=
ower, multi-thread 20% faster using more RAM). Hash tree and FEC are<br>reg=
enerated at apply time by my own implementations. Detailed info, plus Linux=
 evaluation binaries:<br><br>=C2=A0 <a href=3D"https://github.com/peacherwu=
969/acedelta">https://github.com/peacherwu969/acedelta</a><br><br>A questio=
n for EROFS people. Both AOSP (lz4diff) and AceDelta must reproduce the lz4=
 compression exactly; mismatches are patched with small fixups. Although Ac=
eDelta is doing better than AOSP in fixup sizes through lots of experiments=
, it&#39;s still like shooting in the dark. Is there a more systematic way =
that ensures exactness?<br><br>Is there an EROFS WeChat group I could join?=
<br><br>Thanks,<br>--Peacher</div>

--000000000000a96c33065d415872--

