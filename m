Return-Path: <linux-erofs+bounces-4285-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2A2BAC5DF87
	for <linux-erofs@archiver.kernel.org>; Fri, 21 Aug 2026 11:25:56 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hRJ022Yv3z2yFt;
	Fri, 21 Aug 2026 21:25:54 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=115.124.30.119
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1787311554;
	cv=none; b=HWFMhxYJgQ0Ho6CmnxZ5av1JcBn7z1M0/jn+JFoPIqvaiNxQIupBzq4fQ2ZEpBveGOw1no2t4sbp40jZ0lgI2DI7XPve1Vu8c5YlwFPTNIAkMqD092QCOtO/p3l78L5lBWoVN4fCcZW/6OlZqwf0ifEzmpAhjSmP+eCFU5eirwP8Fp7kg1UHGWG46VdAmJJ/DK7ZrYPjKUVYxMICLEpaPneerSBPVs2DmHjWj+MgegrQzLYs7+qe3n3tAOCDhGjlqvvA7mdR7bty7NT3EVJDe5H+1OpvWKM9cv4GcgAqy85ZFoD3uD8yoso/AEE4iuRM6M28azaOff3MYNvM4MLlag==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1787311554; c=relaxed/relaxed;
	bh=y/867Gz4hyyV1khkrLV4SyqkiwJeQpPmJVYuZX3Z/J0=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=D7QiBecOQswC6OkWfWFKFaCoR+OGUloHNAkD4zVxp79hGdC1tSUM+uCb0t7QG5j158HpkbBgYVi6+gUY0NjeeFgoLfzo+DJi5XMBKMTy8LVv/0IZDwgZJ6ZCMVNpGXQre3Y4UOzq+DoCab8LUNZ35DJdKdTWtp/GuHJ7X6Re6VOJyfYjnq3du8EDBNEo46R53yYVLVrKGfO1oU9N34dBTHYNcG4opppbLqQ2AZprBOFJKdtRL/MEaIoA//ntjoHbSB7/9AyUzNmMG4cUVwvLHlheU+Sv2Il1vZC/kdkL6PfCDy+lGKmtfhEsNep+QnjVI3xQ3S1bv842p1V1Ismq6g==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=Ss4/ffze; dkim-atps=neutral; spf=pass (client-ip=115.124.30.119; helo=out30-119.freemail.mail.aliyun.com; envelope-from=jefflexu@linux.alibaba.com; receiver=lists.ozlabs.org) smtp.mailfrom=linux.alibaba.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=Ss4/ffze;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=linux.alibaba.com (client-ip=115.124.30.119; helo=out30-119.freemail.mail.aliyun.com; envelope-from=jefflexu@linux.alibaba.com; receiver=lists.ozlabs.org)
Received: from out30-119.freemail.mail.aliyun.com (out30-119.freemail.mail.aliyun.com [115.124.30.119])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hRHzz0H72z2yFl
	for <linux-erofs@lists.ozlabs.org>; Fri, 21 Aug 2026 21:25:48 +1000 (AEST)
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1787311542; h=From:To:Subject:Date:Message-Id:MIME-Version;
	bh=y/867Gz4hyyV1khkrLV4SyqkiwJeQpPmJVYuZX3Z/J0=;
	b=Ss4/ffzeUYDLYuyO5Bm/J6muPk8bRxb/Avt8qIUv7uPQufxgAGjAQjrv5L5LOZbo9n7lRCPtnBy7q/LWIjz41BShFkrM/M9s1guT/JoVe056oXxbvsAZPaMPvIStff+UXnkGMsc1nPMOweQt9lzwW64B+S2CSSkwP9GuAN0tfJQ=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R191e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam011083073210;MF=jefflexu@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0X9MAVAi_1787311540;
Received: from localhost(mailfrom:jefflexu@linux.alibaba.com fp:SMTPD_---0X9MAVAi_1787311540 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 21 Aug 2026 19:25:41 +0800
From: Jingbo Xu <jefflexu@linux.alibaba.com>
To: xiang@kernel.org,
	chao@kernel.org,
	linux-erofs@lists.ozlabs.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] erofs: support large folio in inode_share mode
Date: Fri, 21 Aug 2026 19:25:40 +0800
Message-Id: <20260821112540.111105-1-jefflexu@linux.alibaba.com>
X-Mailer: git-send-email 2.19.1.6.gb485710b
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

erofs_fill_inode() calls mapping_set_large_folios() on each erofs
file's own mapping, but in inode_share mode reads are routed to the
shared inode's page cache instead, whose mapping never had large
folio support enabled.

Set up large folios for the shared inode's mapping as well.

Signed-off-by: Jingbo Xu <jefflexu@linux.alibaba.com>
---
 fs/erofs/ishare.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/erofs/ishare.c b/fs/erofs/ishare.c
index 4c7be60565cb..b8897dd6be72 100644
--- a/fs/erofs/ishare.c
+++ b/fs/erofs/ishare.c
@@ -54,6 +54,7 @@ bool erofs_ishare_fill_inode(struct inode *inode)
 		si->i_mapping->a_ops = aops;
 		si->i_mode = 0444 | S_IFREG;
 		si->i_size = inode->i_size;
+		mapping_set_large_folios(si->i_mapping);
 		unlock_new_inode(si);
 	} else {
 		kfree(fp.opaque);
-- 
2.19.1.6.gb485710b


