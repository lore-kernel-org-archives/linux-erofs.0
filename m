Return-Path: <linux-erofs+bounces-4684-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4FCCACA9EC0
	for <linux-erofs@archiver.kernel.org>; Fri,  9 Oct 2026 17:10:33 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4j1YK33Syjz2yr0;
	Sat, 10 Oct 2026 04:10:31 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=172.105.4.254
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1791565831;
	cv=none; b=gVDTkzogGf8LEU6yTDHgdbTPxowHqH/TATJFKa4bKLvRe62sFcqBsyFBNjiWL2TOURPQq0VoZjMbXhoVcMYX8DXgsiZIJzaQLh2ZlaOMtOcfoZtm31uKMsaYym/ax+HPg5tPzULH2SUSxywK2voK67Q5y2/8tG7V2TSbFIjZT5UMGxJ7+qJXNqSsEd6ae6qFtsnD3leEq5SmOTL/A1ZKCOELRvVgvACi46YzQ7TGsFEJQxTMDk6Q1h7am5QBabBIjiHFLzDyhUcdoX3gbYh1agKgCODC2A/pNgrLnPNC0J7IiaxttNSe0x0Ys9om2RC7/kiWDMyfO8q/4gjpYMXIOw==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1791565831; c=relaxed/relaxed;
	bh=dmxj2lj4Q4GvWHDzZDgnLPWqXygKdSJybIHJoEn8ViA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KDBOmPVUTn0iV1H9v08U2SCkcNmW/Ly5VJWxdLi5KR99Mwek5eEqiyQZqZzGYILTbriCQxMNxt77jk74aX3IBQ9hgZfZULo5SMO7x301C4N2kQgSv0NDJchFHllNnorRewMAdcT2mZxkFZ3Zq3f6Ryiem6DKXDNij1F3QEseI8v7WgYU092jDrb8LFUgY7aRgaYeiGrRK1Mk90CgWZglufS9UhxPEhpNUZ8EdGKjEonlaeCl3b+xyrNdTWzABy0v4Ky00EpndVJJbImWTv/DkspbXPhbDJ3X91US/KMpfmBgzLp6COVOT83YUzyzJWU/D/AZ0P3N2qqsrLhJ50dq3g==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HGq10ct+; dkim-atps=neutral; spf=pass (client-ip=172.105.4.254; helo=tor.source.kernel.org; envelope-from=sashal@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HGq10ct+;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=172.105.4.254; helo=tor.source.kernel.org; envelope-from=sashal@kernel.org; receiver=lists.ozlabs.org)
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4j1YK24Fzkz2y8r
	for <linux-erofs@lists.ozlabs.org>; Sat, 10 Oct 2026 04:10:30 +1100 (AEDT)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id E603860AB9;
	Fri,  9 Oct 2026 17:10:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17C381F0089B;
	Fri,  9 Oct 2026 17:10:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791565827;
	bh=dmxj2lj4Q4GvWHDzZDgnLPWqXygKdSJybIHJoEn8ViA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HGq10ct+EGdQoMvMBnywt/4E7GKhC8W4H2urVDdT96H7Pl19V8fziYa0MfjzAVDsg
	 IMOErbNyGL6oVc1dLbFfmJcaRzyqhXpkpJ4OcaaZO8wp4TuUUioUx/BSEFQ5go6/2e
	 zywZmP1UmU82nu3nTiAQ1+ETG/ft0eWFL9RBalI2bLt5eps2xQ0W9RF3Cm+OPpa3yC
	 hpwx/ikMuIohaYGIzMjQ7bqmDPUToTfiFbTGpfw8nHpnSQQ9EMtmH9rg+bqGzYI6ir
	 EbitcYjKQn5AgkaaV7VpVztpC8zp/nllGCmDzKDs84cTMi1RMDXyIUq5gHSQto0bzM
	 aCV4brDvHbNdg==
From: Sasha Levin <sashal@kernel.org>
To: stable@vger.kernel.org
Cc: Sasha Levin <sashal@kernel.org>,
	Artem Dinaburg <artem@trailofbits.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Gao Xiang <hsiangkao@linux.alibaba.com>,
	Robert Morris <rtm@csail.mit.edu>,
	Hongbo Li <lihongbo22@huawei.com>,
	Gao Xiang <xiang@kernel.org>,
	Chao Yu <chao@kernel.org>,
	Yue Hu <huyue2@coolpad.com>,
	Jeffle Xu <jefflexu@linux.alibaba.com>,
	linux-erofs@lists.ozlabs.org,
	linux-kernel@vger.kernel.org,
	Yue Hu <zbestahu@gmail.com>,
	Sandeep Dhavale <dhavale@google.com>,
	Hongbo Li <hongbohbli@tencent.com>,
	Chunhai Guo <guochunhai@vivo.com>
Subject: Re: [PATCH 6.6.y 0/2] erofs: backport CVE-2025-68251, CVE-2026-53015
Date: Fri,  9 Oct 2026 13:09:45 -0400
Message-ID: <2026-10-09-1-daily-reply-0008-erofs-compact-index-6-6@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261008190830.97970-1-artem@trailofbits.com>
References: <20261008190830.97970-1-artem@trailofbits.com>
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

> Could you please consider this series for 6.6.y?

Queued the series for 6.6, thanks.

-- 
Thanks,
Sasha

