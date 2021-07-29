Return-Path: <SRS0=eft8=MV=lists.ozlabs.org=linux-erofs-bounces+linux-erofs=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9955BC4338F
	for <linux-erofs@archiver.kernel.org>; Thu, 29 Jul 2021 03:25:14 +0000 (UTC)
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 12FED6103E
	for <linux-erofs@archiver.kernel.org>; Thu, 29 Jul 2021 03:25:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 12FED6103E
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.ozlabs.org
Received: from boromir.ozlabs.org (localhost [IPv6:::1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4GZwrl5794z3bmy
	for <linux-erofs@archiver.kernel.org>; Thu, 29 Jul 2021 13:25:11 +1000 (AEST)
Authentication-Results: lists.ozlabs.org;
	dkim=fail reason="signature verification failed" (2048-bit key; secure) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=casper.20170209 header.b=CmQJQH43;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org;
 spf=none (no SPF record) smtp.mailfrom=infradead.org
 (client-ip=2001:8b0:10b:1236::1; helo=casper.infradead.org;
 envelope-from=willy@infradead.org; receiver=<UNKNOWN>)
Authentication-Results: lists.ozlabs.org; dkim=pass (2048-bit key;
 secure) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256
 header.s=casper.20170209 header.b=CmQJQH43; 
 dkim-atps=neutral
Received: from casper.infradead.org (casper.infradead.org
 [IPv6:2001:8b0:10b:1236::1])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
 (No client certificate requested)
 by lists.ozlabs.org (Postfix) with ESMTPS id 4GZwrc63MJz2yLd
 for <linux-erofs@lists.ozlabs.org>; Thu, 29 Jul 2021 13:25:02 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
 Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
 Content-Description:In-Reply-To:References;
 bh=Zx24Tdms2CAcVL+Y0xOOs/yG6aW6xTMzubnm9RhAPcs=; b=CmQJQH43AEoXaW6IJUt9izAtX1
 nkDtCr++9IelU/oLypXAuC4T4bx4cGCi9ychlZmYlTz5n3DMVxN5w7aQdahPJA4R+eggkUzB8PF+1
 UlsPalGGzI0z8qrMs66jk2fASWKfU8cdnOJULDzBMGKHA+oQn1J/Ddag8hGwY+LO9g7vgUtiuxVg0
 J06bxwWImi5fyAnx5TpHOgTnKSt+3g4e553AEsxoMwFIRkfLDbXys3Ht/ENgNyh80l05luVzjIStH
 Zbc6ZbAqhDPTOZkssqqzYxOqpSiV7/WdLM85limjNXxnqoBC6WHFZYYnTeWtCJjA349EqIKx/tqTN
 CAQKsHEg==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red
 Hat Linux)) id 1m8weA-00GgCH-Gr; Thu, 29 Jul 2021 03:24:08 +0000
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
To: linux-erofs@lists.ozlabs.org, linux-fsdevel@vger.kernel.org,
 linux-xfs@vger.kernel.org
Subject: [PATCH v2] iomap: Support inline data with block size < page size
Date: Thu, 29 Jul 2021 04:23:44 +0100
Message-Id: <20210729032344.3975412-1-willy@infradead.org>
X-Mailer: git-send-email 2.31.1
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
Cc: agruenba@redhat.com, hch@lst.de,
 "Matthew Wilcox \(Oracle\)" <willy@infradead.org>, djwong@kernel.org
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs"
 <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>

Remove the restriction that inline data must start on a page boundary
in a file.  This allows, for example, the first 2KiB to be stored out
of line and the trailing 30 bytes to be stored inline.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
v2:
 - Rebase on top of iomap: Support file tail packing v9

 fs/iomap/buffered-io.c | 34 ++++++++++++++++------------------
 1 file changed, 16 insertions(+), 18 deletions(-)

diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
index 66b733537c46..50f18985ed13 100644
--- a/fs/iomap/buffered-io.c
+++ b/fs/iomap/buffered-io.c
@@ -209,28 +209,26 @@ static int iomap_read_inline_data(struct inode *inode, struct page *page,
 		struct iomap *iomap)
 {
 	size_t size = i_size_read(inode) - iomap->offset;
+	size_t poff = offset_in_page(iomap->offset);
 	void *addr;
 
 	if (PageUptodate(page))
-		return 0;
+		return PAGE_SIZE - poff;
 
-	/* inline data must start page aligned in the file */
-	if (WARN_ON_ONCE(offset_in_page(iomap->offset)))
-		return -EIO;
 	if (WARN_ON_ONCE(size > PAGE_SIZE -
 			 offset_in_page(iomap->inline_data)))
 		return -EIO;
 	if (WARN_ON_ONCE(size > iomap->length))
 		return -EIO;
-	if (WARN_ON_ONCE(page_has_private(page)))
-		return -EIO;
+	if (poff > 0)
+		iomap_page_create(inode, page);
 
-	addr = kmap_atomic(page);
+	addr = kmap_atomic(page) + poff;
 	memcpy(addr, iomap->inline_data, size);
-	memset(addr + size, 0, PAGE_SIZE - size);
+	memset(addr + size, 0, PAGE_SIZE - poff - size);
 	kunmap_atomic(addr);
-	SetPageUptodate(page);
-	return 0;
+	iomap_set_range_uptodate(page, poff, PAGE_SIZE - poff);
+	return PAGE_SIZE - poff;
 }
 
 static inline bool iomap_block_needs_zeroing(struct inode *inode,
@@ -252,13 +250,8 @@ iomap_readpage_actor(struct inode *inode, loff_t pos, loff_t length, void *data,
 	unsigned poff, plen;
 	sector_t sector;
 
-	if (iomap->type == IOMAP_INLINE) {
-		int ret = iomap_read_inline_data(inode, page, iomap);
-
-		if (ret)
-			return ret;
-		return PAGE_SIZE;
-	}
+	if (iomap->type == IOMAP_INLINE)
+		return iomap_read_inline_data(inode, page, iomap);
 
 	/* zero post-eof blocks as the page may be mapped */
 	iop = iomap_page_create(inode, page);
@@ -593,10 +586,15 @@ __iomap_write_begin(struct inode *inode, loff_t pos, unsigned len, int flags,
 static int iomap_write_begin_inline(struct inode *inode,
 		struct page *page, struct iomap *srcmap)
 {
+	int ret;
+
 	/* needs more work for the tailpacking case, disable for now */
 	if (WARN_ON_ONCE(srcmap->offset != 0))
 		return -EIO;
-	return iomap_read_inline_data(inode, page, srcmap);
+	ret = iomap_read_inline_data(inode, page, srcmap);
+	if (ret < 0)
+		return ret;
+	return 0;
 }
 
 static int
-- 
2.30.2

