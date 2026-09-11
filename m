Return-Path: <linux-erofs+bounces-4532-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 03D9AC88E41
	for <linux-erofs@archiver.kernel.org>; Fri, 11 Sep 2026 04:02:08 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hh18H1GZHz2xpv;
	Fri, 11 Sep 2026 14:02:07 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=pass smtp.remote-ip="2607:f8b0:4864:3b::10" arc.chain=google.com
ARC-Seal: i=2; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1789099327;
	cv=pass; b=H/XR5VjOt3VuIAv+zFjBXAfxUyixX29VGCsTCnKUZ35cZ/cvyxkBKpZzjipFxF1kJKT+IzJ/hlbd/1dVFALVjetMCXPyWUdV6bP1cXba7rk/Vh4m/yaLwpALboNW5SQdvFvS9b/hQw/yJSiz0l2l1DV4tf9fcGhsNiQHBkXqxt2eNUBgkIGN/GzrelUVfFGYaTZCd1cFXCQ/5PPNqZju9P6NxmvR5e9GxqUP4g7sHMYhmy5F8Ltkc69SlUpcgetjy1IbfEfSFi1IF7efaS1OQdNr0roLPSpaxFGxYG5QThbjrfr3HGD9AqSXWzobDOBqGjV0/7EIXIfq+LMeKTbcww==
ARC-Message-Signature: i=2; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1789099327; c=relaxed/relaxed;
	bh=14bBVJmguQC2FRJP9TCbJb2bgqpS+48OYtzyPenh/Uw=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=FJwA3nlC/X45/u9LROIimXuWm+0jdQMzOFYAykVM/VP+HF0WOCOfjHU6lX/eZz5r4ra9Cc7wxe6FzpIGg2nVrW4j6r5nqE2C2HJN65m39sFsB0ri/YVgHfQsC3Q26ltAFMn722+zoSOREv2dXePdEI5Gc5JVQor1PwAY/tOcSfnxfUzddmhfwL6Py1uCHSjB/fD360qoUGh3HKaW484DSKEGl0yEAfVAdkxEOKzWSzCVU9Baj+11toDwGYRtkM4ek+PxOn/hUEc0CHb4hI+BsLml9k9za9YUrK+J7mYIM2PUsZuaDK6XcuuWjfxG3krhqRMsazOOSrT+mP6hqQLH3A==
ARC-Authentication-Results: i=2; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=gmail.com; dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=bfRxzB4c; dkim-atps=neutral; spf=pass (client-ip=2607:f8b0:4864:3b::10; helo=mail-pz2-x10.google.com; envelope-from=l3b2w1@gmail.com; receiver=lists.ozlabs.org) smtp.mailfrom=gmail.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=bfRxzB4c;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=gmail.com (client-ip=2607:f8b0:4864:3b::10; helo=mail-pz2-x10.google.com; envelope-from=l3b2w1@gmail.com; receiver=lists.ozlabs.org)
Received: from mail-pz2-x10.google.com (mail-pz2-x10.google.com [IPv6:2607:f8b0:4864:3b::10])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hh18F56WHz2xlJ
	for <linux-erofs@lists.ozlabs.org>; Fri, 11 Sep 2026 14:02:05 +1000 (AEST)
Received: by mail-pz2-x10.google.com with SMTP id 41be03b00d2f7-cc4c3304784so491264a12.3
        for <linux-erofs@lists.ozlabs.org>; Thu, 10 Sep 2026 21:02:04 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789099322; cv=none;
        d=google.com; s=arc-20260327;
        b=PKpYYYusZUfXy0M5W0WOP25fdo1EbjtlsEE+iYNDCPQ1I0OBNgCCjyf7NvzkOkyVpn
         wpMIVP5FY2PQ6wN26XZF4/unqEwDvPxQKCX8Q/v4WJLhYFLZOdGwRL7CgTpwSainOK2O
         GpPHIx7lCXZUj2VaL+PgF66rlz94y+ompXPSvM0jjFJ/22JDm1XnSih8zS1Yqssxg+fu
         tMmc0iaxrqihGTrxQJOMYvgfF8gz+su1l3i7FwqYFzMC/rnFDhVQUX9XTD+QsMoI46UR
         onBCgep6OrGw5En2ie+oIXZIXJdwEm1uLw08AU19zivSJJWcSRZiMBPkgxasZUeF+kFG
         XAoQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=14bBVJmguQC2FRJP9TCbJb2bgqpS+48OYtzyPenh/Uw=;
        fh=6evFzj904WkCtkIMBHchS3ApakVf2PDvpmNGr3cxXsg=;
        b=MRdSTHiN9wA8CaesgCDIoMLMAYWLe6Ebl37SqKuwP9Q1taK7Tw9B8MgLaQheoIL6NX
         atLJyHn66mmt+/MsUNL514fxuxO7qojCX1p1CGkFP0m0K/TkgjBaklQnwf+pQM2ffG9J
         kb0RHnaJnBVeJ0jWyUBtAFqBOSLB03jyVrT8K1JN+KDipSFZiWcZBTy2hKf9S+tN67df
         eqpfNppIGJvPU0HizAPMH+xDYrkATAp8PUBYZyiJ8G458M4fRbxEcq6r23fZw26WjxpF
         nSIkzK6I6uSCIeQLPNjoSzLVeSMsnvtp+XWiGIvA7iwRy+/MiW6TVlwnw/jg2uSgd2PO
         lQcw==;
        darn=lists.ozlabs.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789099322; x=1789704122; darn=lists.ozlabs.org;
        h=content-type:cc:to:subject:message-id:date:from:mime-version:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=14bBVJmguQC2FRJP9TCbJb2bgqpS+48OYtzyPenh/Uw=;
        b=bfRxzB4cq+LvbVIbZciVm+7xkNJdNVhk1I0VUWD1jXf91mERgv7aqttBTXZgyJeA1t
         Slh4fw66NKKGlFT4H9BGSxUZVIvUqJGYj319f5/jmJYEWSeh7mtxp3odz1XL7fRipuUQ
         Zbdmr5MywvyPEVrD9fGDEm+vtxRttFpdZAAPj3s3ZlZ0hgANEfFJIfYiJXeCTTluFZir
         Orut2BMoVC9M/4bqzGJ0Uf0ue1j/wVUeS7Yfw3wNe8ML7uF5xEjNotpQEZc1svvR78o4
         8D7NvzfQAFL/wgMLbz++VtMRTZ41+7emuTpxHJYykWzvxVtE9m9QpZWSF74CtpLYeuNA
         f2KA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789099322; x=1789704122;
        h=content-type:cc:to:subject:message-id:date:from:mime-version
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=14bBVJmguQC2FRJP9TCbJb2bgqpS+48OYtzyPenh/Uw=;
        b=QeKgkxqeM93toKjBPsNAbLPxBtKob71XnUT1bYt0ansp53PbV4iHAW8i6hz1z1xF/v
         h5q+HszgHFRVMqtj1ji5/pJcLnWSfa6T4+jvvNISKjhFXYW8aRfk8ZYZ4m6LGcjoAfK8
         g9kDOPzhHkZdIpu84r81gFW8ZEZhNZXHf9uzhzaJgvcW4tncyzchDiB59bnIKdODZRGk
         qFzxjiLnTSpCqxkwCdkxMks9gIhpvJhs5K1zMQrOGmZJUNFz7hqbJvJR6OzsmFfkpvwV
         ftCfvHPd3KM/XmWsX7DZdqSqpl1GRSIdzY/HrW3SH0LTBVkTphC69Do3yYnGlL5OAxIz
         1zKQ==
X-Gm-Message-State: AFuF++kUy30fibEWrnyodG7dB/BydEVk7TqX9vndh3nUcuCNAj8Tsibn
	tH9/L75C8AWsMyLzff7AgwejHmWaAm1jnxK7IA8oaZux4BcmB4jigEvU/JXa17nA0XcLPKjoh8M
	A6lgFukqQGn0pj87X6gIgnmN6OS6kV83MIgjsLf4=
X-Gm-Gg: AYBFou1rvPHTfXTXBeFOyKjAUFb8SwcuSo8n49BOMGNM97IRPMGNbhRbtHmZi2vbMbD
	r86cZEXrOT/ZN9w9zXinKfvk76wUM60aZAmtzAAr4HYHBH4dS7gBgUR5yECR+BLOKbtUNWI1aC5
	ZUUzoUSJBvS2Z/dkSSX+x90M9iMyPBanBBuKmrxcnTuxxuj7NAiol5p5TIuPaQi7yA7uiIZwn/8
	L8qdabBYY+YsAxxl/ey4ukL8NCBYBqU5zjiMErz9DzF7ElxzpGOYY/qCaUELknEJyt9d27dC8r0
	7hIh0SgrSvyDYU9T8tga+SQYrmJQd20l11bHpPdATovGBfTaYOOCRvI=
X-Received: by 2002:a17:90b:4fc2:b0:381:6c5:3f63 with SMTP id
 98e67ed59e1d1-39d9bc42d1bmr3993382a91.6.1789099321867; Thu, 10 Sep 2026
 21:02:01 -0700 (PDT)
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
Date: Fri, 11 Sep 2026 12:01:48 +0800
X-Gm-Features: AcwNN1W8xnt88SiWQoqLd-23BIuQog0envAN6ukJDN2-SmJjL4equHPUNHq8RBg
Message-ID: <CAJ3C4KxqO2--RDZN7jCvYKOjwe-XSUcEj8w74ETeHV2ZUq_1dw@mail.gmail.com>
Subject: [PATCH] erofs: fix unbalanced buf->off handling in erofs_bread()
To: linux-erofs@lists.ozlabs.org
Cc: xiang@kernel.org, chao@kernel.org, shengyong1@xiaomi.com, 
	zbestahu@gmail.com, jefflexu@linux.alibaba.com, dhavale@google.com, 
	hongbohbli@tencent.com, guochunhai@vivo.com, wangshuai12@xiaomi.com, 
	linux-kernel@vger.kernel.org
Content-Type: multipart/alternative; boundary="0000000000008c408b065b2d255a"

--0000000000008c408b065b2d255a
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

--0000000000008c408b065b2d255a
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"auto">erofs_bread() locates the target folio with<div dir=3D"au=
to"><br></div><div dir=3D"auto">=C2=A0index =3D (buf-&gt;off + offset) &gt;=
&gt; PAGE_SHIFT;</div><div dir=3D"auto"><br></div><div dir=3D"auto">but com=
putes the in-folio offset without taking buf-&gt;off into account:</div><di=
v dir=3D"auto"><br></div><div dir=3D"auto">=C2=A0return buf-&gt;base + (off=
set &amp; ~PAGE_MASK);</div><div dir=3D"auto"><br></div><div dir=3D"auto">I=
f buf-&gt;off is not page-aligned, the returned pointer misses the in-page<=
/div><div dir=3D"auto">component of buf-&gt;off, so callers end up fetching=
 data from a wrong</div><div dir=3D"auto">offset.</div><div dir=3D"auto"><b=
r></div><div dir=3D"auto">buf-&gt;off is set to sbi-&gt;dif0.fsoff in erofs=
_init_metabuf(), and fsoff can</div><div dir=3D"auto">be specified via the =
&quot;fsoffset=3D&quot; mount option, which only requires</div><div dir=3D"=
auto">block-size alignment.  Therefore, on an image with a sub-page block s=
ize</div><div dir=3D"auto">(e.g. 512 bytes), a non-page-aligned fsoff (e.g.=
 512) triggers the issue,</div><div dir=3D"auto">since 512 is a multiple of=
 the block size but not of PAGE_SIZE.</div><div dir=3D"auto"><br></div><div=
 dir=3D"auto">It can be reproduced by mounting an image that is placed at a=
</div><div dir=3D"auto">non-page-aligned offset:</div><div dir=3D"auto"><br=
></div><div dir=3D"auto">=C2=A0mkfs.erofs -b512 -zlz4hc sub.erofs src/</div=
><div dir=3D"auto">=C2=A0# prepend 512 bytes of padding to the image</div><=
div dir=3D"auto">=C2=A0mount -t erofs -o loop,fsoffset=3D512 padded.erofs /=
mnt</div><div dir=3D"auto"><br></div><div dir=3D"auto">which fails with</di=
v><div dir=3D"auto"><br></div><div dir=3D"auto">=C2=A0erofs (device loop0):=
 cannot find valid erofs superblock</div><div dir=3D"auto"><br></div><div d=
ir=3D"auto">because the on-disk superblock (at offset 1024 within the image=
, i.e.</div><div dir=3D"auto">1536 within the padded file) is read from a w=
rong in-folio offset.  With</div><div dir=3D"auto">this fixed, the very sam=
e image mounts successfully and its file contents</div><div dir=3D"auto">ma=
tch those read from the unpadded image.</div><div dir=3D"auto"><br></div><d=
iv dir=3D"auto">Fix it by including buf-&gt;off in the in-folio offset calc=
ulation, so that</div><div dir=3D"auto">it is consistent with the folio ind=
ex calculation.</div><div dir=3D"auto"><br></div><div dir=3D"auto">Fixes: c=
36ec00d7f67 (&quot;erofs: add &#39;fsoffset&#39; mount option to specify fi=
lesystem offset&quot;)</div><div dir=3D"auto">Cc: &lt;<a href=3D"mailto:sta=
ble@vger.kernel.org">stable@vger.kernel.org</a>&gt; # 6.16+</div><div dir=
=3D"auto">Signed-off-by: Binglei Wang &lt;<a href=3D"mailto:l3b2w1@gmail.co=
m">l3b2w1@gmail.com</a>&gt;</div><div dir=3D"auto">---</div><div dir=3D"aut=
o">=C2=A0fs/erofs/data.c | 2 +-</div><div dir=3D"auto">=C2=A01 file changed=
, 1 insertion(+), 1 deletion(-)</div><div dir=3D"auto"><br></div><div dir=
=3D"auto">diff --git a/fs/erofs/data.c b/fs/erofs/data.c</div><div dir=3D"a=
uto">index 0885b1f2fc92..be63b89f0862 100644</div><div dir=3D"auto">--- a/f=
s/erofs/data.c</div><div dir=3D"auto">+++ b/fs/erofs/data.c</div><div dir=
=3D"auto">@@ -48,7 +48,7 @@ void *erofs_bread(struct erofs_buf *buf, erofs_=
off_t offset, bool need_kmap)</div><div dir=3D"auto">=C2=A0 =C2=A0return NU=
LL;</div><div dir=3D"auto">=C2=A0 if (!buf-&gt;base)</div><div dir=3D"auto"=
>=C2=A0 =C2=A0buf-&gt;base =3D kmap_local_page(buf-&gt;page);</div><div dir=
=3D"auto">-	return buf-&gt;base + (offset &amp; ~PAGE_MASK);</div><div dir=
=3D"auto">+	return buf-&gt;base + ((buf-&gt;off + offset) &amp; ~PAGE_MASK)=
;</div><div dir=3D"auto">=C2=A0}</div><div dir=3D"auto">=C2=A0</div><div di=
r=3D"auto">=C2=A0int erofs_init_metabuf(struct erofs_buf *buf, struct super=
_block *sb,</div><div dir=3D"auto">--=C2=A0</div><div dir=3D"auto">2.33.0</=
div></div>

--0000000000008c408b065b2d255a--

