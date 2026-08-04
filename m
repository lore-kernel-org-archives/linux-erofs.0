Return-Path: <linux-erofs+bounces-4099-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4B208C55184
	for <linux-erofs@archiver.kernel.org>; Tue,  4 Aug 2026 03:32:37 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hDfHl1rp2z2yMl;
	Tue, 04 Aug 2026 13:32:35 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2a00:1450:4864:20::331"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1785814355;
	cv=none; b=VAJwull7+DxhbbuD5gB6Yv0MHeev728HqGSvlKZxlZlUeE8BiJIv2v0vpZoH1cwu2+HdNQAGsuzhJ/7mey4m4F5fO/j2AUjCdA4D/R1GINOxKZLhQzsqFgyBUm8t6NHgCGybOecmz7modPVIB4dAOjqzSCbGonYAJk4i0evqeSQ56ZpHUHQAbLzdpHk6kOoayXykDEPKrIGozkOSHLJbjAZfyXyBupWh5FNXxhZPEKOk6o5m7Z1Gi5I1v/k69q+53n6TT8fnFraYYjTI6J1pS84P8nVjmN+cgZWqSXEFDAVgHPtaQoumgSI/eWS1ib6CzVOaZRmvFBQHZ2hdJMi3Ug==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1785814355; c=relaxed/relaxed;
	bh=o98NXqnAYHwQybxb9Ge4hv5AGm9QJlt2H3CbqlJwKRU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=HyU/sMTwzKORDr+qwKjDYf/W8ztfsuaP2gj6D2D5g8l5Rc6WlpI4CgsewLW9VUDTWGRVJPW20ZcJSH1+bEk6kI8ZPoM/Vqypyb412VYbJ2/+CZQgavP4GMLZNsQntB1ygD316VcaGn9zrIDj6oH65IsyuZ0ubweBk7t2husDltEn10fSPfQbU+S9d2z9UU3CooA9KHFGyvF4LZOA4QR+6SYDbjxTrhx4ivXeFo5EobLd2QbKaobV7zqOI3HfqlLeM6wav4eq2RCbdc44jpttcmsJXhwQuYiaAvWcsKUWAFu8ecVkDbOTn2wO0LeuZ0J2lnOBJ2ZiB+DEFsFWQ2RacA==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=none (p=none dis=none) header.from=amutable.com; dkim=pass (2048-bit key; unprotected) header.d=amutable-com.20251104.gappssmtp.com header.i=@amutable-com.20251104.gappssmtp.com header.a=rsa-sha256 header.s=20251104 header.b=K3lk5fJV; dkim-atps=neutral; spf=pass (client-ip=2a00:1450:4864:20::331; helo=mail-wm1-x331.google.com; envelope-from=martin@amutable.com; receiver=lists.ozlabs.org) smtp.mailfrom=amutable.com
Authentication-Results: lists.ozlabs.org; dmarc=none (p=none dis=none) header.from=amutable.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=amutable-com.20251104.gappssmtp.com header.i=@amutable-com.20251104.gappssmtp.com header.a=rsa-sha256 header.s=20251104 header.b=K3lk5fJV;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=amutable.com (client-ip=2a00:1450:4864:20::331; helo=mail-wm1-x331.google.com; envelope-from=martin@amutable.com; receiver=lists.ozlabs.org)
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hDfHh6Hfjz2xns
	for <linux-erofs@lists.ozlabs.org>; Tue, 04 Aug 2026 13:32:32 +1000 (AEST)
Received: by mail-wm1-x331.google.com with SMTP id 5b1f17b1804b1-4954dff6536so18730475e9.0
        for <linux-erofs@lists.ozlabs.org>; Mon, 03 Aug 2026 20:32:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amutable-com.20251104.gappssmtp.com; s=20251104; t=1785814348; x=1786419148; darn=lists.ozlabs.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=o98NXqnAYHwQybxb9Ge4hv5AGm9QJlt2H3CbqlJwKRU=;
        b=K3lk5fJVoVM0jTGwg2+RbL81eVqTOziiIRsrPfWRgl12pFQJwkMw2yP7pbX46lk1K4
         iBJmUy36lcHQuBm4tRAhSWrfgr/oKmHxJIyF2xoEm1hcqkWYHlMSclPvusvnf6EOT/52
         TiN4Y0/3yF1v5Rsrrd7wl2iW8W921Zsdg+xnju4Mu0d2vj65hLiI9Z/bBH07/O02dYGL
         SEnSFD76P3FGx5QtJFUTqBz7OdDzDqNH8QEb3yPw8OCrElRoOj97WId7Ymv5K7PeYZ8F
         8FOMNR9U9hAzp3R7KmoFg3IcEX7zBQ+aryw1Jnu7dIrXPH0waE8QKsz6fDV33rvmhb1b
         pjQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785814348; x=1786419148;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=o98NXqnAYHwQybxb9Ge4hv5AGm9QJlt2H3CbqlJwKRU=;
        b=CzKkdyTXsNccs15K4WWwfKgDA+uVIaLZODxdGv89YvX7T8yOO74cmTOwhUuFLZpBlf
         S7oWLxbgyZo4dALN+XgXhOV5Za9D7HAznLx2IaQz5KqgZh2qr/a+ITnXdPBywu3grrYx
         TL9S4KKXmXuLtR67Hw70KjnkDhjgRJ5ixk6W69vu1gnZ5ZrjBx0WOeLySDd20+i5kvZR
         yvfngHgX35DpJL6YL94rimld0uDqDFo5JOblj3RRESxBcPUEhePZqNpBuTiDPUZssAMo
         3sp4idtExom7Cs7zw0cEOGIdprRedf+PZGMzJvqYh7/540038FA4u4gfk5qiGTxxaYIB
         uy7w==
X-Gm-Message-State: AOJu0YyQHREmhhyYY1765Lp1IEHUY0t2VUQrkMCrTCQoma4I2KvJzddG
	F14SMJzzbnuNP2Pr6OqI2cOeGBGWGpBE+DHSW9XgU1DYOM03NnWed570nsG2BkXpHRzd3gbfaa/
	DYy7GhK2D
X-Gm-Gg: AR+sD12EoEx9KaqdToBRAWNojLJPNSG867PtVONpXi5e4Az52uA/vjB3ETPzhAZYhCu
	jHuEtsyOJVlV6/xm0Y3RWmZoeCFNXxvEhWwuY/oGkx40iXi/j8kDgyLbiFkNJ24OIePOHGzSHwo
	b19BDmg1VORI7Wa4MkVhkg01IRwTgckTgZgDjF9S0PmtMdXoAfKJRbMDDVvWfqMSujSutSF29Ao
	Xxq/2hLKad6ls5tv67MMry0pRY5Hpdp7wbjizfSNytkZ34UPJva0QUf5zRYeg9Sc9nz1ntdDZuf
	BVqnVI8deqkuOuzck0DYNpQcc7JrtYJUSC6tYl86c802xGC1DHm8JRfXgUS/wJAP46cqX4nOpcM
	aMKgzNZZfAVCLyCML6mEjk+h2dAsOHr8kxbgzkrkz5MBTG1hZJakmHSrQ+2Hhqn/eTmD3TW2W4Y
	oSCZ4mkvLa9QFa0kBC1cE28d4qq5GI0wij1qQxqr0zPM037TKmLO3IpKtLuXyB3xf8xgb96MMGe
	44tCYnqq1ex9t12ny2DQIEUB2Hzruxe1eNL+7GnTcUzrFsy2fWs28tduBE=
X-Received: by 2002:a05:6000:2211:b0:47f:853d:4768 with SMTP id ffacd0b85a97d-47fd72b518emr31588300f8f.20.1785814348046;
        Mon, 03 Aug 2026 20:32:28 -0700 (PDT)
Received: from fedora.fritz.box (p200300c78f45f4002fc0e22e545c127a.dip0.t-ipconnect.de. [2003:c7:8f45:f400:2fc0:e22e:545c:127a])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47fd42d91bfsm41286329f8f.15.2026.08.03.20.32.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Aug 2026 20:32:27 -0700 (PDT)
From: Martin Pitt <martin@amutable.com>
To: linux-erofs@lists.ozlabs.org
Cc: Gao Xiang <xiang@kernel.org>,
	Yifan Zhao <zhaoyifan28@huawei.com>,
	Martin Pitt <martin@amutable.com>
Subject: [PATCH 0/3] erofs-utils: tests: cover the canonical xattr order
Date: Tue,  4 Aug 2026 05:32:11 +0200
Message-ID: <20260804033214.211267-1-martin@amutable.com>
X-Mailer: git-send-email 2.55.0
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

A test for b260119b8edb ("erofs-utils: mkfs: emit an inode's xattrs in a
canonical order"), plus two portability fixes that I ran into along
the way. Based on experimental-tests (a3b00c4).

The test stages the same tree twice with the same attributes set in
opposite order and compares the two images, so it needs neither root nor a
mount. It is red without b260119b8edb and green with it. That commit is
currently only in experimental, so the test fails as long as
experimental-tests is run without it.

Martin Pitt (3):
  erofs-utils: tests: fix broken loop in POSIX shells
  erofs-utils: tests: look up programs with command -v
  erofs-utils: tests: check that the xattr layout is order-independent

 tests/Makefile.am   |  5 ++-
 tests/common/rc     |  8 ++---
 tests/erofs/021     |  2 +-
 tests/erofs/028     |  6 ++--
 tests/erofs/032     | 77 +++++++++++++++++++++++++++++++++++++++++++++
 tests/erofs/032.out |  2 ++
 6 files changed, 91 insertions(+), 9 deletions(-)
 create mode 100755 tests/erofs/032
 create mode 100644 tests/erofs/032.out

-- 
2.55.0


