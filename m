Return-Path: <linux-erofs+bounces-4335-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CCDF8C5DF81
	for <linux-erofs@archiver.kernel.org>; Mon, 24 Aug 2026 15:40:05 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hTFTw0PjJz2xpv;
	Tue, 25 Aug 2026 01:40:04 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=pass smtp.remote-ip="2a00:1450:4864:20::534" arc.chain=google.com
ARC-Seal: i=2; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1787586003;
	cv=pass; b=mXgcJ2J/g0z+21HfdSKwl3BsvtLlOLayQumkfhekoGTbyXhLTDVtPkn0VgSzyRMAfHlzY3WnQoGngdOab9GhvetLEW2NMWn/PJQakgcOmALqZfgC1a6B868ate5EiYbuRX5iig3ZGkLh9D0B77pHeuUa/gF2+k+7J6riT8LXvJoLF4auNRNS6hzgnlqF6Jvc59Nv9rR7j7Z9HMVr7qc9dHvFg2DmbE7qq/PlhXHSM+hbe6hhSMuGl7zlIL3f8PAebeOCKYTvtcxq8Dwt3FlLHz2EcJTB03shUOTP/XqpS0uaptdXB5GaAzFSxhM+io8h6FdibyjvHNVczu7UfwpN1Q==
ARC-Message-Signature: i=2; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1787586003; c=relaxed/relaxed;
	bh=wJCHcWH/H7HoSqeQAsfWyCv2ylIhs9AEwOmpHAgZ6Mo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=m1Cu5uPwHVx/CHtQaQVzo8HM6L3QRJ36gDBHoEUiEnAFBt2Ny7+th2R97Mwo3fUKJ7I3UydXEVJ2LCXJnJc8JAn8Wwr7dH8ykZhcMJJULY53PM4iOq/JWo2FlYOQh3MyqUzv2xrSpPF8SbdXse0K46peZ8YtISeyPsyhpPB1B2XkPyww5rTskPR87aYMN7jIFOArxbMkxZC9QrDKANmeUov9o4yCNaOI1sWPEM6zUSTrpjxlj8isasHJ6DGg0euDfALmGI0rIS0QJnFKNKC1V6LND1maW3hm07uiSW0U51wjMIeEisshLUZbrXR9+Lc/STKXayX/ETYDFDVF1/PNUg==
ARC-Authentication-Results: i=2; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=gmail.com; dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=nyZsRN+A; dkim-atps=neutral; spf=pass (client-ip=2a00:1450:4864:20::534; helo=mail-ed1-x534.google.com; envelope-from=aurelien.couderc2002@gmail.com; receiver=lists.ozlabs.org) smtp.mailfrom=gmail.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=nyZsRN+A;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=gmail.com (client-ip=2a00:1450:4864:20::534; helo=mail-ed1-x534.google.com; envelope-from=aurelien.couderc2002@gmail.com; receiver=lists.ozlabs.org)
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hTFTs6y3cz2xGt
	for <linux-erofs@lists.ozlabs.org>; Tue, 25 Aug 2026 01:40:00 +1000 (AEST)
Received: by mail-ed1-x534.google.com with SMTP id 4fb4d7f45d1cf-6a422090b2fso5366176a12.0
        for <linux-erofs@lists.ozlabs.org>; Mon, 24 Aug 2026 08:40:00 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787585997; cv=none;
        d=google.com; s=arc-20260327;
        b=tAy2yUv+zKSlRoy++5PO0izrQW27XOpF+OjD5VDy30JyXkgSMu7uuEYq7Q0dVZlN6d
         VI5bMUYEW9NdPXUMDq6VFkRbhqLpkPF+q2Mtu7aLiOgMiio+BuQVoJWsI+99/IKx3o3x
         oIH8Ca1JVO5XWzVu+VkyqxrGUlLsEauUJcVM+JM/34b9in/aIqf7tWvFpSBXS6YTIysA
         heKY4sUzv/YdfapKXMd8IRbqQGCu9q/VzOvxNycdUi9O671EWuKlz2mFm7fIckiM3UHL
         dRzD0U1wMM4PdYqGbb+QWi1eSBKlK60lLZWTi/azWPb36HsxY3QJ1jvCWGwtU18Gt7Ca
         4zYg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=wJCHcWH/H7HoSqeQAsfWyCv2ylIhs9AEwOmpHAgZ6Mo=;
        fh=qzhiBwQ32z53zg+j3eUNmZVeuRhyUH6t/0JBoCw5vAg=;
        b=iUQByodEFx/RPCZUFbRO2gqwX649JJW4d6MyeTtmrYcUVaYLWZ5OsyQmJZcWwrLFce
         M/o8OH0yWuJnt9fIUp02hlJ3e602B99RB4DLWR94Ex9RxV41qSJlZz6AvYeyumFP5pT4
         0/zprvl34+DFC3bILyyQBlOVvtzgmdLcOH083h2989CXIntgR42j6dfmO4+dD4oXENPW
         OLzPMwpOg+V51bEAU5MzhQkgx4C/30xoXsn0xX3rrmo9/GqCEJVbePlO+Z75sJ+SWXmS
         PM+EbCw83zE6k0p7dtBcUsa9d68gSKtuOjW6P+3adVz/8YNWDyJUI6ScLJeHwRtO/Z++
         CD0g==;
        darn=lists.ozlabs.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787585997; x=1788190797; darn=lists.ozlabs.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=wJCHcWH/H7HoSqeQAsfWyCv2ylIhs9AEwOmpHAgZ6Mo=;
        b=nyZsRN+AkL8OpFBxgKtgVL3w/PktYgOncFGKK1yzi95g0ODn3W1DHsqly2H2JLuojL
         VUaMau324/fvdrh/DSaIK7Ap4hamEDY9TkKH1wPKIKRmurHH/qIjZyW4gCOTcuegVnwb
         KxHTDgvkuoEB41QmETuRYykFVPFoU6whwib3urlJ1wBFuiyfNoddVeC7Ow6UDUvNCYgU
         wxPbKiD2GRDGgacbbKLosqyLuUk5VJc11v1KWnAnrSeMZAJOqzSa8i8WexIC/w2fsch+
         /ARa1YTnwyADcmor6HcFga5KlbQNd6wl+Uq2c5Jc0V1KhHeUnzveVO7YN5WLSdUgoEk0
         jOJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787585997; x=1788190797;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=wJCHcWH/H7HoSqeQAsfWyCv2ylIhs9AEwOmpHAgZ6Mo=;
        b=MY5PVbx8rvuBakeGaaiqKjqEwlgw0Q0C70rwAvg/vrdspOe8uCu8VJubXdQ+utqNxM
         JhvNGnnBANAKc79VMcFGGryVfI4j93x8iuVAjtaKv67Rxm7qPBJYuBawHoEhpjRVdNkW
         5H282TeV0eBBw0J/huRZsltLl+ebcIst3oRCetUr1DDyfdae8tUDRRP/676cXrhMdpK2
         X7MxwPhFoqxZpezb0UP2qtEQsKRnmRdHQ4DF0mZz8vFgtfFk0XVjy89PRMuw1F9Y7t0G
         ghl21BgEz7tuq0AXl2aowpB/UA2qRM/Oq2c2EX5ggxMimdMO28ZEIzmDgS60E90ib+sW
         fSiQ==
X-Forwarded-Encrypted: i=1; AHgh+Rr0N9Cp54HFzZws4dD+zHIOs928Vkbn1DI0UpEwTaOOvWDr1nZ01rznXfWDM45nMfQ9iMon9te3xciqlw==@lists.ozlabs.org
X-Gm-Message-State: AFuF++l9+afjsjoA/42TQQNyhfeq9FmmJLn7hDyYeW8gMu5E0W9Akrua
	pDbHM7O2NajwMNWUyCpdzE7n4SjePJBg1V/oAg9gpYrfDBX2r0y4L4s1eSQZbDKCCjHqSUPPB5o
	JFAbefJoGIZGVGDVMjvHZeiTsmFmXy2Q=
X-Gm-Gg: AR+sD11nhA/uAYHtAVoB/7boXphXe+oO58E6wSes6LeUsDPgpIzbyQohzcpra+Fc4lU
	7uCN3H3nhtZwnpr93rXTwjZlHk/wxlAEEUJFPfSJei58WpkhOhgVdk/pqGbSiNQxJPmqZoZyTv1
	n4a1A3mB9b12D/fJLcxs/GFrOZIHQBArAvOieRrpy1QtEYOam2/G3fwboqvz3drzCBhgbipNem3
	swux9jux3ycCIzrF0VjJS3sQ8Pp5hnDQNF5cdEyrk/f9gvSAwoxWDBFoDAIwfUaVI9AofBp6n44
	WTwR8QZ6GccPcLIURk3TYafNVHwmUuNZ78JV18csomoYDN3+xanLlk1ub0pkl9u9QK8zerTrl0R
	7
X-Received: by 2002:a05:6402:1ecb:b0:6a0:dda3:83db with SMTP id
 4fb4d7f45d1cf-6a42eec0421mr29612154a12.0.1787585996720; Mon, 24 Aug 2026
 08:39:56 -0700 (PDT)
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
References: <20260824144130.759997-1-dhowells@redhat.com> <20260824144130.759997-31-dhowells@redhat.com>
In-Reply-To: <20260824144130.759997-31-dhowells@redhat.com>
From: =?UTF-8?Q?Aur=C3=A9lien_Couderc?= <aurelien.couderc2002@gmail.com>
Date: Mon, 24 Aug 2026 17:39:20 +0200
X-Gm-Features: AcwNN1UVhOm3jvQyZ6QNY0YG-DuDugP0zSGCGTU-9BV_0e1-yGju4sTdJrlUq5g
Message-ID: <CA+1jF5qPZUhCevwbu7zQDEVWss6gMdoDMhqKqH3k7v=WStRtEA@mail.gmail.com>
Subject: READ_PLUS in NetFS? Re: [PATCH v10 30/35] netfs: Simplify read abandonment
To: David Howells <dhowells@redhat.com>
Cc: Paulo Alcantara <pc@manguebit.org>, Christian Brauner <christian@brauner.io>, 
	Matthew Wilcox <willy@infradead.org>, Christoph Hellwig <hch@infradead.org>, Jens Axboe <axboe@kernel.dk>, 
	Leon Romanovsky <leon@kernel.org>, Namjae Jeon <linkinjeon@kernel.org>, 
	ChenXiaoSong <chenxiaosong@chenxiaosong.com>, Marc Dionne <marc.dionne@auristor.com>, 
	Stefan Metzmacher <metze@samba.org>, Eric Van Hensbergen <ericvh@kernel.org>, 
	Dominique Martinet <asmadeus@codewreck.org>, Ilya Dryomov <idryomov@gmail.com>, netfs@lists.linux.dev, 
	linux-afs@lists.infradead.org, linux-cifs@vger.kernel.org, 
	Linux NFS Mailing List <linux-nfs@vger.kernel.org>, ceph-devel@vger.kernel.org, 
	v9fs@lists.linux.dev, linux-erofs@lists.ozlabs.org, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Aug 24, 2026 at 5:04=E2=80=AFPM David Howells <dhowells@redhat.com>=
 wrote:
>
> Currently, if one or more of the subrequests in a read request fails, the
> read collection algorithm will attempt to salvage folios that are fully
> downloaded but that span multiple subreqs, provided all of the contributo=
ry
> subreqs succeeded, but this makes the algorithm quite complicated as a
> subreq can contribute to multiple folios and a folio can be contributed t=
o
> by multiple subreqs.
>
> Simplify this by just abandoning the rest of a read request once a
> permanently failed subreq is hit.  This is what read_folio, DIO/unbuffere=
d
> read, gap filling, RMW and write preload all need to do; readahead is the
> odd one out as it doesn't have any return other than unlocking folios.
>
> With this change, even for readahead, the rest of the read is simply
> abandoned; read() and suchlike will call ->read_folio() on each
> non-uptodate folio to retry and retrieve the error.
>
> Note that retryable failures still get retried by netfslib as part of the
> request as before.

What about READ_PLUS, i.e. sparse file reads? If you do this kind of
work of handling partial abandonment, can such a work also benefit
READ_PLUS?

Aur=C3=A9lien
--=20
Aur=C3=A9lien Couderc <aurelien.couderc2002@gmail.com>
Big Data/Data mining expert, chess enthusiast

