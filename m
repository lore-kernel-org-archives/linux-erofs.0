Return-Path: <SRS0=lyQx=L5=lists.ozlabs.org=linux-erofs-bounces+linux-erofs=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.9 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	UNWANTED_LANGUAGE_BODY,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F1CAC07E95
	for <linux-erofs@archiver.kernel.org>; Mon,  5 Jul 2021 03:30:41 +0000 (UTC)
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 5053A613BA
	for <linux-erofs@archiver.kernel.org>; Mon,  5 Jul 2021 03:30:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5053A613BA
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Received: from boromir.ozlabs.org (localhost [IPv6:::1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4GJB666Y3nz3036
	for <linux-erofs@archiver.kernel.org>; Mon,  5 Jul 2021 13:30:38 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized)
 smtp.mailfrom=linux.alibaba.com (client-ip=115.124.30.133;
 helo=out30-133.freemail.mail.aliyun.com;
 envelope-from=hsiangkao@linux.alibaba.com; receiver=<UNKNOWN>)
Received: from out30-133.freemail.mail.aliyun.com
 (out30-133.freemail.mail.aliyun.com [115.124.30.133])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
 (No client certificate requested)
 by lists.ozlabs.org (Postfix) with ESMTPS id 4GJB625LR4z2yNW
 for <linux-erofs@lists.ozlabs.org>; Mon,  5 Jul 2021 13:30:33 +1000 (AEST)
X-Alimail-AntiSpam: AC=PASS; BC=-1|-1; BR=01201311R191e4; CH=green; DM=||false|;
 DS=||; FP=0|-1|-1|-1|0|-1|-1|-1; HT=e01e04394; MF=hsiangkao@linux.alibaba.com;
 NM=1; PH=DS; RN=3; SR=0; TI=SMTPD_---0UehItrJ_1625455810; 
Received: from
 e18g09479.et15sqa.tbsite.net(mailfrom:hsiangkao@linux.alibaba.com
 fp:SMTPD_---0UehItrJ_1625455810) by smtp.aliyun-inc.com(127.0.0.1);
 Mon, 05 Jul 2021 11:30:16 +0800
From: Gao Xiang <hsiangkao@linux.alibaba.com>
To: linux-erofs@lists.ozlabs.org
Subject: [PATCH v2] erofs-utils: add "noinline_data" extended option
Date: Mon,  5 Jul 2021 11:30:08 +0800
Message-Id: <20210705033008.154747-1-hsiangkao@linux.alibaba.com>
X-Mailer: git-send-email 2.24.4
In-Reply-To: <YOHlZpBbOZSiOFN%2F@B-P7TQMD6M-0146.local>
References: <YOHlZpBbOZSiOFN%2F@B-P7TQMD6M-0146.local>
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
Cc: Gao Xiang <hsiangkao@linux.alibaba.com>
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs"
 <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>

Don't inline regular files in order to add preliminary
DAX feature support.

Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
---
v2:
 - update the prefix of the patch subject.

 include/erofs/config.h | 1 +
 lib/inode.c            | 5 +++++
 mkfs/main.c            | 6 ++++++
 3 files changed, 12 insertions(+)

diff --git a/include/erofs/config.h b/include/erofs/config.h
index 67e7a0fed24c..8124f3b36baf 100644
--- a/include/erofs/config.h
+++ b/include/erofs/config.h
@@ -44,6 +44,7 @@ struct erofs_configure {
 	bool c_random_pclusterblks;
 #endif
 	char c_timeinherit;
+	bool c_noinline_data;
 
 #ifdef HAVE_LIBSELINUX
 	struct selabel_handle *sehnd;
diff --git a/lib/inode.c b/lib/inode.c
index 97f0cf763baf..38906370f533 100644
--- a/lib/inode.c
+++ b/lib/inode.c
@@ -562,6 +562,11 @@ static int erofs_prepare_inode_buffer(struct erofs_inode *inode)
 	if (is_inode_layout_compression(inode))
 		goto noinline;
 
+	if (cfg.c_noinline_data && S_ISREG(inode->i_mode)) {
+		inode->datalayout = EROFS_INODE_FLAT_PLAIN;
+		goto noinline;
+	}
+
 	/*
 	 * if the file size is block-aligned for uncompressed files,
 	 * should use EROFS_INODE_FLAT_PLAIN data mapping mode.
diff --git a/mkfs/main.c b/mkfs/main.c
index 28539da5ea5f..10fe14d7a722 100644
--- a/mkfs/main.c
+++ b/mkfs/main.c
@@ -161,6 +161,12 @@ static int parse_extended_opts(const char *opts)
 				return -EINVAL;
 			erofs_sb_clear_sb_chksum();
 		}
+
+		if (MATCH_EXTENTED_OPT("noinline_data", token, keylen)) {
+			if (vallen)
+				return -EINVAL;
+			cfg.c_noinline_data = true;
+		}
 	}
 	return 0;
 }
-- 
2.24.4

