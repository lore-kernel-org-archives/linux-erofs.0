Return-Path: <linux-erofs+bounces-4297-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D9904C5DF8C
	for <linux-erofs@archiver.kernel.org>; Mon, 24 Aug 2026 01:03:13 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hSt276mBrz2y2P;
	Mon, 24 Aug 2026 11:03:11 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=172.234.252.31
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1787533391;
	cv=none; b=jU+NslSm7i3suj5oZc6XfPIhP8UWdlMh91Nbq62/Ol0Y8YQRui8xOQgL9Islc2C88C+5/jWFICEFkdhre3KIoYbSS8crebTb3rk4A1buXMQ4MEOe/CjxhgsVfMpXN6pirYAY1Tah5QuqkSeUTRnpvQSUR4RIU/tTAoA9XdoPGvcLLjP+ausuEo+KPS7ulM1mMhO2o9kolKc8akEbpDFh70Fe62aDFl7H0r07x+pQbPlIiXjmOjr/z/pXy19mgZkEUANvL4wT1Y9ld9irQqpboFpSPTcnft2nNvSoIn60JXbVKTTnJII1OlCHaX4DvJG1T9HGkK5zNwWMOJUU5nxIDg==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1787533391; c=relaxed/relaxed;
	bh=1JCtvzs7ucXhd4fAl/T97AqRrhouKPNDQ/l1KJn/42I=;
	h=Message-ID:Date:MIME-Version:Cc:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=GYv5Yj+nvCdOtZwBx2nrTWtubes9+HSaWSADA1rEPu/v9HdDq8jpWQ3yfZuJNLZvO1+sf+M5mvwMn7hyKgqOjEkEW9RT0Ivv07ba4WD6M0wUX82HKGdi6RrFI6LEAz3cemT2zfo4hZ/ZpslIc+amSZAicrcMl/NIicjlICjQq917ErFyHF6W0NehdHCuLUw6kgWvV7iOaUuFpyE+H/5fNu3ar3qXox/egpuzkFIYojSpsN1c1xwDb/MpKT/Eeo6orXVvkQHX1quSWidl7+prxHGIULSBz5gKqemC3YaiIi13ZHMsd88uNr3kWLX/Ml1IooWRqCyquqwTAtUgrsO/hA==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JoWlSVvb; dkim-atps=neutral; spf=pass (client-ip=172.234.252.31; helo=sea.source.kernel.org; envelope-from=chao@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JoWlSVvb;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=172.234.252.31; helo=sea.source.kernel.org; envelope-from=chao@kernel.org; receiver=lists.ozlabs.org)
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hSt270dNkz2xns
	for <linux-erofs@lists.ozlabs.org>; Mon, 24 Aug 2026 11:03:10 +1000 (AEST)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 4722343DC6
	for <linux-erofs@lists.ozlabs.org>; Mon, 24 Aug 2026 01:03:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14A771F000E9;
	Mon, 24 Aug 2026 01:03:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787533389;
	bh=1JCtvzs7ucXhd4fAl/T97AqRrhouKPNDQ/l1KJn/42I=;
	h=Date:Cc:Subject:To:References:From:In-Reply-To;
	b=JoWlSVvb7w5gqat22u/LOvLr67o8RFfEcFUZUfh7FrIFMs+5g1SAIfO62b5VNYxi7
	 7p1PZ81LijS1zvuuwDqMZSSRdeKqJy0wCI36M7RGHZLFVQacDT56UL+clpi9hoEUY8
	 vH4hxjXAChzEuHia0f69UX/bZHxaXsRW5hZpDqYBCF02HPWcRKDxhHY6vIRJn/MpcJ
	 rAVCvurg7tZ8p+P+3ttukdRY47lUjSeNGgPhhucKIM8fz3n9spZOjiHmj5m7ylucGu
	 Ba/iv0T0U+QqleAk+ECwklLCWhBRbytmhUhAZhBpVh/sPcKTKzKi59KysKDwyAZgus
	 1ih8Cg4c8igBQ==
Message-ID: <1d1ac804-405e-4854-a0aa-f0889fe54c7a@kernel.org>
Date: Mon, 24 Aug 2026 09:03:05 +0800
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
Cc: chao@kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] erofs: simplify z_erofs_gbuf_growsize()
To: Gao Xiang <xiang@kernel.org>, linux-erofs@lists.ozlabs.org
References: <20260823142306.42533-1-xiang@kernel.org>
Content-Language: en-US
From: Chao Yu <chao@kernel.org>
In-Reply-To: <20260823142306.42533-1-xiang@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/23/26 22:23, Gao Xiang wrote:
>   - Use guard(mutex)() to manage gbuf_resize_mutex;
> 
>   - Nullify tmp_pages after successful allocation, so that the error
>     path becomes clearer.
> 
> Signed-off-by: Gao Xiang <xiang@kernel.org>

Reviewed-by: Chao Yu <chao@kernel.org>

Thanks,

