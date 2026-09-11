Return-Path: <linux-erofs+bounces-4537-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6286BC88E41
	for <linux-erofs@archiver.kernel.org>; Fri, 11 Sep 2026 04:23:05 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hh1cS0KVPz2ygK;
	Fri, 11 Sep 2026 14:23:04 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=pass smtp.remote-ip="2607:f8b0:4864:20::1032" arc.chain=google.com
ARC-Seal: i=2; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1789100584;
	cv=pass; b=febiAbyjeeo10hK0c6HznZhx2bzi88M3zuqTiW8/HmRlx3WxPx43RVGSolxG1ic8Jr8G+ErV2eGQDjCHsLXXVfC8N2VxNRgiwnnJwPSKbN+UCwt5/f0s+cnQ9O1aDqwnV+yVZOPF04hurvUc4S+2esfvh90AlDU47JSU7/ggRoRO9o9gz7wbPdo8wQm45DxfoShaJJC5sg4a/ZH+vna28E6WATupS3exEs2cHBhH9fIEDFJRWGsAcRvxbdFu/0hT/bCJvNwAlizvHSxcg98OIq2BPpKufiEtC2Cmuok4UWFTXQ6CRc9da9Uw7Nltg5WTDNkvMdYIe+MrwBc/EOlZLw==
ARC-Message-Signature: i=2; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1789100584; c=relaxed/relaxed;
	bh=Ggy3ISe8QzO8vHRv3PE5LfWMT0iuFdX620ARBjOXCwY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Content-Type; b=biMJv3YYhbp78V40kmB0l8q4pt7W5mnjnjwybuGX/45+NKdMyl5CW1Aws/KnvP3+/AwDF3gC+fIJoKFuYDrg9AdJ/TUWqCqQLVPcVWQIAoms3jCUdwpBiAu7F5tdiC7jxjvp7PP9N8M+QR8kXWcjN+Pjj6x5YKwSh5xxWtdeIO2MIzA+DY9pCrrzGSekB159h6hXCBGU+NLwSrznJ4thprzqETks8s3lTO8YsBkfzOHh99EjjdkMXQB731OKmS9O9XJLOzCG///yU4IMQgkQ1Aszz07Q3dFozfJScv7S5KZZPQF8IOi45Ow0lrFwUYxXhawqT1rs56ZRvSkQZ7FtUg==
ARC-Authentication-Results: i=2; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=gmail.com; dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=egweUY9u; dkim-atps=neutral; spf=pass (client-ip=2607:f8b0:4864:20::1032; helo=mail-pj1-x1032.google.com; envelope-from=l3b2w1@gmail.com; receiver=lists.ozlabs.org) smtp.mailfrom=gmail.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=egweUY9u;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=gmail.com (client-ip=2607:f8b0:4864:20::1032; helo=mail-pj1-x1032.google.com; envelope-from=l3b2w1@gmail.com; receiver=lists.ozlabs.org)
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hh1cR0mmGz2xRs
	for <linux-erofs@lists.ozlabs.org>; Fri, 11 Sep 2026 14:23:02 +1000 (AEST)
Received: by mail-pj1-x1032.google.com with SMTP id 98e67ed59e1d1-3969e82ff8fso575519a91.0
        for <linux-erofs@lists.ozlabs.org>; Thu, 10 Sep 2026 21:23:02 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789100580; cv=none;
        d=google.com; s=arc-20260327;
        b=Pt8QWud33XST7B/bSXRuCciAShZeOYJX5MeMa/n+quflfdMa1NrnGuIrZJu0rkspl5
         wh7NuY5bRs8CNxbZstkjKVLS7Z5o0pUuk2XI0A8cMF2xbo+hpgyX02O3YABvnJ+EL5ca
         8wGeJTmm9e5WQXGBUyKsLtL9uTSi0QADOMVxxwlFYjZT9X4BrDpKk/OuhfkZAiZY2iNS
         FKJgg87WMQi+JRpqoegcbD2xePGp+6oBqETAKluWVu3oZ8l5SSIRMMbCC8v0zXQqeXew
         3Vv/7Tf/d40CSR6I/N8uEx5xep/YHIODqv0ZNJu2NmVnnQzOHVtqzeNO9/SslRdyG/w/
         WrAw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=to:subject:message-id:date:from:in-reply-to:references:mime-version
         :dkim-signature;
        bh=Ggy3ISe8QzO8vHRv3PE5LfWMT0iuFdX620ARBjOXCwY=;
        fh=GF3rivrTcgf7HegGZns2OFhwg6vuGxzqIyZ+wGk97wQ=;
        b=chDG+WdK7F3FHtI1dtQvAYct3/1DlSqeb/xN21jY3r6BWXCIkoQrS6VdwDaJ42Mohm
         Q3Z5pjuATsLKplS6ha+FCEG/zxr2PCq80v0di28IMuTE7lM4rkuDtanGx9/OZztZ4rWq
         x/6D34zbK2JElL0Mv3fkcX9i26zF8FW1iU2cFYvK/DYipMd4ZNYIt643d22xOyZdgokX
         rtPJO034UN+w5bM4eoixuHdzkGN+uvyzdXLXOtjgPfKaB9AFLLhJzdY9eG31aOwa62Kh
         3+BQuU9DBAWNORFOU9AwsYD0s0HzMMnK2uPKauPyxU2Ojrg5+0DUJZi9FcYPvPRbKBko
         kuQA==;
        darn=lists.ozlabs.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789100580; x=1789705380; darn=lists.ozlabs.org;
        h=content-type:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Ggy3ISe8QzO8vHRv3PE5LfWMT0iuFdX620ARBjOXCwY=;
        b=egweUY9uK796R87DlpzEk//43IKa2DuPfVSj1xc3lDlB8EI/zQ2fRc5dCG7YrHtaUU
         WufD2WUfzZCi6p2LddoxE5dWNijcQN5OwdeJe17WUipAXeUJZdt2q6OAsxngD3UnkEdp
         5EuFn0qhAW931Y5dAsG8Re5DSh/74ShS40uiqVfvSoUFGgrjNNZOJ4iVp2RKaFdQ+TJC
         knKj4BtC7i7Hf8vzl0gyLRhArL4OIQVBUWzBIA4SJVAqya8lbFbeivsP0sVheQsQA84z
         RAD+6rOuQphqNO5zEWSy/5QZ30jYbyvwzv8rRGP6rqqXMgvJKJ7V6NMkBIKFLMDKxOlw
         Y4rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789100580; x=1789705380;
        h=content-type:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Ggy3ISe8QzO8vHRv3PE5LfWMT0iuFdX620ARBjOXCwY=;
        b=SupXi7GwZo0epIxlwxkYU1fW98jTH0ua6YoD0AdV5B1CMZWjYmmC6GnsNjaviiRlra
         OTJO7GXfmponHK1klrhtT2FdkE3v2jVtE0aecpckP8V+ZUU6TpAPWG9im7p4vQ9+ZCRl
         k0klWQOPPJAoulnl0wb9RuOTR915IrpijPxDXvXhzP/uDEip1wOJXyoAfVea4KEEezlj
         17oJNtvSCNf4/OdfQzGLRYLPzqfiRAV4I4hf65goL+LoA1j/CqjGw1rjLEwSTW4xLJu9
         lTDDB2fU+TgKd5Pl3HISYbiQGPSbVLIiaGXgQzIkqBidiWNXgVAgOrqvd6Th/9xVe8nc
         ZZtA==
X-Forwarded-Encrypted: i=1; AKwUvBzGw0JfTbUOzEDljb5CesjcIgPGl/+qk+3KE2pQ1d1kyjpedcLiGVlW0NYra/hHbGgIOAIbLP9kFQXrEA==@lists.ozlabs.org
X-Gm-Message-State: AFuF++nz6JvcRNYhVQzlTERHU3WBr+IK/TNTw0dvsV1m5O/zEIbzz/po
	UkbLjX+4DsofmJmSlNelf1qIKRqDQISLwskod/Wpfmsn/oUoOElPtD7e7tICca+9T5fEoZwLrzx
	W+mIeCxHekQ0siRxx9rYL/NNp3hdlgvI=
X-Gm-Gg: AYBFou25xEJPk2xwJwPUIAVt8QsGBnyQDwQqO+BgzlEPZwBGRcsVZFlL2AFJX2rzf5K
	4PqeiUK3XcqCwac6oR2zZOT2AmO1Vt9rRymvu4TvynomfKcb2BTtNDYSgjtCYxmyyfqZUR31KLg
	i8fD1JUXPpIPwcujVRkHECJ3aIM5ATbg1ppZJ+d83RFK9KI/AkmhRf/3ff0vk0BC5qJG5d358mt
	MGZrdIhbIVPJ5K3+H90HihV8s6HeZrbm+RfdZXGgdMLtLzcqwq5ACp+fL9/lek9/5glP4NkTYoW
	m8y3Ui0/z770QW6hOs1K6fbIqRdQPq+SEiebnbG1O703PS3H4I9hU6hr
X-Received: by 2002:a17:90b:3f10:b0:398:cb56:e92 with SMTP id
 98e67ed59e1d1-39d9bdaac2fmr3960807a91.11.1789100580475; Thu, 10 Sep 2026
 21:23:00 -0700 (PDT)
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
References: <CAJ3C4KxqO2--RDZN7jCvYKOjwe-XSUcEj8w74ETeHV2ZUq_1dw@mail.gmail.com>
 <aqOBLWQEkH7_3LSu@XiangdeMacBook-Pro.local>
In-Reply-To: <aqOBLWQEkH7_3LSu@XiangdeMacBook-Pro.local>
From: binglei wang <l3b2w1@gmail.com>
Date: Fri, 11 Sep 2026 12:22:46 +0800
X-Gm-Features: AcwNN1UEri1rSYm-5DjnhH21l0qSWjrlPNi4rK7mYz3QQfKA13WW0Kz0QncN_g8
Message-ID: <CAJ3C4KxD+7KDwgX7aimq2L3Ua8x0kNpfu28=KytOCmBhfwx10w@mail.gmail.com>
Subject: Re: [PATCH] erofs: fix unbalanced buf->off handling in erofs_bread()
To: binglei wang <l3b2w1@gmail.com>, linux-erofs@lists.ozlabs.org, xiang@kernel.org, 
	chao@kernel.org, shengyong1@xiaomi.com, zbestahu@gmail.com, 
	jefflexu@linux.alibaba.com, dhavale@google.com, hongbohbli@tencent.com, 
	guochunhai@vivo.com, wangshuai12@xiaomi.com, linux-kernel@vger.kernel.org
Content-Type: multipart/alternative; boundary="000000000000911796065b2d70b1"

--000000000000911796065b2d70b1
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Thanks for the feedback!  I will check it.

Gao Xiang <xiang@kernel.org> =E4=BA=8E2026=E5=B9=B49=E6=9C=8811=E6=97=A5=E5=
=91=A8=E4=BA=94 12:19=E5=86=99=E9=81=93=EF=BC=9A

> Hi Binglei,
>
> On Fri, Sep 11, 2026 at 12:01:48PM +0800, binglei wang wrote:
> > erofs_bread() locates the target folio with
> >
> >  index =3D (buf->off + offset) >> PAGE_SHIFT;
> >
> > but computes the in-folio offset without taking buf->off into account:
> >
> >  return buf->base + (offset & ~PAGE_MASK);
> >
> > If buf->off is not page-aligned, the returned pointer misses the in-pag=
e
> > component of buf->off, so callers end up fetching data from a wrong
> > offset.
> >
> > buf->off is set to sbi->dif0.fsoff in erofs_init_metabuf(), and fsoff c=
an
> > be specified via the "fsoffset=3D" mount option, which only requires
> > block-size alignment. Therefore, on an image with a sub-page block size
> > (e.g. 512 bytes), a non-page-aligned fsoff (e.g. 512) triggers the issu=
e,
> > since 512 is a multiple of the block size but not of PAGE_SIZE.
> >
> > It can be reproduced by mounting an image that is placed at a
> > non-page-aligned offset:
> >
> >  mkfs.erofs -b512 -zlz4hc sub.erofs src/
> >  # prepend 512 bytes of padding to the image
> >  mount -t erofs -o loop,fsoffset=3D512 padded.erofs /mnt
> >
> > which fails with
> >
> >  erofs (device loop0): cannot find valid erofs superblock
> >
> > because the on-disk superblock (at offset 1024 within the image, i.e.
> > 1536 within the padded file) is read from a wrong in-folio offset. With
> > this fixed, the very same image mounts successfully and its file conten=
ts
> > match those read from the unpadded image.
> >
> > Fix it by including buf->off in the in-folio offset calculation, so tha=
t
> > it is consistent with the folio index calculation.
> >
> > Fixes: c36ec00d7f67 ("erofs: add 'fsoffset' mount option to specify
> > filesystem offset")
> > Cc: <stable@vger.kernel.org> # 6.16+
> > Signed-off-by: Binglei Wang <l3b2w1@gmail.com>
>
> The fix looks fine, but the patch format is broken:
> Reviewed-by: Gao Xiang <xiang@kernel.org>
>
> I applied the following version manually with an updated
> patch subject.
>
> From 135d84c66f85426299db01a09d93a79a87af18ba Mon Sep 17 00:00:00 2001
> From: Binglei Wang <l3b2w1@gmail.com>
> Date: Fri, 11 Sep 2026 12:11:33 +0800
> Subject: [PATCH] erofs: add missing buf->off in erofs_bread()
>
> erofs_bread() locates the target folio with
>
>  index =3D (buf->off + offset) >> PAGE_SHIFT;
>
> but computes the in-folio offset without taking buf->off into account:
>
>  return buf->base + (offset & ~PAGE_MASK);
>
> If buf->off is not page-aligned, the returned pointer misses the in-page
> component of buf->off, so callers end up fetching data from a wrong
> offset.
>
> buf->off is set to sbi->dif0.fsoff in erofs_init_metabuf(), and fsoff can
> be specified via the "fsoffset=3D" mount option, which only requires
> block-size alignment. Therefore, on an image with a sub-page block size
> (e.g. 512 bytes), a non-page-aligned fsoff (e.g. 512) triggers the issue,
> since 512 is a multiple of the block size but not of PAGE_SIZE.
>
> It can be reproduced by mounting an image that is placed at a
> non-page-aligned offset:
>
>  mkfs.erofs -b512 -zlz4hc sub.erofs src/
>  # prepend 512 bytes of padding to the image
>  mount -t erofs -o loop,fsoffset=3D512 padded.erofs /mnt
>
> which fails with
>
>  erofs (device loop0): cannot find valid erofs superblock
>
> because the on-disk superblock (at offset 1024 within the image, i.e.
> 1536 within the padded file) is read from a wrong in-folio offset. With
> this fixed, the very same image mounts successfully and its file contents
> match those read from the unpadded image.
>
> Fix it by including buf->off in the in-folio offset calculation, so that
> it is consistent with the folio index calculation.
>
> Fixes: c36ec00d7f67 ("erofs: add 'fsoffset' mount option to specify
> filesystem offset")
> Signed-off-by: Binglei Wang <l3b2w1@gmail.com>
> Reviewed-by: Gao Xiang <xiang@kernel.org>
> Signed-off-by: Gao Xiang <xiang@kernel.org>
> ---
>  fs/erofs/data.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/fs/erofs/data.c b/fs/erofs/data.c
> index 0885b1f2fc92..be63b89f0862 100644
> --- a/fs/erofs/data.c
> +++ b/fs/erofs/data.c
> @@ -48,7 +48,7 @@ void *erofs_bread(struct erofs_buf *buf, erofs_off_t
> offset, bool need_kmap)
>                 return NULL;
>         if (!buf->base)
>                 buf->base =3D kmap_local_page(buf->page);
> -       return buf->base + (offset & ~PAGE_MASK);
> +       return buf->base + ((buf->off + offset) & ~PAGE_MASK);
>  }
>
>  int erofs_init_metabuf(struct erofs_buf *buf, struct super_block *sb,
> --
> 2.47.3
>
>

--000000000000911796065b2d70b1
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Thanks for the feedback!=C2=A0 I will check it.</div><br><=
div class=3D"gmail_quote gmail_quote_container"><div dir=3D"ltr" class=3D"g=
mail_attr">Gao Xiang &lt;<a href=3D"mailto:xiang@kernel.org">xiang@kernel.o=
rg</a>&gt; =E4=BA=8E2026=E5=B9=B49=E6=9C=8811=E6=97=A5=E5=91=A8=E4=BA=94 12=
:19=E5=86=99=E9=81=93=EF=BC=9A<br></div><blockquote class=3D"gmail_quote" s=
tyle=3D"margin:0px 0px 0px 0.8ex;border-left:1px solid rgb(204,204,204);pad=
ding-left:1ex">Hi Binglei,<br>
<br>
On Fri, Sep 11, 2026 at 12:01:48PM +0800, binglei wang wrote:<br>
&gt; erofs_bread() locates the target folio with<br>
&gt; <br>
&gt;=C2=A0 index =3D (buf-&gt;off + offset) &gt;&gt; PAGE_SHIFT;<br>
&gt; <br>
&gt; but computes the in-folio offset without taking buf-&gt;off into accou=
nt:<br>
&gt; <br>
&gt;=C2=A0 return buf-&gt;base + (offset &amp; ~PAGE_MASK);<br>
&gt; <br>
&gt; If buf-&gt;off is not page-aligned, the returned pointer misses the in=
-page<br>
&gt; component of buf-&gt;off, so callers end up fetching data from a wrong=
<br>
&gt; offset.<br>
&gt; <br>
&gt; buf-&gt;off is set to sbi-&gt;dif0.fsoff in erofs_init_metabuf(), and =
fsoff can<br>
&gt; be specified via the &quot;fsoffset=3D&quot; mount option, which only =
requires<br>
&gt; block-size alignment. Therefore, on an image with a sub-page block siz=
e<br>
&gt; (e.g. 512 bytes), a non-page-aligned fsoff (e.g. 512) triggers the iss=
ue,<br>
&gt; since 512 is a multiple of the block size but not of PAGE_SIZE.<br>
&gt; <br>
&gt; It can be reproduced by mounting an image that is placed at a<br>
&gt; non-page-aligned offset:<br>
&gt; <br>
&gt;=C2=A0 mkfs.erofs -b512 -zlz4hc sub.erofs src/<br>
&gt;=C2=A0 # prepend 512 bytes of padding to the image<br>
&gt;=C2=A0 mount -t erofs -o loop,fsoffset=3D512 padded.erofs /mnt<br>
&gt; <br>
&gt; which fails with<br>
&gt; <br>
&gt;=C2=A0 erofs (device loop0): cannot find valid erofs superblock<br>
&gt; <br>
&gt; because the on-disk superblock (at offset 1024 within the image, i.e.<=
br>
&gt; 1536 within the padded file) is read from a wrong in-folio offset. Wit=
h<br>
&gt; this fixed, the very same image mounts successfully and its file conte=
nts<br>
&gt; match those read from the unpadded image.<br>
&gt; <br>
&gt; Fix it by including buf-&gt;off in the in-folio offset calculation, so=
 that<br>
&gt; it is consistent with the folio index calculation.<br>
&gt; <br>
&gt; Fixes: c36ec00d7f67 (&quot;erofs: add &#39;fsoffset&#39; mount option =
to specify<br>
&gt; filesystem offset&quot;)<br>
&gt; Cc: &lt;<a href=3D"mailto:stable@vger.kernel.org" target=3D"_blank">st=
able@vger.kernel.org</a>&gt; # 6.16+<br>
&gt; Signed-off-by: Binglei Wang &lt;<a href=3D"mailto:l3b2w1@gmail.com" ta=
rget=3D"_blank">l3b2w1@gmail.com</a>&gt;<br>
<br>
The fix looks fine, but the patch format is broken:<br>
Reviewed-by: Gao Xiang &lt;<a href=3D"mailto:xiang@kernel.org" target=3D"_b=
lank">xiang@kernel.org</a>&gt;<br>
<br>
I applied the following version manually with an updated<br>
patch subject.<br>
<br>
From 135d84c66f85426299db01a09d93a79a87af18ba Mon Sep 17 00:00:00 2001<br>
From: Binglei Wang &lt;<a href=3D"mailto:l3b2w1@gmail.com" target=3D"_blank=
">l3b2w1@gmail.com</a>&gt;<br>
Date: Fri, 11 Sep 2026 12:11:33 +0800<br>
Subject: [PATCH] erofs: add missing buf-&gt;off in erofs_bread()<br>
<br>
erofs_bread() locates the target folio with<br>
<br>
=C2=A0index =3D (buf-&gt;off + offset) &gt;&gt; PAGE_SHIFT;<br>
<br>
but computes the in-folio offset without taking buf-&gt;off into account:<b=
r>
<br>
=C2=A0return buf-&gt;base + (offset &amp; ~PAGE_MASK);<br>
<br>
If buf-&gt;off is not page-aligned, the returned pointer misses the in-page=
<br>
component of buf-&gt;off, so callers end up fetching data from a wrong<br>
offset.<br>
<br>
buf-&gt;off is set to sbi-&gt;dif0.fsoff in erofs_init_metabuf(), and fsoff=
 can<br>
be specified via the &quot;fsoffset=3D&quot; mount option, which only requi=
res<br>
block-size alignment. Therefore, on an image with a sub-page block size<br>
(e.g. 512 bytes), a non-page-aligned fsoff (e.g. 512) triggers the issue,<b=
r>
since 512 is a multiple of the block size but not of PAGE_SIZE.<br>
<br>
It can be reproduced by mounting an image that is placed at a<br>
non-page-aligned offset:<br>
<br>
=C2=A0mkfs.erofs -b512 -zlz4hc sub.erofs src/<br>
=C2=A0# prepend 512 bytes of padding to the image<br>
=C2=A0mount -t erofs -o loop,fsoffset=3D512 padded.erofs /mnt<br>
<br>
which fails with<br>
<br>
=C2=A0erofs (device loop0): cannot find valid erofs superblock<br>
<br>
because the on-disk superblock (at offset 1024 within the image, i.e.<br>
1536 within the padded file) is read from a wrong in-folio offset. With<br>
this fixed, the very same image mounts successfully and its file contents<b=
r>
match those read from the unpadded image.<br>
<br>
Fix it by including buf-&gt;off in the in-folio offset calculation, so that=
<br>
it is consistent with the folio index calculation.<br>
<br>
Fixes: c36ec00d7f67 (&quot;erofs: add &#39;fsoffset&#39; mount option to sp=
ecify filesystem offset&quot;)<br>
Signed-off-by: Binglei Wang &lt;<a href=3D"mailto:l3b2w1@gmail.com" target=
=3D"_blank">l3b2w1@gmail.com</a>&gt;<br>
Reviewed-by: Gao Xiang &lt;<a href=3D"mailto:xiang@kernel.org" target=3D"_b=
lank">xiang@kernel.org</a>&gt;<br>
Signed-off-by: Gao Xiang &lt;<a href=3D"mailto:xiang@kernel.org" target=3D"=
_blank">xiang@kernel.org</a>&gt;<br>
---<br>
=C2=A0fs/erofs/data.c | 2 +-<br>
=C2=A01 file changed, 1 insertion(+), 1 deletion(-)<br>
<br>
diff --git a/fs/erofs/data.c b/fs/erofs/data.c<br>
index 0885b1f2fc92..be63b89f0862 100644<br>
--- a/fs/erofs/data.c<br>
+++ b/fs/erofs/data.c<br>
@@ -48,7 +48,7 @@ void *erofs_bread(struct erofs_buf *buf, erofs_off_t offs=
et, bool need_kmap)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return NULL;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 if (!buf-&gt;base)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 buf-&gt;base =3D km=
ap_local_page(buf-&gt;page);<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0return buf-&gt;base + (offset &amp; ~PAGE_MASK)=
;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0return buf-&gt;base + ((buf-&gt;off + offset) &=
amp; ~PAGE_MASK);<br>
=C2=A0}<br>
<br>
=C2=A0int erofs_init_metabuf(struct erofs_buf *buf, struct super_block *sb,=
<br>
-- <br>
2.47.3<br>
<br>
</blockquote></div>

--000000000000911796065b2d70b1--

