Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6357F606A330
	for <linux-erofs@archiver.kernel.org>; Fri, 20 Nov 2026 09:56:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=deepseek.com header.i=@deepseek.com header.a=rsa-sha256 header.s=default header.b=Ro/lQahU
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4jW9hJ6sWQz2xpt;
	Fri, 20 Nov 2026 20:56:00 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=160.236.53.16
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1795168560;
	cv=none; b=HvFl0kiaz26Ltm2Tqe76+ksClgQuv3UgJmYRXknZC8Lr+wRixn+1qTKw+cCsFunS558eanbTPSo7Y6YXy05x/svI5jwtWMgQfJ2QQNaaRNvdN1KPdH+C1ALswZjhQrvOIxz50+2AsUCs1nJwpssuP/G4MkWNcyUj72GRE2+BqNJSvahKIwEHOFiZ0Bba+n5e+YnV2ovi9m4AiXDxNl6d8U1k3auQUR7N4ssVS2RCVl+NjQGjPd3zaZoy7NaG+Mx6hjDTVKLtJxw+yXEzNquEW0asl+1VyIhChhxXXfgehxZYSK1sLYicT11yeE1DWpIoGfVjXiw3x9ej638Jp0YAOQ==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1795168560; c=relaxed/relaxed;
	bh=GbBRSi0E9QODWRMrtQDtnR319HHjRRGdOAHmb8HM6GE=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SJLMiBo+e1IZjlhOk3iFBT6ar6XV+ZAoIAfsZhox/F4KIoglxYJp3RCFxQ/mMZU9rZJqQA+4sVUQ0wr6ukt92dAGI5eyBtEQFqjzu0KoXrIrH3jg5KqFOi9YF4I7hcewDmghbak4o+xp4m/pYY5uE9j6uHoQ+g+KFG79AuaZtiz3cpGtG/VAjd/+pcp1EO/LHGaTIc4PaTIsoyXBTvmUSDW98T13Y/JZntJEpZPMx4sYcNxOKXtgOeR0UDiYgd7cT6mNFwoX7tzjnCawVUNyZxIcK4IOXIeD7Gqo1lwbjJ8gB5z/OxiN8nc9IRwFLyfUEgd3tnJOefEZa7Kh04nvjw==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=deepseek.com; dkim=pass (1024-bit key; unprotected) header.d=deepseek.com header.i=@deepseek.com header.a=rsa-sha256 header.s=default header.b=Ro/lQahU; dkim-atps=neutral; spf=pass (client-ip=160.236.53.16; helo=mail-m1602365316.xmail.ntesmail.com; envelope-from=sereno.xu@deepseek.com; receiver=lists.ozlabs.org) smtp.mailfrom=deepseek.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=deepseek.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=deepseek.com header.i=@deepseek.com header.a=rsa-sha256 header.s=default header.b=Ro/lQahU;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=deepseek.com (client-ip=160.236.53.16; helo=mail-m1602365316.xmail.ntesmail.com; envelope-from=sereno.xu@deepseek.com; receiver=lists.ozlabs.org)
Received: from mail-m1602365316.xmail.ntesmail.com (mail-m1602365316.xmail.ntesmail.com [160.236.53.16])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4jW9hG0Fgmz2yQl
	for <linux-erofs@lists.ozlabs.org>; Fri, 20 Nov 2026 20:55:55 +1100 (AEDT)
Received: from localhost.localdomain (unknown [124.243.154.139])
	by smtp.qiye.163.com (Hmail) with ESMTP id 556b0cc05;
	Fri, 20 Nov 2026 17:55:50 +0800 (GMT+08:00)
From: Wenyuan Xu <sereno.xu@deepseek.com>
To: xiang@kernel.org,
	linux-erofs@lists.ozlabs.org
Subject: [PATCH 2/2] erofs-utils: tests: cover opaque dirs across multiple rebuild stages
Date: Fri, 20 Nov 2026 09:55:43 +0000
Message-ID: <20261120095543.2927739-2-sereno.xu@deepseek.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261120095543.2927739-1-sereno.xu@deepseek.com>
References: <20261120095543.2927739-1-sereno.xu@deepseek.com>
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
X-HM-Tid: 0aa1f8623cfb03a3kunm115447d663c4f9
X-HM-MType: 1
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFITzdXWRgWCB1ZQUpXWS1ZQUlXWQ8JGhUIEh9ZQVkaQxlLVk8ZQxhNGkxDTkIeS1YVFA
	kWGhdVEwETFhoSFyQUDg9ZV1kYEgtZQVlKSU9VSU9IVUpOT1VKSEJZV1kWGg8SFR0UWUFZT0tIVU
	pLSU9PT0hVSktLVUpCS0tZBg++
DKIM-Signature: a=rsa-sha256;
	b=Ro/lQahU6l4Y+TNb2uHZ5LlANZSIdtZUN1YowoOWSjwGEM7iGNmxHIp/fXLnaY1bXIT/d4pBMiT+b6xxpHLjZOAk1kFayuwGgD2BS5hLt8QUjAj4mvdThf91v6SxgIsFUqsNwpydWq2nyqEYG5K2slyjxofS8r+tP8lngFQYlvw=; c=relaxed/relaxed; s=default; d=deepseek.com; v=1;
	bh=GbBRSi0E9QODWRMrtQDtnR319HHjRRGdOAHmb8HM6GE=;
	h=date:mime-version:subject:message-id:from;
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Add erofs/034 to verify that opaque directory semantics survive multiple
rebuilds.  The test creates three layers directly:

  layer1: dir/old
  layer2: dir is a 0:0 whiteout
  layer3: dir/new

It first rebuilds layer2 and layer3 into layer2_3.erofs, then mounts
layer1 and layer2_3 together as overlayfs lower dirs and checks that only
dir/new is visible.

Finally, it rebuilds layer1 with layer2_3 into merged.erofs.  Mount the
final image and check that only dir/new is visible.  If the intermediate
or merged directory loses its opaque marker, dir/old from layer1
reappears.

All builds use --ovlfs-strip=0 so whiteouts and opaque markers are
retained.

Assisted-by: LLM
Signed-off-by: Wenyuan Xu <sereno.xu@deepseek.com>
---
 tests/Makefile.am   |  3 ++
 tests/erofs/034     | 81 +++++++++++++++++++++++++++++++++++++++++++++
 tests/erofs/034.out |  2 ++
 3 files changed, 86 insertions(+)
 create mode 100755 tests/erofs/034
 create mode 100644 tests/erofs/034.out

diff --git a/tests/Makefile.am b/tests/Makefile.am
index f64ca83..4ed042f 100644
--- a/tests/Makefile.am
+++ b/tests/Makefile.am
@@ -138,6 +138,9 @@ TESTS += erofs/032
 # 033 - preserve overlay xattrs without adding duplicate names
 TESTS += erofs/033
 
+# 034 - preserve opaque dirs across multiple rebuild stages
+TESTS += erofs/034
+
 # NEW TEST CASE HERE
 # TESTS += erofs/999
 
diff --git a/tests/erofs/034 b/tests/erofs/034
new file mode 100755
index 0000000..1ce34c4
--- /dev/null
+++ b/tests/erofs/034
@@ -0,0 +1,81 @@
+#!/bin/sh
+# SPDX-License-Identifier: GPL-2.0+
+#
+# Rebuild must preserve whiteout semantics across multiple merge stages.
+#
+seq=`basename $0`
+seqres=$RESULT_DIR/$(echo $0 | awk '{print $((NF-1))"/"$NF}' FS="/")
+
+. "${srcdir}/common/rc"
+
+localdir=$tmp/$seq
+
+cleanup()
+{
+	cd /
+	for mp in mnt layer2_3-mnt layer1-mnt; do
+		$UMOUNT_PROG "$localdir/$mp" >/dev/null 2>&1
+	done
+	rm -rf $tmp.*
+}
+
+_require_root
+_require_erofs
+_require_overlayfs
+
+rm -f $seqres.full
+mkdir -p "$localdir/layer1/dir" "$localdir/layer2" "$localdir/layer3/dir" \
+	"$localdir/layer1-mnt" "$localdir/layer2_3-mnt" "$localdir/mnt" ||
+	_fail "mkdir failed"
+
+printf old > "$localdir/layer1/dir/old" || _fail "cannot create layer1 file"
+mknod "$localdir/layer2/dir" c 0 0 >> $seqres.full 2>&1 ||
+	_notrun "cannot create whiteouts"
+printf new > "$localdir/layer3/dir/new" || _fail "cannot create layer3 file"
+
+echo "QA output created by $seq"
+
+$MKFS_EROFS_PROG --ovlfs-strip=0 "$localdir/layer1.erofs" \
+	"$localdir/layer1" >> $seqres.full 2>&1 || _fail "mkfs failed"
+$MKFS_EROFS_PROG --ovlfs-strip=0 "$localdir/layer2.erofs" \
+	"$localdir/layer2" >> $seqres.full 2>&1 || _fail "mkfs failed"
+$MKFS_EROFS_PROG --ovlfs-strip=0 "$localdir/layer3.erofs" \
+	"$localdir/layer3" >> $seqres.full 2>&1 || _fail "mkfs failed"
+
+# Merge layer2 and layer3 first.
+$MKFS_EROFS_PROG --clean=data --ovlfs-strip=0 "$localdir/layer2_3.erofs" \
+	"$localdir/layer2.erofs" "$localdir/layer3.erofs" \
+	>> $seqres.full 2>&1 || _fail "mkfs failed"
+
+# The intermediate image must hide dir/old from layer1 when mounted
+# together with it as overlayfs lower dirs.
+$MOUNT_PROG -t erofs -o loop,ro "$localdir/layer1.erofs" \
+	"$localdir/layer1-mnt" >> $seqres.full 2>&1 || _fail "mount failed"
+$MOUNT_PROG -t erofs -o loop,ro "$localdir/layer2_3.erofs" \
+	"$localdir/layer2_3-mnt" >> $seqres.full 2>&1 || _fail "mount failed"
+$MOUNT_PROG -t overlay overlay \
+	-o "lowerdir=$localdir/layer2_3-mnt:$localdir/layer1-mnt" \
+	"$localdir/mnt" >> $seqres.full 2>&1 || _fail "overlay mount failed"
+[ -f "$localdir/mnt/dir/new" ] || _fail "recreated dir/new lost"
+[ ! -e "$localdir/mnt/dir/old" ] || _fail "deleted dir/old reappeared"
+$UMOUNT_PROG "$localdir/mnt" >> $seqres.full 2>&1 || _fail "unmount failed"
+$UMOUNT_PROG "$localdir/layer2_3-mnt" >> $seqres.full 2>&1 ||
+	_fail "unmount failed"
+$UMOUNT_PROG "$localdir/layer1-mnt" >> $seqres.full 2>&1 ||
+	_fail "unmount failed"
+
+# Then merge layer1 with the intermediate image.
+$MKFS_EROFS_PROG --clean=data --ovlfs-strip=0 "$localdir/merged.erofs" \
+	"$localdir/layer1.erofs" "$localdir/layer2_3.erofs" \
+	>> $seqres.full 2>&1 || _fail "mkfs failed"
+
+# The final image must only expose dir/new.
+SCRATCH_DEV=$localdir/merged.erofs
+_scratch_mount >> $seqres.full 2>&1
+[ -f "$SCRATCH_MNT/dir/new" ] || _fail "recreated dir/new lost"
+[ ! -e "$SCRATCH_MNT/dir/old" ] || _fail "deleted dir/old reappeared"
+_scratch_unmount >> $seqres.full 2>&1 || _fail "unmount failed"
+
+echo Silence is golden
+status=0
+exit 0
diff --git a/tests/erofs/034.out b/tests/erofs/034.out
new file mode 100644
index 0000000..4c8873c
--- /dev/null
+++ b/tests/erofs/034.out
@@ -0,0 +1,2 @@
+QA output created by 034
+Silence is golden
-- 
2.43.0


