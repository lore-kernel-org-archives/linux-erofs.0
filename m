Return-Path: <linux-erofs+bounces-4534-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 21E57C88E41
	for <linux-erofs@archiver.kernel.org>; Fri, 11 Sep 2026 04:17:13 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hh1Tg5WD5z2y2b;
	Fri, 11 Sep 2026 14:17:11 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=pass smtp.remote-ip="2607:f8b0:4864:39::10" arc.chain=google.com
ARC-Seal: i=2; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1789100231;
	cv=pass; b=eGigoMT0isTB1lmLgWClqzth8Qa0bBxzKjflgqQyVRc0x/NnY/1em5G4PEcwIax7H+Mu7hXKFRSrGuZ7CrYEQ9BTYIy61+Es/DfxZrf2jKc3vqBjnd2wXQKlsJE3Se8gUqVcukIcKPbzB5MQcfA8Kja/cZSDheSnG+WUvfGCgs/evapB6/bQ02B1FM5/uJMG28BCS4UktkJlLR29XgViGGjMV8nkBl9QRdUkM0u8G2cRIKnwGs3fh1hFqZPcjytsJN5HhdmXlOruucelQWVuXBuavdO93fe5AFx76S3FgX1ILWmbCIvz6CDH4PAhq8s7AKjyEo+XMdSe8QBLNhK1Wg==
ARC-Message-Signature: i=2; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1789100231; c=relaxed/relaxed;
	bh=km0lnNTmwXrZJKXp2ynu4K02G4DzAWFfmBysMl3cUEs=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=OM5fLE+CL/C3hDcQK5gzhwJkN0ofSxnFrSuTK+QzZA5s4M/RBq35fh4IlxsbYHQUvOsXv5tqoib2I/IlZL4rHDj2uJklU3PbA+OhBX0APA9SXFB1NXA2sV/nXA255MmW/U4pEb08lT8VmMXLv0ODfRm7L5mK/P/V4quSjdFpbqe+JaJ7Z2oQEL2uTOfnnAvnwjVsqLXDeZYjRIpkdq1nXj1Uaqy2A80oTg6bvA6mpQXIO3BHk/uzlMcv9J95pyiRIlPY4oCG4f7KcuIcTUPQnTIpTmB61Rl68DkdRCWbR96c5ZK8H827LhWpfa7Wyv+5dN+gXDDIIOiLfjDC9KTyig==
ARC-Authentication-Results: i=2; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=gmail.com; dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=fIpYskAB; dkim-atps=neutral; spf=pass (client-ip=2607:f8b0:4864:39::10; helo=mail-pj2-x10.google.com; envelope-from=l3b2w1@gmail.com; receiver=lists.ozlabs.org) smtp.mailfrom=gmail.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=fIpYskAB;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=gmail.com (client-ip=2607:f8b0:4864:39::10; helo=mail-pj2-x10.google.com; envelope-from=l3b2w1@gmail.com; receiver=lists.ozlabs.org)
Received: from mail-pj2-x10.google.com (mail-pj2-x10.google.com [IPv6:2607:f8b0:4864:39::10])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hh1Tf6qrXz2xRs
	for <linux-erofs@lists.ozlabs.org>; Fri, 11 Sep 2026 14:17:10 +1000 (AEST)
Received: by mail-pj2-x10.google.com with SMTP id d9443c01a7336-2d90ba1d807so5023275ad.3
        for <linux-erofs@lists.ozlabs.org>; Thu, 10 Sep 2026 21:17:10 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789100229; cv=none;
        d=google.com; s=arc-20260327;
        b=AKbqH94NJ8BHnL+0/zwY307ff+sahYu283gtEyEEoF7YBVxlRnqpVIolyM3JjiOm1A
         ClfzWJNxceVWN1jPi1thVFKv9FKT8tMELmkn6veqnB3JuM46Yo8saKDSL/2vH+4Wx8TH
         q5XGKdjo5vKm74laOUY6Yj/NtkUvSu8L9C1Kez/RbujPZmFc2826kjITXOaZI6E/PS5D
         MsjfC60McoLCci0FOH1bNcGx3Y58KhEehoJxOg+5BekOwanA5u2hPpOAiKqot4FU65qu
         jg56YNT4wQh706D3rb6KmSaEYvqGVMewwS89a0oHN171HSbfFvcus4lK6JDjEHjqyXF/
         hrsw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=km0lnNTmwXrZJKXp2ynu4K02G4DzAWFfmBysMl3cUEs=;
        fh=6evFzj904WkCtkIMBHchS3ApakVf2PDvpmNGr3cxXsg=;
        b=kkYg0p6PELXqtMLmfYB7gsMN+39WMBg97ufmes3im5ma6a8KkNwRDrRl9908P5JnEv
         +DX1Rci8Y7TCi4HaKUs/tDtvTQaia5WQYyeZcHNTr2ZuGUbTShttaZO74Nz+fgJmv183
         4TkEkxZNswnJDENQ2IPbDLXpWak4a39Q7MJXknCMmsMRvOonLIMc5d+9YIMk+ZZlqzcC
         JUZjtwxH0mXR29D56fujkhs09k2KvIdXv08fzZgfrQ2wjD318TmqyhWfMwwvetdMp7mj
         tYuXXyVFYQ8BJWE3GMVIYVK/HDVrBLCh2VJSEbq3tCecfRUjwIT5JiqbJOIabCzLF+QE
         cpig==;
        darn=lists.ozlabs.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789100229; x=1789705029; darn=lists.ozlabs.org;
        h=content-type:cc:to:subject:message-id:date:from:mime-version:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=km0lnNTmwXrZJKXp2ynu4K02G4DzAWFfmBysMl3cUEs=;
        b=fIpYskABQcp99us1ldDM9A3m4wcDkyDMbLWS6xiSQjTHQOsKYQcoMN2LSXzw6N3Q3C
         hhz+L3XxwWqd2463sYWHidu6KbsvBx0A6ckg+T3fx+rm+5JoFVu2E5LeG+STFQ3UmhS/
         zHip51vskjbEMrgJuWwDm5KbfZJuBBsldbFckcjEnS0WmLPRHkB1htiLkAmEu8VoVAoE
         PnaOU7VI4UD/w1OvYK3movGHNgQtzSHvB1ThLKAm5khDg7kXdu/V23noYYsbWNeqN6ik
         GRTLcfQdZCWQeBsnwtB8yjx9m9JooWo4zwxaBRVzXYFQ4D5MM1/1cydkTnviUqxQcpBI
         sk7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789100229; x=1789705029;
        h=content-type:cc:to:subject:message-id:date:from:mime-version
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=km0lnNTmwXrZJKXp2ynu4K02G4DzAWFfmBysMl3cUEs=;
        b=B8Sw8p9syMhMdSyIieONmlJvjADf9eK/88KKSze/zzbZ4IzMMSx4VrRsdYhW8Uemoo
         Y0113eIV2t2fFXzCKU1zJpvf7Ys503w1NzmODktAn9zQZg9gxQ8hZnVRkB/8062OXaLM
         hSlP9F1j9ERQWpbJjvWj0OyTvBkorVQfin6/gOeg/tdOuk6zAk/K+/0/9gIk+LwFahz7
         hYqpk7hBp/K+wKvBOrS74DKSxh6UZpnBk3b/6qX3YNmKbrfTrTPVPWK4AtKqcGgnlI31
         Y8hdRz0Nh+dtep7dN+TNpbOzOdSa/2ur+slLXtMmmleAdwr2bRw505fVIi80JwJkqADy
         NV8g==
X-Gm-Message-State: AFuF++nl8IhW+kgw6Uj3+iim0mUP+aEGcyzkB0lPv4+I4OEV0Uc9Psuw
	xeHAd0hhjMCMZ3vxf4csQj1WOVjTma+AmkiF+8jyGR3XvhU7T/D3UOAXFM8Td/B4xotmHjFXoCD
	fLDy6S0rarNSN1eAxowqMKSiuVuT2hV0JvjkiCTQ=
X-Gm-Gg: AYBFou0dWRMGVtoRYX/mll9W7xh9kecWoj9lfvkKtENN6YXFM1/fHFfbsq50q3jaWQU
	VYQKrl/28bUvH1L4Q6nuQnUQ9DL/RWj/k/G8UHfhPKmfYIkcnRXlvlfU4Sc3de4EjJNUqnESjdz
	dVxDij4UNOTzYYyACmnhPBUca01CicnaXSi5lkuw13x8ZUuW8iZdwMRrd9TpTY+siVV2sXV22Tz
	CaUrR/Q++HNJN2CWk9Gv8S1Mj0IfmTjip116Jd8wXvJsL61MySlWi6r3qcf6avscraFS2WZE1yu
	+krUC4FsmSytW5j0HhTm9oubLLwNcIMORnGLs9LHtiJnpTlqoESfPrs=
X-Received: by 2002:a17:90b:574b:b0:39d:985b:4274 with SMTP id
 98e67ed59e1d1-39d9bc66ac4mr3488185a91.5.1789100228672; Thu, 10 Sep 2026
 21:17:08 -0700 (PDT)
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
From: binglei wang <l3b2w1@gmail.com>
Date: Fri, 11 Sep 2026 12:16:56 +0800
X-Gm-Features: AcwNN1U5n7Gt4fUQm8gTktRc2SC1mnvo_2rRnpwNo6vKgs9wfT6sR5OzFIpho-4
Message-ID: <CAJ3C4Kwms2my+y_T0Mx+XM_gb9gs7cVZ7w4v2GRAURF1rRFU0g@mail.gmail.com>
Subject: [PATCH] erofs: fix unbalanced buf->off handling in erofs_bread()
To: linux-erofs@lists.ozlabs.org
Cc: xiang@kernel.org, chao@kernel.org, shengyong1@xiaomi.com, 
	zbestahu@gmail.com, jefflexu@linux.alibaba.com, dhavale@google.com, 
	hongbohbli@tencent.com, guochunhai@vivo.com, wangshuai12@xiaomi.com, 
	linux-kernel@vger.kernel.org
Content-Type: multipart/alternative; boundary="00000000000098ff68065b2d5b09"

--00000000000098ff68065b2d5b09
Content-Type: text/plain; charset="UTF-8"

erofs_bread() locates the target folio with

 index = (buf->off + offset) >> PAGE_SHIFT;

but computes the in-folio offset without taking buf->off into account:

 return buf->base + (offset & ~PAGE_MASK);

If buf->off is not page-aligned, the returned pointer misses the in-page
component of buf->off, so callers end up fetching data from a wrong
offset.

buf->off is set to sbi->dif0.fsoff in erofs_init_metabuf(), and fsoff can
be specified via the "fsoffset=" mount option, which only requires
block-size alignment. Therefore, on an image with a sub-page block size
(e.g. 512 bytes), a non-page-aligned fsoff (e.g. 512) triggers the issue,
since 512 is a multiple of the block size but not of PAGE_SIZE.

It can be reproduced by mounting an image that is placed at a
non-page-aligned offset:

 mkfs.erofs -b512 -zlz4hc sub.erofs src/
 # prepend 512 bytes of padding to the image
 mount -t erofs -o loop,fsoffset=512 padded.erofs /mnt

which fails with

 erofs (device loop0): cannot find valid erofs superblock

because the on-disk superblock (at offset 1024 within the image, i.e.
1536 within the padded file) is read from a wrong in-folio offset. With
this fixed, the very same image mounts successfully and its file contents
match those read from the unpadded image.

Fix it by including buf->off in the in-folio offset calculation, so that
it is consistent with the folio index calculation.

Fixes: c36ec00d7f67 ("erofs: add 'fsoffset' mount option to specify
filesystem offset")
Cc: <stable@vger.kernel.org> # 6.16+
Signed-off-by: Binglei Wang <l3b2w1@gmail.com>
---
 fs/erofs/data.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/erofs/data.c b/fs/erofs/data.c
index 0885b1f2fc92..be63b89f0862 100644
--- a/fs/erofs/data.c
+++ b/fs/erofs/data.c
@@ -48,7 +48,7 @@ void *erofs_bread(struct erofs_buf *buf, erofs_off_t
offset, bool need_kmap)
   return NULL;
  if (!buf->base)
   buf->base = kmap_local_page(buf->page);
- return buf->base + (offset & ~PAGE_MASK);
+ return buf->base + ((buf->off + offset) & ~PAGE_MASK);
 }

 int erofs_init_metabuf(struct erofs_buf *buf, struct super_block *sb,
-- 
2.33.0

--00000000000098ff68065b2d5b09
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">erofs_bread() locates the target folio with<br><br>=C2=A0i=
ndex =3D (buf-&gt;off + offset) &gt;&gt; PAGE_SHIFT;<br><br>but computes th=
e in-folio offset without taking buf-&gt;off into account:<br><br>=C2=A0ret=
urn buf-&gt;base + (offset &amp; ~PAGE_MASK);<br><br>If buf-&gt;off is not =
page-aligned, the returned pointer misses the in-page<br>component of buf-&=
gt;off, so callers end up fetching data from a wrong<br>offset.<br><br>buf-=
&gt;off is set to sbi-&gt;dif0.fsoff in erofs_init_metabuf(), and fsoff can=
<br>be specified via the &quot;fsoffset=3D&quot; mount option, which only r=
equires<br>block-size alignment. Therefore, on an image with a sub-page blo=
ck size<br>(e.g. 512 bytes), a non-page-aligned fsoff (e.g. 512) triggers t=
he issue,<br>since 512 is a multiple of the block size but not of PAGE_SIZE=
.<br><br>It can be reproduced by mounting an image that is placed at a<br>n=
on-page-aligned offset:<br><br>=C2=A0mkfs.erofs -b512 -zlz4hc sub.erofs src=
/<br>=C2=A0# prepend 512 bytes of padding to the image<br>=C2=A0mount -t er=
ofs -o loop,fsoffset=3D512 padded.erofs /mnt<br><br>which fails with<br><br=
>=C2=A0erofs (device loop0): cannot find valid erofs superblock<br><br>beca=
use the on-disk superblock (at offset 1024 within the image, i.e.<br>1536 w=
ithin the padded file) is read from a wrong in-folio offset. With<br>this f=
ixed, the very same image mounts successfully and its file contents<br>matc=
h those read from the unpadded image.<br><br>Fix it by including buf-&gt;of=
f in the in-folio offset calculation, so that<br>it is consistent with the =
folio index calculation.<br><br>Fixes: c36ec00d7f67 (&quot;erofs: add &#39;=
fsoffset&#39; mount option to specify filesystem offset&quot;)<br>Cc: &lt;<=
a href=3D"mailto:stable@vger.kernel.org">stable@vger.kernel.org</a>&gt; # 6=
.16+<br>Signed-off-by: Binglei Wang &lt;<a href=3D"mailto:l3b2w1@gmail.com"=
>l3b2w1@gmail.com</a>&gt;<br>---<br>=C2=A0fs/erofs/data.c | 2 +-<br>=C2=A01=
 file changed, 1 insertion(+), 1 deletion(-)<br><br>diff --git a/fs/erofs/d=
ata.c b/fs/erofs/data.c<br>index 0885b1f2fc92..be63b89f0862 100644<br>--- a=
/fs/erofs/data.c<br>+++ b/fs/erofs/data.c<br>@@ -48,7 +48,7 @@ void *erofs_=
bread(struct erofs_buf *buf, erofs_off_t offset, bool need_kmap)<br>=C2=A0 =
=C2=A0return NULL;<br>=C2=A0 if (!buf-&gt;base)<br>=C2=A0 =C2=A0buf-&gt;bas=
e =3D kmap_local_page(buf-&gt;page);<br>- return buf-&gt;base + (offset &am=
p; ~PAGE_MASK);<br>+ return buf-&gt;base + ((buf-&gt;off + offset) &amp; ~P=
AGE_MASK);<br>=C2=A0}<br>=C2=A0<br>=C2=A0int erofs_init_metabuf(struct erof=
s_buf *buf, struct super_block *sb,<br>-- <br>2.33.0</div>

--00000000000098ff68065b2d5b09--

