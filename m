Return-Path: <linux-erofs+bounces-4020-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 08016C531D0
	for <linux-erofs@archiver.kernel.org>; Tue, 28 Jul 2026 02:18:49 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4h8Jzq55sZz2xQD;
	Tue, 28 Jul 2026 12:18:47 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2607:f8b0:4864:20::729"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1785205127;
	cv=none; b=dlipWLg9vlBwS0dmWYQRK2JeKtKxazOn5Qx8vMROy2TgvZJtHSQ8L1xj8TWZWiH1SwpJvKrL3doi92FYfyqh+iq2Mm3IG40RzQPlXqRGhff72bsZ5QZCUA+uO2fHwidGp0Sl5zz857e3sP58Um/9LXiOaPSt2LW6b6A+dYXWbFSZT/fiwNL8dWHYL6EoUtiJNJ+gDRwuwWLtCMuuRyMyftJdAzm/m3/YiLCJBymTUwuWUJuH8Y3msdp+Fv38CRFg2HuIk1sQJTanH6bVUpfwOOHjMt10R+DJVlU5zEh5UnLzyaYJLFyS2Dhj+XHX8gSzOA2d9GiIcTSrQBPJXhTphA==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1785205127; c=relaxed/relaxed;
	bh=ZVyf1iyJaAiVVkRPJ40VHPyg9CuIf4ZNPax+DqMD7t8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=abe4YGKxWgiUapUkcr3dw9MsgPwzv4FknCmsKIwrWwF1K0LtZikwnNZhMs7k7TK4OqHIh1/EMdt37i7a7J9FICkRH1QIx4MUVrZBZwwardIvMnhlLoSsApIjMcUQn4xzKGj86NkOXGFlYW+7/jzxYeDRt+cO8Itkk9fGk/Ovyfrl/7jdyfX6IzLdE/mD7OsmHVnvHy2otjsgp38BLCN9tdfV4tPF8+KrPG9ZdmGeaxM5mZrC58MvOQFLtcyfLVqIoKCOULu+neZUI3Jp1q+o8HeW1FEAXmdF5umlsgrdCeOA7qcfXU6pGcpVqXaN1kKs/M9YYnosKGZKJtUJEn5zvA==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=gmail.com; dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=g7zPi+QL; dkim-atps=neutral; spf=pass (client-ip=2607:f8b0:4864:20::729; helo=mail-qk1-x729.google.com; envelope-from=zhanxusheng1024@gmail.com; receiver=lists.ozlabs.org) smtp.mailfrom=gmail.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=g7zPi+QL;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=gmail.com (client-ip=2607:f8b0:4864:20::729; helo=mail-qk1-x729.google.com; envelope-from=zhanxusheng1024@gmail.com; receiver=lists.ozlabs.org)
Received: from mail-qk1-x729.google.com (mail-qk1-x729.google.com [IPv6:2607:f8b0:4864:20::729])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4h8Jzn5Ncxz2xLq
	for <linux-erofs@lists.ozlabs.org>; Tue, 28 Jul 2026 12:18:44 +1000 (AEST)
Received: by mail-qk1-x729.google.com with SMTP id af79cd13be357-9305a2121a1so283587385a.2
        for <linux-erofs@lists.ozlabs.org>; Mon, 27 Jul 2026 19:18:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785205122; x=1785809922; darn=lists.ozlabs.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=ZVyf1iyJaAiVVkRPJ40VHPyg9CuIf4ZNPax+DqMD7t8=;
        b=g7zPi+QLiXmETzD2B+TKZOakJv4ZwxolomhVZxBZH5gL/tLNBRbiQsRlWfOy5Vi6RP
         PRc0WOjEymypz+J89bXlU49nPSwumQ30PaVeLYXt3k07IB3RGzVcQ0DSnAgkTpaBwS+N
         JCoEkDXGzn+QBywQFqLj3toLN1GBCAlO9SbNpdQv1qFvduQ+Rkkz64QA+DEt5A/BkElt
         w5oZgkXWSnl2/R6/ru3FVGb0Zjk4gSY+jVYiHZicGt8R/VtgrL8aTrKef00Ix0/3wff7
         E683vXAc0CZPIrKsWOerX48O8FayMbgDx/oBnOyU6W8w1MFCtreUCUNGPULIClcyeVC0
         h/5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785205122; x=1785809922;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ZVyf1iyJaAiVVkRPJ40VHPyg9CuIf4ZNPax+DqMD7t8=;
        b=rehR8zsVx8cNTJHufizvEHV+H70y+gVitO5WXtBs9Duy4lHjcRPEGU6oFCd2ZQgv0f
         V9bVVOJ6XeU72Q07YC/I9lcAotvAlbAMZ/Drt4sYLxPRDozOfDNNbqXlU/6o3H8sw9ea
         Qdf0ZINOU1Gv/aQly0CAYR7cdOHXqGmjH84VkZTHnlEGN5Y2mv4Q0Wmtd45h6eMl3qFs
         C0R6wKmkVy5HIzdps69MPZ7Fgjziawijj8BO24j8pAmbEiKrefZXb2VVyz3jg5uqD4M6
         BVZjf1wkIURo5+e03+sMhu6wsAgSI240qm0+8orzBw5EBNwuod14NLddGoTIfgS/usTh
         TLkQ==
X-Forwarded-Encrypted: i=1; AHgh+Rr2IBVHa0UpcfY09FyInpZXlw8cU57r3LkJ3FTJGnJ+9qQ/Ze0RznnrqdXvkFWDKwu8lo2WRMQf7lh18g==@lists.ozlabs.org
X-Gm-Message-State: AOJu0YyEquvgge7hqYPA/lZBL9E2LNyQlxW9Drrax7tufO9F+JExFknR
	nB7P3UdHP7CYrCQKLGdkisJOkV+sUPDYexqfEDrUxtaeHm7ed7D5EslQ
X-Gm-Gg: AR+sD11L+h+4e/D3/Yo2g5P2L8SHaxxoc5ntyyr/d/oWOC+4DCncm6tUo1Cf4lvGm2Q
	c78HFY6ML7T0eqXoFwCY/HmMEAzJl+zz6zA3k6fJf22AjsyAUqvGZ3hJOFgPeswoo+3UNaGt/Xm
	7LGuZPrYxMqXmaBn5fmqj6YXtJqolkkC9/92orvxAqbR8wsLcC1h7A7vVB4jK5CI2WB9Pf/ffrJ
	hER6w4sVc253APkldQ1c+q/p4jqcqC2oDiNvTTSDNcKKZnigKJMqiFAM3hhy+6s0kmD+ITSzyuv
	5wkZmTVEiIdboX6KBFqO7H0tt+vxnzTboeJU8wjQioW+zo9CP4fqF1L5KUD4zDxNun756RFG54B
	a0MwD4VbksbjhQTWdiWXBaBn6zBxiwBpAiyB3Go3XEUHTHawAB1we6SCjdyMIa9UtzmoGAYcr8G
	eoURLAnR6CuV0tAeZOQw==
X-Received: by 2002:a05:620a:458a:b0:930:f129:1a45 with SMTP id af79cd13be357-93302658626mr42048185a.30.1785205121627;
        Mon, 27 Jul 2026 19:18:41 -0700 (PDT)
Received: from osman.mioffice.cn ([43.224.245.178])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-932de655676sm758546685a.37.2026.07.27.19.18.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jul 2026 19:18:40 -0700 (PDT)
From: Zhan Xusheng <zhanxusheng1024@gmail.com>
To: Gao Xiang <xiang@kernel.org>,
	Chao Yu <chao@kernel.org>
Cc: Yue Hu <zbestahu@gmail.com>,
	Jeffle Xu <jefflexu@linux.alibaba.com>,
	Sandeep Dhavale <dhavale@google.com>,
	Hongbo Li <hongbohbli@tencent.com>,
	Chunhai Guo <guochunhai@vivo.com>,
	Nick Terrell <terrelln@fb.com>,
	David Sterba <dsterba@suse.com>,
	linux-erofs@lists.ozlabs.org,
	linux-kernel@vger.kernel.org,
	Zhan Xusheng <zhanxusheng@xiaomi.com>
Subject: [PATCH] erofs: cap Zstandard stream pool size
Date: Tue, 28 Jul 2026 10:18:31 +0800
Message-ID: <20260728021831.1532541-1-zhanxusheng1024@gmail.com>
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

From: Zhan Xusheng <zhanxusheng@xiaomi.com>

fs/erofs/decompressor_zstd.c sizes the module-global Zstandard stream
pool from num_possible_cpus() when the zstd_streams module parameter is
unset, and z_erofs_load_zstd_config() then preallocates one workspace per
stream, grown to the largest dictionary of any mounted image (up to
Z_EROFS_ZSTD_MAX_DICT_SIZE, i.e. Z_EROFS_PCLUSTER_MAX_SIZE).  On high-CPU
systems this can pin a large amount of vmalloc-backed decoder state until
the erofs module is unloaded, mirroring the LZMA case fixed in commit
c9b47e6b2311 ("erofs: cap LZMA stream pool size").

Bound the default stream count by a new
CONFIG_EROFS_FS_ZIP_ZSTD_DEFAULT_MAX_STREAMS option, default 16, while
preserving the per-image workspace sizing.  An explicit zstd_streams
module parameter is still honoured as-is.

Fixes: 7c35de4df105 ("erofs: Zstandard compression support")
Signed-off-by: Zhan Xusheng <zhanxusheng@xiaomi.com>
---
 fs/erofs/Kconfig             | 14 ++++++++++++++
 fs/erofs/decompressor_zstd.c |  3 ++-
 2 files changed, 16 insertions(+), 1 deletion(-)

diff --git a/fs/erofs/Kconfig b/fs/erofs/Kconfig
index 8ca1767dafb6..a27114d3c82f 100644
--- a/fs/erofs/Kconfig
+++ b/fs/erofs/Kconfig
@@ -167,6 +167,20 @@ config EROFS_FS_ZIP_ZSTD
 
 	  If unsure, say N.
 
+config EROFS_FS_ZIP_ZSTD_DEFAULT_MAX_STREAMS
+	int "EROFS Zstandard default maximum decompression streams"
+	depends on EROFS_FS_ZIP_ZSTD
+	range 1 NR_CPUS
+	default 16
+	help
+	  By default EROFS allocates one Zstandard decompression stream per
+	  CPU.  Each stream preallocates a workspace sized for the largest
+	  dictionary of any mounted image (up to 1 MiB), so on systems with
+	  many CPUs this can reserve a lot of memory.  This caps the default;
+	  the zstd_streams module parameter still overrides it.
+
+	  If unsure, keep the default of 16.
+
 config EROFS_FS_ZIP_ACCEL
 	bool "EROFS hardware decompression support"
 	depends on EROFS_FS_ZIP
diff --git a/fs/erofs/decompressor_zstd.c b/fs/erofs/decompressor_zstd.c
index ab318a2400f9..44f9d89674e3 100644
--- a/fs/erofs/decompressor_zstd.c
+++ b/fs/erofs/decompressor_zstd.c
@@ -53,7 +53,8 @@ static int __init z_erofs_zstd_init(void)
 {
 	/* by default, use # of possible CPUs instead */
 	if (!z_erofs_zstd_nstrms)
-		z_erofs_zstd_nstrms = num_possible_cpus();
+		z_erofs_zstd_nstrms = min_t(unsigned int, num_possible_cpus(),
+				CONFIG_EROFS_FS_ZIP_ZSTD_DEFAULT_MAX_STREAMS);
 
 	for (; z_erofs_zstd_avail_strms < z_erofs_zstd_nstrms;
 	     ++z_erofs_zstd_avail_strms) {
-- 
2.43.0


