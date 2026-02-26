Return-Path: <linux-erofs+bounces-2423-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EB395FD4609
	for <linux-erofs@archiver.kernel.org>; Thu, 26 Feb 2026 02:40:27 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4fLwfy3dvPz2yvy;
	Thu, 26 Feb 2026 13:40:26 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=115.124.30.111
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1772073626;
	cv=none; b=RPU678Nr45pI7fK6ESGfnkWD7+93HxaP9v23ENAk2v1qCFhR56uShED1YADBqR+KLh/URJZYQDKK1R9Bh31GwJzGEtRTiY6NBmxHdz8eF029pLCfrba+j7HzMJo47ov2PB3b32PEY6PEvLQ0LXE0S2Yfl7JlTfXYRYUb3MOdDTrMXNqIlG8uZP0VX0Q3akQ09MTc60Kii6eXvQXbxNEoAlLgXOHdcXWQ/AKn/dtG0CB0JeC349cCoBHsvCW49CcdoDvaTw8PQHj0J5fKS/9ADQYVbQXXlGY76hYLpVN2H+M5t0NdxKrFDDVD0AjmdrxpVGrv3HvKLiGCVVVSuROHVg==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1772073626; c=relaxed/relaxed;
	bh=je75n9Ln93cElPl1C1XEe8BoPZ4Ghtc5+x6/JDcNNUY=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=h59xmCVLOHSs55kdfuBwRXhL41gCT6TrOJ0GaBSSnS8BP01/vfqXm5mAGPlkFJn5SplTZ6BpbwIJMO2ipd5UrZ34dBX6+JwTn/NJHU8YKUqdmCZc6WfgUftebng0Qzyawqx6d5IEoplUhE6em2y38kLTxzifZifbPDLNpumIVGcpgfNu8UlhPySW2e/FxojEWK+VvMPDZgyn+1dzlipZT7wrdPgLMMhG2UMLip/tlPQK0/KRD/QGmJVG7spq8taMrknOvPFgtYyy35gMw2eO+Qd34iRcNigvoTT7tdIJOMIpDsUnsMSAjoz6dly6/AoVryEGADK8A+SGd5nh68sOpQ==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=E/kkxJmc; dkim-atps=neutral; spf=pass (client-ip=115.124.30.111; helo=out30-111.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org) smtp.mailfrom=linux.alibaba.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=E/kkxJmc;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=linux.alibaba.com (client-ip=115.124.30.111; helo=out30-111.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org)
Received: from out30-111.freemail.mail.aliyun.com (out30-111.freemail.mail.aliyun.com [115.124.30.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4fLwfx2NC2z2ySS
	for <linux-erofs@lists.ozlabs.org>; Thu, 26 Feb 2026 13:40:24 +1100 (AEDT)
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1772073617; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=je75n9Ln93cElPl1C1XEe8BoPZ4Ghtc5+x6/JDcNNUY=;
	b=E/kkxJmc4UUdkiOPvz5esrIZKD1UMvhXEzWbBR+l0MafdzGHKfHwACfY922z9Ei97fgwjrJebJAV4RDyPQDu8ozAjoV+0z7+R2pmYPPyxh5K2Hn5Ky65KvS0vR0U/P+xzn8qpnLBOYJiW58MHM5v0Q6d1NuQFb8Q20rdQdkKA4A=
Received: from 30.221.131.221(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0WzpZubm_1772073616 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 26 Feb 2026 10:40:16 +0800
Message-ID: <555e6fbb-79f9-422f-9b43-bc655a106229@linux.alibaba.com>
Date: Thu, 26 Feb 2026 10:40:16 +0800
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
To: Yifan Zhao <yifan.yfzhao@foxmail.com>, Ashley Lee <yester1324@gmail.com>,
 linux-erofs@lists.ozlabs.org
References: <20260225173036.194311-1-yester1324@gmail.com>
 <tencent_E8B3BD7F4663756DD9915EF539DC95AB1805@qq.com>
From: Gao Xiang <hsiangkao@linux.alibaba.com>
In-Reply-To: <tencent_E8B3BD7F4663756DD9915EF539DC95AB1805@qq.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 2026/2/26 10:32, Yifan Zhao wrote:
> Hi Lee,
> 
> 
> A quick search shows that x86 kernel implementation also use `div` instruction
> 
> under Linux v6.19 and GCC 15.2.1, add GCC correctly generate shift instruction

Could we try more GCC versions and find the impacts?

Does it a recent GCC regression?


> 
> in my arm64 machine with GCC 14.2.0.
> 
> Could you also consider evaluate this optimization in kernel?

Yes, but I wonder if `div` is already used for these years on x86,
could you check this?

Thanks,
Gao Xiang

> 
> 
> Thanks,
> 
> Yifan
> 
> On 2/26/2026 1:30 AM, Ashley Lee wrote:
>> perf on fsck.erofs in gcc reports that z_erofs_load_compact_lcluster
>> was spending 20% of its time doing the div instruction. While the
>> function itself is ~40% of user runtime. In the source code, it seems
>> that dividing by vcnt doesn't optimize to a shift despite the two
>> possible states being powers of 2.
>>
>> Changing the division into a ilog2() function call encourages the
>> compiler to recognize it as a power of 2. Thus performing a shift.
>>
>> Running a benchmark on lzma compressed freebsd code on x86, shows
>> there is a ~4% increase in performance in gcc. While clang shows
>> virtually no regression in performance. The tradeoff is slightly
>> obfuscated source code.
>>
>> The following command was run locally on x86.
>>
>> $ hyperfine -w 5 -m 30 "./fsck.erofs ./bsd.erofs.lzma"
>>
>> patch on gcc 15.2.1
>> Time (mean ± σ):     354.8 ms ±   6.0 ms    \
>>    [User: 227.8 ms, System: 126.1 ms]
>> Range (min … max):   345.8 ms … 366.2 ms    30 runs
>>
>> dev on gcc 15.2.1
>> Time (mean ± σ):     370.7 ms ±   6.7 ms    \
>>    [User: 246.5 ms, System: 123.4 ms]
>> Range (min … max):   362.7 ms … 390.7 ms    30 runs
>>
>> patch on clang 21.1.8
>> Time (mean ± σ):     371.9 ms ±   2.4 ms    \
>>    [User: 247.2 ms, System: 123.9 ms]
>> Range (min … max):   369.1 ms … 380.0 ms    30 runs
>>
>> dev on clang 21.1.8
>> Time (mean ± σ):     371.0 ms ±   1.9 ms    \
>>    [User: 245.5 ms, System: 124.5 ms]
>> Range (min … max):   368.4 ms … 377.7 ms    30 runs
>>
>> Signed-off-by: Ashley Lee <yester1324@gmail.com>
>> ---
>> v2: changed vdiv to ilog2 call
>>
>>   lib/zmap.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/lib/zmap.c b/lib/zmap.c
>> index baec278..3ac7fe9 100644
>> --- a/lib/zmap.c
>> +++ b/lib/zmap.c
>> @@ -160,7 +160,7 @@ static int z_erofs_load_compact_lcluster(struct z_erofs_maprecorder *m,
>>       m->nextpackoff = round_down(pos, vcnt << amortizedshift) +
>>                (vcnt << amortizedshift);
>>       lobits = max(lclusterbits, ilog2(Z_EROFS_LI_D0_CBLKCNT) + 1U);
>> -    encodebits = ((vcnt << amortizedshift) - sizeof(__le32)) * 8 / vcnt;
>> +    encodebits = (((vcnt << amortizedshift) - sizeof(__le32)) * 8) >> ilog2(vcnt);
>>       bytes = pos & ((vcnt << amortizedshift) - 1);
>>       in -= bytes;
>>       i = bytes >> amortizedshift;


