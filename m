Return-Path: <linux-erofs+bounces-4632-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0A95DCA5FA5
	for <linux-erofs@archiver.kernel.org>; Wed, 30 Sep 2026 01:19:41 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hvcf22cL5z2ylm;
	Wed, 30 Sep 2026 11:19:38 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2607:f8b0:4864:20::1346"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1790731178;
	cv=none; b=kpBetkFGDTdpwt/PWSLfF0Q5ZnpGOMRGoFoV9H78ElGnKMmqCa8hd9n51upngiItUi6lAzlI8Qe7fZXYEXWJxcqEesdiPI/k7W1VkHC76nXAEoLsiYM8ca+hfs9ueIEKUWRsNSrST4NctQLt0zppRpiknvNaQNHJmsPZXZQg/XVXHclY77guZavt4Hq+Ml50nB/74/8lpL0lvG+jw1lwXwi3GHDUh6mDK+Goi+KVmkN/B4hFoVIUkjFSl8sQq0yHQtq61KPk5GwYjDDhfD0PZRATY92eHRefGk4y4iIAymzdJg4upoZgsritSTJ4cUTBYuYoZKoeT8K969eEh0Zxug==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1790731178; c=relaxed/relaxed;
	bh=dHwk2OQQ4Zl9lDHyUY4iPD2cM/pNo2Pz0tvm4qnKYmM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=d28qifLs99DfFsejSYQ5QMlD7zHamqnTtrjpSwqH7sOdYLXUT/UyCpUUCJhhuCeU5rb+tKSSExWEGQjyTmwtTeaQQzX+K73CBPPmF9onCNjmAw40TQ8uqHKuYEjQrYz6aDoM8raZ5aPe8Nb1DVP8gTfiabY0XkfHFofZvkwSS4ZQB9wthBXPo2LAcljm2c9cS3L+1nqmOW9OmWpECRoneDm0IMY81DV8hxA3lQlImH1GddhIbd4EdMU7hMyfvKky+ia+RSiTsD0y1ELlbSb5p1XHPskA0FrnKvfRrnqIwJe4bORMbi4u4KfkDOcauq4tGMfvufE6cfy43MqqJtrl4Q==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=reject dis=none) header.from=google.com; dkim=pass (2048-bit key; unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=gZM71AdU; dkim-atps=neutral; spf=pass (client-ip=2607:f8b0:4864:20::1346; helo=mail-dy1-x1346.google.com; envelope-from=3pgo8ag4kc7krzqsgzjjtjqdshfnnfkd.bnlkhmtw-dqnerkhrsr.nykzar.nqf@flex--sarthakkukreti.bounces.google.com; receiver=lists.ozlabs.org) smtp.mailfrom=flex--sarthakkukreti.bounces.google.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=gZM71AdU;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=flex--sarthakkukreti.bounces.google.com (client-ip=2607:f8b0:4864:20::1346; helo=mail-dy1-x1346.google.com; envelope-from=3pgo8ag4kc7krzqsgzjjtjqdshfnnfkd.bnlkhmtw-dqnerkhrsr.nykzar.nqf@flex--sarthakkukreti.bounces.google.com; receiver=lists.ozlabs.org)
Received: from mail-dy1-x1346.google.com (mail-dy1-x1346.google.com [IPv6:2607:f8b0:4864:20::1346])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hvcf00YLxz2yYd
	for <linux-erofs@lists.ozlabs.org>; Wed, 30 Sep 2026 11:19:35 +1000 (AEST)
Received: by mail-dy1-x1346.google.com with SMTP id 5a478bee46e88-3282d5302ffso2492531eec.1
        for <linux-erofs@lists.ozlabs.org>; Tue, 29 Sep 2026 18:19:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790731173; x=1791335973; darn=lists.ozlabs.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=dHwk2OQQ4Zl9lDHyUY4iPD2cM/pNo2Pz0tvm4qnKYmM=;
        b=gZM71AdUHVtXQrWkwpJTxF5z9AfwB/2F4BcCUUzYTh4+nDXhUCULqFsgy7mpGfV3CN
         +Y8YXIFv5a3BYXOparPGORru5sjd5MZqY2OWsnxpkZKuSj0xKTl+M3Lm0DXgs6njRjKk
         OxWh2yZhNuhHkME3eaEvES0cFqCLZ20LgAP+1L1g+wj6uDb3oko1rTKfgV6QBf5MO32H
         nGEMSHGzHIos/iqtsZS4z2kNOXadbJvXkYz+Q1DfA2HxNDzllVxJ7g4Mdk1P0lLDEb7K
         R9DBWA68X+IIhloJ/7rkh0kOySbBKeJdzaLfI7Qb4NFhhRBN9eAEdaVys9pcWDC0ixEf
         KDPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790731173; x=1791335973;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=dHwk2OQQ4Zl9lDHyUY4iPD2cM/pNo2Pz0tvm4qnKYmM=;
        b=g3uO90i0DfhqkO100DVqpKJYiz0NhqRZaf9CoRASlFzrr/n8FpR9AS4wQufJ5ffKFG
         rz0JdpEgwNTpOs7u6AaYu9NV2tPXEP8RSL54NvG42GvuW+b6XvQ+idaPJpT0+4AEevhv
         jrv3RVGaTUljcL7MmihDXIZOpdpHslDmiL3/IiOip4VsfStXs99j73qbQhI4iuTw4HJP
         WJ7SGJGJAlYRqzNJIJTXhIiyLvycU5MWYsqJo9n5RMlAUzr3Gt/V9j56BmShKTnmPJX6
         CwvssA6FdJU0OJHL5eMCl0S6TJ2jCX/NaxpJjQriColvzZmRO0YF51mJTulFkrnHfJGV
         +mwQ==
X-Forwarded-Encrypted: i=1; AKwUvByArVpOdOKKE8EKkJ85oeSdcUYFmBaOXiYv8sK9OcUb4moDpvkzFaF3x3cab+pMDwyo0r2+bKZTKzW/oA==@lists.ozlabs.org
X-Gm-Message-State: AFuF++lhoW1IAiuBhFYwq+faMaht6RDIrioxxfiYKaApl1vWa2quiYgd
	tmz+P13K23znJzKpO0m0WBat5794wUEgsA1n9+/WQ+jOGTbmmNztBDSpHR3qTJR2JwIURduj3EI
	ZokYctd3iy7x2lpfJcYSLFx4VWdLX0KvJDMvLLA==
X-Received: from dybhe38.prod.google.com ([2002:a05:7300:e1a6:b0:34c:489e:103b])
 (user=sarthakkukreti job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:693c:88c3:20b0:33e:5e42:e0f9 with SMTP id 5a478bee46e88-34cdc2ca4f9mr14476eec.6.1790731172919;
 Tue, 29 Sep 2026 18:19:32 -0700 (PDT)
Date: Tue, 29 Sep 2026 18:19:19 -0700
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
Message-ID: <20260930011921.1188150-2-sarthakkukreti@google.com>
Subject: [PATCH 1/3] erofs: avoid redundant page copy for aligned
 shifted/plain pclusters
From: Sarthak Kukreti <sarthakkukreti@google.com>
To: Gao Xiang <xiang@kernel.org>, Chao Yu <chao@kernel.org>
Cc: Sandeep Dhavale <dhavale@google.com>, linux-erofs@lists.ozlabs.org, 
	linux-kernel@vger.kernel.org, Sarthak Kukreti <sarthakkukreti@google.com>
Content-Type: text/plain; charset="UTF-8"

When a Z_EROFS_COMPRESSION_SHIFTED pcluster is read in-place into its
target page cache folio(s) with page-aligned input and output offsets
(pageofs_in == 0 && pageofs_out == 0), z_erofs_transform_plain() still
maps each page via kmap_local_page() and calls memmove(kin + po,
kin + rq->pageofs_in + pi, cnt) where dst == src. On x86_64,
arch/x86/lib/memmove_64.S does not early-exit when dst == src, executing
rep movsb over the entire 4 KiB page and dirtying all 64 cachelines.

Furthermore, z_erofs_attach_page() restricts uncompressed pclusters to
a single inplace I/O page (fe->icur <= 1), forcing multi-page aligned
Z_EROFS_COMPRESSION_SHIFTED extents to allocate temporary shortlived
pages and copy every page beyond the first via memcpy_to_page().

1. Allow multi-page inplace I/O in z_erofs_attach_page() when the
   pcluster uses Z_EROFS_COMPRESSION_SHIFTED with page-aligned input
   and output offsets (!pcl->pageofs_in && !pcl->pageofs_out) and full
   page bvecs.
2. In z_erofs_transform_plain(), return immediately when a page-aligned
   Z_EROFS_COMPRESSION_SHIFTED request has identical input and output
   page pointers (rq->in[ni] == rq->out[ni]), and skip memmove() when
   po == rq->pageofs_in + pi.

Signed-off-by: Sarthak Kukreti <sarthakkukreti@google.com>
---
 fs/erofs/decompressor.c | 24 ++++++++++++++++++++----
 fs/erofs/zdata.c        | 14 ++++++++++++--
 2 files changed, 32 insertions(+), 6 deletions(-)

diff --git a/fs/erofs/decompressor.c b/fs/erofs/decompressor.c
index d387b27c4ee2..0f6517f329ee 100644
--- a/fs/erofs/decompressor.c
+++ b/fs/erofs/decompressor.c
@@ -283,6 +283,21 @@ static const char *z_erofs_transform_plain(struct z_erofs_decompress_req *rq,
 		rq->outputsize -= cur;
 	}
 
+	if (rq->alg == Z_EROFS_COMPRESSION_SHIFTED && !rq->pageofs_in &&
+	    !rq->pageofs_out && nrpages_in == nrpages_out) {
+		bool same = true;
+
+		for (ni = 0; ni < nrpages_in; ++ni) {
+			if (!rq->in[ni] || rq->in[ni] != rq->out[ni]) {
+				same = false;
+				break;
+			}
+		}
+		if (same)
+			return NULL;
+		ni = 0;
+	}
+
 	for (; rq->outputsize; rq->pageofs_in = 0, cur += insz, ni++) {
 		insz = min(PAGE_SIZE - rq->pageofs_in, rq->outputsize);
 		rq->outputsize -= insz;
@@ -295,10 +310,11 @@ static const char *z_erofs_transform_plain(struct z_erofs_decompress_req *rq,
 			po = (rq->pageofs_out + cur + pi) & ~PAGE_MASK;
 			DBG_BUGON(no >= nrpages_out);
 			cnt = min(insz - pi, PAGE_SIZE - po);
-			if (rq->out[no] == rq->in[ni])
-				memmove(kin + po,
-					kin + rq->pageofs_in + pi, cnt);
-			else if (rq->out[no])
+			if (rq->out[no] == rq->in[ni]) {
+				if (po != rq->pageofs_in + pi)
+					memmove(kin + po,
+						kin + rq->pageofs_in + pi, cnt);
+			} else if (rq->out[no])
 				memcpy_to_page(rq->out[no], po,
 					       kin + rq->pageofs_in + pi, cnt);
 			pi += cnt;
diff --git a/fs/erofs/zdata.c b/fs/erofs/zdata.c
index 6b07e73ee2aa..0517caf61959 100644
--- a/fs/erofs/zdata.c
+++ b/fs/erofs/zdata.c
@@ -698,9 +698,19 @@ static int z_erofs_attach_page(struct z_erofs_frontend *fe,
 	int ret;
 
 	if (exclusive) {
-		/* Inplace I/O is limited to one page for uncompressed data */
+		/*
+		 * Allow multi-page inplace I/O for page-aligned SHIFTED
+		 * pclusters so that uncompressed multi-block extents read
+		 * directly into the target page cache folios without allocating
+		 * intermediate shortlived pages or copying in
+		 * z_erofs_transform_plain().
+		 */
 		if (pcl->algorithmformat < Z_EROFS_COMPRESSION_MAX ||
-		    fe->icur <= 1) {
+		    fe->icur <= 1 ||
+		    (pcl->algorithmformat == Z_EROFS_COMPRESSION_SHIFTED &&
+		     !pcl->pageofs_in && !pcl->pageofs_out &&
+		     !(bvec->offset & ~PAGE_MASK) &&
+		     bvec->end == PAGE_SIZE)) {
 			/* Try to prioritize inplace I/O here */
 			spin_lock(&pcl->lockref.lock);
 			while (fe->icur > 0) {
-- 
2.56.0.rc1.315.gc6ed9934b7-goog


