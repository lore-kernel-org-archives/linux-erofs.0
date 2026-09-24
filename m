Return-Path: <linux-erofs+bounces-4602-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 62A4AC98318
	for <linux-erofs@archiver.kernel.org>; Thu, 24 Sep 2026 17:13:40 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hrL5Z2nhGz2yD3;
	Fri, 25 Sep 2026 03:13:38 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2600:3c04:e001:324:0:1991:8:25"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1790270018;
	cv=none; b=X3rxc7cmu1hxXAxBkC1D8+q1QKkBZdsHOAuZSjexXmxxCoDxjzfaktP21BH4SuwFnX9KyrsAkLoctOi/2NOhSqHep2Qwcxte0EuCgnjLeA51cPu1vW9ZyCuFQuTQ1nDYqTWj8u75sKYz7GzYOFjltwx550S9/UjxZSsHT+PipxALoWduXKLkIYo/HYPFv411z42RTqmlkKN1+H3+nyejOitSAW8HN4Gtrcqtq1miAlifu88gaOQduZ5Di0q8kgYC5zN3ZNULhZLVyVAqCOWDylVOHz8nmTWHeG84DmnuYfVS6UKfzktq3brvA5DMMM1SNJhUdWaeVsy1autvbRDg1Q==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1790270018; c=relaxed/relaxed;
	bh=KVynk1J9ZIK4NwAOt2xgFc/0dJmWVgfWI4Vto+E1s90=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=J+Td3WEOPY0J4gAk6U96KEliIq+k0qB/+YSKu5kjpoxAE93gIGxgINowUKeZZcG4YgzJrooyOAFs4Jf3rYPHbJ6XLkNbziFDTwid30DjLsy8OnygVylqR1Fpie4PJgBy305O0kGMeDV5FK8m0L1y4DOXDX2q62+QPs6w12pbz43cD4tZt4j8T6EZMe8AfJX/YINynisgXHFoOBMD8CyVJ+UoEutOFhA6y08oTEnOlv/b7gFHp8mQhbFmkb+3UIIgtpYF4CmYlBP60JRlcP1/WPGixxG+QAmXR1XAon9bCZs38njjkfubeAJCFJ4jOnD6Yq1bQU75TXIyszAg7kdBEg==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Xkw8QSU1; dkim-atps=neutral; spf=pass (client-ip=2600:3c04:e001:324:0:1991:8:25; helo=tor.source.kernel.org; envelope-from=sashal@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Xkw8QSU1;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=2600:3c04:e001:324:0:1991:8:25; helo=tor.source.kernel.org; envelope-from=sashal@kernel.org; receiver=lists.ozlabs.org)
Received: from tor.source.kernel.org (tor.source.kernel.org [IPv6:2600:3c04:e001:324:0:1991:8:25])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hrL5Y4TzYz2y7Y
	for <linux-erofs@lists.ozlabs.org>; Fri, 25 Sep 2026 03:13:36 +1000 (AEST)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 8DBA8601E4;
	Thu, 24 Sep 2026 17:13:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 061D81F000FF;
	Thu, 24 Sep 2026 17:13:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790270014;
	bh=KVynk1J9ZIK4NwAOt2xgFc/0dJmWVgfWI4Vto+E1s90=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Xkw8QSU1DY28gW4aTKgq8Pup73EjI4O7BSOXGjhDPEgAPnPPEsRBp5iQmpvThMv1V
	 ATK/P3jPW9Guz9FUWdPM4IjfGc0CVyYFCRPUPXCH8gYjRtcpNhygJ284BUKcnV0JDj
	 8stpYgR4uUH/Ev2aJldIKvTobxf9kQG1jiAuC8LR8jR7995st6DWQVej3D6d5ujjU5
	 /Sax2mW6uVzLxG+jzqtxxDJdIG58XWY1IJmk/AInYGd59Xn+dBXld2IpTFdS3OanhS
	 nUjT8SWCAtAtwPIS06kRVAX46BPDm/J+IlNg0mK/o/RSwWHelir/bSVoIWDRSREQvc
	 seiU7Ut/houZg==
From: Sasha Levin <sashal@kernel.org>
To: gregkh@linuxfoundation.org
Cc: Sasha Levin <sashal@kernel.org>,
	stable@vger.kernel.org,
	xiang@kernel.org,
	chao@kernel.org,
	zbestahu@gmail.com,
	jefflexu@linux.alibaba.com,
	dhavale@google.com,
	lihongbo22@huawei.com,
	guochunhai@vivo.com,
	yinxin.x@bytedance.com,
	linux-erofs@lists.ozlabs.org,
	Wenwu Hou <hwenwur@gmail.com>
Subject: Re: [PATCH stable] erofs: fix large folio race in erofs_fscache_req_complete
Date: Thu, 24 Sep 2026 13:13:20 -0400
Message-ID: <2026-09-24-daily-reply-0001-re-erofs-fscache-large-folio-race@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260923084823.496741-1-hwenwur@gmail.com>
References: <20260923084823.496741-1-hwenwur@gmail.com>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

> For stable branches: 5.19.y, 6.0.y–6.19.y, and 7.0.y.

Queued for 6.18, 6.12 and 6.6, thanks. 6.1 doesn't need it, since erofs
doesn't enable large folios there.

-- 
Thanks,
Sasha

