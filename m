Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99512606A336
	for <linux-erofs@archiver.kernel.org>; Tue, 17 Nov 2026 07:27:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=OKXZ8VVe
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4jTGWn0wY2z2xly;
	Tue, 17 Nov 2026 18:27:01 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2607:f8b0:4864:20::429"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1794900421;
	cv=none; b=QAGERh9pq0C5Drbr4qY97lnOwFukFCODcW/qaVRE1Vn5JvV0HjRCiDdmPY+ZhJ5QTZy+wkE4+xTgqvSoEZ/3pvRQ/rTek9UQpZ5+TCSayAf8E492WhFnRBcRWbODR8E8ZzFPTbfIM/1rIyAvggmX7Qu4EQw90nz2ntxj42XtFBULE6x2nKcM0yZr2WrKb/kAADjJy6cmkkPovG3MddqcLoJGOgtDtXHmn9OmvzcBcYrJF5LS3cgBRZAeKP8bZSXDyJxKsfVqVmEYCUjfr2/KLKAN5vZQgEVnnVZPWyVRe8ezAPN0jFhwlIxsyRWoruwTPAbxO0QSjxBWdSSPCtLmXQ==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1794900421; c=relaxed/relaxed;
	bh=DZ50ws9hyFywhYvacT8nUV6QwPsNneQb2mU0+qDEXHo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Pr6Jtbrc8yYbW/8f/x6kLR0v9BzufTG/2q2JgHuausBsJHT4FipFvLUkS5cRsQsolRYuzb3g0AoHCc2WCOAJ/V2hWd+7j8Umsslw9DGNL4a5mpgaAVWOvkMPZY9kesNydFrF6KWPpTniLP2ig9oTJ/KSVwFDdI+aPteAX/Wg900/9wZAgQB34UdyJzXolpJX107a1Ibg3SdySja4FfvUgF7Qwa233VENfV5lqTAku1c+OLfBSnE4gmjTNzPvg32zpEoirMTmEb6XS7Ls1KtJxgGtBBQdU2U6xzxKJoTb1LHhXVH9iUc8MjiMb59hQ/Gvb43fJjFclGGPhJYhpTxGVQ==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=gmail.com; dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=OKXZ8VVe; dkim-atps=neutral; spf=pass (client-ip=2607:f8b0:4864:20::429; helo=mail-pf1-x429.google.com; envelope-from=stopire@gmail.com; receiver=lists.ozlabs.org) smtp.mailfrom=gmail.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=OKXZ8VVe;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=gmail.com (client-ip=2607:f8b0:4864:20::429; helo=mail-pf1-x429.google.com; envelope-from=stopire@gmail.com; receiver=lists.ozlabs.org)
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4jTGWm0GvDz2xcB
	for <linux-erofs@lists.ozlabs.org>; Tue, 17 Nov 2026 18:26:59 +1100 (AEDT)
Received: by mail-pf1-x429.google.com with SMTP id d2e1a72fcca58-8b4c8b51b58so3522851b3a.1
        for <linux-erofs@lists.ozlabs.org>; Mon, 16 Nov 2026 23:26:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794900418; x=1795505218; darn=lists.ozlabs.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=DZ50ws9hyFywhYvacT8nUV6QwPsNneQb2mU0+qDEXHo=;
        b=OKXZ8VVeNCGkeLqW2RFYIZOTlJNTzbdrre/bDYVuczcApOvrd3x8vbGNuhDYV3DGr9
         JbHF7VNrha2jVeD/z/G37VvnT+wknGPUb6M1/Te7TqLnTllBZscA9KLHGOCAM7h0Ij2i
         NX8PekpncQhF/RWGpDSShrKe8pYWB/aH7WMLFax+9yP6yVgMrzBtmz3Hywj8oHNxp0f/
         nsrfNw2C+4JihjYRzZdDn5iAFQ0q7Sld4SvvVqBRgNFiTavkvwEvBmi7zIXlxaMx/K2Z
         wngFY01BeAUlF446cGceHx/4dl8Vodzy4QEQhbqMwNELmyRYJyLgtJSyijwN+B6JOhsg
         lSaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794900418; x=1795505218;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=DZ50ws9hyFywhYvacT8nUV6QwPsNneQb2mU0+qDEXHo=;
        b=vnBjKQxi7PXfen3NRxUhGuRnYxe/QH9xOA310v4zD8QF1e4kgAWJtKi2Q4K3awbS0i
         bpXoE/MekPXezxYbcD1CExJRzXpQwH7JueO+TVZHxzFGKwHBWeTALYKAX2ufaQZfl/TL
         UuaPawkXnczRehemtFBpKHyIzMxAekY8ly3ywTH3djEro8XLpaCmpxqTvYY3dDPpFX7e
         yU03aiVwgtM+0q0nBI8L7mESbI41l50JVnEG9gQ+D6h5OCCs9GoCYNhEGotmBYfz78Bi
         ULc5Yip0wr/q8RLyWOFTsVTSg6LGsOsQg4xPjp1v7NmBYrOd8Md+7wifZNBDSQTaiPJF
         FnBg==
X-Gm-Message-State: APuU4Z/GjuMrviIfZe9WN1btUPJVreOMZ93uP0hYzDxvLQ2gRvXO9r3s
	aF89vvNEhI6YBqGxlz66wp5FGTCrqwt1AwCXvoCixHGgLERiE7TpkK5CPo/sXbRj+SE=
X-Gm-Gg: AYBFou08Tccy+4Ei9p5ADaPuN5ETUSsJr1S9Alt7ksSe/8vXPZigyTSvr/MJh5Ud+bK
	Idx4XGU9+LQkL/9hMBVYBgl2RpePS20htV+YOs5dRAAc89fX6D7H/Ts4thy8yK2zvhv5kGNwpDa
	LnbC/ifgNp/LtTtKgNMb2kVmqOQBIRrR5q/3Bmu5CTrJBkT8Xh/RH4UV5iI27bOuVZp2GKQsfdK
	EHK2RAa+opcP3kqGzLQHRXDudHZ0Gyk6RMOdCGY+i07HUiIqQsAd6alDRQCUofm0dTqh/qjqNdU
	JmZ2XabpdqECverVztC6qS8ICZ6QahSJxggVo9YnMFUn1nAv2dzbURhCUcGRmd8ls7nz/AdC6wt
	xQxWeBN1HmJNo8s4IMW6huixLG7EVAnOen1PpYtSJZw8ulBiEgL4IPyiRGUygF2iSfeT3D9pGmw
	tXvuKquspPj4FJHisLZvAzU6Mjd0I+fN1AXP9CaOpLMfoK0+ksbK3WIHtMBCBxxxxfgy2Utv7vK
	X5sU4vLDR+ciwGqOXtfXtrkuTjVe3DocDybtHW59+n29wCm+GOlcm7WdLqQh3ALpJeh9+ZZ7UXW
	8r4PdVMIC1+kNoyhll2M3wArlAw6P/GORmggOD2EHf+3/Cwj
X-Received: by 2002:a05:6372:a705:b0:3fb:29a:8874 with SMTP id adf61e73a8af0-3fb029a8a20mr4508532637.32.1794900417933;
        Mon, 16 Nov 2026 23:26:57 -0800 (PST)
Received: from zyf-laptop.tail52ade4.ts.net ([124.70.231.56])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8bed2055031sm4940716b3a.39.2026.11.16.23.26.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Nov 2026 23:26:57 -0800 (PST)
From: Yifan Zhao <stopire@gmail.com>
To: linux-erofs@lists.ozlabs.org
Cc: xiang@kernel.org,
	Yifan Zhao <stopire@gmail.com>
Subject: [PATCH v2 1/9] erofs-utils: lib: free inline data on rebuild failure
Date: Tue, 17 Nov 2026 15:26:21 +0800
Message-ID: <49cdd6473b1dd9e3d7092486a1a1fb005ba3353b.1794899782.git.stopire@gmail.com>
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

Fixes: 1c230a485f25 ("erofs-utils: mkfs: support rebuild mode for compressed inodes")
Assisted-by: Codex:gpt-6-astra
Assisted-by: Claude Code:deepseek-v4.1-flash-1017
Signed-off-by: Yifan Zhao <stopire@gmail.com>
---
 lib/compress.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/lib/compress.c b/lib/compress.c
index e1cfc05..b5f75ca 100644
--- a/lib/compress.c
+++ b/lib/compress.c
@@ -2607,6 +2607,8 @@ int z_erofs_rebuild_load_metadata(struct erofs_sb_info *dst_sbi,
 err_free_ei:
 	free(ei);
 err_out:
+	free(inode->idata);
+	inode->idata = NULL;
 	list_for_each_entry_safe(ei, n, &extents, list) {
 		list_del(&ei->list);
 		free(ei);
-- 
2.56.0


