Return-Path: <linux-erofs+bounces-4734-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 796B7CC6B12
	for <linux-erofs@archiver.kernel.org>; Tue, 13 Oct 2026 15:38:55 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4j3z5V0198z2y8f;
	Wed, 14 Oct 2026 02:38:54 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=pass smtp.remote-ip="2607:f8b0:4864:20::122a" arc.chain=google.com
ARC-Seal: i=2; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1791905933;
	cv=pass; b=omB9vRYQt11T3TQyjirHQ0xxKoMzW+OX+DYYVIPGv0YAaTSsGNBwCXenZOihXnUjLduFUy8XQmIrnzzQ3Fcjl9OQAG6HcEGJ8DHiFgdfs2/hCHmgkV6hEF4SIGoNViqU9uUc+kmGCvkIGSCqINV/Ke3TaFU454svqbha2Dc96Sgo/KJmGrwCzQ3UXZDeTs+aSrS1whLfzTFZE1eLRYBqJ2xlV6ObxPbBRykH9bXk+P+9KriNOCt8XOoql1DZ2QqUjqvdfFWWnm8zh5z5IQDHhSPbwrhQ8q4HgTZJWu/YyEc89V+iIMrd7qEkuJxvgKu5mhRPXZvQvq6vByM2DDwUAA==
ARC-Message-Signature: i=2; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1791905933; c=relaxed/relaxed;
	bh=DhEC5iKGmDT1Q4djHur1UHW6CKfi5NZIESjDQpegjHI=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Content-Type; b=chiBx9Xps9mpttvWmIwVgY1m8boe/sgcA3+tF/r0xcwuoMKhJuimnuFGmTxSquujsXyfAVL2G9/qdniX89QkovI84lON4PHiSFD7GMlSY9779cn0I2muysGMxzflpcESbof4nK7PWvGYkIyoqTAd+T1egKyXZcWI1C2nofxHp1mlXX5B00ebo6D4Z4HnzwuKk8mhV1EGTeGxFHwct8DCPKNQNpgcK29jKe281YhElPfEBkz2A0DWCC9GaIUjhjFkBQKdf26tyOVKgfNORWZ1OsfSpIIMqKhNhDCCU+vH+++BLhDcGlbpd8ybXDIFZddt77LB0kulSjdnZ23FMEWRzQ==
ARC-Authentication-Results: i=2; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=gmail.com; dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=IAHOhpvN; dkim-atps=neutral; spf=pass (client-ip=2607:f8b0:4864:20::122a; helo=mail-dl1-x122a.google.com; envelope-from=hajekmatej21@gmail.com; receiver=lists.ozlabs.org) smtp.mailfrom=gmail.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=IAHOhpvN;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=gmail.com (client-ip=2607:f8b0:4864:20::122a; helo=mail-dl1-x122a.google.com; envelope-from=hajekmatej21@gmail.com; receiver=lists.ozlabs.org)
Received: from mail-dl1-x122a.google.com (mail-dl1-x122a.google.com [IPv6:2607:f8b0:4864:20::122a])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4j3z5S0ZvVz2xwM
	for <linux-erofs@lists.ozlabs.org>; Wed, 14 Oct 2026 02:38:50 +1100 (AEDT)
Received: by mail-dl1-x122a.google.com with SMTP id a92af1059eb24-154e9d2d979so44107c88.1
        for <linux-erofs@lists.ozlabs.org>; Tue, 13 Oct 2026 08:38:50 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1791905928; cv=none;
        d=google.com; s=arc-20260327;
        b=PrmPzUlFEQdbu6Ec+bnPbXeLlVHIPSm6FH/VHLLJ77Jfm5/TVvda9MoWFZQ0KzDSGR
         leqBPrBB1G5L5Oh2iOLcGKVLFQX0BZwt00GXaU31ceXooCyXxDxFFbwAPu2A5Yv54EUS
         T6AqGqHyBkftRlFKTMrwgxdCr91j+n8uGZp7agfmLc/pxdG7sRWIOKTtWznETsoW3qH6
         Vd+839RGr0xzKKgYDEDQe8c32Ma5HtGaIWz6uVwkaQLfClXTZ5aYBrqkceL/SyW0yRrq
         SOHRKNMBRXVOBfhI8eATX9whHrXZGlJ3zDOl/ZvwOF8SLDPGqfdimfOW6X9577zaLYfg
         Wl0A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=DhEC5iKGmDT1Q4djHur1UHW6CKfi5NZIESjDQpegjHI=;
        fh=wOhGMmq2KH+KOElLlPuS8ws9o9ArjDb4wH58JVHh4Vg=;
        b=RPFhq4kC7rWKlJhfpSLCf+Oeu04ctaMKkEZpvpxqoTz5zht/vVOVfyN/k2lG04hglC
         KlDEUshEwGO9ptH6rVjbC0KQswvrFPQ8SyvKLSzAfKoIlOLR7KjkF20Neq9wI9GRP+Wv
         QUe97KtOZ2wQAW443WshEFMaD+fqZISDYSx07K9vH58GeiOkFx1R4Ap/JBHGKgeL5WLD
         cn+MKgRsOmPUeimgJUWfp5MJQULUixI4UNnzLpG/KExCPBEYxtU4L34TmWHZymUCUBDO
         e4XRWqiPYpxomL4NcSSRlkEOHBb6N13iunnx2MwG2OEqjXP2RFde1SNTz19hHTo2GSd3
         PLNw==;
        darn=lists.ozlabs.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791905928; x=1792510728; darn=lists.ozlabs.org;
        h=content-type:to:subject:message-id:date:from:mime-version:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=DhEC5iKGmDT1Q4djHur1UHW6CKfi5NZIESjDQpegjHI=;
        b=IAHOhpvNx9b5ABf6xWPw7QE69Tp7MarMr1uAZRCSMbXeJ/zWyRtUXieptnjjcqh2Yc
         3aGwi6rXlYBf0ym/kZ7+dTKnSGGZ3+/XbX4Q402g6wad8oyL4WMOhf8AT9nH7LDmeE+C
         pQjncctrVo5EEiLV95l8SyZQoGJSRgcEl3PFUfnddaLc0nREtrGMQIp6KLonXFysYVn/
         nIBLufk0WLGlxHGe0B5FIkt1gmczJJfNlJiGebubHxsbuiKJK8vgAoR4SUln6es+85Rv
         MUgGxV5UoTHYwJ9tRTLgyePS2UIYPPkBwsHyQiaTqqo5pbx3zQRrzMKaC+2HORAhIRIx
         DMEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791905928; x=1792510728;
        h=content-type:to:subject:message-id:date:from:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=DhEC5iKGmDT1Q4djHur1UHW6CKfi5NZIESjDQpegjHI=;
        b=iZDNL3Dj1czBbWxbJ/b/+xGJn3i0caGrXfQbRbWaSEe/m2Uo7qqwoB4kdpYINkBIED
         WA6WXQ62DYnMEo+b3WTjtU4G931SmiJZ01grhZhuRfpW2/uSWqEBOa2V3NNMMcnBctS8
         //+BXCKfjXnFPTdvjloTWSq5yV+SnglGcgbgYy2msWNMlF7dCLq/u2PQ6hK0i1pgI6jU
         2Grci2l56ahS4O+wMWnmezcfDrwBUMcnvtNDeHwhk+Q49xUrIiBw3VrS7+Vyrdjt8Xli
         sXv10Tqdv/qA+pYAZPqO0LPJYxS01JkSmYKAABuTjuSC0888TCiAbdQptMFOuJi6L3Vn
         lhzQ==
X-Gm-Message-State: AFq9FYJIsQCMLvrT/g0fuO5NmZ+zVCbuVWbMUcJIbw4IXtHYT0KyLikW
	xluJskkQ/Loywff2H/hqoespP60okI1Pz6smB69177hNDsaLfeZW2/lbkVyPH+kpgJx2L5hupru
	aQWApA7WKkw4VVbzMAqETocQADWE0k89F94PaRfY=
X-Gm-Gg: AYBFou25eTuEmq1uEauK868u0ysi3umgCE/8QyeYA94i+q22bVCHsswJaoMf8Uwg2U5
	5jPTUNSq1euYTP8hVU5cLxaFvUJJ9xLGJbMvQvQHKEg1cd0SCCjOYNWqYm3IVOVMmZxOq0szA5O
	E2oJWkk2qpHcJCpPt/aG9f81Ske3v4DCfZnxeBaVcZYcMPmn4RQzvNqHaYSSK7RSvSl092n9z8Z
	LSktC50OVpc11vuV3+wpURVpFCt2U5uKR4pdhQW2OeX4BKk/17dnJvXXLIXq3WmNlBkEVN5W1gW
	w73av9HFqv2xxZlSDBoYV+zJt5qHUjVwV20bGC4BA5CEQjLygq5jJAvE
X-Received: by 2002:a05:7022:6ba1:b0:143:f79:f679 with SMTP id
 a92af1059eb24-16a550ac0d8mr25082983c88.1.1791905927900; Tue, 13 Oct 2026
 08:38:47 -0700 (PDT)
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
From: =?UTF-8?Q?Mat=C4=9Bj_Haj?= <hajekmatej21@gmail.com>
Date: Tue, 13 Oct 2026 17:38:35 +0200
X-Gm-Features: AclHuK-b0mZHPwYTARUWtIO3_rLtK7kK9fEp5f4jlg1BhwOBMtuLXMf2S0siq2c
Message-ID: <CAEi2J8VjtE1MN3Sih70N6LgZx9TJAF-k1rfHk8y1emk+SZpvXw@mail.gmail.com>
Subject: [BUG] erofs-utils: xattr: initialize shared_xattrs in erofs_xattr_init()
To: linux-erofs@lists.ozlabs.org
Content-Type: multipart/alternative; boundary="0000000000004db36b065dba9c02"

--0000000000004db36b065dba9c02
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

erofs_xattr_init() allocates the xattr manager with malloc() but never
initializes xamgr->shared_xattrs, so it holds uninitialized heap data.
The first shared xattr moved in erofs_cleanxattrs() then does

item->next_shared_xattr =3D xamgr->shared_xattrs;  /* garbage */

which terminates the shared xattr list with a dangling pointer.
erofs_load_shared_xattrs_from_path() walks that list while filling the
fixed-size sorted_n array, runs past the real entries, and dereferences
the garbage pointer -> SIGSEGV and a zero-length output image.

This is normally hidden because the xattr manager is larger than the
dynamic mmap threshold, so malloc() serves it from freshly zeroed
memory.  Once glibc raises that threshold after large allocations are
freed, the manager can come from the main heap with stale contents,
which makes the crash depend on the tree size and allocation history.
It reproduces when packing large Android partitions that pass both
--fs-config-file and --file-contexts (i.e. many shared selinux xattrs).

Initialize xamgr->shared_xattrs to NULL.

Signed-off-by: Mat=C4=9Bj H=C3=A1jek <hajekmatej21@gmail.com>
---
 lib/xattr.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/lib/xattr.c b/lib/xattr.c
index d86d94a..64fc235 100644
--- a/lib/xattr.c
+++ b/lib/xattr.c
@@ -169,6 +169,7 @@ int erofs_xattr_init(struct erofs_sb_info *sbi)
  if (!xamgr)
  return -ENOMEM;

+ xamgr->shared_xattrs =3D NULL;
  for (i =3D 0; i < ARRAY_SIZE(xamgr->hash); ++i)
  init_list_head(&xamgr->hash[i]);
  sbi->xamgr =3D xamgr;
--

--0000000000004db36b065dba9c02
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">erofs_xattr_init() allocates the xattr manager with malloc=
() but never<br>initializes xamgr-&gt;shared_xattrs, so it holds uninitiali=
zed heap data.<br>The first shared xattr moved in erofs_cleanxattrs() then =
does<br><br>	item-&gt;next_shared_xattr =3D xamgr-&gt;shared_xattrs; =C2=A0=
/* garbage */<br><br>which terminates the shared xattr list with a dangling=
 pointer.<br>erofs_load_shared_xattrs_from_path() walks that list while fil=
ling the<br>fixed-size sorted_n array, runs past the real entries, and dere=
ferences<br>the garbage pointer -&gt; SIGSEGV and a zero-length output imag=
e.<br><br>This is normally hidden because the xattr manager is larger than =
the<br>dynamic mmap threshold, so malloc() serves it from freshly zeroed<br=
>memory.=C2=A0 Once glibc raises that threshold after large allocations are=
<br>freed, the manager can come from the main heap with stale contents,<br>=
which makes the crash depend on the tree size and allocation history.<br>It=
 reproduces when packing large Android partitions that pass both<br>--fs-co=
nfig-file and --file-contexts (i.e. many shared selinux xattrs).<br><br>Ini=
tialize xamgr-&gt;shared_xattrs to NULL.<br><br>Signed-off-by: Mat=C4=9Bj H=
=C3=A1jek &lt;<a href=3D"mailto:hajekmatej21@gmail.com">hajekmatej21@gmail.=
com</a>&gt;<br>---<br>=C2=A0lib/xattr.c | 1 +<br>=C2=A01 file changed, 1 in=
sertion(+)<br><br>diff --git a/lib/xattr.c b/lib/xattr.c<br>index d86d94a..=
64fc235 100644<br>--- a/lib/xattr.c<br>+++ b/lib/xattr.c<br>@@ -169,6 +169,=
7 @@ int erofs_xattr_init(struct erofs_sb_info *sbi)<br>=C2=A0	if (!xamgr)<=
br>=C2=A0		return -ENOMEM;<br>=C2=A0<br>+	xamgr-&gt;shared_xattrs =3D NULL;=
<br>=C2=A0	for (i =3D 0; i &lt; ARRAY_SIZE(xamgr-&gt;hash); ++i)<br>=C2=A0	=
	init_list_head(&amp;xamgr-&gt;hash[i]);<br>=C2=A0	sbi-&gt;xamgr =3D xamgr;=
<br>-- </div>

--0000000000004db36b065dba9c02--

