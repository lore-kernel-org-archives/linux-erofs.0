Return-Path: <linux-erofs+bounces-3221-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CE5D8105D9A5
	for <linux-erofs@archiver.kernel.org>; Wed,  8 Apr 2026 03:33:36 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4fr7vL5Tznz2yZN;
	Wed, 08 Apr 2026 13:33:34 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=115.124.30.110
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1775619214;
	cv=none; b=LtDA7717B/LAADkgvnHGb7gSODoeQN8T4SREQYF53Uz1INgXrQEAAW6MCxpheGpu8Tdn8x6fqEPHy5SZMigs7DGHmb58cFDs3f+AdJmqcSta2QBz+0yph/fANe0NEuwz1Y8WQ/pL+bzreXMwmB8DbK3utJOE4HWv8NXMDbaRTn4gKh8G33dY0UNDURSBv7r3tVdSz5iYKdaNsum4yuDljqZW+iitHB5eK9nj1JlUr9flQZy8kwpW5EXwEkVRzD6I26cf332KFwCkkziG0lA2lmJh4Imk9GpCdPQPRG0+6r22OFggsTKyA9kdInKUg9tnRioKXM7zPnGd9Mb2MyDUAg==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1775619214; c=relaxed/relaxed;
	bh=jiXIQYzHTjgKZD19o3KZmE8RKt8IVLXUkJPKXnc/k3Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lDvkPyXg+7kMTF9Xliwoh5p9O8oisIcESonyvMzatXnL3vNokb/g+Wi6WVa1U572dV3WjyL8fOwxdjf/kWcBGHQD/G8/+rbdEiKl2EyQLCLojne9WQ9AqQhUhBddp9CBynSgNk6Ea6x5vabnA1ula+NP+M0GpMInAM9IKEcnA+Dttlmpl+TubGmdEjMcGEN07lU2lgPpboxNo7nWFTacVVakszVW4/7Uu2ll25+dnuK93VdalPLcRKuun2Q5X+tgSI66cRpjoJrNxxTojcCI1I5onA/iETiLKg2/p4HavBRlpr2nMvC4nOH3J3D5Hji+qymYuBqBazq7rNf0oXFbYw==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=mW1+L6uG; dkim-atps=neutral; spf=pass (client-ip=115.124.30.110; helo=out30-110.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org) smtp.mailfrom=linux.alibaba.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=mW1+L6uG;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=linux.alibaba.com (client-ip=115.124.30.110; helo=out30-110.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org)
Received: from out30-110.freemail.mail.aliyun.com (out30-110.freemail.mail.aliyun.com [115.124.30.110])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4fr7vH5rzsz2yYJ
	for <linux-erofs@lists.ozlabs.org>; Wed, 08 Apr 2026 13:33:29 +1000 (AEST)
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1775619204; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=jiXIQYzHTjgKZD19o3KZmE8RKt8IVLXUkJPKXnc/k3Y=;
	b=mW1+L6uGypowoMW8l9lxuwDiRqJd6GwAFVFMpIdKhKDWiJB7/qO7Ef6xNF0PLI38lwWA7P80eiMbhfxPSEo6BTyWd2HP3wYKuizM7gqZN30swCQ8Os4UmYfHL70zpwAm3sEV2zYwsQmRM5IWhU8n1tXSWMay2s+/yMNkqtARy58=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R161e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam011083073210;MF=hsiangkao@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0X0dNgvl_1775619197;
Received: from x31i01179.sqa.na131.tbsite.net(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0X0dNgvl_1775619197 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 08 Apr 2026 11:33:21 +0800
From: Gao Xiang <hsiangkao@linux.alibaba.com>
To: linux-erofs@lists.ozlabs.org
Cc: oliver.yang@linux.alibaba.com,
	Vansh Choudhary <ch@vnsh.in>,
	Gao Xiang <xiang@kernel.org>
Subject: [PATCH v2] erofs-utils: tests: add test for negative GNU tar mtimes
Date: Wed,  8 Apr 2026 11:33:16 +0800
Message-ID: <20260408033316.273626-1-hsiangkao@linux.alibaba.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20260407181313.89203-1-ch@vnsh.in>
References: <20260407181313.89203-1-ch@vnsh.in>
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

From: Vansh Choudhary <ch@vnsh.in>

Add a regression test for negative GNU tar mtimes.

It creates a tarball with a file whose mtime is -1, checks that the
mtime field is encoded in GNU base-256 format, and verifies that the
timestamp is preserved after building and extracting the image.

Signed-off-by: Vansh Choudhary <ch@vnsh.in>
Signed-off-by: Gao Xiang <xiang@kernel.org>
---
v2:
 - use dump.erofs instead of fsck.erofs;
 - switch to MIT license.

 tests/Makefile.am   |  3 +++
 tests/erofs/030     | 55 +++++++++++++++++++++++++++++++++++++++++++++
 tests/erofs/030.out |  2 ++
 3 files changed, 60 insertions(+)
 create mode 100755 tests/erofs/030
 create mode 100644 tests/erofs/030.out

diff --git a/tests/Makefile.am b/tests/Makefile.am
index d8ac067805e8..28edc0d744d1 100644
--- a/tests/Makefile.am
+++ b/tests/Makefile.am
@@ -126,6 +126,9 @@ TESTS += erofs/028
 # 029 - test FUSE daemon and kernel error handling on corrupted inodes
 TESTS += erofs/029
 
+# 030 - regression test for negative GNU tar mtimes
+TESTS += erofs/030
+
 # NEW TEST CASE HERE
 # TESTS += erofs/999
 
diff --git a/tests/erofs/030 b/tests/erofs/030
new file mode 100755
index 000000000000..72765cb19aee
--- /dev/null
+++ b/tests/erofs/030
@@ -0,0 +1,55 @@
+#!/bin/sh
+# SPDX-License-Identifier: MIT
+#
+# 030 - regression test for negative GNU tar mtimes
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
+if [ -z "$SCRATCH_DEV" ]; then
+	SCRATCH_DEV=$tmp/erofs_$seq.img
+	rm -f $SCRATCH_DEV
+fi
+
+localdir="$tmp/$seq"
+rm -rf $localdir
+mkdir -p $localdir/src
+
+touch -d @-1 $localdir/src/testfile >> $seqres.full 2>&1 || \
+	_notrun "touch -d @-1 is not supported"
+tar --format=gnu -C $localdir/src -cf $localdir/foo.tar testfile >> $seqres.full 2>&1 || \
+	_fail "failed to create tarball"
+
+mtime=$(od -An -t x1 -j 136 -N 12 $localdir/foo.tar | tr -d '[:space:]')
+[ "$mtime" = "ffffffffffffffffffffffff" ] || \
+	_notrun "tar did not encode a negative GNU mtime"
+
+$MKFS_EROFS_PROG --tar=f $SCRATCH_DEV $localdir/foo.tar \
+	>> $seqres.full 2>&1 || _fail "failed to mkfs tarball"
+
+output=$($DUMP_EROFS_PROG --path=/testfile $SCRATCH_DEV 2>&1)
+[ $? -eq 0 ] || _fail "failed to dump testfile"
+echo "$output" >> $seqres.full
+
+mtime=$(grep '^Timestamp:' <<< $output | sed 's/^.*: //')
+[ "x$mtime" = "x1970-01-01 07:59:59.000000000" ] || \
+	_fail "negative GNU mtime was not preserved"
+
+echo Silence is golden
+status=0
+exit 0
diff --git a/tests/erofs/030.out b/tests/erofs/030.out
new file mode 100644
index 000000000000..06a1c8fe02bb
--- /dev/null
+++ b/tests/erofs/030.out
@@ -0,0 +1,2 @@
+QA output created by 030
+Silence is golden
-- 
2.43.5


