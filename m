Return-Path: <linux-erofs+bounces-4372-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EC485C61DE4
	for <linux-erofs@archiver.kernel.org>; Sun, 30 Aug 2026 04:19:31 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hXf5p5Xmlz2ybK;
	Sun, 30 Aug 2026 14:19:26 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2001:8b0:10b:1236::1"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1788063566;
	cv=none; b=EDGKZBxeii1FpOqC8VVgimoCVwphspj58BpxowFiZUDRadJJHy+yvOQNcjbzJjEt7uHIJ41PsSxnbx3hrNAIhLwEtSWZvJ/PT8ORc7AaQJpyXG0RgFGb2BIyu0Vmsm3mE59SScUDOg3wU7m6xOUAemxc7Njg3GSoGn9/kHAk4nB2hJY3IrC2MdAKdDxum3wrFyaGIuoKxhVvqIbzsgnxwf3lQM3B6Bojy6eSIJbeTHR8y/a00c0fqQaAzqP6QloZK3Rt/LxUzptbV3/xGoUQiCaWVPQ4QBgmhS7kLx/uyJzGUz4OBAGknnK5/TugXnueKQsHUrXqr4v2lV60jPKIfQ==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1788063566; c=relaxed/relaxed;
	bh=E9PhFISLskt0G9jrpDuqAu5vcSeLsmZLZhXWQ4ku/eI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K2842Sz1QY87acS7nkCNZiDzKkjHLcQNEf7ine//1ON17uaXtdxBuxeWODR9h7biggQX553fDgazCRaPBaXbyC2g1ht/TaNcgOohCMWk+4FFOUCE1ol7o+kBnqFGLKWrnuaFnumB/WnvPz8VL9NlelnPXovyH5fkzmvmLIofMxDhINsDrr5iS5m2v8cyHzLsoBSsaGlFyoTyn0IDaqzFc/pleIZiXHg53wDUfSaHwJgxGjUq7a+wqwu5oVvn+84G8Dqb+/CEg0MDyYHfkSEXt0yt6gmq5C6tbIP5v7M+Cd1N60WlOUZW0hHHb2hr6RIKxRcxRj8U8Zn+VC9Wq7qyCw==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=infradead.org; dkim=pass (2048-bit key; secure) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=casper.20170209 header.b=dl4JOhdj; dkim-atps=neutral; spf=pass (client-ip=2001:8b0:10b:1236::1; helo=casper.infradead.org; envelope-from=willy@infradead.org; receiver=lists.ozlabs.org) smtp.mailfrom=infradead.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; secure) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=casper.20170209 header.b=dl4JOhdj;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=infradead.org (client-ip=2001:8b0:10b:1236::1; helo=casper.infradead.org; envelope-from=willy@infradead.org; receiver=lists.ozlabs.org)
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hXf5g0Xrrz2xr2
	for <linux-erofs@lists.ozlabs.org>; Sun, 30 Aug 2026 14:19:18 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=E9PhFISLskt0G9jrpDuqAu5vcSeLsmZLZhXWQ4ku/eI=; b=dl4JOhdjy5Ky53MMIMMBSBjxka
	GMyBrCs+KW2T06hsemYTZsbViVEsYqH6IaNoiFeMIOs23zFgdkh5S85D4oEtrKsHkfOgxzhps21Kh
	6NpoQaSvy8g3bfy7JVTIHe7QClXeT/eCwfxNkZomI5FDA1vK8kOFGCVOXEqBcAIU07qbwq64YXybZ
	ZYvDvIoj6CbhKrL2AetEuVzCnYNaBocvwGaeqPf/lQS+EcUHCgTIgf/W9rTKkkPkc/ba67HcDVp4Q
	9CgcYBOQTK5Du77A8ZYIfso3emJlI1o86I2tmoE58/7/o6UdqqDwrPtwAXs6hbhhEd6NkD7c8n0Yi
	CDA201oA==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x0X0Z-000000000i7-30zs;
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
Subject: [PATCH 9/9] filemap: Remove FGP_NOFS
Date: Sun, 30 Aug 2026 05:18:56 +0100
Message-ID: <20260830041901.2668-10-willy@infradead.org>
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

There are no more users of FGP_NOFS.  Remove it.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 include/linux/pagemap.h | 10 ++++------
 mm/filemap.c            |  2 --
 2 files changed, 4 insertions(+), 8 deletions(-)

diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
index 3974b063a049..bff8b7264fb0 100644
--- a/include/linux/pagemap.h
+++ b/include/linux/pagemap.h
@@ -697,7 +697,6 @@ pgoff_t page_cache_prev_miss(struct address_space *mapping,
  *   folio is already in cache.  If the folio was allocated, unlock it
  *   before returning so the caller can do the same dance.
  * * %FGP_WRITE - The folio will be written to by the caller.
- * * %FGP_NOFS - __GFP_FS will get cleared in gfp.
  * * %FGP_NOWAIT - Don't block on the folio lock.
  * * %FGP_STABLE - Wait for the folio to be stable (finished writeback)
  * * %FGP_DONTCACHE - Uncached buffered IO
@@ -710,11 +709,10 @@ typedef unsigned int __bitwise fgf_t;
 #define FGP_LOCK		((__force fgf_t)0x00000002)
 #define FGP_CREAT		((__force fgf_t)0x00000004)
 #define FGP_WRITE		((__force fgf_t)0x00000008)
-#define FGP_NOFS		((__force fgf_t)0x00000010)
-#define FGP_NOWAIT		((__force fgf_t)0x00000020)
-#define FGP_FOR_MMAP		((__force fgf_t)0x00000040)
-#define FGP_STABLE		((__force fgf_t)0x00000080)
-#define FGP_DONTCACHE		((__force fgf_t)0x00000100)
+#define FGP_NOWAIT		((__force fgf_t)0x00000010)
+#define FGP_FOR_MMAP		((__force fgf_t)0x00000020)
+#define FGP_STABLE		((__force fgf_t)0x00000040)
+#define FGP_DONTCACHE		((__force fgf_t)0x00000080)
 #define FGF_GET_ORDER(fgf)	(((__force unsigned)fgf) >> 26)	/* top 6 bits */
 
 #define FGP_WRITEBEGIN		(FGP_LOCK | FGP_WRITE | FGP_CREAT | FGP_STABLE)
diff --git a/mm/filemap.c b/mm/filemap.c
index 6afec636881f..e6580291f218 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -1994,8 +1994,6 @@ struct folio *__filemap_get_folio_mpol(struct address_space *mapping,
 
 		if ((fgp_flags & FGP_WRITE) && mapping_can_writeback(mapping))
 			gfp |= __GFP_WRITE;
-		if (fgp_flags & FGP_NOFS)
-			gfp &= ~__GFP_FS;
 		if (fgp_flags & FGP_NOWAIT) {
 			gfp &= ~GFP_KERNEL;
 			gfp |= GFP_NOWAIT;
-- 
2.47.3


