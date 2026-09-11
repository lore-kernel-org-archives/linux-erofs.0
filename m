Return-Path: <linux-erofs+bounces-4538-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A1AE4C79FA1
	for <linux-erofs@archiver.kernel.org>; Fri, 11 Sep 2026 04:33:53 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hh1rw1Wbxz2yd7;
	Fri, 11 Sep 2026 14:33:52 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=pass smtp.remote-ip="2607:f8b0:4864:3b::10" arc.chain=google.com
ARC-Seal: i=2; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1789101232;
	cv=pass; b=VxwwwxfDpKF4ZtIV6KaK4a9etD9+z3V5EarsmHHzZHo7XsEMLwzUDD9DoCHq3n6fYrDOnOGByjxwkAf+USbFW+uERu57XE3d2/I0I/LZz7kHPR8SKinwDN6/TwqfHzWcMrjTIpbctdhKilyOuUDGyyw97BaQRBi7lYvtNaPoKuEEYXFN+kLvP5ecyGJQFcw4qIIzRl0JPLzLxVpYSEAuHsLSCU8V+N7xafuOleE8CDMbvKct3TDF1X0cGpQOtXCTJNNKoGqVPubEbakVfhVYJh1tSpWcOGiSBbstscCjX4/JpGZu+KGIeqB6eqvsD6/cJokKlzvNyZ/RvCAPkzMEeQ==
ARC-Message-Signature: i=2; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1789101232; c=relaxed/relaxed;
	bh=dIWRR//ZGZfoOim50ZwGoG0z8YUpZDtxKvhcTftzbMI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Content-Type; b=VT6I0cbm7NqmKqugQbzGuiRuHTQdgPD7j4FYPo07rBox9t97DAOg1ugQNGa0274WkY/E0OQ7UQj5uXQ4zbS/k32WFlEK0sbWpTXzcoOQ4RgA5tDSuVGMjpVzdbnIHQISlKbtkPR5TetAOaXCsZvLukwcOwGytjgUnOoApsGqz0W/SymMmFBWbBuYJN9ku4ZRcJWcGybhgJKlocv7uEaM6ZaRt0uMM0tSnLr2RQBt1hHUy3PSEmxTcOBDTQRKqYuTsIr6EETXWcO0FcEB7Y56cD7EGJywKnKj+TrYdAfQO6SWN0eNYd40PaWp7mR5ELJiImHM1Jq03ddwzAYCxGiiLw==
ARC-Authentication-Results: i=2; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=gmail.com; dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=E/7VJlnO; dkim-atps=neutral; spf=pass (client-ip=2607:f8b0:4864:3b::10; helo=mail-pz2-x10.google.com; envelope-from=l3b2w1@gmail.com; receiver=lists.ozlabs.org) smtp.mailfrom=gmail.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=E/7VJlnO;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=gmail.com (client-ip=2607:f8b0:4864:3b::10; helo=mail-pz2-x10.google.com; envelope-from=l3b2w1@gmail.com; receiver=lists.ozlabs.org)
Received: from mail-pz2-x10.google.com (mail-pz2-x10.google.com [IPv6:2607:f8b0:4864:3b::10])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hh1rv1mNJz2yFj
	for <linux-erofs@lists.ozlabs.org>; Fri, 11 Sep 2026 14:33:49 +1000 (AEST)
Received: by mail-pz2-x10.google.com with SMTP id 41be03b00d2f7-cc4ae61629fso398691a12.2
        for <linux-erofs@lists.ozlabs.org>; Thu, 10 Sep 2026 21:33:49 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789101227; cv=none;
        d=google.com; s=arc-20260327;
        b=bNUXLNM673cUConCKLErk3kp29MX9Xnpb8hxgrb8R/s2i/B5ZaJectj7zZWmigIpTg
         q4+tWxvujYDG4RR+RbYOmYeogi2GsiYYZ/ZkhxHCIXYxD8jqhmn7SYHrVJvhyaaEf2gO
         OFoZLwb/fSI0yYNVDcJ195gCRTp7yhs66U71grSN9zFBpFWhDTcr29SkRulkkBeLg4wQ
         ZrEMrlf/gvNiA4IiGjOxo3apEBCC+zmT9yrDRJfa0Rsz7c0eFotywhKP4DB7A/bafcbi
         xxzkZqefais4DpkvQF2uzcayLNDdHQKfdk8b5Ag5NqjM5Rda0/y16IlrqLl6NzL2bKlE
         gx5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=to:subject:message-id:date:from:in-reply-to:references:mime-version
         :dkim-signature;
        bh=dIWRR//ZGZfoOim50ZwGoG0z8YUpZDtxKvhcTftzbMI=;
        fh=FMqlO85htAUNPfP5vWwpNH5eSZmHP1R+0BGa/HNnkFw=;
        b=naihOSt4oreSTNKsUPYFmt4u82gEnWx8INCr9w3+05/wjh1HlR2RjzYmY6I36EmsId
         t+PxDHuSRuSjNSPP5we/Gdvr7NDe34vHyK9Hs0FEKwwXdilL3CnSvZ8Bd8jbMVjuHtiC
         /RTVOwa1si/chMZacdLSnODkb3E/+OfZx7OIBxjQKV39NCUFQ8vf5PuXm/fg0xCzm/Y5
         k4D48l3OT3sk2+dKWamwB952ZiKUyqkh51DBMI3u9vM/ebDbNkUqsUgkMfNn6BiiNgNj
         74+NyOieZARvBxN0sujdd84agOlyqOjYwzFiolITNtgCwbqeJw05qHdT3bvC+3LB7WAy
         smQw==;
        darn=lists.ozlabs.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789101227; x=1789706027; darn=lists.ozlabs.org;
        h=content-type:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=dIWRR//ZGZfoOim50ZwGoG0z8YUpZDtxKvhcTftzbMI=;
        b=E/7VJlnOVntjLgVEPz/IlCYjeA/BmaaJqjx0Y22NqfSdtATRHAHlPHaPGwPpdEhL6I
         KjAkqVR87lhsOL3/cmuYPLl1zxydlqZYtnJuQjajD05Eai6/g1GNHQ4rhRflZO9QmjNa
         4M7pLBQHXKpSNMcn8El4kbur7OAsP9zVEyv2MzOI9MF0oBzhxQHj/S8WTxl6ZHA2yYlO
         a4dv90Uwb77flgzF/eqnQEYukslKxgqLVDWQlCjU3Tp8BjjWIBbJ1jsJ6c+1CunkZVws
         PiMvS4dZwZSA9hrf1bV6bLuz/JHu5a5WbO5eQ5ybnB26h6p0cq5qlOjoYuUE7ybvzBOC
         6WHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789101227; x=1789706027;
        h=content-type:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=dIWRR//ZGZfoOim50ZwGoG0z8YUpZDtxKvhcTftzbMI=;
        b=RRIYw1xijY0TidqSEQckGAIksr9qnFfurkxqH2wdwT7NLCQ77DCpBWAqLtnT0P2h5m
         WVbrdvVam1VQMEDs1eVpr6RMba7Uq8PwQA9/dcpGbn1SMPIfLBtBhvnls4KVO7OsUtqw
         DZs7GuDGOSTwKhu+aBnWVBc5i5UAUmaXxvi0gFl2RyNZeR4KTT3KNk4SmBzrs7xFfYwl
         yJvy69NcW2VfRfUHK6OIu8hAJ5JsOTBEsdpqUvCTSH0QzRwLdbVuHZkR4Pd/Ppw58gdX
         BNEEeJZqOf+riVE3V690uUAGEWW3KoW7pmp02qObbwsUsXbseH2w6anDvauN9V1zANs5
         d3wA==
X-Forwarded-Encrypted: i=1; AKwUvBxyGvot6iSwjoZhlJIXcPzdeVVGKuL6jzH3Y+gQfHRaRnVwQmwRVJAghkd6Zf6jopy2tthnQyr+v7rhTA==@lists.ozlabs.org
X-Gm-Message-State: AFuF++m8+tBl95Nlp3tLWoEWhJBp+d9tgej8lcd8zP3XGasyStmlMGbY
	D3DqoZ268haGxkYdbo79McNFuvE0XJuL9Hfo5kYH8cqvMrMOCQ2hkK6P2GflPI30NEp/B9t/X/F
	OUByN1LpJ0OCMNRsPej/XAO8wDp0ipAo=
X-Gm-Gg: AYBFou22ZqaGaAKaGA0/Z8g2DVw+C+YYU1KovPhydbELWyDrWAoERPPUcu32j6lDIJb
	2KAEumYlNvb2N3UQGJucL6aWfQdAyOA/Lds8pqsZqcVZpwq+leDJUSkIjyVCSJs5SYIDetuY269
	1ruvgy0+KJexO+sHdQr3LfLKInt2KdYydeXdrduFvtmq5knxtYnH2pO6OyFe9rq3XbBDGm9HA9j
	G3qprSYyEJIUMP66fXLbw5kYEc82QUH6h1cQsyMRe8FAB8iApzFrzVGreUBrk1btQ3Z0jsL6/Mc
	kc7jOylflaUect3ED4dqkd865Nx+Jj+YLmfKxioWBRt5ayLCWTQFy70=
X-Received: by 2002:a05:6a21:6d8a:b0:3d3:adbf:777e with SMTP id
 adf61e73a8af0-3daed49d798mr4458336637.19.1789101227001; Thu, 10 Sep 2026
 21:33:47 -0700 (PDT)
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
References: <CAJ3C4Kwms2my+y_T0Mx+XM_gb9gs7cVZ7w4v2GRAURF1rRFU0g@mail.gmail.com>
 <aqOCEK8T209eXwnW@XiangdeMacBook-Pro.local>
In-Reply-To: <aqOCEK8T209eXwnW@XiangdeMacBook-Pro.local>
From: binglei wang <l3b2w1@gmail.com>
Date: Fri, 11 Sep 2026 12:33:33 +0800
X-Gm-Features: AcwNN1W1AIpgKaGpweBB6AFAoXMuc1DVKBzixOJVGID7PmH3zvI9HfJEzERWX1M
Message-ID: <CAJ3C4Ky_Gk=shyh+ZM=x9_xYbBk=tUS1kcMiBZEp+hXLMBO1pQ@mail.gmail.com>
Subject: Re: [PATCH] erofs: fix unbalanced buf->off handling in erofs_bread()
To: binglei wang <l3b2w1@gmail.com>, linux-erofs@lists.ozlabs.org, xiang@kernel.org, 
	chao@kernel.org, shengyong1@xiaomi.com, zbestahu@gmail.com, 
	jefflexu@linux.alibaba.com, dhavale@google.com, hongbohbli@tencent.com, 
	guochunhai@vivo.com, wangshuai12@xiaomi.com, linux-kernel@vger.kernel.org
Content-Type: multipart/alternative; boundary="0000000000001a512d065b2d97a6"

--0000000000001a512d065b2d97a6
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Thanks for the review. The code fix is unchanged. I've resent the patch in
plain text with proper formatting. Sorry for the noise.

Gao Xiang <xiang@kernel.org> =E4=BA=8E 2026=E5=B9=B49=E6=9C=8811=E6=97=A5=
=E5=91=A8=E4=BA=94 12:22=E5=86=99=E9=81=93=EF=BC=9A

> Hi,
>
> On Fri, Sep 11, 2026 at 12:16:56PM +0800, binglei wang wrote:
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
> As I said, I applied a modified version:
> https://lore.kernel.org/r/aqOBLWQEkH7_3LSu@XiangdeMacBook-Pro.local
>
> I think if you have some email client issue, you could loop the patch to
> your own email, download it from your mailbox and try to apply locally
> for self-testing first.
>
> Thanks,
> Gao Xiang
>

--0000000000001a512d065b2d97a6
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"auto">Thanks for the review. The code fix is unchanged. I&#39;v=
e resent the patch in plain text with proper formatting. Sorry for the nois=
e.</div><br><div class=3D"gmail_quote gmail_quote_container"><div dir=3D"lt=
r" class=3D"gmail_attr">Gao Xiang &lt;<a href=3D"mailto:xiang@kernel.org">x=
iang@kernel.org</a>&gt; =E4=BA=8E 2026=E5=B9=B49=E6=9C=8811=E6=97=A5=E5=91=
=A8=E4=BA=94 12:22=E5=86=99=E9=81=93=EF=BC=9A<br></div><blockquote class=3D=
"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding=
-left:1ex">Hi,<br>
<br>
On Fri, Sep 11, 2026 at 12:16:56PM +0800, binglei wang wrote:<br>
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
&gt; Cc: &lt;<a href=3D"mailto:stable@vger.kernel.org" target=3D"_blank" re=
l=3D"noreferrer">stable@vger.kernel.org</a>&gt; # 6.16+<br>
&gt; Signed-off-by: Binglei Wang &lt;<a href=3D"mailto:l3b2w1@gmail.com" ta=
rget=3D"_blank" rel=3D"noreferrer">l3b2w1@gmail.com</a>&gt;<br>
<br>
As I said, I applied a modified version:<br>
<a href=3D"https://lore.kernel.org/r/aqOBLWQEkH7_3LSu@XiangdeMacBook-Pro.lo=
cal" rel=3D"noreferrer noreferrer" target=3D"_blank">https://lore.kernel.or=
g/r/aqOBLWQEkH7_3LSu@XiangdeMacBook-Pro.local</a><br>
<br>
I think if you have some email client issue, you could loop the patch to<br=
>
your own email, download it from your mailbox and try to apply locally<br>
for self-testing first.<br>
<br>
Thanks,<br>
Gao Xiang<br>
</blockquote></div>

--0000000000001a512d065b2d97a6--

