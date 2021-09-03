Return-Path: <SRS0=hJpO=NZ=lists.ozlabs.org=linux-erofs-bounces+linux-erofs=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD57AC433FE
	for <linux-erofs@archiver.kernel.org>; Fri,  3 Sep 2021 13:41:07 +0000 (UTC)
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 5DAC96101A
	for <linux-erofs@archiver.kernel.org>; Fri,  3 Sep 2021 13:41:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 5DAC96101A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.ozlabs.org
Received: from boromir.ozlabs.org (localhost [IPv6:::1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4H1Jpn6Vyqz2yQH
	for <linux-erofs@archiver.kernel.org>; Fri,  3 Sep 2021 23:41:05 +1000 (AEST)
Authentication-Results: lists.ozlabs.org;
	dkim=fail reason="signature verification failed" (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20210112 header.b=MpE6FBJ0;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized)
 smtp.mailfrom=gmail.com (client-ip=2607:f8b0:4864:20::1034;
 helo=mail-pj1-x1034.google.com; envelope-from=jnhuang95@gmail.com;
 receiver=<UNKNOWN>)
Authentication-Results: lists.ozlabs.org; dkim=pass (2048-bit key;
 unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256
 header.s=20210112 header.b=MpE6FBJ0; dkim-atps=neutral
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com
 [IPv6:2607:f8b0:4864:20::1034])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
 (No client certificate requested)
 by lists.ozlabs.org (Postfix) with ESMTPS id 4H1JpZ2kp7z2xYQ
 for <linux-erofs@lists.ozlabs.org>; Fri,  3 Sep 2021 23:40:54 +1000 (AEST)
Received: by mail-pj1-x1034.google.com with SMTP id
 mw10-20020a17090b4d0a00b0017b59213831so3857139pjb.0
 for <linux-erofs@lists.ozlabs.org>; Fri, 03 Sep 2021 06:40:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20210112;
 h=from:to:cc:subject:date:message-id:in-reply-to:references
 :mime-version:content-transfer-encoding;
 bh=qO5CMNW4XaR9NiEtFFrnR0NDM8bY6E/YApQSRyIL1zI=;
 b=MpE6FBJ0Bco9m5SRJS+7w0RHGWJcYA5rJ81hWR5Vyyed0ixZXevhetQLH7zGgPMH4R
 ovzOKk+gl4r3E5apSbnQW7dfRsmHX3VYm3f5RzmcicuWD9DbgJhcj8NRN5x4GN0Il48g
 y5YPnjmklUPaEWlyMaWDQC/Kr5EY44BPmo6baqy0THrg+tQR0Br9X1sVczqmc6ubwfIX
 T9EhEz+fWWaW4/wY6QjUcJ6S0vsXesJPw0177J4K8lYswWUvzvLFfQQ9rhlAT8EQ1sv3
 ygvMJwee6uUZKCa62OiFo21tAC8PDL+3rOr7tl8VH04bov4Wq8AJgFWHxKzFS2rLxsUE
 spqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
 :references:mime-version:content-transfer-encoding;
 bh=qO5CMNW4XaR9NiEtFFrnR0NDM8bY6E/YApQSRyIL1zI=;
 b=SsX285+xqMcxfY72MCJp9eZgn3aAFqV3xN6Xa+VEr4GS1wIWkQfzD77ve25XXFDrJ6
 n7ZJyPQLKsPrbV79uTY1RJ+NBscnnvbgRpbJuFZ5GoL8LRv8RsF+hIFDJhBsMOrPIsWB
 pHXl9VLqygjVk2MjclsHMBSicZ2r4tjfeGcylPYCzGWuLi3Z3lRiEkYWL5J4uN/40+1p
 X+9Bh6IlpvhS702fyvTo5Ov4+YHsv8mlzv4SKIN/pNrRsIk5UTfh9gYSldLTTHPU4GN2
 UsIT27eoKldzbxdED6Ap93sXnHC2f4DUiVD4yEaVAxQcUZstLcWYM0uzIacKbENxukZT
 uB2A==
X-Gm-Message-State: AOAM530mLWpwZjdPr3+sN5uYlkTv2A6ilB+XOQ4hdG8eVzAUQl+RSl0b
 DksnELw4j4AZ3QvJi0CkHUGyqUVh5hwJaTTE
X-Google-Smtp-Source: ABdhPJwVMf4FOeHt0QowHZHOHCq4L86zdQ+O8XnvdckAXKlQ1ONtLO+yZHzcXuH83yrIZ/FLTu4vBg==
X-Received: by 2002:a17:90a:7c42:: with SMTP id
 e2mr9653741pjl.132.1630676451498; 
 Fri, 03 Sep 2021 06:40:51 -0700 (PDT)
Received: from hjn-PC.localdomain (li1080-207.members.linode.com.
 [45.33.61.207])
 by smtp.gmail.com with ESMTPSA id o1sm5590948pjk.1.2021.09.03.06.40.50
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Fri, 03 Sep 2021 06:40:51 -0700 (PDT)
From: Huang Jianan <jnhuang95@gmail.com>
To: linux-erofs@lists.ozlabs.org
Subject: [PATCH V2 2/6] erofs-utils: fix SPDX comment style
Date: Fri,  3 Sep 2021 21:40:31 +0800
Message-Id: <20210903134035.12507-3-jnhuang95@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210903134035.12507-1-jnhuang95@gmail.com>
References: <20210831165116.16575-1-jnhuang95@gmail.com>
 <20210903134035.12507-1-jnhuang95@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
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
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs"
 <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>

From: Huang Jianan <huangjianan@oppo.com>

Signed-off-by: Huang Jianan <huangjianan@oppo.com>
---
 fuse/macosx.h              | 1 +
 include/erofs/block_list.h | 2 +-
 include/erofs/xattr.h      | 2 +-
 3 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/fuse/macosx.h b/fuse/macosx.h
index 372eba6..81ac47f 100644
--- a/fuse/macosx.h
+++ b/fuse/macosx.h
@@ -1,3 +1,4 @@
+/* SPDX-License-Identifier: GPL-2.0+ */
 #ifdef __APPLE__
 #undef LIST_HEAD
 #endif
diff --git a/include/erofs/block_list.h b/include/erofs/block_list.h
index 5127b23..fca476a 100644
--- a/include/erofs/block_list.h
+++ b/include/erofs/block_list.h
@@ -1,4 +1,4 @@
-// SPDX-License-Identifier: GPL-2.0+
+/* SPDX-License-Identifier: GPL-2.0+ */
 /*
  * Copyright (C), 2021, Coolpad Group Limited.
  * Created by Yue Hu <huyue2@yulong.com>
diff --git a/include/erofs/xattr.h b/include/erofs/xattr.h
index 5086b54..f0c4c26 100644
--- a/include/erofs/xattr.h
+++ b/include/erofs/xattr.h
@@ -1,4 +1,4 @@
-// SPDX-License-Identifier: GPL-2.0+
+/* SPDX-License-Identifier: GPL-2.0+ */
 /*
  * Originally contributed by an anonymous person,
  * heavily changed by Li Guifu <blucerlee@gmail.com>
-- 
2.25.1

