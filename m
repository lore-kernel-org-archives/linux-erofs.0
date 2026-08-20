Return-Path: <linux-erofs+bounces-4257-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 700DDC5DF81
	for <linux-erofs@archiver.kernel.org>; Thu, 20 Aug 2026 06:44:56 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hQYpG3m4Sz2xGZ;
	Thu, 20 Aug 2026 16:44:54 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2607:f8b0:4864:20::630"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1787208294;
	cv=none; b=Ys+zoMKXp2j3DEyeS+eTLQqASSwSPeZ1Zw8cBdrxEfOrJJjmx3VDGxTIwTlaxpg3P/jlSMWC8CJe3TZV+R+6rhWR6EeyWqIeY3Wl3O3rxkiztA1l8OuDFcGyTjrJ/3kEu8kECKG2xePc7X01cVHhvhXqOaF3CzMbT3q9iHAuNsEvuMQOIAt45TaVaxqmUlAmxgZiqSRT0gD+ctJ7dqRDlfPXHo8dJraBQyin+1ZdEmCWDNWBzpq62CEzYkpYwet1XBQZtxS3rtQMwsFPIPa0FYdjH+Z2YRqj/5HWoT7FZVbyW0gDDuERN4vJ8go6/SlxEUXzACjYpCZ94pt63U1rXg==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1787208294; c=relaxed/relaxed;
	bh=YfVzXFvKOR32XDZBxRNLOvcTMqLAQDvf/lKqqU77i4k=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Yo2s0KbYNge2F9uk8SN5EZmzTJyA+kJof4R3Mu71ZJGPvgVdbJbcVBOfKLsxB6PfVRwAf4q56vXNRy9Wx8bQkCM06lN/9b1ebjyHB6Cd26Cg0uVMSHWHzsVd6dvzACY04mzHzTfvGks4evstVtcQDXSr0VczkvfIJIeMdKL2ua5FudXR7A9YhkWWc2RpOxziKVz9FuMML1LVBmkiKomS+iIeNKMUBOKWcH45E7rSHsr4fsDeBRvzIOYnjpuN5NN1xMAWtHAxRj6YCbCSJfkCQ0X3lOv11xTDlGG+NVOGBvCN9vdy2XnnZSXupc15Sdfu5QMgdKno0vgLJCZQjiIAsw==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=gmail.com; dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=f/86BCVE; dkim-atps=neutral; spf=pass (client-ip=2607:f8b0:4864:20::630; helo=mail-pl1-x630.google.com; envelope-from=zhanxusheng1024@gmail.com; receiver=lists.ozlabs.org) smtp.mailfrom=gmail.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=f/86BCVE;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=gmail.com (client-ip=2607:f8b0:4864:20::630; helo=mail-pl1-x630.google.com; envelope-from=zhanxusheng1024@gmail.com; receiver=lists.ozlabs.org)
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hQYpD5FLnz2xBK
	for <linux-erofs@lists.ozlabs.org>; Thu, 20 Aug 2026 16:44:51 +1000 (AEST)
Received: by mail-pl1-x630.google.com with SMTP id d9443c01a7336-2cacf197759so24350215ad.2
        for <linux-erofs@lists.ozlabs.org>; Wed, 19 Aug 2026 23:44:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787208288; x=1787813088; darn=lists.ozlabs.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=YfVzXFvKOR32XDZBxRNLOvcTMqLAQDvf/lKqqU77i4k=;
        b=f/86BCVE9e+sEW7wX9sR+x3IK4wdBeZPhAjFDW06pnNSrsNjNjrgE3cwcpy3F46QVb
         Rrm0AigkM7gU8s0EunAeS9SYd+sinxsiXN+QiPZTlSx1dHwgKKFp/m2hdiQmcNGbk/zU
         U9z6rrG+J/mF4B7he1eaUivfUJCywSZytEEu4a1KXHb9i9e7TUQttH6owcK7YNNNQXie
         coOm7HX2QixB4Hl+eINVjAdTyRTxWh63ge1y++PwMJOF3DclcxeOj28agtdhMEY2sMeC
         OFcpsJXiGkAkB4LOsx81RSvzDjbI9X7fh/iTQVqDmE1MNXoFhBOBMlUSSIbMBO0TGh7K
         Tlkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787208288; x=1787813088;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=YfVzXFvKOR32XDZBxRNLOvcTMqLAQDvf/lKqqU77i4k=;
        b=kw+XZYMOSGepcWvbDP4/QjzmL8DN+WgzLNJHfYrexunXnxUFHRbq5z9SpwOMlOJD7i
         10Gr/M1V9n9XtZpeJOkZbAJZPmnB63ftcNf99THfh2HZtaExwZYnEg2A8zvKU8dSJSd2
         snGAC42L6mSErba0hUWXaODWUrMXnhS7C8QEDhgONNFZw4kZQ31cxFLYVC51u+061Byk
         PKNKVoXshdV87EEF9HZuJmHEZquYxRGdO0SiAEpFxwdGo6DCDPHoF9Q35TtHzXamzCVC
         bgF2stFTKNpYpVeV0o30/6BVyvdhIh9PXX+abxzDOlAkANemTZKkvGbtdRBlJlqoX0Cf
         PaQQ==
X-Forwarded-Encrypted: i=1; AHgh+Rp12x1U36A2rX39z7U3+CEnluSF7pncjQdE9PIAxKPH5xkqu3vDAgSpCG95qsE5+f2lDrAfAsuEZiUxuw==@lists.ozlabs.org
X-Gm-Message-State: AFuF++mUaDN1ByevCmfIiqaekQwRDpTjXS2MgMlmdJhHYTej6c1h0mND
	6BAN3ZQES/ym2YoiMKlVxJEIjJ7zhOhYuwTwsuXDoDrDqrojg4bBcZfJTIrqsGKU
X-Gm-Gg: AR+sD10wGIfgOkoXovYuc/5RMUiKfoP3QynXKoayZxBQoVQ5Aik7WeJZPfkFxvkzBuh
	4fjKpPkSrtzqwlebAlSR68aNgHO2jx3zhKD+T639uK43MX3b5kJKCOx5AjvLRNTWQ3mA4x5zjf0
	cHB1AM1+tJOetY5AmVNa0Sb1JDA2JE97xl3WhSYKaV4nwzcSw521bfkRT//jGCPuqZoJzKNxX+O
	H8yA3KYS4u98BX0ceRZMn4xfPzW30NWNv5jP+ugIwqf7bkyii4L4B0rWBRicB0FoDcA6XEdSKKn
	Oq2MLGj4/D1e7AdKnvRUPxRR0A8FEPqk5QVELj9gxyqF16gEA+aW9LLZZEgDEANlUTXSdnbHTfi
	JP8QdgRyn+sUAwVWJ88gGTRksNy4zAr6VYsnF1kSnCRf/mOwDs2QaJDuFrHW7SqWMCTq5Gvvc7T
	b54du2OuR2P02DKxfoOVqqrBPgiEhlTLaRqGTGKPPmCfYjzd3AgTqcmKFzLhzH26ZPZq8VzRAv
X-Received: by 2002:a17:902:f68b:b0:2d3:7887:7e7f with SMTP id d9443c01a7336-2d601859936mr194245245ad.11.1787208288465;
        Wed, 19 Aug 2026 23:44:48 -0700 (PDT)
Received: from osman.mioffice.cn ([43.224.245.178])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2d62d554411sm2976085ad.10.2026.08.19.23.44.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Aug 2026 23:44:48 -0700 (PDT)
From: Zhan Xusheng <zhanxusheng1024@gmail.com>
X-Google-Original-From: Zhan Xusheng <zhanxusheng@xiaomi.com>
To: Gao Xiang <xiang@kernel.org>,
	Chao Yu <chao@kernel.org>
Cc: Jingbo Xu <jefflexu@linux.alibaba.com>,
	zhanxusheng@xiaomi.com,
	linux-erofs@lists.ozlabs.org,
	linux-kernel@vger.kernel.org,
	Zhan Xusheng <zhanxusheng1024@gmail.com>
Subject: [PATCH] erofs: use the shared page cache for splice in inode_share mode
Date: Thu, 20 Aug 2026 14:44:41 +0800
Message-ID: <20260820064441.1083470-1-zhanxusheng@xiaomi.com>
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

From: Zhan Xusheng <zhanxusheng1024@gmail.com>

From: Zhan Xusheng <zhanxusheng@xiaomi.com>

erofs_ishare_fops routes everything that touches the page cache to the
backing file in ->private_data: read_iter clones the iocb onto it, mmap
does vma_set_file(), fadvise calls vfs_fadvise() on it.  splice_read was
left as filemap_splice_read(), which works on the user file's own mapping.

filemap_splice_read() does init_sync_kiocb(&iocb, in), and
filemap_get_pages() then takes iocb->ki_filp->f_mapping, so splice() and
sendfile() populate the per-file page cache from disk instead of using the
shared one.  The data is correct, since erofs_fill_inode() sets that
mapping's a_ops either way, but the same content ends up cached twice,
which is what inode_share is there to avoid.

Pass the backing file, as read_iter already does.

Fixes: 5ef3208e3be5 ("erofs: introduce the page cache share feature")
Link: https://lore.kernel.org/all/b7dc7192-d586-45a2-bc4a-b41dc681c9bb@linux.alibaba.com/
Signed-off-by: Zhan Xusheng <zhanxusheng@xiaomi.com>
---
 fs/erofs/ishare.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/fs/erofs/ishare.c b/fs/erofs/ishare.c
index fa7d4112dec5..01dc53e9e3ad 100644
--- a/fs/erofs/ishare.c
+++ b/fs/erofs/ishare.c
@@ -148,6 +148,13 @@ static int erofs_ishare_mmap(struct file *file, struct vm_area_struct *vma)
 	return generic_file_readonly_mmap(file, vma);
 }
 
+static ssize_t erofs_ishare_splice_read(struct file *in, loff_t *ppos,
+					struct pipe_inode_info *pipe,
+					size_t len, unsigned int flags)
+{
+	return filemap_splice_read(in->private_data, ppos, pipe, len, flags);
+}
+
 static int erofs_ishare_fadvise(struct file *file, loff_t offset,
 				loff_t len, int advice)
 {
@@ -161,7 +168,7 @@ const struct file_operations erofs_ishare_fops = {
 	.mmap		= erofs_ishare_mmap,
 	.release	= erofs_ishare_file_release,
 	.get_unmapped_area = thp_get_unmapped_area,
-	.splice_read	= filemap_splice_read,
+	.splice_read	= erofs_ishare_splice_read,
 	.fadvise	= erofs_ishare_fadvise,
 };
 
-- 
2.43.0


