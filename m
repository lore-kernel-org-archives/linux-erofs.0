Return-Path: <linux-erofs+bounces-4705-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1F9DACA9EC5
	for <linux-erofs@archiver.kernel.org>; Mon, 12 Oct 2026 14:01:41 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4j3Jzl46k3z3bh4;
	Tue, 13 Oct 2026 01:01:39 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=185.125.188.123
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1791813699;
	cv=none; b=BgJLg5pxBzc4w4D4XJlMndAySo/xm3ny8aQgZuUwmW0aINSu6HQ7xU97kpiTJ8ty64Rw7lBJ7IiCAW4cxOLrS2k/Ou7h7YAD6sO/6Ko4kmpuMIfH//zuZiCQYdc6OFdeVOphstlH8x463fdrk9rbqfaHxTIu/SPrWI9jnfd7xOKjJEAXuVNppaPvZUpEjFpvENtxYv0XSGj4R2vvHZ+wycuKUn9aQhs0u9Nq1ZZrzslScOwhvE6Z85XEaenw5J9cCGWVcoNFgjE939JJOde+fk1R07irgQj9qlV43hhDr6QNpCyQi4THwptjwCLXlY05NO5aAQjst5hRevu9Rb76aA==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1791813699; c=relaxed/relaxed;
	bh=zpElUv7lb0HdX6PWGga/yrr4iXUea7cVqTJVsOTqDFo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WUlHa+0EqoD75p5k4Qo3FxYQWwpzedwZtxzTxFILO9d+irtl4m1yfkiidt2BV7kQJuj154sBlZ25CAXBDDoYWzT7j+XAPMNP05+R9qzBNgIke0cB/sobzkPT2saSXkrpTRgCOKumOWkY2ppFKpIfYynD4B79oVTw5FlHQNTGQHai2iRPfv62MLL3s+MtpQiirPMLvMxUkmeTjUS7XDtaJuRTP52G6yfspq5V/nmHpbt3a0dyQ6J3SHjoOWqs6ToxvbORoqF7UC7mPjBxRP72lf2fUEvePyu9bOBM7rZRN41pmENQQfyw5A/7HBHclbVUPp7b9neXlhRsmML7m1OKJA==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=reject dis=none) header.from=canonical.com; dkim=pass (4096-bit key; unprotected) header.d=canonical.com header.i=@canonical.com header.a=rsa-sha256 header.s=20251003 header.b=GD1+oTrc; dkim-atps=neutral; spf=pass (client-ip=185.125.188.123; helo=smtp-relay-internal-1.canonical.com; envelope-from=heinrich.schuchardt@canonical.com; receiver=lists.ozlabs.org) smtp.mailfrom=canonical.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=reject dis=none) header.from=canonical.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (4096-bit key; unprotected) header.d=canonical.com header.i=@canonical.com header.a=rsa-sha256 header.s=20251003 header.b=GD1+oTrc;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=canonical.com (client-ip=185.125.188.123; helo=smtp-relay-internal-1.canonical.com; envelope-from=heinrich.schuchardt@canonical.com; receiver=lists.ozlabs.org)
Received: from smtp-relay-internal-1.canonical.com (smtp-relay-internal-1.canonical.com [185.125.188.123])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4j3Jzk5W8Vz3bgK
	for <linux-erofs@lists.ozlabs.org>; Tue, 13 Oct 2026 01:01:38 +1100 (AEDT)
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com [209.85.218.70])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id 110E63F13F
	for <linux-erofs@lists.ozlabs.org>; Mon, 12 Oct 2026 14:01:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
	s=20251003; t=1791813696;
	bh=zpElUv7lb0HdX6PWGga/yrr4iXUea7cVqTJVsOTqDFo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version;
	b=GD1+oTrczn26nkjGIZ/pBTAW+zJNbMpmxQCLP7sbwzlj8NArTobgJ1KbJ4LQ9ZDEO
	 TYfU227q2ddcV6aagTnqwekaHqzXWmFX+iTYYuBsS4ne4PftTLebszZQvgDiZVFaxq
	 QUFoOHrOm1W3hAOz1HTVxUwCybfLzPXx5hnwvOjYYSBeVwT6VvTdfgRsAgMqyoh+QZ
	 gwDFHXtPfrjcVFDUXbJ8UtmIzbNdDkGMw2j9oa2A4kB2O0jquN6pOKtzh3uozVeJdd
	 GldKRbG+SG5iheYOQJANaiY8Moak41jHAYNserFqpFnH4g8Q3k7J7JlLQnodC4ghwD
	 rtJsvu2Ew0AjVY+0Msa6U0tCGgtvpjb4CKtHxfMnPxIfYitoWJP4HqPe7nIi7SZqTv
	 4STFVQO8bzmmPkainX8chw+k9VIfsHO2TbjPOFE8D5G8jMqCs8WR1XpVAiXXrmEzCo
	 WnAMEpB8H0kJlZDa9mISavV/yzXxWym+golcTaBMpb3a24seDeVQ+XhxibxmCtvkx0
	 +Bq0pFv5tfVFJMCsSAUK8rprGBevZVcVApwpaLH74obHvJ1J0vpnJtkXL3Nta4uWZ9
	 204RYq16gJQjjB4DqEu57bBsZv25dzkCYV87IOnzX+ROjmutNK1kjLydU44wit8IuF
	 krbSHwlQJAgd0kMzlzLOjoKs=
Received: by mail-ej1-f70.google.com with SMTP id a640c23a62f3a-c2e315271c1so170760966b.0
        for <linux-erofs@lists.ozlabs.org>; Mon, 12 Oct 2026 07:01:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791813695; x=1792418495;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=zpElUv7lb0HdX6PWGga/yrr4iXUea7cVqTJVsOTqDFo=;
        b=Q9KpD8TeVZJc1LnUrefOXXAR+6Vfb6PdKCptT2rPBzurIivfqTnbkf1nHFBJrKeBlZ
         UZZ1angu1m128Za7oqhmQLjqR6k+YnFMFLmQm6GFHomE6MuDt7uAj6wCPs8WRtgW9qkR
         AQVzdIpfAl7jiAG+w5SKiUD93GwmHGvKtyCj0a8mCPSYyLjpuStZW2xHkKoAihXBnLkt
         lbnl6gJQQImUZN0oPrscbwhQAu3ce0uIgOQJegLKCTmCu1LE011t4bcXu+l8p3jkVQHf
         4jWSZLMljVSs3rkXWEk/Tda6Nbx5x5b/7RT1x52Ars9MimaDZ6xqWt+vPrID2Y8CfzHb
         jpMA==
X-Forwarded-Encrypted: i=1; AKwUvBzcg2aAw98BKSDY6QvajF2xeniz/ujGdK4cQR1zD+58rb0mlG6q/NVS1kVSmy77qU0XKirHAOGq7JXUxQ==@lists.ozlabs.org
X-Gm-Message-State: AFq9FYJNHrW8WfCl5dMS0Irnu+oIlWaV65JPK5IgWKceLHvSXI967XB2
	ydThxhBu8ZSvRCedoEA601fewROA8H/AzNBQF8DAgUNtGtqBEmwIK0n5xGsZ0YPgUlxqpQv21QK
	oNC/wVd+mLQlDKe7z2mDBZbXxZc6ADIOzVUUeBHIgKPeDARPRTKqZOqTNfC9XioxAc0H7lqBw8n
	zAVr3d+EtsrpPVcQ==
X-Gm-Gg: AYBFou2hy7eD0qrBKrOxegAgM0j5jmfjo3lWTbF2ntTMu3pF1YruNAD+0KDOH65OmAd
	OFBXhzFvIeJj68k35OsZHMYfmziCV8Qr6JU9mv/OKxOi5lmV/6DO6YtCTTKgKQD5cyX900AQ0fw
	++a3t4UUijk37eCMSI/0P+WMm/8rJLbnwBLTqshRMNvf+QFG5GQmKEmiRAXRJR7G2YcMZwLRvhV
	bW6gUTwIhqldZNXgcUnb9WIjOOur1qyjEneSHYsZFlN1OS34cWHDdrfKrLzHeYq6WqXSBCItDYT
	ioEq7EjltD9QKcT1mpZbxxg0ZV1UDSziI/MGFNx0zn3LVyiWYQaiTahzWUXsXax0yrTIba1ykYe
	8HQnEDtox4Twxp0LLhyp1BXq1LblJIIhxoNLH1Rt+VWwk/aEEMtPIWQU=
X-Received: by 2002:a05:6402:4490:b0:6aa:ea1f:7e64 with SMTP id 4fb4d7f45d1cf-6b17c25d5acmr8897624a12.15.1791813695606;
        Mon, 12 Oct 2026 07:01:35 -0700 (PDT)
X-Received: by 2002:a05:600c:8208:b0:4a0:1b14:d00c with SMTP id 5b1f17b1804b1-4a18e446f55mr176937245e9.3.1791813683844;
        Mon, 12 Oct 2026 07:01:23 -0700 (PDT)
Received: from workstation5 ([2a02:908:1242:30e0:468d:767c:32e6:22fa])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a18bf15691sm284551015e9.6.2026.10.12.07.01.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Oct 2026 07:01:23 -0700 (PDT)
From: Heinrich Schuchardt <heinrich.schuchardt@canonical.com>
To: Tom Rini <trini@konsulko.com>
Cc: Simon Glass <sjg@chromium.org>,
	Huang Jianan <jnhuang95@gmail.com>,
	Daniel Munic <v-dmunic@microsoft.com>,
	Tony Dinh <mibodhi@gmail.com>,
	Alexey Charkov <alchark@flipper.net>,
	Vincent Jardin <vjardin@free.fr>,
	joaomarcos.costa@bootlin.com,
	Aristo Chen <aristo.chen@canonical.com>,
	u-boot@lists.u-boot-project.org,
	linux-erofs@lists.ozlabs.org,
	Heinrich Schuchardt <heinrich.schuchardt@canonical.com>
Subject: [PATCH 8/9] test: env: allow optional date field in ls output assertion
Date: Mon, 12 Oct 2026 16:00:47 +0200
Message-ID: <20261012140048.214059-9-heinrich.schuchardt@canonical.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261012140048.214059-1-heinrich.schuchardt@canonical.com>
References: <20261012140048.214059-1-heinrich.schuchardt@canonical.com>
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

fs_ls_generic() now prints a date between the file size and filename
when the filesystem sets FS_CAP_DATE (currently FAT and ext4).

Adjust the assert in test_env.py().

Signed-off-by: Heinrich Schuchardt <heinrich.schuchardt@canonical.com>
---
 test/py/tests/test_env.py | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/test/py/tests/test_env.py b/test/py/tests/test_env.py
index f8713a59ba9..e9d502148bc 100644
--- a/test/py/tests/test_env.py
+++ b/test/py/tests/test_env.py
@@ -523,7 +523,7 @@ def test_env_ext4(state_test_env):
         assert 'Loading Environment from EXT4... OK' in response
 
         response = c.run_command('ext4ls host 0:0')
-        assert '8192   uboot.env' in response
+        assert(re.search('8192 .*uboot.env', ''.join(response)))
 
         response = c.run_command('env info')
         assert 'env_valid = valid' in response
-- 
2.55.0


