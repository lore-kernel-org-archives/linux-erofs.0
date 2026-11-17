Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3103E606A31C
	for <linux-erofs@archiver.kernel.org>; Tue, 17 Nov 2026 07:27:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=GTQnh8g/
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4jTGWr6Gsfz2y8p;
	Tue, 17 Nov 2026 18:27:04 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2607:f8b0:4864:20::435"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1794900424;
	cv=none; b=HQHllURZlHJhJba6gjBuKi8hOOefPL3ITERFHzKDuVOhDhNueRS4cBzoLzAm1XNlVxF9ud16XzuwIn/vcqdZ1u8Nlz/A/jHDGDvVXiGGJV8MMgyUddUlQbfEx/5WJ0zYsyz+PpbELLApsLIHn36UuxdErrd2Agfm9WVuvSo8AYEmDuLoAA49KmKFpgZC9SDIsmZPFpl0UKZ3LsOEw3P4raHr+yfXCKL4SXWAElzQsUDw5mWWxqoHr2CHuzYXp3a36tOkyAHSS5BflKttiH1CwHoQr20IpPKUd3rCDPKyC9HWgpDVSV4sh+gFhkCbZTSPNT6XoFYdqlqb/qUl4bbALg==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1794900424; c=relaxed/relaxed;
	bh=ugrCFoVuEnY7A97vOhK99b1ZGvPnObgQRhfWP1VHBwk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k5TZf07U0agGBh7PZgEa+hXXhPkcOuTTYt9oMUSHogfAGdsFp2Ano+V09+bBvfR55Wip2tnmWDv+c7fRPbHCEz53wLCMD+ylxvXQdOQQROGXPEx00jxC06FKTFbNyamKuLn7bEEmwD/ETUuo6sAMthZyNz6mn5dwD39iWUCRDKK87nJqevja28L1J1liWdsIxYVnoOq7TLK4mKzX72fENnlbA7CZQLEtEZJKS7PM/bPW15Di/8NMDZRz+AjNpyPVn53CBJ3J58oEk25R2SHJW5CyOhstYPlZtoQhozFjT71aqgQqoZE5pykN96Dkdri2Gqd75UvycoALYS/pyyMr6Q==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=gmail.com; dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=GTQnh8g/; dkim-atps=neutral; spf=pass (client-ip=2607:f8b0:4864:20::435; helo=mail-pf1-x435.google.com; envelope-from=stopire@gmail.com; receiver=lists.ozlabs.org) smtp.mailfrom=gmail.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=GTQnh8g/;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=gmail.com (client-ip=2607:f8b0:4864:20::435; helo=mail-pf1-x435.google.com; envelope-from=stopire@gmail.com; receiver=lists.ozlabs.org)
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4jTGWr1csGz2xPb
	for <linux-erofs@lists.ozlabs.org>; Tue, 17 Nov 2026 18:27:04 +1100 (AEDT)
Received: by mail-pf1-x435.google.com with SMTP id d2e1a72fcca58-8b5a6f2f27fso1865763b3a.3
        for <linux-erofs@lists.ozlabs.org>; Mon, 16 Nov 2026 23:27:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794900422; x=1795505222; darn=lists.ozlabs.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ugrCFoVuEnY7A97vOhK99b1ZGvPnObgQRhfWP1VHBwk=;
        b=GTQnh8g/GNAUzbS9UQtk61ltlY4i2CHRuvGMNJ+ACLDJfxDPJ0zZNNUq34M8G+LSbE
         ymAsO65uziXvzz0fW7ofiP+Ny9eobbp4sp1L2rZiD320HJzpMisC2df7pY/4FzW1aVsF
         QbQKgQqpQ3bzTexdsj8v+SUwEiIQCPuSnOueezh6m5go8jfSu7dyPxS5ZomW/13IcNMM
         CwMoeOMFZD/ltpuVopMzHYtYOuptQs1nFzQQGO0bAtBv8xY3JkO66eO34Z0Ju1V07oKS
         NPx1Ny9TJac5JAldFdxxtbkuZC7bdv6Lff8kEyCCcemJ3AVZoMpVQZZhUKorUamoyXs8
         6r3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794900422; x=1795505222;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=ugrCFoVuEnY7A97vOhK99b1ZGvPnObgQRhfWP1VHBwk=;
        b=sWFh2yayDeaN606VN9qGaqTagNWq/MJ8h2DWtUh18lWmdDh4Fa3hzrmwo1bWo/4l4D
         IGf36IDxXsFqv1YSd24MjKz3ypeSe2zlO9P9OQZQTsjlT7x60krCLjv3S3J/4lWUVFqc
         j4AUttwObrtG8LolHrc14w8lKkQOnMmQxlNYMJfVt3TRaq4NQaFpOyvbR3hH/Rzuou8h
         kjUT6iMHHP6+L6LmYIbWpigx0W5f7+5YbJtUDyisKRJhXu3dyMDrJeTI4m3Pev62bqwV
         jJHcWVDYbFlBjBPtB4AhwbWWblaq9FBvZWfvnVjt/PC7A7Z2c/iv70s0N9XLgUJU6MoV
         Jeug==
X-Gm-Message-State: APuU4Z+KgAGyFDYFnaoOug6U6QCfELYQcuk9jO70CVJJaXg98tJ/HscN
	f4hO1xbCKsOPhQHCiIm2NredsrGfSOgK6FM+yLsuXz+QxT4FroLW1bZnfMR1BXT3gfw=
X-Gm-Gg: AYBFou3zdc29xhWxH6DecPDwxIzGsSfnA5QuFbtJ2DXruj79gziQPI6GscRBnQjiD8U
	6DZ3I3eUPFq9QCSH+A/tJuKTcaCl68PfEADG/CW3NFM1wR65f6ZpVYCSXLkr6vqYzx5x144rTD2
	xUZ7qBUL6v06jSH4loFdKlaeX/jifgdFOWitXUkDqEfZcAG/KTrQUmy4Bg1d8GIRnp7NSBMARAr
	qqRTRDwE5Oci4Ygt8TyUXSvKBLcivxonkcoRn2gZPi1e+PZO32mFxH9nTUNj6nCGtQMvoesm6cy
	yQAaq/CeRj15QrMELZlrieipqiL23/g9rT8tT+L1DCuzhz5Y6t36RZ2EmkTS+55eZdlo9/xkedx
	liy/62Px+TSBkYsQrNSl6YzAT2ppeRqoEmdWEMKIK2fbonIFPijeKGDIxQnKGRhLcbu/eGkS5/N
	12uennMudDf50IIbb+KgsSedFUvujT4+cRxNwg3krZD8X/6Rn50+euJAkfYMki1++8S+ymXjSJJ
	A3gwddHa/hTq7dFjNxPfjT1g8ioyMtQgV0qEXUd1NvaEpSHKUxGx2v468g9M+u8XVDxhAA9Hqjc
	dlz3eGc9U9lHrBNApsGF09bSDwdcQX78qpaMe7xpxcC1J3Hv
X-Received: by 2002:a05:6a00:2d09:b0:89f:7ed5:865c with SMTP id d2e1a72fcca58-8beb5ba8e71mr11593750b3a.9.1794900422411;
        Mon, 16 Nov 2026 23:27:02 -0800 (PST)
Received: from zyf-laptop.tail52ade4.ts.net ([124.70.231.56])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8bed2055031sm4940716b3a.39.2026.11.16.23.27.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Nov 2026 23:27:02 -0800 (PST)
From: Yifan Zhao <stopire@gmail.com>
To: linux-erofs@lists.ozlabs.org
Cc: xiang@kernel.org,
	Yifan Zhao <stopire@gmail.com>
Subject: [PATCH v2 3/9] erofs-utils: lib: fix erofs_io_read() caller error handling
Date: Tue, 17 Nov 2026 15:26:23 +0800
Message-ID: <d1dcf98ec64a330ad19c2a1e4dea75a1488fcbff.1794899782.git.stopire@gmail.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <cover.1794899782.git.stopire@gmail.com>
References: <20261112124725.2774244-1-stopire@gmail.com> <cover.1794899782.git.stopire@gmail.com>
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

erofs_io_read() may return a positive value smaller than len on a
short read. Check the return value correctly in its callers.

Assisted-by: Codex:gpt-6-astra
Assisted-by: Claude Code:deepseek-v4.1-flash-1017
Signed-off-by: Yifan Zhao <stopire@gmail.com>
---
 lib/backends/nbd.c | 2 ++
 lib/compress.c     | 2 +-
 lib/inode.c        | 2 +-
 3 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/lib/backends/nbd.c b/lib/backends/nbd.c
index db0df44..81506b1 100644
--- a/lib/backends/nbd.c
+++ b/lib/backends/nbd.c
@@ -600,6 +600,8 @@ int erofs_nbd_get_request(int skfd, struct erofs_nbd_request *rq)
 	int err;
 
 	err = erofs_io_read(&vf, rq, sizeof(*rq));
+	if (err < 0)
+		return err;
 	if (err < sizeof(*rq))
 		return -EPIPE;
 
diff --git a/lib/compress.c b/lib/compress.c
index b5f75ca..e764e44 100644
--- a/lib/compress.c
+++ b/lib/compress.c
@@ -1386,7 +1386,7 @@ int z_erofs_compress_segment(struct z_erofs_compress_sctx *ctx,
 			erofs_io_pread(vf, ctx->queue + ctx->tail, rx,
 				       ictx->fpos + offset));
 		if (ret != rx)
-			return -errno;
+			return ret < 0 ? ret : -EIO;
 
 		ctx->remaining -= rx;
 		ctx->tail += rx;
diff --git a/lib/inode.c b/lib/inode.c
index f687857..00fd885 100644
--- a/lib/inode.c
+++ b/lib/inode.c
@@ -690,7 +690,7 @@ static int erofs_write_unencoded_data(struct erofs_inode *inode,
 		if (ret < inode->idata_size) {
 			free(inode->idata);
 			inode->idata = NULL;
-			return -EIO;
+			return ret < 0 ? ret : -EIO;
 		}
 	}
 	return 0;
-- 
2.56.0


