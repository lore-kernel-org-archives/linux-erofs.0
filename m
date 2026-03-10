Return-Path: <linux-erofs+bounces-2554-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4B8C6FCC9D3
	for <linux-erofs@archiver.kernel.org>; Tue, 10 Mar 2026 07:13:26 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4fVQ8N1rd6z3bjb;
	Tue, 10 Mar 2026 18:13:24 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=172.234.252.31
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1773126804;
	cv=none; b=cB/uvOkXRpVKJQKDW3L9BfhURMe6N4nOI8LJdTUiKOO+4qiDQIfkjIUPZfSGD1KZSWKUyyl2IzGmy2sMplAiRV6Wf8A0tuiAaROWQxhW5QTjJxA3X1FyWfV0jRql112E3hkzbXIuorTE5/M8f3uzqayfm+iHq3iqiP7DiDK5W5p16frSTBnnNR78HAx8cVaiLfn+XhIvf+eaEnWkW+7JXyGxKsdABvRCwtGH+NLZoWhRIh/jeVlHeP12pkdP/Z0PGg9MxjvobwPrZjGBonOX/Z0BcqoNdyDn3oH7yknh+wo1kr5ZMauisGt6NJoNLFPftI8eudtyoF6axE1cQQL8Sw==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1773126804; c=relaxed/relaxed;
	bh=Ulz+gmRsPDLV5zOUy/2/bPIkvC308dY6Mfd822z+ffs=;
	h=Message-ID:Date:MIME-Version:Cc:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=f+cd3HBJk8d+bdxtkIhpPFUfiOSwXidpcNihl1I3ROH2qjK6sVipgil3FoS6KV/SEiJpigwcNP3f0/6afromck/DYwQmJ7eSF6Hodt+XA4Bid1L+vMIOHMM04ztZQEjx+96Cq/9jrExs/bnFRzgo7thbjqrA2XeohCoxOMI0evD2inqUEaje16eXnh0eZ82dePTwcUTPOlFcMHT/76XtVyQgFT2mMEZLrRy+cF8V5aKPpg7KTTST9GkCPJ5nWf1/HzcJdSH+kzMV0LI0CyfSIDM6D4te91RQhZMBne5JTuaYZXXOMD7K2+KtmS5hs5RacHFkD+ss17lD5Ps2ynqtLQ==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20201202 header.b=gS+v42Ll; dkim-atps=neutral; spf=pass (client-ip=172.234.252.31; helo=sea.source.kernel.org; envelope-from=chao@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20201202 header.b=gS+v42Ll;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=172.234.252.31; helo=sea.source.kernel.org; envelope-from=chao@kernel.org; receiver=lists.ozlabs.org)
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4fVQ8M3C5Jz2yFY
	for <linux-erofs@lists.ozlabs.org>; Tue, 10 Mar 2026 18:13:23 +1100 (AEDT)
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id ED265435EF;
	Tue, 10 Mar 2026 07:13:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFF0CC19423;
	Tue, 10 Mar 2026 07:13:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773126800;
	bh=Q6xcBXHNuicDNA0HG45fl3n9eDQDK7GjZ8Lp4YQEqQo=;
	h=Date:Cc:Subject:To:References:From:In-Reply-To:From;
	b=gS+v42LlsueP8KIMsq3bUeernz7YGdezod33aJ5up60bWgpCLl2UknWMSK54P+32R
	 ptq1mpcCQUTED/DZGCBSW6uCSMAZx7Fc837t1gZw7HKPMafe5fyV7KYopJalZVoobD
	 kZ+nl02uqurLUmVCSn8YGkMKkrPJpFKohS4NVD2WtsqAYXZcU+SukpFo/odsU66xHk
	 jj85YsGoniF4miPxhP7DyfUS6SDjoDpdEY4N3LY85CD6Krwzib+q6Ly1eWGDjTeHdf
	 8uY8Z1hOUeS8WfEfrXs8ZEeqak/Mjnu5rUyo8nO2L9BZDOjmc/fn1o0RN3P19WqzOm
	 WsSYgsgTyqyTA==
Message-ID: <aac25712-a3f4-4f1a-9200-d16cc7ea97a7@kernel.org>
Date: Tue, 10 Mar 2026 15:13:13 +0800
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
Cc: chao@kernel.org, linux-erofs@lists.ozlabs.org,
 linux-kernel@vger.kernel.org, Yue Hu <zbestahu@gmail.com>,
 Jeffle Xu <jefflexu@linux.alibaba.com>, Sandeep Dhavale
 <dhavale@google.com>, Chunhai Guo <guochunhai@vivo.com>,
 Hongbo Li <lihongbo22@huawei.com>, Matthew Wilcox <willy@infradead.org>,
 Jan Kara <jack@suse.cz>,
 "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH] erofs: introduce nolargefolio mount option
To: Gao Xiang <hsiangkao@linux.alibaba.com>, xiang@kernel.org
References: <20260309023053.1685839-1-chao@kernel.org>
 <02925ac8-64a6-4cd6-bbd4-c37d838f862a@linux.alibaba.com>
 <dc645bd1-2881-4472-8918-0eada3786ab3@kernel.org>
 <a15eeac5-8035-4ac5-93b5-5c71f3ce7105@linux.alibaba.com>
Content-Language: en-US
From: Chao Yu <chao@kernel.org>
In-Reply-To: <a15eeac5-8035-4ac5-93b5-5c71f3ce7105@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 3/10/26 15:02, Gao Xiang wrote:
> 
> 
> On 2026/3/10 14:43, Chao Yu wrote:
>> Xiang,
>>
>> On 3/9/26 11:03, Gao Xiang wrote:
>>> Hi Chao,
>>>
>>> (+cc -fsdevel, willy, Jan kara)
>>>
>>> On 2026/3/9 10:30, Chao Yu wrote:
>>>> This patch introduces a new mount option 'nolargefolio' for EROFS.
>>>> When this option is specified, large folio will be disabled by
>>>> default for all inodes, this option can be used for environments
>>>> where large folio resources are limited, it's necessary to only
>>>> let specified user to allocate large folios on demand.
>>>
>>> For this kind of options, I think more real backgrounds
>>> about avoiding high-order allocations are needed in the
>>> commit message (at least for later reference) also like
>>> what I observed in:
>>> https://android-review.googlesource.com/c/kernel/common/+/3877981
>>
>> Basically, the background is about contention scenario on large folio allocation,
>> it's among multiple users including EROFS in Android-system, as it's related to
>> internal scene of product, so I can not provide more details now, I'm sorry
>> about that, but I'm glad to discuss based on the background and pain point once
>> if I can share more, let's see. :)
> 
> Understood, but I think it's hard to justify an upstream
> solution without a public load for discussion.  Anyway,
> I can imagine some real workloads which large folios could
> cause unnecessary pressure since I once worked for Android,
> but I think others need an explicit one anyway to justify
> this.

Yes,

> 
> As Matthew and Jan mentioned, it's hard to add a per-fs
> knob like this.  If it's Android-specific and no possible
> public infos, I suggest leaving the changes Android
> downstream for now, until the workloads can be made public.

Sure, I can understand that we're not going to accept per-fs change
on large folio policy, as if there is conclusion or agreement about
this in previous discussion from community.

Thanks for the suggestion, I can take a look from downstream side.

Thanks,

> 
> Thanks,
> Gao Xiang


