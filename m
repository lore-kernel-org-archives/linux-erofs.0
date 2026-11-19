Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6171606A32C
	for <linux-erofs@archiver.kernel.org>; Thu, 19 Nov 2026 03:53:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=rNU6CgTV
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4jVPgx2SL5z2y2T;
	Thu, 19 Nov 2026 14:53:01 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2607:f8b0:4864:20::132a"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1795060381;
	cv=none; b=NqXfn2K1FiGbDmY+kpLpENoWfhNKnyGRzb6lbnIz/cKbFvByRGqn5Il74/2TuFAfph/bYTb3yMCzSaooHHUs/osrRi8yn/l4xb0KDg2WYwBQOKFMxsF7/qZQanpDR9maiVDcsAslQUZcBsYc6r5oluXbrvwP/AOxcG0MRdN3jH67osOjc/Gx9wnhfrYr3Ngnv/27xYlLVI3ib42DBs55g3xPkLf1AWchlTyXgNTS5uGXDDgZ+lASBNjZHhiGl8A1kQbv0rYn1HGvENAtGF37e99447ooQndkf5P22QkKq03ysdyIjq5I0dprAl6P7wNH5AEb1BCkJwwHemUwkvxubg==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1795060381; c=relaxed/relaxed;
	bh=XSIy9FLQysYTgaYYrX+1jyfQu2/aKcX5jVQ/CvHepYI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=kRkCVpzGNihrP65oH6uZA7XnV0j8hz5yCTMKNQsMezR0aY6uId0oNQN+Qiu/EDhcS9Xnjq1HUnx/BsBbhcMss+pnFT+qvy2fWH6i5YeU3GK8JjkKLKnEOZcPjPVbxZPEKJTO7QMLLncFOO/eWl65y+S7Vne3mA5ihR8CbSYjp4oGu9hvcBbK0mxpDLGqD0eTDnIhm+78/Jp97RdsSR/OfB4qIIHsOYxpJLd+KjLXWdBD5lpA2AFh3Ho6fMJUWz0AnzdT3rwt1Sgb4+RQC0T6lsYMzAVhMn9uq037Aaj1/mYnTBByQDQoKNjN8J3oqR38LuLVurd/genscaoOK2z2eQ==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=gmail.com; dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=rNU6CgTV; dkim-atps=neutral; spf=pass (client-ip=2607:f8b0:4864:20::132a; helo=mail-dy1-x132a.google.com; envelope-from=qwjhust@gmail.com; receiver=lists.ozlabs.org) smtp.mailfrom=gmail.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=rNU6CgTV;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=gmail.com (client-ip=2607:f8b0:4864:20::132a; helo=mail-dy1-x132a.google.com; envelope-from=qwjhust@gmail.com; receiver=lists.ozlabs.org)
Received: from mail-dy1-x132a.google.com (mail-dy1-x132a.google.com [IPv6:2607:f8b0:4864:20::132a])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4jVPgw3W0fz2xlP
	for <linux-erofs@lists.ozlabs.org>; Thu, 19 Nov 2026 14:52:59 +1100 (AEDT)
Received: by mail-dy1-x132a.google.com with SMTP id 5a478bee46e88-381f65e4e4bso2823305eec.0
        for <linux-erofs@lists.ozlabs.org>; Wed, 18 Nov 2026 19:52:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795060377; x=1795665177; darn=lists.ozlabs.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=XSIy9FLQysYTgaYYrX+1jyfQu2/aKcX5jVQ/CvHepYI=;
        b=rNU6CgTVsx6+dbDX42GsTrPV3xNmRUo4uGhlKGYHy8vccFXstP3jT/Z94YiPIx/Opr
         xM9QUO5sBMElOe4zD98jnoQIAXUbQr6sfsjsJamihlXjPvLgwIhwCcQB3kEOh28lgJ/f
         oODXk4hdA7tBqg8TBZtVIWcPwgDMThcmxfsUk7HIgmhjxvIEPVPpX4pUt909F21DDFy2
         gI5raxcBnFjWCd7OaQp3CfhV2L3mzFv+c7Dbud179euN8ncs573IrHQmKUvM3Pr5t4+5
         ZEf3YDc5SXiH8s3CI3DUfaNUWNlrsElBiFPZqZ97XLjMUArMkAVInqckqXPezrkzc6xs
         z+Kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795060377; x=1795665177;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=XSIy9FLQysYTgaYYrX+1jyfQu2/aKcX5jVQ/CvHepYI=;
        b=UGTocdIEw1hiYn8F5IAHNv7NYYGqrYFVFaH2BFobgyHOVjw8mTBmqi5FNQUrhvRtcO
         M70mHc9TFSAZ979koDgoJ+1thZJHTP8cHxOLRmF1xVgdx2zAAOl8pqh/9P8ceLxYCOHH
         rYTjiOMesV79M4phWzEaLZS2PBiWffTIBO8PkznmszjR4+gLcuUuMiGgMjM8juogc8W3
         mmqQGUJGlBnTbF6W9LIpOXawS/V/XwB8M4htBEeGOgKlrkIrmIyC11FL3JAKCtEO2mxb
         YB3h30T70xEeFWAGYo8j0yQ7GAgCxJEW/kjaYr6bjbRJJTTgWQe1Qzsc07VXqKJdVz81
         hefw==
X-Gm-Message-State: APuU4Z9We1sZy2AeESrrHCL9TuEbgVm+tQOxBZvPx6eYDOmadivp6S0Q
	2OKvhIE+DwWrSFmsb7WcpEbkrho3vbZOBOPSUkatTx9uhIck1em4jFcd
X-Gm-Gg: AZFdTZdRIOkCNB5asB4GtM7xtQ3/z/rbxx4BF3LWYsIjO7G4ROi5kOaGV0rT9gD5bx9
	r9ZivzdBgtDK3Bip/BreUrRzSxGnwcC7m3gwT3xkgT+h47/5eDltfg+2+zpQjkYi6Dl4k1BinzD
	L92GTcwPV42w0uSj2WMlHJzZvF9DPp3sD/CIo36Zb3vlUFD+E27GqFdbHcxK7JaOUjCSRYQB/+C
	tLy9VuJe4QmCtTTtDSAaB8853fqN3/xADXGTgnklhQ4HN9W2nps+VHHsPIwLUGpxXE/pYWhAWB6
	HAWrqpiE6rmwhDzBDVSQXnp7SgnAemepu8Mg+ZPpV8NvptiEf6I+0bB5yMUYmNLyOvf3OjsUtt4
	VR/qpLTct8Z6VrQxmGkNSv4YVA0UTzDE1h2MH3ZDlRpOM38gMcGjF6B6GdR5TNG1G4eV4nLOze0
	yqlGejjHd63hZtpCosjxgslCCy2m6qU7804bJQtaVXpedyYOiTW8IcqVrxiQN/r68ceTY5AyxhN
	QFCh+6GHaY7GnQ6GT2nDK482hNW/Kdug2A7rANGsAKrVoETX+DAnFvPdFmFUPqxc2IzDS1omwAn
	ukBr/C0Cb1tcSEoB8mKl3nVbJ8s6M+ktIZrMa5xDmYUJy1sub0lyK5M/jwemdEY=
X-Received: by 2002:a05:7301:6184:20b0:36c:a44c:1763 with SMTP id 5a478bee46e88-38281813f4emr4287341eec.32.1795060377432;
        Wed, 18 Nov 2026 19:52:57 -0800 (PST)
Received: from qiwenjie-ThinkCentre-M760t.mioffice.cn ([43.224.245.241])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-382a6800338sm13049206eec.11.2026.11.18.19.52.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Nov 2026 19:52:56 -0800 (PST)
From: Wenjie Qi <qwjhust@gmail.com>
To: xiang@kernel.org,
	chao@kernel.org
Cc: linux-erofs@lists.ozlabs.org,
	linux-fsdevel@vger.kernel.org,
	shengyong1@xiaomi.com,
	yangyongpeng@xiaomi.com,
	qiwenjie@xiaomi.com,
	qwjhust@gmail.com
Subject: [PATCH] erofs: enable buffered RWF_DONTCACHE reads
Date: Thu, 19 Nov 2026 11:52:50 +0800
Message-ID: <b168501806b41e3f0be15efec4b54b371d8dd4e1.1795059802.git.qiwenjie@xiaomi.com>
X-Mailer: git-send-email 2.43.0
X-Mailing-List: linux-erofs@lists.ozlabs.org
List-Id: <linux-erofs.lists.ozlabs.org>
List-Help: <mailto:linux-erofs+help@lists.ozlabs.org>
List-Owner: <mailto:linux-erofs+owner@lists.ozlabs.org>
List-Post: <mailto:linux-erofs@lists.ozlabs.org>
List-Subscribe: <mailto:linux-erofs+subscribe@lists.ozlabs.org>,
  <mailto:linux-erofs+subscribe-digest@lists.ozlabs.org>,
  <mailto:linux-erofs+subscribe-nomail@lists.ozlabs.org>
Precedence: list
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Wenjie Qi <qiwenjie@xiaomi.com>

EROFS uses filemap_read() for buffered reads, including the inode-sharing
path, which preserves request flags when cloning the kiocb.

Advertise FOP_DONTCACHE in both file operation tables so preadv2() callers
can request that newly instantiated file-cache folios be dropped after
consumption. This is useful for one-pass reads that need not retain data
in the page cache.

For compressed reads, retain trailing readmore and propagate dropbehind
to the single-folio neighbor lookup. Readahead expansion already marks
new folios through readahead_control. Suppress prefix readmore so it
cannot refill pages already consumed and evicted. Ordinary readmore is
unchanged.

Tested sequential reads of 1-GiB files with 1-MiB requests on NVMe-backed
LZ4 and Zstd EROFS images in x86-64 QEMU/KVM with two vCPUs and 2 GiB RAM.
Each reader ran with memory.max=255852544 (244 MiB) and
memory.swap.max=0. Normal and dontcache ran in ten paired rounds per
layout, alternating their order and using a fresh guest for each run.

Results are arithmetic means of ten runs. Memory values average the
run-level time-weighted memory.current means. Percentage changes are
relative to normal reads:

                    MiB/s                  Mean memory, MiB
 Layout   normal/dontcache  change    normal/dontcache  change
 LZ4      2513.57/6350.61  +152.65%      169.53/17.39   -89.74%
 Zstd     2535.57/4066.49   +60.38%      179.01/18.17   -89.85%

In this test, dontcache reduced average cgroup memory by about 90%,
left no consumed file pages resident and recorded no memcg reclaim
scans or steals. Both layouts were faster in all ten pairs. This
offers a smaller cache footprint for one-pass reads on memory-constrained
systems.

Signed-off-by: Wenjie Qi <qiwenjie@xiaomi.com>
Signed-off-by: Sheng Yong <shengyong1@xiaomi.com>
Reviewed-by: Yongpeng Yang <yangyongpeng@xiaomi.com>
---
 fs/erofs/data.c     |  1 +
 fs/erofs/internal.h |  5 +++--
 fs/erofs/ishare.c   |  1 +
 fs/erofs/zdata.c    | 10 +++++++++-
 4 files changed, 14 insertions(+), 3 deletions(-)

diff --git a/fs/erofs/data.c b/fs/erofs/data.c
index 968303afd..db0bac732 100644
--- a/fs/erofs/data.c
+++ b/fs/erofs/data.c
@@ -537,4 +537,5 @@ const struct file_operations erofs_file_fops = {
 	.get_unmapped_area = thp_get_unmapped_area,
 	.splice_read	= filemap_splice_read,
 	.setlease	= generic_setlease,
+	.fop_flags	= FOP_DONTCACHE,
 };
diff --git a/fs/erofs/internal.h b/fs/erofs/internal.h
index 8363c0c05..cbe58576b 100644
--- a/fs/erofs/internal.h
+++ b/fs/erofs/internal.h
@@ -321,10 +321,11 @@ static inline unsigned int erofs_inode_datalayout(unsigned int ifmt)
 
 /* reclaiming is never triggered when allocating new folios. */
 static inline struct folio *erofs_grab_folio_nowait(struct address_space *as,
-						    pgoff_t index)
+						    pgoff_t index, bool dropbehind)
 {
 	return __filemap_get_folio(as, index,
-			FGP_LOCK|FGP_CREAT|FGP_NOFS|FGP_NOWAIT,
+			FGP_LOCK | FGP_CREAT | FGP_NOFS | FGP_NOWAIT |
+			(dropbehind ? FGP_DONTCACHE : 0),
 			readahead_gfp_mask(as) & ~__GFP_RECLAIM);
 }
 
diff --git a/fs/erofs/ishare.c b/fs/erofs/ishare.c
index ea146fa8a..585bf4614 100644
--- a/fs/erofs/ishare.c
+++ b/fs/erofs/ishare.c
@@ -190,6 +190,7 @@ const struct file_operations erofs_ishare_fops = {
 	.get_unmapped_area = thp_get_unmapped_area,
 	.splice_read	= erofs_ishare_splice_read,
 	.fadvise	= erofs_ishare_fadvise,
+	.fop_flags	= FOP_DONTCACHE,
 };
 
 struct inode *erofs_real_inode(struct inode *inode, bool *need_iput)
diff --git a/fs/erofs/zdata.c b/fs/erofs/zdata.c
index e981e371d..19e6051f5 100644
--- a/fs/erofs/zdata.c
+++ b/fs/erofs/zdata.c
@@ -512,6 +512,7 @@ struct z_erofs_frontend {
 	struct page *candidate_bvpage;
 	struct z_erofs_pcluster *pcl, *head;
 	enum z_erofs_pclustermode mode;
+	bool dropbehind;
 
 	erofs_off_t headoffset;
 
@@ -1807,6 +1808,10 @@ static void z_erofs_pcluster_readmore(struct z_erofs_frontend *f,
 	erofs_off_t cur, end, headoffset = f->headoffset;
 	int err;
 
+	/* Avoid repopulating a prefix that dropbehind has already evicted. */
+	if (f->dropbehind && !backmost)
+		return;
+
 	if (backmost) {
 		if (rac)
 			end = headoffset + readahead_length(rac) - 1;
@@ -1836,7 +1841,8 @@ static void z_erofs_pcluster_readmore(struct z_erofs_frontend *f,
 		pgoff_t index = cur >> PAGE_SHIFT;
 		struct folio *folio;
 
-		folio = erofs_grab_folio_nowait(f->sharedinode->i_mapping, index);
+		folio = erofs_grab_folio_nowait(f->sharedinode->i_mapping, index,
+						f->dropbehind);
 		if (!IS_ERR_OR_NULL(folio)) {
 			if (folio_test_uptodate(folio))
 				folio_unlock(folio);
@@ -1860,6 +1866,7 @@ static int z_erofs_read_folio(struct file *file, struct folio *folio)
 	int err;
 
 	trace_erofs_read_folio(realinode, folio, false);
+	f.dropbehind = folio_test_dropbehind(folio);
 	z_erofs_pcluster_readmore(&f, NULL, true);
 	err = z_erofs_scan_folio(&f, folio, false);
 	z_erofs_pcluster_readmore(&f, NULL, false);
@@ -1890,6 +1897,7 @@ static void z_erofs_readahead(struct readahead_control *rac)
 	int err;
 
 	trace_erofs_readahead(realinode, readahead_index(rac), nrpages, false);
+	f.dropbehind = rac->dropbehind;
 	z_erofs_pcluster_readmore(&f, rac, true);
 
 	/* traverse from last to first for best metadata I/O performance */

base-commit: 6628e7d4c6b25c8d18f1345e3a20d21829aae7e4
-- 
2.43.0


