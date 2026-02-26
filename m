Return-Path: <linux-erofs+bounces-2424-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 001DBFD4609
	for <linux-erofs@archiver.kernel.org>; Thu, 26 Feb 2026 02:40:58 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4fLwgY2x3rz309S;
	Thu, 26 Feb 2026 13:40:57 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=203.205.221.240
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1772073356;
	cv=none; b=jwYNi9C1fqdQDKmc4vqPbvwS+yAgQHCtc5EseEiBHwKOrJ7bn1JqvtYMGnB8URgvO3rbYxkxVK77bOujQ16oUoJTL3iFH2wDQV9DM02rui0BogE8t/eZ6CtcfFvw9m8CdJGapm62RF7pxLYSmEsRVraprwlY6dOZyx3FmpS5iG1PxqgwnyznBZdl3EQT1PEn0AO0/X+zImXVepJUpJzMaCHjkDNxXL5gA1YNHGWVTDGJgcgwgaar1L+/vJOgXnODJgnvDXBgYenEGMrfrEX3Nf6fWywYyWUO2ezjy8spEAZgI3/nSKVoyTFHF/uhgeU0s+lcZT9ePnMVkQBM0GxQxw==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1772073356; c=relaxed/relaxed;
	bh=T52PzzBvd4ygBeYqQ87reXWNaO9BJX+Y6D4YvYuu4AU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=J4s8f75WACo999NmNLZhzrumn1hm89fe9yB7eANMBR9CdLWRL4CqahzxJ+CNJe+EjrxnXBk27ckddKvE+iMfoiFhLKgXACmr8bYEf9zW5Yvkk3PeNlBRWhfhgQX8iKZUEReV//g8MprxqGReXnsENrLI9vjemefu/rtuZe6Hr3XJy+rU33klqh5A3Ej13xGmB2tPi/SnnKGYGrvNKbhxz3PmdLrNU5kRy+I68GpUM2cQKSCmZzlceLWNIQ7rBiw9Zp8ThmKC8QDQkrzxnikYOF5imUvNiPYyTxJ6hdXhiwuKuiefv3mRh958MdlPOmbI7lqKWIalE+pk+MgJdiCNAg==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=foxmail.com; dkim=pass (1024-bit key; unprotected) header.d=foxmail.com header.i=@foxmail.com header.a=rsa-sha256 header.s=s201512 header.b=Cha8Wo6r; dkim-atps=neutral; spf=pass (client-ip=203.205.221.240; helo=out203-205-221-240.mail.qq.com; envelope-from=yifan.yfzhao@foxmail.com; receiver=lists.ozlabs.org) smtp.mailfrom=foxmail.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=foxmail.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=foxmail.com header.i=@foxmail.com header.a=rsa-sha256 header.s=s201512 header.b=Cha8Wo6r;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=foxmail.com (client-ip=203.205.221.240; helo=out203-205-221-240.mail.qq.com; envelope-from=yifan.yfzhao@foxmail.com; receiver=lists.ozlabs.org)
Received: from out203-205-221-240.mail.qq.com (out203-205-221-240.mail.qq.com [203.205.221.240])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with UTF8SMTPS id 4fLwYh3pY2z2xQs
	for <linux-erofs@lists.ozlabs.org>; Thu, 26 Feb 2026 13:35:51 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=foxmail.com;
	s=s201512; t=1772073349;
	bh=T52PzzBvd4ygBeYqQ87reXWNaO9BJX+Y6D4YvYuu4AU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Cha8Wo6r6pHmD++6mAEq2jh/I4f+Fc/WtpM/a4l9H+cpP44K68NQXOOELmTvlcLM/
	 aH/4VVh2b3Kips+pLtF7F8SBnKfl8towGeZ4BfsTx/0xoaR9wzObNpobKgKI49Ul+1
	 4vXjwJuke5OGFL9XZ18jJpihAStNImpEmXTeDjDk=
Received: from [100.125.4.233] ([124.70.231.43])
	by newxmesmtplogicsvrsza53-0.qq.com (NewEsmtp) with SMTP
	id 81C08CAC; Thu, 26 Feb 2026 10:32:28 +0800
X-QQ-mid: xmsmtpt1772073148tj0o6qvrm
Message-ID: <tencent_E8B3BD7F4663756DD9915EF539DC95AB1805@qq.com>
X-QQ-XMAILINFO: NMGzQWUSIfvTsQAsPapjIdbYacErVhddVb07YxJJCrEzrkhne9HoKZ/4oO9l26
	 0BPI8Q8I//bvPr4Vi9HfKLbvhWmwBAb53hQmhRvjxYQTjGtjWgbLn/Qo+In9bdb+o0O5ttyV8ULt
	 M9qKB0DQ92MrB7t7a0pa7lLahWdp8Qb6whBEjxmxrfcfIhXGcrdbRQCpu/g4Wkj4UKjKbfZWdOXl
	 SWuL1oUdTmsJZ9myAJT9VRFQVsVgciF1iDCqV2cRMjNr8BHrN+93SqhbLHqAbtHs2A5NxYqYk5DK
	 LQ2f43cmW5v+A9h2zZKe+Et6QD3p45sVTz7ISOAO+8wOcsas8g795WPb89uyk3z5hgpSLxEQuFTc
	 1uJt6vCS3Wkb7DEWzLT58QHte+ET6reChueFOE469/Z++YiiP1v1qFzOTFCh9vqdtKW8X5j/zHHE
	 CoorhJYKm0jkviJk5vM/B5p9yqvwJuZABky06OGWiDW2P1/Z52cwS75Fbn03t6cMDzzmRSR5WIJ5
	 fuEOjZRstdsvcozOh6Hd4fyNNf6+OaCVxNBa+4LRmsljAChcDy7h2RJ5Z6zC1skXYzU8o1DAN8sP
	 37YTxzd+WwPptGVozg4pp0kSr6UgTNibYiVcNF5XRRNjVvfcBPnPp7ONiFd8rtjqbxbmjaedRZ5A
	 WCpOe3K4VGxDS7tjvjjNQwxK5hbC3DVddxdaz5x3VVYZOoNdBtm2NoFZFZOPbpbenz9E/7dZHlMh
	 qICxVvtkaRT8JBmXhdkRz9dC/CaER/BLVDYQoopZxTdX6WU47UZGu1IXTe8figT3DecjEw2/yN47
	 Qd4y9fXXNni4wbxObaMagozahobYRWB/j7Ll8ZZ81ES6mwTaTfg2erAzA58TtBY/i3MW/nUKmqui
	 WHclGxHNmYln+u+v6ACrbcmuSJtKQ55AD3I2IQ+shBMVoYq9kOQUiAu2DJOMisCvPU6ASWkUWjm/
	 slDho2JHRgFFZCvYICtqPNjlsGAS1JM9PMuR9sGufDyY/le72QQZ0ZT3+D8bBSCXX02WVvZ3N0mn
	 mGf0dsOJJJUX8nW/3kRFTokcq09jJBpF9P07eo2ck+tSgc1NSr
X-QQ-XMRINFO: OWPUhxQsoeAVwkVaQIEGSKwwgKCxK/fD5g==
X-OQ-MSGID: <03856d6f-205d-4092-b4c5-16195e5e2e6f@foxmail.com>
Date: Thu, 26 Feb 2026 10:32:33 +0800
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
Subject: Re: [PATCH v2] erofs-utils: lib: converted division to shift in
 z_erofs_load_compact_lcluster
To: Ashley Lee <yester1324@gmail.com>, linux-erofs@lists.ozlabs.org
Cc: hsiangkao@linux.alibaba.com
References: <20260225173036.194311-1-yester1324@gmail.com>
Content-Language: en-US
From: Yifan Zhao <yifan.yfzhao@foxmail.com>
In-Reply-To: <20260225173036.194311-1-yester1324@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Hi Lee,


A quick search shows that x86 kernel implementation also use `div` 
instruction

under Linux v6.19 and GCC 15.2.1, add GCC correctly generate shift 
instruction

in my arm64 machine with GCC 14.2.0.

Could you also consider evaluate this optimization in kernel?


Thanks,

Yifan

On 2/26/2026 1:30 AM, Ashley Lee wrote:
> perf on fsck.erofs in gcc reports that z_erofs_load_compact_lcluster
> was spending 20% of its time doing the div instruction. While the
> function itself is ~40% of user runtime. In the source code, it seems
> that dividing by vcnt doesn't optimize to a shift despite the two
> possible states being powers of 2.
>
> Changing the division into a ilog2() function call encourages the
> compiler to recognize it as a power of 2. Thus performing a shift.
>
> Running a benchmark on lzma compressed freebsd code on x86, shows
> there is a ~4% increase in performance in gcc. While clang shows
> virtually no regression in performance. The tradeoff is slightly
> obfuscated source code.
>
> The following command was run locally on x86.
>
> $ hyperfine -w 5 -m 30 "./fsck.erofs ./bsd.erofs.lzma"
>
> patch on gcc 15.2.1
> Time (mean ± σ):     354.8 ms ±   6.0 ms    \
>    [User: 227.8 ms, System: 126.1 ms]
> Range (min … max):   345.8 ms … 366.2 ms    30 runs
>
> dev on gcc 15.2.1
> Time (mean ± σ):     370.7 ms ±   6.7 ms    \
>    [User: 246.5 ms, System: 123.4 ms]
> Range (min … max):   362.7 ms … 390.7 ms    30 runs
>
> patch on clang 21.1.8
> Time (mean ± σ):     371.9 ms ±   2.4 ms    \
>    [User: 247.2 ms, System: 123.9 ms]
> Range (min … max):   369.1 ms … 380.0 ms    30 runs
>
> dev on clang 21.1.8
> Time (mean ± σ):     371.0 ms ±   1.9 ms    \
>    [User: 245.5 ms, System: 124.5 ms]
> Range (min … max):   368.4 ms … 377.7 ms    30 runs
>
> Signed-off-by: Ashley Lee <yester1324@gmail.com>
> ---
> v2: changed vdiv to ilog2 call
>
>   lib/zmap.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/lib/zmap.c b/lib/zmap.c
> index baec278..3ac7fe9 100644
> --- a/lib/zmap.c
> +++ b/lib/zmap.c
> @@ -160,7 +160,7 @@ static int z_erofs_load_compact_lcluster(struct z_erofs_maprecorder *m,
>   	m->nextpackoff = round_down(pos, vcnt << amortizedshift) +
>   			 (vcnt << amortizedshift);
>   	lobits = max(lclusterbits, ilog2(Z_EROFS_LI_D0_CBLKCNT) + 1U);
> -	encodebits = ((vcnt << amortizedshift) - sizeof(__le32)) * 8 / vcnt;
> +	encodebits = (((vcnt << amortizedshift) - sizeof(__le32)) * 8) >> ilog2(vcnt);
>   	bytes = pos & ((vcnt << amortizedshift) - 1);
>   	in -= bytes;
>   	i = bytes >> amortizedshift;


