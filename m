Return-Path: <linux-erofs+bounces-4084-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 45806C55175
	for <linux-erofs@archiver.kernel.org>; Mon,  3 Aug 2026 09:13:02 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hD9v03YrJz3078;
	Mon, 03 Aug 2026 19:13:00 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2a00:1450:4864:20::42c"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1785748380;
	cv=none; b=YmfIMUEmvocRYOJ1/nyQNjadGB2nQHmx2/yFbVu7U2NFIPQTEKYrD1P0RBiXFUX+b6xGSKQ6uW0GaBiz2ma2s2hsSriQ2de0MlGFUT932bwo8UP5T0yVEbkvmlLq3FxfTnRmiEi0YVtd03gkZI+GCZfwdXOz+Q30cHPrqaoUzRmzECzqXiTwS/C+focG1Zy/gWgqaszmqFfFGmbs7fCGFe9KadBH+kv930/byXBjz/SzxqZxrqi4zWe9oNdXHXHwcmniTk+BwcLL7v3gWVKAOFJicWNG9M1uhnGfzdq7/+gXZ3vt4LibKUcStHT8VJpOLEixfXZS79p+qTMQuSHP+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1785748380; c=relaxed/relaxed;
	bh=Tf9PxesmSKIPqmzevqF82I/y3pP5pgGQ+7FsJ/KVC3M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=I56m1fFs1u+QrX7CriSN6GGkbhdQMtMFvTGejmy1fVlxBDAK6qqIVy5tutSZqsSyb9N3D7e/0h1LX8jhDS28wfgDgucro8Vc2wbZlZRdzzHy4RCNsO5kF0wmuRE5HYMg+djf3QFzDvRzxCkHD8jIaTHawftgmV+ace1bhOzHRfeFWNR2FTia1jtpYKRPwqhaM/+wC4eCqLZUkKHFR/SLiwVt6p5+qTMJPUO8opzXW+SSgQfBJUwDyOZ11sWg6tXQZeFO7mJWf1gR9c7J1NUUoVaUx4GyjmVTCytUUc802Qkylp9arh1WxMBHjqU6u49K2VjkO5CnI/ZcYUP3KBfX7w==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=none (p=none dis=none) header.from=baylibre.com; dkim=pass (2048-bit key; secure) header.d=baylibre.com header.i=@baylibre.com header.a=rsa-sha256 header.s=google header.b=bbm4okhj; dkim-atps=neutral; spf=pass (client-ip=2a00:1450:4864:20::42c; helo=mail-wr1-x42c.google.com; envelope-from=ukleinek@baylibre.com; receiver=lists.ozlabs.org) smtp.mailfrom=baylibre.com
Authentication-Results: lists.ozlabs.org; dmarc=none (p=none dis=none) header.from=baylibre.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; secure) header.d=baylibre.com header.i=@baylibre.com header.a=rsa-sha256 header.s=google header.b=bbm4okhj;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=baylibre.com (client-ip=2a00:1450:4864:20::42c; helo=mail-wr1-x42c.google.com; envelope-from=ukleinek@baylibre.com; receiver=lists.ozlabs.org)
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hD9tx32Gkz2yQJ
	for <linux-erofs@lists.ozlabs.org>; Mon, 03 Aug 2026 19:12:55 +1000 (AEST)
Received: by mail-wr1-x42c.google.com with SMTP id ffacd0b85a97d-47f7027ca11so1935461f8f.3
        for <linux-erofs@lists.ozlabs.org>; Mon, 03 Aug 2026 02:12:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre.com; s=google; t=1785748372; x=1786353172; darn=lists.ozlabs.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Tf9PxesmSKIPqmzevqF82I/y3pP5pgGQ+7FsJ/KVC3M=;
        b=bbm4okhjGAY5V96wv8ewgiNV9DKJ6GPdsTxefPScTVwCy/Bx0RIG3LOTr8iWTeKtYD
         5QlrKy7zcArpY2lBiQXv+iJBnk2h+q6GqD9cFlokP+1HuTDI69vTzCPvCBbswJ2xgVTL
         cto3fh17Vkg8t6oBU3iQJklwdjyMqtbyXNaqaOgWWDoWzefHUOfNr2HNnwVGYvfi5QLL
         64+y3oYbFGxX/pPuLeJTusgRzH3X1ObS4MHfVNNlbLrHz3W7TL7hbHej/izHsDNw7XkY
         JskzgYD6G8qq0ursm87qLWTUM63BDXBjYIXiblHl43DOP+GpIHxVzYHVWz3ESPbglytC
         a/pQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785748372; x=1786353172;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Tf9PxesmSKIPqmzevqF82I/y3pP5pgGQ+7FsJ/KVC3M=;
        b=c99KheQu9fY7sOdhOqq5wYqDDc4PgXoBnCdbz1JN1TpTbEHntFCDX6nlIzu2mxbLrL
         /dlt5fXixzOvkEEmJ3hN6OUNiIMy2TtHBT7juSRrU/uT86gTzfd9gxTPK1qzxzYf6jPb
         xv76RmTg1UDJHIYEbSuK01hqIpaiCSagkLiYvFHyBsqp8l3Acd6buD5K9JEohZyvRjIf
         EGzRbV3CS1PQ3rgqtNHpraZ+fDlaAGQPl1HKRUveLM13k8MuJDVVkNuhOIAYAH1wnZ0W
         yAVgLaNwyxry8ryJ3vCt/6BlDuTCEvXBjwMH3ccMKyc0OR8ypjwzEH053fIUU9toWjKY
         UCTQ==
X-Forwarded-Encrypted: i=1; AHgh+Rrn2wELisCPg+6PcN6CJY75nBOFYa4Vq/7LculDGYxlehBNB5xmUjoLQY//a9NrpPpk81cBf940vhe30Q==@lists.ozlabs.org
X-Gm-Message-State: AOJu0Yy6njAq1OIw5ZDumUMElsYR+zBCjYLyaSOctk1hdNdEAo9qpKyZ
	7cENbPFsckq4iuWrj8q9zmNmDG6BFldtxAAZVhCJGnazIozKySnr4dPN1+5lKzCAN9M=
X-Gm-Gg: AR+sD11XOUSJ78UXIHNOGeLWOS58/jN6XxpKSB1rsU8/ex3MIzglcOeqdWwZx2gWfez
	NkhWJjhoHUTmsFMLutj1FsfzyUmBIPRM19DXLxMp2pJRVhTRAaRx8ZSatU99sKYcH/RKri7efFw
	lizyo7H0HyK1E3bXxKxcpJtT5vst6HGJ8pifC1TYada8xE3HPjnPLshcSCSAA5qmqVNVaaLA8Mt
	rPA4GiFCxAzmE8INZcpW+gDa6Wv7boLIAnfsmVZC1r+oA7K50IeQEL7TNJO0AApjiYkpBzUOWs8
	tj57b9kGGIVh4KwSTV7uUx8nCuWWiOe9IpvXn4LdRN0XC2pLBt50rvFn6X74vMkZU9Vl0nfwbBf
	TiUwJKoujiJ5Sz247MECqrn0iZvu9xfRNd5l/862DSuuQWQeUVo2PSgGPMbgaeTcXEsgQJ6lhSW
	J6BVeyBQ0rrv51VtINDve4b0ALvCrINwgCurn3Qg0LJiXctBdNDfvURLjYMFbBdqAjWhjf4cyPn
	fXrI0KLSjJcGeeo
X-Received: by 2002:a05:6000:2203:b0:47f:cb39:10c4 with SMTP id ffacd0b85a97d-47fd72c75d5mr20472888f8f.12.1785748372101;
        Mon, 03 Aug 2026 02:12:52 -0700 (PDT)
Received: from localhost (p5dc68b01.dip0.t-ipconnect.de. [93.198.139.1])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-47fe742936csm85878f8f.31.2026.08.03.02.12.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Aug 2026 02:12:51 -0700 (PDT)
Date: Mon, 3 Aug 2026 11:12:49 +0200
From: Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <u.kleine-koenig@baylibre.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: SJ Park <sj@kernel.org>, Gao Xiang <xiang@kernel.org>, 
	Gao Xiang <hsiangkao@linux.alibaba.com>, Michael Bommarito <michael.bommarito@gmail.com>, 
	Yue Hu <zbestahu@gmail.com>, Jeffle Xu <jefflexu@linux.alibaba.com>, 
	Sandeep Dhavale <dhavale@google.com>, Chunhai Guo <guochunhai@vivo.com>, linux-erofs@lists.ozlabs.org, 
	linux-kernel@vger.kernel.org, Chao Yu <chao@kernel.org>, Guenter Roeck <linux@roeck-us.net>, 
	David Hildenbrand <david@redhat.com>
Subject: Re: [PATCH v3] erofs: cap LZMA stream pool size
Message-ID: <anBYnPELPotUiNjv@monoceros>
References: <amhMsk5Z6P0IA8sr@XiangdeMacBook-Pro.local>
 <20260728065447.91511-1-sj@kernel.org>
 <CAMuHMdWq1eutRM4u1Q3r50f8W4oSejo_XAgyjEKuwi4Lw6K7jQ@mail.gmail.com>
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
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="sfor6dhu35gfvxc4"
Content-Disposition: inline
In-Reply-To: <CAMuHMdWq1eutRM4u1Q3r50f8W4oSejo_XAgyjEKuwi4Lw6K7jQ@mail.gmail.com>


--sfor6dhu35gfvxc4
Content-Type: text/plain; protected-headers=v1; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH v3] erofs: cap LZMA stream pool size
MIME-Version: 1.0

Hello,

On Mon, Aug 03, 2026 at 10:09:06AM +0200, Geert Uytterhoeven wrote:
> On Tue, 28 Jul 2026 at 08:55, SJ Park <sj@kernel.org> wrote:
> > I don't have a m68k testfarm, either.  I'm doing crossbuild [1].  Hopef=
ully you
> > could also reproduce it.

FTR, I don't have m68k hardware either, but as this is a build time
failure installing the Debian package gcc-m68k-linux-gnu and then doing
builds using

	make ARCH=3Dm68k CROSS_COMPILE=3Dm68k-linux-gnu-

is good enough to reproduce the failure.

> I think you can reproduce some of the issues on most architectures
> with a non-SMP kernel, cfr. my reply[1] to Uwe's proposed fix.
> Unfortunately the Kconfig warning only shows up on architectures that
> don't define NR_CPUS (because they do not support SMP) at all,
> while ending up with zero streams is probably a runtime failure.
>=20
> [1] https://lore.kernel.org/CAMuHMdVGKX=3D3cfOrLWp1uSHX76xf1-=3DC0+GVCXkA=
8JTqNPg-ew@mail.gmail.com

I guess EROFS_FS_ZIP_LZMA_DEFAULT_MAX_STREAMS should depend on SMP and
it's use should be conditionalized using something like

diff --git a/fs/erofs/decompressor_lzma.c b/fs/erofs/decompressor_lzma.c
index 6b0cdb446c6a..c00e94f8206f 100644
--- a/fs/erofs/decompressor_lzma.c
+++ b/fs/erofs/decompressor_lzma.c
@@ -50,9 +50,13 @@ static int __init z_erofs_lzma_init(void)
 	unsigned int i;
=20
 	/* by default, use # of possible CPUs instead */
-	if (!z_erofs_lzma_nstrms)
-		z_erofs_lzma_nstrms =3D min_t(unsigned int, num_possible_cpus(),
-				CONFIG_EROFS_FS_ZIP_LZMA_DEFAULT_MAX_STREAMS);
+	if (!z_erofs_lzma_nstrms) {
+		if (IS_ENABLED(CONFIG_SMP))
+			z_erofs_lzma_nstrms =3D min_t(unsigned int, num_possible_cpus(),
+					CONFIG_EROFS_FS_ZIP_LZMA_DEFAULT_MAX_STREAMS);
+		else
+			z_erofs_lzma_nstrms =3D 1;
+	}
=20
 	for (i =3D 0; i < z_erofs_lzma_nstrms; ++i) {
 		struct z_erofs_lzma *strm =3D kzalloc_obj(*strm);

I played a bit with the definition of
EROFS_FS_ZIP_LZMA_DEFAULT_MAX_STREAMS in fs/erofs/Kconfig, but didn't
find a way to define it that both uses NR_CPUS and doesn't generate a
warning with ARCH=3Dm68k.

Best regards
Uwe

--sfor6dhu35gfvxc4
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEP4GsaTp6HlmJrf7Tj4D7WH0S/k4FAmpwW40ACgkQj4D7WH0S
/k5LwAf/cdL6nHd/eq299wreF7wmJ/uzYymvnXI6g+WJKc5gZTwGHYeRdcLbnNux
3HBeU54Tekgm2/c8Dzf1HKMr8yW83g9d+dnWpEhjjrBtU1neZDCs8SkUV5cZmtAZ
eBU0DQ6xEvWD5+uUuCkoluWU/0jQXAzzdhpGcGBTCFRIORwXEwDpRK/190nXO64u
TNhzAxYRmmWop9WnxcL6ZsVv/d/bcRHM+th39zYaV3bfh6XDNsjhYriUqkcJVezF
+XTq18Wb4HY77xH61A0s/5cd75E3/zLtHfoqb6oGX7PpiEsliZxqUKdIPPpytxBf
xOsHM7j3e1USwS8UybcC6AKsa7K+bw==
=9m7x
-----END PGP SIGNATURE-----

--sfor6dhu35gfvxc4--

