Return-Path: <linux-erofs+bounces-3700-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DDFF6CD98E4
	for <linux-erofs@archiver.kernel.org>; Mon, 22 Jun 2026 03:44:12 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4gkDZz32Pyz2xyh;
	Mon, 22 Jun 2026 13:44:11 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=113.46.200.222
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1782099851;
	cv=none; b=N+S8M/vlOUJ8BXZ+DYBiNygemNvLwvfc45fNy41JiWSH1vp0I6dF0+8YyXf1nzEzt9v2Fy7vIujA5ZUwtTE+PSIdCbKlbjyQwrsTjGCG2mVUvgH5vlo+VeJ54GWy29LXYuq8kA/aG/H4mELFr81zO2oy8AatY2vMv3N0lzoOapsysb7JImVcqMEkOFFyt3v5hTmxm+Lv9HMpaEkJRKbUzJLiRY8jLNgJJHXc1MDEt65CGCtZu/biKeUf4rhNGh4v8F2fwo25CDNzBh+PzzPQRCOcK3Zwq+64J308g4naeKNykO57hX5OnJiwbGqGjqKHxnNflcHdroaTuift7/ISYQ==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1782099851; c=relaxed/relaxed;
	bh=eqxDOpZ+VXY82NnkSAe/DD0ldXK3KnpBPze+XYrzlrc=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=YLWb/4nYVqalBBbP3tuonisu1asb3Q7/naW7CCG78gVUg1TBY4HLPXwPXmsVWKm5+S2v7YrRzgy9uUrJf/iimqqu+QRuysiOo50C/AOaDk4LxHX5nIKFw5iYjpUyaik3K6nnaDDSncF7yv6DYKcORx4mtg+gWtX3so1AIOYk/nhjRU8Id9quPXnOgSrFEN1TzCF19OPrw0gJLgETJSlaA3jdDsWADeFfzI9kqMb0hbgsy+wqC2TqrDsYy6JqAx4RtjqJ09JAIKwAGdVqGqT8AuJCkZIqDRhfjm2yG16QVwhnEW61e76W6iWW/fcz4ycU2Tci/YWVDoNDm8/7hcabVQ==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; dkim=pass (1024-bit key; unprotected) header.d=huawei.com header.i=@huawei.com header.a=rsa-sha256 header.s=dkim header.b=M+Ae3BtO; dkim-atps=neutral; spf=pass (client-ip=113.46.200.222; helo=canpmsgout07.his.huawei.com; envelope-from=zhaoyifan28@huawei.com; receiver=lists.ozlabs.org) smtp.mailfrom=huawei.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=huawei.com header.i=@huawei.com header.a=rsa-sha256 header.s=dkim header.b=M+Ae3BtO;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=huawei.com (client-ip=113.46.200.222; helo=canpmsgout07.his.huawei.com; envelope-from=zhaoyifan28@huawei.com; receiver=lists.ozlabs.org)
Received: from canpmsgout07.his.huawei.com (canpmsgout07.his.huawei.com [113.46.200.222])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4gkDZy5ypqz2yVd
	for <linux-erofs@lists.ozlabs.org>; Mon, 22 Jun 2026 13:44:10 +1000 (AEST)
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=eqxDOpZ+VXY82NnkSAe/DD0ldXK3KnpBPze+XYrzlrc=;
	b=M+Ae3BtO/heB3QkJytNS2kVTxd1pJYlnP8eV7N/xtEQOcl5GVIX7PBf2AmKpGSzRkDFgKaQO0
	B8aSmLur5hktP0puALN6FN71cCHMWnsxXC52F5kBJv7xb++V1g9nesqlmQzGA/aD46N3i0eNXdT
	NSWYs518NYXZUTpdSp2ULuA=
Received: from mail.maildlp.com (unknown [172.19.163.15])
	by canpmsgout07.his.huawei.com (SkyGuard) with ESMTPS id 4gkDNR0NM3zLlYn;
	Mon, 22 Jun 2026 11:35:03 +0800 (CST)
Received: from kwepemr100010.china.huawei.com (unknown [7.202.195.125])
	by mail.maildlp.com (Postfix) with ESMTPS id F3D8440539;
	Mon, 22 Jun 2026 11:44:06 +0800 (CST)
Received: from huawei.com (10.50.159.234) by kwepemr100010.china.huawei.com
 (7.202.195.125) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.36; Mon, 22 Jun
 2026 11:44:06 +0800
From: Yifan Zhao <zhaoyifan28@huawei.com>
To: <linux-erofs@lists.ozlabs.org>, <hsiangkao@linux.alibaba.com>
CC: <zhukeqian1@huawei.com>, <zhaoyifan28@huawei.com>
Subject: [RESEND PATCH 1/2] erofs-utils: lib: don't abort on compression fallback
Date: Mon, 22 Jun 2026 11:42:47 +0800
Message-ID: <20260622034248.1047783-1-zhaoyifan28@huawei.com>
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


