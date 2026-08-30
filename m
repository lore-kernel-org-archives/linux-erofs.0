Return-Path: <linux-erofs+bounces-4375-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EA608C61DDE
	for <linux-erofs@archiver.kernel.org>; Sun, 30 Aug 2026 04:19:40 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hXf5q5N8gz2y7Y;
	Sun, 30 Aug 2026 14:19:27 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2001:8b0:10b:1236::1"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1788063567;
	cv=none; b=jlJ2j7MrIVjrDnMPLViNmW+IdcU7bCNeiZLCuMXGWOP4lcQKqu3tz5W63TBOe8Py0p0UQzxn+FQpk74si2UTuji2yHkSCJBRH3sMIqCu6UJiECD/qVRi7nuP7ICF8Ky+JwHY6F/V54Ks1U1khoGg24RFWlJfNMsrSTaPrBzgtgkIu9fn0qD/OcP1wDuZz4QPm6yLup1V6l/oy2mRwlZd+cyocAb12hoahSXF6zz3jBj/qV3IutZ0NdhIsSCH72BDX9n2j6VHKyMiqdsIiuIqFkLzuVRoqJNhExCrunWyvlzsLPf8Io6WHjhs999wTPRpXALEtyyLw0wi0tHbVjiQTw==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1788063567; c=relaxed/relaxed;
	bh=HX1YDxtUboff1x1jxC0V0517QCG7T5Er/z3xEiz/4yI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VN7cm3G2BLCp9GH2npPR1fBf8RZcssTQvkIC+9S8Uaeb1qW12tSGdajzqSI5g/hockio7wBgzXu45qJuphls6XPM9X+wWDPP1GPhUuIkkBNCZf3PUFZBVOSP4Ye8pHwvllcI12Q0biE6sNSRjNCwu462VYdOpQxsmf5VWD0RDlL4SKu1pFQJDiCC3JteFd7SwmfG3z49TI1+rBux16bNixP5s4mpDWhblONh8lq1xEqcSUiwrqoR/XvwxVcvgTZPUYFDAsie562+DO/DNsYYEqtLNeBz0vyEck6LAiY7OoK/u+NfwQIOa1BzFdeIfLDxDVrn/0F9mm99Uvt9jkTWQA==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=infradead.org; dkim=pass (2048-bit key; secure) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=casper.20170209 header.b=Ia8PDE2J; dkim-atps=neutral; spf=pass (client-ip=2001:8b0:10b:1236::1; helo=casper.infradead.org; envelope-from=willy@infradead.org; receiver=lists.ozlabs.org) smtp.mailfrom=infradead.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; secure) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=casper.20170209 header.b=Ia8PDE2J;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=infradead.org (client-ip=2001:8b0:10b:1236::1; helo=casper.infradead.org; envelope-from=willy@infradead.org; receiver=lists.ozlabs.org)
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hXf5n4jLTz2xbQ
	for <linux-erofs@lists.ozlabs.org>; Sun, 30 Aug 2026 14:19:25 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=HX1YDxtUboff1x1jxC0V0517QCG7T5Er/z3xEiz/4yI=; b=Ia8PDE2J2L592KXDaHpWvWTj85
	NBPDULnBAmGG3IioI8moIoKt27O8MzhWpiF8X5mkvtK2f3gT2lxyE+rovkiLoGZtaNu8rpXjLzE1X
	y/qzn8ph0pq9AyJyutBn4yxdtnrIG0I8ie7p7DUyEhGMr3vxcqeAuXOXcrXgJKOhdbS019CrIK8kp
	ALBRFMAZRUNq78CHH7EUDPXo6vM6jpwZmR2bj/GcxFtVZUjPIQzsV5t3qGR6z1Toj4PBbKVodMH3Q
	ql0J0/GC6hH8KdGVCXhVvfOwE0SQ+c00DRGQ6Vfe2QpfB0R05sIakJVbP+ObSEpkWWLCLjwX4QaBC
	GqtlndIg==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x0X0Y-000000000hM-42LV;
	Sun, 30 Aug 2026 04:19:02 +0000
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
Subject: [PATCH 1/9] mm: Improve memalloc_nofs_save() documentation
Date: Sun, 30 Aug 2026 05:18:48 +0100
Message-ID: <20260830041901.2668-2-willy@infradead.org>
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

Talk about why someone should call this function instead of
what this function does.  This makes the long comment in mm/readahead.c
obsolete; replace it with a comment about which case we're protecting
against.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 include/linux/sched/mm.h | 31 +++++++++++++++++++++++--------
 mm/readahead.c           | 14 ++------------
 2 files changed, 25 insertions(+), 20 deletions(-)

diff --git a/include/linux/sched/mm.h b/include/linux/sched/mm.h
index d7c6a942aa7e..f76be1141b06 100644
--- a/include/linux/sched/mm.h
+++ b/include/linux/sched/mm.h
@@ -372,13 +372,26 @@ static inline void memalloc_noio_restore(unsigned int flags)
 }
 
 /**
- * memalloc_nofs_save - Marks implicit GFP_NOFS allocation scope.
+ * memalloc_nofs_save - Prevent recursion into the filesystem.
  *
- * This functions marks the beginning of the GFP_NOFS allocation scope.
- * All further allocations will implicitly drop __GFP_FS flag and so
- * they are safe for the FS critical section from the allocation recursion
- * point of view. Use memalloc_nofs_restore to end the scope with flags
- * returned by this function.
+ * All memory allocations between calling this function and calling
+ * memalloc_nofs_restore() will be prevented from calling into filesystems
+ * to reclaim memory.  Clean page cache memory can still be reclaimed,
+ * but (for example) inodes will not be.
+ *
+ * The primary reason to do this is that the caller has taken a lock
+ * which would be needed by FS reclaim.  While we could theoretically
+ * call into a different filesystem in this case, it can be a deep call
+ * stack so it is better to avoid all filesystems.
+ *
+ * Filesystems often choose to incorporate a call to this function as part
+ * of starting a journal transaction.  While not a lock in the normal
+ * sense, it has much the same effect as nested journal transactions
+ * are either prohibited or expensive.
+ *
+ * Also call this function if you need to allocate memory while holding
+ * a file folio locked.  High order allocations (such as those requested
+ * by slab) can trigger compaction which will attempt to lock the folio.
  *
  * Context: This function is safe to be used from any context.
  * Return: The saved flags to be passed to memalloc_nofs_restore.
@@ -389,10 +402,12 @@ static inline unsigned int memalloc_nofs_save(void)
 }
 
 /**
- * memalloc_nofs_restore - Ends the implicit GFP_NOFS scope.
+ * memalloc_nofs_restore - End filesystem reclaim scope.
  * @flags: Flags to restore.
  *
- * Ends the implicit GFP_NOFS scope started by memalloc_nofs_save function.
+ * Ends the implicit memory allocation scope started by
+ * memalloc_nofs_save().  This may not enable access to filesystem reclaim
+ * if it was already disabled at the time memalloc_nofs_save() was called.
  * Always make sure that the given flags is the return value from the
  * pairing memalloc_nofs_save call.
  */
diff --git a/mm/readahead.c b/mm/readahead.c
index 6e5563290287..9c116d4ba963 100644
--- a/mm/readahead.c
+++ b/mm/readahead.c
@@ -227,17 +227,7 @@ void page_cache_ra_unbounded(struct readahead_control *ractl,
 	gfp_t gfp_mask = readahead_gfp_mask(mapping);
 	unsigned long mark = ULONG_MAX, i = 0;
 	unsigned int min_nrpages = mapping_min_folio_nrpages(mapping);
-
-	/*
-	 * Partway through the readahead operation, we will have added
-	 * locked pages to the page cache, but will not yet have submitted
-	 * them for I/O.  Adding another page may need to allocate memory,
-	 * which can trigger memory reclaim.  Telling the VM we're in
-	 * the middle of a filesystem operation will cause it to not
-	 * touch file-backed pages, preventing a deadlock.  Most (all?)
-	 * filesystems already specify __GFP_NOFS in their mapping's
-	 * gfp_mask, but let's be explicit here.
-	 */
+	/* Allocating with locked folios */
 	unsigned int nofs = memalloc_nofs_save();
 
 	lockdep_assert_held(&mapping->invalidate_lock);
@@ -512,7 +502,7 @@ void page_cache_ra_order(struct readahead_control *ractl,
 
 	ra->order = new_order;
 
-	/* See comment in page_cache_ra_unbounded() */
+	/* Allocating with locked folios */
 	nofs = memalloc_nofs_save();
 	filemap_invalidate_lock_shared(mapping);
 	/*
-- 
2.47.3


