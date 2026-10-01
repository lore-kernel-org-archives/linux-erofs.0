Return-Path: <linux-erofs+bounces-4645-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8777FCA5FA5
	for <linux-erofs@archiver.kernel.org>; Thu,  1 Oct 2026 06:02:22 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hwLsm3pk3z2yMP;
	Thu, 01 Oct 2026 16:02:20 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2607:f8b0:4864:39::c"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1790834540;
	cv=none; b=PLMOAn79t/GvqKVHe9QeaEmWOOPsgSu29eVRZWwHLIgpDPoXVuLs7aCSReV1og5blV1xlz9a8lkmSPcj7DmAl/oyU9GIbKoB87NOLvDN6mSqLnV9lQANNZx2y3s/UuLVOAoV0FhjfT5wkchJMmtX2RAKyU1cil+9p2vN0a5fJIH6c9JBXPFM0ZrBIVdDH6XcLCqfJ4cuO7H466DE/Gm+FFoMD983kE7jq5cIz8yEZavHlsTRdNo9XIcIk8DyXTCkFlDnkGxydL7nUQPUO7dtINKaSCb9ya2xvWTMuw+PuoDvo+lVSlcfpYskBEyvHL7ai2zJQJMYUNcL5W7x7Tnq+w==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1790834540; c=relaxed/relaxed;
	bh=7NgYYXX+3pYT7yeSiDeSwVSAtcZqCQ1BZxSB1MwHyIo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b6rIxu+ZQT6ctxHHC94/FABbDr1x+KRi7x+X0FkP9h2DlRha50XS7HS3nwI3Q5WvuVydXgIG76qQCSAo1qQXEjJ71QEbXaRt4MNo7XZ9Baz96LjtqCIWGRvcDwNoO7fUvLi/hPc8+yDANpzbyEwvF2wUQXijdsLM+sjSsQ+C4Odj3+IL/Rc8sYSv5GmnOCcg6eftn9hvaOtbJ/IJB3Wr+YdUPdVvY6m9cZhVBtaifFN2cubknHbw1uBzuFohZSZJHT7c7Xa1AnPjy1FYhmLYFXDMc9Z2RniomzwlcWB2iF+CuXIPGmLVmsIEq9VNN8/t5kBdXid0zCjJx9l+ocjbVw==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=gmail.com; dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=a1GeuVsb; dkim-atps=neutral; spf=pass (client-ip=2607:f8b0:4864:39::c; helo=mail-pj2-x0c.google.com; envelope-from=l3b2w1@gmail.com; receiver=lists.ozlabs.org) smtp.mailfrom=gmail.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=a1GeuVsb;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=gmail.com (client-ip=2607:f8b0:4864:39::c; helo=mail-pj2-x0c.google.com; envelope-from=l3b2w1@gmail.com; receiver=lists.ozlabs.org)
Received: from mail-pj2-x0c.google.com (mail-pj2-x0c.google.com [IPv6:2607:f8b0:4864:39::c])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hwLsk57Glz2xsW
	for <linux-erofs@lists.ozlabs.org>; Thu, 01 Oct 2026 16:02:17 +1000 (AEST)
Received: by mail-pj2-x0c.google.com with SMTP id 98e67ed59e1d1-3a2adb9bc3cso2476143a91.2
        for <linux-erofs@lists.ozlabs.org>; Wed, 30 Sep 2026 23:02:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790834534; x=1791439334; darn=lists.ozlabs.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=7NgYYXX+3pYT7yeSiDeSwVSAtcZqCQ1BZxSB1MwHyIo=;
        b=a1GeuVsbleOwxe3HLgkEBPvXtNk0jK6Q45N2e00R1pfKHltqu4rCTN42oKy5TiCp7d
         UJP+RXCUa0pZGwNC/9ST5wvYvpGhz6JVmzpKHbSo6ScYjv57n0shoj0VsBr0QJ5cf3Bj
         Y/F/vdpN/bZcrsbhdRsV1i80JoYBAlT17zI88yDIwlRN9Si9ROeWYsTh8M7Sh+SpGH2r
         rlcystEKV6Q6OWP0pkG64VX1dOQJ2ic7BIgyIzAlJAKsQQHWMhaBZAy4cKc8bALE8X2Q
         H7nruGpuePBqG3SoZFeV+rRYXzszmzHIq19IZw3iyZeBDH8dJQZbszJ3GaQXysVc97h/
         cAxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790834534; x=1791439334;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=7NgYYXX+3pYT7yeSiDeSwVSAtcZqCQ1BZxSB1MwHyIo=;
        b=lI4DL3AqLsMrIDMaZrplyoaxa0/GZt+ipYEjsbV+lTHTk9UZiXCmj5tDlnxZvvkSYG
         plX9DSd23VuHSnQSdpKwRCDmhp9iJt10h9vWdi+z3Ty5D7QYDwGOe9F1wncczA9fEb4R
         Ep33xIGDC3s3kyoADm9d3nmd56L9/7BOY0CmRrBe+JS7T3zra8ogmjxjdYUQTYHTj+ef
         uGetO5ZIj3ra1+z1I6XEoJGcvaQ6UPEWjLI6SRhZqlkATBEJKs3wllMa7nCKpHNSmVM6
         EUVzMfhAkIe2xUppILjTT0K62bakWUbr4HxudkH9ATTXNRf8PBu9Pzu0jik437EJ8TMb
         zl1w==
X-Forwarded-Encrypted: i=1; AKwUvBz/vZP+dUHcsHUuzP8Xz1sVmOQms1XC4+3pSmECA5y6wjPUKz+8DYYats7YV2XngWyeAHiejqwLruJfAg==@lists.ozlabs.org
X-Gm-Message-State: AFq9FYI0mTVVjRvjdz0IXs1rrb8MXFosdQmEtNMi/KZJMs1hnGTKOdFz
	28vO2nO6YbueBasAPLFth33moQ4Vw2uoUGj5xq/iE6pdGX2ZJQdZsLQcXCYvlQ==
X-Gm-Gg: AYBFou2yBpl/xv/Yk61emaLyAseOWXxlwLpKvGVWt6kvzyhUD1+mW5ZmrdPoIpEFwBY
	+SbqbJi3AswU+EzuRTQBAYcerExNkjF2iGOk8ymndBx1jnxTMNTn/Uw/hd65Zwp/54AsHXjW8I+
	3oGlaxLqxhCX16USJwGMZfu9wGiBDr7OFIWT5Lk/Ns31Ux64AAcdqCjPP+UvgbIgkitXCnTB6LE
	f3egolY/fV0tjBMxEfIGPCuPQjPV2ggGthC9fO2oxvEhtPChQ2EjeMvBFJh/Vm/yq10/SaE8XGE
	IqTpsqX01ZNOD12FetdcOsecujOMXJ/7ac6EbziC0uDINLmda0Q9YIY/lOFi1/phRFElvUD1Pk7
	gQcuSkIs0idTtaj5R3J8G1hEQh27z8VCeEIptUkcQeSQawVvetp4ceo33qDIt+uotptPtaJVN4Y
	S9rhIAtqBoaCsSeo8bodFho0K6fGG9ZZ3jgWFhVGJ9SuOiTAHIdhGqVNCwKCisad2XGO9W7Hek6
	ZQ=
X-Received: by 2002:a17:90b:1c8d:b0:3a4:b8f6:e176 with SMTP id 98e67ed59e1d1-3a4d18f39c5mr1377205a91.53.1790834534478;
        Wed, 30 Sep 2026 23:02:14 -0700 (PDT)
Received: from vb ([2409:8a2b:a18:4ab0:48f2:54b4:489a:3ce0])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a4f44c02absm2752433a91.15.2026.09.30.23.02.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Sep 2026 23:02:13 -0700 (PDT)
From: Binglei Wang <l3b2w1@gmail.com>
To: xiang@kernel.org
Cc: chao@kernel.org,
	linux-erofs@lists.ozlabs.org,
	linux-kernel@vger.kernel.org,
	l3b2w1@gmail.com,
	"Bo Liu (OpenAnolis)" <liubo03@inspur.com>
Subject: [PATCH v2] erofs: fix folio reuse from a different address_space in erofs_bread()
Date: Thu,  1 Oct 2026 14:01:31 +0800
Message-ID: <20261001060131.51103-1-l3b2w1@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <ar1xOV3x9ZMGx9XY@MacBookPro>
References: <ar1xOV3x9ZMGx9XY@MacBookPro>
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

erofs_bread() reuses a cached folio on page index match without
checking folio->mapping.

xattr.c calls erofs_init_metabuf() twice on the same buffer without
erofs_put_metabuf(); the two in_metabox sources differ, so buf->mapping
can switch while buf->page still belongs to the old address_space.
The next erofs_bread() then reads the wrong mapping, dropping shared
xattrs with METABOX.

We require folio->mapping == buf->mapping in the reuse check; otherwise
drop the cached folio and re-read via the slow path.

Fixes: 414091322c63 ("erofs: implement metadata compression")
Cc: Bo Liu (OpenAnolis) <liubo03@inspur.com>
Signed-off-by: Binglei Wang <l3b2w1@gmail.com>
---
Changes since v1:
 - Drop the redundant erofs_put_metabuf() call; setting folio to NULL is
   enough since the slow path already releases the cached folio (Gao Xiang).
 - Rewrap the commit message to 72 columns.

 fs/erofs/data.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/fs/erofs/data.c b/fs/erofs/data.c
index be63b89f0862..4b9fe670fdda 100644
--- a/fs/erofs/data.c
+++ b/fs/erofs/data.c
@@ -33,8 +33,12 @@ void *erofs_bread(struct erofs_buf *buf, erofs_off_t offset, bool need_kmap)
 
 	if (buf->page) {
 		folio = page_folio(buf->page);
-		if (folio_file_page(folio, index) != buf->page)
+		if (folio->mapping != buf->mapping) {
+			/* the cached folio belongs to another address_space */
+			folio = NULL;
+		} else if (folio_file_page(folio, index) != buf->page) {
 			erofs_unmap_metabuf(buf);
+		}
 	}
 	if (!folio || !folio_contains(folio, index)) {
 		erofs_put_metabuf(buf);

