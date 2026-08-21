Return-Path: <linux-erofs+bounces-4280-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9BDECC5DF81
	for <linux-erofs@archiver.kernel.org>; Fri, 21 Aug 2026 01:57:34 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hR3ND3Ztjz2xcG;
	Fri, 21 Aug 2026 11:57:32 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2607:f8b0:4864:20::102c"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1787277452;
	cv=none; b=N6L24UqZ6eFBVprC2GdLdojWs13GWuzRQrdS9oWOMv8N9nwJDzWSWmIN2Adjh8CD9LeQ99+ZwFr5xQTogxKJ8Z3R7B7Q/FEDFUAzqYlNdkHgYU4+yT50hty3QekJWkWVKxCKFLBnzphQV2ZHFAbaaBqIPMflIHpmWSq67fB6gCUptksKjyCUHJxEkeATlH3ITUmH2XaRXIzUET07jwcLzkDlcXShg02lAdrTWn2BhG85BaZtgn4ZPXUFiMOtAeU7JzYcqhegMV/Fz/0QBUcBUwu8F9GZGw4MYceRZObcofMRbVEi6raJoxwAqixgvCFQB5zW7M78vHeXje5hwBqglw==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1787277452; c=relaxed/relaxed;
	bh=BFxLz2bdTVmcdDojw+cIbn4eTcy7TdcCZqmmyX2Ubao=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=aKt9scIKO68a0XV5Hl5gZqELg2/VF7mDkShpb1vOUKbzjLx7FMoT6lSFSudxkrbbOzJR4bLgyn48wV5+Z6bG1POXU9HB1CVDFz0L1JIQDMHN+21TQlF/puWtu3qxATfZZ1qEp52CLtgkpf0w6vJ0APPvCk4K26OmjS5O0tSkQCX/WuwSp400tCpYKkEJdFc6+Yi0VUP9x4tsDI+wRpmQr1lidm/4YOnm5XmEbfaVVdWyK1r6rRIhQpVpeoqS9b/k/fkI573nrZw145c8FtT74yg2SuFAIv8LBVISqwoLZ8dgtPLgV4iBHVrhJr64Ym3KPUVlclk60pgC5X0AsP3XHA==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=gmail.com; dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=dhnzu4e+; dkim-atps=neutral; spf=pass (client-ip=2607:f8b0:4864:20::102c; helo=mail-pj1-x102c.google.com; envelope-from=zhanxusheng1024@gmail.com; receiver=lists.ozlabs.org) smtp.mailfrom=gmail.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=dhnzu4e+;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=gmail.com (client-ip=2607:f8b0:4864:20::102c; helo=mail-pj1-x102c.google.com; envelope-from=zhanxusheng1024@gmail.com; receiver=lists.ozlabs.org)
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hR3NB4cbcz2xRs
	for <linux-erofs@lists.ozlabs.org>; Fri, 21 Aug 2026 11:57:30 +1000 (AEST)
Received: by mail-pj1-x102c.google.com with SMTP id 98e67ed59e1d1-39266382df6so369363a91.3
        for <linux-erofs@lists.ozlabs.org>; Thu, 20 Aug 2026 18:57:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787277448; x=1787882248; darn=lists.ozlabs.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=BFxLz2bdTVmcdDojw+cIbn4eTcy7TdcCZqmmyX2Ubao=;
        b=dhnzu4e+eD9/6LWRWCVsWp5oyOfzS6wpQdj+n1ZAsVUqV1MU5KzU70EvzdYwgbd9XN
         BBo8oRpfrjriwjcuiE3YmheT0kD8K45HZSnFpVkti0qrmiSfAwDKXealQklOqorA/R1W
         FUj1vWaNIhddZ7+iE5MwPC+aAiLUsoOJ92fPFhXjF3RaxqkC39WztSaa7/upPh4sDg6f
         V4M3EWeQL9fYWb1TlNiHc5xAF5YIBfHkP1Mr/VMlKmv66lfht9hFSSaDYLq6PXqi/Cb7
         vxFRoCE86tdEsDkAMBIbfXIjdF1Z1oOIg4qvV/B6t7VbzAA0K/hUl8k63zjyNCkL4KTm
         Hp3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787277448; x=1787882248;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=BFxLz2bdTVmcdDojw+cIbn4eTcy7TdcCZqmmyX2Ubao=;
        b=fEa+KWq4WEM8rmAD/Hb6GzPCbIZO/i+PXZuiiEBdOKmEYqojyXnsyUWJI48DI3GCed
         3HBw742fTP/xpXJ24mwixczNvvEGvL3XlAYHdzWEPWZDm5sXiWk13QF2o05GiC4T2PHy
         KiGZs2JbyxnSQTsiFnvX4DH3uB+MuSlZ2fref9ewWKFY2WK/o3ap0F5HmJPnx431KBbu
         DGHyasfMwxQuC4+x9NSmI+Q000Zcgju93xmyxIlHjLwMkVrJv2/dVHeujlLGc+qwEXu2
         CxPO6KW7Hv2Mj8qc6DSsn/4swruj3QGiUiAw9sqChGc0sNGRLXlVKJ7vbrqjXKlqLQsR
         s6hw==
X-Forwarded-Encrypted: i=1; AHgh+Rrdu/9Ls1EF/y4f0POXK1vI1IwyCzn4rpBODYX+/jzOcqjmS589XvBDT+Mx55xTzMjNgQdkQKevyKDTdQ==@lists.ozlabs.org
X-Gm-Message-State: AFuF++l7JLSoBquBXW4IX/SqKa404E9WQ9yOXDlPwcTC++iT4XgUO3t+
	FdE8lL6qvpUcONQ5etIhSd5B08eNmw88Yi8IbEQ/fgiO222FYK75Y6Y9uLIWApO6
X-Gm-Gg: AR+sD10UPLnsAMARoYvAejOUiQsRYWA2/eZKnzVtxgjTg6x5w3P0Y5agaqbsxuEbEwr
	sjapC+ysthCHYvqy2hW9cU19iaHBzQphMGd3CtMBiQcAKLh4mJiLWeUZgJJOMY4PW9w1IXIMSlt
	8sIn2E4Cud+ouXu3/aHeJoLyOnA1bVRLw77kfw3BdwEneCRk23lf76SR3gobOUkA2/XOYolM0+n
	pq+VimSiu77OpiEOPeokE3qPcL2BZG9jOkhh6f0MOtZCi9Qe/GDMs3AEwL6/KLn4joCXc15SbpK
	gqxgGCO0qFPLl6MTJW7c/wn5zBvEzgXhzyzjzI1dywpFDF7HuOAQkBCKC+E7GSh4+/SjvzHPhGf
	YPPDNp17LmrPrEmZBt7jE4fyizLzodP7yO9IyNovUadW/G3hwX7A9274qLohkahHW4GzcGdiQhc
	8PBY2gut5ykPRSk0P+IfZRWThiBAhhZYANCsizSGrwceKW/zlURD4NsO5t5gbd9htecMe8GuvQd
	2LNSOkRMWk=
X-Received: by 2002:a17:90b:5646:b0:38d:f5bb:e0f4 with SMTP id 98e67ed59e1d1-395c33367ebmr5369665a91.1.1787277448432;
        Thu, 20 Aug 2026 18:57:28 -0700 (PDT)
Received: from osman.mioffice.cn ([43.224.245.178])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-395c4c12c2fsm1034927a91.13.2026.08.20.18.57.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Aug 2026 18:57:28 -0700 (PDT)
From: Zhan Xusheng <zhanxusheng1024@gmail.com>
X-Google-Original-From: Zhan Xusheng <zhanxusheng@xiaomi.com>
To: Gao Xiang <xiang@kernel.org>
Cc: Jingbo Xu <jefflexu@linux.alibaba.com>,
	zhanxusheng@xiaomi.com,
	linux-erofs@lists.ozlabs.org,
	Zhan Xusheng <zhanxusheng1024@gmail.com>
Subject: [PATCH] erofs-utils: tests: add a splice() test for inode_share mode
Date: Fri, 21 Aug 2026 09:57:22 +0800
Message-ID: <20260821015722.1936404-1-zhanxusheng@xiaomi.com>
X-Mailer: git-send-email 2.43.0
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

From: Zhan Xusheng <zhanxusheng1024@gmail.com>

From: Zhan Xusheng <zhanxusheng@xiaomi.com>

splice() and sendfile() went through filemap_splice_read() on the user
file, so they populated the per-inode page cache instead of the shared one
that read() and mmap() use.  The content was correct either way, which is
why nothing caught it: only which mapping the pages land in changes.

Observe that instead.  cachestat() works on the file's own mapping, while
fincore's mmap()+mincore() fallback goes through erofs_ishare_mmap(), which
redirects the vma to the backing file and so reports the shared mapping.
After a splice-only read the first must be empty and the second must not,
which is the same pair of observations erofs/028 already relies on.

Measured on 7.2 with two identical 8 MiB files under inode_share, before
and after the kernel change, as pages of the 8 MiB file:

  before   own 2048   shared 0
  after    own 0      shared 2048

spliceread is a small helper because no common tool reads a file purely
with splice(2); dd and cat both use read(2).

Signed-off-by: Zhan Xusheng <zhanxusheng@xiaomi.com>
---
 tests/Makefile.am      |  3 ++
 tests/common/rc        |  6 ++++
 tests/erofs/032        | 82 ++++++++++++++++++++++++++++++++++++++++++
 tests/erofs/032.out    |  2 ++
 tests/src/Makefile.am  |  5 ++-
 tests/src/spliceread.c | 61 +++++++++++++++++++++++++++++++
 6 files changed, 158 insertions(+), 1 deletion(-)
 create mode 100755 tests/erofs/032
 create mode 100644 tests/erofs/032.out
 create mode 100644 tests/src/spliceread.c

diff --git a/tests/Makefile.am b/tests/Makefile.am
index c0291ac..d7674fe 100644
--- a/tests/Makefile.am
+++ b/tests/Makefile.am
@@ -132,6 +132,9 @@ TESTS += erofs/030
 # 031 - test chunk-based mapping with shared chunks across inodes
 TESTS += erofs/031
 
+# 032 - test that splice() uses the shared page cache in inode_share mode
+TESTS += erofs/032
+
 # NEW TEST CASE HERE
 # TESTS += erofs/999
 
diff --git a/tests/common/rc b/tests/common/rc
index aa7ef99..32484ee 100644
--- a/tests/common/rc
+++ b/tests/common/rc
@@ -357,6 +357,12 @@ _require_fssum()
 	[ -x $FSSUM_PROG ] || _notrun "fssum not built"
 }
 
+_require_spliceread()
+{
+	SPLICEREAD_PROG=${PWD}/src/spliceread
+	[ -x $SPLICEREAD_PROG ] || _notrun "spliceread not built"
+}
+
 # generate random string with maximum $1 length
 _random()
 {
diff --git a/tests/erofs/032 b/tests/erofs/032
new file mode 100755
index 0000000..aef2164
--- /dev/null
+++ b/tests/erofs/032
@@ -0,0 +1,82 @@
+#!/bin/sh
+# SPDX-License-Identifier: GPL-2.0+
+#
+# Test that splice() reads through the shared page cache in inode_share mode
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
+	rm -f $tmp.*
+}
+
+# Resident bytes as reported through cachestat(), which works on the file's
+# own mapping.  In inode_share mode that is the per-inode one.
+own_cached()
+{
+	fincore -oRES -bnr "$1"
+}
+
+# The same, with cachestat() made to fail so that fincore falls back to
+# mmap()+mincore().  mmap is redirected to the backing file, so this reports
+# the shared mapping instead.
+shared_cached()
+{
+	strace -efault=cachestat -o/dev/null fincore -oRES -bnr "$1"
+}
+
+_require_erofs
+_require_erofs_inode_sharing
+_require_spliceread
+command -v strace > /dev/null 2>&1 || _notrun "strace is not found"
+command -v fincore > /dev/null 2>&1 || _notrun "fincore is not found"
+command -v fadvise > /dev/null 2>&1 || _notrun "fadvise is not found"
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
+# two files with identical content, so that they end up sharing one inode
+dd if=/dev/urandom of=$localdir/a bs=1M count=8 2>/dev/null
+cp $localdir/a $localdir/b
+
+_scratch_mkfs --xattr-inode-digest=system.erofs.fingerprint $localdir \
+	>> $seqres.full 2>&1 || _fail "failed to mkfs"
+_scratch_mount -oinode_share,domain_id=share_$seq 2>> $seqres.full
+
+f=$SCRATCH_MNT/b
+
+# fadvise is redirected to the backing file, so this empties the shared
+# mapping.  The per-inode mapping is empty anyway on a fresh mount.
+fadvise -a dontneed $f
+
+$SPLICEREAD_PROG $f >> $seqres.full 2>&1 || _fail "splice failed"
+
+echo "own $(own_cached $f) shared $(shared_cached $f)" >> $seqres.full
+
+[ "$(own_cached $f)" -eq 0 ] || \
+	_fail "splice populated the per-inode page cache"
+[ "$(shared_cached $f)" -gt 0 ] || \
+	_fail "splice did not populate the shared page cache"
+
+_scratch_unmount
+
+echo Silence is golden
+status=0
+exit 0
diff --git a/tests/erofs/032.out b/tests/erofs/032.out
new file mode 100644
index 0000000..34e059f
--- /dev/null
+++ b/tests/erofs/032.out
@@ -0,0 +1,2 @@
+QA output created by 032
+Silence is golden
diff --git a/tests/src/Makefile.am b/tests/src/Makefile.am
index 16de41a..f51be82 100644
--- a/tests/src/Makefile.am
+++ b/tests/src/Makefile.am
@@ -3,12 +3,15 @@
 
 AUTOMAKE_OPTIONS	= foreign
 check_PROGRAMS		=
-noinst_PROGRAMS		= fssum
+noinst_PROGRAMS		= fssum spliceread
 
 fssum_CFLAGS = -Wall -I$(top_srcdir)/include
 fssum_LDADD = $(top_builddir)/lib/liberofs.la
 fssum_SOURCES = fssum.c
 
+spliceread_CFLAGS = -Wall
+spliceread_SOURCES = spliceread.c
+
 if ENABLE_LZ4
 check_PROGRAMS += badlz4
 badlz4_SOURCES = badlz4.c
diff --git a/tests/src/spliceread.c b/tests/src/spliceread.c
new file mode 100644
index 0000000..cb9f09d
--- /dev/null
+++ b/tests/src/spliceread.c
@@ -0,0 +1,61 @@
+// SPDX-License-Identifier: GPL-2.0+
+/*
+ * spliceread.c
+ *
+ * Read a file into a pipe with splice(2) and discard it, so that a test can
+ * exercise ->splice_read without any read(2) touching the file.
+ */
+#define _GNU_SOURCE
+#include <fcntl.h>
+#include <stdio.h>
+#include <unistd.h>
+
+#define CHUNK	65536
+
+int main(int argc, char *argv[])
+{
+	static char buf[CHUNK];
+	int fd, p[2];
+
+	if (argc != 2) {
+		fprintf(stderr, "usage: %s FILE\n", argv[0]);
+		return 2;
+	}
+
+	fd = open(argv[1], O_RDONLY);
+	if (fd < 0) {
+		perror("open");
+		return 1;
+	}
+	if (pipe(p)) {
+		perror("pipe");
+		return 1;
+	}
+
+	for (;;) {
+		ssize_t n = splice(fd, NULL, p[1], NULL, CHUNK, 0);
+
+		if (n < 0) {
+			perror("splice");
+			return 1;
+		}
+		if (!n)
+			break;
+
+		/* drain the pipe so the next splice() has room */
+		while (n > 0) {
+			ssize_t m = read(p[0], buf, n > CHUNK ? CHUNK : n);
+
+			if (m <= 0) {
+				perror("read");
+				return 1;
+			}
+			n -= m;
+		}
+	}
+
+	close(p[0]);
+	close(p[1]);
+	close(fd);
+	return 0;
+}
-- 
2.43.0


