Return-Path: <SRS0=KC2W=QD=lists.ozlabs.org=linux-erofs-bounces+linux-erofs=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1F10C433F5
	for <linux-erofs@archiver.kernel.org>; Tue, 16 Nov 2021 01:10:59 +0000 (UTC)
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 4073160EE9
	for <linux-erofs@archiver.kernel.org>; Tue, 16 Nov 2021 01:10:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 4073160EE9
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.ozlabs.org
Received: from boromir.ozlabs.org (localhost [IPv6:::1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4HtSg56djxz2yNY
	for <linux-erofs@archiver.kernel.org>; Tue, 16 Nov 2021 12:10:57 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized)
 smtp.mailfrom=linux.alibaba.com (client-ip=115.124.30.132;
 helo=out30-132.freemail.mail.aliyun.com;
 envelope-from=hsiangkao@linux.alibaba.com; receiver=<UNKNOWN>)
Received: from out30-132.freemail.mail.aliyun.com
 (out30-132.freemail.mail.aliyun.com [115.124.30.132])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
 (No client certificate requested)
 by lists.ozlabs.org (Postfix) with ESMTPS id 4HtSg26PGYz2xDr
 for <linux-erofs@lists.ozlabs.org>; Tue, 16 Nov 2021 12:10:54 +1100 (AEDT)
X-Alimail-AntiSpam: AC=PASS; BC=-1|-1; BR=01201311R111e4; CH=green; DM=||false|;
 DS=||; FP=0|-1|-1|-1|0|-1|-1|-1; HT=e01e04423; MF=hsiangkao@linux.alibaba.com;
 NM=1; PH=DS; RN=6; SR=0; TI=SMTPD_---0UwmImHY_1637025037; 
Received: from
 e18g09479.et15sqa.tbsite.net(mailfrom:hsiangkao@linux.alibaba.com
 fp:SMTPD_---0UwmImHY_1637025037) by smtp.aliyun-inc.com(127.0.0.1);
 Tue, 16 Nov 2021 09:10:37 +0800
From: Gao Xiang <hsiangkao@linux.alibaba.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	stable@vger.kernel.org
Subject: [PATCH 5.4.y 1/2] erofs: remove the occupied parameter from
 z_erofs_pagevec_enqueue()
Date: Tue, 16 Nov 2021 09:10:34 +0800
Message-Id: <20211116011035.124503-1-hsiangkao@linux.alibaba.com>
X-Mailer: git-send-email 2.24.4
In-Reply-To: <163698346111096@kroah.com>
References: <163698346111096@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-BeenThere: linux-erofs@lists.ozlabs.org
X-Mailman-Version: 2.1.29
Precedence: list
List-Id: Development of Linux EROFS file system <linux-erofs.lists.ozlabs.org>
List-Unsubscribe: <https://lists.ozlabs.org/options/linux-erofs>,
 <mailto:linux-erofs-request@lists.ozlabs.org?subject=unsubscribe>
List-Archive: <http://lists.ozlabs.org/pipermail/linux-erofs/>
List-Post: <mailto:linux-erofs@lists.ozlabs.org>
List-Help: <mailto:linux-erofs-request@lists.ozlabs.org?subject=help>
List-Subscribe: <https://lists.ozlabs.org/listinfo/linux-erofs>,
 <mailto:linux-erofs-request@lists.ozlabs.org?subject=subscribe>
Cc: Gao Xiang <hsiangkao@linux.alibaba.com>, Yue Hu <huyue2@yulong.com>,
 linux-erofs@lists.ozlabs.org
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs"
 <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>

From: Yue Hu <huyue2@yulong.com>

commit 7dea3de7d384f4c8156e8bd93112ba6db1eb276c upstream.

No any behavior to variable occupied in z_erofs_attach_page() which
is only caller to z_erofs_pagevec_enqueue().

Link: https://lore.kernel.org/r/20210419102623.2015-1-zbestahu@gmail.com
Signed-off-by: Yue Hu <huyue2@yulong.com>
Reviewed-by: Gao Xiang <xiang@kernel.org>
Signed-off-by: Gao Xiang <xiang@kernel.org>
Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
---
Gao Xiang: Apply this trivial cleanup (no behavior change) for easier
           backporting.

 fs/erofs/zdata.c | 4 +---
 fs/erofs/zpvec.h | 5 +----
 2 files changed, 2 insertions(+), 7 deletions(-)

diff --git a/fs/erofs/zdata.c b/fs/erofs/zdata.c
index fad80c97d247..f784feaeb819 100644
--- a/fs/erofs/zdata.c
+++ b/fs/erofs/zdata.c
@@ -292,7 +292,6 @@ static int z_erofs_attach_page(struct z_erofs_collector *clt,
 			       enum z_erofs_page_type type)
 {
 	int ret;
-	bool occupied;
 
 	/* give priority for inplaceio */
 	if (clt->mode >= COLLECT_PRIMARY &&
@@ -300,8 +299,7 @@ static int z_erofs_attach_page(struct z_erofs_collector *clt,
 	    z_erofs_try_inplace_io(clt, page))
 		return 0;
 
-	ret = z_erofs_pagevec_enqueue(&clt->vector,
-				      page, type, &occupied);
+	ret = z_erofs_pagevec_enqueue(&clt->vector, page, type);
 	clt->cl->vcnt += (unsigned int)ret;
 
 	return ret ? 0 : -EAGAIN;
diff --git a/fs/erofs/zpvec.h b/fs/erofs/zpvec.h
index 58556903aa94..a38c52610367 100644
--- a/fs/erofs/zpvec.h
+++ b/fs/erofs/zpvec.h
@@ -107,10 +107,8 @@ static inline void z_erofs_pagevec_ctor_init(struct z_erofs_pagevec_ctor *ctor,
 
 static inline bool z_erofs_pagevec_enqueue(struct z_erofs_pagevec_ctor *ctor,
 					   struct page *page,
-					   enum z_erofs_page_type type,
-					   bool *occupied)
+					   enum z_erofs_page_type type)
 {
-	*occupied = false;
 	if (!ctor->next && type)
 		if (ctor->index + 1 == ctor->nr)
 			return false;
@@ -125,7 +123,6 @@ static inline bool z_erofs_pagevec_enqueue(struct z_erofs_pagevec_ctor *ctor,
 	/* should remind that collector->next never equal to 1, 2 */
 	if (type == (uintptr_t)ctor->next) {
 		ctor->next = page;
-		*occupied = true;
 	}
 	ctor->pages[ctor->index++] = tagptr_fold(erofs_vtptr_t, page, type);
 	return true;
-- 
2.24.4

