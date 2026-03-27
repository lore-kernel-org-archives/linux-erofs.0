Return-Path: <linux-erofs+bounces-3050-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F297110BA420
	for <linux-erofs@archiver.kernel.org>; Fri, 27 Mar 2026 04:34:08 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4fhnpl4sRRz2xmX;
	Fri, 27 Mar 2026 15:34:07 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=115.124.30.119
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1774586047;
	cv=none; b=Csu/Q+nyzoH5noVYZm+CIuVo1mxqzR1WxMtSpo2D0LAbQa9533a/DytRneNuyEE8Y5OAt7K0UtqtBTbOTscO2PCs5hrOyfg4+h2059cK5sYDhFqSmhlc8k0xp2zs/LSNpJ6NLiEKvSov+PYOtqKdZvFkeeyHCvv/BQlgAq2cM3aUmn6QZ3EEV+sOeusl8cSyVUU/Ra2KWHrSw2PJ6zvGFO1u9wViYh3N3yo6pouL5kFUDWb4kqRu415Dlva6GcPfg7PepwIu9ovaTueFan+0uVO/AQi6WmCSJ3eiwDTOIBbKMw+WjK2TKsUU75mt5G0NkJk/agUBjbJV8M/UKnWncg==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1774586047; c=relaxed/relaxed;
	bh=vKvfbIED4Ic/7/VKTaCX+Ke32ydNec+/Tqe9KVUrd4A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PVbb4gz0tzrqncftm6paUocP8vwE1jPXJalau/rys826BK/plkq2x20M7R/oC/+gZsB1f2+NTJeC4egLVg1Fgu9EOkRv3RBxJDmMLscZb7utDf6sWHERjfUw9ihW0gVnmmYUZdk+sfWzgUXR5zTIBt0CfbIz5PoWTCIhMvFeCdWG5dmghe98fbFJfLT4QJO3NhapxGcSHqLPasA2x5n7e7LKAXZMzO0zz9bI7pwYPY6k4sv+k5wY+Gb0zwDEiSsfE8mhxLnR26M6MsQacGctjqNCOf2urn81myGc4F08UI9lz1IhN1xb+kYM2rw1gzjIl2YygDaxHWNOHfIwaMelTA==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=Y6UutZTL; dkim-atps=neutral; spf=pass (client-ip=115.124.30.119; helo=out30-119.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org) smtp.mailfrom=linux.alibaba.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=Y6UutZTL;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=linux.alibaba.com (client-ip=115.124.30.119; helo=out30-119.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org)
Received: from out30-119.freemail.mail.aliyun.com (out30-119.freemail.mail.aliyun.com [115.124.30.119])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4fhnpk5f1yz2xR4
	for <linux-erofs@lists.ozlabs.org>; Fri, 27 Mar 2026 15:34:06 +1100 (AEDT)
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1774586042; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=vKvfbIED4Ic/7/VKTaCX+Ke32ydNec+/Tqe9KVUrd4A=;
	b=Y6UutZTL0zAb7JOY/r4ICPLfgqnW7tgDJ5Jg8AiAT9BGx/ssQjTACJxDieZB9oewv8e1tp2JZ87er/eRsNmVYrYodF7o9bHdWh+bMB5QWvWXTwi2qMlaaC1rLXQI+fY97G6lBnjvLCBFWu+0/127aIo2k69dtCMfspMdPsKOFTo=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R101e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam011083073210;MF=hsiangkao@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0X.n3CJL_1774586041;
Received: from x31i01179.sqa.na131.tbsite.net(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0X.n3CJL_1774586041 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 27 Mar 2026 12:34:01 +0800
From: Gao Xiang <hsiangkao@linux.alibaba.com>
To: stable@vger.kernel.org,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-erofs@lists.ozlabs.org,
	Gao Xiang <hsiangkao@linux.alibaba.com>,
	Max Kellermann <max.kellermann@ionos.com>,
	Chao Yu <chao@kernel.org>,
	Alexey Panov <apanov@astralinux.ru>
Subject: [PATCH 6.1.y 2/2] erofs: fix PSI memstall accounting
Date: Fri, 27 Mar 2026 12:33:59 +0800
Message-ID: <20260327043359.1121251-1-hsiangkao@linux.alibaba.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20260327043312.1118901-1-hsiangkao@linux.alibaba.com>
References: <20260327043312.1118901-1-hsiangkao@linux.alibaba.com>
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

commit 1a2180f6859c73c674809f9f82e36c94084682ba upstream.

Max Kellermann recently reported psi_group_cpu.tasks[NR_MEMSTALL] is
incorrect in the 6.11.9 kernel.

The root cause appears to be that, since the problematic commit, bio
can be NULL, causing psi_memstall_leave() to be skipped in
z_erofs_submit_queue().

Reported-by: Max Kellermann <max.kellermann@ionos.com>
Closes: https://lore.kernel.org/r/CAKPOu+8tvSowiJADW2RuKyofL_CSkm_SuyZA7ME5vMLWmL6pqw@mail.gmail.com
Fixes: 9e2f9d34dd12 ("erofs: handle overlapped pclusters out of crafted images properly")
Reviewed-by: Chao Yu <chao@kernel.org>
Link: https://lore.kernel.org/r/20241127085236.3538334-1-hsiangkao@linux.alibaba.com
Signed-off-by: Alexey Panov <apanov@astralinux.ru>
Link: https://lore.kernel.org/r/20250304110558.8315-3-apanov@astralinux.ru
Link: https://lore.kernel.org/r/20250304110558.8315-1-apanov@astralinux.ru
[ Gao Xiang: re-address the previous Alexey's backport. ]
CVE: CVE-2024-47736
Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
---
 fs/erofs/zdata.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/fs/erofs/zdata.c b/fs/erofs/zdata.c
index aa311aed0dd8..04d4491e0073 100644
--- a/fs/erofs/zdata.c
+++ b/fs/erofs/zdata.c
@@ -1571,11 +1571,10 @@ static void z_erofs_submit_queue(struct z_erofs_decompress_frontend *f,
 			move_to_bypass_jobqueue(pcl, qtail, owned_head);
 	} while (owned_head != Z_EROFS_PCLUSTER_TAIL);
 
-	if (bio) {
+	if (bio)
 		submit_bio(bio);
-		if (memstall)
-			psi_memstall_leave(&pflags);
-	}
+	if (memstall)
+		psi_memstall_leave(&pflags);
 
 	/*
 	 * although background is preferred, no one is pending for submission.
-- 
2.43.5


