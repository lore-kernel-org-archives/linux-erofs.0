Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 922F0606A31C
	for <linux-erofs@archiver.kernel.org>; Tue, 17 Nov 2026 07:27:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Mv+WsRQN
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4jTGX566ggz2y8r;
	Tue, 17 Nov 2026 18:27:17 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2607:f8b0:4864:20::52d"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1794900437;
	cv=none; b=CZBA7D6O9CqhmZSIN/7PCvZnpbNb6JCYtSA3W2OQCR6P/qqivi7RgARBHUkji7c8zBleJQmaQAYUd+PegSCoD7QgBLeQycf/SawKIS0btvSEkqH56QhK4V7O+szCDo/cru4fnAbd2RcJUGv63HoHU4HeI+FGrtEsrmf3pgNRSNLSIpZ/mGbbEl0Zy2dfTJeIqhQFFubykRjYuQt0wTG1XjQmtrjdPvMfS1+hI+tWKPdksVmF+INVwr3fiF4NYWr3MsEg3yyR1bV8RQi1gL2bZjQs8tj3Gt7D4opgfDQwpDFUyCO5VIJsUMI9tHyxj7PgQobQLMGPX0OKuDmZwpKsug==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1794900437; c=relaxed/relaxed;
	bh=LalScOsTvJgML23cf1jg/B/LAQgoGo10yA782Z4To7g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oBnKpUTqv4qY5fNCeQY4IkTMtNAoErT2dfJUIOowFLRjO1OWDicxnsNl9bFEz04QID8hZ3j5USkVTcLrq1PIUCr+VHMGjBMYDqG0rosfw8P9kVXCIFC8Fjk6YrRIt4AXX6UQsYktdoDYBPJJTRf2UvAk9gMbCSoDDejESnVsa4QNC98ansLKPST0tNErlvhCTq51YnAmoIM3CG0I7Rv6YrcEfMbSKCFBrlTvu4SE5FfUEWTpWz6qvSXoTNjxZUiHwsQmCVSvo/V/x0f2W6ZgtG4T4XlkeckSMdSKZsPu1h5EiTC4SXB138y2+/b2kY7sjkyLxUNGl4vWpNbV5FmbbQ==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=gmail.com; dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Mv+WsRQN; dkim-atps=neutral; spf=pass (client-ip=2607:f8b0:4864:20::52d; helo=mail-pg1-x52d.google.com; envelope-from=stopire@gmail.com; receiver=lists.ozlabs.org) smtp.mailfrom=gmail.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Mv+WsRQN;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=gmail.com (client-ip=2607:f8b0:4864:20::52d; helo=mail-pg1-x52d.google.com; envelope-from=stopire@gmail.com; receiver=lists.ozlabs.org)
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4jTGX523x7z2xPb
	for <linux-erofs@lists.ozlabs.org>; Tue, 17 Nov 2026 18:27:17 +1100 (AEDT)
Received: by mail-pg1-x52d.google.com with SMTP id 41be03b00d2f7-cc147d86bebso494452a12.0
        for <linux-erofs@lists.ozlabs.org>; Mon, 16 Nov 2026 23:27:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794900435; x=1795505235; darn=lists.ozlabs.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=LalScOsTvJgML23cf1jg/B/LAQgoGo10yA782Z4To7g=;
        b=Mv+WsRQNvBlfXVp5Q+vmgmHLhsSyaXv904bt9Vgon3BSvHC28mysM705dYwkZrAqJj
         6/4NrSo5yW+VxWqESjtuel4qoxVOvi6juFIZI7c28e1NgFcx5yM0iP7OKlTHscWBKiTn
         bqvIBmEWzgNatDBK+jF+Zl3qQJbiun6jox5dzQgzBL1HE3jmsQ2iVV/cn3iXsjJeC3uP
         fmu9xaMii8U9QtkCK1w6zeQTzU5tX8BzIMe0qA0M4x9MCUaHsb2cT3dNjVWFL4psokTA
         qp7ZquDioUQcPNBuoRtJ8Yikvb5IOvq4fp24mNGwwmDoma7n6jnDax9fDzzqEuhih/Uw
         gCCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794900435; x=1795505235;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=LalScOsTvJgML23cf1jg/B/LAQgoGo10yA782Z4To7g=;
        b=qBQ3KdrCKHfNYLgkMh5ToNjjuYBEmRnTubvyawnnS8zBkIa7W6DK0gj4PAr7qlI9NX
         J2GKCPRLI1mHBny8P2o/fmilkF2KxgUaCVzqCLvyKs2lWn4DC/I2LAv+J5FvFhLOXJnO
         rQxunKJc3xg7nTAsMK8WI15Ig0ei/PZF4HewrpVdAD7AoooDHbMalpKcdeU7FbYcoAJ4
         k4lchMvho0swn9PnUZiZWqk7v4lZaG1Pe4gKuQRE4kRgG5BFuGoJmBSG5nAx25WbEwi6
         tpF5unLB9ID7sFHi6ZX/7rhPu1TlewyDmOUXg6yJ5SGlLtgFpN2e3w7vDsCUThAA4/m6
         NIRw==
X-Gm-Message-State: APuU4Z8Pi0j3xzGPQesvwo3JP83aFHHgkyekHJc4Mt1//mHAe7mwK9qw
	Jj7Br0rOL5OOVNN6nrE8gyylrhJfr3S3uPytGqg4V/A982b3fzOVargDSNQyKLIYjoY=
X-Gm-Gg: AYBFou2e2uzQa/3Rmgx9VYijBl7MoFXWxGWyCmhHrHj8PZd0Rx7BiFo58ap/9fjP4XY
	e6LxNXbaC8npVUoom6PqxRJO72sA9gbPkvwTyqiEZDnCeDOqkcw0pFmSlvEEnpeExshr4W1uxRF
	u8kQX4M19agV7zXE/xhnW1mMsIxXCPV/LOUh1LvTXLhuIcWMYfuYm3JgWJRm926YCP652XGRHAN
	L00gTQgYr7NEx9D9dq1lhuCkBqs2QdfBx6+2Due7V/kqM3JQdIi62W2bufjEMcXfWERV+DTAy8g
	z/bef55qFfeYLJDNr+w3hUv8JIstbIiuE1xaV6CNGBwlX9IVS2R9UykoabMpgKkW6lw7UqmoJt5
	3qyy3S+qpOYaYzXBHSYZzEM1HkEWF25IBfZrJ90uPvVRUrK63pjcB8nyrlrGbjvTeIfuT0QRtuA
	awM2gqgxrCsSuIpDg1tqqieJr87zZzsaEnZpUIAOeUNX38B/8Q0L8LqgRfwXGXsRQE/DbKmPCuM
	CNSv9+5u1JkrL1NHo5uNFfyjCUDNvq0LMVj9HZtMyXtXWA44uJ9kK7Y4tEExTZw8oj/X/syCIXv
	zWvzvK6innaAQFyXR9IqiAUOIts/fRQbKePLw/D+MGbN/F7d
X-Received: by 2002:a05:6a21:7913:b0:3fc:d7b5:94d5 with SMTP id adf61e73a8af0-3fd2bfc4f07mr852955637.32.1794900434804;
        Mon, 16 Nov 2026 23:27:14 -0800 (PST)
Received: from zyf-laptop.tail52ade4.ts.net ([124.70.231.56])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8bed2055031sm4940716b3a.39.2026.11.16.23.27.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Nov 2026 23:27:14 -0800 (PST)
From: Yifan Zhao <stopire@gmail.com>
To: linux-erofs@lists.ozlabs.org
Cc: xiang@kernel.org,
	Yifan Zhao <stopire@gmail.com>
Subject: [PATCH v2 8/9] erofs-utils: ublk: report the handler's real I/O result
Date: Tue, 17 Nov 2026 15:26:28 +0800
Message-ID: <8026f063911c25390932710b7afb11de19c61514.1794899782.git.stopire@gmail.com>
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

Respect the handler's actual I/O result instead of always committing
the full requested transfer length, which falsely reported incomplete
transfers as complete.

Fixes: 799c933bbefb ("erofs-utils: add ublk userspace block device backend")
Assisted-by: Codex:gpt-6-astra
Assisted-by: Claude Code:deepseek-v4.1-flash-1017
Signed-off-by: Yifan Zhao <stopire@gmail.com>
---
 lib/backends/ublk.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/backends/ublk.c b/lib/backends/ublk.c
index d2c5e19..7fa88d9 100644
--- a/lib/backends/ublk.c
+++ b/lib/backends/ublk.c
@@ -630,7 +630,7 @@ static int ublk_handle_io(struct erofs_ublk_queue *q, int tag)
 		if (ret < 0)
 			io->result = ret;
 		else
-			io->result = req.nr_sectors << 9;
+			io->result = req.result;
 	} else {
 		io->result = -EOPNOTSUPP;
 	}
-- 
2.56.0


