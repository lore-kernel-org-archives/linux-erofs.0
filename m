Return-Path: <linux-erofs+bounces-4251-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AB1F9C5DF70
	for <linux-erofs@archiver.kernel.org>; Tue, 18 Aug 2026 11:37:36 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hPSNt2cbyz2yGB;
	Tue, 18 Aug 2026 21:37:34 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=115.124.30.133
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1787053054;
	cv=none; b=SLMppWsFzaFaRDJ/Mp9IgxUdUHQxT+0eUpdlHRT0XxNjajNRDHnP2pLwmJV6Jd15NeThO3S1HQLcMMECVuJaeHrvVIT34FultBnxhphELN5mKE6Efs54h4Ti9SLxDTf2NaHkIZVpBKMTTTXRX+qh+8OrnpSXQZL1ZcgWAKLkXrJSy0eIPS9yNxs9yYlnIEiYVwcr0YqlFfboBL4Dw5YgMqcOlZ/6iMarIc+I6dI2DbcRX+gRqHHPnE4l9T4KFZTemYbWw0rZhW+es73Z+TbgRGVXoTJb9dqMxDo2En9lCUNVl3obUYsuEqYYaMJDGmG12b/6dfksdNBnCS/wN1nWHg==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1787053054; c=relaxed/relaxed;
	bh=CFrZbe/zoAbWSEEae8g2rMxIifB/6Ye1yePxe9JFFRU=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=oRtYpwsZ31U1Y/0UqkceOyc2QoKrlDLZoPr8ZCWM+sDtSKu7xwTVUxLuARHIpVhtJBz89mNKAvZKaGWhELkfb6vzjUrXXLtTSfFS4uexWj3DKZrbZbcnLVIDxIxImo0g21HE4w4I3qlYsyD8XqQBF7fm3xx5nyacblj7AdzHHgUaBcNWwKDHkkCcQKyRsqn+H04J5TsUQpWnGJ4aF3knUZ8FJfhGL1wGIYygHAcXbw11gvP2a1oVyYVtYGFYhlPPAN6+vFG+HZfDsD87/D3OT1OtTPSSJTgXK25An6WpqJ2gZgwhkk/FgODtKMScXVKCjjlc86SE8MFEkcUgDMl4MA==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=RmNmj+xP; dkim-atps=neutral; spf=pass (client-ip=115.124.30.133; helo=out30-133.freemail.mail.aliyun.com; envelope-from=jefflexu@linux.alibaba.com; receiver=lists.ozlabs.org) smtp.mailfrom=linux.alibaba.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=RmNmj+xP;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=linux.alibaba.com (client-ip=115.124.30.133; helo=out30-133.freemail.mail.aliyun.com; envelope-from=jefflexu@linux.alibaba.com; receiver=lists.ozlabs.org)
Received: from out30-133.freemail.mail.aliyun.com (out30-133.freemail.mail.aliyun.com [115.124.30.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hPSNj6cHQz2yFt
	for <linux-erofs@lists.ozlabs.org>; Tue, 18 Aug 2026 21:37:21 +1000 (AEST)
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1787053035; h=From:To:Subject:Date:Message-Id:MIME-Version;
	bh=CFrZbe/zoAbWSEEae8g2rMxIifB/6Ye1yePxe9JFFRU=;
	b=RmNmj+xPi+F0oSqYQs2Qe5vdG1vSIWUA2XUXMjVFyqL29F2oJ8HBMpyfP0KpzjhQTqPaQu1Bs4KB+ohoY3BOa/320Y+a6Cm296N6upzFCP/dx2Xq9968BW/Qd4S8VVUqPBQD4p2iOw6RrkxX9+nl5eJxDgqboZM60q0yst/9ox0=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R181e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037009110;MF=jefflexu@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0X9DNCHB_1787053033;
Received: from localhost(mailfrom:jefflexu@linux.alibaba.com fp:SMTPD_---0X9DNCHB_1787053033 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 18 Aug 2026 19:37:13 +0800
From: Jingbo Xu <jefflexu@linux.alibaba.com>
To: xiang@kernel.org,
	chao@kernel.org,
	linux-erofs@lists.ozlabs.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] erofs: support SEEK_HOLE/SEEK_DATA in inode_share mode
Date: Tue, 18 Aug 2026 19:37:13 +0800
Message-Id: <20260818113713.116849-1-jefflexu@linux.alibaba.com>
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

Reported-by: Yuanhe Shu <xiangzao@linux.alibaba.com>
Signed-off-by: Jingbo Xu <jefflexu@linux.alibaba.com>
---
 fs/erofs/data.c     | 2 +-
 fs/erofs/internal.h | 2 ++
 fs/erofs/ishare.c   | 2 +-
 3 files changed, 4 insertions(+), 2 deletions(-)

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
index 57bd21859c65..3263c11d714c 100644
--- a/fs/erofs/internal.h
+++ b/fs/erofs/internal.h
@@ -528,6 +528,8 @@ static inline struct inode *erofs_real_inode(struct inode *inode, bool *need_ipu
 }
 #endif
 
+loff_t erofs_file_llseek(struct file *file, loff_t offset, int whence);
+
 long erofs_ioctl(struct file *filp, unsigned int cmd, unsigned long arg);
 long erofs_compat_ioctl(struct file *filp, unsigned int cmd,
 			unsigned long arg);
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


