Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B0A8606A325
	for <linux-erofs@archiver.kernel.org>; Tue, 10 Nov 2026 09:40:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=sQM/tS2N
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4jP1qP5B1tz3bkd;
	Tue, 10 Nov 2026 20:40:49 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=115.124.30.132
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1794303649;
	cv=none; b=lhFOrKZj2suglrrDpg8lcBG1L26PP7e7/KgoD7PiN1Xa6/gHBvsWopSfN7uUbgT8EIFowwsOawSCusA0G6XNmi3AUmlo73v2YUcRdkhy9z6NrTHDKBeGmhUfV7YUYtv1bQ5m5+CSds9dpKYnL0WXno+2U6SoabhKMntzDc1wsjrssWXhIuNKfg08VYtrky5V7gqaUFjK7CJsvvTocHBgWIxeQciuUocjKP83iRtMRkxTTJPphkyhJTYJ/VjSe39wi7qaUz4CGLanuPMRA454Acc5n6BtsAmLACYJtrsfty6e47iPtnRPEwnTPYVdVLdbW/er5jvtyGVDA41e8s7e1g==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1794303649; c=relaxed/relaxed;
	bh=yy3nx2ViPnpZriMldrPESjiFFbCtxlLrBDTf4vQlI7o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Lb4XPgtW2Z/0+oYM//zAlb3s8RmD4zJpwS0sZRVW4Q4uFmMrAZQVvYOW8gw+DDubpQwi2GMR2tpb5rmFHYUVdijFBhTWriz99PamKghCrd+r2dgMhOG7uFPyyH0cli9hZC5A3qlzxnpioAWp2H1bP6G3B25Tuh7Td9ehrhordNVwpPaO8Egc0da/iyR1jYxPktALoJelvSyn1KaHwkpOkBJqYlfDcH7hV5PHbhUh+xWCL6vTWYhxm4fxPXxcZ5PB18wUH87jAI6LqQ+d4dqeYgKQyRWsf9gbk3eqS/rDTX1eOZNWDNGBLQGKlSKx7RIlfRvX46vEu8CWVwfbD+9Nng==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=sQM/tS2N; dkim-atps=neutral; spf=pass (client-ip=115.124.30.132; helo=out30-132.freemail.mail.aliyun.com; envelope-from=lanbingying.lby@linux.alibaba.com; receiver=lists.ozlabs.org) smtp.mailfrom=linux.alibaba.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=sQM/tS2N;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=linux.alibaba.com (client-ip=115.124.30.132; helo=out30-132.freemail.mail.aliyun.com; envelope-from=lanbingying.lby@linux.alibaba.com; receiver=lists.ozlabs.org)
Received: from out30-132.freemail.mail.aliyun.com (out30-132.freemail.mail.aliyun.com [115.124.30.132])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4jP1qN54vkz3bkP
	for <linux-erofs@lists.ozlabs.org>; Tue, 10 Nov 2026 20:40:48 +1100 (AEDT)
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1794303642; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=yy3nx2ViPnpZriMldrPESjiFFbCtxlLrBDTf4vQlI7o=;
	b=sQM/tS2NA5Wq6yKNHg+AG1Nsh6xTEvaIM9JFHR5jNAb71gXdW4zu08/68RR6rSzn3AP/5epTvD070zPLZZtuzJVaWeznuza/SXXVmfe+lilREpLTOvl2ygBk1mdCFdv0OwlR8O8HeBPXv4DNZo47P1Q7oQIlstaZGZlubrNH454=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R111e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037033178;MF=lanbingying.lby@linux.alibaba.com;NM=1;PH=DS;RN=2;SR=0;TI=SMTPD_---0XEUy1ig_1794303627;
Received: from x31i01179.sqa.na131.tbsite.net(mailfrom:lanbingying.lby@linux.alibaba.com fp:SMTPD_---0XEUy1ig_1794303627 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 10 Nov 2026 17:40:41 +0800
From: bingying lan <lanbingying.lby@linux.alibaba.com>
To: linux-erofs@lists.ozlabs.org
Cc: xiang@kernel.org
Subject: [PATCH 1/3] erofs-utils: lib: initialize xattr prefix buffer cleanup before errors
Date: Tue, 10 Nov 2026 17:40:10 +0800
Message-ID: <20261110094012.1820140-2-lanbingying.lby@linux.alibaba.com>
X-Mailer: git-send-email 2.53.0.apsara
In-Reply-To: <20261110094012.1820140-1-lanbingying.lby@linux.alibaba.com>
References: <20261110094012.1820140-1-lanbingying.lby@linux.alibaba.com>
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
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL
	autolearn=ham autolearn_force=no version=4.0.1
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

The prefix writer can return after allocating a buffer head but before
assigning its operations. Offset overflow and write errors then leave
an uninitialized callback for erofs_buffer_exit(), which can crash
while reporting the original error.

Install erofs_drop_directly_bhops immediately after successful allocation
and remove the redundant assignments after the writes. This fixes an
existing error path without changing prefix inheritance or allocation
order.

Signed-off-by: bingying lan <lanbingying.lby@linux.alibaba.com>
---
 lib/xattr.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/lib/xattr.c b/lib/xattr.c
index c670b12..8c7bbcf 100644
--- a/lib/xattr.c
+++ b/lib/xattr.c
@@ -913,6 +913,7 @@ int erofs_xattr_flush_name_prefixes(struct erofs_importer *im, bool plain)
 		bh = erofs_balloc(bmgr, XATTR, 0, 0);
 		if (IS_ERR(bh))
 			return PTR_ERR(bh);
+		bh->op = &erofs_drop_directly_bhops;
 		(void)erofs_mapbh(bmgr, bh->block);
 		offset = erofs_btell(bh, false);
 	}
@@ -951,11 +952,9 @@ int erofs_xattr_flush_name_prefixes(struct erofs_importer *im, bool plain)
 	}
 
 	if (bh) {
-		bh->op = &erofs_drop_directly_bhops;
 		err = erofs_bh_balloon(bh, offset - start);
 		if (err < 0)
 			return err;
-		bh->op = &erofs_drop_directly_bhops;
 		erofs_bdrop(bh, false);
 	} else {
 		DBG_BUGON(bmgr);
-- 
2.53.0.apsara


