Return-Path: <SRS0=0voy=KR=lists.ozlabs.org=linux-erofs-bounces+linux-erofs=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33BB2C2B9F2
	for <linux-erofs@archiver.kernel.org>; Sat, 22 May 2021 05:51:40 +0000 (UTC)
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 819A3611AD
	for <linux-erofs@archiver.kernel.org>; Sat, 22 May 2021 05:51:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 819A3611AD
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Received: from boromir.ozlabs.org (localhost [IPv6:::1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4FnCK61zh6z3089
	for <linux-erofs@archiver.kernel.org>; Sat, 22 May 2021 15:51:38 +1000 (AEST)
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20201202 header.b=WbO9lyVr;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized)
 smtp.mailfrom=kernel.org (client-ip=198.145.29.99; helo=mail.kernel.org;
 envelope-from=xiang@kernel.org; receiver=<UNKNOWN>)
Authentication-Results: lists.ozlabs.org; dkim=pass (2048-bit key;
 unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256
 header.s=k20201202 header.b=WbO9lyVr; 
 dkim-atps=neutral
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by lists.ozlabs.org (Postfix) with ESMTPS id 4FnCK262wMz2ydJ
 for <linux-erofs@lists.ozlabs.org>; Sat, 22 May 2021 15:51:34 +1000 (AEST)
Received: by mail.kernel.org (Postfix) with ESMTPSA id 20C4C6138C;
 Sat, 22 May 2021 05:51:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1621662692;
 bh=7ncGXrO9jpLn6Wxq9rotd0dYWyzWpBj0Dcf7EbcbZJQ=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=WbO9lyVrbblSbj4vEXXStouTOfu8cPsiXrkXYyw8smt1mvQ6jztMWDB9o9jaxqv3f
 DSiNE3W7OV0hkmRNgB46wUE7Y1iwC0ZcCfq7Pr68RiiB4jYyTEdJXkH+UrAcisPazi
 EuP9RsbaqD8gKi45Q0b0iv2RkgCWnDTUcsc3GpFrPbkvGwGI6Oz9D+0r/cKPflTyGu
 O+spTaGSP2uiP6+55WuSkjMbez9Iib106xGhLSVIRUcc8nfmdmaAk86NsUTLCVyfT/
 dBEPrT2Db2V8AXr3m7MKUFgSsrvjFUIlle7pFd8MMSGoZkMxJpULRS5iv0Nw/ccPLx
 uVUlD25PGmmFg==
From: Gao Xiang <xiang@kernel.org>
To: linux-erofs@lists.ozlabs.org
Subject: [PATCH 2/2] erofs-utils: README: big pcluster feature update
Date: Sat, 22 May 2021 13:50:57 +0800
Message-Id: <20210522055057.25004-2-xiang@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210522055057.25004-1-xiang@kernel.org>
References: <20210522055057.25004-1-xiang@kernel.org>
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

Add some description for end users to know its usage.

Signed-off-by: Gao Xiang <xiang@kernel.org>
---
 README | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/README b/README
index bcf30e11aa52..567192c8c497 100644
--- a/README
+++ b/README
@@ -74,6 +74,24 @@ In addition, you could specify a higher compression level to get a
 (slightly) better compression ratio than the default level, e.g.
  $ mkfs.erofs -zlz4hc,12 foo.erofs.img foo/
 
+How to generate EROFS big pcluster images (Linux 5.13+)
+~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+
+In order to get much better compression ratios (thus better sequential
+read performance for common storage devices), big pluster feature has
+been introduced since linux-5.13, which is not forward-compatible with
+old kernels.
+
+In details, -C is used to specify the maximum size of each big pcluster
+in bytes, e.g.
+ $ mkfs.erofs -zlz4hc -C65536 foo.erofs.img foo/
+
+So in that case, pcluster size can be 64KiB at most.
+
+Note that large big pcluster size can cause bad random performance, so
+please evaluate carefully in advance. Or make your own per-(sub)file
+compression strategies according to file access patterns if needed.
+
 How to generate legacy EROFS images (Linux 4.19+)
 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 
-- 
2.20.1

