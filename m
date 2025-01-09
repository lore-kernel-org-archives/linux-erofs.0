Return-Path: <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E62C9E77197
	for <linux-erofs@archiver.kernel.org>; Thu,  9 Jan 2025 05:05:38 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [IPv6:::1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4YTCR45W5fz3bXH
	for <linux-erofs@archiver.kernel.org>; Thu,  9 Jan 2025 16:05:36 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=115.124.30.113
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1736399135;
	cv=none; b=d2+N3QlR7mlnYML0RX0OC+ee2YThtyWsazYJhvQyFCx5f6qFHCSBqCPdDM3AkewTQkoKD9Ic7swkvzxnLP0lZA9iFz41CitV7ndONCvESZOB/mPqtEOTQHMBxoc9WDw6KnQ65UYvzjyszusDiAB60ac7n/qA71o8Ji1AzwlZK0GZ6dVyBgvCmEb5wdBubcczglGQTLPUfhM/Rfqrc9iGx9a2Onnfv0JTifYIffcS6nINV1OoRPsT9go64019DMjRTJNS5B/KfCd/tfYGQbVrluJQTvg5/IRIg0/+x0+zZrQdN2qqPJUR/VDGdlDsbZA3qf6baEdieJUXzSvkH60K2A==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1736399135; c=relaxed/relaxed;
	bh=k59iyDtCkAlnEiHeLa/vsLC5xDJuK6tzMEkPE8H0ykA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=RPMcvK1ql+xfb4zD5D8VEXgnL+gRk82vANGh4OFWsjeryysYMrnvDu/BivOE8ONzgCM42pnYP+JjPNsxkeGbsPdnE7O9PaixMD13uzaLFdlESp0Zbkh3FDDF9tTaCKtmk7CakA8M2lB0C/juZotodmz9hG4BxRE60zhMOn3VBx+/NUPwlLK1x/7PbOqO800EPB6/G51lhOIgvCSehjGKAW+4qTyTvB1s2BcVNc5WDQCuXkKlF+LasFz7PKydxTq+rqSVzMRVUQqwE/bZ5jQjB1oBvfHXguamXc7bP2hW1WST8kPLBYjJD3LVNu72aVvcIlBHbTyhrGiLJkHcnRujVw==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=sGhVSHnU; dkim-atps=neutral; spf=pass (client-ip=115.124.30.113; helo=out30-113.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org) smtp.mailfrom=linux.alibaba.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=sGhVSHnU;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=linux.alibaba.com (client-ip=115.124.30.113; helo=out30-113.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org)
Received: from out30-113.freemail.mail.aliyun.com (out30-113.freemail.mail.aliyun.com [115.124.30.113])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4YTCR02zlhz2yNs
	for <linux-erofs@lists.ozlabs.org>; Thu,  9 Jan 2025 16:05:29 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1736399124; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=k59iyDtCkAlnEiHeLa/vsLC5xDJuK6tzMEkPE8H0ykA=;
	b=sGhVSHnUre7zIJ9MaUDZjG6wbkxCyH3UwQ1w+3YEOTSZWM9b4SeSs7yi0ZapsKyx48QAiGnWNTNbCC2EOX8ExW8Ps5g1iiNMIaX3sK8Y5x3nCm0T4p49Vp9ON2BXMay0Ao+RO2uCg9eSx56Ow0UKHmqF6mNnE38rOFecdJz9eXU=
Received: from x31i01179.sqa.na131.tbsite.net(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0WNG4CPp_1736399114 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 09 Jan 2025 13:05:21 +0800
From: Gao Xiang <hsiangkao@linux.alibaba.com>
To: linux-erofs@lists.ozlabs.org
Subject: [PATCH] erofs-utils: mkfs: fix crash when failing to build tree
Date: Thu,  9 Jan 2025 13:05:14 +0800
Message-ID: <20250109050514.3836023-1-hsiangkao@linux.alibaba.com>
X-Mailer: git-send-email 2.43.5
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
Cc: Gao Xiang <hsiangkao@linux.alibaba.com>, Jonathan Lebon <jonathan@jlebon.com>
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs" <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>

For example: It crashes instead of cleanly erroring out if there's
a file for which it doesn't have permissions to read (e.g. /etc/gshadow
has mode 000).

Reported-by: Jonathan Lebon <jonathan@jlebon.com>
Fixes: 6a8e395ae4fd ("erofs-utils: fix up root inode for incremental builds")
Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
---
 mkfs/main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/mkfs/main.c b/mkfs/main.c
index 2988c65..624b191 100644
--- a/mkfs/main.c
+++ b/mkfs/main.c
@@ -1450,6 +1450,7 @@ int main(int argc, char **argv)
 		root = erofs_mkfs_build_tree_from_path(&g_sbi, cfg.c_src_path);
 		if (IS_ERR(root)) {
 			err = PTR_ERR(root);
+			root = NULL;
 			goto exit;
 		}
 	}
-- 
2.43.5

