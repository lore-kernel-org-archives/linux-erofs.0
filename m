Return-Path: <SRS0=q2nB=LV=lists.ozlabs.org=linux-erofs-bounces+linux-erofs=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-21.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78611C48BC2
	for <linux-erofs@archiver.kernel.org>; Sun, 27 Jun 2021 13:32:47 +0000 (UTC)
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id D759961C35
	for <linux-erofs@archiver.kernel.org>; Sun, 27 Jun 2021 13:32:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D759961C35
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Received: from boromir.ozlabs.org (localhost [IPv6:::1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4GCWrY2thDz3049
	for <linux-erofs@archiver.kernel.org>; Sun, 27 Jun 2021 23:32:45 +1000 (AEST)
Authentication-Results: lists.ozlabs.org;
	dkim=fail reason="signature verification failed" (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20201202 header.b=pN8SmqYa;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized)
 smtp.mailfrom=kernel.org (client-ip=198.145.29.99; helo=mail.kernel.org;
 envelope-from=chao@kernel.org; receiver=<UNKNOWN>)
Authentication-Results: lists.ozlabs.org; dkim=pass (2048-bit key;
 unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256
 header.s=k20201202 header.b=pN8SmqYa; 
 dkim-atps=neutral
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by lists.ozlabs.org (Postfix) with ESMTPS id 4GCWrV6n8Fz2yL6
 for <linux-erofs@lists.ozlabs.org>; Sun, 27 Jun 2021 23:32:42 +1000 (AEST)
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3DB0761C2E;
 Sun, 27 Jun 2021 13:32:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1624800758;
 bh=/MLqqw3r2VUawzFcJJCJ279yx9HsZsFtE3O6P8hbUaI=;
 h=From:To:Cc:Subject:Date:From;
 b=pN8SmqYaXDw0b1/C/nvC2cfC0RCLIH/WI1QC/7a7FmZmFwA+akkydTdOw81+M4z6Z
 afcpLBjU14RTkpvL0CEfMMbRWqmfc6GJA8YwBVZIE1TT4BIVqsdtDO9YPSfGd7Ei7S
 U+j7swcLMsxc7Bj/VRNvL3y4fYD+/Q/oyJairfo2+MflxRXNfpYFzXdjeiVuWVPa8C
 NXV/BYjarH5yciy8n8wk2YyAhaDtmqm0djryVO959rBhcmcl52VCAq7IoEVLliH+PB
 jfxqk8gm40gIf9cAQQD9qn42ZNninpAE8LMZTKLVqrZdQhCae+YAHbryFSL+qdgrqw
 gZ+XKLJfFTcXQ==
From: Chao Yu <chao@kernel.org>
To: linux-erofs@lists.ozlabs.org
Subject: [PATCH] MAINTAINERS: erofs: update my email address
Date: Sun, 27 Jun 2021 21:32:29 +0800
Message-Id: <20210627133229.8025-1-chao@kernel.org>
X-Mailer: git-send-email 2.22.1
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
Cc: xiang@kernel.org, linux-kernel@vger.kernel.org
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs"
 <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>

Old email address will be invalid after a few days, update it
to kernel.org one.

Signed-off-by: Chao Yu <chao@kernel.org>
---
 MAINTAINERS | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 93ce2b8c1b44..7fa367400f7d 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -6763,7 +6763,7 @@ F:	include/video/s1d13xxxfb.h
 
 EROFS FILE SYSTEM
 M:	Gao Xiang <xiang@kernel.org>
-M:	Chao Yu <yuchao0@huawei.com>
+M:	Chao Yu <chao@kernel.org>
 L:	linux-erofs@lists.ozlabs.org
 S:	Maintained
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/xiang/erofs.git
-- 
2.22.1

