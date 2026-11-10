Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF03D606A325
	for <linux-erofs@archiver.kernel.org>; Tue, 10 Nov 2026 09:40:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=LZpiYB3U
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4jP1qD3rTJz3bjW;
	Tue, 10 Nov 2026 20:40:40 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=115.124.30.124
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1794303640;
	cv=none; b=HHSDLg76YZsudWlgMxgPufn2qxEwKra12pQZ77vYxAaLF+AN/UXi9vXsv7lNTVX+hFbHVLgK1uZH+/VyZLSSMRK/mtoT5uAODIjq+pPh9s4hgE+NKoxs14rhS4sXFNU4Kd5Vc1hB7oDjhNYEVhRfah9SDzhP6qDnHr663eoNow27LdEQcoGKsKCNonqEjjX/5pvnZ9sYE6sbgsifZ8GkczKl62pDKjkAg7QXAFExaNos6C9dtHu/HCotZ0X/5a2KlJe5uhm8OyJH1qFganfhdrDdqgBiLzV6ghw7RQryUNt0++VSpNNQwOHhF6oNMEdGQRukpz7O46oR7x3K4QrLkg==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1794303640; c=relaxed/relaxed;
	bh=FZQ7+Q7CQz3LseARjs81djMrwITdfbtjiPJ+8TwBzpI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=JKAPYjXhFY2WjaiUn1R6pxdUmyyJkJw6ShtMw4FfLlBR0oNBTMbhpaHrmjKvVmPAiZ8O/rnYeKwPiAJgoLAiEgnerbRCCrMTYvjhkydub/QOGOUiIKG08R93SXBk9eqA5TmIBOQ6OnsZxzanShW43PJc3x1PrjbHI4BTxXhqT4rZIvkSrVWB0wOyvmwb6wArdTmWF1Urbc8Pz7H5kiJsiIyLSfxSHSHlIgbhzuAF0q7kOgOwiTmxktbOq6kP2t0nulmhdqGcdzvKw9rJ6WMFHo0fMoPN0Hg2Zz8xnzXlpT6OkH+NCap/ryyaPl9z1LnXZj4PCdhI90X2g3TEJv8JIQ==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=LZpiYB3U; dkim-atps=neutral; spf=pass (client-ip=115.124.30.124; helo=out30-124.freemail.mail.aliyun.com; envelope-from=lanbingying.lby@linux.alibaba.com; receiver=lists.ozlabs.org) smtp.mailfrom=linux.alibaba.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=LZpiYB3U;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=linux.alibaba.com (client-ip=115.124.30.124; helo=out30-124.freemail.mail.aliyun.com; envelope-from=lanbingying.lby@linux.alibaba.com; receiver=lists.ozlabs.org)
Received: from out30-124.freemail.mail.aliyun.com (out30-124.freemail.mail.aliyun.com [115.124.30.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4jP1qB1JKGz3bjN
	for <linux-erofs@lists.ozlabs.org>; Tue, 10 Nov 2026 20:40:36 +1100 (AEDT)
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1794303629; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=FZQ7+Q7CQz3LseARjs81djMrwITdfbtjiPJ+8TwBzpI=;
	b=LZpiYB3UKQpsYXFlQ2aUbpx/ubiemBYayyGev6rnx0YMCsyLXPc89HizA1Yp3sznCvoX4i/BN2g4Npx8Pt5DpwEqGhmbNivm3ybuXvkl9Mqq8YFcolNYutlWSUyiZ/fYK0Z+gXpozhHOyJGgJBI6Ra8tas2GzbDwHYZZzzD1Ev4=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R151e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037033178;MF=lanbingying.lby@linux.alibaba.com;NM=1;PH=DS;RN=2;SR=0;TI=SMTPD_---0XEUy1d9_1794303613;
Received: from x31i01179.sqa.na131.tbsite.net(mailfrom:lanbingying.lby@linux.alibaba.com fp:SMTPD_---0XEUy1d9_1794303613 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 10 Nov 2026 17:40:26 +0800
From: bingying lan <lanbingying.lby@linux.alibaba.com>
To: linux-erofs@lists.ozlabs.org
Cc: xiang@kernel.org
Subject: [PATCH 0/3] erofs-utils: preserve and reserve plain xattr prefixes
Date: Tue, 10 Nov 2026 17:40:09 +0800
Message-ID: <20261110094012.1820140-1-lanbingying.lby@linux.alibaba.com>
X-Mailer: git-send-email 2.53.0.apsara
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
X-Spam-Status: No, score=-21.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no
	version=4.0.1
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Incremental builds must preserve the prefix indices referenced by
inherited inodes. Replacing the base prefix table with the current
command-line list can change those indices. Rewriting an unchanged table
is also unnecessary and may fail once the image exceeds the prefix-table
address limit.

Patch 1 fixes buffer-head cleanup when writing a prefix table fails.
Patch 2 preserves every base prefix slot, appends newly requested
prefixes, and reuses an unchanged plain table. It also preserves and
remaps the inode digest prefix configuration.

Patch 3 adds --xattr-prefix-reserve to allocate an optional 64 KiB region
for future prefix additions. Later incremental builds can append records
there without relocating the table. This proposes a new compat feature
bit without changing prefix record encoding. Feedback on the flag and
reservation design would be appreciated; patches 1 and 2 can be considered
separately from this extension.

The series was built and passed local regression tests covering inherited
prefix IDs, digest-prefix handling, unchanged-table reuse beyond 16 GiB,
table writes around 4 GiB, reservation allocation and migration, packed
table handling, and clean failure on prefix offset overflow. Reservation
checks covered 512-byte and 4 KiB blocks, compressed data, and shared
xattrs. The local test scripts are not included in this series.

This series is based on erofs-utils dev at de2dbe430f06.

Thanks,
bingying lan

bingying lan (3):
  erofs-utils: lib: initialize xattr prefix buffer cleanup before errors
  erofs-utils: mkfs: preserve plain xattr prefixes in incremental builds
  erofs-utils: mkfs: add opt-in plain xattr prefix reservations

 include/erofs/internal.h |   1 +
 include/erofs/xattr.h    |  12 ++
 include/erofs_fs.h       |   2 +
 lib/xattr.c              | 291 +++++++++++++++++++++++++++++++++++++--
 man/mkfs.erofs.1         |  49 +++++++
 mkfs/main.c              |  40 +++++-
 6 files changed, 378 insertions(+), 17 deletions(-)


base-commit: de2dbe430f066ab02d7272e6b47fcc70446bca61
-- 
2.53.0.apsara


