Return-Path: <SRS0=9oqF=4B=lists.ozlabs.org=linux-erofs-bounces+linux-erofs=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45F92C2BA83
	for <linux-erofs@archiver.kernel.org>; Thu, 13 Feb 2020 14:45:47 +0000 (UTC)
Received: from lists.ozlabs.org (lists.ozlabs.org [203.11.71.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 00E5A218AC
	for <linux-erofs@archiver.kernel.org>; Thu, 13 Feb 2020 14:45:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 00E5A218AC
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=os.inf.tu-dresden.de
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Received: from lists.ozlabs.org (lists.ozlabs.org [IPv6:2401:3900:2:1::3])
	by lists.ozlabs.org (Postfix) with ESMTP id 48JK7X6z0WzDqNJ
	for <linux-erofs@archiver.kernel.org>; Fri, 14 Feb 2020 01:45:44 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; spf=none (no SPF record)
 smtp.mailfrom=os.inf.tu-dresden.de (client-ip=141.76.48.99;
 helo=os.inf.tu-dresden.de; envelope-from=mplaneta@os.inf.tu-dresden.de;
 receiver=<UNKNOWN>)
Authentication-Results: lists.ozlabs.org; dmarc=none (p=none dis=none)
 header.from=os.inf.tu-dresden.de
X-Greylist: delayed 1515 seconds by postgrey-1.36 at bilbo;
 Fri, 14 Feb 2020 01:45:34 AEDT
Received: from os.inf.tu-dresden.de (os.inf.tu-dresden.de [141.76.48.99])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
 (No client certificate requested)
 by lists.ozlabs.org (Postfix) with ESMTPS id 48JK7L54WkzDqCw
 for <linux-erofs@lists.ozlabs.org>; Fri, 14 Feb 2020 01:45:34 +1100 (AEDT)
Received: from [2002:8d4c:3001:48::120:84] (helo=jupiter)
 by os.inf.tu-dresden.de with esmtpsa (TLS1.3:TLS_AES_256_GCM_SHA384:256) (Exim
 4.93.0.3) id 1j2FKe-0000pY-M0; Thu, 13 Feb 2020 15:19:08 +0100
From: Maksym Planeta <mplaneta@os.inf.tu-dresden.de>
To: mplaneta@os.inf.tu-dresden.de, Zhou Wang <wangzhou1@hisilicon.com>,
 Herbert Xu <herbert@gondor.apana.org.au>,
 "David S. Miller" <davem@davemloft.net>, Alasdair Kergon <agk@redhat.com>,
 Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com,
 Song Liu <song@kernel.org>, Gao Xiang <xiang@kernel.org>,
 Chao Yu <chao@kernel.org>, linux-crypto@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
 linux-erofs@lists.ozlabs.org
Subject: [PATCH] Remove WQ_CPU_INTENSIVE flag from unbound wq's
Date: Thu, 13 Feb 2020 15:18:23 +0100
Message-Id: <20200213141823.2174236-1-mplaneta@os.inf.tu-dresden.de>
X-Mailer: git-send-email 2.24.1
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
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs"
 <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>

The documentation [1] says that WQ_CPU_INTENSIVE is "meaningless" for
unbound wq. I remove this flag from places where unbound queue is
allocated. This is supposed to improve code readability.

1. https://www.kernel.org/doc/html/latest/core-api/workqueue.html#flags

Signed-off-by: Maksym Planeta <mplaneta@os.inf.tu-dresden.de>
---
 drivers/crypto/hisilicon/qm.c | 3 +--
 drivers/md/dm-crypt.c         | 2 +-
 drivers/md/dm-verity-target.c | 2 +-
 drivers/md/raid5.c            | 2 +-
 fs/erofs/zdata.c              | 2 +-
 5 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/crypto/hisilicon/qm.c b/drivers/crypto/hisilicon/qm.c
index b57da5ef8b5b..4a39cb2c6a0b 100644
--- a/drivers/crypto/hisilicon/qm.c
+++ b/drivers/crypto/hisilicon/qm.c
@@ -1148,8 +1148,7 @@ struct hisi_qp *hisi_qm_create_qp(struct hisi_qm *qm, u8 alg_type)
 	qp->qp_id = qp_id;
 	qp->alg_type = alg_type;
 	INIT_WORK(&qp->work, qm_qp_work_func);
-	qp->wq = alloc_workqueue("hisi_qm", WQ_UNBOUND | WQ_HIGHPRI |
-				 WQ_CPU_INTENSIVE | WQ_MEM_RECLAIM, 0);
+	qp->wq = alloc_workqueue("hisi_qm", WQ_UNBOUND | WQ_HIGHPRI | WQ_MEM_RECLAIM, 0);
 	if (!qp->wq) {
 		ret = -EFAULT;
 		goto err_free_qp_mem;
diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index c6a529873d0f..44d56325fa27 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -3032,7 +3032,7 @@ static int crypt_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 						  1, devname);
 	else
 		cc->crypt_queue = alloc_workqueue("kcryptd/%s",
-						  WQ_CPU_INTENSIVE | WQ_MEM_RECLAIM | WQ_UNBOUND,
+						  WQ_MEM_RECLAIM | WQ_UNBOUND,
 						  num_online_cpus(), devname);
 	if (!cc->crypt_queue) {
 		ti->error = "Couldn't create kcryptd queue";
diff --git a/drivers/md/dm-verity-target.c b/drivers/md/dm-verity-target.c
index 0d61e9c67986..20f92c7ea07e 100644
--- a/drivers/md/dm-verity-target.c
+++ b/drivers/md/dm-verity-target.c
@@ -1190,7 +1190,7 @@ static int verity_ctr(struct dm_target *ti, unsigned argc, char **argv)
 	}
 
 	/* WQ_UNBOUND greatly improves performance when running on ramdisk */
-	v->verify_wq = alloc_workqueue("kverityd", WQ_CPU_INTENSIVE | WQ_MEM_RECLAIM | WQ_UNBOUND, num_online_cpus());
+	v->verify_wq = alloc_workqueue("kverityd", WQ_MEM_RECLAIM | WQ_UNBOUND, num_online_cpus());
 	if (!v->verify_wq) {
 		ti->error = "Cannot allocate workqueue";
 		r = -ENOMEM;
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index ba00e9877f02..cd93a1731b82 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -8481,7 +8481,7 @@ static int __init raid5_init(void)
 	int ret;
 
 	raid5_wq = alloc_workqueue("raid5wq",
-		WQ_UNBOUND|WQ_MEM_RECLAIM|WQ_CPU_INTENSIVE|WQ_SYSFS, 0);
+		WQ_UNBOUND|WQ_MEM_RECLAIM|WQ_SYSFS, 0);
 	if (!raid5_wq)
 		return -ENOMEM;
 
diff --git a/fs/erofs/zdata.c b/fs/erofs/zdata.c
index 80e47f07d946..b2a679f720e9 100644
--- a/fs/erofs/zdata.c
+++ b/fs/erofs/zdata.c
@@ -43,7 +43,7 @@ void z_erofs_exit_zip_subsystem(void)
 static inline int z_erofs_init_workqueue(void)
 {
 	const unsigned int onlinecpus = num_possible_cpus();
-	const unsigned int flags = WQ_UNBOUND | WQ_HIGHPRI | WQ_CPU_INTENSIVE;
+	const unsigned int flags = WQ_UNBOUND | WQ_HIGHPRI;
 
 	/*
 	 * no need to spawn too many threads, limiting threads could minimum
-- 
2.24.1

