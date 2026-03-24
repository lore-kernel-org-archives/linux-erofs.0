Return-Path: <linux-erofs+bounces-2971-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2B92CF54AD2
	for <linux-erofs@archiver.kernel.org>; Tue, 24 Mar 2026 15:54:28 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4fgF363zXxz2ynP;
	Wed, 25 Mar 2026 02:54:26 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=115.124.30.98
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1774367666;
	cv=none; b=SMA4yU4spCqEO0E2kUrkXI2CFNKXlZk33+ZVX0Z6nc0qhCI+/kLNcol8GjY1Pc5ApM3OE95H/Ntx6XbiIAGaAOKlezVT6ycPnvefyKfpTiAdnAGB+0BS+JrQPwdSjDiKKruNId1b3MCb0d8uAipPZYXRhvNO73NYq5HCDrj20uPm1B1WO9C8L6LVsD5BkUaA3RDfcN5Eb9YWzrcgHF+dPuS+eqJVHackP32UN+TF/sNeLZxv2Xo36aGM6i2ywH75jcuslpdEiamFDeSeCyYPuEX4UXt0LGFzbAmEIgfXfwz3b1BMaITak1mL9JvFf1C4gKKLMk8UbXukjIiVSEUcyQ==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1774367666; c=relaxed/relaxed;
	bh=4hVaJmFmshKdDCM6BozTuwWtZc1MVjyP17xXKKrx3eM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=OosUARepwjq4nPG9oMijMC5slqAo6qGrXbBPPdBoUQ1QsEVW02Bn0tG8AK7kTvOE2DGR5R65JqQzBrAovdYSyJDi+0Ex5TtdxW56/UtqDLfKF7TdTNcggdJ777lTExNOKWd+NjJx8jFGSBvh3fzC4NYrmnjnlkNLReSIc736QdxCyORPauisjPSRmQGqVU0wL+Q4G7VJH9FwvItOFBfctc6ZF07PBP1hlmdm30e53pTXdjy+2BEDfoLESDXOIbO+m6B4NWsUYaykXiZJfEHTfRmaF1KMDBCh0ITe8xJDL9y1FiHuerPZ2Bb1VRnQzroQ9g6fL9Q5AFDcWCGXWNfw6Q==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=AOEBdCMI; dkim-atps=neutral; spf=pass (client-ip=115.124.30.98; helo=out30-98.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org) smtp.mailfrom=linux.alibaba.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=AOEBdCMI;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=linux.alibaba.com (client-ip=115.124.30.98; helo=out30-98.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org)
Received: from out30-98.freemail.mail.aliyun.com (out30-98.freemail.mail.aliyun.com [115.124.30.98])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4fgF325XNBz2yhZ
	for <linux-erofs@lists.ozlabs.org>; Wed, 25 Mar 2026 02:54:20 +1100 (AEDT)
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1774367656; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=4hVaJmFmshKdDCM6BozTuwWtZc1MVjyP17xXKKrx3eM=;
	b=AOEBdCMIXs16JLUjV3TRkHivZKAXGsKWfUU96FT45q+x+sRqCluJOZOlhbjHeau4RLHbZ9IjBlEBSZOfboTR7ZpZZOJ9nRMQk5/NAhSjHm6spEPDcKyophax+ND9Iw1pzOkM+HpnDlf+XFhSPVLTBCcKYeBK/ssW7fPeyo7Kstg=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R201e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam011083073210;MF=hsiangkao@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0X.esRfB_1774367648;
Received: from x31i01179.sqa.na131.tbsite.net(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0X.esRfB_1774367648 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 24 Mar 2026 23:54:13 +0800
From: Gao Xiang <hsiangkao@linux.alibaba.com>
To: linux-erofs@lists.ozlabs.org
Cc: LKML <linux-kernel@vger.kernel.org>,
	Gao Xiang <hsiangkao@linux.alibaba.com>,
	Hongbo Li <lihongbo22@huawei.com>
Subject: [PATCH v2] erofs: fix .fadvise() for page cache sharing
Date: Tue, 24 Mar 2026 23:54:07 +0800
Message-ID: <20260324155407.371642-1-hsiangkao@linux.alibaba.com>
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

Currently, .fadvise() doesn't work well if page cache sharing is on
since shared inodes belong to a pseudo fs generated with init_pseudo(),
and sb->s_bdi is the default one &noop_backing_dev_info.

Then, generic_fadvise() will just behave as a no-op if sb->s_bdi is
&noop_backing_dev_info, but as the bdev fs (the bdev fs changes
inode_to_bdi() instead), it's actually NOT a pure memfs.

Let's generate a real bdi for erofs_ishare_mnt instead.

Fixes: d86d7817c042 ("erofs: implement .fadvise for page cache share")
Cc: Hongbo Li <lihongbo22@huawei.com>
Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
---
v2:
 - handle super_setup_bdi() failure properly.

 fs/erofs/ishare.c | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/fs/erofs/ishare.c b/fs/erofs/ishare.c
index 829d50d5c717..ec433bacc592 100644
--- a/fs/erofs/ishare.c
+++ b/fs/erofs/ishare.c
@@ -200,8 +200,19 @@ struct inode *erofs_real_inode(struct inode *inode, bool *need_iput)
 
 int __init erofs_init_ishare(void)
 {
-	erofs_ishare_mnt = kern_mount(&erofs_anon_fs_type);
-	return PTR_ERR_OR_ZERO(erofs_ishare_mnt);
+	struct vfsmount *mnt;
+	int ret;
+
+	mnt = kern_mount(&erofs_anon_fs_type);
+	if (IS_ERR(mnt))
+		return PTR_ERR(mnt);
+	/* generic_fadvise() doesn't work if s_bdi == &noop_backing_dev_info */
+	ret = super_setup_bdi(mnt->mnt_sb);
+	if (ret)
+		kern_unmount(mnt);
+	else
+		erofs_ishare_mnt = mnt;
+	return ret;
 }
 
 void erofs_exit_ishare(void)
-- 
2.43.5


