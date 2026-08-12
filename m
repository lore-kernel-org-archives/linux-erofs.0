Return-Path: <linux-erofs+bounces-4206-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 654A9C5B572
	for <linux-erofs@archiver.kernel.org>; Wed, 12 Aug 2026 13:12:47 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hKpnT0KnZz3bpP;
	Wed, 12 Aug 2026 23:12:45 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=172.105.4.254
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1786540364;
	cv=none; b=Jh4VfmeIEMsbXjmsl/CeoX+6bK6qZg2I3wqh8tlIh7jZfJ2m7iAqJyj/UajXLW+VDJ4aOPSx7T3PbwGOcA1XlH6Cwk+iP4t91YjW9jnQaaGruryqMHgl7695tyxN8iEg7pTlvaV5AWU7Ce6bsS1ASOnNGfNnEvyukR1nwtlHijCk5lpvXx+gveDvkCqQ2Txfz4yhBzHJJQ4oYegkYBpXIIs8lIFBasPOYBhxcnsvwZihSK9Njcm4t4Fb89eSC3vDwIh1Fjdzd9Aqam2PiB3wZ1/iZZAXSNXvI7+2/Tt/yetyWYkbYprUNGp1HVqSv9iJdftM8hqVWgZtUASBdn6t+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1786540364; c=relaxed/relaxed;
	bh=JA43vQGtccT6sp4qL2p5gqo3GNrXNGk+Tzdfpku8ooo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=giX3YZSvuP0bp1eo7MDSkqAKglQlocx2CjPf13F/h1f0o7c5JEtrs1vIEyCP8vi2uAFsAAF3tdVEli2AI4GCuH8A+1I54uHYUhKXxPPUezL2PDQgoJqk6tOyTrk51QYb1oBA45huzzBQ0hDJ1wHfXRkBW2QjqPQlCPuczvKs6K994peUgTSHAcDl7tHvHqUw1wu+OY9Hu2lU9Xp8OkYcMuGmWUX+imNLfPGBrH5acWwgvXFoWeplhyhywauCslorOsuzcGvdXZywWIsx4OjutEvL66OeE8fih0weepvCCtw4n+45vo/6Tv10ZskRpNL6kC7hkP112LP3BQlff9nfrQ==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=SPkKW6Jb; dkim-atps=neutral; spf=pass (client-ip=172.105.4.254; helo=tor.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=SPkKW6Jb;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=172.105.4.254; helo=tor.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org)
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hKpnR4Rzkz303K
	for <linux-erofs@lists.ozlabs.org>; Wed, 12 Aug 2026 23:12:43 +1000 (AEST)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 8B80060A85;
	Wed, 12 Aug 2026 13:12:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F30B1F000E9;
	Wed, 12 Aug 2026 13:12:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786540360;
	bh=JA43vQGtccT6sp4qL2p5gqo3GNrXNGk+Tzdfpku8ooo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SPkKW6Jb4E+W3RoxnWDtIz5DooV7CZt6FbXdWq0vfRLvTh9RDz6i34ntjG5+n4frB
	 r6O/5O4zQchhCaGbu5fKRqbo4MQyGDUjrx9n382FL1D3LWpDZJjDCeTOVwQm+q4c6G
	 BLW4LERHIVPNIE1LJKFOozFftSRKFCkzoHACYFVqMN/lI8SGdMyRweuSrO7cLkLOqH
	 yYfXgYUxF/qb/xnCZ4CxuvtRgJpW5DzntAP+ysn1hiyyIu0qvEqDvEzmZZ6ehCQ9C7
	 iMf3wciOOFQ7DIv40SgM7ShbCH9lDhdYY4VlWF0Jx98aUxRmuTGnz4PNXTsiNM2y7j
	 obEDmCV2R3PpQ==
From: Gao Xiang <xiang@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-erofs@lists.ozlabs.org,
	LKML <linux-kernel@vger.kernel.org>,
	Gao Xiang <xiang@kernel.org>,
	SJ Park <sj@kernel.org>,
	Guenter Roeck <groeck7@gmail.com>,
	Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH] erofs: fix EROFS_FS_ZIP_LZMA_DEFAULT_MAX_STREAMS on some UP platforms
Date: Wed, 12 Aug 2026 21:11:43 +0800
Message-ID: <20260812131144.30802-1-xiang@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <CAMuHMdUO8_BY514PhSXeEPABCoeaJcEk1TimzxvtwPz6zFA5nw@mail.gmail.com>
References: <CAMuHMdUO8_BY514PhSXeEPABCoeaJcEk1TimzxvtwPz6zFA5nw@mail.gmail.com>
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

CONFIG_NR_CPUS doesn't define on some UP platforms (e.g. arm), so this
can cause make oldconfig to loop indefinitely when CONFIG_SMP=n:

 $ make ARCH=arm allmodconfig
 $ sed -i "/CONFIG_SMP=y/d" .config
 $ sed -i "/CONFIG_EROFS_FS_ZIP_LZMA_DEFAULT_MAX_STREAMS.*/d" .config

EROFS LZMA default maximum decompression streams (EROFS_FS_ZIP_LZMA_DEFAULT_MAX_STREAMS) [0] (NEW)
EROFS LZMA default maximum decompression streams (EROFS_FS_ZIP_LZMA_DEFAULT_MAX_STREAMS) [0] (NEW)
...

Let's guard NR_CPUS with SMP instead of using a hardcoded arbitrary CPU
uplimit here, similar to commit a3344078101c ("mm: make SPLIT_PTE_PTLOCKS
depend on SMP").

The initial report from SJ Park was for m68k [1] (m68k is the only arch
without NR_CPUS in Kconfig), and it will be changed in another patch [2].

[1] https://lore.kernel.org/all/anuyFHLUGDjZWY4K@XiangdeMacBook-Pro.local/T/#u
[2] https://lore.kernel.org/r/20260731094950.1988084-2-ukleinek@kernel.org

Reported-by: SJ Park <sj@kernel.org>
Closes: https://lore.kernel.org/r/20260728065447.91511-1-sj@kernel.org
Reported-by: Guenter Roeck <groeck7@gmail.com>
Closes: https://lore.kernel.org/r/87853c96-cc8f-49e6-81b1-02bfe409e372@roeck-us.net
Fixes: c9b47e6b2311 ("erofs: cap LZMA stream pool size")
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Gao Xiang <xiang@kernel.org>
---
Hi Linus,

Could you apply this Kconfig fix directly since I don't have other urgent
patch for 7.2 (so maybe it's unnecessary to have a pull request just for
this..)

Many thank,
Gao Xiang

 fs/erofs/Kconfig | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/erofs/Kconfig b/fs/erofs/Kconfig
index 8ca1767dafb6..2dfc313588d2 100644
--- a/fs/erofs/Kconfig
+++ b/fs/erofs/Kconfig
@@ -134,7 +134,8 @@ config EROFS_FS_ZIP_LZMA
 config EROFS_FS_ZIP_LZMA_DEFAULT_MAX_STREAMS
 	int "EROFS LZMA default maximum decompression streams"
 	depends on EROFS_FS_ZIP_LZMA
-	range 1 NR_CPUS
+	range 1 NR_CPUS if SMP
+	range 1 1 if !SMP
 	default 16
 	help
 	  By default EROFS allocates one LZMA decompression stream per CPU.
-- 
2.47.3


