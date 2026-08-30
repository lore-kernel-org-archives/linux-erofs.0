Return-Path: <linux-erofs+bounces-4378-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1109DC61DDE
	for <linux-erofs@archiver.kernel.org>; Sun, 30 Aug 2026 04:19:48 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hXf5y19LPz2ygp;
	Sun, 30 Aug 2026 14:19:34 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2001:8b0:10b:1236::1"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1788063574;
	cv=none; b=hIIXrMw3wJh1J9tAPe+fZx382kqRIxFnrbpwZ6dbwr8zNiGwTj3ee7mU26kxMukqKY8nuvqd9tGI8+fNhdSwVaNzX5MbSdEzDGTE8WcvbeJWHTp5D9pvHL9JiK5VIsArVV+SswUVmC7YSaVmvvaMafyVuGr7bdjsWu4ynHDyWhH7GCtYr+pUQAnnCHCqR84vfCPotGWRxdMYH+hPrdaZUwv5/xrr2LlHQvIiZ1qpZlnpFkjt7V6lvKiK1/w0/3ERghKQ8ASYzujUVH6wjq8O3x61N2fsyQJ8dc/FTjK5TDQWYIyNtqsnSrtLL76rXlfoBfaOJ3smRNN6TAR6K9tUzg==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1788063574; c=relaxed/relaxed;
	bh=tsfpWnTEEugF5BhxxP0f5NSzcOBwxx6do+o7r7CRpoM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gGvEFUkua7/ZEYcEeAKCf/jbE29VBdkd77GZ7mWA+Sd8NyexsmTuFsBcq2g+HV5v1Z+GeNGh6fTAbbsht0bELWiQmdwvOILS0scWjdbdd0wxpeD8IOMcMsm0n4q8nVcF0ud59/+sLzMjLLJHKgw57c0YMBSkmtHSsZpgt6t0cq0kuCIHfn54t013GcUx4ICf48ySV4QERClHZHxBTZrYKQKsjDQ3cxk/Whu+B6rilOVk9lt/0Gl1OEfrFYybRe+geDzGf9Stf/UOeJ6P5V+Qa1qgSuagX/CvU+nGIIdGPKwogizQNMXn+Zq1TiT84IGrBzR0Kk98LQoqCY6w6y59XA==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=infradead.org; dkim=pass (2048-bit key; secure) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=casper.20170209 header.b=jmnyzAGh; dkim-atps=neutral; spf=pass (client-ip=2001:8b0:10b:1236::1; helo=casper.infradead.org; envelope-from=willy@infradead.org; receiver=lists.ozlabs.org) smtp.mailfrom=infradead.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; secure) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=casper.20170209 header.b=jmnyzAGh;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=infradead.org (client-ip=2001:8b0:10b:1236::1; helo=casper.infradead.org; envelope-from=willy@infradead.org; receiver=lists.ozlabs.org)
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hXf5x4PvZz2ygg
	for <linux-erofs@lists.ozlabs.org>; Sun, 30 Aug 2026 14:19:33 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=tsfpWnTEEugF5BhxxP0f5NSzcOBwxx6do+o7r7CRpoM=; b=jmnyzAGhnXUs0+C5LS24e7OvOs
	zECGaQnz/K7uDPY+0u1wIf57vrFCgxSAVDmXvvj2TMBVH3TwhpYMMCjU/iKIiKTFWX3wS6ki66JzL
	u+cDYy9gVlfHAwnU21whEjN+K2q/N4jfjfUTBerTfCmMcehN/SHRRgR81UCMVMH1utVmJ4lkryx73
	gukk3XpXRgPtZ+cK2nFL5ks8imp9XnV9WbnbHY6KaDnzoVrezcKyrtL4QpAosis5BrPyRe81xoTst
	U6BQxwL8QcjppnnEieucNP8b4nPqOQuTwxvZKv4tOIF7s0w4u3IBCUeo+jof7AAqQejsMCVDHmuHG
	SfbA0xNQ==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x0X0Z-000000000hS-0u4B;
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
Subject: [PATCH 4/9] nfs: Remove redundant FGP_NOFS
Date: Sun, 30 Aug 2026 05:18:51 +0100
Message-ID: <20260830041901.2668-5-willy@infradead.org>
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
 fs/nfs/dir.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/nfs/dir.c b/fs/nfs/dir.c
index 49394123bd09..e34125a8a2e2 100644
--- a/fs/nfs/dir.c
+++ b/fs/nfs/dir.c
@@ -447,7 +447,7 @@ static struct folio *nfs_readdir_folio_get_next(struct address_space *mapping,
 	struct folio *folio;
 
 	folio = __filemap_get_folio(mapping, index,
-			FGP_LOCK|FGP_CREAT|FGP_NOFS|FGP_NOWAIT,
+			FGP_LOCK | FGP_CREAT | FGP_NOWAIT,
 			mapping_gfp_mask(mapping));
 	if (IS_ERR(folio))
 		return NULL;
-- 
2.47.3


