Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37647606A334
	for <linux-erofs@archiver.kernel.org>; Tue,  3 Nov 2026 00:46:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=docker.com header.i=@docker.com header.a=rsa-sha256 header.s=google header.b=DQSYLOZC
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4jJVHW5v0qz3c2Z;
	Tue, 03 Nov 2026 11:45:59 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2a00:1450:4864:20::334"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1793666759;
	cv=none; b=e2YxuAzB3QDhBJdA+hFB9JsuB3b1js/bjM1aO46vchXH1k5/1Twp9REEKyQxPT1IS27nFgnvoEQbnWGZc9uO4gatyhUpkf/XEB2YpJNUafViDXV3S+LcqvHKMdBv/zdt0RKTw0DpNdE7rAcvosx3ZZe79EtG8oB7h0MLpBlFbnTfeFf2GdoxZGjreZZKwUrlv99budfYlgy2INAfUDvwJTDsEA/YNRWQFSvVEPKsxbfA8kAKflV/M5N7dRhbTTsUVNY0h41qicKNxk6EnFQfP5/YCynZ9dBeMvsL4XdMwRgwMg9pfTzFyVWcVJhJa91Cr9WqQFUkwKIquTptMuIJ1w==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1793666759; c=relaxed/relaxed;
	bh=UjSWvSEDjM4rFiPtOCoDxNo/jB9W7KHeMORzAlJZb0E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LaqCFoOj7aUR8Ib0sViVtGw0VO4ezjI67Z1RY63TYwDRJZhTOzYkLcijhRfZG5ZorPlRuG1ULf2eSi+qqVOm82ANpWADuePR5YnSIGIGm5iNvT/ZNKIJStl544dua8ecbf+H7kNGUhcv5WPgTf9340TdBi21K4egxTZWLh9R8rLTd9lUBQs489YF5JsxHJhTqyZ/5IVsiBBvbeC1eXkguzCKzolTjJMwBYoYH9JkPaEIGc++XraOt4fm0DWwhD+GfxknBE5vYd9fmfWdfkwuFst3bD8gD9b1x1E6vmo1cOpdITEHZ6QMwcI3WF9LBpnbx18P9CLjQGE0+jAdCBrjLA==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=docker.com; dkim=pass (2048-bit key; unprotected) header.d=docker.com header.i=@docker.com header.a=rsa-sha256 header.s=google header.b=DQSYLOZC; dkim-atps=neutral; spf=pass (client-ip=2a00:1450:4864:20::334; helo=mail-wm1-x334.google.com; envelope-from=xiang.gao@docker.com; receiver=lists.ozlabs.org) smtp.mailfrom=docker.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=docker.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=docker.com header.i=@docker.com header.a=rsa-sha256 header.s=google header.b=DQSYLOZC;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=docker.com (client-ip=2a00:1450:4864:20::334; helo=mail-wm1-x334.google.com; envelope-from=xiang.gao@docker.com; receiver=lists.ozlabs.org)
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4jJVHT5VWzz2xLg
	for <linux-erofs@lists.ozlabs.org>; Tue, 03 Nov 2026 11:45:57 +1100 (AEDT)
Received: by mail-wm1-x334.google.com with SMTP id 5b1f17b1804b1-4afe2d546f9so18821895e9.3
        for <linux-erofs@lists.ozlabs.org>; Mon, 02 Nov 2026 16:45:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=docker.com; s=google; t=1793666754; x=1794271554; darn=lists.ozlabs.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=UjSWvSEDjM4rFiPtOCoDxNo/jB9W7KHeMORzAlJZb0E=;
        b=DQSYLOZCoRsLNWy/t6hvWfFD9Hck13yyUXRtKiOVp9vx0jYDwQuq3PH0iXFKcm5VTw
         qT9qVReW/l4dMk+du4OV0J/i++oMMFp4rzhdMfxoDsuQPMku19+qn8x1l6U6vCGlCsIZ
         1ON7P9j0Yt9e4s21UbR2PEbiItX/odP12g6Sms4qQfSLn84N4ByuFJ/QPHxwljhjN87+
         X/VcTwodnnq5YHW+PldQNjyAAORh7bdzKPRf5KmletzcggPqTZWd1214RaXQloqMdhyX
         luOYNUBR2+nhZzpgFEcAd5IfXzb1HDJqk5XqmNqYYwdQY9UpUsvkSqISzHTCmTNpOTjJ
         +DtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793666754; x=1794271554;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=UjSWvSEDjM4rFiPtOCoDxNo/jB9W7KHeMORzAlJZb0E=;
        b=qqiBxXEwXOO3A33L3Z3tz0XxCdPaA4UIDpLWXv7T2dT/8AWUJqlCK1+10XXj5ArY6K
         TzEzxEQ4iLZ3+snhUO91K53LNZ22GTUE2IgcriFyue//0BBK+ErMSDa+KQr4IyLWyhuS
         LzyvMMJ95qtpQ7gQKKJ1W6HvKEvcFQQ7a6qo5nXLwDaZpdLBc3ZVpiVheaU9zmAu0LlB
         mkN92VXzuQPc1r9hWSqhq0pXEQVO91dxPKA59NmOqKThESDXXp/kXJfwa+gAdEUfe2fL
         T/0qVIX2HKZ5GwtZUVFT2VtUnbeJQrSYO2MB8wGR6Uk/gqoYwgTVdfYvKps1rzfjCw+0
         pWxw==
X-Gm-Message-State: AFq9FYLCfv+rZfuV6x2wOeZ6qz5XrtEu1Qx/HMxB2n787agx+wHGS3wC
	TzD7Q2b75BIMumLEBMvG5q6w3trcI0x1ef2rEkEawgXEkZfbg9dVP4ty3ctWvGQ0wK3QVQNiotR
	M5W/q/XI=
X-Gm-Gg: AYBFou3zYDU2C9J/0rbt+nLp4tfVBpK1d2Z93EAXmRUwBjQq3WJ9qCidvkpV+BgRZfF
	NabVrk8VvcdXx+hHlh71K/RgWI73/bkSw8yQjaEzBv2MpVfUO5O6BELy+P36OCbO1nhVVzS/Xyi
	ZrbzVvEdSAs8tu8e+tlHzJF0WytX/8VGcwsrE0g2qgEPwu4BnOa3NHvQEV6bD7V7RqThtHj6VtA
	eqC87WmYWVxSKkHBrSx6JcQdaSM8MmA+KwTj/9OK5NumXoPlrgJ/AVu6QvZ2gZ8nsOJ/cY3PqXB
	/K/PFp+OC8iAljQ6sD420uzntQqSwlj3dsuEl3RIcfkv/VrQ4LeXeiz5vQj5457k47LUrJNGS3H
	4i+h74eul4mfqts5Poq+T9UyAC6onkRvKHS4tFSCvQLT1lUTPe6QuO+f8FZrezJFLE0p16l2y/y
	wQixSSw5RJWnNQAlVNmzvOFa7Pldq+C4a3ZH44RPKnLxO1+H++P51M74gtnpelslhvBZ3L6pFjG
	S4SmikuWRSR0XRMwPhLZxC+3YW26u4gZepU8LlxNrzNVtyoB7xnRcChYsOfrrgpZE4VtFFaRScE
	BoWgBf/4CRUoptH+/RMgjTxnx84JZHAp8/7i+heeiwyDxOp7+rQOI/AP60xlwR8J0jtE
X-Received: by 2002:a05:600c:1d16:b0:4a1:fa33:441a with SMTP id 5b1f17b1804b1-4ac151a8fd2mr267882675e9.2.1793666753923;
        Mon, 02 Nov 2026 16:45:53 -0800 (PST)
Received: from F7R9GP321C.fritz.box ([2a02:8108:8388:6600:3c00:331c:b5fa:ff22])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4b2a555e59dsm22078585e9.0.2026.11.02.16.45.52
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 02 Nov 2026 16:45:53 -0800 (PST)
From: Gao Xiang <xiang.gao@docker.com>
To: linux-erofs@lists.ozlabs.org
Cc: Gao Xiang <xiang.gao@docker.com>
Subject: [PATCH 2/5] erofs-utils: lib: use positional reads for single-threaded compression
Date: Tue,  3 Nov 2026 01:45:44 +0100
Message-ID: <20261103004547.15053-2-xiang.gao@docker.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261103004547.15053-1-xiang.gao@docker.com>
References: <20261103004547.15053-1-xiang.gao@docker.com>
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

Use explicit offsets when reading compression input. Skip segment-level
fragment matching for the single-threaded context, which handles it
before compression.

Assisted-by: ChatGPT:gpt-6.1-sol
Signed-off-by: Gao Xiang <xiang.gao@docker.com>
---
 lib/compress.c | 28 +++++++++++++++-------------
 1 file changed, 15 insertions(+), 13 deletions(-)

diff --git a/lib/compress.c b/lib/compress.c
index 8305543..aa60f14 100644
--- a/lib/compress.c
+++ b/lib/compress.c
@@ -65,6 +65,8 @@ struct z_erofs_compress_ictx {		/* inode context */
 #endif
 };
 
+static struct z_erofs_compress_ictx g_ictx;
+
 struct z_erofs_compress_sctx {		/* segment context */
 	union {
 		struct list_head extents;
@@ -1345,16 +1347,18 @@ int z_erofs_compress_segment(struct z_erofs_compress_sctx *ctx,
 	struct erofs_vfile *vf = ictx->vf;
 	int ret;
 
-	DBG_BUGON(offset != -1 && frag && inode->fragment_size);
-	if (offset != -1 && frag && !inode->fragment_size &&
-	    params->fragdedupe != EROFS_FRAGDEDUPE_OFF) {
-		ret = erofs_fragment_findmatch(inode, vf, ictx->fpos,
-					       ictx->tofh);
-		if (ret < 0)
-			return ret;
-		if (inode->fragment_size > ctx->remaining)
-			inode->fragment_size = ctx->remaining;
-		ctx->remaining -= inode->fragment_size;
+	if (ictx != &g_ictx && offset != -1 && frag) {
+		DBG_BUGON(inode->fragment_size);
+		if (!inode->fragment_size &&
+		    params->fragdedupe != EROFS_FRAGDEDUPE_OFF) {
+			ret = erofs_fragment_findmatch(inode, vf, ictx->fpos,
+						       ictx->tofh);
+			if (ret < 0)
+				return ret;
+			if (inode->fragment_size > ctx->remaining)
+				inode->fragment_size = ctx->remaining;
+			ctx->remaining -= inode->fragment_size;
+		}
 	}
 
 	ctx->pstart = pstart;
@@ -1579,8 +1583,6 @@ out:
 	return err < 0 ? ERR_PTR(err) : metabuf;
 }
 
-static struct z_erofs_compress_ictx g_ictx;
-
 #ifdef EROFS_MT_ENABLED
 void *z_erofs_mt_wq_tls_alloc(struct erofs_workqueue *wq, void *ptr)
 {
@@ -2169,7 +2171,7 @@ int erofs_write_compressed_file(struct z_erofs_compress_ictx *ictx)
 	};
 	init_list_head(&sctx.extents);
 
-	ret = z_erofs_compress_segment(&sctx, -1, pstart);
+	ret = z_erofs_compress_segment(&sctx, 0, pstart);
 	if (ret)
 		goto err_free_idata;
 
-- 
2.54.0 (Apple Git-157)


