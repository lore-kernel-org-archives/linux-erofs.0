Return-Path: <SRS0=g/qA=ME=lists.ozlabs.org=linux-erofs-bounces+linux-erofs=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3662C07E99
	for <linux-erofs@archiver.kernel.org>; Mon, 12 Jul 2021 12:03:22 +0000 (UTC)
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 8EDBD6044F
	for <linux-erofs@archiver.kernel.org>; Mon, 12 Jul 2021 12:03:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8EDBD6044F
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Received: from boromir.ozlabs.org (localhost [IPv6:::1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4GNj8T2Ldrz303x
	for <linux-erofs@archiver.kernel.org>; Mon, 12 Jul 2021 22:03:21 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized)
 smtp.mailfrom=linux.alibaba.com (client-ip=47.88.44.36;
 helo=out4436.biz.mail.alibaba.com; envelope-from=hsiangkao@linux.alibaba.com;
 receiver=<UNKNOWN>)
Received: from out4436.biz.mail.alibaba.com (out4436.biz.mail.alibaba.com
 [47.88.44.36])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
 (No client certificate requested)
 by lists.ozlabs.org (Postfix) with ESMTPS id 4GNj8M2zSjz2yNp
 for <linux-erofs@lists.ozlabs.org>; Mon, 12 Jul 2021 22:03:14 +1000 (AEST)
X-Alimail-AntiSpam: AC=PASS; BC=-1|-1; BR=01201311R181e4; CH=green; DM=||false|;
 DS=||; FP=0|-1|-1|-1|0|-1|-1|-1; HT=e01e04394; MF=hsiangkao@linux.alibaba.com;
 NM=1; PH=DS; RN=10; SR=0; TI=SMTPD_---0UfXFBmR_1626091362; 
Received: from
 e18g09479.et15sqa.tbsite.net(mailfrom:hsiangkao@linux.alibaba.com
 fp:SMTPD_---0UfXFBmR_1626091362) by smtp.aliyun-inc.com(127.0.0.1);
 Mon, 12 Jul 2021 20:02:48 +0800
From: Gao Xiang <hsiangkao@linux.alibaba.com>
To: linux-erofs@lists.ozlabs.org
Subject: [PATCH v2 0/2] erofs: dio/dax support for non-tailpacking cases
Date: Mon, 12 Jul 2021 20:02:39 +0800
Message-Id: <20210712120241.199903-1-hsiangkao@linux.alibaba.com>
X-Mailer: git-send-email 2.24.4
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
Cc: nvdimm@lists.linux.dev, "Darrick J. Wong" <djwong@kernel.org>,
 LKML <linux-kernel@vger.kernel.org>, Joseph Qi <joseph.qi@linux.alibaba.com>,
 Liu Bo <bo.liu@linux.alibaba.com>, linux-fsdevel@vger.kernel.org,
 Gao Xiang <hsiangkao@linux.alibaba.com>, Liu Jiang <gerry@linux.alibaba.com>
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs"
 <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>

Hi folks,

This patchset mainly adds preliminary EROFS iomap dio/dax support
for non-tailpacking uncompressed cases.

Direct I/O is useful in certain scenarios for uncompressed files.
For example, double pagecache can be avoid by direct I/O when
loop device is used for uncompressed files containing upper layer
compressed filesystem.

Also, DAX is quite useful for some VM use cases in order to
save guest memory extremely by using the minimal lightweight EROFS.

Tail-packing inline iomap support will be handled later since
currently iomap doesn't support such data pattern, which is
independent to non-tailpacking cases.

Comments are welcome. Thanks for your time on reading this!

Thanks,
Gao Xiang

changes since v1:
 - allow 'dax=always' and 'dax=never' to keep in sync with ext4/xfs

Gao Xiang (1):
  erofs: dax support for non-tailpacking regular file

Huang Jianan (1):
  erofs: iomap support for non-tailpacking DIO

 fs/erofs/Kconfig    |   1 +
 fs/erofs/data.c     | 142 +++++++++++++++++++++++++++++++++++++++++++-
 fs/erofs/inode.c    |   9 ++-
 fs/erofs/internal.h |   4 ++
 fs/erofs/super.c    |  60 ++++++++++++++++++-
 5 files changed, 212 insertions(+), 4 deletions(-)

-- 
2.24.4

