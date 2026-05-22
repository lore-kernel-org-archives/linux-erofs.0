Return-Path: <linux-erofs+bounces-3477-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D8524CD4F3D
	for <linux-erofs@archiver.kernel.org>; Fri, 22 May 2026 08:27:31 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4gMJLB0lVLz2xSN;
	Fri, 22 May 2026 18:27:30 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=115.124.30.119
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1779438450;
	cv=none; b=TdBwWzNiI/KuP0X1eODmDWTC+gP+N+8ps9SlkePG2MVUpT4fq4xRXr50X1fNNNfOsTbtSgSxIlq0VBa0NVIy+Z/iYaZdzHAxrTk2+8MEiBggwNLQ2cBkBnk2CGTcI14zUypwOBFsB0li4p2Hh/d7GS5Sau5DxY6TSRhfVh2dUeGgG13zZrAGgcCqfz9wF/F3xQlswS9QiuKGcAtCqvvQGhylFdx6IybuKg1GHFkp+TlaSLcODZR6BnGK9SwP3GCpnJJWyjQwxhzgpe2iKpWXGASv6lYaaVq4ZVpAAOGlHR9LUPHFX7PdJvpZs1j+/nh6MNTMa9p7oriE4ws8hVBH0g==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1779438450; c=relaxed/relaxed;
	bh=Av3NOw2DfrctqHU3cMGoOQFqriKBG8U8dr2oCOma5UM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=XNSQ9j2Hvd8h7HnXklzCox0wo9otfrgxtY6x1a0n1MkLoQqyujCvDZD/I89DceV7KTpi0Gj7lln4zlIDAU/ahnw9oOEGQ25bog0IiLokW80fW+5kwQ307gGphCutmSllazuZuy37xZKyPBb8jTK1H8u9X+mTlr/3a9/d1zsfxJAJRbeIOUI/qTZT5odtLGJojdDJ13A9wNu99cmsa0MSVUowyEdCKRrVOWPvDuUZF6Ye/4WwTzYUa+H6wMLNUbNW7aRB5fkE7thB+2/iYI6Zgf46DShOw4uuzlWvVFePW/03PCWUwM3FhOwdloWJVP9eMkKKvTqiE29k+teuwHJ8OA==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=ewEVPrvE; dkim-atps=neutral; spf=pass (client-ip=115.124.30.119; helo=out30-119.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org) smtp.mailfrom=linux.alibaba.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=ewEVPrvE;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=linux.alibaba.com (client-ip=115.124.30.119; helo=out30-119.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org)
Received: from out30-119.freemail.mail.aliyun.com (out30-119.freemail.mail.aliyun.com [115.124.30.119])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4gMJL74jl0z2xGY
	for <linux-erofs@lists.ozlabs.org>; Fri, 22 May 2026 18:27:26 +1000 (AEST)
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1779438443; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=Av3NOw2DfrctqHU3cMGoOQFqriKBG8U8dr2oCOma5UM=;
	b=ewEVPrvEsXeEayv3sx+kiEv9sfC2egcHgZpOPEEAOhgTRMx/QPaCsihfoismFD1fFHNZE7641VL5Cd4UIaUdWOnduqk4rS5qGZNQGSLiG36RE8088d2IBbKxT572lC+AnQUbxEd9zXyx1Dzx7qDKVRiB1ZuneA/UAFzw+n9mjDE=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R141e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037033178;MF=hsiangkao@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0X3O3ZGO_1779438437;
Received: from x31i01179.sqa.na131.tbsite.net(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0X3O3ZGO_1779438437 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 22 May 2026 16:27:21 +0800
From: Gao Xiang <hsiangkao@linux.alibaba.com>
To: linux-erofs@lists.ozlabs.org,
	Chao Yu <chao@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
	oliver.yang@linux.alibaba.com,
	Gao Xiang <hsiangkao@linux.alibaba.com>,
	syzbot+52bae5c495dbe261a0bc@syzkaller.appspotmail.com
Subject: [PATCH] erofs: fix use-after-free on sbi->sync_decompress
Date: Fri, 22 May 2026 16:27:16 +0800
Message-ID: <20260522082716.3598160-1-hsiangkao@linux.alibaba.com>
X-Mailer: git-send-email 2.43.5
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

z_erofs_decompress_kickoff() can race with filesystem unmount, causing
a use-after-free on sbi->sync_decompress.

When I/O completes, z_erofs_endio() calls z_erofs_decompress_kickoff()
to queue z_erofs_decompressqueue_work() asynchronously. Then, after all
folios are unlocked, unmount workflow can proceed and sbi will be freed
before accessing to sbi->sync_decompress.

Thread (unmount)        I/O completion        kworker
                        queue_work
                                              z_erofs_decompressqueue_work
                                               (all folios are unlocked)
cleanup_mnt
 ..
 erofs_kill_sb
  erofs_sb_free
   kfree(sbi)
                        access sbi->sync_decompress  // UAF!!

Fixes: 40452ffca3c1 ("erofs: add sysfs node to control sync decompression strategy")
Reported-by: syzbot+52bae5c495dbe261a0bc@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=52bae5c495dbe261a0bc
Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
---
 fs/erofs/zdata.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/erofs/zdata.c b/fs/erofs/zdata.c
index 27ab7bd844ec..c6240dccbb0f 100644
--- a/fs/erofs/zdata.c
+++ b/fs/erofs/zdata.c
@@ -1455,6 +1455,9 @@ static void z_erofs_decompress_kickoff(struct z_erofs_decompressqueue *io,
 	if (atomic_add_return(bios, &io->pending_bios))
 		return;
 	if (z_erofs_in_atomic()) {
+		/* See `sync_decompress` in sysfs-fs-erofs for more details */
+		if (sbi->sync_decompress == EROFS_SYNC_DECOMPRESS_AUTO)
+			sbi->sync_decompress = EROFS_SYNC_DECOMPRESS_FORCE_ON;
 #ifdef CONFIG_EROFS_FS_PCPU_KTHREAD
 		struct kthread_worker *worker;
 
@@ -1471,9 +1474,6 @@ static void z_erofs_decompress_kickoff(struct z_erofs_decompressqueue *io,
 #else
 		queue_work(z_erofs_workqueue, &io->u.work);
 #endif
-		/* See `sync_decompress` in sysfs-fs-erofs for more details */
-		if (sbi->sync_decompress == EROFS_SYNC_DECOMPRESS_AUTO)
-			sbi->sync_decompress = EROFS_SYNC_DECOMPRESS_FORCE_ON;
 		return;
 	}
 	gfp_flag = memalloc_noio_save();
-- 
2.43.5


