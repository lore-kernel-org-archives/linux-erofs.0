Return-Path: <linux-erofs+bounces-3326-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8ADA8EA719A
	for <linux-erofs@archiver.kernel.org>; Sun, 19 Apr 2026 13:16:19 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4fz8Jd72z0z2ypm;
	Sun, 19 Apr 2026 23:16:17 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2607:f8b0:4864:20::431"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1776604577;
	cv=none; b=e+tH5cUN54bcu9K/bb0ViNZDNkqzhMNlwmk7+0LQguwk2M8mTZL3D2bvGFYFgrtpVkwBAaXYqbTaVNyW41l77PMZ+teNWv7bfRF64NYpjHYeYAafrTXTFwF23/DPUPwNXVMcwNZSa3hO6QglTj+DkNdBvltBWA4iY6/LK9LCsTgEdLdwO7m1B74bWPVXiaKzpswisMWILiPxDaXPNQVGhzQqdtmSxS4MxyywAJxpHiiZ5Gnw4i5YptL3wQANl9YcGGwJ3j9SRvxj6obugbGKdVXI6epE1n0VOyjXXIXljmH+rf7ode7evrqjak6o3z2Wkbxn2ssKyLTSbZU3EFFU8w==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1776604577; c=relaxed/relaxed;
	bh=07zAt24ooHXIsJdmsCcVtgdqmX1dhTvTBZHIiJvM3qo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=osNqlz0cfs3CuM2Y7SBn71EJYPjPequi4JL85WA50zOjtoAs6iJLOOyrM3qW/w6Wkvu4sV5dPgB5Njn0XzXnPQB13OfzqvLYPO4UuAil1nUnH+I8wxKs8n2zRKmu3Yp8PmBckv79bZAXqvAsOJIzw3Ixu3yZGxfM4FAdREr7IvFD6o+kaTXTqtqvG052ZmyohGgFOxLme3xm2dnPYFzQdZ10qAjWIMZEO1ibAbn7Z3aRVdNiFeiPSNOOTBKd4Hfccykhxt9EiTtE9GjCxybreDJ6J8D24Ok9T09Gs8XWMeCbYQEm/fFRBgYnG8vtEACVtiToAoZPWTDVqRvBtVhCuA==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=gmail.com; dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=J+/jQiZM; dkim-atps=neutral; spf=pass (client-ip=2607:f8b0:4864:20::431; helo=mail-pf1-x431.google.com; envelope-from=nithurshen.dev@gmail.com; receiver=lists.ozlabs.org) smtp.mailfrom=gmail.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=J+/jQiZM;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=gmail.com (client-ip=2607:f8b0:4864:20::431; helo=mail-pf1-x431.google.com; envelope-from=nithurshen.dev@gmail.com; receiver=lists.ozlabs.org)
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4fz8Jc1mr3z2ynn
	for <linux-erofs@lists.ozlabs.org>; Sun, 19 Apr 2026 23:16:15 +1000 (AEST)
Received: by mail-pf1-x431.google.com with SMTP id d2e1a72fcca58-82f4a53ae20so1665304b3a.3
        for <linux-erofs@lists.ozlabs.org>; Sun, 19 Apr 2026 06:16:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776604573; x=1777209373; darn=lists.ozlabs.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=07zAt24ooHXIsJdmsCcVtgdqmX1dhTvTBZHIiJvM3qo=;
        b=J+/jQiZMR3UjnUnzRLqdyb42nf424AhNeLxrXff2aMoFmCme5KZt2uikncj4M1kevF
         9os2iE2+ohCRfEjmrPVfNLQVz7Y/FtPCLnhhI34w5HeGV5ncpFuWkKHgJNx1N7Go3czP
         vTv/BOUL55YX8JEqu2qg80A9Rha1bNH6lrcwEf20S+/cHlfJDeY2ZSJfa+Xkb6UHJXu+
         TX9yBsXmr9//lXUUHczfiX+QuQevbkRf76/CjdNvxymvm1rLEEuOOlgOXNw0h7LzZ/Zw
         8JaFH6JofYJGPrJU2M22oqj2glSOirtjSWPX2IAXE1Uxc9NQPIHyRoUqNIIH1KvskZXk
         nMbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776604573; x=1777209373;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=07zAt24ooHXIsJdmsCcVtgdqmX1dhTvTBZHIiJvM3qo=;
        b=Z8ZSPN8CshjCiEXSY9xEJ4YZeQ0vFxoIwlpWNxYCMHbUMFD/4Mg7h5VF0fkzUs7TWO
         6NKA113jSn2qLST0ZSS8uAu2g5IAWmomN3ZREbiMkVk7gmVerfhqx1SLvdGWq+os44su
         OvLdt+DwHoV+w/mTDHDS1YwJUl96sOeRCtv8nU8oZC3LBBKxivlnwK4eXLuKpgn+eLM/
         DAAFme5CMuxXFhOjUWchqkf/QuPW508wIbgFkhTy6Q48sl36hV17AH/bzFNwCf+Zpw2w
         Qr2uCe43B4ArBaa5IBIhCVJfSYaL6S5O0c0ttFOtGtPpY2E+xsyEopOFkK172EgRQTTJ
         ayJg==
X-Gm-Message-State: AOJu0YwU8167pRvlF/VtLb+WYvBF2p/6cyZhVGstNOprfP0Zz/iWRmbo
	21Fajp+UgCUfzef0QMnDpjeyY1G7kQK+VPSDhlPxmUIcoUcF3dRxkhC5CKoNBw==
X-Gm-Gg: AeBDievPoLPbDWuQy8Bf7Hhix3GiODK/ruvfjuCq8g8OGL0VU94L68XLBgbTTFrtVBr
	mvO5nbpvZOIFLAUc4H/BYlKxyMXbGRRd4K5H85CyjD1y6Fs7Xwf2GvHQma1M0DzJQkqj9iwUmAt
	gws9kA6eHFGNNvSXRycU1+7G/AxNtk5NzDb43O1gC8Wiom34dlCkbzY8KotwUFAV/5lMRGeQNQ2
	kRUuIcx/dyhr0r3DAyW1L90zCQE7k4YyPx1Vls9HEpvkNoNX2n9AggG6ao/W/CflrCMl2zVSJ0j
	3DX9JkcevADXVCzxm62zXcL4GwYzU1DkiNuUbOiE8s4zgebbbgMoONu1quIQ/GEPYe2itKGZwws
	FruhNiL75Pue1Ju7YIhRU8VbmwlEdPN3pm1Cbqdrued7EXo/cdeUB3PdOidImgKaSxRuWaufRUn
	hzuTQnUqkaOtT6d9t7bYjCnaIJzm02AuJHWDDYGzTokHIFnmlCgR31l+TJp86I0ZHMYTgN1vUwf
	vccFA==
X-Received: by 2002:a05:6a00:4ac9:b0:82c:217c:98ca with SMTP id d2e1a72fcca58-82f8c828d95mr10085382b3a.12.1776604572972;
        Sun, 19 Apr 2026 06:16:12 -0700 (PDT)
Received: from localhost.localdomain ([45.114.151.61])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82f97eb5ce8sm5557779b3a.61.2026.04.19.06.16.10
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sun, 19 Apr 2026 06:16:12 -0700 (PDT)
From: Nithurshen <nithurshen.dev@gmail.com>
To: linux-erofs@lists.ozlabs.org
Cc: xiang@kernel.org,
	hsiangkao@linux.alibaba.com,
	Nithurshen <nithurshen.dev@gmail.com>
Subject: [PATCH 1/2] erofs-utils: fix undefined behavior shift in erofs_init_devices
Date: Sun, 19 Apr 2026 18:46:03 +0530
Message-ID: <20260419131604.95875-1-nithurshen.dev@gmail.com>
X-Mailer: git-send-email 2.52.0
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

In erofs_init_devices(), roundup_pow_of_two() can potentially trigger
an undefined behavior shift if the incremented 'ondisk_extradevs'
value results in an overflow or an input that leads to an
out-of-bounds shift.

Promote the argument to u64 before the increment to ensure the
rounding logic operates on a safe bit-width.

Signed-off-by: Nithurshen <nithurshen.dev@gmail.com>
---
 lib/super.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/super.c b/lib/super.c
index 088c9a0..10831a7 100644
--- a/lib/super.c
+++ b/lib/super.c
@@ -49,7 +49,7 @@ static int erofs_init_devices(struct erofs_sb_info *sbi,
 		return 0;
 
 	sbi->extra_devices = ondisk_extradevs;
-	sbi->device_id_mask = roundup_pow_of_two(ondisk_extradevs + 1) - 1;
+	sbi->device_id_mask = roundup_pow_of_two((u64)ondisk_extradevs + 1) - 1;
 	sbi->devs = calloc(ondisk_extradevs, sizeof(*sbi->devs));
 	if (!sbi->devs)
 		return -ENOMEM;
-- 
2.52.0


