Return-Path: <SRS0=0voy=KR=lists.ozlabs.org=linux-erofs-bounces+linux-erofs=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7142C2B9F2
	for <linux-erofs@archiver.kernel.org>; Sat, 22 May 2021 04:35:36 +0000 (UTC)
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id ED06F6138C
	for <linux-erofs@archiver.kernel.org>; Sat, 22 May 2021 04:35:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org ED06F6138C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Received: from boromir.ozlabs.org (localhost [IPv6:::1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4Fn9dL4XkHz308R
	for <linux-erofs@archiver.kernel.org>; Sat, 22 May 2021 14:35:34 +1000 (AEST)
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20201202 header.b=ZnTTkyIL;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized)
 smtp.mailfrom=kernel.org (client-ip=198.145.29.99; helo=mail.kernel.org;
 envelope-from=xiang@kernel.org; receiver=<UNKNOWN>)
Authentication-Results: lists.ozlabs.org; dkim=pass (2048-bit key;
 unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256
 header.s=k20201202 header.b=ZnTTkyIL; 
 dkim-atps=neutral
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by lists.ozlabs.org (Postfix) with ESMTPS id 4Fn9dB5wgXz2xxn
 for <linux-erofs@lists.ozlabs.org>; Sat, 22 May 2021 14:35:26 +1000 (AEST)
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6C0BA6135A;
 Sat, 22 May 2021 04:35:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1621658123;
 bh=JcoRB+IVgckDscyS4nYkfbkfyszokqFDFl0rd5RFT/o=;
 h=From:To:Cc:Subject:Date:From;
 b=ZnTTkyILtN/RPLmGgIVlom9e6bY0IUh+VfT1cfcdi/s8ir2mPFITWJ+XgCnWyhYCp
 GBz/uJFm4YVSs9RXFM0eFikBoYHZ4lTF5KgAkTqzI063M9uijjHCyUn9QVRy/zsFrl
 HrS2Z5zgn4t5PCxZr4cdVOK2LQFyMvcQw3MEtO8+Z6O5a/TlEmV+1TtddJq8waIJtA
 zs+Xg1UeQG2KkJ8svz6anbsjwXdRrSxMIKNgVu+sYSp/+TUNKJttXWNY253glAfxzB
 p/Hs7VQTXPj30rYKbTiJbPfap3nH8bLJux2kHu9JUo0VdVUdnHrl7ORvqcnPqB5j7R
 p6bsMy3KGx2sA==
From: Gao Xiang <xiang@kernel.org>
To: linux-erofs@lists.ozlabs.org
Subject: [PATCH v2 0/3] erofs-utils: prepare for per-(sub)file compression
 strategies
Date: Sat, 22 May 2021 12:34:59 +0800
Message-Id: <20210522043502.11975-1-xiang@kernel.org>
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

This patchset mainly provides a new helper z_erofs_get_max_pclusterblks()
to prepare for per-(sub)file compression strategies, valid pclustersize
can be returned according to detailed data type or access patterns.

In order to do that, compression header is now generated on the per-file
basis as well, which will be also needed for parallel compression in
the future.

randomizing pclusterblks support in debugging mode is also added to
randomize each pcluster size for big pcluster selftest.

Thanks,
Gao Xiang

Gao Xiang (3):
  erofs-utils: prepare for per-(sub)file compress strategies
  erofs-utils: introduce --enable-debug
  erofs-utils: support randomizing pclusterblks in debugging mode

 configure.ac           | 12 ++++++
 include/erofs/config.h |  3 ++
 lib/compress.c         | 85 ++++++++++++++++++++++++++++--------------
 mkfs/main.c            | 50 ++++++++++++++++---------
 4 files changed, 105 insertions(+), 45 deletions(-)

-- 
2.20.1

