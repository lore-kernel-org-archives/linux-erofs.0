Return-Path: <linux-erofs+bounces-4466-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 76DC0C624A4
	for <linux-erofs@archiver.kernel.org>; Thu,  3 Sep 2026 12:09:15 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hbJL20dGRz2y2Q;
	Thu, 03 Sep 2026 22:09:14 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2607:f8b0:4864:20::533"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1788437354;
	cv=none; b=R9/9e7EAsqXXavQak5OgmuSUeZvHf62VGm2fIf9FG/zlxmMr3H8E3JewbAhAQJt26kHIvOFe7V3witR020QPd9c1RnHUxwgNe/c4Xsxx+11aGphowiKfMymN9z5aeVWDXw6Aq+QELMMDZ2Z67h8cC0F/a1LTx3pebEsVs9H1JiMhwUDKqwKn/8vAOUOPLlX/N8TkD25BpTtg4LylypNcB4+teSbYPwpmR9n32p9FluHPZVuBfPhUScFnIhz/Xc5VwKUyJN1hpVuF9l9V+U6S7RCyWGguXaOqmL+uw68ImjiD1FuXvQU1n1WrURgmA5sPQlGZvxPzLzIkSF4R57k0LA==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1788437354; c=relaxed/relaxed;
	bh=9FqSSC9faAu+Pq7rKQ4ARAyltD3dfXUDtyyonTc1IFY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=FjPYiJ5SoFEAqBe+W1As+kFNa3ED11pV6XeMsLmvaluBGwPkM/WZvFf4Z0Va2mg1MhbFkNUifvnK+xYBf/FTafV+gZEYdGlAaKXWCoqHWegh1lwDvSYf6AdwBCVM16yvhgtkM2bz8YVmUYPzJdVMoZGuBRMDC6QvscC5hCz12labHOnZ03fmz+JgPcxdN1815pNQErDYROTNYgHntLv8AxYpCNu/4edLZprna5KjxnOzcVzOveNCe/fztq3dp19QVJhO19pfUt3BllWReSu04+5StJM57Ibzdb6MwGKhWcRqBjWV31m8dVvbh6WpGfw4YyCfiChvNr3jwinA1jRXGA==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=gmail.com; dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=W2dzCUKQ; dkim-atps=neutral; spf=pass (client-ip=2607:f8b0:4864:20::533; helo=mail-pg1-x533.google.com; envelope-from=zhanxusheng1024@gmail.com; receiver=lists.ozlabs.org) smtp.mailfrom=gmail.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=W2dzCUKQ;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=gmail.com (client-ip=2607:f8b0:4864:20::533; helo=mail-pg1-x533.google.com; envelope-from=zhanxusheng1024@gmail.com; receiver=lists.ozlabs.org)
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hbJL03cv3z2xyl
	for <linux-erofs@lists.ozlabs.org>; Thu, 03 Sep 2026 22:09:11 +1000 (AEST)
Received: by mail-pg1-x533.google.com with SMTP id 41be03b00d2f7-cbe6295f05bso648853a12.1
        for <linux-erofs@lists.ozlabs.org>; Thu, 03 Sep 2026 05:09:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788437349; x=1789042149; darn=lists.ozlabs.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=9FqSSC9faAu+Pq7rKQ4ARAyltD3dfXUDtyyonTc1IFY=;
        b=W2dzCUKQVP2Dxby5fkZE10BAJIRC2JVBXO0lq79BZZ6A66Ki7KSw4r6iKvBEcoNx/R
         rUsFn+ChqMs7UJZKn1PfPWO1Lg8ufQcqgulESjTGeFJekiiP+JhmFA47wUufmFitW/WF
         c+nLVr3AxP6z83i4o8EkObO0nVmuIpkHBTBV8Kji14CWKTGgviWw8kOqhw0lt6xsS6gu
         RGG2+EsR4TajKIGKuD5WiOAmoXNYLSTDgv0M6wLEWV3d9qytAabFpJyIFDnqY4h6kDmg
         OK/M6zjg1A5oPQ/vV+eqLGQOfKWhPj70Yb/TC4jHU0mpWaQyBEI6KDtMUnsuzwpr18/n
         Z+rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788437349; x=1789042149;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=9FqSSC9faAu+Pq7rKQ4ARAyltD3dfXUDtyyonTc1IFY=;
        b=kLy0OEKh1aqEwllQ13scr6IL0szuv7d/Sp2co0idKMXqmkRyU2TMNaeRfDQoQKfGHc
         NvoHneUPxGSnduLEEwcfQU7aubBtId510YSEmUvs17KUNUmTQ6fqcV7fPQXn01zsaSxd
         v7JamRuprvzOPW6xSOmfeFBFh6H+eID3BgSroyUIuLtgwAofUszYYaR5Ie9lMk/UrbWs
         CYNb+ORNzZ4t2ut8HeSj2Ls6YSZ98SwLdkV8BThWQfvuWXgG2/z4Ah8d6unTLYsNcxrE
         mjlHC6Dja/XDdTcWq5vxEEtPMQgvv+Hb6gFxjOtRYTV5L7ANRceeaDBr8G338539v0ce
         NBFg==
X-Gm-Message-State: AFuF++nB0Wpx5rhec5KXE0J1l1NPCPh3Sood5nXqC9MtPoImr0ZIAXBd
	pnb4XQ4BoLNBvcU06cXNvNeQI83tNpXuJWKHsbHautEghOHFTszILHSZ
X-Gm-Gg: AYBFou0rQ8UKb4boLnN/BUWNOrrzPge5iAJ8KzK5rmFBrpS06bE6EApx63wQv2n8Jsz
	EhuJPCa6FCaeIDq955Awlmehdk8TNyFgVDl/Q5u0rD9WENLKj0ncRdDzEHwuWfyv9he3WenMWxz
	t3fOXvQTJSkPub5lQDkdxsK3T9iRLtMm/6HVWOSF3V4F5sDlPvPUl9v2WH+v+OgQVF3VDG3efeC
	+GxFOjZfRrtLQ0P3xa/6NjUSNN2GZmit3WHUPhUF6Bj2QVj+DA7Fjtm4ILffdRt0cfgS4KxFmNj
	l66rPqlqAxJu5WDp7vZkjqA0rD0EYG52bXciT8P5RklOgi7HMMLhY6WYQ3U0sJYRXHTMOy9Wmqt
	pZB00FBZRJvQAzEXCiXxIHD7jAoMTRgXF3fExcKtIl6TmbODn7A3ESDnbHuyTsHrYqq7jbV0yDz
	hZmfPcW55ynBP50OI+6GIRctv3Dj2EKYYLUlu/B1tqEviUatNhbFWo9BjMwH49C4jdN5Zs2Wdv
X-Received: by 2002:a17:90b:5706:b0:38f:657:6823 with SMTP id 98e67ed59e1d1-39b1325b657mr2721393a91.8.1788437348699;
        Thu, 03 Sep 2026 05:09:08 -0700 (PDT)
Received: from osman.mioffice.cn ([43.224.245.178])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39b08cacbb0sm5224723a91.13.2026.09.03.05.09.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Sep 2026 05:09:07 -0700 (PDT)
From: Zhan Xusheng <zhanxusheng1024@gmail.com>
X-Google-Original-From: Zhan Xusheng <zhanxusheng@xiaomi.com>
To: xiang@kernel.org
Cc: linux-erofs@lists.ozlabs.org,
	stopire@gmail.com,
	zhanxusheng@xiaomi.com
Subject: [PATCH 1/2] erofs-utils: lib: drop the dead bmgr initializer
Date: Thu,  3 Sep 2026 20:09:00 +0800
Message-ID: <20260903120901.540675-1-zhanxusheng@xiaomi.com>
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

The chain below covers all three signs of device_id, so the initializer
that runs before it is always overwritten.  For device_id > 0 it also
resolves to the metadata zone instead of the device.

The call is not elided either: erofs_metadata_bmgr() sits in another
translation unit, so erofs_allocate_inode_bh_data() calls it twice.
Dropping the initializer removes one call and 10 of the function's 101
instructions on x86-64 with gcc 13.

Signed-off-by: Zhan Xusheng <zhanxusheng@xiaomi.com>
---
Requested here:
https://lore.kernel.org/linux-erofs/aphHlNHyv85i1A3u@XiangdeMacBook-Pro.local/

 lib/inode.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/lib/inode.c b/lib/inode.c
index 24be613..d71a9d1 100644
--- a/lib/inode.c
+++ b/lib/inode.c
@@ -201,8 +201,7 @@ int erofs_allocate_inode_bh_data(struct erofs_inode *inode, erofs_blk_t nblocks,
 				 int device_id)
 {
 	struct erofs_sb_info *sbi = inode->sbi;
-	struct erofs_bufmgr *bmgr = device_id ?
-		erofs_metadata_bmgr(sbi, false) : sbi->bmgr;
+	struct erofs_bufmgr *bmgr;
 	struct erofs_buffer_head *bh;
 	int ret, type;
 

base-commit: 0beeaae8e8ccc907fd2a49ee054aa882c76b40d4
-- 
2.43.0


