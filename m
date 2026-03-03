Return-Path: <linux-erofs+bounces-2483-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9FF67E67A70
	for <linux-erofs@archiver.kernel.org>; Tue,  3 Mar 2026 06:36:30 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4fQ5g103kkz2yFY;
	Tue, 03 Mar 2026 17:36:29 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=47.90.199.11
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1772519788;
	cv=none; b=klDr92HXoLQUUjiTVyrCPKf6kRpFBoOIo9Y09oEFdRD7cqhNANc3Cm0S2V92wh/uHtDcLMSKc70r04pWUhMVk/gt9KgUvLnyliThig89+0G8zTztdbe5LeOEbWaLq6ZDPjvgFmYndEgeYm5mlg9RYutMbywA2yq9VE0DYICN/EV/0rn2nRtRbpYAKDOye7Nl8CvrRmD6YGP02U0Xaha1QODH6Y9XrhDvX5e4OWxeuT2uVMPom95R7rQnk0tpJIWqeWemuQqN41JF/bByrHrgiUukqwKwawmQTTKq8vXma8M2XHP6qlVrrF75YacMsaENt5ctgahGuxEtPKm2DrxOPA==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1772519788; c=relaxed/relaxed;
	bh=atRMWhVAM1R2ceNuLdy0ZMdSTz55TIfxjDOzHkv4VVQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=CwL43HikS9kBbcUuIzJ3LRPpTigh6FfnJYOhKkhbvZmxaclhm465D7scH4KnTT0kPp5SwXCGVU3Et14F3m8JXNlPzWhCzvVNKVzm1vWbHaWMe3R/S2bznmvYOiicfdTVsxf92LrrOqfd+nCJhvXOQxYL78rXSawau4pAFWzmgLf7Yjr4gwLcxD9I87m6xGbRm+lRVWeQg5o4iW2tH8Ibyb52HOxb8GwlDq4D7YuoMT9XtizQIuAFzOOlgRHu25k7rbW0Qc18rYGEdupgaEQmfM6ZxYsHZY+bbqoA7S090qjt5I/OTIMj5l2X4oRXdMo7I09qrAaQ4ddfhmLOoVuxvA==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=ah7E26Uf; dkim-atps=neutral; spf=pass (client-ip=47.90.199.11; helo=out199-11.us.a.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org) smtp.mailfrom=linux.alibaba.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=ah7E26Uf;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=linux.alibaba.com (client-ip=47.90.199.11; helo=out199-11.us.a.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org)
Received: from out199-11.us.a.mail.aliyun.com (out199-11.us.a.mail.aliyun.com [47.90.199.11])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4fQ5fx4Qvsz2xpk
	for <linux-erofs@lists.ozlabs.org>; Tue, 03 Mar 2026 17:36:24 +1100 (AEDT)
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1772519769; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=atRMWhVAM1R2ceNuLdy0ZMdSTz55TIfxjDOzHkv4VVQ=;
	b=ah7E26UfmGR/TFdbtOB/4pnwQ1i7YbAsva207oh91Ouk5cynrYAh/IUKR55wXcf7euWG7jUBD9V0G/n7cZYYqMtiHJP6Jdp+JtdWQhkysn21RneAkoofVzKoYrLPpzqbKJ/jOZiombugLVJoHoWgjE+UZkZsA3LUM2XKpHW264k=
Received: from 30.221.132.55(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0X-8n6Sx_1772519767 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 03 Mar 2026 14:36:08 +0800
Message-ID: <165cb173-f8bb-4d80-950f-6ab87b58ceb8@linux.alibaba.com>
Date: Tue, 3 Mar 2026 14:36:06 +0800
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
Subject: Re: [PATCH] fsck.erofs: introduce multi-threaded decompression PoC
 with pcluster batching
To: Nithurshen Karthikeyan <nithurshen.dev@gmail.com>,
 linux-erofs@lists.ozlabs.org
Cc: xiang@kernel.org
References: <20260302073216.94384-1-nithurshen.dev@gmail.com>
 <1415c632-7a4f-40e6-af3d-09ca2c02244c@linux.alibaba.com>
 <CANRYsKh4ZYYiJxd2S11crsyt6G57L_3nmWmFEp4iMQ7use0+1Q@mail.gmail.com>
From: Gao Xiang <hsiangkao@linux.alibaba.com>
In-Reply-To: <CANRYsKh4ZYYiJxd2S11crsyt6G57L_3nmWmFEp4iMQ7use0+1Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 2026/3/3 14:25, Nithurshen Karthikeyan wrote:
> Hi Xiang,
> 
> On Mon, Mar 2, 2026 at 9:22 PM Gao Xiang <hsiangkao@linux.alibaba.com> wrote:
>>
>> Hi Nithurshen,
>>
>> Glad to see the improvements, I think there are more room
>> to be improved anyway.
>>
>> Also there are still some follow-up works, I'm busy these
>> two days, but I will release a formal gsoc page later.
>>
>> Thanks,
>> Gao Xiang
> 
> I completely agree that there is significant room for improvement
> beyond this initial batching implementation. In my formal GSoC
> proposal, I plan to explore several key areas:
> 1) Dynamically scaling the batch size based on the algorithm's
> complexity. Fast algorithms like LZ4 can handle larger batches to hide
> latency, while compute-heavy LZMA/ZSTD may require smaller, more
> frequent dispatches to keep cores saturated without bloating memory.
> 2) Currently, the directory traversal remains serial. I want to
> investigate parallelizing the inode verification pass to ensure the
> entire fsck process is truly multi-threaded.
> 3) Implementing a sliding-window or credit-based throttle to prevent
> worker threads from over-consuming memory on low-resource devices when
> disk I/O is slow.

For the part 3), The linux kernel already has dirty page throttling
and it will block the worker thread if there is enough dirty page
cache.

So I wonder if it's really necessary since apart from that, the
remaining memory (incluing memory allocated in the compressors) are
all temporary buffers and should correlate to the number of workers.

For the part 1,2, I think they are good.

Also there is another thing about metadata/directory decompression,
I think in order to make these faster, we need to implement caching
for these, much like what we did for fragments now.

> 
> Before I begin drafting my proposal based on these goals, can you
> kindly let me know your thoughts on this?
> 
> Thanks for the guidance!
> 
> Best regards,
> Nithurshen


