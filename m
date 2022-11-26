Return-Path: <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 193CCC43217
	for <linux-erofs@archiver.kernel.org>; Sat, 26 Nov 2022 00:58:14 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [IPv6:::1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4NJtdJ3GnVz3f4Z
	for <linux-erofs@archiver.kernel.org>; Sat, 26 Nov 2022 11:58:12 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=linux.alibaba.com (client-ip=115.124.30.42; helo=out30-42.freemail.mail.aliyun.com; envelope-from=jefflexu@linux.alibaba.com; receiver=<UNKNOWN>)
Received: from out30-42.freemail.mail.aliyun.com (out30-42.freemail.mail.aliyun.com [115.124.30.42])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4NJtd80dkJz3c2Q
	for <linux-erofs@lists.ozlabs.org>; Sat, 26 Nov 2022 11:58:03 +1100 (AEDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R321e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046051;MF=jefflexu@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0VVgrtrD_1669424278;
Received: from localhost(mailfrom:jefflexu@linux.alibaba.com fp:SMTPD_---0VVgrtrD_1669424278)
          by smtp.aliyun-inc.com;
          Sat, 26 Nov 2022 08:57:59 +0800
From: Jingbo Xu <jefflexu@linux.alibaba.com>
To: xiang@kernel.org,
	chao@kernel.org,
	linux-erofs@lists.ozlabs.org
Subject: [PATCH 2/2] erofs: enable large folio support for non-compressed format
Date: Sat, 26 Nov 2022 08:57:56 +0800
Message-Id: <20221126005756.7662-3-jefflexu@linux.alibaba.com>
X-Mailer: git-send-email 2.19.1.6.gb485710b
In-Reply-To: <20221126005756.7662-1-jefflexu@linux.alibaba.com>
References: <20221126005756.7662-1-jefflexu@linux.alibaba.com>
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
Cc: linux-kernel@vger.kernel.org
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs" <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>

Enable large folio in both device and fscache mode.  Then the readahead
routine will pass down large folio containing multiple pages.

Enable this feature for non-compressed format for now, until the
compression part supports large folio later.

Signed-off-by: Jingbo Xu <jefflexu@linux.alibaba.com>
---
 fs/erofs/fscache.c | 1 +
 fs/erofs/inode.c   | 1 +
 2 files changed, 2 insertions(+)

diff --git a/fs/erofs/fscache.c b/fs/erofs/fscache.c
index 0643b205c7eb..d2dd58ce312b 100644
--- a/fs/erofs/fscache.c
+++ b/fs/erofs/fscache.c
@@ -436,6 +436,7 @@ struct erofs_fscache *erofs_fscache_acquire_cookie(struct super_block *sb,
 		inode->i_size = OFFSET_MAX;
 		inode->i_mapping->a_ops = &erofs_fscache_meta_aops;
 		mapping_set_gfp_mask(inode->i_mapping, GFP_NOFS);
+		mapping_set_large_folios(inode->i_mapping);
 
 		ctx->inode = inode;
 	}
diff --git a/fs/erofs/inode.c b/fs/erofs/inode.c
index ad2a82f2eb4c..85932086d23f 100644
--- a/fs/erofs/inode.c
+++ b/fs/erofs/inode.c
@@ -295,6 +295,7 @@ static int erofs_fill_inode(struct inode *inode)
 		goto out_unlock;
 	}
 	inode->i_mapping->a_ops = &erofs_raw_access_aops;
+	mapping_set_large_folios(inode->i_mapping);
 #ifdef CONFIG_EROFS_FS_ONDEMAND
 	if (erofs_is_fscache_mode(inode->i_sb))
 		inode->i_mapping->a_ops = &erofs_fscache_access_aops;
-- 
2.19.1.6.gb485710b

