Return-Path: <linux-erofs+bounces-4284-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5D4E2C5DF7D
	for <linux-erofs@archiver.kernel.org>; Fri, 21 Aug 2026 08:54:06 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hRDcr0mHpz2xnW;
	Fri, 21 Aug 2026 18:54:04 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2607:f8b0:4864:20::636"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1787302444;
	cv=none; b=P5BF4mEQ6/+BQqGh4qLvRREMtat+1hC1j8po5qQgluXQoXy7FdsvVs3aPNLozXn994vq9VGjOuSDtByGH8anKCAsvCxJHtNzFuUIsH3E4+nBPRI8qwYrWnajYBRNx70bn8RZ3uBkGyr/72MctuHw6vNp6/7mxLqOmxloPWTb8cKJyNQ48FkYeoHyB2nVbVuV7K0lFv6PPVC+W69RNBx/TPEKaQqIpHjoFBcbdclNma06p842wtUD5GCHHrBcWJKgWO6c5WvMnWrky5safX6m3pNyP2gKaT49vhetGyr/XckgiND0aYhoCvaK6/1M+7SrDvtGSrGiXZxIt0ixuwSUIg==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1787302444; c=relaxed/relaxed;
	bh=yR0hWzNZW87/c1G83X0z6LMto4HrOqqSyB/mX+ZwfYs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=PILzf6XWiQDSEDeE5QChG1VvpJfQltorQJ9Cuxo/AReriVKy0owlK2WxtBBbhp1WGnwaGDFWsMw6JnppLk2okhJc0DrJCLqFhH/4Xg0jhXAlKPtJKdP7Gq3qIiORWpvd9C4e86egDj/XtdsgDwyju4G8LLg5piEZ/5Qt2qI37lpi3jub2rPPavP7/uhXolGDWTYn9kZIz+U0n6kgUx35+ouEnaUavCIVs7aBlMg5aE3xGHEh76Yg7W7Wa8XRECN6qsVM7nsnpLMRpXMm9fs3Cu/HPNP0jmqAgSW+1jfB/BifxmFWR0klZ0C0xCB2id04GyYiOTjUDe1xKi3FFFJGNw==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=gmail.com; dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=JxRJZISv; dkim-atps=neutral; spf=pass (client-ip=2607:f8b0:4864:20::636; helo=mail-pl1-x636.google.com; envelope-from=zhanxusheng1024@gmail.com; receiver=lists.ozlabs.org) smtp.mailfrom=gmail.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=JxRJZISv;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=gmail.com (client-ip=2607:f8b0:4864:20::636; helo=mail-pl1-x636.google.com; envelope-from=zhanxusheng1024@gmail.com; receiver=lists.ozlabs.org)
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hRDcn0w23z2xWt
	for <linux-erofs@lists.ozlabs.org>; Fri, 21 Aug 2026 18:54:00 +1000 (AEST)
Received: by mail-pl1-x636.google.com with SMTP id d9443c01a7336-2ce7d2adef4so10947015ad.3
        for <linux-erofs@lists.ozlabs.org>; Fri, 21 Aug 2026 01:54:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787302438; x=1787907238; darn=lists.ozlabs.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=yR0hWzNZW87/c1G83X0z6LMto4HrOqqSyB/mX+ZwfYs=;
        b=JxRJZISvpxU7tTpU5rZzQ9DKv4JpNS8/1N2+6CW0tI+qHIenOmSsmwuyyw5VjEMz3t
         zFQ+V7kSV96fs1t1UOT2ZzakmyJpJud8pl3UHmyGxEOEm6qUp4vI30zE/RTPMUB192QM
         XWcSf4pOh1drtsf3Nx6a7LdFWxEJr98M4VEyIio689yxUfVDUGZRkq4PNwXqtC7EqoIF
         3/qTeRY4AWF54Qyth5QCRiSm8UJgaEdKBjnNNGUTt0Swb2laIwPwHRWwJjiWRF/cz62o
         YP4t3yCa8HlIkDzwkEivP9kvE32iOCRUZCHAbbbdBRIyUs3YhIl+FgbS4keXxd5hde9u
         f26g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787302438; x=1787907238;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=yR0hWzNZW87/c1G83X0z6LMto4HrOqqSyB/mX+ZwfYs=;
        b=KEPGUe2HLe1ogmlm7ekplTCCOYv96cgqdaYV5JQ6+FLhW+BWniv67URxG31F+Ay7Nx
         dbH9OKNJNt4Z/GgilMdpGaC+3C2tjMxQOY7jrTi9DelB5vVsvksbny8zIXbaQl66q0pN
         l+SaKOZ9D+t/hcTVDz8NbweCje6nOckpOSrGQKXtxpFq7X9WMWTycCh2hpfQhALhU2wm
         Ylq5UDjRGO1tXY9KRwIIXljZRgfjr9vATLHmhlpN2E/syZiaFs02HEtVndeItwYc1kKA
         JAyYVw4a7yYPuWmjnXfJuP3HgGJ1qOud8KDldXdsIPqXJzpQKjj+/fMryCx8zTpsksVd
         bulQ==
X-Forwarded-Encrypted: i=1; AHgh+RovPxRQWAMSDML+DQgz53AnG/T75/C4IZBmKa64ELkcgvfSXxq5yAOjSeREQf7aEti4dFv4NIVccQPLYw==@lists.ozlabs.org
X-Gm-Message-State: AFuF++lQQGxuqm1g83ZEdK0S9H3dzwgyL4odWKldxP9aGwfaDPTxv07P
	D/gsFbdzVG1RvP8O0Yw3J6S4sJ6OE7aQwqQKlCR0ESNAoZVNtZ7pMugz
X-Gm-Gg: AR+sD12/cURdZ64hBJ9ykBbRxRgKMH3fy9hr4o/rLQQn2+ph+PCf17+XdTF0o+F6Cuj
	TUGCAJsgPhjGU3B37ojcMdxnWIR9wx0AFiZi8rTOBPhhFAGOCIiD+XyhyOC1E4wjDQ/U8Kq7Jgo
	73Hu82KrBM56/cT0dJbM+gu9iE29UjQdMkuxAz57Da7W3MlsxHG2kVm8OZATM4vvGcv7r3cWqEf
	m7Xdj9ZfCobBDZv/ICZA2tFmhw8QRFjVSoj9VCTBikrUhWEB2gwi5xkqyjoBHBJxBoOOFL6V+RL
	Vid2OmkU3xHyh5CoGI2cT1NPZE2FagrGL9qfGQ9C6FRCTSgA8+7EczInbJMcc2wsr0SwglIryZJ
	CocZdf2raZsmr6oYNN1vxVGfK5eXMyMfG5HnGbH0Nb4pi0+0255tsD78pO58VaBtEmogA1+YW68
	Fg6y3k1bk/mRrcEhUE4XbK26bDrlqKn25SYPBQJTV2DZxUfNWLsDYeVwJILI4nifGI5vww7lymn
	edLo2yAYBg=
X-Received: by 2002:a17:902:ebcd:b0:2cf:ccc2:6088 with SMTP id d9443c01a7336-2d64af6b6aemr100319425ad.4.1787302438329;
        Fri, 21 Aug 2026 01:53:58 -0700 (PDT)
Received: from osman.mioffice.cn ([43.224.245.178])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2d62e3c4731sm15759795ad.71.2026.08.21.01.53.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Aug 2026 01:53:56 -0700 (PDT)
From: Zhan Xusheng <zhanxusheng1024@gmail.com>
X-Google-Original-From: Zhan Xusheng <zhanxusheng@xiaomi.com>
To: Gao Xiang <xiang@kernel.org>
Cc: Jingbo Xu <jefflexu@linux.alibaba.com>,
	zhanxusheng@xiaomi.com,
	linux-erofs@lists.ozlabs.org,
	Zhan Xusheng <zhanxusheng1024@gmail.com>
Subject: [PATCH v2] erofs-utils: tests: add a splice() test for inode_share mode
Date: Fri, 21 Aug 2026 16:53:50 +0800
Message-ID: <20260821085350.2024348-1-zhanxusheng@xiaomi.com>
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

So read one file with splice() alone and then look for the pages through
the other one, where they only show up if the read went through the shared
mapping.  pgresident counts them with mmap() + mincore(), which reaches
the backing file because erofs_ishare_mmap() points the vma there.

Measured on 7.2 with two identical 8 MiB files, before and after the
kernel change, as pages seen through the file that was not spliced:

  before   0
  after    2048

Two small helpers because no common tool reads a file purely with
splice(2) -- dd and cat both use read(2) -- and because counting resident
pages otherwise means either cachestat(), which reports the file's own
mapping rather than the shared one, or coaxing fincore off it.

Signed-off-by: Zhan Xusheng <zhanxusheng@xiaomi.com>
---
v1->v2:
- Dropped cachestat() as asked.  v1 both asserted what it reports and
  used strace -efault=cachestat to push fincore onto mmap()+mincore();
  neither is left.  If erofs_ishare_fops ever grows a ->cachestat()
  that fault injection would have been the wrong way round anyway.
- Observe through the file that was not spliced, so the count is only
  non-zero if the read went through the shared mapping.
- Count the pages in a helper, which also drops the strace, fincore
  and fadvise dependencies.  The empty starting state is now asserted
  rather than forced with fadvise.

v1: https://lore.kernel.org/all/20260821015722.1936404-1-zhanxusheng@xiaomi.com

 tests/Makefile.am      |  3 ++
 tests/common/rc        | 12 +++++++
 tests/erofs/032        | 64 +++++++++++++++++++++++++++++++++++
 tests/erofs/032.out    |  2 ++
 tests/src/Makefile.am  |  7 +++-
 tests/src/pgresident.c | 76 ++++++++++++++++++++++++++++++++++++++++++
 tests/src/spliceread.c | 61 +++++++++++++++++++++++++++++++++
 7 files changed, 224 insertions(+), 1 deletion(-)
 create mode 100755 tests/erofs/032
 create mode 100644 tests/erofs/032.out
 create mode 100644 tests/src/pgresident.c
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
index aa7ef99..e4d9f5e 100644
--- a/tests/common/rc
+++ b/tests/common/rc
@@ -357,6 +357,18 @@ _require_fssum()
 	[ -x $FSSUM_PROG ] || _notrun "fssum not built"
 }
 
+_require_spliceread()
+{
+	SPLICEREAD_PROG=${PWD}/src/spliceread
+	[ -x $SPLICEREAD_PROG ] || _notrun "spliceread not built"
+}
+
+_require_pgresident()
+{
+	PGRESIDENT_PROG=${PWD}/src/pgresident
+	[ -x $PGRESIDENT_PROG ] || _notrun "pgresident not built"
+}
+
 # generate random string with maximum $1 length
 _random()
 {
diff --git a/tests/erofs/032 b/tests/erofs/032
new file mode 100755
index 0000000..958e5e2
--- /dev/null
+++ b/tests/erofs/032
@@ -0,0 +1,64 @@
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
+_require_erofs
+_require_erofs_inode_sharing
+_require_spliceread
+_require_pgresident
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
+# pgresident maps the file and counts the resident pages.  erofs_ishare_mmap()
+# points the vma at the backing file, so this counts the shared mapping.
+before=$($PGRESIDENT_PROG $SCRATCH_MNT/a) || _fail "pgresident failed"
+echo "before $before" >> $seqres.full
+[ "$before" -eq 0 ] || _fail "shared page cache not empty after mount"
+
+# Read one file with splice() alone, then look for the pages through the other
+# one.  They only show up there if the read went through the shared mapping.
+$SPLICEREAD_PROG $SCRATCH_MNT/b >> $seqres.full 2>&1 || _fail "splice failed"
+
+after=$($PGRESIDENT_PROG $SCRATCH_MNT/a) || _fail "pgresident failed"
+echo "after $after" >> $seqres.full
+[ "$after" -gt 0 ] || _fail "splice did not populate the shared page cache"
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
index 16de41a..99358de 100644
--- a/tests/src/Makefile.am
+++ b/tests/src/Makefile.am
@@ -3,12 +3,17 @@
 
 AUTOMAKE_OPTIONS	= foreign
 check_PROGRAMS		=
-noinst_PROGRAMS		= fssum
+noinst_PROGRAMS		= fssum spliceread pgresident
 
 fssum_CFLAGS = -Wall -I$(top_srcdir)/include
 fssum_LDADD = $(top_builddir)/lib/liberofs.la
 fssum_SOURCES = fssum.c
 
+spliceread_CFLAGS = -Wall
+spliceread_SOURCES = spliceread.c
+pgresident_CFLAGS = -Wall
+pgresident_SOURCES = pgresident.c
+
 if ENABLE_LZ4
 check_PROGRAMS += badlz4
 badlz4_SOURCES = badlz4.c
diff --git a/tests/src/pgresident.c b/tests/src/pgresident.c
new file mode 100644
index 0000000..2164766
--- /dev/null
+++ b/tests/src/pgresident.c
@@ -0,0 +1,76 @@
+// SPDX-License-Identifier: GPL-2.0+
+/*
+ * Report how many pages of a file are resident in the page cache it is
+ * mapped from, using mmap() + mincore().
+ *
+ * For erofs inode_share this is the shared mapping, since
+ * erofs_ishare_mmap() points the vma at the backing file.
+ */
+#include <fcntl.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <sys/mman.h>
+#include <sys/stat.h>
+#include <unistd.h>
+
+int main(int argc, char *argv[])
+{
+	unsigned char *vec;
+	size_t pages, i;
+	struct stat st;
+	long resident = 0;
+	long pagesize;
+	void *addr;
+	int fd;
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
+	if (fstat(fd, &st)) {
+		perror("fstat");
+		return 1;
+	}
+	if (!st.st_size) {
+		printf("0\n");
+		return 0;
+	}
+
+	pagesize = sysconf(_SC_PAGESIZE);
+	if (pagesize <= 0) {
+		perror("sysconf");
+		return 1;
+	}
+	pages = ((size_t)st.st_size + pagesize - 1) / pagesize;
+
+	addr = mmap(NULL, st.st_size, PROT_READ, MAP_SHARED, fd, 0);
+	if (addr == MAP_FAILED) {
+		perror("mmap");
+		return 1;
+	}
+	vec = malloc(pages);
+	if (!vec) {
+		perror("malloc");
+		return 1;
+	}
+	if (mincore(addr, st.st_size, vec)) {
+		perror("mincore");
+		return 1;
+	}
+	for (i = 0; i < pages; i++)
+		if (vec[i] & 1)
+			resident++;
+
+	printf("%ld\n", resident);
+
+	free(vec);
+	munmap(addr, st.st_size);
+	close(fd);
+	return 0;
+}
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


