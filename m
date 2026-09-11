Return-Path: <linux-erofs+bounces-4533-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B4BDBC79FA1
	for <linux-erofs@archiver.kernel.org>; Fri, 11 Sep 2026 04:15:37 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hh1Rr0Mn4z2y2b;
	Fri, 11 Sep 2026 14:15:36 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=pass smtp.remote-ip="2607:f8b0:4864:20::c35" arc.chain=google.com
ARC-Seal: i=2; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1789100135;
	cv=pass; b=lbKsrZZwhmcau3+ay6VH7vK7Z+i++hkUDKmet4Z6flghMXKJwRjU4e02rhSRxMjJ8cKY7nLg9afVz+7Z5fcG7byJGYic66clFFcNmIANxSskJO3ECGwDl2qJyB+KMEbNCCY4OQGIa2O+zZbA5bmGtuIKYP9j4dAFsQPkOZ+9aTaHxCSXVnrfsURArWbeCGZ2qLyWWeVO1Ypm8eVbD967I38pCemvWtrwCMdd9vURbbENy2l8zU4n7ADf55zzIXAlmpHnNgzyIL4s6kCTbniheHTR8F1PwJq2pIU9Dx8Fcyyx7JFe2NucEIMGf86Gl80wys0eLTnaME6eB2WWXn4z4A==
ARC-Message-Signature: i=2; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1789100135; c=relaxed/relaxed;
	bh=mxws4ynOTB5ANxS9YDh+9QSLZixWhHNtkZror59ozCU=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=IIpAgLFiBi9+OEDt7bYj4+Q80/GRsTlhVuFqrI2vQ+xz5ywJOr5V+QLkUrLdtEDqkTaSyaC8moV0C4DIFZhVS9/Refreatcj4grY9225Jg7O+FGqSlizde7YXmoJjxTV7okqbA3MxRMals6rjpjLTmCVN1n7mSJszSINDtyrM51XuWEzpqxNJr6daWQmk0NsS2+jRjaEWCMrom8D2VpsdiXw9FsumeqMi72KVsnBvhWCQM3wVttwnHjXttYqswo1LT59phatP2PHk+pIYBUhnBMdxmp7g4fl2YLqyM7G6FG7Rfc8ztLpJaV/KkQ4s0K30hhcONx2HyCWZszXGHkIoQ==
ARC-Authentication-Results: i=2; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=gmail.com; dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=HgDfaFGu; dkim-atps=neutral; spf=pass (client-ip=2607:f8b0:4864:20::c35; helo=mail-oo1-xc35.google.com; envelope-from=l3b2w1@gmail.com; receiver=lists.ozlabs.org) smtp.mailfrom=gmail.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=HgDfaFGu;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=gmail.com (client-ip=2607:f8b0:4864:20::c35; helo=mail-oo1-xc35.google.com; envelope-from=l3b2w1@gmail.com; receiver=lists.ozlabs.org)
Received: from mail-oo1-xc35.google.com (mail-oo1-xc35.google.com [IPv6:2607:f8b0:4864:20::c35])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hh1Rq0knmz2xpv
	for <linux-erofs@lists.ozlabs.org>; Fri, 11 Sep 2026 14:15:33 +1000 (AEST)
Received: by mail-oo1-xc35.google.com with SMTP id 006d021491bc7-6b1afdf98dfso443304eaf.3
        for <linux-erofs@lists.ozlabs.org>; Thu, 10 Sep 2026 21:15:33 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789100131; cv=none;
        d=google.com; s=arc-20260327;
        b=qPot9JdVMVE5ZZgTZlYmXsjS3zu1wttsXM31r62qgPNewjxpM0Sz0FWSwqiLJIywIy
         5yv92lzdqUrgC7QPQgmhiB2yUMrScE6VpARf8wEK+2FZNTklvMMUYTg5SIA/eoZ0lgQK
         DL7aG09Bxd3dqQgsgGlsg0HzOtBEWpdw/+Z8t4VFn+U66QnWLXEiQku4nLh0hwAdSN/o
         thoOO6zcgXj9vzJdDi9zMkkzlP1eX7lS10SMSNXQcwy1vSQbler4IopoaFekHK64ZJjp
         0jawbzcDkdLSVzmLJ5kTwTHOimeE8GB/KJ/53YsbQAs1r8rw+XMoWSxr3UEW01kFg3iy
         1qQw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=mxws4ynOTB5ANxS9YDh+9QSLZixWhHNtkZror59ozCU=;
        fh=KHSZtFZf8VtY361Z+77ksgpLHFJy07HstrNMQ1PJy5I=;
        b=MNjzLg8OeXf0f/g/W6D0IBuHQngf2rShWJRpqUTGkNd0gu30iNtsr/IiW7w3nP+JnM
         56WzeDZcxmRnKdt4OoD2YOYMHv302OQC/p6QgVsHYfn3jFsYbnZCryENr55nrS23VOMo
         JsQQ7X4wcU/RzyVo5xD2v2IHtDWcIDGIuPuAeCqf9E8Q9kUuxJNsS6NymH2s78WWKI1E
         0KiQK/dEr5QX+SvOTx4Zz7WqIopn8CF85wjVnFfVi3ubLDH/Owx1ufCli3FwDARKzTAi
         ytUhk4mvHU7dgQZEWRDhON05/m/Tw3QT+E05yvcW7Zi1nR52rq42cRno8FUtG/PeOpIk
         RLEg==;
        darn=lists.ozlabs.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789100131; x=1789704931; darn=lists.ozlabs.org;
        h=content-type:cc:to:subject:message-id:date:from:mime-version:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=mxws4ynOTB5ANxS9YDh+9QSLZixWhHNtkZror59ozCU=;
        b=HgDfaFGuosxZZT198nIv+rFpwINBYTUDJ4gEuc8tlwN4V0ulZP/qVwsjGB2jARPe4A
         ob8dQL+QasjUaIWqWWYu5MLmWkaGGodve3gVHNTlUWhD7QakzajZHu6V5mW7Z7RwJnB1
         uXauKk1XecolRalWs3Zww7n+H15sBGoyMTQFYEX3bt/cePhTNZdwHgqAWo4j97aesWuj
         0BEtxyOXc3aid6aCCGS69wGMgT5l3uL/KOQf1nfqpOF1e91z+HfffNs7QAeYREdSntx0
         aJdznGAQKnK/0uCY0rPQfG3s+To16v1RT8kQYHC5JYE/xi841G1eyO5gjoEGCxONT/Co
         mF4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789100131; x=1789704931;
        h=content-type:cc:to:subject:message-id:date:from:mime-version
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=mxws4ynOTB5ANxS9YDh+9QSLZixWhHNtkZror59ozCU=;
        b=eFpkNUs16zyPPPGqtgtNm+sprDUQwqSz0HcHJDzlKBGnnthxLPPf3Q5mkwZEPmS87i
         1/uIhC8VR3oFAkcQCZ+UYdPumpGvCPr1OokLfOob8xmHZAS21EY3SNJImUiqA6qaYKXs
         r4BuCZjTnjr/gWik2yKsN4f+yNMnA6ZNpANfBvXLXw93XKt7nVJT/FLUbBCrBJH/gaVS
         GJhfWz6kJeVfEsFQA5g3V54qXCslGFthA/qCRXR+sU8wfMgC5AOxFFTEF4DKSU6vJqxw
         12nzp8F4CE+OVoOT6oenCmegSFrTBB+IlxgUP6ySXP5xMeilzdcNzzE6Dcy4JHW7fypO
         NZxg==
X-Gm-Message-State: AFuF++kPMoc+GnKb49x5flphTFq5D4Nh9hYIc5WtkFhVWouBTuwStfUC
	3Hb4muoaueKDaOohXz+cIFycMmxBPcI6RsJX6X0OM05jmRtQ3iIoBliMwQJdUmANECuyWfNjn/5
	SlSji7s4ielFFBE0PM3WnTM4IdQBrx3VweGnmji8=
X-Gm-Gg: AYBFou3FzOZiNwLQHvI6ea1Tn67xK6dgca87k/8F5lMa4mH+S+0WGl4rjE0D6qNePJG
	GRN8UbRYiH99MzHCNiVDlpYZXJi8eyXlnQXNTB2qCymVQQoUABoS8NDTZOcZPSbcg5rK2ptUDYt
	z6t6yjlGD4hgweJ6PJg3I5/9dc7iA0Sgk37QMagcmCuJNCFdjK7HVsJ13kzMFZO87Dufy/oDyN9
	97IgXPL4CVnQ5qdF1pKTq9qC0Gk8WAtvUH4svfXhIAbHmKLOdol82gck/zdzOZlVLcWp9zx3ZWR
	q8yalZS96wdlPH420iF5LF09uzJ13WXPaFWPfwt9t1rLZXnIoP5pq79xr3lvBqrSkg==
X-Received: by 2002:a05:6820:f023:b0:6b3:8240:b2e9 with SMTP id
 006d021491bc7-6c0b9958c2amr1751489eaf.21.1789100131109; Thu, 10 Sep 2026
 21:15:31 -0700 (PDT)
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
Date: Fri, 11 Sep 2026 12:15:18 +0800
X-Gm-Features: AcwNN1WOK0cmPXffTw0EaMzETVjbG5dPoVMFtyRiVa4z7wqUrfTVNdETEbxlYsA
Message-ID: <CAJ3C4KwmPuri+x07kBReYBpUOwLUGEy1L5BEBTVgQMWTywXhjA@mail.gmail.com>
Subject: [PATCH] erofs: fix unbalanced buf->off handling in erofs_bread()
To: linux-erofs@lists.ozlabs.org
Cc: linux-kernel@vger.kernel.org, wangshuai12@xiaomi.com, guochunhai@vivo.com, 
	hongbohbli@tencent.com, dhavale@google.com, jefflexu@linux.alibaba.com, 
	zbestahu@gmail.com, shengyong1@xiaomi.com, chao@kernel.org, xiang@kernel.org
Content-Type: multipart/alternative; boundary="000000000000c8523e065b2d55b2"

--000000000000c8523e065b2d55b2
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
block-size alignment.  Therefore, on an image with a sub-page block size
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
1536 within the padded file) is read from a wrong in-folio offset.  With
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

--000000000000c8523e065b2d55b2
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div dir=3D"ltr">erofs_bread() locates the target folio wi=
th<br><br>	index =3D (buf-&gt;off + offset) &gt;&gt; PAGE_SHIFT;<br><br>but=
 computes the in-folio offset without taking buf-&gt;off into account:<br><=
br>	return buf-&gt;base + (offset &amp; ~PAGE_MASK);<br><br>If buf-&gt;off =
is not page-aligned, the returned pointer misses the in-page<br>component o=
f buf-&gt;off, so callers end up fetching data from a wrong<br>offset.<br><=
br>buf-&gt;off is set to sbi-&gt;dif0.fsoff in erofs_init_metabuf(), and fs=
off can<br>be specified via the &quot;fsoffset=3D&quot; mount option, which=
 only requires<br>block-size alignment.=C2=A0 Therefore, on an image with a=
 sub-page block size<br>(e.g. 512 bytes), a non-page-aligned fsoff (e.g. 51=
2) triggers the issue,<br>since 512 is a multiple of the block size but not=
 of PAGE_SIZE.<br><br>It can be reproduced by mounting an image that is pla=
ced at a<br>non-page-aligned offset:<br><br>	mkfs.erofs -b512 -zlz4hc sub.e=
rofs src/<br>	# prepend 512 bytes of padding to the image<br>	mount -t erof=
s -o loop,fsoffset=3D512 padded.erofs /mnt<br><br>which fails with<br><br>	=
erofs (device loop0): cannot find valid erofs superblock<br><br>because the=
 on-disk superblock (at offset 1024 within the image, i.e.<br>1536 within t=
he padded file) is read from a wrong in-folio offset.=C2=A0 With<br>this fi=
xed, the very same image mounts successfully and its file contents<br>match=
 those read from the unpadded image.<br><br>Fix it by including buf-&gt;off=
 in the in-folio offset calculation, so that<br>it is consistent with the f=
olio index calculation.<br><br>Fixes: c36ec00d7f67 (&quot;erofs: add &#39;f=
soffset&#39; mount option to specify filesystem offset&quot;)<br>Cc: &lt;<a=
 href=3D"mailto:stable@vger.kernel.org" target=3D"_blank">stable@vger.kerne=
l.org</a>&gt; # 6.16+<br>Signed-off-by: Binglei Wang &lt;<a href=3D"mailto:=
l3b2w1@gmail.com" target=3D"_blank">l3b2w1@gmail.com</a>&gt;<br>---<br>=C2=
=A0fs/erofs/data.c | 2 +-<br>=C2=A01 file changed, 1 insertion(+), 1 deleti=
on(-)<br><br>diff --git a/fs/erofs/data.c b/fs/erofs/data.c<br>index 0885b1=
f2fc92..be63b89f0862 100644<br>--- a/fs/erofs/data.c<br>+++ b/fs/erofs/data=
.c<br>@@ -48,7 +48,7 @@ void *erofs_bread(struct erofs_buf *buf, erofs_off_=
t offset, bool need_kmap)<br>=C2=A0		return NULL;<br>=C2=A0	if (!buf-&gt;ba=
se)<br>=C2=A0		buf-&gt;base =3D kmap_local_page(buf-&gt;page);<br>-	return =
buf-&gt;base + (offset &amp; ~PAGE_MASK);<br>+	return buf-&gt;base + ((buf-=
&gt;off + offset) &amp; ~PAGE_MASK);<br>=C2=A0}<br>=C2=A0<br>=C2=A0int erof=
s_init_metabuf(struct erofs_buf *buf, struct super_block *sb,<br>-- <br>2.3=
3.0</div>
</div>

--000000000000c8523e065b2d55b2--

