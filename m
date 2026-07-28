Return-Path: <linux-erofs+bounces-4027-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9B616C54F4C
	for <linux-erofs@archiver.kernel.org>; Tue, 28 Jul 2026 15:41:27 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4h8fnx5gHdz2xyh;
	Wed, 29 Jul 2026 01:41:25 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=172.105.4.254
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1785253285;
	cv=none; b=Y8lxCLBEp7cuBQkfUiFoR/556cn69deO58+CGmbdaVwNjD0BJvHVmMXvDcrT2Qnh0f+dhaHp9wPf3VM8BA0H+kDWjuu65MtTq5XctFLma2hMLQ/t/HDcmfsEb12sJnNq4aVYpomIRAwItRQQUfIfijNLKSVlt3ixrg8h3qXdPpQ5eriMAozVcbZzFqPPD/UHDm+el0ywfLYtf2A5bDjGjS4vGGDTxoAmkoyBtI6ELKurHZFry+zPydEYAqrc4d3R4j0OmHd5ubClQOR6ZdiYsou6P4p7rURG2GDqNYZGcvQiCwhZgB+DU3FQgS8NqAjNlSEb4h0OqOaXnfhXCNxekA==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1785253285; c=relaxed/relaxed;
	bh=ftY/yQPQio0DoCsyDQ/VD3hXhs9YFgYbwQDnd3UUfJo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=kd9nWRM7n6RRJB3Wq6s+bv+jZYqWAfslCIM9AkLhkmK1d422Br0cinUeAmRV03m0E/95a30AleEER6i+UHynxzgUtjM9/aezidYEJa7daNCnp1HQZ0CAInJw7xGWfrwNRxUCE3WpPD5I3mOygcKbcc5hWgC/SJE1j1rNLtqOn7ca1+S/q+U+kmxbcjuQnAKxsUdt0c6h65SH6GLth/PcS5d8mPq1YkoEM/PREXpH5DqHQcfHPsNZ1m1T4JQhSXQAbQMuwHmgKfgeqXspEUyxM+XdadR7yq5/1y6x5xIrM4zWP0uQy1D0mfEQ2g0oiThAof81cCAqjb3sPEeFXDoknw==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GuHSxTI0; dkim-atps=neutral; spf=pass (client-ip=172.105.4.254; helo=tor.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GuHSxTI0;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=172.105.4.254; helo=tor.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org)
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4h8fnw2z6Lz2xYg
	for <linux-erofs@lists.ozlabs.org>; Wed, 29 Jul 2026 01:41:24 +1000 (AEST)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D9C676001A
	for <linux-erofs@lists.ozlabs.org>; Tue, 28 Jul 2026 15:41:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDE521F000E9;
	Tue, 28 Jul 2026 15:41:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785253281;
	bh=ftY/yQPQio0DoCsyDQ/VD3hXhs9YFgYbwQDnd3UUfJo=;
	h=From:To:Cc:Subject:Date;
	b=GuHSxTI0pFc8sMR3UdXFIwHH0yd6139sYuyFcfi3wSvoioxjG8H2k++zvhfIU7+p/
	 juREHldx9XdU0kGp7fdzxm2OISHLGweU205OnVpBRI0x0h3vViArtNi09SqOBnNSvW
	 Lqm64WNeO0WuSHjDKTDIDZnkfHVgay+Wv+C9LvQyiLOwruhDEgJtO4DFDGVIvJ+rnR
	 TXMPbJVqaY0FgauN2LbZOZbB5iExRVhs4yZN/rxcvTZh5f5OgkZEdevAkUkcBi/NXv
	 M2yFMqDMpkETVwPFZlJS+uGuFZvzZ1vDnRHThgDS1KhNZv+EQIecoNK9bUsUTnZq4J
	 PaE3YHvX6wWLw==
From: Gao Xiang <xiang@kernel.org>
To: linux-erofs@lists.ozlabs.org
Cc: Gao Xiang <xiang@kernel.org>
Subject: [PATCH] erofs-utils: mkfs: fix `--incremental=data` failure
Date: Tue, 28 Jul 2026 23:40:32 +0800
Message-ID: <20260728154032.73630-1-xiang@kernel.org>
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

`idata_size` should be set for erofs_prepare_tail_block().

Fixes: c16df072941f ("erofs-utils: mkfs: support directory compression")
Signed-off-by: Gao Xiang <xiang@kernel.org>
---
 lib/inode.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/lib/inode.c b/lib/inode.c
index 9f4d14c..0547b60 100644
--- a/lib/inode.c
+++ b/lib/inode.c
@@ -1605,7 +1605,8 @@ static int erofs_mkfs_create_directory(const struct erofs_mkfs_btctx *ctx,
 	}
 
 	/* it will be used in erofs_prepare_inode_buffer */
-	if (inode->datalayout == EROFS_INODE_FLAT_INLINE)
+	if (inode->datalayout == EROFS_INODE_FLAT_INLINE ||
+	    inode->datalayout == EROFS_INODE_FLAT_PLAIN)
 		inode->idata_size = inode->i_size & (bsz - 1);
 
 	/*
-- 
2.47.3


