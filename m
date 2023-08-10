Return-Path: <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 18CE9C001DB
	for <linux-erofs@archiver.kernel.org>; Thu, 10 Aug 2023 06:46:50 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [IPv6:::1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4RLyBw4XLMz3bw9
	for <linux-erofs@archiver.kernel.org>; Thu, 10 Aug 2023 16:46:48 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=linux.alibaba.com (client-ip=115.124.30.130; helo=out30-130.freemail.mail.aliyun.com; envelope-from=jefflexu@linux.alibaba.com; receiver=lists.ozlabs.org)
Received: from out30-130.freemail.mail.aliyun.com (out30-130.freemail.mail.aliyun.com [115.124.30.130])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4RLyBr02kTz2y3Y
	for <linux-erofs@lists.ozlabs.org>; Thu, 10 Aug 2023 16:46:41 +1000 (AEST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R121e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046059;MF=jefflexu@linux.alibaba.com;NM=1;PH=DS;RN=2;SR=0;TI=SMTPD_---0VpSXZMh_1691649993;
Received: from localhost(mailfrom:jefflexu@linux.alibaba.com fp:SMTPD_---0VpSXZMh_1691649993)
          by smtp.aliyun-inc.com;
          Thu, 10 Aug 2023 14:46:34 +0800
From: Jingbo Xu <jefflexu@linux.alibaba.com>
To: xiang@kernel.org,
	linux-erofs@lists.ozlabs.org
Subject: [PATCH 1/2] erofs-utils: mkfs: fix double write of long xattr name prefixes
Date: Thu, 10 Aug 2023 14:46:32 +0800
Message-Id: <20230810064633.56218-1-jefflexu@linux.alibaba.com>
X-Mailer: git-send-email 2.19.1.6.gb485710b
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
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs" <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>

Fix double write of long xattr name prefixes in non-tarerofs mode.

Besides fix the compiling error of tar.h.  Include "internal.h" to
introduce prototypes of `struct erofs_inode` and `struct erofs_sb_info`.

Fixes: 95d315fd7958 ("erofs-utils: introduce tarerofs")
Signed-off-by: Jingbo Xu <jefflexu@linux.alibaba.com>
---
 include/erofs/tar.h | 11 +++++++++++
 mkfs/main.c         |  3 ---
 2 files changed, 11 insertions(+), 3 deletions(-)

diff --git a/include/erofs/tar.h b/include/erofs/tar.h
index 8d3f8de..b7c2ef8 100644
--- a/include/erofs/tar.h
+++ b/include/erofs/tar.h
@@ -2,8 +2,15 @@
 #ifndef __EROFS_TAR_H
 #define __EROFS_TAR_H
 
+#ifdef __cplusplus
+extern "C"
+{
+#endif
+
 #include <sys/stat.h>
 
+#include "internal.h"
+
 struct erofs_pax_header {
 	struct stat st;
 	bool use_mtime;
@@ -27,4 +34,8 @@ int tarerofs_parse_tar(struct erofs_inode *root, struct erofs_tarfile *tar);
 int tarerofs_reserve_devtable(struct erofs_sb_info *sbi, unsigned int devices);
 int tarerofs_write_devtable(struct erofs_sb_info *sbi, struct erofs_tarfile *tar);
 
+#ifdef __cplusplus
+}
+#endif
+
 #endif
diff --git a/mkfs/main.c b/mkfs/main.c
index 9c2397c..c03a7a8 100644
--- a/mkfs/main.c
+++ b/mkfs/main.c
@@ -912,9 +912,6 @@ int main(int argc, char **argv)
 
 	erofs_inode_manager_init();
 
-	if (cfg.c_extra_ea_name_prefixes)
-		erofs_xattr_write_name_prefixes(&sbi, packedfile);
-
 	if (!tar_mode) {
 		err = erofs_build_shared_xattrs_from_path(&sbi, cfg.c_src_path);
 		if (err) {
-- 
2.19.1.6.gb485710b

