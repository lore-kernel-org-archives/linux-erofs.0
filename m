Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB018606A31E
	for <linux-erofs@archiver.kernel.org>; Fri, 23 Oct 2026 19:01:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=cs.unc.edu header.i=@cs.unc.edu header.a=rsa-sha256 header.s=google header.b=d3oI6cvS
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4jBC684jgHz2xlY;
	Sat, 24 Oct 2026 06:01:04 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2607:f8b0:4864:20::112f"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1792782064;
	cv=none; b=VsOQgqT/s9mhutLCzYc8UPKQLB9eDj27RUMfWr2hwWmnvemdNWde/voqAlORyGIHDb/TQLv1V+oCqHnrdZ0fca6L5mtUR4EYkUHQdRe16jj8pWxg8o+7k2WYrGlVWLq+BtJAiAZQFQ3kzWB16a7YhNB1Fn0G+a0EAJc1xIPbFpJWxQo/hdeI5p9yyALS1KMGFESQ3lHbqmxagTLnSr49VebONyeK5Mfsj2MKYcnj8EdqQIUpvmagAxtzffLBEQtNUuc/U21nxr0Ifkgufl0OLF0BmbKya01nBpAcOcbggBgzU7xiFS48aBBfG/4mbVfGWr6yrUHHUamkrxylu/7uNw==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1792782064; c=relaxed/relaxed;
	bh=CXL4R8sulkGCQUPMGPuMacTqy3n9g+qVj+Ldz7ej5tM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=fEbZBcSugC7X6v+TPKA7EJa5zE0I0AXDpeB1e0Z9YyplFFPnMe2nJ0gxhWtzdZ1eNcYmr1TEnzZ5w9TzvMfoptf7F1OTwuzv1RA0Y6KbwvtkKYPYx+g1psCl53eRzRTDygw5KwRD8bTegXx5bOMtpqvX01EfXSYDRRZFdr0kIhmX3MqY9zCH4I1/QPgkF2K5NsBRmmjTSVzaFsW4g4ISj09zAa/tFiYNhXdMxUZXE5qcjLqrjwxzY4+sbqJM4bacZhQoshBMjZ28mtDsp85PXZtvgrZWHdpkuITk5fex8IXEeGlAqARTM0iA8MIUrRb6Vsv6wsMuBNLaj+KPUeOQmg==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=cs.unc.edu; dkim=pass (2048-bit key; unprotected) header.d=cs.unc.edu header.i=@cs.unc.edu header.a=rsa-sha256 header.s=google header.b=d3oI6cvS; dkim-atps=neutral; spf=pass (client-ip=2607:f8b0:4864:20::112f; helo=mail-yw1-x112f.google.com; envelope-from=hengyul@cs.unc.edu; receiver=lists.ozlabs.org) smtp.mailfrom=cs.unc.edu
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=cs.unc.edu
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=cs.unc.edu header.i=@cs.unc.edu header.a=rsa-sha256 header.s=google header.b=d3oI6cvS;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=cs.unc.edu (client-ip=2607:f8b0:4864:20::112f; helo=mail-yw1-x112f.google.com; envelope-from=hengyul@cs.unc.edu; receiver=lists.ozlabs.org)
Received: from mail-yw1-x112f.google.com (mail-yw1-x112f.google.com [IPv6:2607:f8b0:4864:20::112f])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4jBC641vKVz2xKx
	for <linux-erofs@lists.ozlabs.org>; Sat, 24 Oct 2026 06:00:58 +1100 (AEDT)
Received: by mail-yw1-x112f.google.com with SMTP id 00721157ae682-8b0a921ee46so10312567b3.2
        for <linux-erofs@lists.ozlabs.org>; Fri, 23 Oct 2026 12:00:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cs.unc.edu; s=google; t=1792782056; x=1793386856; darn=lists.ozlabs.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=CXL4R8sulkGCQUPMGPuMacTqy3n9g+qVj+Ldz7ej5tM=;
        b=d3oI6cvSYpXdlghaDbpxvXbRywmVPJxbrtAHgwXpUhAl5evhBxyi7t/9LYuyxO1MSM
         U7zhBg1Yjkd0wSqfAZVZNV+6URUdMwgaEHvpN3DEKVCA5oe67TQUfiu44zRGhzALGm9j
         UJLCuqIRUvt/cjl2Lunpno2mYoweM6rCKAbuFcqcqRSPS6HFrYYmws6way1jD5u7vNBv
         tLtmC2Ft4FI+YYmVuM5GweW4WskNLdoqql668KGc5XJ6YYMU40sm+jIg7ZgcTohnz5vu
         5662heoDliDp2s4Ttz6YAGKuCWMUSReB+6pDSjBLDavVP06zTN2+IhXPHPugiEcrexNM
         qgtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792782056; x=1793386856;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=CXL4R8sulkGCQUPMGPuMacTqy3n9g+qVj+Ldz7ej5tM=;
        b=dEpImW5xrDJtwxMvhKc4RkFByWvBut2Nm0x70gi8n11G4WNIU6Y1M5FsdCBY9h5Z8h
         ybGSJrMr2WBpO3nvwpbU7OrJ6vzXEBGKp1SyRFi+YS0W/o49zJmbfgGpjtma8N05WOkV
         akfrpa077rBSTK8W158bbm/+GEYxTB+agTvTYIl+KOJ03NhDQVh1fa3juKQJoVp3b93Q
         YscFZDByEWGInxYQ41MWXIrL2DGOIqd5SJM9+guC0yU4I8D/N6HSSKsp8fSU1vCz25fD
         wnaex5eTZnbJMu5tVKPS9kffqQ/4QaOdszXorTWx7rz7ZCnGE3QH8LnZua8GDTSZJJcN
         um4Q==
X-Forwarded-Encrypted: i=1; AKwUvBxve++6VRQharRe4dM0k8NrpapPTm8zmffxGUG9b4+pG1bw6T3Ma7m19o23sDVa8iYxNhzeYhgjRCEm0g==@lists.ozlabs.org
X-Gm-Message-State: AFq9FYL1Q9l40yg83jgA/nDDbHGp1FfMFtcRsjFJAW5enUZnC630bbwp
	TMj8haU4rGNiiZYVbNFg8JNonqVmmM+pRpcWTMM7ZGHy9Vp7kqVO8pwl9sp6Y/BlFg==
X-Gm-Gg: AYBFou24ISQVFmU4RnGUnjQ6kYxG5KTaXKFxESdSRFBjpjJ2SpMdxkPu5wiZrFKH2MV
	3EMkqTIUR1Qta1o9xpleVeNDpeFbjhSKEfnVdHYNdepe8iBm8N8x7TFUSDQgOLab0aFoBjudaSc
	An/n7fGhOkU4Cx2LTZBvWis1dqmn1evh9QxJKujrB2tAOWiitBDKS941aFQTIEsC6l14aaehxg0
	bIUzzL1l9ERHsrATMK9FGt9dW+hDxykJWZDPXYfryGOJCHMdAjJ/SqJIJArZEXUKj0gn2ZD7EEj
	IUrEniZIR1Sfbr+t24ZaWbI1lqjUxDtN5K3+rIvvuMCOKC7QoDt30CDcjXRRoQHzJRqJ4tWcvKb
	wATMWNmakTvoA3pa6P9Tloe+CO1hJWFxq0YMduGxM+7Kc0+MM3yIgw5d7hEBm2oL9asmqS/Aq49
	8kO1UpfUhPvf6HPiacCLrAvxBEnBET2tfKnBgJemQO91kXnzmLIj8WROw1VbpqDw8VYmq+5lBeL
	2hklu2adetcwB9GDjiHCK+HoQ+6dut57gdI0hOOAvCwrnVqI1aomJ00ulZfw+0W0ImJqkW5hNRl
	0g==
X-Received: by 2002:a05:690c:e0d4:10b0:8b0:cf3d:7b35 with SMTP id 00721157ae682-8b1669bc5a3mr634117b3.15.1792782055599;
        Fri, 23 Oct 2026 12:00:55 -0700 (PDT)
Received: from cobra01.cs.unc.edu (cobra01.cs.unc.edu. [152.2.130.143])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-67a42f046f3sm368994d50.16.2026.10.23.12.00.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Oct 2026 12:00:54 -0700 (PDT)
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
Subject: [PATCH v2] erofs: fix metadata reads at the end of file-backed images
Date: Fri, 23 Oct 2026 15:00:51 -0400
Message-ID: <20261023190051.3457491-1-hengyul@cs.unc.edu>
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
zeroes the rest, as the page cache of the backing file did before. A
folio that lies wholly past the end is zeroed without a read.

Fixes: e587a984d332 ("erofs: use dedicated meta inodes for file-backed mounts")
Cc: stable@vger.kernel.org
Signed-off-by: Hengyu Liang <hengyul@cs.unc.edu>
---
Changes in v2:
- Also zero a folio that lies wholly past the end of the backing file,
  without a read, as suggested by Gao Xiang.
- v1: https://lore.kernel.org/r/20261023174232.3282900-1-hengyul@cs.unc.edu

Tested in KVM with KASAN on 734bef548a96: the images used for v1, plus
three images cut so that whole folios lie past the end. With this
patch every complete image reads back correctly, and the cut images
give the same results as v7.2 (EFSCORRUPTED instead of EIO for the
inodes past the end).

 fs/erofs/fileio.c | 19 ++++++++++++++++---
 1 file changed, 16 insertions(+), 3 deletions(-)

diff --git a/fs/erofs/fileio.c b/fs/erofs/fileio.c
index c36a90a1a4cb..a77af604479f 100644
--- a/fs/erofs/fileio.c
+++ b/fs/erofs/fileio.c
@@ -142,17 +142,30 @@ int erofs_read_meta_folio(struct file *file, struct folio *folio)
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
+	/* the image may end before the end of the folio, zero the rest */
+	if (pos + folio_size(folio) > isize) {
+		len = isize > pos ? isize - pos : 0;
+		folio_zero_segment(folio, len, folio_size(folio));
+		if (!len) {
+			folio_end_read(folio, true);
+			return 0;
+		}
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

base-commit: 734bef548a96e8774d6eef5dfa2026c6edc4e80b
-- 
2.53.0


