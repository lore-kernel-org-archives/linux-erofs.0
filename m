Return-Path: <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5BE05C7EE23
	for <linux-erofs@archiver.kernel.org>; Tue, 30 May 2023 20:24:39 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [IPv6:::1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4QW3ln69LJz3f8w
	for <linux-erofs@archiver.kernel.org>; Wed, 31 May 2023 06:24:37 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=lists.ozlabs.org;
	s=201707; t=1685478277;
	bh=M5llbHL5Be3EtuixSo+vMZDY1Lz6bORzEUzGqsYwx/Q=;
	h=Date:In-Reply-To:References:Subject:To:List-Id:List-Unsubscribe:
	 List-Archive:List-Post:List-Help:List-Subscribe:From:Reply-To:Cc:
	 From;
	b=Fjn8R1tzK1plMSE3YXjvLOeLOkAeIm6mYyH/bG6xPXp/FaCDhJv2d7BeQ6yv4yebH
	 2g4jA02oR6YExrPlpNJ6+U4DtxIfrNwKCjUjgzVJ812akoFKLXcWoGra7YeW1w6fYT
	 H3mvMEv5OnhyUYWT1zQHGTpvhN+vieKD6RcerY2SfVpuTXb6WS9FxgumSJMwNQJNOC
	 dlLJm0z0rBRh3iMlJgEoP9yr2lVg/xpp3KFNhE3Woy65TNPrhKBHCiLj+BXM/cG6LD
	 JWmzpO2zzgl2W5ZtWBZW875bk1nq/37ThuV49uKtYxToP151Ggw65FSlFM/AaFbPMV
	 ca6gi2A57+2sA==
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=flex--zhangkelvin.bounces.google.com (client-ip=2607:f8b0:4864:20::54a; helo=mail-pg1-x54a.google.com; envelope-from=3dlt2zaskczemunatxryivatbbtyr.pbzyvahk-rebsfyvfgf.bmynof.bet@flex--zhangkelvin.bounces.google.com; receiver=<UNKNOWN>)
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20221208 header.b=y3Go95US;
	dkim-atps=neutral
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4QW3lY05lBz3cLx
	for <linux-erofs@lists.ozlabs.org>; Wed, 31 May 2023 06:24:24 +1000 (AEST)
Received: by mail-pg1-x54a.google.com with SMTP id 41be03b00d2f7-53450fa3a18so4291434a12.0
        for <linux-erofs@lists.ozlabs.org>; Tue, 30 May 2023 13:24:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685478263; x=1688070263;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=M5llbHL5Be3EtuixSo+vMZDY1Lz6bORzEUzGqsYwx/Q=;
        b=U9t9bWeVXAEYGtDTY0LBt7uGVPxhS6x5PA8ra5sEa52M1kMCHr8SwnVdk/QhCJiXJd
         B2xjJUT4a3HeXVNV7mkc93nog32n0pRmnHJ3bvpr60v/BpTL9eu2PMkTZDnEGiq0WxKH
         F/KqqeoHDkzdiR41xGT79LqakAuvOamzDBnyGbVmpO5FObCeZFheRGj5JMAmDwO/d5hM
         zVA/m2FkcQ04spiujEyciZO0wgpkffVaMm279MbOe4FkjrLKzYoeUU3I2wU2u0qlyYgk
         xrrhJ8McCRzwRYklS+P6dsuNbP9hQ6FypZdIzvwnTQKTPtiAigLThqj+z2e2kSU/Nd7F
         YFcQ==
X-Gm-Message-State: AC+VfDzwHVvluq69O1bOnvSJfg37vbe8lxKHoxq38c8dxTIZ0BaVmmR5
	TdeL39dTUgLFJjju+2lNR4jZPqGNsMjm3Cn6jn6ulzRafNtU5aRipvPgLke+C25LG0ExJyiYHG7
	fXzUWq0EGftzNaXS6Eg+Q2szf5wrT0H8pmWuRr33vIQ5lEaXVTGaNaCxJN5wv1RcdCIrF0y7nq/
	qs/5EdSE4=
X-Google-Smtp-Source: ACHHUZ5gEJvgqD4wxtdu54CMEQCYsUmokL54f/NSPxbKuxEMezpeXi/+OUUE+F/xzUha8IEmTcYHUdWoMb+NtPib5g==
X-Received: from zhangkelvin.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:2bb0])
 (user=zhangkelvin job=sendgmr) by 2002:a63:4082:0:b0:53f:2302:8f6a with SMTP
 id n124-20020a634082000000b0053f23028f6amr629937pga.8.1685478262619; Tue, 30
 May 2023 13:24:22 -0700 (PDT)
Date: Tue, 30 May 2023 13:24:13 -0700
In-Reply-To: <20230530202413.2734743-1-zhangkelvin@google.com>
Mime-Version: 1.0
References: <20230530202413.2734743-1-zhangkelvin@google.com>
X-Mailer: git-send-email 2.41.0.rc0.172.g3f132b7071-goog
Message-ID: <20230530202413.2734743-2-zhangkelvin@google.com>
Subject: [PATCH v1 2/2] Allow developer to manually set a max block size
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

Signed-off-by: Kelvin Zhang <zhangkelvin@google.com>
---
 include/erofs/internal.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/erofs/internal.h b/include/erofs/internal.h
index b3d04be..6eba35d 100644
--- a/include/erofs/internal.h
+++ b/include/erofs/internal.h
@@ -35,7 +35,9 @@ typedef unsigned short umode_t;
 #define PAGE_SIZE		(1U << PAGE_SHIFT)
 #endif
 
+#ifndef EROFS_MAX_BLOCK_SIZE
 #define EROFS_MAX_BLOCK_SIZE	PAGE_SIZE
+#endif
 
 #define EROFS_ISLOTBITS		5
 #define EROFS_SLOTSIZE		(1U << EROFS_ISLOTBITS)
-- 
2.41.0.rc0.172.g3f132b7071-goog

