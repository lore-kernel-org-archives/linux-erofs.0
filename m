Return-Path: <linux-erofs+bounces-3137-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8A4F0FF60C1
	for <linux-erofs@archiver.kernel.org>; Tue, 31 Mar 2026 03:58:42 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4flDr10j0Wz2ybQ;
	Tue, 31 Mar 2026 14:58:41 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2607:f8b0:4864:20::631"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1774929521;
	cv=none; b=eyKw4EchJ6CpRIT8UiVl8wUmADM1tFqO0S20zSTrTows8M3YLUKg+WSUpVRasK3tr5v0zEvKcdzRKTQ2KYKOmu4GdCc0iSk3xDxn2ukIV+EdVPqyrhlMYBak7jol8/mYQNPTy+9bsmKENfKrTe87cgFbV8J+v6LbJmgo+5WXqAlkutpI74SmIUHlFXeuAFDrC/5/1Nsqr1xtN3BpNXXw+ptq7Bi1EYMOYR7TXU+iXkpnKhjYhG0xhpOe1VHY0EplfoSs5KlCwWEY2XeYZS4qP5Vm9FDaNRcJ3O46Uw5/v+g/EecbNVomYhyKnBcuLO3y5VlT2HCGVqR1doB94OQVLw==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1774929521; c=relaxed/relaxed;
	bh=s9E5vIG/N5OXAeNAYaNbDKiiICJJsQLYdSA3T1Ywogc=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=WoaoGQ0p7VVyNKQl/7zD4DwWf3D5YeoycBkq3W56bzMIr2Sre87h4ddDUQTufQdNhPifr3opXdoBtTLjELEq2BGKeFWT0hIDxiYxL1CyJmH/qXfQgE/vOKTbawPMLOwA4eEZ1oDoN3qyygA05FE4N+yX28wOzRgXMvedEPefCgP+UXTCRfyFwmwAzLBll0XSh8WM+TRTawSyfSbNlZTBtKQylDec4dJkEQtTNswz8lIcKY0qTmbya+3DoVu2iWPyvSNcJXCSLtYhjWr/JmYPQmZymh6XUiTQK2u7usmrakGEnbT5mm7yA4ZHbTR1cjdCRUTZ+UOhBmtPtZ0ZAXGbvQ==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=gmail.com; dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=LxWCdYqX; dkim-atps=neutral; spf=pass (client-ip=2607:f8b0:4864:20::631; helo=mail-pl1-x631.google.com; envelope-from=stopire@gmail.com; receiver=lists.ozlabs.org) smtp.mailfrom=gmail.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=LxWCdYqX;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=gmail.com (client-ip=2607:f8b0:4864:20::631; helo=mail-pl1-x631.google.com; envelope-from=stopire@gmail.com; receiver=lists.ozlabs.org)
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4flDr013mmz2xlK
	for <linux-erofs@lists.ozlabs.org>; Tue, 31 Mar 2026 14:58:39 +1100 (AEDT)
Received: by mail-pl1-x631.google.com with SMTP id d9443c01a7336-2b2503753efso15281775ad.0
        for <linux-erofs@lists.ozlabs.org>; Mon, 30 Mar 2026 20:58:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774929517; x=1775534317; darn=lists.ozlabs.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=s9E5vIG/N5OXAeNAYaNbDKiiICJJsQLYdSA3T1Ywogc=;
        b=LxWCdYqX+xKGXeZ3456NQorxY0n1Fu3JmlrjPphDih7ETYsStngHBTfyV3HHbhFQjP
         r+fRroIA3HI9+pt8qMUvUi8Tygb6q3kbQcQsABPZuu0BXGFsi4UsIer1GhGV9RYGMVBI
         J+CVJ01JttjsxBwWRRWekZsLPf57oqHKXjLyaQaY/HvNsWxodw2z73ytDv0Qbq3Zq/JP
         uKT1pgBqv9KPHHl7Ds+R3MTasH2PS4xTUbNgEaADOmVYbrdQ9OwYuLpdVKxtjmVivTL1
         cI2MnFAYxRZ0J5hV/JE3+6Zpi0mCcuDrvQpYYypUg7hrAms1BBT7nSccqxzxMG9hEnqG
         g9Cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774929517; x=1775534317;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=s9E5vIG/N5OXAeNAYaNbDKiiICJJsQLYdSA3T1Ywogc=;
        b=WSoKKm4mfLTNX8HUtSeB0g4uWflBR7jDGHPIf8Q0V+nnS/4NLZ+RtkSzbbSPJy235e
         jEMUdQk1TUy3OgdMa/Xwn/ILX71sNLmiK3HgomTaFMz/lnxF25qZNyqtsRb0vm/K7/Q5
         gAE25afFu6/lb3Px2Z0wChgFhhQkhBtGmokEFi6TzAkF1SGaqoi0h1ZRqprXDwDpX4Nw
         5ztQt5/DIrquzD7BR3ZKUy29Xb5UK5kdOJ8UqgEOiSb0/4H4Lbgf279EnsYPA28SFO38
         TvdRiYuDfZhDruZVK85BmLSKLE/8R0WEac8xOyJW3MXPYef73jFo2IJm94B+mBvCbxdN
         FK+A==
X-Gm-Message-State: AOJu0YwL/mG+FEYBLCxGCttlrwpiAkvDy42/E4Qgrm0Sl0aKhnvGbAYV
	a7a9ntg20abPNvOD/0XOarCtoq7G2OmONowFdYhdHwGE6LhNR3InPfgSvijRbIDoxuQ=
X-Gm-Gg: ATEYQzwVDVBYxgFzqbptzThG4MleQQoxj3BIEc1akiYkpKFSlsI4WmKrJDws1bEDGNC
	g//stl/E1Zp+2h7u3AMfr2OwzqUq75FW5pEgboMzV9tzU+WvaBcybXlRuOnPNdNyH91DSWyRX5I
	+/kV3TMPlhe85gLIS+vk37kiELmB5wuFa59lPE+l4bKf59DVvQYswXpAD7N3Gnfd6a/5jkkB9Qt
	xxjKh1BHSMKdiGZ/1j57PGs1VGVj3w8pXjBeyADBd3pqgNIqPp12DTLS1n6PiCX4hdaTh3L0n3R
	4tvNqJfQD1yEppHUqwq1UjcSFNNnBsC69Cbb8McgNeniQYM+YOHFCQt9c5dUaOJgw5P0ppoXgec
	CDveT9ymUKTSSyCRQPiomekicfqsstyM6wktp1yfPE3y15B9Towe/VflGd0D1KKDdSp/fnNTbUr
	X8pHv7jstzmO47Ii6hX6IYMq45/Wt51ZNjc3fFgdqlPbdrJJ7IKM7FmZ9fGdI9U/kgUwns
X-Received: by 2002:a17:903:1a86:b0:2b2:4e1a:aff9 with SMTP id d9443c01a7336-2b24e1ab2aemr78274955ad.44.1774929517353;
        Mon, 30 Mar 2026 20:58:37 -0700 (PDT)
Received: from [100.125.4.18] ([124.70.231.46])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b24277fb50sm93178315ad.56.2026.03.30.20.58.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 30 Mar 2026 20:58:36 -0700 (PDT)
Message-ID: <23825fb7-040c-48dd-a363-1e47a860d7c3@gmail.com>
Date: Tue, 31 Mar 2026 11:58:45 +0800
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
Subject: Re: [PATCH] erofs-utils: tar: guard slash-only header names
To: linux-erofs@lists.ozlabs.org, ch@vnsh.in
References: <20260330173447.486569-1-ch@vnsh.in>
Content-Language: en-US
From: Yifan Zhao <stopire@gmail.com>
In-Reply-To: <20260330173447.486569-1-ch@vnsh.in>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit


On 3/31/2026 1:34 AM, Vansh Choudhary wrote:
> Check that the assembled header path is non-empty before trimming
> trailing slashes from it.
>
> A malformed tar header name made up only of '/' characters could
> otherwise drive the trim loop to read before the start of the buffer.
>
> Signed-off-by: Vansh Choudhary <ch@vnsh.in>
> ---
>   lib/tar.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/lib/tar.c b/lib/tar.c
> index 4e97522..39e2321 100644
> --- a/lib/tar.c
> +++ b/lib/tar.c
> @@ -866,7 +866,7 @@ out_eot:
>   			path[1] = '\0';
>   		} else {
I think this else branch has ensured `j != 0`.
>   			*_path = '\0';
> -			while (path[j - 1] == '/')
> +			while (j && path[j - 1] == '/')
>   				path[--j] = '\0';
>   		}
>   	}

