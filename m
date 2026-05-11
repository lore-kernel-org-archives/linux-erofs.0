Return-Path: <linux-erofs+bounces-3395-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F063ECD37AC
	for <linux-erofs@archiver.kernel.org>; Mon, 11 May 2026 08:59:17 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4gDYYw3SHLz2xlh;
	Mon, 11 May 2026 18:59:16 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=185.125.188.123
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1778489956;
	cv=none; b=jidYcyBrYuYCVCuqbFR4ibMskqO47rtIOhVpfoU/zOQ9DTZvWiz3/kO9GiF4L33Iw+OqMzr9rNIbgV5McsjUHSHOObSxrwIAeNbdFBaWjRlVQ2BWPO57yWJZqZ+xdnr7i37KhrwaRBwEfOYlTtnhjQlDXw9bZi5eY8MjlqxiGEG38iAKMYi//IQF6idrxGNm7sAK7VVGedOtoaxI2b2phz/gLyZzBOIvxqROzeE7MkasA7cYarOekbRvxPOj71BE+5CDLiBr9jsgC/5tP6Gw81T1aiphLrf/C+J+4quxA7IkF4qswJSRF3bYcyMu/vUEPSviFEfU+M/zuKwgJzafUQ==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1778489956; c=relaxed/relaxed;
	bh=S6S3tmCtghAcRufgbPHFJ9gmk8ioXC1goBcILuNfLMI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Ze3SXQdmqgbLKVrYEPUZhUJ3TgTetojTPx2EZk6AXPuFKB2Lmqy1UJ0KOaw9Cyg7ltM+BLxcOVaEn8Dq298rb0YCPEPMFSZnrcS//2mqpe9M6oz1OMRQFTQA5US+bqmQmx6blR3KnCbV5npUofm0php3ddLERv4us/Uf5CtW30mLr12PRub7xsHeEPgT1UogS/or8HafB5zj5LSJVRymghnMAq+FEN1WM0H7jTwXeizHx8P2NIfvX2W+1/VaTfGTQvi/EUEOrP8BGLFm8Mse/z4+CM+AIGmfxEXrqYOLP7uqPWDM4j5NRR6Vqxd0Z8CvE5vhvwtQiXM0cjR5jUYrew==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=reject dis=none) header.from=canonical.com; dkim=pass (4096-bit key; unprotected) header.d=canonical.com header.i=@canonical.com header.a=rsa-sha256 header.s=20251003 header.b=FdHBuJeC; dkim-atps=neutral; spf=pass (client-ip=185.125.188.123; helo=smtp-relay-internal-1.canonical.com; envelope-from=aristo.chen@canonical.com; receiver=lists.ozlabs.org) smtp.mailfrom=canonical.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=reject dis=none) header.from=canonical.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (4096-bit key; unprotected) header.d=canonical.com header.i=@canonical.com header.a=rsa-sha256 header.s=20251003 header.b=FdHBuJeC;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=canonical.com (client-ip=185.125.188.123; helo=smtp-relay-internal-1.canonical.com; envelope-from=aristo.chen@canonical.com; receiver=lists.ozlabs.org)
Received: from smtp-relay-internal-1.canonical.com (smtp-relay-internal-1.canonical.com [185.125.188.123])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4gDYYs5GY4z2xjQ
	for <linux-erofs@lists.ozlabs.org>; Mon, 11 May 2026 18:59:12 +1000 (AEST)
Received: from mail-pf1-f198.google.com (mail-pf1-f198.google.com [209.85.210.198])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id 05FE23F60E
	for <linux-erofs@lists.ozlabs.org>; Mon, 11 May 2026 08:59:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
	s=20251003; t=1778489949;
	bh=S6S3tmCtghAcRufgbPHFJ9gmk8ioXC1goBcILuNfLMI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version;
	b=FdHBuJeCtMEVsXi1SRZ0sGWz5VGi3MGPrPUBKU8Dh4wO8MKxaEW2LvInxpDPXIguk
	 5wPxhHgThLoWtbBUxjbULYLMgFJ2oge0lcHXu2PXArjaN1N0aChiCf3RcQ2HWpMm1n
	 38O13XrlGG2AywHmOTVRrQzJyAwzA9QQM6eiPzfLo+1UgidhiOx6yNecSE8V0iUzOg
	 nOJSHNRP8Xm9m9hBKJF/Q5M2q1oHicHkg2GkhCSVHLABYHDtgALYX8ldfkM6lspMkq
	 maa9xUyDfc44eoCXHv+qVcAwJVimVcMy3AF0nSubIiPIxZQX1SQmuE8/Q52CDXIb+c
	 AhXtvK/kW66BNqZCbOMORbF3JARTGOasbivCEW4QKgENjokxmCNBBGT+aF4yRAS+7A
	 c3D3BWxbJnm8k1qycSF+wpi6FiCUw+p/F8PBrS19btJtteg/zcd74BhoTu47FGknEv
	 Dj7uXEyb4HDkbHLEJxBF99b1IYkzRbSE3QinhZtQi7JLardqU99nhr5ItHmxnyqD4A
	 BNBBmX+s7AEEkH5BV3JHoZYnDBbFxX6zn/YI5eJ1iXSnGapM2M1xB8d8VwLVplqaPB
	 jkPyweILNTbcnWlJFhjl/RmDRPG98n4aw8iU/0trpX4eYL8i83IiBQF6U+yLx/XyuY
	 P5S0gpE/bJzBz5vObQkZBJEQ=
Received: by mail-pf1-f198.google.com with SMTP id d2e1a72fcca58-82fa1c94b37so4916676b3a.0
        for <linux-erofs@lists.ozlabs.org>; Mon, 11 May 2026 01:59:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778489947; x=1779094747;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=S6S3tmCtghAcRufgbPHFJ9gmk8ioXC1goBcILuNfLMI=;
        b=oVY2YlhvoJN8yLVa16X7aNYmwigmwSDWSt3XdeYmh6AYFCz83IQX3ErikazTw54Iwx
         ykx0+Dr8Hi+LD6Ul2STWOGMgg5xpD/19ADCwus6hWaH7CK5sfb6/N1nEVGB5zu8Bye9h
         0bR/rYx3/aJWQIZEh0uwWhq2Ha+GpGpBLvsZJEP+HIFzlFf/tJXdW8QRS/qqxHqk1TDz
         x32hNrUgs1m5HggYORnFjtmnz5VyIVcugxXHpxKrtQ889og8pzrFSyYLltosL1YR3FTJ
         4SKzHwDsHA0k8HGCE9EOtJlxfkyho/94Nw06TiCVwUf9o1wXn4Dv78IJQnFZsD7YVLz4
         WQTQ==
X-Forwarded-Encrypted: i=1; AFNElJ8kbP02wm69lYQJXqm/nZyGYZTPPYqvOSO1NMVK2tC4BfjreTjUOIZb8WUbGK83Jk6GqhC5UW/HopkQlg==@lists.ozlabs.org
X-Gm-Message-State: AOJu0YzlcgRaeS3Wp2fn/bXoB54+P+PhJCwwmUzf90afTJybxibBSNJB
	xbJgmz2fJ7KZGoROYeFklWi/esN+gK5xBxn8gmKzgq6WHHWBB44FF/lfIvfE373X09mDjxMOhk1
	+J1T56pk/VGKEZIHyEHFwXMiBx/qmUqmlaiQkUBYuamcCN7qQJQ0/ONp+UXSo4b0IF4iZPkAc6O
	1sFlx9cQ==
X-Gm-Gg: Acq92OGA0UGjbHYcn6Q06ciuQtKq4mRPLePtyyYH0Rb09+NzSqFOjrDEbHsws56Pht+
	sCoKXBbHnDo/gYWM3xdwXDZHLQ0cvJVrUNdOlQXIPxE+fNivw0XYZya67wxZWpP8nOfw5F+FskX
	xaTLX/mrb8I1bg8JHe3dIevcJbx2M5saKjA7cx2CwGd+jQ07UwBrkApZq6zHtFuQJGWt/TSLwSL
	x9g3RTSPafcYWfpMbzWBJ9+L2IAj4PuAT1MQ4hb41cV+OKunGURHMvn8YnGwBR0hY7stxVt1+EY
	mF01P+QGyiiV8X9UifsN66gsuRhU8hgJSvvC9dbPGp9R7MsFxXA0qhTqAck/+44jQOYGXMfgYES
	G4TQwwGfjifQ+m9mKA62RZBQsLWlrNzluYRqmT8fjO3Rd9HBExYClMwPNtntqjH5L5McVE/0pmE
	+EOLKc4otW0ycHU55jZSH7+e0E3A==
X-Received: by 2002:a05:6a00:3e22:b0:82f:7888:e2fa with SMTP id d2e1a72fcca58-83bb7fb5438mr14346694b3a.17.1778489947353;
        Mon, 11 May 2026 01:59:07 -0700 (PDT)
X-Received: by 2002:a05:6a00:3e22:b0:82f:7888:e2fa with SMTP id d2e1a72fcca58-83bb7fb5438mr14346660b3a.17.1778489946868;
        Mon, 11 May 2026 01:59:06 -0700 (PDT)
Received: from noble-uboot.tail872496.ts.net (124-218-37-86.cm.dynamic.apol.com.tw. [124.218.37.86])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-839679c80e7sm24034367b3a.31.2026.05.11.01.59.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 May 2026 01:59:06 -0700 (PDT)
From: Aristo Chen <aristo.chen@canonical.com>
To: u-boot@lists.denx.de
Cc: Aristo Chen <aristo.chen@canonical.com>,
	Huang Jianan <jnhuang95@gmail.com>,
	Tom Rini <trini@konsulko.com>,
	Joao Marcos Costa <joaomarcos.costa@bootlin.com>,
	Richard Genoud <richard.genoud@bootlin.com>,
	Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	linux-erofs@lists.ozlabs.org
Subject: [PATCH v1 1/1] test: fs: Use shared generate_file from utils
Date: Mon, 11 May 2026 08:58:50 +0000
Message-ID: <20260511085857.3933053-1-aristo.chen@canonical.com>
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

test_fs/test_erofs.py and test_fs/test_squashfs/sqfs_common.py both
defined a generate_file() helper that writes a file of a given size
filled with 'x'. The two functions were functionally identical and
differed only in parameter names and docstrings.

Move the helper into the existing test/py/utils.py module, which is
the established home for generic test utilities (md5sum_file,
PersistentRandomFile, attempt_to_open_file). Update both call sites
to use it.

Signed-off-by: Aristo Chen <aristo.chen@canonical.com>
---
 test/py/tests/test_fs/test_erofs.py           | 16 ++++----------
 .../test_fs/test_squashfs/sqfs_common.py      | 22 +++++--------------
 test/py/utils.py                              | 13 +++++++++++
 3 files changed, 22 insertions(+), 29 deletions(-)

diff --git a/test/py/tests/test_fs/test_erofs.py b/test/py/tests/test_fs/test_erofs.py
index a2bb6b505f2..cec803256ac 100644
--- a/test/py/tests/test_fs/test_erofs.py
+++ b/test/py/tests/test_fs/test_erofs.py
@@ -6,19 +6,11 @@ import os
 import pytest
 import shutil
 import subprocess
+import utils
 
 EROFS_SRC_DIR = 'erofs_src_dir'
 EROFS_IMAGE_NAME = 'erofs.img'
 
-def generate_file(name, size):
-    """
-    Generates a file filled with 'x'.
-    """
-    content = 'x' * size
-    file = open(name, 'w')
-    file.write(content)
-    file.close()
-
 def make_erofs_image(build_dir):
     """
     Makes the EROFS images used for the test.
@@ -36,15 +28,15 @@ def make_erofs_image(build_dir):
     os.makedirs(root)
 
     # 4096: uncompressed file
-    generate_file(os.path.join(root, 'f4096'), 4096)
+    utils.generate_file(os.path.join(root, 'f4096'), 4096)
 
     # 7812: Compressed file
-    generate_file(os.path.join(root, 'f7812'), 7812)
+    utils.generate_file(os.path.join(root, 'f7812'), 7812)
 
     # sub-directory with a single file inside
     subdir_path = os.path.join(root, 'subdir')
     os.makedirs(subdir_path)
-    generate_file(os.path.join(subdir_path, 'subdir-file'), 100)
+    utils.generate_file(os.path.join(subdir_path, 'subdir-file'), 100)
 
     # symlink
     os.symlink('subdir', os.path.join(root, 'symdir'))
diff --git a/test/py/tests/test_fs/test_squashfs/sqfs_common.py b/test/py/tests/test_fs/test_squashfs/sqfs_common.py
index d1621dcce3a..b366bde5f49 100644
--- a/test/py/tests/test_fs/test_squashfs/sqfs_common.py
+++ b/test/py/tests/test_fs/test_squashfs/sqfs_common.py
@@ -5,6 +5,7 @@
 import os
 import shutil
 import subprocess
+import utils
 
 """ standard test images table: Each table item is a key:value pair
 representing the output image name and its respective mksquashfs options.
@@ -66,19 +67,6 @@ def init_standard_table():
     for key, value in zip(STANDARD_TABLE.keys(), opts_list):
         STANDARD_TABLE[key] = value
 
-def generate_file(file_name, file_size):
-    """ Generates a file filled with 'x'.
-
-    Args:
-        file_name: the file's name.
-        file_size: the content's length and therefore the file size.
-    """
-    content = 'x' * file_size
-
-    file = open(file_name, 'w')
-    file.write(content)
-    file.close()
-
 def generate_sqfs_src_dir(build_dir):
     """ Generates the source directory used to make the SquashFS images.
 
@@ -107,20 +95,20 @@ def generate_sqfs_src_dir(build_dir):
 
     # 4096: minimum block size
     file_name = 'f4096'
-    generate_file(os.path.join(root, file_name), 4096)
+    utils.generate_file(os.path.join(root, file_name), 4096)
 
     # 5096: minimum block size + 1000 chars (fragment)
     file_name = 'f5096'
-    generate_file(os.path.join(root, file_name), 5096)
+    utils.generate_file(os.path.join(root, file_name), 5096)
 
     # 1000: less than minimum block size (fragment only)
     file_name = 'f1000'
-    generate_file(os.path.join(root, file_name), 1000)
+    utils.generate_file(os.path.join(root, file_name), 1000)
 
     # sub-directory with a single file inside
     subdir_path = os.path.join(root, 'subdir')
     os.makedirs(subdir_path)
-    generate_file(os.path.join(subdir_path, 'subdir-file'), 100)
+    utils.generate_file(os.path.join(subdir_path, 'subdir-file'), 100)
 
     # symlink (target: sub-directory)
     os.symlink('subdir', os.path.join(root, 'sym'))
diff --git a/test/py/utils.py b/test/py/utils.py
index ca80e4b0b0a..e8971502509 100644
--- a/test/py/utils.py
+++ b/test/py/utils.py
@@ -51,6 +51,19 @@ def md5sum_file(fn, max_length=None):
         data = fh.read(*params)
     return md5sum_data(data)
 
+def generate_file(file_name, file_size):
+    """ Generates a file filled with 'x'.
+
+    Args:
+        file_name: the file's name.
+        file_size: the content's length and therefore the file size.
+    """
+    content = 'x' * file_size
+
+    file = open(file_name, 'w')
+    file.write(content)
+    file.close()
+
 class PersistentRandomFile:
     """Generate and store information about a persistent file containing
     random data."""
-- 
2.43.0


