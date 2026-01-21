Return-Path: <linux-erofs+bounces-2109-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 64095D262B2
	for <linux-erofs@archiver.kernel.org>; Wed, 21 Jan 2026 05:23:33 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4dwszl6bGYz2yFg;
	Wed, 21 Jan 2026 16:23:31 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=172.234.252.31
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1768973011;
	cv=none; b=ERANpk2dOcKGczvI7z8Np6AijA6JnFTYYENvgJL8HJxVyDB1W1HzcFRxaRkyM2Tpj2SAYBUdUH0bqNCFX+siK7tf8NhAsV4KgcSyAHIHM48xanyj2rlSUORA/5HJErbU/0RLom9w2ivIFpnt/PAIMYbh48yXJkQI7seLZt1KjJFsZm46snRfYY8oGQDWNY/xaqgm/QQqvA4GYkbVE9ZA3keePIe92HC83ZweuLI7EX+30d2QzfdbQ3ddXK3rUD8GLzj0K/YemWgGpdkihSJaReOLpy9QB1jRGG8ccUU7uQJLCBAY/T/g0RAWeElUamVt725de2i6/Thqo5s7ZRNWhg==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1768973011; c=relaxed/relaxed;
	bh=XELRupvEWGRYwGCJIC9STtRM2bBc/e+UPbESJEin4hk=;
	h=Message-ID:Date:MIME-Version:Cc:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=XkD/5zfamb8wmK4KffIL6qgyI93FU6M3uLhVFpKoeltSVqJ1stIXGhuk7akyl4De/7o8AbKG2TwKvlEcYEYdanhdKZ1NkPk+0xos2rLv5uRepUUMwS9C02XAvawrjT/dzIk8iBPO8imosS5iV+FcWSTvcFQUcSeuE6syJ3Bt503gADmlIuFLFKHzOV/VEUPqvMm2OJJ/rvqvI1JYbBXpuk+RboPXHgEj8h3Rwo3netjq2XEl3YrY0cPACXlo1SFEyooHBRVenZnzLEg9Ju3Vjs465y4NWizgWKL6S1PkpNh9dPjIKS72vI+7YHl1jagKPW2OPXCW3CfiYbTwUlnDsQ==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20201202 header.b=iSra//tN; dkim-atps=neutral; spf=pass (client-ip=172.234.252.31; helo=sea.source.kernel.org; envelope-from=chao@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20201202 header.b=iSra//tN;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=172.234.252.31; helo=sea.source.kernel.org; envelope-from=chao@kernel.org; receiver=lists.ozlabs.org)
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4dwszl2qcvz2xqD
	for <linux-erofs@lists.ozlabs.org>; Wed, 21 Jan 2026 16:23:31 +1100 (AEDT)
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 2A9ED43A59;
	Wed, 21 Jan 2026 05:23:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF13EC116D0;
	Wed, 21 Jan 2026 05:23:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768973009;
	bh=Wb7ux9lPwXTWQpGJrwDdWLozj3EIWQgaSIOcFprtfxU=;
	h=Date:Cc:Subject:To:References:From:In-Reply-To:From;
	b=iSra//tNAwvU+7Fut1gEgGr2ujiTU1KqwmWBEjmI0jgANirIlAmjeBpq6j/TL3S5e
	 uXtQ+RFZHvIqaVOkOHPqrYqHTy0amaYt4hCqTNjGklaG84a4JS4ZGQhgLlsS6GCxsd
	 upBYVrCBZ5MqRtfa8YIaCjjvH/+abSJ0T8vtuibb/EXMEe7y78xqynKZyR748n0olW
	 PF/jkUKfbXqOK59vJs475x1BcSFQyl5XCboAKQAJAfsolor0CYyT4a14hQtYHXb3e+
	 aVE/AOvJVpTUUbNut14QWfJPpXermrIKDz7cWhqBjuR46kloSKpezteMasfHd5+d8A
	 qUEAUxVvkuP/w==
Message-ID: <25ccc2ee-07d4-4be6-b6d7-10186d922c5c@kernel.org>
Date: Wed, 21 Jan 2026 13:23:24 +0800
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
Subject: Re: [PATCH] erofs: make z_erofs_crypto[] static
To: Ferry Meng <mengferry@linux.alibaba.com>, linux-erofs@lists.ozlabs.org
References: <20251216082141.108624-1-mengferry@linux.alibaba.com>
Content-Language: en-US
From: Chao Yu <chao@kernel.org>
In-Reply-To: <20251216082141.108624-1-mengferry@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2025/12/16 16:21, Ferry Meng wrote:
> Reduce the scope of 'z_erofs_crypto[]' that is not used outside of
> 'decompressor_crypto.c'.
> 
> Reported-by: kernel test robot <lkp@intel.com>
> Closes: https://lore.kernel.org/oe-kbuild-all/202512102025.4mWeBSsf-lkp@intel.com/
> Signed-off-by: Ferry Meng <mengferry@linux.alibaba.com>

Reviewed-by: Chao Yu <chao@kernel.org>

Thanks,

