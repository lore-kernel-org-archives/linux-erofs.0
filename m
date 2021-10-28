Return-Path: <SRS0=IMi0=PQ=lists.ozlabs.org=linux-erofs-bounces+linux-erofs=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0DBEC433EF
	for <linux-erofs@archiver.kernel.org>; Thu, 28 Oct 2021 10:49:57 +0000 (UTC)
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id CD22D610D2
	for <linux-erofs@archiver.kernel.org>; Thu, 28 Oct 2021 10:49:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org CD22D610D2
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.ozlabs.org
Received: from boromir.ozlabs.org (localhost [IPv6:::1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4Hg2Pv40M5z2ynX
	for <linux-erofs@archiver.kernel.org>; Thu, 28 Oct 2021 21:49:55 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized)
 smtp.mailfrom=huawei.com (client-ip=45.249.212.189; helo=szxga03-in.huawei.com;
 envelope-from=guoxuenan@huawei.com; receiver=<UNKNOWN>)
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by lists.ozlabs.org (Postfix) with ESMTPS id 4Hg2Pp5Tdtz2y8R
 for <linux-erofs@lists.ozlabs.org>; Thu, 28 Oct 2021 21:49:48 +1100 (AEDT)
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.57])
 by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4Hg2N10vszz8ty8;
 Thu, 28 Oct 2021 18:48:17 +0800 (CST)
Received: from kwepemm600004.china.huawei.com (7.193.23.242) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.15; Thu, 28 Oct 2021 18:49:33 +0800
Received: from huawei.com (10.175.101.6) by kwepemm600004.china.huawei.com
 (7.193.23.242) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.15; Thu, 28 Oct
 2021 18:49:32 +0800
From: Guo Xuenan <guoxuenan@huawei.com>
To: <xiang@kernel.org>, <linux-erofs@lists.ozlabs.org>
Subject: [PATCH v2 5/5] erofs-utils: manpage: add dump.erofs manpage.
Date: Thu, 28 Oct 2021 18:57:48 +0800
Message-ID: <20211028105748.3586231-5-guoxuenan@huawei.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211028105748.3586231-1-guoxuenan@huawei.com>
References: <20211028105748.3586231-1-guoxuenan@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.175.101.6]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 kwepemm600004.china.huawei.com (7.193.23.242)
X-CFilter-Loop: Reflected
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
Cc: daeho43@gmail.com, mpiglet@outlook.com
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs"
 <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>

This patch adds dump.erofs manpage.

Signed-off-by: Guo Xuenan <guoxuenan@huawei.com>
---
 man/Makefile.am  |  2 +-
 man/dump.erofs.1 | 60 ++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 61 insertions(+), 1 deletion(-)
 create mode 100644 man/dump.erofs.1

diff --git a/man/Makefile.am b/man/Makefile.am
index d62d6e2..769b557 100644
--- a/man/Makefile.am
+++ b/man/Makefile.am
@@ -1,6 +1,6 @@
 # SPDX-License-Identifier: GPL-2.0+
 
-dist_man_MANS = mkfs.erofs.1
+dist_man_MANS = mkfs.erofs.1 dump.erofs.1
 
 EXTRA_DIST = erofsfuse.1
 if ENABLE_FUSE
diff --git a/man/dump.erofs.1 b/man/dump.erofs.1
new file mode 100644
index 0000000..d44c7b6
--- /dev/null
+++ b/man/dump.erofs.1
@@ -0,0 +1,60 @@
+.\" Copyright (c) 2021 Guo Xuenan <guoxuenan@huawei.com>
+.\"
+.TH DUMP.EROFS 1
+.SH NAME
+dump.erofs \- retrieve directory and file entries, show specific file
+or overall disk statistics information from an EROFS-formated image.
+.SH SYNOPSIS
+.B dump.erofs
+[
+.B \--nid
+.I inode number
+]
+[
+.B \-e
+]
+[
+.B \-s
+]
+[
+.B \-S
+]
+[
+.B \-V
+]
+.I DEVICE
+.SH DESCRIPTION
+.B dump.erofs
+is used to retrieve erofs metadata (usually in a disk partition).
+\fIdevice\fP is the special file corresponding to the device (e.g.
+\fI/dev/sdXX\fP).
+
+Currently, it can demonstrate 1) a file information of given inode number, 2)
+overall disk statistics, 3) file extent information,
+4) erofs superblock information.
+.SH OPTIONS
+.TP
+.BI \--nid " inode number"
+Specify an inode number to print its file information.
+.TP
+.BI \-e
+show the file extent information, the option depends on option --nid to specify nid.
+.TP
+.BI \-V
+Print the version number and exit.
+.TP
+.BI \-s
+Show superblock information of the an EROFS-formated image.
+.TP
+.BI \-S
+Show statistics of the overall disk, including file type(by file extension)/size statistics and distribution, number of compressed and uncompressed files, whole compression ratio of image etc.
+.SH AUTHOR
+Initial code was written by Wang Qi <mpiglet@outlook.com>, Guo Xuenan <guoxuenan@huawei.com>.
+.PP
+This manual page was written by Guo Xuenan <guoxuenan@huawei.com>
+.SH AVAILABILITY
+.B dump.erofs
+is part of erofs-utils package and is available from git://git.kernel.org/pub/scm/linux/kernel/git/xiang/erofs-utils.git.
+.SH SEE ALSO
+.BR mkfs.erofs(1),
+.BR fsck.erofs(1)
-- 
2.31.1

