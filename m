Return-Path: <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3F31AC54E58
	for <linux-erofs@archiver.kernel.org>; Mon, 25 Mar 2024 13:42:07 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [IPv6:::1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4V3Dcs6VTQz3dKG
	for <linux-erofs@archiver.kernel.org>; Tue, 26 Mar 2024 00:42:05 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=sjtu.edu.cn (client-ip=202.120.2.232; helo=smtp232.sjtu.edu.cn; envelope-from=zhaoyifan@sjtu.edu.cn; receiver=lists.ozlabs.org)
Received: from smtp232.sjtu.edu.cn (smtp232.sjtu.edu.cn [202.120.2.232])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4V3Dck06nRz3cDk
	for <linux-erofs@lists.ozlabs.org>; Tue, 26 Mar 2024 00:41:55 +1100 (AEDT)
Received: from proxy188.sjtu.edu.cn (smtp188.sjtu.edu.cn [202.120.2.188])
	by smtp232.sjtu.edu.cn (Postfix) with ESMTPS id 8EAC11008DC87
	for <linux-erofs@lists.ozlabs.org>; Mon, 25 Mar 2024 21:41:47 +0800 (CST)
Received: from zhaoyf.ipads-lab.se.sjtu.edu.cn (unknown [202.120.40.82])
	by proxy188.sjtu.edu.cn (Postfix) with ESMTPSA id B600D37C974
	for <linux-erofs@lists.ozlabs.org>; Mon, 25 Mar 2024 21:41:45 +0800 (CST)
From: Yifan Zhao <zhaoyifan@sjtu.edu.cn>
To: linux-erofs@lists.ozlabs.org
Subject: [PATCH v5 0/2] erofs-utils: mkfs: introduce inter-file multi-threaded compression
Date: Mon, 25 Mar 2024 21:41:40 +0800
Message-ID: <20240325134142.174389-1-zhaoyifan@sjtu.edu.cn>
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
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs" <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>

changelog since v4:
- Fix more format issues in inode.c reported by checkpatch.pl
- Add missing cfg.c_chunkbits in erofs_mkfs_issue_compress

Yifan Zhao (2):
  erofs-utils: lib: split function logic in inode.c
  erofs-utils: mkfs: introduce inter-file multi-threaded compression

 include/erofs/compress.h |  16 ++
 include/erofs/inode.h    |  30 +++
 include/erofs/internal.h |   3 +
 lib/compress.c           | 336 +++++++++++++++++++++------------
 lib/inode.c              | 397 +++++++++++++++++++++++++++++++++------
 5 files changed, 604 insertions(+), 178 deletions(-)

Interdiff against v4:
diff --git a/lib/inode.c b/lib/inode.c
index 0faf461..1de3f8a 100644
--- a/lib/inode.c
+++ b/lib/inode.c
@@ -1152,11 +1152,12 @@ static int erofs_mkfs_handle_file(struct erofs_inode *inode)
 
 static int erofs_mkfs_issue_compress(struct erofs_inode *inode)
 {
-	if (!inode->i_size || S_ISLNK(inode->i_mode))
+	if (!inode->i_size || S_ISLNK(inode->i_mode) || cfg.c_chunkbits)
 		return 0;
 
 	if (cfg.c_compr_opts[0].alg && erofs_file_is_compressible(inode)) {
 		int fd = open(inode->i_srcpath, O_RDONLY | O_BINARY);
+
 		if (fd < 0)
 			return -errno;
 		return erofs_write_compressed_file(inode, fd, 0);
@@ -1420,7 +1421,7 @@ static int z_erofs_mt_reap_compressed(struct erofs_inode *inode)
 	return ret;
 }
 
-static int z_erofs_mt_reap_inodes()
+static int z_erofs_mt_reap_inodes(void)
 {
 	struct erofs_inode *inode, *dumpdir;
 	int ret = 0;
@@ -1456,6 +1457,7 @@ static int z_erofs_mt_reap_inodes()
 			ret = 0;
 		} else {
 			int fd = open(inode->i_srcpath, O_RDONLY | O_BINARY);
+
 			if (fd < 0)
 				return -errno;
 
-- 
2.44.0

