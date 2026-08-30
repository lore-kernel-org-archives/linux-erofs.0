Return-Path: <linux-erofs+bounces-4370-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 865DFC61DB9
	for <linux-erofs@archiver.kernel.org>; Sun, 30 Aug 2026 04:19:27 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hXf5m6mTLz2ygK;
	Sun, 30 Aug 2026 14:19:24 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2001:8b0:10b:1236::1"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1788063564;
	cv=none; b=AtCfjCISwqXvliiqhcbtV7jahFkro4ST8+8+d2HqW+u5ExLyvUw7mcFlX4Jku41rWzS3qtN7Dt2qRDjy6/rdHI6Uqi3ts8WeVMueAZpXSdqA953qhLd2rI9rNMVgt8Gr//lwLiRI/chzK/vIHUA9vCZYYPJ2r4Y871iSmTryZSEgaxZofqkAK31y42jOebNMwvXKShNOTjuJf/CF9cSbjaQ0ndu8aIqqdsbABwH4R3WtFIlV5cW6/JJffPaepgUXiKv1RDq1o/CZXIwZJtknjGOq2GBDTGdEzwVKKmDOI6Jyut6rUJH9XiOwUtl231O7wPdYB937FYZLi76oyU0I/g==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1788063564; c=relaxed/relaxed;
	bh=sAVqQaDD0nzQkp3zhExFeGOqa+2+Hy4Fdk9PRQI1fM0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QGOZBGvHBFcVzsRjgyw7zOO+6JMqWpFc2yaocNY+EypXA87q2wg/Z+iLEUuh5RBxMRgGNXlUphiZRBaNuQdpuKOA5s0qTGrAhhSSsHBhdccliMDcex0hqIU+yKr2CwkwbZyLrhlyklzTvPcvKb+pi6TL/BHZFOijmhsVvak0NACaMX4orHpqlX+95BNJ7hQPe6WIdeglErlD5XNUAIsxUB5BX1gU+aT1ja6jNNRkGjgD7cCUNxtrFE4GvO3BkfY30mPcZnFVJ6eITQ1cPgUobg7tl/pIzwlRidfMc+oV/3qFpNVvA+CVjZgIn/T+JdOivOrXmKSZ0S/ZIemPMznQdw==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=infradead.org; dkim=pass (2048-bit key; secure) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=casper.20170209 header.b=WlAnPemS; dkim-atps=neutral; spf=pass (client-ip=2001:8b0:10b:1236::1; helo=casper.infradead.org; envelope-from=willy@infradead.org; receiver=lists.ozlabs.org) smtp.mailfrom=infradead.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; secure) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=casper.20170209 header.b=WlAnPemS;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=infradead.org (client-ip=2001:8b0:10b:1236::1; helo=casper.infradead.org; envelope-from=willy@infradead.org; receiver=lists.ozlabs.org)
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hXf5f4Zr9z2xbQ
	for <linux-erofs@lists.ozlabs.org>; Sun, 30 Aug 2026 14:19:16 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=sAVqQaDD0nzQkp3zhExFeGOqa+2+Hy4Fdk9PRQI1fM0=; b=WlAnPemS/R3wjjMsjkr3aofwS9
	6+ju9+kQC8VWeYQe+2IMhIT2Ko4MIpm9T7B0Lmm4+/Uf13Fwv8n715o7H+hWFddniZcLhAJHjjiiT
	aA/migYecE82jkMkMMno5/JuEXsrfN8WoUpiMiBkPVeWqz6axs0dVwulU9dCBTp+IdoSnPAkf8xcF
	YL0wyjvMwNGrulHZepPot54Pow7G/n21dtGCExy83ftylOY2SG0+rm98uLlu8rzis9gkxjUassWDi
	GOIryltiIV4homH5urnoNY/qK3Nlb1+CoSZyheJTky/4EyXoGDGMC8FQvASOJOANDxQLnuv/J2DyQ
	0jOAQa3g==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x0X0Z-000000000hU-1DZI;
	Sun, 30 Aug 2026 04:19:03 +0000
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
To: Christian Brauner <christian@brauner.io>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Jan Kara <jack@suse.cz>,
	Gao Xiang <xiang@kernel.org>,
	Chao Yu <chao@kernel.org>,
	"Theodore Tso" <tytso@mit.edu>,
	Trond Myklebust <trondmy@kernel.org>,
	Anna Schumaker <anna@kernel.org>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Hyunchul Lee <hyc.lee@gmail.com>,
	Phillip Lougher <phillip@squashfs.org.uk>,
	linux-erofs@lists.ozlabs.org,
	linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	linux-nfs@vger.kernel.org,
	ntfs@lists.linux.dev,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 5/9] ntfs: Remove FGP_NOFS from __ntfs_inode_resident_attr_pwrite()
Date: Sun, 30 Aug 2026 05:18:52 +0100
Message-ID: <20260830041901.2668-6-willy@infradead.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260830041901.2668-1-willy@infradead.org>
References: <20260830041901.2668-1-willy@infradead.org>
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

I do not believe that FGP_NOFS is needed here.  This function is called
from one place (ntfs_inode_attr_pwrite) which calls either this function
or __ntfs_inode_non_resident_attr_pwrite().  The latter function does not
use FGP_NOFS in its calls to allocate pagecaache memory, so it should not
be needed here either.  If it turns out to be needed by both functions,
then we should use memalloc_nofs_save at a higher level to protect both
of them.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 fs/ntfs/inode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ntfs/inode.c b/fs/ntfs/inode.c
index 32edb4045178..36a0d6b26c02 100644
--- a/fs/ntfs/inode.c
+++ b/fs/ntfs/inode.c
@@ -3676,7 +3676,7 @@ static s64 __ntfs_inode_resident_attr_pwrite(struct inode *vi,
 	mark_mft_record_dirty(ctx->ntfs_ino);
 
 	/* Keep the first page clean and uptodate */
-	folio = __filemap_get_folio(mapping, 0, FGP_WRITEBEGIN | FGP_NOFS,
+	folio = __filemap_get_folio(mapping, 0, FGP_WRITEBEGIN,
 				   mapping_gfp_mask(mapping));
 	if (IS_ERR(folio)) {
 		err = PTR_ERR(folio);
-- 
2.47.3


