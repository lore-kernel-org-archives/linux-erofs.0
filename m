Return-Path: <linux-erofs+bounces-4634-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A22E3CA5FA5
	for <linux-erofs@archiver.kernel.org>; Wed, 30 Sep 2026 01:19:45 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hvcf30Nyjz2y8p;
	Wed, 30 Sep 2026 11:19:39 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2607:f8b0:4864:20::1346"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1790731179;
	cv=none; b=VBlPkJ53XSvM5Hn387TbPjekQAcJSXvR3iI+hNYXzxJ4Pa0kr/zFHj4C3ss4BUVqxuVe+xLDLIEmqkO1yuop0j3i0hpd4wYlW1HitgobtR8Hi7JzUhYKDAvkFe1zeOXjbq0wflzPAM95VVF+RlYodqyMT9i+85mWeJxgAfOg6x3FyfjSNM4IDL2mBr4QdwKcHIXC5JJN4dT82couRBrIOiaLS7psYczPkBkz5fB0d1aHXumtQy5PlQN00PbNt9QhJerb0gd+04Z7/+GmJC0eCleG76FqhM6oKiBrpXSIAyhebSFgRVaVUJMJO0zJQMdbNLya+gRgFlh8Do/B0AYS5A==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1790731179; c=relaxed/relaxed;
	bh=VApuM5lufQKhv2Z8CNJsSepO+dLFr7rZjSeOJOWL1Og=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Ni+QXqeX1e2FU3fkPuJn7PBuEPddg+w1x2F8+YK87Z+AJi7RKKbccMJ/k5jp12cVYU0b8Vh66UWHAz4UnPt3jDOPFBmwMDt3XI8qZbb1+1ZxHHoXqI4AAV5bUWXhOVjraAP/WmNoPKP5Ub9CYirvZ1UXkza7RpyA6P/DspD9qPbHuwvVjzm22LWXVEB0MPnpisrJGpd1btCpINjwr+KDlcdeWuUufzKvW5hU0YhKBU4bjHtzFjzUmfGg1zY3wYeSNItCsR3muTuMSUdE3gP0VHL/Uc3y6cCk3SY19rrsA/wS6xsULaCeiSuC4MpvfC+xxlcZ0HFq10Y4dufhjB87sA==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=reject dis=none) header.from=google.com; dkim=pass (2048-bit key; unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=JdvOIUJm; dkim-atps=neutral; spf=pass (client-ip=2607:f8b0:4864:20::1346; helo=mail-dy1-x1346.google.com; envelope-from=3p2o8ag4kc7wuctvjcmmwmtgvkiqqing.eqonkpwz-gtqhunkuvu.q1ncdu.qti@flex--sarthakkukreti.bounces.google.com; receiver=lists.ozlabs.org) smtp.mailfrom=flex--sarthakkukreti.bounces.google.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=JdvOIUJm;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=flex--sarthakkukreti.bounces.google.com (client-ip=2607:f8b0:4864:20::1346; helo=mail-dy1-x1346.google.com; envelope-from=3p2o8ag4kc7wuctvjcmmwmtgvkiqqing.eqonkpwz-gtqhunkuvu.q1ncdu.qti@flex--sarthakkukreti.bounces.google.com; receiver=lists.ozlabs.org)
Received: from mail-dy1-x1346.google.com (mail-dy1-x1346.google.com [IPv6:2607:f8b0:4864:20::1346])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hvcf21jNDz2ydN
	for <linux-erofs@lists.ozlabs.org>; Wed, 30 Sep 2026 11:19:38 +1000 (AEST)
Received: by mail-dy1-x1346.google.com with SMTP id 5a478bee46e88-34bbf2e3c5cso3491769eec.0
        for <linux-erofs@lists.ozlabs.org>; Tue, 29 Sep 2026 18:19:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790731175; x=1791335975; darn=lists.ozlabs.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=VApuM5lufQKhv2Z8CNJsSepO+dLFr7rZjSeOJOWL1Og=;
        b=JdvOIUJmlrvuVzQ1JdBhQKpL+68YORxij1oR4GhAWoYz9V65PPTcRJ7t5a8lem+Sif
         4OXPV4K1zck73TTXMJ9WJrmLLEJeQ5NIrsT0LB/HYeCDnNAA+hE59kFd+5Oe5O8jwlv0
         6my0VwwSWB/Kdp9erHC/5XDX7GyzqVqznyEKsXl0sSaToXNGyvG4SIsmdf1MKjEq1xdk
         KyrermoJr9p17mLi0ixRk9kYfZfkd9hOxwdu96d5WTSJNSchwmgdDvHVI3O0ZTpIfydk
         kfVZCDeizM1M4IjjL3ibPtglj591iKfUvw4ETxya7SC/puK3IgqMxWcOqEDfyAlAXEWR
         /R3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790731175; x=1791335975;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=VApuM5lufQKhv2Z8CNJsSepO+dLFr7rZjSeOJOWL1Og=;
        b=uBIIWmBRlZRFvTPYY5JJb16F1BpQI1uMI5MHbytGQIIk9xRJTxu7gHq6Ukp/o/2oC8
         Xqm6DReJOdUVshM7d8p23gMeNGMT8UowXDJYGOsEHujRhX3YHbRWxmRscTbnyZ7IEZuK
         AMLEeVANh+u7pPYp5nM32yJHN3D0YkmdKn8H8s2SdGu/ZWi079jrWcjHbusWRSf3Qkny
         VsFXhSgOLmiraaH+9WcIxCtX8hw3SZL94TN1XUAzbPPM6o2f9rJhP6rcY7GV6GjQOO9P
         BZjpYcNqu8nOB1fGKQLHBIC7VNgXeItZmrVY2xuDhe/sK3f9S+onp4bS29/BnR6+WPrX
         XkVg==
X-Forwarded-Encrypted: i=1; AKwUvBx5CSOnP/s22oR6rS7gDD/W2yxHEzMfVhyNPQFYGIrakQWA4hQ7duDOLUL5vRWvfmqR1FEHY2UObD8jjA==@lists.ozlabs.org
X-Gm-Message-State: AFq9FYKCjyBIL3AoFLDviehTh2k/DadSi76mgdsADG98GbnwDzEvGTLO
	0rQj8xYfsZqndRYxBXJxVKzx2jK2FJHmwQIMzJ9FUPbT+Bcl6T6KWEmpdT6cmmVFi2hCDWJYyeC
	R4hKYPGeBlGjgC27hYvcZbMx15oROzTBgbDu8qA==
X-Received: from dyblf37.prod.google.com ([2002:a05:7301:a25:b0:33e:6278:c3de])
 (user=sarthakkukreti job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:7300:aa6:b0:342:94b:aa28 with SMTP id 5a478bee46e88-34c64cb8e45mr1319141eec.27.1790731175148;
 Tue, 29 Sep 2026 18:19:35 -0700 (PDT)
Date: Tue, 29 Sep 2026 18:19:20 -0700
In-Reply-To: <20260930011921.1188150-1-sarthakkukreti@google.com>
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
Mime-Version: 1.0
References: <20260930011921.1188150-1-sarthakkukreti@google.com>
X-Mailer: git-send-email 2.56.0.rc1.315.gc6ed9934b7-goog
Message-ID: <20260930011921.1188150-3-sarthakkukreti@google.com>
Subject: [PATCH 2/3] erofs: bypass managed_pslots xarray when compressed cache
 and dedupe are disabled
From: Sarthak Kukreti <sarthakkukreti@google.com>
To: Gao Xiang <xiang@kernel.org>, Chao Yu <chao@kernel.org>
Cc: Sandeep Dhavale <dhavale@google.com>, linux-erofs@lists.ozlabs.org, 
	linux-kernel@vger.kernel.org, Sarthak Kukreti <sarthakkukreti@google.com>
Content-Type: text/plain; charset="UTF-8"

When EROFS is mounted with cache_strategy=disabled and without global
compressed data deduplication (!erofs_sb_has_dedupe(sbi)), every
pcluster still:
1. Performs an RCU xa_load(&sbi->managed_pslots, map->m_pa) lookup in
   z_erofs_pcluster_begin().
2. Acquires the superblock-wide xa_lock(&sbi->managed_pslots) spinlock
   to insert the pcluster via __xa_cmpxchg() in
   z_erofs_register_pcluster().
3. Scans all pcluster pages in z_erofs_bind_cache() calling
   filemap_get_folio() on an empty MNGD_MAPPING.
4. Acquires xa_trylock(&sbi->managed_pslots) on completion in
   z_erofs_put_pcluster() to __xa_erase() the pcluster and defer freeing
   via call_rcu().

Under multi-threaded random read workloads with cache_strategy=disabled,
the superblock-wide managed_pslots XArray spinlock and RCU callback
queue become a contention bottleneck despite no managed cache folios or
shared pclusters ever being retained.

Record whether a pcluster is unregistered (pcl->anon, fitting in existing
struct padding alongside pcl->from_meta) at allocation time when
cache_strategy <= EROFS_ZIP_CACHE_DISABLED and !erofs_sb_has_dedupe(sbi).
Skip managed_pslots lookup, insertion, and cache binding for anonymous
pclusters, and free them directly via z_erofs_free_pcluster() upon
decompression completion just like inline metadata pclusters. Recording
pcl->anon per pcluster also avoids races if sbi->opt.cache_strategy is
changed via remount while pclusters are in flight.

Signed-off-by: Sarthak Kukreti <sarthakkukreti@google.com>
---
 fs/erofs/zdata.c | 19 ++++++++++++++-----
 1 file changed, 14 insertions(+), 5 deletions(-)

diff --git a/fs/erofs/zdata.c b/fs/erofs/zdata.c
index 0517caf61959..cd0411695a02 100644
--- a/fs/erofs/zdata.c
+++ b/fs/erofs/zdata.c
@@ -77,6 +77,9 @@ struct z_erofs_pcluster {
 	/* I: whether compressed data is in-lined or not */
 	bool from_meta;
 
+	/* I: whether pcluster is not registered in managed_pslots */
+	bool anon;
+
 	/* L: whether partial decompression or not */
 	bool partial;
 
@@ -775,6 +778,9 @@ static int z_erofs_register_pcluster(struct z_erofs_frontend *fe)
 	pcl->pageofs_in = pageofs_in;
 	pcl->pageofs_out = map->m_la & ~PAGE_MASK;
 	pcl->from_meta = map->m_flags & EROFS_MAP_META;
+	pcl->anon = pcl->from_meta ||
+		(READ_ONCE(sbi->opt.cache_strategy) <= EROFS_ZIP_CACHE_DISABLED &&
+		 !erofs_sb_has_dedupe(sbi));
 	fe->mode = Z_EROFS_PCLUSTER_FOLLOWED;
 
 	/*
@@ -784,7 +790,7 @@ static int z_erofs_register_pcluster(struct z_erofs_frontend *fe)
 	mutex_init(&pcl->lock);
 	DBG_BUGON(!mutex_trylock(&pcl->lock));
 
-	if (!pcl->from_meta) {
+	if (!pcl->anon) {
 		while (1) {
 			xa_lock(&sbi->managed_pslots);
 			pre = __xa_cmpxchg(&sbi->managed_pslots, pcl->pos,
@@ -819,6 +825,7 @@ static int z_erofs_pcluster_begin(struct z_erofs_frontend *fe)
 {
 	struct erofs_map_blocks *map = &fe->map;
 	struct super_block *sb = fe->inode->i_sb;
+	struct erofs_sb_info *sbi = EROFS_SB(sb);
 	struct z_erofs_pcluster *pcl = NULL;
 	void *ptr = NULL;
 	bool needretry;
@@ -840,10 +847,11 @@ static int z_erofs_pcluster_begin(struct z_erofs_frontend *fe)
 			return PTR_ERR(ptr);
 		}
 		ptr = map->buf.page;
-	} else {
+	} else if (READ_ONCE(sbi->opt.cache_strategy) > EROFS_ZIP_CACHE_DISABLED ||
+		   erofs_sb_has_dedupe(sbi)) {
 		do {
 			rcu_read_lock();
-			pcl = xa_load(&EROFS_SB(sb)->managed_pslots, map->m_pa);
+			pcl = xa_load(&sbi->managed_pslots, map->m_pa);
 			needretry = pcl && !z_erofs_get_pcluster(pcl);
 			rcu_read_unlock();
 		} while (needretry);
@@ -875,7 +883,8 @@ static int z_erofs_pcluster_begin(struct z_erofs_frontend *fe)
 				Z_EROFS_INLINE_BVECS, fe->pcl->vcnt);
 	if (!fe->pcl->from_meta) {
 		/* bind cache first when cached decompression is preferred */
-		z_erofs_bind_cache(fe);
+		if (!fe->pcl->anon)
+			z_erofs_bind_cache(fe);
 	} else {
 		folio_get(page_folio((struct page *)ptr));
 		WRITE_ONCE(fe->pcl->compressed_bvecs[0].page, ptr);
@@ -1383,7 +1392,7 @@ static int z_erofs_decompress_pcluster(struct z_erofs_backend *be, bool eio)
 	WRITE_ONCE(pcl->next, NULL);
 	mutex_unlock(&pcl->lock);
 
-	if (pcl->from_meta)
+	if (pcl->anon)
 		z_erofs_free_pcluster(pcl);
 	else
 		z_erofs_put_pcluster(sbi, pcl, try_free);
-- 
2.56.0.rc1.315.gc6ed9934b7-goog


