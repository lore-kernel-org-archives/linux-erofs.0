Return-Path: <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4FA12C77B75
	for <linux-erofs@archiver.kernel.org>; Sat,  6 May 2023 03:53:20 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [IPv6:::1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4QCtv25lfhz3fGT
	for <linux-erofs@archiver.kernel.org>; Sat,  6 May 2023 13:53:18 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=linux.alibaba.com (client-ip=115.124.30.130; helo=out30-130.freemail.mail.aliyun.com; envelope-from=jefflexu@linux.alibaba.com; receiver=<UNKNOWN>)
Received: from out30-130.freemail.mail.aliyun.com (out30-130.freemail.mail.aliyun.com [115.124.30.130])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4QCtty6ZXkz3bqB
	for <linux-erofs@lists.ozlabs.org>; Sat,  6 May 2023 13:53:13 +1000 (AEST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R141e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046050;MF=jefflexu@linux.alibaba.com;NM=1;PH=DS;RN=2;SR=0;TI=SMTPD_---0VhrphTH_1683345186;
Received: from localhost(mailfrom:jefflexu@linux.alibaba.com fp:SMTPD_---0VhrphTH_1683345186)
          by smtp.aliyun-inc.com;
          Sat, 06 May 2023 11:53:07 +0800
From: Jingbo Xu <jefflexu@linux.alibaba.com>
To: hsiangkao@linux.alibaba.com,
	linux-erofs@lists.ozlabs.org
Subject: [PATCH v2] erofs-utils: fix `-Ededupe` crash without fragments enabled
Date: Sat,  6 May 2023 11:53:06 +0800
Message-Id: <20230506035306.2269-1-jefflexu@linux.alibaba.com>
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

From: Gao Xiang <hsiangkao@linux.alibaba.com>

Otherwise, an unexpected segfault will happen since
  EROFS_FEATURE_INCOMPAT_FRAGMENTS and
  EROFS_FEATURE_INCOMPAT_DEDUPE    share the same bit.

Fixes: 18fbf7d12e4f ("erofs-utils: build xattrs upon extra long name prefixes")
Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
Signed-off-by: Jingbo Xu <jefflexu@linux.alibaba.com>
---
v2: flush packed inode when either cfg.c_fragments or
cfg.c_extra_ea_name_prefixes is specified
---
 mkfs/main.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/mkfs/main.c b/mkfs/main.c
index 467ea86..61387b3 100644
--- a/mkfs/main.c
+++ b/mkfs/main.c
@@ -903,7 +903,8 @@ int main(int argc, char **argv)
 	}
 
 	packed_nid = 0;
-	if (erofs_sb_has_fragments()) {
+	if ((cfg.c_fragments || cfg.c_extra_ea_name_prefixes) &&
+	    erofs_sb_has_fragments()) {
 		erofs_update_progressinfo("Handling packed_file ...");
 		packed_inode = erofs_mkfs_build_packedfile();
 		if (IS_ERR(packed_inode)) {
-- 
2.19.1.6.gb485710b

