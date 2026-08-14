Return-Path: <linux-erofs+bounces-4223-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D7A4AC5CFC1
	for <linux-erofs@archiver.kernel.org>; Fri, 14 Aug 2026 18:44:43 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hMB3Y5tvqz2yMn;
	Sat, 15 Aug 2026 04:44:41 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2607:f8b0:4864:20::62b"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1786733081;
	cv=none; b=Dc/vcp0e/pa4UoXMp6GZD8KIhGZGCyi6szfedvmGRmV3fFbUkKGnL4+WnfN+Rzb93cpAyHkUboF0HV9hcESWEmYzN13cqSs8OW017UzIHuJ1Mk9Hv/7iwmkne0scun9VW1fVu0cDTqNole/tRjILhqaZbn2JDUu6B5SHLqX+8mWjviGBSw8zNjVljXbn8dx2vWRZLcVL3hksz847MOnSHFGzUj6LjOhqGnP1i81MWocgoF1O4eYq1bqJc5aa46MlZWTiLrU2ZgeMV87o2MHahrl9R2lSClAO9tVUkiARQzRuiKcr4EgPOFc40GKVedifCJuQPZPohvbWlYZA22b/ng==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1786733081; c=relaxed/relaxed;
	bh=MNEidr2KFt1I7RwedPmL91IOikOMlVYzJSqT4ObkJNk=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=dQwfpmYVaqheB9W4AIFXvrnkFFPDduCDuwqq6E8of5+G3gEqkylzy2h8u1b5p5DDkEX3pFuOeL24PPyEZgWwYwN5T8lQuOICas6YCQ7XmlMkdgfGgKFUHvhsFFQi1O+SDV6buVgYYVoSGmOv0ehiE2+QxGqs9b1Y9eSHsHsnU5nVF5MkyesV1sETZZnwKcjgrJDUONYEBzyBzOpWMtuiXi6sauIvexOBgQuNBRZJJgLPayKe+h6Qm0Y9bUjXVLPt5BSbZWNbi1+K/kxh5gkIMIXCXTqgA3LQ79CgMYrrRGulc2C5KYyUeegn+hP+HtO1HjuNrb/Z4LONTiW9+TlP+g==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=none (p=none dis=none) header.from=roeck-us.net; dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=XIPEAv08; dkim-atps=neutral; spf=pass (client-ip=2607:f8b0:4864:20::62b; helo=mail-pl1-x62b.google.com; envelope-from=groeck7@gmail.com; receiver=lists.ozlabs.org) smtp.mailfrom=gmail.com
Authentication-Results: lists.ozlabs.org; dmarc=none (p=none dis=none) header.from=roeck-us.net
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=XIPEAv08;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=gmail.com (client-ip=2607:f8b0:4864:20::62b; helo=mail-pl1-x62b.google.com; envelope-from=groeck7@gmail.com; receiver=lists.ozlabs.org)
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hMB3V1nnNz2xyk
	for <linux-erofs@lists.ozlabs.org>; Sat, 15 Aug 2026 04:44:37 +1000 (AEST)
Received: by mail-pl1-x62b.google.com with SMTP id d9443c01a7336-2ccf2360620so14615455ad.3
        for <linux-erofs@lists.ozlabs.org>; Fri, 14 Aug 2026 11:44:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786733074; x=1787337874; darn=lists.ozlabs.org;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:to:subject:user-agent:mime-version:date
         :message-id:sender:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=MNEidr2KFt1I7RwedPmL91IOikOMlVYzJSqT4ObkJNk=;
        b=XIPEAv08gweFFZYo5ednnVXHCAbssf4/mkS4oeznvj784Ddi447lyFnsPzgufuWt5F
         J0rWd8EoGpG4fG4PTLDZWF//4MuNf+IvASwUiB8E2+10R4w2sRqAW4O0MAaSemQKMwwH
         F/Ai/rCAmcghvPX0ngLfAqQ6UHdECR72EQ96P8se6Skjb99a6DzYCqVoZVuXEIaJ7sKR
         vE9ZswIW3fYAvzbNuy5zXIMMQ0QT4FuUVXMhjW57dyraCcZhpGy/teBY481uX5zjXC1W
         80rFpJzxvFtjU/6zO1fKsLTLvj9k6CvgMZF837w3TNmh4xphzC8IFCFhuA+2zee6zhv8
         94Iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786733074; x=1787337874;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:to:subject:user-agent:mime-version:date
         :message-id:sender:x-gm-gg:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=MNEidr2KFt1I7RwedPmL91IOikOMlVYzJSqT4ObkJNk=;
        b=tVGhIky2Iv1QFl1rN0BNTrzrRJk6ZNp4Gk96Oq9w1BKuymZeSXADv99Iwu0l7e0o+7
         INnAQcCghk+dmsB4xFOhqGUuZhpyAM/CpMxRBPemZeqbigr7xy6PqMEghCURgk4SNk5L
         2X6P/982NyuORvookSG2o/aLcuolFJctcXeodKcdP4ST3M8iGsvRyLDWyZNIpoEaaBEs
         svaczDWmZlB23l5qSFXdBvqRO3EwXp/yzkIpD3O2xhCpmbhlfV+ZuWNDKPBEXbcpmwHp
         E/chxGeTJDfFD3xJqnkAebdXENSVlJRbwrfl/jNiLM8Mzwn3EYVSycK4NxyOFV8kJD9Y
         Ms7A==
X-Forwarded-Encrypted: i=1; AHgh+Rqy3pm3wGfo+Dz4iK18Q7CYjfVQYpgSN6KIVetNF0hkbp2WBK9a1U0i7Gvjl9v5ICkiuhO0+2n61IkKKQ==@lists.ozlabs.org
X-Gm-Message-State: AOJu0YyvWjdap7t4GvQfCiv1+rvie81RsRIN0hpMFnLcMsYPAtjQa+ri
	nHiYd4Va3T9RFkClorDyve67cg5SzYdLFaONnMJLYzOlHa5esyTl13b3
X-Gm-Gg: AR+sD12Bb//0u5lS5g1NOjNkTROaGB3tKfNuMVyGB8KKAss/Y0ITFpZKbsLjoN0h4kg
	GgNQzgML/XHSVO+fzFImoZhE83eNZR8P4sAe4RzblPmWbcDdnpBh2Y03LnOUl06IBwZE/UyhG5q
	JVoB9RvAGzRcNdO+RLsR6G2pE/QQ57d1d4Cwyvb/ddB8O912KkoWxRefkn0d7GNzDPqqnvKNGEJ
	COkQi4mTZ4TJRyPriZ41g1Ejo6ky1j5RcK3EZKPHjk3bhnfTJTvhLUEqlTWos1wUotJSwkMCBmT
	jx5T3ITe04tfrMDYF7tCSCdmbUmIcQ3w5UimXl3DddTCTd9musRfwc8wisvdwj/m5Smiz5ZmRC1
	VEkLmj2ARWTfpk+41fDDC/oZFmYvZu7STPOjz1bsz+zgPtYR/XJLQKbl1xyHZ375jajiBkhLuIo
	9wzBVjMOYrFK+J/ya8sW9t2uzyv/0/HSuTSwgFDinXdC5k5Bkhj1VY9wKRTzQgE7PQUDjf2iokW
	mdxN2iPpoerovazwnU3pzPfJz6Um93/xzumnn7t6YMSecrd
X-Received: by 2002:a17:903:37c4:b0:2d2:da8e:9017 with SMTP id d9443c01a7336-2d3b0c5437dmr96796605ad.8.1786733073453;
        Fri, 14 Aug 2026 11:44:33 -0700 (PDT)
Received: from ?IPV6:2600:1700:e321:62f0:da43:aeff:fecc:bfd5? ([2600:1700:e321:62f0:da43:aeff:fecc:bfd5])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-320e9df03f9sm7047822eec.19.2026.08.14.11.44.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 14 Aug 2026 11:44:32 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Message-ID: <1638f2a8-d9cd-423d-83f6-2b436e3c9de0@roeck-us.net>
Date: Fri, 14 Aug 2026 11:44:31 -0700
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
To: Geert Uytterhoeven <geert@linux-m68k.org>, Gao Xiang <xiang@kernel.org>,
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
Content-Language: en-US
From: Guenter Roeck <linux@roeck-us.net>
Autocrypt: addr=linux@roeck-us.net; keydata=
 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
 np3900V20aS7eD9K8GTU0TGC1pyz6IVJwIE=
In-Reply-To: <an9d0zxE5J8txxf6@XiangdeMacBook-Pro.local>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 8/14/26 11:26, Gao Xiang wrote:
> Hi Guenter,
> 
> On Wed, Aug 12, 2026 at 07:25:50AM -0700, Guenter Roeck wrote:
> 
> ...
> 
>>>>
>>>> Thank you, that seems to work (despite still seeing the warning on m68k,
>>>> as NR_CPUS does not exist).
>>>>
>>>
>>> ...
>>>
>>>>
>>>>         $ make ARCH=m68k allmodconfig
>>>>        fs/erofs/Kconfig:137:warning: range is invalid
>>>>
>>>>    Warning...
>>>>
>>>
>>> Yes, other arches shouldn't have the warning because I think other
>>> arches (including microblaze) defines NR_CPUS in Kconfig, except m68k.
>>>
>>
>> That is not entirely true. openrisc only has it if SMP=y. But it still
>> does not generate the warning for some reason.
>>
> 
> I looked into the documentation a bit
> (https://docs.kernel.org/kbuild/kconfig-language.html), especially the
> following parts:
> 
>   - type definition: “bool”/”tristate”/”string”/”hex”/”int” ...
>   - input prompt: “prompt” <prompt> [“if” <expr>] ...
>       and "If a prompt is not present, the config option is
>            a non-visible symbol, ..."
> 
>   - dependencies: “depends on” <expr> [“if” <expr>] ...
>   - Menu dependencies ..
> 
> and I think that is true, taking openrisc for example:
> 
> config NR_CPUS
>          int "Maximum number of CPUs (2-32)"
>          range 2 32
>          depends on SMP
>          default "2"
> 
> which can be transformed into
> 
> config NR_CPUS
>          int
> 	prompt "Maximum number of CPUs (2-32)"
> 	range 2 32
> 	depends on SMP
>          default "2"
> 
> which can be then transformed into
> 
> config NR_CPUS
>          int
> 	prompt "Maximum number of CPUs (2-32)" if SMP
> 	range 2 32 if SMP
>          default "2" if SMP
> 
> so if `SMP=n`, it's equivalent to
> 
> config NR_CPUS
>          int
> 
> so NR_CPUS symbol is still there I think (and its value is 0.)
> 
$ grep NR_CPUS .config
CONFIG_FORCE_NR_CPUS=y
$ grep EROFS .config
CONFIG_EROFS_FS=y
# CONFIG_EROFS_FS_DEBUG is not set
CONFIG_EROFS_FS_XATTR=y
CONFIG_EROFS_FS_POSIX_ACL=y
CONFIG_EROFS_FS_SECURITY=y
CONFIG_EROFS_FS_BACKED_BY_FILE=y
CONFIG_EROFS_FS_ZIP=y
CONFIG_EROFS_FS_ZIP_LZMA=y
CONFIG_EROFS_FS_ZIP_LZMA_DEFAULT_MAX_STREAMS=0
# CONFIG_EROFS_FS_ZIP_DEFLATE is not set
# CONFIG_EROFS_FS_ZIP_ZSTD is not set
# CONFIG_EROFS_FS_ZIP_ACCEL is not set
# CONFIG_EROFS_FS_PCPU_KTHREAD is not set
# CONFIG_EROFS_FS_PAGE_CACHE_SHARE is not set

The symbol may be there internally, but it does not show up in .config.

Guenter


