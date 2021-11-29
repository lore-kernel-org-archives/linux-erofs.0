Return-Path: <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1D03DC433EF
	for <linux-erofs@archiver.kernel.org>; Mon, 29 Nov 2021 10:23:30 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [IPv6:::1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4J2hJc5gXZz3cW6
	for <linux-erofs@archiver.kernel.org>; Mon, 29 Nov 2021 21:23:28 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org;
	dkim=fail reason="signature verification failed" (2048-bit key; secure) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=casper.20170209 header.b=ONr3+Hqh;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=none (no SPF record)
 smtp.mailfrom=casper.srs.infradead.org (client-ip=2001:8b0:10b:1236::1;
 helo=casper.infradead.org;
 envelope-from=batv+13c9c90cf431a9f4f7f6+6672+infradead.org+hch@casper.srs.infradead.org;
 receiver=<UNKNOWN>)
Authentication-Results: lists.ozlabs.org; dkim=pass (2048-bit key;
 secure) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256
 header.s=casper.20170209 header.b=ONr3+Hqh; 
 dkim-atps=neutral
Received: from casper.infradead.org (casper.infradead.org
 [IPv6:2001:8b0:10b:1236::1])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
 (No client certificate requested)
 by lists.ozlabs.org (Postfix) with ESMTPS id 4J2hHW3tpGz3cTd
 for <linux-erofs@lists.ozlabs.org>; Mon, 29 Nov 2021 21:22:31 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
 References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
 Content-Type:Content-ID:Content-Description;
 bh=ZI8fdJdAHvC2/8mTH+7pB1lSA27KsqbHwcacuu5ur0Y=; b=ONr3+Hqhtmlw3mDkcAWneercGq
 rt6I893UuowUX/zXeALoSjQCy/x0sEwKWPAtbKgul2jhM//AAJ50ZfaX5683gI4sBwbXMSyAATkT/
 SNX+V/PjIZmsMIGQhQTl/xuRKuNf3I55iQy4OK3aEHxl0L159LvqS3w0Iklm5jB0Lh5kMAtlDQfBc
 7nkMbOC8pA6bEgwfn/eSwOZplpeGO13m5ytFJAIwNED0TUpotITZACvM0X9kWZoPw2kDHf+8w+1mX
 gziZR5lkN5mnJL+xEkocYcOZDVSJXOxruOgnTe7Cm3Q5xPbByWN7PeYVnTsIHbOOCVv7dQfA0yJzt
 nYhtSfpw==;
Received: from [2001:4bb8:184:4a23:724a:c057:c7bf:4643] (helo=localhost)
 by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
 id 1mrdng-0073O9-Bb; Mon, 29 Nov 2021 10:22:21 +0000
From: Christoph Hellwig <hch@lst.de>
To: Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH 12/29] fsdax: remove a pointless __force cast in
 copy_cow_page_dax
Date: Mon, 29 Nov 2021 11:21:46 +0100
Message-Id: <20211129102203.2243509-13-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211129102203.2243509-1-hch@lst.de>
References: <20211129102203.2243509-1-hch@lst.de>
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
 dm-devel@redhat.com, "Darrick J . Wong" <djwong@kernel.org>,
 linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
 Ira Weiny <ira.weiny@intel.com>
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs"
 <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>

Despite its name copy_user_page expected kernel addresses, which is what
we already have.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/dax.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/dax.c b/fs/dax.c
index 4e3e5a283a916..73bd1439d8089 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -728,7 +728,7 @@ static int copy_cow_page_dax(struct block_device *bdev, struct dax_device *dax_d
 		return rc;
 	}
 	vto = kmap_atomic(to);
-	copy_user_page(vto, (void __force *)kaddr, vaddr, to);
+	copy_user_page(vto, kaddr, vaddr, to);
 	kunmap_atomic(vto);
 	dax_read_unlock(id);
 	return 0;
-- 
2.30.2

