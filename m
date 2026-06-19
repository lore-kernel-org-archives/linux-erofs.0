Return-Path: <linux-erofs+bounces-3678-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5CD72CD98F6
	for <linux-erofs@archiver.kernel.org>; Fri, 19 Jun 2026 04:19:40 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4ghPWG1zzgz3bps;
	Fri, 19 Jun 2026 14:19:38 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=115.124.28.62
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1781842778;
	cv=none; b=AxXSL6lqy3BduupIE1izfvR71SV0CQ8kpUiT6SNtRkSC5EsHjSqfiuWOiGNlyJd1jraz9dstRo/taxWdCJP3gF0Xn1zjFSXbSZHGhoNnaTrfaLBmTjMsO4VvB9aZsxN9ILzt95WDm8ynjEZvl+I/ww9WXTOiiYHC3r4p9A33DuMlS79xgSRDGoN6BfAfazjKzDLrnkB13T/GfTJRWATAqiPmvDqbZw6RF54g+tN6JY6a1LdeKbg3OR4y26r4MqmKGAYft4Ho5EtgXbh09URzuftIUljAt3K+IyBSRA4AQFE2kbRk6E14pbrSiOhvGbVDwbruKovyPhH89NLvAOVfYQ==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1781842778; c=relaxed/relaxed;
	bh=eOTBuewEJAuqsPkyF+tcyxa2XVezxYhVgyFbOqsw7Fs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=HmGv74ddqMtUkYy0sfHTAYuqSRyeH4C1YWqfCl1ukmk0PYMx3KC7hbR1+H+TEhBIVJRepCb+ayLH7Wm/rrWy0MO+p4ZprN7sUGFruiBjzPwq1gU4/JUn2QD0+m9ecl7b7B5Hg9A4B4NhuHqHPQ9o9+uBLTVXggGxWvo16IE7hHThJ4KYU7kMZVPH+5tyTizLHpduQIY14Qq7JDa9vzHrdIGPi+e0Bri9yRFoqkEy3YLlE/uG+CW+ug2WeWJOr5CUaS8XEYlhURY98ybXo1WMVbw3rgSQHNWuduM1cvFAkzGwIcOjzr93kBuQeXN/nFXRa9Jsfo5VmuCvemfiTyVaQg==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=none (p=none dis=none) header.from=cyzhu.com; spf=pass (client-ip=115.124.28.62; helo=out28-62.mail.aliyun.com; envelope-from=hudson@cyzhu.com; receiver=lists.ozlabs.org) smtp.mailfrom=cyzhu.com
Authentication-Results: lists.ozlabs.org; dmarc=none (p=none dis=none) header.from=cyzhu.com
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=cyzhu.com (client-ip=115.124.28.62; helo=out28-62.mail.aliyun.com; envelope-from=hudson@cyzhu.com; receiver=lists.ozlabs.org)
Received: from out28-62.mail.aliyun.com (out28-62.mail.aliyun.com [115.124.28.62])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4ghPWD1G7Cz3bpp
	for <linux-erofs@lists.ozlabs.org>; Fri, 19 Jun 2026 14:19:32 +1000 (AEST)
X-Alimail-AntiSpam:AC=CONTINUE;BC=0.385346|-1;CH=green;DM=|CONTINUE|false|;DS=CONTINUE|ham_system_inform|0.00282732-0.000360199-0.996812;FP=3272964558224594357|0|0|0|0|-1|-1|-1;HT=maildocker-contentspam033032023038;MF=hudson@cyzhu.com;NM=1;PH=DS;RN=3;RT=3;SR=0;TI=SMTPD_---.i0FVOeA_1781842762;
Received: from HUDSONZHU-MB0.tencent.com(mailfrom:hudson@cyzhu.com fp:SMTPD_---.i0FVOeA_1781842762 cluster:ay29)
          by smtp.aliyun-inc.com;
          Fri, 19 Jun 2026 12:19:25 +0800
From: Chengyu <hudson@cyzhu.com>
To: linux-erofs@lists.ozlabs.org
Cc: hsiangkao@linux.alibaba.com,
	Chengyu Zhu <hudsonzhu@tencent.com>
Subject: [PATCH 0/2] erofs-utils: support ublk recovery
Date: Fri, 19 Jun 2026 12:19:20 +0800
Message-ID: <20260619041922.64521-1-hudson@cyzhu.com>
X-Mailer: git-send-email 2.47.1
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

From: Chengyu Zhu <hudsonzhu@tencent.com>

This series adds recovery support for the ublk backend and then cleans up
the mount-side naming that became misleading once the same context is shared
by NBD, ublk and fanotify paths.

Chengyu Zhu (2):
  ublk: support ublk recovery
  mount: rename erofsmount_nbd_ctx to erofsmount_ctx

 lib/backends/ublk.c |  23 ++++--
 mount/main.c        | 186 +++++++++++++++++++++++++++++++++-----------
 2 files changed, 159 insertions(+), 50 deletions(-)

-- 
2.47.1


