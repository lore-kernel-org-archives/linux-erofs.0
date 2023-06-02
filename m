Return-Path: <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 31253C77B7A
	for <linux-erofs@archiver.kernel.org>; Fri,  2 Jun 2023 05:53:20 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [IPv6:::1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4QXXH24hnDz3dyQ
	for <linux-erofs@archiver.kernel.org>; Fri,  2 Jun 2023 15:53:18 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=linux.alibaba.com (client-ip=115.124.30.101; helo=out30-101.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=<UNKNOWN>)
Received: from out30-101.freemail.mail.aliyun.com (out30-101.freemail.mail.aliyun.com [115.124.30.101])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4QXXGv1QnKz3cCy
	for <linux-erofs@lists.ozlabs.org>; Fri,  2 Jun 2023 15:53:09 +1000 (AEST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R991e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045176;MF=hsiangkao@linux.alibaba.com;NM=1;PH=DS;RN=3;SR=0;TI=SMTPD_---0Vk8fjxQ_1685685177;
Received: from e18g06460.et15sqa.tbsite.net(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0Vk8fjxQ_1685685177)
          by smtp.aliyun-inc.com;
          Fri, 02 Jun 2023 13:53:03 +0800
From: Gao Xiang <hsiangkao@linux.alibaba.com>
To: linux-erofs@lists.ozlabs.org
Subject: [PATCH] erofs-utils: fsck: block insane long paths when extracting images
Date: Fri,  2 Jun 2023 13:52:56 +0800
Message-Id: <20230602055256.18061-1-hsiangkao@linux.alibaba.com>
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
Cc: Gao Xiang <hsiangkao@linux.alibaba.com>, Chaoming Yang <lometsj@live.com>
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs" <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>

Since some crafted EROFS filesystem images could have insane deep
hierarchy (or may cause directory loops) which triggers the
PATH_MAX-sized path buffer OR stack overflow.

Actually such crafted images cannot be deemed as real corrupted
images but over-PATH_MAX paths are not something that we'd like to
support for now.

CVE: CVE-2023-33551
Closes: https://nvd.nist.gov/vuln/detail/CVE-2023-33551
Reported-by: Chaoming Yang <lometsj@live.com>
Fixes: f44043561491 ("erofs-utils: introduce fsck.erofs")
Fixes: b11f84f593f9 ("erofs-utils: fsck: convert to use erofs_iterate_dir()")
Fixes: 412c8f908132 ("erofs-utils: fsck: add --extract=X support to extract to path X")
Signeo-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
---
 fsck/main.c | 23 +++++++++++++++--------
 1 file changed, 15 insertions(+), 8 deletions(-)

diff --git a/fsck/main.c b/fsck/main.c
index 52fb7a0..3d1682c 100644
--- a/fsck/main.c
+++ b/fsck/main.c
@@ -680,28 +680,35 @@ again:
 static int erofsfsck_dirent_iter(struct erofs_dir_context *ctx)
 {
 	int ret;
-	size_t prev_pos = fsckcfg.extract_pos;
+	size_t prev_pos, curr_pos;
 
 	if (ctx->dot_dotdot)
 		return 0;
 
-	if (fsckcfg.extract_path) {
-		size_t curr_pos = prev_pos;
+	prev_pos = fsckcfg.extract_pos;
+	curr_pos = prev_pos;
+
+	if (prev_pos + ctx->de_namelen >= PATH_MAX) {
+		erofs_err("unable to fsck since the path is too long (%u)",
+			  curr_pos + ctx->de_namelen);
+		return -EOPNOTSUPP;
+	}
 
+	if (fsckcfg.extract_path) {
 		fsckcfg.extract_path[curr_pos++] = '/';
 		strncpy(fsckcfg.extract_path + curr_pos, ctx->dname,
 			ctx->de_namelen);
 		curr_pos += ctx->de_namelen;
 		fsckcfg.extract_path[curr_pos] = '\0';
-		fsckcfg.extract_pos = curr_pos;
+	} else {
+		curr_pos += ctx->de_namelen;
 	}
-
+	fsckcfg.extract_pos = curr_pos;
 	ret = erofsfsck_check_inode(ctx->dir->nid, ctx->de_nid);
 
-	if (fsckcfg.extract_path) {
+	if (fsckcfg.extract_path)
 		fsckcfg.extract_path[prev_pos] = '\0';
-		fsckcfg.extract_pos = prev_pos;
-	}
+	fsckcfg.extract_pos = prev_pos;
 	return ret;
 }
 
-- 
2.24.4

