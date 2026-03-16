Return-Path: <linux-erofs+bounces-2763-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C7950F53D9A
	for <linux-erofs@archiver.kernel.org>; Mon, 16 Mar 2026 20:56:05 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4fZS6r1bMgz2yhG;
	Tue, 17 Mar 2026 07:56:04 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2607:f8b0:4864:20::432"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1773694564;
	cv=none; b=Vr6L95r6puq1WibFftNgGwqNermuZnpfxlqW6jVaueApTbLdGqTQFAuoDGe9txw9QklvKdzdwvQbFE9pdK8DFGXzro5O8AJicdeLzlf9b2EifRlltuHwVPh+VSnLQA6ebn64h9f1AqUbpY29mjZj6fa1f8yD0+zu8CkQi/XOSyR8qZai0BGQaZj8M45wIAk3cLxc7xAImGpYFMrjoujoeAYHxTmAxVHyDo/uSCLLu7gONJnmnyHMoBCs3g5kYtawvYY8uZaNuenL8eqou5nwUV5IgWP1J4y3jfkDeohhborHHK96l+AYqQfR+F6s8yvxp6fH2sT5h9t+KPT3Nx5Piw==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1773694564; c=relaxed/relaxed;
	bh=/Ol4B2Up7PW/G5eIIu1kFvmjn5jkmduWK3HOrRERUQk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=QptcO7Hq/QVpi8+cEhYki/gteLQ/UhOIDqskGQN8u/ZQ5vimy/mnsg4KcWUtGekBXmw8msV5fQL1R3Z5Japu6md5OzZFtXtKhFRnsw57gLsbDcEPzIukN5MBNCjD3e2Pcr4JdcTwgUj1ZTE4dV/3+X3F1z/FoQCV+3p+8T1RRqrZkBFhYZKZjLvWjd/tXb4imQt9gr4eGBwJnOJO7XR6WXVOWBf0qAp+TM9qYVESminp0/Mn7qqWpK8ukeZASxjeg0KyMRzGqn2CurrOkCfSOsyVjzUan6eNX8Ip4YFLzXO5Se/e/w8OpJirzsqVATPYZA03gsGlP5YYstxRwrpADQ==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=gmail.com; dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20230601 header.b=NwDxievO; dkim-atps=neutral; spf=pass (client-ip=2607:f8b0:4864:20::432; helo=mail-pf1-x432.google.com; envelope-from=singhutkal015@gmail.com; receiver=lists.ozlabs.org) smtp.mailfrom=gmail.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20230601 header.b=NwDxievO;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=gmail.com (client-ip=2607:f8b0:4864:20::432; helo=mail-pf1-x432.google.com; envelope-from=singhutkal015@gmail.com; receiver=lists.ozlabs.org)
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4fZS6p2gjTz2yh4
	for <linux-erofs@lists.ozlabs.org>; Tue, 17 Mar 2026 07:56:01 +1100 (AEDT)
Received: by mail-pf1-x432.google.com with SMTP id d2e1a72fcca58-82980ceb244so396564b3a.3
        for <linux-erofs@lists.ozlabs.org>; Mon, 16 Mar 2026 13:56:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773694558; x=1774299358; darn=lists.ozlabs.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=/Ol4B2Up7PW/G5eIIu1kFvmjn5jkmduWK3HOrRERUQk=;
        b=NwDxievO1jOCQxEPsCBamkL0XUSUp1mrM0yD0RqbIGGLB3Dg2eb2GNzcBm/27l2kn8
         Pb5hUVlf5HtBdWQin43ImVIPqucdiZMYYsEG/4ewCbdecmnDo0Hi4HyPD0oT2SNeLsgK
         5fgvpuR3ydYgfa/UXjF5CBIZ416m6zjXpUlI6Opx63bc0I4ifXtmoOoWfcgmpShLWP72
         TvICrOGmPIhdGzhmcyB9U91Yq+kUORWGUemDUSJTb0uBLLqkEUyQftKiPTHCkgvQCeaM
         2voeePEp8+GFHIyBw6AtwjcTmkxPUlMNvheEnRSss/JSPCLaYth4Pzop1CzuPghzOQ+m
         hjhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773694558; x=1774299358;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/Ol4B2Up7PW/G5eIIu1kFvmjn5jkmduWK3HOrRERUQk=;
        b=ryQ+32Be9AwxWu9DwOAM0NP+FQNM6kcYbvcUhWR0qQ54HGG4+CBlruk/+8Qn6zprws
         stmLSlOIRabxJWa87Q30kFr5yERzUxiic0pwJ0cOVqSLXkIQxXfVhHXRFmIwam7ns7oL
         aP8WqX3v0Tp8rWcnVZs03VarQrnxA9Y5mVQOxH9T8pU3/eUbPwruHGoqVDgFrMUsVs5t
         XnmwAyMy6BCEKVATStf2zqKKpn85yO1sg9HAy0bL5RV4Ao9JUQ+pCA67zAWd5Mp/7ZY+
         AfESkuOOQx0BBiU+yHqWEFPwzKOcXb2zePzlUaIcgFCTrCJTGMUZHHdcrPW1b4/8EYgH
         3xWA==
X-Gm-Message-State: AOJu0Yx7YJFJI3B3BVYlRXhUyjCp5AKH7Hd813FkHknIT4J5J5KnSXDs
	zio+dafAZlw4QyF2DIJzwtPvTVnBD91bKs2NnQOh8ucwT7h5qoqRb3Lc4HHfsJJ8
X-Gm-Gg: ATEYQzyoCSv80VsEStJnypYfNEj0kW2b4NALUxCUS3jq1jrPgA6STjwOy5Wxu/Iwug6
	uLC65AAgoXopZDlK7U9SYAff+enluKlfMZ8qnL2yqPxC+hmQWsbIhxt2wvBRyTmKffnLBxAh3ot
	OPIsIyiX45XgfJfLlgMczhvKR4F0FxqGxfFfi5VfxS+AM8fgQf27m6gzU9jp6TKtR2Q6jghlm7K
	C7/upPU40CvbznRtgrWVbseA/e1LdT+wuImALyC0pJyxbOqNL4Ktex5VKAQCUQsmHhbAb9CTVd+
	gsxNrfOeONpCegOUtRz0ehdIZNfiE3ap6tJfdKOHree+rGaCtlj66reB1Z0J1Xj7TQ5u93Ndim0
	/F+DS44Fnt5NRGvsLoWu73FFgXUCHupPC9lk+ANvRzVcDJ8MClSPYYgw2tJPvtaaKhfcEmltrBT
	GD7TjQvdEYY90ZqIlgAV/TCxFj9MEMkKt/VX526ICuDggNDRexY+Brj/aglPD2NmK66q1pfF0lM
	PwzT5UN89sIPTvNYVn1kg4qdNP4JnqGrSYz
X-Received: by 2002:a05:6a20:7350:b0:39b:83cf:eb99 with SMTP id adf61e73a8af0-39b83cfedf9mr33071637.1.1773694558534;
        Mon, 16 Mar 2026 13:55:58 -0700 (PDT)
Received: from DESKTOP-PU4IGQQ.localdomain ([14.139.242.98])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82a07365b22sm14293554b3a.45.2026.03.16.13.55.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Mar 2026 13:55:58 -0700 (PDT)
From: Utkal Singh <singhutkal015@gmail.com>
To: linux-erofs@lists.ozlabs.org
Cc: hsiangkao@linux.alibaba.com,
	yifan.ytzhao@foxmail.com,
	Utkal Singh <singhutkal015@gmail.com>
Subject: [PATCH] erofs-utils: lib: validate decodedskip in z_erofs_decompress()
Date: Mon, 16 Mar 2026 20:55:49 +0000
Message-ID: <20260316205550.50342-1-singhutkal015@gmail.com>
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

The INTERLACED and SHIFTED paths in z_erofs_decompress() guard against
decodedskip exceeding decodedlength, but the compressed backends --
LZ4, LZMA, deflate, zstd -- all perform:

  memcpy(rq->out, dest + rq->decodedskip,
         rq->decodedlength - rq->decodedskip);

without the same check.  Both fields are unsigned int, so when
decodedskip > decodedlength the subtraction wraps to ~4 GiB, causing
a heap buffer overflow in every affected backend.

A crafted EROFS image with inconsistent compressed extent mapping can
cause z_erofs_read_one_data() to pass a skip value that exceeds the
logical extent length.  This affects all library consumers: erofsfuse,
dump.erofs, fsck.erofs, and the rebuild path.

Add an early validation ensuring decodedskip does not exceed
decodedlength before any algorithm dispatch, so all decompression
paths are uniformly protected.

Signed-off-by: Utkal Singh <singhutkal015@gmail.com>
---
 lib/decompress.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/lib/decompress.c b/lib/decompress.c
index 3e7a173..e102292 100644
--- a/lib/decompress.c
+++ b/lib/decompress.c
@@ -511,6 +511,13 @@ int z_erofs_decompress(struct z_erofs_decompress_req *rq)
 {
 	struct erofs_sb_info *sbi = rq->sbi;
 
+	/* reject decodedskip exceeding decodedlength to avoid underflow */
+	if (rq->decodedlength < rq->decodedskip) {
+		erofs_err("bogus decodedskip %u > decodedlength %u",
+			  rq->decodedskip, rq->decodedlength);
+		return -EFSCORRUPTED;
+	}
+
 	if (rq->alg == Z_EROFS_COMPRESSION_INTERLACED) {
 		unsigned int count, rightpart, skip;
 
-- 
2.43.0


