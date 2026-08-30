Return-Path: <linux-erofs+bounces-4376-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 94B23C61DB9
	for <linux-erofs@archiver.kernel.org>; Sun, 30 Aug 2026 04:19:44 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hXf5r3sKGz2xbQ;
	Sun, 30 Aug 2026 14:19:28 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2001:8b0:10b:1236::1"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1788063568;
	cv=none; b=mcQi4b3f14/WHeC4IEMGIbue+vrUTLlLsEmwSM1KhDlI8XzlTdhR7FN1u1brUsrb0GRjeiRWFC1jszfwcyKQSA1msJPessqeX1C/3m1OXSNaO9XdYUax/o1PUe76c276YV8et6S2iSFfl0ktiMPw2M7hViqcijfx7vSC/xHFlrBxlN/CeZ5kW3vJnJgfVy7M/4tUu9DJLuWoP0746u+0pC5aahdq3tbwGMRGpsP2wirZXLlVdFm7BQuMHN0mVhMhFq6zl1R2StO9Qg6cZjpqbox+6PT+kMrqB46XSoIvIaE/z9FJ5a7Bpe04kEa8DQQh4ygimCXqOCRAtegpp5Ay+w==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1788063568; c=relaxed/relaxed;
	bh=iOsUEQiX5hPPz6sUPul1Vy0rSyJQxXGSiFeQvRVO8q0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f+u9sUK6oFOvbPjqJ3E6tUk1lg1ptVP+/lzwtaJCgeHNeQHidoZy5fKOvULgkDM+JDcP2lm02xYFGsyTywx6u0u4EeHdV8g/0rgkocEXklyBGKns4GtJBFz7QF0SfwLFPPs+1hkFb7vxlABpI8huOb/vQGYPg1u2TrhYJN3GEi9Sh03M0p6ZwWz/IbdepEWg8eOHZmcqG2J2xhNsjVoKllpwJFE/8G4tHx4EuLfjNH2h0Kg9yACQlzfodRvMXYZsb7+o6i2gEggg+59fETJqv3WKBvo7C/BznD+zMq9N0vWCRvY+gurY8I8MGIRACTHJQ9oqFIvvPLrgtfhlQCQ8Ew==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=infradead.org; dkim=pass (2048-bit key; secure) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=casper.20170209 header.b=L037xD86; dkim-atps=neutral; spf=pass (client-ip=2001:8b0:10b:1236::1; helo=casper.infradead.org; envelope-from=willy@infradead.org; receiver=lists.ozlabs.org) smtp.mailfrom=infradead.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; secure) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=casper.20170209 header.b=L037xD86;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=infradead.org (client-ip=2001:8b0:10b:1236::1; helo=casper.infradead.org; envelope-from=willy@infradead.org; receiver=lists.ozlabs.org)
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hXf5q6VLmz2yjN
	for <linux-erofs@lists.ozlabs.org>; Sun, 30 Aug 2026 14:19:27 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=iOsUEQiX5hPPz6sUPul1Vy0rSyJQxXGSiFeQvRVO8q0=; b=L037xD86tbRevrRc914UOatghV
	p+tn3zXNS1KjRC7ubVd5/qGwTQYn67z7oD8fyhA7G9ULdUFo+SleMrRPBP2CXoDSeI/7al9q9nIBh
	bmvFtG3Y5i5bMroPMma4KLePX0fwM4bTu9I2VJ5gXVLsypFk64Gnc/qCG7u567/hwq8yGZliK/Zvc
	mp+qCjf6x5LPR33alJLx9+FDr9EgLfA9qOEQWikc5b8t/EBAvvRKPq/rfyqVNKKFKh6WXwWwv2OGf
	vwRlTrodbR9EbM/Z0xfKyBR0cszGGhcIfowJ6uc6nEYVcihEAwYLp019cM9AJ+pEp5IabkI6qHXVM
	QYpBsLrA==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x0X0Z-000000000i3-26Vc;
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
Subject: [PATCH 7/9] squashfs: Remove use of FGP_NOFS
Date: Sun, 30 Aug 2026 05:18:54 +0100
Message-ID: <20260830041901.2668-8-willy@infradead.org>
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

Since we can allocate memory while holding a folio locked, we cannot
allow page reclaim to call into the filesystem and attempt to compact
the folio we're currently holding locked.  Use memalloc_nofs_save()
instead of FGP_NOFS here.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 fs/squashfs/file.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/squashfs/file.c b/fs/squashfs/file.c
index d83594ce91d2..34c550a266bc 100644
--- a/fs/squashfs/file.c
+++ b/fs/squashfs/file.c
@@ -398,6 +398,7 @@ void squashfs_copy_cache(struct folio *folio,
 	struct squashfs_sb_info *msblk = inode->i_sb->s_fs_info;
 	int i, mask = (1 << (msblk->block_log - PAGE_SHIFT)) - 1;
 	int start_index = folio->index & ~mask, end_index = start_index | mask;
+	unsigned int nofs = memalloc_nofs_save();
 
 	/*
 	 * Loop copying datablock into pages.  As the datablock likely covers
@@ -415,7 +416,7 @@ void squashfs_copy_cache(struct folio *folio,
 
 		push_folio = (i == folio->index) ? folio :
 			__filemap_get_folio(mapping, i,
-					FGP_LOCK|FGP_CREAT|FGP_NOFS|FGP_NOWAIT,
+					FGP_LOCK | FGP_CREAT | FGP_NOWAIT,
 					mapping_gfp_mask(mapping));
 
 		if (IS_ERR(push_folio))
@@ -430,6 +431,8 @@ void squashfs_copy_cache(struct folio *folio,
 		if (i != folio->index)
 			folio_put(push_folio);
 	}
+
+	memalloc_nofs_restore(nofs);
 }
 
 /* Read datablock stored packed inside a fragment (tail-end packed block) */
-- 
2.47.3


