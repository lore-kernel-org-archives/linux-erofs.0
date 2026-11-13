Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0E41606A321
	for <linux-erofs@archiver.kernel.org>; Fri, 13 Nov 2026 07:58:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=i5YnkL4o
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4jQqPp5QwMz3bQl;
	Fri, 13 Nov 2026 18:58:22 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2607:f8b0:4864:20::132c"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1794556702;
	cv=none; b=Tt9uDX2RRrgRjqRbHlJRS7DsMJPDj/Q65W/Rj28YX5sXXlTHtaUe1OPukS86iWJwcIJAvoB2C8ZIvrmxUHEUN4elQOhFAWPxYom06PtYim8BxhBYihIIcZLkKx6SBj3zdTRRG2W9I0HutOidVziEFeyDhlTV8i2Im8e/kCgPDv/HiEMudwgBDvg+Nm9WKAA2cUsjfP5SciC1CrvL3fdTFu7ts6866dwvHcduJCBMCw9tX0krKC0QwxTmQvhkdG/tvyJ6+b16M3bSbaPOkSgSedZ2E+HDOI3aJhTKJGOnUQo6OD6dVM/Ib7B3SF6WxzuLp+FZR5uacYt9u0JurFSVow==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1794556702; c=relaxed/relaxed;
	bh=scWuz6tkU8SSdwFQjjpPjI1UXp9rIA0HCX8xANp0Ej4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Q++7EWwsciktE2fuUtwyypvC4tbQM/6fQm4mCYKlc2UC8zxXpdGRIJlNeeZv3dO/3cJW1xVMbP9+tUFEniQvdjR7dpQdMhs+iNXfw+oz3w6lJSTpvlAQDLHvrWAJoyz5uNjBCWGRDxDebjuDGr0z4sHSXt78jgSSxrxEUcnGuLcOWEM/S501L8MEbJg9ce3t0XruBLlVdnFBAmpEgu5xG4Wm7KMfevT/8O3jPFHfbpBO8LC14HA4xs0fF5V4qbM1iYiQh0YncdUgRhGL7Usxs6N2CLPZZXBZ3Z3mw9AefWhWS5ZwbTTQuWSk+VgJkhF/i5DzCSINzFrF223RsWrnxQ==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=gmail.com; dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=i5YnkL4o; dkim-atps=neutral; spf=pass (client-ip=2607:f8b0:4864:20::132c; helo=mail-dy1-x132c.google.com; envelope-from=zhanxusheng1024@gmail.com; receiver=lists.ozlabs.org) smtp.mailfrom=gmail.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=i5YnkL4o;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=gmail.com (client-ip=2607:f8b0:4864:20::132c; helo=mail-dy1-x132c.google.com; envelope-from=zhanxusheng1024@gmail.com; receiver=lists.ozlabs.org)
Received: from mail-dy1-x132c.google.com (mail-dy1-x132c.google.com [IPv6:2607:f8b0:4864:20::132c])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4jQqPn4b8dz30Wg
	for <linux-erofs@lists.ozlabs.org>; Fri, 13 Nov 2026 18:58:20 +1100 (AEDT)
Received: by mail-dy1-x132c.google.com with SMTP id 5a478bee46e88-36f6295304dso517026eec.1
        for <linux-erofs@lists.ozlabs.org>; Thu, 12 Nov 2026 23:58:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794556699; x=1795161499; darn=lists.ozlabs.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=scWuz6tkU8SSdwFQjjpPjI1UXp9rIA0HCX8xANp0Ej4=;
        b=i5YnkL4o/omX8bh/8/e+nNOIiMbu33ZQfDFPg2HKqM4DAFw8JWu7uur5w2Kvv/fk2H
         RLbhXyqBNl0b0Em+huDt1P6yxj1nqw/0z4G9xOzJQkwqEZfTtCWRmrYrNEOmpM3On4AE
         dQV837Zayi/db+bf8RQL6L2pKqMqw9M9ZWZTzny7AKUCcDq8tY9iHU4mETIKCfEfEuxC
         jhM/WlSqjOqBP4aVsikQIPoNflYPvj+HBvdkbhRu+rhzbwZq6320Q/iQlW7hC8gecaYW
         y3whqE0rT5FWIsh6NnPSFsagJ1Ioc1s2czGyNz0K8XsbWJ3LBnfBkMpbKRHWvs4FDYbB
         kq1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794556699; x=1795161499;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=scWuz6tkU8SSdwFQjjpPjI1UXp9rIA0HCX8xANp0Ej4=;
        b=EKI5YKhbt0VNLu0bIjIL9dMPMB86Wjqa74FTaieGXNGWLa3Aow8xFqj7b9vRIS0dZw
         s9k64ue/UaApFNRQ9t1N+3/uvWfAOvdsBlW7YU8JmpLCE8CSghQWtN8CvOvwvGfVvtX1
         Th4yEFjaGkaouf6QtkmCAG+V9OlOx8DJTBUuDLnSKS7c8SAGoZ6JcljWFJyU4OV6aTiI
         eRBS38fSm9LqJ9Sxkti+X0tnw4eH5y6lRjfNKWnqk7Wb77yEsa+P7hmosKt3l7oFzAoU
         S0gbvC5x1Bhx+2WN61lzacurpYYla5aaQSLAAVLA1yI3kdDBSUTxyU0y7xNOnInOW+zx
         Rc5A==
X-Gm-Message-State: APuU4Z+akE09zMwaY4NGe2fu40r/zywv7O1UpoD2K8ycSw6unlZx7FUw
	WSm6J+CKwMtyU4MWT+aFv+e0aOk10BMhiPC9m1x33c2cnGBMyLDwrmziN59tCddS
X-Gm-Gg: AYBFou3S4nR0YKav5UYeuQgE3ugopssPV0wd96DNCoiujiavxvDWaetTUEJKB7NaB1G
	rs737oaN204KY3IMMc2u1C35NvqGlgbAhCkSjwJEHIWa94v+gynjQJkdAP0OVrb+J5LOg01Uxyx
	lZgB/BBghvQHWhz3nMaOt1j74qyBPedD+Xd0WoAOAnoWk8Fx0atB9yh/LQjc2iDE9/mFNrascgD
	adhp6FKXZPjJEes2Hc9ygPq/2JoBT4dkpAsu9tDR44oYoV3o3vlqgqX4virVROzDOg1Xmzj0r51
	53fURzUWY+eT4xgmnaF49HV7oMEl8ATJXdxuJQEhbuZXqoTjA8Ezw++qWFgwI5LBBYNMZqcrrCu
	Sw6nyEaG4Ne8VzxJhS7V7BHTxG8ZOQg/B17jEH62TIcJEDpvTe5WMOiv4jyvYlslVgGEX9P4jws
	OMdyvwWgNkTzchK9FOXBQaHaN5Hrd+MIpmsBaFFvyEPFhG31sZ1QJdv3nX+ayKew6pzW4WxHEJX
	Fa5P3elWV6WtdMCQvf6if4c/V2qEgBZb/wnrh6jbRmgufmc6Jf8MZdERsJWgOOVVfvdIhYXT1Vg
	ZE0GO5LwJjTf47bg4Yr6M8+0ci6+Ut3zDRhHF03KCWMhYg==
X-Received: by 2002:a05:7300:8b85:b0:36a:1f8:a56e with SMTP id 5a478bee46e88-37966a5848emr2327677eec.23.1794556698494;
        Thu, 12 Nov 2026 23:58:18 -0800 (PST)
Received: from osman.mioffice.cn ([43.224.245.178])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3795591f4f8sm5187207eec.13.2026.11.12.23.58.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Nov 2026 23:58:18 -0800 (PST)
From: Zhan Xusheng <zhanxusheng1024@gmail.com>
To: linux-erofs@lists.ozlabs.org
Cc: xiang@kernel.org,
	stopire@gmail.com,
	zhanxusheng@xiaomi.com
Subject: [PATCH 1/2] erofs-utils: lib: drop the cached block when the metabuf source changes
Date: Fri, 13 Nov 2026 15:58:13 +0800
Message-ID: <20261113075814.1526283-1-zhanxusheng1024@gmail.com>
X-Mailer: git-send-email 2.43.0
X-Mailing-List: linux-erofs@lists.ozlabs.org
List-Id: <linux-erofs.lists.ozlabs.org>
List-Help: <mailto:linux-erofs+help@lists.ozlabs.org>
List-Owner: <mailto:linux-erofs+owner@lists.ozlabs.org>
List-Post: <mailto:linux-erofs@lists.ozlabs.org>
List-Subscribe: <mailto:linux-erofs+subscribe@lists.ozlabs.org>,
  <mailto:linux-erofs+subscribe-digest@lists.ozlabs.org>,
  <mailto:linux-erofs+subscribe-nomail@lists.ozlabs.org>
Precedence: list
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Zhan Xusheng <zhanxusheng@xiaomi.com>

erofs_bread() reuses buf->base when the block number matches
buf->blocknr, but erofs_init_metabuf() can switch buf->vf between the
metabox and the device without resetting it.  The xattr code reads the
inline xattrs through the metabox and then the shared xattrs through
the device on the same buffer.  If both are at the same block number,
the shared entries are looked up in the metabox block and not found.

With 40 files that each have one inline and one shared xattr:

  mkfs.erofs -m4096 t.img src
  fsck.erofs --extract=out --xattrs t.img

35 of the extracted files have no shared xattr.  Without -m all 40 are
correct.  erofsfuse and mkfs.erofs rebuild mode use the same path; a
rebuild of the image above (built with --chunksize=4096) drops the
shared xattr from the same 35 files.

Reset blocknr when the source changes.

Fixes: c6903c7e32a1 ("erofs-utils: dump,fsck,fuse: support metadata compression")
Signed-off-by: Zhan Xusheng <zhanxusheng@xiaomi.com>
---
 lib/data.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/lib/data.c b/lib/data.c
index 91809d0..9b5d00f 100644
--- a/lib/data.c
+++ b/lib/data.c
@@ -70,8 +70,13 @@ void *erofs_bread(struct erofs_buf *buf, erofs_off_t offset, bool need_kmap)
 void erofs_init_metabuf(struct erofs_buf *buf, struct erofs_sb_info *sbi,
 			bool in_mbox)
 {
+	struct erofs_vfile *vf = in_mbox ? NULL : &sbi->bdev;
+
+	/* the cached block belongs to the previous file */
+	if (buf->vf != vf)
+		buf->blocknr = ~0ULL;
 	buf->sbi = sbi;
-	buf->vf = in_mbox ? NULL : &sbi->bdev;
+	buf->vf = vf;
 }
 
 void *erofs_read_metabuf(struct erofs_buf *buf, struct erofs_sb_info *sbi,

base-commit: b9dd73fb478ac88fc142e6430ed71be43dc65cab
-- 
2.43.0


