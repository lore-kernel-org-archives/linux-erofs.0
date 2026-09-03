Return-Path: <linux-erofs+bounces-4467-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 43511C624D7
	for <linux-erofs@archiver.kernel.org>; Thu,  3 Sep 2026 12:09:20 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hbJL63RsCz2yDD;
	Thu, 03 Sep 2026 22:09:18 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2607:f8b0:4864:20::436"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1788437358;
	cv=none; b=WbGOCuzV6JXu11IEYCzlCx0WcNwVLGvY48xs74iGliQI9uJYcTU/g2FG2FUSAj8ryOiSDs+fosJw/Zvjm87WUTiGcKce+41I9eGIgrivULB+Vf9sidrYfpSIKSjmr49ZaAhK6+ngC1q5xfQivjiK7QFVjXsuwHjs9TrvzkpwHNroU6fZh6iSm9gU9kHBGzTrw21vnNYylz8nl5UzlH7yz7st6bbyw2KLtlTtQzJS+bUokoYXovRMswh8PxQKCT839+Oqgu6hXEcXedrfxQJDazTitbmSzC/UY+IX7zvcjaJfhJLyjN4itLriYJCSHyZrxzcQ5YpoSBikPrfk8Moiaw==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1788437358; c=relaxed/relaxed;
	bh=ergzB784m0BqSYJeGyev/0uG+l+9Ci8RteY+uvMQHXw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ct6f1Nj6fMrno+aTLL5x3JFnxdqQGhfuEoxegXbfkyDOqsxP+XZd9mj+1r84WVPe3MtCRB7jHudOgiBESyXhhptalKTM/59J4yflnQN8YZ9UZ209B3eyMJwA9B7QpUgqVoKkX//R7aIe4GL8MbUGRtURrhrhvFBxU5Q9L9v33wUqEL7nWnn86RqFP2u1HJ0uNr5NWP/zd1pWd1wo9KtSOwes6GNYTa0pNlTxv3jP0KDSw9i34faRiSu+wo9MAMY3XBqnq81oEvELdX+8uZnWjrjPnNBoPiW6/7tbvLzykjFFjzl5RMl9y0/mo/e/GOHj23LT0lRCIgp7SRm6AOgqdw==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=gmail.com; dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=dAlBv4O4; dkim-atps=neutral; spf=pass (client-ip=2607:f8b0:4864:20::436; helo=mail-pf1-x436.google.com; envelope-from=zhanxusheng1024@gmail.com; receiver=lists.ozlabs.org) smtp.mailfrom=gmail.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=dAlBv4O4;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=gmail.com (client-ip=2607:f8b0:4864:20::436; helo=mail-pf1-x436.google.com; envelope-from=zhanxusheng1024@gmail.com; receiver=lists.ozlabs.org)
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hbJL55sqQz2xyl
	for <linux-erofs@lists.ozlabs.org>; Thu, 03 Sep 2026 22:09:17 +1000 (AEST)
Received: by mail-pf1-x436.google.com with SMTP id d2e1a72fcca58-8568e3ed034so1913272b3a.0
        for <linux-erofs@lists.ozlabs.org>; Thu, 03 Sep 2026 05:09:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788437355; x=1789042155; darn=lists.ozlabs.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ergzB784m0BqSYJeGyev/0uG+l+9Ci8RteY+uvMQHXw=;
        b=dAlBv4O46l+kUEpdpaiAZ7S116vX1CA5SWhYPAlw6eFRWvlddXoQ4zZE/hRxdOmIPZ
         On77Fe5wyIqr8aCDRUJ4PQntRSMV4WtXtyI1FkrUiWLS6NrpZTnK+uC9k63/rzEbQ2dZ
         u6VLgPQZC5xJ5AXRq6I1UA/TsvcUZBDZQG4urPfd/LbEgs25uJSe+/nHulng6NV2rsu0
         E/BjQsWTVA4w67/E4Ue/1gz3NpoALGYx9bR/++LlEr83b6JfgxOrtpG7Hj9BYQBUH/hm
         hXZ93L3j52muUbeOS/XV7ShbX2Hp5QTfltSnqRstKFKshTz7EoxL93m90qJ0atjNgWZ6
         UJaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788437355; x=1789042155;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=ergzB784m0BqSYJeGyev/0uG+l+9Ci8RteY+uvMQHXw=;
        b=BdM3KcReFpJmRzrd1oAXHMfFcXKM4Tmg7iuULflEb2PsPF6CaXThY/T2A46WNGE9hW
         CZ1tGkJFRLKICvMF25R09s6xwGRbEKlXZj0AzEsZhBg7NWy2nRwAs07C+1ChMVFFkN2/
         wtIC4ZV5FVnqAsg3DYncTBPgBnEZ/dPgztOjsWZJPc0ol0a4CKDrfeXAiLCFZ9Hvf38G
         MDnclHxyTMCz8tB0xZ75XjGE0NUCQp6FQ5gyhpSPWsTaEqOALOaEBa/a9//yWqfZiEq5
         CPiNfKqam/Pj9vivAvxUtVDArGMce03DZqzNns2/KeFWYAp75F+wUBs4TR9yNGWJwNXS
         dd/w==
X-Gm-Message-State: AFuF++kY9PKYvgLBZ1kzoSD7d/CVNEIqpez2PGnEJLP8sJ0wnjycOBiR
	aIpo/4kTsLuYVODVrg25tEIYLpSo8yN4kqZNE8Zp6wIlRKZBoqbBtU0R
X-Gm-Gg: AYBFou0mBV4OEomMaCrs2VAsk9rylXssC9rZsp23LDydrLe/WTSvaf5kxN0/NQUW7eW
	7YzJYvb9MaGaiVsQhgheFVnPkSN5y/YdeJ7XkSxlA41mXoEh1ZwPsGls8iFCTRjankrFLl3c0m9
	bUpzEba14COobx3tCX4dBQfhqnGn4bYfw1Z9d5dPRc6k04oxg4nP5WoKU7/st/bwprYY6Csla1m
	NQfwPyw3M6oMHFtFvyiCUQBxBfKRn1YxL7jPTxtw6Ua4Mk1vYViQdOXskqb0ifzAkcsaRslx5qQ
	JivTeYFnCZJrvU7V3eY6mLvIIeB6ISka192aF/yiPK29XrLwagIjgaC6ZwmjwkEMwrqi4BiEroY
	UrH6hcrFe7dxMuPpmUJi8mnZkoqtesX4Lbl9SWrzS5wBNBr9MPGv5xHXVk4cuL4aDmyB2V2H/eo
	W782ZyMA+Wb0Dry8z7Bo93T9nv6AhL+bVAIzEru9Pv3pmUoLzMVAtXJo/lRdx/a/twutHqdEpp
X-Received: by 2002:a17:90b:3f84:b0:381:25ce:bcc2 with SMTP id 98e67ed59e1d1-39aedf1922dmr18316694a91.6.1788437355274;
        Thu, 03 Sep 2026 05:09:15 -0700 (PDT)
Received: from osman.mioffice.cn ([43.224.245.178])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39b08cacbb0sm5224723a91.13.2026.09.03.05.09.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Sep 2026 05:09:14 -0700 (PDT)
From: Zhan Xusheng <zhanxusheng1024@gmail.com>
X-Google-Original-From: Zhan Xusheng <zhanxusheng@xiaomi.com>
To: xiang@kernel.org
Cc: linux-erofs@lists.ozlabs.org,
	stopire@gmail.com,
	zhanxusheng@xiaomi.com
Subject: [PATCH 2/2] erofs-utils: lib: name the metadata zone in the allocation error
Date: Thu,  3 Sep 2026 20:09:01 +0800
Message-ID: <20260903120901.540675-2-zhanxusheng@xiaomi.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260903120901.540675-1-zhanxusheng@xiaomi.com>
References: <20260903120901.540675-1-zhanxusheng@xiaomi.com>
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

Before the device_id conversion this error named its target:

	cannot allocate data in the metazone when unavailable for %s

It is now a single device message, and device_id < 0 means the metadata
zone rather than a device, so that case prints the sentinel:

	cannot allocate data on unavailable device -1 for ...

Reachable with mkfs.erofs --incremental --MZ over an image built with
--MZ.  Name the metadata zone again there.

Signed-off-by: Zhan Xusheng <zhanxusheng@xiaomi.com>
---
 lib/inode.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/lib/inode.c b/lib/inode.c
index d71a9d1..2cd7bed 100644
--- a/lib/inode.c
+++ b/lib/inode.c
@@ -213,8 +213,12 @@ int erofs_allocate_inode_bh_data(struct erofs_inode *inode, erofs_blk_t nblocks,
 		bmgr = sbi->devs[device_id - 1].bmgr;
 
 	if (!bmgr) {
-		erofs_err("cannot allocate data on unavailable device %d for %s",
-			  device_id, inode->i_srcpath);
+		if (device_id < 0)
+			erofs_err("cannot allocate data in the unavailable metadata zone for %s",
+				  inode->i_srcpath);
+		else
+			erofs_err("cannot allocate data on unavailable device %d for %s",
+				  device_id, inode->i_srcpath);
 		return -EINVAL;
 	}
 
-- 
2.43.0


