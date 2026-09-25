Return-Path: <linux-erofs+bounces-4617-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1CFA2C9830E
	for <linux-erofs@archiver.kernel.org>; Fri, 25 Sep 2026 18:48:40 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hs08k5Zzmz2yfD;
	Sat, 26 Sep 2026 04:48:38 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=172.234.252.31
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1790362118;
	cv=none; b=Sv43sO5QEiSCjjG76THurrRn0JgHQWvyOSVJT8F7dNgTdinnn7dW5ya+/oHdSVc6Z7OqLpLqPyHkYZ66mb6qDjJnj2PuCfpZN4IzxjzcqGBmb/ZD+uV1ee1K7/uSY8asD97UrUw819T7ToljDH3370v6S2VKCQqJdNJlrCstsCs/8qxz6qDTZBiKLjKI/inuYLsrPGVHeuUW6BIzAoBz9Uq2/VQr9M7jHSpY1MyQq1d5kfU15oEcNBrEoRaH+oLamKKJx/nPep117AcMUX9yofWPU34EhYqwxtEtxVPDcfeAB87yCzyP45G6CDy4waXNMF5C8oYVLiS46K1xOVRUAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1790362118; c=relaxed/relaxed;
	bh=WrgWRdYmbvngJuego1CL3y0Q6XgtgwKTem8e626V37s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f0JmK2PhjZuCYZUoylR+d8qci6xsazG4ODJ55LNl+kPWgxx1niJDCcPk/CK+8KwPr4GmiKdYqTVmTo42EeF3uaUKOHWzxr8os1FajwYf4itwrsQ05q3Od3Oc/Vbl8tngjU648orf8MbJchTxYrr1zazqQ2ZcQUkbzi9UG3DBNiPmEanZ4jBG56BZz/5lRajTEeMk0czUIql0/w2pLqF9gt5ajRN9+JHwF/WIYIo6EA0BhiLL6LvVUO34Rdd7FYG6gcs8BKgwcwCOd2Xa60dMT8ihYrIMlX7BCiQCbJf8LgVyMMY4nVOA+WyaCN9ddPzEqezjtlCTCMZ8focFhEAHcA==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JeEdSaNS; dkim-atps=neutral; spf=pass (client-ip=172.234.252.31; helo=sea.source.kernel.org; envelope-from=sashal@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JeEdSaNS;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=172.234.252.31; helo=sea.source.kernel.org; envelope-from=sashal@kernel.org; receiver=lists.ozlabs.org)
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hs08k1XrDz2yQl
	for <linux-erofs@lists.ozlabs.org>; Sat, 26 Sep 2026 04:48:38 +1000 (AEST)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A5C03409DE;
	Fri, 25 Sep 2026 18:48:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C508B1F000FF;
	Fri, 25 Sep 2026 18:48:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790362115;
	bh=WrgWRdYmbvngJuego1CL3y0Q6XgtgwKTem8e626V37s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JeEdSaNSef922NokpeOobJ0BVHhX7Dvt1FQDeZ05iBGsjwIVL4b0Hlq70n6Pc/hJf
	 +hKDFnRaa8RO9EbNVnuo2vjAqhcVAjB2/YBgZNbXGSVnUU2H80Euds/ktKZQVLqGQ2
	 cCXPK7OwhhMNrb5g8dyNnJuSAO0T/oIC4dYU79Z3rNvDgS08SsvU8ho63HNIT8yaJ7
	 ZWf8KDXr+B+vSWdXOYMkLoCRi4932bgbQ3AM+QzmKfvrTyTs3gcKrzbObFJDDZYJv4
	 M+8RNUfInHPoiIuO+9BERi0OCQDQ1qUd0W6wRQbEw3vFfNtdMjR2hR/+5CRweYR4w3
	 H5zEFeJW0B3PA==
From: Sasha Levin <sashal@kernel.org>
To: Gao Xiang <xiang@kernel.org>
Cc: Sasha Levin <sashal@kernel.org>,
	Artem Dinaburg <artem@trailofbits.com>,
	stable@vger.kernel.org,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Chao Yu <chao@kernel.org>,
	Yue Hu <huyue2@coolpad.com>,
	Jeffle Xu <jefflexu@linux.alibaba.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	linux-erofs@lists.ozlabs.org,
	linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org,
	Sandeep Dhavale <dhavale@google.com>,
	Will Shiu <will.shiu@mediatek.com>,
	Gao Xiang <hsiangkao@linux.alibaba.com>,
	Alexandre Mergnat <amergnat@baylibre.com>
Subject: Re: [PATCH 6.1.y] erofs: Fix detection of atomic context
Date: Fri, 25 Sep 2026 14:48:05 -0400
Message-ID: <2026-09-25-daily-reply-0013-re-erofs-atomic-context-5-15@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <arYacJ7KdcTO7UDQ@MacBookPro.fritz.box>
References: <20260922200448.27724-1-artem@trailofbits.com> <arSoAUX4jDzgY-rG@MacBookPro.fritz.box> <2026-09-24-daily-reply-0004-re-erofs-atomic-context-follow-up@kernel.org> <arYacJ7KdcTO7UDQ@MacBookPro.fritz.box>
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
Content-Transfer-Encoding: 8bit

> btw, just correct a bit 5.15.y also has commit 648f2de053a8 ("erofs: use
> workqueue decompression for atomic contexts only"), so
>
> upstream commit 12d0a24afd9e ("erofs: Fix detection of atomic context")
> upstream commit c99fab6e80b7 ("erofs: fix atomic context detection when !CONFIG_DEBUG_LOCK_ALLOC")
>
> are also needed for 5.15.y.

Right, both are already queued for 5.15 (and for 6.1).

-- 
Thanks,
Sasha

