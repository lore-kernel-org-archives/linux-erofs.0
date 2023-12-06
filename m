Return-Path: <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4367EC10F04
	for <linux-erofs@archiver.kernel.org>; Wed,  6 Dec 2023 09:11:30 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [IPv6:::1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4SlWqN5hS3z3dH4
	for <linux-erofs@archiver.kernel.org>; Wed,  6 Dec 2023 20:11:28 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=linux.alibaba.com (client-ip=115.124.30.98; helo=out30-98.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org)
Received: from out30-98.freemail.mail.aliyun.com (out30-98.freemail.mail.aliyun.com [115.124.30.98])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4SlWqD1WXwz3cWH
	for <linux-erofs@lists.ozlabs.org>; Wed,  6 Dec 2023 20:11:18 +1100 (AEDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R511e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046056;MF=hsiangkao@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0VxxSRMO_1701853861;
Received: from e69b19392.et15sqa.tbsite.net(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0VxxSRMO_1701853861)
          by smtp.aliyun-inc.com;
          Wed, 06 Dec 2023 17:11:11 +0800
From: Gao Xiang <hsiangkao@linux.alibaba.com>
To: linux-erofs@lists.ozlabs.org
Subject: [PATCH 0/5] erofs: basic sub-page compressed data support
Date: Wed,  6 Dec 2023 17:10:52 +0800
Message-Id: <20231206091057.87027-1-hsiangkao@linux.alibaba.com>
X-Mailer: git-send-email 2.39.3
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
Cc: Gao Xiang <hsiangkao@linux.alibaba.com>, LKML <linux-kernel@vger.kernel.org>
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs" <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>

Hi folks,

Recently, there are two new cases so that we need to add a preliminary
sub-page block support for compressed files;

 - As Android folks requested, Android ecosystem itself is now switching
   to 16k page size for their arm64 devices.  They needs an option of
   4k-block image compatibility on their new 16k devices;

 - Some arm64 cloud servers use 64k page size for their optimized
   workloads, but 4k-block EROFS container images need to be parsed too.

So this patchset mainly addresses the requirements above with a very
very simple approach as a start: just allocate short-lived temporary
buffers all the time to keep compressed data if sub-page blocks are
identified.  In other words, no inplace/cache decompression for
the preliminary support.

This patchset survives EROFS stress test on my own testfarms.

Thanks,
Gao Xiang

Gao Xiang (5):
  erofs: support I/O submission for sub-page compressed blocks
  erofs: record `pclustersize` in bytes instead of pages
  erofs: fix up compacted indexes for block size < 4096
  erofs: refine z_erofs_transform_plain() for sub-page block support
  erofs: enable sub-page compressed block support

 fs/erofs/decompressor.c |  81 +++++++++------
 fs/erofs/inode.c        |   6 +-
 fs/erofs/zdata.c        | 224 ++++++++++++++++++----------------------
 fs/erofs/zmap.c         |  32 +++---
 4 files changed, 169 insertions(+), 174 deletions(-)

-- 
2.39.3

