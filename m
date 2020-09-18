Return-Path: <SRS0=FHtV=C3=lists.ozlabs.org=linux-erofs-bounces+linux-erofs=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8EF0EC43464
	for <linux-erofs@archiver.kernel.org>; Fri, 18 Sep 2020 13:59:34 +0000 (UTC)
Received: from lists.ozlabs.org (lists.ozlabs.org [203.11.71.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id E255A208C3
	for <linux-erofs@archiver.kernel.org>; Fri, 18 Sep 2020 13:59:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZaIvoXzS";
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZaIvoXzS"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E255A208C3
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Received: from bilbo.ozlabs.org (lists.ozlabs.org [IPv6:2401:3900:2:1::3])
	by lists.ozlabs.org (Postfix) with ESMTP id 4BtFnb2cFGzDq9k
	for <linux-erofs@archiver.kernel.org>; Fri, 18 Sep 2020 23:59:31 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized)
 smtp.mailfrom=redhat.com (client-ip=63.128.21.124;
 helo=us-smtp-delivery-124.mimecast.com; envelope-from=hsiangkao@redhat.com;
 receiver=<UNKNOWN>)
Authentication-Results: lists.ozlabs.org;
 dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: lists.ozlabs.org; dkim=pass (1024-bit key;
 unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256
 header.s=mimecast20190719 header.b=ZaIvoXzS; 
 dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com
 header.a=rsa-sha256 header.s=mimecast20190719 header.b=ZaIvoXzS; 
 dkim-atps=neutral
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [63.128.21.124])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by lists.ozlabs.org (Postfix) with ESMTPS id 4BtFhp25f2zDqbC
 for <linux-erofs@lists.ozlabs.org>; Fri, 18 Sep 2020 23:55:21 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1600437318;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:content-type:content-type:in-reply-to:in-reply-to:
 references:references; bh=x/V6psnjWa7bZ2+Jw/8jPkXMC70/LQzTlIIUciZVaDg=;
 b=ZaIvoXzS6fxdoFaWbH+0BhAprHRDNZWiGF7+6jdw5gHP4CHRTa5YVIV8nGzaZ9CTbir08V
 nOlRBI/oCfNAPz34yO4g500yKL1SqBN6ClcmtZ6Pq1B/92WLOAo2bX8nF+zD8bfZARh41Y
 l+dXdiTMaptuIv8x52qMylva7llrke4=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1600437318;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:content-type:content-type:in-reply-to:in-reply-to:
 references:references; bh=x/V6psnjWa7bZ2+Jw/8jPkXMC70/LQzTlIIUciZVaDg=;
 b=ZaIvoXzS6fxdoFaWbH+0BhAprHRDNZWiGF7+6jdw5gHP4CHRTa5YVIV8nGzaZ9CTbir08V
 nOlRBI/oCfNAPz34yO4g500yKL1SqBN6ClcmtZ6Pq1B/92WLOAo2bX8nF+zD8bfZARh41Y
 l+dXdiTMaptuIv8x52qMylva7llrke4=
Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com
 [209.85.210.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-578-PEiiuDw_N0-h04z6pyn5Aw-1; Fri, 18 Sep 2020 09:55:16 -0400
X-MC-Unique: PEiiuDw_N0-h04z6pyn5Aw-1
Received: by mail-pf1-f200.google.com with SMTP id s204so3698806pfs.18
 for <linux-erofs@lists.ozlabs.org>; Fri, 18 Sep 2020 06:55:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
 :references;
 bh=x/V6psnjWa7bZ2+Jw/8jPkXMC70/LQzTlIIUciZVaDg=;
 b=DMJ/TBVgB/VdUHdzo/9ci4j60u43ri0k40KrmrhKtdnDb46/nDTwQg1QCJGfaD5jHy
 V+ptPMuDWIkqMMYVoUu34zQtQapb94pxfuxGyGCAoFgN8Cy2eQv++KqUGmN3Os1bMpDw
 GrjLBX2nLQTTtTa83y2HQFcn3ycr+ObJXUGTr4wMZt+myPz90cnKJEA5N839l1XqwiCc
 gzBJlkezfohyEiD2q6Gh4qhWx8zCIxunSCTBDONXPBG1OVE1A2yt3e/lH6iNb7H88jBL
 VJ5j7zy1WMCyP7rrRibxfp6Kgf0oMMRChTPH30gLnTJmH6pKt/ykFuhcIH7jmaWdJMWQ
 gDDQ==
X-Gm-Message-State: AOAM532pRBEOm1CwMM25ilt+M6BfsPGCXjfBuIS83GZRznNpnQVudcNj
 GC+LgAVBn/+c2b4ySC00TfnIyO7mEXy/zxduIuB3kaNEYUz9xNgmBrIwGhhq9BnEZuBKKqjOJ0F
 CZ32NRbT/5UiSc/m8gaVIP5hR
X-Received: by 2002:a63:c74f:: with SMTP id v15mr16416024pgg.143.1600437314738; 
 Fri, 18 Sep 2020 06:55:14 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxA9hEhCK5BgOCduGHc66YcxXr3W4T4GK/zG/fX16vDb2Ffy6oVinpavyGNjAGm+hAibFUXAQ==
X-Received: by 2002:a63:c74f:: with SMTP id v15mr16416009pgg.143.1600437314470; 
 Fri, 18 Sep 2020 06:55:14 -0700 (PDT)
Received: from xiangao.com ([209.132.188.80])
 by smtp.gmail.com with ESMTPSA id j19sm3642016pfe.108.2020.09.18.06.55.11
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Fri, 18 Sep 2020 06:55:13 -0700 (PDT)
From: Gao Xiang <hsiangkao@redhat.com>
To: linux-erofs@lists.ozlabs.org,
	Chao Yu <yuchao0@huawei.com>
Subject: [PATCH 2/4] erofs: fold in should_decompress_synchronously()
Date: Fri, 18 Sep 2020 21:54:34 +0800
Message-Id: <20200918135436.17689-2-hsiangkao@redhat.com>
X-Mailer: git-send-email 2.18.1
In-Reply-To: <20200918135436.17689-1-hsiangkao@redhat.com>
References: <20200918135436.17689-1-hsiangkao@redhat.com>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=hsiangkao@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII
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
Cc: LKML <linux-kernel@vger.kernel.org>
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs"
 <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>

should_decompress_synchronously() has one single condition
for now, so fold it instead.

Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
---
 fs/erofs/zdata.c | 12 +++---------
 1 file changed, 3 insertions(+), 9 deletions(-)

diff --git a/fs/erofs/zdata.c b/fs/erofs/zdata.c
index df6fa691097f..d483e9fee41c 100644
--- a/fs/erofs/zdata.c
+++ b/fs/erofs/zdata.c
@@ -1297,24 +1297,18 @@ static int z_erofs_readpage(struct file *file, struct page *page)
 	return err;
 }
 
-static bool should_decompress_synchronously(struct erofs_sb_info *sbi,
-					    unsigned int nr)
-{
-	return nr <= sbi->ctx.max_sync_decompress_pages;
-}
-
 static void z_erofs_readahead(struct readahead_control *rac)
 {
 	struct inode *const inode = rac->mapping->host;
 	struct erofs_sb_info *const sbi = EROFS_I_SB(inode);
 
-	bool sync = should_decompress_synchronously(sbi, readahead_count(rac));
+	unsigned int nr_pages = readahead_count(rac);
+	bool sync = (nr_pages <= sbi->ctx.max_sync_decompress_pages);
 	struct z_erofs_decompress_frontend f = DECOMPRESS_FRONTEND_INIT(inode);
 	struct page *page, *head = NULL;
 	LIST_HEAD(pagepool);
 
-	trace_erofs_readpages(inode, readahead_index(rac),
-			readahead_count(rac), false);
+	trace_erofs_readpages(inode, readahead_index(rac), nr_pages, false);
 
 	f.headoffset = readahead_pos(rac);
 
-- 
2.18.1

