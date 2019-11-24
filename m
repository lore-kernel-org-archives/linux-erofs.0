Return-Path: <SRS0=2/5V=ZQ=lists.ozlabs.org=linux-erofs-bounces+linux-erofs=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09D6EC432C0
	for <linux-erofs@archiver.kernel.org>; Sun, 24 Nov 2019 02:52:55 +0000 (UTC)
Received: from lists.ozlabs.org (lists.ozlabs.org [203.11.71.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id A171F20719
	for <linux-erofs@archiver.kernel.org>; Sun, 24 Nov 2019 02:52:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=lists.ozlabs.org header.i=@lists.ozlabs.org header.b="L6gEF1I/";
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=aol.com header.i=@aol.com header.b="N5QA0/P+"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A171F20719
Authentication-Results: mail.kernel.org; dmarc=pass (p=none dis=none) header.from=lists.ozlabs.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Received: from lists.ozlabs.org (lists.ozlabs.org [IPv6:2401:3900:2:1::3])
	by lists.ozlabs.org (Postfix) with ESMTP id 47LF8N3mWnzDqtG
	for <linux-erofs@archiver.kernel.org>; Sun, 24 Nov 2019 13:52:52 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=lists.ozlabs.org;
	s=201707; t=1574563972;
	bh=Pf8lx0Qp33qGehSSkjf0D+TNR6aP639BdfKoq9V0m9A=;
	h=To:Subject:Date:References:List-Id:List-Unsubscribe:List-Archive:
	 List-Post:List-Help:List-Subscribe:From:Reply-To:Cc:From;
	b=L6gEF1I/HTMdfgHXWS1ym6zYWxuQeArLkRvrUTgYHFJq5gQt+g3vtgxeLRxpqSGls
	 GD9qBzDR0mC47LOeU4yioFjv4g6XUEn8C4V1zNEx48v3j/zYzFr8jXonl/6bvbQVqY
	 66GizhnyPszcfA0gX5ni/hhjRleg89a30+48y665ViWZJfnMT+ZebqA7+AduiUwmnD
	 W/w96lj+R8/Tax6S8GXxsKwAqPdmdO030u1Afb4fuR4Ljr1hv+PhNMausERm7BU3ks
	 tHRqtUqMylFkngsntr1fg0g8hK0uYKDyM1UekJcwlwfCF13GUKMzW/p1owaL7g7nXF
	 OuS8rDwNvd6FA==
Authentication-Results: lists.ozlabs.org;
 spf=pass (sender SPF authorized) smtp.mailfrom=aol.com
 (client-ip=98.137.64.204; helo=sonic303-23.consmr.mail.gq1.yahoo.com;
 envelope-from=hsiangkao@aol.com; receiver=<UNKNOWN>)
Authentication-Results: lists.ozlabs.org;
 dmarc=pass (p=reject dis=none) header.from=aol.com
Authentication-Results: lists.ozlabs.org; dkim=pass (2048-bit key;
 unprotected) header.d=aol.com header.i=@aol.com header.b="N5QA0/P+"; 
 dkim-atps=neutral
Received: from sonic303-23.consmr.mail.gq1.yahoo.com
 (sonic303-23.consmr.mail.gq1.yahoo.com [98.137.64.204])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by lists.ozlabs.org (Postfix) with ESMTPS id 47LF8D4nylzDqrW
 for <linux-erofs@lists.ozlabs.org>; Sun, 24 Nov 2019 13:52:41 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=aol.com; s=a2048;
 t=1574563958; bh=UQ4wEZ2d5NEnClVo49438KLMoHozWpLWnEb3RCQEf1Y=;
 h=From:To:Cc:Subject:Date:References:From:Subject;
 b=N5QA0/P+b7sJ6mKtnfxMiNVv23FDYr2L3MKhgtRVVGAYAMXGzvVrdhn8SnfVFGD2YZ0AQsS3ruia3lEzJbx2yBRsbTaRGdjvGI1X8FVBBX4XkoZZZgBKTtg3k4hytokwo07oWZlKPVlSKFEkWdx5TLANT/pwMIfpSQQ465c7aOzcP5UzNqzJLc9k8ZXBLXgUBQJfQG6nPTbZtbnD1t+koFrTlnGJqLGM195+OMnRlx5SpMrTL6tf5+xBFsxt29qb4rH8NCNYWnTPPyj/OKxIcZtSk0JDde8OI8lZrguZnf3YrhOYiDnXXgOBh+/KWpUcqoBJKbBG0aIhX6IiOsSSgA==
X-YMail-OSG: o8bN8bkVM1lr77BD6flAMTJxBebO6EqyEPf.bKp8RQ2MRvrXbbWyyCtuxzqvkxO
 VIioLoqljHOENu12xtKzhZ7nxdhgx8_in4Zbzb0gNlqpakWRkx0kMxhJlTvREvIqyrxKL3v.2MDi
 _OI_ABrPrrl7mZX1F_dxJuTQQzs76JeqpGF.OXB6oQ_F75rTp3qWLcOML46yvPimMvw1O1EDLZMV
 p9W..s886cdLZQaVF1R78fJjXbp6krM.qngPcloxlztTEHPstZYGGTEQRFyLXEGjYBYxl_y9olUv
 DZn2E.AojuknbP4a9fsmLlGvaBnnEFszZVWPHnlAfJ3v8iX50hOrghHVBafG6d5qrLL_EJnUImo3
 3BZam8qDcVdrI1MDi2F73hci2RhZojo0GKVaSJfj3.fFR2MakSwN2kjECL3vCECxOwdU9Y9mZrvy
 XcWmfdEHmGGH_2C.c9gvk.4He4Nki8Q6jgoSVsa5a.MJeeAIrvpjPfww6Xm4Ct7KWq1NrnZnMhqz
 nnyQTvnQNVMLgVr5LVK1xbOFvKydgymTsgbPEz4ldpXTBcXi_Hui7pGoEsYHBVMq0XhG3LU5ayF9
 wrkvTjWJb65I4zOhQ5siYCsD1We64A5jHo2VMUL6ScmC8gkdeqmrVuVXs.7n4GeguviINB8EK5_i
 H_tI1dcD9DLoCE6Au1YxXDU89nb9fHWLz52KCfcV8UZLH4Dk0H5kyDmqChswugvlAYoH1EtzIozF
 KP9s6chiGBOpiyffG3UqZFIYZ2LU7EazIKASI6AfYlBCOBjtlE3j0wLl3QDI5ke_V1MoZd.iW49_
 FucMYtDnAFK4ix.2Fn0xrCFy_dzjCDbZBim58diqN6.r3xTItuxlNbWFSnGnCPk_iwEZWkEjs4wD
 CFknDwnDdpO995jF4elRuTHATBpY7Cb5DfAGMaBBZvFpUyGIeO353X_0yo3Lno_At0KntO6h5cPC
 eRHoYQXZ_exWMelXS8ysTVXN3HgRx45.fglDEjv_l72PygDi3iPlepRx9Cy9dr9fu9eMTMVRENvd
 Nohfdo8PpURk6VvQ2DlW0IZx850kP1pniQGzrMZI1oVVwBQrn.fUbhM7gz3HDsC.aVrChOCmQ8O0
 VnetiRKvQw3cOQDkutXBqcC8swB3PaVMspVU4Rjbw1tptXp47vJJu7JlC27gUJphuWDLqSTs9BkN
 UxiK3kJ9XLbPxNHzMMzzdgLOBOE3hndHnVsgEy88yQn6fGeODo3EpS1j0ghAm6CHi.QLkfp27G5f
 nxkgBptkrdhiu82e.7A4ltiDuYXHXL1ki68MhQg1o55eAe8NZPv5mMXVaSX2.5FtWMLZ1I8CGw2q
 Y3VNPlvJ1mjZvil9amjvDQKzMa.qIoZXRHOBwB.fr39IijOnK7jr9MCLyRml9Byw.9XHkwy4l4AM
 -
Received: from sonic.gate.mail.ne1.yahoo.com by
 sonic303.consmr.mail.gq1.yahoo.com with HTTP; Sun, 24 Nov 2019 02:52:38 +0000
Received: by smtp412.mail.gq1.yahoo.com (Oath Hermes SMTP Server) with ESMTPA
 ID 5bd6a20cd9601ad8d553e03d3cdf2cec; 
 Sun, 24 Nov 2019 02:52:33 +0000 (UTC)
To: Chao Yu <yuchao0@huawei.com>,
	linux-erofs@lists.ozlabs.org
Subject: [PATCH v2] erofs: get rid of __stagingpage_alloc helper
Date: Sun, 24 Nov 2019 10:52:17 +0800
Message-Id: <20191124025217.12345-1-hsiangkao@aol.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
References: <20191124025217.12345-1-hsiangkao.ref@aol.com>
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
From: Gao Xiang via Linux-erofs <linux-erofs@lists.ozlabs.org>
Reply-To: Gao Xiang <hsiangkao@aol.com>
Cc: Miao Xie <miaoxie@huawei.com>, LKML <linux-kernel@vger.kernel.org>
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs"
 <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>

From: Gao Xiang <gaoxiang25@huawei.com>

Now open code is much cleaner due to iterative development.

Reviewed-by: Chao Yu <yuchao0@huawei.com>
Signed-off-by: Gao Xiang <gaoxiang25@huawei.com>
---
changes since v1:
 - drop redundant nofail in erofs_allocpage since it has gfp;
 - add to managed cache then visible to pcluster;
 - stress testing survival for days on products
   without unexpected behavior.

 fs/erofs/decompressor.c |  2 +-
 fs/erofs/internal.h     |  2 +-
 fs/erofs/utils.c        |  4 ++--
 fs/erofs/zdata.c        | 37 +++++++++++++++++--------------------
 4 files changed, 21 insertions(+), 24 deletions(-)

diff --git a/fs/erofs/decompressor.c b/fs/erofs/decompressor.c
index 19f89f9fb10c..2890a67a1ded 100644
--- a/fs/erofs/decompressor.c
+++ b/fs/erofs/decompressor.c
@@ -73,7 +73,7 @@ static int z_erofs_lz4_prepare_destpages(struct z_erofs_decompress_req *rq,
 			victim = availables[--top];
 			get_page(victim);
 		} else {
-			victim = erofs_allocpage(pagepool, GFP_KERNEL, false);
+			victim = erofs_allocpage(pagepool, GFP_KERNEL);
 			if (!victim)
 				return -ENOMEM;
 			victim->mapping = Z_EROFS_MAPPING_STAGING;
diff --git a/fs/erofs/internal.h b/fs/erofs/internal.h
index 544a453f3076..0c1175a08e54 100644
--- a/fs/erofs/internal.h
+++ b/fs/erofs/internal.h
@@ -382,7 +382,7 @@ int erofs_namei(struct inode *dir, struct qstr *name,
 extern const struct file_operations erofs_dir_fops;
 
 /* utils.c / zdata.c */
-struct page *erofs_allocpage(struct list_head *pool, gfp_t gfp, bool nofail);
+struct page *erofs_allocpage(struct list_head *pool, gfp_t gfp);
 
 #if (EROFS_PCPUBUF_NR_PAGES > 0)
 void *erofs_get_pcpubuf(unsigned int pagenr);
diff --git a/fs/erofs/utils.c b/fs/erofs/utils.c
index f66043ee16b9..1e8e1450d5b0 100644
--- a/fs/erofs/utils.c
+++ b/fs/erofs/utils.c
@@ -7,7 +7,7 @@
 #include "internal.h"
 #include <linux/pagevec.h>
 
-struct page *erofs_allocpage(struct list_head *pool, gfp_t gfp, bool nofail)
+struct page *erofs_allocpage(struct list_head *pool, gfp_t gfp)
 {
 	struct page *page;
 
@@ -16,7 +16,7 @@ struct page *erofs_allocpage(struct list_head *pool, gfp_t gfp, bool nofail)
 		DBG_BUGON(page_ref_count(page) != 1);
 		list_del(&page->lru);
 	} else {
-		page = alloc_pages(gfp | (nofail ? __GFP_NOFAIL : 0), 0);
+		page = alloc_page(gfp);
 	}
 	return page;
 }
diff --git a/fs/erofs/zdata.c b/fs/erofs/zdata.c
index 93f8bc1a64f6..1c582a3a40a3 100644
--- a/fs/erofs/zdata.c
+++ b/fs/erofs/zdata.c
@@ -546,15 +546,6 @@ static bool z_erofs_collector_end(struct z_erofs_collector *clt)
 	return true;
 }
 
-static inline struct page *__stagingpage_alloc(struct list_head *pagepool,
-					       gfp_t gfp)
-{
-	struct page *page = erofs_allocpage(pagepool, gfp, true);
-
-	page->mapping = Z_EROFS_MAPPING_STAGING;
-	return page;
-}
-
 static bool should_alloc_managed_pages(struct z_erofs_decompress_frontend *fe,
 				       unsigned int cachestrategy,
 				       erofs_off_t la)
@@ -661,8 +652,9 @@ static int z_erofs_do_read_page(struct z_erofs_decompress_frontend *fe,
 	/* should allocate an additional staging page for pagevec */
 	if (err == -EAGAIN) {
 		struct page *const newpage =
-			__stagingpage_alloc(pagepool, GFP_NOFS);
+			erofs_allocpage(pagepool, GFP_NOFS | __GFP_NOFAIL);
 
+		newpage->mapping = Z_EROFS_MAPPING_STAGING;
 		err = z_erofs_attach_page(clt, newpage,
 					  Z_EROFS_PAGE_TYPE_EXCLUSIVE);
 		if (!err)
@@ -1079,19 +1071,24 @@ static struct page *pickup_page_for_submission(struct z_erofs_pcluster *pcl,
 	unlock_page(page);
 	put_page(page);
 out_allocpage:
-	page = __stagingpage_alloc(pagepool, gfp);
-	if (oldpage != cmpxchg(&pcl->compressed_pages[nr], oldpage, page)) {
-		list_add(&page->lru, pagepool);
-		cpu_relax();
-		goto repeat;
-	}
-	if (!tocache)
-		goto out;
-	if (add_to_page_cache_lru(page, mc, index + nr, gfp)) {
+	page = erofs_allocpage(pagepool, gfp | __GFP_NOFAIL);
+	if (!tocache || add_to_page_cache_lru(page, mc, index + nr, gfp)) {
+		/* non-LRU / non-movable temporary page is needed */
 		page->mapping = Z_EROFS_MAPPING_STAGING;
-		goto out;
+		tocache = false;
 	}
 
+	if (oldpage != cmpxchg(&pcl->compressed_pages[nr], oldpage, page)) {
+		if (tocache) {
+			/* since it added to managed cache successfully */
+			unlock_page(page);
+			put_page(page);
+		} else {
+			list_add(&page->lru, pagepool);
+		}
+		cond_resched();
+		goto repeat;
+	}
 	set_page_private(page, (unsigned long)pcl);
 	SetPagePrivate(page);
 out:	/* the only exit (for tracing and debugging) */
-- 
2.20.1

