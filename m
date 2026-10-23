Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D747160A2600
	for <linux-erofs@archiver.kernel.org>; Fri, 23 Oct 2026 17:42:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=cs.unc.edu header.i=@cs.unc.edu header.a=rsa-sha256 header.s=google header.b=PnZdjLqB
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4jB9Mx32fsz2xpt;
	Sat, 24 Oct 2026 04:42:53 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2607:f8b0:4864:20::f2d"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1792777373;
	cv=none; b=jiIRj6ZD2MuLZKBT5QHMMpD35AQR1QYtfpiJVaDgGD3ronbLcydCGmx5ScKQ2SbyvG5aExyDA04Za2NTydKnCzyIZxNzTQDYoOxyVJ93OYM8PGxyhvHz36S763RvYLaQTgoaDTUroI6DQPZniWAZtZ7rdFdc4bhxjXMtYjWnNmjuUIhIDMZFsOoM3YRx4yBir+UpTAdJbepJ/M5+XUb/kNBzN1Y8VQNOgpQf2/MaNeFfffZwBEhfa5AZ5DDojEcwfs4tL+4NPsWPsqtRGpPUZhR8rzFlCJVyv1x2/KHdvz2i7ZxsGocnDZ2EKn65t1gFkVhi1hpTQbJh5kPRl/9Vzg==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1792777373; c=relaxed/relaxed;
	bh=pttEG3ZBXhyYyMZMgd6B9fdOX/UQFW77/8mvHBDA3zg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=DzIS54vlL1qWpZOGig7zAzqot3KssTTM+zKe2FwAFe0+oAMP6a0hfOnhYDPzsrRUhUE/g4GXEnhrjly3a+w/WCxOOzx11lOnLGrv5TsAvnL7w2uq1vXdeaeV4JCFByxjmXCBlLcbTG9t+yMBa4DuL/Y2L5Zt8Wx5W3tv/698vMA2HZhqq9TgQ87iv5eHIAqduUYZYObIVWlP4ZHwEPkBoalYQDvx/OxuHaW1RPnWskEVz4sgDC6YxokprJaO0EhSisENmc8zFrVb8bGwC4hgfmpZk2so1bdfcd9hfx9UUwsaPOVENgr9b6+gik/bnuW10RxsUK38uKmFxKRNDlcYOw==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=cs.unc.edu; dkim=pass (2048-bit key; unprotected) header.d=cs.unc.edu header.i=@cs.unc.edu header.a=rsa-sha256 header.s=google header.b=PnZdjLqB; dkim-atps=neutral; spf=pass (client-ip=2607:f8b0:4864:20::f2d; helo=mail-qv1-xf2d.google.com; envelope-from=hengyul@cs.unc.edu; receiver=lists.ozlabs.org) smtp.mailfrom=cs.unc.edu
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=cs.unc.edu
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=cs.unc.edu header.i=@cs.unc.edu header.a=rsa-sha256 header.s=google header.b=PnZdjLqB;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=cs.unc.edu (client-ip=2607:f8b0:4864:20::f2d; helo=mail-qv1-xf2d.google.com; envelope-from=hengyul@cs.unc.edu; receiver=lists.ozlabs.org)
Received: from mail-qv1-xf2d.google.com (mail-qv1-xf2d.google.com [IPv6:2607:f8b0:4864:20::f2d])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4jB9Mq4bJrz2xGw
	for <linux-erofs@lists.ozlabs.org>; Sat, 24 Oct 2026 04:42:45 +1100 (AEDT)
Received: by mail-qv1-xf2d.google.com with SMTP id 6a1803df08f44-9178d514951so10710536d6.0
        for <linux-erofs@lists.ozlabs.org>; Fri, 23 Oct 2026 10:42:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cs.unc.edu; s=google; t=1792777362; x=1793382162; darn=lists.ozlabs.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=pttEG3ZBXhyYyMZMgd6B9fdOX/UQFW77/8mvHBDA3zg=;
        b=PnZdjLqB5UR7bX1n72fM4NXjtRG4/RSSMMohfa7QGLB6N/GnrJynOYqSvYoMXTjXw+
         nGl2LZSBRDJSPWJ5XKfo+OTOn2YjjmKDWi+3VwijNTO9j0ogVcHexsSuT3D6seaF3t55
         Nd+/b4VoC2ZinpX3LFZD6myMbmWyigpx1+0MEOsBzXrIfCiAW4ePcZDtIgQ7yGEIthsC
         7ZN8c+bOb/z3izGmtfMs7yImVby4EUYGg0yer5FZyr1yipFlTXo91EqVpAC6NrZol5Yy
         MKufaMD+fQcPvXvJCUlR3Ii4+UIvfpE4rdO5Ym1WF9I6Lfmi4y34srDvozaSzD/asLNJ
         jcbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792777362; x=1793382162;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=pttEG3ZBXhyYyMZMgd6B9fdOX/UQFW77/8mvHBDA3zg=;
        b=EpTglQzdEDeMs7cv1Kf2JPNjeccQ7alBkrGJlfQTpHjxvSVyr6mayFlgDePhoWcnLk
         g0wrOvkiGCxAHOjmLQxoOh+mFp/KAYCYVgrJEZ4kePuds6JmL6mLiZ79tSYkWPpnyin1
         ibDcg49s1BFv+k1ySmdia6RZISiP2TNiZVW8bAxFI886FW+fTGnGfRTo00A6zVtDUC1z
         CjU863d+bVhB5uJqQq2iv0sTmXYYvKuDaCEhHxRdEmrbH7t9RcOl4xSD7wbqm/YaQfOL
         TBAHmLVUqSyd69nCqrHVcWqhv4BbjL6o+Ep5efODV/cjkY57TRDDja9LScyNY1esWebQ
         WFWg==
X-Forwarded-Encrypted: i=1; AKwUvByvYMAbOyFDZ0tlrp8AWVgPzwdO+FQSg+RDRalpHY6M9NAAQjRthio89w5cAaNA7wE1uJlq2bC1RAOQaQ==@lists.ozlabs.org
X-Gm-Message-State: AFq9FYKNf8xZwws+hWRZzI7sDE2uMtq7G/2YGI3Sk6uY65LJRZ1jm67O
	0rAEhvVNhkID+/xbo7fDitAeC9C3Yzs3bGdq+dbWi58yKAyOzNfoSDsFKUGqH7huEA==
X-Gm-Gg: AYBFou0AYt7XloVctbR1NlWOyzZVw0XZODx0IMZlIY/4rpx7rWn0TgJ0qC3uR1QNxdu
	P/bz+koCqDdLuMzB6a7UtZWpvpQWzJWDuBqyEOmpUPcdd0CZj1AJ8Gfp96dIqQb05DmRBNE1F3I
	J/UPa93WqJklewmIN+jVOc3WfQBI2+fLeqcOw7NlalRP2pwAU8q5Zs3F4PXTAn6FyB/NTVb1nP6
	gJKD7OCJk7DEX8XK6tV1QyIshS1XDXvsJntxMnA4f1bJW1LzTZXrSdgSimS5yPwC+Zq+nz9GEKU
	Bf2BGQ+2K6iB8y01ylQyAVFKwcpYh2jRj7Jv1zPRb46wdPILxX6YMx1RBmQ2uzVEohNtXUXKJfN
	Ob5/dzQo5dp1SiAx2K91B0PmTCOqBxsLDJrt/gqN0t40Lmaw9oz8gDKuZLN5VPkHh4b7I82biHZ
	BzHH94sqymRUB5cH8bb5hsztygmhpSt1c4PUwq90vN+hDn8DyrX81O1X9fi0R8KWn0gATEUn8vn
	XytD7QWI624/nljGIHfDf/dscBEu9qRokG3XWzEW/Ny+musqEqT7QTSVod1xqrcua0KjpRuhf5y
	54Q=
X-Received: by 2002:a05:6214:f6a:b0:91b:8c62:eda7 with SMTP id 6a1803df08f44-91c3a86fa9emr45307186d6.29.1792777361801;
        Fri, 23 Oct 2026 10:42:41 -0700 (PDT)
Received: from cobra01.cs.unc.edu (cobra01.cs.unc.edu. [152.2.130.143])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91c47cdf6cfsm277166d6.43.2026.10.23.10.42.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Oct 2026 10:42:41 -0700 (PDT)
From: Hengyu Liang <hengyul@cs.unc.edu>
To: xiang@kernel.org
Cc: chao@kernel.org,
	zbestahu@gmail.com,
	jefflexu@163.com,
	dhavale@google.com,
	hongbohbli@tencent.com,
	guochunhai@vivo.com,
	linux-erofs@lists.ozlabs.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: [PATCH] erofs: fix metadata reads at the end of file-backed images
Date: Fri, 23 Oct 2026 13:42:31 -0400
Message-ID: <20261023174232.3282900-1-hengyul@cs.unc.edu>
X-Mailer: git-send-email 2.53.0
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
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Commit e587a984d332 ("erofs: use dedicated meta inodes for file-backed
mounts") made erofs_read_meta_folio() read the metadata of a
file-backed mount one whole folio at a time.

However, an image only has to be a multiple of its block size. With a
block size below the page size, it can end in the middle of a page. The
read of that last page is then short, and erofs_fileio_ki_complete()
fails it with -EIO. As of now, inodes in the last page of such an image
cannot be read, and an image smaller than a page cannot be mounted.

The issue can be reproduced with util-linux 2.41, whose mount uses the
image file directly:

    mkdir src
    for i in $(seq 50); do echo $i > src/$i; done
    mkfs.erofs -b512 test.erofs src
    mount -t erofs test.erofs /mnt
    ls -l /mnt

Before that commit, ls -l lists all 50 files. After it, ls -l reports
"Input/output error" for 24 of them.

This patch reads the folio only up to the end of the backing file and
zeroes the rest, as the page cache of the backing file did before.

Fixes: e587a984d332 ("erofs: use dedicated meta inodes for file-backed mounts")
Cc: stable@vger.kernel.org
Signed-off-by: Hengyu Liang <hengyul@cs.unc.edu>
---
Tested in KVM with KASAN on a804c5742bff: file-backed mounts of images
with 512 to 4096 byte blocks, uncompressed and compressed, with and
without directio. With this patch every file reads back correctly;
without it, 24 of the 36 mounts give errors. Not tested on 16K or 64K
page kernels, where 4K-block images should be affected too.

 fs/erofs/fileio.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/fs/erofs/fileio.c b/fs/erofs/fileio.c
index c36a90a1a4cb..b4ed7fe7347c 100644
--- a/fs/erofs/fileio.c
+++ b/fs/erofs/fileio.c
@@ -142,17 +142,26 @@ int erofs_read_meta_folio(struct file *file, struct folio *folio)
 		.dev = { .m_pa = folio_pos(folio), },
 	};
 	struct inode *inode = folio_inode(folio);
+	size_t len = folio_size(folio);
+	loff_t pos, isize;
 	int err;
 
 	err = erofs_map_dev(inode->i_sb, &io.dev);
 	if (err)
 		return err;
 
+	pos = io.dev.m_dif->fsoff + io.dev.m_pa;
+	isize = i_size_read(file_inode(io.dev.m_dif->file));
+	/* the image may end in the middle of the folio, zero the rest */
+	if (pos < isize && isize - pos < len) {
+		len = isize - pos;
+		folio_zero_segment(folio, len, folio_size(folio));
+	}
+
 	io.rq = erofs_fileio_rq_alloc(inode->i_sb, io.dev.m_dif->file);
 	io.rq->bio.bi_end_io = erofs_fileio_meta_endio;
-	io.rq->bio.bi_iter.bi_sector =
-		(io.dev.m_dif->fsoff + io.dev.m_pa) >> 9;
-	bio_add_folio_nofail(&io.rq->bio, folio, folio_size(folio), 0);
+	io.rq->bio.bi_iter.bi_sector = pos >> 9;
+	bio_add_folio_nofail(&io.rq->bio, folio, len, 0);
 	erofs_fileio_rq_submit(io.rq);
 	return 0;
 }

base-commit: a804c5742bff224d4cb4d25dd383554d598be32b
-- 
2.53.0


