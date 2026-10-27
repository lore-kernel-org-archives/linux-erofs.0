Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72855606A31D
	for <linux-erofs@archiver.kernel.org>; Tue, 27 Oct 2026 08:08:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=cVpFXZ8r
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4jDNRZ2VY2z2yST;
	Tue, 27 Oct 2026 19:08:42 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=172.105.4.254
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1793088522;
	cv=none; b=hus2Xz+f3LaWEubGb+8vLRILVG6EdqmGXUNrOZ/VAtmcwma0acCCFLNmZvJbex1Nh51j1UlvjoSrAH+TtioxZXrkcve23SDwQke4IYmU/fUeT3MZadv4/uDsj/Cakqe27MH9YsUZABwgeDSMn5NzIus923XKQf+aX0KrFXWJUr8Tw5zYC/sW0cj7F0cOYBcCHiX6mKv7Kw57RbTa3GrQ21LKL+zVkvcpUeEwSpJlRph+gsmFxE1iInQyPJ5p7FFzEyGgYCjIj6IyJu7UORIGH646TJDJPzOc9zsT4RyRVcWADfngXKoYG+pq13Vj5sRJuT8K3lYC38qfqZj9hsbPfA==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1793088522; c=relaxed/relaxed;
	bh=1UvL3mp5p0BwJk6NSPGETpacBFCSAwHbGB7AHkVNMDs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Xqzm1DgnOsD3DSyDdzg+0h3+8bOXQqOVwnSCcdecV9yE7clz2xKVDp0D9F9cfXqj/YkEmbh0zsEvTu0cILROI20pSBva7Zyv2vyA27SzG/54/cLRF15/R9IseneXS3QesFbn9M49eFZTmQQmTsyUH/cuSApsLAEL7imDnVRU4A+sUbD0DaUjyWn+PRBjITynxV58aEwPGZZ5lfewfroS3hjJ/MQQBlWg1BjlQRCfC/FJ4O/To9IbCUUvrn0QNN4jMQyRQDfVcGCt/mnOZzvW7khUeO7lFiT6Bim9hSl/C8T5dE/Tqk4Vq93wQuFn++/tbPm4nwhvVL5yCyfHCjGnUw==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=cVpFXZ8r; dkim-atps=neutral; spf=pass (client-ip=172.105.4.254; helo=tor.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=cVpFXZ8r;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=172.105.4.254; helo=tor.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org)
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4jDNRY28Jdz2y8Z
	for <linux-erofs@lists.ozlabs.org>; Tue, 27 Oct 2026 19:08:41 +1100 (AEDT)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 4D5F2601FF
	for <linux-erofs@lists.ozlabs.org>; Tue, 27 Oct 2026 08:08:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06E2E1F01825;
	Tue, 27 Oct 2026 08:08:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793088518;
	bh=1UvL3mp5p0BwJk6NSPGETpacBFCSAwHbGB7AHkVNMDs=;
	h=From:To:Cc:Subject:Date;
	b=cVpFXZ8rDt+M0QuPUBN9cuE8SKJla7WpesX0xEtRFsjFQv+Z97EKyOXRSlxr+nsz4
	 d+Nu2Ip8jzNTD7fua28JfePWeBhosPsjS9uerJV6IPV7MGQaiX6eDFVGHQsnkZV2c4
	 BFeeA2snZOAygloxE0QcZ/DkIQP/bc4mGTz/OwjTgPStPmNHzWWH3zLCCDsX0mm76x
	 fdFunBHbcX1owTZT/s5ewswAOezOcYQW7ZvotTpPSr+dZzTsNr9pOslnk3bNYMXSJ9
	 ziBMhufOdTUCT1Y/zbjl+N6neJYbvEbdidqfwR1gK8PHbCg5QuDlDhWqJU6qa+dEEZ
	 +daiH4YMyp1/A==
From: Gao Xiang <xiang@kernel.org>
To: linux-erofs@lists.ozlabs.org
Cc: LKML <linux-kernel@vger.kernel.org>,
	Gao Xiang <xiang@kernel.org>
Subject: [PATCH] erofs: drop unnecessary .read_folio() checks for file-backed mounts
Date: Tue, 27 Oct 2026 09:07:46 +0100
Message-ID: <20261027080747.12207-1-xiang@kernel.org>
X-Mailer: git-send-email 2.47.3
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
X-Spam-Status: No, score=-19.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Since currently dedicated EROFS-owned meta inodes are used for
file-backed mounts, .read_folio() checks are now redundant.

As a result, EROFS file-back mounts can now apply to tmpfs too.

Fixes: e587a984d332 ("erofs: use dedicated meta inodes for file-backed mounts")
Signed-off-by: Gao Xiang <xiang@kernel.org>
---
 fs/erofs/super.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/fs/erofs/super.c b/fs/erofs/super.c
index 16fa3b853f1b..254b32f77a42 100644
--- a/fs/erofs/super.c
+++ b/fs/erofs/super.c
@@ -850,8 +850,7 @@ static int erofs_fc_get_tree(struct fs_context *fc)
 			errorfc(fc, "source fd option not supported");
 			return -EINVAL;
 		}
-		if (!S_ISREG(file_inode(sbi->dif0.file)->i_mode) ||
-		    !sbi->dif0.file->f_mapping->a_ops->read_folio) {
+		if (!S_ISREG(file_inode(sbi->dif0.file)->i_mode)) {
 			errorfc(fc, "source is unsupported");
 			return -EINVAL;
 		}
@@ -871,8 +870,7 @@ static int erofs_fc_get_tree(struct fs_context *fc)
 			return PTR_ERR(file);
 		sbi->dif0.file = file;
 
-		if (S_ISREG(file_inode(sbi->dif0.file)->i_mode) &&
-		    sbi->dif0.file->f_mapping->a_ops->read_folio)
+		if (S_ISREG(file_inode(sbi->dif0.file)->i_mode))
 			return erofs_file_get_tree(fc);
 	}
 	return ret;
-- 
2.47.3


