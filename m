Return-Path: <SRS0=ho0r=K5=lists.ozlabs.org=linux-erofs-bounces+linux-erofs=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C38D9C47082
	for <linux-erofs@archiver.kernel.org>; Thu,  3 Jun 2021 20:19:11 +0000 (UTC)
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 2D48361400
	for <linux-erofs@archiver.kernel.org>; Thu,  3 Jun 2021 20:19:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2D48361400
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Received: from boromir.ozlabs.org (localhost [IPv6:::1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4Fwy0Z0pWwz3021
	for <linux-erofs@archiver.kernel.org>; Fri,  4 Jun 2021 06:19:10 +1000 (AEST)
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20161025 header.b=WtA9eMfE;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized)
 smtp.mailfrom=gmail.com (client-ip=2607:f8b0:4864:20::832;
 helo=mail-qt1-x832.google.com; envelope-from=fedora.dm0@gmail.com;
 receiver=<UNKNOWN>)
Authentication-Results: lists.ozlabs.org; dkim=pass (2048-bit key;
 unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256
 header.s=20161025 header.b=WtA9eMfE; dkim-atps=neutral
Received: from mail-qt1-x832.google.com (mail-qt1-x832.google.com
 [IPv6:2607:f8b0:4864:20::832])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
 (No client certificate requested)
 by lists.ozlabs.org (Postfix) with ESMTPS id 4Fwy0S1zWMz2xMw
 for <linux-erofs@lists.ozlabs.org>; Fri,  4 Jun 2021 06:19:03 +1000 (AEST)
Received: by mail-qt1-x832.google.com with SMTP id l17so1217160qtq.12
 for <linux-erofs@lists.ozlabs.org>; Thu, 03 Jun 2021 13:19:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20161025;
 h=from:to:cc:subject:date:message-id:mime-version;
 bh=SggH4knF0XHBZgyqlbbrHSqhHGvdK/XZh+Dsdo6W4rU=;
 b=WtA9eMfEXTiUmBDu8rThZOm5qzO8lBbi1MyQgct37WkHYe/oUfXf+mhfGqBk8Ms4Da
 rtakAw9vJaAWGuHQqfSA79KY/uJwX6HkK1h5HPekRZMQc8xSucO4qfcoHDQWk4hZrC74
 EgkY/eaBmBs6MuZhE0jkJkVScxzyfd5nZsxgbw+L3vqkQrZzeMAxxz9i2GJm7APWLi5s
 xTrRZe1GW9GdBnU3E6M8J5EQUSCdRhtphBI0ycG3vOkU2cm1iUUhj5ji2t33+EpXe1UM
 JRob8Danp/PE88SBym0V9EDmdK/FUu8CYtNIOYI2+VdeZ1UcmJG2Z4DYlsgFMEEsF1zO
 byqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version;
 bh=SggH4knF0XHBZgyqlbbrHSqhHGvdK/XZh+Dsdo6W4rU=;
 b=pVYWV+h73QtZ+ZkxhDVYqiIHm0jFEZkNta1oUaLw1jglUK2+n3ofQoNqV7TFEU0GL1
 IkpC2jt3LQVk9Q2fN0PkGnArAhl/kvKaggXqLGHnTzIoDYcHA50AqwktGFI+qohaEtoO
 1I8jf56+F92/qXBkLySumpqh9vN40FiHh26zWYTNTLTeNnwDSa6Tyw/F15vLiz8nojHB
 D6I4gsn00xzjEOIRE2bxUwJpX0VCbC4NK97VhyKAaYxwnnWwDA+0D8EOCEZVyiknDFDc
 B+H37T9TQjoCFetuitNPKeSrkYzo73DihCpL/RwUa7fn/RLEGWu1AloaJOvBe0Q5gxdo
 TfDA==
X-Gm-Message-State: AOAM531ga94LD4HQjrvYDtWQzstueSaNaDZ9rSIuS/xo1mFfc5cKbX9Y
 8XRLelgeMlwEGewbv6b10cI=
X-Google-Smtp-Source: ABdhPJwiwTCSUqooYDRu+NPRutFjag0eGw1jRN9hedVZBfAf2tvzZ4Spf9Rz6AbBZxsnvMRSd6+kIw==
X-Received: by 2002:ac8:58c9:: with SMTP id u9mr1286076qta.58.1622751538807;
 Thu, 03 Jun 2021 13:18:58 -0700 (PDT)
Received: from callisto (c-73-175-137-55.hsd1.pa.comcast.net. [73.175.137.55])
 by smtp.gmail.com with ESMTPSA id
 s10sm2500887qkj.77.2021.06.03.13.18.58
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 03 Jun 2021 13:18:58 -0700 (PDT)
From: David Michael <fedora.dm0@gmail.com>
To: linux-erofs@lists.ozlabs.org
Subject: [PATCH] erofs-utils: manpage: only install erofsfuse.1 with the
 command
Date: Thu, 03 Jun 2021 16:18:57 -0400
Message-ID: <87lf7q3dn2.fsf@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain
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
Cc: xiang@kernel.org
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs"
 <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>

Signed-off-by: David Michael <fedora.dm0@gmail.com>
---

Hi,

Can the erofsfuse man page be made to install only when the program is
installed?  This will clean up packaging a little bit.

Thanks.

David

 man/Makefile.am | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/man/Makefile.am b/man/Makefile.am
index ffcf6f8..0df947b 100644
--- a/man/Makefile.am
+++ b/man/Makefile.am
@@ -1,5 +1,9 @@
 # SPDX-License-Identifier: GPL-2.0+
 # Makefile.am
 
-dist_man_MANS = mkfs.erofs.1 erofsfuse.1
+dist_man_MANS = mkfs.erofs.1
 
+EXTRA_DIST = erofsfuse.1
+if ENABLE_FUSE
+man_MANS = erofsfuse.1
+endif
-- 
2.31.1
