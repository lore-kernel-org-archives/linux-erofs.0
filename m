Return-Path: <linux-erofs+bounces-2838-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D93E41088E6D
	for <linux-erofs@archiver.kernel.org>; Thu, 19 Mar 2026 03:17:10 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4fbrTd0mW3z2yZ5;
	Thu, 19 Mar 2026 14:17:09 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2607:f8b0:4864:20::42d"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1773890229;
	cv=none; b=XWsTnnPCJZni+JoOcVJv575KdidKSpUfQ8On1Ht+WQr4fbZ8XtR2JNoE13VrYw4gXaOwkdSKQ7ibvg6gnWKnanlJrp0m+H35dcYuishey17YMGMftUAvGSxQ8y3Xx188zm3sDUFcJukO3SHcGGS/QvdrREyjXNMd13TjT7IJxlnNkL9r315mbV9qEHfBGgO+x6dj6WiCsUPhWWUl8nkj26pKWo3ixjbd3TzVmJtBfGBbd5CXQz6QsQvj5EgAX3yUtFEdYYx4q1ORPj9/qy7aQXORCya68ADa7Mf+4N//WDd9wt6TWVeJQ+jsADk9Qc4hIcOMXma7lOoX43Tg5Pa6Qg==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1773890229; c=relaxed/relaxed;
	bh=5hzwjfu268N144a8b+DbgqeF4RF6f7QHSW7skjv76iE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=GWZ1iJapvcPuN2xDCfuu/b0dq5blvIxUUbBrDGwPfVJTTXWVP+f8P8xQYkjSbEsJd1XD+hT+i7nnqreKM3JmzORGTEc6I6IRD2HQwjtXqnIJKTuamqXfeQg6fX7LbNbQvOllhS8aQ6ytXf2RJQ5a7gakp34d6fgNHjYbl8m9qBk1NgBEF5/3yJZcO3YRXkMWxrt5XGM6ugXM6ePsAStNA8P/c6NPOK+usjOTLeoGaEOGIe+0wN52DheRxEl691UorxNJhFQRS/XfdMmR7nYd3K3crfoUzFbjcjtHaP98QDGvmcDY1uy8AFXO+0Zvnz/6xxv4ez0NVqDROqLwZGu8KA==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=gmail.com; dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20230601 header.b=FANe8jD+; dkim-atps=neutral; spf=pass (client-ip=2607:f8b0:4864:20::42d; helo=mail-pf1-x42d.google.com; envelope-from=nithurshen.dev@gmail.com; receiver=lists.ozlabs.org) smtp.mailfrom=gmail.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20230601 header.b=FANe8jD+;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=gmail.com (client-ip=2607:f8b0:4864:20::42d; helo=mail-pf1-x42d.google.com; envelope-from=nithurshen.dev@gmail.com; receiver=lists.ozlabs.org)
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4fbrTb3BCXz2xVT
	for <linux-erofs@lists.ozlabs.org>; Thu, 19 Mar 2026 14:17:06 +1100 (AEDT)
Received: by mail-pf1-x42d.google.com with SMTP id d2e1a72fcca58-829759ca646so323188b3a.2
        for <linux-erofs@lists.ozlabs.org>; Wed, 18 Mar 2026 20:17:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773890224; x=1774495024; darn=lists.ozlabs.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=5hzwjfu268N144a8b+DbgqeF4RF6f7QHSW7skjv76iE=;
        b=FANe8jD+jcCi+Iw31Bg85wDrssjPSaOcj+G8+eFf+8e1pykLKNJ0Rdjr6PB88Z0LCu
         c0tBTBhaF2mQRQlqBb1+aDs9/HkPAJWEIINgB/yrk5pxR/qQUMeQG+LRpX+d/0IsmN8j
         7tKV7eMvtZebbbu+fKJDK76T5hpIJ3xGXQ54L0lZh+ZsHmLtlpgvVuHUkyNMEsU49NTJ
         wVIRZ/njUhaxFQtHIb7TuuGS3B9GZl6+27/7xLVKcmFWkyY9fQoRJQiWbOKg0iNnHJu1
         X3yNoTT8ib0an/nYbwSe58bynFzQvxHuQYZWYdbIl2xYz2hiM49u5KIVyzmL3j4sZz2D
         gYkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773890224; x=1774495024;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5hzwjfu268N144a8b+DbgqeF4RF6f7QHSW7skjv76iE=;
        b=jXan3Uxd2izSWmOnPm0M3HisP0lllaU72PWVIsX1apXwhoo4kyQ5JHzOr28KU0Sx5R
         +Rg1DtBdAJ+dbdZIS9tf4/+TwBR1junu6N4x1CnjyooEe04AQt6vSvRzJgD5d58UTbbg
         /r+da1yAdtK1pp/Nuxe2XX9NesE6++6inheRi5oKVM+LLFAU5pvXL1LXHJy3sJVWOtyq
         QSoUqNVL5CgNt5bGEDlLIolaZ27XfzCvMxORNDvJCBJMOOtJs42NL46UIwpCVsBbbQW9
         k4R1M74g1eWMyAwbadgvbfcBvZRjciapZ3enbKQOzctZQ48qsMOFM8Hd+iHQWoU0i4l9
         Z+Qw==
X-Gm-Message-State: AOJu0YzBLFsLUEsqd3BWnZqsn8OWJZRoKbRSlvvVQ8YXWw2Q6iEnaX6p
	+Zg5Rq1GzaEvafAiO65DfNvuhpl2YN4O16Co6VMhTSbfSzGp3KOElqa2YAZF2i9K
X-Gm-Gg: ATEYQzwqtHpBXFO1p4GGnrB1fIMBtqIEfWYViAdbibzlslfpKHTQbnrHJ1wQci1Ypmw
	ktdnQYdEDvxr9Ve+fcGCmUGqGcfQHae0WN1nofUt/ioJOLDwPQfF6bHXS52VhSYvlAHmhlWWIUO
	C+x0DiU50/kgEDzV+qr6gOZWjSkaqsBDCX3VMMbrKgPztfDkXQ6a/b1AUGvApv45zbkXDrVyTte
	peM64/gUqs84++Bsq24B/t6aZ/zI/FyMKDQ436fMcUb25DlysVVi4MbNBEbQ8zJQUJPlaJK+XwD
	/cxS3pbyBl74VsbEszmBgZE583lacgdbXIIi0GJkm8e0r9tCL9EVzHAS/wKZMUTGViFX8BlNTRd
	ATo1k4dVSq7dPFUusqr/2h04zNXg2o9RK/0K2NYZkgK222aC7YVNKHRWwlzTvr2mnjCOe87OxIU
	AApCpkUrB0DHLFVTu7+r8LuHGeK3dUOBVqns82pZk4CL2WYZoHVZ9Tcrh/
X-Received: by 2002:a05:6a00:2888:b0:81f:4a36:1c7c with SMTP id d2e1a72fcca58-82a6add18e1mr4950234b3a.23.1773890223696;
        Wed, 18 Mar 2026 20:17:03 -0700 (PDT)
Received: from localhost.localdomain ([45.114.151.61])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82a6b5308fcsm5091656b3a.9.2026.03.18.20.17.00
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 18 Mar 2026 20:17:03 -0700 (PDT)
From: Nithurshen <nithurshen.dev@gmail.com>
To: linux-erofs@lists.ozlabs.org
Cc: hsiangkao@linux.alibaba.com,
	zhaoyifan28@huawei.com,
	xiang@kernel.org,
	Nithurshen <nithurshen.dev@gmail.com>
Subject: [PATCH experimental-tests] erofs-utils: tests: add test for blobdev block map support
Date: Thu, 19 Mar 2026 08:46:43 +0530
Message-ID: <20260319031643.97106-1-nithurshen.dev@gmail.com>
X-Mailer: git-send-email 2.52.0
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

Recent changes to mkfs.erofs enabled the use of the block map chunk
format in conjunction with extra blob devices.

Add a test case to ensure this functionality works as expected and
to prevent future regressions. The test creates a dummy source
directory, formats it using `--blobdev` and `-E force-inode-blockmap`,
extracts the resulting image using `fsck.erofs`, and performs a strict
diff to verify that the data mapped to the external blob device is
read correctly without corruption.

Signed-off-by: Nithurshen <nithurshen.dev@gmail.com>
---
 tests/Makefile.am   |  3 +++
 tests/erofs/028     | 48 +++++++++++++++++++++++++++++++++++++++++++++
 tests/erofs/028.out |  2 ++
 3 files changed, 53 insertions(+)
 create mode 100755 tests/erofs/028
 create mode 100644 tests/erofs/028.out

diff --git a/tests/Makefile.am b/tests/Makefile.am
index fe7fb47..03c6212 100644
--- a/tests/Makefile.am
+++ b/tests/Makefile.am
@@ -119,6 +119,9 @@ TESTS += erofs/026
 # 027 - ensure that uncompressed filesystems should not have LZ4_0PADDING set
 TESTS += erofs/027
 
+# 028 - test mkfs with block map for blob devices
+TESTS += erofs/028
+
 EXTRA_DIST = common/rc erofs
 
 clean-local: clean-local-check
diff --git a/tests/erofs/028 b/tests/erofs/028
new file mode 100755
index 0000000..cfd1531
--- /dev/null
+++ b/tests/erofs/028
@@ -0,0 +1,48 @@
+#!/bin/sh
+# SPDX-License-Identifier: GPL-2.0+
+#
+# test mkfs with block map for blob devices
+
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
+	rm -f SCRATCH_DEV
+fi
+
+blob_dev=$tmp/erofs_blob_$seq.img
+rm -f $blob_dev
+
+localdir="$tmp/$seq"
+rm -rf $localdir
+mkdir -p $localdir/test-source
+
+dd if=/dev/urandom of=$localdir/test-source/large_file.bin bs=1M count=2 status=none
+echo "Hello EROFS Block Map" > $localdir/test-source/small_file.txt
+
+_scratch_mkfs $localdir/test-source -E force-inode-blockmap --chunksize=4096 --blobdev=$blob_dev >> $seqres.full 2>&1 || _fail "failed to mkfs"
+
+mkdir -p $localdir/extract-dir
+$FSCK_EROFS_PROG --extract=$localdir/extract-dir --device=$blob_dev $SCRATCH_DEV >> $seqres.full 2>&1 || _fail "failed to extract image"
+
+diff -r --no-dereference $localdir/test-source/ $localdir/extract-dir/ >> $seqres.full 2>&1 || _fail "content mismatch! Data read from blob device is corrupted."
+
+echo Silence is golden
+status=0
+exit 0
\ No newline at end of file
diff --git a/tests/erofs/028.out b/tests/erofs/028.out
new file mode 100644
index 0000000..2615f73
--- /dev/null
+++ b/tests/erofs/028.out
@@ -0,0 +1,2 @@
+QA output created by 028
+Silence is golden
-- 
2.43.0


