Return-Path: <linux-erofs+bounces-4685-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CE371CA9EBE
	for <linux-erofs@archiver.kernel.org>; Sat, 10 Oct 2026 07:06:45 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4j1vsv5kBPz2yjw;
	Sat, 10 Oct 2026 18:06:43 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=172.234.252.31
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1791616003;
	cv=none; b=FW7m9QBkwdU6MgFkCNBHWbK8KUWJr8y2jp1DiZ/S98dSFqURob/F4WxtKnERY0fDZhEy8UGt7M/uNOHw5nzscR7p2PvSw6+gBzTZsbJRGlHeJN6eEHIsR78AAxAiaXcDWggx4p9JjDyA3XO57hxPiAFnTz0RZUNLmBMhbQayAbsWLknomVFeicgtmXDrXsS0Fc2gK1cGUOTZrgmqlCePgeIiuw8hCfDaX687vazdBIx5hvUArgwQjVPQhSNKosoGzCWN/ZJGYX5ufMUso+fh3CePSq2GigkxWHQp4jbiTl3CA8hYBr7R1Swr6+zHEfoNyq6hMOsBxZOzI9LpTioiaw==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1791616003; c=relaxed/relaxed;
	bh=Suzf8PCRnkauEGFkBM6f+/nSdAYzije1adxZPO+1Hvw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=id6OMgT4RMEVYcK4lPeTh1lf75SnCPicWBbNDSGQsfRy2pj0wjcoHWRmVhgKkxWPcUuJuntu4HYNAeeRW/sHySjGrr19fTSAIOkQiWFhOZWaH9QtmSCP37PStjh1DRjmP4ODsNQem8QdHD5/DhWR1bKu5cCH0gh9KIWnFQGvsLyMrRjMzZbpp9O/16rz+aKRMJ2+uKFpRaEU5H059YPCD8OmbF2n2CTsBRfBmvYm0QHMbO70IrPLvE+LGP36F/JheibPXZ8TJFFO9G71gAMHqSipuodrtA1Q4vjtRgLOSrNr0P4mNSEmHT+f9woFpuQNL7engLCtjr7hLDoLQipkEQ==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=YEJksbD7; dkim-atps=neutral; spf=pass (client-ip=172.234.252.31; helo=sea.source.kernel.org; envelope-from=chao@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=YEJksbD7;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=172.234.252.31; helo=sea.source.kernel.org; envelope-from=chao@kernel.org; receiver=lists.ozlabs.org)
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4j1vst4PXzz2yHD
	for <linux-erofs@lists.ozlabs.org>; Sat, 10 Oct 2026 18:06:42 +1100 (AEDT)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 3232343B1A;
	Sat, 10 Oct 2026 07:06:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A93FA1F00893;
	Sat, 10 Oct 2026 07:06:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791616000;
	bh=Suzf8PCRnkauEGFkBM6f+/nSdAYzije1adxZPO+1Hvw=;
	h=From:To:Cc:Subject:Date;
	b=YEJksbD737KiIJ3DHjtl8X8VgDFniow81R+lnSWCbirvFR0+9HrrMM0yC5hkJn1N2
	 MnihZN7sy1Lpn4sX3fTqt8KKsc5HdCL5rddTPeDag3lTyJbEKs6z8mmMR4apWjdb6i
	 8c8ONZi9ZfgFs4bVrYGLXKIFE7aoe6tu2XDN/D+wK+5k5+rWOipsTk2G3FkjCX8jaF
	 c0nceMI89x44CX2Ss07KvwGQdRRhpWpTbzwBqx7+aiVfFIAaeqFd/u5AK6lPiZe5kD
	 3D5+o7Zvx9Sij8ZATxCoZLpGaNx9HnD4Afzp5lFe1QIYR5GkQemjXUnyTpeqsQxl/d
	 6RnmqYV9iDgNQ==
From: Chao Yu <chao@kernel.org>
To: xiang@kernel.org
Cc: linux-erofs@lists.ozlabs.org,
	linux-kernel@vger.kernel.org,
	Yue Hu <zbestahu@gmail.com>,
	Jeffle Xu <jefflexu@linux.alibaba.com>,
	Sandeep Dhavale <dhavale@google.com>,
	Hongbo Li <lihongbo22@huawei.com>,
	Chunhai Guo <guochunhai@vivo.com>,
	Chao Yu <chao@kernel.org>
Subject: [PATCH] MAINTAINERS: erofs: add dev branch to git tree entry
Date: Sat, 10 Oct 2026 15:06:23 +0800
Message-ID: <20261010070623.1766952-1-chao@kernel.org>
X-Mailer: git-send-email 2.56.0.385.gd3acb90ef8-goog
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

From: Chao Yu <chao@kernel.org>

The EROFS entry lists the git tree without a branch, so tools that
derive a baseline from MAINTAINERS, e.g. sashiko, fall back to the
remote HEAD, which points to master. master only moves at -rc1, so
series developed against the dev branch fail to apply there.

Name the dev branch explicitly, where erofs patches are queued.

Signed-off-by: Chao Yu <chao@kernel.org>
---
 MAINTAINERS | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 068beaa035ac..63c8de75ada9 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -9690,7 +9690,7 @@ R:	Chunhai Guo <guochunhai@vivo.com>
 L:	linux-erofs@lists.ozlabs.org
 S:	Maintained
 W:	https://erofs.docs.kernel.org
-T:	git git://git.kernel.org/pub/scm/linux/kernel/git/xiang/erofs.git
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/xiang/erofs.git dev
 F:	Documentation/ABI/testing/sysfs-fs-erofs
 F:	Documentation/filesystems/erofs.rst
 F:	fs/erofs/
-- 
2.49.0


