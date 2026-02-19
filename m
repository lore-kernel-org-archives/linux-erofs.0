Return-Path: <linux-erofs+bounces-2338-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 970BAE9A05A
	for <linux-erofs@archiver.kernel.org>; Thu, 19 Feb 2026 19:25:03 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4fH3HL12J9z2yFY;
	Fri, 20 Feb 2026 06:25:02 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=115.124.30.99
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1771529102;
	cv=none; b=fkbHsMFEgZnZccCBO9Fb6JNwBzYMfE/Yfn+zRnNRYmTaE2uX8sg+ef7vYnI1ZjevzWS72O0pgH/NzRxasnjJHoLzjK1Z05iFFx8G6GZmT1IoJIROw0phfCb/z03qIAEvfs+sgNtOvx/AiAczh+AZgq00E0dhO1a7DZsznRtToNEf5MQV+wz4PPKBLxJmDvkqSKWQ3HAK2iGkFasABIhqR0f9sI8ZFPyCZ2ZDxjQdcwOhHQRJBm6B4eusUQnkq2D2/1JHZCf+oqjD4GjSJU/OCMxT8cAH/biQvWQpzo+C9xeVPiSWdYssvlzh9kNoyyHV4pApQqoc+J5Ituap4Pqq2A==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1771529102; c=relaxed/relaxed;
	bh=byLy6ZcE7R4rvihX9khdPJ4xyeJWy6XwPX4KFIPtxJA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=H0u56IPCz/mbcjIrgnOoOyLzzmCvs65UHPpSD+yEkvcfyADLARNvhxUd+XKiDOx4nCtfwBGSpqSuTbypsIcZRAtg+zcEZ0SSb479tH7pmQmMS8/Cw5pDiaw/810+rdnimzWKiE5Bn0efV41hExv0OoqYoH/kVbYYML8pqnnWKyz9KVrpGmEVdyGGGI1ZW19t257QnMOzsAALnFHJzfTwLQL4SYy5UICVuWCcCqL6c2z1x7Jzdc9DYhENthRy5RdHJ2c/HHMDPuTCJyIRt4HUWO+ysRQ3xvDLhbse+GUSQunp9lpC5sCFjVt8j4ei7yWxchwzC9crSdFvA3D0/V5WpQ==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=J89VZOYn; dkim-atps=neutral; spf=pass (client-ip=115.124.30.99; helo=out30-99.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org) smtp.mailfrom=linux.alibaba.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=J89VZOYn;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=linux.alibaba.com (client-ip=115.124.30.99; helo=out30-99.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org)
Received: from out30-99.freemail.mail.aliyun.com (out30-99.freemail.mail.aliyun.com [115.124.30.99])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4fH3HH4v1Tz2xlM
	for <linux-erofs@lists.ozlabs.org>; Fri, 20 Feb 2026 06:24:57 +1100 (AEDT)
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1771529091; h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type;
	bh=byLy6ZcE7R4rvihX9khdPJ4xyeJWy6XwPX4KFIPtxJA=;
	b=J89VZOYn/HkhdOigDGkT0SWpHRBzgEF1/nZ/btSPzHLHbQr5N0iCblA76bBAx6ldZmekcE9F5Y56axEMpB1K+LgvAeltPVPd6oVQ0ZYJY+WzYNc9GF2Kc835MQBTm/WJWEuyB+AMDKiR+KsNUeTWYlIthf7/46m3TO5QVGmXdPk=
Received: from x31i01179.sqa.na131.tbsite.net(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0WzVamF0_1771529083 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 20 Feb 2026 03:24:47 +0800
From: Gao Xiang <hsiangkao@linux.alibaba.com>
To: linux-erofs@lists.ozlabs.org
Cc: oliver.yang@linux.alibaba.com,
	Gao Xiang <hsiangkao@linux.alibaba.com>
Subject: [PATCH] erofs-utils: lib: fix false-positive uninitialized variable warning
Date: Fri, 20 Feb 2026 03:24:42 +0800
Message-ID: <20260219192442.2609494-1-hsiangkao@linux.alibaba.com>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

It may trigger the following warning:

xattr.c: In function ‘erofs_xattr_iter_inline.constprop’:
xattr.c:1349:13: error: ‘ret’ may be used uninitialized in this function [-Werror=maybe-uninitialized]
 1349 |         int ret;
      |             ^~~

'remaining' is always greater than 0. Switch to a do-while loop
to eliminate this false-positive warning.

Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
---
 lib/xattr.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/lib/xattr.c b/lib/xattr.c
index 86f2e45b09b2..565070a698dc 100644
--- a/lib/xattr.c
+++ b/lib/xattr.c
@@ -1358,7 +1358,7 @@ static int erofs_xattr_iter_inline(struct erofs_xattr_iter *it,
 	erofs_init_metabuf(&it->buf, it->sbi, erofs_inode_in_metabox(vi));
 	remaining = vi->xattr_isize - xattr_header_sz;
 	it->pos = erofs_iloc(vi) + vi->inode_isize + xattr_header_sz;
-	while (remaining) {
+	do {
 		it->kaddr = erofs_bread(&it->buf, it->pos, true);
 		if (IS_ERR(it->kaddr))
 			return PTR_ERR(it->kaddr);
@@ -1380,7 +1380,7 @@ static int erofs_xattr_iter_inline(struct erofs_xattr_iter *it,
 			break;
 
 		it->pos = next_pos;
-	}
+	} while (remaining);
 	return ret;
 }
 
-- 
2.43.5


