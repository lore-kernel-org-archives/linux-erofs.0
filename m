Return-Path: <linux-erofs+bounces-3698-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6E1F4CD98F6
	for <linux-erofs@archiver.kernel.org>; Mon, 22 Jun 2026 03:42:24 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4gkDXs4Y1qz2yVd;
	Mon, 22 Jun 2026 13:42:21 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=113.46.200.225
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1782099741;
	cv=none; b=a9WsewDI80b8mI8HaRAlIO1UyJC5dOwrgR4Ck0oNvXM7LCwjKNFCf7eJB+dVEKGkKgZ+57TWtPU69Ytesu5SpVqrkgoU+/vuadLAccMmyuHi4EKPdhrrCbFtgxYr6XMyM3Ig/51qIYimZv6DHAtRLje6CHZfm3RKE1TvT5L4Rv5GI1Ty+viWUBfVvVyy1BjUBhM70q19st1pG75pntIFmwI+FUvUpy9MfCaAiMrxbxWav6UkqTy2CoD3WD+sJcchkH7OpOzgLfh/Lba4uQ0dHyneLtZpqEkqgv0QRSKSltppc44HHOXbxkvnYSuKduf0ozrI023uC4V0PBeL2jWwlA==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1782099741; c=relaxed/relaxed;
	bh=7ovTf7l0wy3Fx0EY9949fVau2mCftdSE6nJpgWYIhwA=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=fHEjKBteV91YwDUvj/cETrWo4pza2u1VIw4khgjTExBoeyQq4GOoxzhH3dyF/olne6FkwzomCZxEM6UldJX+ojP/Qe1NDc8jQo2XtOjwokPwc6nFv7fSTyHqP1+36UNLP/1SiMe+Od4grFZzTONvUrD/V5v0sehLXYG1LhY9KLBXTUmjR6zNyExDMLir4Rv+8wnBF8NJfk2EstBr0/Qubn8+w7lb+QeSManPt2mN2dN0jfLQvCZhQ4ls9Zep8yeTR4uAirXsN3nMO2y7IKKoPrBA2uAQOZaFmH0htKJth943fx23SR+Ejk9LUhaox+p/J8+HYdH8zFxsokfQkmA5Bw==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; dkim=pass (1024-bit key; unprotected) header.d=huawei.com header.i=@huawei.com header.a=rsa-sha256 header.s=dkim header.b=ZOtA1kL0; dkim-atps=neutral; spf=pass (client-ip=113.46.200.225; helo=canpmsgout10.his.huawei.com; envelope-from=zhaoyifan28@huawei.com; receiver=lists.ozlabs.org) smtp.mailfrom=huawei.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=huawei.com header.i=@huawei.com header.a=rsa-sha256 header.s=dkim header.b=ZOtA1kL0;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=huawei.com (client-ip=113.46.200.225; helo=canpmsgout10.his.huawei.com; envelope-from=zhaoyifan28@huawei.com; receiver=lists.ozlabs.org)
Received: from canpmsgout10.his.huawei.com (canpmsgout10.his.huawei.com [113.46.200.225])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4gkDXq2vhsz2yVP
	for <linux-erofs@lists.ozlabs.org>; Mon, 22 Jun 2026 13:42:16 +1000 (AEST)
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=7ovTf7l0wy3Fx0EY9949fVau2mCftdSE6nJpgWYIhwA=;
	b=ZOtA1kL0+XbIDPK55L7mGkKQf5otG8/sCropAGax9ZF+PnlcUOKwJdwdb20/JNfcK+AFcQ79H
	AoCrtd8sJI+vXsd3Y4/AHxHvrEvsRBIdYmaGl0JHFFcp5HjpyJa0qmspZFGs9UBDm46ALxZQ5vS
	BZzbTnAigqhukSQLRj+xdHs=
Received: from mail.maildlp.com (unknown [172.19.163.163])
	by canpmsgout10.his.huawei.com (SkyGuard) with ESMTPS id 4gkDLD2WTBz1K982;
	Mon, 22 Jun 2026 11:33:08 +0800 (CST)
Received: from kwepemr100010.china.huawei.com (unknown [7.202.195.125])
	by mail.maildlp.com (Postfix) with ESMTPS id 1758A405D3;
	Mon, 22 Jun 2026 11:42:11 +0800 (CST)
Received: from huawei.com (10.50.159.234) by kwepemr100010.china.huawei.com
 (7.202.195.125) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.36; Mon, 22 Jun
 2026 11:42:10 +0800
From: Yifan Zhao <zhaoyifan28@huawei.com>
To: <linux-erofs@lists.ozlabs.org>, <hsiangkao@linux.alibaba.com>
CC: <zhukeqian1@huawei.com>, <zhaoyifan28@huawei.com>
Subject: [PATCH 1/2] erofs-utils: lib: don't abort on compression fallback
Date: Mon, 22 Jun 2026 11:40:51 +0800
Message-ID: <20260622034052.1047677-1-zhaoyifan28@huawei.com>
X-Mailer: git-send-email 2.47.3
X-Mailing-List: linux-erofs@lists.ozlabs.org
List-Id: <linux-erofs.lists.ozlabs.org>
List-Help: <mailto:linux-erofs+help@lists.ozlabs.org>
List-Owner: <mailto:linux-erofs+owner@lists.ozlabs.org>
List-Post: <mailto:linux-erofs@lists.ozlabs.org>
List-Subscribe: <mailto:linux-erofs+subscribe@lists.ozlabs.org>,
  <mailto:linux-erofs+subscribe-digest@lists.ozlabs.org>,
  <mailto:linux-erofs+subscribe-nomail@lists.ozlabs.org>
List-Unsubscribe: <mailto:linux-erofs+unsubscribe@lists.ozlabs.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.50.159.234]
X-ClientProxiedBy: kwepems200002.china.huawei.com (7.221.188.68) To
 kwepemr100010.china.huawei.com (7.202.195.125)

From: Yifan Zhao <yifan.yfzhao@foxmail.com>

-ENOSPC can be a normal compression fallback when fragments are off.
Keep the global compression context reusable for that case while
preserving the fatal state for real errors.

Fixes: a729584ef975 ("erofs-utils: mkfs: avoid hanging if fragment is on and tmpdir is full")
Reported-by: Bastian Schmitz <8330902+bshm@users.noreply.github.com>
Closes: https://github.com/erofs/erofs-utils/issues/50
Assisted-by: Codex:GPT-5.5
Signed-off-by: Yifan Zhao <zhaoyifan28@huawei.com>
---
 lib/compress.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/lib/compress.c b/lib/compress.c
index ea07409..2a43b81 100644
--- a/lib/compress.c
+++ b/lib/compress.c
@@ -2031,7 +2031,11 @@ err_free_idata:
 out:
 #ifdef EROFS_MT_ENABLED
 	pthread_mutex_lock(&ictx->mutex);
-	ictx->seg_num = ret < 0 ? INT_MAX : 0;
+	if (ret < 0 && (ret != -ENOSPC || inode->fragment_size))
+		/* mark as failed to avoid further processing */
+		ictx->seg_num = INT_MAX;
+	else
+		ictx->seg_num = 0;
 	pthread_cond_signal(&ictx->cond);
 	pthread_mutex_unlock(&ictx->mutex);
 #endif
-- 
2.47.3


