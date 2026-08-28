Return-Path: <linux-erofs+bounces-4360-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8DDCEC61DBD
	for <linux-erofs@archiver.kernel.org>; Fri, 28 Aug 2026 09:52:11 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hWYZf01b6z2xlw;
	Fri, 28 Aug 2026 19:52:10 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2607:f8b0:4864:20::102e"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1787910729;
	cv=none; b=aBJrrtaQdA0dM/W7L11OTXyyu4EiZiOvsut58bZYZ45/V/BJ/TI7VfCcxmlz6wg9ywNZAuga4z1QFUBL371EzqYRrtobwKS9Ldu9kjVelcNogD5pgbX8+xNWigZYGjWyGhPAgt6hmLKwr0BQKmBYx5BOpr3CZ7UR258YyW4MAIJHHLuru/nONQ6l/0OeARL3eW+Q7zxvzqx08blWphCZMKqTM2ZUnzfJam3gVZT+pEaBmnTb2hW6ub4WKuNYmJsYhx2+LFaKLaVLedPSOoOcoTLWXoKz+emW5QAV5gpApjeZHwa0yENw7dKVYgJvc2WdIlVjE/ccLffRc3QNl8WfOA==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1787910729; c=relaxed/relaxed;
	bh=ZJ6ED+haDoK/JTOtYlJ5xHx69NdrwVtynXsgQqjaUbs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=eH+lpjZD/UymphOsPyDNLjefSEKqZogv0fMKqMeu+lWySqxwZIuDOCYKpDEQCjnArB8s/DMZOo/MGeTcBoi6etPSmdMrmiiux9/Bcs4HJ4YoWYRiQc+6IRSHAm1JNBgnN417gR2E7KMe9ObNHNIMVzoEXAy14KjBIIKPadj7XqdPzvOGceT7eNhq7yM6QaC0aR3Xwg3Fqw8GHbGcWcR/K6ePEvh+rBRGAlB3Uc1q8xTUKBvgapHW3YqQC6/jkrNby/CUofirPkZ0SOapzVt4xGxA8e7fMEVAyDi0dus/+9nQF52fWwvUgEf9KSd/tGszcA0aYWwC1B/5wRyU8/bv0Q==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=gmail.com; dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=OAMiPZXf; dkim-atps=neutral; spf=pass (client-ip=2607:f8b0:4864:20::102e; helo=mail-pj1-x102e.google.com; envelope-from=stopire@gmail.com; receiver=lists.ozlabs.org) smtp.mailfrom=gmail.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=OAMiPZXf;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=gmail.com (client-ip=2607:f8b0:4864:20::102e; helo=mail-pj1-x102e.google.com; envelope-from=stopire@gmail.com; receiver=lists.ozlabs.org)
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hWYZc4H2cz2xLg
	for <linux-erofs@lists.ozlabs.org>; Fri, 28 Aug 2026 19:52:08 +1000 (AEST)
Received: by mail-pj1-x102e.google.com with SMTP id 98e67ed59e1d1-3966791a6eeso1114421a91.3
        for <linux-erofs@lists.ozlabs.org>; Fri, 28 Aug 2026 02:52:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787910726; x=1788515526; darn=lists.ozlabs.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=ZJ6ED+haDoK/JTOtYlJ5xHx69NdrwVtynXsgQqjaUbs=;
        b=OAMiPZXfxXZBmQwNgVs8OXcc/P4zsRhPOL0hSqxDl19SFsa9RyJCRQMsqrr4gQNaS6
         LQHI8DK4KIMNy0/2SabbX+J/ZfHZ3qgUEm7YMeP30pUEMrpO6K+woOHi6Z8dU+PeJOV9
         9aNX0sHEDq/0jWE0Ru5Ut7E7ZBaZRDfBItE9wsDRz11rTg5gjBrMI+bJB/DtPhOF8YJO
         xFidD189egA2xfVH0ottFcGDXXXTTB0zEr11bxuW14PxEUhhzBQ1VOMBzZhwwTKsqm+C
         7Yu2SA3W1O3MVYyMKqqxFqKa4bfz+s2i/MxGk3+RXA1qKhMnjfRI4D6E/ibtZMgXWHcx
         fgZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787910726; x=1788515526;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ZJ6ED+haDoK/JTOtYlJ5xHx69NdrwVtynXsgQqjaUbs=;
        b=KOJPo9unTTy0OEJSktNU1mdyqO6Th9RSt4MBXpPiB4jTIXUqANmQ1qHov534Mv4/He
         GjT9TlSa3/QeOVsU46HgGBz1SCi4zLNACaL9jOc5uWspKhe/kY7now9NAJ3l6k30Z6DJ
         E/XOFd/O0XjpalyzrT3xmWyxZfWwrx75MpDFwdd1kCWHFqsFtfgJQBLxLhlHDOebiVH7
         E6un58dQzUcdpkLIDVqfaHwHtdYmvb/TNecf/Jgnna/PL9tpURwERBpxdHFSuXpN5fLV
         nmiv5gTOGCnzuSnuCmFb9MUwLLs6Qu0UguMT+4dCrG6l6Fl2hoBM9THORwWwzgTRw2hM
         q6bw==
X-Gm-Message-State: AFuF++lOcOJFlLRoPt0nrOGvyF/nOBLe1fcUD+t9MCJglv6k9yBgCIHI
	oiheUUZWQnoXdbbxfZCyzmGU3Y30ciI5fCSCUsmFkZpwysMS49NJZvv1u2jFEnBo
X-Gm-Gg: AR+sD12XqP/K985JhOBzMcWTRZsRZ8XPRdTaA1yRqlqg9vjmQS52mVrCtnIp7an5Y1y
	Ho63gj1PNKY8katkwixW5XEiDXSivPcF86AawBSA9g8L/DN2lMEYpSpgYIcMHOH+bScrmMI6+zs
	307PpwJP5riyyyxhFHZUE8eCn3Eh3VfTfCmDXFGyTHLCea07P31ivJRAcjfXy3F0SwwxRMzWo/u
	V4Sm81+iKVnzLLvrzRwaW2lzC9lcofncuPf/ZhcN/uSCbUpU9u4bbvbI+9YbSBm9yt2hHR1yy+t
	bUFHiuKD23Ok8POcwhB86R5WxTpqJ9MZiRLDlTX9rAX02GpEFbEOXd3JHjvyAH39RJYi3vEJBtI
	Qh2RI8xYAa1xI0GOqzcSBfObuTvmR4ZKpwkFnwSmKJ2GroeeWFxw2L5vBXiWQmUBUjSRMfyOG3M
	IfU37YLSoOF9HLId29ufHJXfPijifh6z67nGeER8xWo4mhICkY1cc1Wg/zn62zbssMGLvDaaIU+
	AHDkoSucgQ3OYLAxgbdl6h9dqNob4l1ajRmDSK6
X-Received: by 2002:a17:90a:dfc6:b0:38e:57a3:f218 with SMTP id 98e67ed59e1d1-396d0ef6470mr12979859a91.13.1787910725459;
        Fri, 28 Aug 2026 02:52:05 -0700 (PDT)
Received: from zyf-laptop.tail52ade4.ts.net ([124.70.231.58])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-396b186807bsm6802484a91.12.2026.08.28.02.52.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Aug 2026 02:52:05 -0700 (PDT)
From: Yifan Zhao <stopire@gmail.com>
To: linux-erofs@lists.ozlabs.org,
	xiang@kernel.org
Cc: stopire@gmail.com
Subject: [PATCH] erofs-utils: lib: use cpu_to_le16() for chunk index startblk_hi
Date: Fri, 28 Aug 2026 17:52:00 +0800
Message-ID: <20260828095200.1662955-1-stopire@gmail.com>
X-Mailer: git-send-email 2.55.0
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

Assisted-by: Codex:gpt-5.6-sol
Signed-off-by: Yifan Zhao <stopire@gmail.com>
---
 lib/blobchunk.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/blobchunk.c b/lib/blobchunk.c
index d307a4f..f969cf2 100644
--- a/lib/blobchunk.c
+++ b/lib/blobchunk.c
@@ -245,7 +245,7 @@ int erofs_write_chunk_indexes(struct erofs_inode *inode, struct erofs_vfile *vf,
 		startblk &= addrmask;
 		idx.device_id = cpu_to_le16(chunk->device_id);
 		idx.startblk_lo = cpu_to_le32(startblk);
-		idx.startblk_hi = cpu_to_le32(startblk >> 32);
+		idx.startblk_hi = cpu_to_le16(startblk >> 32);
 		DBG_BUGON(!_48bit && idx.startblk_hi);
 
 		if (unit == EROFS_BLOCK_MAP_ENTRY_SIZE)
-- 
2.55.0


