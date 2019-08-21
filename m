Return-Path: <SRS0=D63+=WR=lists.ozlabs.org=linux-erofs-bounces+linux-erofs=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.3 required=3.0 tests=DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 662EEC3A589
	for <linux-erofs@archiver.kernel.org>; Wed, 21 Aug 2019 00:19:11 +0000 (UTC)
Received: from lists.ozlabs.org (lists.ozlabs.org [203.11.71.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id B33192332B
	for <linux-erofs@archiver.kernel.org>; Wed, 21 Aug 2019 00:19:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="k4427tlh"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B33192332B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Received: from bilbo.ozlabs.org (lists.ozlabs.org [IPv6:2401:3900:2:1::3])
	by lists.ozlabs.org (Postfix) with ESMTP id 46CpDr54ljzDqdw
	for <linux-erofs@archiver.kernel.org>; Wed, 21 Aug 2019 10:19:08 +1000 (AEST)
Authentication-Results: lists.ozlabs.org;
 spf=pass (mailfrom) smtp.mailfrom=gmail.com
 (client-ip=2607:f8b0:4864:20::642; helo=mail-pl1-x642.google.com;
 envelope-from=caitlynannefinn@gmail.com; receiver=<UNKNOWN>)
Authentication-Results: lists.ozlabs.org;
 dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: lists.ozlabs.org; dkim=pass (2048-bit key;
 unprotected) header.d=gmail.com header.i=@gmail.com header.b="k4427tlh"; 
 dkim-atps=neutral
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com
 [IPv6:2607:f8b0:4864:20::642])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
 (No client certificate requested)
 by lists.ozlabs.org (Postfix) with ESMTPS id 46CpDd2mmYzDqdw
 for <linux-erofs@lists.ozlabs.org>; Wed, 21 Aug 2019 10:18:54 +1000 (AEST)
Received: by mail-pl1-x642.google.com with SMTP id y8so290121plr.12
 for <linux-erofs@lists.ozlabs.org>; Tue, 20 Aug 2019 17:18:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20161025;
 h=from:to:cc:subject:date:message-id:in-reply-to:references;
 bh=wYmP7l7xYXEkpyG7dJwFSke/FRHdQ6zd7wLrtCe0Nro=;
 b=k4427tlhkbAql47p/Igzqz9qG7iGY4VAjnTQCSvYQF2yNIuU9dyzJC4kHtm0M4r5eR
 sqY80jG2mnHwORi1nDP7JqJPuHA2FqonA4I3Rp8wmASaosWeQg4MUwiQfW+HIqn2T8Nh
 xORTETo+y/tIN3brE8Y+v2OMPBAiaQaX1f3NP23rJCEZRPPOvnvwCfuJnK57bBcfwqV/
 7ixqGAQnp8uQnxqAZ9d2Fawi6vDDSM45A2MJPObeCosJZLGdPRdq3pING/UyJWnltOHt
 PnAUEVlSqR4ZDKjlLk5bYhYAZ0+EUbNrV2O0aVunvGz3l6+AhIFtwuRVz0siuG1io3cP
 Gx1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
 :references;
 bh=wYmP7l7xYXEkpyG7dJwFSke/FRHdQ6zd7wLrtCe0Nro=;
 b=Tp0qzK8kso0EMrNXQ1DSED/PpEWslrZUhjNVpc+DpTdDbB7JEvKeIs1fl2iPTlC3Uy
 8HrYcsl8CPti7bu/c625lzq6kY0JuT0ozBjkeWv5NwqOKek1C+GbyMnvDlYUTpnJscZ3
 JFSagldeaWYcmGq5bw+iQkeXjVhUn9gJoDX7oKf5BgFnXUcUVjFGn6YMCWu1QH+T5h7c
 SEs3+M5DqXeQ8k4n9X758KSPJE507WsJSuxd0qraod5soHb7lywkuEHb6tAe6Obdh0vN
 81JaHS5WOP3Dqy+exoDjWi5nAKZ1afFrObh1x2qLGRVV1Krdpow8SAWdEX/KXpJneBEE
 yQDQ==
X-Gm-Message-State: APjAAAVnsJbrE4ZKtiTjNPI4uWsnpNqjmrkncyNJWh34gh+RLMyvwrKi
 BOWw3eYscLKbLtwLj0PvyYw=
X-Google-Smtp-Source: APXvYqy4XOtwQD0YpAxEXf3o3I+klcEKkKhlauOgufGqS5op00QX4mOatNkI/mvUJE8aQ6wDXxuCsA==
X-Received: by 2002:a17:902:6b07:: with SMTP id
 o7mr30180035plk.180.1566346731539; 
 Tue, 20 Aug 2019 17:18:51 -0700 (PDT)
Received: from localhost.localdomain (wsip-184-188-36-2.sd.sd.cox.net.
 [184.188.36.2])
 by smtp.googlemail.com with ESMTPSA id g2sm18806323pfm.32.2019.08.20.17.18.50
 (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
 Tue, 20 Aug 2019 17:18:51 -0700 (PDT)
From: Caitlyn <caitlynannefinn@gmail.com>
To: Gao Xiang <gaoxiang25@huawei.com>, Chao Yu <yuchao0@huawei.com>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 2/2] staging/erofs: Balanced braces around a few conditional
 statements.
Date: Tue, 20 Aug 2019 20:18:20 -0400
Message-Id: <1566346700-28536-3-git-send-email-caitlynannefinn@gmail.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1566346700-28536-1-git-send-email-caitlynannefinn@gmail.com>
References: <1566346700-28536-1-git-send-email-caitlynannefinn@gmail.com>
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
Cc: devel@driverdev.osuosl.org, "Tobin C . Harding" <me@tobin.cc>,
 linux-erofs@lists.ozlabs.org, linux-kernel@vger.kernel.org,
 Caitlyn <caitlynannefinn@gmail.com>
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs"
 <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>

Balanced braces to fix some checkpath warnings in inode.c and
unzip_vle.c

Signed-off-by: Caitlyn <caitlynannefinn@gmail.com>
---
 drivers/staging/erofs/inode.c     |  4 ++--
 drivers/staging/erofs/unzip_vle.c | 12 ++++++------
 2 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/erofs/inode.c b/drivers/staging/erofs/inode.c
index 4c3d8bf..8de6fcd 100644
--- a/drivers/staging/erofs/inode.c
+++ b/drivers/staging/erofs/inode.c
@@ -278,9 +278,9 @@ struct inode *erofs_iget(struct super_block *sb,
 		vi->nid = nid;
 
 		err = fill_inode(inode, isdir);
-		if (likely(!err))
+		if (likely(!err)) {
 			unlock_new_inode(inode);
-		else {
+		} else {
 			iget_failed(inode);
 			inode = ERR_PTR(err);
 		}
diff --git a/drivers/staging/erofs/unzip_vle.c b/drivers/staging/erofs/unzip_vle.c
index f0dab81..f431614 100644
--- a/drivers/staging/erofs/unzip_vle.c
+++ b/drivers/staging/erofs/unzip_vle.c
@@ -915,21 +915,21 @@ static int z_erofs_vle_unzip(struct super_block *sb,
 	mutex_lock(&work->lock);
 	nr_pages = work->nr_pages;
 
-	if (likely(nr_pages <= Z_EROFS_VLE_VMAP_ONSTACK_PAGES))
+	if (likely(nr_pages <= Z_EROFS_VLE_VMAP_ONSTACK_PAGES)) {
 		pages = pages_onstack;
-	else if (nr_pages <= Z_EROFS_VLE_VMAP_GLOBAL_PAGES &&
-		 mutex_trylock(&z_pagemap_global_lock))
+	} else if (nr_pages <= Z_EROFS_VLE_VMAP_GLOBAL_PAGES &&
+		 mutex_trylock(&z_pagemap_global_lock)) {
 		pages = z_pagemap_global;
-	else {
+	} else {
 repeat:
 		pages = kvmalloc_array(nr_pages, sizeof(struct page *),
 				       GFP_KERNEL);
 
 		/* fallback to global pagemap for the lowmem scenario */
 		if (unlikely(!pages)) {
-			if (nr_pages > Z_EROFS_VLE_VMAP_GLOBAL_PAGES)
+			if (nr_pages > Z_EROFS_VLE_VMAP_GLOBAL_PAGES) {
 				goto repeat;
-			else {
+			} else {
 				mutex_lock(&z_pagemap_global_lock);
 				pages = z_pagemap_global;
 			}
-- 
2.7.4

