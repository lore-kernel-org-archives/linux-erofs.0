Return-Path: <linux-erofs+bounces-4200-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A12C3C5AC67
	for <linux-erofs@archiver.kernel.org>; Tue, 11 Aug 2026 19:37:56 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hKMNK3JDsz2yrW;
	Wed, 12 Aug 2026 05:37:53 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=pass smtp.remote-ip="2607:f8b0:4864:20::b134" arc.chain=google.com
ARC-Seal: i=2; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1786477073;
	cv=pass; b=iMhbyG4aOM66TXQdhVXKgo/VnAeThlXcDkm95zVrJnL+TFwGONX19jJXh9yCDmz/nplFcUj3XNqsF9JaAK9G5/7/gwZ/9lfGhZ5x1vwaRFl1qTbEKUtXrNaPhyLAlxauZyKcBM9AvEF7g5jJ22mFFc9KF/ake9LrroH7GNfAg3C8hf4rvN6pOXBdnV1cFxdFojNO+bT96XDXuwpEpXEtJpqs+ke81ulVQymCKCAFRubLXw56VF8sCgh+gnzUEimDfRxGM1QIfLuom4h1lu/uYGp0gR6pokcysQLCibssydJSNjnB5gkGPYW8FhYESz70C8aK9igW490t6Ui/BzPMsw==
ARC-Message-Signature: i=2; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1786477073; c=relaxed/relaxed;
	bh=ovb2et/EgjKJUGMTBaA3YTI5r/Dd4k5WNI3t0f+gz4M=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=NUQUESuPyccP7OpA9m0XXdEvMDJknH7AyaBZ2uCgZqu9PA/SKafxxHSxOUjFd6e5lR3b0Vb3B5/StNdHWUtyENx78NRyZmTeI3dCb+elt2Fbe/S0TgLZZYj+ETUqNDTa7KzGy9kjnBBa5sg8YoSPLwbJy8rnxtx4bGo28Ojh11WSU1FqAEwfAzkiC1N/MCDbAj5QSCg1gOhdbBqCw0e7Rbt3zt/QdC8IMAWg2pgM+49z90If61C6+RS86GrjBuErL+wP6wTQ0+DIrLHOX1vmY15pAeFh5s1tEocXZ9xdgDScaHqmGKXCDIa5kFMcFbzlUre6m6NnLNkLrdIeT3f3XA==
ARC-Authentication-Results: i=2; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=gmail.com; dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=qYurZUsZ; dkim-atps=neutral; spf=pass (client-ip=2607:f8b0:4864:20::b134; helo=mail-yx1-xb134.google.com; envelope-from=michael.bommarito@gmail.com; receiver=lists.ozlabs.org) smtp.mailfrom=gmail.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=qYurZUsZ;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=gmail.com (client-ip=2607:f8b0:4864:20::b134; helo=mail-yx1-xb134.google.com; envelope-from=michael.bommarito@gmail.com; receiver=lists.ozlabs.org)
Received: from mail-yx1-xb134.google.com (mail-yx1-xb134.google.com [IPv6:2607:f8b0:4864:20::b134])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hKMNJ3xS8z2ynC
	for <linux-erofs@lists.ozlabs.org>; Wed, 12 Aug 2026 05:37:52 +1000 (AEST)
Received: by mail-yx1-xb134.google.com with SMTP id 956f58d0204a3-668432fe416so430989d50.0
        for <linux-erofs@lists.ozlabs.org>; Tue, 11 Aug 2026 12:37:52 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1786477070; cv=none;
        d=google.com; s=arc-20260327;
        b=fL1HUxTuz4fXS9foiXyZ4q69Z181stsVBrnPpNX4jjPMv9SYun+0dSo5v3gWXopSDo
         7lMdOOOMeXIbFdFC6oKbgi7lJuND9sKVqyu0A6B3HMpOabtK3u++uSyHCDpn+i1Xx7p6
         L+zUO4RKMzOvRmmmv0jvFBukGRJJhIuJ7FuzLShg1nBn/5u3nv5C/ofAjOkMXSoosFhQ
         XhQFtCEh1zmHjBSbkRr5WH39963LIoJ+OloP1cWDhzp5iMs2/gCGpX4+kzVWK5U+H348
         5x1D0AKYuFlr8xxzhLiYpQsE9ZCwLqx+PVsnRHWLbJ3X1NYJOE+bLQZYc64G8iZVd40F
         FoWA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=ovb2et/EgjKJUGMTBaA3YTI5r/Dd4k5WNI3t0f+gz4M=;
        fh=r0O3/8jGKrhVoq6HW0Sip2glEYwcjXq7wnrJN9WpoGc=;
        b=QCtydRziB5QbMOdYauhwzGxrAlRb3pzASzZ2odBfP2vta9UdUi9JHkCWBNeKm/RPuG
         t3BkrwYNjbaEOiqL/romJrOhA+mQx+0b8Pu1SbbTP6IAI2X4fcKJ5cpnTSI9+sY1dT/q
         11DQOHdsVhhgYYs7v2OXSIdlljLzGyYRl/NpzSUNBsv+/gqNfspMXzYY0KQqApPRuLpd
         qb+cvZpQvHZGEYUrfp3JeqvPswU2n/JAQy9Iy/ohTzike31YfTUjRMtF80HPrq01Lxbk
         8W3Rg5eAcWRM32qUU1SE9wo1gt1+t8nzf2hD3aiotu8ZH0MlwBHFS4tGABdHVVurTKw9
         elAA==;
        darn=lists.ozlabs.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786477070; x=1787081870; darn=lists.ozlabs.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=ovb2et/EgjKJUGMTBaA3YTI5r/Dd4k5WNI3t0f+gz4M=;
        b=qYurZUsZLv/kzb9TAyMIPRlL1mC/fx0DthRk9fRphGilFkrbiVRG7uJNYerT8akh7P
         vsdRXrSEyn3+P1ITGQeLiW90QxPLea6jrLnPqCYl8OEi8DlZF/f2va9YJMcuMWcyG/eN
         vo/Tw8fzZQ1v6VcrRC8r4NpG+O8v0xBJVs5e8XNRIkD2qbNLEs057wfP0nWKxTmwiq96
         HagrDbDY5svtsNfmI6gUmXyes0CGwCZxRwETPtAfvhSgWOn+EViYIRwTprs58t9GN/Wo
         ELw3iAHzHfIxAcuJqbVIkh88q6hWTxYh/WZmkDS9Kv00+GVIIbkJghkl93I/z9W59jpF
         d7yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786477070; x=1787081870;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ovb2et/EgjKJUGMTBaA3YTI5r/Dd4k5WNI3t0f+gz4M=;
        b=CLNbd269SF233eCU1UVe89apzZbjjIMvl77gTaBQHCzKLsrVsZuMEYbhREPJUomniV
         KNWUnLMUzAFnM2UDV4GGkg7X+DTQq4rf2gyOio0K0GUm8E+fkszA+wZXCSpNaOoidXxQ
         Ud/BENZYHJHCt0PikdZ0YkYrNp9WRORDyOHDlCDguGaJcXhjLDTG116gKsgZsxe498NZ
         jzPmNW4HfbBqnXTKm8OTjvJArIhsd6V3CahnVGhZzg0bKp/9XhsMZZhmXTE9UW8jZtlN
         j8x9cttWgmTdYnRkTaNyaNx8HC73qdToy0PoP2KsBh/e5r1dHCdzn7LH1mwAPi1ZioH5
         jLXA==
X-Forwarded-Encrypted: i=1; AHgh+RpFA8tXt065tjqtJQCTZq+S/55lDAI2YM+MEGspR4XLFaUPotcaM1pxV1jFu91NQCsyapi7+45k0Yc/fw==@lists.ozlabs.org
X-Gm-Message-State: AOJu0YzvQjhZDCZ5hEVIiV5YnHlLb0R7usrG14ubcA15pC3mizPTJowK
	Q2CSyFHQcc8j2A/bKxxBbdISM+w1fPWqb84uhMvifZNOI10YboitSG1WjDQqy2KofSKyKbYEWpy
	gyewiYDizedKauZaTcT6vKWu9ZVO0nnY=
X-Gm-Gg: AR+sD13kk3OFIUq4FJB1jQ7swjRs8kmeE/Fq3jPFcqOM/RvIeL4hjdEoqwU88+RtWD+
	WU0+HF21EUM7KwI0Y13S8Cn6+XVqjdwVCBr3NX6q7v0byEcXg0/spKT13o1/guRfkM/u0jeTmzz
	XYlC8iekMU35wXjcH/0SC7qIvSxJ7ECmMuWl/1bVQ5fYGLk/Dwuyj07BMrNUqE6jf7i522dFGCz
	UVWogOKbDGM0x7tNWlxOMKevOcqxnYehGAHNDMHuSPH+Pd9v0KRgfcLovMMmKE+x1j3N4uEHCqx
	NaQOAGEgDNrz5JNvYTfKLoC5utOFdp8LDRS4tJV3AyuhRVxM/Blwuq3OLKatZDDmYgtU5Jchhyx
	/nELPXAE9
X-Received: by 2002:a05:690e:4813:b0:668:12f:9dd7 with SMTP id
 956f58d0204a3-66b2c453e28mr1753800d50.44.1786477069467; Tue, 11 Aug 2026
 12:37:49 -0700 (PDT)
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
References: <amhMsk5Z6P0IA8sr@XiangdeMacBook-Pro.local> <20260728065447.91511-1-sj@kernel.org>
 <CAMuHMdWq1eutRM4u1Q3r50f8W4oSejo_XAgyjEKuwi4Lw6K7jQ@mail.gmail.com>
 <anBYnPELPotUiNjv@monoceros> <CAMuHMdXUyAX0TV0Sq9_YxvipzkVOBX=4s_r5mVQcZ_7nL=-AQw@mail.gmail.com>
 <87853c96-cc8f-49e6-81b1-02bfe409e372@roeck-us.net>
In-Reply-To: <87853c96-cc8f-49e6-81b1-02bfe409e372@roeck-us.net>
From: Michael Bommarito <michael.bommarito@gmail.com>
Date: Tue, 11 Aug 2026 15:37:38 -0400
X-Gm-Features: AUfX_mycx9Yi0z5vy5Jhy6n2fZ1oemh5r229UqKCqSqEIQfSajg9AQeRNoC045k
Message-ID: <CAJJ9bXyC=piPamaGJN=VMA72Ws+WqgJbYZgTj_w6NFzyLa_mMg@mail.gmail.com>
Subject: Re: [PATCH v3] erofs: cap LZMA stream pool size
To: Guenter Roeck <linux@roeck-us.net>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>, 
	=?UTF-8?Q?Uwe_Kleine=2DK=C3=B6nig?= <u.kleine-koenig@baylibre.com>, 
	SJ Park <sj@kernel.org>, Gao Xiang <xiang@kernel.org>, 
	Gao Xiang <hsiangkao@linux.alibaba.com>, Yue Hu <zbestahu@gmail.com>, 
	Jeffle Xu <jefflexu@linux.alibaba.com>, Sandeep Dhavale <dhavale@google.com>, 
	Chunhai Guo <guochunhai@vivo.com>, linux-erofs@lists.ozlabs.org, 
	linux-kernel@vger.kernel.org, Chao Yu <chao@kernel.org>, 
	David Hildenbrand <david@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 11, 2026 at 3:35=E2=80=AFPM Guenter Roeck <linux@roeck-us.net> =
wrote:
> > Any progress with fixing this for v7.2?

I would like to fix this since I started the problem with the original
patch, but I feel a bit stuck.  My v1 and v2 patches would not have
triggered the build failure, but Gao made valid points about the
trade-offs that led us to this v3.  Maybe it would be worth your
opinion on the config approach in those earlier patches?

Thanks,
Mike

