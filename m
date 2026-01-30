Return-Path: <linux-erofs+bounces-2244-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E3E7FD49C6F
	for <linux-erofs@archiver.kernel.org>; Fri, 30 Jan 2026 07:54:39 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4f2Svy30Qjz309H;
	Fri, 30 Jan 2026 18:54:38 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=115.124.30.113
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1769759678;
	cv=none; b=ca38QbpsjDjhQgt0r0GEWbnXd5k0zzVXbeX4/vLX5IgGCti4EUIaQkprLmELAjhrxy6deXzeJq9yh7xlHvedP6+KpERDzNhIwru3X/NZqO77BopbBJb/VweKh1f7yryF6z4QMXUHAplBUizDPQU5YNLIEarOKlZ49qAIpu7eYtHF3MtBcGME4mW/jDimxU3dtwYYolZvwIrT79at3zo0aQajk9zc2t3Yadb6r39jQl8iQHbqr3SPTnS6ZH63X867BBtTKde0gk5VW8BltI3PNEXaC3f2ZRDt6lNMmiRD61HtgH2ctUm8y2AvWUJpjJfWGCaiaGwT/wk0W9Bg3EX3MQ==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1769759678; c=relaxed/relaxed;
	bh=MGY4VwLN5JRVmFEubrf4XAEAuNVa/H718nLHx6PFxNg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Zbvnbn0FxqkBut/EJwAGCxvJOFpdZhwc6F2NLKCRx/8R1ZCsCSvJuWOf1ZiUDYjnij7PzNgi6lYVc+fpfkV+Y6C+oajIuZbPdak9KCh7oQriAFsoqDgYNOt8ClD1jO7I6DaeDIaZ5ykc2PXGgh7qlULt+Tfdc4Df0b2fuM1MZ78csqfLPdOojaPETM6pR+H7W2GYWVd9SCYL1v2u4QVvaPw8LeKct1GrWeNcOzt0Gb9fVEcQFGPrqiVITIEmlR7z0hAOuRo9zRVDH9YHX7Q4vcuHs5gbgZCzsiyr8lZ+hzxqrPA0OVrz184J8/2JTo6FWTJYlx/w/KuURpK6dXMHnw==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=AQTDzqFv; dkim-atps=neutral; spf=pass (client-ip=115.124.30.113; helo=out30-113.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org) smtp.mailfrom=linux.alibaba.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=AQTDzqFv;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=linux.alibaba.com (client-ip=115.124.30.113; helo=out30-113.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org)
Received: from out30-113.freemail.mail.aliyun.com (out30-113.freemail.mail.aliyun.com [115.124.30.113])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4f2Svv45hcz2xQs
	for <linux-erofs@lists.ozlabs.org>; Fri, 30 Jan 2026 18:54:33 +1100 (AEDT)
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1769759668; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=MGY4VwLN5JRVmFEubrf4XAEAuNVa/H718nLHx6PFxNg=;
	b=AQTDzqFvcf0al4+00touFI0JW5kKF2510HIBMg4dZqGSNi6TAXmThGQiffSjgDGXnaq3ZX9LUjEfii5aKRl612ejhHIeTLUdFBgK91dcqTaI5lfAJfr/oqxRH8z6ZrHcORSa+R6ghkbjnmZbXzIE2Zyw1FIyRUvfXwM2GMo8YHg=
Received: from x31i01179.sqa.na131.tbsite.net(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0WyA00vO_1769759662 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 30 Jan 2026 15:54:26 +0800
From: Gao Xiang <hsiangkao@linux.alibaba.com>
To: linux-erofs@lists.ozlabs.org
Cc: LKML <linux-kernel@vger.kernel.org>,
	oliver.yang@linux.alibaba.com,
	Gao Xiang <hsiangkao@linux.alibaba.com>
Subject: [PATCH v2] erofs: handle end of filesystem properly for file-backed mounts
Date: Fri, 30 Jan 2026 15:54:22 +0800
Message-ID: <20260130075422.2043813-1-hsiangkao@linux.alibaba.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20260130073421.2012225-1-hsiangkao@linux.alibaba.com>
References: <20260130073421.2012225-1-hsiangkao@linux.alibaba.com>
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

I/O requests beyond the end of the filesystem should be zeroed out,
similar to loopback devices and that is what we expect.

Fixes: ce63cb62d794 ("erofs: support unencoded inodes for fileio")
Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
---
v2:
 - rearrange erofs_fileio_ki_complete() a bit.

 fs/erofs/fileio.c | 20 ++++++++------------
 1 file changed, 8 insertions(+), 12 deletions(-)

diff --git a/fs/erofs/fileio.c b/fs/erofs/fileio.c
index c1d0081609dc..43998fe1cce1 100644
--- a/fs/erofs/fileio.c
+++ b/fs/erofs/fileio.c
@@ -24,21 +24,17 @@ static void erofs_fileio_ki_complete(struct kiocb *iocb, long ret)
 			container_of(iocb, struct erofs_fileio_rq, iocb);
 	struct folio_iter fi;
 
-	if (ret > 0) {
-		if (ret != rq->bio.bi_iter.bi_size) {
-			bio_advance(&rq->bio, ret);
-			zero_fill_bio(&rq->bio);
-		}
-		ret = 0;
+	if (ret >= 0 && ret != rq->bio.bi_iter.bi_size) {
+		bio_advance(&rq->bio, ret);
+		zero_fill_bio(&rq->bio);
 	}
-	if (rq->bio.bi_end_io) {
-		if (ret < 0 && !rq->bio.bi_status)
-			rq->bio.bi_status = errno_to_blk_status(ret);
-	} else {
+	if (!rq->bio.bi_end_io) {
 		bio_for_each_folio_all(fi, &rq->bio) {
 			DBG_BUGON(folio_test_uptodate(fi.folio));
-			erofs_onlinefolio_end(fi.folio, ret, false);
+			erofs_onlinefolio_end(fi.folio, ret < 0, false);
 		}
+	} else if (ret < 0 && !rq->bio.bi_status) {
+		rq->bio.bi_status = errno_to_blk_status(ret);
 	}
 	bio_endio(&rq->bio);
 	bio_uninit(&rq->bio);
@@ -48,7 +44,7 @@ static void erofs_fileio_ki_complete(struct kiocb *iocb, long ret)
 static void erofs_fileio_rq_submit(struct erofs_fileio_rq *rq)
 {
 	struct iov_iter iter;
-	int ret;
+	ssize_t ret;
 
 	if (!rq)
 		return;
-- 
2.43.5


