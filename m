Return-Path: <linux-erofs+bounces-3366-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4E9D9FF8864
	for <linux-erofs@archiver.kernel.org>; Wed, 29 Apr 2026 08:23:19 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4g59Kx5Q9Lz2ySf;
	Wed, 29 Apr 2026 18:23:17 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=222.66.158.135
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1777450997;
	cv=none; b=OfTIeux04glWUNepAxrZ2Sxm5Q9nUqZT1mU66HDD+KoWjmtciH+tdwFSRhJYhskvn8W/l0wgSE3ApL3fCXfL2QTgy92AHNTfNI4XmzNlkV4vUzXr1iUJ7WEQ0YvEYYuwa/n9w3UJ9LtLgVnyfxMXK/qYwB9kU0auA6b75YQ1w9zI6QxpXIde7JBMbSqjDUpYdUKzGJ5n0IJOGfzBVWs+7L9MMqf4rzoE6DgDsepx8tQ7h+NEwZaLP1+Vau6XhBROahUIpynv6Bu4u6IOQW2IBxe2ysUWVcD+hF4z6mdSARA+P46LO6BhUZEufXszl7yKwlrHOVebqCaLSDa16CsBIA==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1777450997; c=relaxed/relaxed;
	bh=erMdAkk//4FIKnol/gaYF5mdQ1a0G/RcxiKGXNU+OMU=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=XMhs5erv2uHAePMHCpzdSmrKdYttNSupFWJmlulJOcR7OvwwSfUPc03r9bazIjquipRwAbtcJS16QtMINkQio1xpiB39AEeLS/KbeMM8N43Aj4+j8QJ4R4CcH6kdxCl61HffXbbSyy6RESnlF6tcp1Do8OzkSHnnjG5Da2kRi687zD14nyt3/t+cM5+/A+BKTs6jYsun6xZMcnfcdJdHVzYcWl51ZRGekOx653hJA6AcWlKdQmwgK8PySs1V1HwBaAPo2+PzfKQRmlaWJfID6hy392B4eNeeCGZ5AXkc7MRi//MB1vrmVDX/qvjy6CQGlhE5VcRLwTNmD8dwSPUwkA==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=unisoc.com; dkim=pass (2048-bit key; unprotected) header.d=unisoc.com header.i=@unisoc.com header.a=rsa-sha256 header.s=default header.b=aAisdaeV; dkim-atps=neutral; spf=pass (client-ip=222.66.158.135; helo=shsqr01.spreadtrum.com; envelope-from=zhiguo.niu@unisoc.com; receiver=lists.ozlabs.org) smtp.mailfrom=unisoc.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=unisoc.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=unisoc.com header.i=@unisoc.com header.a=rsa-sha256 header.s=default header.b=aAisdaeV;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=unisoc.com (client-ip=222.66.158.135; helo=shsqr01.spreadtrum.com; envelope-from=zhiguo.niu@unisoc.com; receiver=lists.ozlabs.org)
X-Greylist: delayed 1360 seconds by postgrey-1.37 at boromir; Wed, 29 Apr 2026 18:23:13 AEST
Received: from SHSQR01.spreadtrum.com (unknown [222.66.158.135])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4g59Ks5XHFz2ySW
	for <linux-erofs@lists.ozlabs.org>; Wed, 29 Apr 2026 18:23:08 +1000 (AEST)
Received: from SHSQR01.spreadtrum.com (localhost [127.0.0.2] (may be forged))
	by SHSQR01.spreadtrum.com with ESMTP id 63T80XoP096162
	for <linux-erofs@lists.ozlabs.org>; Wed, 29 Apr 2026 16:00:33 +0800 (+08)
	(envelope-from Zhiguo.Niu@unisoc.com)
Received: from dlp.unisoc.com ([10.29.3.86])
	by SHSQR01.spreadtrum.com with ESMTP id 63T7wJHV074988;
	Wed, 29 Apr 2026 15:58:19 +0800 (+08)
	(envelope-from Zhiguo.Niu@unisoc.com)
Received: from SHDLP.spreadtrum.com (BJMBX02.spreadtrum.com [10.0.64.8])
	by dlp.unisoc.com (SkyGuard) with ESMTPS id 4g58jm0DQKz2L0psS;
	Wed, 29 Apr 2026 15:55:24 +0800 (CST)
Received: from bj08434pcu.spreadtrum.com (10.0.73.87) by
 BJMBX02.spreadtrum.com (10.0.64.8) with Microsoft SMTP Server (TLS) id
 15.0.1497.48; Wed, 29 Apr 2026 15:58:17 +0800
From: Zhiguo Niu <zhiguo.niu@unisoc.com>
To: <hsiangkao@linux.alibaba.com>
CC: <niuzhiguo84@gmail.com>, <zhiguo.niu@unisoc.com>, <ke.wang@unisoc.com>,
        <linux-erofs@lists.ozlabs.org>
Subject: [PATCH] erofs-utils: mkfs: also handle last compacted 2B pack in z_erofs_drop_inline_pcluster
Date: Wed, 29 Apr 2026 15:59:25 +0800
Message-ID: <1777449565-22154-1-git-send-email-zhiguo.niu@unisoc.com>
X-Mailer: git-send-email 1.9.1
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
Content-Type: text/plain
X-Originating-IP: [10.0.73.87]
X-ClientProxiedBy: SHCAS01.spreadtrum.com (10.0.1.201) To
 BJMBX02.spreadtrum.com (10.0.64.8)
X-MAIL:SHSQR01.spreadtrum.com 63T7wJHV074988
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=unisoc.com;
	s=default; t=1777449537;
	bh=erMdAkk//4FIKnol/gaYF5mdQ1a0G/RcxiKGXNU+OMU=;
	h=From:To:CC:Subject:Date;
	b=aAisdaeVg4ks5j+K952UCWzU8LLkIVh5YABCGJ2FbknaI6bXmBtrO/W0CgutN6j2k
	 gpX1MzaRQjiErv43F46EdNZISl3i+mFv3S/+IlK+MUIjQ2dtMveUMM0iok0jq9tus0
	 SD9vvtgQATpDRKwqb3Uuq4k92PoGMujckijal74QKV8lgdyr6u/CKSSWJeTxxFY0Bs
	 KG4jyBQbtkADnaYPKjp4oot9+tWCOLdqAJ38nK9Xq7onUfXwPxs6Ap1RGhZh+y/i8z
	 hhbQyzkxvvHNK5clHoo/liuZoRCv40NqehI5Gqfyvwax7uGDhE9S2jM5oEWbCX35Hy
	 ASV3p6WCCbsdA==

With ztailpacking enabled, the current process assumes that a compacted_4b_end
always exists in the compacted pack. However, in some specific files, the
compacted pack may not have a compacted_4b_end. This leads to an incorrect
modification of the last compacted_2B entry, resulting in incorrect modification
of its clusterofs. In subsequent fsck operations, incorrect parameters will
affect the decompression of the penultimate pcluster.

This patch determines whether the last entry of the current compacted pack
belongs to compacted 2B or 4B and then updates the correct bits accordingly.

Fixes: a7c1f0575ef8 ("erofs-utils: lib: refine tailpcluster compression approach")
Signed-off-by: Zhiguo Niu <zhiguo.niu@unisoc.com>
---
 lib/compress.c | 38 +++++++++++++++++++++++++++-----------
 1 file changed, 27 insertions(+), 11 deletions(-)

diff --git a/lib/compress.c b/lib/compress.c
index 62d2672..0eb464b 100644
--- a/lib/compress.c
+++ b/lib/compress.c
@@ -1223,19 +1223,35 @@ void z_erofs_drop_inline_pcluster(struct erofs_inode *inode)
 
 		di->di_advise = cpu_to_le16(type);
 	} else if (inode->datalayout == EROFS_INODE_COMPRESSED_COMPACT) {
-		/* handle the last compacted 4B pack */
+		/* handle the last compacted pack */
 		unsigned int eofs, base, pos, v, lo;
 		u8 *out;
-
-		eofs = inode->extent_isize -
-			(4 << (BLK_ROUND_UP(sbi, inode->i_size) & 1));
-		base = round_down(eofs, 8);
-		pos = 16 /* encodebits */ * ((eofs - base) / 4);
-		out = inode->compressmeta + base;
-		lo = erofs_blkoff(sbi, get_unaligned_le32(out + pos / 8));
-		v = (type << sbi->blkszbits) | lo;
-		out[pos / 8] = v & 0xff;
-		out[pos / 8 + 1] = v >> 8;
+		unsigned int compacted_4b_initial, compacted_2b, compacted_4b_end;
+		unsigned int totalidx = BLK_ROUND_UP(sbi, inode->i_size);
+		const erofs_off_t ebase = sizeof(struct z_erofs_map_header) +
+			round_up(erofs_iloc(inode) + inode->inode_isize +
+					inode->xattr_isize, 8);
+
+		compacted_4b_initial = ((32 - ebase % 32) / 4) & 7;
+		compacted_2b = 0;
+		if ((le16_to_cpu(h->h_advise) & Z_EROFS_ADVISE_COMPACTED_2B) &&
+			compacted_4b_initial < totalidx)
+			compacted_2b = rounddown(totalidx - compacted_4b_initial, 16);
+		compacted_4b_end = totalidx - compacted_4b_initial - compacted_2b;
+		if (!compacted_2b || compacted_4b_end) {
+			eofs = inode->extent_isize - (4 << (totalidx & 1));
+			base = round_down(eofs, 8);
+			pos = 16 /* encodebits */ * ((eofs - base) / 4);
+			out = inode->compressmeta + base;
+			lo = erofs_blkoff(sbi, get_unaligned_le32(out + pos / 8));
+			v = (type << sbi->blkszbits) | lo;
+			out[pos / 8] = v & 0xff;
+			out[pos / 8 + 1] = v >> 8;
+		} else {
+			eofs = inode->extent_isize - (4 + 1);
+			out = inode->compressmeta + eofs;
+			*out = (*out & 0x3f) | (type << 6);
+		}
 	} else {
 		DBG_BUGON(1);
 		return;
-- 
1.9.1


