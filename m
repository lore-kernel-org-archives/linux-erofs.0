Return-Path: <linux-erofs+bounces-4296-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 867ECC5DF97
	for <linux-erofs@archiver.kernel.org>; Mon, 24 Aug 2026 00:57:54 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hSsw03ylGz2y2P;
	Mon, 24 Aug 2026 10:57:52 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=172.234.252.31
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1787533072;
	cv=none; b=mrL7iTPHiU0EAaCxKj6DxB2uCZtFAtJeqZRJNP/xIxBV1YpwWcRT1tI+kT1d72zWzhS68AfDrHjqBINUWB/eznpRB9mTDZEy2gYWtdavW+v4tiZdl8MPD/anNx8x+FVUBHf1wqJ3j+n1XekpARm1SkMMXZUQAYNUmYR8fE3RgPfl63/yVrqAVafi9mO8Gk1+nDU8YRSbAW49cXHsZH6tvaTffRpilIY/8n2jSdnuV97mdfzIdvU96WSKYHVo9gUyueaXf7suczJU7FJ66pvl2xcP+CYg2DBKNsmMV5zvd9mmml51m0AjmQesQs6aB9yvv4MrkUpheD5cdW2XPLdcsg==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1787533072; c=relaxed/relaxed;
	bh=hDlgbjhSR4ai6RtZNkwjoZhpTUzRuGdgR34nn3zo+7Y=;
	h=Message-ID:Date:MIME-Version:Cc:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=LIF8/MpqiwtnVZd1zhTdn3Ta9EZRr4e6DdCcmNX4HvNj+F39P9OieNqnoNkowqAf6qpwt7xbrk5mJBiqBohvwL5+GxrBtNejyvfYo8zBbC7/gKHk2tdvrwHIqqAtfLei16Q29UH2QmK5ukSgFK3EkTP/M0YbIufiKB1S9LZj0eo2+iHngfffQ03nIKnGxCnGrtaNj2F9aZw81IL62DZIQbYpOm4Q0X6f1txMo0LeUquulwnLhcDZyExWcAoLxYg2XBk6iodkgB38L3sS9sw7XhH6ZNOrdeyLEa9q/T+SfFPZVIQBX5YtdyTuUmK4N4bDuU+7L/9sSRmvCHvNdIwKEw==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Rx0s+QsX; dkim-atps=neutral; spf=pass (client-ip=172.234.252.31; helo=sea.source.kernel.org; envelope-from=chao@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Rx0s+QsX;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=172.234.252.31; helo=sea.source.kernel.org; envelope-from=chao@kernel.org; receiver=lists.ozlabs.org)
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hSsvy6F6qz2xns
	for <linux-erofs@lists.ozlabs.org>; Mon, 24 Aug 2026 10:57:50 +1000 (AEST)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id AE42943ADE;
	Mon, 24 Aug 2026 00:57:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D40E01F000E9;
	Mon, 24 Aug 2026 00:57:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787533068;
	bh=hDlgbjhSR4ai6RtZNkwjoZhpTUzRuGdgR34nn3zo+7Y=;
	h=Date:Cc:Subject:To:References:From:In-Reply-To;
	b=Rx0s+QsXwKJTFdh0Ne/Cim3ZdgLMn3myynXUE1Hdt5KYQfr//5Qpo0wxy/2x58lnc
	 cz6Qz3PIV3xD4m3afEvVpyvSZQ5RdTXygP9jsy/6BQHLr5zPUCry6d1UrBcQJkVUS0
	 NB/LMqukgV1hqfwOOl6rNEBphrnQSp580QAFxBkPhG7d0qWA9h2QV+2L/mfuE+HtwY
	 rm81XHhf6LHtg0EVJ3SPnUdGdK5KALkH23mLAYHHkWgtK8NE6AWQpk/wRRaLk+9ujL
	 N2mMuZ3UKOANwTyRLY6eDXodykkJgzjZnA3H6tCs6gm58JbOFwzCTW0YtKtjfjZW6L
	 pW0MeDbOhNqXQ==
Message-ID: <39e2934d-7155-4a55-bd55-3006308b810c@kernel.org>
Date: Mon, 24 Aug 2026 08:57:43 +0800
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
Cc: chao@kernel.org, zbestahu@gmail.com, jefflexu@linux.alibaba.com,
 dhavale@google.com, hongbohbli@tencent.com, guochunhai@vivo.com,
 linux-erofs@lists.ozlabs.org, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org
Subject: Re: [PATCH] erofs: skip sufficiently large global buffers when
 resizing
To: Nikhil Gurudasani <nikhilgurudasani314@gmail.com>, xiang@kernel.org
References: <20260822140017.8119-1-nikhilgurudasani314@gmail.com>
Content-Language: en-US
From: Chao Yu <chao@kernel.org>
In-Reply-To: <20260822140017.8119-1-nikhilgurudasani314@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/22/26 22:00, Nikhil Gurudasani wrote:
> z_erofs_gbuf_nrpages is advanced only after every global buffer has been
> grown. If a resize fails after some buffers were enlarged, a retry
> revisits those enlarged buffers.
> 
> Retrying the same size then returns -ENOMEM because alloc_pages_bulk()
> has no pages to add and the unchanged return value is treated as a
> failure. Retrying an intermediate size allocates a temporary pointer
> array smaller than gbuf->nrpages and copies more existing pointers than
> the array can hold.
> 
> Skip buffers that already satisfy the request. Once all remaining
> buffers have caught up, advancing z_erofs_gbuf_nrpages again describes
> the guaranteed minimum size across the pool.
> 
> Fixes: d6db47e571dc ("erofs: do not use pagepool in z_erofs_gbuf_growsize()")
> Cc: stable@vger.kernel.org # 6.10+
> Signed-off-by: Nikhil Gurudasani <nikhilgurudasani314@gmail.com>

Reviewed-by: Chao Yu <chao@kernel.org>

Thanks,

