Return-Path: <linux-erofs+bounces-4373-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EF7B2C61DDE
	for <linux-erofs@archiver.kernel.org>; Sun, 30 Aug 2026 04:19:36 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hXf5q1h5pz2xr2;
	Sun, 30 Aug 2026 14:19:27 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2001:8b0:10b:1236::1"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1788063567;
	cv=none; b=iefr5NqSwXuXl3SYoMB+gX6WNYe8oDujEzk0QzgVeYmzsvntRkNL1CtiBULCinXlse8UMf4rqAVL0r8Kss0WTkq9vWeWMV/JQwY66lpIokoMcNaq3FvdIuHXPoc+emzXnDcw1HPRr3FhcJqOaXFv3etB2T82N3e2mIQsykYordnin2kMXFAfSQVRSLoWkDi2UuXUWX01Rzn478vtLkmgqV0hhYB68IUFDdeguUuHVzraQWRpPEhZSs7Adp/8FfB03V+iUIMaGSs51+J5biIpO0ye0ul/tDUvoutfUIsvxRzP72++NcRh+bGIxT5807YmxlxkVlzmAwBlSjafqGO6OA==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1788063567; c=relaxed/relaxed;
	bh=/LhwqzyL2tHWHjKBCqUfd5fZsEqJTMNd4JrJ5Ssrbtk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IfgqlAT+9OJroWvlpERCsODTQ87ZNzWdJVMf3lje/gcdVjam8xtzebJH8eZ4zTCwavg/eW3eQdkZh1tf2GpaA+cjSwSPBcjljlWiAzCIxLYIfw2YuKs2BgICI8rfmYGODeA2sT05NBqCowz/ao1My7Rwmyh3eEc8mTg1C4I+fxsSjuP8RKeuuDMy3QrB9J8F5ZkAghcbmUgLQLLVXFJSo+nNvaOvtknar1R3qthEt7wQeaD7qmngU5n6b6svt+8hG9LbkQkLEl2AvJNHBvsRckC857zLzEJ+crKAg8fu5BtmIg3tCUWmLLjiu2rLuYdGwX7+h7kso0gUwRThl+fibg==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=infradead.org; dkim=pass (2048-bit key; secure) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=casper.20170209 header.b=St5YwczI; dkim-atps=neutral; spf=pass (client-ip=2001:8b0:10b:1236::1; helo=casper.infradead.org; envelope-from=willy@infradead.org; receiver=lists.ozlabs.org) smtp.mailfrom=infradead.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; secure) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=casper.20170209 header.b=St5YwczI;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=infradead.org (client-ip=2001:8b0:10b:1236::1; helo=casper.infradead.org; envelope-from=willy@infradead.org; receiver=lists.ozlabs.org)
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hXf5k09z1z2yft
	for <linux-erofs@lists.ozlabs.org>; Sun, 30 Aug 2026 14:19:21 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=/LhwqzyL2tHWHjKBCqUfd5fZsEqJTMNd4JrJ5Ssrbtk=; b=St5YwczIjGD0oycKcDall0vCVj
	B/1aacESJcnXac0qwwdgA/3w7ddFCpbvgsmZ/nlVJWobcV88bxg9CPvLkAGBCmV8ocwJagWRH8n/Q
	F216KC+E/t18eabT9+uXGIANM5zKCAR54zmlgGDg86mc8YESyhqBWaZu0k8XEEXkc7+Ll73JN1N9e
	S0K736Ep457HSJh8byMrQqKhowm2Z2zDnpX+PtHZrMZDRAXNuO8Q2e3KDVtpG2GzHgIXlWZUeiWzt
	KYUd1hZSWA+A5i6//HQpp0cdcprL0TWsBtQFQSGfDQWm31miYDxSCH2g/AIYWfGA5lOLoy0abA+8C
	1XFm7/+Q==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x0X0Z-000000000i5-2UZC;
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
Subject: [PATCH 8/9] filemap: Remove redundant FGP_NOFS
Date: Sun, 30 Aug 2026 05:18:55 +0100
Message-ID: <20260830041901.2668-9-willy@infradead.org>
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
 include/linux/pagemap.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
index 0adfa6605653..3974b063a049 100644
--- a/include/linux/pagemap.h
+++ b/include/linux/pagemap.h
@@ -929,7 +929,7 @@ static inline struct page *grab_cache_page_nowait(struct address_space *mapping,
 				pgoff_t index)
 {
 	return pagecache_get_page(mapping, index,
-			FGP_LOCK|FGP_CREAT|FGP_NOFS|FGP_NOWAIT,
+			FGP_LOCK | FGP_CREAT | FGP_NOWAIT,
 			mapping_gfp_mask(mapping));
 }
 
-- 
2.47.3


