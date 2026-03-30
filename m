Return-Path: <linux-erofs+bounces-3085-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0106AFF4930
	for <linux-erofs@archiver.kernel.org>; Mon, 30 Mar 2026 02:20:48 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4fkZjW2NwXz2xly;
	Mon, 30 Mar 2026 13:20:47 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=115.124.30.97
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1774837247;
	cv=none; b=iZmoj6joPuK3J2lLmfuH4PRAya/wKshpG4i6bvTpnjwSsV62SjeJl43qriLuem1jv6wTkwCDpjB2Tp0+E4V6QPQH8SMBMp62PbW7uGEz2TLOjsT4kiigw5ftAdhS6tqtr2sai6/1Ya8KJcRGcqP5KHfAXZdMzoSpk/pHaszqHAlc7mufNgzMuUv3mqDGChlK9ph3fQ3T3TUqBvidPkDEcFmu30UwWXHX5UBn7GULm/WPo9GRVQDxPKJ2wMCaMilTfViLXeirztcoyhMXhvBwNjlvRnLE67m0hgx9Hy8mkNgJ9YHMALHjTan/OQ46C6vFOVHvlqzQf2pBxRzJjEoOtQ==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1774837247; c=relaxed/relaxed;
	bh=KIITCaTj5UlOKpXNQWHZKk1QN9M4wLF+SwTlo4rXyDo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=KaJwKxgDShdajWYm8TwlHZ4iwdy66hDPGA8prnSjTF8p76AeawNbaWgwwHDNzRps5oczhHUWmyzxBY1y0zxfoBUn2uIJ6AWT4rC8TKPQq7Q/wK7VARcESEBooYptda8Gjew5cNh9U+3ABaGet+JjLlolr4T7b3r6I71pI+d32TbV/cky+3L36f2DSnAKaSwXeNlM460XCmB6dJlzk/ByXF5Qv49Dt6usWd1D/khZ6SD5Trw5Ags9QYPVGkg+gozmgG07gKbaW6Gh2yIWFNBEq20QhAPr4qzir1/5KLZn8PQb9l296OiS8r5pUdUoWB9tJiGOs5LaeFqZlyxJ2HJuEQ==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=VfU69Vmc; dkim-atps=neutral; spf=pass (client-ip=115.124.30.97; helo=out30-97.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org) smtp.mailfrom=linux.alibaba.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=VfU69Vmc;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=linux.alibaba.com (client-ip=115.124.30.97; helo=out30-97.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org)
Received: from out30-97.freemail.mail.aliyun.com (out30-97.freemail.mail.aliyun.com [115.124.30.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4fkZjS4mdqz2xMQ
	for <linux-erofs@lists.ozlabs.org>; Mon, 30 Mar 2026 13:20:43 +1100 (AEDT)
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1774837239; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=KIITCaTj5UlOKpXNQWHZKk1QN9M4wLF+SwTlo4rXyDo=;
	b=VfU69VmcyJY+/DJ4XIWqy+jZjuAWukB8iN+MqglBLVAy9c+Vwhq/Qt+RN/CqmwyL7dUa7tS3QGuEPXPzzdsns1aOAfEGKRRUPXajFf4OiIBejHz504gcFC9w5KCb1J7gKYjzxMzpraW7ePqN0gfa27V7PSK6MgA357/r2g/JSag=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R121e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045133197;MF=hsiangkao@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0X.u.bHb_1774837233;
Received: from x31i01179.sqa.na131.tbsite.net(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0X.u.bHb_1774837233 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 30 Mar 2026 10:20:38 +0800
From: Gao Xiang <hsiangkao@linux.alibaba.com>
To: linux-erofs@lists.ozlabs.org
Cc: LKML <linux-kernel@vger.kernel.org>,
	Jan Kara <jack@suse.cz>,
	Christian Brauner <brauner@kernel.org>,
	Gao Xiang <hsiangkao@linux.alibaba.com>,
	Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH] erofs: verify metadata accesses for file-backed mounts
Date: Mon, 30 Mar 2026 10:20:31 +0800
Message-ID: <20260330022031.2107239-1-hsiangkao@linux.alibaba.com>
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

For file-backed mounts, metadata is fetched via the page cache of
backing inodes to avoid double caching and redundant copy ops, which is
currently used by Android APEXes, ComposeFS and containerd for example.
However, rw_verify_area() was missing prior to metadata accesses.

Similar to vfs_iocb_iter_read(), fix this by:
 - Enabling fanotify pre-content hooks on metadata accesses;
 - security_file_permission() for security modules.

Verified that fanotify pre-content hooks now works correctly.

Fixes: fb176750266a ("erofs: add file-backed mount support")
Acked-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
---
 fs/erofs/data.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/fs/erofs/data.c b/fs/erofs/data.c
index f79ee80627d9..cf27b8fbaaa1 100644
--- a/fs/erofs/data.c
+++ b/fs/erofs/data.c
@@ -30,6 +30,20 @@ void *erofs_bread(struct erofs_buf *buf, erofs_off_t offset, bool need_kmap)
 {
 	pgoff_t index = (buf->off + offset) >> PAGE_SHIFT;
 	struct folio *folio = NULL;
+	loff_t fpos;
+	int err;
+
+	/*
+	 * Metadata access for file-backed mounts reuses page cache of backing
+	 * fs inodes only folio data will be needed) to prevent double caching.
+	 * However, the data access range must be verified here in advance.
+	 */
+	if (buf->file) {
+		fpos = index << PAGE_SHIFT;
+		err = rw_verify_area(READ, buf->file, &fpos, PAGE_SIZE);
+		if (err)
+			return ERR_PTR(err);
+	}
 
 	if (buf->page) {
 		folio = page_folio(buf->page);
-- 
2.43.5


