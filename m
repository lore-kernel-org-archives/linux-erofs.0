Return-Path: <linux-erofs+bounces-4270-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 88EA7C5DF85
	for <linux-erofs@archiver.kernel.org>; Thu, 20 Aug 2026 13:40:21 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hQl1b6SKwz2xT6;
	Thu, 20 Aug 2026 23:40:19 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=115.124.30.113
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1787233219;
	cv=none; b=hVUqYBinMMvAmXqNidkKyoFIji8cCvVnkZzjP2NDcNHfIMezDsFly+2kpgBl6GkidVV7h2NQ+RjTvTqBWRRXGcb+dW3WtiiQj4mN9kFxMWK0gSuPUHh+L+4e9kR2KrfG/Ox4hdZQne7Fsab3UokIPXLg2H4Bt47W03fkvfrOnGqaedko9spyqrxtuLCcKLpMHepOcZCwb2kwshz10j0qMo9YBgIGlIkWNs5ZGcXLTbaTjDkqAlyiikok/XxFAmCtKqFwh4eUZ5CHdOgoxNT/uLgBOrYXhwirj924C9NKXrBAj8Sa7lebwGqTlJGRA9kfoQDeDRCd2+sQXCClMhlJqA==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1787233219; c=relaxed/relaxed;
	bh=iBrmwIeNKTKMB+LPg59hkXR8E6mblony+dYzbzlE07M=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=dwdTRD9TbpBQtpYjOtBC49uAfeb6YLD85J/voLvWx15LTf61ECQd0w1YAhKe6Glxmu4UnBsrzHrymeaeJvf8C6SFRUDifORVtWAoOkkTRxxRRP4f/n/93l68v0EgQ2vuPXwWufrbLFW9GfkbMN+R5TGglb0h/OLa9PfoV9B+pslurQ8+ujCksgb3NgM0D69ubsZWC4MkkZn2xcPpdghWe8GH/BIKCyvX3L1T7dOxwcvhzBh6M6kGcKzH/vGhfcIoxFZr/SWcG9p9n1hEJxW3OjeXp2P1v+yIOjV0cj12Lk+my6tIylbP8e3rHsA/l353PuEn4Qyn45h6B5ju8TPhqg==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=op0PT6aa; dkim-atps=neutral; spf=pass (client-ip=115.124.30.113; helo=out30-113.freemail.mail.aliyun.com; envelope-from=jefflexu@linux.alibaba.com; receiver=lists.ozlabs.org) smtp.mailfrom=linux.alibaba.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=op0PT6aa;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=linux.alibaba.com (client-ip=115.124.30.113; helo=out30-113.freemail.mail.aliyun.com; envelope-from=jefflexu@linux.alibaba.com; receiver=lists.ozlabs.org)
Received: from out30-113.freemail.mail.aliyun.com (out30-113.freemail.mail.aliyun.com [115.124.30.113])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hQl1Y5X2kz2xRw
	for <linux-erofs@lists.ozlabs.org>; Thu, 20 Aug 2026 23:40:16 +1000 (AEST)
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1787233208; h=From:To:Subject:Date:Message-Id:MIME-Version;
	bh=iBrmwIeNKTKMB+LPg59hkXR8E6mblony+dYzbzlE07M=;
	b=op0PT6aazAVtZdzROd2PR4JvMNRjhInVOyJbGyyCUKZnhzZxW6dwTfzU6QI23hAk93F2B/W9cNL3u7qLPa8DqgCpYUiofpe/TUtcU3d+UuFTkdaPDZUJJ7gv4QheVhzw/TFOVIY+JOhKosCFVMj55eeqCcwSNDYOaXtmGir4YCY=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R941e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045133197;MF=jefflexu@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0X9Jd8lM_1787233207;
Received: from localhost(mailfrom:jefflexu@linux.alibaba.com fp:SMTPD_---0X9Jd8lM_1787233207 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 20 Aug 2026 21:40:07 +0800
From: Jingbo Xu <jefflexu@linux.alibaba.com>
To: xiang@kernel.org,
	chao@kernel.org,
	linux-erofs@lists.ozlabs.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH v2] erofs: support SEEK_HOLE/SEEK_DATA in inode_share mode
Date: Thu, 20 Aug 2026 21:40:06 +0800
Message-Id: <20260820134006.66208-1-jefflexu@linux.alibaba.com>
X-Mailer: git-send-email 2.19.1.6.gb485710b
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

When inode_share is enabled, erofs_ishare_fops.llseek falls back to
generic_file_llseek, which treats the whole file as data and always
returns i_size for SEEK_HOLE, hiding real holes in sparse files.

Switch it to erofs_file_llseek instead.  For user files f_mapping->host
is always the real erofs inode, so SEEK_HOLE/SEEK_DATA resolve the
per-file on-disk layout via iomap_seek_hole()/iomap_seek_data().

Reviewed-by: Gao Xiang <xiang@kernel.org>
Signed-off-by: Jingbo Xu <jefflexu@linux.alibaba.com>
---
 fs/erofs/data.c     | 2 +-
 fs/erofs/internal.h | 1 +
 fs/erofs/ishare.c   | 2 +-
 3 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/erofs/data.c b/fs/erofs/data.c
index d2f01245ee79..09d668deb86d 100644
--- a/fs/erofs/data.c
+++ b/fs/erofs/data.c
@@ -509,7 +509,7 @@ static int erofs_file_mmap_prepare(struct vm_area_desc *desc)
 #define erofs_file_mmap_prepare	generic_file_readonly_mmap_prepare
 #endif
 
-static loff_t erofs_file_llseek(struct file *file, loff_t offset, int whence)
+loff_t erofs_file_llseek(struct file *file, loff_t offset, int whence)
 {
 	struct inode *inode = file->f_mapping->host;
 	const struct iomap_ops *ops = &erofs_iomap_ops;
diff --git a/fs/erofs/internal.h b/fs/erofs/internal.h
index 57bd21859c65..0cd434d939ba 100644
--- a/fs/erofs/internal.h
+++ b/fs/erofs/internal.h
@@ -411,6 +411,7 @@ void *erofs_read_metabuf(struct erofs_buf *buf, struct super_block *sb,
 int erofs_map_dev(struct super_block *sb, struct erofs_map_dev *dev);
 int erofs_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
 		 u64 start, u64 len);
+loff_t erofs_file_llseek(struct file *file, loff_t offset, int whence);
 int erofs_map_blocks(struct inode *inode, struct erofs_map_blocks *map);
 void erofs_onlinefolio_init(struct folio *folio);
 void erofs_onlinefolio_split(struct folio *folio);
diff --git a/fs/erofs/ishare.c b/fs/erofs/ishare.c
index fa7d4112dec5..4c7be60565cb 100644
--- a/fs/erofs/ishare.c
+++ b/fs/erofs/ishare.c
@@ -156,7 +156,7 @@ static int erofs_ishare_fadvise(struct file *file, loff_t offset,
 
 const struct file_operations erofs_ishare_fops = {
 	.open		= erofs_ishare_file_open,
-	.llseek		= generic_file_llseek,
+	.llseek		= erofs_file_llseek,
 	.read_iter	= erofs_ishare_file_read_iter,
 	.mmap		= erofs_ishare_mmap,
 	.release	= erofs_ishare_file_release,
-- 
2.19.1.6.gb485710b


