Return-Path: <linux-erofs+bounces-2948-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 80CCBEC01A6
	for <linux-erofs@archiver.kernel.org>; Mon, 23 Mar 2026 08:52:28 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4ffRkf57Jqz2ySb;
	Mon, 23 Mar 2026 19:52:26 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=95.143.211.150
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1774255946;
	cv=none; b=IEa72gFrlCjbSQQBmQeYONerj6U/EdpGlpw5ZKqqUUNURJcgCNynJmZPtWS5NtB3ce8+dMCy7VSJZWuDf+KPaAyoLRlVhNUgW9MJj4cs5Wkzc0HYYNwTujWhd6H+8/GAzndSmN++RwGaXCwIwvY7KcnO1qLXrbcWtktm5MDjRRT7RYKCwPTPGPhx8p+UnEH73M+nPFCe5hz8nRrxmcz5PEVDQU2kkD8eJT5at102gZb6cPJOxxV/V1U03MrP1gDtZNt1V4et8By9QsGpPBy0Ud3PEPWvr/GnlJJsZ3JCD0ajIlId1GBDVxzIl1NEfbbth5Q0NDj1F1PeMAGYWescKg==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1774255946; c=relaxed/relaxed;
	bh=lYIKaq6RqMCVMjkTrPjv9Za1ry2XEuhSkXIBu8VGE+g=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=T+Wfx92xGNIBVwzAoIXVDt0jXMTuzHg6ZY8iUWQy0XudD0SlRy3cOOWYA0ex8z/sii85QtTyUwVZ3LDO4GzVhJqlCtmPUtkBZTVTDj1enu9qY7szCrCEVU41T8kZZ3hYpltxIYQP4A6hWhucm8wpj/B3dD3me9aLhb9zKHjFd8CTJgH3azdQ6xsKe1sP9IKPOzIzeEeGCXkvp+RGAZGd1EFK8r3uQwH7adl45ELB9HPn7HsKf5BYCV0F5TjZolkCBszER7rp09z92KNraisFW6BAvDO/QTDF86xSkHXdhFTFkpNeAysEklOaYxVtvM/dvqQT3l0CkZ1p5uLlEPbVZQ==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=swemel.ru; dkim=pass (1024-bit key; unprotected) header.d=swemel.ru header.i=@swemel.ru header.a=rsa-sha256 header.s=mail header.b=lE4VlWy6; dkim-atps=neutral; spf=pass (client-ip=95.143.211.150; helo=mx.swemel.ru; envelope-from=arefev@swemel.ru; receiver=lists.ozlabs.org) smtp.mailfrom=swemel.ru
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=swemel.ru
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=swemel.ru header.i=@swemel.ru header.a=rsa-sha256 header.s=mail header.b=lE4VlWy6;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=swemel.ru (client-ip=95.143.211.150; helo=mx.swemel.ru; envelope-from=arefev@swemel.ru; receiver=lists.ozlabs.org)
Received: from mx.swemel.ru (mx.swemel.ru [95.143.211.150])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4ffRkd52Kmz2xly
	for <linux-erofs@lists.ozlabs.org>; Mon, 23 Mar 2026 19:52:24 +1100 (AEDT)
From: Denis Arefev <arefev@swemel.ru>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=swemel.ru; s=mail;
	t=1774255936;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=lYIKaq6RqMCVMjkTrPjv9Za1ry2XEuhSkXIBu8VGE+g=;
	b=lE4VlWy6ymbdvjugYdmL0BsXmqJ1Ea0QASXrHEV83UiKMkcLAbZEDUL5EJYr+YO2U1l0u0
	JQX2CKDjENkTbHDuEC2f3V/Y7RibpJ3Ulx5t/JeIkGTYejSjRDj33LG7lon7YyW0fA+Cq+
	xp9SkEbRh6AFvQoBm40NLjWqxkCp0XM=
To: stable@vger.kernel.org,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Gao Xiang <xiang@kernel.org>,
	Chao Yu <chao@kernel.org>,
	Jeffle Xu <jefflexu@linux.alibaba.com>,
	linux-erofs@lists.ozlabs.org,
	linux-kernel@vger.kernel.org,
	lvc-project@linuxtesting.org,
	syzbot+5b886a2e03529dbcef81@syzkaller.appspotmail.com
Subject: [PATCH 6.1] erofs: Fix the slab-out-of-bounds in drop_buffers()
Date: Mon, 23 Mar 2026 11:52:14 +0300
Message-ID: <20260323085216.7965-1-arefev@swemel.ru>
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

No upstream commit exists for this patch.

Syzbot reported that a KASAN slab-out-of-bounds bug was discovered in
the drop_buffers() function [1].

The root cause is that erofs_raw_access_aops does not define .release_folio
and .invalidate_folio. When using iomap-based operations, folio->private
may contain iomap-specific data rather than buffer_heads. Without special
handlers, the kernel may fall back to generic functions (such as 
drop_buffers), which incorrectly treat folio->private as a list of
buffer_head structures, leading to incorrect memory interpretation and
out-of-bounds access.

Fix this by explicitly setting .release_folio and .invalidate_folio to the
values of iomap_release_folio and iomap_invalidate_folio, respectively.

[1] https://syzkaller.appspot.com/x/report.txt?x=12e5a142580000 

Fixes: 7479c505b4ab ("fs: Convert iomap_readpage to iomap_read_folio")
Reported-by: syzbot+5b886a2e03529dbcef81@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?id=c6aeabd0c4ad2466f63a274faf2a123103f8fbf7
Signed-off-by: Denis Arefev <arefev@swemel.ru>
---
 fs/erofs/data.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/erofs/data.c b/fs/erofs/data.c
index 7b648bec61fd..302e824827fc 100644
--- a/fs/erofs/data.c
+++ b/fs/erofs/data.c
@@ -406,6 +406,8 @@ const struct address_space_operations erofs_raw_access_aops = {
 	.readahead = erofs_readahead,
 	.bmap = erofs_bmap,
 	.direct_IO = noop_direct_IO,
+	.release_folio = iomap_release_folio,
+	.invalidate_folio = iomap_invalidate_folio,
 };
 
 #ifdef CONFIG_FS_DAX
-- 
2.43.0


