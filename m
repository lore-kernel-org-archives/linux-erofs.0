Return-Path: <linux-erofs+bounces-1040-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 646E2CAC598
	for <linux-erofs@archiver.kernel.org>; Wed, 17 Sep 2025 08:17:12 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4cRWpG2mSTz304l;
	Wed, 17 Sep 2025 18:17:10 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=115.124.30.113
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1758097030;
	cv=none; b=efE8axR50JRC4FSNT5KJosgB2IBpjSp+zui1Jijg1vRetuZdizKUKx7c7adalYRuqRZF7BnrGri+FehCCN0gf0zVh0n7NPk++kwO7KWbBNi+I0DBHGCYYqaNHepxMYc1C2GR6/VS0JJIAGh6UqOH/CmXpJDrQAenMwgireKbu0uy2DhfglFY1iJQaz06kbKwUyXhzEPBMgRzdMOlgrtWJS6YCMOeuf74sDpNa3pKI9faYnho6a3FhCFM80hYug2p8axKqh88mOeu5Ii7beqGXNY9sS8ReVu+brBA3dkJzPXAuukPyrf3UZq2LmT5BRjeUIXryiaymJRnxZ8prYxOiA==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1758097030; c=relaxed/relaxed;
	bh=7CwrFcsQmZrMdNgyqjPzljLpQ40EmILDoz900pe6jOA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NX+P8se9TjzZmGqDtUEFRz7xLsamciPP5moNdVzHI9giZmZbM1YtbJNtbLykTgEMI78ZkDixMruLAsmm1BOGeJGgGH0Y6EF+40IwAsRkNdHjryG5qCfQ83yWe+sDC9/WGyIXO1TB+7W/NSWbFEgEM1E4fRYFSCFlsAAzarebR3vz79Ojdq4NO6K8nEJc41caDKMM1qDELBSMKLcXgJB1TxaRTiYShnl/0FhngTqFDvVe5i1cLaerHibsjLwY0diWAMJgIeiXCYdSFlFA/c70+1cUwGMZjzqt3o/i9+q5SL/nCVjDAuA6f2Fit8JvEpg5Gts3mVGrRqvQbmHnpiOIsw==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=hywSgn9V; dkim-atps=neutral; spf=pass (client-ip=115.124.30.113; helo=out30-113.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org) smtp.mailfrom=linux.alibaba.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=hywSgn9V;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=linux.alibaba.com (client-ip=115.124.30.113; helo=out30-113.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org)
Received: from out30-113.freemail.mail.aliyun.com (out30-113.freemail.mail.aliyun.com [115.124.30.113])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4cRWpF0x44z3cQx
	for <linux-erofs@lists.ozlabs.org>; Wed, 17 Sep 2025 18:17:08 +1000 (AEST)
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1758097025; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=7CwrFcsQmZrMdNgyqjPzljLpQ40EmILDoz900pe6jOA=;
	b=hywSgn9VuU7CXzZLRA4ed2ll6BwYUArxRc6C2yE57sburES0UlAGTMjkwGWKZd849TeKTVGq+YPnJEex5skSDtvZpr+LwxAY6X2iqUfhDsFG2rs/zJQWcSVJ4SR8MJlCG5gOTy/ibVMOZDKYUR1EkoMrXasaI7HGaJ9E37TwRlM=
Received: from x31i01179.sqa.na131.tbsite.net(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0WoBqWMx_1758097021 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 17 Sep 2025 16:17:02 +0800
From: Gao Xiang <hsiangkao@linux.alibaba.com>
To: linux-erofs@lists.ozlabs.org
Cc: hudson@cyzhu.com,
	Gao Xiang <hsiangkao@linux.alibaba.com>
Subject: [PATCH 3/2] TEST CODE
Date: Wed, 17 Sep 2025 16:16:54 +0800
Message-ID: <20250917081654.3603244-3-hsiangkao@linux.alibaba.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20250917081654.3603244-1-hsiangkao@linux.alibaba.com>
References: <20250917081654.3603244-1-hsiangkao@linux.alibaba.com>
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

This reverts commit ad879589e4a281cbd05a1fd9c8d8865a34cd8d87.
---
 lib/gzran.c | 51 +++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 51 insertions(+)

diff --git a/lib/gzran.c b/lib/gzran.c
index 6a6fddc..6d55c4a 100644
--- a/lib/gzran.c
+++ b/lib/gzran.c
@@ -390,3 +390,54 @@ struct erofs_vfile *erofs_gzran_zinfo_open(struct erofs_vfile *vin,
 	return ERR_PTR(-EOPNOTSUPP);
 }
 #endif
+
+#ifdef TEST
+#include <fcntl.h>
+
+int main(int argc, char *argv[])
+{
+	struct erofs_vfile vin, *vout;
+	int zinfo_len, fd, len, offset;
+	char *zinfo_buf;
+	char *outbuf;
+
+	if (argc < 5)
+		exit(1);
+	fd = open(argv[2], O_RDONLY);
+	if (fd < 0)
+		exit(1);
+	zinfo_len = lseek(fd, 0, SEEK_END);
+	if (zinfo_len < 0)
+		exit(1);
+	(void)lseek(fd, 0, SEEK_SET);
+
+	zinfo_buf = malloc(zinfo_len);
+	if (!zinfo_buf)
+		exit(1);
+	if (read(fd, zinfo_buf, zinfo_len) < zinfo_len)
+		exit(1);
+	close(fd);
+
+	fd = open(argv[1], O_RDONLY);
+	if (fd < 0)
+		exit(1);
+	vin = (struct erofs_vfile) {.fd = fd};
+
+	vout = erofs_gzran_zinfo_open(&vin, zinfo_buf, zinfo_len);
+	if (IS_ERR(vout))
+		exit(1);
+	free(zinfo_buf);
+
+	len = atoi(argv[4]);
+	offset = atoi(argv[3]);
+
+	outbuf = malloc(len);
+	if (!outbuf)
+		exit(1);
+	erofs_io_pread(vout, outbuf, len, offset);
+	write(STDOUT_FILENO, outbuf, len);
+	erofs_io_close(vout);
+	return 0;
+}
+
+#endif
-- 
2.43.5


