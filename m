Return-Path: <linux-erofs+bounces-4242-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BB9B6C5B572
	for <linux-erofs@archiver.kernel.org>; Mon, 17 Aug 2026 08:11:27 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hNlsV36F0z2xy6;
	Mon, 17 Aug 2026 18:11:26 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=172.234.252.31
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1786954286;
	cv=none; b=Wejye/wk0sUDM41l0jcFkMDdHWtyVTW80xsBb2fOpA1ZJ5NVAsYSUI5zMrej163rrA7MivcAEZFBwUXO8bgEx/EF6CJuG5HZETmSpRdZcb6mUo4YRwh0JeqrhFConBonZe5sZ7+vtSiP8RhqEXh6ybi9ldAnEkzM2P3gwjvoJUxtaKxgtoCud42o8RLX8Z/r/GDJXyW07N4f8ienFWYX7A1Y+avGcmFU2wiSJdtHVqlY7ymGJWlIHOkDAv92bDBg0xomw+BvLUuUSjocirEEqjpB7Russ3rJF7VqFucZYpn2MOFOgsUnOVrQTWvT54d3P1fqGLXZ79OhwJdxiPRgFA==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1786954286; c=relaxed/relaxed;
	bh=AyyzHu8e4Htiwfuj+novWAoEVev/f7N2ubm2IGDxvAo=;
	h=Message-ID:Date:MIME-Version:Cc:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=CUXNSB8ygDXiPDzN0s5N+S/3B0miQwotQTcX83yZrOSMz3WvFK2Bllbf1Aj6NlMECKwjWTqfKL3R/pygObDTZ8AB05E3cxGzi4nFMUClxhWB2DA0IiBOQb0QJ1EZmfZQNuV3E6FBGBjrv6WW4dmOhjlSgLhKATeFJk0XRCSN7AiaSOtZAtyhdifkRqsuxpNcdl29+JaBaYhS8w1g/Z7JZbPrAWIOTDjJzYa0tKuwxJjUVI/Yn7aRVgYUVs8YM4AyeeWOtd1TKsdXptkrA2szn0wCmCOEWxk/XHosQswCTuqhmAX/mgkTJ7L/IqaWVvmN69+6jAzMgCPIBlWRckX4eg==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=IJYZhxpB; dkim-atps=neutral; spf=pass (client-ip=172.234.252.31; helo=sea.source.kernel.org; envelope-from=chao@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=IJYZhxpB;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=172.234.252.31; helo=sea.source.kernel.org; envelope-from=chao@kernel.org; receiver=lists.ozlabs.org)
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hNlsT62vYz2xl5
	for <linux-erofs@lists.ozlabs.org>; Mon, 17 Aug 2026 18:11:25 +1000 (AEST)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id DC7BC40A98
	for <linux-erofs@lists.ozlabs.org>; Mon, 17 Aug 2026 08:11:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D48801F000E9;
	Mon, 17 Aug 2026 08:11:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786954283;
	bh=AyyzHu8e4Htiwfuj+novWAoEVev/f7N2ubm2IGDxvAo=;
	h=Date:Cc:Subject:To:References:From:In-Reply-To;
	b=IJYZhxpBga8gDnoO/WhVJ0DuXaBhU/3/8qtQ2d6UKnfCfiZKfhTpR72eaMh8y0yPB
	 nZpqB6SPbee1ol3NCjlhFXTEQSt4EtDl/IbHyNJytVPobuASGwW880ED29C9jya3Kp
	 d2ZioEGKjK+CG7/krz3JILj+1ZLIiR5fj9KXSGAsVLJq0EymjU8leqSflHrdmC9GBr
	 allUk7h6iY6XHjJsF7VXp/sJZgaYAgtM67e7lr3cpw2OBL1VybyrgvyGpXFU/aAZPY
	 gjD6W9+MOL6ZMyYZ6r4AZQXESMGpfscQcwoFxAo9+NAzRTigtZuVMMrOWV1lOyJS4+
	 XoTuSUuZ7wqXg==
Message-ID: <aaa5ed03-af98-4450-aad4-f9a9c9bbc19c@kernel.org>
Date: Mon, 17 Aug 2026 16:11:20 +0800
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
Subject: Re: [PATCH] erofs: guard on-disk algorithm IDs against
 Z_EROFS_COMPRESSION_MAX
To: Gao Xiang <xiang@kernel.org>, linux-erofs@lists.ozlabs.org
References: <20260814081437.86684-1-xiang@kernel.org>
Content-Language: en-US
From: Chao Yu <chao@kernel.org>
In-Reply-To: <20260814081437.86684-1-xiang@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/14/26 16:14, Gao Xiang wrote:
> All on-disk algorithm IDs should be validated against
> supported Z_EROFS_COMPRESSION_MAX.
> 
> This includes a partial revert of a previous commit and also adds
> validation for encoded extents.
> 
> Fixes: 131897c65e2b ("erofs: fix invalid algorithm for encoded extents")
> Signed-off-by: Gao Xiang <xiang@kernel.org>

Reviewed-by: Chao Yu <chao@kernel.org>

Thanks,

