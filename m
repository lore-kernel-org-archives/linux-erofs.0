Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97E14606A339
	for <linux-erofs@archiver.kernel.org>; Fri, 20 Nov 2026 10:46:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=docker.com header.i=@docker.com header.a=rsa-sha256 header.s=google header.b=qsXzlb98
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4jWBpL5q72z2yR1;
	Fri, 20 Nov 2026 21:46:18 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2a00:1450:4864:20::42b"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1795171578;
	cv=none; b=FsvZKf0iwmXn8ghWLlVSW2M+fDYp9799u+KsYHX+hYjSvWuRFbJtVJ/LCMaNI7XWFobFkHDs/5xD/3+7k2MXNdngCx3zXJ5qzKuanoFJWoJKOiH8RoIO01HYBzRxqXJk/PT9c4rE1dxQ0dbdp+8ZHJZyM8IUWXJTNs8aCGMwYs5vnbCMg1aj/J/4Pm0IE8bxvXDoxljRhyJsVRkri8RRlaUhxtyKzYcqSr7E/a4yvoGKSEzue5A1w79U4hOg8mV32XRGYtfWNrBkN00sDQTNpmvDW3cWmI2opwtb8h6cMOqvB5bFSjJ/kaGtrE7FgpM9pSHnQK+J9KJlgjmJjKD5XA==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1795171578; c=relaxed/relaxed;
	bh=RSuO3+c9F+Z8zrc/YHyBJ7Aq0YU81J2dUu3uJC9jvbI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XPXKaj2fOxMaIzDtgEuKhgE+HutFibSTaOBdU2GpOVaopD+fswezuKQizcl/Fs02neWi7RqgYTwYBiNryT94eZegA7rBUFq/hrjWi72xegFYI4MQserlZ+m+7rgE4jytgnFEOkwyXlYhe4sg14vMU7QyKGy0rTAZpXc+ood0h5R13OqQ942V3uAt14BbhYYNrRJRAre2UR+1olUOlyXNsSUwmetFjuz1vZBUWz1SnqBeN5dmP5d25rmAgbiTe4lUv0BqnxAajXbD/D6Q0bwPB9Of2CKTBmhudNwrw8B0S7Of98ucMxzWSBilB99utPyNKu/T/xJU2CSIs1ewlR/ZBA==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=docker.com; dkim=pass (2048-bit key; unprotected) header.d=docker.com header.i=@docker.com header.a=rsa-sha256 header.s=google header.b=qsXzlb98; dkim-atps=neutral; spf=pass (client-ip=2a00:1450:4864:20::42b; helo=mail-wr1-x42b.google.com; envelope-from=xiang.gao@docker.com; receiver=lists.ozlabs.org) smtp.mailfrom=docker.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=docker.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=docker.com header.i=@docker.com header.a=rsa-sha256 header.s=google header.b=qsXzlb98;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=docker.com (client-ip=2a00:1450:4864:20::42b; helo=mail-wr1-x42b.google.com; envelope-from=xiang.gao@docker.com; receiver=lists.ozlabs.org)
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4jWBpJ6ZdQz2xpt
	for <linux-erofs@lists.ozlabs.org>; Fri, 20 Nov 2026 21:46:16 +1100 (AEDT)
Received: by mail-wr1-x42b.google.com with SMTP id ffacd0b85a97d-4a3e706b5dfso455993f8f.2
        for <linux-erofs@lists.ozlabs.org>; Fri, 20 Nov 2026 02:46:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=docker.com; s=google; t=1795171573; x=1795776373; darn=lists.ozlabs.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=RSuO3+c9F+Z8zrc/YHyBJ7Aq0YU81J2dUu3uJC9jvbI=;
        b=qsXzlb98Uk2RCNJTZulbXe8LEnyTjjZP3pXhDt+Yx5ugw1RWPqLmvUZtmreTojb73M
         Vh+Pk4dxXCBZqPz3nTjixKsvKTY6Rpr99I+srEgValbE1JxQjxaKOCb+mbfLBgrRXSud
         JGrc0wocSjuCt1eTCBCpRBKGySFIbgk0cQwa8ZJLfRmsNDc3rZ1r0ql+YlJikYOeMy/T
         xrEac164LJo4J67BJCLqvhbtJuklgQ0u0wOFvY1WIG1SwtVDxnymc4wa8rUzYl+O2Lwq
         QE+u4RCE7R7yMu1Ad7L0RWuMuH2SaylCJcs35Wl2ohck3lh492lyvY1VRYjCy0gPOHVo
         hNfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795171573; x=1795776373;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=RSuO3+c9F+Z8zrc/YHyBJ7Aq0YU81J2dUu3uJC9jvbI=;
        b=RLGkSEQ7duPMm+KRU92IcPlPJIqS2Yl3wmZgKsNF+iR7KrAwrgs16tlONGrf2FEE8x
         HA61TwUgU7IMCDxOaImbNyBlHsS1fVfDdyx0vUopw9YZPsdUSSb3CFK42Ar1uWSo+vk2
         RLqX+FhonVHQDkFBBODNg69Qpn+9ITG2eor4gJeZM0yDKWZrDDFijTp0aRd1tDgGoqmC
         Wwn1oFKq54kEnbCKQEQ3cOYREnaqgfgTYBS/ZTxgbaBCstMhdn4DojP/ONQVfpQjpmSR
         9B8vQDo6PbNfEdNkiKRm1EqVD+KCpg1Q39AEd1Z3NhLAQoZi3eqF/oDX1P62w0uxXhfh
         LIzw==
X-Gm-Message-State: APuU4Z9BURVQY20TukciVKA0Cz4NGbXqOlcxwfL04MDVDzHfQf/yiK08
	uj1e5lQGev7QUN35TQNiHNjvtk9iM6mhgulPreAMYppUU06FvbfxCDH5HPjabC6M3LNTU8ZaOKW
	/AI8V1r4=
X-Gm-Gg: AZFdTZeoB/Q9Vj6pSz0JG3CW3LGN3FnU8o/IvMOQMUgoyRiRwcX4xXj6v9g/y6JKVfD
	XUkp2/ZCbx3bAtdSGU0IEwHNf1RkqJm8mFFmT23hUlw2b4hij/TgQG7s5zumfIKKZ3mxbrw7KD2
	p99dD6hOCT4Byd63eFO++PwV2CQLeJbvWIvniq3b2ysNDQTNf0fUCkKyN7k1qUvnQ/Sq4S3mlXY
	jQDdGAKwTPQRHbT6yxuQ5kjx+uy0V1MpqJhPmr39YgYOYDjMGnSb18EajGxVz2ATXEDSQf3oTmy
	O2bHO9x0C5ZRALDfL9o+/S3TiQFNSveUWHwgjH7wuO68W9hO1ijtHVNKYQNI/hi4ZTpy8E0VcXp
	babYd873+YFndg4IobZr1UoahRv6MNsTGZeheFwIcLaSjX4IG5Fk2P+Dn+ofNWNvNyB3PuWE2if
	B+4cHjtwuEgy+vAhzqiFtHRSloVL8iVE5EKJ4gcvZGgXmDlshtSucwAkmTHO+SZbNDz7NkeIfQz
	rG6TKv0M+1kkRPYE4AW6kvPi4v4OSUYvCiR41oJEbPCMqhiScKahUFjm2whdLVrSdwGTQRNo28v
	3t4tYZuoZ4X6efGubLCp4coF37nwInocJjSBVKnLnJ9cQOmEM7I6TD38CTHFtvNXAzgC0+6JHtQ
	PxzZ9kDI=
X-Received: by 2002:a05:6000:4541:b0:4aa:d196:f329 with SMTP id ffacd0b85a97d-4abb4c7afc6mr3550437f8f.27.1795171572657;
        Fri, 20 Nov 2026 02:46:12 -0800 (PST)
Received: from F7R9GP321C.fritz.box ([2a02:8108:8388:6600:5888:55e8:d901:aec])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4ab6b110d56sm4795522f8f.40.2026.11.20.02.46.11
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 20 Nov 2026 02:46:12 -0800 (PST)
From: Gao Xiang <xiang.gao@docker.com>
To: linux-erofs@lists.ozlabs.org
Cc: Gao Xiang <xiang.gao@docker.com>
Subject: [PATCH v2 2/5] erofs-utils: lib: drop unresolved symlink target dentries
Date: Fri, 20 Nov 2026 11:46:03 +0100
Message-ID: <20261120104606.25056-2-xiang.gao@docker.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261120104606.25056-1-xiang.gao@docker.com>
References: <20261120104606.25056-1-xiang.gao@docker.com>
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
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Resolving a dangling intermediate symlink leaves an UNKNOWN dentry
pointing to its parent inode.  Remove this placeholder and return
ENOENT when the target does not exist.

Fixes: fd041ac99272 ("erofs-utils: lib: follow symlinks on intermediate tar path components")
Assisted-by: ChatGPT:gpt-6.1-sol
Signed-off-by: Gao Xiang <xiang.gao@docker.com>
---
 lib/rebuild.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/lib/rebuild.c b/lib/rebuild.c
index a5dd4f3..96aeb0a 100644
--- a/lib/rebuild.c
+++ b/lib/rebuild.c
@@ -127,6 +127,12 @@ static struct erofs_dentry *erofs_rebuild_follow_link(struct erofs_inode *root,
 					       &dumb_wh, &dumb_opq, false, depth);
 		if (IS_ERR(d) || !d || d->type == EROFS_FT_DIR)
 			return d;
+		if (d->type == EROFS_FT_UNKNOWN) {
+			/* The unresolved target does not own an inode. */
+			list_del(&d->d_child);
+			free(d);
+			return ERR_PTR(-ENOENT);
+		}
 		if (d->type != EROFS_FT_SYMLINK)
 			return ERR_PTR(-ENOTDIR);
 		/* the target is itself a symlink: keep following the chain */
-- 
2.54.0 (Apple Git-157)


