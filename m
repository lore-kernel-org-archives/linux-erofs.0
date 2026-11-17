Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11B60606A31C
	for <linux-erofs@archiver.kernel.org>; Tue, 17 Nov 2026 07:27:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Ik/0h6wy
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4jTGWy0dD1z2xcB;
	Tue, 17 Nov 2026 18:27:10 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2607:f8b0:4864:20::433"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1794900430;
	cv=none; b=aoP6ziwQLyElsvewbMm37TVE618kAFIt98cP77jovOZONF045hWmoHu5z+oQgEcPW3OENB4yQM87Ux7mr9p/UP7hib5IZ0SYslvTdWemJTGi/pOZGfdv9/REXyQoxw2U+i7lk7Yl4odmTK/u1XNM79cG3UQxTpOp7Ve3xfxhcjqCVaxaOUp/LZ2G+1h7wvlxGg9rwplsnStVI2LhQ1Opl/bNkrjclGj0fsym/lhtAZp1O0a4KcQrNgB8hwDci+n+MzxMFKUVxYFeR9yISWGHTaUoIFVyoh/gGzJcMMzFC8i66R3ytkpoUwWosDhLvzec6eIW/o30t377eQySCkdGwg==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1794900430; c=relaxed/relaxed;
	bh=5maYMNwmnovmIb047aLflHF+qWLcO5Xc4cr/HZOmOTw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PotZjVgeOKvVmtXssivbX+r0ax2hoeccZUiSiDC5OKvUfON+AKGnZKucklvbc2CujR1r6m1oqHpoXlreX+zXSPuqOLd8qc3PKpEvwtapW0+v47nY+1Jf3SHe45Z06vspEABS8wmz2wosHLkyS1lB+3wJA5WJy7bM49v0N/PwXjcAHoPB0BI5OVnIyDmEiT0NZhnnw9e41kKtgHu0WHpMDZISRfFC/I5xHTIPnpCx71cNe1I2UgakiytSMK6NjS/KHlu175poKQRfmbC8rwNKxpzLIWQ4UzEmBO6yWcyHHi7RbBnwpjenW1eHWmu+fjbRhRbQD89IyI2ttze7Ok7r3A==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=gmail.com; dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Ik/0h6wy; dkim-atps=neutral; spf=pass (client-ip=2607:f8b0:4864:20::433; helo=mail-pf1-x433.google.com; envelope-from=stopire@gmail.com; receiver=lists.ozlabs.org) smtp.mailfrom=gmail.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Ik/0h6wy;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=gmail.com (client-ip=2607:f8b0:4864:20::433; helo=mail-pf1-x433.google.com; envelope-from=stopire@gmail.com; receiver=lists.ozlabs.org)
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4jTGWx3M5bz2xPb
	for <linux-erofs@lists.ozlabs.org>; Tue, 17 Nov 2026 18:27:09 +1100 (AEDT)
Received: by mail-pf1-x433.google.com with SMTP id d2e1a72fcca58-8a60f90a924so1720230b3a.3
        for <linux-erofs@lists.ozlabs.org>; Mon, 16 Nov 2026 23:27:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794900427; x=1795505227; darn=lists.ozlabs.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=5maYMNwmnovmIb047aLflHF+qWLcO5Xc4cr/HZOmOTw=;
        b=Ik/0h6wylRSRnPLNvdvpQo1ilevY3xw8IKNv/lvGfk3/iN3ZJyCYlOCqn0m6TiYa8/
         N+RYTb+1hg0lIGK98N8OxNL/LQf6WgDTV3fs7+SpV9fHMKMxkY95NAAgiS0wcv4DK0jA
         Ri2+Q0xVxYoA8jqHtUTY8mDyowkYEGtUdKg3tCCshEZnTE5h1MHfD3iQIVtY3xphYYRP
         FXgfMsza9lJNaWv6hPNBCVF7EOFWZSXc63q+cpXjRTYDb+q/mU1GfDuav2C6wIU1lzUh
         bHgA8cWPw2ZdhyuEDMfRn30AnfAy8rgOmvOFlpxs17HDG3aUp3zCI4GS+9CmcY22vTM/
         8EHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794900427; x=1795505227;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=5maYMNwmnovmIb047aLflHF+qWLcO5Xc4cr/HZOmOTw=;
        b=ymkb0eEyILWf3TsPosms3cx/FVPLpUxVVIrM+5urzlFxFzSHGOnSz/C5wJHF7YTNO3
         /9aETODWrgrCa1DBsK/aeVolbV5S0sz/o4Ih9QUbkUGT3WU2d1oLD/FNSdajprP+Es4u
         wAXsPHf/2jmTidTOuSvnnQvi63r3Dx7YF4ZZ9zGLjILgIHYeZLF1dallcC1QHljL9xx1
         ab7Fb+ASJukA+6TcZfMJtUKW6yxNp9GZn01oKz7yGPuXNBXSi6PwJ45wsU58gNlglvuI
         kAh/Io8/36ZotpiHb/YIocYvq/NUJAK30hNeO1IJqqh7UwXcH1KqwFUh+3juhRxy9IPT
         WyAA==
X-Gm-Message-State: APuU4Z/RIdL20rpifRi7TMZpiBpPKFsWpnysHxFc6461VOpuEBoraH6J
	KEd8zNP+kSpDV1D3cLiKfRfiZBjmeB9iNVQ1lJSVKhqe2DQ29OwVPwJb4O7r5+ga8qQ=
X-Gm-Gg: AYBFou3tHyD6M9+pTrw9uP6zCJt7sDHsV4N2OrVWqQakcC9XxsKOsXbP/oOBAVg3jRV
	gHS6ZYVC5H/9MN/9F9AhXblNHr2ycAvefhY4mGOoReumhRr3aEs4elw64Wn+eZ9LdNe6xgR+1+u
	8XqLQArrQwPxL/hBrWMZMNmT3nCehoNTMxhxy/16HFFAUz5Lc/bDZnt3SxhBcwNpMMukZ/lcKYT
	Ac+qep9p1v/8hJwdxjysw6Ad9no0ybQSsUvr7dmBMFFArVjyNYEMeYOMOw7Wn8fNOQF3fc6/Wed
	AxGQJV33FuQR/BacC7H6/zh7wUEh19dM/Ea+vxn2nfPiWjtV8upIFcigP9FzRNF6Rzw+113E4ka
	YpFp0Y0TkSK/8eaquyiee7kud1fFgP8uPREZPXj3xDmI1x5R6sJ4H/JcllV8MDkihO1ZVv4RdXS
	TXWY2h0b4m4aVLvqtIADIZB0ReJukir5+M7UwjzrNkSTnPPgkbGZb3C7BBEt100cnjbwnUQ51tQ
	4Bs3X4O56Tuns3jVHjYA3i8cxDfBfN0ldx4pmmzPV9kXb95eDeiwJBhvVDr5f5d0K8uSRwdm9I6
	ThGgbPjCOo5N8kwXgI1DypRHDhulCwpqtyImLbmLUYM6VOKj
X-Received: by 2002:a05:6a00:3d0d:b0:886:84c7:72b3 with SMTP id d2e1a72fcca58-8beb5da5bcamr11964202b3a.26.1794900427385;
        Mon, 16 Nov 2026 23:27:07 -0800 (PST)
Received: from zyf-laptop.tail52ade4.ts.net ([124.70.231.56])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8bed2055031sm4940716b3a.39.2026.11.16.23.27.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Nov 2026 23:27:06 -0800 (PST)
From: Yifan Zhao <stopire@gmail.com>
To: linux-erofs@lists.ozlabs.org
Cc: xiang@kernel.org,
	Yifan Zhao <stopire@gmail.com>
Subject: [PATCH v2 5/9] erofs-utils: lib: fix erofs_io_pwrite() caller error handling
Date: Tue, 17 Nov 2026 15:26:25 +0800
Message-ID: <62a068ea290993536ad2cf78b2118ed5f8fc14b6.1794899782.git.stopire@gmail.com>
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

Fixes: f79a359550f5 ("erofs-utils: mkfs: avoid partial writes in erofs_write_tail_end()")
Fixes: 97f48b3c37f5 ("erofs-utils: fix erofs_io_p{read,write} and erofs_dev_close")
Assisted-by: Codex:gpt-6-astra
Signed-off-by: Yifan Zhao <stopire@gmail.com>
---
 lib/io.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/lib/io.c b/lib/io.c
index 35da5bd..2b61f9d 100644
--- a/lib/io.c
+++ b/lib/io.c
@@ -120,11 +120,10 @@ ssize_t erofs_io_pwritev(struct erofs_vfile *vf, const struct iovec *iov,
 	written = 0;
 	for (i = 0; i < iovcnt; ++i) {
 		ret = erofs_io_pwrite(vf, iov[i].iov_base, pos, iov[i].iov_len);
-		if (ret < iov[i].iov_len) {
-			if (ret < 0)
-				return ret;
+		if (ret < 0)
+			return ret;
+		if (ret < iov[i].iov_len)
 			return written + ret;
-		}
 		written += iov[i].iov_len;
 		pos += iov[i].iov_len;
 	}
@@ -188,12 +187,15 @@ int erofs_io_fallocate(struct erofs_vfile *vf, u64 offset,
 	while (len > sizeof(erofs_zeroed)) {
 		ret = erofs_io_pwrite(vf, erofs_zeroed, offset,
 				      sizeof(erofs_zeroed));
-		if (ret < 0)
-			return (int)ret;
+		if (ret <= 0)
+			return ret < 0 ? ret : -EIO;
 		len -= ret;
 		offset += ret;
 	}
-	return erofs_io_pwrite(vf, erofs_zeroed, offset, len) == len ? 0 : -EIO;
+	ret = erofs_io_pwrite(vf, erofs_zeroed, offset, len);
+	if (ret < 0)
+		return ret;
+	return ret == len ? 0 : -EIO;
 }
 
 int erofs_io_ftruncate(struct erofs_vfile *vf, u64 length)
-- 
2.56.0


