Return-Path: <linux-erofs+bounces-4576-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5C169C88E72
	for <linux-erofs@archiver.kernel.org>; Thu, 17 Sep 2026 03:54:10 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hlhhG2vBGz2yCr;
	Thu, 17 Sep 2026 13:54:06 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2607:f8b0:4864:39::11"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1789617246;
	cv=none; b=JTxS7RX0EI13xSYJ6d4iTkIadiOBXqEEeETZdBw6+L/262YWYfrF582RpJBIXiGUqd8q0fJFRCyPiuFYNV6r3DhaY2zMV7oZEjAtZktZido+BECv4j3Z7ck/3lwH2Kp7ur0zL81F+iIEmgrd1WteCAVF28CvpsDNmbIXwG8TRu+c8I0JOfZ6nif3oa0k6vbRcrl1ZLVeD+2h4w1CB6rs4xSYfENbI3/0AOPmN0A/xWYZKv+myQIOMqx6UvdHRMcuV59EeTFRk+blPon6WvQ1l1dCwt4ySQW4/vejfyoIHeZRgaEC8HuG3CXcn3/x1pQPalRnMXtzrAOkXjBOI44qFA==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1789617246; c=relaxed/relaxed;
	bh=cCcoaYBtjTI0bgGY/bghPgeAwi5nZNfVcvNuD4Pmz3Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Skzlntd11Ul4JJDgEiXNy+7xFDHaDatTIgSpEluFWyX8SfIs7wKwMLVTpyloOl6+ElSd01ZuBn1sEmus9Y7nabBBa8o3T6P8VaWoeY7JjPTBvWoN6St64pTlpBimfhjatV7g+F6vO4fB/EKDbrWnIvOkGfqztE6Za57e3Zgv8YAot8EatwUNDVR8uxskTJGaeyZ0XE5WeNfLlgcsAjw9tAI2CM/Pjl6ya2AMu9Ym6FOGEDyyy8YvBwK3lFINsnS4rkgZhHW6vS303gQ5n1b/Q2TnS7J+NNjBNY21FTF7OOuOX1BFb5RPiYi/5fP382MyhsTTQnG77/RAs59zTv7S8g==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=gmail.com; dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=ewLjIDlm; dkim-atps=neutral; spf=pass (client-ip=2607:f8b0:4864:39::11; helo=mail-pj2-x11.google.com; envelope-from=stopire@gmail.com; receiver=lists.ozlabs.org) smtp.mailfrom=gmail.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=ewLjIDlm;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=gmail.com (client-ip=2607:f8b0:4864:39::11; helo=mail-pj2-x11.google.com; envelope-from=stopire@gmail.com; receiver=lists.ozlabs.org)
Received: from mail-pj2-x11.google.com (mail-pj2-x11.google.com [IPv6:2607:f8b0:4864:39::11])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hlhhF4gQxz2xbQ
	for <linux-erofs@lists.ozlabs.org>; Thu, 17 Sep 2026 13:54:05 +1000 (AEST)
Received: by mail-pj2-x11.google.com with SMTP id d9443c01a7336-2d8fdc579daso3966235ad.1
        for <linux-erofs@lists.ozlabs.org>; Wed, 16 Sep 2026 20:54:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789617244; x=1790222044; darn=lists.ozlabs.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=cCcoaYBtjTI0bgGY/bghPgeAwi5nZNfVcvNuD4Pmz3Q=;
        b=ewLjIDlm2+qOkw/ODwhzZaOAXNmeKbTMEZp6DHw17N3/B1w54lvPAdSnDTDK3/TCHN
         k79P7tmnKn3rsc0pbwfX6eXtt2DyYoNS2VfaIMc2mUZaRi42UF3x+f/upMgIiOHsEpDA
         9VCqgdHPy+3fdXWAk+3i1CFd9bdZor0nRoYRDTybRi10eiRyLtP05PssPzCCXsBn3OvY
         M4zn8OdTWBE0UbAZCNgDtgQj01XTvstWOL9At1JhmkuSCJZbmJqnoabSvHBqNFtJjqE+
         fHvaSTntjn9wqEOpcqJ/OGGeCU/U9rxfFIsAibC1Oz8iIMG/bZyIknkD5I5lQ4z6duqs
         AArA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789617244; x=1790222044;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=cCcoaYBtjTI0bgGY/bghPgeAwi5nZNfVcvNuD4Pmz3Q=;
        b=SAkEFmjgDtD7PekyJp/f7QY+R2QVPNlbi6x2TFRhnxonN+/d7PuAnq/s1l/ORQA7Mk
         ve2meTSN42QR9pHQP1oXD2jh+7ksHcHnw682JXyZvxw6uLV6aTXGXHX8nqAOxoJOx4Ip
         tqOqk8fw3ytuSp01A++uSRHuuRoXtsboFwKHbUlZVvEAXee9x8w369CleiLzcMCk8R1o
         Qd4ZpgBwAJG2NtCrNdQB+WjsCZnMIHJYEl+3t9yZdyk4Q984XEshMW1gLW1R8RRVCZPf
         HezZDVYhjT2xxOcbXDjMcT16ZwteuiYXxBiv7vc+lKl4S2bpyeoEjAdW8jsrQ3OhnPrH
         jsyg==
X-Gm-Message-State: AFuF++kE/z1uLBhMaRKcNYvs4Sd/c1rvH+PNWun746gmgyn6tsZTFV1D
	u7gkni/EnS/c8u6mOYpwhupgWZMts+qnJn/iFECjyg9v09uteY6o+tPpnXsCXUW3KLU=
X-Gm-Gg: AYBFou3AWy57aO6S/v1m91DxBBhnK6jw0poaEP2rPNHIdZb5LsvPA7nZH3A9uGpHtjO
	gIf/0K6rLq/pJx/ZFV3h0Py9F6glUNhiWUjMXNTu2ANbD0iOYq1CpEaOUGfk6le/tH5m6TJj2Qq
	MGsy4p7ZcAejPPypLaE/6PDWT+G+9kPDeXMHd6L1Cayoundys9amaCrHdWRQF9pVE7MoAVBGB8k
	STxOE7rrx3gsZw1nzvUdz8n8SssY1Q9WOeuBi1UBPQtwjnVM4l4X63bpDm6iXczGEZQ2E0X4xe1
	KxUSEMoREnm2LC7jwoVs5z6J9s+MOgQw8+KvEC1Ur66fcVMolLxPHW2kGvFnpyB5rq5YETTb042
	ySVg5R2oWlPW/4T247F+BCmhmUDxmO0t6/WV5uoMTGZi1k0g1WCCbVsUS3nmAFQQGCWOssDUdEz
	rakXAuGnu3MocDp/RLAJ0yGfTQMoY8wOhDxpzlA1WXdaTYLp9OGytyHCBpqaTl5Pd0JwMSlccCw
	t9HcpWK7/1bWzof3eYX4Q6sQGldgxNI+MmZmCR44Lth5nqDLg==
X-Received: by 2002:a17:903:2452:b0:2da:f7ad:cfea with SMTP id d9443c01a7336-2dd8df0a71emr106213335ad.8.1789617243604;
        Wed, 16 Sep 2026 20:54:03 -0700 (PDT)
Received: from zyf-laptop.tail52ade4.ts.net ([124.70.231.58])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2dd89ee3557sm19423245ad.52.2026.09.16.20.54.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Sep 2026 20:54:03 -0700 (PDT)
From: Yifan Zhao <stopire@gmail.com>
To: linux-erofs@lists.ozlabs.org
Cc: xiang@kernel.org,
	Yifan Zhao <stopire@gmail.com>
Subject: [PATCH 3/4] erofs-utils: lib: fix rebuilding empty chunk-based files
Date: Thu, 17 Sep 2026 11:53:48 +0800
Message-ID: <20260917035349.1339521-3-stopire@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917035349.1339521-1-stopire@gmail.com>
References: <20260917035349.1339521-1-stopire@gmail.com>
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

Switch empty files to FLAT_PLAIN before setting u.i_blkaddr to
EROFS_NULL_ADDR, which would otherwise overwrite u.chunkformat.

Fixes: b0b1711d4611 ("erofs-utils: support building image with reserved space")
Assisted-by: Codex:gpt-6-astra
Signed-off-by: Yifan Zhao <stopire@gmail.com>
---
 lib/rebuild.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/lib/rebuild.c b/lib/rebuild.c
index ebac1c5..c378885 100644
--- a/lib/rebuild.c
+++ b/lib/rebuild.c
@@ -335,6 +335,7 @@ static int erofs_rebuild_update_inode(struct erofs_sb_info *dst_sb,
 	}
 	case S_IFREG:
 		if (!inode->i_size) {
+			inode->datalayout = EROFS_INODE_FLAT_PLAIN;
 			inode->u.i_blkaddr = EROFS_NULL_ADDR;
 			break;
 		}
-- 
2.55.0


