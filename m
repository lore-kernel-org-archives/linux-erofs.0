Return-Path: <linux-erofs+bounces-4366-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D0645C61DCB
	for <linux-erofs@archiver.kernel.org>; Fri, 28 Aug 2026 23:20:06 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hWvVr3x33z2y2L;
	Sat, 29 Aug 2026 09:20:04 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2a00:1450:4864:20::334"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1787959204;
	cv=none; b=lpXMZm3Xx6eGnIHm9oaBGl7HakczL8wDrY/f9fw8ddSodQABtkINJbkbz+ed5EPIcfkO8Js7EDvYd9CZQV2H36HR2Brx0Y8qtstZd5VU+qWaM3vcLIKsmc9JIDQ4qGlMrCa6kxNDhhL38/rnZMvGU6ez5QUdSaIUebTMfOc3y8ANAx3QeXm3SG/jmNgkfwqzIcpPJP6PE464fdHYbFI09DqJuULvJwFxppSIw/jokxFC7yyYi2M82nZJ6Hf8PsgPklxyoKgV6UUiz9qcW8hYjHdviSRqwpDwEVzKNV9R9QFwGzF1847vCTWlmdIv8vbPAyke4y/i+nf70JFRr6D+ng==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1787959204; c=relaxed/relaxed;
	bh=Dsr8qBZLgil/7Jhc9mZG6IoOdofcq7dtRdjka7YmlGM=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=T24lkbebW+qOvLcwN4Y0dP1jMvSZ/t/vdcMJ1wx1QC0UWKW4ehmyWV7NWfJWFVpYJ1zII7tHOHTOplFTlppgdqeKsUI5BVxDLbdUNVi4zXTSIv7Sw48NqTMVz7jjl01GWo5kaYUgz32CtTGQxVtbIWbo+PNUx6LWwgihGP3CtFW3mdhHYRAOL7yu/N6x2S96n97y6PZqNjq/Ezu+y6s6OA6l0/p5UbvMUdOKv/U3sobuQaqyIStYs4fE9/eK23d6gqQ7y45vZWF2hE6BuysnAAezrWoenG/DfhbR8tuqhLJ+1T/2Ce3ev0WAg4k7Cj1XkkKdSm/tyeGyn8HJsMbkdA==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=gmail.com; dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=LbrgjPk/; dkim-atps=neutral; spf=pass (client-ip=2a00:1450:4864:20::334; helo=mail-wm1-x334.google.com; envelope-from=julianbraha@gmail.com; receiver=lists.ozlabs.org) smtp.mailfrom=gmail.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=LbrgjPk/;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=gmail.com (client-ip=2a00:1450:4864:20::334; helo=mail-wm1-x334.google.com; envelope-from=julianbraha@gmail.com; receiver=lists.ozlabs.org)
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hWvVp3zjzz2xLq
	for <linux-erofs@lists.ozlabs.org>; Sat, 29 Aug 2026 09:20:01 +1000 (AEST)
Received: by mail-wm1-x334.google.com with SMTP id 5b1f17b1804b1-49b8be0409fso8372455e9.2
        for <linux-erofs@lists.ozlabs.org>; Fri, 28 Aug 2026 16:20:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787959196; x=1788563996; darn=lists.ozlabs.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:to:subject:user-agent:mime-version:date
         :message-id:sender:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Dsr8qBZLgil/7Jhc9mZG6IoOdofcq7dtRdjka7YmlGM=;
        b=LbrgjPk/YmE5H8wdUmbya8ikBYWaeZlu1MYWaqQKE+d/rWsmaTkdhGy9PRsxJH/rUm
         trSNoNaQ1HWVkKObA4FqYhHFS7wB08KgzK51LCGhUkDq5+JM5FxI8wOpMllOIZ8rfr2d
         3kY8UEAjPSpJVq+JlgqupfmKhIM5eV84I/+x19xTeU01VAgz7xpHLUkiv201ksQNgdHB
         rcet4CfhDqQYeRZGZ+4J59bnz0ugXKrgqjqjAIbuBWPNJlbQCHyEGvGneJVwP2/BoTS3
         riFCoghyiZB//hfsqCj9mYwbb2gC+WXMw+xDPrsZgU9xWOWv3dIlIz1O9Tzcw6OWkv0X
         K45Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787959196; x=1788563996;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:to:subject:user-agent:mime-version:date
         :message-id:sender:x-gm-gg:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Dsr8qBZLgil/7Jhc9mZG6IoOdofcq7dtRdjka7YmlGM=;
        b=eXhOtctjj4ztplFTlL2CGrMb9WgWxPx6xmuFoDOqkKV/Rv7CDaOorWk77Ki9l8fT/b
         rtaeI04ZuRj/C0jH7yRjMmeblaOThOfhoY+8eLScq0vyjthPWfio5fbLh6NCGTOUTQoT
         A0KH5cuUNkfiMliVcnq4nZM+nG99lHvUYyH2QU6JtWahIFWd+bwQrpYe/16bKRu5ic/D
         fYm0trhdpOF1uLKmHnPoge9TQR6b1dv4e+oQ2XbCDAQ/FGz8P6PVdLfui1iDUDmiXK99
         GRtHyg9ZGKjbKYNegYRZJIWNGTXMGnPMRqyhXBMe2eZ3yDYAEJPWzUzsZneOYtsXaT27
         5M4w==
X-Forwarded-Encrypted: i=1; AHgh+RrN7lhYmuii1FPdW+TkOwY5eynNZNuE+zFpbdzncAutmpM9Y77LfAPtkoo7c61Oyf0WaoFBukpwNFe0dQ==@lists.ozlabs.org
X-Gm-Message-State: AFuF++mwHffbLl9zsFWJP8vGySk0MZ9gEnswYDJj5xX1VzW26KRiuhRF
	wU5h5MVPvKB3u0PtwY8BJPOASkFrvK4dtQmRwVU9wdlZU64eOHaW18sc
X-Gm-Gg: AR+sD13ExXFV9bhIN7Se7OG8M8Lpa3tKmfn+GQrCdHmxjCzucwBRflGiKVjgjJ377+8
	WXDrEWV8tKSE5jhZEavb9KpIGyD4B2cvHqOUnc5WaTLBj4gH0L35zjpqix573YT+ylCDnF0UIAS
	FEPlYnKrLdnfTnQBqR86jcL8nk8l2Jp3eTJPimCRyP0oyJJgIVo+9HfGAU6+bhaRlZDiXFmGktn
	aE4STvLSBvUH/y9FkKN2WAFhAXFaWkyESQ9KPIvh/YkhXOr7LYavtloHMSZNlD1XAWFf9Z2JX6X
	e+GgTqQVh8u/fhNkWjdVQQpi22yl5Sunrgd64pcqVERstWcVd2BgHo/AozeIqF/NaSASeaS9G4w
	gv50b6f/pIu0VnukB0oGxgZPemcrmk5zDdw1vt8CKZzkqGIZw0ATsRbSxNYJUDqTk9TjKM/LNNA
	QtyDy6GVFLXxHDtGvz8v0su8t6uerV1SWmm7XBiyHZmJJLyJYpKViL3w8B4FlYtPzbaUNeYGQ5B
	AHL6CpgTxPhkJKUm6o5XIVqqYrHhrdHacnj1cjeA2QpNtjJtyfuoMsN
X-Received: by 2002:a05:600d:8449:b0:49b:96a0:5c00 with SMTP id 5b1f17b1804b1-49b96a05caemr110929705e9.13.1787959195990;
        Fri, 28 Aug 2026 16:19:55 -0700 (PDT)
Received: from [10.128.10.232] (195-23-151-163.net.novis.pt. [195.23.151.163])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49cca1ed292sm33018995e9.8.2026.08.28.16.19.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 28 Aug 2026 16:19:55 -0700 (PDT)
Sender: Julian Braha <julian.braha@gmail.com>
Message-ID: <9de2f5e7-079b-472f-9d98-91d878dcefd3@gmail.com>
Date: Sat, 29 Aug 2026 00:19:54 +0100
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
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] erofs: Fix EROFS_FS_ZIP_LZMA_DEFAULT_MAX_STREAMS default
 logic
To: Geert Uytterhoeven <geert@linux-m68k.org>,
 Nathan Chancellor <nathan@kernel.org>, Gao Xiang <xiang@kernel.org>,
 Chao Yu <chao@kernel.org>, Yue Hu <zbestahu@gmail.com>,
 Jeffle Xu <jefflexu@linux.alibaba.com>, Sandeep Dhavale
 <dhavale@google.com>, Hongbo Li <hongbohbli@tencent.com>,
 Chunhai Guo <guochunhai@vivo.com>,
 Michael Bommarito <michael.bommarito@gmail.com>,
 linux-erofs@lists.ozlabs.org, linux-kernel@vger.kernel.org,
 linux-kbuild <linux-kbuild@vger.kernel.org>
References: <c480ed6b8bf38822263e2c5b7cf32b28600f212d.1787219898.git.geert+renesas@glider.be>
 <CAMuHMdVyUAA3L4mUkSjmnuE3cvj-+N8z-Bhxsh1wa-FQWc=fjw@mail.gmail.com>
 <apGqg5a5I9g1CoF_@levanger>
 <CAMuHMdXwmCrzLZiPnQejJ+dTvVNf2zTzgKwTWEFEkfKRkZQpPQ@mail.gmail.com>
 <apHfhILRL0-lFOEh@levanger>
Content-Language: en-US
From: Julian Braha <julianbraha@gmail.com>
In-Reply-To: <apHfhILRL0-lFOEh@levanger>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 8/28/26 20:20, Nicolas Schier wrote:
> Cc: Julian

Thanks for looping me in.

So it's not great usage of the Kconfig language to have the 'range 1 1'
and the 'default 16' here contradicting each other. But, it's currently
legal.

I would prefer to disallow this, but a proper check would actually
require SAT solving (or similar) in the general case, so it's unlikely
to become an error in the near future.

Anyway, as long as we're continuing to allow it, savedefconfig should be
considered bugged for not handling it accordingly.

Let me see if I can send something out this weekend.

- Julian Braha

