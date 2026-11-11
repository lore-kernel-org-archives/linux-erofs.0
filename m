Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43FB0606A324
	for <linux-erofs@archiver.kernel.org>; Wed, 11 Nov 2026 14:15:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=mz4wwBz4
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4jPlt43lz7z2xK7;
	Thu, 12 Nov 2026 01:15:40 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2607:f8b0:4864:20::132f"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1794406540;
	cv=none; b=h0krIF8MkSZe1k7g5gjNVD7aKqxqMmAOUcoj3/NA6leeF/hLrq19ZAeV0GMJV6ZKw6Y479nqE5RKJ0+AjoVv8iSV3E+B+TkCeHTFyZLjt1Ki17mFS/bl5c92YMOCvIaJCBnuZzG9V8uhVXOyBfOLlGnA5ixTjLHRQkfu74jyAeXw9VTSiLWL+c8bGf22hSbuNWHsJd8bYUybuw2cmmua10NzqNgXVoPLTZ2nmzsQrrQcyx6AFwAjySldSuHF/aksvgeAvHSJ7baalbNYKCNexepp568RACEvCnvmy2OlcMqgqKjOfnVRbPdjBkb9VuVDaKEm8fdEg2b4zY12no2d0g==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1794406540; c=relaxed/relaxed;
	bh=hD0FvPuK89Nc4itApZkfNbLnC4rRCi60V7hm0Ulu9Xw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=oQ8G9QrXOaCnhYihYXepStyvlHIqltqarImNKRblckouTyBymxMRRCkd0Jt0tJzphcdW4AlJYFKaQad5/REnLCE4lTgzxsJfJJkssaMquAEneXx2KVO4Scshw9HMzwV2t0/iBHD+AfMBvcQxcdZgYgNeOEMr7EBxixyjAHLkbQcZpejLrKhwle+s+ZvYA6iEYRpGQhkKay45gOingtmt3jZ+qyWVsJN44/vL1+CW68SEsDuw+2TDC3dhUyJHLr5zR2YqeYQxtk8Ou4Y/tAJCyagU+8E6z/GvsbYeYpDUhbzwkkxobC7dZCI3vAMfo0JCOqviBFs8P68/fGBZHujo8Q==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=gmail.com; dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=mz4wwBz4; dkim-atps=neutral; spf=pass (client-ip=2607:f8b0:4864:20::132f; helo=mail-dy1-x132f.google.com; envelope-from=zhanxusheng1024@gmail.com; receiver=lists.ozlabs.org) smtp.mailfrom=gmail.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=mz4wwBz4;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=gmail.com (client-ip=2607:f8b0:4864:20::132f; helo=mail-dy1-x132f.google.com; envelope-from=zhanxusheng1024@gmail.com; receiver=lists.ozlabs.org)
Received: from mail-dy1-x132f.google.com (mail-dy1-x132f.google.com [IPv6:2607:f8b0:4864:20::132f])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4jPlt25xTxz2x9N
	for <linux-erofs@lists.ozlabs.org>; Thu, 12 Nov 2026 01:15:37 +1100 (AEDT)
Received: by mail-dy1-x132f.google.com with SMTP id 5a478bee46e88-33fb4680717so3346579eec.1
        for <linux-erofs@lists.ozlabs.org>; Wed, 11 Nov 2026 06:15:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794406535; x=1795011335; darn=lists.ozlabs.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=hD0FvPuK89Nc4itApZkfNbLnC4rRCi60V7hm0Ulu9Xw=;
        b=mz4wwBz4IG9DEGleG66R1rhZ+Tv5Z7HBjLobUIbKGD+KR7ilB6ggPc57Dp3DGUH+FX
         v9J7W9ZVHVPJuC0tJeWeFLx+DF71y2p4plmsIpFhLGWi+uXF031UVc/6s2S+uXN3cCEz
         HUtNms8KEZoTmQKoQ/s3icRNHe1tD+/GD+2Ay1NhrV7/BFCL7lvU5Sxp7uMJbr9N7/zA
         j599WqjJ6TIpV1+GyLCz0fk4oPfCZGoXH7XzsydYqoYKiPtDldqx+nAJ5fDU2B65IpHn
         l5wcGxqDKYP58p252Z6c7fO09j8ah50Z741nemdG/vheYllVLs3/2vLVU/LVbP5y10P7
         fVJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794406535; x=1795011335;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=hD0FvPuK89Nc4itApZkfNbLnC4rRCi60V7hm0Ulu9Xw=;
        b=nSeNaNJJAhjvJQQcHUyUlHpGIg+Nm25u+kqLq/sQa2ubxzEMD0tGzzWo/dk4PvU/GT
         jD2zzqvyP0E0VKK2obu8BTpDO6q8agG8+K8YIMkAw34UGN4MMtsGlftgk/k7eG11EB/H
         XdbNo5foA1OcTlocVPOxSYmqJzxbwW1l1V7LElyNAyOZCtww2yGoHMm98jUq8MrmxbwP
         qp06FJ3NDnTHfjLHk6wwOicsTkTx81McJQbMSgD2JC0ceqra425YJClOsXLSH/ZJDo2u
         9qpu1KpFe90E+DjY7SXs/cniQ7mqh5OrU3dRD/rEVY3UTJJJl8h66SFWOPng7gylZvST
         3ErQ==
X-Forwarded-Encrypted: i=1; AL+hErH3uRgsXGe66DkQ5Sdmken3ZSTbH6QBNfvNHj9NfHbjERQn3rQG6OWj2xAEjh/BUe7DH4MSc7q52GnQJQ==@lists.ozlabs.org
X-Gm-Message-State: APuU4Z8hxRVlmm8jgSwpTsTfsp+O8vvbqwEFkcfUHxNFH7vSioZohp7A
	kLD+swY4etKQNeM92zisYU9lw9m4hqvzBsjZLRIiBG69TOw0EcxxCW52
X-Gm-Gg: AYBFou1l8AxNph5qVdvYya+3w7m+6YESrm8q8VCxpsEHWraHVBJ22m7jHgpyon3TwH+
	iKKcXGpWylujPQDEwQXPnXKrREcGV2R1fK6bUFsLDwlv2CiEdynp/UG7VZG5b54PgIbn7dZXVWZ
	Rdj9nlWa5N93mke4u1LImBbNHhO7T0JlvPjI2ANDUB2oBKK7dHCQIh0fOScuiP9dHl0V/HlbAQI
	XlOqOMHbBoAIDTPlfjUfnXM0bzlakZoP0oFGSIBOssIjdhReALOX977XSUs+qPki4B/0/wfNsfv
	NKqycWxPXul2834RaWC1VWCjJwVXL48/jPOKSH+IBOwoTwkR+HfQDa7RMcSynoHVui6i7O7b/rt
	FjzyGl8ekdVT33Y8/iN4DXrtgQRCIP4R29ScBRIRyLjIfGqndNpXpRFYxM8yGsq40wkK7aVgrAt
	SSlpL5ClVptgppusbtByw18eE1iA3ZwlqYn26OJcS3cocQ6bbYJhSuHxQ4HK7kaaCUc9aXMVUFA
	m4HKFBpCPZY9WynAmjERUJAPZ9in1nZKwjLDN3jOcmHX21uo2mXfGy+84qJXfEqauhPYcwnF2Rx
	JnAxenZ4T6P/xjjduxsN5du/DB81SQJcq3uamgo68NTqGg==
X-Received: by 2002:a05:7300:cc82:b0:370:a11f:dcb7 with SMTP id 5a478bee46e88-37686a4a762mr3171035eec.41.1794406535092;
        Wed, 11 Nov 2026 06:15:35 -0800 (PST)
Received: from osman.mioffice.cn ([43.224.245.178])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-375218c7c50sm32700233eec.29.2026.11.11.06.15.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Nov 2026 06:15:34 -0800 (PST)
From: Zhan Xusheng <zhanxusheng1024@gmail.com>
To: xiang@kernel.org
Cc: chao@kernel.org,
	zbestahu@gmail.com,
	jefflexu@163.com,
	dhavale@google.com,
	hongbohbli@tencent.com,
	guochunhai@vivo.com,
	linux-erofs@lists.ozlabs.org,
	linux-kernel@vger.kernel.org,
	zhanxusheng@xiaomi.com
Subject: [PATCH] erofs: reset buf->off in erofs_init_metabuf()
Date: Wed, 11 Nov 2026 22:15:29 +0800
Message-ID: <20261111141529.719166-1-zhanxusheng1024@gmail.com>
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

erofs_init_metabuf() sets buf->off only for the block device and keeps
the old value when it switches to the metabox or the managed cache.
erofs_bread() adds buf->off to every offset, so the result depends on
how the buffer was last initialized.

getxattr and listxattr init the same buffer twice, for the inline and
the shared xattrs, with in_metabox taken from different places.  On a
block device mount with fsoffset=, if the inode is outside the metabox
and COMPAT_SHARED_EA_IN_METABOX is set, the shared xattrs are read at
their metabox offset plus fsoffset.  The same image mounted file-backed
returns the right values.

Reset buf->off on every init.

Fixes: 414091322c63 ("erofs: implement metadata compression")
Signed-off-by: Zhan Xusheng <zhanxusheng@xiaomi.com>
---
Tested with a hand-edited image, as mkfs.erofs does not produce this
layout.
---
 fs/erofs/data.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/erofs/data.c b/fs/erofs/data.c
index 968303afd620..da4f3e7bd443 100644
--- a/fs/erofs/data.c
+++ b/fs/erofs/data.c
@@ -60,6 +60,7 @@ int erofs_init_metabuf(struct erofs_buf *buf, struct super_block *sb,
 	struct erofs_sb_info *sbi = EROFS_SB(sb);
 
 	buf->mc = false;
+	buf->off = 0;
 	if (in_metabox) {
 		if (unlikely(!sbi->metabox_inode))
 			return -EFSCORRUPTED;

base-commit: 7c26dc33ea7bb677db294bfb4e58d4207477c9e3
-- 
2.43.0


