Return-Path: <linux-erofs+bounces-3367-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 95260FF8867
	for <linux-erofs@archiver.kernel.org>; Wed, 29 Apr 2026 08:43:30 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4g59nF0JGWz2ySW;
	Wed, 29 Apr 2026 18:43:29 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=pass smtp.remote-ip=103.117.158.51 arc.chain=zohomail.in
ARC-Seal: i=2; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1777452208;
	cv=pass; b=IM3yr4hjRfNEPArY+ZOV61irHAStduOtyIPuV+jQCeNwHicdd09h3zq8ICKwvHx8eDLdAMT0RXro8/eEmNdAdkRi8VTWTTALdqi5MnxFmDzHym6Ki0VJpxmtit57TFcUAJcp3iknEIKbDKmp4XSSKdyYRlyr+/Y1sy9yzQwGkz/APs+0DkWu9JPt8VScALCpmkdtF3MgbLIYBZM/PfoXl7D12cKeMh1//SSzrJIlCgVyDceuRSutrfTnQTGpzs5OPSG9qTLI7Vz8/mYF1LN+LinXZSUXbbT4/6SLJHRaMoceIsQOa0sCXWL2fvG2WvEoqHadonQCQkoTcNn72pOtnA==
ARC-Message-Signature: i=2; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1777452208; c=relaxed/relaxed;
	bh=S9cnjeOA+5FPoko9S7SlEwgDVh12VYYlZRkVqJFz88k=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XAMlHrKuka1zAJWx89ZCl2efNNQeZCWtcQqmjT5ZFtRLJ2r3s7nltHF3XBA7rjjNjzRZFdcroYbEjXjZzSMHczDXM7U4m7tAe7fBL2yfshU8B09oxNq1d5gnNCYSTiKz30KAA/GN9lN3HqDSBJGLVFbV1VUUVwvZ3cLPFL3FfAlfGAwxruHDyBOcheJthbJvJE7/zf3FdYPqZMMklwoqpmcwDcfwgwbNmcATo5z1AiVLLl7NEkgB1JwSfxCVqjSO025BvHj9TOvg3c5qiwyfaAe+q9sLYDscpyk/gmjtGEywc1NtQR7GD6DA7tSHVqOHZuiTX53rPqOFVkq3bMkKQQ==
ARC-Authentication-Results: i=2; lists.ozlabs.org; dmarc=none (p=none dis=none) header.from=vnsh.in; dkim=pass (1024-bit key; unprotected) header.d=vnsh.in header.i=ch@vnsh.in header.a=rsa-sha256 header.s=zoho header.b=XKkhi7gP; dkim-atps=neutral; spf=pass (client-ip=103.117.158.51; helo=sender-of-o51.zoho.in; envelope-from=ch@vnsh.in; receiver=lists.ozlabs.org) smtp.mailfrom=vnsh.in
Authentication-Results: lists.ozlabs.org; dmarc=none (p=none dis=none) header.from=vnsh.in
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=vnsh.in header.i=ch@vnsh.in header.a=rsa-sha256 header.s=zoho header.b=XKkhi7gP;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=vnsh.in (client-ip=103.117.158.51; helo=sender-of-o51.zoho.in; envelope-from=ch@vnsh.in; receiver=lists.ozlabs.org)
Received: from sender-of-o51.zoho.in (sender-of-o51.zoho.in [103.117.158.51])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4g59nB69Dfz2yD6
	for <linux-erofs@lists.ozlabs.org>; Wed, 29 Apr 2026 18:43:26 +1000 (AEST)
ARC-Seal: i=1; a=rsa-sha256; t=1777452202; cv=none; 
	d=zohomail.in; s=zohoarc; 
	b=O/kT3g/WgUHN1C+qaw2KpR9/dVaWGXtXXVttxziu0p3CQR69GP5vgVV+lP8jMF9xaeqe0fYCgkLqKwGoeScvBPcuQLP6lJy/dyW93WoLLjyCFUtNv/kh6puAlG7i5swsPyfwf1mNoy0tQMvfCltqFagN0QDrAbyVM51xuVvkn1Q=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.in; s=zohoarc; 
	t=1777452202; h=Content-Transfer-Encoding:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To:Cc; 
	bh=S9cnjeOA+5FPoko9S7SlEwgDVh12VYYlZRkVqJFz88k=; 
	b=d+j5EpTdywqZPD1jSJ+D4vn2n8x4X7Qje0ZPYCu6fSWq5jlMKPJclba5siGWjVGzuhUA979mqI2Qoc/6eNYB/BfLvMeAZNswQeLMnJ6+hu801y5xGn5QQQokvkemEYJ8dkKWilinCW24AvkkQpQ64iaU9FUkQzpRGs6YMNiu2JE=
ARC-Authentication-Results: i=1; mx.zohomail.in;
	dkim=pass  header.i=vnsh.in;
	spf=pass  smtp.mailfrom=ch@vnsh.in;
	dmarc=pass header.from=<ch@vnsh.in>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1777452202;
	s=zoho; d=vnsh.in; i=ch@vnsh.in;
	h=From:From:To:To:Subject:Subject:Date:Date:Message-ID:In-Reply-To:References:MIME-Version:Content-Transfer-Encoding:Message-Id:Reply-To:Cc;
	bh=S9cnjeOA+5FPoko9S7SlEwgDVh12VYYlZRkVqJFz88k=;
	b=XKkhi7gPRCsCq/qSAFT3YKahVLbhh8dOo3SLW7T8UbfaaXChNAPG+54N9MuIFNE1
	yM4vPn4uLMDItTY0dGMFrgqU8rKTgoS/H+Xffl2YQBMXjBIdPRmr6bRnSXQwv8yGoLY
	WAz5DUb02O88zXSAXwuu5cJNwAPsD6e9k49i5/Ak=
Received: by mx.zoho.in with SMTPS id 1777452199963113.4652072774378;
	Wed, 29 Apr 2026 14:13:19 +0530 (IST)
From: Vansh Choudhary <ch@vnsh.in>
To: linux-erofs@lists.ozlabs.org
Subject: [PATCH] erofs-utils: tests: add test for malformed PAX mtime parsing
Date: Wed, 29 Apr 2026 14:13:19 +0530
Message-ID: <20260429084319.41980-1-ch@vnsh.in>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <f2afe93e-245c-4856-b277-634271f596a0@linux.alibaba.com>
References: <f2afe93e-245c-4856-b277-634271f596a0@linux.alibaba.com>
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
X-ZohoMailClient: External

This is a regression test for "erofs-utils: lib: tar: fix
fractional PAX mtime parsing".

Signed-off-by: Vansh Choudhary <ch@vnsh.in>
---
 tests/Makefile.am   |  3 +++
 tests/erofs/031     | 60 +++++++++++++++++++++++++++++++++++++++++++++
 tests/erofs/031.out |  2 ++
 3 files changed, 65 insertions(+)
 create mode 100755 tests/erofs/031
 create mode 100644 tests/erofs/031.out

diff --git a/tests/Makefile.am b/tests/Makefile.am
index cd1971a..36fbe92 100644
--- a/tests/Makefile.am
+++ b/tests/Makefile.am
@@ -129,6 +129,9 @@ TESTS += erofs/029
 # 030 - regression test for NULL dentry on hardlink-to-root tar entry
 TESTS += erofs/030
 
+# 031 - regression test for malformed PAX mtime acceptance
+TESTS += erofs/031
+
 # NEW TEST CASE HERE
 # TESTS += erofs/999
 
diff --git a/tests/erofs/031 b/tests/erofs/031
new file mode 100755
index 0000000..8644291
--- /dev/null
+++ b/tests/erofs/031
@@ -0,0 +1,60 @@
+#!/bin/sh
+# SPDX-License-Identifier: MIT
+#
+# Regression test for malformed PAX mtime acceptance in mkfs.erofs --tar
+#
+seq=`basename $0`
+seqres=$RESULT_DIR/$(echo $0 | awk '{print $((NF-1))"/"$NF}' FS="/")
+
+# get standard environment, filters and checks
+. "${srcdir}/common/rc"
+
+cleanup()
+{
+	cd /
+	rm -rf $tmp.*
+}
+
+# remove previous $seqres.full before test
+rm -f $seqres.full
+
+# real QA test starts here
+echo "QA output created by $seq"
+
+if [ -z $SCRATCH_DEV ]; then
+	SCRATCH_DEV=$tmp/erofs_$seq.img
+	rm -f $SCRATCH_DEV
+fi
+
+localdir="$tmp/$seq"
+rm -rf $localdir
+mkdir -p $localdir
+
+footar="$localdir/foo.tar"
+
+# build a PAX archive whose extended header carries a single record:
+# "22 mtime=10.123456789\n" at payload offset 512.
+: > $localdir/a
+(cd $localdir && tar --format=pax \
+	--pax-option='delete=atime,delete=ctime,mtime:=10.123456789' \
+	-cf $footar a) || _fail "failed to build input tar"
+
+# verify the PAX payload before patching, so the test fails clearly if
+# tar's output ever diverges from the expected layout.
+hdr=`dd if=$footar bs=1 skip=512 count=22 2>/dev/null`
+[ "$hdr" = "22 mtime=10.123456789" ] || \
+	_fail "unexpected PAX payload: $hdr"
+
+# overwrite the trailing '9' (offset 532) with 'x' so the record reads
+# "22 mtime=10.12345678x". sscanf("%d") would silently accept 12345678
+# and ignore the trailing 'x'; the fixed parser rejects it as -EIO.
+printf 'x' | dd of=$footar bs=1 seek=532 count=1 conv=notrunc 2>/dev/null
+
+$MKFS_EROFS_PROG --tar $SCRATCH_DEV $footar >> $seqres.full 2>&1
+rc=$?
+[ $rc -ge 128 ] && _fail "mkfs.erofs crashed on malformed PAX mtime (rc=$rc)"
+[ $rc -eq 0 ] && _fail "mkfs.erofs unexpectedly accepted malformed PAX mtime"
+
+echo Silence is golden
+status=0
+exit 0
diff --git a/tests/erofs/031.out b/tests/erofs/031.out
new file mode 100644
index 0000000..b3d0bb0
--- /dev/null
+++ b/tests/erofs/031.out
@@ -0,0 +1,2 @@
+QA output created by 031
+Silence is golden
-- 
2.43.0


