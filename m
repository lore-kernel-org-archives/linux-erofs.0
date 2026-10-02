Return-Path: <linux-erofs+bounces-4647-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 58286CA5FC4
	for <linux-erofs@archiver.kernel.org>; Fri,  2 Oct 2026 16:01:42 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hxD6r2z8yz30Bd;
	Sat, 03 Oct 2026 02:01:40 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2600:3c0a:e001:78e:0:1991:8:25"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1790956900;
	cv=none; b=cgGWBE7iT6vej/Nqzpk8cYkpNMnQzaWXdB3OOLFTDMjUVFsFU6tmd4eMPKxSrsbYpfoAQND1GkzXm+J3/CTN0cZWXdxs1BcXy2tKhkhMBmZ/S0ggWglKyUftEJaXbrLw4GSnhTAYkTQMoHnIoAOZJnDy29Nid6PI3TlJpIMGlzyszGrniwEFGYzx/QEsWUJS9XO+QSzBzogfN/wp2+yMUV1ahrBrlmmXrXCmJuEg6kADb5GRk5cOEpV6ytfrIMm/t8Kky2bx6DJUZ4p+xfFYadz0q1EzzuhTYeUqg9yfsLrfh5DGOnBhhI7qhM+xoXH0HLUdUOCWt7e1fnQUCy6JKA==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1790956900; c=relaxed/relaxed;
	bh=3vFWWbdkuzKO84u1HS77x/+zIrXxLyxg38gNf5Y6Mhg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PbMITQT7oqVPKjNnOaT39QlU2n8B6HjS8aIBl2yp/yHFAnz2spAxfZL4h3IkgBNuvoZWHPSh//JZDvpQEpdukCv27auqw3D/KMoNcAiqtIWOojI32hZ+prgrft4THi6Dpsf27Www2u3uNvRcVIAVyW/iKQmstHBI/dAMZBuChMoGO0fDb0YdMtOlOYdLU6G/llBZT+Lc+eFeERiBiBu4+wB5Scx3gb4puN4xiHwhpbZpm6nY2pnqJybGjuZQSK84G6RabwKAyWNomf0GE2Z4cbSj298nO67Ov7QpWoLL7oZNqQBOriaLhZqCImHptQShUJhtvvINVdZh9uzhVXrpbQ==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NvZ32+9j; dkim-atps=neutral; spf=pass (client-ip=2600:3c0a:e001:78e:0:1991:8:25; helo=sea.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NvZ32+9j;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=2600:3c0a:e001:78e:0:1991:8:25; helo=sea.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org)
Received: from sea.source.kernel.org (sea.source.kernel.org [IPv6:2600:3c0a:e001:78e:0:1991:8:25])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hxD6q0D6lz2ygK
	for <linux-erofs@lists.ozlabs.org>; Sat, 03 Oct 2026 02:01:39 +1000 (AEST)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id E84BA41855;
	Fri,  2 Oct 2026 16:01:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C2BB1F000FF;
	Fri,  2 Oct 2026 16:01:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790956895;
	bh=3vFWWbdkuzKO84u1HS77x/+zIrXxLyxg38gNf5Y6Mhg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=NvZ32+9jkLbtdxnvmJ4AFYUJu+jFOA+ZCIPACpe+WiSyY8cO9EIt6jM7NC/8wl0gz
	 Yw9Cvq/FLYfsInZGBVyq4C0Y/lVR1cDQnAGIzhVogx1EFqRaJpazzL0NbGYLs58Tkn
	 D8MO9Qc03yhNxi/l+7xDKXMPQZCHnajAURww22CSHcWRyx37QbP0s7fFPA8TM5QgX4
	 6s2u/CshmpjgGQ5BV7lTDOoUKbqZA2VKbggoK6Ht/NYbQ1/QrPCmFqBqENpZ4y+tlc
	 Wp9blISLSzFCwuhwPXqundEAxUpa8AAcNMwlIEcorqU+y2C2n5CgnOeDSmGo3vgQVl
	 Akb99sZ86Pnnw==
Date: Fri, 2 Oct 2026 18:01:28 +0200
From: Gao Xiang <xiang@kernel.org>
To: Binglei Wang <l3b2w1@gmail.com>
Cc: xiang@kernel.org, chao@kernel.org, linux-erofs@lists.ozlabs.org,
	linux-kernel@vger.kernel.org,
	"Bo Liu (OpenAnolis)" <liubo03@inspur.com>
Subject: Re: [PATCH v2] erofs: fix folio reuse from a different address_space
 in erofs_bread()
Message-ID: <ar_VWGhC1O6-4w0a@XiangdeMacBook-Pro.local>
Mail-Followup-To: Binglei Wang <l3b2w1@gmail.com>, xiang@kernel.org,
	chao@kernel.org, linux-erofs@lists.ozlabs.org,
	linux-kernel@vger.kernel.org,
	"Bo Liu (OpenAnolis)" <liubo03@inspur.com>
References: <ar1xOV3x9ZMGx9XY@MacBookPro>
 <20261001060131.51103-1-l3b2w1@gmail.com>
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
In-Reply-To: <20261001060131.51103-1-l3b2w1@gmail.com>

On Thu, Oct 01, 2026 at 02:01:31PM +0800, Binglei Wang wrote:
> erofs_bread() reuses a cached folio on page index match without
> checking folio->mapping.
> 
> xattr.c calls erofs_init_metabuf() twice on the same buffer without
> erofs_put_metabuf(); the two in_metabox sources differ, so buf->mapping
> can switch while buf->page still belongs to the old address_space.
> The next erofs_bread() then reads the wrong mapping, dropping shared
> xattrs with METABOX.
> 
> We require folio->mapping == buf->mapping in the reuse check; otherwise
> drop the cached folio and re-read via the slow path.
> 
> Fixes: 414091322c63 ("erofs: implement metadata compression")
> Cc: Bo Liu (OpenAnolis) <liubo03@inspur.com>
> Signed-off-by: Binglei Wang <l3b2w1@gmail.com>

I applied this patch with the updated subject:

erofs: fix xattrs handling when metadata compression is used

Reviewed-by: Gao Xiang <xiang@kernel.org>

Thanks,
Gao Xiang

