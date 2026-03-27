Return-Path: <linux-erofs+bounces-3048-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 176ECF532CC
	for <linux-erofs@archiver.kernel.org>; Fri, 27 Mar 2026 04:15:40 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4fhnPQ4GcKz2yVt;
	Fri, 27 Mar 2026 15:15:38 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=115.124.30.100
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1774584938;
	cv=none; b=OR/SUtk63KythF/hIDNSHibuBlFGF/KV4FMb/vUSXrAOA2PqAdp1zJ0jTs7qko1am3U80hNoNuSNz4C7qJGjVqglXMYsgPGYwd+W9uaQdlwrWYhvN5U8J61Bo6ttFa/dEjdOu12KzYLjMjC+Z3SQ394ujE41lUy6Keqa1k0loWCPx4OoXlAJo+80keYtYvKbTl098GmIzH4xxnanrJMzOtvk0ZoHVkdZJWH/Yu2Erb34VJDRX9RfToGoNgzDvapkc6ZiQgIktg8LvG2CYFU9v3sZThL6KozUMFRvdXOGs0Qp83lXWHEs4ft8QtvWGCirLeCRQFq3o+MjKD5RA0z01g==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1774584938; c=relaxed/relaxed;
	bh=SaMl55v3P256PUqGIsXKeLgVv4g7GfDpRpgEKt5uNj4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=SKJLCkkIPNu4q4LugN+n1sRVVm/BzKuY+g9pC7ZwYJxIaC903E3kV2kyV4slx6I+ndPzqbjyFx+QrZxn/Z8tDllCpC8lsgniUt+dCCmFZznekNFwv0x6e5XQjpZUaHussHvMWGpZOAWIs1s3k9K74GEijOJwJH55BlJTOJHLBhi+VbwJ8OP5YBbtkuJXhCWPhjG85xpeWTivm5mqrefBMxYFWfQzbZzy3Gn+gJ+RH/ypw7/x7IPh33JDRmImTOklSvh7PsQItkNUWuvQJJ6qfa5ZSkeOw4yMwiWR2RAR5cuf5nndtdcgJBJr6347tlm0hTAbOuzTSe6au1ZZpW3PMw==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=Vn15nyDw; dkim-atps=neutral; spf=pass (client-ip=115.124.30.100; helo=out30-100.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org) smtp.mailfrom=linux.alibaba.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=Vn15nyDw;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=linux.alibaba.com (client-ip=115.124.30.100; helo=out30-100.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org)
Received: from out30-100.freemail.mail.aliyun.com (out30-100.freemail.mail.aliyun.com [115.124.30.100])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4fhnPN3418z2xmX
	for <linux-erofs@lists.ozlabs.org>; Fri, 27 Mar 2026 15:15:35 +1100 (AEDT)
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1774584931; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=SaMl55v3P256PUqGIsXKeLgVv4g7GfDpRpgEKt5uNj4=;
	b=Vn15nyDwW9kRAhkXBkbW2vAuqykj3aWRRfq7o7mG3WwBjqJbmzaBdc5OHwLlxXWRxD/QMH2WueLWXiyz/YSt5HZ0dEo1n06ZQxbcLuVElo2zEhj4C0kJ2KqHVSE+IXak8SnDT8W1aOOa3d+NCc4ZSedxDsFEGUbfpwyxaEz71y0=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R141e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam011083073210;MF=hsiangkao@linux.alibaba.com;NM=1;PH=DS;RN=5;SR=0;TI=SMTPD_---0X.n37JY_1774584925;
Received: from x31i01179.sqa.na131.tbsite.net(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0X.n37JY_1774584925 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 27 Mar 2026 12:15:30 +0800
From: Gao Xiang <hsiangkao@linux.alibaba.com>
To: stable@vger.kernel.org,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-erofs@lists.ozlabs.org,
	Gao Xiang <hsiangkao@linux.alibaba.com>,
	syzbot+b6353e35ae2bab997538@syzkaller.appspotmail.com
Subject: [PATCH 6.6.y] erofs: fix "BUG: Bad page state in z_erofs_do_read_page"
Date: Fri, 27 Mar 2026 12:15:24 +0800
Message-ID: <20260327041524.1087336-1-hsiangkao@linux.alibaba.com>
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

It's actually a stable-only issue from backporting 9e2f9d34dd12
("erofs: handle overlapped pclusters out of crafted images properly")

We missed to update `oldpage` after `pcl->compressed_bvecs[nr].page`
is updated, so that the following cmpxchg() will fail; the original
upstream commit doesn't behave like this due to new features and
refactoring.

This backport issue only impacts some specific crafted images and
normal filesystems won't be impacted at all.

Fixes: 1bf7e414cac3 ("erofs: handle overlapped pclusters out of crafted images properly") # 6.6.y
Closes: https://syzkaller.appspot.com/bug?extid=b6353e35ae2bab997538
Reported-and-tested-by: syzbot+b6353e35ae2bab997538@syzkaller.appspotmail.com [1]
[1] https://lore.kernel.org/r/69c3b299.a70a0220.234938.004b.GAE@google.com
Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
---
 fs/erofs/zdata.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/erofs/zdata.c b/fs/erofs/zdata.c
index c1f802ecc47b..97764612fc76 100644
--- a/fs/erofs/zdata.c
+++ b/fs/erofs/zdata.c
@@ -1500,6 +1500,7 @@ static struct page *pickup_page_for_submission(struct z_erofs_pcluster *pcl,
 	lock_page(page);
 	if (likely(page->mapping == mc)) {
 		WRITE_ONCE(pcl->compressed_bvecs[nr].page, page);
+		oldpage = page;
 
 		/*
 		 * The cached folio is still in managed cache but without
-- 
2.43.5


