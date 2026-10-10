Return-Path: <linux-erofs+bounces-4687-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 29E8BCA6017
	for <linux-erofs@archiver.kernel.org>; Sat, 10 Oct 2026 07:19:07 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4j1w892GMRz304x;
	Sat, 10 Oct 2026 18:19:05 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2600:3c04:e001:324:0:1991:8:25"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1791616745;
	cv=none; b=kC9KI44xmnwiCLP5Nw1CtAXHwTgKFSLGUD8+SePcKdzthgOJ02Ue2xnLcruObyCP+Jdr556qPdxlqKMdhQfVslAwZZzV+hb39g4fu+uAo0WmCcdcQ/lGAzsFakyR9tO/wPrMdnpxqpVk47pZAv/NUb0L7N2Zy/ccBRA5a5fYPJBuWAeqfbsQncozq873q7y71ie93ZcnVGl+KSFIGLB/1Uuky+3/f9ppu8V4bexDNGfwVC+kfydxmDe81XqcuDcAf7v1GcPddRkoUAIivgEmeSwys9yrWiCj47m69D8d/B1cney4DVlxLapDqhyretWfKVnpI/w+aSnDi3bqxFB9qQ==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1791616745; c=relaxed/relaxed;
	bh=7e3wJo05pIykdcj39kHBCTmS82u9k8Ir/4Ic+j2EQXw=;
	h=Message-ID:Date:MIME-Version:Cc:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=Wqwb5UhsOajz2SZ/kBw2+ktRArga8TevDWGjK0B3/qk560OK4DDBTyXsUq1kFYUH+reOphren7yyjFCkqIQncynP7OUDuH6xsKUlmPPq938nWuztGk4CUP/4uc6oUfP8C6t36GVPu7voYgoKBRnP33PO7rGqJ3+p3ndCYolgVgNx6sYXKiQyhsZjYLH3FSQE7nzrQaWz6HaAicXAAbGWeIQN6ncXmurdUe4tk+hzwMW72TontV39+heZsza098OEFrbPYAjrxhwAqM7tm7U60gqiu7TyZyFRnUcfdMbiiODbgM+pG3O2IT5D+rbLfc6Cnu8VlNxgXEXiFMCCkQEBog==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jAYDOZsB; dkim-atps=neutral; spf=pass (client-ip=2600:3c04:e001:324:0:1991:8:25; helo=tor.source.kernel.org; envelope-from=chao@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jAYDOZsB;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=2600:3c04:e001:324:0:1991:8:25; helo=tor.source.kernel.org; envelope-from=chao@kernel.org; receiver=lists.ozlabs.org)
Received: from tor.source.kernel.org (tor.source.kernel.org [IPv6:2600:3c04:e001:324:0:1991:8:25])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4j1w8851wzz2yqT
	for <linux-erofs@lists.ozlabs.org>; Sat, 10 Oct 2026 18:19:04 +1100 (AEDT)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id DDEB3601F0;
	Sat, 10 Oct 2026 07:19:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0A9C1F000FF;
	Sat, 10 Oct 2026 07:19:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791616741;
	bh=7e3wJo05pIykdcj39kHBCTmS82u9k8Ir/4Ic+j2EQXw=;
	h=Date:Cc:Subject:To:References:From:In-Reply-To;
	b=jAYDOZsBqnRBv7vaRoK/JW4BSXAsvIHCsLTWCr23KdNitOB79MZRLva7d2mIawlcQ
	 cMY78frNbxEpLaSZW7p6a6g0pEdPKwFe1IDtG0OyBCaPRlk4Fn/D6xzwxztUuwaavn
	 Jr9ytCa6lO9VzJ4HoJDCqDKjmy+zSeu/YXTUWeQ7e3gNPxJfA+Chgl07VUD5+ltnoK
	 TR07mCLKbVofxhe/AoG51CVcJksJEqgaLeHVAhGvQ6gPW3btH/nZvklvnncfEpMekv
	 HSFsmdnb+RGL2eFO0lC4s76/ze4VxgxIyiY10pIqok3WOuWPpls4i2Ca0p/+YY0E/j
	 oOWkKGCj3dpGw==
Message-ID: <1aaa8a8f-1604-4fb8-8245-609258ac97be@kernel.org>
Date: Sat, 10 Oct 2026 15:18:59 +0800
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
 linux-kernel@vger.kernel.org, "Bo Liu (OpenAnolis)" <liubo03@inspur.com>
Subject: Re: [PATCH v2] erofs: fix folio reuse from a different address_space
 in erofs_bread()
To: Binglei Wang <l3b2w1@gmail.com>, xiang@kernel.org
References: <ar1GgGSIZ1h0bBip@MacBookPro>
 <20260930191905.539-1-l3b2w1@gmail.com>
Content-Language: en-US
From: Chao Yu <chao@kernel.org>
In-Reply-To: <20260930191905.539-1-l3b2w1@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 10/1/26 03:19, Binglei Wang wrote:
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
Reviewed-by: Chao Yu <chao@kernel.org>

Thanks,

