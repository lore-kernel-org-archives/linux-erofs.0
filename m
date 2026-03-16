Return-Path: <linux-erofs+bounces-2745-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1AF14F4644A
	for <linux-erofs@archiver.kernel.org>; Mon, 16 Mar 2026 10:53:13 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4fZBlC4n1Zz2ygl;
	Mon, 16 Mar 2026 21:53:11 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2607:f8b0:4864:20::1029"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1773658391;
	cv=none; b=M/ctSrInIuGGzJETPnMV/Wh5LKJeY+lnsEosjbh/rEojEUnR36roZ77ogMVeU+AgEXo6ts3siV6qJ/bwGcfNfx/OhRmeOEfMHVYBrMaHFh6i2uC1SWwnNAA8hp97Ah+uQaMXnLf0GXrUBRbczy9pzQlEiOMyxSPC3exefWHefUokoFWZ8MKvXvG5XYvvEcy3rzYq9R4XwLtN8QRM9FWLtW7wsY+hmaKp+I4ek7KBHZMlUvdZJcSR+DVGnFV7JL++t4cXBuWkNFM27NIvRnfPwDnd9jbpjZDP9TiYiLm5EnJCyDNjKUEegbxtlT3UhY7yC6qZCtSBlhTmL9hS5AvuFA==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1773658391; c=relaxed/relaxed;
	bh=lH8vlBD7OXb6PzT/zvffx1a70qG+1+A/SkL4u81qX0I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kvb7RKXh602tGwtCpMAmyvIrY/+G48FjKmiFEwCJiNsO6F43SAT29ggjr0Zuk+DnbzompAh5m25VgWkla/d5gsf++5UqGYzLF95schX4Pqr20QAV2kWf9PWiRNVPoDJTJM+pUb8IgCcRO0kDCoMlOu+pjNDVp+1Qi7A9PfZQfuR0+8hSQzAVTcCeyNITjGIs51JCfWrp1ZV0rAQ2xcxubuPgWs1aDeIzhM0r9M4yVFCJKElohMo1hapouYmWUapCQ/GtW+s8ay1fuK7JkhUQQHpk3lEicerNDyCeHlBmYxqDCAtCLSosEpOBnnUtAnBzUXxX/DK2XZh7o6EkW4+P0Q==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=gmail.com; dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20230601 header.b=g62U0BdX; dkim-atps=neutral; spf=pass (client-ip=2607:f8b0:4864:20::1029; helo=mail-pj1-x1029.google.com; envelope-from=nithurshen.dev@gmail.com; receiver=lists.ozlabs.org) smtp.mailfrom=gmail.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20230601 header.b=g62U0BdX;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=gmail.com (client-ip=2607:f8b0:4864:20::1029; helo=mail-pj1-x1029.google.com; envelope-from=nithurshen.dev@gmail.com; receiver=lists.ozlabs.org)
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4fZBlC0ftbz2xMQ
	for <linux-erofs@lists.ozlabs.org>; Mon, 16 Mar 2026 21:53:10 +1100 (AEDT)
Received: by mail-pj1-x1029.google.com with SMTP id 98e67ed59e1d1-35b98def50bso751940a91.0
        for <linux-erofs@lists.ozlabs.org>; Mon, 16 Mar 2026 03:53:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773658389; x=1774263189; darn=lists.ozlabs.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lH8vlBD7OXb6PzT/zvffx1a70qG+1+A/SkL4u81qX0I=;
        b=g62U0BdXpdZddg4g+OwkY48bzeFYkdsMAKRl/rzYLTsaySjC3nn2MScfHLwyjDOr5N
         928ySOrnBGExbnFcvySxAi4/Q2aZhx1c7tWQGLmWPHHZg9pgLT9T+6JYNXONWo2VdVrE
         btl87HTjQ7mQTahTKmBAjlx+WiVkfSomPAH1s2N4CQ+UGUt1zIx+8j8hOy5h5kntgSm0
         OrHOaZh5yE2AeJn2MwjM0343pw+pN69vRbTMaF73Uk8TyMndwr5y+ZwuUva8+ZURfkui
         5Nej2Vrss9pVQ/D3DGpWs68uH4Axiq7Gw6w5uGsmmjpZn93PIQeHgmy+qjtBqXsUO3Io
         EKyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773658389; x=1774263189;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=lH8vlBD7OXb6PzT/zvffx1a70qG+1+A/SkL4u81qX0I=;
        b=A80muXcrcDdht2czrxPpV98Qrj6I/WCmGpNIqyas10lsoXt+oJKMeqJ1RwC99HSpyx
         ziWatLwAdHDAemqY0VWXkX/09+u4arH2q1wO3EYFd7h7JtfOso6palBsEQmHpgnqxIM3
         Vo7aPAkcjN2Phu2uv2k8n47Rdo/GeYhp2XeF+4rJNmGoyCiebjxMTXW9m7eGa4Mq4PQl
         SkH9Sz8rR+mBZYO/Gvb9UoORyASVMGIR8t0W43GSy1LCTdixVVbnsGJTVgMWJ209xmU2
         U8yoCYXdFukfQ6cAA3M2UtcREuctzksBwjcLHoKB9dVgDmZQrkbEFZ5eLbLBLuc7nsl+
         iZhQ==
X-Gm-Message-State: AOJu0YwW69lVOB4/TOc3tnIP5aavU9CDrv4LuSnbw0mVZZ9TiW9bhkGL
	L51A9/oXaEU8vP3gKnqrR/c3ztfWdcj9X19hmzZQ3iGg0yBKrSxfpwsayqVQYGZSwFE=
X-Gm-Gg: ATEYQzwHaNDS8m9kwQykCSX8A15Y/zOd8r2Pz+l8wWUJmzOPxpgDCuk7mw7gCZTlWXz
	sbWFlqTki+T+CZwtCRC4yLNsE3QkGi4W+LAGYz+qy4zfQ3Y/wpbWDfyEHfPl1A92zrHGLie9okG
	V0cz0IpAOIfKUxGjZ9mFmpPNUWMgL1xWoIN83XjUEaooSY08ZRQJSqtXLSPlCA2nVEOaBhzleB3
	Hs/0Rfu794XY3F8j0ybvLuAfwTpJHibRdR0aucMEMcu57O8H5jRaKKF1stV30ptP8q/0LlkXGMu
	FveE1/txIq4c7f7wFFWv/+3Q2+JdHXlSN30ckcDFbpU6zIihZ1RmD9QrhAVtWaWKCyqR6hSFs72
	VA75FzDMSysKrql2JQFKzsWVUgu3wUbM7DE1ohRWrPn2nfolHhHKu2hpiX0ZWPn4meGO8a9GbMx
	MaIzjqqSWCDmnWq1pq2RiQHmJ9l6S8smLAQQzeqeQw7lw7cW70vFg=
X-Received: by 2002:a17:90a:e7d1:b0:359:ff8a:ee3f with SMTP id 98e67ed59e1d1-35a220a50d2mr10980948a91.30.1773658389126;
        Mon, 16 Mar 2026 03:53:09 -0700 (PDT)
Received: from ubuntu-arm-nithurshen.SNU.IN ([45.114.151.63])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-35b94e8baf9sm1693569a91.13.2026.03.16.03.53.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Mar 2026 03:53:08 -0700 (PDT)
From: Nithurshen <nithurshen.dev@gmail.com>
To: linux-erofs@lists.ozlabs.org
Cc: xiang@kernel.org,
	hsiangkao@linux.alibaba.com,
	Nithurshen <nithurshen.dev@gmail.com>
Subject: [PATCH v2 2/2] erofs-utils: fsck: add warning for unsupported file types during extraction
Date: Mon, 16 Mar 2026 16:22:42 +0530
Message-ID: <20260316105242.6894-5-nithurshen.dev@gmail.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260316105242.6894-1-nithurshen.dev@gmail.com>
References: <20260306085717.12776-1-nithurshen.dev@gmail.com>
 <20260316105242.6894-1-nithurshen.dev@gmail.com>
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

When extracting an image using fsck.erofs, if the tool encounters
an unsupported file type (falling into the default case of the
switch statement), it currently skips extraction silently and jumps
straight to verifying the data chunk layout.

Add a warning message to the default case so the user is explicitly
informed that a specific file type was not extracted, rather than
failing silently.

Signed-off-by: Nithurshen <nithurshen.dev@gmail.com>
---
 fsck/main.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fsck/main.c b/fsck/main.c
index 16cc627..16a354f 100644
--- a/fsck/main.c
+++ b/fsck/main.c
@@ -963,7 +963,8 @@ verify:
 		ret = erofs_extract_special(inode);
 		break;
 	default:
-		/* TODO */
+		erofs_warn("unsupported file type %o @ nid %llu, skipped extraction",
+			inode->i_mode, inode->nid | 0ULL);
 		goto verify;
 	}
 	if (ret && ret != -ECANCELED)
-- 
2.51.0


