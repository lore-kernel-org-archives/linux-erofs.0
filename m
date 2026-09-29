Return-Path: <linux-erofs+bounces-4627-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D8C8CCA5FA5
	for <linux-erofs@archiver.kernel.org>; Tue, 29 Sep 2026 13:39:35 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hvK6G1Nj8z30V6;
	Tue, 29 Sep 2026 23:39:34 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2607:f8b0:4864:3b::2b"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1790689174;
	cv=none; b=VKijXMYSbI5q8yNIuSNqs2f5u+drK7re0FLIx+lKpwoKqybgDSe2VAJb1zVR/rL8BDK7/tkHgAjqFpKldif+7H4FgfkpDPinbXPrMroEBosLx26eRmQ4KIm8xWQUFtyR7YNQ3c4Ezar3mESujp9RAcsRnZkdfUwmjWIZsTvAe/OW+7fMjE33sEbrwtMyeSR0qZUlJ/hOVm2voCxeX1cWbld9TFD2YCqNWFP2MBwPblscARqHpTihr1U7IcdvR+Ccvz/CWAxIrLBInScjI2v/5n92QnOWRp1aHuFFlGbdshyA4e6zDMrqC15WzY4CzMiOzngJ7GHwnvIKtRlcJdc2BQ==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1790689174; c=relaxed/relaxed;
	bh=7nRLoie9d/1UVkBgwaSehcJ2Erx+Qf1tliwRHCVLdHE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=L56K3oUacCmpRe9qpsjww3xeVdnEcO7OKklzb0rHzEC1yERrMR8SsHYneLBtDFLz+zEyz80g3Yd9adBNHMzhGVLxBA81SxqIJqO5efLertTlytpUkyjzCjAWUaxXEo2bdoIpb/eT0pf9rpIpUF8yiowudg7f7AL/9+Im1tk/sjbHZFfoG2Lr+LKOUrUCIl+J2YWlZq0Kg9CciUl7PPU68RocojNO8eli5NAxnGbIwFX5mcJKLzsIxrGFPSlUKGvn9cHMGROe6jk6U5nhNzu6sVVjtnjuDx6ymUvt8VKeGHMrj5DuBb/V0U4FJdplGGMRonj1I+ejsK0y/nQmHpRu4g==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=gmail.com; dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=ontTuAQs; dkim-atps=neutral; spf=pass (client-ip=2607:f8b0:4864:3b::2b; helo=mail-pz2-x2b.google.com; envelope-from=garvkumar1502@gmail.com; receiver=lists.ozlabs.org) smtp.mailfrom=gmail.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=ontTuAQs;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=gmail.com (client-ip=2607:f8b0:4864:3b::2b; helo=mail-pz2-x2b.google.com; envelope-from=garvkumar1502@gmail.com; receiver=lists.ozlabs.org)
Received: from mail-pz2-x2b.google.com (mail-pz2-x2b.google.com [IPv6:2607:f8b0:4864:3b::2b])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hvK6D3RF4z30Pp
	for <linux-erofs@lists.ozlabs.org>; Tue, 29 Sep 2026 23:39:31 +1000 (AEST)
Received: by mail-pz2-x2b.google.com with SMTP id 41be03b00d2f7-cc7979d1dedso1252146a12.3
        for <linux-erofs@lists.ozlabs.org>; Tue, 29 Sep 2026 06:39:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790689169; x=1791293969; darn=lists.ozlabs.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=7nRLoie9d/1UVkBgwaSehcJ2Erx+Qf1tliwRHCVLdHE=;
        b=ontTuAQsMfE2Tpz1tAM0JM/Pvgs3xQai2xpw2ClXXw/WFinuReoTfasitFwJ34pNJW
         Y+A8Ftjzut7EE/6k7DRmZQsfmUmdlE0lyi681HYM98DIfzd4GM6O48kVekMOncgVhZ02
         gSytj/98TXO8Cl3edbmHoT9OOVavD6g5+3Q9FTxzLGIfWxoAdvTFyQMIoj/F85tlFeKe
         KvCcsd68DJS0HNREKPp+sq081bAW2tI6/QR0IhNS8yNYwcOs+tai5mVQvC2sqBjRoz8W
         NCd5q7eH6Ki6I5oCNWfOUD3Ge8tZxEM/0NfYpZjZ5U1/2fjlcwuQPv0RgmzUFzRMcEiW
         7Liw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790689169; x=1791293969;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=7nRLoie9d/1UVkBgwaSehcJ2Erx+Qf1tliwRHCVLdHE=;
        b=JSmFckQxj3uwScsiGH00iWQ8SaSANitsHgOy09gWHHeC3YNUR30BhdFXXt0WFzkiN2
         vE8v56qs5P8S58+TEfPkUc3rlj5LkfjrzSwpCk1seGJaZwDWGuCE+7BC1ne6lVlcbDXT
         Sa2dVg9fsMnjHKNWVEMyoGaEERx866l2CXcW5AxyoatDvRmsbH+Ej7YDnMRbebNoOH0H
         iveANhus8sJn1k7IK4tqfTyLd17PJ1RzWVvSsf6Z+OxUetpiZshIMG3+FpKV+wCk9Ez1
         fmK+Dw80W6JTvYwSgtfC7B69cFaJg22s1tgltY9n1/npGe2ovjUEEZV+2dlBpW/20IfI
         k2Hg==
X-Gm-Message-State: AFuF++ndILUKF5VGUyInag2M9fppS/NwfhmboS9NkXU/ChGUR+Xy6GJy
	EqUZ6a8SRRQiUiCXn3iKJQlMdGrs8LvN36jn+BMAhMD+KZQIo2vhW76OVJFFyNXD
X-Gm-Gg: AYBFou2QMXPtimK3WmB/OtVQG8S1Y+TtV8fZ55+4ASV3t30S0r3lkkLebL5mUuMvMRp
	rdn+6wXqhpmODTyPpvVvDAyJx8Ehm2y8FNOjKRIk+WzuyWLHzW5iFh0s0w0MoDBrGrCFkOQnqbf
	7BXZxFGSY9wVmUId9/1juzkiXEfJR6gk1qbybvj3+Vzof71b/RBVJZUJ3V8CpiZ0qZzl/BEkpip
	UmcGUsaknLdJSjjDV25D8sI6kXHJSFENqb5fBl395kJsW1TNXLpXHhuQ7HDbg1RhutUsV5ST5F7
	3DPma1n93VJu+zNWigxViqG/YPmKW/rB26JiIBNjK612tnAqmc9Esnxh+4QXn/jlR7IzSGlEwOb
	82UcRT1tpXy3c5EfoXxmwn6b9XUmm2FwmH2g1AXDJ1xFgGJOhzrxN4DnhUCCMnLTezZWAqf6Je5
	QeiG7zjUyHvgKvgYeeTe8jCz3voKKg6CPSVup542ZYqTfXn52G961SD5/Ova6kjUQHPb5u8fClj
	AMPXIbIrzNPnYYx9iRrVDBm51xNkfTHMY9hvUPplw==
X-Received: by 2002:a05:6a21:6e01:b0:3de:3f4d:f2c1 with SMTP id adf61e73a8af0-3de3f4df711mr9040562637.20.1790689168697;
        Tue, 29 Sep 2026 06:39:28 -0700 (PDT)
Received: from localhost.localdomain ([2401:4900:6315:3b62:d0bb:7c5a:481d:40a1])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cc78773acfasm6256609a12.0.2026.09.29.06.39.27
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 29 Sep 2026 06:39:28 -0700 (PDT)
From: Garv <garvkumar1502@gmail.com>
To: linux-erofs@lists.ozlabs.org
Cc: Garv <garvkumar1502@gmail.com>
Subject: [PATCH] erofs-utils: zero directory writer buffer
Date: Tue, 29 Sep 2026 19:09:17 +0530
Message-ID: <20260929133917.14100-1-garvkumar1502@gmail.com>
X-Mailer: git-send-email 2.53.0
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

Signed-off-by: Garv <garvkumar1502@gmail.com>
---
 lib/inode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/inode.c b/lib/inode.c
index ec96556..e7d07e0 100644
--- a/lib/inode.c
+++ b/lib/inode.c
@@ -597,7 +597,7 @@ static struct erofs_vfile *erofs_dirwriter_open(struct erofs_inode *dir)
 {
 	struct erofs_dirwriter_vf *dwv;
 
-	dwv = malloc(sizeof(*dwv) + erofs_blksiz(dir->sbi));
+	dwv = calloc(1, sizeof(*dwv) + erofs_blksiz(dir->sbi));
 	if (!dwv)
 		return ERR_PTR(-ENOMEM);
 	dwv->vf.ops = &erofs_dirwriter_vfops;
-- 
2.53.0


