Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC5D4606A320
	for <linux-erofs@archiver.kernel.org>; Sun, 22 Nov 2026 03:12:12 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4jXDdN4g9zz2xgv;
	Sun, 22 Nov 2026 14:12:08 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=159.226.251.21
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1795317128;
	cv=none; b=EIwMIzqXD4L7z4bWQ1WbfwEbCZta5hHO9ikHBOWG0GqGXQocN1vgHmuSVbLQryUox6Gu/ekMOZmH5XPBLy3RzPp6fwB1suNkIAEjouiHZsSJZt1KmynHsoMhGIefxOvHVwiVR8yWeZeFjjvpD0JLAccERQtqcbEAw3kc00OUVDINQnNqd24mMSavN3mjzpKh6tJRJI+ztT2ApBomsU6PbA7j8fXoIj77VSUxFLA+kGjnCvWiFkN7rG7cisn9uctNYi1xTspx1OnZGuYTp3JWpApXLk3y226JRW0V9NO0pMSxVz35ndaIIaC8/IMHk1b6gWl+SxYaDwNU8Z+IsC0fVg==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1795317128; c=relaxed/relaxed;
	bh=LLmYQWoSvb8CnHdCwkwKC0omUSOEPSGk29bfKXKAo0k=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=JdTVQlYEOBhHw1FGKCorDRAfX12ahB1/r9fDuzOwWm878pFa1t3hKdz5Xfe6ZnUl1TXOPDH4QmHN/R1Vno5EgQoVh2wF+Epkx5GzuXlEvguDhjpwFmxS0qCboBKimS63eH8WKmFD7eE771JtEBlbmckKShAarCUtmLyjcObFqGdXBjiiXEBUYll8iKVInpsOCn8FXG1Amf1zftJ63Yr4SvjFy0mxhjqzy1I6+HWNYd6Ddi+LI239xHSTFTZsbjyyG+zJGCqLm5nlM+WrWpYTwn/xchV9xWRrOIZUxxlQrIyPELsWDQeVY31fQ4dbugNjgR+ZF/0Th1PPpc5nATVHuw==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=none (p=none dis=none) header.from=mails.ucas.ac.cn; spf=pass (client-ip=159.226.251.21; helo=cstnet.cn; envelope-from=yanmengdie24@mails.ucas.ac.cn; receiver=lists.ozlabs.org) smtp.mailfrom=mails.ucas.ac.cn
Authentication-Results: lists.ozlabs.org; dmarc=none (p=none dis=none) header.from=mails.ucas.ac.cn
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=mails.ucas.ac.cn (client-ip=159.226.251.21; helo=cstnet.cn; envelope-from=yanmengdie24@mails.ucas.ac.cn; receiver=lists.ozlabs.org)
Received: from cstnet.cn (smtp21.cstnet.cn [159.226.251.21])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4jXDdL4gxbz2yQG
	for <linux-erofs@lists.ozlabs.org>; Sun, 22 Nov 2026 14:12:05 +1100 (AEDT)
Received: from localhost.localdomain (unknown [36.110.52.2])
	by APP-01 (Coremail) with SMTP id qwCowACHsvzFWwJrAQdzAQ--.19888S2;
	Sun, 22 Nov 2026 11:04:40 +0800 (CST)
From: Mengdie Yan <yanmengdie24@mails.ucas.ac.cn>
To: linux-erofs@lists.ozlabs.org
Cc: Mengdie Yan <yanmengdie24@mails.ucas.ac.cn>,
	Gao Xiang <xiang@kernel.org>,
	Chengyu Zhu <hudsonzhu@tencent.com>
Subject: [PATCH] erofs-utils: tests: check hot file placement of --hot-file-list
Date: Sun, 22 Nov 2026 11:04:33 +0800
Message-ID: <acf0a2e90f7673c9d1add33324f002d5bbaef6d9.1795283998.git.yanmengdie24@mails.ucas.ac.cn>
X-Mailer: git-send-email 2.50.1
X-Mailing-List: linux-erofs@lists.ozlabs.org
List-Id: <linux-erofs.lists.ozlabs.org>
List-Help: <mailto:linux-erofs+help@lists.ozlabs.org>
List-Owner: <mailto:linux-erofs+owner@lists.ozlabs.org>
List-Post: <mailto:linux-erofs@lists.ozlabs.org>
List-Subscribe: <mailto:linux-erofs+subscribe@lists.ozlabs.org>,
  <mailto:linux-erofs+subscribe-digest@lists.ozlabs.org>,
  <mailto:linux-erofs+subscribe-nomail@lists.ozlabs.org>
Precedence: list
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qwCowACHsvzFWwJrAQdzAQ--.19888S2
X-Coremail-Antispam: 1UD129KBjvJXoW3JF13WFWUurWDXr43GFyrtFb_yoW7Zr4rp3
	y5C3WrXry8A3WIy39a9w13Kr15Gr4vqF45Z3sFg34jyF4DGr1kJ393Kr10yFyagr45Jw48
	Za4IvFy5Cr1vvwUanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUv014x267AKxVWUJVW8JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26ryj6F1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4j
	6F4UM28EF7xvwVC2z280aVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gr
	1j6F4UJwAac4AC62xK8xCEY4vEwIxC4wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40E
	FcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWUtVWrXwAv7VC2z280aVAFwI0_Gr
	1j6F4UJwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IYc2Ij64vIr41lF7I21c0EjII2zVCS
	5cI20VAGYxC7MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I
	8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUAVWU
	twCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1I6r4UMIIF0xvE2Ix0cI8IcVCY1x
	0267AKxVW8JVWxJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_
	Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7VUb
	rHUDUUUUU==
X-CM-SenderInfo: 51dqzv5qjgxvysu6ztxlovh3xfdvhtffof0/
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Check that hot regular files are placed in list order before cold
files, both uncompressed and with compressed fragments, and that their
contents survive a round trip through fsck.erofs.

Also cover stale list entries (missing paths, symlink loops and
symlinks climbing above the image root), which must not fail the
build, and check that an unlisted symlink to a hot file stays cold.

A compressible file with an incompressible tail is included since its
tail gets inlined as a raw pcluster when fragments are enabled.

Signed-off-by: Mengdie Yan <yanmengdie24@mails.ucas.ac.cn>
---
Based on experimental-tests (aaa2ee9).  It needs the series "[PATCH 0/4]
erofs-utils: mkfs: add --hot-file-list for cold-start locality" and is
skipped when mkfs.erofs lacks --hot-file-list.

033 and 034 are already used by other pending tests on the list, so
this one takes 035; please renumber as needed.
 tests/Makefile.am   |   3 ++
 tests/erofs/035     | 119 ++++++++++++++++++++++++++++++++++++++++++++
 tests/erofs/035.out |   2 +
 3 files changed, 124 insertions(+)
 create mode 100755 tests/erofs/035
 create mode 100644 tests/erofs/035.out

diff --git a/tests/Makefile.am b/tests/Makefile.am
index 363b93d..3c1096a 100644
--- a/tests/Makefile.am
+++ b/tests/Makefile.am
@@ -135,6 +135,9 @@ TESTS += erofs/031
 # 032 - check that the xattr layout does not depend on listxattr(2) order
 TESTS += erofs/032
 
+# 035 - check hot file placement of --hot-file-list
+TESTS += erofs/035
+
 # NEW TEST CASE HERE
 # TESTS += erofs/999
 
diff --git a/tests/erofs/035 b/tests/erofs/035
new file mode 100755
index 0000000..4ac5dd7
--- /dev/null
+++ b/tests/erofs/035
@@ -0,0 +1,119 @@
+#!/bin/sh
+# SPDX-License-Identifier: GPL-2.0+
+#
+# Check that --hot-file-list places hot regular files in list order before
+# cold ones, tolerates stale entries (missing paths, symlink loops, symlinks
+# climbing above the image root) and keeps file contents intact.
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
+$MKFS_EROFS_PROG --help 2>&1 | grep -q -- '--hot-file-list' ||
+	_notrun "--hot-file-list is not supported, skipped."
+[ -z "$DUMP_EROFS_PROG" ] && _notrun "dump.erofs is not available, skipped."
+_require_fssum
+
+# remove previous $seqres.full before test
+rm -f $seqres.full
+
+# real QA test starts here
+echo "QA output created by $seq"
+
+localdir=$tmp/$seq
+src=$localdir/src
+rm -rf $localdir
+mkdir -p $src/cold $src/usr/lib $src/lib $src/data/sub
+
+for i in 1 2 3 4; do
+	dd if=/dev/urandom of=$src/cold/c$i bs=1000 count=$((i * 7)) 2>/dev/null
+done
+dd if=/dev/urandom of=$src/data/sub/big bs=1000 count=50 2>/dev/null
+dd if=/dev/urandom of=$src/lib/libfoo.so.1 bs=1000 count=13 2>/dev/null
+dd if=/dev/urandom of=$src/data/h1 bs=1000 count=8 2>/dev/null
+dd if=/dev/urandom of=$src/data/small bs=300 count=1 2>/dev/null
+# compressible head with an incompressible inline tail
+awk 'BEGIN { for (i = 1; i <= 2000; i++) print i }' > $src/data/mixed
+dd if=/dev/urandom bs=1500 count=1 2>/dev/null >> $src/data/mixed
+ln $src/data/h1 $src/cold/h1-alias
+# ".." beyond the image root stays at the root
+ln -s ../../../../lib/libfoo.so.1 $src/usr/lib/libfoo.so
+ln -s loop $src/loop
+ln -s data/h1 $src/alias
+
+cat > $localdir/list <<EOL
+# hot files in list order
+data/sub/big
+usr/lib/libfoo.so
+data/small
+data/mixed
+/data/h1
+../escape
+loop/x
+missing/file
+EOL
+
+FSSUM_OPTS="-MAC"
+
+# print the first physical byte of a file, skip inline-only data
+pstart()
+{
+	$DUMP_EROFS_PROG -e --path="$2" $1 2>/dev/null |
+		awk '/^ *0:/ { gsub(/\.\./, " "); if ($7 % 4096 == 0) print $7; exit }'
+}
+
+check()
+{
+	img=$localdir/$1.erofs
+	shift
+	$MKFS_EROFS_PROG "$@" --hot-file-list=$localdir/list $img $src \
+		>> $seqres.full 2>&1 || _fail "failed to mkfs with $*"
+
+	rm -rf $localdir/out
+	$FSCK_EROFS_PROG --extract=$localdir/out $img >> $seqres.full 2>&1 ||
+		_fail "fsck failed with $*"
+	[ "`$FSSUM_PROG $FSSUM_OPTS $src`" = \
+	  "`$FSSUM_PROG $FSSUM_OPTS $localdir/out`" ] ||
+		_fail "contents differ with $*"
+
+	prev=-1
+	for f in /data/sub/big /lib/libfoo.so.1 /data/h1; do
+		p=`pstart $img $f`
+		[ -n "$p" ] && [ $p -gt $prev ] ||
+			_fail "hot file $f is out of order with $*"
+		prev=$p
+	done
+	for f in /cold/c1 /cold/c2 /cold/c3 /cold/c4; do
+		p=`pstart $img $f`
+		[ -n "$p" ] && [ $p -gt $prev ] ||
+			_fail "cold file $f precedes hot files with $*"
+	done
+}
+
+check plain
+if [ -n "$lz4hc_on" ]; then
+	check frag -zlz4hc -Eztailpacking,fragments
+	$MKFS_EROFS_PROG --help 2>&1 | grep -q -- '--workers' &&
+		check mt -zlz4hc -Eztailpacking,fragments --workers=4
+fi
+
+# an unlisted symlink to a hot file stays cold
+$MKFS_EROFS_PROG -d9 --hot-file-list=$localdir/list $localdir/alias.erofs \
+	$src > $localdir/alias.log 2>&1 || _fail "failed to mkfs"
+order=`awk '/ file .* dumped/ { printf "%s ", $4 }' $localdir/alias.log`
+case "$order" in
+*"data/h1 "*"alias "*) ;;
+*) _fail "unlisted symlink was scheduled as hot: $order" ;;
+esac
+
+echo Silence is golden
+status=0
+exit 0
diff --git a/tests/erofs/035.out b/tests/erofs/035.out
new file mode 100644
index 0000000..5c8f63c
--- /dev/null
+++ b/tests/erofs/035.out
@@ -0,0 +1,2 @@
+QA output created by 035
+Silence is golden

base-commit: aaa2ee970b59b1f95533f558037cc5b4be66d01c
-- 
2.50.1 (Apple Git-155)


