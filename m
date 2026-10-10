Return-Path: <linux-erofs+bounces-4688-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1697CCA9EBE
	for <linux-erofs@archiver.kernel.org>; Sat, 10 Oct 2026 09:43:33 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4j1zLr27znz2xdb;
	Sat, 10 Oct 2026 20:43:32 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2001:cf8:acf:41::8"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1791625412;
	cv=none; b=Q4wdFnC2N3OpUYV/m3pyz0+p6BLyfmaZMu17WAoQb40FPwmdcKB4VA2az+5vVrC8lwNsSDNyQ6XnZVMrP3TmL3vG0itFYvtbG/rOzNU7FlXPiH6R4d4s9JmR9lF2T14dwJ+6/Ayl4GXAlPgw5Kwite48gj19MHPHpQomVlBMPqYwlcAMdHhsv5AWB8buIBILqVe9hqOxelLjR1KJxTyljT3ObzuwU0wZXPMJmtHEk3QetyMmK1ZHh/FjEx2UjH4RGGmJcS4GpfgxibySP2uKNuNH0Rkgdck20Ou/jkbeZenfLGddv8EgldAAChiNWV6WDEOXerdX+mwfmGxp2SrUwA==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1791625412; c=relaxed/relaxed;
	bh=gY84DdlCXXCCtPKxy3gsbbnHG9YkyEpV7xHj0YNGUXc=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=JAsdwpSmdx/XGWt82zgimlJ08zTaVLgeeBk/J043wLYJGQNp9b+iq6D1PvyDzb4jDzOSwdQo5noNSvHTXCj08YP76iBAw3v7x4z7R3PHF+mZy4GyZ3gbwtGI2PW1f8O/WjJLeA2njOwDjIQHiz2GLEuO0cfFnZJ3ZasW1tCN/Qn6arecUsXs0TBWDCpRZp59GrX68r+RFf36YGgpvYVhtB1uuUOfs6Nj8ZSt6Q0RfNqIGU2JTUr+kq0luRsShjetRVYlU1zuLBifFXDAKPOR18aOPkkwcPr9IHS71bF9xV9mo+PhEidAl5LqH2dHIynb9P+mLbab6v9yW7KEHUGq8w==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=sony.com; dkim=pass (2048-bit key; unprotected) header.d=sony.com header.i=@sony.com header.a=rsa-sha256 header.s=s1jp header.b=SnX/ajqx; dkim-atps=neutral; spf=pass (client-ip=2001:cf8:acf:41::8; helo=jpms-ob02-os7.noc.sony.co.jp; envelope-from=friendy.su@sony.com; receiver=lists.ozlabs.org) smtp.mailfrom=sony.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=sony.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=sony.com header.i=@sony.com header.a=rsa-sha256 header.s=s1jp header.b=SnX/ajqx;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=sony.com (client-ip=2001:cf8:acf:41::8; helo=jpms-ob02-os7.noc.sony.co.jp; envelope-from=friendy.su@sony.com; receiver=lists.ozlabs.org)
Received: from jpms-ob02-os7.noc.sony.co.jp (jpms-ob02-os7.noc.sony.co.jp [IPv6:2001:cf8:acf:41::8])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4j1zLp3vMdz2xSV
	for <linux-erofs@lists.ozlabs.org>; Sat, 10 Oct 2026 20:43:28 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=sony.com; s=s1jp; t=1791625411; x=1823161411;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=gY84DdlCXXCCtPKxy3gsbbnHG9YkyEpV7xHj0YNGUXc=;
  b=SnX/ajqxCvI7Kyuk53Ub4hNkiuKKk9Ln/zlMmu/+Rbq1NQ8hrI56tKBr
   at8eieTKs5xfRckyOL45H/w4yVneKpGza3v81abKZsL+usKnakzLSQeby
   8oGIzsaYgiX+oFHa/hAqqVzVoJoXbIDA5w65NJjCGroPak9ccJEeH9RpZ
   EqlwxOxu+wJG7pslniNMBvEvtVSUZWGmY/ev/Of7gTtq+rG7pplg0kHcM
   zsFiMWqqRoAIeUF0lgFixea9VaB2n56t2wxhb4vnS0jiJEC3eUu1MEuC9
   Ts92HfnUBYT+Uk6ZfhGdlmCux4dmUlgTxKsGDa/Qbe3+usDhs4X0kscX6
   Q==;
X-CSE-ConnectionGUID: Li/TW2HPRRi7733EEpYdOw==
X-CSE-MsgGUID: 8/bvHm+URs+EgZq+o05ZJA==
Received: from unknown (HELO jpmta-ob01-os7.noc.sony.co.jp) ([IPv6:2001:cf8:acf:1104::6])
  by jpms-ob02-os7.noc.sony.co.jp with ESMTP/TLS/TLS_AES_256_GCM_SHA384; 10 Oct 2026 18:43:23 +0900
X-CSE-ConnectionGUID: 5cs7UJUuTeKVEjejzsyScQ==
X-CSE-MsgGUID: 4VAO1LyrTgqIoadtMI4Fyw==
X-IronPort-AV: E=Sophos;i="6.27,150,1786978800"; 
   d="scan'208";a="71590581"
Received: from unknown (HELO cscsh-5109200313.ap.sony.com) ([43.82.111.223])
  by jpmta-ob01-os7.noc.sony.co.jp with ESMTP; 10 Oct 2026 18:43:22 +0900
From: Friendy Su <friendy.su@sony.com>
To: xiang@kernel.org,
	chao@kernel.org
Cc: linux-erofs@lists.ozlabs.org,
	linux-kernel@vger.kernel.org,
	Friendy Su <friendy.su@sony.com>,
	Yuezhang Mo <Yuezhang.Mo@sony.com>,
	Daniel Palmer <daniel.palmer@sony.com>
Subject: [PATCH v1] erofs: enable SB_I_ALLOW_HSM to support fanotify pre access event
Date: Sat, 10 Oct 2026 17:40:00 +0800
Message-Id: <20261010094000.2036805-1-friendy.su@sony.com>
X-Mailer: git-send-email 2.34.1
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

This patch makes erofs support a use case below:

erofs file data are not available at local, but need be
filled at fanotify pre access event handler.

E.g. when format erofs to blob mode, meta data image
is store locally, blob image size is big so it is stored remotely.
At erofs mount, a loop device based on a sparse image file is
used as blob device. The sparse image file size is equal to blob
image size. Like:

$ sudo mount -o device=/dev/loop1 /dev/sdb1 /mnt/erofs/

Then at file access, need retrieve data from remote, then fill
into sparse image at FAN_PRE_ACCESS event handler.

Signed-off-by: Friendy Su <friendy.su@sony.com>
Reviewed-by: Yuezhang Mo <Yuezhang.Mo@sony.com>
Reviewed-by: Daniel Palmer <daniel.palmer@sony.com>
---
 fs/erofs/super.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/erofs/super.c b/fs/erofs/super.c
index 0967aace9f7f..b92d3353319d 100644
--- a/fs/erofs/super.c
+++ b/fs/erofs/super.c
@@ -659,6 +659,10 @@ static int erofs_fc_fill_super(struct super_block *sb, struct fs_context *fc)
 	sb->s_maxbytes = MAX_LFS_FILESIZE;
 	sb->s_op = &erofs_sops;
 
+	/*
+	 * Allow HSM to support fanotify pre access event
+	 */
+	sb->s_iflags |= SB_I_ALLOW_HSM;
 	if (!sbi->domain_id && test_opt(&sbi->opt, INODE_SHARE)) {
 		errorfc(fc, "domain_id is needed when inode_share is on");
 		return -EINVAL;
-- 
2.34.1


