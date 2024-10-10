Return-Path: <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 34696CF11C0
	for <linux-erofs@archiver.kernel.org>; Thu, 10 Oct 2024 09:51:51 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [IPv6:::1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4XPQ5K4C9Cz3btp
	for <linux-erofs@archiver.kernel.org>; Thu, 10 Oct 2024 20:51:49 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=115.124.30.98
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1728553907;
	cv=none; b=ONWsZi6nPr4tCL3APUBrGBbw+8APwZFxqPVnUDC5VrHo+bk93TyoOQ9Fi4vKfIYhuOHzW8YAw3siPm4DiZwLKQORreNFMG/ImrpapgaGinSQSkIwSZsni3fFs5NoQgfMgwOb1HCCqqG4tWcex0bY8latZHCiF1n6XZD1gxtBy0hM7vj9LS3Oe82T/U0VLIQJ07F54wKseXhAHCfxL9fMX8LDmdk+42zeO4PHwKipy/FZg6SpuG+g2W6bxYTDLRFReDUNJ3I8cehq2EuRg8du3CUPThhrqGDIYJIrj/Jhv24fMnGetNODT47N7Wn4l6NKS1domAEdH0lhS7XjjXDn8g==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1728553907; c=relaxed/relaxed;
	bh=hYTe/l79DEvNC3TWS9cCvY5JcYiwD+uEuZi0pVlddbU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=fQS09hslmqiWjkfDgsX+5tkva//Yi5H99yc4777Z+VLZ91SFUIFM0LFnO/Pa8jWQrwtBgDIDfKznkgccKJMJBfceHVmSEZdvLAFZym5SrjToIg9cjH5icLdouyqBkkAdCsJqTBiXnMCnp28sJky19Ws7YhHCt7DnzfQJ0nC3qATxhAIw7vl3uurwnMEsuxjci5/uBhcSU2+0cIVGx8rDO5pzD6NuvaeSQ8tVT2ahWh610DTKOTOCJgB/qS8Y4Z1RWysV47KTygmvj3D8ZNEz6EiLFs8KsLuC2xyqL1QL7pDf41DjPPkTpzAqJfbsWrab3yoB+/U7tADGqtLAMXjTDA==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=TO0LyKk+; dkim-atps=neutral; spf=pass (client-ip=115.124.30.98; helo=out30-98.freemail.mail.aliyun.com; envelope-from=hongzhen@linux.alibaba.com; receiver=lists.ozlabs.org) smtp.mailfrom=linux.alibaba.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=TO0LyKk+;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=linux.alibaba.com (client-ip=115.124.30.98; helo=out30-98.freemail.mail.aliyun.com; envelope-from=hongzhen@linux.alibaba.com; receiver=lists.ozlabs.org)
Received: from out30-98.freemail.mail.aliyun.com (out30-98.freemail.mail.aliyun.com [115.124.30.98])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4XPQ5933fGz2xjb
	for <linux-erofs@lists.ozlabs.org>; Thu, 10 Oct 2024 20:51:39 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1728553895; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=hYTe/l79DEvNC3TWS9cCvY5JcYiwD+uEuZi0pVlddbU=;
	b=TO0LyKk+FIDb9VUSMAXbavhrG+MUrKqKorVUmSeXbrNRnaYGwu3+VdUqoUP6CFWYxv5EhnWY/fbq7IOrLDGlHli8ynRxZd0yIe05jmAkzql74rzLeFM3oeXLa8oRwwNCEWV4MPulJc+oDXSQ8bLFu9P+NhiBxFHpBqx2Q5RR72o=
Received: from localhost(mailfrom:hongzhen@linux.alibaba.com fp:SMTPD_---0WGlzO.3_1728553893 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 10 Oct 2024 17:51:33 +0800
From: Hongzhen Luo <hongzhen@linux.alibaba.com>
To: linux-erofs@lists.ozlabs.org
Subject: [PATCH] erofs-utils: tests: fix compression algorithms check
Date: Thu, 10 Oct 2024 17:51:24 +0800
Message-ID: <20241010095124.2529867-1-hongzhen@linux.alibaba.com>
X-Mailer: git-send-email 2.43.5
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-BeenThere: linux-erofs@lists.ozlabs.org
X-Mailman-Version: 2.1.29
Precedence: list
List-Id: Development of Linux EROFS file system <linux-erofs.lists.ozlabs.org>
List-Unsubscribe: <https://lists.ozlabs.org/options/linux-erofs>,
 <mailto:linux-erofs-request@lists.ozlabs.org?subject=unsubscribe>
List-Archive: <http://lists.ozlabs.org/pipermail/linux-erofs/>
List-Post: <mailto:linux-erofs@lists.ozlabs.org>
List-Help: <mailto:linux-erofs-request@lists.ozlabs.org?subject=help>
List-Subscribe: <https://lists.ozlabs.org/listinfo/linux-erofs>,
 <mailto:linux-erofs-request@lists.ozlabs.org?subject=subscribe>
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs" <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>

When checking with _require_erofs_compression(), the error "xxx is
not a block device" occurs. This patch adds "-o loop" to address this
issue.

Fixes: ace04f5bbc5c ("erofs-utils: tests: add compression algorithms
check for tests")

Signed-off-by: Hongzhen Luo <hongzhen@linux.alibaba.com>
---
 tests/common/rc | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tests/common/rc b/tests/common/rc
index b739089..4fb4674 100644
--- a/tests/common/rc
+++ b/tests/common/rc
@@ -157,7 +157,7 @@ _require_erofs_compression()
 	truncate -s 1m $random_dir/test/file > /dev/null 2>&1
 
 	eval "$MKFS_EROFS_PROG $opt $random_dir/tmp.erofs $random_dir/test" >> /dev/null 2>&1
-	_try_mount $random_dir/tmp.erofs $random_dir/mnt || \
+	_try_mount -o loop $random_dir/tmp.erofs $random_dir/mnt || \
 		_notrun "fail to mount filesystem in _require_erofs_compression"
 	_do_unmount $random_dir/mnt
 
-- 
2.43.5

