Return-Path: <linux-erofs+bounces-4738-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 54228CC6B1D
	for <linux-erofs@archiver.kernel.org>; Wed, 14 Oct 2026 12:06:35 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4j4VL12npzz2yLY;
	Wed, 14 Oct 2026 23:06:33 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=172.234.252.31
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1791979593;
	cv=none; b=bFmF8pP4ViuhjESbeR0aFlmN0pYFuGg6ZZlJmKFqBvEfpZinncdREHGa5WkMAl7crFVa+HqBk/2l+xhf+zXi/QTlkMsNs6kKx0Gt7ji7EEOhgJ8XTCyaYJr3E47I7xlvqCD5iikVklT0u0f2Gb+zeSdvn0NmW+9Bte9ykJk3KwNPNP7keTO1twVbltrDqnrBtPQrbLtRBraEZzTRFWE0WqYhp9490xht6NGTohHVmJG40ek+yK1pHG8kV/4B2hR6l2BKF/Z6Y+AY6fp4Q4/heeY4xLdq1SMnOi3zB2vRiWCSrI9cKT8FqUZpnfAIDslqPquwsdfY1ukzB5ORGBofoQ==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1791979593; c=relaxed/relaxed;
	bh=UOKoeE91QC6wHlg10Z5WINTUk2LP61/1hj8/SrQfMlM=;
	h=Message-ID:Date:MIME-Version:Cc:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=Vpxm+EM5jxbi35Codr6ZGYSyQhDonsxKiLEe7PW5dT5J+x+vPPP9lVba2tnN8d+SPO3kY71iSodfN/D/QGDSKy5+zVLhl6cpf8Rh5J7sawCZmcuEd8UpiWDSzISvnGVRPrJ+oGpb0m83WSZW3C5o9y9da/kesEDihBQqRovyELr5e6Xf31Rkjx7jLFNon1Mmh6mjcRH65koBaVeelK1l/W1T6XT65jxNo7Di4rv7JcgcXDZhmS+Mwkc1k3sa3mKXu511KupgxWdvXKlb2CjPbqjOVJy1cIXEEFrCsCj0sA6y+RsiQqnubQXje65Co0g+EIxpZgTj8165G4fCus2A0g==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=k25Fo/BT; dkim-atps=neutral; spf=pass (client-ip=172.234.252.31; helo=sea.source.kernel.org; envelope-from=chao@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=k25Fo/BT;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=172.234.252.31; helo=sea.source.kernel.org; envelope-from=chao@kernel.org; receiver=lists.ozlabs.org)
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4j4VL03pPkz2yK7
	for <linux-erofs@lists.ozlabs.org>; Wed, 14 Oct 2026 23:06:32 +1100 (AEDT)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 0CF0141496;
	Wed, 14 Oct 2026 12:06:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0722A1F000FF;
	Wed, 14 Oct 2026 12:06:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791979589;
	bh=UOKoeE91QC6wHlg10Z5WINTUk2LP61/1hj8/SrQfMlM=;
	h=Date:Cc:Subject:To:References:From:In-Reply-To;
	b=k25Fo/BTJqRN8wMTrL2GokCqB56I6UZMJfYKO+1SNvTqdx/Su+uO/JNTZp5lsndV7
	 wdBzrQuTBcEFF5GCvRSdduKX2dWu5wAhKTh5vaeEfeQqn3Yt22JNGttWRxy4SXNms1
	 yy3nV7+tIyneAJlvXoNg4voiwfjzCEM0Yjn+v6vWR5Ci2AlTqvXqkp5S3IMpjBZvmE
	 L9dEanAwHCYO54rp86lTeP13cP9r/zKXvr0qRiDKin9mo6PhHQpgL0oaQXAbdtaikP
	 2TpRdju9kDlaj0EoOL4SekyLIP4GjAAthScAeW4f+pexIo3NNtzFTmMmMVZ83ka0V7
	 cNPlVl4aja0vA==
Message-ID: <6fd7029b-f0dd-4b29-b480-3d9c4b113bbd@kernel.org>
Date: Wed, 14 Oct 2026 20:06:27 +0800
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
Cc: chao@kernel.org, LKML <linux-kernel@vger.kernel.org>,
 Xiang Gao <xiang@kernel.org>
Subject: Re: [PATCH] mailmap: update entry for Gao Xiang
To: Xiang Gao <xiang.gao@docker.com>, linux-erofs@lists.ozlabs.org
References: <20261014111504.48355-1-xiang.gao@docker.com>
Content-Language: en-US
From: Chao Yu <chao@kernel.org>
In-Reply-To: <20261014111504.48355-1-xiang.gao@docker.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 10/14/26 19:15, Xiang Gao wrote:
> I recently got a new job; update my mailmap entry to indicate my
> new legal work email address (though I'm not sure I will use it
> in the very near future).

Congrats! Xiang.

> 
> Signed-off-by: Xiang Gao <xiang@kernel.org>
> Signed-off-by: Xiang Gao <xiang.gao@docker.com>
Acked-by: Chao Yu <chao@kernel.org>

Thanks,

