Return-Path: <linux-erofs+bounces-4229-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0CBD6C5DF6A
	for <linux-erofs@archiver.kernel.org>; Sat, 15 Aug 2026 13:31:25 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hMg3c0j3Hz2xnQ;
	Sat, 15 Aug 2026 23:31:24 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2607:f8b0:4864:20::1029"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1786800684;
	cv=none; b=WhvIr6omLP4uzH0F+gkIiP/QjIkk2Or0m/HH0UO7QVj6FC0yxDNiIvDYp+/W0HHlGyDaUgqLwhlNHJ7mmD6GkvdCwof7Rq6zZKNmLMaSrbOKhQYgu4lDk6gk896o6ElveeFAAZiAe4O3A9YinTHa+3/JVUD+DnUaq7qxC5VS7HTlwmhTbJv09CjgFRKlhFEWuBTJEFH+4OSlJd6duJrJKLG923FcKnjiPOhFeO6IdOufSJI1UKokRvshDwmUJnbhFZ/5jfpzJXCL72dQRjfWB+zSW7IenfSOTbP0hn3cVxfxhLkdI63R1gfwExtEc/22p7yyBzUP63MhzJgNIIVY8w==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1786800684; c=relaxed/relaxed;
	bh=CV62CXzf5K42ViVKXjIE4H/Klf/9YX5YUXCrJukmmRY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=nM04mcdqW064gXBVSyfWoMVIkmBLo1BIDeG2b0viMtTS8CJcLUoFoymIx53ordu8+1fSjYutyDnZTMzgSl1HvxMqh2k7qTROxz4/H4RoMEXJ/qROb2QeCt8Eg1TtgNNUV5WAGCzB+yo5QMlc6mTayZV4jFD32QjOIE4jkH3hR0qsyktOxrSj3YJgkzh2cZRGvoDF32sF2azVL+kttbA+/65XDZRmq9WoAIkMBCMzq1xqmOPWpkn/2Q46bukR9WstY9Ztw72cEQZaNHgxIQFYooFrbeDXtwigwIqkPc0RU1LgulOinFz1gL5PaeHxBjOIWfHjg0DiT1si2MI2F7PoTA==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=none (p=none dis=none) header.from=roeck-us.net; dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=okIdt10n; dkim-atps=neutral; spf=pass (client-ip=2607:f8b0:4864:20::1029; helo=mail-pj1-x1029.google.com; envelope-from=groeck7@gmail.com; receiver=lists.ozlabs.org) smtp.mailfrom=gmail.com
Authentication-Results: lists.ozlabs.org; dmarc=none (p=none dis=none) header.from=roeck-us.net
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=okIdt10n;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=gmail.com (client-ip=2607:f8b0:4864:20::1029; helo=mail-pj1-x1029.google.com; envelope-from=groeck7@gmail.com; receiver=lists.ozlabs.org)
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hMg3Y4hM1z2xlw
	for <linux-erofs@lists.ozlabs.org>; Sat, 15 Aug 2026 23:31:21 +1000 (AEST)
Received: by mail-pj1-x1029.google.com with SMTP id 98e67ed59e1d1-382ef647e20so1885813a91.1
        for <linux-erofs@lists.ozlabs.org>; Sat, 15 Aug 2026 06:31:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786800678; x=1787405478; darn=lists.ozlabs.org;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:sender:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=CV62CXzf5K42ViVKXjIE4H/Klf/9YX5YUXCrJukmmRY=;
        b=okIdt10nb+wXT9hJbaR4Xv/KjqDqv4dJAEPP+4tIfSPEwbSr9IY6Yeyl3byCChVOAE
         VcVnqvyq76mg6amo9p8Gb/wVYwm95yVZRkTFVp1vEsVoRJRCTrBlkMLk7xS2hfyPu/fY
         JcsXsSlogYOuIbZiyRC6Y56mQg58h9WU6NSeNvZpDFWJfsnTh6Cplb0WSWpy8vO6aXnE
         rmhmqEu3EkIpvsHHF0SXgVwHB8FZc4XEg2fwbIlSb7BmmYURwI8h55vuhAhSEDvJ76ZZ
         lcl5VZpCGR05mW0WYkOSUyV3VK9TfJHnhEe94ss43ChtG0KFEi/0qrgJih2YSuwQuk/s
         kyEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786800678; x=1787405478;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:sender:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=CV62CXzf5K42ViVKXjIE4H/Klf/9YX5YUXCrJukmmRY=;
        b=DKUviv5hXGpAz+hQm3p8vErhcIx0E68pAfOvmUCkpesuQB3KFWPPCZwhC1B8vyN7t9
         27Gdz9D23Eb1Fs4u4td0/HrDeaayCPgX7FqjgLtitCjlDtsim/9fdpPTQAVI8mzzcutW
         uG2vUSQTT5yM+WRxsOX8shdXNeKwQa/Wk6hiduGCvFfqyA+oMcqxaefpdD5IGEQxjLF+
         kWQpEenuueDYkdX/GaEwYErTmWGxBNGs+VHx08V2Xv4SSLaUZHcIprrwyvpL642MNdzT
         HSXf6pJZKrNEXsW8s2gjMIEmOmBpIL0pDt9ybuX65vS3/h+ezCGalucKLcbLqGuGajJo
         tZVQ==
X-Forwarded-Encrypted: i=1; AHgh+RoIPIDJotOAUCXH9GEeTPPsKCkYAGmU/aY+//boVPW3WJ9jsbIAxORmSCObONgU6bI8S7utvJdMFzCUoA==@lists.ozlabs.org
X-Gm-Message-State: AOJu0Yy2FBBOJOjIi6W4X9Wr4nsj5Ir9h1swnUCDNHI7QV1mPJF68vDh
	34Clpxc+c/ucNPj6xb1iivF33b3g3siznVNFRmleNIhR6iaJlArlESFj
X-Gm-Gg: AR+sD12J5esrs0lMeWyRssZsN2R5pKN8qSbrhyyfkMKRD3TjJsSXOLAT17c6ueCvaZy
	2nJgrVnphVhW+/IMjfj+sFDNhzb+hJR47RVVdMiuItoXbGivI/TMcAJfk9wokA9bQCN8aqewGR/
	95XXs0CufZD+VwZNpPrMLxxAyBz8IAdsPnMBV/ZdUPllSiUdjKIJ+T3PwHlkt98Wt+AP2txTEFa
	/M1hZdxcQkM8IWeokTHohZfNWggjZi9w2bvcjAdVtNkfFZv9BEFG67gmRLv1OeIH1kIt2f5h4HL
	doBBfsT3BVL/ddl0tmOv8803L9dYmRerKZHyrzQX78CQjNxxsXutE/qyymgNOL5efWIGJvgdHLz
	tCf0LA2U0doHfxjqEMg0GDOxppV7CkqqmeK58Eyb+NKS6JA6MCtwVp/wWU+U92x+l6wLxHceU6G
	5vZ05K4yDBIeulJQ+2rBgj8TGf81r/MqtuoGOsTEPL2K1fFz0SJbQvwdWxQbCTd8tDsMAai4tl+
	a3eaeCt//eAffkkmmw88J9tsOq4StrgGg/4lg==
X-Received: by 2002:a17:90b:58e5:b0:381:a766:efc9 with SMTP id 98e67ed59e1d1-3933caf3a05mr14623380a91.7.1786800677874;
        Sat, 15 Aug 2026 06:31:17 -0700 (PDT)
Received: from ?IPV6:2600:1700:e321:62f0:da43:aeff:fecc:bfd5? ([2600:1700:e321:62f0:da43:aeff:fecc:bfd5])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-394ea97207fsm6224722a91.1.2026.08.15.06.31.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 15 Aug 2026 06:31:17 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Message-ID: <7322fa42-3b9a-442b-a49d-ec456b273928@roeck-us.net>
Date: Sat, 15 Aug 2026 06:31:15 -0700
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
Subject: Re: [PATCH v3] erofs: cap LZMA stream pool size
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Gao Xiang <xiang@kernel.org>,
 Michael Bommarito <michael.bommarito@gmail.com>,
 =?UTF-8?Q?Uwe_Kleine-K=C3=B6nig?= <u.kleine-koenig@baylibre.com>,
 SJ Park <sj@kernel.org>, Gao Xiang <hsiangkao@linux.alibaba.com>,
 Yue Hu <zbestahu@gmail.com>, Jeffle Xu <jefflexu@linux.alibaba.com>,
 Sandeep Dhavale <dhavale@google.com>, Chunhai Guo <guochunhai@vivo.com>,
 linux-erofs@lists.ozlabs.org, linux-kernel@vger.kernel.org,
 Chao Yu <chao@kernel.org>, David Hildenbrand <david@redhat.com>,
 linux-kbuild <linux-kbuild@vger.kernel.org>
References: <20260728065447.91511-1-sj@kernel.org>
 <CAMuHMdWq1eutRM4u1Q3r50f8W4oSejo_XAgyjEKuwi4Lw6K7jQ@mail.gmail.com>
 <anBYnPELPotUiNjv@monoceros>
 <CAMuHMdXUyAX0TV0Sq9_YxvipzkVOBX=4s_r5mVQcZ_7nL=-AQw@mail.gmail.com>
 <87853c96-cc8f-49e6-81b1-02bfe409e372@roeck-us.net>
 <CAJJ9bXyC=piPamaGJN=VMA72Ws+WqgJbYZgTj_w6NFzyLa_mMg@mail.gmail.com>
 <anuyFHLUGDjZWY4K@XiangdeMacBook-Pro.local>
 <CAMuHMdWQLwgShMK7G-6soiZxtRPYWLizBLRdouwxFUcFXUJM-Q@mail.gmail.com>
 <anxQ-DohuQvuKwAH@XiangdeMacBook-Pro.local>
 <5825b5c2-06b3-4358-91b0-d7bf437528a3@roeck-us.net>
 <an9d0zxE5J8txxf6@XiangdeMacBook-Pro.local>
 <1638f2a8-d9cd-423d-83f6-2b436e3c9de0@roeck-us.net>
 <CAMuHMdXpJY3gqx98z92=P8NxV2_-_N+5OVqNvMLDMKq9bhuY+Q@mail.gmail.com>
Content-Language: en-US
From: Guenter Roeck <linux@roeck-us.net>
Autocrypt: addr=linux@roeck-us.net; keydata=
 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
 np3900V20aS7eD9K8GTU0TGC1pyz6IVJwIE=
In-Reply-To: <CAMuHMdXpJY3gqx98z92=P8NxV2_-_N+5OVqNvMLDMKq9bhuY+Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 8/15/26 04:41, Geert Uytterhoeven wrote:
> Hi Günter,
> 
> On Fri, 14 Aug 2026 at 20:44, Guenter Roeck <linux@roeck-us.net> wrote:
>> On 8/14/26 11:26, Gao Xiang wrote:
>>> On Wed, Aug 12, 2026 at 07:25:50AM -0700, Guenter Roeck wrote:
>>>>>> Thank you, that seems to work (despite still seeing the warning on m68k,
>>>>>> as NR_CPUS does not exist).
>>>>>>
>>>>>>          $ make ARCH=m68k allmodconfig
>>>>>>         fs/erofs/Kconfig:137:warning: range is invalid
>>>>>>
>>>>>>     Warning...
>>>>>
>>>>> Yes, other arches shouldn't have the warning because I think other
>>>>> arches (including microblaze) defines NR_CPUS in Kconfig, except m68k.
>>>>
>>>> That is not entirely true. openrisc only has it if SMP=y. But it still
>>>> does not generate the warning for some reason.
>>>
>>> I looked into the documentation a bit
>>> (https://docs.kernel.org/kbuild/kconfig-language.html), especially the
>>> following parts:
>>>
>>>    - type definition: “bool”/”tristate”/”string”/”hex”/”int” ...
>>>    - input prompt: “prompt” <prompt> [“if” <expr>] ...
>>>        and "If a prompt is not present, the config option is
>>>             a non-visible symbol, ..."
>>>
>>>    - dependencies: “depends on” <expr> [“if” <expr>] ...
>>>    - Menu dependencies ..
>>>
>>> and I think that is true, taking openrisc for example:
>>>
>>> config NR_CPUS
>>>           int "Maximum number of CPUs (2-32)"
>>>           range 2 32
>>>           depends on SMP
>>>           default "2"
>>>
>>> which can be transformed into
>>>
>>> config NR_CPUS
>>>           int
>>>        prompt "Maximum number of CPUs (2-32)"
>>>        range 2 32
>>>        depends on SMP
>>>           default "2"
>>>
>>> which can be then transformed into
>>>
>>> config NR_CPUS
>>>           int
>>>        prompt "Maximum number of CPUs (2-32)" if SMP
>>>        range 2 32 if SMP
>>>           default "2" if SMP
>>>
>>> so if `SMP=n`, it's equivalent to
>>>
>>> config NR_CPUS
>>>           int
>>>
>>> so NR_CPUS symbol is still there I think (and its value is 0.)
>>>
>> $ grep NR_CPUS .config
>> CONFIG_FORCE_NR_CPUS=y
>> $ grep EROFS .config
>> CONFIG_EROFS_FS=y
>> # CONFIG_EROFS_FS_DEBUG is not set
>> CONFIG_EROFS_FS_XATTR=y
>> CONFIG_EROFS_FS_POSIX_ACL=y
>> CONFIG_EROFS_FS_SECURITY=y
>> CONFIG_EROFS_FS_BACKED_BY_FILE=y
>> CONFIG_EROFS_FS_ZIP=y
>> CONFIG_EROFS_FS_ZIP_LZMA=y
>> CONFIG_EROFS_FS_ZIP_LZMA_DEFAULT_MAX_STREAMS=0
>> # CONFIG_EROFS_FS_ZIP_DEFLATE is not set
>> # CONFIG_EROFS_FS_ZIP_ZSTD is not set
>> # CONFIG_EROFS_FS_ZIP_ACCEL is not set
>> # CONFIG_EROFS_FS_PCPU_KTHREAD is not set
>> # CONFIG_EROFS_FS_PAGE_CACHE_SHARE is not set
>>
>> The symbol may be there internally, but it does not show up in .config.
> 
>      config EROFS_FS_ZIP_LZMA_DEFAULT_MAX_STREAMS
>      ...
>      range 1 NR_CPUS
> 
> Apparently the default value picked by "automatic" configs like
> allmodconfig and defconfig is the last item from the range.
> If NR_CPUS exists internally (e.g. openrisc and arm), you end up with
> the "undefined value", aka zero:
> 
>      CONFIG_EROFS_FS_ZIP_LZMA_DEFAULT_MAX_STREAMS=0
> 
> As NR_CPUS did not exist on m68k at all, you ended up with the NR_CPUS
> literal:
> 
>      CONFIG_EROFS_FS_ZIP_LZMA_DEFAULT_MAX_STREAMS=NR_CPUS
> 

Upstream commit a64d500b0078 ("erofs: fix EROFS_FS_ZIP_LZMA_DEFAULT_MAX_STREAMS
on some UP platforms") should fix that problem. Apparently it did not only
affect openrisc.

Thanks,
Guenter


