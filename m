Return-Path: <linux-erofs+bounces-4147-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D4DF5C55838
	for <linux-erofs@archiver.kernel.org>; Thu,  6 Aug 2026 06:55:09 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hFyhW2k3Cz304x;
	Thu, 06 Aug 2026 16:55:07 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2607:f8b0:4864:39::b"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1785999307;
	cv=none; b=DX58HgSVV8HoCRI8CmVLuYefwt1/XJPO+ClfDHbssqYzHvpNb9hLL0nvE648bhngyi7GEgmfyFpJ396TizB9mzvXT1bHwtN6yzzCD1TjigyJo/NKffzCfyd7vyEBn4AKXBZVUzEQ6c2QZCmwGSF8k5PdqjD7fj53hb7ISVeLAPxhzqcrRWUKqaTTm7sNU88eAuR1JL/gxcrdwPqiiyTraSJBtY9dcsjISTRG7Mln3f/Qpn58VM3sx5ZHYowhTUZhFP5xPo/a/HN0UFfbLKXN2Hm67jPnZjPjWhSZXmipZBYJNS6+7Oxo7P0gLLsGTd9NSuo1lYtUc3dmyQ/NyZ2asw==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1785999307; c=relaxed/relaxed;
	bh=LHiVelN5mh9CVmWnGQoTnlP7xVCZ+d8Y4Ey2Z8wrXTE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=XefuhAYUeM0XJjmfLMyDYhQkGESih4pPdqP5Atqpe66jWh89dWD4XSCD8joI+nWwzRbkeMmxbSGbFk7B8FE9JiduFoilkBti+giaOLgylYo2UousGHQ2quxs3RjKDnYSHdap5uD+MPpYS/LF6liygByxRIYL8Zx168vg6P2D/PSeNL6UH+GK7D1S6PwkxEnbalCfnRe4zF+NyVSb3+KWLfcCSR84Eqo3syMT+AWE1J8ed9Y/PgcxfDIaB2qzNLHi6p4LAof9aMJALVC0oaHN4u8yvaL9mopRpGtFWaqlrvAX8gXxMosptr8D65mPB24m8gwHzjUd3DP787wHB5uHYQ==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=gmail.com; dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=I0LMVS94; dkim-atps=neutral; spf=pass (client-ip=2607:f8b0:4864:39::b; helo=mail-pj2-x0b.google.com; envelope-from=huanghaiyang83@gmail.com; receiver=lists.ozlabs.org) smtp.mailfrom=gmail.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=I0LMVS94;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=gmail.com (client-ip=2607:f8b0:4864:39::b; helo=mail-pj2-x0b.google.com; envelope-from=huanghaiyang83@gmail.com; receiver=lists.ozlabs.org)
Received: from mail-pj2-x0b.google.com (mail-pj2-x0b.google.com [IPv6:2607:f8b0:4864:39::b])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hFyhS47lRz2yh4
	for <linux-erofs@lists.ozlabs.org>; Thu, 06 Aug 2026 16:55:03 +1000 (AEST)
Received: by mail-pj2-x0b.google.com with SMTP id d9443c01a7336-2cf02ecb572so20200615ad.1
        for <linux-erofs@lists.ozlabs.org>; Wed, 05 Aug 2026 23:55:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785999301; x=1786604101; darn=lists.ozlabs.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=LHiVelN5mh9CVmWnGQoTnlP7xVCZ+d8Y4Ey2Z8wrXTE=;
        b=I0LMVS94hKfdeAOrC68TqqHhmh82W4KytJSinBtwh9CnwWVKZSd4QkcZApJC4ladkU
         Fg9UQ3jAvWjA6Os4NxLQ2H51P+0mfY+YXlOOlck6NUke8NNe3zL8ct0Pbo7PrA3vTBKr
         2cCLlfOExI7Ve0BNs/kp9o4fsgZSvR7irCWnQIyVGxyQdpM9LVtVoVFlLp1pizzci6+I
         V2M1RRPN9VzV+71mRQW/GgOFyDFJA/Wq5n+21RDJkaKHMaLeqoTIdn4c61vOBYt4YoJJ
         9KoSAa3Si2Ssi/vImNozuE1WiTttDaagZX2oe0q93kJUXT7BzbYOYzRzZkxvpyCzXivs
         KfPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785999301; x=1786604101;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=LHiVelN5mh9CVmWnGQoTnlP7xVCZ+d8Y4Ey2Z8wrXTE=;
        b=nAHle1U+DlmJF8InMPTCEDgu59mXDg/t0ckcfpWrlWwORVDzrgTedXha71dfWzlRTJ
         utyL3KxTcg5t3Lg4RCgQqfaAzgVIkJzVRoEsJFZaWrtnFZ6cav6QwnfY9TVc5Hl9oUlt
         N7KLefK1/gBJ8R6PmHVdr2i9zfa6Hj5RopW7wP8IZ5QK/HRsq2B/MKqs3ZtoTb8oiajl
         vLmB85i8xnycvr/Br6Z5JV0pn/vNwBLJgdbwF69LZJnW6MpcAUSuE2/XvQRc1mgEBiy1
         XSa1HYfOLPOEP85/HDG9f5QMJzV/3JV7DeT4baY+li+nleR627lX9sQfT6QX2uqeqitL
         ORCw==
X-Gm-Message-State: AOJu0YzH2/9bWFJU4T2LGb5/bPKC1a/cEulI5pgyRszC9lNiaE2qK9ha
	4g04waGAicUlJrbwuZ4H3PS9xmJR2oQ914IADcdBZH1TEOfcWcWCmv97
X-Gm-Gg: AR+sD13yWPYoiBeuGfMbRipmiReG3WSghTtX6OE/G2n1UT2ljZqH/M7ImiUEHL8JWmL
	p9lI+ixHQjODt8txvjOFiTvsMbJGsAPu7R64dZVQAI0tn6Fa5KyMJcuLsLcz2k42mI8o0GG7pLY
	uCKH3schQDTKc0y6R4KYcXeh7wR5JJZMupUZg8zpPNDnyh4BbZdf/CguoZq7NhRpmjlQIwWUoE2
	7hsGTqV1Pt35BNEaD7z1Mil4wD6d4CrrJCaFoyckyVnLJxABg4O0POMVe79fe+LVpesUcwCn0dj
	cCYFJrG7JhoUvxv22BSKyaWBfPzEQOFr/s/pScKSIzp/8ux/CvS0hBVCASpOjoILIuV+dF+kT2a
	mK2SI+om6XLffD/bnV4wQB5zUR74JlybzYVOy9vkmpwDOEfMJWRAhYUlO0gSEBCKKBVpl4Zjg7s
	jRwLb0o2y2FiuVAk4CxnSTazsNbvkTIBtXXKifkcftNYYUpMUAiv0NESdUz93qKfJ+2ixWoYSpI
	UtPQaDGf3tWY04K7WKXy2tvnDD2
X-Received: by 2002:a17:903:2392:b0:2d0:cc92:f7a3 with SMTP id d9443c01a7336-2d0cc930281mr137694955ad.2.1785999300646;
        Wed, 05 Aug 2026 23:55:00 -0700 (PDT)
Received: from yde24-ubuntu ([39.155.246.150])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2d0a9f93657sm26417645ad.17.2026.08.05.23.54.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Aug 2026 23:55:00 -0700 (PDT)
From: Haiyang Huang <huanghaiyang83@gmail.com>
To: xiang@kernel.org,
	chao@kernel.org
Cc: linux-erofs@lists.ozlabs.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	Haiyang Huang <huanghaiyang83@gmail.com>
Subject: [PATCH] erofs: fix out-of-bounds read in INTERLACED pi computation
Date: Thu,  6 Aug 2026 14:52:52 +0800
Message-ID: <20260806065253.1083865-1-huanghaiyang83@gmail.com>
X-Mailer: git-send-email 2.53.0
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

In z_erofs_transform_plain(), the page offset `pi` for the INTERLACED
initial tail copy is computed using the unclamped value of `cur`:

    cur = bs - (rq->pageofs_out & (bs - 1));
    pi = (rq->pageofs_in + rq->inputsize - cur) & ~PAGE_MASK;
    cur = min(cur, rq->outputsize);

When cur > pageofs_in + inputsize (which is the common case for
ztailpacking pclusters since pageofs_in + inputsize <= bs), the
subtraction underflows in unsigned arithmetic. The subsequent
& ~PAGE_MASK extracts a bogus intra-page offset, and the memcpy/
memmove reads up to inputsize bytes from past the kmap'd page boundary.

Fix this by clamping cur before computing pi, so the subtraction uses
the actual copy size rather than the raw block-alignment distance.

Fixes: 1ca01520148a ("erofs: refine z_erofs_transform_plain() for sub-page block support")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-4-6
Signed-off-by: Haiyang Huang <huanghaiyang83@gmail.com>
---
 fs/erofs/decompressor.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/erofs/decompressor.c b/fs/erofs/decompressor.c
index 3c54e95964c9..9c65364ed002 100644
--- a/fs/erofs/decompressor.c
+++ b/fs/erofs/decompressor.c
@@ -299,8 +299,8 @@ static const char *z_erofs_transform_plain(struct z_erofs_decompress_req *rq,
 		return ERR_PTR(-EOPNOTSUPP);
 	if (rq->alg == Z_EROFS_COMPRESSION_INTERLACED) {
 		cur = bs - (rq->pageofs_out & (bs - 1));
-		pi = (rq->pageofs_in + rq->inputsize - cur) & ~PAGE_MASK;
 		cur = min(cur, rq->outputsize);
+		pi = (rq->pageofs_in + rq->inputsize - cur) & ~PAGE_MASK;
 		if (cur && rq->out[0]) {
 			kin = kmap_local_page(rq->in[nrpages_in - 1]);
 			if (rq->out[0] == rq->in[nrpages_in - 1])
-- 
2.53.0


