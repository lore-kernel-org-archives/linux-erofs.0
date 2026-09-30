Return-Path: <linux-erofs+bounces-4635-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DDDB6CA5FAD
	for <linux-erofs@archiver.kernel.org>; Wed, 30 Sep 2026 01:19:46 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hvcf46VGWz2ypW;
	Wed, 30 Sep 2026 11:19:40 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2607:f8b0:4864:20::1346"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1790731180;
	cv=none; b=B3UitIp2gF8hePkshMIuMQWV4nr5IyXI/2+9thjF4Hfx+mmU1z3vzANzRb56ojZlQnIkexlKEsBNLbQzaJkPYwgVNOrcnSVxWtr9zBvPd1F3Bbzk9PqrxLgEy4MccRC9EKYsWZq6Ed3MTbpaNoW3brusVmJpEf4F0YenuaFPVsxNqlciQ8EO3VrOi8hIn23V+8+13AQkalZ508eNfFvZGHc02rWJtCZ1epMWMgdpEEc8BFV1HnxEqKaYH3Xg+GsvO6ZuF2k6G4o4+Y4Et18pkh2MhARGK9OB9QAdU33NQem0n9xi0VC6cNCAcnACUqC9c072Fz8UeyKUgtBUlJfqQQ==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1790731180; c=relaxed/relaxed;
	bh=0wlYFbpFghnstlU+2b6sLYN8nNwY9HP02E2/+9cpOkI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=WiUkAzRoqLI8my3V92Ocw1mdpBc/CV7guRMdr8oEIdRiu3QAfwns4KUVrUJ+2SSlkP/T18ZT+yEb97zuC1dw46v95jCr3ZF9JL1Mj6JC5qrF+5pr9eHgz/YqZC/alABgJ40cQtIxkelQvtBipSxuezoNubf7Mc7aezMJ4q/7l1yXuy6Pzx+qmUNoNRc6oxIqEPLNC+0RRQvT5gyZxuS8SKMG2EPWNm01YZf/+DiB69ny/12mWX4KGmLTl3ddRP8tjpBdSmD5u4a9zXe1s4uE96ZNxxVW+w9cAZJe9Cqk9idyvjn0x4Iz+Y1bPDfMx0ViclQj6WG8nmaUJBZoFjsJcQ==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=reject dis=none) header.from=google.com; dkim=pass (2048-bit key; unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=J5KyUUlB; dkim-atps=neutral; spf=pass (client-ip=2607:f8b0:4864:20::1346; helo=mail-dy1-x1346.google.com; envelope-from=3qwo8ag4kc74wevxleooyovixmksskpi.gsqpmry1-ivsjwpmwxw.s3pefw.svk@flex--sarthakkukreti.bounces.google.com; receiver=lists.ozlabs.org) smtp.mailfrom=flex--sarthakkukreti.bounces.google.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=J5KyUUlB;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=flex--sarthakkukreti.bounces.google.com (client-ip=2607:f8b0:4864:20::1346; helo=mail-dy1-x1346.google.com; envelope-from=3qwo8ag4kc74wevxleooyovixmksskpi.gsqpmry1-ivsjwpmwxw.s3pefw.svk@flex--sarthakkukreti.bounces.google.com; receiver=lists.ozlabs.org)
Received: from mail-dy1-x1346.google.com (mail-dy1-x1346.google.com [IPv6:2607:f8b0:4864:20::1346])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hvcf40dKLz2ydN
	for <linux-erofs@lists.ozlabs.org>; Wed, 30 Sep 2026 11:19:40 +1000 (AEST)
Received: by mail-dy1-x1346.google.com with SMTP id 5a478bee46e88-34318e88ba2so3794407eec.1
        for <linux-erofs@lists.ozlabs.org>; Tue, 29 Sep 2026 18:19:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790731178; x=1791335978; darn=lists.ozlabs.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=0wlYFbpFghnstlU+2b6sLYN8nNwY9HP02E2/+9cpOkI=;
        b=J5KyUUlB4Hhm68nGot1l0NFG7E/bzU8tojf07zP4Ke/IQEmMqNJ/SjxgLmE5bKVMSv
         MbWVqFeBqYhcps1wFK/VMXGuz/hUS6dDb82W4EJWgzmfp6UQDl/UNKA5S31T8+wqc+Jm
         HdTPTg4QEVo9dP/LSFYla9V4oeNxosgqS6/gY0nWrX2Tt+qd9C4+0mpLnijia3hSz+PL
         g8ssftQN2PVaE3HzPgpbwhTJ19BoKK7GBx1SSTk6MiUVEE1+j1/nNQFEpyPaweMAzHND
         y1PPrwLVECdEDEeaUtmoRumEjwNQDo4t1YOO4kNfqSO1PQ1n8q2HyM6oFpLMErx6vvqj
         lktQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790731178; x=1791335978;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=0wlYFbpFghnstlU+2b6sLYN8nNwY9HP02E2/+9cpOkI=;
        b=jdVh5YSE+V7KM9Yx4QOappmYSkFlIAnywt3nKN1g0XhoDBGIxS/D8w3oPqrNR6LE0y
         MoCNJIrEbPpTcA+sovXUsIpRlEKkLS9g2vjk23RrbSF1HarRpVPWxIfZHbef7AFjOh4E
         rp4+rXCBbShrybHBGk+1MfZ40ZFUiR4IrX1KUNW9ImV3k6qGGhdwUpAzxRGHSjmqsgsA
         NkRNRX57DF80d5wpicm8rmq0NmzvBoUYmJSQKIX/kuc5wuu9uYWUZjYVu7MtWT2USdko
         /ve2MaptzPODM86rJ2lwh7ZoFUBpzZ04ioD/JeT6ngKusBwmBOV3FpT8waBFWpE10wwz
         F9Sw==
X-Forwarded-Encrypted: i=1; AKwUvBxLbRjmmIP2//BNbHVdP4F00iCuw50X3DnLJr5KabRimse35VBYbjETflwEjRRzDr/84oowmjN69DWy3Q==@lists.ozlabs.org
X-Gm-Message-State: AFuF++m/2Bf0CAKt7d8SfCjeSYcNtA1k8LJroj7hIYwIUVtV9WhbcUsN
	aHSMIPjxF/gY4cOKq/5+tQ5sijqPrMSM/9NSRmxtTnSUI4NAv3hzDh1PmbzGjgRQnXrexpFNO5i
	cdCC+asoh6TPAt44grsHeEaYpZv9lxXQViQG3GA==
X-Received: from dycnn9.prod.google.com ([2002:a05:7301:1409:b0:344:1693:c118])
 (user=sarthakkukreti job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:7301:1a02:b0:34b:ee3a:10af with SMTP id 5a478bee46e88-34cd91735admr43302eec.4.1790731177107;
 Tue, 29 Sep 2026 18:19:37 -0700 (PDT)
Date: Tue, 29 Sep 2026 18:19:21 -0700
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
Message-ID: <20260930011921.1188150-4-sarthakkukreti@google.com>
Subject: [PATCH 3/3] erofs: optimize 48-bit encoded extent lookup with O(1)
 hint, interpolation, and in-page search
From: Sarthak Kukreti <sarthakkukreti@google.com>
To: Gao Xiang <xiang@kernel.org>, Chao Yu <chao@kernel.org>
Cc: Sandeep Dhavale <dhavale@google.com>, linux-erofs@lists.ozlabs.org, 
	linux-kernel@vger.kernel.org, Sarthak Kukreti <sarthakkukreti@google.com>
Content-Type: text/plain; charset="UTF-8"

In z_erofs_map_blocks_ext(), 48-bit variable-length encoded extent
tables (recsz >= 16) currently perform a full O(log N) binary search
across [0, z_extents), invoking erofs_read_metabuf() on every iteration
even when multiple binary search probes land within the same 4 KiB
metadata page or when reading sequentially.

Optimize 48-bit variable-length extent lookup in three ways:
1. O(1) Sequential Continuation Hint: Cache the last resolved extent
   index (z_extent_hint) and its logical end offset (z_extent_hint_lend)
   in struct erofs_inode. Because extent i + 1 starts at hint_lend,
   check map->m_la == hint_lend on step 0 to probe hint + 1 directly
   on sequential reads with zero false positives on random reads.
2. Step-0 Linear Interpolation: On random reads where map->m_la !=
   hint_lend, estimate the initial probe index via linear interpolation
   div64_u64(map->m_la * (r - l), lend) so that step 0 lands on or
   adjacent to the target 4 KiB metadata page (~16 MiB logical coverage
   per 256-record metadata page at recsz = 16).
3. In-Page Binary Search: Once erofs_read_metabuf() maps a metadata
   block, narrow [l, r) across all extent records [blk_first, blk_last]
   residing in that same metadata block in memory before issuing another
   erofs_read_metabuf() call.

Signed-off-by: Sarthak Kukreti <sarthakkukreti@google.com>
---
 fs/erofs/internal.h |  2 +
 fs/erofs/zmap.c     | 94 +++++++++++++++++++++++++++++++++++----------
 2 files changed, 75 insertions(+), 21 deletions(-)

diff --git a/fs/erofs/internal.h b/fs/erofs/internal.h
index 12e3a5b80a5a..9bf1df974bcf 100644
--- a/fs/erofs/internal.h
+++ b/fs/erofs/internal.h
@@ -271,6 +271,8 @@ struct erofs_inode {
 			};
 			erofs_off_t    z_fragmentoff;
 			unsigned short z_idata_size;
+			u64            z_extent_hint;
+			erofs_off_t    z_extent_hint_lend;
 		};
 #endif	/* CONFIG_EROFS_FS_ZIP */
 	};
diff --git a/fs/erofs/zmap.c b/fs/erofs/zmap.c
index f8981fc74246..56cd9dd088b6 100644
--- a/fs/erofs/zmap.c
+++ b/fs/erofs/zmap.c
@@ -558,36 +558,86 @@ static int z_erofs_map_blocks_ext(struct inode *inode,
 		lend = min(lstart, lend);
 		lstart -= 1 << vi->z_lclusterbits;
 	} else {
+		unsigned int step = 0;
+		u64 hint = READ_ONCE(vi->z_extent_hint);
+		erofs_off_t hint_lend = READ_ONCE(vi->z_extent_hint_lend);
+
 		lstart = lend;
-		for (l = 0, r = vi->z_extents; l < r; ) {
-			mid = l + (r - l) / 2;
+		for (l = 0, r = vi->z_extents; l < r; ++step) {
+			erofs_off_t blk_off;
+			u64 back, fwd, blk_first, blk_last;
+			u64 orig_mid, sub_mid, lo, hi;
+			struct z_erofs_extent *e;
+
+			if (step == 0 && hint_lend &&
+			    map->m_la == hint_lend &&
+			    hint + 1 < vi->z_extents) {
+				mid = hint + 1;
+			} else if (step == 0 && r - l > 4 && lend > map->m_la) {
+				u64 est = div64_u64(map->m_la * (r - l), lend);
+
+				if (est >= r)
+					est = r - 1;
+				mid = est;
+			} else {
+				mid = l + (r - l) / 2;
+			}
 			ext = erofs_read_metabuf(&map->buf, sb,
 						 pos + mid * recsz, in_mbox);
 			if (IS_ERR(ext))
 				return PTR_ERR(ext);
 
-			la = le32_to_cpu(ext->lstart_lo);
-			pa = le32_to_cpu(ext->pstart_lo) |
-				(u64)le32_to_cpu(ext->pstart_hi) << 32;
-			if (recsz > offsetof(struct z_erofs_extent, lstart_hi))
-				la |= (u64)le32_to_cpu(ext->lstart_hi) << 32;
-
-			if (la > map->m_la) {
-				r = mid;
-				if (la > lend) {
-					DBG_BUGON(1);
-					return -EFSCORRUPTED;
+			/*
+			 * Multiple extent records reside in the same metadata
+			 * block (e.g., 256 records per 4 KiB page for
+			 * 16-byte extents, or 128 records for 32-byte extents).
+			 * Narrow [l, r) across all records already present in
+			 * the currently mapped metadata page to avoid repeated
+			 * erofs_read_metabuf() calls.
+			 */
+			blk_off = (pos + mid * recsz) & bmask;
+			back = min_t(u64, mid, blk_off / recsz);
+			fwd = (sb->s_blocksize - blk_off) / recsz;
+			blk_first = mid - back;
+			blk_last = min_t(u64, vi->z_extents - 1, mid + fwd - 1);
+			orig_mid = sub_mid = mid;
+
+			while (l < r) {
+				e = (void *)ext +
+				    ((s64)sub_mid - (s64)orig_mid) * recsz;
+
+				la = le32_to_cpu(e->lstart_lo);
+				pa = le32_to_cpu(e->pstart_lo) |
+					(u64)le32_to_cpu(e->pstart_hi) << 32;
+				if (recsz > offsetof(struct z_erofs_extent, lstart_hi))
+					la |= (u64)le32_to_cpu(e->lstart_hi) << 32;
+
+				if (la > map->m_la) {
+					r = sub_mid;
+					if (la > lend) {
+						DBG_BUGON(1);
+						return -EFSCORRUPTED;
+					}
+					lend = la;
+				} else {
+					l = sub_mid + 1;
+					if (map->m_la == la)
+						r = min(l + 1, r);
+					lstart = la;
+					map->m_plen = le32_to_cpu(e->plen);
+					map->m_pa = pa;
 				}
-				lend = la;
-			} else {
-				l = mid + 1;
-				if (map->m_la == la)
-					r = min(l + 1, r);
-				lstart = la;
-				map->m_plen = le32_to_cpu(ext->plen);
-				map->m_pa = pa;
+				lo = max_t(u64, l, blk_first);
+				hi = min_t(u64, r - 1, blk_last);
+				if (lo > hi)
+					break;
+				sub_mid = lo + (hi - lo) / 2;
 			}
 		}
+		if (l > 0) {
+			WRITE_ONCE(vi->z_extent_hint, l - 1);
+			WRITE_ONCE(vi->z_extent_hint_lend, lend);
+		}
 		last = (l >= vi->z_extents);
 	}
 
@@ -665,6 +715,8 @@ static int z_erofs_fill_inode(struct inode *inode, struct erofs_map_blocks *map)
 	}
 	vi->z_advise = le16_to_cpu(h->h_advise);
 	vi->z_lclusterbits = sb->s_blocksize_bits + (h->h_clusterbits & 15);
+	vi->z_extent_hint = 0;
+	vi->z_extent_hint_lend = 0;
 	if (vi->datalayout == EROFS_INODE_COMPRESSED_FULL &&
 	    (vi->z_advise & Z_EROFS_ADVISE_EXTENTS)) {
 		vi->z_extents = le32_to_cpu(h->h_extents_lo) |
-- 
2.56.0.rc1.315.gc6ed9934b7-goog


