Return-Path: <SRS0=DYSV=XN=lists.ozlabs.org=linux-erofs-bounces+linux-erofs=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2B8CC4CEC4
	for <linux-erofs@archiver.kernel.org>; Wed, 18 Sep 2019 08:29:35 +0000 (UTC)
Received: from lists.ozlabs.org (lists.ozlabs.org [203.11.71.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 53FFD20640
	for <linux-erofs@archiver.kernel.org>; Wed, 18 Sep 2019 08:29:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 53FFD20640
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Received: from bilbo.ozlabs.org (lists.ozlabs.org [IPv6:2401:3900:2:1::3])
	by lists.ozlabs.org (Postfix) with ESMTP id 46YCnn0c0NzF3BG
	for <linux-erofs@archiver.kernel.org>; Wed, 18 Sep 2019 18:29:33 +1000 (AEST)
Authentication-Results: lists.ozlabs.org;
 spf=pass (mailfrom) smtp.mailfrom=huawei.com
 (client-ip=45.249.212.35; helo=huawei.com;
 envelope-from=weiyongjun1@huawei.com; receiver=<UNKNOWN>)
Authentication-Results: lists.ozlabs.org;
 dmarc=none (p=none dis=none) header.from=huawei.com
X-Greylist: delayed 951 seconds by postgrey-1.36 at bilbo;
 Wed, 18 Sep 2019 18:29:26 AEST
Received: from huawei.com (szxga07-in.huawei.com [45.249.212.35])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by lists.ozlabs.org (Postfix) with ESMTPS id 46YCnf69MbzF350
 for <linux-erofs@lists.ozlabs.org>; Wed, 18 Sep 2019 18:29:24 +1000 (AEST)
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.58])
 by Forcepoint Email with ESMTP id 67232FF8DCCAFA0289D1;
 Wed, 18 Sep 2019 16:13:28 +0800 (CST)
Received: from localhost.localdomain.localdomain (10.175.113.25) by
 DGGEMS411-HUB.china.huawei.com (10.3.19.211) with Microsoft SMTP Server id
 14.3.439.0; Wed, 18 Sep 2019 16:13:20 +0800
From: Wei Yongjun <weiyongjun1@huawei.com>
To: Gao Xiang <xiang@kernel.org>, Chao Yu <chao@kernel.org>, Gao Xiang
 <gaoxiang25@huawei.com>
Subject: [PATCH -next] erofs: fix return value check in erofs_read_superblock()
Date: Wed, 18 Sep 2019 08:30:33 +0000
Message-ID: <20190918083033.47780-1-weiyongjun1@huawei.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.175.113.25]
X-CFilter-Loop: Reflected
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
Cc: linux-erofs@lists.ozlabs.org, kernel-janitors@vger.kernel.org,
 Wei Yongjun <weiyongjun1@huawei.com>, linux-kernel@vger.kernel.org
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs"
 <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>

In case of error, the function read_mapping_page() returns
ERR_PTR() not NULL. The NULL test in the return value check
should be replaced with IS_ERR().

Fixes: fe7c2423570d ("erofs: use read_mapping_page instead of sb_bread")
Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
---
 fs/erofs/super.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/erofs/super.c b/fs/erofs/super.c
index caf9a95173b0..0e369494f2f2 100644
--- a/fs/erofs/super.c
+++ b/fs/erofs/super.c
@@ -105,9 +105,9 @@ static int erofs_read_superblock(struct super_block *sb)
 	int ret;
 
 	page = read_mapping_page(sb->s_bdev->bd_inode->i_mapping, 0, NULL);
-	if (!page) {
+	if (IS_ERR(page)) {
 		erofs_err(sb, "cannot read erofs superblock");
-		return -EIO;
+		return PTR_ERR(page);
 	}
 
 	sbi = EROFS_SB(sb);



