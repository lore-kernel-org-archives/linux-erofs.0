Return-Path: <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1848BC10F15
	for <linux-erofs@archiver.kernel.org>; Wed, 24 Apr 2024 08:59:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=lists.ozlabs.org;
	s=201707; t=1713949158;
	bh=3QDRNmAVBJwEI0DjW4Q8QZxGCbMGYjzUHZhHfViYzqA=;
	h=To:Subject:Date:List-Id:List-Unsubscribe:List-Archive:List-Post:
	 List-Help:List-Subscribe:From:Reply-To:Cc:From;
	b=CCqek7+kjrq48gMdmqYB+oWGb7JCx83KvU+AGLWToqtteXgsDqWefjEWb9/Uk0AsQ
	 W0CjfP3yXI0rlP1GGi38PviMsFpGoPXvchoj2hzG4J2M2V21jAGgAHNoFjUykIS/R/
	 krwvVbN6sWyzSpWVlG+9ZmBS3Zm4EizFOjlSohGr4gYUfmDdbiwhVSFUOzBiC0WyOz
	 xWMmbAfZU8di31MQeLQNf2AWgf2eNrgg/zi34hfYeZXYiHddnksdyMJ/hgcpT2dxI8
	 wyNLB8miew7GaSNkFmghILRndwJMqGX3Htso9hbNPYZkwOQafXRvwaO0VuWmdS1dz2
	 nBqhhgXE1y4kQ==
Received: from boromir.ozlabs.org (localhost [IPv6:::1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4VPXwk4kRzz3cSS
	for <linux-erofs@archiver.kernel.org>; Wed, 24 Apr 2024 18:59:18 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=huawei.com (client-ip=45.249.212.191; helo=szxga05-in.huawei.com; envelope-from=lihongbo22@huawei.com; receiver=lists.ozlabs.org)
Received: from szxga05-in.huawei.com (szxga05-in.huawei.com [45.249.212.191])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4VPXwY4MYsz3byl
	for <linux-erofs@lists.ozlabs.org>; Wed, 24 Apr 2024 18:59:06 +1000 (AEST)
Received: from mail.maildlp.com (unknown [172.19.88.163])
	by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4VPXTy0jFYz1j0sv;
	Wed, 24 Apr 2024 16:39:34 +0800 (CST)
Received: from dggpeml500022.china.huawei.com (unknown [7.185.36.66])
	by mail.maildlp.com (Postfix) with ESMTPS id 14EB518005F;
	Wed, 24 Apr 2024 16:42:38 +0800 (CST)
Received: from huawei.com (10.90.53.73) by dggpeml500022.china.huawei.com
 (7.185.36.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.35; Wed, 24 Apr
 2024 16:42:37 +0800
To: <xiang@kernel.org>, <chao@kernel.org>
Subject: [PATCH -next] erofs: modify the error message when prepare_ondemand_read failed
Date: Wed, 24 Apr 2024 16:42:47 +0800
Message-ID: <20240424084247.759432-1-lihongbo22@huawei.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.90.53.73]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggpeml500022.china.huawei.com (7.185.36.66)
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
From: Hongbo Li via Linux-erofs <linux-erofs@lists.ozlabs.org>
Reply-To: Hongbo Li <lihongbo22@huawei.com>
Cc: linux-kernel@vger.kernel.org, huyue2@coolpad.com, lihongbo22@huawei.com, linux-erofs@lists.ozlabs.org
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs" <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>

When prepare_ondemand_read failed, wrong error message is printed.
The prepare_read is also implemented in cachefiles, so we amend it.

Reviewed-by: Gao Xiang <hsiangkao@linux.alibaba.com>
Signed-off-by: Hongbo Li <lihongbo22@huawei.com>
---
 fs/erofs/fscache.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/erofs/fscache.c b/fs/erofs/fscache.c
index 8aff1a724805..62da538d91cb 100644
--- a/fs/erofs/fscache.c
+++ b/fs/erofs/fscache.c
@@ -151,7 +151,7 @@ static int erofs_fscache_read_io_async(struct fscache_cookie *cookie,
 		if (WARN_ON(len == 0))
 			source = NETFS_INVALID_READ;
 		if (source != NETFS_READ_FROM_CACHE) {
-			erofs_err(NULL, "prepare_read failed (source %d)", source);
+			erofs_err(NULL, "prepare_ondemand_read failed (source %d)", source);
 			return -EIO;
 		}
 
-- 
2.34.1

