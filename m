Return-Path: <linux-erofs+bounces-3889-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 13DABC43458
	for <linux-erofs@archiver.kernel.org>; Tue, 14 Jul 2026 01:18:24 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4gzhJZ4bcCz2yb9;
	Tue, 14 Jul 2026 11:18:22 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=pass smtp.remote-ip="2607:f8b0:4864:20::b12e" arc.chain=google.com
ARC-Seal: i=2; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1783991902;
	cv=pass; b=nRTptOG3O/vGFBk9vnPLu5GLy5SvA1FZ+UwkRgtDJIVesbbskVJyFiNqjisqswBiG/FIaoXzbC7RKXRgghlBIaycvthENGavzNbtbvwgyDr9xaFxRh4sPoJS148ArYYOp6FAck+73FAc2v0bi3q7CrCLhK+Cz5Ctq0dJ6iuceh8I1Vqr7BgRl5DEVCidXoaYg6IV1nNkipHPpmFlT9Rl3IF7QJ5wSnV3Rd0RIBEeMXGhTJtBGwryNcRrV25qzbNhO+CqZaVIoYtlce3VUp9ymrfoJgixCyt9zNKbFIqM17e5pUYMdRUXXoWop8jHWYoc90j31+/JX6KVGPx1qXTDYQ==
ARC-Message-Signature: i=2; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1783991902; c=relaxed/relaxed;
	bh=ptfNU0O3NYD3rj6H1eB1bTNYaL7urX+ntbaWPvnJr28=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=RTs6v4dpLV0RncrkjqaNzlFO4+UkIMObsPlbOeSsI9Ik6JWSf1jS3r5oROLlmTQH/81smzqBTlVyZnzL/SRMvtGdPJu3ohQHr6b5ocje8EdvBgEG8XPJ6PAXS3UJTPMO91wHEs/JmHZ/pMqikgQ48N5eDWsZAWa8Rspv+E7AoRTANnGqJKVcjB/LzUQaZTjeizvABOx5W1j0IkvSLECDgKVZExe4GyqEwgAfbaCjBpYgXs/YIi+I51JX+7L/JWd5Zu1QxKK5nRW3SCR2qAyyoMuJ2DGA/emXMb+9MkNk1Rz5GkjW67vrb9xl5MlTbvjwEoSVmv2g73ar71Y6XfF6Mw==
ARC-Authentication-Results: i=2; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=gmail.com; dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=qLxJr69P; dkim-atps=neutral; spf=pass (client-ip=2607:f8b0:4864:20::b12e; helo=mail-yx1-xb12e.google.com; envelope-from=nithurshen.dev@gmail.com; receiver=lists.ozlabs.org) smtp.mailfrom=gmail.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=qLxJr69P;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=gmail.com (client-ip=2607:f8b0:4864:20::b12e; helo=mail-yx1-xb12e.google.com; envelope-from=nithurshen.dev@gmail.com; receiver=lists.ozlabs.org)
Received: from mail-yx1-xb12e.google.com (mail-yx1-xb12e.google.com [IPv6:2607:f8b0:4864:20::b12e])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4gzhJY59rgz2yYq
	for <linux-erofs@lists.ozlabs.org>; Tue, 14 Jul 2026 11:18:20 +1000 (AEST)
Received: by mail-yx1-xb12e.google.com with SMTP id 956f58d0204a3-6662551100bso4523491d50.0
        for <linux-erofs@lists.ozlabs.org>; Mon, 13 Jul 2026 18:18:20 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1783991898; cv=none;
        d=google.com; s=arc-20260327;
        b=ZyIKuRXsaBFvxgasAzej6YLiB69cONUY+R0AWuZMFJqi257Ki9wO0H8k4cUvyE5qeq
         33ZYuBZPKAD1wbgTkGfQoxp4jF+ujVMJoiiNMvVFxUhUGWc5bhFAPcGhoiFG7EDJmK0d
         MjH6vaEA+9/f0DEsEaY+12oVP3kPm3+4VLjtBbYUmQSeYN35klg8hLotJdq1f1aoUq+L
         eVoeQ23N9+dkBpsRmIRrD2bOnun7LLeulFLlvinv6HhBbdLpb5sYDM2GP5M2yNzX+dQV
         +4giD4lb1ckrNz0pUAQfXbcJ6g1aZ7BLfv0cd9PWlUKfL7n1HZZojnSUH2gjPelp3oTo
         xn1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=ptfNU0O3NYD3rj6H1eB1bTNYaL7urX+ntbaWPvnJr28=;
        fh=UE18cFBm6391AqxqivXGYQlIzDQe4zdk2PBRc9Bcknc=;
        b=SwQSX6SzBNLV+HKtDZTv7+fl0qq36J2BS2l+c/tagT8oapla3WoQKntn6nF9LfCsYI
         GuCvPlZKMgDjUoxM9Ajgvzw+nJC7+mxq4e+nITIvO8lJJjF6bMZ+qvzWbnJDSeY4wZAU
         qUohOlQjEIyf3QIZL1HvQCrd/f0e0P5pmYR4AAbnMJkGa4cdVzdzmdQo39tN4GhpFRmG
         ltAtPo/KEcuqkM9/IyoEeaovzTbLKjeVg1nLu8/P+ojOWJaP6XI2v5nQKJV5mUIrBlXq
         totnacCCWMqVXk5111OZ0F+2H4Yv3BaZK/jVadlIPVMtqtVwhpnAELU9FE+QXQ+g+8vl
         62iw==;
        darn=lists.ozlabs.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783991898; x=1784596698; darn=lists.ozlabs.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ptfNU0O3NYD3rj6H1eB1bTNYaL7urX+ntbaWPvnJr28=;
        b=qLxJr69PW/i9a/NwaWl1xUooFfGpug0YXzuM55OY65Bp1ysUA3MH+7iutqW9MVkaPl
         pjJ9bJEgm4oZlzgtl1Lg09d1G8wy4IP5XrrGAILWoAs4+8O3bCHeYnlEaANG8dM1X3v5
         01KsDKL9kEV/xYkbmnX75ommYOvxK7UIfCcMDIrREPC9aN5auQiHDb5IQLufRcEz+m/Q
         hzroGS+u/4wrMSobFP0CxL294I04dzT9jaIAxApNTcO0vzD8ubT9UOaJvuD9SRS1nX/D
         Mxbt8sfoop7zR0T+cGSIJVQwueqvIYlI6ywvVQvTqPEEhQDVEz11VYtB5M1TtASvf6Mx
         cGNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783991898; x=1784596698;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=ptfNU0O3NYD3rj6H1eB1bTNYaL7urX+ntbaWPvnJr28=;
        b=DMwrb2QyHFWMf6V87F9fHUwFzBsZ3A641n/NVySSj0eR5gQfg8l3sxpvdwQkBnvXHt
         b4hx86fMaPiEFkJP016o0ABprA3rUPHNvHb7ohi8om1Ng3mpf1q5IqoZfrodC5gDjIHV
         C5eAjIaE/5FOb+k9NmYE2YPbDWjWm2aMj1+aibGzCWtcyJpg7N9YjeEtiVpx60eRpK7x
         IzoRRfdfc66j2jH7nswZvXl6cwSCjVC315X8YGddQdsjta9RqUcgqmTJY6+yeI5eP9Tu
         DLX46mbATuM0/xIqjS24pRICVpqLSAashJwMGqRDayY4MKekH0wHr5Bn5ObTlxp03zcD
         Wb7g==
X-Forwarded-Encrypted: i=1; AHgh+RpBgUBv+SwX7ATnpSEF/JDMycu8SiOm6r4cjYAl3MSmyZ0CHtLfTiFdMDn/LK/2jLb6nh2kklCOEkNCQg==@lists.ozlabs.org
X-Gm-Message-State: AOJu0Yw9enZ99r3+69c9Aglq9HBTgWUOZejfz9C+UFbMSVDwpr16JBD1
	BoV2WFtVFQHKrhUAq7x5ogfIt4961zEmQXqZ+LJIAHrS7TsjxDScwnJcB4248ihT6NeBnNc3+Rl
	rJY8WYOqwge30jGEINSEhf7Yn10Nh0khhd2zn
X-Gm-Gg: AfdE7clMuRqSceuG3JFzUHw8zhtdoWoYxuYk4DfuoRhl88F4vYzUA+pLUXfrfjecO/M
	Wp0lI9vQuT/Dv6v70p9plFU+g1OfMxtJTJDl9ENdMSSdqiNAFxbVOTsmyIuCSilE0J6Hr2Q2L8B
	xpvPDES6O5+U9oNcrFt1TaSNX/r1bfaAG7MV2pRNtacDi6W2FN0jUMliRojeqaqXGtaqSbnxJAS
	vVosG4hmJSdGFCvgi1XWWuvnslMOHSzqnPt0Upx3iO62UftZ9JCw7wXfavVqdKSOf9fKis=
X-Received: by 2002:a05:690e:130e:b0:665:1bb1:e38 with SMTP id
 956f58d0204a3-668076cafbemr246715d50.13.1783991898202; Mon, 13 Jul 2026
 18:18:18 -0700 (PDT)
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
References: <20260621120121.73114-3-nithurshen.dev@gmail.com> <20260714011054.71167-1-nithurshen.dev@gmail.com>
In-Reply-To: <20260714011054.71167-1-nithurshen.dev@gmail.com>
From: Nithurshen Karthikeyan <nithurshen.dev@gmail.com>
Date: Tue, 14 Jul 2026 06:48:07 +0530
X-Gm-Features: AVVi8Cd715G8CLhqEXcYpBp9hiKQo1yU-kNh1I1gW00bgI1dAJE4ocx7ZG3x7j4
Message-ID: <CANRYsKgvY5-heOs3m_r4p-y+zNw0QzMSWrXsSigxAuiChoWYPw@mail.gmail.com>
Subject: Re: [PATCH v5] fsck.erofs: add multi-threaded decompression
To: nithurshen.dev@gmail.com
Cc: hsiangkao@linux.alibaba.com, linux-erofs@lists.ozlabs.org, 
	xiang@kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi Xiang,

| Algorithm | 4k | 8k | 16k | 32k | 64k |
| --- | --- | --- | --- | --- | --- |
| lz4hc(MTv5) | 6.44 | 6.71 | 5.64 | 5.18 | 4.71 |
| lz4hc(MTv3) | 9.36 | 8.31 | 8.27 | 8.54 | 6.94 |
| lz4hc(ST) | 4.40 | 5.77 | 3.65 | 5.45 | 3.36 |
| zstd(MTv5) | 6.85 | 6.47 | 5.99 | 6.11 | 6.16 |
| zstd(MTv3) | 9.26 | 8.68 | 8.89 | 8.11 | 7.94 |
| zstd(ST) | 5.23 | 4.52 | 4.62 | 4.11 | 4.02 |
| lzma(MTv5) | 21.92 | 23.43 | 23.82 | 24.92 | 26.74 |
| lzma(MTv3) | 23.72 | 24.79 | 25.90 | 26.92 | 27.77 |
| lzma(ST) | 56.37 | 65.06 | 71.07 | 74.69 | 81.63 |

Please find the new benchmark times for this patch.
I profiled the extraction process, and found out there was some
bottleneck for using `calloc` calls. I have switched them to
`malloc`.
And with some optimisation, I am seeing a ~2 sec improvement
from our previous baseline.

I will share profiling data shortly.

Please let me know your thoughts on this.

Thanks,
Nithurshen

