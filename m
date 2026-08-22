Return-Path: <linux-erofs+bounces-4288-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CD603C5DF97
	for <linux-erofs@archiver.kernel.org>; Sat, 22 Aug 2026 14:01:16 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hRzNq0LXBz2xcG;
	Sun, 23 Aug 2026 00:01:15 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2607:f8b0:4864:20::32f"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1787407275;
	cv=none; b=AKQ2bRo1pI7dMmAXOutLCxUpkvMmbH6lMBacoNJHUuyw1Jiv1Y5RMLwuVpls7oKmUS3Os6hHKAzAWyPVUhEK9hI/Q10iDlqmW7ltwXGn1qV5YXt00x+ETNSWU0iyQHyuIivzxyo1XcUB6bUaxAIeeuvZRsQwajgAShXCu8+FjhAbLe6y4MJXmwntw+kLUbUy90JLFPZdVVCAjVIkYXhZbahHBTV6mUOiimPegFXgzBciT0TAjjXN2JO5M8NRd9NZDtGF6v1BRYj26mekTNw49kqkCEwwvJnGclGPiImzLvcauqbuOIHiJrlvSaCPgjAZvgjY3uPpj4jkNm1FtR8wqA==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1787407275; c=relaxed/relaxed;
	bh=RAu2d0iA448dCKNC/0dAOo9eNJ/v3Puws2Lutq5hDZo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Op0+OQYRbt7UVoA1F81ucWdvexgNdiaOmYxt9gD/SOxC7y+W4v/L3j5E4qD9pyLay6iDLVVUYltKsm+zFaxkf1ot/mMeJFJfKxNS46PqPhMh75JXkUCDJcYEGEXPJKXzsudzLQALGAP5NDiz/8Em6AlQ4FUSxY0zEHsRzs8Klj8F8dHyPADYgpFV5IPqs0pDm332cyBCOH5umWZgVSWNMTYZCOzXG/jRtGjpYCRLR6LqmLlRhTxITqXK44kXKT/kIJ1aRZT/QJrOWJgQvxBt6PG/LxvYVuh87vcvbBLFzvuQRRGieUyELvkafvLzMbRfIXnE5XZ77EiToRP3zYDSrA==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=gmail.com; dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=k+9o4pM7; dkim-atps=neutral; spf=pass (client-ip=2607:f8b0:4864:20::32f; helo=mail-ot1-x32f.google.com; envelope-from=nikhilgurudasani314@gmail.com; receiver=lists.ozlabs.org) smtp.mailfrom=gmail.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=k+9o4pM7;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=gmail.com (client-ip=2607:f8b0:4864:20::32f; helo=mail-ot1-x32f.google.com; envelope-from=nikhilgurudasani314@gmail.com; receiver=lists.ozlabs.org)
Received: from mail-ot1-x32f.google.com (mail-ot1-x32f.google.com [IPv6:2607:f8b0:4864:20::32f])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hRzNn19zhz2xQ7
	for <linux-erofs@lists.ozlabs.org>; Sun, 23 Aug 2026 00:01:12 +1000 (AEST)
Received: by mail-ot1-x32f.google.com with SMTP id 46e09a7af769-7f3ff92cf4aso2046675a34.1
        for <linux-erofs@lists.ozlabs.org>; Sat, 22 Aug 2026 07:01:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787407268; x=1788012068; darn=lists.ozlabs.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=RAu2d0iA448dCKNC/0dAOo9eNJ/v3Puws2Lutq5hDZo=;
        b=k+9o4pM7PRCujbpgkmquE2NxW4/zp9V3muLQYDnTg7d+KH43m1bWp59pB6ouA5+IZA
         UDIlU4UITsl8t28W4XbLb/Fw6+FwBsx/P6mTWCVyyOnODuSRfYBRPqLvQviES3R4aWsV
         vhPW+1H/H1HqxC0GT9E95dDIAa/EG5rhSE+FxWJoIPJH/tuT0M+YWOlvyucWc3Kfarwh
         q1zooRm558OeHhsaOANIefifVPhzIDzzKwVfcicBlglezKqiSY/1iu/M9UpFO2jA7Vms
         oQTpwKISdl5zFaG0cBYdCTctrIKZPrE320GdOdHImACKxefq5iddl5oNtNInGPCNmtxF
         ufTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787407268; x=1788012068;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=RAu2d0iA448dCKNC/0dAOo9eNJ/v3Puws2Lutq5hDZo=;
        b=R3FjarRWMCvoBc4FLKiFaiZXcaQw/21sErjxkFXYwvU6WBy/Ey9BwCCIPhB7EOpdMH
         yrcL9hIz8UuREV5tF/ONdoAn2ND95K610Yj7Nx4RycjJhbPGunUca0p9jbR5AMcTbNe+
         jHWW0fsm817Ijk0T5AK/whQc/H/wV4wQ8LqlMbPVeLs6CV/Jis6Cqc95OcJzBXeNItQt
         qIglGLStmVr0LPnqr9+pIRwZ7v6/ctwwt5mSAc3lcRYi0ybvX2jeygkaL4T2C+QVDBCf
         Wp3vTCvDoxDjL9NWH4p4r9nyv5aNlnlHHWPm7shDN6Ed9s8C3HOMXLPIaJb4ncweuSQN
         Xp1Q==
X-Forwarded-Encrypted: i=1; AHgh+Ro9WlzOE+nHtUS/nZ+ScsB6urxBEmATkvomQVYvC0IMm2E7o40LjqXAEfpl7R+nAsS7L/hPtKadOhIyvg==@lists.ozlabs.org
X-Gm-Message-State: AFuF++kl3JpaCTA3RIc5QPcUA9qdoUnjFmz/kALXv87bSHCALwaT2EvV
	YpBjIl4jtJPU7deWEqjNoBHdjGDt6qqV6buo7QgMUe4r1PLQlk6ZUGQ2
X-Gm-Gg: AR+sD10tq1DHZyrg2ktCJQ6hGdCxlyvo/plA9yP+7ipkyziUDX5eI4bZC9FHRHP7SED
	rsPNFme/V0x9utBijQD27sRNksd1ER0K4o2UcUn4p8dH3wNwKzqHXvndBtoz6tveSajPJLq+6HT
	AGbvfLW9NaqRtcPNmZ4iMpbA1ZXqjfRhQFyOFn9gGXuyFAcxZKYMnx25M0QVd+d76y78OYJ/tiR
	Q5zuxxjrc1JDzcTa226tUjJDa9/+zkyJrX7h1P+LUn6wVf53RG125sAwvOKtbE40CDuBoPVrvBJ
	+8FIlQLZK6S7Ueh3qck1QRrW6ssK2n0GwW9GofEf1PAKgIkpEsbmMRG8FW/ls+H19q9dFDFn/DH
	IarKjcp+BZn1oeHXLY6nsMesrtd59CyIkN/u9t6C98jWXutmDoQA4wO6gvVwGlNzq2fEtWAGa6T
	pwdzWANM52NEKUateX4AMizPyOPjAyOigePTl1u6X98SwCxPEnnN7ZM97ltgw6F/lys6qV4Wezw
	fcgp+e+/o5VwhaA
X-Received: by 2002:a05:6820:1686:b0:6b1:6462:7e4a with SMTP id 006d021491bc7-6b164629665mr9378701eaf.13.1787407267786;
        Sat, 22 Aug 2026 07:01:07 -0700 (PDT)
Received: from White.tail445f11.ts.net ([45.127.44.104])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1418619d6ecsm7614856c88.14.2026.08.22.07.01.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 22 Aug 2026 07:01:07 -0700 (PDT)
From: Nikhil Gurudasani <nikhilgurudasani314@gmail.com>
To: xiang@kernel.org,
	chao@kernel.org
Cc: zbestahu@gmail.com,
	jefflexu@linux.alibaba.com,
	dhavale@google.com,
	hongbohbli@tencent.com,
	guochunhai@vivo.com,
	linux-erofs@lists.ozlabs.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: [PATCH] erofs: skip sufficiently large global buffers when resizing
Date: Sat, 22 Aug 2026 19:30:17 +0530
Message-ID: <20260822140017.8119-1-nikhilgurudasani314@gmail.com>
X-Mailer: git-send-email 2.43.0
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

z_erofs_gbuf_nrpages is advanced only after every global buffer has been
grown. If a resize fails after some buffers were enlarged, a retry
revisits those enlarged buffers.

Retrying the same size then returns -ENOMEM because alloc_pages_bulk()
has no pages to add and the unchanged return value is treated as a
failure. Retrying an intermediate size allocates a temporary pointer
array smaller than gbuf->nrpages and copies more existing pointers than
the array can hold.

Skip buffers that already satisfy the request. Once all remaining
buffers have caught up, advancing z_erofs_gbuf_nrpages again describes
the guaranteed minimum size across the pool.

Fixes: d6db47e571dc ("erofs: do not use pagepool in z_erofs_gbuf_growsize()")
Cc: stable@vger.kernel.org # 6.10+
Signed-off-by: Nikhil Gurudasani <nikhilgurudasani314@gmail.com>
---
 fs/erofs/zutil.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/erofs/zutil.c b/fs/erofs/zutil.c
index a0ce9226b..6b9bfa2ef 100644
--- a/fs/erofs/zutil.c
+++ b/fs/erofs/zutil.c
@@ -79,6 +79,8 @@ int z_erofs_gbuf_growsize(unsigned int nrpages)
 
 	for (i = 0; i < z_erofs_gbuf_count; ++i) {
 		gbuf = &z_erofs_gbufpool[i];
+		if (gbuf->nrpages >= nrpages)
+			continue;
 		tmp_pages = kzalloc_objs(*tmp_pages, nrpages);
 		if (!tmp_pages)
 			goto out;

base-commit: 075b74841bd0065a3bda3440873c747938e69b68
-- 
2.43.0


