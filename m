Return-Path: <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6A56BC2BD05
	for <linux-erofs@archiver.kernel.org>; Mon, 24 Jun 2024 06:51:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=lists.ozlabs.org;
	s=201707; t=1719211909;
	bh=Lvox0fsHtJOtWmd9MoEJ7nOxTSjC0BjxThURgNSUFTE=;
	h=To:Subject:Date:List-Id:List-Unsubscribe:List-Archive:List-Post:
	 List-Help:List-Subscribe:From:Reply-To:Cc:From;
	b=N9Fnc/qjaiCduj4N3CFDyq78CMnSPX0N657mfQEv8sYKs9Iv5oKmCJLuFDgu7YVmT
	 VEShDznZDdjEdmz6uYMZDSGAguK0O1xvLS3xZdy7qbihqd2wbYyLPt+WpXY9keCxSx
	 EBxDyWpwliK5fvhOiYE18vKRtHIfu51C+TGkKLb/qm8l3qvb0xUqFiDQKiItPc85is
	 Cqqhm7YcciT5xrKk5j+hNrr0bar8gXacE6mQDcDOpmKJEYtwoE8eSaDWO3MWIw6i44
	 ph1P4U4S8nINGe+DBMDKt/QCK13u9ZzWEOcTnLU9ZubiHuZ6mcBe/hnLEUT3MFLUd7
	 KPv+BoGcMSYxw==
Received: from boromir.ozlabs.org (localhost [IPv6:::1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4W6zCT2f3Jz3cWS
	for <linux-erofs@archiver.kernel.org>; Mon, 24 Jun 2024 16:51:49 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=huawei.com (client-ip=45.249.212.32; helo=szxga06-in.huawei.com; envelope-from=huangxiaojia2@huawei.com; receiver=lists.ozlabs.org)
X-Greylist: delayed 1060 seconds by postgrey-1.37 at boromir; Mon, 24 Jun 2024 16:51:43 AEST
Received: from szxga06-in.huawei.com (szxga06-in.huawei.com [45.249.212.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4W6zCM4C0Kz30Vd
	for <linux-erofs@lists.ozlabs.org>; Mon, 24 Jun 2024 16:51:41 +1000 (AEST)
Received: from mail.maildlp.com (unknown [172.19.162.112])
	by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4W6yn96Fjzz1xsvp;
	Mon, 24 Jun 2024 14:32:29 +0800 (CST)
Received: from dggpemm500021.china.huawei.com (unknown [7.185.36.109])
	by mail.maildlp.com (Postfix) with ESMTPS id 6E0E71402CA;
	Mon, 24 Jun 2024 14:33:58 +0800 (CST)
Received: from huawei.com (10.90.53.73) by dggpemm500021.china.huawei.com
 (7.185.36.109) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.39; Mon, 24 Jun
 2024 14:33:58 +0800
To: <xiang@kernel.org>, <chao@kernel.org>, <huyue2@coolpad.com>,
	<jefflexu@linux.alibaba.com>, <dhavale@google.com>, <yuehaibing@huawei.com>
Subject: [PATCH -next] erofs: convert to use super_set_uuid to support for FS_IOC_GETFSUUID
Date: Mon, 24 Jun 2024 14:37:04 +0800
Message-ID: <20240624063704.2476070-1-huangxiaojia2@huawei.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.90.53.73]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggpemm500021.china.huawei.com (7.185.36.109)
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
From: Huang Xiaojia via Linux-erofs <linux-erofs@lists.ozlabs.org>
Reply-To: Huang Xiaojia <huangxiaojia2@huawei.com>
Cc: linux-erofs@lists.ozlabs.org
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs" <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>

FS_IOC_GETFSUUID ioctl exposes the uuid of a filesystem. To support
the ioctl, init sb->s_uuid with super_set_uuid().

Signed-off-by: Huang Xiaojia <huangxiaojia2@huawei.com>
---
 fs/erofs/super.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/erofs/super.c b/fs/erofs/super.c
index c93bd24d2771..1b91d9513013 100644
--- a/fs/erofs/super.c
+++ b/fs/erofs/super.c
@@ -343,7 +343,7 @@ static int erofs_read_superblock(struct super_block *sb)
 	sbi->build_time = le64_to_cpu(dsb->build_time);
 	sbi->build_time_nsec = le32_to_cpu(dsb->build_time_nsec);
 
-	memcpy(&sb->s_uuid, dsb->uuid, sizeof(dsb->uuid));
+	super_set_uuid(sb, (void *)dsb->uuid, sizeof(dsb->uuid));
 
 	ret = strscpy(sbi->volume_name, dsb->volume_name,
 		      sizeof(dsb->volume_name));
-- 
2.34.1

