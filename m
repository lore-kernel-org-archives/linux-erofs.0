Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9993606A320
	for <linux-erofs@archiver.kernel.org>; Wed, 18 Nov 2026 11:25:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=J+deZcaz
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4jTzmY4HGbz2xlY;
	Wed, 18 Nov 2026 22:25:33 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2607:f8b0:4864:20::629"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1795001133;
	cv=none; b=SSRx2DZMx6GxxgYxKIwofLFkIgIB2ksQJLG8xVaClZteARReWdC7E3CF7exk+YUu1KySlyEk3JF+ECCCjBHV9SNcTEo6fKdgA60Kr0UQR+e9pB8NbaTXYHTJManobKN+Liw9zSQKr3ts6XeI8EGvH61nsnIcRr0Ky2jL6OAJRHC60uOcDlePtCGgAyjzEIvp/PnntwmL4dmuQzQGS+mfNKLlzr6nhObyRU8auM210NFAzS8nLB6LtPK/fKOSyp/Wuz4pUpjbbwiIiuYj5XceYd45NFXiOLwtIUhyDNRIpiWYJhpPa11DuLXX0iCCr0TO2Ha+zFqapg7kH8kMzhM+EA==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1795001133; c=relaxed/relaxed;
	bh=YoWmRHzC0ZELuZ7/SC3fVKMECkRMqpESbzYlx1qsT7E=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=NyO/ZGTpUOCmPxJ8eSHveSV7x5bvudbq54N2GsoJFfmljH8SE9gtwrH1du7HpdSaIye61n0eNL1cbHCp3S5W9TXIK3thYwr/WMDh4tnxKHN6LDkrlrr3rpec2DedIdR+ACMm25iutzhhDH+tSACaTe67UdOyAq0KDSj3Lm3d3TkK3x5qPTyZQF9umPv0x9DXOsXmZww0/IPqBNt47AscLg5w51qIqhGKeBX3m5MJ23GsmkjPgtzt9Y9r2dVdW+w+QG7suMgF38KcM10Sk+0PrPyq1oeqUtKhpTslupx4xYW/93E9S7T79Xw5Xo5vDuBOyPRNH82YH0qSqwwku074vg==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=gmail.com; dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=J+deZcaz; dkim-atps=neutral; spf=pass (client-ip=2607:f8b0:4864:20::629; helo=mail-pl1-x629.google.com; envelope-from=leeonion.muyu@gmail.com; receiver=lists.ozlabs.org) smtp.mailfrom=gmail.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=J+deZcaz;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=gmail.com (client-ip=2607:f8b0:4864:20::629; helo=mail-pl1-x629.google.com; envelope-from=leeonion.muyu@gmail.com; receiver=lists.ozlabs.org)
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4jTzmX6cZPz2xSl
	for <linux-erofs@lists.ozlabs.org>; Wed, 18 Nov 2026 22:25:32 +1100 (AEDT)
Received: by mail-pl1-x629.google.com with SMTP id d9443c01a7336-2eff722a480so4385305ad.0
        for <linux-erofs@lists.ozlabs.org>; Wed, 18 Nov 2026 03:25:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795001131; x=1795605931; darn=lists.ozlabs.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=YoWmRHzC0ZELuZ7/SC3fVKMECkRMqpESbzYlx1qsT7E=;
        b=J+deZcazVWvtgBrCby1EMWl8SfKDqp371of0qsZ95a2qwaufhk13OTzuwCAFXKTTTU
         mYrvPoNksSQJxQPdC8zAgOlLPYQ+zA382k27ND1QLaLjbbHluuJdXD1upoMquOPNKahq
         1vKK6BOuLczxtGy7tPGc6G7dkWiLfPruTs0FxDfImOBI/Y18/mmS2Vy5Hj3N6T61vRbm
         cFU5EZs7IktLqWj3vEbfxZeOCXPV/5DxOZK5Cnfcy47JsW95MgZADBSpV04MAvvp5PQ5
         OOxKUMyADgdwMWAzmUOjMNFSQw627weoojdqP09qfntaT8dZUWScphOrWOzLLAU0CGHM
         VMFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795001131; x=1795605931;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=YoWmRHzC0ZELuZ7/SC3fVKMECkRMqpESbzYlx1qsT7E=;
        b=m+BiyM5fqap0qo3xbpcflWvFVR0/L4GU4G7NCQ07VURtbKmZhrRwZNQKCWEeMBxgr/
         TuwqrO9zl2u++k+ACdxKI4QA2ZDxAfKDxgjdPyAihkGRHci8reou+lnOgnhHI/huQnFS
         f1a5wX9hA7muePcoyI88MRtnusnzNZhrkI84Lbv51Udp2pDnfmH8/GJ+sE7E/IwTRGD5
         BYFhm9Mf0Ik3sBqoyurQpPQeVeV6UXcDqJ+dQ2WT6S9lTbJ9Ad841uquVdfaKh6+Eb3Q
         AHGYgwJV5m6xyPsVSG2Ivzx+iSCzVRZmkmTvOrrI3QAGgKPaNFlNA+QMkdG6eEGqfzUm
         rDrA==
X-Gm-Message-State: APuU4Z+yAGLPzBbJQkqdKNLnh/tuoSS/0nPg1Lwlc/3We099v+JfsMsn
	JNiAw1bmZs0sOxmKKFeMRk7jmsqyK/xQ12k4xij71OxTg+fO7X26VOSg
X-Gm-Gg: AZFdTZemrWPdLNzyMOVS1P6Bd+4RIUxtbgSR4dVkWw4aGVbpujjyQfQqFTPCm+ncrfV
	Ex/+aMGMYc4CBNoP66EAMcJGuQDReMFrtWCXc/1SoAH/UPtupuavHkrmw3uYAN+JMHt87inSHjN
	3DX+TfYTs3ANClv/xKEcPW3Yop9lrBw8x8w6JB530XNHwxTiWdZBuI5lXg6e2GxY4mEVk+xl2q1
	vbX/jOBkJflZ3DUxx06aV9c0uK85yTJeTrRvj8N0BAJGGvR2/ENS2XVMhlEnNRemj7t9cjwXISu
	2FXf1vUXrq6ufjBtHQXQIZ+Zi7yRJC22Ij+oWjtcPVayzaxLO9mH0txFAplnryUjtmzqIZ/yNKQ
	CPCR6VGlQjOZdANmYy6sUyiZWZwadGJu2tr/wrYuBkXw4Eea0QYx90bHqWMwP9Rpn4fRStwjrv9
	sBchdQsov5eH/smIPzg5rvKv8xSmFZdyVXAUZTuX3pZEUL7lVUGie1Nul4fQvt6fBDiokLUg2z5
	BqOtGS9g+N5Lp7c0P5HeYP3ezfhVAr0KjODVzTnds9zfpdLATQLzkKmyRYrJuYHa5Yfex4uP4qU
	dxM3ShfvyWzt4YpR3bu1m/IBjBgqOa4APQ==
X-Received: by 2002:a17:903:384d:b0:2e8:95d8:6423 with SMTP id d9443c01a7336-2efd9eeba96mr39665665ad.38.1795001130590;
        Wed, 18 Nov 2026 03:25:30 -0800 (PST)
Received: from server225.. ([39.170.101.209])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2eff6183f8csm11702945ad.31.2026.11.18.03.25.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Nov 2026 03:25:29 -0800 (PST)
From: Ping Li <leeonion.muyu@gmail.com>
To: xiang@kernel.org,
	chao@kernel.org
Cc: linux-erofs@lists.ozlabs.org,
	linux-kernel@vger.kernel.org,
	zbestahu@gmail.com,
	jefflexu@163.com,
	dhavale@google.com,
	hongbohbli@tencent.com,
	guochunhai@vivo.com,
	Ping Li <leeonion.muyu@gmail.com>
Subject: [PATCH] erofs: preserve unspecified options on remount
Date: Wed, 18 Nov 2026 19:25:23 +0800
Message-Id: <20261118112523.3824782-1-leeonion.muyu@gmail.com>
X-Mailer: git-send-email 2.34.1
X-Mailing-List: linux-erofs@lists.ozlabs.org
List-Id: <linux-erofs.lists.ozlabs.org>
List-Help: <mailto:linux-erofs+help@lists.ozlabs.org>
List-Owner: <mailto:linux-erofs+owner@lists.ozlabs.org>
List-Post: <mailto:linux-erofs@lists.ozlabs.org>
List-Subscribe: <mailto:linux-erofs+subscribe@lists.ozlabs.org>,
  <mailto:linux-erofs+subscribe-digest@lists.ozlabs.org>,
  <mailto:linux-erofs+subscribe-nomail@lists.ozlabs.org>
Precedence: list
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Before the fs_context conversion, erofs_remount() parsed the new
options on top of the live option set, so an option not mentioned
in the remount data kept its current value.  After the conversion,
erofs_fc_reconfigure() swaps in a freshly parsed option set, so
every option left unspecified is silently reset to its default.

In practice util-linux and busybox mount paper over this by
re-sending the options shown in /proc/mounts, but any caller doing
a mount(2) remount with NULL or partial data silently loses e.g.
cache_strategy or, on a filesystem mounted with inode_share, the
page cache sharing feature itself -- memory usage then silently
grows once new inodes stop deduplicating.  It can be observed on a
mount of "-o domain_id=test,inode_share" followed by:

    mount(NULL, mnt, NULL, MS_RDONLY | MS_REMOUNT, NULL);

which returns 0 while "inode_share" disappears from /proc/mounts.

Fix it by seeding the reconfigure option set from the live one,
in the same spirit as ext4 (fc->s_fs_info = EXT4_SB(sb)) and
tmpfs (only "seen" options applied).

Fixes: f57a3fe44995a ("erofs: convert to use the new mount fs_context api")
Signed-off-by: Ping Li <leeonion.muyu@gmail.com>
---
 fs/erofs/super.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/erofs/super.c b/fs/erofs/super.c
index c2c652522fad..305b2daa343f 100644
--- a/fs/erofs/super.c
+++ b/fs/erofs/super.c
@@ -1000,6 +1000,13 @@ static int erofs_init_fs_context(struct fs_context *fc)
 	idr_init(&sbi->devs->tree);
 	init_rwsem(&sbi->devs->rwsem);
 	erofs_default_options(sbi);
+	/*
+	 * On remount, start from the current option set so that options
+	 * left unspecified this round keep their existing values rather
+	 * than being silently reset to defaults.
+	 */
+	if (fc->purpose == FS_CONTEXT_FOR_RECONFIGURE)
+		sbi->opt = EROFS_SB(fc->root->d_sb)->opt;
 	fc->ops = &erofs_context_ops;
 	return 0;
 }

base-commit: 79f9e56d1bbf598503b240b8119624602e7ef3d2
-- 
2.34.1


