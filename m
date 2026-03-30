Return-Path: <linux-erofs+bounces-3107-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0ADADFF4959
	for <linux-erofs@archiver.kernel.org>; Mon, 30 Mar 2026 07:36:48 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4fkjk6484Nz2xpt;
	Mon, 30 Mar 2026 18:36:46 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2001:cf8:acf:41::8"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1774856206;
	cv=none; b=kbyaTM7qZlHsRHb+/vsu49j0sYXwNnjq+oWMz9AjRKnTFkKd0/HMxauu62NmANdRcJOLM+XqGDoGWI+oCBVEek2uK9D+UM3m/rv+jlgsNY2jd8v0uYSv/GgdNy1Z9+qEVjPs/Ki2jvyI7Ra4YtvgxJSJxIXtM1WKxPpUXOh+YmEPU+TdAR4WZbo4j8cFcO0TuwdvrAqneTIQXtO7KfiwsYf3jHZbn8Wgyj9MoSOFug+dqHrcOn135z4DGwtcVmBWGl6coXuYkosJFZ8OOVq080vthZAFbVBIhvo9wWVnnayPZnPRAzlnnsTm7weBn2kPIeMlojkkKYUaTiBCLoLT4A==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1774856206; c=relaxed/relaxed;
	bh=wB9as7h8t1QIBwm7u3wnc1MtOqO/hBikqxFcqRkKSIw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=eFZmZvvUDTJpVmmyTnfGZxUIA+Ev8CtIfSvSav9zu5Rs2duOML6+bLatdVL537LDtQzsJrjr9hzDVzXSArZwCGZyvxJZJlyFauTyzJPebuopfmn2Fzcd7C+/Iye2RazXZL/Z0tp9lyhNNLQyt8pkn9h7VYtg3BHz/JLQ4/vtmbqEMrOBylOwFWWqsX3732wW/+Gl82YfiCtXnCX4c1XQQoQ4NvSJIVzBfOUNFJZ701wVpRA6HHUfxxUkNGZXYkPhZy6iTy9m4w/6Iqd4YdO5Qo+lQ+uVHS1yzZfFplKub3171uMUegy6OIPUipMekqnuRS+jSeoldIu9LTNHMMrGzw==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=sony.com; dkim=pass (2048-bit key; unprotected) header.d=sony.com header.i=@sony.com header.a=rsa-sha256 header.s=s1jp header.b=DHN581SZ; dkim-atps=neutral; spf=pass (client-ip=2001:cf8:acf:41::8; helo=jpms-ob02-os7.noc.sony.co.jp; envelope-from=yuezhang.mo@sony.com; receiver=lists.ozlabs.org) smtp.mailfrom=sony.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=sony.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=sony.com header.i=@sony.com header.a=rsa-sha256 header.s=s1jp header.b=DHN581SZ;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=sony.com (client-ip=2001:cf8:acf:41::8; helo=jpms-ob02-os7.noc.sony.co.jp; envelope-from=yuezhang.mo@sony.com; receiver=lists.ozlabs.org)
Received: from jpms-ob02-os7.noc.sony.co.jp (jpms-ob02-os7.noc.sony.co.jp [IPv6:2001:cf8:acf:41::8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4fkjk44370z2xlK
	for <linux-erofs@lists.ozlabs.org>; Mon, 30 Mar 2026 18:36:42 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=sony.com; s=s1jp; t=1774856205; x=1806392205;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=wB9as7h8t1QIBwm7u3wnc1MtOqO/hBikqxFcqRkKSIw=;
  b=DHN581SZgZd9PTcbrUkuEvXYw0Hq92D+RcR/W/3UwWTrxsE08cyE/yN4
   4Bgm3aG89oTMgYpkGtdxtOkdbg9oneN+Q/uDvSt5n/KLgTBJbxyfVj7vh
   xnSab9HyvA+rU0nlPuZFSk8SiACoD/nwvY4GsZpskaFp0B/BAyw5OpxkS
   Cw2XP3qg3rlVAi591XMLejZGk/MSPRKYJfR3nUqcoH+w4OX5zGeWKJziM
   wVbaF1W7WF5DWyeTNoc7P8WpstzMfb8fx4aENMHVJ0yv5hAlTOLa1hFem
   a5j+JceTZS85V8ltaZBUGgrOcNuOgum1VYVAVtvl6IL/mrLCGE3J5gu4u
   Q==;
Received: from unknown (HELO jpmta-ob02-os7.noc.sony.co.jp) ([IPv6:2001:cf8:acf:1104::7])
  by jpms-ob02-os7.noc.sony.co.jp with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Mar 2026 16:36:35 +0900
X-CSE-ConnectionGUID: b/Xvp0/MSrSI7xozVUw1uA==
X-CSE-MsgGUID: DzJ5+YOBQj267pqNglrR1w==
X-IronPort-AV: E=Sophos;i="6.23,149,1770562800"; 
   d="scan'208";a="49838186"
Received: from unknown (HELO cscsh-7000014390..) ([43.82.111.225])
  by jpmta-ob02-os7.noc.sony.co.jp with ESMTP; 30 Mar 2026 16:36:33 +0900
From: Yuezhang Mo <Yuezhang.Mo@sony.com>
To: linux-erofs@lists.ozlabs.org
Cc: Gao Xiang <xiang@kernel.org>,
	Chao Yu <chao@kernel.org>,
	Yue Hu <zbestahu@gmail.com>,
	Jeffle Xu <jefflexu@linux.alibaba.com>,
	Sandeep Dhavale <dhavale@google.com>,
	Hongbo Li <lihongbo22@huawei.com>,
	Chunhai Guo <guochunhai@vivo.com>,
	Yuezhang Mo <Yuezhang.Mo@sony.com>,
	Friendy Su <friendy.su@sony.com>,
	Daniel Palmer <daniel.palmer@sony.com>
Subject: [PATCH v1] erofs: remove the guard of showing domain_id and fsid
Date: Mon, 30 Mar 2026 15:32:36 +0800
Message-ID: <20260330073235.3328579-2-Yuezhang.Mo@sony.com>
X-Mailer: git-send-email 2.43.0
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

This change fixes an issue where domain_id was not shown when
CONFIG_EROFS_FS_PAGE_CACHE_SHARE is enabled, as this configuration
is mutually exclusive with CONFIG_EROFS_FS_ONDEMAND.

Both domain_id and fsid fields are present in struct erofs_sb_info
regardless of configuration. They are not set if the configurations
are not enabled, and remain NULL. Therefore, the conditional guard
in erofs_show_options() are unnecessary and can be removed.

Signed-off-by: Yuezhang Mo <Yuezhang.Mo@sony.com>
Reviewed-by: Friendy Su <friendy.su@sony.com>
Reviewed-by: Daniel Palmer <daniel.palmer@sony.com>
---
 fs/erofs/super.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/fs/erofs/super.c b/fs/erofs/super.c
index 972a0c82198d..be028cdf902c 100644
--- a/fs/erofs/super.c
+++ b/fs/erofs/super.c
@@ -1095,12 +1095,10 @@ static int erofs_show_options(struct seq_file *seq, struct dentry *root)
 		seq_puts(seq, ",dax=never");
 	if (erofs_is_fileio_mode(sbi) && test_opt(opt, DIRECT_IO))
 		seq_puts(seq, ",directio");
-	if (IS_ENABLED(CONFIG_EROFS_FS_ONDEMAND)) {
-		if (sbi->fsid)
-			seq_printf(seq, ",fsid=%s", sbi->fsid);
-		if (sbi->domain_id)
-			seq_printf(seq, ",domain_id=%s", sbi->domain_id);
-	}
+	if (sbi->fsid)
+		seq_printf(seq, ",fsid=%s", sbi->fsid);
+	if (sbi->domain_id)
+		seq_printf(seq, ",domain_id=%s", sbi->domain_id);
 	if (sbi->dif0.fsoff)
 		seq_printf(seq, ",fsoffset=%llu", sbi->dif0.fsoff);
 	if (test_opt(opt, INODE_SHARE))
-- 
2.43.0


