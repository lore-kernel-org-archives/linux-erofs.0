Return-Path: <linux-erofs+bounces-2968-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F2BD7F54AC0
	for <linux-erofs@archiver.kernel.org>; Tue, 24 Mar 2026 14:08:21 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4fgBhh3V7bz2ykV;
	Wed, 25 Mar 2026 01:08:20 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=115.124.30.101
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1774361300;
	cv=none; b=aFGKirdVSvPScMWt1Xx2gFkZRAwng64VqzItS8v9B9e/EHN7cUvppJKKEQzXn8IBqMoDsYW1gyFNC+nwptQjzRhFtrbsR/Qmd1e2JD7Wnxcyr8aKk8/2fQ7ow9RtapetvAD2c2chbtglhB0KsL8UiWRU4mBglJnmdTBd8+7DCzMUVh4wzlEpfxX1vdVy2gcQYxZXedkK71svdmm2SjfayH3SdT75X8lyNYfIXSntGpCogOvq7adiTQ9lTmxiQDIlE0x+/kLYbsYAfzli25aNPPtgeHk3A9ohlcpSo++9J8fwwU5a4xec9UAnky9nDaFtFCH5+oQqzt/pnFtqib6tKw==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1774361300; c=relaxed/relaxed;
	bh=vpivJBCuzAYnN3HFD1lEir3R4MT75M+1TjEuwNcM5lM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=AHEOGFSgf3v7yl03+YaJ68rRG4CHxVDhkmvpgVGGPbbxk77iQdgHH9ms27gVCwKO2vsJp+XAl4p8kmB8eabc/GqIDZedKH9ICQdJMk37Bs9tz6RpqSxi17dFsszHLVteDJk19GpKeTn+wfdyFeqI3dIXMBoKUviMecXdglUas5riQACdEuU46sv/0j70j4cSQeXbcPTNWdx1OI1Nw9fY9bQ5T16DN7iCOq9B7/VjW8FOJM7sg7061mJf1pohKeI7DuznBjx8ObuXrz933IHYXrg7mXwyCBVQkXU5UxEfEKm71+YaBs33ZWfWwaxiGF5eaVCl2F1tY+g+L1yChnsieg==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=gD4tRr25; dkim-atps=neutral; spf=pass (client-ip=115.124.30.101; helo=out30-101.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org) smtp.mailfrom=linux.alibaba.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=gD4tRr25;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=linux.alibaba.com (client-ip=115.124.30.101; helo=out30-101.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org)
Received: from out30-101.freemail.mail.aliyun.com (out30-101.freemail.mail.aliyun.com [115.124.30.101])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4fgBhf0t83z2xBV
	for <linux-erofs@lists.ozlabs.org>; Wed, 25 Mar 2026 01:08:16 +1100 (AEDT)
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1774361292; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=vpivJBCuzAYnN3HFD1lEir3R4MT75M+1TjEuwNcM5lM=;
	b=gD4tRr25+oDJqi0Uvzw6NW/ojBLJ9sOI73ABOmNl6lw9GxZdgcpovDxkaziLWZOy13j2TMdlXSn+d/xZx9kxCgKeJISzTqzTtFRsmVIKv/frtsDaQgEJMTulfWEzDq6u0yOqzIacOQzk85YPjqYK+uHwi0BqhzsOcVf/jMzRy/8=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R191e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033032089153;MF=hsiangkao@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0X.ei8RJ_1774361286;
Received: from x31i01179.sqa.na131.tbsite.net(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0X.ei8RJ_1774361286 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 24 Mar 2026 22:08:10 +0800
From: Gao Xiang <hsiangkao@linux.alibaba.com>
To: linux-erofs@lists.ozlabs.org
Cc: LKML <linux-kernel@vger.kernel.org>,
	Gao Xiang <hsiangkao@linux.alibaba.com>,
	Hongbo Li <lihongbo22@huawei.com>
Subject: [PATCH] erofs: fix .fadvise() for page cache sharing
Date: Tue, 24 Mar 2026 22:08:05 +0800
Message-ID: <20260324140805.225088-1-hsiangkao@linux.alibaba.com>
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
 fs/erofs/ishare.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/erofs/ishare.c b/fs/erofs/ishare.c
index 829d50d5c717..57b51d77263d 100644
--- a/fs/erofs/ishare.c
+++ b/fs/erofs/ishare.c
@@ -201,7 +201,10 @@ struct inode *erofs_real_inode(struct inode *inode, bool *need_iput)
 int __init erofs_init_ishare(void)
 {
 	erofs_ishare_mnt = kern_mount(&erofs_anon_fs_type);
-	return PTR_ERR_OR_ZERO(erofs_ishare_mnt);
+	if (IS_ERR_OR_NULL(erofs_ishare_mnt))
+		return PTR_ERR_OR_ZERO(erofs_ishare_mnt);
+	/* generic_fadvise() doesn't work if s_bdi == &noop_backing_dev_info */
+	return super_setup_bdi(erofs_ishare_mnt->mnt_sb);
 }
 
 void erofs_exit_ishare(void)
-- 
2.43.5


