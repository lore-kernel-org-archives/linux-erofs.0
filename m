Return-Path: <linux-erofs+bounces-4381-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AECB5C61DD9
	for <linux-erofs@archiver.kernel.org>; Sun, 30 Aug 2026 10:41:33 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hXpZg5WfQz2xr2;
	Sun, 30 Aug 2026 20:41:31 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2607:f8b0:4864:20::62c"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1788086491;
	cv=none; b=GUEcFR9zk3qAiKfX6ZYEBnMbnq9HGgMBAvR8e4VAaIrR+R41r+MqRqNxE8gGIlpR3IxGj2EjGvi6y8sXKIyM7oxwO9dKfU+85uP7hyvhqlhr4NP6Khrc+DaQ43vEVCrUdsm1esejyyh0jS5fN6q3fRakXbtAYeqDSJ726G5LWnVnlFEwnpXb7/h/Z3GvKQHdDo61q8vXG71p11y7iVdOLthLaZkLtP2CI3ngUwRaKbOZCqgfttBq1UiLDVJbCI8GpAderjyv2c0bAzMIExRjeCeneb27IZouZKsbErrUXitS8TPbnf44PLHhcuOwPwXNWbKTedDISUYypDruDO+69Q==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1788086491; c=relaxed/relaxed;
	bh=znTHXW0vFaDslWJG9EPjkjXJi2Xw+kqh5VdDYY4ZDpc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=fNydbFr9UUz/i/b7+Wda+jZERFRDAreip7Yi2iW4iqPJoSbDbG1kSsi/q1LMXUUQgNnqEXXzcw/7u1nEkALfy+X/fZ4TpgfInYxY+MiavKjmH14BTe2qxZfriUzt3X/o+XSckcKJBU/Bwba2mqyhpAVZrDMvWaU1o3OjkZhRHvXmvFW+eGuAIEH+5mY8JjRswVVdM/tDntnQ88VGNzNhFvt1rpH4edbB1RbK4c/bERBCEdIYIV9GjRkSQpLX45w4R9qiLFuaAtgG7qFkfXBZZTKt9WveEuR0lkv1gL+8UOhYVhwbAjU52QzwQ4lQgGsd9qe6z5HIgqlbuujhgzottg==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=gmail.com; dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=q9BZTeVX; dkim-atps=neutral; spf=pass (client-ip=2607:f8b0:4864:20::62c; helo=mail-pl1-x62c.google.com; envelope-from=nikhilgurudasani314@gmail.com; receiver=lists.ozlabs.org) smtp.mailfrom=gmail.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=q9BZTeVX;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=gmail.com (client-ip=2607:f8b0:4864:20::62c; helo=mail-pl1-x62c.google.com; envelope-from=nikhilgurudasani314@gmail.com; receiver=lists.ozlabs.org)
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hXpZf06f0z2xT6
	for <linux-erofs@lists.ozlabs.org>; Sun, 30 Aug 2026 20:41:29 +1000 (AEST)
Received: by mail-pl1-x62c.google.com with SMTP id d9443c01a7336-2d6efd73032so29864535ad.0
        for <linux-erofs@lists.ozlabs.org>; Sun, 30 Aug 2026 03:41:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788086482; x=1788691282; darn=lists.ozlabs.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=znTHXW0vFaDslWJG9EPjkjXJi2Xw+kqh5VdDYY4ZDpc=;
        b=q9BZTeVXRSt3k+PxP6rMnAzPu/QOgBaG5mlbWkeHuFvBjC2CLJG9AzXMYqxg/j9/e/
         nY686HM6y/LjqGGJ3nF3enJ92FFpBD+lDAzdm/xApVs/DIOXXkRE8ZRnoRfufBuplTc3
         t7916K3ywQkKoqMqPhqLXI7IfDjR5QiQ341MIuPCIThvIbBDx5Puq6qaWMWIiU6h+gIF
         QiOto/zObhUlooX31BMV/rj0zAZlgLUk6VmNF5AgEsGpwpmwOjrJXL9TGVERLm0WMvLu
         IDzwvRz6LR7p6GeXJY4DiPzqerSKkKjNcgFxYCBAmpzqc5EGRV7MrN0twiirAZBxNJTH
         ShKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788086482; x=1788691282;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=znTHXW0vFaDslWJG9EPjkjXJi2Xw+kqh5VdDYY4ZDpc=;
        b=e2XP8Vh52GFFxu33wPv1t66kI2aLvVw+7AOgSshrI+Rd2caFCXDyUL1g4K3s6D52yb
         9W0JwrHx1TX5ABnjsd9Ul1KZNAAOrJeyTyu3wCtZjqZf+ylw4xe5egHBBhkBPUYfNV5X
         Q2jLLJv/+xKfZKmAhGHVvkEUL4+Wg4/0jMp91zLZAFUOOc4VPTdO9MiNwkAsc56i3cEB
         7M+SOIbyIp7+I9eT5L2u3VK0vbZjaZ4vDzdY5ZSGaWcs3LM4KZ769xBb/N7vxgArv9ON
         0w2NRiDyCEWla9GIeSGeej5N5YCdT0AUZWaaUiFFrpH1IfAGhV4PRtRufj9txoUYxc7H
         xtIw==
X-Forwarded-Encrypted: i=1; AKwUvByjeYFLaJBEfx0Yiu9B8JHOsL8qpumGtUGG7uhy7fco3Wac2WvGNYt8Op+yg5tp3gnl7Bpbv+j/Ua51Bg==@lists.ozlabs.org
X-Gm-Message-State: AFuF++l+5j71MUQRXDFTmAWdAk3j+G4TPdrs7Dl6v/3MbN08cpfEF3qZ
	vZHbO4pRKQuv4A9Fr/BE1LZyV0Pdrgpisp5sOb5Fp65IbIX9+MZfOYOa
X-Gm-Gg: AYBFou2WEeQkPca8FXEoJe53RWDA7r1pgpxsBh9jhkr3Da2SRsjDBE0ACTwXIowjEDS
	avl8uD9grp0V3Ha6SFDCFJyPhDkMn+4rDhbNFI7ASVd7tOm4i48joNg1qytSVkjSQKuLlyw7B1C
	L3vuVb0gW8rWWtyPDfPjCeqQmqKR6YkefV0Or6d/6kzfEpG9ZSsZ+53055KcfRbImOedWOgn6st
	8O2aq2s+K2q4rObOqpO9T5MPUYIyqPB2oXvXLTU7xM6mNeBGEl4+8MArYOSg6RKzcV3TNOV17GR
	1HbuW9rCcN/nr0+qsPqktqdFTnazW1VNiZyeExiJaU/6xboRSTTm1EM4Sbpnu4qenM3ZVTvGaaz
	GmTROPpq5a6JYjedKZVp8wOovZOnHRZqqcvFNbqvS4vAARR26fzv1z4QSPWiYq8krLqiIdHy99j
	oH3SPZtPEfs3EJq60p5kt6TU7t+CybS8tOXu1mmHFg4cIzmT6TpVdxE07SBfYOEvaambASNEeBm
	UajiTWocbvdKQ==
X-Received: by 2002:a17:902:d58a:b0:2d8:d4d2:d135 with SMTP id d9443c01a7336-2d91b244075mr11865595ad.17.1788086481630;
        Sun, 30 Aug 2026 03:41:21 -0700 (PDT)
Received: from White.tail445f11.ts.net ([45.127.45.76])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-32b26fd7edbsm9791771eec.5.2026.08.30.03.41.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 30 Aug 2026 03:41:21 -0700 (PDT)
From: Nikhil Gurudasani <nikhilgurudasani314@gmail.com>
To: Gao Xiang <xiang@kernel.org>,
	Chao Yu <chao@kernel.org>
Cc: Yue Hu <zbestahu@gmail.com>,
	Jeffle Xu <jefflexu@linux.alibaba.com>,
	Sandeep Dhavale <dhavale@google.com>,
	Hongbo Li <hongbohbli@tencent.com>,
	Chunhai Guo <guochunhai@vivo.com>,
	linux-erofs@lists.ozlabs.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] erofs: preserve LZMA decoders on resize failure
Date: Sun, 30 Aug 2026 16:11:09 +0530
Message-ID: <20260830104109.60639-1-nikhilgurudasani314@gmail.com>
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

The pool-resize path frees each stream's old decoder before allocating
its replacement. If an allocation fails after some streams have already
been replaced, the failed stream is put back on the list with state ==
NULL. z_erofs_lzma_max_dictsize is still advanced as if the whole
pool had been resized.

An existing LZMA mount can select the broken stream and pass
NULL to xz_dec_microlzma_reset(). A retry at the same size also
skip another resize attempt. Since the global maximum was advanced,
thus, the invalid state is left unrepaired.

Allocate each replacement before freeing the old decoder, temporarily
retaining one old decoder during allocation. Stop at the first failure
and advance z_erofs_lzma_max_dictsize only after all streams satisfy
the request.

Record each stream's dictionary capacity so retries can skip streams
already enlarged before a partial failure.

Fixes: 622ceaddb764 ("erofs: lzma compression support")
Cc: stable@vger.kernel.org
Signed-off-by: Nikhil Gurudasani <nikhilgurudasani314@gmail.com>
---
 fs/erofs/decompressor_lzma.c | 18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

diff --git a/fs/erofs/decompressor_lzma.c b/fs/erofs/decompressor_lzma.c
index 6b0cdb446c6a..9d15f94cbee1 100644
--- a/fs/erofs/decompressor_lzma.c
+++ b/fs/erofs/decompressor_lzma.c
@@ -5,6 +5,7 @@
 struct z_erofs_lzma {
 	struct z_erofs_lzma *next;
 	struct xz_dec_microlzma *state;
+	unsigned int dict_size;
 	u8 bounce[PAGE_SIZE];
 };
 
@@ -128,11 +129,19 @@ static int z_erofs_load_lzma_config(struct super_block *sb,
 	err = 0;
 	/* 2. walk each isolated stream and grow max dict_size if needed */
 	for (strm = head; strm; strm = strm->next) {
+		struct xz_dec_microlzma *state;
+
+		if (strm->dict_size >= dict_size)
+			continue;
+		state = xz_dec_microlzma_alloc(XZ_PREALLOC, dict_size);
+		if (!state) {
+			err = -ENOMEM;
+			break;
+		}
 		if (strm->state)
 			xz_dec_microlzma_end(strm->state);
-		strm->state = xz_dec_microlzma_alloc(XZ_PREALLOC, dict_size);
-		if (!strm->state)
-			err = -ENOMEM;
+		strm->state = state;
+		strm->dict_size = dict_size;
 	}
 
 	/* 3. push back all to the global list and update max dict_size */
@@ -142,7 +151,8 @@ static int z_erofs_load_lzma_config(struct super_block *sb,
 	spin_unlock(&z_erofs_lzma_lock);
 	wake_up_all(&z_erofs_lzma_wq);
 
-	z_erofs_lzma_max_dictsize = dict_size;
+	if (!err)
+		z_erofs_lzma_max_dictsize = dict_size;
 	mutex_unlock(&lzma_resize_mutex);
 	return err;
 }

base-commit: a7d28aa0e9b2c983b915d091f9596f0e3b253355
-- 
2.43.0


