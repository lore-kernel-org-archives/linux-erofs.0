Return-Path: <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8E943C7EE26
	for <linux-erofs@archiver.kernel.org>; Mon, 22 May 2023 09:22:07 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [IPv6:::1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4QPsR20WCwz3f4v
	for <linux-erofs@archiver.kernel.org>; Mon, 22 May 2023 19:22:06 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=linux.alibaba.com (client-ip=115.124.30.99; helo=out30-99.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=<UNKNOWN>)
Received: from out30-99.freemail.mail.aliyun.com (out30-99.freemail.mail.aliyun.com [115.124.30.99])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4QPsQq2zcLz3bxL
	for <linux-erofs@lists.ozlabs.org>; Mon, 22 May 2023 19:21:53 +1000 (AEST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R451e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046049;MF=hsiangkao@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0VjCMWO._1684747302;
Received: from e18g06460.et15sqa.tbsite.net(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0VjCMWO._1684747302)
          by smtp.aliyun-inc.com;
          Mon, 22 May 2023 17:21:47 +0800
From: Gao Xiang <hsiangkao@linux.alibaba.com>
To: linux-erofs@lists.ozlabs.org
Subject: [PATCH] erofs: use HIPRI by default if per-cpu kthreads are enabled
Date: Mon, 22 May 2023 17:21:41 +0800
Message-Id: <20230522092141.124290-1-hsiangkao@linux.alibaba.com>
X-Mailer: git-send-email 2.24.4
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
Cc: Gao Xiang <hsiangkao@linux.alibaba.com>, LKML <linux-kernel@vger.kernel.org>, Sandeep Dhavale <dhavale@google.com>
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs" <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>

As Sandeep shown [1], high priority RT per-cpu kthreads are
typically helpful for Android scenarios to minimize the scheduling
latencies.

Switch EROFS_FS_PCPU_KTHREAD_HIPRI on by default if
EROFS_FS_PCPU_KTHREAD is on since it's the typical use cases for
EROFS_FS_PCPU_KTHREAD.

Also clean up unneeded sched_set_normal().

[1] https://lore.kernel.org/r/CAB=BE-SBtO6vcoyLNA9F-9VaN5R0t3o_Zn+FW8GbO6wyUqFneQ@mail.gmail.com
Cc: Sandeep Dhavale <dhavale@google.com>
Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
---
 fs/erofs/Kconfig | 1 +
 fs/erofs/zdata.c | 2 --
 2 files changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/erofs/Kconfig b/fs/erofs/Kconfig
index 704fb59577e0..f259d92c9720 100644
--- a/fs/erofs/Kconfig
+++ b/fs/erofs/Kconfig
@@ -121,6 +121,7 @@ config EROFS_FS_PCPU_KTHREAD
 config EROFS_FS_PCPU_KTHREAD_HIPRI
 	bool "EROFS high priority per-CPU kthread workers"
 	depends on EROFS_FS_ZIP && EROFS_FS_PCPU_KTHREAD
+	default y
 	help
 	  This permits EROFS to configure per-CPU kthread workers to run
 	  at higher priority.
diff --git a/fs/erofs/zdata.c b/fs/erofs/zdata.c
index 92f3a01262cf..3ba505434f03 100644
--- a/fs/erofs/zdata.c
+++ b/fs/erofs/zdata.c
@@ -367,8 +367,6 @@ static struct kthread_worker *erofs_init_percpu_worker(int cpu)
 		return worker;
 	if (IS_ENABLED(CONFIG_EROFS_FS_PCPU_KTHREAD_HIPRI))
 		sched_set_fifo_low(worker->task);
-	else
-		sched_set_normal(worker->task, 0);
 	return worker;
 }
 
-- 
2.24.4

