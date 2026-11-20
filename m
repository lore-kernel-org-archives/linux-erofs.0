Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58C0660A2602
	for <linux-erofs@archiver.kernel.org>; Fri, 20 Nov 2026 03:22:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sony.com header.i=@sony.com header.a=rsa-sha256 header.s=s1jp header.b=uBiCWNaB
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4jW0y240J9z2xLt;
	Fri, 20 Nov 2026 14:22:18 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2001:cf8:acf:41::7"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1795144938;
	cv=none; b=X6qhn/H0W4CejSlkGmtIjOuLlfoR8vGtKBiTHYy2AZtLB6xQXDlcSVwotI7aF6wtfPq92LAXAQV+0Sd9BLo07ws+BhevC3NF67YtBqjgJdwb3W9ArgObdXKq+Helu40Wls2DWy07yMKIrEpLwmuCM1qhSNjBVVdaQl49+BzzyuiTC77Vsnmc7DRtezXcZ8fwLiWu/h0tZiqy/OdvfE2J0wqS8Xww0ijx+bwdGur1luzgH67xyR61EdCJzdN4dqHE6HvumBvVa4zCeuO45bJpTCtaJLYbBnj6fMOjS4cHf7gK/WjnFrrFZSSc5c+hEdAmJM+gjb1JlCefUKKNYkkT2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1795144938; c=relaxed/relaxed;
	bh=QX5Pn6Wnb4UoeoOJOWQY8hREz2NI4GOQ6dhczU3Ype4=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=Dua1IezgZj3QrPn7aSADmBooyrr/ZMLOQu0GMysz9W8TV7pKD0MWoVTcYct4FmVpYwAhv7zuiNpFkbR83OkJcrh2tE27K6+YpfXHvGpuRLxxLfq4JXELl6BZJQkSlJYiilVymM+ikm8druP92ky4da4aE51/kiOTAakYK2t+Ku6ZcfyFTX4wa0Wl1jyxWts5SCCzGZRf7ydLTD2faBZHQfx2hcBDljc/sR1XRn8AhNE+czbjvnCFNFvsE4pzo2E0FkxU6YCzATBHCjbJyWqaI/UHTkLvvCs9Qwmw4wh0HApUBt0TQefv/kigXE9dQGThhV4WAOEU7+OaoJu/QKpelQ==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=sony.com; dkim=pass (2048-bit key; unprotected) header.d=sony.com header.i=@sony.com header.a=rsa-sha256 header.s=s1jp header.b=uBiCWNaB; dkim-atps=neutral; spf=pass (client-ip=2001:cf8:acf:41::7; helo=jpms-ob01-os7.noc.sony.co.jp; envelope-from=friendy.su@sony.com; receiver=lists.ozlabs.org) smtp.mailfrom=sony.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=sony.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=sony.com header.i=@sony.com header.a=rsa-sha256 header.s=s1jp header.b=uBiCWNaB;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=sony.com (client-ip=2001:cf8:acf:41::7; helo=jpms-ob01-os7.noc.sony.co.jp; envelope-from=friendy.su@sony.com; receiver=lists.ozlabs.org)
Received: from jpms-ob01-os7.noc.sony.co.jp (jpms-ob01-os7.noc.sony.co.jp [IPv6:2001:cf8:acf:41::7])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4jW0y052pqz2x99
	for <linux-erofs@lists.ozlabs.org>; Fri, 20 Nov 2026 14:22:14 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=sony.com; s=s1jp; t=1795144936; x=1826680936;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=QX5Pn6Wnb4UoeoOJOWQY8hREz2NI4GOQ6dhczU3Ype4=;
  b=uBiCWNaBuW2b/WpcUtc+GS+FnAdO3Vq2Up+ghZiQSGbEMifqtcN0cPqD
   PBSbNcbEB5/f5ICi5cnHMsdobZWrIpIdXZEhSNK+yQ9cozGGPHbELGXfs
   3udnDDgqjLh2jnshokrRNV/5YGKkk0rEgf/WEh5s5xba/LklY4isU5mF+
   qZE8wufvF9+xMPLrlBwcLudpsM5EUCb+k6Q8t2GpJ7nUpESZyZhzK9tlo
   QAZVNke2RFTmDJFikxdvFI/WBGHp26kuWyper27jeFPTLojH3gogqjNyY
   OYZp6A8aUyd4y7S1WD2NHwABk0/k2dRJYI+I3GQJ7BO7fGX2z0IAf5Oxt
   g==;
X-CSE-ConnectionGUID: YxWLKFnpR/6RF40UfcCstg==
X-CSE-MsgGUID: RBasym9hTnGK9EtiFoeI/g==
Received: from unknown (HELO jpmta-ob01-os7.noc.sony.co.jp) ([IPv6:2001:cf8:acf:1104::6])
  by jpms-ob01-os7.noc.sony.co.jp with ESMTP/TLS/TLS_AES_256_GCM_SHA384; 20 Nov 2026 12:22:08 +0900
X-CSE-ConnectionGUID: zXGdvRdHTiitO4LDGqUUuw==
X-CSE-MsgGUID: 8NRGQHi7SjmMdFuR627dQg==
X-IronPort-AV: E=Sophos;i="6.27,166,1786978800"; 
   d="scan'208";a="86754485"
Received: from unknown (HELO cscsh-5109200313.ap.sony.com) ([43.82.111.223])
  by jpmta-ob01-os7.noc.sony.co.jp with ESMTP; 20 Nov 2026 12:22:08 +0900
From: Friendy Su <friendy.su@sony.com>
To: xiang@kernel.org,
	chao@kernel.org,
	jack@suse.cz,
	amir73il@gmail.com
Cc: linux-erofs@lists.ozlabs.org,
	linux-kernel@vger.kernel.org,
	Friendy Su <friendy.su@sony.com>,
	Yuezhang Mo <Yuezhang.Mo@sony.com>,
	Daniel Palmer <daniel.palmer@sony.com>
Subject: [PATCH v3] erofs: set SB_I_ALLOW_HSM for bdev-based mounts
Date: Fri, 20 Nov 2026 11:19:09 +0800
Message-Id: <20261120031909.1757230-1-friendy.su@sony.com>
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
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Set SB_I_ALLOW_HSM to enable fanotify FAN_PRE_ACCESS events for
bdev-backed mounts. File-backed mounts are not supported.

This allows EROFS to handle cases where file data is not available
locally at mount time and needs to be fetched on demand by a
FAN_PRE_ACCESS event handler.

For example, an EROFS image can use blob mode with metadata stored
on /dev/pmem0 and file data on /dev/pmem1, where the latter initially
contains dummy data.

The filesystem can be mounted with:

    mount -o dax,device=/dev/pmem1 /dev/pmem0 /mnt/erofs

On receiving a FAN_PRE_ACCESS event, the handler fetches the actual
file data from a remote source and fills the corresponding blocks
on /dev/pmem1 before access proceeds.

Signed-off-by: Friendy Su <friendy.su@sony.com>
Reviewed-by: Yuezhang Mo <Yuezhang.Mo@sony.com>
Reviewed-by: Daniel Palmer <daniel.palmer@sony.com>
---
 fs/erofs/super.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/fs/erofs/super.c b/fs/erofs/super.c
index ce05557bd998..4ef4c8ce1240 100644
--- a/fs/erofs/super.c
+++ b/fs/erofs/super.c
@@ -684,6 +684,14 @@ static int erofs_fc_fill_super(struct super_block *sb, struct fs_context *fc)
 		errorfc(fc, "superblock_share does not support extra devices");
 		return -EINVAL;
 	}
+	if (!erofs_is_fileio_mode(sbi)) {
+		/*
+		 * Follow other filesystems by supporting FAN_PRE_ACCESS events
+		 * only on bdev-backed mount. Don't bother with file-backed
+		 * mounts.
+		 */
+		sb->s_iflags |= SB_I_ALLOW_HSM;
+	}
 
 	sbi->blkszbits = PAGE_SHIFT;
 	if (erofs_is_fileio_mode(sbi)) {
-- 
2.34.1


