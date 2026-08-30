Return-Path: <linux-erofs+bounces-4371-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 012C0C61DD9
	for <linux-erofs@archiver.kernel.org>; Sun, 30 Aug 2026 04:19:29 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hXf5n0TR0z2ygW;
	Sun, 30 Aug 2026 14:19:25 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2001:8b0:10b:1236::1"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1788063564;
	cv=none; b=VgrTnRAHRq+T6+4wnA039ocYgdVi5qZtLR821FdC4NOumEfqQq4tg6HA+lAUmZ4YGU6JC8Js5sIjivqbjNRQy2wy3dbSu5vzcCynfYdNg9Q5watrLmiqIYVUB0ZRELWEUYjGFl6XsJT9VFbSaz4jHigifFOESVadfzukgCe7hwhkJFlUy9Y3p97LDPjZK6mn2J/YwW80dcFHA/xPR9vMsAhFmnm0h38NUljlB/8Azg6iT8JskQcUpY1Qx4sQmFen5F6di43uz+Bt6ssInDifNkPI4x8aFXxLAoMM6noOERjjfVayNtNxs1eJQvkgIJ9YBNxlyaAlps5+TmV4Oaijdw==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1788063564; c=relaxed/relaxed;
	bh=dejHJnjtKaOM8kEBucRI9H7VqzSRiRdAVrdQgRGUFkI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KG7BXmhTU9+oup3P1t6ZP71iEZP92X1zUdXOjMPhKcpGqDWvEEYmnz3LMwi3yG7orG9kSJDf300agxK60GSQccw6NAGvmKzCqyyUuPlSk6NWaEsnBXPilSIGndtGk1sx/OkHBunp/hht+rWebvldfgsEPVvFN87uUgOhwhwpyVWg9m2EgcOyHx2JSikPcq8tto2aX7kRfy590g8+Y16+GuVKIs8C3CteE+WP5bEBihVqt9o054Vz3GBr7k//v/Rlerk3xxRKUOW/XRTrjau1p0RG+UCK5LjVX6QVFbNRPZF9xQUnNz7lgCj5nDQIzJ5b9BGUYXvYqo5Qt8Es5nW6zQ==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=infradead.org; dkim=pass (2048-bit key; secure) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=casper.20170209 header.b=kq9hbcwK; dkim-atps=neutral; spf=pass (client-ip=2001:8b0:10b:1236::1; helo=casper.infradead.org; envelope-from=willy@infradead.org; receiver=lists.ozlabs.org) smtp.mailfrom=infradead.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; secure) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=casper.20170209 header.b=kq9hbcwK;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=infradead.org (client-ip=2001:8b0:10b:1236::1; helo=casper.infradead.org; envelope-from=willy@infradead.org; receiver=lists.ozlabs.org)
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hXf5g0zZmz2ybK
	for <linux-erofs@lists.ozlabs.org>; Sun, 30 Aug 2026 14:19:16 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=dejHJnjtKaOM8kEBucRI9H7VqzSRiRdAVrdQgRGUFkI=; b=kq9hbcwKXkJ4J1vRrFYKTsZrzz
	6lUCw4ImNf0uzG7wmavDvL2d1b1zE8A/RpsFFBEd2KjgADVNelaeu+Cc2ft0JaNcevE7WuveiN7Hb
	tuuPLC7wUk69v4nkxbWpYMUDTfv9hB1Rd+51IvuOI4rXruVCB/9lK9RX1+qkSSlUe/PNQoGfnKbnr
	FbqvDhWB9HA1L6PBoHuVyoe3P+DiWEWuQlRK2pYw1HhzYEuIWWYCtbW/rzc5y5iVbW1pda9V9RBwl
	edUQp11krj3umqsJsfHJRhphqubpVr29NMhHxEytCZURqMJYmtIFItwO3XcpwP+SOtdsg84LGxNjv
	2q6HPnXQ==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x0X0Z-000000000hb-1c0i;
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
Subject: [PATCH 6/9] ntfs: Remove redundant FGP_NOFS from ntfs_wof_collect_dest()
Date: Sun, 30 Aug 2026 05:18:53 +0100
Message-ID: <20260830041901.2668-7-willy@infradead.org>
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
just reclaiming from the filesystem.  Use mapping_gfp_mask() instead of
GFP_NOFS as this will preserve flags like GFP_MOVABLE.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 fs/ntfs/wof.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/fs/ntfs/wof.c b/fs/ntfs/wof.c
index 8f84c2212eee..c981b4a3b695 100644
--- a/fs/ntfs/wof.c
+++ b/fs/ntfs/wof.c
@@ -464,10 +464,9 @@ static int ntfs_wof_collect_dest(struct address_space *mapping,
 			folio = target;
 			is_target = true;
 		} else {
-			folio = __filemap_get_folio(
-				mapping, index,
-				FGP_LOCK | FGP_CREAT | FGP_NOFS | FGP_NOWAIT,
-				GFP_NOFS);
+			folio = __filemap_get_folio(mapping, index,
+					FGP_LOCK | FGP_CREAT | FGP_NOWAIT,
+					mapping_gfp_mask(mapping));
 			if (IS_ERR(folio))
 				return PTR_ERR(folio);
 			is_target = false;
-- 
2.47.3


