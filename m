Return-Path: <linux-erofs+bounces-4295-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5DD73C5DF97
	for <linux-erofs@archiver.kernel.org>; Mon, 24 Aug 2026 00:47:22 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hSsgr3YbJz2y2P;
	Mon, 24 Aug 2026 10:47:20 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2600:3c04:e001:324:0:1991:8:25"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1787532440;
	cv=none; b=l1bQ1jMO/ILhLXxEZKbU/TV1u9sBGcy4Q/fO64xNBOY2QkeMIeBJOZ5xMnnU6GIcENGz7Rs8Wc6y8BqZczq7m7L507G1uCveRf1MGnNvJm6AJdtioIHN8f4DPbikwX3GaSF6pIKcNSbvPoTHQ5UgpK4fWwVCXtVQoMbZgIt7R+GLGIcW8tTKwjwzXnUx2NZ4SOoHS0ECe58kVOOhFRIGsuIBIe2azcDLKwe5WeUCxM9RhS2gfp9LeGuA/HOC586B3K6IreCOaKBpyZCfF56U+sYyuuaoumBLhTu95g8r0mV11Dp3JVNT/HptuOSPwPo0OPPkZxkvyA3Aua4621jfGw==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1787532440; c=relaxed/relaxed;
	bh=m026UcOV8M2l9HpNOYJpXj/R66caI1sJC3TKri6cjAw=;
	h=Message-ID:Date:MIME-Version:Cc:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=P+Ng+eyeN7bNhUUTEImV655q3DvxSV+m5Dezl4BcZ9dAMDzgVpBReL8TXHtvpZLY77/jA2frfZuohs2mJvzA4aafQypKGoAUlwZczpn/bTm1D2ramn7qHR/AmKzvXbSPIh2aaNyckQ7No2jOi47IYvLaGalKIybYVNJ81nO4zhbCWXkzOYlpa/zCUy3Z+4+IAUeg5AFyE9cq5gB6lxi+C5Dw0MjewhKp5rl3zyOJkd4PDX/rAzI3BdZPPGj0ibOfsOYYlStOcZwxyAyh7cv5QJI50QQIuegW/UiFRUpnsP+BqBwS8GNbTkSStyqQgU/g0YgIqC32BU32FAg5u8dXHg==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Zdv9T6n7; dkim-atps=neutral; spf=pass (client-ip=2600:3c04:e001:324:0:1991:8:25; helo=tor.source.kernel.org; envelope-from=chao@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Zdv9T6n7;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=2600:3c04:e001:324:0:1991:8:25; helo=tor.source.kernel.org; envelope-from=chao@kernel.org; receiver=lists.ozlabs.org)
Received: from tor.source.kernel.org (tor.source.kernel.org [IPv6:2600:3c04:e001:324:0:1991:8:25])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hSsgq55JXz2xns
	for <linux-erofs@lists.ozlabs.org>; Mon, 24 Aug 2026 10:47:19 +1000 (AEST)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 656AD600AD;
	Mon, 24 Aug 2026 00:47:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F34DF1F000E9;
	Mon, 24 Aug 2026 00:47:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787532437;
	bh=m026UcOV8M2l9HpNOYJpXj/R66caI1sJC3TKri6cjAw=;
	h=Date:Cc:Subject:To:References:From:In-Reply-To;
	b=Zdv9T6n7M4gapt/StQI41OAeuoZ8Xryds3U34Ip6GksY+A01PavNuMVIAbGS/LTWx
	 5+FRK7nr0MYGpBqYhjE9/nSc3g73/iddKqSjhbDvrcFNf0EVeCGEDgwHQcklyrQSfm
	 /Xc5APd//zn8kKtiD1c2Zzi5e8mscuWqx3Sm7a8XqGkThJfYYOb94BmG1tWb2oT05Z
	 1CsvsEUH4o1e9LklkpC/mJchgJE08DJQ20gd7QqzjeMwiTNyAzzi8DHBbXxfRHa8z6
	 MD7v/A6RKyc6sYA4T0SruXFdFWGp0jaUViMeLDBOauScVX2gXscig5ZQISi5xgldNX
	 r8+2226m4msVw==
Message-ID: <03fc2c18-c92c-49d2-afb4-a77d774b91eb@kernel.org>
Date: Mon, 24 Aug 2026 08:47:14 +0800
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
Cc: chao@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] erofs: support large folio in inode_share mode
To: Jingbo Xu <jefflexu@linux.alibaba.com>, xiang@kernel.org,
 linux-erofs@lists.ozlabs.org
References: <20260821112540.111105-1-jefflexu@linux.alibaba.com>
Content-Language: en-US
From: Chao Yu <chao@kernel.org>
In-Reply-To: <20260821112540.111105-1-jefflexu@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/21/26 19:25, Jingbo Xu wrote:
> erofs_fill_inode() calls mapping_set_large_folios() on each erofs
> file's own mapping, but in inode_share mode reads are routed to the
> shared inode's page cache instead, whose mapping never had large
> folio support enabled.
> 
> Set up large folios for the shared inode's mapping as well.
> 
> Signed-off-by: Jingbo Xu <jefflexu@linux.alibaba.com>

Reviewed-by: Chao Yu <chao@kernel.org>

Thanks,

