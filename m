Return-Path: <linux-erofs+bounces-4643-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 91304CA5FC4
	for <linux-erofs@archiver.kernel.org>; Wed, 30 Sep 2026 19:19:52 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hw4cQ3FSYz2y24;
	Thu, 01 Oct 2026 05:19:50 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2607:f8b0:4864:39::c"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1790795990;
	cv=none; b=FeGLZtfD+HRstRjOYPsIWM1uVPx47jDn32tRjP4B1eOQsVuOwv01Yyg1nIryOaPeH8xvV6WBvRqSHsecfeaBzBTx0y74nrB7GvQ0A7K4xhgsj0D73urBLV/nBOPYAQcnLOVKhs7QRcClBAzk512hfTvLwEqTyL6uhBOfKgUkPeiZEDhgly8S+vYrfa9Y5CoaOW7GN/fFIrIaLTH2rd3meHfv1riLHzDM72lVmxNsF0O7HV52jIngo8ZYCWvlhqG1c6fh+xusv98UibQkmObCiERL/bWoQC/nChsDe2zi6KwmkhixrlI9psOfR1afar3Nt/sTAncsIpQkOpfK6+ejVw==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1790795990; c=relaxed/relaxed;
	bh=VjekLQOz04ZtOGTEi4Fgq7YnHJvxOIm/NIV1qGR60Rk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dbPRznKRpof3oQa/W+AJSIDAaAapwbSyA8d7eRiBmsfEU/I1WAt8bZFnHpioRI0ERBN2HnoKmzMhGgp+YrCEy0I9J2VOLwBqXMFrZzfYoO6zvnVomosWr1L0Fi/LIDeuAT91wVw7OnO0/rGgCILlFlUEmSR9IFgMOIP9GJWlccAbsVa/uQuY4lFYCz9TGgZe69i+fpljeQkvXIh20kRk53U7FPdykT2iNxjcQsTrkTMmgAnnqfDa0U/i3dIJNAxS+YjLljU6ZAOlqXb7ScIUAxAvj6DllfxAMlEouDZJ584Pj45BCuClWuvyYWSRTleLsSG5CLQZhweFeivQ4idsnA==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=gmail.com; dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=ROzVx5It; dkim-atps=neutral; spf=pass (client-ip=2607:f8b0:4864:39::c; helo=mail-pj2-x0c.google.com; envelope-from=l3b2w1@gmail.com; receiver=lists.ozlabs.org) smtp.mailfrom=gmail.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=ROzVx5It;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=gmail.com (client-ip=2607:f8b0:4864:39::c; helo=mail-pj2-x0c.google.com; envelope-from=l3b2w1@gmail.com; receiver=lists.ozlabs.org)
Received: from mail-pj2-x0c.google.com (mail-pj2-x0c.google.com [IPv6:2607:f8b0:4864:39::c])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hw4cN4sfTz2xfP
	for <linux-erofs@lists.ozlabs.org>; Thu, 01 Oct 2026 05:19:47 +1000 (AEST)
Received: by mail-pj2-x0c.google.com with SMTP id 98e67ed59e1d1-3a0d31bda43so3628317a91.1
        for <linux-erofs@lists.ozlabs.org>; Wed, 30 Sep 2026 12:19:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790795984; x=1791400784; darn=lists.ozlabs.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=VjekLQOz04ZtOGTEi4Fgq7YnHJvxOIm/NIV1qGR60Rk=;
        b=ROzVx5ItA4KmW9GaOC1CZ2pDvwmPP9MzyxbEzDcHkHMRfbqgA1445sbYGQAtHp/87I
         uFBEkZNJVLWYhRdOx4Gxsl7dVlxz1XZeM8ETl7e6Pa3/ZLha+hZWNCy+skVxYiVjhqMg
         kw9wD8i4Dfi5GrNcJ6CHJJTAGJ8+nHUNGXTV5rm3OPqeUvfGQTzmbOKjBWc7RamLKmNa
         KJlZR+jT1wzTKYVpyqrt6E6RP9TfGGWv/oi9PRQKWN9orVYfzgU5Rzuj8ZHn5tYQCX9R
         yWldO6mFgSf5BQI3NxzygFj2vFKx2ziqf7jvef/vDWqPG6lHLeT9qIZSkwEQTQwNzNT/
         Ie8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790795984; x=1791400784;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=VjekLQOz04ZtOGTEi4Fgq7YnHJvxOIm/NIV1qGR60Rk=;
        b=XlzeNX9f7xoZC+DbIaNX135YVtgwOtlW3sULXvAPmmsRtwmhw3cyUTitRg1vKd2UEJ
         iZ/oq2kOY3t9VAkSrKvvhKO2XkSSKOrtBcdV0IiSm3wsahACzF7WiFHSfsFrlpA/4AmV
         I3MSfCSZ+jjSljFRoQwrNzZxy8uTlHQKHOuGqNiXTl7Ge7EHqAQJrCdRS8e5uEqunmxQ
         YcwPXhhJxKRMXZB35osaz73y+gYdlanmsJOHrY6x4bAG9LaKtE0xtatCttmqftM9WaPj
         2gZ3PHoouQCxy60V00CFBemUFHd1jnGDT4/M8Dbj0Ut2OIPSlnQ/OA+pfbrcFbkoz+TU
         aEuA==
X-Forwarded-Encrypted: i=1; AKwUvBzGatmwIkUtdNKWmLNwd1XyXXA2fw9w+qIJh5NrHskm6zbyps+9z3UEfEKmxmkR7s+qyeafioeIQCfuww==@lists.ozlabs.org
X-Gm-Message-State: AFq9FYLXj8oTA4y2YhhSK7KHmWIBcsPor67dd55YG2XOFCKvBrg6UH/t
	cDFB97WpNCi4M74zTbPyLGUB7dRHApD1Zj5Fnga1misL9ixCQqRREkfM
X-Gm-Gg: AYBFou2rwRoLdZfUcqlTxXqByEI6FcryWZrBGchwiXfP25eaMMbsqUPpBMM8HQ6els+
	V+PmZSpAtDMvSZghflD0FHcrRrdfRwyS0NRm+3CDa/ZC+1fsJGI0A3x4Djyrf/Ttk1td5O9gHU8
	fB0ykcYuk4TBC+Qy/HyTLAoFYVEriKgLH67phgSLf3aR8ixN86vvriX2zd1x7dgFg17H6hatM3U
	MbDUTMAljeFPItrsn8mgVsQPHM/emEugcIdC9D/tIKGiDU3xWcEqdeMNUQGUKkQrKjgkbqyUdPY
	D9eXZg1C7gi2ymjim/kuH/0PPgvVNCHO7bECjJtZpeI5diMBxp7wL2hckNqYObNjDJ4wznvk6Ay
	XuOhyOHPEaKejvhQKkC1gi0GjupOcFGE6KNFtnr0jVnhQ1M1E/fja2bYp9zTR8Xy7FyFXEvUbNb
	zjyVDiGwEZHzGfO4M3fnvwIN/NpBIELQOIqPu+enbu/zS0AHqq+r9Qf3oAS0y2DoN5U0d7Tj8yP
	wz1gHLD
X-Received: by 2002:a17:90b:1e42:b0:39e:2e79:7ce7 with SMTP id 98e67ed59e1d1-3a4f8d7e1edmr33895a91.6.1790795984030;
        Wed, 30 Sep 2026 12:19:44 -0700 (PDT)
Received: from bing ([39.180.169.85])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a4f4419ff9sm654192a91.9.2026.09.30.12.19.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Sep 2026 12:19:43 -0700 (PDT)
From: Binglei Wang <l3b2w1@gmail.com>
To: xiang@kernel.org
Cc: chao@kernel.org,
	linux-erofs@lists.ozlabs.org,
	linux-kernel@vger.kernel.org,
	l3b2w1@gmail.com,
	"Bo Liu (OpenAnolis)" <liubo03@inspur.com>
Subject: [PATCH v2] erofs: fix folio reuse from a different address_space in erofs_bread()
Date: Thu,  1 Oct 2026 03:19:01 +0800
Message-ID: <20260930191905.539-1-l3b2w1@gmail.com>
X-Mailer: git-send-email 2.56.0.windows.1
In-Reply-To: <ar1GgGSIZ1h0bBip@MacBookPro>
References: <ar1GgGSIZ1h0bBip@MacBookPro>
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

