Return-Path: <linux-erofs+bounces-1172-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C2F8ECCD18D
	for <linux-erofs@archiver.kernel.org>; Sat, 11 Oct 2025 02:53:09 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4ck7TJ0rp8z304x;
	Sat, 11 Oct 2025 13:53:08 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=115.124.30.101
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1760151188;
	cv=none; b=F4/HI0njHojakuiUUynk1hjb7B9NvxobwZ1Rb8Q683KDfUJYzEjD28qUq6eRuDhcB3nXP7Mn21gE6yALGHe5ZylSsMumMoOynjJHqW4nxJ6Uv3yRMYuJU1WgzHidQbwEyCmlmVl1WyA+FdVbIbAADef1pKsMSYqC4atj6E7GFicB2JTE3xuZ5he3nNawcuMWKcUT8FjGEATqZH/3ErfiP/qShktDwiV78JqODaWbBW0EtZ/UoVFAJLGrDXJgec5ony1RDpIGA3xGG3o5iB1PKS34JL0pYAn3IGYYg6botIp2Z0fwUcQcvCGt3/e8EQmJYE6uAEvuKZoHevNIfLM5wg==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1760151188; c=relaxed/relaxed;
	bh=/XH6O+w/vLkIKzDZCp4JPxCPSxFkrEmYd0YC6ui49Po=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=kWLk2y89nJee60IoUegO3ARQjAASjGhEdb7kgv5IjoPF5qEOHOqAQjhqee5wiBo4W4y1GgAAGpagPLvK9x792S7JytLX5GvbPW+LC3iJKKd2Oiv69aggFwtRDa3FLjiBqar6C7fHT8bO5UuQMKsxnyM/WtxAZzXB4QaNRmTJIrOngAm8vzcOBPGhlCDTmwmP/Ayz8WTDh/wS0f7XfDDIRgGb43lTBXZjy8U/W1S7HB+DVQgmPRAj3iv6SgCYWA87DNJRhH9SHj0denp5yItlhW7AJ+FG7/0Q3Q4Z48ig/SHVud5lOOuq8erb0RWyBvcLIRtpuGa4uQ2LSHVjlveI4w==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=oIUCAndM; dkim-atps=neutral; spf=pass (client-ip=115.124.30.101; helo=out30-101.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org) smtp.mailfrom=linux.alibaba.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=oIUCAndM;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=linux.alibaba.com (client-ip=115.124.30.101; helo=out30-101.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org)
Received: from out30-101.freemail.mail.aliyun.com (out30-101.freemail.mail.aliyun.com [115.124.30.101])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4ck7TF3b45z2xlQ
	for <linux-erofs@lists.ozlabs.org>; Sat, 11 Oct 2025 13:53:03 +1100 (AEDT)
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1760151178; h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type;
	bh=/XH6O+w/vLkIKzDZCp4JPxCPSxFkrEmYd0YC6ui49Po=;
	b=oIUCAndMZfiyLnecjhsrtbvX8YeBRG0OcnwonRMOETX6q2a82efDCBuXuMoRxi0ZFTUT4NVZK6ytEew/+YbQu7P/Lj3cLHiJsKYrg9nQd91tD4pn9S0xO7lXXffN8qwZNU8/AdRW+FVZdR3xvhr416M8+QoCNA0F84S8FoBj3C0=
Received: from x31i01179.sqa.na131.tbsite.net(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0Wpv64J9_1760151173 cluster:ay36)
          by smtp.aliyun-inc.com;
          Sat, 11 Oct 2025 10:52:57 +0800
From: Gao Xiang <hsiangkao@linux.alibaba.com>
To: linux-erofs@lists.ozlabs.org
Cc: LKML <linux-kernel@vger.kernel.org>,
	Robert Morris <rtm@mit.edu>,
	Gao Xiang <hsiangkao@linux.alibaba.com>,
	Robert Morris <rtm@csail.mit.edu>
Subject: [PATCH] erofs: fix crafted invalid cases for encoded extents
Date: Sat, 11 Oct 2025 10:52:52 +0800
Message-ID: <20251011025252.1714898-1-hsiangkao@linux.alibaba.com>
X-Mailer: git-send-email 2.43.5
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Robert recently reported two corrupted images that can cause system
crashes, which are related to the new encoded extents introduced
in Linux 6.15:

  - The first one [1] has plen != 0 (e.g. plen == 0x2000000) but
    (plen & Z_EROFS_EXTENT_PLEN_MASK) == 0. It is used to represent
    special extents such as sparse extents (!EROFS_MAP_MAPPED), but
    previously only plen == 0 was handled;

  - The second one [2] has pa 0xffffffffffdcffed and plen 0xb4000,
    then "cur [fffffffffffff000] += bvec.bv_len [0x1000]" in
    "} while ((cur += bvec.bv_len) < end);" wraps around, causing an
    out-of-bound access of pcl->compressed_bvecs[] in
    z_erofs_submit_queue().  EROFS only supports 48‑bit physical
    addresses (up to 1 EiB), so add a sanity check to enforce this.

Fixes: 1d191b4ca51d ("erofs: implement encoded extent metadata")
Reported-by: Robert Morris <rtm@csail.mit.edu>
Closes: https://lore.kernel.org/r/75022.1759355830@localhost
Closes: https://lore.kernel.org/r/80524.1760131149@localhost
Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
---
 fs/erofs/zmap.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/fs/erofs/zmap.c b/fs/erofs/zmap.c
index e5581dbeb4c2..c346397dc859 100644
--- a/fs/erofs/zmap.c
+++ b/fs/erofs/zmap.c
@@ -596,7 +596,7 @@ static int z_erofs_map_blocks_ext(struct inode *inode,
 			vi->z_fragmentoff = map->m_plen;
 			if (recsz > offsetof(struct z_erofs_extent, pstart_lo))
 				vi->z_fragmentoff |= map->m_pa << 32;
-		} else if (map->m_plen) {
+		} else if (map->m_plen & Z_EROFS_EXTENT_PLEN_MASK) {
 			map->m_flags |= EROFS_MAP_MAPPED |
 				EROFS_MAP_FULL_MAPPED | EROFS_MAP_ENCODED;
 			fmt = map->m_plen >> Z_EROFS_EXTENT_PLEN_FMT_BIT;
@@ -715,6 +715,7 @@ static int z_erofs_map_sanity_check(struct inode *inode,
 				    struct erofs_map_blocks *map)
 {
 	struct erofs_sb_info *sbi = EROFS_I_SB(inode);
+	u64 pend;
 
 	if (!(map->m_flags & EROFS_MAP_ENCODED))
 		return 0;
@@ -732,6 +733,10 @@ static int z_erofs_map_sanity_check(struct inode *inode,
 	if (unlikely(map->m_plen > Z_EROFS_PCLUSTER_MAX_SIZE ||
 		     map->m_llen > Z_EROFS_PCLUSTER_MAX_DSIZE))
 		return -EOPNOTSUPP;
+	/* Filesystems beyond 48-bit physical addresses are invalid */
+	if (unlikely(check_add_overflow(map->m_pa, map->m_plen, &pend) ||
+		     pend >= BIT_ULL(48)))
+		return -EFSCORRUPTED;
 	return 0;
 }
 
-- 
2.43.5


