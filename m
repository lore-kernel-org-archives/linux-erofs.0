Return-Path: <linux-erofs+bounces-3873-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0B4B9C43458
	for <linux-erofs@archiver.kernel.org>; Fri, 10 Jul 2026 10:37:35 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4gxSvf3v9Bz2ySg;
	Fri, 10 Jul 2026 20:37:34 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=pass smtp.remote-ip="2607:f8b0:4864:20::112c" arc.chain=google.com
ARC-Seal: i=2; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1783679854;
	cv=pass; b=ozEmCTHwLWpQgIGh42cR8Rx6suq4sgCmc6Oyj8+m90SZxivLZgo3dUfSugV1O5UXe9eLOEUZYGRDxpGqcKDsbBkQ5VyLXEkGhsLjQweAjPooqjJWkMxiRLUAYnC1XT+7gslmLHW0ddo/9EeLieY5cGlcn84z4Xv7R6ArnlRsebsKrS4itLFdiMNQCit6oFWSxNbCKk//fhUcnLirIKaDHb11iJM9zJepm3nz2QZyGn+NvLZDZTg6CJ8PwJLP2ihsl2n3zwiA1D8cN/bPsL9jU0nn5desOP55QvY38EOkBwbjM2A5K6eESuVm3QGsBkegBjXKUJToiZSjjRQxNe8Cmw==
ARC-Message-Signature: i=2; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1783679854; c=relaxed/relaxed;
	bh=0JCCK/TG0jvCYWzkXuH2FOsoNpOIN0Oi1w32Ig5m1gU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Content-Type; b=fnfL8pQwwkulK2qtoz/LUSStwX9J5OeZ4iy+jG3r0A6sU+w3hl9Lxz7rTpjDzE/ADgEzCNFXGspoJe9NOSBoQVPWZfEujqvyST9dTh+He2+5ERnt6M+E8tYKlvqyUHL2EwfmL7LpaEBtiT/3cj6/hiM2Uaa095bMQn6obTvkd8UDaCEo8TdgJQOahUstLW7Pd942uI7jIkI1u78by98OVUPrTTr+HfyKkdei7waS9hw9ScioFgovQz+MDBeWcQ79tjVeqh7LIZCH+QxUT/c+lm5mD7S3Ng7IZvW19Aob2kozbt1nmLjkp+dlGY4zrser92w/NdU7M5gDZa9lpHIEjQ==
ARC-Authentication-Results: i=2; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=gmail.com; dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=QKP723Oz; dkim-atps=neutral; spf=pass (client-ip=2607:f8b0:4864:20::112c; helo=mail-yw1-x112c.google.com; envelope-from=michael.bommarito@gmail.com; receiver=lists.ozlabs.org) smtp.mailfrom=gmail.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=QKP723Oz;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=gmail.com (client-ip=2607:f8b0:4864:20::112c; helo=mail-yw1-x112c.google.com; envelope-from=michael.bommarito@gmail.com; receiver=lists.ozlabs.org)
Received: from mail-yw1-x112c.google.com (mail-yw1-x112c.google.com [IPv6:2607:f8b0:4864:20::112c])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4gxSvc4RzRz2yRF
	for <linux-erofs@lists.ozlabs.org>; Fri, 10 Jul 2026 20:37:32 +1000 (AEST)
Received: by mail-yw1-x112c.google.com with SMTP id 00721157ae682-81e763fb7bbso9801787b3.0
        for <linux-erofs@lists.ozlabs.org>; Fri, 10 Jul 2026 03:37:32 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1783679850; cv=none;
        d=google.com; s=arc-20260327;
        b=VrWopOx9+q/D6rmiYI5icxveYes4txsHMIaKet9OtyIbJIeMUh4drzvCONGM5nIFZz
         deCG/tVPWhR1QT/ry5g19wjoChJPZU02NCoROtV+DT20cUYuSiokpRVlOWVIpVyXo0RD
         JnJTbxG+D9Ld9937/9dw2k6dHDncvUiXkRkWezUsWIJ7DfcOfJsEdJPV1LEKZwoLu0xo
         1jGdRZ2qZujrRJVAS0poOCQxnDPXkyTN5gEaaB1aBeJuBtD4sDUY5AT9dh0yJD9+/gw4
         eD5JiFE9pJjK5yoIxSWKm9BUdVpbrHIK3fOI3kydtLXMLO3DEfxsQqlaDx56G/23eef2
         RXuA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=0JCCK/TG0jvCYWzkXuH2FOsoNpOIN0Oi1w32Ig5m1gU=;
        fh=2GeEek1V305iw/kJOwRibTu0QcVgNgCpAptNq07v5i0=;
        b=TReK1Cg5mZfigSTlLzDPwYrKXJfI92DokSKJ+4BLviYGy9Ti/lnUihzJeXULX8kijj
         lC13m1KA3lRUN4q9t/c25m4nRCcubOeco2kTpZIvpporcZV3GdgM6vzpQDFjTxV0Gghz
         3kbebPsJQi2SfeDUTo/nOAZc0TZjTnJLIHuFnDP6vSEtVLgaBgR2kanilSfhDodCBksu
         0fZ9XI0Pa/6ZQenpxPR+ktad/8+SmmAw9qltDYM9373RwKqxOqLWJ1KGCywcVXwBvNXI
         qoWZvsO+Y6HQ9F/X9xXWY5Dy/PycriDlGYyeXke4BtJ9kavIvaaASJfU0gMfIJZkoYKo
         rCDQ==;
        darn=lists.ozlabs.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783679850; x=1784284650; darn=lists.ozlabs.org;
        h=content-transfer-encoding:content-type:to:subject:message-id:date
         :from:in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=0JCCK/TG0jvCYWzkXuH2FOsoNpOIN0Oi1w32Ig5m1gU=;
        b=QKP723OzX14mG1pIlwmYTFl+RH3rl6TPsV/Jav7AjBfYDSv6GR2Q7DlRWx8Cs6xn2M
         pW/py9+94I6pqf7VFNwFc/JaprXuuJyhBK01z+Q1lZk5AhsXIhD8BbkwLUsT+QMALY7K
         urw5p3lNfFdy9CLm+/T1DYF9y41DZyrASwhv9773t2E2RIUBuALmSxK58oFSaLwYq8vH
         CeFVIRYSrKR4lX8EwnCMonnhiA1ZYYasoByDG4t/q1xY2ff176oSs6piJLMBcySSgHS2
         SrKF2cFjj4n3ANymqPWgpBirj2gLrMYO9lt46Qt0xFSjkNH2AGaGx9LFKSFo2h8kQE3n
         unBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783679850; x=1784284650;
        h=content-transfer-encoding:content-type:to:subject:message-id:date
         :from:in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=0JCCK/TG0jvCYWzkXuH2FOsoNpOIN0Oi1w32Ig5m1gU=;
        b=SqjDUbnMucfZtVk9ig48iTOsw7vpSAwwuEz9WFxFKRvaZxKCKmwrLrBEDMrmh1utuB
         x/JyCrSz3CO6R4TC67L5asJmkWeF5douTKVB8JYf9GQgIKovKWC27PAV/kzotMTvUB1j
         imXHVdL4OKcjsodEtWUr+tYcp0/jVBmVnjbY5w5pDmKjEfQ+HIlGaiehJQ7xA/um7hTJ
         nxUWvL6vO65g11wJ5ctPfQTKqvwTiyu47g7k/wqn5/eIk+yvNG4jsBmglhsYEL7usXOC
         27QG6RxjJAXM+bN9Ibx5zT1Y3ql5F4aBBMijC4M7N+iib93hwofUgrwXjNNwBQ5+Xg22
         c5FQ==
X-Forwarded-Encrypted: i=1; AHgh+RouxpNqbw1ohWfY+/MFG9z186yIZw442vkUMBDsyEDS5buzGC8N2XkTzP+skY12BR8fuc1Ge+8QOuDpbA==@lists.ozlabs.org
X-Gm-Message-State: AOJu0YxE2RXyfQMwQcJPftMQ/TKq0/aL+Eo46QyVR6cfhI8jPcer8Qrd
	Pq4bPlj6zm+aZgt6fTuKV5Tm6tzxCSwAI2eBqL8OAoOGeWG3mI1uMaESIidTnPa06OD5H5sl7+q
	48bEvnQm2u8uDiASv4Tfyy6iwRlw6yvI=
X-Gm-Gg: AfdE7clBquUYj2BiFX38R9wKv5RhvzaaKXWwdMpCUnVMxgSYGZ/DduP9uxs23Bf4/kc
	s5gD79IB2enqEWgqCtxhYu/qEkpW9ZYFs1jT0UGPmKYSykd4OAbkq4mBtSpAXigkew6y1EXi6Bi
	O+Ne7gzbys++mawKIOIYqX6jX7VjOwFjv09QRVQxS/adYdyHvxVM6dFLl92FrjkYEN/XXVkrs60
	DTgqtv12c9vPI2AfLuug4OWcsVizculcnhr4KNlPQjotbn5IYfGFTK0Jg2oQkNB4qDkHqMZpL+7
	XBr8lG+Wb607nybMeEKYDA9apQ==
X-Received: by 2002:a05:690c:e0a:b0:80c:85b6:75b9 with SMTP id
 00721157ae682-81dbf56ec3dmr90488607b3.66.1783679849851; Fri, 10 Jul 2026
 03:37:29 -0700 (PDT)
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
References: <20260710023036.3745254-1-michael.bommarito@gmail.com> <alBcDlPeV8IPEngL@debian>
In-Reply-To: <alBcDlPeV8IPEngL@debian>
From: Michael Bommarito <michael.bommarito@gmail.com>
Date: Fri, 10 Jul 2026 06:37:17 -0400
X-Gm-Features: AUfX_mxE85m0PgKq6exSlea8kQElVFjkZ94OrrDgW-o3O-BKH0z00Einlr7_ibU
Message-ID: <CAJJ9bXyTZRNUzSy5Y10zbx+1LyLguobgGm7FdGPO0foSzunLpw@mail.gmail.com>
Subject: Re: [PATCH] erofs: cap LZMA stream pool size
To: Michael Bommarito <michael.bommarito@gmail.com>, Gao Xiang <xiang@kernel.org>, 
	Chao Yu <chao@kernel.org>, Yue Hu <zbestahu@gmail.com>, 
	Jeffle Xu <jefflexu@linux.alibaba.com>, Sandeep Dhavale <dhavale@google.com>, 
	Hongbo Li <lihongbo22@huawei.com>, Chunhai Guo <guochunhai@vivo.com>, 
	linux-erofs@lists.ozlabs.org, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 9, 2026 at 10:42=E2=80=AFPM Gao Xiang <xiang@kernel.org> wrote:
> like CONFIG_EROFS_FS_LZMA_MAX_STREAMS, since I assume there is
> the different setting between the embedded systems and servers.

That sounds like a much nicer solution.

Do you want to wait for any other feedback, or should I send a v2 with
that approach, and if so, what do you want for the default value?

Thanks,
Mike

