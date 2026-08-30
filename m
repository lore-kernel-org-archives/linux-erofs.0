Return-Path: <linux-erofs+bounces-4377-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CEC98C61DE4
	for <linux-erofs@archiver.kernel.org>; Sun, 30 Aug 2026 04:19:46 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hXf5v4TDSz2yh4;
	Sun, 30 Aug 2026 14:19:31 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2001:8b0:10b:1236::1"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1788063571;
	cv=none; b=MNrT7LhJkFFHAEU9hiFVoXY+o9HV3HEEYq1+S8c8Tih8IY2Za8/zsv+G0Jja4DEb1fMb3aCyyS0cMyPdFu7ul05fOC5Ugh2NteVs9B/DMpSp2blTDW5yqFX2jPUvIuakgHzllNBBqYJcLhGWjN1hB7uoiykQ7HP/4lhfTP4ibrpRlvcQwnp+wH4kiKvk6JsGybinjqs0dh/yhAjWC5NHqAQ1RYqxxmhwS+9GQUxqru2XnnJNyE7Qup2tgx69Y3EAW4BuQUSguJtFKav5JWoZTHfNaNot1oF5UhPOPUTu700yfyid5Vb9MM+KWPTBFMRnz4owEUAMRNQoz8neebpGng==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1788063571; c=relaxed/relaxed;
	bh=yrBK9zAVRuWrfCGTpwW8HiqL2BzA7MjQTeYnO4XWRqM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CSrbAFQbqFdZmJxW9wT1fthyFT2g59MtD8cO0jEupNqiDPRd7HI3TXd8JNk8UXny4fDHyBjwIYVs65aHBbdApNSOvSWKRg2TLmUlbZmhF8pS95hVsqW3ZGDFhjOkxq981Pez/XX/y/gu26l1tvDAqIaAlMY67EJhRxikOLX0AsPPmn6AByon0WM+wfBUfOulg9sAmkOaDHgo5Y/JEC91P5qebF2fyqv6MSgqTSWiYSHsJCNdj034v/KuVP9RtZW1Tbj483iMETz2YB6PcsY+W6GGQrjYgXRRc+EMiQ5yBQn/5EY8Hds0NhVkmhTzCGYdrGj5GsO2Ef9M+6j/xdt39A==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=infradead.org; dkim=pass (2048-bit key; secure) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=casper.20170209 header.b=ZYfiTFLB; dkim-atps=neutral; spf=pass (client-ip=2001:8b0:10b:1236::1; helo=casper.infradead.org; envelope-from=willy@infradead.org; receiver=lists.ozlabs.org) smtp.mailfrom=infradead.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; secure) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=casper.20170209 header.b=ZYfiTFLB;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=infradead.org (client-ip=2001:8b0:10b:1236::1; helo=casper.infradead.org; envelope-from=willy@infradead.org; receiver=lists.ozlabs.org)
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hXf5t6GbRz2ygg
	for <linux-erofs@lists.ozlabs.org>; Sun, 30 Aug 2026 14:19:30 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=yrBK9zAVRuWrfCGTpwW8HiqL2BzA7MjQTeYnO4XWRqM=; b=ZYfiTFLBbqpdaWTdAiqc0+5xJO
	44XPrYZU6F4MGY/PtsCU8/I8FsN60fK+PLVNyFLOolQBLhPVG4oAy5ghiGXh3XA6i/J8LrLNlo1gS
	nRD1GPEqKKMUK1wKAK3kF8msLk4fxe0AnMcFu6iWeHAQ/J+5S2aFm/tnFPN7QjjcMKL2r40t93fJO
	iZEBXKfJRTsrPd1dKa/7324uldDA6fT9fizmRe62wSkq1l2cgf5cGHSNieSrJSrGjzuHeudQfxZwe
	36jH284GDJM01IX/0tCWU5I0AQj8pu6NkuPaA+ZB5fcN6kKlOk0Z0pCzUTrAL+zeI8fN6sy5EkstX
	GOyKOdMA==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x0X0Z-000000000hQ-0aEV;
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
Subject: [PATCH 3/9] erofs: Remove redundant FGP_NOFS
Date: Sun, 30 Aug 2026 05:18:50 +0100
Message-ID: <20260830041901.2668-4-willy@infradead.org>
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

The flags already include FGP_NOWAIT which prohibits all reclaim, not
just reclaiming from the filesystem.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 fs/erofs/internal.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/erofs/internal.h b/fs/erofs/internal.h
index 65974e57aebf..84b3cdc8e88f 100644
--- a/fs/erofs/internal.h
+++ b/fs/erofs/internal.h
@@ -327,7 +327,7 @@ static inline struct folio *erofs_grab_folio_nowait(struct address_space *as,
 						    pgoff_t index)
 {
 	return __filemap_get_folio(as, index,
-			FGP_LOCK|FGP_CREAT|FGP_NOFS|FGP_NOWAIT,
+			FGP_LOCK | FGP_CREAT | FGP_NOWAIT,
 			readahead_gfp_mask(as) & ~__GFP_RECLAIM);
 }
 
-- 
2.47.3


