Return-Path: <linux-erofs+bounces-4078-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F34EAC55162
	for <linux-erofs@archiver.kernel.org>; Sun,  2 Aug 2026 12:46:32 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hCfgp6bT9z2yh4;
	Sun, 02 Aug 2026 22:46:30 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=172.105.4.254
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1785674790;
	cv=none; b=DMxagoHNXsyEbtYmRtuGH80kVAauY5SiNdRMM1kOsuvE/PGyHUO5x6Cc13JZWs0yNfePRYCdGrkHPPkh02gALlKpLme1l5oHPiO/jpA9D1F05wvaSFg07uRGliSUWkP+MHPEKjoKfSB1qAgnocy5MS+ndrh2NeQvdPRXMJ+bho216TAyne1ONSfW4RXkDBzvznbpKWFxm/Xx1wW1RLaGzn7mcosDUJfA0gS4vPVjx5vo+bQzedY+MJUOdBNko0xVl2JL7uCy4DlgvVDPL2kQdwjsws3YtRSSlLaDqwPaO3hQ/2Ac+cp/LAQbMaghIl6APbBIVE2rnsmH0aj5g1yArw==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1785674790; c=relaxed/relaxed;
	bh=79U0b22dpozo0u3oAqL8dw7jqzk7QPSbO2I4aegrXIU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=CcmXanfgWYFfnPGr4Q513LcAilK666bX5diXDCjD6v4x5JNR7CqocSkn53Wc3gJ8+rqeK6em0dwcHACNObI6QNNaN2/NN/Qf1PgK1+JLIk+oupxOqZmIILMpig21kadLqzqaFYEk7IORI43dLz41FpYq69PrWYPDoWtOyUm1M1CiH4DmB6c7suEji5P+Pd0mGOTj/4eWH7O9biKVxwMm4IrWf/hK6LpwAi3iUvZn9xF3KuPhl1VYKjsNa659EYfUrAkJawU+8MF1IlgmshxsaTaKEO7GH6bkyMHeNUdrauAeD65XCoWwCemN2F4+bejgaGP69L+IoQ26hKaTZOrYzw==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QMIJtCAt; dkim-atps=neutral; spf=pass (client-ip=172.105.4.254; helo=tor.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QMIJtCAt;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=172.105.4.254; helo=tor.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org)
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hCfgn6Wnwz2yRC
	for <linux-erofs@lists.ozlabs.org>; Sun, 02 Aug 2026 22:46:29 +1000 (AEST)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 095DC60051
	for <linux-erofs@lists.ozlabs.org>; Sun,  2 Aug 2026 12:46:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 535D41F000E9;
	Sun,  2 Aug 2026 12:46:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785674785;
	bh=79U0b22dpozo0u3oAqL8dw7jqzk7QPSbO2I4aegrXIU=;
	h=From:To:Cc:Subject:Date;
	b=QMIJtCAtn6n9q17lWh7VT7D6Jm0BI46HcKQATM15K+6ngqlFEgm+MDag2+HNu3iTr
	 wicN1O4b9zxxH7opiR6jBg5crMK7Lobyo9CgiRGy2x4G/H5K6GS+U1eQrJ3tni7rQM
	 4qL5ECZ9zyYHVzbVrXWpnk5YHGlw0qqhEsjlcpur1/bBqyy1JsTX0zgrCiVl5EHdRR
	 yLmQO/plRlv2MY6cH+g0prZ/R8eSdd7RtrNSEd1GoYNQHFQqzcsehozoJQ6BHr9jA7
	 sMgfICR+09kUqIN7Bn8zN1A/Nu1Tt0nVMcZjVMcSx4lN/CZxbs35iQRhyyPDDDcEAT
	 YrzCqb0QGlA/g==
From: Gao Xiang <xiang@kernel.org>
To: linux-erofs@lists.ozlabs.org
Cc: Gao Xiang <xiang@kernel.org>
Subject: [PATCH] erofs-utils: lib: define unknown OS for GNU Hurd
Date: Sun,  2 Aug 2026 20:46:18 +0800
Message-ID: <20260802124618.40318-1-xiang@kernel.org>
X-Mailer: git-send-email 2.50.1
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

https://buildd.debian.org/status/fetch.php?pkg=erofs-utils&arch=hurd-amd64&ver=1.9.2-1&stamp=1783137028&raw=0

Signed-off-by: Gao Xiang <xiang@kernel.org>
---
 lib/remotes/oci.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/lib/remotes/oci.c b/lib/remotes/oci.c
index 80a1e38..d395581 100644
--- a/lib/remotes/oci.c
+++ b/lib/remotes/oci.c
@@ -1119,6 +1119,8 @@ const char *ocierofs_get_platform_spec(void)
 #define EROFS_OCI_OS "windows"
 #elif defined(__FreeBSD__)
 #define EROFS_OCI_OS "freebsd"
+#else
+#define EROFS_OCI_OS "unknown"
 #endif
 
 #if defined(__x86_64__) || defined(__amd64__)
-- 
2.50.1 (Apple Git-155)


