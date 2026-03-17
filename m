Return-Path: <linux-erofs+bounces-2792-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B5774FD8740
	for <linux-erofs@archiver.kernel.org>; Tue, 17 Mar 2026 11:18:36 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4fZqG32vJFz2yj1;
	Tue, 17 Mar 2026 22:18:35 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2607:f8b0:4864:20::102a"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1773746315;
	cv=none; b=QrsOlL6wjd+u1GP68omoRHcH11qzSI+fLscinEWRXpNwX6rx0Reeo64NSTtHrf8hIm6d4SxrN/pNBxGLoOb7b+4DHMKvpUf85HdMRdbPv0UD0xzE5HxyFD7YDQ+8AqBEEn25oy/Hw0/zvt98QoFHZd7SjWLqgiTmBX6/RBGGXEc+Ld2487c5SouozQLeIReznOnolriJ10hwxOmRyXZ8VpIjyoIbrG7UiMTVE7FsMAIeCaEVlGsp6XW/ZBxzE/eIcvhhZxqwYh4KacNZ9s/Df54hXRICVP7ozOfIBKsagzU8Pz6FoYti15J9srPTy/fruy35iNaL3qHuYPIO1rxYIQ==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1773746315; c=relaxed/relaxed;
	bh=WJwB2aZO5ezWggopdA6FSNQyWgs7aWy0shX4d1FUz/I=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=W4nWlvckwwWkYWAUURg2E17HXsWpUAVoeUw0PuifFzBlgH1v+WE8l0dE37ynZG3Xm0eqKzUsIi7tc2zA3oSMzavTHs0/oIXwcZoxPs8kvLFHMPskRK6A9KmnTDmF7+IubWkFpNUr9xL7MRTtudqHGBCdglp1ztWF38PN3Idur10x7jZg7hoUB79YjBEiGIV1lFMt8aef52sMffOjmBdlJcSoh3sf/W5OjOIyIUHop7+PtndCh/C7O6TMnvWdGQeh2hMCOlI5qEaSpPz452zj/nkk6NjyGaZyHFYoOwtQZ2KEeQoytr6rcAl25NYa3qdGv9geCXtFZz2p0MqNdBnR8g==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=gmail.com; dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20230601 header.b=EhAuIQaP; dkim-atps=neutral; spf=pass (client-ip=2607:f8b0:4864:20::102a; helo=mail-pj1-x102a.google.com; envelope-from=singhutkal015@gmail.com; receiver=lists.ozlabs.org) smtp.mailfrom=gmail.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20230601 header.b=EhAuIQaP;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=gmail.com (client-ip=2607:f8b0:4864:20::102a; helo=mail-pj1-x102a.google.com; envelope-from=singhutkal015@gmail.com; receiver=lists.ozlabs.org)
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4fZqG16yswz2yfP
	for <linux-erofs@lists.ozlabs.org>; Tue, 17 Mar 2026 22:18:33 +1100 (AEDT)
Received: by mail-pj1-x102a.google.com with SMTP id 98e67ed59e1d1-35a277dcff6so233628a91.0
        for <linux-erofs@lists.ozlabs.org>; Tue, 17 Mar 2026 04:18:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773746310; x=1774351110; darn=lists.ozlabs.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=WJwB2aZO5ezWggopdA6FSNQyWgs7aWy0shX4d1FUz/I=;
        b=EhAuIQaPZiiEVBfN4HODqdrdN7eVGGHVE7J7YD+/LTgw+qo9KAA7rt3hvXSy6y1bJk
         0jelOrtmYrRtm8lIWAlWrQdtxqR/jP/fIn6NbtqH9A5w6FaYMeWjI6SsRNYe1f33EEvs
         rH2IcM1iLmhJyff35gBh2SXfgYGTas0yoFVgh2IRat/+mXpXz4SYpkApngDOOt9b70Sc
         El4NzxpRPh8Fgfoa8VvVjzClhlwq6qLLsDL1GfFy/HoCaUB7pz0mAnOgb4++YyeZsx7b
         4r/RGpiLY90v7r/Tmk4HsrsBPycO9Yi/HhOMRAJGR/v1ECSkQMYVOurB3FaZpeDlTyco
         Ynqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773746310; x=1774351110;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WJwB2aZO5ezWggopdA6FSNQyWgs7aWy0shX4d1FUz/I=;
        b=Q1B2bs4Dh8qPU/36VbGeufpLgJsop1xM2M5Hn8AndKD+E4A7sokgsVwNAcSagF4qom
         eP0/Fyh37C31/lT+fvwl7tuLUsKQifkgYWaoy9SHX3OVs/ZUdyCLOJ0hUS6BJNWzH5Fk
         1pS2hCpu6qcFQZBDX7ZHrLUg3asLZytPbyCTRRveCSVCcn9lpVfzRpUlS3p7GNmUwNwn
         O6l5DC7d1hoTftsDv1ZGqnXJ1al3OeBGNhgY8VKkyGpjdJhNfKWyMilTKBz7V2ILwTZy
         0M6V5GumnRDMqJQu+MKwBLXoGhdoG+AI+/Ac9YENxAaHRb9eZWcfuDaAlXiC97cQfzE2
         n59Q==
X-Gm-Message-State: AOJu0Yz3cJzFYKPVVTgk8v2RzdNChQlICOmy8LN1wQgbJPQd+Gt6ntux
	2hRsE/6VZlU1UKh1XBp/9zdbStnyzOicdfOth18eS7Z8I3+0FWpMDBjxzefyz01P
X-Gm-Gg: ATEYQzywXTyHWPRzJQpB4BwS34RHHFrEqSBWfldUe8Aua2fmYtaY+NXqyqb44xvVurR
	JT/BzbAw+oYY26S+dwWO86Ty7wE5VJhYD1+mijW/TfAZy4IcT3U0clVsAUgmmXy9MKkLmCg1i1y
	JboMz2qOf6bBfxUY/ByqoI7UvQ6dzE5Ve9MdX84vZLw0+vV1e7Ou/cGEPkSe1xHiV0TDs7kHoGq
	3PJ0QBUnVcu8QRanhxlnTDJsAP3utvJAbyliHd1dMH8Qs/+AQkPiGc80Q17l2OYVSNx3+LUxOxD
	rnTvAlF3Ht18N2nM74+J8BCvalsurZt5QK+5GZFYjUKlUNRwJpKi6dI4jEvrt55BztU0PMO8XW9
	yZlbepGKy5jWl3OY8Rq50xWQj4Ss/GrsVX+7MCyiiqB3ws0kpWVPHWT6sG3Q0D7FBDYYc/X2WZ3
	Dgt0YOlW1iD1fXKLx96cCoMQzSckZzNTvW9XepruvnpfuYwu+lC6oMKLeR5EYuZWKu7Zji4FX62
	X2IeXbJ63S15ApLKJweovcTsHBaBJ9Fdo5FDQ==
X-Received: by 2002:a17:90b:180b:b0:359:ff8a:ee4d with SMTP id 98e67ed59e1d1-35a2206cddamr11313548a91.6.1773746310425;
        Tue, 17 Mar 2026 04:18:30 -0700 (PDT)
Received: from DESKTOP-PU4IGQQ.localdomain ([117.203.246.41])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-35ba4b3ae18sm1894794a91.1.2026.03.17.04.18.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Mar 2026 04:18:30 -0700 (PDT)
From: Utkal Singh <singhutkal015@gmail.com>
To: linux-erofs@lists.ozlabs.org
Cc: xiang@kernel.org,
	yifan.yfzhao@gmail.com,
	Utkal Singh <singhutkal015@gmail.com>
Subject: [PATCH] erofs-utils: lib: validate h_shared_count in erofs_init_inode_xattrs()
Date: Tue, 17 Mar 2026 11:17:43 +0000
Message-ID: <20260317111743.84988-1-singhutkal015@gmail.com>
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

erofs_init_inode_xattrs() reads h_shared_count from the on-disk xattr
ibody header and uses it to size a malloc and drive a loop that reads
shared xattr IDs.  If h_shared_count exceeds the space available
within xattr_isize, the loop reads past the intended ibody region
and the malloc is oversized.

Validate that h_shared_count does not exceed the number of __le32
entries that fit after the ibody header.  Return -EFSCORRUPTED with
a diagnostic message on failure.

Reproducer:
  mkdir testdir && echo hello > testdir/a.txt
  setfattr -n user.test -v val testdir/a.txt
  mkfs.erofs test.img testdir
  # corrupt h_shared_count (offset = nid*32 + inode_size + 4) to 0xFF
  # then: fsck.erofs --extract=/tmp/out --xattrs test_corrupted.img
  # Without patch: silently processes invalid shared xattr IDs
  # With patch: returns -EFSCORRUPTED

Signed-off-by: Utkal Singh <singhutkal015@gmail.com>
---
 lib/xattr.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/lib/xattr.c b/lib/xattr.c
index 565070a..5888602 100644
--- a/lib/xattr.c
+++ b/lib/xattr.c
@@ -1182,6 +1182,14 @@ static int erofs_init_inode_xattrs(struct erofs_inode *vi)
 
 	ih = it.kaddr;
 	vi->xattr_shared_count = ih->h_shared_count;
+	if (vi->xattr_shared_count >
+	    (vi->xattr_isize - sizeof(struct erofs_xattr_ibody_header)) /
+	    sizeof(__le32)) {
+		erofs_err("invalid h_shared_count %u in nid %llu",
+			  vi->xattr_shared_count, vi->nid | 0ULL);
+		erofs_put_metabuf(&it.buf);
+		return -EFSCORRUPTED;
+	}
 	vi->xattr_shared_xattrs = malloc(vi->xattr_shared_count * sizeof(uint));
 	if (!vi->xattr_shared_xattrs) {
 		erofs_put_metabuf(&it.buf);
-- 
2.43.0


