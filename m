Return-Path: <SRS0=vkr2=JZ=lists.ozlabs.org=linux-erofs-bounces+linux-erofs=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-24.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F5B3C433B4
	for <linux-erofs@archiver.kernel.org>; Wed, 28 Apr 2021 04:04:05 +0000 (UTC)
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 1411B613E5
	for <linux-erofs@archiver.kernel.org>; Wed, 28 Apr 2021 04:04:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1411B613E5
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Received: from boromir.ozlabs.org (localhost [IPv6:::1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4FVQ435rp3z2yys
	for <linux-erofs@archiver.kernel.org>; Wed, 28 Apr 2021 14:04:03 +1000 (AEST)
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20201202 header.b=QBB777RV;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized)
 smtp.mailfrom=kernel.org (client-ip=198.145.29.99; helo=mail.kernel.org;
 envelope-from=xiang@kernel.org; receiver=<UNKNOWN>)
Authentication-Results: lists.ozlabs.org; dkim=pass (2048-bit key;
 unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256
 header.s=k20201202 header.b=QBB777RV; 
 dkim-atps=neutral
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by lists.ozlabs.org (Postfix) with ESMTPS id 4FVQ4001myz302B
 for <linux-erofs@lists.ozlabs.org>; Wed, 28 Apr 2021 14:03:59 +1000 (AEST)
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0C72C6140B;
 Wed, 28 Apr 2021 04:03:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1619582637;
 bh=H8mgb1DnwAxCW49sTNCp4fxCn6yzcQzu1iqc2tKfnOc=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=QBB777RVctHQYj8vsvqpsGB7hbitSS0rn0Lh4JW07IRRzu1MfdaA36tm2qVcaGs1x
 KkbiRBf/W4MdJZO/fpNEzybhjtxwcbHEwU1a8GfSZodkNg8F+lPTYsHqjRBcro8SXj
 PjYRlL51BoSFPEZsucEj4Dy8ufNfY946d7p+pi842sfqoqfwKDEtT+rqCLyWZayhRx
 MImbnTy4IeAB5NQFSArePq75ZSzzmJIJTN4HTmdqKHIyvB4T/ED6qiJmtmpc7M61zV
 o2wYH/T4epL7wmCC/CFcj2sP7n2T08056XOGxEihWqHTxDly1QZfNw6ToYOxsjjD+I
 R+1JHfFOn120g==
From: Gao Xiang <xiang@kernel.org>
To: linux-erofs@lists.ozlabs.org,
	Li Guifu <bluce.liguifu@huawei.com>
Subject: [PATCH v3 5/5] erofs-uils: manpage: add manual for erofsfuse
Date: Wed, 28 Apr 2021 12:03:45 +0800
Message-Id: <20210428040345.4047-5-xiang@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210428040345.4047-1-xiang@kernel.org>
References: <20210428040345.4047-1-xiang@kernel.org>
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
Cc: Gao Xiang <xiang@kernel.org>
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs"
 <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>

This patch adds missing erofsfuse manpage.

Signed-off-by: Gao Xiang <xiang@kernel.org>
---
 man/erofsfuse.1 | 44 ++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 44 insertions(+)
 create mode 100644 man/erofsfuse.1

diff --git a/man/erofsfuse.1 b/man/erofsfuse.1
new file mode 100644
index 000000000000..6bd48b0460bd
--- /dev/null
+++ b/man/erofsfuse.1
@@ -0,0 +1,44 @@
+.\" Copyright (c) 2021 Gao Xiang <xiang@kernel.org>
+.\"
+.TH EROFSFUSE 1
+.SH NAME
+erofsfuse \- FUSE file system client for erofs file system
+.SH SYNOPSIS
+\fBerofsfuse\fR [\fIOPTIONS\fR] \fIDEVICE\fR \fIMOUNTPOINT\fR
+.SH DESCRIPTION
+.B erofsfuse
+is a FUSE file system client that supports reading from devices or image files
+containing erofs file system.
+.SH OPTIONS
+.SS "general options:"
+.TP
+\fB\-o\fR opt,[opt...]
+mount options
+.TP
+\fB\-h\fR   \fB\-\-help\fR
+display help and exit
+.SS "erofsfuse options:"
+.TP
+.BI "\-\-dbglevel=" #
+Specify the level of debugging messages. The default is 2, which shows basic
+warning messages.
+.SS "FUSE options:"
+.TP
+\fB-d -o\fR debug
+enable debug output (implies -f)
+.TP
+\fB-f\fR
+foreground operation
+.TP
+\fB-s\fR
+disable multi-threaded operation
+.P
+For other FUSE options please see
+.BR mount.fuse (8)
+or see the output of
+.I erofsfuse \-\-help
+.SH AVAILABILITY
+\fBerofsfuse\fR is part of erofs-utils package and is available from
+git://git.kernel.org/pub/scm/linux/kernel/git/xiang/erofs-utils.git.
+.SH SEE ALSO
+.BR mount.fuse (8)
-- 
2.20.1

