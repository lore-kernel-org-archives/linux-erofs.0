Return-Path: <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9A131C5478C
	for <linux-erofs@archiver.kernel.org>; Wed, 28 Feb 2024 16:17:10 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [IPv6:::1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4TlKHn2Btzz3dSM
	for <linux-erofs@archiver.kernel.org>; Thu, 29 Feb 2024 03:17:09 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=sjtu.edu.cn (client-ip=202.120.2.232; helo=smtp232.sjtu.edu.cn; envelope-from=zhaoyifan@sjtu.edu.cn; receiver=lists.ozlabs.org)
Received: from smtp232.sjtu.edu.cn (smtp232.sjtu.edu.cn [202.120.2.232])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4TlKHh45Dqz3bsQ
	for <linux-erofs@lists.ozlabs.org>; Thu, 29 Feb 2024 03:17:02 +1100 (AEDT)
Received: from proxy188.sjtu.edu.cn (smtp188.sjtu.edu.cn [202.120.2.188])
	by smtp232.sjtu.edu.cn (Postfix) with ESMTPS id 8B3F11008EE00;
	Thu, 29 Feb 2024 00:16:57 +0800 (CST)
Received: from zhaoyf.ipads-lab.se.sjtu.edu.cn (unknown [202.120.40.82])
	by proxy188.sjtu.edu.cn (Postfix) with ESMTPSA id 1966D37C953;
	Thu, 29 Feb 2024 00:16:55 +0800 (CST)
From: Yifan Zhao <zhaoyifan@sjtu.edu.cn>
To: hsiangkao@linux.alibaba.com
Subject: [PATCH v4 0/5] erofs-utils: mkfs: introduce multi-threaded compression
Date: Thu, 29 Feb 2024 00:16:47 +0800
Message-ID: <20240228161652.1010997-1-zhaoyifan@sjtu.edu.cn>
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

changelog since v3:
- remove unnecessary struct z_erofs_write_index_ctx, and add a
  helper z_erofs_mt_fix_index to fix extents->blkaddr before
  writing index
- rename: z_erofs_vle_compress_ctx -> z_erofs_compressed_segment_ctx
- rename: z_erofs_file_compress_ctx -> z_erofs_compressed_inode_ctx
- leave tryrecompress_trailing() unchanged as it's only used in
  ztailpacking scenario which is not supported yet  

Gao Xiang (2):
  erofs-utils: add a helper to get available processors
  erofs-utils: lib: introduce atomic operations

Yifan Zhao (3):
  erofs-utils: introduce multi-threading framework
  erofs-utils: mkfs: add --worker=# parameter
  erofs-utils: mkfs: introduce inner-file multi-threaded compression

 configure.ac                |  17 +
 include/erofs/atomic.h      |  28 ++
 include/erofs/compress.h    |   1 +
 include/erofs/config.h      |   5 +
 include/erofs/internal.h    |   3 +
 include/erofs/workqueue.h   |  37 ++
 lib/Makefile.am             |   4 +
 lib/compress.c              | 703 +++++++++++++++++++++++++++++-------
 lib/compressor.c            |   2 +
 lib/compressor_deflate.c    |  11 +-
 lib/compressor_libdeflate.c |   6 +-
 lib/compressor_liblzma.c    |   5 +-
 lib/config.c                |  16 +
 lib/workqueue.c             | 132 +++++++
 mkfs/main.c                 |  38 ++
 15 files changed, 877 insertions(+), 131 deletions(-)
 create mode 100644 include/erofs/atomic.h
 create mode 100644 include/erofs/workqueue.h
 create mode 100644 lib/workqueue.c

-- 
2.44.0

