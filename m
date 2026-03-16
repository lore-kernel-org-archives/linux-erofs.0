Return-Path: <linux-erofs+bounces-2762-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A7D87F53D94
	for <linux-erofs@archiver.kernel.org>; Mon, 16 Mar 2026 20:20:20 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4fZRKb1NZJz2ygn;
	Tue, 17 Mar 2026 07:20:19 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2607:f8b0:4864:20::631"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1773692419;
	cv=none; b=Dk0X/mS9nkwCyDlOlTonEGDo33pO8MghL44ZsWaVcNA4aPqXQlN9dEQ1+eJ5eT/w154ZdEqkH0loCrDTPKsKgSIzv1CeAhnHiY6OLmRYbynw4KQ4NUzso9gJW6rC1sB3XEjXFN17pzuFl/1dskr2m0r1jP/HMUbXfATfrDa3kTw7tHBJ/1LwP7xDGLlWsVrcGceEO+N4O+WuSj2wOk7X915m8EgtVxzfyXRr0UVZnjNtFMH/Gtf+5d9hGvnq+tRHyObpuH0j3N2bV/XQJnF4XDXXCSUtKDhH+/NE6qS9z67kCgViAWk5GeVZYo9QSKuaxOG/rF4n7HmfmyqSjM6q2w==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1773692419; c=relaxed/relaxed;
	bh=TUKpr+YlIbI5r7yPeTkOeBRcFPuKiaNpkesCDutQmY0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=LRlK/lHKUUgEx2DmE5mQRyAaM91vNxX7X1BYkDycKohp/0yNqM7r4/SeJZl/6yV9ZcMSb6H7JNLcR4IHu9sOYGorPITVTQ3zL5TxfeyazCFsK27yVf7m1zPszx8/FdrfAasGqSTMQcdA5DnfIxPpJN+88+OdiVA8J5TGzchOrENjco1V9QvsjVUR1AFEq2yXrbf4hfijpt1i393DRdEeZ8+gUwBSFek5JUMXey08mWB9yK9iE3GD0v4B+sMG5xWFeUTdX0hu60JppaD8njBMjzbertNbByRz7YewevsR0H4oTwCu8d/0ZsaZpo4HctLQ/z9DqxZI5ak14dT6TnCa+w==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=gmail.com; dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20230601 header.b=R+gGwq4J; dkim-atps=neutral; spf=pass (client-ip=2607:f8b0:4864:20::631; helo=mail-pl1-x631.google.com; envelope-from=singhutkal015@gmail.com; receiver=lists.ozlabs.org) smtp.mailfrom=gmail.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20230601 header.b=R+gGwq4J;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=gmail.com (client-ip=2607:f8b0:4864:20::631; helo=mail-pl1-x631.google.com; envelope-from=singhutkal015@gmail.com; receiver=lists.ozlabs.org)
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4fZRKY6hD5z2xQ1
	for <linux-erofs@lists.ozlabs.org>; Tue, 17 Mar 2026 07:20:16 +1100 (AEDT)
Received: by mail-pl1-x631.google.com with SMTP id d9443c01a7336-2a9633ef0d6so3170635ad.0
        for <linux-erofs@lists.ozlabs.org>; Mon, 16 Mar 2026 13:20:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773692413; x=1774297213; darn=lists.ozlabs.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=TUKpr+YlIbI5r7yPeTkOeBRcFPuKiaNpkesCDutQmY0=;
        b=R+gGwq4JYJG1/ADdDTZS/a96JBGU8RkHPS1MWkF+iYPX+qbmsgfYusQfK/STQHrxaX
         COVn+JprK2HImugQHyFPVF7LTnXeH0AKafH2n1KT4Pr1KH7E9/B6a/H3noXvisGg35qv
         c5w3+cqIGSNNNUZpS5QQoaQaBetoNQ/s2Qaqi6gzQOWxthUn1oVZgcQAD9fpjrZzhW8a
         uqMGGWTnoTsSiQXpasnPBn/94mzRXXP22+cD1OfM+qUFcZMFqShoaPPHWfU2kBe607fk
         O2VAiA8dLxg3syOgZ/ZQvdRyU4FwRsVJJ0wWl8wPs5YmoGhPy468cdDLmaNtPVly9SeX
         oCMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773692413; x=1774297213;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TUKpr+YlIbI5r7yPeTkOeBRcFPuKiaNpkesCDutQmY0=;
        b=OJGY9UV9/I3zV8pUkTaYQ8dW+8OyerQxj3Yr24nEBfc2f98Ojwy/ZauRl/8JHqU6WE
         J0IvnROM3qHU00rK6dmJORchlYHEwdQW7ujIgPQVtn+69IrJslnyeb6HK8sFLfIEe4mZ
         R3hWuJR2HSnjB4SYhZud4jDBepoJYg+eM1nO6tEGEmux67abidVrVPqVGBqrTYvC3Voh
         bSTIrrrXLkOTyGRGNKykr3rAWjC1X5oUpQCsRqFu6NZNHHQUGCjXSQUh7Gscmh4fP3V8
         zjOLB+g35RZrCexSYr/yTUsw4ueKCiS5m2GKavYhnxJyrQPyhKAx1vS6z4NFxNuEkTXj
         oFFw==
X-Gm-Message-State: AOJu0YzB7ix1qmSseZI7hGCb9fySv2KmyNvdtBnetRMuTWv7cnxv4E/U
	fboOwTOEQ8HASWQ7OmyCTydAdmFzyc4pcAePjZKX9vgJ/armWzy7nGx5QTWCLLeM
X-Gm-Gg: ATEYQzyktYRQGJdEY1WuIUsijIE3dvtnT/F1rvA23d8zMkziC4FVulSxYslv4nwZYFQ
	xYSG2LUkhokCpIZp1AIy4Dv5m30zT4ZNjGjNtYuIB9blsJF5Y7IY0qVLxpL2OgIhVWnXew5hD4h
	3HEb3dy4g71+TuTaQpkPBCLtwUYAK9fUqjFQiZV/+ump8XqePGvLSuVcMiuGrVh8GB6vyr7KeKC
	ZS7bRjxI54YKA/dVO4zDayBv4GH7LqLAEe1O3XvQW2EN3I90o8oWL5V9UlruXGYAfpal8I/caBm
	MckzGJBwzfq1gxvBjh2P2dTSf9DSO5PXmmJhM3k0/2JdbvKJFn+CQLz74gRUG32G5T23usLVbGe
	3D/Vkz/mTI6hoAC5nBSV+w4oiD75SmF9Ku66RMajTqai53lgWUNzSHg7zgOr6lA6O66rC9ITMvi
	u6sh2+E+ZUikRCjaVU/wzwfdC+yPF0CQFj9Hxx2/0hFs4iORSjm8HlcErHP1YOCfz4wgewYQoie
	VgJc/AIFS9+eOBRirnnLe2WqFt17zo8+BKL9g==
X-Received: by 2002:a17:902:ccd1:b0:2ae:cefd:18ce with SMTP id d9443c01a7336-2aecefd1e81mr83617755ad.2.1773692413252;
        Mon, 16 Mar 2026 13:20:13 -0700 (PDT)
Received: from DESKTOP-PU4IGQQ.localdomain ([117.203.246.41])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2aece56e0b8sm143190895ad.16.2026.03.16.13.20.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Mar 2026 13:20:12 -0700 (PDT)
From: Utkal Singh <singhutkal015@gmail.com>
To: linux-erofs@lists.ozlabs.org
Cc: hsiangkao@linux.alibaba.com,
	Utkal Singh <singhutkal015@gmail.com>
Subject: [PATCH] erofs-utils: lib: validate h_shared_count in erofs_init_inode_xattrs()
Date: Mon, 16 Mar 2026 20:19:19 +0000
Message-ID: <20260316201919.41839-1-singhutkal015@gmail.com>
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

erofs_init_inode_xattrs() reads h_shared_count directly from the on-disk
xattr ibody header and uses it to size a heap allocation and drive a
read loop without checking whether the implied shared xattr array fits
within xattr_isize.

A crafted EROFS image with a large h_shared_count but a minimal
xattr_isize causes the subsequent loop to read shared xattr entries
beyond the xattr ibody boundary, interpreting unrelated on-disk data
as shared xattr IDs.  This affects every library consumer -- dump.erofs,
erofsfuse, and the rebuild path (lib/rebuild.c) -- none of which call
the fsck-only erofs_verify_xattr() before reaching this code.

Validate that h_shared_count fits within the available xattr body space
before allocating or reading.  Use a division-based check to avoid any
theoretical overflow in the multiplication.

The subtraction is safe because callers above already reject
xattr_isize < sizeof(struct erofs_xattr_ibody_header).

Signed-off-by: Utkal Singh <singhutkal015@gmail.com>
---
 lib/xattr.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/lib/xattr.c b/lib/xattr.c
index 565070a..6891812 100644
--- a/lib/xattr.c
+++ b/lib/xattr.c
@@ -1182,6 +1182,16 @@ static int erofs_init_inode_xattrs(struct erofs_inode *vi)
 
 	ih = it.kaddr;
 	vi->xattr_shared_count = ih->h_shared_count;
+	/* validate h_shared_count fits within xattr_isize */
+	if (vi->xattr_shared_count >
+	    (vi->xattr_isize - sizeof(struct erofs_xattr_ibody_header)) /
+			sizeof(u32)) {
+		erofs_err("bogus h_shared_count %u (xattr_isize %u) @ nid %llu",
+			  vi->xattr_shared_count, vi->xattr_isize,
+			  vi->nid | 0ULL);
+		erofs_put_metabuf(&it.buf);
+		return -EFSCORRUPTED;
+	}
 	vi->xattr_shared_xattrs = malloc(vi->xattr_shared_count * sizeof(uint));
 	if (!vi->xattr_shared_xattrs) {
 		erofs_put_metabuf(&it.buf);
-- 
2.43.0


