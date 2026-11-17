Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60E08606A31C
	for <linux-erofs@archiver.kernel.org>; Tue, 17 Nov 2026 07:27:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=XcPcq85d
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4jTGWp3Flmz2y7p;
	Tue, 17 Nov 2026 18:27:02 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2607:f8b0:4864:20::42a"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1794900422;
	cv=none; b=CpVOFbw9CtL4N4yV9meG4W6XPghWLOv823Ws2yeS0P3YOXo+OMO5E57QDVOPk6vh462a+Obi5AioflNwYYJfn6yKdefmo5v5ejpAsutsuMzy1/g+lBPiQT5GbRJzyfdlUTNCwDPbpgt5RIggqB7ddGNk6tFj00bmG8a72/iaML1YOHJ0euAlg8TMyyykq3vfRhcD1e4vGV/XBcd++Mw2EzlEpkpSR5JRTpemMSQnHDdwTUWMolavm4rIvjhwOE+BuxZu968gAzUinTm0bkX9QZdkeyVIcM+MymjPPEnGjY0VlqtHiaD8+rQy7+Hjud+7RzoohAt5A2c7tDJvVKt8Ng==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1794900422; c=relaxed/relaxed;
	bh=aRME31iPrUCDAXwH5aunQTDi4/CNaUlLg1U6HVEPeNQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UxFA5t9KH9SiFEnec2ze5Q+6IFYe2U1KCORWUa3Q/Z1kV/jk74K4Jv9ldDew/SkjHOA5OCPlmAhRGRZB5rff2E81rryyDsoLVJBU3m461YBG/goQuZ9MUe3YENXDC6y2uda2FMLMC9q8BrJgLLXRWYBMXh30r+uwW8oNnnVo+TWeRQ1L9n1EhHzEGkqvZOQr9I8dyPx7Sxr5MBsZ40jR0aGYLDB1jKRXqCGBi//+Zjmy+h/MTH0Wf+KVEnwB3F+jkJkWyikvJ60TZi6MD9ZzQ83pbt8jDJ+hKX3EaXxs9O2HuBSGJYyZBD+4tjRcjGEmwv9wz6pxMXbX8IJDiY1i6Q==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=gmail.com; dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=XcPcq85d; dkim-atps=neutral; spf=pass (client-ip=2607:f8b0:4864:20::42a; helo=mail-pf1-x42a.google.com; envelope-from=stopire@gmail.com; receiver=lists.ozlabs.org) smtp.mailfrom=gmail.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=XcPcq85d;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=gmail.com (client-ip=2607:f8b0:4864:20::42a; helo=mail-pf1-x42a.google.com; envelope-from=stopire@gmail.com; receiver=lists.ozlabs.org)
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4jTGWn5CW9z2xPb
	for <linux-erofs@lists.ozlabs.org>; Tue, 17 Nov 2026 18:27:01 +1100 (AEDT)
Received: by mail-pf1-x42a.google.com with SMTP id d2e1a72fcca58-8b2f59de176so4617243b3a.2
        for <linux-erofs@lists.ozlabs.org>; Mon, 16 Nov 2026 23:27:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794900420; x=1795505220; darn=lists.ozlabs.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=aRME31iPrUCDAXwH5aunQTDi4/CNaUlLg1U6HVEPeNQ=;
        b=XcPcq85dcXYlaexLSRGmuX4lDoyUIs+bFMULxub6Us55kBpSeS6xyOGnlVzl1+q9R/
         bazXe2DfwwQlhlWzTWZKeWTNRHbR6LMHR8WPQcI45/UIGVR21by5u59rx+y4Ttq+aJdF
         Efk8jIamN18qaFIlK2iAHTehLGdNeTEYv/kxGXAWtR2rgi8ZxlrN4nJUXAQoexI8Ng0O
         K+KIzWUERA8A6Bf4nXUNvCBHIMR8i6bzLcpEr0N5SYKIMqP80l6FwE0PMnC3aRKJu9nl
         Xo7RRmppmE1H34vPzVnzYNwRG1t2n1PLxbQFlHeo+IkQ/LnMs+aaAoLSTG/qz399C6r/
         LrvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794900420; x=1795505220;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=aRME31iPrUCDAXwH5aunQTDi4/CNaUlLg1U6HVEPeNQ=;
        b=bADwgcVKmVP3DmuMm+8FPGm5NBQrEfHSFghUOD0BvS+cck5s7OpYdv4foYACUs7DLr
         uEjNqTgq5n5OmWHOizESV4bHTvn+V3YB7Ei0MkcARyW1l4eygwaBM7tfUgIJ8GBEcobm
         +wiUZkohJK569fWvHYDYPbjL9gu/RMy4oZ8lARQWOjh9riGTARA05JSKOctGGL8tw5po
         1ayQH/nEC1CyDL1TRkBSHgN1SUfzvan/4KWFNvrCfxzW1rCjh0jDrV0WuSGfM9v4NK+H
         m9L9QPA6JO8rJ1XRcHURZ0hOipr5x15Hz2KlsYS9Zs+fo8ZOaZ1VPSLvAZP6ECiZn7zP
         P9Hw==
X-Gm-Message-State: APuU4Z+dgz2FF00vylHjT3EyOALADwwh0a/p3IcChI/1KXs68IGfUG2U
	4QzX1fDG8kA/OvPimLvf0bXvjo8s/BvgF8KG1SBaPSEb+tb0QFRfwO02cgePTKGxZ+g=
X-Gm-Gg: AYBFou391M/MouSjXNUnX1jAi1mcvwde4CRWjkR8rFce6cIDj6Ewo1mTvi6HqFYVgLD
	oelZ1Kuja+4Fjtn9ah+r2OU19MNIJ/wSjb0cp9B3zKtSTFdurh5KoqKbv9UXnreBT+ks4J16Mxm
	iMdJZVcESu/7jav0DijHYe9w6AKDtoS/gmrhpT/t11GLXuiZwGRtvboIvhAMTo6NJpTvYjiFibN
	bZr+dnziro5ZQEh4s5H5hvkukWWzqyrGlvCEnryxw3AFyc1eTPGdQBuACkpTJEKtoSDenIDNME6
	th6vIrKt53oe85qMKTUWRKQ9iaux0ukeic8HSOhcBYhnfS7oG9ryCWETM3p6jaOHNQJ/55u7AZI
	H8wkXiV4PsQ9tmu4ezRRdLcFDAz96vbaYiFD/SWqUiERhNs7pZAQEfq/K++4XdG1flpFNmFc/9S
	gONwoi8RGy3kUUqO+518vIfWpI9HN3yc35Fw2Ni5/NNAmhgWWAJWVWK6+hxqxXap5r2B3qDBYX8
	5gSo7sDU/qOA1lKWfCMj0wmTrDTl85aZ640rZYB9/5RMVjpynymbH4/oaibTCQBZiaeopiAskT8
	ZoeakK9fHHhTnaWH6il6xXVzR7mgpaC2kseEGO9UR/kygfdf
X-Received: by 2002:a05:6a20:244e:b0:3eb:8ae3:e1a8 with SMTP id adf61e73a8af0-3f7a91e913amr13175118637.72.1794900419764;
        Mon, 16 Nov 2026 23:26:59 -0800 (PST)
Received: from zyf-laptop.tail52ade4.ts.net ([124.70.231.56])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8bed2055031sm4940716b3a.39.2026.11.16.23.26.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Nov 2026 23:26:59 -0800 (PST)
From: Yifan Zhao <stopire@gmail.com>
To: linux-erofs@lists.ozlabs.org
Cc: xiang@kernel.org,
	Yifan Zhao <stopire@gmail.com>
Subject: [PATCH v2 2/9] erofs-utils: lib: fix fragment buffer leak on realloc failure
Date: Tue, 17 Nov 2026 15:26:22 +0800
Message-ID: <b4a6a7a6ce1dce88ddc9aa7989e5d15448a3f3fb.1794899782.git.stopire@gmail.com>
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

Preserve fi->data on realloc() failure so erofs_packedfile_exit() can
free it together with fi during cleanup.

Fixes: 84bae6acdbee ("erofs-utils: lib: keep full data until the fragment is committed")
Assisted-by: Codex:gpt-6-astra
Assisted-by: Claude Code:deepseek-v4.1-flash-1017
Signed-off-by: Yifan Zhao <stopire@gmail.com>
---
 lib/fragments.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/lib/fragments.c b/lib/fragments.c
index d4e79b2..1f9e493 100644
--- a/lib/fragments.c
+++ b/lib/fragments.c
@@ -368,7 +368,6 @@ int erofs_fragment_commit(struct erofs_inode *inode, u32 tofh)
 		nb = realloc(fi->data, sz);
 		if (!nb) {
 			erofs_up_write(&bk->lock);
-			fi->data = NULL;
 			return -ENOMEM;
 		}
 		fi->data = nb;
-- 
2.56.0


