Return-Path: <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AABAEC54798
	for <linux-erofs@archiver.kernel.org>; Sun, 25 Feb 2024 14:28:23 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [IPv6:::1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4TjR1f2dcnz3cPm
	for <linux-erofs@archiver.kernel.org>; Mon, 26 Feb 2024 01:28:22 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=sjtu.edu.cn (client-ip=202.120.2.232; helo=smtp232.sjtu.edu.cn; envelope-from=zhaoyifan@sjtu.edu.cn; receiver=lists.ozlabs.org)
Received: from smtp232.sjtu.edu.cn (smtp232.sjtu.edu.cn [202.120.2.232])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4TjR1W0gVJz30Kd
	for <linux-erofs@lists.ozlabs.org>; Mon, 26 Feb 2024 01:28:12 +1100 (AEDT)
Received: from proxy188.sjtu.edu.cn (smtp188.sjtu.edu.cn [202.120.2.188])
	by smtp232.sjtu.edu.cn (Postfix) with ESMTPS id B221110089E40;
	Sun, 25 Feb 2024 22:28:01 +0800 (CST)
Received: from zhaoyf.ipads-lab.se.sjtu.edu.cn (unknown [202.120.40.82])
	by proxy188.sjtu.edu.cn (Postfix) with ESMTPSA id D70C237C986;
	Sun, 25 Feb 2024 22:28:00 +0800 (CST)
From: Yifan Zhao <zhaoyifan@sjtu.edu.cn>
To: hsiangkao@linux.alibaba.com
Subject: [PATCH v3 0/4] erofs-utils: mkfs: introduce multi-threaded compression
Date: Sun, 25 Feb 2024 22:27:55 +0800
Message-ID: <20240225142759.340165-1-zhaoyifan@sjtu.edu.cn>
X-Mailer: git-send-email 2.44.0
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
Cc: linux-erofs@lists.ozlabs.org
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs" <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>

change log since v2:
- squash per-worker tmpfile commit into previous PATCH
- give static global variable `erofs_` prefix
- remove inter-file compression support from this patchset
- introduce a new `z_erofs_file_compress_ctx` struct to divide the segment
  context from the file context
- remove the patch related to pring warning from this patchset, which may be
  supported later with atomic variables

Gao Xiang (1):
  erofs-utils: add a helper to get available processors

Yifan Zhao (3):
  erofs-utils: introduce multi-threading framework
  erofs-utils: mkfs: add --worker=# parameter
  erofs-utils: mkfs: introduce inner-file multi-threaded compression

 configure.ac              |  17 +
 include/erofs/compress.h  |   1 +
 include/erofs/config.h    |   5 +
 include/erofs/internal.h  |   3 +
 include/erofs/workqueue.h |  37 ++
 lib/Makefile.am           |   4 +
 lib/compress.c            | 690 +++++++++++++++++++++++++++++++-------
 lib/compressor.c          |   2 +
 lib/config.c              |  16 +
 lib/workqueue.c           | 132 ++++++++
 mkfs/main.c               |  38 +++
 11 files changed, 827 insertions(+), 118 deletions(-)
 create mode 100644 include/erofs/workqueue.h
 create mode 100644 lib/workqueue.c

-- 
2.44.0

