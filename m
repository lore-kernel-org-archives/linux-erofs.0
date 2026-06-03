Return-Path: <linux-erofs+bounces-3511-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AAB83CD6E55
	for <linux-erofs@archiver.kernel.org>; Wed,  3 Jun 2026 10:08:35 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4gVk1F6MKFz2yjp;
	Wed, 03 Jun 2026 20:08:33 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=115.124.30.118
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1780481313;
	cv=none; b=O0EgF68K+uhUjCfvAihUPahyDT62Uls3cuxPhjYbd76qg7auSZ95dbLeQUrO3u0hVNlU3tAfYdO5BS3zs6eqTAkisUqNcw/oFd0nMSjxdSftTa44YxH+soQxbJ+yd9zSF+ESfgyOBq0/ESKJoOS8eAJEzgW0CRxsA+LqXxuBW8nix4+XNs1xUyq8pEWY6j3sy4frHREs9sPrP5rMqEw7rFaJRNcgJR6rfDLcr+d4KYqUuEf2CQVHz2MrdCwbsARNk/27Tk7Uy5bkiI5tWIPawxuTw6h/qI2NwgTziL7LWkStiRECGrcW9Cs/0LulkY3EONXE1fG2Z/ol4ynElccoHQ==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1780481313; c=relaxed/relaxed;
	bh=++HrwQlzGd3VxPKR5oKyJssI6nMKEwuSzKxHX7NlgJU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=RACCO14DihRj8pkw3Qj1dLtxMIh4apxcHR/ITWla7gBxlvD6WQX1YURItjssqLhB+MXOJit+5Zm60FGrVjZKI19OnE1llq0LWp9fu2z74yER3InlH1MNRzQkv5kqGmTYvoyOHj7h6PNn/4F7ILjNrpk1iQJcRW4sj+oKSsd7YQZ+Jsp6bWQC1dnndvz7EET/4T4H4ly54a4UUizJRd3kBHVHuRC6QG4t0CGLN7YsLljig45Mh6sJgOjhGG37i7Z2tVIbZtJqS26wQAxdYOfh9ImPU6Gn6+Ea0mKV0ieJ5SoWoYA9oTnpu+8v61chig4g+qU0JEoNmIfk1u22Z6H46A==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=kvX5oWlv; dkim-atps=neutral; spf=pass (client-ip=115.124.30.118; helo=out30-118.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org) smtp.mailfrom=linux.alibaba.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=kvX5oWlv;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=linux.alibaba.com (client-ip=115.124.30.118; helo=out30-118.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org)
Received: from out30-118.freemail.mail.aliyun.com (out30-118.freemail.mail.aliyun.com [115.124.30.118])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4gVk1C4Fgkz2ybQ
	for <linux-erofs@lists.ozlabs.org>; Wed, 03 Jun 2026 20:08:30 +1000 (AEST)
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1780481299; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=++HrwQlzGd3VxPKR5oKyJssI6nMKEwuSzKxHX7NlgJU=;
	b=kvX5oWlvkYcjs6jaFrivZOe1tziNWuQADOo1Hp2dDpIl8sXgnX12iKft4EGTMhFMP3SbMYBQdahfPiE4PnmZl26RRSZ/R7EVttlVFybW+HQaXkiZjcznnOyWbaGJX0D/cgM11kPOj0T6IJI/zFRSgQH+CMffCONzCMl5eHsJY1A=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R961e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045098064;MF=hsiangkao@linux.alibaba.com;NM=1;PH=DS;RN=2;SR=0;TI=SMTPD_---0X477kxu_1780481293;
Received: from x31i01179.sqa.na131.tbsite.net(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0X477kxu_1780481293 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 03 Jun 2026 18:08:17 +0800
From: Gao Xiang <hsiangkao@linux.alibaba.com>
To: linux-erofs@lists.ozlabs.org
Cc: Gao Xiang <hsiangkao@linux.alibaba.com>
Subject: [PATCH 1/2] erofs-utils: tar: reject negative size= value in PAX header
Date: Wed,  3 Jun 2026 18:08:11 +0800
Message-ID: <20260603100812.2617238-1-hsiangkao@linux.alibaba.com>
X-Mailer: git-send-email 2.43.5
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

From: Utkal Singh <singhutkal015@gmail.com>

The PAX extended header size= field is parsed into a signed long
long but no check is made for negative values before assigning to
eh->st.st_size. A crafted PAX header with size=-1 passes the
existing format check, resulting in a negative file size that can
cause incorrect memory allocation and heap corruption in subsequent
read or seek operations.

Add an explicit check to reject negative size= values with -EINVAL.

Signed-off-by: Utkal Singh <singhutkal015@gmail.com>
Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
---
 lib/tar.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/lib/tar.c b/lib/tar.c
index 5a83da43f3c1..c522bc3f21e1 100644
--- a/lib/tar.c
+++ b/lib/tar.c
@@ -571,6 +571,12 @@ int tarerofs_parse_pax_header(struct erofs_iostream *ios,
 					ret = -EIO;
 					goto out;
 				}
+				if (lln < 0) {
+					erofs_err("invalid negative size=%lld in PAX header",
+						  lln);
+					ret = -EFSCORRUPTED;
+					goto out;
+				}
 				eh->st.st_size = lln;
 				eh->use_size = true;
 			} else if (!strncmp(kv, "uid=", sizeof("uid=") - 1)) {
-- 
2.43.5


