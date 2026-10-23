Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92300606A31F
	for <linux-erofs@archiver.kernel.org>; Fri, 23 Oct 2026 02:19:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=sony.com header.i=@sony.com header.a=rsa-sha256 header.s=s1jp header.b=SG6WOWOs
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4j9mtl0ztlz2xlZ;
	Fri, 23 Oct 2026 13:19:43 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2001:cf8:acf:41::8"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1792721983;
	cv=none; b=Sz1KeI61OhR9xxe0yoLjeSQW5UdKzEPoC/kGpran7WfCQsef0fBIfQtMaB/bqGWcVx1Ytztc9ljh+FZ+ZiNK+EDUzPt3fzRuqBtDqwrHgbaIio54YmRLRO8wV9aZjg/4SvJIOXQb7k8epyFIhz7KqWfWMlAj0GNdSCmJvPfhzfe++nMSPVUgsBKFJjaKmanH8x1rmjHg6PzBE/vBqbb1OcRJM/0qYYAT86rHwjGXtpatIFxqsD6LncpvMKDkylYaUt+ZRMBLPlu55b35Z07F+u7i0FqHtASWWIX5PZrvJsM8ltc+kPYwIjIVmXloD2XHC3WCBpt8wOFbsLNBPprMGA==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1792721983; c=relaxed/relaxed;
	bh=aAWFseEF0M/Hl3cR2tptx6HrylBbJWi8q1fxT2EXnXM=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=gXjcuMwzpLpIkSUDPhxrU6koyV41dXLK39i4BInQ9Pk2n/guOmuCynUju0GhBspzErkrXQ2FpVfvMl7WxJZtmzItSUxY2haFRWHW76sD+BKvzMQytp/ifNAbJZV6sARd3YcsQv0Z7h8o+kB3JIxKo+QOA+B3RJmzYedvAF+H6eLmljMNTN3SaKQ2VnoYK6hATTrWmjzsNI+Yo2iI5CnF9+e+IJDfS7DYClnYMOJeElixF3wgden2e2mSCPGdFOeUV40TB2E8TVGDR7+O+P/4DlJ0ZE0R4XxDPdss0PPyakouGJ8R5YElsN3USZfOdGrIRGaXjBbvA3x+2MDzFdxZGg==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=sony.com; dkim=pass (2048-bit key; unprotected) header.d=sony.com header.i=@sony.com header.a=rsa-sha256 header.s=s1jp header.b=SG6WOWOs; dkim-atps=neutral; spf=pass (client-ip=2001:cf8:acf:41::8; helo=jpms-ob02-os7.noc.sony.co.jp; envelope-from=friendy.su@sony.com; receiver=lists.ozlabs.org) smtp.mailfrom=sony.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=sony.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=sony.com header.i=@sony.com header.a=rsa-sha256 header.s=s1jp header.b=SG6WOWOs;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=sony.com (client-ip=2001:cf8:acf:41::8; helo=jpms-ob02-os7.noc.sony.co.jp; envelope-from=friendy.su@sony.com; receiver=lists.ozlabs.org)
Received: from jpms-ob02-os7.noc.sony.co.jp (jpms-ob02-os7.noc.sony.co.jp [IPv6:2001:cf8:acf:41::8])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4j9mth5jjnz2xKx
	for <linux-erofs@lists.ozlabs.org>; Fri, 23 Oct 2026 13:19:39 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=sony.com; s=s1jp; t=1792721981; x=1824257981;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=aAWFseEF0M/Hl3cR2tptx6HrylBbJWi8q1fxT2EXnXM=;
  b=SG6WOWOsxMTPjWAEJXOqf8GPaHc2cUkSrfaR+JMq3QsHGBgJV7DIroir
   A7Ldmo1nGfr87CoxTDDXO3G+IOjhkD/jz8fSfpOjrsMJRbEKr73jBcxW3
   XOsHv7eQ7SR6wtrVTAakjLyBbU9/A8UB1Lf9GWjDYulZQuS/PL2/YukL1
   /j2ASX6/8tFCZPuuOI2NFpOSOpsFC6APQu60S3oBN5UeGYkBrapUQExyk
   VFAi7TBtbVD6h1rP2kcdfAYqp1fjwVw0fOAqRNsawCMlZvjigE5+olpkK
   5FuqOHQucTjomQxn+knIPopehQctEqQ5IX8O444fv6JnWdmPAT8f/Lhhn
   Q==;
X-CSE-ConnectionGUID: TfZWqo8WTH6FGzxDNMOQng==
X-CSE-MsgGUID: u4RQ4YR+RX+E2Zz4CEo+FQ==
Received: from unknown (HELO jpmta-ob01-os7.noc.sony.co.jp) ([IPv6:2001:cf8:acf:1104::6])
  by jpms-ob02-os7.noc.sony.co.jp with ESMTP/TLS/TLS_AES_256_GCM_SHA384; 23 Oct 2026 11:19:34 +0900
X-CSE-ConnectionGUID: +Ou05pHdSdeiUz+aDjpD5Q==
X-CSE-MsgGUID: 031jg9LFS6upltFkcIgM9g==
X-IronPort-AV: E=Sophos;i="6.27,166,1786978800"; 
   d="scan'208";a="75838793"
Received: from unknown (HELO cscsh-5109200313.ap.sony.com) ([43.82.111.223])
  by jpmta-ob01-os7.noc.sony.co.jp with ESMTP; 23 Oct 2026 11:19:33 +0900
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
Subject: [PATCH v2] erofs: set SB_I_ALLOW_HSM for bdev-based mounts
Date: Fri, 23 Oct 2026 10:16:35 +0800
Message-Id: <20261023021635.2852395-1-friendy.su@sony.com>
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
X-Spam-Status: No, score=-19.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

SB_I_ALLOW_HSM makes erofs support fanotify FAN_PRE_ACCESS event
for bdev-based mounts. file-backed mounts do not support this.

This is for use case that erofs file data is not available on
local block device at mount, but need to be filled at fanotify
FAN_PRE_ACCESS event handler.

E.g. format erofs to blob mode, meta data on /dev/pmem0, file data
on blob device /dev/pmem1. The file content in blob device is dummy.

mount as below:

$ sudo mount -o dax,device=/dev/pmem1 /dev/pmem0 /mnt/erofs/

In FAN_PRE_ACCESS handler, actual file content is fetched from remote
then filled into the DAX mounted block device /dev/pmem1.

Signed-off-by: Friendy Su <friendy.su@sony.com>
Reviewed-by: Yuezhang Mo <Yuezhang.Mo@sony.com>
Reviewed-by: Daniel Palmer <daniel.palmer@sony.com>
---
 fs/erofs/super.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/fs/erofs/super.c b/fs/erofs/super.c
index 0967aace9f7f..be8728b8d116 100644
--- a/fs/erofs/super.c
+++ b/fs/erofs/super.c
@@ -667,6 +667,15 @@ static int erofs_fc_fill_super(struct super_block *sb, struct fs_context *fc)
 		errorfc(fc, "FSDAX is not allowed when inode_share is on");
 		return -EINVAL;
 	}
+	if (!erofs_is_fileio_mode(sbi)) {
+		/*
+		 * Only enable HSM to support fanotify FAN_PRE_ACCESS event
+		 * under block device backed mounts.
+		 * For file-backed mounts, do not enable since erofs-utils
+		 * has already supported FAN_PRE_ACCESS event on backend image.
+		 */
+		sb->s_iflags |= SB_I_ALLOW_HSM;
+	}
 
 	sbi->blkszbits = PAGE_SHIFT;
 	if (erofs_is_fileio_mode(sbi)) {
-- 
2.34.1


