Return-Path: <linux-erofs+bounces-3411-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6F34DCD343F
	for <linux-erofs@archiver.kernel.org>; Mon, 18 May 2026 05:58:04 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4gJnCX47rwz3dRH;
	Mon, 18 May 2026 15:58:00 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=185.125.188.120
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1779083880;
	cv=none; b=Ne+TQTZnUOra+XUVgnoEDcULbNDPcE/Z/d/AMc5fxSKks6Lx7UyjIaq8rd7wirsl75t5zpA8EeyUqmG7PMRlHIuXgYsE58fvbyA+xJPxSfOQ98MXIjqmf/EhSSFsIcBkxzIKJMtRzH96TklEp47k+nUFwOTpyqFNulgFGc4uXqeVrG0/5zJCikBbXQ3zTvY1bzXwMfP1Yb/+Lh22VY3PXRMdxQcnqyymTgqRDDR1QHanoagq2xOtf5bHt8/wzLndyNq7fZAsxzMrHB9fsKB4MUcVLtBUoqLjKSl6Usl+ekPp9wHHbfvS+V/H6da1ROXN78QLs+qWMfodT8H355cMjA==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1779083880; c=relaxed/relaxed;
	bh=OZCpZu/c2ag8M1KotSGygZRzDu6zm5Wmre3bZsCXr94=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=WuZnSf1wWVKcT+Q97WqY6A6nXKNnlSpw2J5YiXK0A6uhG+yQsa/SyQ2CYfk5M3szWcWX3ZZj4YiE8SW1pxJLnLfeOcagqA480bQOJtCpnZFPy6gdpBMU4jF6kUsBMejSnxRYqo0vxvY4s30r3lls9e6QRqSIYaIh7Q8tDgmg+S1+9vyETEiO0d1quHuWqeM9Z4HdbpWTOH8sD3jGYQ0VnAak1wEFhpUBoTr7yI3S/l5LgoJWj8PIwD8E3gVfcN3KoLfqG+RkqNghe08yJPlYGHfG9JWCMvPbEbH0lD5lKAfMuZLWWUy9sbSnXevnv6PKltRTn5Cuz2IoqtlYV0RtDA==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=reject dis=none) header.from=canonical.com; dkim=pass (4096-bit key; unprotected) header.d=canonical.com header.i=@canonical.com header.a=rsa-sha256 header.s=20251003 header.b=eW4qI1JP; dkim-atps=neutral; spf=pass (client-ip=185.125.188.120; helo=smtp-relay-canonical-0.canonical.com; envelope-from=heinrich.schuchardt@canonical.com; receiver=lists.ozlabs.org) smtp.mailfrom=canonical.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=reject dis=none) header.from=canonical.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (4096-bit key; unprotected) header.d=canonical.com header.i=@canonical.com header.a=rsa-sha256 header.s=20251003 header.b=eW4qI1JP;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=canonical.com (client-ip=185.125.188.120; helo=smtp-relay-canonical-0.canonical.com; envelope-from=heinrich.schuchardt@canonical.com; receiver=lists.ozlabs.org)
Received: from smtp-relay-canonical-0.canonical.com (smtp-relay-canonical-0.canonical.com [185.125.188.120])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4gJnCS4p27z3dRR
	for <linux-erofs@lists.ozlabs.org>; Mon, 18 May 2026 15:57:54 +1000 (AEST)
Received: from LT03 (dynamic-046-114-109-175.46.114.pool.telefonica.de [46.114.109.175])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-canonical-0.canonical.com (Postfix) with ESMTPSA id F3DF440A19;
	Mon, 18 May 2026 05:57:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
	s=20251003; t=1779083870;
	bh=OZCpZu/c2ag8M1KotSGygZRzDu6zm5Wmre3bZsCXr94=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version;
	b=eW4qI1JPnxllEZ3juCi/YoB84yR1JKObD9+X9b+sHs+5Q07vEPsP6mKYP5xEBHGZy
	 dxMxMm+OYx4WVWJBDrjPUOFQ3DkEW/+Z8g+XDIWHKNhypA7inRLI+E58zENrAu2H3l
	 hCT1yz5CaHD3ZRe1+ybz78GRBl6wDBLkj5Wyub9txKkbDKdSA9zwdUJ4qBFPppRYos
	 4ukjn5R0bHqmavZLJ49jcgaRX+57v3zvtjjU/tywjLMv8pAmaQ8Ein/eju/PIECtiB
	 7j5YvSui9ViGpzB4NSTjp8M7/Ypv7ztChvO2Vl4b2mi1RBgpIaQN+pqd+ZAovz5lly
	 kYM9arsQcs/5qKV95/xEEoqEzke7QetUxkD9cnsadqj6aY/Nt2x0BdBV7fwcQ6sFYE
	 wNaAplRj5Yh6+ZwGZlMX0pgbCFGL51OKbCd8jUtDD0sp/0d94ZghdQIfYcAwdMFkBK
	 UU9JDD3KtqTlbMRW/nN8NSPkrV/sS3y9xL05Mu6CLLBDv/N+uSCB7YODGX26ug/BWO
	 jIm75Kfeyh9G0/akc7c0BUNyk2EZiILYVur62qOjUe+v7iFhzum8j9MDFbsRrqiHuU
	 HZCQQkJAM+d5cHXn7GZ5SP4EnSClSFe3bEHQDt5FQmik7m1Oh/y1qNVsxxfdVpyZo/
	 z6PybPceYE+YN+tb4L94du6Q=
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
Subject: [PATCH 0/9] fs: add change date to ls output
Date: Mon, 18 May 2026 07:57:19 +0200
Message-ID: <20260518055728.178507-1-heinrich.schuchardt@canonical.com>
X-Mailer: git-send-email 2.53.0
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

The ls command currently only displays the size and name of files and
directories.

* Add the change date to the output on FAT and ext2/3/4.
* Use the actual date when updating the change date in ext2/3/4
  file-systems.

Heinrich Schuchardt (9):
  fs: move struct fstype_info definition to top of file
  fs: print change date in directory listing for FAT
  fs: ext4: print change date in directory listing
  fs: ext4: don't read time fields in XPL
  fs: ext4: set inode timestamps on write
  test: Probe RTC early in dm_test_host()
  test: fs: allow optional date field in ls output assertion
  test: env: allow optional date field in ls output assertion
  test: test_erofs: adjust expected ls output

 fs/ext4/ext4_write.c                |  41 ++++++++-
 fs/ext4/ext4fs.c                    |   8 +-
 fs/fat/fat.c                        |   2 +-
 fs/fs.c                             | 127 ++++++++++++++++++----------
 test/dm/host.c                      |  13 +++
 test/py/tests/test_env.py           |   2 +-
 test/py/tests/test_fs/test_basic.py |   4 +-
 test/py/tests/test_fs/test_erofs.py |   8 +-
 8 files changed, 146 insertions(+), 59 deletions(-)

-- 
2.53.0


