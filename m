Return-Path: <linux-erofs+bounces-4696-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B4301CA9EC5
	for <linux-erofs@archiver.kernel.org>; Mon, 12 Oct 2026 14:01:13 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4j3JzC5lsmz30Vm;
	Tue, 13 Oct 2026 01:01:11 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=185.125.188.122
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1791813671;
	cv=none; b=bRAjwbIsC2/ez9l1j37JGOJzUS6OJkqUM2Z3GkUm2pfhFvj/lZj4isa2K8G2wRAviNYglM3sHTf3sQkTWSvpdaUn6xhyk6zxyR2a8ZmlMRbOGRl3t3z/LEhqxk4c7JKpEW9svJzDI5Gu8fGssDTHONg4fQ9BOrvAGp+DjqPoBC/hZfy1wCaCAMFnr7gRjemt5pMZOiXzdSaqBrW6Btd9x/rcge7bpjbkne0nN9zez2QeW/86/eNbU5cSwYcVq4TaKwrrQtnrZFyYGajE1Iom5MWAcm3jfrhrw0QK75jj+/3el6H4Kh/dHSnND8StxsVcczmZv7VgjLDDna/9xARDNw==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1791813671; c=relaxed/relaxed;
	bh=afzLNemZ9BnwP+jnhUnGmD8FCTofIYCNqHjd+AROSF8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=BeR0+GFrBJEImd4qpddoq1oAub6eyaT1ySkNdhBjUJX1+I0vzxkOt82J4Nb8JzyrY6lvNjnewjVBM/SuRrASxe/R+yE6UjnL1xsAhhGdsneJm56tgcg9HRebmxMYpgY2/2jCocDv2w5gutaaxFVQuF9sqg94dGwkpBRWWArE2gmoypHHhFLGiAPOWFRPnNHflKSCmmIFSjmJzhaLsrMeQi4e6KuADr99Hgv3FSjeAbeEh+M85IyvzMh4RWbqjfG4T00e1sAewgiOqBdS7BNcIZVRjJTsoxp7Hv+vZ/k7Y1zWZkDViJ8E0gcyUQ2YT5ilgJMuYZV/z8X4DfZHzPHeSg==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=reject dis=none) header.from=canonical.com; dkim=pass (4096-bit key; unprotected) header.d=canonical.com header.i=@canonical.com header.a=rsa-sha256 header.s=20251003 header.b=HH4pJdLW; dkim-atps=neutral; spf=pass (client-ip=185.125.188.122; helo=smtp-relay-internal-0.canonical.com; envelope-from=heinrich.schuchardt@canonical.com; receiver=lists.ozlabs.org) smtp.mailfrom=canonical.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=reject dis=none) header.from=canonical.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (4096-bit key; unprotected) header.d=canonical.com header.i=@canonical.com header.a=rsa-sha256 header.s=20251003 header.b=HH4pJdLW;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=canonical.com (client-ip=185.125.188.122; helo=smtp-relay-internal-0.canonical.com; envelope-from=heinrich.schuchardt@canonical.com; receiver=lists.ozlabs.org)
Received: from smtp-relay-internal-0.canonical.com (smtp-relay-internal-0.canonical.com [185.125.188.122])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4j3Jz93y5qz30VV
	for <linux-erofs@lists.ozlabs.org>; Tue, 13 Oct 2026 01:01:08 +1100 (AEDT)
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com [209.85.128.71])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id 6B2FA3F1F9
	for <linux-erofs@lists.ozlabs.org>; Mon, 12 Oct 2026 14:01:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
	s=20251003; t=1791813663;
	bh=afzLNemZ9BnwP+jnhUnGmD8FCTofIYCNqHjd+AROSF8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version;
	b=HH4pJdLWiX++qnqv6I58DSK7BCED+CbO3y8g0tTRqiEdmNlEV/hZoxpSmApLTBimi
	 AsToNG9HY5arAYOesgRBLNtRmv+bjZsujrCkFpBxftZG/ExFjR6SIqTm7qScSBzoNr
	 ju1EvRd/X2pCFMd1BJvSOKGnbX7Pssr9GuFHCKYJ+hvrTaB+bOcgZjrhEuCS012/eJ
	 y2Y4HS3Iq2uywiGKMmJHFphEKpg7pVu/lXZr6HNvBG4Ae+1B5D3Ainbly3pRmBg/N7
	 MgdrnnNhqzVJOUzpNvjU0RTabNcngvoYRH8algsjknplIcG0P2CVQye8VRdj2Z9/rc
	 s71bTIQRoljnk0qWj87x7h86B5qpJgUN4uPsqQq3BkUSGs70wW7yqvSjRVk9dX+rrv
	 A0fYMRojG+edEpgO8I1nWQuOz7BXESRE2u/nPfz09WErV6096ZnH1cAHPTMhFeOfCg
	 +jWUUdeglhAnxf9I5jAzq++5BbXxi+z/Blpj/9+6yCt3JsRrI5OaMPamuAGNG3VQyM
	 ghqln3TZ9GK1HX1OfiQRxdzs7lvjfJoYh2U/5BkDpolRHeNQ5/yJZ3ZQp5QRq26pm/
	 KIuzwGFGoKxO6lAUQwy5NpgUCHGjNtdy4eg2QWPNVeGn/yw2cw8Risb+yWeBVWwqVZ
	 VaeZ5XQDKwBLpRH2ls1TTA/Q=
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-4a020cf06c3so10413615e9.3
        for <linux-erofs@lists.ozlabs.org>; Mon, 12 Oct 2026 07:01:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791813663; x=1792418463;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=afzLNemZ9BnwP+jnhUnGmD8FCTofIYCNqHjd+AROSF8=;
        b=yqGdOKRNOm7c8xr8+HBMccmoyUOUwLoKoC0MoIwOChbgm8ZtmV1lFA6nPbOYl0KP3Y
         68FtOHtKifm0ZfYQUA/dDo+jS5xowYf61SIBqL64oalcYyE+g/BPdthpe0WaeP0N2msy
         ZiOlz9p3hwg7vpUdScu6x85beyAEKoVLBzktytDbDU2pswnmlgrK8sPs9UjoEXyAkMPd
         PdmSsVaTHzxz61Td+2knRLQKj7sdz7FHUryPh4uHFkTottBddlYKLc7zLxc43t6PkWvM
         wnl8rGrNswaBRqcLVs1jJSOp8uCo8jXHVBfgsk0/jYawbtDMB4v4CoFlX2p8WbPLbeId
         dwVQ==
X-Forwarded-Encrypted: i=1; AKwUvByXNjpnfjMVJB6ty4/XDsot2Qx4UWlXjBL+1XfUN7qPGm6PDH+itLkIK7iuliDpvRh4yh0Hw1gor3IeQA==@lists.ozlabs.org
X-Gm-Message-State: AFq9FYKOS0QUd/0DVq8GqhLHSIMBPdK4jKZFZ2wNzR3br5aVCntn0WLT
	A5HoNZDeOBIT+TYKO5kakHSo6+5289MSmjZ68tx/bsjrxW9zR4OjtXvZUWTGckpAeSgQCQ2629M
	y9dubYma+TKj9kXnDqItX5AJ0GCIso+36Xp4W6A3NU4KA8IOIPn63zApaGcaMuYDDeD4eR881tN
	caOpPCtg==
X-Gm-Gg: AYBFou0BtTtNdmVq6lKRbsgsZlFoxHMcdqRmQqIIwom68oLwEwafUld6PH+sfsxeog3
	qyOALDE/srFnwPAbphw3UlN25A2aaALWjeSenZZt74T/3lTW3Dgg7xFaV0roEIwuBfnmz2YcSjv
	SvpssZsKvmTY0H3PR52hy0QV/iopNmc7BC24nOkLwlHIBhcxqEtwBucDL6DvSdj5y2vhN/rB3LC
	VtAHZiz4vWrhqUt+7d8im2lPUcfJ1aNBu0WIYqEu/jc+zkrHbFg+vU+qti4qjFVhEEN6rOkYo59
	ck4hi1c7g4LDXyAd6HuANW11HAZ6s+oREdgcNNxChZHUDkYHIMfhUF1B4FIpRT+qwId1EhTyx+b
	+gJCUJRV6RXsA435FSfGC5QXeiWj+9Br63t3aKUnQRO8Jv/i4j6UaoeA=
X-Received: by 2002:a05:600c:3ba5:b0:4a1:70d4:c69 with SMTP id 5b1f17b1804b1-4a18e4c03bbmr210745995e9.28.1791813662882;
        Mon, 12 Oct 2026 07:01:02 -0700 (PDT)
X-Received: by 2002:a05:600c:3ba5:b0:4a1:70d4:c69 with SMTP id 5b1f17b1804b1-4a18e4c03bbmr210745395e9.28.1791813662399;
        Mon, 12 Oct 2026 07:01:02 -0700 (PDT)
Received: from workstation5 ([2a02:908:1242:30e0:468d:767c:32e6:22fa])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a18bf15691sm284551015e9.6.2026.10.12.07.00.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Oct 2026 07:01:00 -0700 (PDT)
From: Heinrich Schuchardt <heinrich.schuchardt@canonical.com>
To: Tom Rini <trini@konsulko.com>
Cc: Simon Glass <sjg@chromium.org>,
	Huang Jianan <jnhuang95@gmail.com>,
	Daniel Munic <v-dmunic@microsoft.com>,
	Tony Dinh <mibodhi@gmail.com>,
	Alexey Charkov <alchark@flipper.net>,
	Vincent Jardin <vjardin@free.fr>,
	joaomarcos.costa@bootlin.com,
	Aristo Chen <aristo.chen@canonical.com>,
	u-boot@lists.u-boot-project.org,
	linux-erofs@lists.ozlabs.org,
	Heinrich Schuchardt <heinrich.schuchardt@canonical.com>
Subject: [PATCH 0/9] fs: improve change date handling
Date: Mon, 12 Oct 2026 16:00:39 +0200
Message-ID: <20261012140048.214059-1-heinrich.schuchardt@canonical.com>
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

* Let the ls command print the change date for FAT and ext4 files.
* Correctly update the change date when writing ext4 files.
* Adjust tests.

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

 fs/ext4/ext4_write.c                |  45 +++++++++-
 fs/ext4/ext4fs.c                    |   8 +-
 fs/fat/fat.c                        |   2 +-
 fs/fs.c                             | 127 ++++++++++++++++++----------
 test/dm/host.c                      |  13 +++
 test/py/tests/test_env.py           |   2 +-
 test/py/tests/test_fs/test_basic.py |   4 +-
 test/py/tests/test_fs/test_erofs.py |   8 +-
 8 files changed, 150 insertions(+), 59 deletions(-)

-- 
2.55.0


