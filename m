Return-Path: <linux-erofs+bounces-4220-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E3118C5CFC1
	for <linux-erofs@archiver.kernel.org>; Fri, 14 Aug 2026 07:00:50 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hLtRN6N28z2yD8;
	Fri, 14 Aug 2026 17:00:48 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2600:3c04:e001:324:0:1991:8:25"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1786690848;
	cv=none; b=aE6N6kg8jaQI9mYrYOX9U0Wxwn6bcJFPhYxwdObKjJezkAUUujWvJjtiwEJuOeikd7xHvbtBIOVwZ/OrL3/fPWfkV5a6tXIHELqqg73iENYbqzXTKrhqYMmwYUMUXzoggwqccnLhsXKIUuB8VkgnLCzSU1vetbZNOnu8PzZ7gY8Bae8vLpmqMROXpQl22lIB6WHfCPz3hsVt2l4c8k2XUX9QiK7p6olCvm0HPWTdmIim9vNNq+spB/IG+kHylUG6LQ8hAiGBcXUaV+mDyRXU8d0QU8voyXanFLa1fWVG6sRlNedvvYY5C+oc0O/lw1U4OukLKXX5bF5SlA5jTUpVXA==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1786690848; c=relaxed/relaxed;
	bh=DMchTTGVCMvOtRC0iT99gWsRNfqufDGghfJVlAoNEtg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=JB2av1p6TSnInmKJMP4o7C48ptm2lMdYDUHDWgRIZchC0KG9THtPFoW0IrbDutOksOEDtwxgNVYhBzT2IzQL8JOcOwrDYfpHKPAfF18h5brFd4IEUkbhkStasBBfXqe+dTTL1jekoxpWexY91XL609AfYkgxuT5CET/Qhq821AsqGL8WHOVOhZIS052eTVhgyoWqW321mUPjs4UKLKT5LGGUEzOYP6ABGO2tQzyRTE82f8BFcKzIJ5ryOALHHOC9FNS9Z2Tvs4ECpFG6jCvIxjvLdc/WDDMGXnEMhWYtBcJsNvXA5mvf5ihCKalPh9wet8iF8qLPZFCVB70c0uPS9Q==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HFArCfYA; dkim-atps=neutral; spf=pass (client-ip=2600:3c04:e001:324:0:1991:8:25; helo=tor.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HFArCfYA;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=2600:3c04:e001:324:0:1991:8:25; helo=tor.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org)
Received: from tor.source.kernel.org (tor.source.kernel.org [IPv6:2600:3c04:e001:324:0:1991:8:25])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hLtRM6Y6Fz2xnv
	for <linux-erofs@lists.ozlabs.org>; Fri, 14 Aug 2026 17:00:47 +1000 (AEST)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 1C143600AD;
	Fri, 14 Aug 2026 07:00:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BA7B1F000E9;
	Fri, 14 Aug 2026 07:00:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786690843;
	bh=DMchTTGVCMvOtRC0iT99gWsRNfqufDGghfJVlAoNEtg=;
	h=From:To:Cc:Subject:Date;
	b=HFArCfYAU0/QmoO7sKGAsGFjVG3YFtGlycZ7NYmd5DTOCcXx8jstHMbGpBPbrbCl4
	 6Hc2ZI20crRt/b5HRc7+nuAPIhg8AdMX7NIEUcSd6YIl0pCYuYKhupUE5ZMd5oraHp
	 mxSoF72HQv81vYWNL8Rfg9t78aTpw+9b6HfmRN/3MUo8TRnQH8C73PJ240epWekLFp
	 EhkXYHLaVdyt2SS7bp9xApi5MWbfg8guD1a+YAGFqkFRatgsta1irkT7xz3cK5kHQz
	 nRKnCGvuWtupQLOdd7VUlRI/O1eSpRAnXS3Wl8uO1439Po/cNo2WgywYrUiroTQ82V
	 OJznwytmcQ2Hw==
From: Gao Xiang <xiang@kernel.org>
To: linux-erofs@lists.ozlabs.org
Cc: LKML <linux-kernel@vger.kernel.org>,
	Gao Xiang <xiang@kernel.org>,
	Haiyang Huang <huanghaiyang83@gmail.com>
Subject: [PATCH] erofs: fix interlaced ztailpacking pclusters
Date: Fri, 14 Aug 2026 14:59:46 +0800
Message-ID: <20260814065946.78216-1-xiang@kernel.org>
X-Mailer: git-send-email 2.47.3
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

On-disk sizes of interlaced pclusters should be block-aligned, and
ztailpacking interlaced pclusters should be invalid at all.

Currently, mkfs.erofs won't generate any interlaced pcluster with
ztailpacking enabled, so this doesn't affect any existing valid
filesystems.

However, crafted images can contain invalid interlaced ztailpacking
pclusters, resulting in an out-of-bounds read from a kmap'd page and
copying irrelevant kernel memory into userspace-visible page cache.

Reported-by: Haiyang Huang <huanghaiyang83@gmail.com>
Closes: https://lore.kernel.org/r/20260806065253.1083865-1-huanghaiyang83@gmail.com
Fixes: fdffc091e6f9 ("erofs: support interlaced uncompressed data for compressed files")
Signed-off-by: Gao Xiang <xiang@kernel.org>
---
 fs/erofs/decompressor.c | 1 +
 fs/erofs/zmap.c         | 3 ++-
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/erofs/decompressor.c b/fs/erofs/decompressor.c
index 3c54e95964c9..27caf4bebddc 100644
--- a/fs/erofs/decompressor.c
+++ b/fs/erofs/decompressor.c
@@ -299,6 +299,7 @@ static const char *z_erofs_transform_plain(struct z_erofs_decompress_req *rq,
 		return ERR_PTR(-EOPNOTSUPP);
 	if (rq->alg == Z_EROFS_COMPRESSION_INTERLACED) {
 		cur = bs - (rq->pageofs_out & (bs - 1));
+		DBG_BUGON(rq->pageofs_in & (bs - 1));
 		pi = (rq->pageofs_in + rq->inputsize - cur) & ~PAGE_MASK;
 		cur = min(cur, rq->outputsize);
 		if (cur && rq->out[0]) {
diff --git a/fs/erofs/zmap.c b/fs/erofs/zmap.c
index 5811556a7b71..331a231dfe13 100644
--- a/fs/erofs/zmap.c
+++ b/fs/erofs/zmap.c
@@ -483,7 +483,8 @@ static int z_erofs_map_blocks_fo(struct inode *inode,
 	}
 
 	if (m.headtype == Z_EROFS_LCLUSTER_TYPE_PLAIN) {
-		if (vi->z_advise & Z_EROFS_ADVISE_INTERLACED_PCLUSTER)
+		if (vi->z_advise & Z_EROFS_ADVISE_INTERLACED_PCLUSTER &&
+		    !(map->m_flags & EROFS_MAP_META))
 			map->m_algorithmformat = Z_EROFS_COMPRESSION_INTERLACED;
 		else
 			map->m_algorithmformat = Z_EROFS_COMPRESSION_SHIFTED;
-- 
2.47.3


