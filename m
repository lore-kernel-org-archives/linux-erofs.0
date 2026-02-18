Return-Path: <linux-erofs+bounces-2334-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3DEECE9A02C
	for <linux-erofs@archiver.kernel.org>; Wed, 18 Feb 2026 13:14:46 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4fGH6X37Rxz3bnD;
	Thu, 19 Feb 2026 00:14:44 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2600:3c0a:e001:78e:0:1991:8:25"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1771420484;
	cv=none; b=OI29YRCAgmnQJ/mhvkcyPPzdC628rCGW11N/TL3Fxv+WQY8hY4o+rjbQ6OR+X6cmSbanjYzKkuUwBf+A1S1lpZJfEZYapkZYCFb43BPi2gNBnabrAn18YLJfjkmokgIlg8BH5M/3edMezvSB4OTCgzvS8VAouYXiYB9sgAkpEdVU1chcrRp6rxoK3hdHfSlF/4jK2c3bPBaFWSx3yRTP1t9DfsrPUKDVXUIqLVRIuF28CCY+wW1uaA+8F5XSax/GTS4ydbIMMSjtL67l+PWTjNq+cS6mjYzwaqSmwdaC4hdgksoni4dY55hyNyoxSFPAmOygmem94YIG83o52dENaA==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1771420484; c=relaxed/relaxed;
	bh=R9o7B0XyRf4oxbZtrtwELk9VUK22k/bz/nbBOAn63to=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=eNr3fk3ecOjONndgkL/FQUFiAYDVEsZ7tO3NefCOnfg1dQSyUslGHeSAiNaKUvPPRkUIvrMraVzmzJJ7hVBkj9CjQZK5XXYyi80IKjSAnVM+DhPGcFUUadUdgx0jbqOJXGX3G637VX2/xd8ohikwCCrgQioR7evDT1TgcVR7alfhV9mSGCNNy2+WuN5ZCiJaPKgOtJ1uI9qss0Ju5om4uFm8Op7ZdfsVGbiWay0f9KllX9PcmO124y4C6s63SwDpTsoLkYIa/sVqpCoY2ZF4JZAJIalQEWydD6O6ijX0Ls12QbFKTlAHgMo1uGQ42HkQ6YCisTJIl0MatlveS+NyWQ==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20201202 header.b=aAwtVuj9; dkim-atps=neutral; spf=pass (client-ip=2600:3c0a:e001:78e:0:1991:8:25; helo=sea.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20201202 header.b=aAwtVuj9;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=2600:3c0a:e001:78e:0:1991:8:25; helo=sea.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org)
Received: from sea.source.kernel.org (sea.source.kernel.org [IPv6:2600:3c0a:e001:78e:0:1991:8:25])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4fGH6W2WV2z3bnB
	for <linux-erofs@lists.ozlabs.org>; Thu, 19 Feb 2026 00:14:43 +1100 (AEDT)
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 36B8944497
	for <linux-erofs@lists.ozlabs.org>; Wed, 18 Feb 2026 13:14:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B90A6C19421;
	Wed, 18 Feb 2026 13:14:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771420480;
	bh=bfKMXFcupLlPjIgRJunEY2tjDlC/CeYIZUY+LIxrNYY=;
	h=From:To:Cc:Subject:Date:From;
	b=aAwtVuj9qKo/zKtJ0ZZfZHg7ONlgoh89pCnsLk4MPsOjyh8zJjXZ5VWvGKDYwYrUn
	 pIE9t0ybbnfjRUGxNljhyllWr+UehBgVmj5c5jVqBSBOWf69UprtTY6LqRK3dqXSex
	 Qlx3j5JiMxdpCt2La4Y9aLc64Trx+cSZsy/JhE0yl5ndAsJzH9hZBKQeF6PI/I+NMQ
	 FojghEtivg22ZKWav+lcHR3BNiRXImyJBxUNZ7JK74sYQPyEu8PdSNKy2/wuQRTU8A
	 wT3Bb9GfLFANseBfmYP97CjckHJ84ENVgM1DO3M8iauzAHxV4JVFKLHHyNUVJSJsfP
	 fY8LriFR2AYqg==
From: Gao Xiang <xiang@kernel.org>
To: linux-erofs@lists.ozlabs.org
Cc: Gao Xiang <xiang@kernel.org>
Subject: [PATCH] erofs-utils: manpage: fix installation of `erofsfuse.1`
Date: Wed, 18 Feb 2026 21:13:51 +0800
Message-ID: <20260218131351.46839-1-xiang@kernel.org>
X-Mailer: git-send-email 2.47.3
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

`erofsfuse.1` may be missing if `man_MANS` is assigned twice.

Signed-off-by: Gao Xiang <xiang@kernel.org>
---
 man/Makefile.am | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/man/Makefile.am b/man/Makefile.am
index c951681..b9b5989 100644
--- a/man/Makefile.am
+++ b/man/Makefile.am
@@ -3,10 +3,12 @@
 dist_man_MANS = mkfs.erofs.1 dump.erofs.1 fsck.erofs.1
 
 EXTRA_DIST = erofsfuse.1 mount.erofs.8
+
+man_MANS =
 if ENABLE_FUSE
-man_MANS = erofsfuse.1
+man_MANS += erofsfuse.1
 endif
 
 if OS_LINUX
-man_MANS = mount.erofs.8
+man_MANS += mount.erofs.8
 endif
-- 
2.47.3


