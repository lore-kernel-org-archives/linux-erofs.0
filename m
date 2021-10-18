Return-Path: <SRS0=Or+M=PG=lists.ozlabs.org=linux-erofs-bounces+linux-erofs=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA1DAC43219
	for <linux-erofs@archiver.kernel.org>; Mon, 18 Oct 2021 04:41:44 +0000 (UTC)
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 5C783610E8
	for <linux-erofs@archiver.kernel.org>; Mon, 18 Oct 2021 04:41:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 5C783610E8
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.ozlabs.org
Received: from boromir.ozlabs.org (localhost [IPv6:::1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4HXkjg0pJlz2ypk
	for <linux-erofs@archiver.kernel.org>; Mon, 18 Oct 2021 15:41:43 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org;
	dkim=fail reason="signature verification failed" (2048-bit key; secure) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=bhBX7rmC;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=none (no SPF record)
 smtp.mailfrom=bombadil.srs.infradead.org (client-ip=2607:7c80:54:e::133;
 helo=bombadil.infradead.org;
 envelope-from=batv+653fb0268b18c2e086a8+6630+infradead.org+hch@bombadil.srs.infradead.org;
 receiver=<UNKNOWN>)
Authentication-Results: lists.ozlabs.org; dkim=pass (2048-bit key;
 secure) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256
 header.s=bombadil.20210309 header.b=bhBX7rmC; 
 dkim-atps=neutral
Received: from bombadil.infradead.org (bombadil.infradead.org
 [IPv6:2607:7c80:54:e::133])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
 (No client certificate requested)
 by lists.ozlabs.org (Postfix) with ESMTPS id 4HXkjM6GbVz3051
 for <linux-erofs@lists.ozlabs.org>; Mon, 18 Oct 2021 15:41:27 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
 MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
 :Reply-To:Content-Type:Content-ID:Content-Description;
 bh=yshAG8x+L3xCEIWR2tCMFQdAdZ38kdA8kcPW6wRpxek=; b=bhBX7rmC2goJgheM7uWADn7Ng3
 ZCjw15mYLC3VRnFAe9eD3FDAoqH7sEHb+jygTTK6Oe+FR9PYkNy6XEMko7FHY4YLzzhtiwa5N8l3R
 KL0STGaWID3Ia+tH4U4MpzB0aNcpkNl4PJv+9QoRAfvzrqkRB1K5zLuUzzuC6ttcb6rb3oR1Z/VM9
 1Goq9dd6tQ31GOcNne/xqGbNU46C5Bc+knsTbQKQ79P4rmsEwYgX4bxc2nAdyn7kUpWepCyqIXqJ/
 X4Gxb8rURTooQyrqOrfPd56VERFu+jC+vGOb/7Tat2bGN/cHbo1D8iER+4Ss/+WD4nNJqUv6uRaoI
 V1jtRkKw==;
Received: from 089144211028.atnat0020.highway.a1.net ([89.144.211.28]
 helo=localhost)
 by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
 id 1mcKSg-00E3P7-Px; Mon, 18 Oct 2021 04:41:23 +0000
From: Christoph Hellwig <hch@lst.de>
To: 
Subject: [PATCH 08/11] dm-linear: add a linear_dax_pgoff helper
Date: Mon, 18 Oct 2021 06:40:51 +0200
Message-Id: <20211018044054.1779424-9-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211018044054.1779424-1-hch@lst.de>
References: <20211018044054.1779424-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by
 bombadil.infradead.org. See http://www.infradead.org/rpr.html
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
 dm-devel@redhat.com, linux-fsdevel@vger.kernel.org,
 Dan Williams <dan.j.williams@intel.com>, linux-ext4@vger.kernel.org,
 Ira Weiny <ira.weiny@intel.com>
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs"
 <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>

Add a helper to perform the entire remapping for DAX accesses.  This
helper open codes bdev_dax_pgoff given that the alignment checks have
already been done by the submitting file system and don't need to be
repeated.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/md/dm-linear.c | 49 +++++++++++++-----------------------------
 1 file changed, 15 insertions(+), 34 deletions(-)

diff --git a/drivers/md/dm-linear.c b/drivers/md/dm-linear.c
index 32fbab11bf90c..bf03f73fd0f36 100644
--- a/drivers/md/dm-linear.c
+++ b/drivers/md/dm-linear.c
@@ -164,63 +164,44 @@ static int linear_iterate_devices(struct dm_target *ti,
 }
 
 #if IS_ENABLED(CONFIG_FS_DAX)
+static struct dax_device *linear_dax_pgoff(struct dm_target *ti, pgoff_t *pgoff)
+{
+	struct linear_c *lc = ti->private;
+	sector_t sector = linear_map_sector(ti, *pgoff << PAGE_SECTORS_SHIFT);
+
+	*pgoff = (get_start_sect(lc->dev->bdev) + sector) >> PAGE_SECTORS_SHIFT;
+	return lc->dev->dax_dev;
+}
+
 static long linear_dax_direct_access(struct dm_target *ti, pgoff_t pgoff,
 		long nr_pages, void **kaddr, pfn_t *pfn)
 {
-	long ret;
-	struct linear_c *lc = ti->private;
-	struct block_device *bdev = lc->dev->bdev;
-	struct dax_device *dax_dev = lc->dev->dax_dev;
-	sector_t dev_sector, sector = pgoff * PAGE_SECTORS;
-
-	dev_sector = linear_map_sector(ti, sector);
-	ret = bdev_dax_pgoff(bdev, dev_sector, nr_pages * PAGE_SIZE, &pgoff);
-	if (ret)
-		return ret;
+	struct dax_device *dax_dev = linear_dax_pgoff(ti, &pgoff);
+
 	return dax_direct_access(dax_dev, pgoff, nr_pages, kaddr, pfn);
 }
 
 static size_t linear_dax_copy_from_iter(struct dm_target *ti, pgoff_t pgoff,
 		void *addr, size_t bytes, struct iov_iter *i)
 {
-	struct linear_c *lc = ti->private;
-	struct block_device *bdev = lc->dev->bdev;
-	struct dax_device *dax_dev = lc->dev->dax_dev;
-	sector_t dev_sector, sector = pgoff * PAGE_SECTORS;
+	struct dax_device *dax_dev = linear_dax_pgoff(ti, &pgoff);
 
-	dev_sector = linear_map_sector(ti, sector);
-	if (bdev_dax_pgoff(bdev, dev_sector, ALIGN(bytes, PAGE_SIZE), &pgoff))
-		return 0;
 	return dax_copy_from_iter(dax_dev, pgoff, addr, bytes, i);
 }
 
 static size_t linear_dax_copy_to_iter(struct dm_target *ti, pgoff_t pgoff,
 		void *addr, size_t bytes, struct iov_iter *i)
 {
-	struct linear_c *lc = ti->private;
-	struct block_device *bdev = lc->dev->bdev;
-	struct dax_device *dax_dev = lc->dev->dax_dev;
-	sector_t dev_sector, sector = pgoff * PAGE_SECTORS;
+	struct dax_device *dax_dev = linear_dax_pgoff(ti, &pgoff);
 
-	dev_sector = linear_map_sector(ti, sector);
-	if (bdev_dax_pgoff(bdev, dev_sector, ALIGN(bytes, PAGE_SIZE), &pgoff))
-		return 0;
 	return dax_copy_to_iter(dax_dev, pgoff, addr, bytes, i);
 }
 
 static int linear_dax_zero_page_range(struct dm_target *ti, pgoff_t pgoff,
 				      size_t nr_pages)
 {
-	int ret;
-	struct linear_c *lc = ti->private;
-	struct block_device *bdev = lc->dev->bdev;
-	struct dax_device *dax_dev = lc->dev->dax_dev;
-	sector_t dev_sector, sector = pgoff * PAGE_SECTORS;
-
-	dev_sector = linear_map_sector(ti, sector);
-	ret = bdev_dax_pgoff(bdev, dev_sector, nr_pages << PAGE_SHIFT, &pgoff);
-	if (ret)
-		return ret;
+	struct dax_device *dax_dev = linear_dax_pgoff(ti, &pgoff);
+
 	return dax_zero_page_range(dax_dev, pgoff, nr_pages);
 }
 
-- 
2.30.2

