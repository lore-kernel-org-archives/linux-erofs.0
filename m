Return-Path: <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4FA95CDB474
	for <linux-erofs@archiver.kernel.org>; Sat, 21 Oct 2023 02:01:51 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [IPv6:::1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4SC4St0D1fz3dmy
	for <linux-erofs@archiver.kernel.org>; Sat, 21 Oct 2023 13:01:50 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=linux.alibaba.com (client-ip=115.124.30.98; helo=out30-98.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org)
Received: from out30-98.freemail.mail.aliyun.com (out30-98.freemail.mail.aliyun.com [115.124.30.98])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4SC4Sp0xkLz30MQ
	for <linux-erofs@lists.ozlabs.org>; Sat, 21 Oct 2023 13:01:45 +1100 (AEDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R131e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046060;MF=hsiangkao@linux.alibaba.com;NM=1;PH=DS;RN=3;SR=0;TI=SMTPD_---0VuYG-.I_1697853700;
Received: from e69b19392.et15sqa.tbsite.net(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0VuYG-.I_1697853700)
          by smtp.aliyun-inc.com;
          Sat, 21 Oct 2023 10:01:41 +0800
From: Gao Xiang <hsiangkao@linux.alibaba.com>
To: linux-erofs@lists.ozlabs.org
Subject: [PATCH] erofs: don't warn MicroLZMA format anymore
Date: Sat, 21 Oct 2023 10:01:37 +0800
Message-Id: <20231021020137.1646959-1-hsiangkao@linux.alibaba.com>
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

The LZMA algorithm support has been landed for more than one year since
Linux 5.16.  Besides, the new XZ Utils 5.4 has been available in most
Linux distributions.

Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
---
 fs/erofs/Kconfig             | 7 ++-----
 fs/erofs/decompressor_lzma.c | 2 --
 2 files changed, 2 insertions(+), 7 deletions(-)

diff --git a/fs/erofs/Kconfig b/fs/erofs/Kconfig
index f6dc961e6c2b..e540648dedc2 100644
--- a/fs/erofs/Kconfig
+++ b/fs/erofs/Kconfig
@@ -91,13 +91,10 @@ config EROFS_FS_ZIP_LZMA
 	select XZ_DEC_MICROLZMA
 	help
 	  Saying Y here includes support for reading EROFS file systems
-	  containing LZMA compressed data, specifically called microLZMA. it
-	  gives better compression ratios than the LZ4 algorithm, at the
+	  containing LZMA compressed data, specifically called microLZMA. It
+	  gives better compression ratios than the default LZ4 format, at the
 	  expense of more CPU overhead.
 
-	  LZMA support is an experimental feature for now and so most file
-	  systems will be readable without selecting this option.
-
 	  If unsure, say N.
 
 config EROFS_FS_ZIP_DEFLATE
diff --git a/fs/erofs/decompressor_lzma.c b/fs/erofs/decompressor_lzma.c
index ba4ec73f4aae..852dd8eac5df 100644
--- a/fs/erofs/decompressor_lzma.c
+++ b/fs/erofs/decompressor_lzma.c
@@ -96,8 +96,6 @@ int z_erofs_load_lzma_config(struct super_block *sb,
 		return -EINVAL;
 	}
 
-	erofs_info(sb, "EXPERIMENTAL MicroLZMA in use. Use at your own risk!");
-
 	/* in case 2 z_erofs_load_lzma_config() race to avoid deadlock */
 	mutex_lock(&lzma_resize_mutex);
 
-- 
2.39.3

