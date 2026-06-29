Return-Path: <linux-erofs+bounces-3782-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 001A1C43458
	for <linux-erofs@archiver.kernel.org>; Mon, 29 Jun 2026 12:18:28 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4gplg73Ptnz2yZ8;
	Mon, 29 Jun 2026 22:18:27 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2607:7c80:54:3::133"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1782735507;
	cv=none; b=jd4TomURh5gQy7eIfHe6IoexvN1Gr5nROy5ZvITw2Wgwrf4iPqHiFWh32nr/7rB4pST6E0L91jxIa5ZOknAKQ9kt4SsFPDpMq3sAKBqk8PpzXy+oG/WO68uwNUdkXAudjGuOeRH9douPTpYgOmx2vA+TcbFd5gOgdfMna035244yxNXMmAZ47LenGgkF4NhGlwwHmcRYLX3LGnuIHtZLfRfyBYqqXSX5NYjWE4chCDdDzBg47ZiKBXxoUOFY9tAd5BPEu3fH0StfxRdP2mZiE9kWZU8th0VEwrjieRH6BIt+7kJERkQ2C00yMmZk/xDFuKMZkdE1vIqwBISQCyszbg==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1782735507; c=relaxed/relaxed;
	bh=v898+QkB1UDAKWiTlcnqdkDW1C2WbAo9fOIytjJGE+U=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=DD6ehO91hSk8d1bVIHFw3uj5rL7c8j33ugXg4Z/x9rtrdJ81jaGYlhSBX87OLuRjHvT1Z+dZfWNWKHt//u+gqypybzHj2JnN+bfHrAA+7X4M4kbBUvRvVyRCiIp66qPdnkUKDZ9UedbtkSKw2mR6urAbH2hfz1GWqWxyZnL4nBY8WNlkcnczJ6jQOOitWK24G9ysFs0lVXcCcyPaO023Kpp3ykTl4GuoTBKrKzA4x15NJFJyxjwOtsgEydJHQavRtBH49c0qZIzNavJJDb9Hbm3ticPHzWfSyc5rd3mPZGRxoy1xODN37UZVJxkjfICseWKoHidNkv1I2IMh3fn0dA==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=fail (p=none dis=none) header.from=lst.de; dkim=pass (2048-bit key; secure) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=Xa/6fOwI; dkim-atps=neutral; spf=temperror (client-ip=2607:7c80:54:3::133; helo=bombadil.infradead.org; envelope-from=batv+90a5730460baaf6f6760+8345+infradead.org+hch@bombadil.srs.infradead.org; receiver=lists.ozlabs.org) smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: lists.ozlabs.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; secure) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=Xa/6fOwI;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=temperror (SPF Temporary Error: DNS Timeout) smtp.mailfrom=bombadil.srs.infradead.org (client-ip=2607:7c80:54:3::133; helo=bombadil.infradead.org; envelope-from=batv+90a5730460baaf6f6760+8345+infradead.org+hch@bombadil.srs.infradead.org; receiver=lists.ozlabs.org)
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4gplg63Mr8z2xYh
	for <linux-erofs@lists.ozlabs.org>; Mon, 29 Jun 2026 22:18:04 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=v898+QkB1UDAKWiTlcnqdkDW1C2WbAo9fOIytjJGE+U=; b=Xa/6fOwIwXnUiihMQCuFbBCt1l
	LpE+6eJtf9J9rUjXsdqp/TyDk9l+UMjKFhyiR7+feG1+zLWMmIcL34TdcZT5hai0zCepUx7yepQJo
	qBjiMd9vE7vLxOEKVmG7z0AAzhohqY4dsUDfSS3f9hx4gGrN8iil0CCpM7qYTUIlfvfQKjegwXYfc
	m1fEO120AVKanyGRkZJzZ5hf12yrWyTjPBEA0Uvfx9RUZNcGsgk68qJNDqAKTS6Q5AZcog0yJC1X1
	FkziMp68z/OvI8z43NZ36VNCqkc08xZm5Jv0uzi2lEuAUx1VsR3DPiTgNMzCtfx/FTcAMV4ytIEA3
	XxcngfRw==;
Received: from clnet-b08-202.ikbnet.co.at ([83.175.123.202] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1weAw0-0000000EWzb-1HZn;
	Mon, 29 Jun 2026 12:17:56 +0000
From: Christoph Hellwig <hch@lst.de>
To: Christian Brauner <brauner@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>
Cc: Kelu Ye <yekelu1@huawei.com>,
	Yifan Zhao <zhaoyifan28@huawei.com>,
	Ritesh Harjani <ritesh.list@gmail.com>,
	Joanne Koong <joannelkoong@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sungjong Seo <sj1557.seo@samsung.com>,
	Hyunchul Lee <hyc.lee@gmail.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Miklos Szeredi <miklos@szeredi.hu>,
	fuse-devel@lists.linux.dev,
	ntfs3@lists.linux.dev,
	linux-erofs@lists.ozlabs.org,
	linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Subject: don't build bios/contexts over multiple iomaps v3
Date: Mon, 29 Jun 2026 14:17:37 +0200
Message-ID: <20260629121750.3392300-1-hch@lst.de>
X-Mailer: git-send-email 2.53.0
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
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Hi all,

this patch changes how iomap submits bios for reads.  The old behavior
to build up bios across iomap was already considered problematic for
a while, but we now ran into a erofs bug because of it, so it's time
to finally fix it.

It would be great to get the fix into 7.2 as the fixed bug can be
triggered by users.

Changes since v2:
 - drop an unused argument
 - make sure we submit for the same iteration to not leave a landmine
   for future changes

Changes since v1:
 - don't submit fuse context after each iteration
 - consolidate some code to support the above
 - fix a bug in the fs PI support found while doing the above

