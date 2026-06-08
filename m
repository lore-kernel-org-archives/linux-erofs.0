Return-Path: <linux-erofs+bounces-3523-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B5047CD8C9D
	for <linux-erofs@archiver.kernel.org>; Mon,  8 Jun 2026 05:07:27 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4gYg5T6kS7z2ytV;
	Mon, 08 Jun 2026 15:07:25 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2607:f8b0:4864:20::1030"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1780895245;
	cv=none; b=eeAwbR5zB5niEsl7w93IkLHuwi9Fz/ozev0XsD4bywrZGdPqArXfQqyvXcTglDvYiwPK55ZMYiM8YDCCfD4TkWnAvMqMS9tYqwCuWmoNAIXynt6XEYPku6h0Zk94ChdtU3SIwJRxTO9ekqf0fb1tCW3wG6DP/wmcMxQI9dXdctg/aaMEH+9mBiHeKGkOCMsKUTMoW+9njS+oNSbNPhvPGbIrNy0BDUj8J6VGCPsEovc1p4mt9fbOOubLMWU2bbDgg4ROgPHQkMZz9OonUp/LM2H3dL8oJWlRxpDWouTpu+pB6zFpTzLg+keCHApz7RpbumW36VoIBpUrfDjINbGyZw==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1780895245; c=relaxed/relaxed;
	bh=epOBO4bF1Ans+8IsPL44B54Os7VfV0akO2a4r8GhbB0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eG5QdfyL+IC6mcFtbygYLdFO9/U2tgvRUN0/DX1sNO3yLhOjtOUWYGEZrlLDmR4N7MPkLhZ2vFJib9K0E0jEli8IHvqslj3rtc9QwevAMA69totUtZJnnEEO6+RYrMol5sCobgHc3Jr43xqdNlOU2j3UdiZNhZQ8c6OXXiTyJuQgrGz4LHLA0nLL/GEnNqm9mMbvdsL8fFUVsMBWIM7lECiEHKDafa1Wr8LJeLKoQmtSPGyLhrMfSEAzzVthUCPewp1QjJAjIk43GyjvCEcnRE6HYc2uw4Wz8DijRwfm/O+3pURs0VSAp3SqSpGql2c89at7KkkHqLlmYrtX+TWXRw==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=gmail.com; dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=A+5hIgYe; dkim-atps=neutral; spf=pass (client-ip=2607:f8b0:4864:20::1030; helo=mail-pj1-x1030.google.com; envelope-from=nithurshen.dev@gmail.com; receiver=lists.ozlabs.org) smtp.mailfrom=gmail.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=A+5hIgYe;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=gmail.com (client-ip=2607:f8b0:4864:20::1030; helo=mail-pj1-x1030.google.com; envelope-from=nithurshen.dev@gmail.com; receiver=lists.ozlabs.org)
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4gYg5S3y8kz2xqv
	for <linux-erofs@lists.ozlabs.org>; Mon, 08 Jun 2026 15:07:23 +1000 (AEST)
Received: by mail-pj1-x1030.google.com with SMTP id 98e67ed59e1d1-36d98b68d68so2523020a91.2
        for <linux-erofs@lists.ozlabs.org>; Sun, 07 Jun 2026 22:07:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780895241; x=1781500041; darn=lists.ozlabs.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=epOBO4bF1Ans+8IsPL44B54Os7VfV0akO2a4r8GhbB0=;
        b=A+5hIgYeNvsWmOtme08z1K7cRWBvnOEJOF2PSyBWBueAWccVfviZf3ZcgKPtMD5rRN
         0HL9sGhCROUGTLxSRNxoRxL8BCX8bhs73tBfSI8D23ty5fL/0Lh7kkI/sm7J0kqQ9CIZ
         0zKFjtBFxe028vajc2wUUz52NI2Jy2O3j4PNG+Up0RkaW1xujaBR6Ju6suurtGfYgVES
         Vgo0jInMKYrOAUtXtMdEQ6Ztz2TlQm59WPBPNlbipZB/yPvkqWseFvvUVNNqCb1qgtt3
         qQitEaGc6t9p3uERsJA3P4RjfjwIQcEkD6rzgD8HkHh2UuXLWTerjFxyt1Mdlt16+X4s
         d/8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780895241; x=1781500041;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=epOBO4bF1Ans+8IsPL44B54Os7VfV0akO2a4r8GhbB0=;
        b=Au5jfFDmzn8uHk5C0183RJA2HuNoTs3SQ04vZAR3UCSde5pJ/NaE/zfuPM6fRDl7Qj
         DCHAaNIqv0BjtkQMSu1jNV+9bWMQgtLqa9uFIPtOAOHKEYAtOXt3WCb7iHd2AtLz2hTi
         h+/Z/YjVxCrHsrF8dypLWdfGiIa8c2/I9DQTYOSoEsCDmsU4zoMFpLoDklH6Mlr6qWA8
         /tT0feLeZH4vBWvtMz7muDWAuEYPoW/ab91voP/mj5TPt18g3t4ft8kPDeLL8TOI8A0l
         +SCnnAxJfHVL7me9cBHF/H9yYhrtrHNcYJxoNNSG46HwO0xf/AZjCH9A5jdtt5LkUFDP
         CrgQ==
X-Forwarded-Encrypted: i=1; AFNElJ9LIuUwC+066xAzdTHs6el5mnYu6nXHRvnF1Rn/jOx6iARYaB64n2upreIXwVmwy48M9pcRO3FngLjZTA==@lists.ozlabs.org
X-Gm-Message-State: AOJu0YyQkpQz7sW01+FttZRN8JGIK2cPgn9TJTTYAqzKkOsuGoE/x+kg
	476D7R3DK4f5NIMI4v6RE6clwpPNhn2lAMsJr3WuQDjHESegYVSHUTEc
X-Gm-Gg: Acq92OG90Qcvak46O2SUvdsOGoUixh3Qf09HyXGjGE+zoNRTOEwPuYo7HEqbHjd/RmM
	rjVcarRfTTutStu7KFzDxGJXTeRQPRRRofGxzHP084qUEUXzkupIIMi/sOGCVIDRbOMEfhpjvPx
	WPbh6ZMYXIFzBgnP4TeVCkkDQ+dinhmYCwBsaBdZqABRG60geG9S7tYrTSH5RGo/dfsT1/N1cmY
	0xt8LRmQAUWs+QMHulB5sdwC0mMPBLMdtC+rQDHJ4cnRvd/6d8GnsBnomkFWdiEodX+4KMRVEUO
	cBT4s3byQCTPuVcoh0Ci+M2CmgnRg0Wnnj4RPCzuxMkuUb4+6o12+x45GKQ+SuwWbG3LaD1+IUB
	e0hkudPNlO4pDk9mbiZE7oaR9FzcTFDru2Xnzh6h6kAk6h87jaubl7ndm4ElI+3C4cjKpL1vhxL
	zV2+BevVYDBBVghV6Kovu4yHUerlSBcI/R0r+jzts8z2ORFgLvV+H8EHmtc2GsUece59IdGvpoZ
	VmJ18ejsqWF9nL44JjMDgA5
X-Received: by 2002:a17:90b:6c3:b0:36d:6308:12fa with SMTP id 98e67ed59e1d1-370f0386f18mr15677265a91.18.1780895240719;
        Sun, 07 Jun 2026 22:07:20 -0700 (PDT)
Received: from pool-100-10-46-50.prvdri.fios.verizon.net ([139.167.225.118])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-36f70a29cd6sm14198397a91.11.2026.06.07.22.07.18
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sun, 07 Jun 2026 22:07:20 -0700 (PDT)
From: Nithurshen <nithurshen.dev@gmail.com>
To: nithurshen.dev@gmail.com
Cc: hsiangkao@linux.alibaba.com,
	linux-erofs@lists.ozlabs.org,
	xiang@kernel.org
Subject: [PATCH v2 0/2] fsck.erofs: add multi-threaded decompression
Date: Mon,  8 Jun 2026 10:37:09 +0530
Message-ID: <20260608050711.30648-1-nithurshen.dev@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260523003757.13078-1-nithurshen.dev@gmail.com>
References: <20260523003757.13078-1-nithurshen.dev@gmail.com>
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

Hi Xiang,

Thank you for the review. I have addressed the feedback:
1. Replaced bare pthread calls with EROFS abstractions (erofs_mutex_t,
   erofs_cond_t) to ensure the code remains portable and works when
   !EROFS_MT_ENABLED.
2. Updated "dynamic" batching terminology to "algorithm-aware"
   batching for better clarity.

This series introduces multi-threaded decompression to fsck.erofs to
decouple I/O from decompression, significantly improving extraction
throughput on multicore systems.

Best regards,
Nithurshen

Nithurshen (2):
  fsck.erofs: introduce multi-threaded decompression with static
    batching
  fsck.erofs: implement algorithm-aware pcluster batching

 fsck/main.c              | 239 ++++++++++++++++++---------------------
 include/erofs/internal.h |  19 +++-
 include/erofs/lock.h     |  22 ++++
 lib/data.c               | 210 ++++++++++++++++++++++++----------
 4 files changed, 301 insertions(+), 189 deletions(-)

-- 
2.52.0


