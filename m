Return-Path: <SRS0=5rU9=NF=lists.ozlabs.org=linux-erofs-bounces+linux-erofs=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82A56C4338F
	for <linux-erofs@archiver.kernel.org>; Sat, 14 Aug 2021 19:03:34 +0000 (UTC)
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id F199860EB5
	for <linux-erofs@archiver.kernel.org>; Sat, 14 Aug 2021 19:03:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org F199860EB5
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.ozlabs.org
Received: from boromir.ozlabs.org (localhost [IPv6:::1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4Gn8w44NmRz3bhl
	for <linux-erofs@archiver.kernel.org>; Sun, 15 Aug 2021 05:03:32 +1000 (AEST)
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20201202 header.b=FQ8c/A5y;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized)
 smtp.mailfrom=kernel.org (client-ip=198.145.29.99; helo=mail.kernel.org;
 envelope-from=xiang@kernel.org; receiver=<UNKNOWN>)
Authentication-Results: lists.ozlabs.org; dkim=pass (2048-bit key;
 unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256
 header.s=k20201202 header.b=FQ8c/A5y; 
 dkim-atps=neutral
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by lists.ozlabs.org (Postfix) with ESMTPS id 4Gn8vw1mHlz30Hx
 for <linux-erofs@lists.ozlabs.org>; Sun, 15 Aug 2021 05:03:24 +1000 (AEST)
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0B19E60EB5;
 Sat, 14 Aug 2021 19:03:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1628967800;
 bh=afv0iBrrBunt4OwvlwhTSjXRLnPRVjyQfS3213nrQm8=;
 h=From:To:Cc:Subject:Date:From;
 b=FQ8c/A5yWp0dKY1QPCj+aagihTZoNSOGJovL1xcQyf/gWGvxP5swB4h9gPggGCOXa
 9UWF1TcupGevsr8lPi/vDliYIqJBd+nLr9JfqDgCiKLFEXz3HJHdRws82Z3/siLYYd
 Vl8T+gXl2AlD0YHGYf6jT9dgxcoSTOYM+rxC7W3wQJJUEuyE5I1Hdu0mTO1ufi9h8l
 SyTLrhR7FpPD+pg7EPu0n3UcDSufFYDinVA7qN3SftYLHqKbTeNH//dDrOaUMhH7M0
 F7/G90PJNAFneYuPO0P5RwweIRFPKopyhwUlxJBTpNh+07F14R5v83v3jB9SKxLtWd
 UoZNSHNpWjYEA==
From: Gao Xiang <xiang@kernel.org>
To: linux-erofs@lists.ozlabs.org
Subject: [PATCH] erofs-utils: generate version number from git commit
Date: Sun, 15 Aug 2021 03:03:01 +0800
Message-Id: <20210814190301.21150-1-xiang@kernel.org>
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
Cc: Gao Xiang <xiang@kernel.org>
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs"
 <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>

In order to make the version string more precise.

Signed-off-by: Gao Xiang <xiang@kernel.org>
---
 configure.ac               |  2 +-
 scripts/get-version-number | 33 +++++++++++++++++++++++++++++++++
 2 files changed, 34 insertions(+), 1 deletion(-)
 create mode 100755 scripts/get-version-number

diff --git a/configure.ac b/configure.ac
index 7217cf531265..38c371c4910f 100644
--- a/configure.ac
+++ b/configure.ac
@@ -3,7 +3,7 @@
 
 AC_PREREQ([2.69])
 
-m4_define([erofs_utils_version], m4_esyscmd([sed -n '1p' VERSION | tr -d '\n']))
+m4_define([erofs_utils_version], m4_esyscmd_s([scripts/get-version-number]))
 m4_define([erofs_utils_date], m4_esyscmd([sed -n '2p' VERSION | tr -d '\n']))
 
 AC_INIT([erofs-utils], [erofs_utils_version], [linux-erofs@lists.ozlabs.org])
diff --git a/scripts/get-version-number b/scripts/get-version-number
new file mode 100755
index 000000000000..26f0b5acb753
--- /dev/null
+++ b/scripts/get-version-number
@@ -0,0 +1,33 @@
+#!/bin/sh
+# SPDX-License-Identifier: GPL-2.0
+
+scm_version()
+{
+	# Check for git and a git repo.
+	if test -z "$(git rev-parse --show-cdup 2>/dev/null)" &&
+	   head="$(git rev-parse --verify HEAD 2>/dev/null)"; then
+		# If we are at a tagged commit, we ignore it.
+		if [ -z "$(git describe --exact-match 2>/dev/null)" ]; then
+			# Add -g and 8 hex chars.
+			printf '%s%s' -g "$(echo $head | cut -c1-8)"
+		fi
+		# Check for uncommitted changes.
+		# This script must avoid any write attempt to the source tree,
+		# which might be read-only.
+		# You cannot use 'git describe --dirty' because it tries to
+		# create .git/index.lock .
+		# First, with git-status, but --no-optional-locks is only
+		# supported in git >= 2.14, so fall back to git-diff-index if
+		# it fails. Note that git-diff-index does not refresh the
+		# index, so it may give misleading results. See
+		# git-update-index(1), git-diff-index(1), and git-status(1).
+		if {
+			git --no-optional-locks status -uno --porcelain 2>/dev/null ||
+			git diff-index --name-only HEAD
+		} | read dummy; then
+			printf '%s' -dirty
+		fi
+	fi
+}
+
+echo $(sed -n '1p' VERSION | tr -d '\n')$(scm_version)
-- 
2.20.1

