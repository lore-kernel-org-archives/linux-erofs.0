Return-Path: <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7A2A5C7EE23
	for <linux-erofs@archiver.kernel.org>; Tue, 30 May 2023 20:24:34 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [IPv6:::1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4QW3lh5G11z3f8n
	for <linux-erofs@archiver.kernel.org>; Wed, 31 May 2023 06:24:32 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=lists.ozlabs.org;
	s=201707; t=1685478272;
	bh=r/vOAfNORPiV2P2g/gE43OdkiuJv4jjSAdO+l4U4CVg=;
	h=Date:Subject:To:List-Id:List-Unsubscribe:List-Archive:List-Post:
	 List-Help:List-Subscribe:From:Reply-To:Cc:From;
	b=NCbzGQHhpIbnedhmM1H/0iM6TMB6BLP2iN7mpi8Xt+D2VzpqZZ2QbfydB/b9Jrr4F
	 HVEv3Z70Iw1ESt3q0EjXq6YMng+UnJ6FUTdAqyjSv1aUIjAKRQhjiaP3ofwG55cll4
	 6gKAyfINp3KBi7R8MEW0yH3iityB7dDbkWygWvSp/knJ8usLnAGR5QPKeAcxVnaNzb
	 m27mxtjTIq1Ekp6W08L3SGVDTAbgl5n7sVPSE6PsHEI1NgEyLHcu4Q7mZjsXpPn/d7
	 RBVt542r8r9yilp40MAArgqdgEPcIMjis3VrbYW0TCAevNT5S78HY1O2vTi8u9U49N
	 jHol81aRTVwvw==
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=flex--zhangkelvin.bounces.google.com (client-ip=2607:f8b0:4864:20::449; helo=mail-pf1-x449.google.com; envelope-from=3clt2zaskcy0iqjwptnuerwpxxpun.lxvurwdg-naxoburbcb.xiujkb.xap@flex--zhangkelvin.bounces.google.com; receiver=<UNKNOWN>)
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20221208 header.b=JIQau8aE;
	dkim-atps=neutral
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4QW3lX1Xmhz3cLx
	for <linux-erofs@lists.ozlabs.org>; Wed, 31 May 2023 06:24:22 +1000 (AEST)
Received: by mail-pf1-x449.google.com with SMTP id d2e1a72fcca58-64d44d14db4so115937b3a.0
        for <linux-erofs@lists.ozlabs.org>; Tue, 30 May 2023 13:24:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685478259; x=1688070259;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=r/vOAfNORPiV2P2g/gE43OdkiuJv4jjSAdO+l4U4CVg=;
        b=AHt9ZhnrEi2Xs2brHDnjuOMIItLwezf+CPpmNh+x422viF009S98yEMm5skxgGcPbf
         gPPc9FTE9XVv3bSGmM20w1TqxcUcERQqqFdFhVymEfOFeIAxVcj7Ci95P8/WjAZIVJ3T
         C94bxUeiDzEqZh9XLVrTxNyue+IIgNLYooQLADNWnK4xi+z/1j4JHKt23nwvt25Gtttc
         rGND6FdBjlUZICdepX9qnw7dvaa6taDqaKHNCfZSojPV9z2KNjfR+CNva3cJiziRi3mO
         ybDiyo5hN1hnu2DAvfPIurv1Xq5EDNl2uN2cuzsVujLCTejMTbIptTf3ekYUMMN0kY4W
         aP+w==
X-Gm-Message-State: AC+VfDx8/tXQGQS01cl/bMYrYkhXNDmw2vxCfwk7fEo76PdTagqXGg4u
	E1oMm+6eci7uYHzrKWWGmZN81KyZGpS+h3geD/OR6E3p1mrqXXLdUFlK4kUIlBbf9mFqXAQvCjM
	GamW0VxhHN158ya0mIso8Z2WQ0NR+Di0yqJJpb3Vgq34yEwnIEjO8FkL7Mca5hgdNi2pSQJ2yyr
	fo/V7EIWQ=
X-Google-Smtp-Source: ACHHUZ7y+w+P2WvRsS86AyQpSqE9dJDQ+3egKL14OCvdhX9KkamPjbboizplD17ciT35ZKPUlz6F/B9zNa6pKGGJhQ==
X-Received: from zhangkelvin.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:2bb0])
 (user=zhangkelvin job=sendgmr) by 2002:a05:6a00:a29:b0:64a:f4ac:343a with
 SMTP id p41-20020a056a000a2900b0064af4ac343amr1399254pfh.2.1685478258989;
 Tue, 30 May 2023 13:24:18 -0700 (PDT)
Date: Tue, 30 May 2023 13:24:12 -0700
Mime-Version: 1.0
X-Mailer: git-send-email 2.41.0.rc0.172.g3f132b7071-goog
Message-ID: <20230530202413.2734743-1-zhangkelvin@google.com>
Subject: [PATCH v1 1/2] Remove hardcoded block size shifts
To: linux-erofs mailing list <linux-erofs@lists.ozlabs.org>, Miao Xie <miaoxie@huawei.com>, 
	Fang Wei <fangwei1@huawei.com>
Content-Type: text/plain; charset="UTF-8"
X-BeenThere: linux-erofs@lists.ozlabs.org
X-Mailman-Version: 2.1.29
Precedence: list
List-Id: Development of Linux EROFS file system <linux-erofs.lists.ozlabs.org>
List-Unsubscribe: <https://lists.ozlabs.org/options/linux-erofs>,
 <mailto:linux-erofs-request@lists.ozlabs.org?subject=unsubscribe>
List-Archive: <http://lists.ozlabs.org/pipermail/linux-erofs/>
List-Post: <mailto:linux-erofs@lists.ozlabs.org>
List-Help: <mailto:linux-erofs-request@lists.ozlabs.org?subject=help>
List-Subscribe: <https://lists.ozlabs.org/listinfo/linux-erofs>,
 <mailto:linux-erofs-request@lists.ozlabs.org?subject=subscribe>
From: Kelvin Zhang via Linux-erofs <linux-erofs@lists.ozlabs.org>
Reply-To: Kelvin Zhang <zhangkelvin@google.com>
Cc: Kelvin Zhang <zhangkelvin@google.com>
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs" <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>

This improves support for non 4K block sizes

Signed-off-by: Kelvin Zhang <zhangkelvin@google.com>
---
 lib/compress.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/compress.c b/lib/compress.c
index 06bacdb..ae0838c 100644
--- a/lib/compress.c
+++ b/lib/compress.c
@@ -766,7 +766,7 @@ static void z_erofs_write_mapheader(struct erofs_inode *inode,
 		.h_algorithmtype = inode->z_algorithmtype[1] << 4 |
 				   inode->z_algorithmtype[0],
 		/* lclustersize */
-		.h_clusterbits = inode->z_logical_clusterbits - 12,
+		.h_clusterbits = inode->z_logical_clusterbits - sbi.blkszbits,
 	};
 
 	if (inode->z_advise & Z_EROFS_ADVISE_FRAGMENT_PCLUSTER)
-- 
2.41.0.rc0.172.g3f132b7071-goog

