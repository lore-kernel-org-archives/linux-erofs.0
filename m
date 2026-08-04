Return-Path: <linux-erofs+bounces-4102-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 181E5C55182
	for <linux-erofs@archiver.kernel.org>; Tue,  4 Aug 2026 03:32:52 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hDfJ220Dbz3092;
	Tue, 04 Aug 2026 13:32:50 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2a00:1450:4864:20::333"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1785814370;
	cv=none; b=JODHbeZEQ6ZoIVTmHaq8Fu3gsK8/2NVjizVYLfuHorazLLG957E66DPh0kb4HQQtozFy5/2isuQw1X1VXihcWJdHBwdwErlTPfd6OY2oaiC+/n4kAUTeCktUwexC3tVCAqcAuPHD0XpANI4Oqc1vedHffW2Y4musxzgPLAzC68YrgHb6Zkp0KqWkMKzyeDRlsiGAMPcc5QrCtaqzDCfeUZ4Y3mvnlH4TKCuTNpR5qN3BRcWjHMaKYP0cEQDALtnhwiBjq+17vpqab2rrnSiN9BpJDfLR8uz+zhaBozCyfOvVJxvzIRwGMnT18i8nSuJ9gQpCNaGG6Xcv452Z56d2bQ==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1785814370; c=relaxed/relaxed;
	bh=YPq/CJyuXNTZgIEDNWli7RIyKoJSknBZ7JrFP42xtrc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=al/DIddDiz7he+zPMgGFL7i55tfndmGrcr53B8NZ0enLYLb6Wf0KJpUocS6Gkk8KC/T/eZh6NMxgXrH00uBdH2CNWyOAzrlLSkDLv733ty2HeAWFbJkvK8MwTIKVZthxWzO4IudVU+Ory9FX5AAG69lyacxjKItc4mqj2L76R/xbuuid3stpfPHQdlJ8x7aruIhgseSa19960JeZ2qQAuOC0yrSkgghOTIPAYglHkcrMYZnhy1w3z1MXnwjO3Dql2v8E0Y8stiUGdqtvD8FH+dNBlVj9p6YCNO3DX7NYxcLZUyRD3udgJdqOnlTqis5mMCRTnqOInvgXsQ2EDyh/RA==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=none (p=none dis=none) header.from=amutable.com; dkim=pass (2048-bit key; unprotected) header.d=amutable-com.20251104.gappssmtp.com header.i=@amutable-com.20251104.gappssmtp.com header.a=rsa-sha256 header.s=20251104 header.b=qrqtCfZa; dkim-atps=neutral; spf=pass (client-ip=2a00:1450:4864:20::333; helo=mail-wm1-x333.google.com; envelope-from=martin@amutable.com; receiver=lists.ozlabs.org) smtp.mailfrom=amutable.com
Authentication-Results: lists.ozlabs.org; dmarc=none (p=none dis=none) header.from=amutable.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=amutable-com.20251104.gappssmtp.com header.i=@amutable-com.20251104.gappssmtp.com header.a=rsa-sha256 header.s=20251104 header.b=qrqtCfZa;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=amutable.com (client-ip=2a00:1450:4864:20::333; helo=mail-wm1-x333.google.com; envelope-from=martin@amutable.com; receiver=lists.ozlabs.org)
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hDfJ13p3Xz2xns
	for <linux-erofs@lists.ozlabs.org>; Tue, 04 Aug 2026 13:32:49 +1000 (AEST)
Received: by mail-wm1-x333.google.com with SMTP id 5b1f17b1804b1-4955158f26aso18497695e9.3
        for <linux-erofs@lists.ozlabs.org>; Mon, 03 Aug 2026 20:32:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amutable-com.20251104.gappssmtp.com; s=20251104; t=1785814366; x=1786419166; darn=lists.ozlabs.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=YPq/CJyuXNTZgIEDNWli7RIyKoJSknBZ7JrFP42xtrc=;
        b=qrqtCfZaOsvLB+id+tFhQypqa9UZ3UIsuS8kqNAU7nQIt0UWFJoM74tVBnAIzU+XHJ
         nPeCg3V0ZeTxCod9FWhEPNxrZ6GV96b6Dzybf8vlwrJor+3CJxdv6xVy7rIdJ4q5KSM4
         +rJgSSwhcdEIYkR1l/7Do4u0BjSr39eVDbUUwDCD0Jl2zdAEietClrEA/jpxLqOgg1L4
         Wo423bqoPRaWcZ1zJmgR65eGCwkN4XAUMtXmeVbJ0m/iFH3A4z9SMJx0kh0l3j37QvQR
         TZwK/tfMKVmHyMLjglMNRvDi9fU5lSyiC0dV7sRdGnpUeZK7eSICbEkcremXXOzMa4vr
         ztaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785814366; x=1786419166;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=YPq/CJyuXNTZgIEDNWli7RIyKoJSknBZ7JrFP42xtrc=;
        b=MhrffrmqT/yzvt1a0mXiMiOWaWEK+Taj40Ygugc0TxlBdlT39HLGA+/JfEEpJgbkYF
         CZA80uqRqo56EfyCDAypY8xPbG631maWY1osamNNQ+22UReR+Yzpt61aVG+nAPmrL+BX
         PBkfNVnuzASr9YwReOL+X1Vv/bJ+0sMrfWvr901p1zE4VOSJE5KZWZaRxSa35lFqoSq1
         MByY+iXvtpU4Ff1nimkeRDTBgN8/6oASxMKep1lJaF25Tt3AIN62z+Zuy+MSYi0JyISU
         S6DN6JvPAsuZKW2fog6iQLn19fas3WJmmLpFLxBsYBqPloPYm2a5UwR8DFVW8R0cbmlf
         zOEA==
X-Gm-Message-State: AOJu0Yws+b3aQ8XkG8QEyapqrWa55gMHQXdq2OdO3+Kmk0yOpD8/iudK
	xY3A6eLbMlCAQQcJgkoPuG8OOWNU2ZB8R/emEsnooqdY/J7OtZq68IWSX/HcpR+k66mqakgwaMp
	ktS+2kBs4
X-Gm-Gg: AR+sD11iNiSNqmJgQb+smlmQPjIrbC/ej4DOJHt/A8OtNZwjUQqbWeAIG1QqymCMj0D
	AnkEKPpL2VpUw3FyTdZjQDAlA/5H0U70YCHyCEZAU/Sxt841RNaVPWTw6b+5N0GusCQQDP46JT7
	OWJNM2z5iGeiL+G1pJhexWstGyz2ses364xD7ZAz7De2ofoGbd+l/89HUyGfMj7yKmfLXKaXiNR
	C5X3NMMml6fvW2MEbRTO5MfKfpoW7Xcn81+O9BoxV7F8kybWfnQUdDjUL6gSNcpCcfhn+hj0AeK
	ndvpVZHPRpe7d96cdImDkxl9D1tUE/8uxSbsuO7R1qpxkYYSZPrxuVLt8VmPl2YZbl6cjjWcpaL
	o82dAr/MAzaVWRswqOmEW0GFgERQHKqew2aUkmVtwdFTlftCRdhVlDLQEck0sxpQn7tcie7ulsw
	sDk0bkcLzqP4nujqfrBP/L8GgD447b5lxUCfjZyeKhtVXcCJHhW4zKQknZ/EbJVaIkxYI6qC3OF
	PM6aH/twZu/SERX4PZc63xonU14/c3ktPdQihtqtGdn0v6Zugs96urx4BQ=
X-Received: by 2002:a05:600c:c113:b0:495:4689:1e98 with SMTP id 5b1f17b1804b1-4980c674e1dmr230932475e9.10.1785814365947;
        Mon, 03 Aug 2026 20:32:45 -0700 (PDT)
Received: from fedora.fritz.box (p200300c78f45f4002fc0e22e545c127a.dip0.t-ipconnect.de. [2003:c7:8f45:f400:2fc0:e22e:545c:127a])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47fd42d91bfsm41286329f8f.15.2026.08.03.20.32.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Aug 2026 20:32:45 -0700 (PDT)
From: Martin Pitt <martin@amutable.com>
To: linux-erofs@lists.ozlabs.org
Cc: Gao Xiang <xiang@kernel.org>,
	Yifan Zhao <zhaoyifan28@huawei.com>,
	Martin Pitt <martin@amutable.com>
Subject: [PATCH 3/3] erofs-utils: tests: check that the xattr layout is order-independent
Date: Tue,  4 Aug 2026 05:32:14 +0200
Message-ID: <20260804033214.211267-4-martin@amutable.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260804033214.211267-1-martin@amutable.com>
References: <20260804033214.211267-1-martin@amutable.com>
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

b260119b8edb ("erofs-utils: mkfs: emit an inode's xattrs in a canonical
order") made the layout independent of the order listxattr(2) reports an
inode's attributes in. Cover it: stage the same tree twice with the same
attributes set in opposite order, and compare the two images. The names
differ in length and share prefixes, so a subtly wrong comparison cannot
order them correctly by accident.

Signed-off-by: Martin Pitt <martin@amutable.com>
---
 tests/Makefile.am   |  3 ++
 tests/erofs/032     | 77 +++++++++++++++++++++++++++++++++++++++++++++
 tests/erofs/032.out |  2 ++
 3 files changed, 82 insertions(+)
 create mode 100755 tests/erofs/032
 create mode 100644 tests/erofs/032.out

diff --git a/tests/Makefile.am b/tests/Makefile.am
index c0291ac..363b93d 100644
--- a/tests/Makefile.am
+++ b/tests/Makefile.am
@@ -132,6 +132,9 @@ TESTS += erofs/030
 # 031 - test chunk-based mapping with shared chunks across inodes
 TESTS += erofs/031
 
+# 032 - check that the xattr layout does not depend on listxattr(2) order
+TESTS += erofs/032
+
 # NEW TEST CASE HERE
 # TESTS += erofs/999
 
diff --git a/tests/erofs/032 b/tests/erofs/032
new file mode 100755
index 0000000..063ed2c
--- /dev/null
+++ b/tests/erofs/032
@@ -0,0 +1,77 @@
+#!/bin/sh
+# SPDX-License-Identifier: GPL-2.0+
+#
+# Check that the xattr layout does not depend on listxattr(2) order
+#
+# listxattr(2) makes no promise about the order it reports, and filesystems
+# disagree: tmpfs reports the order the attributes were set in, while ext4 and
+# btrfs report their own on-disk order. The same set of attributes must end up
+# in the same layout however mkfs.erofs is handed them, otherwise images are
+# not reproducible. The names also differ in length and share prefixes, which
+# exercises the length tiebreak.
+#
+# On a filesystem that reports its own order rather than the insertion order
+# this check cannot fail, so it needs $tmp on a filesystem that keeps insertion
+# order or randomizes it, like tmpfs, which /tmp normally is.
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
+_require_xattr
+
+# remove previous $seqres.full before test
+rm -f $seqres.full
+
+# real QA test starts here
+echo "QA output created by $seq"
+
+attrs="user.aa=1 user.mm=22 user.mm_long=333 user.zz=4444
+user.a_long_attribute_name=55555 user.growfs=666666 user.roothash=7777777
+user.verity=88888888 user.gpt_label=999999999 user.gpt_type_uuid=aaaaaaaaaa"
+
+localdir=$tmp/$seq
+rm -rf $localdir
+
+# same tree and same attributes twice, set in opposite order
+for pass in forward reverse; do
+	tree=$localdir/$pass
+	mkdir -p $tree/dir
+	echo payload > $tree/dir/file
+
+	list=$attrs
+	if [ $pass = reverse ]; then
+		list=
+		for attr in $attrs; do
+			list="$attr $list"
+		done
+	fi
+	for attr in $list; do
+		setfattr -n "${attr%%=*}" -v "${attr#*=}" $tree ||
+			_fail "failed to set ${attr%%=*}"
+	done
+
+	# pin the timestamps and the filesystem UUID, so the attribute order
+	# is the only thing that can differ
+	$MKFS_EROFS_PROG -T1739577600 -U 5230d7cf-f2ce-43ed-9ae2-39e7e2fe48ca \
+		$localdir/$pass.img $tree >> $seqres.full 2>&1 ||
+		_fail "failed to mkfs"
+done
+
+$FSCK_EROFS_PROG --extract $localdir/forward.img >> $seqres.full 2>&1 ||
+	_fail "fsck failed"
+
+cmp -s $localdir/forward.img $localdir/reverse.img ||
+	_fail "the image depends on the order listxattr(2) reported"
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
-- 
2.55.0


