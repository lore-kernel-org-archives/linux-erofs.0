Return-Path: <linux-erofs+bounces-2958-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1AFECF46114
	for <linux-erofs@archiver.kernel.org>; Mon, 23 Mar 2026 13:43:21 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4ffZBG4YlQz2ySb;
	Tue, 24 Mar 2026 00:43:18 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2600:3c04:e001:324:0:1991:8:25"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1774273398;
	cv=none; b=AUf9mu+Y5Qrq8pBpHvoy9g7bS0HeiD6WuFIsD3XNbCLPdFduyzqKhhqZDtdOGmwn048FV6j6WdPrCh1ZYpVUy2pUk7N8sqti9+kTwryr4WY1xfRTo2SdH84mTQOmBkf9KlCg/C1AYmd19276rcxXs6e2vZSW95HomT84azK2Ee2RgX+Ul3j9wrzwVgGiWXm4o1MGKhQVtyfziPuuQDG6f457eusnPwnMM5vh53+aQPWWcQST6wOyd/lpoC+3A/v2fhUu2neo+2trqq7bBsRbjYdIqOU23+QMBGsmB65STatcfYjZa9Nca8GBhRKteQjMY9dpPEG8CQD9QzAFnQe5Lg==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1774273398; c=relaxed/relaxed;
	bh=J8rv5S3HJ9n7hKyfrpOjthQeFYGYmivvm0cHDYpF9ZQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S6J7RuqQPnkRdqo6ZWRh4a2hcTAIbv20wSDSrtHRuEA2hYrUCfyNEFs4T76NhkHgHkcpfsI+BwuB1/OHm6IAilnVGe8jiQAOchRyHMr0Dy1kMyfXMl0ahEJHbvrQdgD957Sz9iNJLugChaunmBVopYulO4Z5b5sS+Jj6G2cXiDyr22i77Pkm4HwJ+4Cxc11N/uUSk5jhiLBVXfLeJjga2pQXhoyJ4OJWI/hwt0J+svbqh2uVoIO1BDv+o9iqcY3JeG5WZOlgysAgkEsHuGZM7UmIwoc29PcbaIyGclKx5RlLXWPvOsH8NOsnqbKFVVQoQTz5ZbY05/no0Q/VTYveqw==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20201202 header.b=D1/as+cv; dkim-atps=neutral; spf=pass (client-ip=2600:3c04:e001:324:0:1991:8:25; helo=tor.source.kernel.org; envelope-from=mwalle@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20201202 header.b=D1/as+cv;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=2600:3c04:e001:324:0:1991:8:25; helo=tor.source.kernel.org; envelope-from=mwalle@kernel.org; receiver=lists.ozlabs.org)
Received: from tor.source.kernel.org (tor.source.kernel.org [IPv6:2600:3c04:e001:324:0:1991:8:25])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4ffZBF5m3Sz2xHX
	for <linux-erofs@lists.ozlabs.org>; Tue, 24 Mar 2026 00:43:17 +1100 (AEDT)
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 66320600C4;
	Mon, 23 Mar 2026 13:43:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E61AEC4CEF7;
	Mon, 23 Mar 2026 13:43:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774273395;
	bh=/cdDqnkmARcCVtIycTF2CQXXTceu5AYWx37gMowF26w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=D1/as+cvbEKNAInYdfsixz72l9Ql5aP4b+VRp7qoiKEK7LqB4MzEkvNfP0FQ+z74Q
	 JhIPH5vizYBKO7jPNAAoIKNWW79ODAWNbiIM7ad6iGYFZZSJMrx7/T4b1qk67MIrZm
	 KxZa5g8ISLzfwdZe0Wc7YqDi5TYn4sWFRrkdAyM+t8fktoSvE3MsMbqIJrWWg0yity
	 FM2U/B7Ug7nX/GobEK4rAZnpEPVvAQ+mwg4O2ydHEtJKSwf1c4+KOw7WTaeAmK15HW
	 HZJQsted2nlIUt2fdPYfDjl3VCjifBbQZEfTIyLYzhqHavkDbhvmsaSngQCuA+ZASY
	 wJ3CdEKTnU8sg==
From: Michael Walle <mwalle@kernel.org>
To: Huang Jianan <jnhuang95@gmail.com>,
	Tom Rini <trini@konsulko.com>
Cc: linux-erofs@lists.ozlabs.org,
	u-boot@lists.denx.de,
	Michael Walle <mwalle@kernel.org>
Subject: [PATCH 3/4] fs/erofs: allocate data buffers on heap with alignment (2/3)
Date: Mon, 23 Mar 2026 14:42:19 +0100
Message-ID: <20260323134305.2675822-4-mwalle@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260323134305.2675822-1-mwalle@kernel.org>
References: <20260323134305.2675822-1-mwalle@kernel.org>
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

The data buffers are used to transfer from or to hardware peripherals.
Often, there are restrictions on addresses, i.e. they have to be aligned
at a certain size. Thus, allocate the data on the heap instead of the
stack (at a random address alignment).

This will also have the benefit, that large data (4k) isn't eating up
the stack.

The actual change is split across multiple patches. This one allocates
the inode buffer on the heap. Before, if there was an extended inode,
the buffer was read incrementally. Now, as we need to have an aligned
buffer, the first part is just read again to keep the original buffer
address.

Signed-off-by: Michael Walle <mwalle@kernel.org>
---
 fs/erofs/namei.c | 21 +++++++++++++++------
 1 file changed, 15 insertions(+), 6 deletions(-)

diff --git a/fs/erofs/namei.c b/fs/erofs/namei.c
index b493ef97a09..7ce62955540 100644
--- a/fs/erofs/namei.c
+++ b/fs/erofs/namei.c
@@ -13,14 +13,20 @@ static dev_t erofs_new_decode_dev(u32 dev)
 int erofs_read_inode_from_disk(struct erofs_inode *vi)
 {
 	int ret, ifmt;
-	char buf[sizeof(struct erofs_inode_extended)];
+	char *buf;
 	struct erofs_inode_compact *dic;
 	struct erofs_inode_extended *die;
 	const erofs_off_t inode_loc = iloc(vi->nid);
 
+	buf = malloc_cache_aligned(sizeof(struct erofs_inode_extended));
+	if (!buf)
+		return -ENOMEM;
+
 	ret = erofs_dev_read(0, buf, inode_loc, sizeof(*dic));
-	if (ret < 0)
+	if (ret < 0) {
+		free(buf);
 		return -EIO;
+	}
 
 	dic = (struct erofs_inode_compact *)buf;
 	ifmt = le16_to_cpu(dic->i_format);
@@ -29,17 +35,18 @@ int erofs_read_inode_from_disk(struct erofs_inode *vi)
 	if (vi->datalayout >= EROFS_INODE_DATALAYOUT_MAX) {
 		erofs_err("unsupported datalayout %u of nid %llu",
 			  vi->datalayout, vi->nid | 0ULL);
+		free(buf);
 		return -EOPNOTSUPP;
 	}
 	switch (erofs_inode_version(ifmt)) {
 	case EROFS_INODE_LAYOUT_EXTENDED:
 		vi->inode_isize = sizeof(struct erofs_inode_extended);
 
-		ret = erofs_dev_read(0, buf + sizeof(*dic),
-				     inode_loc + sizeof(*dic),
-				     sizeof(*die) - sizeof(*dic));
-		if (ret < 0)
+		ret = erofs_dev_read(0, buf, inode_loc, sizeof(*die));
+		if (ret < 0) {
+			free(buf);
 			return -EIO;
+		}
 
 		die = (struct erofs_inode_extended *)buf;
 		vi->xattr_isize = erofs_xattr_ibody_size(die->i_xattr_icount);
@@ -113,6 +120,7 @@ int erofs_read_inode_from_disk(struct erofs_inode *vi)
 	default:
 		erofs_err("unsupported on-disk inode version %u of nid %llu",
 			  erofs_inode_version(ifmt), vi->nid | 0ULL);
+		free(buf);
 		return -EOPNOTSUPP;
 	}
 
@@ -121,6 +129,7 @@ int erofs_read_inode_from_disk(struct erofs_inode *vi)
 		if (vi->u.chunkformat & ~EROFS_CHUNK_FORMAT_ALL) {
 			erofs_err("unsupported chunk format %x of nid %llu",
 				  vi->u.chunkformat, vi->nid | 0ULL);
+			free(buf);
 			return -EOPNOTSUPP;
 		}
 		vi->u.chunkbits = sbi.blkszbits +
-- 
2.47.3


