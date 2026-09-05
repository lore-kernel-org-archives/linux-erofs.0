Return-Path: <linux-erofs+bounces-4480-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3B58DC624DB
	for <linux-erofs@archiver.kernel.org>; Sat,  5 Sep 2026 12:09:13 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hcXF31lYfz2yv2;
	Sat, 05 Sep 2026 22:09:11 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2607:f8b0:4864:20::1029"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1788610151;
	cv=none; b=N33I63PLNZKxMjZ8vQu87JgRkWox5EvNABh2VetPQEy5ADOE1xfNtifAx54lkskz6TTmME3WJE8saX2mKw02XTsRhz/D6ROLz9F5du4xNwqjogTpDv8iCafZ7lpcYRSuu/Guj9HH/GtcgI+KaeSPBqCxrWHONnk9kzGZP0YfsS+6jd/DcW5ftEg7dK2hyZj5qpArm+JBYH4aYkJ/HgpIGPtFYmC9MxkjwxIjbfB7jU5f4VEAnWUwZILrUk0sYDZWY/PfBZwQBaaUxvsbarIM8q82wbMxgkzPVsIF0WC13Jqh1Jwj8c1DXwkGt/z2ibl2BoEQHU7QxRoch43kGm8ruw==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1788610151; c=relaxed/relaxed;
	bh=L0Mz9q9D31hlW2IcBGeGYl1vfO3cS5A2SQxmG0qD+rM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=dI8KiD/cx4jpjpH6dFIv2DaRVEd4HQ0yWPIXagmqhekjdeq6r804RQLE/X1fbgNo5dzjqDxBwr0aRIUjcb7x/dTYRs/Vy3gDByUtxrze4NXZzy1Vk8eKT5Qj1gQxThXYwJYJLzRThoHSN3q5Rp7zXI95YimHbFJXanT2Z+cvAPbn0eW2g9Uycf1V26MayAJ+wskLmJo9klIjGpTPd6BFTiHUrfzgmKRatYNxoAKOdPRB4D214C8c7SYO/S02odWUbm64PhNoP9I7iQKemBZWLkFFYviyegrqd/Jy6uuhffa1kxYVsfWpBaG1v8K9FziWCpbIavuBxMbJuECeAbhc5g==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=gmail.com; dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=mI/L+uPm; dkim-atps=neutral; spf=pass (client-ip=2607:f8b0:4864:20::1029; helo=mail-pj1-x1029.google.com; envelope-from=stopire@gmail.com; receiver=lists.ozlabs.org) smtp.mailfrom=gmail.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=mI/L+uPm;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=gmail.com (client-ip=2607:f8b0:4864:20::1029; helo=mail-pj1-x1029.google.com; envelope-from=stopire@gmail.com; receiver=lists.ozlabs.org)
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hcXF11pvNz2ytj
	for <linux-erofs@lists.ozlabs.org>; Sat, 05 Sep 2026 22:09:08 +1000 (AEST)
Received: by mail-pj1-x1029.google.com with SMTP id 98e67ed59e1d1-39647184c73so2903803a91.1
        for <linux-erofs@lists.ozlabs.org>; Sat, 05 Sep 2026 05:09:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788610146; x=1789214946; darn=lists.ozlabs.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=L0Mz9q9D31hlW2IcBGeGYl1vfO3cS5A2SQxmG0qD+rM=;
        b=mI/L+uPmXLsX3Pd5cS4bP/Mh5TggN/bGGhl1I3FKU4diInCOyUTIPX9IZDBajr1Ef1
         qfRDO1nDnNaY+1x6MStniQ+3gcY/Io5iWKF+u+a4WpGmT1/fQ029/sA6HOb6sL6Q3tXU
         OnbxFC9FRf/g0YfYW8kukwF0g1bijuHLwKfyGFg7yw96WUPxTi9OQnJu3p83VZOfq6xa
         SIDiD495S0+O6BLwMFNNlu7ixOfpyr7h0hVTS/5zQ6AVqBxj3+8X0OAJtfV69dP5+oLB
         xDJ6e+BUeT6/9esS2sctumszfURMdsXrbXc6EnOLJLioqtDEqqxevDFbaxSiP4W+Rl0+
         b2vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788610146; x=1789214946;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=L0Mz9q9D31hlW2IcBGeGYl1vfO3cS5A2SQxmG0qD+rM=;
        b=tHIMzab1CuqvVol4FrtLFck3yU24yTtLbBPoYA/74UzIB3op2fYaKONEosyVzf09JU
         +xnminOarsQNxAGcxM6lV1lAxgqdGISi0WSW0IRSMnB6OIPP9PMwEd8gpboFtJYhhmWm
         mF4Ylyg5OwZyUxwt/0pg33tj/BaHvYV1xa7XjjaWmTXeKzDnWhCrByvrHiZzdzFUX6t+
         GTJrHWF0oL3vnYe/qNteb3twbDvn2nd7WqhVlNgM5BJeLtyCr84BvP5MO0tpbPcsE71F
         1dRYe7QDY5uKmm4/7XpsyiSLkJtSLlNMrZZ+fyzSZ9FqNMNIqKRCjOvmODa7XYiYauC3
         UEzQ==
X-Gm-Message-State: AFuF++nuAdVPNNzJT2UTzKanDhTjLJuZWMTA79cKrSdlrL0oLC6p99fZ
	pC9Cbtcb0yI2RAgV1FaewLFi8wB6wLtj+Rzs/vXV+LV4/G7PocvoZDmb1qhf+SlBLxUv0g==
X-Gm-Gg: AYBFou2h9aI5yeTW/uu/Q/EKiWHcJ9AT0/nMYwcE7cNEaSa6PjLV23pGhCLyk7G/3Eq
	QYbbDI7sqSY9qU6l8mcakSZzLULj8UVEdF271AJSocYvsHL/nmgX8W5EOij19/hmECFmnu2puaf
	1wbagP1jsNzgiOSE005MPqgA/t4pk8ZTJqJEoWV3Mxyyk9k8M8cemLWyy+Lifgu8sYb2Unga+hN
	XiDRRPBq5WyGJIyQ7CixpD3zVysxbRGdYSTFSoDJRqfU9inZjm2jddVh8stgDsN7/Y5mQWOqDRW
	ZCW0vO1kVOWAXY+IDpx/76XDA0GVUwE67RoaeCsHMFHwfMRFCGn/UruFEGvoyNRTuDpQUjzgsen
	GzqHqTofgzpncewkonVilJjGRujjyyYkCqS4bdMba4sU50zJDZZ9sCnL6f/LbjrzntOx6GuWf7Q
	UWiMQ6bevgJrerhIPvKKAREkmLB+VUnJOwhp7yA523UQFAxACDhunPlMt7YL2mTx/2s/j6LBw4Y
	MFT7Dxyvm7lstr7rqsIsIrczvwanDM6bMJqwXsZzA==
X-Received: by 2002:a17:90b:2751:b0:398:9bd3:d6d4 with SMTP id 98e67ed59e1d1-39b27ec580fmr9758682a91.14.1788610145854;
        Sat, 05 Sep 2026 05:09:05 -0700 (PDT)
Received: from zyf-laptop.tail52ade4.ts.net ([2406:da18:1fc5:7000:bd99:825f:cbe1:e75f])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39b08bcc081sm15980035a91.6.2026.09.05.05.09.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 05 Sep 2026 05:09:05 -0700 (PDT)
From: Yifan Zhao <stopire@gmail.com>
To: linux-erofs@lists.ozlabs.org
Cc: xiang@kernel.org,
	Yifan Zhao <stopire@gmail.com>
Subject: [PATCH] erofs-utils: lib: fix chunk index reads from metabox
Date: Sat,  5 Sep 2026 20:09:00 +0800
Message-ID: <20260905120900.943511-1-stopire@gmail.com>
X-Mailer: git-send-email 2.55.0
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

Chunk indexes stored in metabox are incorrectly read from the primary
device, resulting in incorrect file contents.

Assisted-by: Codex:gpt-6-astra
Signed-off-by: Yifan Zhao <stopire@gmail.com>
---
 lib/data.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/lib/data.c b/lib/data.c
index 5a17af5..fa2907b 100644
--- a/lib/data.c
+++ b/lib/data.c
@@ -72,7 +72,7 @@ int __erofs_map_blocks(struct erofs_inode *inode,
 	struct erofs_sb_info *sbi = inode->sbi;
 	unsigned int unit, blksz = 1 << sbi->blkszbits;
 	struct erofs_inode_chunk_index *idx;
-	u8 buf[EROFS_MAX_BLOCK_SIZE];
+	struct erofs_buf buf = __EROFS_BUF_INITIALIZER;
 	erofs_blk_t startblk, addrmask, nblocks;
 	bool tailpacking;
 	erofs_off_t pos;
@@ -115,11 +115,10 @@ int __erofs_map_blocks(struct erofs_inode *inode,
 	pos = roundup(erofs_iloc(vi) + vi->inode_isize +
 		      vi->xattr_isize, unit) + unit * chunknr;
 
-	err = erofs_blk_read(sbi, 0, buf, erofs_blknr(sbi, pos), 1);
-	if (err < 0)
-		return -EIO;
-
-	idx = (void *)buf + erofs_blkoff(sbi, pos);
+	idx = erofs_read_metabuf(&buf, sbi, pos,
+				erofs_inode_in_metabox(vi));
+	if (IS_ERR(idx))
+		return PTR_ERR(idx);
 	map->m_la = chunknr << vi->u.chunkbits;
 	map->m_llen = min_t(erofs_off_t, 1ULL << vi->u.chunkbits,
 			    round_up(inode->i_size - map->m_la, blksz));
@@ -141,6 +140,7 @@ int __erofs_map_blocks(struct erofs_inode *inode,
 			map->m_flags = EROFS_MAP_MAPPED;
 		}
 	}
+	erofs_put_metabuf(&buf);
 out:
 	if (!err) {
 		map->m_plen = map->m_llen;
-- 
2.55.0


