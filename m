Return-Path: <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C5DCFC433F5
	for <linux-erofs@archiver.kernel.org>; Mon, 22 Nov 2021 00:05:33 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [IPv6:::1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4Hy6wr0jtsz2yms
	for <linux-erofs@archiver.kernel.org>; Mon, 22 Nov 2021 11:05:32 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org;
	dkim=fail reason="signature verification failed" (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20201202 header.b=Ay74Tbx9;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized)
 smtp.mailfrom=kernel.org (client-ip=198.145.29.99; helo=mail.kernel.org;
 envelope-from=xiang@kernel.org; receiver=<UNKNOWN>)
Authentication-Results: lists.ozlabs.org; dkim=pass (2048-bit key;
 unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256
 header.s=k20201202 header.b=Ay74Tbx9; 
 dkim-atps=neutral
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by lists.ozlabs.org (Postfix) with ESMTPS id 4Hy6wm3KHMz2xtT
 for <linux-erofs@lists.ozlabs.org>; Mon, 22 Nov 2021 11:05:28 +1100 (AEDT)
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2CC4360E0C;
 Mon, 22 Nov 2021 00:05:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1637539526;
 bh=rOKAXbst67vAzU1joq6PGuzaCZhZAGpWXefvg5n7Bwo=;
 h=From:To:Cc:Subject:Date:From;
 b=Ay74Tbx9aITxxunbWzOYUuJFrtpFhFscIAPg0pLs7dgGbxaZnn2b7zE5TqlslqzA7
 VLr+H7pvQfRTtuFGrNle3PEtB0+VRt4JxdlvJrV5Rht63uLt47yIBPlPLAc8WLwx9t
 +kuV4wAcQUb9D04Yz56rs7H5tuiu/ZRvhiEdnYC1+XsaA02RxpDmIsSKykaX2svc3v
 MifDOVci7uWjRRauD8tVYaWjzQOT1ViTNZ7IMWE0sgGpURA21/A6dD0LZ9a29JNR2T
 wbojgrLjbgC/MYAJYH9E3jA6OyErkY0ouhylxemS9ZbwJVMcRCoaRwxzxIpIbpEoeF
 XbBZ8q6HvTBGA==
From: Gao Xiang <xiang@kernel.org>
To: linux-erofs@lists.ozlabs.org
Subject: [PATCH] erofs-utils: add fuse/macosx.h to noinst_HEADERS
Date: Mon, 22 Nov 2021 08:05:14 +0800
Message-Id: <20211122000514.27680-1-xiang@kernel.org>
X-Mailer: git-send-email 2.20.1
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
Sender: "Linux-erofs"
 <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>

Fix distcheck recompilation.

Fixes: 95801d47cbde ("erofs-utils: fix macOS build & functionality")
Signed-off-by: Gao Xiang <xiang@kernel.org>
---
 fuse/Makefile.am | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fuse/Makefile.am b/fuse/Makefile.am
index 7b007f3fec11..8a2d4720d1b7 100644
--- a/fuse/Makefile.am
+++ b/fuse/Makefile.am
@@ -1,6 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0+
 
 AUTOMAKE_OPTIONS = foreign
+noinst_HEADERS = $(top_srcdir)/fuse/macosx.h
 bin_PROGRAMS     = erofsfuse
 erofsfuse_SOURCES = dir.c main.c
 erofsfuse_CFLAGS = -Wall -Werror -I$(top_srcdir)/include
-- 
2.20.1

