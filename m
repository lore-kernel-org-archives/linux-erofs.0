Return-Path: <linux-erofs+bounces-4599-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 014C2C9830D
	for <linux-erofs@archiver.kernel.org>; Thu, 24 Sep 2026 00:21:25 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hqvdb5WCKz2yqw;
	Thu, 24 Sep 2026 10:21:23 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2600:3c0a:e001:78e:0:1991:8:25"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1790209283;
	cv=none; b=VObUR9ctikmtP/w0gPmY9wdZ7Gch1n+lxlaG50EFP3ej5bNuEOP7bYmK08HtOs0pkYBaZdbsoFzqZsO1P5XN95AB/k4cWGRcCPChnhw3k/+0QcIDrqgMmhjLH0Y4SaW2fd6Ib8d8hbjXlb4Gfhf9KUSd6Hp2zmS1AyWpZR6TMBWV5fAPdXwB5MWhMCtH8fuMpXWI2shE3A/oYyQzQQOjqZurB3BM8ljUDKKZXQdxiX6T2EpcAV0+e0X5SAETpJGf3kp/ZNNnn2uVS9dYOtulYt5J7LtniVD+tXkk7+imKGxkw1z9RuljGJwkNweiHnoQ6eYSIk+yfhHMvTnkafYU7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1790209283; c=relaxed/relaxed;
	bh=m+GWLIwFpPKVB13qnLI5Bw0feO/05wfn2yVZo+nfxu0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jW2KZJyLdfPN4YHSG+lDWW5Ho4sllZGv5T6RnQQxEMVKd/aSHq21ojqcZrAjlNGbMDDPBjNo6F8XmXJ9z/rvksMrF7LhIoxB24fMl5++VTlvHbpkjB4+SldHG0czjxtxbQEDdyXEhldVUXAcCi/sHBNTYumyl4ReBel11NFi8V+xX4jUiTZ9cN4G0m3v6AFgM3aArl/68neuL7MRYxSYyLuIys85KpKNVPW82kaonYodoJZZP1tgUsP/ZeBU3Tu9IYu0GCiXXPL9X90ip7qmyWhfte5wTCNlPgAsZKt1STrsLwX4Sj5L7EVYQFqosLjF3BXBh6HcsNoAgGksPeG76A==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jzQSwC+w; dkim-atps=neutral; spf=pass (client-ip=2600:3c0a:e001:78e:0:1991:8:25; helo=sea.source.kernel.org; envelope-from=sashal@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jzQSwC+w;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=2600:3c0a:e001:78e:0:1991:8:25; helo=sea.source.kernel.org; envelope-from=sashal@kernel.org; receiver=lists.ozlabs.org)
Received: from sea.source.kernel.org (sea.source.kernel.org [IPv6:2600:3c0a:e001:78e:0:1991:8:25])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hqvdZ5Fj4z2yD3
	for <linux-erofs@lists.ozlabs.org>; Thu, 24 Sep 2026 10:21:22 +1000 (AEST)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 4E88943F94;
	Thu, 24 Sep 2026 00:21:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D6D51F00893;
	Thu, 24 Sep 2026 00:21:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790209279;
	bh=m+GWLIwFpPKVB13qnLI5Bw0feO/05wfn2yVZo+nfxu0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jzQSwC+wFeBtS3T3yLqWeaGdao287ksBdEwlubwx+JX5xLwQLvUNZ+EawYWmxUD/4
	 JCcKYmkiwPbIa3FOtjrOz2R5CUcohmmLZm+DWVynYrMzbY8uimDb8mvqGV/QVGyq9h
	 VjAZEcj2bFnzbkp8VGW/DQqAzI/9sVwQFNt6lzMzyUwQRCsIdtF2CmBOiXtzFy8C/4
	 J01wkM60/5ReUW5kEWssq2IHUpnzyuwHfQQ59DiwQHPOXPiSuRzbFLzpJgDf7xRtk8
	 qEJsmypvEI7V8fZxr4jx7Ey/Iy124DamTXLiPtz8nwUbAsG6/E2XyiJ1iPdGjUphpd
	 xB9qG+32pzRoQ==
From: Sasha Levin <sashal@kernel.org>
To: stable@vger.kernel.org
Cc: Sasha Levin <sashal@kernel.org>,
	Artem Dinaburg <artem@trailofbits.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Gao Xiang <xiang@kernel.org>,
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
Date: Wed, 23 Sep 2026 20:21:00 -0400
Message-ID: <2026-09-23-daily-reply-0011-re-erofs-atomic-context-detection-6-1@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260922200448.27724-1-artem@trailofbits.com>
References: <20260922200448.27724-1-artem@trailofbits.com>
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

> [ Backport to 6.1.y: the source change is unchanged; only its location
>   in z_erofs_decompress_kickoff() differs. ]

Queued for 6.1, thanks.

-- 
Thanks,
Sasha

