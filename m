Return-Path: <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 60872C64EC7
	for <linux-erofs@archiver.kernel.org>; Sat, 25 Feb 2023 12:53:36 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [IPv6:::1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4PP6Bl0BXrz3c7v
	for <linux-erofs@archiver.kernel.org>; Sat, 25 Feb 2023 23:53:35 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=163.com header.i=@163.com header.a=rsa-sha256 header.s=s110527 header.b=eZ6l3lUK;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=163.com (client-ip=220.181.12.214; helo=m12.mail.163.com; envelope-from=zbestahu@163.com; receiver=<UNKNOWN>)
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=163.com header.i=@163.com header.a=rsa-sha256 header.s=s110527 header.b=eZ6l3lUK;
	dkim-atps=neutral
Received: from m12.mail.163.com (m12.mail.163.com [220.181.12.214])
	by lists.ozlabs.org (Postfix) with ESMTP id 4PP6BZ2FzHz30CT
	for <linux-erofs@lists.ozlabs.org>; Sat, 25 Feb 2023 23:53:25 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=HsWMs
	Fo434zGXD48Vm85d+YE7+B+qx0IGG3SEn8Y5IQ=; b=eZ6l3lUKeFVbhpOS/EUgY
	edPnaWrIb3bz+4373beej5Wn8Czc05UA/C/d6FtRw7lhZKaOD/zFcuYCKCRbZNow
	OtMEJpfS3qY9oz+hvznlMrnT6QCX9rOlcRgVRQL/S2lWHa3M7UHa3V1UPOlEsmQQ
	shRYN9t5DVLmaceYvt6OWs=
Received: from localhost.localdomain (unknown [112.22.168.212])
	by zwqz-smtp-mta-g2-2 (Coremail) with SMTP id _____wA3EsAdAfpjxqKVBA--.5769S2;
	Sat, 25 Feb 2023 20:37:52 +0800 (CST)
From: Yue Hu <zbestahu@163.com>
To: linux-erofs@lists.ozlabs.org
Subject: [PATCH] erofs-utils: manpage: add fragments extended option
Date: Sat, 25 Feb 2023 20:37:47 +0800
Message-Id: <20230225123747.25723-1-zbestahu@163.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: _____wA3EsAdAfpjxqKVBA--.5769S2
X-Coremail-Antispam: 1Uf129KBjvdXoWrKrWDJFWDXw1fJr1rtFyUAwb_yoW3KrbEv3
	yktF4I9a45Ar97Cr4SqF15GFyjgryYk3saqF1rta1DZry8Cws8J390gr47JrWSq39xuwsx
	Jr4ayr9Ik3y7KjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IU8BT5PUUUUU==
X-Originating-IP: [112.22.168.212]
X-CM-SenderInfo: p2eh23xdkxqiywtou0bp/1tbiTwQgEVsGde-vQwABsQ
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
Cc: huyue2@coolpad.com, zhangwen@coolpad.com
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs" <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>

From: Yue Hu <huyue2@coolpad.com>

Complete the manpage for fragments feature.

Signed-off-by: Yue Hu <huyue2@coolpad.com>
---
 man/mkfs.erofs.1 | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/man/mkfs.erofs.1 b/man/mkfs.erofs.1
index b65d01b..37f2609 100644
--- a/man/mkfs.erofs.1
+++ b/man/mkfs.erofs.1
@@ -64,6 +64,11 @@ Don't inline regular files to enable FSDAX for these files (Linux v5.15+).
 .BI ztailpacking
 Pack the tail part (pcluster) of compressed files into its metadata to save
 more space and the tail part I/O. (Linux v5.17+)
+.TP
+.BI fragments=
+Pack the tail part (pcluster) of compressed files or the whole files into a
+special inode for smaller image sizes, may take an argument as the pcluster
+size of the packed inode in bytes. (Linux v6.1+)
 .RE
 .TP
 .BI "\-L " volume-label
-- 
2.25.1

