Return-Path: <linux-erofs+bounces-2960-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 27455F4611C
	for <linux-erofs@archiver.kernel.org>; Mon, 23 Mar 2026 13:59:46 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4ffZYF4Mlwz2ySc;
	Tue, 24 Mar 2026 00:59:45 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=95.143.211.150
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1774274385;
	cv=none; b=Np3IAezhN9wjqa5uXqC4Zy4Pz8ILcfBdxwZjUQXQyQHC3HlQx+swyC3Btwc1YL5mlzBFT4xmbqse2hQOtVB6ckEtmXU+OCtfa/aG5DDV5YbFuXS4ARZ2An+SrpP2dyTuibUAuZyp9snnReqJH/fdcoB0dBner2aXMFFKr4EUYo0W0zq++gAcJL3D0jpwXRWvv7J+vcPaBAXx3vAmp5JbYzbrhWFbki/MdrMLQcYJ6FxfIwOnou7Krvv/Nb75seStepUVc0FkbkRZd6MBPHkOSfgbmFSHFElcoODZBgHKzLOnqHokIKl3Y58nkOb/aiNhOlatbbPfrRERsyx2/fbWMA==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1774274385; c=relaxed/relaxed;
	bh=XrJO6oMsQ2sRU4j9Zgoq35iSBOIxZIi6ev2XEDqg5CM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=QflLxA9qXmBBfBJsz6wPTyZwTxOZfl9Nl7PajjN7S5fo8R1NMPiNhktAtffzO1Ad+C47UD0z3ZlTXTcPOvGHrM4idmPZKJ/SayR/UTUbpWsEJqbZXThmwSaOso2qY7SpSDYSE7o5a2aWMCh4Haz5z3V+jhlEmYBV9mHomOsJBuL0V5BfHpTdBxjG9+Q726+QVgnaNRSVFKYLTo78Xa4v/CwiXGboWkwaymvYoWou8bo21IjEIE7a7DeXtMWoDIvXWIR/9cQ6ZIzvAnB1QTZN6pOdmMQ63nho2Q93FhaqpswaqNh7QVgyS20+GnqypftGhlQk25dKdjp/RjSgyHseXQ==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=swemel.ru; dkim=pass (1024-bit key; unprotected) header.d=swemel.ru header.i=@swemel.ru header.a=rsa-sha256 header.s=mail header.b=Y/MSeeoW; dkim-atps=neutral; spf=pass (client-ip=95.143.211.150; helo=mx.swemel.ru; envelope-from=arefev@swemel.ru; receiver=lists.ozlabs.org) smtp.mailfrom=swemel.ru
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=swemel.ru
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=swemel.ru header.i=@swemel.ru header.a=rsa-sha256 header.s=mail header.b=Y/MSeeoW;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=swemel.ru (client-ip=95.143.211.150; helo=mx.swemel.ru; envelope-from=arefev@swemel.ru; receiver=lists.ozlabs.org)
Received: from mx.swemel.ru (mx.swemel.ru [95.143.211.150])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4ffZYB6612z2xQ1
	for <linux-erofs@lists.ozlabs.org>; Tue, 24 Mar 2026 00:59:41 +1100 (AEDT)
From: Denis Arefev <arefev@swemel.ru>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=swemel.ru; s=mail;
	t=1774274377;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=XrJO6oMsQ2sRU4j9Zgoq35iSBOIxZIi6ev2XEDqg5CM=;
	b=Y/MSeeoWxH43lJWsYpqNeMBuaGij5+XGn7zn8n3L5sDVlc9H3c/LSdj0mBThAFnQ6NVdg7
	07uyBXOUtfUxQB2t3h4Es3NiYCsXfSdbH2swrlYpiNfJD/MKDBmWl/w+5F8kCJ22xJ5/1B
	KJ45h0tSM2HyHZYiwFECsrkc/Q4Es+g=
To: stable@vger.kernel.org,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Gao Xiang <xiang@kernel.org>,
	Chao Yu <chao@kernel.org>,
	Jeffle Xu <jefflexu@linux.alibaba.com>,
	linux-erofs@lists.ozlabs.org,
	linux-kernel@vger.kernel.org,
	lvc-project@linuxtesting.org,
	syzbot+5b886a2e03529dbcef81@syzkaller.appspotmail.com
Subject: [PATCH v2 6.1] erofs: Fix the slab-out-of-bounds in drop_buffers()
Date: Mon, 23 Mar 2026 16:59:35 +0300
Message-ID: <20260323135936.15070-1-arefev@swemel.ru>
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

commit ce529cc25b184e93397b94a8a322128fc0095cbb upstream.

This was accidentally fixed in commit ce529cc25b18, but it's not possible
to accept all the changes, due to the lack of large folios support for 
Linux 6.1 kernels, so this is only the actual bug fix that's needed.

[Background]

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


