Return-Path: <SRS0=4szn=24=lists.ozlabs.org=linux-erofs-bounces+linux-erofs=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E1CEC32771
	for <linux-erofs@archiver.kernel.org>; Tue,  7 Jan 2020 02:26:43 +0000 (UTC)
Received: from lists.ozlabs.org (lists.ozlabs.org [203.11.71.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 2963220715
	for <linux-erofs@archiver.kernel.org>; Tue,  7 Jan 2020 02:26:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2963220715
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Received: from lists.ozlabs.org (lists.ozlabs.org [IPv6:2401:3900:2:1::3])
	by lists.ozlabs.org (Postfix) with ESMTP id 47sGTr4NdjzDqWj
	for <linux-erofs@archiver.kernel.org>; Tue,  7 Jan 2020 13:26:40 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized)
 smtp.mailfrom=huawei.com (client-ip=45.249.212.190; helo=huawei.com;
 envelope-from=gaoxiang25@huawei.com; receiver=<UNKNOWN>)
Authentication-Results: lists.ozlabs.org;
 dmarc=none (p=none dis=none) header.from=huawei.com
Received: from huawei.com (szxga04-in.huawei.com [45.249.212.190])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by lists.ozlabs.org (Postfix) with ESMTPS id 47sGTl0WZ0zDqMG
 for <linux-erofs@lists.ozlabs.org>; Tue,  7 Jan 2020 13:26:34 +1100 (AEDT)
Received: from DGGEMS410-HUB.china.huawei.com (unknown [172.30.72.58])
 by Forcepoint Email with ESMTP id 540A6F32E3153190C524;
 Tue,  7 Jan 2020 10:26:25 +0800 (CST)
Received: from architecture4.huawei.com (10.160.196.180) by smtp.huawei.com
 (10.3.19.210) with Microsoft SMTP Server (TLS) id 14.3.439.0; Tue, 7 Jan 2020
 10:26:19 +0800
From: Gao Xiang <gaoxiang25@huawei.com>
To: Chao Yu <yuchao0@huawei.com>
Subject: [PATCH] erofs: fix out-of-bound read for shifted uncompressed block
Date: Tue, 7 Jan 2020 10:25:46 +0800
Message-ID: <20200107022546.19432-1-gaoxiang25@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.160.196.180]
X-CFilter-Loop: Reflected
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
Cc: linux-erofs@lists.ozlabs.org, LKML <linux-kernel@vger.kernel.org>,
 stable@vger.kernel.org, Miao Xie <miaoxie@huawei.com>
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs"
 <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>

rq->out[1] should be valid before accessing. Otherwise,
in very rare cases, out-of-bound dirty onstack rq->out[1]
can equal to *in and lead to unintended memmove behavior.

Fixes: 7fc45dbc938a ("staging: erofs: introduce generic decompression backend")
Cc: <stable@vger.kernel.org> # v5.3+
Signed-off-by: Gao Xiang <gaoxiang25@huawei.com>
---
 fs/erofs/decompressor.c | 22 ++++++++++------------
 1 file changed, 10 insertions(+), 12 deletions(-)

diff --git a/fs/erofs/decompressor.c b/fs/erofs/decompressor.c
index 2890a67a1ded..5779a15c2cd6 100644
--- a/fs/erofs/decompressor.c
+++ b/fs/erofs/decompressor.c
@@ -306,24 +306,22 @@ static int z_erofs_shifted_transform(const struct z_erofs_decompress_req *rq,
 	}
 
 	src = kmap_atomic(*rq->in);
-	if (!rq->out[0]) {
-		dst = NULL;
-	} else {
+	if (rq->out[0]) {
 		dst = kmap_atomic(rq->out[0]);
 		memcpy(dst + rq->pageofs_out, src, righthalf);
+		kunmap_atomic(dst);
 	}
 
-	if (rq->out[1] == *rq->in) {
-		memmove(src, src + righthalf, rq->pageofs_out);
-	} else if (nrpages_out == 2) {
-		if (dst)
-			kunmap_atomic(dst);
+	if (nrpages_out == 2) {
 		DBG_BUGON(!rq->out[1]);
-		dst = kmap_atomic(rq->out[1]);
-		memcpy(dst, src + righthalf, rq->pageofs_out);
+		if (rq->out[1] == *rq->in) {
+			memmove(src, src + righthalf, rq->pageofs_out);
+		} else {
+			dst = kmap_atomic(rq->out[1]);
+			memcpy(dst, src + righthalf, rq->pageofs_out);
+			kunmap_atomic(dst);
+		}
 	}
-	if (dst)
-		kunmap_atomic(dst);
 	kunmap_atomic(src);
 	return 0;
 }
-- 
2.17.1

