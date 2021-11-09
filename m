Return-Path: <SRS0=k0XQ=P4=lists.ozlabs.org=linux-erofs-bounces+linux-erofs=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 928C2C4332F
	for <linux-erofs@archiver.kernel.org>; Tue,  9 Nov 2021 08:34:37 +0000 (UTC)
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 3F51E61186
	for <linux-erofs@archiver.kernel.org>; Tue,  9 Nov 2021 08:34:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 3F51E61186
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.ozlabs.org
Received: from boromir.ozlabs.org (localhost [IPv6:::1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4HpLrD00m4z305P
	for <linux-erofs@archiver.kernel.org>; Tue,  9 Nov 2021 19:34:36 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org;
	dkim=fail reason="signature verification failed" (2048-bit key; secure) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=casper.20170209 header.b=b+PYedII;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=none (no SPF record)
 smtp.mailfrom=casper.srs.infradead.org (client-ip=2001:8b0:10b:1236::1;
 helo=casper.infradead.org;
 envelope-from=batv+ffbfd99345897bc8db8d+6652+infradead.org+hch@casper.srs.infradead.org;
 receiver=<UNKNOWN>)
Authentication-Results: lists.ozlabs.org; dkim=pass (2048-bit key;
 secure) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256
 header.s=casper.20170209 header.b=b+PYedII; 
 dkim-atps=neutral
Received: from casper.infradead.org (casper.infradead.org
 [IPv6:2001:8b0:10b:1236::1])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
 (No client certificate requested)
 by lists.ozlabs.org (Postfix) with ESMTPS id 4HpLqf0yCfz303H
 for <linux-erofs@lists.ozlabs.org>; Tue,  9 Nov 2021 19:34:06 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
 References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
 Content-Type:Content-ID:Content-Description;
 bh=brXsiud4Cc0AgfRTr4nbCZuEA3TzdfnPNyojG8VnBfw=; b=b+PYedIIgGjCdMCp9JN/B8B1Fz
 nzGeNiytbR6ImqRNS4vswOWH638cDm5VRSAitO6lGR+yV/I/Mz2iufYPGI1Y1GX1IfNXWO7JHC4ld
 fEzA52mVx4lCysgJIIwa69LyDX4hyeuPdKgbYC8DhqLL6Y8vrE5UVY453IQYCupw9RKT4TsXvf2ce
 j+ewr0bulk+Ez7yJgzAmbWDuIKmcUNTufJ5ljbdNaEC9XUayw1afVZIMZLjhbdRsIoNb6B7m+WiJa
 HgAsWfZs/0KGoArpevAcNfqJzQStr/V52bfoKMqM4fyX+hMXZKusk/jwOEJCnVmIpMa7W4rq6AHIj
 j82xNF8w==;
Received: from [2001:4bb8:19a:7ee7:fb46:2fe1:8652:d9d4] (helo=localhost)
 by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
 id 1mkMZm-000sAK-3U; Tue, 09 Nov 2021 08:33:55 +0000
From: Christoph Hellwig <hch@lst.de>
To: Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH 24/29] xfs: use xfs_direct_write_iomap_ops for DAX zeroing
Date: Tue,  9 Nov 2021 09:33:04 +0100
Message-Id: <20211109083309.584081-25-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211109083309.584081-1-hch@lst.de>
References: <20211109083309.584081-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by
 casper.infradead.org. See http://www.infradead.org/rpr.html
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
Cc: nvdimm@lists.linux.dev, Mike Snitzer <snitzer@redhat.com>,
 linux-s390@vger.kernel.org, linux-erofs@lists.ozlabs.org,
 virtualization@lists.linux-foundation.org, linux-xfs@vger.kernel.org,
 dm-devel@redhat.com, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
 Ira Weiny <ira.weiny@intel.com>
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs"
 <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>

While the buffered write iomap ops do work due to the fact that zeroing
never allocates blocks, the DAX zeroing should use the direct ops just
like actual DAX I/O.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_iomap.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index 8cef3b68cba78..704292c6ce0c7 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -1324,7 +1324,7 @@ xfs_zero_range(
 
 	if (IS_DAX(inode))
 		return dax_zero_range(inode, pos, len, did_zero,
-				      &xfs_buffered_write_iomap_ops);
+				      &xfs_direct_write_iomap_ops);
 	return iomap_zero_range(inode, pos, len, did_zero,
 				&xfs_buffered_write_iomap_ops);
 }
@@ -1339,7 +1339,7 @@ xfs_truncate_page(
 
 	if (IS_DAX(inode))
 		return dax_truncate_page(inode, pos, did_zero,
-					&xfs_buffered_write_iomap_ops);
+					&xfs_direct_write_iomap_ops);
 	return iomap_truncate_page(inode, pos, did_zero,
 				   &xfs_buffered_write_iomap_ops);
 }
-- 
2.30.2

