Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DBF3606A31C
	for <linux-erofs@archiver.kernel.org>; Tue, 17 Nov 2026 07:27:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=yrGFHWM9
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4jTGX01FJzz2y8m;
	Tue, 17 Nov 2026 18:27:12 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2607:f8b0:4864:20::435"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1794900432;
	cv=none; b=LvmoT5b9OJsVvUAuDYp3P+a/7mtn5hp6nrb/NLranjaN0yJhpX5Eeh9Evgzgja6uTsOBSzvsrSP1CCzQo5xc6EwALQ3Qlf7ikTcNk/KzZ/Sc7r5ZBY4t3hN0M8cMOxTPkH+QdAINBkF691/2kvfeIn89kOh1JBB83NFGSaQxqDhgtYGr++syljRvHo3ff8fZr/hENJMQfcfJhs92zYRnblJUNdkctMuJlzWwKbO/BVfJOsUykYg9vpfCenKmnKTTCNc9QfPoP58f4tdTinXM5twhDX3KG/ocNPV/38JpgEWg7ev73EKW4H0S59CGdHSUvo6TexlsMX3cCqIk00TYgw==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1794900432; c=relaxed/relaxed;
	bh=jglvphpcUZgDz7gFdvmHWk/lDD+mZ+01eDVH8E1lSDs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hpgXPrYk5qp92NR9kg1KF+pq2XVeT1WTUVoKXMBZ1oR1C2pKUIGh4wQppwui6t4fBkv/d2Ycu8o4X8H6NkJQvy1teW5axmD2LdRBu/2ch/hgLsauYIx3+UW2wp1aXfGtfv5f3ybLG9x/TRI91kz6l2FUex56OWCLM0AqsBAzNERiCqWiO6hQujvndrcCFm5MJ82cHKqZzIPRyfxINZTF1A5W9BA2vsuAW0fCFdYOIcqhicir7EGuYVbYK4a3z4YwTCrHC05tV/bin2GqmlF6gcj+K8gLz2A9aAl1sLONO62Zhqc7poWkGh4iZE36FMNZ9IMeNBS1JvhH9nEwnicH4w==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=gmail.com; dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=yrGFHWM9; dkim-atps=neutral; spf=pass (client-ip=2607:f8b0:4864:20::435; helo=mail-pf1-x435.google.com; envelope-from=stopire@gmail.com; receiver=lists.ozlabs.org) smtp.mailfrom=gmail.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=yrGFHWM9;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=gmail.com (client-ip=2607:f8b0:4864:20::435; helo=mail-pf1-x435.google.com; envelope-from=stopire@gmail.com; receiver=lists.ozlabs.org)
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4jTGWz3XLCz2xPb
	for <linux-erofs@lists.ozlabs.org>; Tue, 17 Nov 2026 18:27:11 +1100 (AEDT)
Received: by mail-pf1-x435.google.com with SMTP id d2e1a72fcca58-8b66d1a08ccso4052215b3a.1
        for <linux-erofs@lists.ozlabs.org>; Mon, 16 Nov 2026 23:27:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794900430; x=1795505230; darn=lists.ozlabs.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=jglvphpcUZgDz7gFdvmHWk/lDD+mZ+01eDVH8E1lSDs=;
        b=yrGFHWM9F5oQw4G9pRWrbejh+B8YAOrlkSttJJxRQWvq5kKKiQeZpzYshhEI6eUXVo
         r7NMgxiLUoULn5fQy3p4cSQc2YQcucaU2T07YhRoHndJDYBHcD/Z2AvYk9t3cmayZhaX
         UX/otsDzknRANluf87Om7H5vH0m5QVgmBFk1mzkzUwXwMixKE5CADN2DF7Hlv3YMLXZm
         R8D5tfPCQpet92guZDowlzgAvFWpR8Btdn8+8Jovn+I9FCWDP+kF6qRsVFZlb8v5hfA9
         TR/Si48tcMJFhaKvxVnhhxWtQ4XXqbccLWPUPjaIRTcoSDS8Ynqkt8IiVkfAgHJKftzE
         xVIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794900430; x=1795505230;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=jglvphpcUZgDz7gFdvmHWk/lDD+mZ+01eDVH8E1lSDs=;
        b=uKCoJgnkZXHdrDQFGKKkGRUyZNRaa/2g2FlIUR6zXwQ+TB6ruYw6TCOyqgr+4D4HgA
         9ZKm7+GYJFi0cVr9tzprNHEUUh8teetteLhbecQxOmScpHSKmJVPY9NmFwBTbq4jsPng
         9dZco5iEWZQ3XmepwRXcFGtTXaB0axVTeEqUqbx8OVIQCb7v/uOP2avMpUv83UGy7/vP
         4dqmmro7K4WsspNBIJckzxLzs67y5SqcQ1RgP8RfyMtnjasTjSIyYA1veWjXRkApIxBa
         YJU14FqPle54Y5RtQPVUFF9wdf5mRszYa6cH3p1Pni/02sSCLYZbzS9reUpRRKWdB58e
         gF8w==
X-Gm-Message-State: APuU4Z/fr1+zWBgueP7zHpRxXAiuD5h0w19zJ1JHic5y7+FrQ4Zq5rUM
	IjMEVK4iLuZv14Dzj5mOwoBSCwAGeOzakrRCBmh1LZzgbaFQ89nDreUayO9IhXSJR2A=
X-Gm-Gg: AYBFou0RbIj4asNKMACBKT/Rydf4WdxQ8QfKFbsELQtm5k4XFn/uKetPJIgaD8mDC5b
	n/mevtB5wEfUIx86Oy8i1MnB4s2UfLklS0jVXnoCLqIZeRnpnO0tlY3+1lvS6l2PF0nl+N+dBxw
	z99gXzGXxevXAAlaRft/5GtqEjnWUunhgXi5o8EjVYXO0PlEGRBAuQOQ79rv1ppodPeNw1NAu1T
	YYoyvrzgO6w/LJP3ViKfKaiQDeDVc90I8b40Zv/5+FCIcj1FOiYzLqByRuOE9TKx/cXOtj+ToxA
	CeDMMgeN6j2w0ugLTzNUhKQqucZPl7GhoKP/aMO7gKTneJ4WcnOhGpuLR+/33tFsgOKvrFQK3gC
	zweNOr1DWYaACMRLsht5KQoqp4TlxlrT9sp+95R+6oZ5jKjLgH3lp1FxA6gEFIugn1D9dXh60o+
	lV2vL+CYf2E2wNQA0pVIJHezb0+s3rT8qspx4SydI7t2EfOmtm/ov9AmvDcQOAKyU0za7lA0OC0
	aq2NZP5PIpjLKdV5AYiUEcmgtGN/8A3COvZWmFk0708ian71Uxe05MxPwY/IABC546Knz9ck3V6
	X0cX0Hytl3dXnZCb8nHzrMHCGzWSSZWenXiNcZfZ4NCU/hBK8V2AiA/dkNjIjSWxo5cwtw==
X-Received: by 2002:a05:6a00:2350:b0:897:ffff:c18a with SMTP id d2e1a72fcca58-8beb3b3cea5mr11567215b3a.7.1794900429741;
        Mon, 16 Nov 2026 23:27:09 -0800 (PST)
Received: from zyf-laptop.tail52ade4.ts.net ([124.70.231.56])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8bed2055031sm4940716b3a.39.2026.11.16.23.27.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Nov 2026 23:27:09 -0800 (PST)
From: Yifan Zhao <stopire@gmail.com>
To: linux-erofs@lists.ozlabs.org
Cc: xiang@kernel.org,
	Yifan Zhao <stopire@gmail.com>
Subject: [PATCH v2 6/9] erofs-utils: lib: fix __erofs_io_pwrite() caller error handling
Date: Tue, 17 Nov 2026 15:26:26 +0800
Message-ID: <1a9077f1bec8b028432a866ad36ed4376462ce99.1794899782.git.stopire@gmail.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <cover.1794899782.git.stopire@gmail.com>
References: <20261112124725.2774244-1-stopire@gmail.com> <cover.1794899782.git.stopire@gmail.com>
X-Mailing-List: linux-erofs@lists.ozlabs.org
List-Id: <linux-erofs.lists.ozlabs.org>
List-Help: <mailto:linux-erofs+help@lists.ozlabs.org>
List-Owner: <mailto:linux-erofs+owner@lists.ozlabs.org>
List-Post: <mailto:linux-erofs@lists.ozlabs.org>
List-Subscribe: <mailto:linux-erofs+subscribe@lists.ozlabs.org>,
  <mailto:linux-erofs+subscribe-digest@lists.ozlabs.org>,
  <mailto:linux-erofs+subscribe-nomail@lists.ozlabs.org>
Precedence: list
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Propagate the negative error codes returned by __erofs_io_pwrite()
instead of reading errno again.

Fixes: bfc94a2580c0 ("erofs-utils: lib: track packed inode position explicitly")
Assisted-by: Codex:gpt-6-astra
Signed-off-by: Yifan Zhao <stopire@gmail.com>
---
 lib/fragments.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/lib/fragments.c b/lib/fragments.c
index 090c135..9f83afe 100644
--- a/lib/fragments.c
+++ b/lib/fragments.c
@@ -350,7 +350,7 @@ int erofs_fragment_commit(struct erofs_inode *inode, u32 tofh)
 	ret = __erofs_io_pwrite(epi->fd, fi->data, fi->length, offset);
 	if (ret != fi->length) {
 		if (ret < 0)
-			return -errno;
+			return ret;
 		return -EIO;
 	}
 	offset += fi->length;
@@ -558,7 +558,6 @@ static void *erofs_packedfile_preload(struct erofs_inode *pi,
 
 	err = __erofs_io_pwrite(epi->fd, buffer, map->m_llen, map->m_la);
 	if (err < 0) {
-		err = -errno;
 		if (err == -ENOSPC) {
 			memset(epi->uptodate, 0, epi->uptodate_bits >> 3);
 			(void)!ftruncate(epi->fd, 0);
-- 
2.56.0


