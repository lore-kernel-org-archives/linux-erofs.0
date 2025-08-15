Return-Path: <linux-erofs+bounces-816-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A40F5CA0EE6
	for <linux-erofs@archiver.kernel.org>; Fri, 15 Aug 2025 09:04:35 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4c3GQB1dpvz3cZy;
	Fri, 15 Aug 2025 19:04:34 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=81.70.192.198
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1755248674;
	cv=none; b=lbRxmXC/s+etc6KMSjrMUaBSBfZTfbWeWBabwC3IX9M/WzesomNMRqg7lFssafrkoS+pF3V9e5FjP21mRSGftkXDZMhlHXSN63EwkFApq9hlD9VNaGEZON3TdL6nZkNA09YE7wYtUK5Y7HcW/dFYG27Y6g3uazKijgmmqUXMMpF+liw1kI8/VrCfKev76BTtm8grbUa64yFItTStL5OkX3wlwPCjda8BAsqUkivg8nLYH+VLNvYKyOK9V7H4u6gNgPIHua7RuivBz+yaE8vQ5GG8IIeXzUcD4Z5lzSeY31S1MJOWrmOU0D2qd8QBgsNZFiTfWMb54yYf/mtE9mcd1w==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1755248674; c=relaxed/relaxed;
	bh=EWyW12dxPU8RlIvjfJJm1VuXzzJxRfb/9iaexuAHY6w=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=GIJzWnLYgrrouZAGG3Ple1E3MUneyYbgA2wh/D6mBAXY/ThTwoPfw8br5hTF4O/lCDPq7FUWOZ4w/R55p9scUNdBER791RPWzcBpaA1mnlA+FIs9ZJLmEdg8TP0vIbiCj95YtHISEDHY1KODcwT3mY3aV2StSzUN/2GIlj/UoaJex4qWFa26ZSMslE3Ue+OW62pwqqrSzwp862NIFodcoA8vOUtxxrcek/LU1I0UJFonmOpBMFnascGlBzg95SC5HlXkqvp0d9pPHY76s3QRnAUH6X/y5qnD4SY/bvqjIKch0YT+++xhHKysFthSZKBIsXmZcTKJMH5kPA13rA+xJQ==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=honor.com; dkim=pass (1024-bit key; unprotected) header.d=honor.com header.i=@honor.com header.a=rsa-sha256 header.s=dkim header.b=jiinbMcV; dkim-atps=neutral; spf=pass (client-ip=81.70.192.198; helo=mta22.hihonor.com; envelope-from=wangzijie1@honor.com; receiver=lists.ozlabs.org) smtp.mailfrom=honor.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=honor.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=honor.com header.i=@honor.com header.a=rsa-sha256 header.s=dkim header.b=jiinbMcV;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=honor.com (client-ip=81.70.192.198; helo=mta22.hihonor.com; envelope-from=wangzijie1@honor.com; receiver=lists.ozlabs.org)
X-Greylist: delayed 1191 seconds by postgrey-1.37 at boromir; Fri, 15 Aug 2025 19:04:32 AEST
Received: from mta22.hihonor.com (mta22.honor.com [81.70.192.198])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits))
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4c3GQ83p8Rz3cZs
	for <linux-erofs@lists.ozlabs.org>; Fri, 15 Aug 2025 19:04:31 +1000 (AEST)
dkim-signature: v=1; a=rsa-sha256; d=honor.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=To:From;
	bh=EWyW12dxPU8RlIvjfJJm1VuXzzJxRfb/9iaexuAHY6w=;
	b=jiinbMcVV1v68AksO1MKu+TJFl+HB3Nx0Ecmd2VJI9RZ0DJzLuDly3r8w3gWVl+xfctGQYJBc
	1FKX8OboszKGndBl0/GGLlHtQhZPQozsYzVQ7ofMea8QAOAnjQdEz17+/b0M4luBXH7LyOgsGsR
	Up984N00pxrlgAesbr4FpB8=
Received: from mta21.hihonor.com (unknown [172.31.16.11])
	by mta22.hihonor.com (SkyGuard) with ESMTPS id 4c3Fz22xcpzYl0FH
	for <linux-erofs@lists.ozlabs.org>; Fri, 15 Aug 2025 16:44:30 +0800 (CST)
Received: from w012.hihonor.com (unknown [10.68.27.189])
	by mta21.hihonor.com (SkyGuard) with ESMTPS id 4c3Fys37nxzYl7Cm;
	Fri, 15 Aug 2025 16:44:21 +0800 (CST)
Received: from a011.hihonor.com (10.68.31.243) by w012.hihonor.com
 (10.68.27.189) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Fri, 15 Aug
 2025 16:44:29 +0800
Received: from localhost.localdomain (10.144.23.14) by a011.hihonor.com
 (10.68.31.243) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Fri, 15 Aug
 2025 16:44:29 +0800
From: wangzijie <wangzijie1@honor.com>
To: <xiang@kernel.org>
CC: <linux-erofs@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>,
	<bintian.wang@honor.com>, <feng.han@honor.com>, wangzijie
	<wangzijie1@honor.com>
Subject: [PATCH] erofs-utils: avoid redundant memcpy and sha256() for dedupe
Date: Fri, 15 Aug 2025 16:44:28 +0800
Message-ID: <20250815084428.4157034-1-wangzijie1@honor.com>
X-Mailer: git-send-email 2.25.1
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
Content-Type: text/plain
X-Originating-IP: [10.144.23.14]
X-ClientProxiedBy: w010.hihonor.com (10.68.28.113) To a011.hihonor.com
 (10.68.31.243)

We have already use xxh64() for filtering first for dedupe, when we
need to skip the same xxh64 hash, no need to do memcpy and sha256(),
relocate the code to avoid it.

Signed-off-by: wangzijie <wangzijie1@honor.com>
---
 lib/dedupe.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/lib/dedupe.c b/lib/dedupe.c
index 074cae3..bdd890c 100644
--- a/lib/dedupe.c
+++ b/lib/dedupe.c
@@ -162,18 +162,9 @@ int z_erofs_dedupe_insert(struct z_erofs_inmem_extent *e,
 	if (!di)
 		return -ENOMEM;
 
-	di->original_length = e->length;
-	erofs_sha256(original_data, window_size, di->prefix_sha256);
-
 	di->prefix_xxh64 = xxh64(original_data, window_size, 0);
 	di->hash = erofs_rolling_hash_init(original_data,
 			window_size, true);
-	memcpy(di->extra_data, original_data + window_size,
-	       e->length - window_size);
-	di->pstart = e->pstart;
-	di->plen = e->plen;
-	di->partial = e->partial;
-	di->raw = e->raw;
 
 	/* skip the same xxh64 hash */
 	p = &dedupe_tree[di->hash & (ARRAY_SIZE(dedupe_tree) - 1)];
@@ -183,6 +174,15 @@ int z_erofs_dedupe_insert(struct z_erofs_inmem_extent *e,
 			return 0;
 		}
 	}
+
+	di->original_length = e->length;
+	erofs_sha256(original_data, window_size, di->prefix_sha256);
+	memcpy(di->extra_data, original_data + window_size,
+	       e->length - window_size);
+	di->pstart = e->pstart;
+	di->plen = e->plen;
+	di->partial = e->partial;
+	di->raw = e->raw;
 	di->chain = dedupe_subtree;
 	dedupe_subtree = di;
 	list_add_tail(&di->list, p);
-- 
2.25.1


