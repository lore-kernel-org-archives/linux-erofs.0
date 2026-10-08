Return-Path: <linux-erofs+bounces-4681-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CFD14CA6017
	for <linux-erofs@archiver.kernel.org>; Thu,  8 Oct 2026 19:08:40 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4j0zzq18Tzz30Vy;
	Fri, 09 Oct 2026 06:08:39 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2607:f8b0:4864:20::132a"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1791486519;
	cv=none; b=kvEHBAv27yA7Jp2jP3pR8h67q3U6Lm4CzCGXBKmFjJlq8ZyuFvUInO8AGu5OMkF4VcdwdIjs8X43q4gIDEchAxVllW5blEVf40/VG/B/Gyh9qmg5E+6U6ZVtlpQ0YxI94NMb6vdCt2N2Z0qTiXHHPGGB6r9E1rfOu7mQFB+dER6L6IDpgfxya49nDKXzpa/du10lFWxSkZt2u+BNwUbePX4k461uqEvfzoeyguP1hlCDyX9smdZKuQmhHj+O2nf1GJ8DH8EgXx+tVIc2zPhRlJ7pVrRKzFHuNAVNE9NmIH7y2Eniu5/TvZJE4tYO3zjWD2e+yLZnkLtqNXQyQmt7Kw==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1791486519; c=relaxed/relaxed;
	bh=5apqDPTTuz0tcu66C6sdhKkioJqFGVwtFVltYn4up0I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cgUUQLuLfUNWNq21msqR4HbCGtL3nx5/+Qz4B/kO24f41AX/QCbw+QvHO1LrXkxxM7/clC+fDgxlWaPPax+ht6elbFs0uHx6WD26ljOqYWVjOgxDNMoSzkDNnKUzx53rgOvLhzgeqO7pQFS29+v6SBCtsPJ6uvsY9hqs6Nq0nXxRbSb0s9ggkJi7bPkS5MstJno94Bjw+OrGxtyjOKVJhd3G2DD4anWYdtmRephWrFynXcSMF/+8SNuLVhyYpx0yODXC1JXam794TEQGAqLz8QgrypjVFy54DJCUfnYcob9CjDBp5ZYjnyNLYtGy2GP59vliPqW82h3HNaTDYd+/SA==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=reject dis=none) header.from=trailofbits.com; dkim=pass (2048-bit key; unprotected) header.d=trailofbits.com header.i=@trailofbits.com header.a=rsa-sha256 header.s=google header.b=BPRU0b6Q; dkim-atps=neutral; spf=pass (client-ip=2607:f8b0:4864:20::132a; helo=mail-dy1-x132a.google.com; envelope-from=artem@trailofbits.com; receiver=lists.ozlabs.org) smtp.mailfrom=trailofbits.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=reject dis=none) header.from=trailofbits.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=trailofbits.com header.i=@trailofbits.com header.a=rsa-sha256 header.s=google header.b=BPRU0b6Q;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=trailofbits.com (client-ip=2607:f8b0:4864:20::132a; helo=mail-dy1-x132a.google.com; envelope-from=artem@trailofbits.com; receiver=lists.ozlabs.org)
Received: from mail-dy1-x132a.google.com (mail-dy1-x132a.google.com [IPv6:2607:f8b0:4864:20::132a])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4j0zzp0MS7z2yqs
	for <linux-erofs@lists.ozlabs.org>; Fri, 09 Oct 2026 06:08:37 +1100 (AEDT)
Received: by mail-dy1-x132a.google.com with SMTP id 5a478bee46e88-3115c4451c8so4777838eec.1
        for <linux-erofs@lists.ozlabs.org>; Thu, 08 Oct 2026 12:08:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=trailofbits.com; s=google; t=1791486515; x=1792091315; darn=lists.ozlabs.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=5apqDPTTuz0tcu66C6sdhKkioJqFGVwtFVltYn4up0I=;
        b=BPRU0b6Qp8QmNPUTV6sx7jc2b6otedEeEDg80tp3dyPe1odP2Vvl63kWgegORoIMjS
         XyIuvFDUu0l/xKqk8FLJLWczJcgjGU47LeZzidvV1TNDrfazxYPdTnubkwQ9poBnXFQl
         zI2bIY7mcm88KsD1YCG5lZWfw6ru1g/WinQIy7yk07matzfPK412/Z5AmMAVuHQ817l3
         hJ1MXXmsdfaURK36jil4jUwK/Wqbp8Ar9GODjl3Z9BoqkuLudrRf6Sa+UODMkprO/ydO
         tQ7tkwESj0DWu8Q/rpP9HfE3E86CVVC6hMXu5zHeKGLtqoWEoCb1gKfAwTHZUBY4ayP+
         RRCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791486515; x=1792091315;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=5apqDPTTuz0tcu66C6sdhKkioJqFGVwtFVltYn4up0I=;
        b=eig4M1M4FxT3Cld2VauqjOaY5syYwRD35uti/4MtCIZ5JSOTrL1lLBIYVsPqk3S1TF
         VrNcyIVQjwemXunL5WuvFgdcjHrvD4KTEzrj5IHiEBrwbE+ierO9MMxeahDeTSobDUtK
         Qinvd0o7IFSIWZimUEt8ICx1gF9BDQoHyi0KM87WXdpi1XqVV0VUw9+UOvl6xoBJ4LVG
         3LJNYI+rQ9tnvFZXyaNnkPOSRdMWJ8L1ggcK1zWBT4Va9ccGIy0uRejoTzZ5Gp8c1bb0
         yxOeMygpvQ9yoaaH2HtQWMNfpUlxMjXjCppzJq4Kbl4+dnkmOt8IJ2yRtp6ylpterZPW
         33YA==
X-Forwarded-Encrypted: i=1; AKwUvByKZX1CXdnyI2FcJwbK77BQ4KmEC3i5GJ8oqTsQBfzhbyrdbA5KEJq4cxpgT2MbUjkZm8+Yn7VSfYJ0eg==@lists.ozlabs.org
X-Gm-Message-State: AFq9FYLtRuaRvZKGOd48I9v4ALouWcpEMkJ/05uGfuwNnt25UugjSAhw
	JbrGytpa7rqPHCRLOI3MIBQ8LZcVhkCc7hldV2DXZeK/w5GuIqNLipIr8ZCHXt+ZP1Y=
X-Gm-Gg: AYBFou0xtNOu4BgT2JQXjk6fJXAonT2w8XSpdTduAa6D+7BgN3OaxtS0amYpSaB/ygf
	yDodbKgRrYjIQCGnUSp6Dhh6r0Mx2COHuk8ke7xdaJsnkhE8OKVxQQrO6AsckK7jsmegULR1wdc
	ULKKkK0L4vsCvCjy0CfkLLfGxYo8ylCwIRBf8GM9r53Cplugws8f6w+gIKPYclT+1DEvBs1A8tk
	/p/dphJETS9n3DXbxl8yrOgbIEi3uoKMbhnDXVT8w56XoQkTJM7iW4e5J23HKBrBqcRxNimKApd
	4H+o7xk518oLXSjsS2RIFJRU7gP8lQ8ZVxMUekKI2PGIA2bGDW4OjF8Nk8R9fxJRa8bE2NYYjjc
	tvOT9nejyKBsek7Qwq3C8zb4+3SMh3Ilicatt2SMkNa1ZbE6UGuovk4mvB0PdOpijZwXk+AzFGd
	/Pa6tIgGVEGgx8bmXDbWdMm34555rJB8BcFaPKzPhpzGag3imWVnSEHvJbVbY18BX/s/w1WDLdY
	ErURhi0qawPQRVhRi+QZBkrlyOpiCMyW0Rag7qxUMsDO1QtEaXMY/RUg6kL6EpSpgACK1o=
X-Received: by 2002:a05:693c:87cd:20b0:353:5d7a:cabe with SMTP id 5a478bee46e88-3536c53930dmr317574eec.13.1791486515207;
        Thu, 08 Oct 2026 12:08:35 -0700 (PDT)
Received: from localhost.localdomain ([2603:8001:5f01:8bab:bc88:5ec1:4f8a:5b23])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3537c841648sm80561eec.3.2026.10.08.12.08.34
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 08 Oct 2026 12:08:34 -0700 (PDT)
From: Artem Dinaburg <artem@trailofbits.com>
To: stable@vger.kernel.org
Cc: Artem Dinaburg <artem@trailofbits.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>,
	Gao Xiang <hsiangkao@linux.alibaba.com>,
	Robert Morris <rtm@csail.mit.edu>,
	Hongbo Li <lihongbo22@huawei.com>,
	Gao Xiang <xiang@kernel.org>,
	Chao Yu <chao@kernel.org>,
	Yue Hu <huyue2@coolpad.com>,
	Jeffle Xu <jefflexu@linux.alibaba.com>,
	linux-erofs@lists.ozlabs.org,
	linux-kernel@vger.kernel.org,
	Yue Hu <zbestahu@gmail.com>,
	Sandeep Dhavale <dhavale@google.com>,
	Hongbo Li <hongbohbli@tencent.com>,
	Chunhai Guo <guochunhai@vivo.com>
Subject: [PATCH 6.6.y 1/2] erofs: avoid infinite loops due to corrupted subpage compact indexes
Date: Thu,  8 Oct 2026 15:08:27 -0400
Message-ID: <20261008190830.97970-2-artem@trailofbits.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261008190830.97970-1-artem@trailofbits.com>
References: <20261008190830.97970-1-artem@trailofbits.com>
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

From: Gao Xiang <hsiangkao@linux.alibaba.com>

[ Upstream commit e13d315ae077bb7c3c6027cc292401bc0f4ec683 ]

Robert reported an infinite loop observed by two crafted images.

The root cause is that `clusterofs` can be larger than `lclustersize`
for !NONHEAD `lclusters` in corrupted subpage compact indexes, e.g.:

  blocksize = lclustersize = 512   lcn = 6   clusterofs = 515

Move the corresponding check for full compress indexes to
`z_erofs_load_lcluster_from_disk()` to also cover subpage compact
compress indexes.

It also fixes the position of `m->type >= Z_EROFS_LCLUSTER_TYPE_MAX`
check, since it should be placed right after
`z_erofs_load_{compact,full}_lcluster()`.

[ Backport to 6.6.y: preserve the switch-based full/compact loader and
  perform the type and cluster-offset validation after either loader
  using z_logical_clusterbits. ]

Fixes: 8d2517aaeea3 ("erofs: fix up compacted indexes for block size < 4096")
Fixes: 1a5223c182fd ("erofs: do sanity check on m->type in z_erofs_load_compact_lcluster()")
Reported-by: Robert Morris <rtm@csail.mit.edu>
Closes: https://lore.kernel.org/r/35167.1760645886@localhost
Reviewed-by: Hongbo Li <lihongbo22@huawei.com>
Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
Assisted-by: LLM
Signed-off-by: Artem Dinaburg <artem@trailofbits.com>
---
This is patch 1 of 2 in the ordered 6.6.y backport series.
This change addresses CVE-2025-68251. 6.6 validates clusterofs only in the
full-index loader, leaving corrupted subpage compact NONHEAD records able
to drive non-progressing lookback.
This needed a target-specific adjustment; I called it out in the bracketed
backport note above.

The fix is already present in 6.12.y, 6.18.y, and 7.2.y, but not in 6.6.y.

 fs/erofs/zmap.c | 30 +++++++++++++++++++++++-------
 1 file changed, 23 insertions(+), 7 deletions(-)

diff --git a/fs/erofs/zmap.c b/fs/erofs/zmap.c
index 76566c2cbf63..e53d5239f04d 100644
--- a/fs/erofs/zmap.c
+++ b/fs/erofs/zmap.c
@@ -67,10 +67,6 @@ static int z_erofs_load_full_lcluster(struct z_erofs_maprecorder *m,
 		if (advise & Z_EROFS_LI_PARTIAL_REF)
 			m->partialref = true;
 		m->clusterofs = le16_to_cpu(di->di_clusterofs);
-		if (m->clusterofs >= 1 << vi->z_logical_clusterbits) {
-			DBG_BUGON(1);
-			return -EFSCORRUPTED;
-		}
 		m->pblk = le32_to_cpu(di->di_u.blkaddr);
 		break;
 	default:
@@ -276,14 +272,34 @@ static int z_erofs_load_compact_lcluster(struct z_erofs_maprecorder *m,
 static int z_erofs_load_lcluster_from_disk(struct z_erofs_maprecorder *m,
 					   unsigned int lcn, bool lookahead)
 {
-	switch (EROFS_I(m->inode)->datalayout) {
+	struct erofs_inode *vi = EROFS_I(m->inode);
+	int err;
+
+	switch (vi->datalayout) {
 	case EROFS_INODE_COMPRESSED_FULL:
-		return z_erofs_load_full_lcluster(m, lcn);
+		err = z_erofs_load_full_lcluster(m, lcn);
+		break;
 	case EROFS_INODE_COMPRESSED_COMPACT:
-		return z_erofs_load_compact_lcluster(m, lcn, lookahead);
+		err = z_erofs_load_compact_lcluster(m, lcn, lookahead);
+		break;
 	default:
 		return -EINVAL;
 	}
+	if (err)
+		return err;
+
+	if (m->type >= Z_EROFS_LCLUSTER_TYPE_MAX) {
+		erofs_err(m->inode->i_sb, "unknown type %u @ lcn %u of nid %llu",
+			  m->type, lcn, vi->nid);
+		DBG_BUGON(1);
+		return -EOPNOTSUPP;
+	}
+	if (m->type != Z_EROFS_LCLUSTER_TYPE_NONHEAD &&
+	    m->clusterofs >= (1 << vi->z_logical_clusterbits)) {
+		DBG_BUGON(1);
+		return -EFSCORRUPTED;
+	}
+	return 0;
 }
 
 static int z_erofs_extent_lookback(struct z_erofs_maprecorder *m,
-- 
2.39.5


