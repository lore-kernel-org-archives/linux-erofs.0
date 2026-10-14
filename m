Return-Path: <linux-erofs+bounces-4736-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B3E07CC6B1D
	for <linux-erofs@archiver.kernel.org>; Wed, 14 Oct 2026 11:15:15 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4j4TBp1Tdpz2yVd;
	Wed, 14 Oct 2026 22:15:14 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2a00:1450:4864:20::436"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1791976514;
	cv=none; b=UvbHpYTad+BI1t2212CNDIncNOOeplxk9BT2+C8bzgvfY5cbi5PpYMmt3r+9JOMiGUPJ2YgmvSi0EUdwU65bwxJIYI5KdR79Cdzd7HSpa7tha3hdE3nLrtDEMbvKaWksuLSpQzozK+iabe5R6/n3HJKhf9NA7vfNCJ9RK0qvZt2BZ1/JHRpyuURt4zWIz/UoENy2bV8hxirB/KIgENZjN7cKN/xrXJMgqBxzs30y7Ne9kPcBrVzabwdCB3E/irF99FZlo9TNoc9B4D1SBTbwWGEOUrPUjkzxle3l1r3App7Tniptyw+NzncDFplhjr9tUnabgtHdhwuhlGpz6j7haA==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1791976514; c=relaxed/relaxed;
	bh=iikceBOXTZxD7Ya1iNZJ38IRluPVwuI4hq0the+RtIw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Nk9d3LXe6LMN42CqUUvikcVDEBvpBoFk3qvk3avF08+RWl2Ccl+RiwBb9SdoB+wFOSO3JtR464l7lW1pH0xup5SRsci1w1vSXmxxgMAxMH5iSePFwVOT3I/y+9kc/k6BJgbJF+3OhjqyRFfBsRIYS2oy3UT7J4k/s1w84GENJJq1nam1WQPZVNEOi0qoFekPakxUtqiOvKxNyENhFDdgWrjNtnVLFknaDvqG3Gnv18TXS7bT59gPlpDwijqxK3cr5f47QP5KPquDOW1hrHXk8g0EIDQdVS1YLJ22fjpPYJW+lyW75OPM2cdmMcYTihgB350R/y83r6VsxjGzIo7ByA==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=docker.com; dkim=pass (2048-bit key; unprotected) header.d=docker.com header.i=@docker.com header.a=rsa-sha256 header.s=google header.b=eXdaLHV2; dkim-atps=neutral; spf=pass (client-ip=2a00:1450:4864:20::436; helo=mail-wr1-x436.google.com; envelope-from=xiang.gao@docker.com; receiver=lists.ozlabs.org) smtp.mailfrom=docker.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=docker.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=docker.com header.i=@docker.com header.a=rsa-sha256 header.s=google header.b=eXdaLHV2;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=docker.com (client-ip=2a00:1450:4864:20::436; helo=mail-wr1-x436.google.com; envelope-from=xiang.gao@docker.com; receiver=lists.ozlabs.org)
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4j4TBm4rgqz2yTQ
	for <linux-erofs@lists.ozlabs.org>; Wed, 14 Oct 2026 22:15:11 +1100 (AEDT)
Received: by mail-wr1-x436.google.com with SMTP id ffacd0b85a97d-48c45111bebso2409293f8f.0
        for <linux-erofs@lists.ozlabs.org>; Wed, 14 Oct 2026 04:15:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=docker.com; s=google; t=1791976507; x=1792581307; darn=lists.ozlabs.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=iikceBOXTZxD7Ya1iNZJ38IRluPVwuI4hq0the+RtIw=;
        b=eXdaLHV2Ny8ByhUZ76YR6EuEGHA/xUtIw8Tc5l2EWiyrZsvUUqnvCOBeZESvBUr2Pv
         rokhzJwC0VEPs/o7aXr9/YJ1erMdgFRHM3gspFECXgWvuoD5ozo08pC69cucq8vxK4J4
         XnEu3+XGUu6Rvrj5KcLFcIpgRg+eKXHIzqe7xd14txkdW4cvFeYpTRJyyVUiFlhUFmkk
         XDL0sI9WCN0KbTF4BSKnypb3SZTy/5o/mYQumEkIQFrg1sCtgjnLezVJjCVAdENbdphu
         UdkTQ3ZyLSCTNMDH+BJYrH3enYQYAO3TOi+RJ5vM5N08ZXpXPMbyu9DYXbmICACzHv1u
         IWFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791976507; x=1792581307;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=iikceBOXTZxD7Ya1iNZJ38IRluPVwuI4hq0the+RtIw=;
        b=Jp00QABuMdXhYob7vvN72S46/Y9jfwKPDo3wkdoEQ7+cKqBGnin5RfWcOLp9OMCgsv
         A0Ve3d7HWb9lG5lax3AT8zETlYDsDSaSi42dFPWNZ1ahoVvlARYaa9NyQY/TBVDEw902
         XtazcqxqGbtdy6I1rC4V8D8pVOiDGjykaBdUZ+gNhy2d0GGvupt1UUNxzF0q+QVx/URV
         AneY8xQX4BWKxZqX//uyywpHmIAh5ZPEFrePom7IZGiMnawL581EwBELcDP7tGrw4D0N
         nvy0MMgI12/kbrfkixYrgKElI0cwPrnKmajgYgwO8k0/J79GuhsGAXj9zslI40XakyM5
         9dWQ==
X-Gm-Message-State: AFq9FYIMZ3bBr7MqIw1iIKEQTA5HAuj3oW2FFM0wwCES21wCRuY1Bnu9
	6YH+Sfih5dzeOL7IMi/PuJf8L8kuaQ5PkHeKjCQR1Tg5r44OV2L2W6qly6gBk0yURsqzIXKsW0J
	yJe1J0/37vg==
X-Gm-Gg: AYBFou0DugZTG0pZvHYRa9LLTx3YmuVz1JKVyFUTIp6dPs1wnpDoRsuKd2+6BZ5wq+N
	BEQQ3g4WWAnZNYcJDOICidJD7YbvJSUGBrTpzs3ysDNQ4cSVuUjkUusRv3o/3Nv44LTRSE+BfQE
	Iz0+0TnKMQynIOfOYdnqbTLVvCd5gIgeDi0Y4smc8v1zgFocuhjgBdk0+WKAy+Uf8FtIiylAo69
	Wwn6g1m+HWHNDB+uMCt1ND62lgga1kUrmdCaTqU+lj5P+Jo27BEeckmz+26GEV+l9vAWXPq6zIN
	1xcz50bZMgKqevC/vpaVgegb0pFkvBwZggM+Glh0vEFJsw2948hnVbQ29uqguNqFavI643GS3bB
	r4dPNFfh2e1W1T/gBwUZI4uyjb+cw8kLsILSBtw1k2J3MY/W3zlihE1b8nvpMIgLrd2J92zMfQi
	O5fTEId4uD3Fx9z01os0hMG0S29bthU9qYQK3jgQp9dlx9Tf0kes8L84Adz7R3pN/CNdBNhBG6L
	UKhlc3yT9ddJYO8WDSVoDJXKta9MQ==
X-Received: by 2002:a05:6000:2613:b0:488:7787:469d with SMTP id ffacd0b85a97d-48dbaaec58bmr28291468f8f.25.1791976507110;
        Wed, 14 Oct 2026 04:15:07 -0700 (PDT)
Received: from F7R9GP321C ([2a02:8108:f588:7800:c7:b27:5399:1c2e])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48de0acb1ebsm11643059f8f.44.2026.10.14.04.15.06
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 14 Oct 2026 04:15:06 -0700 (PDT)
From: Xiang Gao <xiang.gao@docker.com>
To: linux-erofs@lists.ozlabs.org
Cc: LKML <linux-kernel@vger.kernel.org>,
	Xiang Gao <xiang.gao@docker.com>,
	Xiang Gao <xiang@kernel.org>
Subject: [PATCH] mailmap: update entry for Gao Xiang
Date: Wed, 14 Oct 2026 13:15:04 +0200
Message-ID: <20261014111504.48355-1-xiang.gao@docker.com>
X-Mailer: git-send-email 2.54.0
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

I recently got a new job; update my mailmap entry to indicate my
new legal work email address (though I'm not sure I will use it
in the very near future).

Signed-off-by: Xiang Gao <xiang@kernel.org>
Signed-off-by: Xiang Gao <xiang.gao@docker.com>
---
 .mailmap | 1 +
 1 file changed, 1 insertion(+)

diff --git a/.mailmap b/.mailmap
index 389b94a0124e..55802b39523b 100644
--- a/.mailmap
+++ b/.mailmap
@@ -318,6 +318,7 @@ Gao Xiang <xiang@kernel.org> <gaoxiang25@huawei.com>
 Gao Xiang <xiang@kernel.org> <hsiangkao@aol.com>
 Gao Xiang <xiang@kernel.org> <hsiangkao@linux.alibaba.com>
 Gao Xiang <xiang@kernel.org> <hsiangkao@redhat.com>
+Gao Xiang <xiang@kernel.org> <xiang.gao@docker.com>
 Geliang Tang <geliang@kernel.org> <geliang.tang@linux.dev>
 Geliang Tang <geliang@kernel.org> <geliang.tang@suse.com>
 Geliang Tang <geliang@kernel.org> <geliangtang@xiaomi.com>
-- 
2.54.0 (Apple Git-157)


