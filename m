Return-Path: <linux-erofs+bounces-4521-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AFE8AC79FAD
	for <linux-erofs@archiver.kernel.org>; Wed,  9 Sep 2026 09:34:49 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hfwd40gYWz2yqd;
	Wed, 09 Sep 2026 19:34:48 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=115.124.30.124
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1788946488;
	cv=none; b=DLiYephlNdzZmHT2FVMT0djmoQ6KT2ad44QtaNAQa9U/f+zsoNVTPS3ZXqJhGt3RwP4XNDvTavAZvjJtOkMa+8f6n8mwytS6U00VHwZctWs56arJC3pRR7v0lLG6P9ipqAweOut4DQtCv7Px1L06/yPdxSTPrBMv3X8xQmn2iuSATe1tf9LIq78bbbriv7TNxCrF6CBNiyGE8ely2FXIU3bUYKnFXa+eqC/ivUPOH+99J3lZ6BB+OHhJ2EQh2cgrRTPagv1ii/K5c7iJ1dEDaH3+kNLd0EZyjEsX+Gt3pi5mKV14lzI1M/OsxMkqPviaPHf4ym4bqPHLRyv7603O8g==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1788946488; c=relaxed/relaxed;
	bh=2pu5v3PkvxboxIbvkXuXaRX4FWEIA4yXTJpoZvgvlcU=;
	h=From:To:Subject:Date:Message-Id:MIME-Version; b=GXOqDatynMtXyOxHJqUL0QGtRWAC23AMnkNG/XB5XYUsyofFXtYU14MmES9dBsnMKbbqkbPMSgUUxn3NeaFC4Zz9AA+AMGdnG0mNyPD6oc95LeoTejz4AzS20Eg4VZk6f48TiW0skXEK5fE18n1dLyazOGgCJu2Niy42+eoshX9mCpXNLIkLm/NPsKmf0Qc+Jj3WZ01mV4zvKnSyf2zbEf8tjDBQjs3dKSABz4E8r0BtByc5mIoTAx0Sym3nep4Wc1EDyfVxlSwQyztj7MeQFoZxPtjivi7+I9MZm0Lh1cqLT+dErzIuzeGEQKV718rYlt2dT/EZOAUb7Si4xKc1vA==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=CTOC/SWy; dkim-atps=neutral; spf=pass (client-ip=115.124.30.124; helo=out30-124.freemail.mail.aliyun.com; envelope-from=jefflexu@linux.alibaba.com; receiver=lists.ozlabs.org) smtp.mailfrom=linux.alibaba.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=CTOC/SWy;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=linux.alibaba.com (client-ip=115.124.30.124; helo=out30-124.freemail.mail.aliyun.com; envelope-from=jefflexu@linux.alibaba.com; receiver=lists.ozlabs.org)
Received: from out30-124.freemail.mail.aliyun.com (out30-124.freemail.mail.aliyun.com [115.124.30.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hfwd03bdMz2ypw
	for <linux-erofs@lists.ozlabs.org>; Wed, 09 Sep 2026 19:34:40 +1000 (AEST)
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1788946474; h=From:To:Subject:Date:Message-Id:MIME-Version;
	bh=2pu5v3PkvxboxIbvkXuXaRX4FWEIA4yXTJpoZvgvlcU=;
	b=CTOC/SWyXnh5J2R8SFY2l9XD74tIukK9+Zlkw66oxYWzrNoe4vqJxby23Hg5B2gA52Jg3t9bKnjoLhXmvIKhHnWBDdh10eKjV4ktPnP29Pe98F0IkSSg0JqrODffPG6OLkiPiTRH7niGJSYjWtudKLk1bqOA+l+h+AmanKCIm90=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R491e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam011083073210;MF=jefflexu@linux.alibaba.com;NM=1;PH=DS;RN=2;SR=0;TI=SMTPD_---0XAeWW.r_1788946473;
Received: from localhost(mailfrom:jefflexu@linux.alibaba.com fp:SMTPD_---0XAeWW.r_1788946473 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 09 Sep 2026 17:34:33 +0800
From: Jingbo Xu <jefflexu@linux.alibaba.com>
To: xiang@kernel.org,
	linux-erofs@lists.ozlabs.org
Subject: [PATCH v2] erofs-utils: tests: check SEEK_HOLE/SEEK_DATA in inode_share mode
Date: Wed,  9 Sep 2026 17:34:33 +0800
Message-Id: <20260909093433.95193-1-jefflexu@linux.alibaba.com>
X-Mailer: git-send-email 2.19.1.6.gb485710b
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

In inode_share mode erofs_ishare_fops used to fall back to
generic_file_llseek(), which considers the whole file to be data, so
SEEK_HOLE always returned i_size and the real holes of sparse files
were hidden.  This is fixed by kernel commit 8ebf95897885 ("erofs:
support SEEK_HOLE/SEEK_DATA in inode_share mode").

Add a regression test for it.

Signed-off-by: Jingbo Xu <jefflexu@linux.alibaba.com>
---
changes since v1:
- add a minimal util probing SEEK_HOLE/SEEK_DATA, rather than relying
  on xfs_io
---
 tests/Makefile.am     |   3 +
 tests/erofs/033       | 151 ++++++++++++++++++++++++++++++++++++++++++
 tests/erofs/033.out   |   2 +
 tests/src/Makefile.am |   5 +-
 tests/src/lseek.c     |  65 ++++++++++++++++++
 5 files changed, 225 insertions(+), 1 deletion(-)
 create mode 100755 tests/erofs/033
 create mode 100644 tests/erofs/033.out
 create mode 100644 tests/src/lseek.c

diff --git a/tests/Makefile.am b/tests/Makefile.am
index 363b93dc..b60a6cc9 100644
--- a/tests/Makefile.am
+++ b/tests/Makefile.am
@@ -135,6 +135,9 @@ TESTS += erofs/031
 # 032 - check that the xattr layout does not depend on listxattr(2) order
 TESTS += erofs/032
 
+# 033 - regression test for SEEK_HOLE/SEEK_DATA in inode_share mode
+TESTS += erofs/033
+
 # NEW TEST CASE HERE
 # TESTS += erofs/999
 
diff --git a/tests/erofs/033 b/tests/erofs/033
new file mode 100755
index 00000000..b3e58628
--- /dev/null
+++ b/tests/erofs/033
@@ -0,0 +1,151 @@
+#!/bin/sh
+# SPDX-License-Identifier: GPL-2.0+
+#
+# Check that SEEK_HOLE/SEEK_DATA see the real holes in inode_share mode
+#
+# In an inode_share mount regular files are served by erofs_ishare_fops,
+# whose .llseek used to be generic_file_llseek().  That one considers the
+# whole file to be data, so SEEK_HOLE always returned i_size and SEEK_DATA
+# always returned the offset it was handed.
+#
+# Regression test for Linux commit 8ebf95897885 ("erofs: support
+# SEEK_HOLE/SEEK_DATA in inode_share mode").
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
+_require_erofs
+_require_erofs_inode_sharing
+_require_mkfs_blksize
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
+# eight chunks, of which chunk 1, 3, 4, 6, 7 stay holes
+chunksize=4096
+truncate -s $((8 * chunksize)) $localdir/sparse ||
+	_fail "failed to truncate $localdir/sparse"
+for i in 0 2 5; do
+	dd if=/dev/urandom of=$localdir/sparse bs=$chunksize seek=$i count=1 \
+		conv=notrunc >> $seqres.full 2>&1 ||
+		_fail "failed to write chunk $i of $localdir/sparse"
+done
+
+# the same size without any hole at all
+dd if=/dev/urandom of=$localdir/dense bs=$chunksize count=8 \
+	>> $seqres.full 2>&1 || _fail "failed to write $localdir/dense"
+
+sparse_layout="data 0 4096
+hole 4096 4096
+data 8192 4096
+hole 12288 8192
+data 20480 4096
+hole 24576 8192"
+dense_layout="data 0 32768"
+
+# seek to the next data or hole, the result ends up in $seek_result
+_seek()
+{
+	local whence=$1
+	local offset=$2
+	local file=$3
+
+	seek_result=`${PWD}/src/lseek "$file" $whence $offset` ||
+		_fail "lseek failed to seek $whence at $offset in $file"
+}
+
+# write the data/hole layout of $1 to $tmp.layout as "<type> <off> <len>"
+_seek_layout()
+{
+	local file="$1"
+	local size=`_get_filesize "$file"`
+	local pos=0
+
+	: > $tmp.layout
+	while [ $pos -lt $size ]; do
+		_seek data $pos "$file"
+		if [ "$seek_result" = "EOF" ]; then
+			echo "hole $pos $((size - pos))" >> $tmp.layout
+			break
+		fi
+		if [ $seek_result -gt $pos ]; then
+			echo "hole $pos $((seek_result - pos))" >> $tmp.layout
+		fi
+		pos=$seek_result
+
+		_seek hole $pos "$file"
+		[ "$seek_result" = "EOF" ] && seek_result=$size
+		echo "data $pos $((seek_result - pos))" >> $tmp.layout
+		pos=$seek_result
+	done
+}
+
+_check_layout()
+{
+	local tag="$1"
+	local file="$2"
+	local expected="$3"
+
+	_seek_layout "$file"
+	if [ "`cat $tmp.layout`" != "$expected" ]; then
+		{
+			echo "--- $tag expected ---"
+			echo "$expected"
+			echo "--- $tag reported ---"
+			cat $tmp.layout
+		} >> $seqres.full
+		_fail "$tag: SEEK_DATA/SEEK_HOLE reported an unexpected layout"
+	fi
+}
+
+for format in force-chunk-indexes force-inode-blockmap; do
+	echo "=== -E$format ===" >> $seqres.full
+
+	_scratch_mkfs -b$chunksize --chunksize=$chunksize -E$format \
+		--xattr-inode-digest=system.erofs.fingerprint \
+		$localdir >> $seqres.full 2>&1 ||
+		_fail "failed to mkfs (-E$format)"
+
+	# make sure that mkfs wrote ishare_xattrs feature bit
+	$DUMP_EROFS_PROG -s $SCRATCH_DEV | grep -q ishare_xattrs ||
+		_fail "the image carries no inode fingerprints (-E$format)"
+
+	# the very same image without inode_share tells them apart
+	_scratch_mount 2>> $seqres.full
+	_check_layout "sparse (-E$format)" \
+		$SCRATCH_MNT/sparse "$sparse_layout"
+	_check_layout "dense (-E$format)" $SCRATCH_MNT/dense "$dense_layout"
+	_scratch_unmount
+
+	_scratch_mount -oinode_share,domain_id=erofs-$seq-$format 2>> $seqres.full
+	_check_layout "sparse (-E$format, inode_share)" \
+		$SCRATCH_MNT/sparse "$sparse_layout"
+	_check_layout "dense (-E$format, inode_share)" \
+		$SCRATCH_MNT/dense "$dense_layout"
+	_scratch_unmount
+done
+
+echo Silence is golden
+status=0
+exit 0
diff --git a/tests/erofs/033.out b/tests/erofs/033.out
new file mode 100644
index 00000000..c5d29149
--- /dev/null
+++ b/tests/erofs/033.out
@@ -0,0 +1,2 @@
+QA output created by 033
+Silence is golden
diff --git a/tests/src/Makefile.am b/tests/src/Makefile.am
index 16de41a1..4d9975e0 100644
--- a/tests/src/Makefile.am
+++ b/tests/src/Makefile.am
@@ -3,12 +3,15 @@
 
 AUTOMAKE_OPTIONS	= foreign
 check_PROGRAMS		=
-noinst_PROGRAMS		= fssum
+noinst_PROGRAMS	= fssum lseek
 
 fssum_CFLAGS = -Wall -I$(top_srcdir)/include
 fssum_LDADD = $(top_builddir)/lib/liberofs.la
 fssum_SOURCES = fssum.c
 
+lseek_CFLAGS = -Wall
+lseek_SOURCES = lseek.c
+
 if ENABLE_LZ4
 check_PROGRAMS += badlz4
 badlz4_SOURCES = badlz4.c
diff --git a/tests/src/lseek.c b/tests/src/lseek.c
new file mode 100644
index 00000000..c8bd2998
--- /dev/null
+++ b/tests/src/lseek.c
@@ -0,0 +1,65 @@
+// SPDX-License-Identifier: GPL-2.0+
+/*
+ * erofs-utils/tests/src/lseek.c
+ *
+ * Minimal SEEK_DATA/SEEK_HOLE probe: report the offset the kernel
+ * resolves a seek to, or EOF if there is nothing left to find.
+ */
+#define _GNU_SOURCE
+#include <errno.h>
+#include <fcntl.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <unistd.h>
+
+int main(int argc, char *argv[])
+{
+	const char *file, *whence_name;
+	char *end;
+	long long offset, ret;
+	int whence, fd;
+
+	if (argc != 4) {
+		fprintf(stderr, "Usage: %s FILE data|hole OFFSET\n", argv[0]);
+		return 2;
+	}
+	file = argv[1];
+	whence_name = argv[2];
+	if (!strcmp(whence_name, "data")) {
+		whence = SEEK_DATA;
+	} else if (!strcmp(whence_name, "hole")) {
+		whence = SEEK_HOLE;
+	} else {
+		fprintf(stderr, "bad whence: %s\n", whence_name);
+		return 2;
+	}
+	errno = 0;
+	offset = strtoll(argv[3], &end, 0);
+	if (*argv[3] == '\0' || *end != '\0' || errno) {
+		fprintf(stderr, "bad offset: %s\n", argv[3]);
+		return 2;
+	}
+
+	fd = open(file, O_RDONLY);
+	if (fd < 0) {
+		fprintf(stderr, "failed to open %s: %s\n", file, strerror(errno));
+		return 2;
+	}
+	/* the kernel reports -ENXIO when no data/hole is left past EOF */
+	ret = lseek(fd, offset, whence);
+	if (ret < 0) {
+		if (errno == ENXIO) {
+			printf("EOF\n");
+			close(fd);
+			return 0;
+		}
+		fprintf(stderr, "lseek %s %lld in %s: %s\n", whence_name,
+			offset, file, strerror(errno));
+		close(fd);
+		return 2;
+	}
+	printf("%lld\n", ret);
+	close(fd);
+	return 0;
+}
-- 
2.19.1.6.gb485710b


