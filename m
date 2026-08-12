Return-Path: <linux-erofs+bounces-4211-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4CD1FC5B56A
	for <linux-erofs@archiver.kernel.org>; Wed, 12 Aug 2026 14:26:00 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hKrPy4RQCz30Wn;
	Thu, 13 Aug 2026 00:25:58 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2607:f8b0:4864:20::630"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1786544758;
	cv=none; b=TPhzkh4uG3nHRMHBtQHcuB5ma9FNBt49eBPhXguVbjbMPzQFtUmkPec44okdntQNyATR1ai9Eip/lZFFTgmdAjRleE1iYAf7O8cJHd+VJgAyeNiBXZfVU3vfdGQcoxYvCL0PxnOd4C6p6WrBythQI0Mb2EqIT2b7HuyXRmQbIOFAwB06BfateCMtAlj0hicj+bx23KT0gji43jz8ou8a1O2gfK7pfF1lKlLM4VSg4GrBy8hC9P48ZZ6x10hr8BkyvyoSrioc19Rw1gc4WskBpq+noTRvM7VEE7wA/4KO/9xRry8qjx6QoIhjR8d31TBxUeyMsVXY5eRCRzRgSNUmWg==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1786544758; c=relaxed/relaxed;
	bh=9s7tY9FyrfboX/STUHSdcJVn78sWP0diU8alEnKmPv8=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=hUCNvn7yoR6DJYvL/FIqXMZm+QB9utWIPXZSudYd+rW1tPrvt5M4PYjAUgSTlR5dVJmgZpld7nZAHOtEkVgiwBDXW3T/v/OpnqQ9lK3IT8OfQhFACObmlf63aLfFF3Q6RRFVTvx05q4cWzbvZ/CtJoPQbjJ1wN9qz41PAya3PQ9dbye2TyHMZfLhhSGsipH+kPH8N/sCS+WSvkRxJngqCifsRC0SV86SLfGBjGRKDb+nnjJoLABoHeKs3nNGlEeCtmerOP5K5Wm4yPAOjK6WF5GTvSKjiWR/ITL6myBMrOqDl/SQyz0F8dvrjoaEybJggyEpcUuVuxlPeiwAiDXzOw==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=none (p=none dis=none) header.from=roeck-us.net; dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=MEoC3M4Z; dkim-atps=neutral; spf=pass (client-ip=2607:f8b0:4864:20::630; helo=mail-pl1-x630.google.com; envelope-from=groeck7@gmail.com; receiver=lists.ozlabs.org) smtp.mailfrom=gmail.com
Authentication-Results: lists.ozlabs.org; dmarc=none (p=none dis=none) header.from=roeck-us.net
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=MEoC3M4Z;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=gmail.com (client-ip=2607:f8b0:4864:20::630; helo=mail-pl1-x630.google.com; envelope-from=groeck7@gmail.com; receiver=lists.ozlabs.org)
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hKrPw276qz303K
	for <linux-erofs@lists.ozlabs.org>; Thu, 13 Aug 2026 00:25:55 +1000 (AEST)
Received: by mail-pl1-x630.google.com with SMTP id d9443c01a7336-2ceb096e675so13786215ad.0
        for <linux-erofs@lists.ozlabs.org>; Wed, 12 Aug 2026 07:25:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786544753; x=1787149553; darn=lists.ozlabs.org;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:to:subject:user-agent:mime-version:date
         :message-id:sender:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=9s7tY9FyrfboX/STUHSdcJVn78sWP0diU8alEnKmPv8=;
        b=MEoC3M4ZPgHgWmiB/KBhpKGIb1ZL1VccAiOD2l/hbhtYQKNRTWBCLS02IT3jg1YP0S
         yF3C1jwDgGH7x0JiA3yKezm3g6gGV8qRm1+ozcpiYYdmpG/v4tpJWn68rDCrxpixUBkq
         z+VCmcQ8G9YFwhwY9xmG1NY2u6ozEMpsA22N4iG+QESgbMwE5XtCLytIPD79w41/8mHa
         tLzDwj9ona+m/VX6Alv5WP8m0/TDgcB6uRWg82wWFhRjE7HzGUKyzwPDt0hSSrd87YyJ
         G55F6nHR+vGQmE7q+t22ucdG5DoppeqgvJJ742P+8gOsyK6Yvrn3kuad+MvocmkGB0TZ
         dd2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786544753; x=1787149553;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:to:subject:user-agent:mime-version:date
         :message-id:sender:x-gm-gg:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=9s7tY9FyrfboX/STUHSdcJVn78sWP0diU8alEnKmPv8=;
        b=klo85gvlbzE3Le6ZQZVMHJ09OiSEwrYDCk2Caxdk9EtVF82vl2w8c+PdBd9ymysGYs
         nMh7Y9j61zL+1XKmPgXHQlOCHrXD09cKOH2rkGU3o9O5Azbu2r1Ux0eeMmNBHPeqmtxW
         vWkwOf3kZ2It6nqn0/ow0QJ+kiAckftkybFnszRmCuueQt/rUEy0UsZuhz/GmAjmRMRC
         TZJeDwtkfMGIaLZmrrYWzHIru78QUDw6I0R9rcJSlt9IHWIiQj6CMj2s5EhgKqkUcEXa
         MSeQwDT3CuucjLZYDeokfsvKFvgBB/KOO3Ww+qRoMnJtn6jQhGKy8f+edO2k5Dmhx81i
         lVaw==
X-Forwarded-Encrypted: i=1; AHgh+RoAPFxCG6uH2nkssGjFZ+fjPT6gEiP32WjWBqZ51kaXIRfiJF0rA5GQosLIUriT3WnY9hG13paPrBbUYA==@lists.ozlabs.org
X-Gm-Message-State: AOJu0YyUuZuJenZeBfiuJXg73Y+1dY7p9yCk90w/VEHp5Fl6vamnl0gg
	dobfmumta9iOrRJv2UZXhzk+zFuhzhyubvUIkMPQ9sFf7lTAdEztKp0P
X-Gm-Gg: AR+sD11WjlRxV9ZQuMOvW3B7Mt4qwVDBi/HxwJfHe43os+xPHD7MLRUiAX9jRTkBYOu
	h1WNWYziQfMmlzNzRlt8aijBw9NbDwLDOmplBOFwdPVbPjMLOdXkbdPqCSL5AnOW65hHz8R5K2H
	XPhmFjkOK4Mc3zF74wOIupav7RIg2LH8/y7mQxUT1PBBEbDzk+/TZ8/KT6280+qFV7qVCGlaxH+
	49A83IsduMGckoGSBR2vdh9gNzY9DpkdDD6/NKNYZpMCSVM3VJykqWX+tTmN6JurODTyfsMvZvZ
	7QOHwpK68Mj3bPH9WO65bFOqsyaNZO8+l+MdATup06I4pedYWQuLnlYA6zVEFiX38+k/ov2YylB
	6GcZR98NTPaSySTZH6uHVAn0w5K6irSzcfJTAGgSv22DrIwSPfeY9/6ezNJbjj0plAUtOu2SYl3
	ZXxoH686/4Un1pSM9SBtf5sLP6x31O6bYL1nhkYCPjSQxbAvGmSjm4tcmF4JJKjEeQUh4AuMeof
	7PZR9M3QMOwPl1FKTEalI7VAbvqUpSeC9sxBTBdGQ4wzCN4wA==
X-Received: by 2002:a17:902:e5d1:b0:2d1:134:b86e with SMTP id d9443c01a7336-2d345358111mr58670815ad.2.1786544752613;
        Wed, 12 Aug 2026 07:25:52 -0700 (PDT)
Received: from ?IPV6:2600:1700:e321:62f0:da43:aeff:fecc:bfd5? ([2600:1700:e321:62f0:da43:aeff:fecc:bfd5])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2d350fe9a4csm7633665ad.18.2026.08.12.07.25.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 12 Aug 2026 07:25:51 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Message-ID: <5825b5c2-06b3-4358-91b0-d7bf437528a3@roeck-us.net>
Date: Wed, 12 Aug 2026 07:25:50 -0700
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
References: <amhMsk5Z6P0IA8sr@XiangdeMacBook-Pro.local>
 <20260728065447.91511-1-sj@kernel.org>
 <CAMuHMdWq1eutRM4u1Q3r50f8W4oSejo_XAgyjEKuwi4Lw6K7jQ@mail.gmail.com>
 <anBYnPELPotUiNjv@monoceros>
 <CAMuHMdXUyAX0TV0Sq9_YxvipzkVOBX=4s_r5mVQcZ_7nL=-AQw@mail.gmail.com>
 <87853c96-cc8f-49e6-81b1-02bfe409e372@roeck-us.net>
 <CAJJ9bXyC=piPamaGJN=VMA72Ws+WqgJbYZgTj_w6NFzyLa_mMg@mail.gmail.com>
 <anuyFHLUGDjZWY4K@XiangdeMacBook-Pro.local>
 <CAMuHMdWQLwgShMK7G-6soiZxtRPYWLizBLRdouwxFUcFXUJM-Q@mail.gmail.com>
 <anxQ-DohuQvuKwAH@XiangdeMacBook-Pro.local>
Content-Language: en-US
From: Guenter Roeck <linux@roeck-us.net>
Autocrypt: addr=linux@roeck-us.net; keydata=
 xsFNBE6H1WcBEACu6jIcw5kZ5dGeJ7E7B2uweQR/4FGxH10/H1O1+ApmcQ9i87XdZQiB9cpN
 RYHA7RCEK2dh6dDccykQk3bC90xXMPg+O3R+C/SkwcnUak1UZaeK/SwQbq/t0tkMzYDRxfJ7
 nyFiKxUehbNF3r9qlJgPqONwX5vJy4/GvDHdddSCxV41P/ejsZ8PykxyJs98UWhF54tGRWFl
 7i1xvaDB9lN5WTLRKSO7wICuLiSz5WZHXMkyF4d+/O5ll7yz/o/JxK5vO/sduYDIlFTvBZDh
 gzaEtNf5tQjsjG4io8E0Yq0ViobLkS2RTNZT8ICq/Jmvl0SpbHRvYwa2DhNsK0YjHFQBB0FX
 IdhdUEzNefcNcYvqigJpdICoP2e4yJSyflHFO4dr0OrdnGLe1Zi/8Xo/2+M1dSSEt196rXaC
 kwu2KgIgmkRBb3cp2vIBBIIowU8W3qC1+w+RdMUrZxKGWJ3juwcgveJlzMpMZNyM1jobSXZ0
 VHGMNJ3MwXlrEFPXaYJgibcg6brM6wGfX/LBvc/haWw4yO24lT5eitm4UBdIy9pKkKmHHh7s
 jfZJkB5fWKVdoCv/omy6UyH6ykLOPFugl+hVL2Prf8xrXuZe1CMS7ID9Lc8FaL1ROIN/W8Vk
 BIsJMaWOhks//7d92Uf3EArDlDShwR2+D+AMon8NULuLBHiEUQARAQABzTJHdWVudGVyIFJv
 ZWNrIChMaW51eCBhY2NvdW50KSA8bGludXhAcm9lY2stdXMubmV0PsLBgQQTAQIAKwIbAwYL
 CQgHAwIGFQgCCQoLBBYCAwECHgECF4ACGQEFAmgrMyQFCSbODQkACgkQyx8mb86fmYGcWRAA
 oRwrk7V8fULqnGGpBIjp7pvR187Yzx+lhMGUHuM5H56TFEqeVwCMLWB2x1YRolYbY4MEFlQg
 VUFcfeW0OknSr1s6wtrtQm0gdkolM8OcCL9ptTHOg1mmXa4YpW8QJiL0AVtbpE9BroeWGl9v
 2TGILPm9mVp+GmMQgkNeCS7Jonq5f5pDUGumAMguWzMFEg+Imt9wr2YA7aGen7KPSqJeQPpj
 onPKhu7O/KJKkuC50ylxizHzmGx+IUSmOZxN950pZUFvVZH9CwhAAl+NYUtcF5ry/uSYG2U7
 DCvpzqOryJRemKN63qt1bjF6cltsXwxjKOw6CvdjJYA3n6xCWLuJ6yk6CAy1Ukh545NhgBAs
 rGGVkl6TUBi0ixL3EF3RWLa9IMDcHN32r7OBhw6vbul8HqyTFZWY2ksTvlTl+qG3zV6AJuzT
 WdXmbcKN+TdhO5XlxVlbZoCm7ViBj1+PvIFQZCnLAhqSd/DJlhaq8fFXx1dCUPgQDcD+wo65
 qulV/NijfU8bzFfEPgYP/3LP+BSAyFs33y/mdP8kbMxSCjnLEhimQMrSSo/To1Gxp5C97fw5
 3m1CaMILGKCmfI1B8iA8zd8ib7t1Rg0qCwcAnvsM36SkrID32GfFbv873bNskJCHAISK3Xkz
 qo7IYZmjk/IJGbsiGzxUhvicwkgKE9r7a1rOwU0ETofVZwEQALlLbQeBDTDbwQYrj0gbx3bq
 7kpKABxN2MqeuqGr02DpS9883d/t7ontxasXoEz2GTioevvRmllJlPQERVxM8gQoNg22twF7
 pB/zsrIjxkE9heE4wYfN1AyzT+AxgYN6f8hVQ7Nrc9XgZZe+8IkuW/Nf64KzNJXnSH4u6nJM
 J2+Dt274YoFcXR1nG76Q259mKwzbCukKbd6piL+VsT/qBrLhZe9Ivbjq5WMdkQKnP7gYKCAi
 pNVJC4enWfivZsYupMd9qn7Uv/oCZDYoBTdMSBUblaLMwlcjnPpOYK5rfHvC4opxl+P/Vzyz
 6WC2TLkPtKvYvXmdsI6rnEI4Uucg0Au/Ulg7aqqKhzGPIbVaL+U0Wk82nz6hz+WP2ggTrY1w
 ZlPlRt8WM9w6WfLf2j+PuGklj37m+KvaOEfLsF1v464dSpy1tQVHhhp8LFTxh/6RWkRIR2uF
 I4v3Xu/k5D0LhaZHpQ4C+xKsQxpTGuYh2tnRaRL14YMW1dlI3HfeB2gj7Yc8XdHh9vkpPyuT
 nY/ZsFbnvBtiw7GchKKri2gDhRb2QNNDyBnQn5mRFw7CyuFclAksOdV/sdpQnYlYcRQWOUGY
 HhQ5eqTRZjm9z+qQe/T0HQpmiPTqQcIaG/edgKVTUjITfA7AJMKLQHgp04Vylb+G6jocnQQX
 JqvvP09whbqrABEBAAHCwWUEGAECAA8CGwwFAmgrMyQFCSbODQkACgkQyx8mb86fmYHlgg/9
 H5JeDmB4jsreE9Bn621wZk7NMzxy9STxiVKSh8Mq4pb+IDu1RU2iLyetCY1TiJlcxnE362kj
 njrfAdqyPteHM+LU59NtEbGwrfcXdQoh4XdMuPA5ADetPLma3YiRa3VsVkLwpnR7ilgwQw6u
 dycEaOxQ7LUXCs0JaGVVP25Z2hMkHBwx6BlW6EZLNgzGI2rswSZ7SKcsBd1IRHVf0miwIFYy
 j/UEfAFNW+tbtKPNn3xZTLs3quQN7GdYLh+J0XxITpBZaFOpwEKV+VS36pSLnNl0T5wm0E/y
 scPJ0OVY7ly5Vm1nnoH4licaU5Y1nSkFR/j2douI5P7Cj687WuNMC6CcFd6j72kRfxklOqXw
 zvy+2NEcXyziiLXp84130yxAKXfluax9sZhhrhKT6VrD45S6N3HxJpXQ/RY/EX35neH2/F7B
 RgSloce2+zWfpELyS1qRkCUTt1tlGV2p+y2BPfXzrHn2vxvbhEn1QpQ6t+85FKN8YEhJEygJ
 F0WaMvQMNrk9UAUziVcUkLU52NS9SXqpVg8vgrO0JKx97IXFPcNh0DWsSj/0Y8HO/RDkGXYn
 FDMj7fZSPKyPQPmEHg+W/KzxSSfdgWIHF2QaQ0b2q1wOSec4Rti52ohmNSY+KNIW/zODhugJ
 np3900V20aS7eD9K8GTU0TGC1pyz6IVJwIE=
In-Reply-To: <anxQ-DohuQvuKwAH@XiangdeMacBook-Pro.local>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 8/12/26 03:54, Gao Xiang wrote:
> Hi Geert,
> 
> On Wed, Aug 12, 2026 at 11:30:14AM +0200, Geert Uytterhoeven wrote:
>> Hi Gao,
>>
>> On Wed, 12 Aug 2026 at 01:37, Gao Xiang <xiang@kernel.org> wrote:
>>> On Tue, Aug 11, 2026 at 03:37:38PM -0400, Michael Bommarito wrote:
>>>> On Tue, Aug 11, 2026 at 3:35 PM Guenter Roeck <linux@roeck-us.net> wrote:
>>>>>> Any progress with fixing this for v7.2?
>>>>
>>>> I would like to fix this since I started the problem with the original
>>>> patch, but I feel a bit stuck.  My v1 and v2 patches would not have
>>>> triggered the build failure, but Gao made valid points about the
>>>> trade-offs that led us to this v3.  Maybe it would be worth your
>>>> opinion on the config approach in those earlier patches?
>>>
>>> Sorry about the late reply.
>>>
>>> As I said, I really dislike hardcoded range, but it is an issue that no
>>> NR_CPUS definition on CONFIG_SMP:
>>>
>>> I wonder if the following diff resolves the m68k issue (I'm not an
>>> Kconfig expert but it seems to work on x86_64 !CONFIG_SMP):
>>>
>>> diff --git a/fs/erofs/Kconfig b/fs/erofs/Kconfig
>>> index 8ca1767dafb6..2dfc313588d2 100644
>>> --- a/fs/erofs/Kconfig
>>> +++ b/fs/erofs/Kconfig
>>> @@ -134,7 +134,8 @@ config EROFS_FS_ZIP_LZMA
>>>   config EROFS_FS_ZIP_LZMA_DEFAULT_MAX_STREAMS
>>>          int "EROFS LZMA default maximum decompression streams"
>>>          depends on EROFS_FS_ZIP_LZMA
>>> -       range 1 NR_CPUS
>>> +       range 1 NR_CPUS if SMP
>>> +       range 1 1 if !SMP
>>>          default 16
>>>          help
>>>            By default EROFS allocates one LZMA decompression stream per CPU.
>>
>> Thank you, that seems to work (despite still seeing the warning on m68k,
>> as NR_CPUS does not exist).
>>
> 
> ...
> 
>>
>>        $ make ARCH=m68k allmodconfig
>>       fs/erofs/Kconfig:137:warning: range is invalid
>>
>>   Warning...
>>
> 
> Yes, other arches shouldn't have the warning because I think other
> arches (including microblaze) defines NR_CPUS in Kconfig, except m68k.
> 

That is not entirely true. openrisc only has it if SMP=y. But it still
does not generate the warning for some reason.

> The following diff can eliminate the m68k warning above, I think m68k
> folks could consider this way if you really don't want to define an
> explicit NR_CPUS.  Anyway, I think it should go with another patch:
> 
> ```
> diff --git a/arch/m68k/Kconfig b/arch/m68k/Kconfig
> index 11835eb59d94..90499f126c73 100644
> --- a/arch/m68k/Kconfig
> +++ b/arch/m68k/Kconfig
> @@ -44,6 +44,9 @@ config M68K
>   	select UACCESS_MEMCPY if !MMU
>   	select ZONE_DMA
>   
> +config NR_CPUS
> +	int

I would suggest to add

	default 1

Guenter

> +
>   config CPU_BIG_ENDIAN
>   	def_bool y
> ```
> 
> I will try to form a formal patch (with the diff in the previous reply)
> directly to Linus (since I don't have other urgent patches for
> Linux 7.2.)
> 
> Thanks,
> Gao Xiang


