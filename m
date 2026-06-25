Return-Path: <linux-erofs+bounces-3757-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A418ECDE001
	for <linux-erofs@archiver.kernel.org>; Thu, 25 Jun 2026 12:08:31 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4gmHdT36b1z2ySg;
	Thu, 25 Jun 2026 22:08:29 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2607:7c80:54:3::133"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1782389309;
	cv=none; b=k8Jozyua4MGcEkXjHy0XCAuhbg6yuIbYG6imYxHuqfrpdA2vmkvxdpU8YSt+4wmvpCDt+XRVC4QtsawRA9QjgLcjUfguh2XaebyOLXkMjxYB8boO0mdIrrRqNb4oyhRYNUIDnwRsrfWgsl65Qln6bzAg+yvDjQ5d/k+hLbWzxs2fRF1lANdjQ4MeQlA78ydLIVtLTjZp7NR9EWYMxrjwYWyS0GGUZqnB6cds8p6Zy1a7R/MJMnDqrjG/uyFU43DFK4DEaDdEZ3H3dx/1i5T3qoahGgWPAiervv7BwNEN54Jp0DRj07gbEM3UxD/T9cMm8jAh7tTrimbH+MgFJvwTog==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1782389309; c=relaxed/relaxed;
	bh=v898+QkB1UDAKWiTlcnqdkDW1C2WbAo9fOIytjJGE+U=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=K0iBYMQQM99C+OXZ/GZRK0qCrlLqSvbMOo4xbGdIfke1JWEG0gBAM1nrtmMIzuFs6wb3X5ekwA//Nk+7bGwTxqMAMhSDrcvcYPC3NAaMWByHw3Th5+M8sgg0WjdRkg4HHAWDPwzIPC3F0rT07cdy0DjwBE1nqZG4zTPMfiujssQwpk9hVEkj/1ikpTak5rSbYUSKrKWbrs12vWlg7DWXFHUH2+dpQPYj8+VdUyEn3bRf/2fnUqxZxPtMznKCi4vllX5nr1QH9S4HMN/v1S3+0swixQ6BRZI5vk6Nic9ggfYMW09bx6ynK8SNRvSwzPRtRPsOldlfMKiW9/TsGe355Q==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=fail (p=none dis=none) header.from=lst.de; dkim=pass (2048-bit key; secure) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=0q71m/R+; dkim-atps=neutral; spf=none (client-ip=2607:7c80:54:3::133; helo=bombadil.infradead.org; envelope-from=batv+469c0735132da6312b2c+8341+infradead.org+hch@bombadil.srs.infradead.org; receiver=lists.ozlabs.org) smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: lists.ozlabs.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; secure) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=0q71m/R+;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=none (no SPF record) smtp.mailfrom=bombadil.srs.infradead.org (client-ip=2607:7c80:54:3::133; helo=bombadil.infradead.org; envelope-from=batv+469c0735132da6312b2c+8341+infradead.org+hch@bombadil.srs.infradead.org; receiver=lists.ozlabs.org)
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4gmHdM5YLlz2y8p
	for <linux-erofs@lists.ozlabs.org>; Thu, 25 Jun 2026 22:08:19 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=v898+QkB1UDAKWiTlcnqdkDW1C2WbAo9fOIytjJGE+U=; b=0q71m/R+GeSiQUd/K98feKFlYc
	P34kbrii86+FHhdh5PQ8b3o7/0unex/bdkTL+NhIK4csq9mCsMQI6o6Z+52/Y+ryWfHyFN9APSTvl
	lQ+KJ3dURUm8SXydsx5x1qAJYfSFVw5+TBoMoD8RfmNZL2edJ6/T909UcQY9l55QxVfAC5/b1mLfR
	zNkWv9wXsaOAxDQMDMupYXjqn4v9vLerhhUeGwopSGVAgqCEXprvpZoAFkU11mgQLhTR7kWu+gEtb
	xfuu01/gNSNJzytRdfkV54k/NXtiIXybpRlGkE6ofOp3fWygkg3oFzEzS7NxCFj1E8GJU1vz60uCL
	lVIx6W+Q==;
Received: from 2a02-8389-2301-9f00-3397-c9eb-6d8a-9179.cable.dynamic.v6.surfer.at ([2a02:8389:2301:9f00:3397:c9eb:6d8a:9179] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wcisM-000000099hh-0knr;
	Thu, 25 Jun 2026 12:08:10 +0000
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
Date: Thu, 25 Jun 2026 14:07:55 +0200
Message-ID: <20260625120803.2462291-1-hch@lst.de>
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

