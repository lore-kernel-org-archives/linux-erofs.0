Return-Path: <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1A5C1C6FA86
	for <linux-erofs@archiver.kernel.org>; Wed, 14 Sep 2022 10:51:07 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [IPv6:::1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4MSHF53GzBz3bqn
	for <linux-erofs@archiver.kernel.org>; Wed, 14 Sep 2022 20:51:05 +1000 (AEST)
Authentication-Results: lists.ozlabs.org;
	dkim=fail reason="signature verification failed" (2048-bit key; unprotected) header.d=bytedance-com.20210112.gappssmtp.com header.i=@bytedance-com.20210112.gappssmtp.com header.a=rsa-sha256 header.s=20210112 header.b=oOrs1LpY;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=bytedance.com (client-ip=2607:f8b0:4864:20::430; helo=mail-pf1-x430.google.com; envelope-from=zhujia.zj@bytedance.com; receiver=<UNKNOWN>)
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=bytedance-com.20210112.gappssmtp.com header.i=@bytedance-com.20210112.gappssmtp.com header.a=rsa-sha256 header.s=20210112 header.b=oOrs1LpY;
	dkim-atps=neutral
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4MSHDx1BGLz2xKX
	for <linux-erofs@lists.ozlabs.org>; Wed, 14 Sep 2022 20:50:56 +1000 (AEST)
Received: by mail-pf1-x430.google.com with SMTP id d82so14508036pfd.10
        for <linux-erofs@lists.ozlabs.org>; Wed, 14 Sep 2022 03:50:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=Wc6UqN2rBrRPIKRWEZkd/HK/BLX6Fc+iydsV3In6uJs=;
        b=oOrs1LpYB0NxT5AuspZSwCGv3oFKdg6VgFR8OpUnYS8lvjCNyjNb/6jMklnwW1HBGG
         jI/xowxQ77fW1KZdkpQYusZAof47Be5v/T65EGudfxhj6viEnmeUtuyU7h3liWHDO8fE
         lC9lPZZ1gL1c/pG/d08McSFu81TO3OX20KtJu1juI83ho9KOwBhj74EvxOx5tzd9ofwY
         cwm9FABc2VC+ElY//cOiWMCQBVXGAXyigc9SV5QPWg3+AW7sUeHh9/nTxz5nTq+pU+Vv
         Wy4EE34SYw/R4YMCJiD56PdZZharxDBstXYdsBEDc4DM84Rl3fDPFYlpa+TODRsI/wun
         rh3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=Wc6UqN2rBrRPIKRWEZkd/HK/BLX6Fc+iydsV3In6uJs=;
        b=bvIERee22O8NNvof4GaDAMhAKQ/+Za0KN3p6bZ8I/dBLxrZGmb+dXlLxVWcgBd8BCl
         y1wCcRePz4hfe83Cz6WNcweYq9kOA+TDoWJMhWShKs/rghE3cV1GT1hfaaNSGGET6lXV
         OYezORQhhQAHjrk8EXkxtQRd/2eFpXWfBNdL8mq/fsFwsl+qE0c+575OwzDCAUpsJkxl
         gNKcC9AefOSdHURp7JR6sMWhWtWO1hBOkM2NeH6/NqsIYO/MUBkUlMgA4t4ZkOiJdZye
         Z6HqevF7GYGi3LgIY24Ud3HfTJaEm7s+IQCy9v3zqhXs5U+ZyLZYSXo6GkYI4gSaRnqr
         4rYg==
X-Gm-Message-State: ACgBeo1GbrS0T7UUF6wfhyPsEhGq1yFYkD11OYBX21Sp3h356rmuIlmV
	dz1EO8s4nT//vTT91xTNOSPHev8NnZgiFiQ8H0kmCA==
X-Google-Smtp-Source: AA6agR6IR4Tl5gCLaL9fQ77Ogd5yC58UKWzNowxeQQLx0k6N3fYtgtwq1tRtRPwePR65gLmmmdj8UA==
X-Received: by 2002:a65:6048:0:b0:412:73c7:cca9 with SMTP id a8-20020a656048000000b0041273c7cca9mr32293293pgp.257.1663152654247;
        Wed, 14 Sep 2022 03:50:54 -0700 (PDT)
Received: from C02G705SMD6V.bytedance.net ([2400:8800:1f02:83:4000:0:1:2])
        by smtp.gmail.com with ESMTPSA id x13-20020a170902ec8d00b0016dc2366722sm10537042plg.77.2022.09.14.03.50.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Sep 2022 03:50:53 -0700 (PDT)
From: Jia Zhu <zhujia.zj@bytedance.com>
To: linux-erofs@lists.ozlabs.org,
	xiang@kernel.org,
	chao@kernel.org
Subject: [PATCH V3 1/6] erofs: use kill_anon_super() to kill super in fscache mode
Date: Wed, 14 Sep 2022 18:50:36 +0800
Message-Id: <20220914105041.42970-2-zhujia.zj@bytedance.com>
X-Mailer: git-send-email 2.37.0 (Apple Git-136)
In-Reply-To: <20220914105041.42970-1-zhujia.zj@bytedance.com>
References: <20220914105041.42970-1-zhujia.zj@bytedance.com>
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
Cc: linux-kernel@vger.kernel.org, huyue2@coolpad.com, linux-fsdevel@vger.kernel.org, yinxin.x@bytedance.com
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs" <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>

Use kill_anon_super() instead of generic_shutdown_super() since the
mount() in erofs fscache mode uses get_tree_nodev() and associated
anon bdev needs to be freed.

Signed-off-by: Jingbo Xu <jefflexu@linux.alibaba.com>
Signed-off-by: Jia Zhu <zhujia.zj@bytedance.com>
---
 fs/erofs/super.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/erofs/super.c b/fs/erofs/super.c
index 3173debeaa5a..9716d355a63e 100644
--- a/fs/erofs/super.c
+++ b/fs/erofs/super.c
@@ -879,7 +879,7 @@ static void erofs_kill_sb(struct super_block *sb)
 	WARN_ON(sb->s_magic != EROFS_SUPER_MAGIC);
 
 	if (erofs_is_fscache_mode(sb))
-		generic_shutdown_super(sb);
+		kill_anon_super(sb);
 	else
 		kill_block_super(sb);
 
-- 
2.20.1

