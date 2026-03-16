Return-Path: <linux-erofs+bounces-2719-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AC26DEFCBB6
	for <linux-erofs@archiver.kernel.org>; Mon, 16 Mar 2026 06:14:46 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4fZ4Yx1p2cz2xln;
	Mon, 16 Mar 2026 17:14:45 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2607:f8b0:4864:20::62b"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1773641685;
	cv=none; b=limk61iJ7/R4qtSSVWWDqvjQjvWmpa2P7ZYy8zvpqjYk9CqPHVlD52fhJMVwK7n+GD8A7kliO30/dywGYtlRA+d2OASnr7EOXIaW/Cv5PvkjIiI1JOxZO+VcZXn5tVHrYjCpYTXKmLSdW845Vnc4JGc3oKNfvBY+wzOjb9U83AQpbCNDDHGKylb0Wbt2uWK95QbseSlQif6NKuo1N3JhyHh3MzBCbptmKESc3y68tb2ptuURqKg4k9YaAU9Obd+qbz4+MiHCre5Mipmg7TFNeeQBM4B8SalRsaD/oMAIEQ9b8aHsoScXrVlp16EdR22TzFUUmB0BMQFXznUi0p3DJg==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1773641685; c=relaxed/relaxed;
	bh=cNPDzeYcOrLN8zuO7rEFIbyP0W/cSDyRsshEgYOTCs4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Crm2WqKHaiSvFuJSVKccadg7akS3abkebAN6zEq1/piBtAReixcz312ahQygN56ruJYgM2jPKu4Yw02drBwlWnVog5L/IlJ8TSqWmh6HQXn8+Rw3VacAnLtxPheINOGnWiE+TcTD+NNr8h6cw9OTqHG1S4MnOnaZMyVX503J27UufyW5yGYOJPyhyZSXBf8lpxys1iJO2oFfcBf2BW144oYSKXrv/5w+aLxUdibsuKmOk5i3Wdsuff3AGbe3czrGTeu1IykW537iu+86LRNKZDPwhyr+MMxtC7VYgEVWRZSkW582k4cUzf2smwuoCNT2GB4L9wVO6IYr15WPzp0cOw==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=gmail.com; dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20230601 header.b=UJmOoTpx; dkim-atps=neutral; spf=pass (client-ip=2607:f8b0:4864:20::62b; helo=mail-pl1-x62b.google.com; envelope-from=singhutkal015@gmail.com; receiver=lists.ozlabs.org) smtp.mailfrom=gmail.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20230601 header.b=UJmOoTpx;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=gmail.com (client-ip=2607:f8b0:4864:20::62b; helo=mail-pl1-x62b.google.com; envelope-from=singhutkal015@gmail.com; receiver=lists.ozlabs.org)
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4fZ4Yw3vPMz2xlP
	for <linux-erofs@lists.ozlabs.org>; Mon, 16 Mar 2026 17:14:44 +1100 (AEDT)
Received: by mail-pl1-x62b.google.com with SMTP id d9443c01a7336-2aea8c13d94so8123105ad.3
        for <linux-erofs@lists.ozlabs.org>; Sun, 15 Mar 2026 23:14:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773641682; x=1774246482; darn=lists.ozlabs.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=cNPDzeYcOrLN8zuO7rEFIbyP0W/cSDyRsshEgYOTCs4=;
        b=UJmOoTpxQpNdfmMs5zKz2qh/LetMPhAuQ/sQFTdW3w6g6lulzLZKkW4bb83CV69oO6
         eibwpjM97q4zLCPzk0pnvNhgygpbyMnoxNpiZ8t2Br1SecbWAsMkuyMvek/n4xw+VWq/
         HwfLE0tecVQmQ8Vai5WNPFVNnfZ23sT4N819UXWBY4RpEEjA8Y1eR7Pjduhfiv9jUywe
         VXYgnDjjyHchaCjQku2eWGA/esv7r3Yy0IIGR+GM0pfd/MySEuGqnRyju5fiGQsnVgT6
         1Pl33E6oWi+MJgUC2lOGlXZJ7Hy7uCRXOcm1IuQ7MUodz1SWaD/F34VEFMyuxAy+wjmY
         NazA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773641682; x=1774246482;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cNPDzeYcOrLN8zuO7rEFIbyP0W/cSDyRsshEgYOTCs4=;
        b=l0vUgDVys/Soh+RSp6XkrsywKR8F6SAT3sbRv55/84Rd9tVYaJ4ahyslB2gOxDY1Rt
         w4z0bNzurTZz5+e3lA7wVO+I2OqKbNL5PNp5215L/1zUgkte7b3sy1UprmbOnG/Y4q09
         2st/8KsDffLdlLgSD2Id0miZngI3VDQsLye15GWpyhwYLXsif/Pv39N4jvQb5hH2ugji
         LMQ35fOwKTHRq6lA2fIjCjCTdmvBrMCxk7AlOvxxNut0gdAqOwrsGI7EUwhc1Xhi50v5
         fIBS1/yRz/r+D73DfC/4eZYcyWEgoORENvz81uzxyClXP8jtBYlF136JyElaGmT5zErz
         HeQQ==
X-Gm-Message-State: AOJu0YwrZF610b526k/oyvFkWR82XGCTJjlzQQGE37g0dxFpIUjXLQT4
	ANBis3pmm+OwY2/HT53y/rROr4iANsLZsWiwB7GBvMnI2X5amZfJpC7sUDTo+vfl
X-Gm-Gg: ATEYQzyQfo+9lbR9Zs+ptk89U9SPMk5P7QPu030Zqt7BPKixe4Wc1UEm/4kK3Kn06aG
	IdGLjfRYmYiHTO8GH12QcbXByj5T3Amgwrg3R4S4WEmUXsvy2Khy3b8kANE5frN6renewgMloKu
	oJ9AtSRebhPYVDgUq+3umZlwi84rfFKyh1siK9VwwxclbUja2yRqVqJvBc11eUkIig94wl9ElqP
	LvcuooiVjXg9fDKfzCPnvu5udg9ynP5yxEg5DqZ2lMI4AuIxztE5Px0g34yxyS90kfSIwmwQHEO
	dgOt9FRK8TYCGK7UxfuqyObPfv93eLSFFXMT6VMMeR/gyuSNODJr04kkcWWWDkbyKqQD9I+AZKO
	L2Gmd4AVb444OqpPTLw29vAfZxHrT+4D2p18uWNZVbKKOEkKqE3zsvqUfyW5bJShKzP/1XQJMob
	vnnQ44mquK6FFNo+6JW9HhG9UTQTB7vh2OQliGGZPCOw5L85yLfULO/hI7Lc4gqwmIu98oAorri
	3n+1afGkg8dGp9zkTCVT08JzOWWb/kL7aA/ZJT6TC+1lc4=
X-Received: by 2002:a17:90b:5306:b0:35a:329:73c7 with SMTP id 98e67ed59e1d1-35a21e45101mr8144332a91.2.1773641681991;
        Sun, 15 Mar 2026 23:14:41 -0700 (PDT)
Received: from DESKTOP-PU4IGQQ.localdomain ([112.196.126.3])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-35b9303eb9bsm3969010a91.8.2026.03.15.23.14.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 Mar 2026 23:14:41 -0700 (PDT)
From: Utkal Singh <singhutkal015@gmail.com>
To: linux-erofs@lists.ozlabs.org
Cc: xiang@kernel.org,
	yifan.yfzhao@foxmail.com,
	Utkal Singh <singhutkal015@gmail.com>
Subject: [PATCH 0/2] erofs-utils: lib/tar: fix PAX header parsing issues
Date: Mon, 16 Mar 2026 06:14:33 +0000
Message-ID: <20260316061435.13437-1-singhutkal015@gmail.com>
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

These two patches fix input validation bugs in the PAX extended
header parser in lib/tar.c that can trigger crashes on malformed
or crafted tar archives.

Patch 1 skips PAX entries with empty path= value to avoid
out-of-bounds access on zero-length strings.

Patch 2 rejects negative size= values to prevent heap corruption
from incorrect allocation sizes in subsequent operations.

Utkal Singh (2):
  erofs-utils: lib/tar: skip PAX entries with empty path
  erofs-utils: lib/tar: reject negative size= value in PAX header

 lib/tar.c | 7 +++++++
 1 file changed, 7 insertions(+)

-- 
2.43.0


