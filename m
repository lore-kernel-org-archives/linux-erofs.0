Return-Path: <linux-erofs+bounces-4668-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8300FCA5FFC
	for <linux-erofs@archiver.kernel.org>; Tue,  6 Oct 2026 22:18:41 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hzrHz6mlzz2yDc;
	Wed, 07 Oct 2026 09:18:39 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=172.105.4.254
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1791325119;
	cv=none; b=lr73WG6sluBYIZbzJwGdiyKW4xMKoL74/O7COE0Hcm/1ajoEgMCS/uukaxktJ9v4+a7elXimzp4GNJZd0CXC6dAZXdJmhjO30jgdOZ5GN+V637xKcaPvYgSY56bJmtw+RNIDkI3vEI3G4TnwAcThUjECYeqZAUoGH0TK8loJtnBYmpin8JvpyfN8vknTyXsQWM7eeMyrHfwQea5PWvXSc2D90m31gvX3MWhseg9UiYeNJmHHvusdrli0J6bfy/AX+1YymxezDoBXgAvGavc8JDAaWpXB10XjXWRgR5ypp4Zy+bCn3Xh4CmxHqwGeJ1NlXqSSlJCHltwYTGFO+Btx4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1791325119; c=relaxed/relaxed;
	bh=DhAjc0GadKCD+x8k5OWStHNlDj7PP3dJfgyeorJv21g=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=MBv2BzlQUneF1KgLFdtPISkZYuZtrdSq4mQWF8fNKR7dXgrNXmoS/frgqbr/xPtSn4nDfPyei2bP/9Bh1+xgut3gb1pwgGY0whM/57a2WZANEKykVvMPalrkGHhbow0B1F7x/JQWIvTQcO4WGknUrtJ5dcqoKiohEb5EU7P7Wl1Lllrv8TtLNmTAVZgHkcbsklNE+UoFgn69t9TOhyoH8vl9uwNVWNhspvjkR5ZTxPxRk3MjIhZ4aE3vwL61r37UJJiqqaCdXAk1mR3o2VmSRH5lIg/psG27idsqOsVcykqIrYX700i2n9nEEE6MB3EAFINAnDlX0SevIsS7Mjhu1Q==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=k/hFbhuO; dkim-atps=neutral; spf=pass (client-ip=172.105.4.254; helo=tor.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=k/hFbhuO;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=172.105.4.254; helo=tor.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org)
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hzrHy2Y0Pz2y2K
	for <linux-erofs@lists.ozlabs.org>; Wed, 07 Oct 2026 09:18:38 +1100 (AEDT)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 5B320601FE;
	Tue,  6 Oct 2026 22:18:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F7C21F0089B;
	Tue,  6 Oct 2026 22:18:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791325115;
	bh=DhAjc0GadKCD+x8k5OWStHNlDj7PP3dJfgyeorJv21g=;
	h=From:To:Cc:Subject:Date;
	b=k/hFbhuOk/qXzjnEGToBjVJgjKRPjbcQKglzM7sNlVdIfXvlRabzhpJhGJ2UmU/AN
	 Cqbaf0l/vDujSWlQ5YFaUimKBhmLsMZjuBQl/1nAmILk5KL8+kibNuS5GrDf2H5Tvl
	 IDMwJ377hVMO7PyimehjOO3Scp34zA75DGaoPsyWju9naqdXwlCKrXOH+wjdWCWHHG
	 2mPtV40RRwuOvXUtk0oQjDxXuPIy9fxLlsMwSv1C2xttgeG9kfhdG1wj8HzM77Uk4e
	 CBQYvLUloR7p/FFHbbavVGEnTy1b84/Hsguzd4l7Hvb7b9gPJrsVbQcyf1iyQRY5Dx
	 eFZarWqZJ4jtg==
From: Gao Xiang <xiang@kernel.org>
To: linux-erofs@lists.ozlabs.org
Cc: Gao Xiang <xiang@kernel.org>,
	=?UTF-8?q?Jan=20=C4=8Cerm=C3=A1k?= <sairon@sairon.cz>
Subject: [PATCH] erofs-utils: mkfs: fix segfault with `--compress-hints`
Date: Wed,  7 Oct 2026 00:18:30 +0200
Message-ID: <20261006221830.4763-1-xiang@kernel.org>
X-Mailer: git-send-email 2.50.1
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Reported-and-suggested-by: Jan Čermák <sairon@sairon.cz>
Fixes: bb9f75521465 ("erofs-utils: lib: migrate `c_compr_opts`")
Closes: https://github.com/erofs/erofs-utils/issues/56
Signed-off-by: Gao Xiang <xiang@kernel.org>
---
 mkfs/main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mkfs/main.c b/mkfs/main.c
index f0d3d8c..93123c1 100644
--- a/mkfs/main.c
+++ b/mkfs/main.c
@@ -1886,6 +1886,7 @@ int main(int argc, char **argv)
 		}
 	}
 
+	importer_params.z_paramsets = mkfscfg.zcfgs;
 	err = erofs_load_compress_hints(&importer, &g_sbi);
 	if (err) {
 		erofs_err("failed to load compress hints %s",
@@ -1895,7 +1896,6 @@ int main(int argc, char **argv)
 
 	if (mkfscfg.inlinexattr_tolerance < 0)
 		importer_params.no_xattrs = true;
-	importer_params.z_paramsets = mkfscfg.zcfgs;
 	importer_params.source = cfg.c_src_path;
 	importer_params.no_datainline = mkfs_no_datainline;
 	importer_params.dot_omitted = mkfs_dot_omitted;
-- 
2.50.1 (Apple Git-155)


