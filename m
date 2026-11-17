Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30AD7606A33B
	for <linux-erofs@archiver.kernel.org>; Tue, 17 Nov 2026 07:27:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=TYM3RA9+
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4jTGWn23gwz2xqL;
	Tue, 17 Nov 2026 18:27:01 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2607:f8b0:4864:20::42a"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1794900421;
	cv=none; b=KwXznY8bpV/9dQ4sASNMMhL4lP87Rypo/hGrh/looVIucZs8e7TDr9r6/fsVPcckIvQ2N2tNmw+qT71wZLRe8phrpvrkXeHXgEJuhFcEAaa8UNsuJ779BhwIn/x1wsHAS3BLQBQQxmknz9+YQ7piptXF/IQESjnAgvy3AjsZGnfWudmgPj8+JuA2VB/fz50b+KxXwI64g/GUMwLQksIgiyzfZEBVcdRgXnjK5Bs8trnnujsRfR+5bkz+IZ1APPGzOMejfslWnHlRLDcAwUNWyPQo3cWNExWELTsJnUytc6XtoAkmdArqjCJWiGNyvairRg9rXnNUDuQuEn+SP0YDYw==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1794900421; c=relaxed/relaxed;
	bh=nUMrIpNHU237UyVUGlbm7HhUN4wwc5TLab34CkLX1Is=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YAymOEvTiIeY7wC6vB22WoLyzg9ZT+QMZwWEBHBg0kpECEydk0OKxMtQ10sK3cbLHuPkPrhE9LlXSOovlH5/G4BIgI56v1FhFtOKT2oSDOimed9WIXp7hn0G8D3XQo0ev7gfr2fC3+mxRhZoPy2jh4b9blL0LtDoaOg0U7Hf8ORpIXv586L6E0jKcNV6RqLCZU+Nq+lMiYAEpG0ZaCkSJNKtXMUcTktHjxDwbdeI+8Nr5+irwCJzV80zn9OTb1VZG9ANoH1BF3bzrVNMUJ4vpH0qV1FczP1v6o0j5YkdHHJh7FvwC38kz0i75juj1+2twReMBQ4siJ82JJ1y1U9/Hw==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=gmail.com; dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=TYM3RA9+; dkim-atps=neutral; spf=pass (client-ip=2607:f8b0:4864:20::42a; helo=mail-pf1-x42a.google.com; envelope-from=stopire@gmail.com; receiver=lists.ozlabs.org) smtp.mailfrom=gmail.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=TYM3RA9+;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=gmail.com (client-ip=2607:f8b0:4864:20::42a; helo=mail-pf1-x42a.google.com; envelope-from=stopire@gmail.com; receiver=lists.ozlabs.org)
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4jTGWl4dfyz2xPb
	for <linux-erofs@lists.ozlabs.org>; Tue, 17 Nov 2026 18:26:58 +1100 (AEDT)
Received: by mail-pf1-x42a.google.com with SMTP id d2e1a72fcca58-8a070755c8cso2336378b3a.0
        for <linux-erofs@lists.ozlabs.org>; Mon, 16 Nov 2026 23:26:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794900415; x=1795505215; darn=lists.ozlabs.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=nUMrIpNHU237UyVUGlbm7HhUN4wwc5TLab34CkLX1Is=;
        b=TYM3RA9+KaXTv24RMasL9rgocsJvMV8v1c0eYBF7BWVgggQddM5kTjgWlEqfN7szSC
         hi7nHujKoBNGK+ibnuxzEjPNYhgmiCn6n8XuMOCIh56ZUMCd0qo1AXt6F6//b3zLYB64
         Z6tJ5xtZOIbaMCQgeCnG53ceutYPNFBojm6dyLPSqDVsrWY32vJVN7t9MAl6/kJkrw6y
         GYfYCYRsgnMls6S8BWpdmrqO/r7FL9+cbB2ko+FKZC37QwF354JVhkyVh1bkBEmXboJG
         2C+Tmu5YEAUBW0y7U0zFbENz159zB1aow9uV7xl3jOx9Eh3QD1XCiPkO/kzB0FB8A895
         zLUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794900415; x=1795505215;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=nUMrIpNHU237UyVUGlbm7HhUN4wwc5TLab34CkLX1Is=;
        b=GyULniwVmorqdJceZ+P3keYsBzQ2goTNUoSY2ntntfwZ9Vx2/TYBUz+EB9r7E6EX1N
         cmbvzy1QJShBSl8XNy8oRKUtBKPiGjD9R/G1zqioKhu4n7DmypJnhj4Qcjreh69VZjFO
         pWJJKRlZwSGORXjGSK+G1M0QbFYj/FxzFOUg3rk7xFfmNzSqs9cxqBNOZcT3JNCONpXu
         jGVl5fXCOEkoYh1Gp0D/ddnAnxT6pbUrxh2Yryyu8rce2W0VPcGVHHbJbR1ELRWxfOhW
         WSaEG9C1Okmg6wDkarcca8hH0DO1TvlePHoK1TN8xFxoR1Dqi+RkGnUl2sX926FdMliw
         JCfQ==
X-Gm-Message-State: APuU4Z8sm+MEA7UBuPz2rLXyxlmTGt7IiMTlarK5sfFEQUK6ssa799AE
	KpHJN8SaENlDLQeCYnMk/p2HooohuOQTrGsePhZuHLAx1uvUACpxUFRdMLc9Zvcbxhw=
X-Gm-Gg: AYBFou2z7OQnBDTqY2/BDDxTTx/A+h2K1vZr8BbI3k9sDSXAtUNK6z+gedptj0nFlDN
	ZImqrJtGFpPJc46BtIGmqLakAL2L+sAJ+9FvOgdQ0q5W+CLWdVXUlYcWpvWaKAYFpfD2eXPRi71
	ADdxM7KfGO4gxjxH6hTV1AINoz25xMnG4elEftA8GotPRchYl1mYoUVaRwlEZpI+tUzPI+sql5l
	CJFuwwiT/MJ6VXplkFcRx2xi+FCd7JbLxUWlx+q7/vYeXtGRBnkCHw9fWrWKe/UX6ijofbnm/cu
	iD9zwflSC3dvi3fh4KgJHfOjSeRElUeS7cxaFD12z+D8FhU+QJXQ+hvM+HITLTyKP9GCEshPnqt
	8xr3jNldqSv/+OHxoh+87FjmsQygstsWJJ126UaPNnNIISf6QRN5eWfN8faqkbO+3GjQgVlbOUG
	YwNFJ02nOqXq5SMAeJh5RlsFFTU67tFhhtxu9eVi6x7Fy1x/pwpWV7/wbx33bIHx0hf+cgt8qqv
	15V2Y4j2usX7KpwieY0RkKER+WD7Obdol7Tvv1Y8YycrZdv6B/Bg4ymV2j9gQaDKPyVGr3rIQ+r
	+4tTaL+YKF15Hm6jammDQqPU8rSsmY3zbWGv2FlqIc57uptN
X-Received: by 2002:a05:6a00:bd10:b0:8a0:1931:e6f7 with SMTP id d2e1a72fcca58-8beb7055eb6mr11383737b3a.10.1794900415379;
        Mon, 16 Nov 2026 23:26:55 -0800 (PST)
Received: from zyf-laptop.tail52ade4.ts.net ([124.70.231.56])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8bed2055031sm4940716b3a.39.2026.11.16.23.26.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Nov 2026 23:26:54 -0800 (PST)
From: Yifan Zhao <stopire@gmail.com>
To: linux-erofs@lists.ozlabs.org
Cc: xiang@kernel.org,
	Yifan Zhao <stopire@gmail.com>
Subject: [PATCH v2 0/9] erofs-utils: fix issues found by LLMs
Date: Tue, 17 Nov 2026 15:26:20 +0800
Message-ID: <cover.1794899782.git.stopire@gmail.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261112124725.2774244-1-stopire@gmail.com>
References: <20261112124725.2774244-1-stopire@gmail.com>
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
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=4.0.1
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

This patchset revises patches 4 and 8 of v1. The other six patches
have already been applied. The nine patches are organized as follows:

1. From v1 patch 4: fix the inline data buffer leak on rebuild failure.
2. From v1 patch 4: fix the fragment buffer leak on realloc() failure.
3. From v1 patch 8: fix erofs_io_read() caller error handling.
4. From v1 patch 8: fix erofs_io_pread() caller error handling.
5. New in v2: fix erofs_io_pwrite() caller error handling.
6. New in v2: fix __erofs_io_pwrite() caller error handling.
7. New in v2: fix erofs_io_fstat() and erofs_io_ftruncate() error returns.
8. From v1 patch 8: report the ublk handler's actual I/O result.
9. From v1 patch 8: limit OCI blob copies to the requested length.

v1: https://lore.kernel.org/linux-erofs/20261112124725.2774244-1-stopire@gmail.com/

Yifan Zhao (9):
  erofs-utils: lib: free inline data on rebuild failure
  erofs-utils: lib: fix fragment buffer leak on realloc failure
  erofs-utils: lib: fix erofs_io_read() caller error handling
  erofs-utils: lib: fix erofs_io_pread() caller error handling
  erofs-utils: lib: fix erofs_io_pwrite() caller error handling
  erofs-utils: lib: fix __erofs_io_pwrite() caller error handling
  erofs-utils: lib: return negative errno from
    erofs_io_{fstat,ftruncate}
  erofs-utils: ublk: report the handler's real I/O result
  erofs-utils: lib: bound OCI blob reads to the requested length

 lib/backends/fanotify.c |  3 ++-
 lib/backends/nbd.c      |  2 ++
 lib/backends/ublk.c     |  2 +-
 lib/compress.c          |  4 +++-
 lib/fragments.c         |  6 ++----
 lib/inode.c             | 13 ++++++-------
 lib/io.c                | 24 +++++++++++++++---------
 lib/remotes/oci.c       |  1 +
 lib/super.c             |  2 +-
 mount/main.c            | 10 +++++-----
 10 files changed, 38 insertions(+), 29 deletions(-)


base-commit: b9dd73fb478ac88fc142e6430ed71be43dc65cab
-- 
2.56.0


