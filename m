Return-Path: <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3CE54C433EF
	for <linux-erofs@archiver.kernel.org>; Tue,  8 Feb 2022 14:05:38 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [IPv6:::1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4JtPt82Lmvz3bTt
	for <linux-erofs@archiver.kernel.org>; Wed,  9 Feb 2022 01:05:36 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org;
	dkim=fail reason="signature verification failed" (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20210112 header.b=q3Zh3NUY;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized)
 smtp.mailfrom=gmail.com (client-ip=2607:f8b0:4864:20::42f;
 helo=mail-pf1-x42f.google.com; envelope-from=jnhuang95@gmail.com;
 receiver=<UNKNOWN>)
Authentication-Results: lists.ozlabs.org; dkim=pass (2048-bit key;
 unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256
 header.s=20210112 header.b=q3Zh3NUY; dkim-atps=neutral
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com
 [IPv6:2607:f8b0:4864:20::42f])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
 (No client certificate requested)
 by lists.ozlabs.org (Postfix) with ESMTPS id 4JtPt4410dz30QZ
 for <linux-erofs@lists.ozlabs.org>; Wed,  9 Feb 2022 01:05:30 +1100 (AEDT)
Received: by mail-pf1-x42f.google.com with SMTP id x65so4512105pfx.12
 for <linux-erofs@lists.ozlabs.org>; Tue, 08 Feb 2022 06:05:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20210112;
 h=from:to:cc:subject:date:message-id:in-reply-to:references
 :mime-version:content-transfer-encoding;
 bh=WCRwThXrh6JkUJPqLq+Y106D2oS6z+dR+PsrJSOnpRM=;
 b=q3Zh3NUYU75JpFVBJ3UscJyvzWZ7Zza27LnAuAS+YgNos8fOb9YALJD67XS4sApbhg
 LEupbNpgPtiG+LayJPSFVlXpJoyTbiwe+hwpTf89scRhnc/tJmLDP6oeq1uu1pYrwGrS
 oJqjoWr0zkS2qg3q3YDcOcXV5dDQNZmRHzo6/WBQorQL7B3nu+aNpiNbgmNpo4zvLBTz
 bRxBtP6turj+azNo+nTCHjr9WblNkYFm8puAzu8STx5vXKljx0rz2JVmZJ6OGAb2AzPc
 JQoM8JrlLxD31dJqJwTqRYlY+8ueAAaHiGb5rzdDP5dZxiZli2uy9u7hwsqVdcIuFa3a
 Aq/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
 :references:mime-version:content-transfer-encoding;
 bh=WCRwThXrh6JkUJPqLq+Y106D2oS6z+dR+PsrJSOnpRM=;
 b=QEq6HCOA6prI1nW2LQgl6b8rBTw0iUDwQp9jhiiamw/QGTk+ze8GhU6LoZBazrK3z7
 CQSxRf8tmzYjTEpDASjttOlPb8L/jp9Ano7cHmd+SLwS2H2UnVFA8gJLuLjiE7+nYUKS
 aYxCSmy0NCeFlg0LsSz4EtlB6QCOAi0Kik/8ti34qQJ470maGCi/HlfBBzoFP3g4jcWj
 4fy3/4iW1LdQbwEU2LVfkv93h37EbmTV6QkxFCoyuAEZEbFLJMHU4p4nK0zqy8WcXQ/y
 8PGyM7EkSEa+SLp52YfGrM3oB2RQEuq2t8Pf8F5nzpKsjEF5hrn5MsxiyRLcvkESKIoD
 4lUQ==
X-Gm-Message-State: AOAM531m8q4eCm9gL7VCRStFXQfdn0Ut91T+tYphCg9j5ycCy4XiBhnR
 54NnLBU6fTFI8yp87wkOK4k=
X-Google-Smtp-Source: ABdhPJzATT7dpIoT4sjXGoYZ3TgnkhCNYeyOmJOB5y+0H3skJXl6sp+3PWSAq9LWPkolDGNRSCliqw==
X-Received: by 2002:a65:6d89:: with SMTP id bc9mr3630446pgb.260.1644329127466; 
 Tue, 08 Feb 2022 06:05:27 -0800 (PST)
Received: from hjn-PC.localdomain (li1080-207.members.linode.com.
 [45.33.61.207])
 by smtp.gmail.com with ESMTPSA id pj4sm3012006pjb.43.2022.02.08.06.05.22
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 08 Feb 2022 06:05:27 -0800 (PST)
From: Huang Jianan <jnhuang95@gmail.com>
To: u-boot@lists.denx.de,
	trini@konsulko.com
Subject: [PATCH v3 0/5] fs/erofs: new filesystem
Date: Tue,  8 Feb 2022 22:05:08 +0800
Message-Id: <20220208140513.30570-1-jnhuang95@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210823123646.9765-1-jnhuang95@gmail.com>
References: <20210823123646.9765-1-jnhuang95@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-BeenThere: linux-erofs@lists.ozlabs.org
X-Mailman-Version: 2.1.29
Precedence: list
List-Id: Development of Linux EROFS file system <linux-erofs.lists.ozlabs.org>
List-Unsubscribe: <https://lists.ozlabs.org/options/linux-erofs>,
 <mailto:linux-erofs-request@lists.ozlabs.org?subject=unsubscribe>
List-Archive: <http://lists.ozlabs.org/pipermail/linux-erofs/>
List-Post: <mailto:linux-erofs@lists.ozlabs.org>
List-Help: <mailto:linux-erofs-request@lists.ozlabs.org?subject=help>
List-Subscribe: <https://lists.ozlabs.org/listinfo/linux-erofs>,
 <mailto:linux-erofs-request@lists.ozlabs.org?subject=subscribe>
Cc: linux-erofs@lists.ozlabs.org
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs"
 <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>

Changes since v2:
 - sync up with erofs-utils 1.4;
 - update lib/lz4 to v1.8.3;
 - add test for filesystem functions;

Changes since v1:
 - fix the inconsistency between From and SoB;
 - add missing license header;

Huang Jianan (5):
  fs/erofs: add erofs filesystem support
  lib/lz4: update LZ4 decompressor module
  fs/erofs: add lz4 decompression support
  fs/erofs: add filesystem commands
  test/py: Add tests for the erofs

 MAINTAINERS                         |   9 +
 cmd/Kconfig                         |   6 +
 cmd/Makefile                        |   1 +
 cmd/erofs.c                         |  42 ++
 configs/sandbox_defconfig           |   1 +
 fs/Kconfig                          |   2 +
 fs/Makefile                         |   1 +
 fs/erofs/Kconfig                    |  21 +
 fs/erofs/Makefile                   |   9 +
 fs/erofs/data.c                     | 311 +++++++++++++
 fs/erofs/decompress.c               |  78 ++++
 fs/erofs/decompress.h               |  24 +
 fs/erofs/erofs_fs.h                 | 436 ++++++++++++++++++
 fs/erofs/fs.c                       | 267 +++++++++++
 fs/erofs/internal.h                 | 313 +++++++++++++
 fs/erofs/namei.c                    | 252 +++++++++++
 fs/erofs/super.c                    | 105 +++++
 fs/erofs/zmap.c                     | 601 ++++++++++++++++++++++++
 fs/fs.c                             |  22 +
 include/erofs.h                     |  19 +
 include/fs.h                        |   1 +
 include/u-boot/lz4.h                |  49 ++
 lib/lz4.c                           | 679 ++++++++++++++++++++--------
 lib/lz4_wrapper.c                   |  23 +-
 test/py/tests/test_fs/test_erofs.py | 211 +++++++++
 25 files changed, 3268 insertions(+), 215 deletions(-)
 create mode 100644 cmd/erofs.c
 create mode 100644 fs/erofs/Kconfig
 create mode 100644 fs/erofs/Makefile
 create mode 100644 fs/erofs/data.c
 create mode 100644 fs/erofs/decompress.c
 create mode 100644 fs/erofs/decompress.h
 create mode 100644 fs/erofs/erofs_fs.h
 create mode 100644 fs/erofs/fs.c
 create mode 100644 fs/erofs/internal.h
 create mode 100644 fs/erofs/namei.c
 create mode 100644 fs/erofs/super.c
 create mode 100644 fs/erofs/zmap.c
 create mode 100644 include/erofs.h
 create mode 100644 test/py/tests/test_fs/test_erofs.py

-- 
2.25.1

