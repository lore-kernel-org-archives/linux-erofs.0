Return-Path: <linux-erofs+bounces-4286-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 33114C5DF93
	for <linux-erofs@archiver.kernel.org>; Fri, 21 Aug 2026 14:32:17 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hRN7372Sgz2xcG;
	Sat, 22 Aug 2026 00:32:15 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=172.234.252.31
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1787322735;
	cv=none; b=gbR9E6FA7MVptpzv8RV9FG1QebCr20CNfbTnG6R3lacc+905032f1teapSsztfUfXZQQbzC903oJoVTqTsLin5/vXTaMUHfoyZhGjUANsdl3y26VYkD2Fje+8zrRESBdc8EuGPl4HPrmaSReux7tHU/cycNmDh3uAbHBTyTNrmj0s9tZu4Xf6RVb6+F9ui5OTkpylE2iwv3+5MfICofE+SETdWtunCzH1mlUd+hBjnARs+6N0aKN6Hex4IVYX9FRlYPd0n+m++TQcqCKX8KJBg8fBj5GXkBnDgphx3kqBLb5ARJK3pDowOHsJuQiN891SSIbw7gmvp9UCCpvHcftMQ==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1787322735; c=relaxed/relaxed;
	bh=+fMcDCG+5fbRAUA+2vA7F/VG/AR7ELvZw5ydJwkImkY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ShwP94SMUyLl3WlJ05ckzftVI4Cu0lo6/gyz+HecfH3X128y19BeKP++2/odVKfgeZaasrzYgAC04+/TfWY3PmYT5jh5/3pfAzwNG0evYjQaQWXfygDPNvJAqsDZgXcNe+E+hn3NnHvQTodzhpnlU2WYCXV8EaHiBNCjiPgLxgTpdG7h5wYN7hBsVhKRfWt+MHpgKmsp/yUAXt2Eg8Wj93qMD/rPZ2TnGTG7whKoqrqQoTOHXUW6VLMIcyj5V6gI0Wu076AvOXxQx8C4y32kSjjpCYewui4jdcq7rESU3CNTICLhK7dB3sqzhO2rhv4lbhd/PTHsAGpfRW2fT8Pgxg==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=R/zAraoZ; dkim-atps=neutral; spf=pass (client-ip=172.234.252.31; helo=sea.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=R/zAraoZ;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=172.234.252.31; helo=sea.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org)
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hRN726D9Lz2xWt
	for <linux-erofs@lists.ozlabs.org>; Sat, 22 Aug 2026 00:32:14 +1000 (AEST)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 56C2C43F59;
	Fri, 21 Aug 2026 14:32:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03D561F000E9;
	Fri, 21 Aug 2026 14:32:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787322732;
	bh=+fMcDCG+5fbRAUA+2vA7F/VG/AR7ELvZw5ydJwkImkY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=R/zAraoZilul6LBO2R+vPGHs16YxvywgycJazEwcRv/U5uwpz7TtJlL6WPdBA/IhZ
	 QwuSjuW5JKlxa5zGkbaRgupG5GkcGGy3yaeTnV4GR8NjkXAtV+EX2DK43jK/mh0vhH
	 AYYS4UJb6xlhJQ7Zy1hRqiG8EZMmNM+6zOWiqWUx3+Egb8IsuGLG9ptTtqMq2tBvZ1
	 CoxaNJdGSetk4CwGkrrp9+kfU3/7jSgpan7ho/iVU4VmyvUzina2PAppf9Z1lOsO5v
	 c5bcdLgvjOWCt1WQDtiUc/4COtIAns094PRT1+SmkhbOcfvRjzwB+IeCE4nWHrFh8M
	 kq+zfOgzCE53A==
Date: Fri, 21 Aug 2026 22:32:03 +0800
From: Gao Xiang <xiang@kernel.org>
To: Jingbo Xu <jefflexu@linux.alibaba.com>
Cc: xiang@kernel.org, chao@kernel.org, linux-erofs@lists.ozlabs.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] erofs: support large folio in inode_share mode
Message-ID: <aohhY1LQAsqVzc4-@XiangdeMacBook-Pro.local>
Mail-Followup-To: Jingbo Xu <jefflexu@linux.alibaba.com>, xiang@kernel.org,
	chao@kernel.org, linux-erofs@lists.ozlabs.org,
	linux-kernel@vger.kernel.org
References: <20260821112540.111105-1-jefflexu@linux.alibaba.com>
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
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260821112540.111105-1-jefflexu@linux.alibaba.com>

On Fri, Aug 21, 2026 at 07:25:40PM +0800, Jingbo Xu wrote:
> erofs_fill_inode() calls mapping_set_large_folios() on each erofs
> file's own mapping, but in inode_share mode reads are routed to the
> shared inode's page cache instead, whose mapping never had large
> folio support enabled.
> 
> Set up large folios for the shared inode's mapping as well.
> 
> Signed-off-by: Jingbo Xu <jefflexu@linux.alibaba.com>

Reviewed-by: Gao Xiang <xiang@kernel.org>

Thanks,
Gao Xiang

