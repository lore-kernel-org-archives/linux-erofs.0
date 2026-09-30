Return-Path: <linux-erofs+bounces-4640-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 93012CA5FBA
	for <linux-erofs@archiver.kernel.org>; Wed, 30 Sep 2026 11:30:00 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hvtBG6KLQz2yqT;
	Wed, 30 Sep 2026 21:29:58 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=pass smtp.remote-ip="2607:f8b0:4864:20::1230" arc.chain=google.com
ARC-Seal: i=2; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1790767798;
	cv=pass; b=jsr7CiP6E+KrvnuXRWNSUs/nFcbktZ01KTbaCGONLQ2INh2ywkgBuzoBPEe/BR5L+4l0lC062BovGevtSUc+nNLVsmBQeEGIX2/r9hTs47CHo9HiQynOYnOKBdgjvOuUlc6kKBKp5Tkbc9AxhSC/VAo8m3ZxuArSicUxy5f5PWqBHRYr+ITdDQ7lC7lNs1T+bS2R7qmse9omdiJzL4OLK3P53xgLLzMnKfqnfSdPjaJvCJAQ1R/SD8ZfHxIRMdeOGWm4XudoSZMzwiuin+8+/gzDWuCWqnvUef6q4CFDmOUPY2eurfjS1/IKHGUL3rgJz2xhuiKYjzz6tmnCe5CXtw==
ARC-Message-Signature: i=2; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1790767798; c=relaxed/relaxed;
	bh=VI9FMfHBO8Xce1RC42SkpR8mv4d8IZMnoN931y6mJ7k=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Content-Type; b=lm20hFjtOHmxofbZk93mdVCkvZIL5kuA+IKEgxxwzNEYlfiJrZwycqHV7IuKhrX3BDJXVHF+9QNfyy6CsFQD0digQAA5FpMgZOroYOwvCsgTTJoaJ4Qf1XiDWKorbRbItF8be+oQP5fYgaPcaV5qi0OkYjHRuX3FGpGqSdw+jGwBUSo7OQzPDjcjTgX6yKrrRt9fX/JHN+U2Xa9SpziFKJGiTRjI1k/gqnM+Knjxhj/nuWxB9iWg63b5W1e2muAySCqy6sVShYKR3doLGAe3/3vFI/xb0NUKpypZL9hw6ryJ+OkLcSRIJhsFLqu8OyW5QqyDGXwGmErNpbzwZQQLRw==
ARC-Authentication-Results: i=2; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=gmail.com; dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=eUovcwGB; dkim-atps=neutral; spf=pass (client-ip=2607:f8b0:4864:20::1230; helo=mail-dl1-x1230.google.com; envelope-from=l3b2w1@gmail.com; receiver=lists.ozlabs.org) smtp.mailfrom=gmail.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=eUovcwGB;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=gmail.com (client-ip=2607:f8b0:4864:20::1230; helo=mail-dl1-x1230.google.com; envelope-from=l3b2w1@gmail.com; receiver=lists.ozlabs.org)
Received: from mail-dl1-x1230.google.com (mail-dl1-x1230.google.com [IPv6:2607:f8b0:4864:20::1230])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hvtBF5D8pz2xmh
	for <linux-erofs@lists.ozlabs.org>; Wed, 30 Sep 2026 21:29:56 +1000 (AEST)
Received: by mail-dl1-x1230.google.com with SMTP id a92af1059eb24-144f79153f5so732236c88.0
        for <linux-erofs@lists.ozlabs.org>; Wed, 30 Sep 2026 04:29:56 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790767793; cv=none;
        d=google.com; s=arc-20260327;
        b=GIAJgObYWIfpamHKCZm4RHYlUMREkqj0qEEJZIDVovufGazYuIKX4v9AHYJlNAn3HG
         BPw1TCXPvVhAc5ESvs+Mj/qHAI0+J6LYkizZ9CnOMRAvv224ZKCZ+PVBoMsc+4zOqoSt
         M1Ai8rtnTx+F+/YHX4OqOjWuDUOPK4uuqP2TIseSTkafpLf4s6iOWd+b24zO8wz3YQMC
         rP2Wey/c73I2Q/Y6WzemL4fxjSvph/dhsw/9MnAxOzblOsqlh5QnGS9rQSEZHwO0JQNo
         mekf1jIzEiofqkfRRD3Oq4/Ah7rJ85x0/g1l6Ulr6za8jN40ReegfxlyyVNhfZ+WiC2q
         Xsvw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=VI9FMfHBO8Xce1RC42SkpR8mv4d8IZMnoN931y6mJ7k=;
        fh=remeewZxP07cSQ1yBMbYdglnWgzlTASU110VTFc62q8=;
        b=mNI46LZE6qzTp3+NhENv8FSgizcOeoDNRNHelHYKmhBGMAoQPDbJqM88XrXbzbWYWS
         rqgC1OMvLlRkgp7qQcJbRqe/PONYaXdrsov6/TdeNb5BleHZPSs23F/tWhoK7Kz7bJwo
         kdQWfcQe6jPeBXLCItmljjDxnN4v7M92dL9iP04QJ+yimc2Kc5CqMGa7XEG6wmB0Kxhy
         CTlPWoUz65efs2fTo7wOtFsmQ1adEgWIdDoISKuPz0cvyxzjKAfDXkD4boow0fHXmwpy
         aF1umF659VP9ZtQX7HkXzx3DgPoRnjgeYMHWU2R49G3/GfUFUTZy6xKozmCoyLzWEpPT
         4CzA==;
        darn=lists.ozlabs.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790767793; x=1791372593; darn=lists.ozlabs.org;
        h=content-transfer-encoding:content-type:to:subject:message-id:date
         :from:in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=VI9FMfHBO8Xce1RC42SkpR8mv4d8IZMnoN931y6mJ7k=;
        b=eUovcwGBTOXpk/xMK0wtWQx5eNz5SafGePCUDGlAU+8CPzhrfio6tEiNAjLjCIGhSu
         s9kSfgcYkAxCg60SB6ajpZ72bng3YdH+B2Z+8WpOIF2pKZkPeOBC1Dn7OQiE2K6Pvy+N
         OXnDwit0ikhHCt0+wm4MXcCgAVwjvZoA8t5lotiOr3fFtPfRxaTOih70/RKggHCd14Te
         UAlxwfEXSw7wPjkiMBtfZ/XBDpfzXaPuO+cikbCt8fReN/dXti0czfM1V8qMWxCzZGWJ
         tYuNbr7NDSBubNiVfDZxvIHr5S6R3SSLI0vbLpD91fSe/qtCs584FZx9xszQMynAVOEL
         VYdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790767793; x=1791372593;
        h=content-transfer-encoding:content-type:to:subject:message-id:date
         :from:in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=VI9FMfHBO8Xce1RC42SkpR8mv4d8IZMnoN931y6mJ7k=;
        b=pwHPLpzTN3uF/7+Jl4dTSf0x8s3zCIpumLvNnwyCsnKnKmn5v1bp8n/nGMRArlx5Cx
         Esop4Iz4+TdtDJ45Pdj7vCuxOTMmOm7m8m2y5VELmVcHmjTd4vbiZaPDViJ92s/CZlFF
         186VTJ2vkYOWA/KjDYUXTacUETHEOB+Uq3sRGBtME3WdzCNmPSnY4IvFdxbBqPr+F5RY
         fxcPPvYke2/EUq0Y62hSuza9ItAK/6kx/awOjS2H8NigsdRUSdIzkirRIByy8F/T16rb
         1ptrHjNr07PPsnFdtwye8HDLikUt6iLkXnH693R4p/IDOs3wRruchn9+xezw4PIGR9Pi
         axZQ==
X-Forwarded-Encrypted: i=1; AKwUvByxa2r589LYYRiWDBJZxrPR76zPcykqqJjMKgqBVPj7qP7Pypug5ilcc7uh4sk3b9TyQq1POSrCu6L5ng==@lists.ozlabs.org
X-Gm-Message-State: AFuF++kKHUjSLIVtYR5sS/OkEj9Mv0pCem7tKf2j8C0cGxOWoS0/AQLN
	3J0F67MLGeoNeRjqIg48YUPpzIm0Qu97x1YtcWURmYUEHgbhOU569k0NVZ07rV5jVn4giZr+vgb
	6MjLuU3Gpw3LEjnhUonM6QRlofgeBFCY=
X-Gm-Gg: AYBFou2+/W2fTsulSMj9YTHlIUknlYLlahs2yyeQEVz4oBRPIzzK+x9aIViFWJqtibr
	DTpwC5lKxQ3nYtEkCb5MbN1YVB1lgIacW2vfNwDJ4BnMmylnKKvsbOoFSM+OAB6pH9MGZKR8kda
	3Ss22r/s6mTgh+0UGvVCOGoZ/oRvnojpBclkWpbUWwDD7ettsxvNwFe4uFDTt4UeMktHoUwGxPH
	76fpGJTgRlBTDg0297LzhypufbX1kDTHZhNoboLy0qQ6xgXy5yOxD5hBRTDe+oQgmNt76a/7Pcv
	RsNMc6zF1MZ4ab6SRMofpD1JtPWk75tUhIcJtgbZdWnpSU3FNjqhrjzB
X-Received: by 2002:a05:7022:ed02:b0:143:1bb1:32ff with SMTP id
 a92af1059eb24-14d34ad85fbmr972307c88.16.1790767793097; Wed, 30 Sep 2026
 04:29:53 -0700 (PDT)
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
References: <CAJ3C4KySUqKevOBn=CROzsWkaLdK_X241oLFXO26FKBVq73QJg@mail.gmail.com>
 <ary_wjlpYNWbqaHU@MacBookPro>
In-Reply-To: <ary_wjlpYNWbqaHU@MacBookPro>
From: binglei wang <l3b2w1@gmail.com>
Date: Wed, 30 Sep 2026 19:29:41 +0800
X-Gm-Features: AclHuK-p_Xk2V1xVIcpsl-hSdtHJfx0KgIA3_98DoxwM1xsRTEU7UjoPuOvA3hI
Message-ID: <CAJ3C4KwGis=rhUp7GPXMCTAn0Tf3mLbf0DgSGhOsd6mvzwRbPA@mail.gmail.com>
Subject: Re: [PATCH] erofs: fix folio reuse from a different address_space in erofs_bread()
To: binglei wang <l3b2w1@gmail.com>, xiang@kernel.org, chao@kernel.org, 
	linux-erofs@lists.ozlabs.org, zbestahu@gmail.com, jefflexu@linux.alibaba.com, 
	dhavale@google.com, hongbohbli@tencent.com, guochunhai@vivo.com, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Sorry, my webbrowser email client configs with something wrong. Thanks
for your reply.

I re-sent the patch from my Linux shell. I believe it's OK this time.


Gao Xiang <xiang@kernel.org> =E4=BA=8E2026=E5=B9=B49=E6=9C=8830=E6=97=A5=E5=
=91=A8=E4=B8=89 15:52=E5=86=99=E9=81=93=EF=BC=9A
>
> On Wed, Sep 30, 2026 at 11:37:53AM +0800, binglei wang wrote:
> > erofs_bread() caches the last folio in struct erofs_buf and reuses it w=
hen
> > the next request lands on the same folio, but the reuse predicate only
> > compares the page index; it never checks that the cached folio still
> > belongs to buf->mapping.  Correctness therefore relies on an invariant
> > that is nowhere enforced.
> >
> > fs/erofs/xattr.c already breaks it: erofs_xattr_iter_inline() and
> > erofs_xattr_iter_shared() call erofs_init_metabuf() on the same buffer
> > with no intervening erofs_put_metabuf(), and their in_metabox arguments
> > come from different sources (per-inode vs per-fs).  When the two differ=
,
> > buf->mapping is switched while buf->page still holds a folio of the
> > previous address_space, so the next erofs_bread() can return data from
> > the wrong one.
> >
> > This is observable with METABOX enabled, where shared xattrs silently
> > disappear on the mounted fs, while the same tree built without METABOX
> > reports them fine.
> >
> > Fix it by validating the address_space in the reuse predicate too: if t=
he
> > cached folio belongs to another mapping, drop it so that the existing
> > slow path re-reads from buf->mapping.  Reading folio->mapping is safe
> > here because a reference on the cached folio is still held; if the foli=
o
> > was already truncated, folio->mapping is NULL and the slow path is take=
n,
> > which is the safe direction.
> >
> > Fixes: 414091322c63 ("erofs: implement metadata compression")
> > Cc: Bo Liu (OpenAnolis) <liubo03@inspur.com>
> > Signed-off-by: Binglei Wang <l3b2w1@gmail.com>
>
> Thanks for the patch.
>
>  1) The patch format is still broken as your previous patch, please
>     check your email client again before sending out a new patch
>     (as I said, you could send a patch to yourself and try to apply
>      the patch and see if it works);
>
>  2) the commit message of this patch is too over long (mostly
> in the LLM-generated style), I think you could simplify a bit since
> it's more friendly to human developers.
>
> > ---
> >  fs/erofs/data.c | 7 ++++++-
> >  1 file changed, 6 insertions(+), 1 deletion(-)
> >
> > diff --git a/fs/erofs/data.c b/fs/erofs/data.c
> > index be63b89f0862..d8b6523bc218 100644
> > --- a/fs/erofs/data.c
> > +++ b/fs/erofs/data.c
> > @@ -33,8 +33,13 @@ void *erofs_bread(struct erofs_buf *buf,
> > erofs_off_t offset, bool need_kmap)
> >
> >   if (buf->page) {
> >   folio =3D page_folio(buf->page);
> > - if (folio_file_page(folio, index) !=3D buf->page)
> > + if (folio->mapping !=3D buf->mapping) {
> > + /* the cached folio belongs to another address_space */
> > + erofs_put_metabuf(buf);
> > + folio =3D NULL;
>
>      `folio =3D NULL` is enough?
>
> Thanks,
> Gao Xiang
>
> > + } else if (folio_file_page(folio, index) !=3D buf->page) {
> >   erofs_unmap_metabuf(buf);
> > + }
> >   }
> >   if (!folio || !folio_contains(folio, index)) {
> >   erofs_put_metabuf(buf);

