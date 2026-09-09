Return-Path: <linux-erofs+bounces-4511-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 96D00C79FAD
	for <linux-erofs@archiver.kernel.org>; Wed,  9 Sep 2026 03:43:39 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hfmqs2k1Qz2xlZ;
	Wed, 09 Sep 2026 13:43:37 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=115.124.30.133
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1788925417;
	cv=none; b=eKSgm/518AjQ8UCdRpxR5LvXgJDJrfcbBhbwxIXSUJ0zTBCncanH+9h8BjMhKm6DiYUB99zxA65aWWMtPBgSryee3S6LgasIZmBAiM1HgOxl5CPTKqb6j0S0K9GzklOu31f5MKbUEdbSu2I/q9cbyBz3wuKwD3yKBOLjpWqcPwJRnZqSPLNFxbV6pUzu7YQbqjxzuLTxHgnlyDhNKbngklGXEbTbINxI8Z3R5abHUOZEzwKizHwahMiHtRwUJHD6J59gJnZWiL74Ow0yCD87+Zmq8aB2YHI1HJtyUJgeX7NMPAw7iTVpb0ZfjyoPLMIWN3cugHbV+xRGAG5N62iEdQ==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1788925417; c=relaxed/relaxed;
	bh=Qk34OFBLaHONDey23ejQAmQuwsl07Z5fcWkdj/ABYk4=;
	h=From:To:Subject:Date:Message-Id:MIME-Version; b=kWdYt2j16Ms+4ILMazgHvUIA80lcyVzPSjFVpP3PQErRUxQrUZKdCBTqgDaZ5cbaA6Nq0zm8d7PqSfeZxKj68zLrjSoOxaCvfS6yMp1swU4PceNB03RsnmpXyuuTzTxQf7pHqlOwYlwr1oZY4w3BiKFkOLcnDtnkGDafpc43l6YUs73vs8HoNpnPs30nOF15y4dBeOxgTKPUrvC5ocN1VEb9jtS6jsqCv/x8ZBM6JbCir4OOM5RQtQsLGv5h0s4+8TROEqiSBQPRo7/1RGky7gN7bRQ6gW3CEu+4x2ScQblnnyeM1rgBXxmQsJL92dHWiI+m7xjUiO1cj71WdR5Eew==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=Mc3su9P+; dkim-atps=neutral; spf=pass (client-ip=115.124.30.133; helo=out30-133.freemail.mail.aliyun.com; envelope-from=jefflexu@linux.alibaba.com; receiver=lists.ozlabs.org) smtp.mailfrom=linux.alibaba.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=Mc3su9P+;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=linux.alibaba.com (client-ip=115.124.30.133; helo=out30-133.freemail.mail.aliyun.com; envelope-from=jefflexu@linux.alibaba.com; receiver=lists.ozlabs.org)
Received: from out30-133.freemail.mail.aliyun.com (out30-133.freemail.mail.aliyun.com [115.124.30.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hfmqn2gpCz2xWV
	for <linux-erofs@lists.ozlabs.org>; Wed, 09 Sep 2026 13:43:31 +1000 (AEST)
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1788925405; h=From:To:Subject:Date:Message-Id:MIME-Version;
	bh=Qk34OFBLaHONDey23ejQAmQuwsl07Z5fcWkdj/ABYk4=;
	b=Mc3su9P+sZgDJWoCP++sz+5bJY6zVHH3GKKs2nN5cYE5dqmzpTWJtd3SJtjD8iFCu/uVJKpGTWVUESFFYctsyD2lJWmjwOhJX9siM8Z7foVqnPAmpXLEXDI3ogbFI9TyHClAr/3ZcajY2zUyUWcC+lGIVlGYEfSySDYjX25Ci+s=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R291e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037009110;MF=jefflexu@linux.alibaba.com;NM=1;PH=DS;RN=2;SR=0;TI=SMTPD_---0XAdoBbL_1788925403;
Received: from localhost(mailfrom:jefflexu@linux.alibaba.com fp:SMTPD_---0XAdoBbL_1788925403 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 09 Sep 2026 11:43:24 +0800
From: Jingbo Xu <jefflexu@linux.alibaba.com>
To: xiang@kernel.org,
	linux-erofs@lists.ozlabs.org
Subject: [PATCH] erofs-utils: tests: check SEEK_HOLE/SEEK_DATA in inode_share mode
Date: Wed,  9 Sep 2026 11:43:23 +0800
Message-Id: <20260909034323.51773-1-jefflexu@linux.alibaba.com>
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

Add a regression test for it.  xfs_io is requisite for seeking
SEEK_HOLE and SEEK_DATA.

Signed-off-by: Jingbo Xu <jefflexu@linux.alibaba.com>
---
 tests/Makefile.am   |   3 +
 tests/erofs/033     | 157 ++++++++++++++++++++++++++++++++++++++++++++
 tests/erofs/033.out |   2 +
 3 files changed, 162 insertions(+)
 create mode 100755 tests/erofs/033
 create mode 100644 tests/erofs/033.out

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
index 00000000..1ec0aac0
--- /dev/null
+++ b/tests/erofs/033
@@ -0,0 +1,157 @@
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
+XFS_IO_PROG="$(command -v xfs_io)"
+[ -z "$XFS_IO_PROG" ] && _notrun "xfs_io is not found"
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
+# seek to the next data (-d) or hole (-h), the offset ends up in $seek_result
+_seek()
+{
+	local whence=$1
+	local offset=$2
+	local file=$3
+
+	$XFS_IO_PROG -r -c "seek -$whence $offset" "$file" > $tmp.seek ||
+		_fail "xfs_io failed to seek $whence at $offset in $file"
+	seek_result=`tail -n 1 $tmp.seek | awk '{print $2}'`
+	[ -n "$seek_result" ] ||
+		_fail "cannot parse the seek output of xfs_io for $file"
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
+		_seek d $pos "$file"
+		if [ "$seek_result" = "EOF" ]; then
+			echo "hole $pos $((size - pos))" >> $tmp.layout
+			break
+		fi
+		if [ $seek_result -gt $pos ]; then
+			echo "hole $pos $((seek_result - pos))" >> $tmp.layout
+		fi
+		pos=$seek_result
+
+		_seek h $pos "$file"
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
-- 
2.19.1.6.gb485710b


