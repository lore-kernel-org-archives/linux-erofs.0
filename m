Return-Path: <linux-erofs+bounces-4199-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 19BF5C5AC67
	for <linux-erofs@archiver.kernel.org>; Tue, 11 Aug 2026 19:35:58 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hKML50Sc6z2yrW;
	Wed, 12 Aug 2026 05:35:57 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2607:f8b0:4864:20::52c"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1786476956;
	cv=none; b=iRlypCy1+k7tqsfTTN/Skeg6zp6rIqvu+tGhGpfpiX/84lXNkLx+Qh1Cl9jGXrH8faVD//GP57Ijsy1AzAWkd+aeUePgei0JE+TbU8QB8YGM60L3CZ7B9NtCSg2tx/TJuWm6A2ipWar0DdB6+3rUyEK7+XCCTxqrilWTaky4KwJDVFrhAfHL0LAVk8zPxm1434yW4zjjMtotbpVjKK8NAwFPluB1v6ahmN/mqvUaZCikuRE9CWTb/5p2GD6W4GoI4HPcCOZADv6c83n2iijXhbcSmSjrFfbikormHuZwqcoYdMCgEBz1dvxmYyfUp5eVi2VbYb2SJ/vVAROvfwKCqQ==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1786476956; c=relaxed/relaxed;
	bh=XpNHdkj4wT5JWnM6cFP5Eq31bX74EfX5J5dPTpRLuE4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=TXzFRGTE8jgIm6HLK9zzosw9Kc1lIU0v7nGfXi6HQ7Vc7EKHHZv+38gGf6FSg1IbtGbEnv95W74syHPzyQc8whUE/F/BODkXkiFxYHu0Q4eI5AYB9iaxIBwsHv6YEnIkEmhGQpbPf7ntT3EROxq/uw4vG7P0Fq/e9Jtb4fgk96K0IQLrrxVVeHinpSrjjo4ntG7KNvoCPvhhUXUdcFV6IivxE6z635/IUweQHxl0DmZYtIINv4+E0i06XjCznM6IXMeCInuNmYRmrsAYRqRzEBvvyAPCNgIObrQttSiUokvxPxsk5t0qB1zrfdPZOYwq+2MlAoMR0pkMGRlISdd3Hw==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=none (p=none dis=none) header.from=roeck-us.net; dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=QLabbX2S; dkim-atps=neutral; spf=pass (client-ip=2607:f8b0:4864:20::52c; helo=mail-pg1-x52c.google.com; envelope-from=groeck7@gmail.com; receiver=lists.ozlabs.org) smtp.mailfrom=gmail.com
Authentication-Results: lists.ozlabs.org; dmarc=none (p=none dis=none) header.from=roeck-us.net
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=QLabbX2S;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=gmail.com (client-ip=2607:f8b0:4864:20::52c; helo=mail-pg1-x52c.google.com; envelope-from=groeck7@gmail.com; receiver=lists.ozlabs.org)
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hKML237VRz2ynC
	for <linux-erofs@lists.ozlabs.org>; Wed, 12 Aug 2026 05:35:53 +1000 (AEST)
Received: by mail-pg1-x52c.google.com with SMTP id 41be03b00d2f7-cbee3777e1cso109128a12.3
        for <linux-erofs@lists.ozlabs.org>; Tue, 11 Aug 2026 12:35:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786476950; x=1787081750; darn=lists.ozlabs.org;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:sender:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=XpNHdkj4wT5JWnM6cFP5Eq31bX74EfX5J5dPTpRLuE4=;
        b=QLabbX2S8VyzBoIbgnjg7NfVCPPbOyQTd0JrVpOYNOLnOJcfcBMYGhaS5r4ZhbxCA+
         C8+kBVx9xyxvjJkEvwo3/DbT2rERmdtclEg9pRaSi5SX+t0FHe9g5yqqr7MJMIYdO3WE
         6eK32CdyMeRzDR0h+pkLoMjo8wG0yYY5kedOVA4D/itFSVUk6RIs+M6D4VsnWZXxOyZX
         K3TZMnZ4ZNw3kxJwq9J2oA39qkRiIU284Xmu9pnEPk3SHd/+bcCLklaiDueCCMAD4bUa
         URsKNfg7laKZTb2h+Tr9/VD+bxXfnDmLR/QB+12ADI1k8moDVgmkFZrwBKjH5I0723zw
         xyvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786476950; x=1787081750;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:sender:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=XpNHdkj4wT5JWnM6cFP5Eq31bX74EfX5J5dPTpRLuE4=;
        b=EBp6s7mst9fk4hhUmSN0IfIk104UobwVOLi8EsL/0bYg43k9hLbprt6xjG1fOKJU5d
         Ze7O8oGWtqxTyhrsdbNwXareaoKY4p28krm5lGKPVqqlUy56KlcOQtw9GVIOmmgqQ4wt
         IUdHr18BST52H9+7P29YR/OqfO3+J9gBiwl+Wg6vKbvOJ6dTMnoMx1GRQRXTjVMeSVnK
         zSelxlK7gk44hcarEfE2qf1laB/VFFW3lmtOvuHmI97AJwWk+mQKeRKBs2qkB6hJNaaM
         rg1+MX+coG5Y4IOA/MEvkZ31V3EZA65EdFi2vyp815HV5tJth7pLCGyJ0whc32lyfl3m
         1iJQ==
X-Forwarded-Encrypted: i=1; AHgh+RpZgZLE+mO0WuWY1SX2bkblvkQqE79+iAxsS9Nz7uRjcKGGt5pmQxqCFXPfnZ5oR08LxV1B0lAfacMhEA==@lists.ozlabs.org
X-Gm-Message-State: AOJu0YyDiESGWmvfMzbVLmzY7GMP9RqU6bNJKpYsZ8E7nmVA4w/B/3OK
	v9Tm++7CcsN22Sw7EWfIrTSN3IX4J7evXPcjRi/nUC5ggY77EeljgSEP
X-Gm-Gg: AR+sD10bvPj+saCHxNFqcUg/KQbPcWWeoNakaWjutoQqntG4pvQnqB9ON5mrP41jnBq
	FEMCh7dVxfU4zLuZ/qDTsp2q9H4ej4wAs1e1QDPJeFKJR0a7Kl4NHIuIbLgKXWhBMJigH/It/8O
	HxT+Cw3EKQ8/6+bsVyxuYiqE89c4bpsEjyjg6oxKuVrl6w5Nc1TTg+eE1MetgQVKaMoAGLDDZ2E
	d9DYjJqq2YKDfYSHov5MlxDCwxusmkTQHoNOtqc6edwxnNZqPoKBlj6HLIY9x5bepGz5+ObgQuW
	25MDqIjERfSPj/yFLtplT9wML+MC8M9wHFfNFPqPDawTdp2G7nDO9Kge468LWS2CbkQU3JB7yAC
	f3BIhRfkhUgCrN5wzP64R1Yp67viCEpz83QGeQdV/h22q2Ge3+zkirEt9lqpgCidd8kNrt88C8t
	qB1nmxqsJejdCpLpPKrBQyB4zvCCbt2zWmERfFPshYRLOD/QJIiVWX03UgzomtK5CDmfpy+lKW1
	kmWFWamIgzOU+UWverAOT7/t5070S486zUhsAMBc/Y5HTOE
X-Received: by 2002:a05:6a21:9cc8:b0:3a2:7ef4:81df with SMTP id adf61e73a8af0-3cc2bb68c4cmr7975652637.26.1786476950241;
        Tue, 11 Aug 2026 12:35:50 -0700 (PDT)
Received: from ?IPV6:2600:1700:e321:62f0:da43:aeff:fecc:bfd5? ([2600:1700:e321:62f0:da43:aeff:fecc:bfd5])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-31cf67912d0sm3065400eec.24.2026.08.11.12.35.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 11 Aug 2026 12:35:49 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Message-ID: <87853c96-cc8f-49e6-81b1-02bfe409e372@roeck-us.net>
Date: Tue, 11 Aug 2026 12:35:47 -0700
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
To: Geert Uytterhoeven <geert@linux-m68k.org>,
 =?UTF-8?Q?Uwe_Kleine-K=C3=B6nig?= <u.kleine-koenig@baylibre.com>
Cc: SJ Park <sj@kernel.org>, Gao Xiang <xiang@kernel.org>,
 Gao Xiang <hsiangkao@linux.alibaba.com>,
 Michael Bommarito <michael.bommarito@gmail.com>, Yue Hu
 <zbestahu@gmail.com>, Jeffle Xu <jefflexu@linux.alibaba.com>,
 Sandeep Dhavale <dhavale@google.com>, Chunhai Guo <guochunhai@vivo.com>,
 linux-erofs@lists.ozlabs.org, linux-kernel@vger.kernel.org,
 Chao Yu <chao@kernel.org>, David Hildenbrand <david@redhat.com>
References: <amhMsk5Z6P0IA8sr@XiangdeMacBook-Pro.local>
 <20260728065447.91511-1-sj@kernel.org>
 <CAMuHMdWq1eutRM4u1Q3r50f8W4oSejo_XAgyjEKuwi4Lw6K7jQ@mail.gmail.com>
 <anBYnPELPotUiNjv@monoceros>
 <CAMuHMdXUyAX0TV0Sq9_YxvipzkVOBX=4s_r5mVQcZ_7nL=-AQw@mail.gmail.com>
Content-Language: en-US
From: Guenter Roeck <linux@roeck-us.net>
Autocrypt: addr=linux@roeck-us.net; keydata=
 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
 np3900V20aS7eD9K8GTU0TGC1pyz6IVJwIE=
In-Reply-To: <CAMuHMdXUyAX0TV0Sq9_YxvipzkVOBX=4s_r5mVQcZ_7nL=-AQw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 8/11/26 12:27, Geert Uytterhoeven wrote:
> On Mon, 3 Aug 2026 at 11:12, Uwe Kleine-König
> <u.kleine-koenig@baylibre.com> wrote:
>> On Mon, Aug 03, 2026 at 10:09:06AM +0200, Geert Uytterhoeven wrote:
>>> On Tue, 28 Jul 2026 at 08:55, SJ Park <sj@kernel.org> wrote:
>>>> I don't have a m68k testfarm, either.  I'm doing crossbuild [1].  Hopefully you
>>>> could also reproduce it.
>>
>> FTR, I don't have m68k hardware either, but as this is a build time
>> failure installing the Debian package gcc-m68k-linux-gnu and then doing
>> builds using
>>
>>          make ARCH=m68k CROSS_COMPILE=m68k-linux-gnu-
>>
>> is good enough to reproduce the failure.
>>
>>> I think you can reproduce some of the issues on most architectures
>>> with a non-SMP kernel, cfr. my reply[1] to Uwe's proposed fix.
>>> Unfortunately the Kconfig warning only shows up on architectures that
>>> don't define NR_CPUS (because they do not support SMP) at all,
>>> while ending up with zero streams is probably a runtime failure.
>>>
>>> [1] https://lore.kernel.org/CAMuHMdVGKX=3cfOrLWp1uSHX76xf1-=C0+GVCXkA8JTqNPg-ew@mail.gmail.com
>>
>> I guess EROFS_FS_ZIP_LZMA_DEFAULT_MAX_STREAMS should depend on SMP and
>> it's use should be conditionalized using something like
>>
>> diff --git a/fs/erofs/decompressor_lzma.c b/fs/erofs/decompressor_lzma.c
>> index 6b0cdb446c6a..c00e94f8206f 100644
>> --- a/fs/erofs/decompressor_lzma.c
>> +++ b/fs/erofs/decompressor_lzma.c
>> @@ -50,9 +50,13 @@ static int __init z_erofs_lzma_init(void)
>>          unsigned int i;
>>
>>          /* by default, use # of possible CPUs instead */
>> -       if (!z_erofs_lzma_nstrms)
>> -               z_erofs_lzma_nstrms = min_t(unsigned int, num_possible_cpus(),
>> -                               CONFIG_EROFS_FS_ZIP_LZMA_DEFAULT_MAX_STREAMS);
>> +       if (!z_erofs_lzma_nstrms) {
>> +               if (IS_ENABLED(CONFIG_SMP))
>> +                       z_erofs_lzma_nstrms = min_t(unsigned int, num_possible_cpus(),
>> +                                       CONFIG_EROFS_FS_ZIP_LZMA_DEFAULT_MAX_STREAMS);
>> +               else
>> +                       z_erofs_lzma_nstrms = 1;
>> +       }
>>
>>          for (i = 0; i < z_erofs_lzma_nstrms; ++i) {
>>                  struct z_erofs_lzma *strm = kzalloc_obj(*strm);
> 
> LGTM.
> 
>>
>> I played a bit with the definition of
>> EROFS_FS_ZIP_LZMA_DEFAULT_MAX_STREAMS in fs/erofs/Kconfig, but didn't
>> find a way to define it that both uses NR_CPUS and doesn't generate a
>> warning with ARCH=m68k.
> 
> Any progress with fixing this for v7.2?
> 
> NR_CPUS depends on SMP on most architectures, so you get e.g.
> with ARCH=arm allmodconfig + CONFIG_SMP=n:
> 
>      CONFIG_EROFS_FS_ZIP_LZMA_DEFAULT_MAX_STREAMS=0
> 
> X86 defines NR_CPUS unconditionally, so there it works as expected.
> Thanks!
> 
FWIW, m68k:allmodconfig now fails to build due to this problem all the
way back to v6.6.y.

Guenter


