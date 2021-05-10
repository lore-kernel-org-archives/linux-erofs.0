Return-Path: <SRS0=3GSP=KF=lists.ozlabs.org=linux-erofs-bounces+linux-erofs=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12983C433B4
	for <linux-erofs@archiver.kernel.org>; Mon, 10 May 2021 07:23:24 +0000 (UTC)
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 45F1B61449
	for <linux-erofs@archiver.kernel.org>; Mon, 10 May 2021 07:23:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 45F1B61449
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Received: from boromir.ozlabs.org (localhost [IPv6:::1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4FdswT6YxLz2yxB
	for <linux-erofs@archiver.kernel.org>; Mon, 10 May 2021 17:23:21 +1000 (AEST)
Authentication-Results: lists.ozlabs.org;
	dkim=fail reason="signature verification failed" (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20201202 header.b=qxAQkn6o;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized)
 smtp.mailfrom=kernel.org (client-ip=198.145.29.99; helo=mail.kernel.org;
 envelope-from=xiang@kernel.org; receiver=<UNKNOWN>)
Authentication-Results: lists.ozlabs.org; dkim=pass (2048-bit key;
 unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256
 header.s=k20201202 header.b=qxAQkn6o; 
 dkim-atps=neutral
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by lists.ozlabs.org (Postfix) with ESMTPS id 4FdswQ3tCpz2yYV
 for <linux-erofs@lists.ozlabs.org>; Mon, 10 May 2021 17:23:18 +1000 (AEST)
Received: by mail.kernel.org (Postfix) with ESMTPSA id BADE8613DC;
 Mon, 10 May 2021 07:23:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1620631395;
 bh=p/punnKry+jUpOqI24NkxkVSMa3NR19To6is8YOefy0=;
 h=From:To:Cc:Subject:Date:From;
 b=qxAQkn6oKFaWvwGJvVE/t+Yge0bZYsSL3xFuXhygkxnZGXZZbr5vPIwDmvPYrEM48
 dGtK4hRtC6FcHOGSwiTIe4idGduT0DoXyyTHSmW0RJNvOuWUUJeiYP1vF3h6V46ivr
 /C4jOkenGFq5Bm2bF961tStBp1iMrc1SuX8p5YDPyl09pjY+/seQPRp6NbCzg8oPIE
 U7DsVJ4QL6961V55vNRflGrZF/Qpuy5aqAj3vQUSUGSoomNcojzfXM3p+ZxR62OIqI
 rZy2jc/gHmmlu0fPbWHYWN+ZB9lQC3jlgFr/9Z8/AiPiRBqZJS41yrrxAAmGMkt8oT
 CRSkP2OewjfIg==
From: Gao Xiang <xiang@kernel.org>
To: linux-erofs@lists.ozlabs.org,
	Li Guifu <bluce.liguifu@huawei.com>
Subject: [PATCH 0/4] erofs-utils: prepare for per-(sub)file compression
 strategies
Date: Mon, 10 May 2021 15:22:59 +0800
Message-Id: <20210510072303.4628-1-xiang@kernel.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-BeenThere: linux-erofs@lists.ozlabs.org
X-Mailman-Version: 2.1.29
Precedence: list
List-Id: Development of Linux EROFS file system <linux-erofs.lists.ozlabs.org>
List-Unsubscribe: <https://lists.ozlabs.org/options/linux-erofs>,
 <mailto:linux-erofs-request@lists.ozlabs.org?subject=unsubscribe>
List-Archive: <http://lists.ozlabs.org/pipermail/linux-erofs/>
List-Post: <mailto:linux-erofs@lists.ozlabs.org>
List-Help: <mailto:linux-erofs-request@lists.ozlabs.org?subject=help>
List-Subscribe: <https://lists.ozlabs.org/listinfo/linux-erofs>,
 <mailto:linux-erofs-request@lists.ozlabs.org?subject=subscribe>
Cc: Gao Xiang <xiang@kernel.org>
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs"
 <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>

Hi all,

This patchset mainly provides a new helper z_erofs_get_max_pclustersize()
to prepare for per-file compression strategies, valid pclustersize can be
returned according to detailed data type or access patterns.

In order to do that, compression header is now generated on the per-file
basis as well, which will be also needed for parallel compression in
the future.

Note that
https://lore.kernel.org/r/20210510064715.29123-1-xiang@kernel.org

should be applied after "erofs-utils: compress trailing data for big
pcluster properly" is used or some compress indexes won't be parsed
correctly.

Thanks,
Gao Xiang

Gao Xiang (4):
  erofs-utils: compress trailing data for big pcluster properly
  erofs-utils: reserve physical_clusterbits[]
  erofs-utils: prepare for per-(sub)file compress strategies
  erofs-utils: sync up z_erofs_get_extent_compressedlen()

 include/erofs/internal.h |  1 -
 lib/compress.c           | 91 +++++++++++++++++++++++++++-------------
 lib/compressor.c         |  5 ++-
 lib/zmap.c               | 53 +++++++++++++----------
 4 files changed, 96 insertions(+), 54 deletions(-)

-- 
2.20.1

