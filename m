Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E976E606A31C
	for <linux-erofs@archiver.kernel.org>; Thu, 12 Nov 2026 12:47:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=ZQKaCcNw
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4jQKt84fmGz2yqs;
	Thu, 12 Nov 2026 23:47:44 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2607:f8b0:4864:20::62d"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1794487664;
	cv=none; b=SjzhtGiUJw25zJi0+Vh3qO1LhzZwQEmh5pOob97NzhdRygTi4vPMf/2QdQr1hOsrYMSXIJwpz7/VG/dkdWvUQh2usHrn42Ne91VtyAqP65FDiEbtQW9xpmgWf/CU5idLat1ULojjc82iT/2s6Lj5y4o/IDwUJKnBooBxru67O2jhd4Dfp0i2/GyBezI168jbdesbtAW17Y8HkxLpABnPc/OEkbXdA4Ya+BrtnoxfzHmMiVd0JKgtdIC71pr/9r3dqhDU5hKNG0vhvO3ycXVaZhUs2jjrGtZacleKk6boEVBgYZRhy3eHvor4SPn+zs0ojgTuV/8axUMfFPafJ47qRg==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1794487664; c=relaxed/relaxed;
	bh=iMZr0RR773r3IWakTqVbp88ylqjWRgFQQQvGSLkapN4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MUtArN9LaRVoS5KFjV7q7LWE6NLFk7UbPzGMlA/+C2Drz3eCz8VJn08A8RoTZ9RNDgIzpGRMlT8q5nU3EPh/BZXBVN5iW3CC8INNttmCzkKysq19isDDqduFx8hxD5Qde5wHBmDY8j2mIjWamODQmU0iKeYPL24otnd9Msf38BO26ARqxI9ChzpZVBxXxWS1+gh7hdIpEtPiFdnrBmC+m7jTP0I5YtBLcEtTzP4mzjIsROvpvpIB3TZDdXgOIIAjKRFGJblwZtxmDYYkGoMlD/ONAW8qYQBXE/3AZ5WI+HeI79UmO2cPPSodgXjTmOMPgBVQF4haRZoRzGfKyvhOgQ==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=gmail.com; dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=ZQKaCcNw; dkim-atps=neutral; spf=pass (client-ip=2607:f8b0:4864:20::62d; helo=mail-pl1-x62d.google.com; envelope-from=stopire@gmail.com; receiver=lists.ozlabs.org) smtp.mailfrom=gmail.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=ZQKaCcNw;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=gmail.com (client-ip=2607:f8b0:4864:20::62d; helo=mail-pl1-x62d.google.com; envelope-from=stopire@gmail.com; receiver=lists.ozlabs.org)
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4jQKt765scz2xly
	for <linux-erofs@lists.ozlabs.org>; Thu, 12 Nov 2026 23:47:43 +1100 (AEDT)
Received: by mail-pl1-x62d.google.com with SMTP id d9443c01a7336-2ed3d8877e6so25535255ad.3
        for <linux-erofs@lists.ozlabs.org>; Thu, 12 Nov 2026 04:47:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794487661; x=1795092461; darn=lists.ozlabs.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=iMZr0RR773r3IWakTqVbp88ylqjWRgFQQQvGSLkapN4=;
        b=ZQKaCcNws9y4NFtFYtB0WZ7t51QjYJC/ttg/wqHhjJNVneeqJtczJrtTMbU9jd2LxV
         tpyZVqt5ctIMqB4Tk0T58bjAcRnx0Ba+Fs2agpzfm1NjhNkOp3gNqNrpouYxyTmD+1w3
         JxkWnPgwpuJPfrmC0OsjSW6wmIiNxvcn8Bu2YmtGduGAgN5wPCxKQ0i3NzgNA31sbBUG
         8Rab/edrgQQZZqFC1LxdOaT0kMZmm5zRZ1fEU5VeO4bzqyyEUWSSt37HKf2CXV7kBz5+
         QUI9vycSvbhLfmqKzRz01hn4yj0reALyYx/8ZOYVgv6bYmIq+7M3FtGFWdhV2nxpdUhD
         oBcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794487661; x=1795092461;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=iMZr0RR773r3IWakTqVbp88ylqjWRgFQQQvGSLkapN4=;
        b=kMFY+KlAUMSE2ecwfyzxw4shjHtUf5b0R+9byqAlJlbliNIPYI6kyxgpNRfMbwiibZ
         ZafYEhTM1mSt1R7PukdZ4tV9j6oj0eHuI0wQcKOPBkRKDoRQjZf/JVQBM6Z+7JzasiO6
         fohqceoP0dQdPOMFYrEMsSQxSlmLn8ixBlPK3xsr57S+7aQDFeUHt41Nir2a8BWkl0xk
         KVCpN6RWaVFjBCUDsUZQGf+wy3INFRB7A022NhSP3pW94hgl89lL3I+VyKouLrqWqhqI
         wOhLGsGMeffty1VEsnAad9Dp6nPERUZTKn2t7aNb9ZiJQkNSsg4XyjwaIous2kXkQ28C
         EauQ==
X-Gm-Message-State: APuU4Z+FMGTZ4BrCrD0MzJkCMiD4Yb9YWEOp+F10H5dhSM/reENgTcPy
	twCTQhp6ltKS/+AQn739Pq87J1FRuVlXrW1xy8xhXOPFfm5twwbtILz6SD2ULmDJ+l0=
X-Gm-Gg: AYBFou2Zg/R1izPhgBGrNBz7O17MU0AFaO6TmiLkryqeYB6IFvbbKU5f4aPxjAnHtO/
	MQAB+cJlNC4V/1AE4KSeK7EXiMMH8u1gq8qVZYlppq8SKQWlp9/kVqT0cI6bm4o04/U/f5zgPnO
	4qQZX9kJj+1qB9rx6DQ08qKBOwXlBsR2eFdakBPFstrIBiHYLGf4WVMDIiq7l37kD1U2aSoIwN3
	oyyrkAMxu8ulLs6lEOdU5sAEnZWXqYedTFJvd5ElE4QrwBvwdJ4xaJxZtfXKGGWbPHfPuGVLlzz
	yVFVCOFioRit0f/5F1tssKWAI36iuNjTVM3gM55iTjQ0v0xKPSCkSUgd2x8d0qLY84FgrNjDBkV
	7x2DmMRoFuYRK76DBNCzgy7K88onnVwdWzawELhT/jOPUwJuKqNI8wsG6sP636Pi2l9AC30Thic
	PUVRzLgzTByNguVPvfPPY57SWMkgIH96MhJ1/8TCcTg296lPY1yC3kDBZ6xsmaUvBgcLdsnQ+ym
	1QmQOIkuUZCWYCo6ve34EXAO/wjMBaaf6gjur2JPXh1rpvnCsBtRN2tRpNFxmTRRWvE4mW14ANX
	9WQcCQc/hZm+5ugSksjTDgKHfAQPWfHVcMRy3LnELwMCfFeR
X-Received: by 2002:a17:902:ce8e:b0:2e9:460e:ca4e with SMTP id d9443c01a7336-2edd7462d98mr59331445ad.1.1794487661511;
        Thu, 12 Nov 2026 04:47:41 -0800 (PST)
Received: from zyf-laptop.tail52ade4.ts.net ([124.70.231.56])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2edb6dd2225sm34189905ad.56.2026.11.12.04.47.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Nov 2026 04:47:41 -0800 (PST)
From: Yifan Zhao <stopire@gmail.com>
To: linux-erofs@lists.ozlabs.org
Cc: Yifan Zhao <stopire@gmail.com>
Subject: [PATCH 1/8] erofs-utils: lib: fix arithmetic overflow in large file handling
Date: Thu, 12 Nov 2026 20:47:18 +0800
Message-ID: <20261112124725.2774244-2-stopire@gmail.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261112124725.2774244-1-stopire@gmail.com>
References: <20261112124725.2774244-1-stopire@gmail.com>
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

Assisted-by: Codex:gpt-6-astra
Assisted-by: Claude Code:deepseek-v4.1-flash-1017
Signed-off-by: Yifan Zhao <stopire@gmail.com>
---
 lib/compress.c | 2 +-
 lib/rebuild.c  | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/lib/compress.c b/lib/compress.c
index b079558..e1cfc05 100644
--- a/lib/compress.c
+++ b/lib/compress.c
@@ -560,7 +560,7 @@ static bool z_erofs_fixup_deduped_fragment(struct z_erofs_compress_sctx *ctx)
 	struct z_erofs_compress_ictx *ictx = ctx->ictx;
 	struct erofs_inode *inode = ictx->inode;
 	struct erofs_sb_info *sbi = inode->sbi;
-	const unsigned int newsize = ctx->remaining + ctx->tail - ctx->head;
+	const erofs_off_t newsize = ctx->remaining + ctx->tail - ctx->head;
 
 	DBG_BUGON(!inode->fragment_size);
 
diff --git a/lib/rebuild.c b/lib/rebuild.c
index 94dc66d..2fa8feb 100644
--- a/lib/rebuild.c
+++ b/lib/rebuild.c
@@ -262,7 +262,7 @@ static int erofs_rebuild_load_chunk_index(struct erofs_sb_info *dst_sb,
 			.buf = __EROFS_BUF_INITIALIZER,
 		};
 
-		map.m_la = i << chunkbits;
+		map.m_la = (erofs_off_t)i << chunkbits;
 		ret = erofs_map_blocks(inode, &map, 0);
 		if (ret)
 			goto err;
-- 
2.56.0


