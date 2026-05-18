Return-Path: <linux-erofs+bounces-3415-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EB0DDCD4F50
	for <linux-erofs@archiver.kernel.org>; Mon, 18 May 2026 05:58:13 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4gJnCZ4sQmz3dS5;
	Mon, 18 May 2026 15:58:02 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=185.125.188.120
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1779083882;
	cv=none; b=TQd/JkhE7hjX+KxpCC9s+Ei8pEd3mxxHEQSC9Tt02BDjxoOl+upoVTgX31pF4z5Uic7ynXcmfAGQy4yTJ2aTOzP9elLme7FY50Bwpx0CBh0XI5f/ew/3Epiz6gjZ6MSYoCKpS2y8142p5lR8pJKc+ChKUae1nfyFGARX6AEbE2T922817flGZFmMMSth/ogPl8leJo0Ku+TlWt+f6k++Njv67wbx6KxDXgCFBa5fXMsnM+2m04JZYroqxQe1ksSmGtpdev3B8efoeaGTq/D4isyTxEFNAR/vamjWOX/xFekzDsJ7XLvBoPo+K3pa8ybpakhAXQFZ59qYWNKU+sJl8Q==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1779083882; c=relaxed/relaxed;
	bh=xEWQS2T7OkzeUKBXKc2GcKYGi1ur+BDSuuyyEdvwzjw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R4Nr9JMwCn1+VYHqlZwAc2aAdsFEQFEzfth2QwtXyimA2mGhps/Lypn+X3uyLxzasYCDOfRFVHH36Znhg9WSN5WNAT369dBAyTW5kaT8s9hSySnR4vBW6scFrknRE40/cIh25B1shRxUTms24b+OaJ/ojH+I6sofc+SU+p55BRbLlfKU9O4iV682E7ZQPrlpUvNf05fXJrtuLJLeIA35mJwxzeelnwqSJ6bldTc+Dox9EvR/swK6OSYp/oOQkeZuHPYSMgbHSCplp0gonlbxXOyfsWL05NzIn9ykE1MUbCWyZPYRieJRXnmFYXXNfT7LbNNnGLQAB6F8763Jm/wuWw==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=reject dis=none) header.from=canonical.com; dkim=pass (4096-bit key; unprotected) header.d=canonical.com header.i=@canonical.com header.a=rsa-sha256 header.s=20251003 header.b=OBBOWlAo; dkim-atps=neutral; spf=pass (client-ip=185.125.188.120; helo=smtp-relay-canonical-0.canonical.com; envelope-from=heinrich.schuchardt@canonical.com; receiver=lists.ozlabs.org) smtp.mailfrom=canonical.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=reject dis=none) header.from=canonical.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (4096-bit key; unprotected) header.d=canonical.com header.i=@canonical.com header.a=rsa-sha256 header.s=20251003 header.b=OBBOWlAo;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=canonical.com (client-ip=185.125.188.120; helo=smtp-relay-canonical-0.canonical.com; envelope-from=heinrich.schuchardt@canonical.com; receiver=lists.ozlabs.org)
Received: from smtp-relay-canonical-0.canonical.com (smtp-relay-canonical-0.canonical.com [185.125.188.120])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4gJnCY6Z2Sz3dRP
	for <linux-erofs@lists.ozlabs.org>; Mon, 18 May 2026 15:58:01 +1000 (AEST)
Received: from LT03 (dynamic-046-114-109-175.46.114.pool.telefonica.de [46.114.109.175])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-canonical-0.canonical.com (Postfix) with ESMTPSA id 8053041799;
	Mon, 18 May 2026 05:57:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
	s=20251003; t=1779083878;
	bh=xEWQS2T7OkzeUKBXKc2GcKYGi1ur+BDSuuyyEdvwzjw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version;
	b=OBBOWlAo1R3Q/xHOHF59c6mcHSdesPg9uE9WvCU/+nRZSENoqif1txGBPTkdgFFjm
	 W+tBOiigogPxzGYNROiEtQG+lDy02XFzgAGZ5UAhinlQi7YOQ6pnk6GeuMvvyrRU9X
	 Xanvu244fFvPMuMMTE9fZAhaCCyNoEO5043GzONFM9AZxqu9l0olGAm3Oeze5IIdx/
	 iXt+J5NfxQkoIaO+TyrORElsZWHOfsxn1ixtnzxz4YUoujhZKXSohhLF0XyCFNG2os
	 Zu/K96yDSxGwMEv0gFpInkBJEqrQPQsYF9l8pPVrMGB83jiDjXXltfmHQzSilYRVMv
	 SS6XM8MslUYHWYZMdOq+WYe/uWYjYyuE/7XQihkxgUrh+M9GoGjR84p6qNn6fBpbd1
	 KPQF0J9p05T8zlof/vtTfoX+9YEhQG3uATSQki+h+eZ5uGTxq8+lXUbvBvMR58aDbF
	 vydDajlrFEfy/ksKsg/ALeNrMILrWC7pUrZchocek5IgJKzcP6RsVq1ur1fh3m5fDO
	 xzmNiYGNZH05PT55BfptNOetE3hmbLxAq3ZjmaiR2Nk4pPhAlvns5j9hqsckecAuOU
	 oM9LtFsV0phXjl9YEPCkVSmHD54u3RJroVfRd0caqOtZFGDLE3Kzn05R3b13ErqsCm
	 sxBq04cf+WXcVx7imNnqcoUQ=
From: Heinrich Schuchardt <heinrich.schuchardt@canonical.com>
To: Tom Rini <trini@konsulko.com>
Cc: Simon Glass <sjg@chromium.org>,
	Huang Jianan <jnhuang95@gmail.com>,
	Quentin Schulz <quentin.schulz@cherry.de>,
	Tony Dinh <mibodhi@gmail.com>,
	=?UTF-8?q?Timo=20tp=20Prei=C3=9Fl?= <t.preissl@proton.me>,
	Francois Berder <fberder@outlook.fr>,
	Andrew Goodbody <andrew.goodbody@linaro.org>,
	Daniel Palmer <daniel@thingy.jp>,
	Varadarajan Narayanan <varadarajan.narayanan@oss.qualcomm.com>,
	Sughosh Ganu <sughosh.ganu@arm.com>,
	Ilias Apalodimas <ilias.apalodimas@linaro.org>,
	Peng Fan <peng.fan@nxp.com>,
	Marek Vasut <marek.vasut+renesas@mailbox.org>,
	u-boot@lists.denx.de,
	linux-erofs@lists.ozlabs.org,
	Heinrich Schuchardt <heinrich.schuchardt@canonical.com>
Subject: [PATCH 9/9] test: test_erofs: adjust expected ls output
Date: Mon, 18 May 2026 07:57:28 +0200
Message-ID: <20260518055728.178507-10-heinrich.schuchardt@canonical.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260518055728.178507-1-heinrich.schuchardt@canonical.com>
References: <20260518055728.178507-1-heinrich.schuchardt@canonical.com>
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

With the addition of the date field the space between columns in the ls
output has been reduced. Reflect this in the expected lines of the erofs
test.

Signed-off-by: Heinrich Schuchardt <heinrich.schuchardt@canonical.com>
---
 test/py/tests/test_fs/test_erofs.py | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/test/py/tests/test_fs/test_erofs.py b/test/py/tests/test_fs/test_erofs.py
index a2bb6b505f2..0531f99cd9c 100644
--- a/test/py/tests/test_fs/test_erofs.py
+++ b/test/py/tests/test_fs/test_erofs.py
@@ -73,8 +73,8 @@ def erofs_ls_at_root(ubman):
     slash = ubman.run_command('erofsls host 0 /')
     assert no_slash == slash
 
-    expected_lines = ['./', '../', '4096   f4096', '7812   f7812', 'subdir/',
-                      '<SYM>   symdir', '<SYM>   symfile', '4 file(s), 3 dir(s)']
+    expected_lines = ['./', '../', '4096 f4096', '7812 f7812', 'subdir/',
+                      '<SYM> symdir', '<SYM> symfile', '4 file(s), 3 dir(s)']
 
     output = ubman.run_command('erofsls host 0')
     for line in expected_lines:
@@ -84,7 +84,7 @@ def erofs_ls_at_subdir(ubman):
     """
     Test if the path resolution works.
     """
-    expected_lines = ['./', '../', '100   subdir-file', '1 file(s), 2 dir(s)']
+    expected_lines = ['./', '../', '100 subdir-file', '1 file(s), 2 dir(s)']
     output = ubman.run_command('erofsls host 0 subdir')
     for line in expected_lines:
         assert line in output
@@ -97,7 +97,7 @@ def erofs_ls_at_symlink(ubman):
     output_subdir = ubman.run_command('erofsls host 0 subdir')
     assert output == output_subdir
 
-    expected_lines = ['./', '../', '100   subdir-file', '1 file(s), 2 dir(s)']
+    expected_lines = ['./', '../', '100 subdir-file', '1 file(s), 2 dir(s)']
     for line in expected_lines:
         assert line in output
 
-- 
2.53.0


