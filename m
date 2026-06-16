Return-Path: <linux-erofs+bounces-3638-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 58C44CD98E1
	for <linux-erofs@archiver.kernel.org>; Tue, 16 Jun 2026 14:08:55 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4gfpkY5tsQz3c4Y;
	Wed, 17 Jun 2026 00:08:53 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2600:3c0a:e001:78e:0:1991:8:25"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1781618933;
	cv=none; b=PJJvBD7C/cn3rSLmJKswiL+3i+S5Bfjpyex12HWh4BJS4eC+kfcbNdohOP16gWyf/KZeQFL6pu5qrhUeJUakxAZT+Lohzy9EfRCyCfI83HgpAn5SGJ9sOXezluDdQHSgZBSRI52mLJE8+5iRr83cGQH24wayIVGKVm36Uf/iiO8oUWtBP0+c+o84y4hnaraiW4XrAjYEAsgUGoyZeOrfDYRryiK68YA4wavPDQW/7g3AGGtQyNEBNswmNH7i/fNzJvFjytghGD/BVPslAejnADgnO+hHTs8NiaIlVLsxGgHoNThVelG9bs7po8SL3Azz2gF7+dt7TG7AGwkMBrHuIQ==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1781618933; c=relaxed/relaxed;
	bh=Jpn/L9xcaTdyM2ThetgELvjl4xXtdXDakn1/zaaFINs=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=VithdXGyl8iQC6YvMINmN6XU93yZVwYG70d+z9N9hfAV8OzJzntUmsiewMEuidrW4g1xCpxhUClK7AfPWTvOhmp0CrAeBcfUsFWaNmoOR68ky/cqb46xon5PRVPfSCxD77/rWnJIXlij6v+iMYsppRrUQ0xyvlrUFjQT7UQ5oxtufFvzmpsjjAt8sZSOJGtugNJ62felA3iCNNKd/NaeSo/Q7pHSl5fSbOKnu8pwGYiOTQXV/ED43CXn2sy5bW38LzG3g8Gh5oqNmwoPyatqdadU6AzPIEfEIFExSa48hZ/0rMyy8lRv5HPjUBAvCS9Uf4KbbJfZXMNEwyB9dOT64w==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=XasbeRe8; dkim-atps=neutral; spf=pass (client-ip=2600:3c0a:e001:78e:0:1991:8:25; helo=sea.source.kernel.org; envelope-from=brauner@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=XasbeRe8;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=2600:3c0a:e001:78e:0:1991:8:25; helo=sea.source.kernel.org; envelope-from=brauner@kernel.org; receiver=lists.ozlabs.org)
Received: from sea.source.kernel.org (sea.source.kernel.org [IPv6:2600:3c0a:e001:78e:0:1991:8:25])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4gfpkX5HYsz2yv0
	for <linux-erofs@lists.ozlabs.org>; Wed, 17 Jun 2026 00:08:52 +1000 (AEST)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 9232740B6A;
	Tue, 16 Jun 2026 14:08:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 087981F00ACA;
	Tue, 16 Jun 2026 14:08:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781618930;
	bh=Jpn/L9xcaTdyM2ThetgELvjl4xXtdXDakn1/zaaFINs=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=XasbeRe8OkjGBVexzq6zTIkmg/re74y42Zvv2USF/F3cgfnj9CjjCvuAlH6rGlwD2
	 kRMl6g+ZMFHOg66znaAQ1UtXHBozcTo1wRUznpibHHc3H5zJ6MxcZyWtLSN16pzS0f
	 5Y8BZ7fOMavOEBv5f7nU/DcID4xz5IZ7RBw0MbUSkX3k9878XLjHER4bFiZub3/OvF
	 6Nzh619SBEbkCefFqXnszALnon4sL7BJ99e15Lc5t/JROEbsN7HmrneH5WkxdWNwei
	 f16pAn7lUXznyYZKOux/KAY2Xkgzof8rVzfb8NfGvTZwgUwWVNTu2M131pS30BimMB
	 GjwwIO+E2gvVQ==
From: Christian Brauner <brauner@kernel.org>
Date: Tue, 16 Jun 2026 16:08:20 +0200
Subject: [PATCH RFC v2 04/18] fs, block: move blk_mode_t and fop_flags_t
 into <linux/types.h>
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
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260616-work-super-bdev_holder_global-v2-4-7df6b864028e@kernel.org>
References: <20260616-work-super-bdev_holder_global-v2-0-7df6b864028e@kernel.org>
In-Reply-To: <20260616-work-super-bdev_holder_global-v2-0-7df6b864028e@kernel.org>
To: Jan Kara <jack@suse.cz>
Cc: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>, 
 Alexander Viro <viro@zeniv.linux.org.uk>, linux-block@vger.kernel.org, 
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
 Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org, 
 Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>, 
 linux-btrfs@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>, 
 linux-ext4@vger.kernel.org, Gao Xiang <xiang@kernel.org>, 
 linux-erofs@lists.ozlabs.org, 
 "Christian Brauner (Amutable)" <brauner@kernel.org>
X-Mailer: b4 0.16-dev-4090c
X-Developer-Signature: v=1; a=openpgp-sha256; l=1800; i=brauner@kernel.org;
 h=from:subject:message-id; bh=W0e283i/NPdnGyczxuKoL2hh/y1kkMtU22l4mrq4nMk=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWQZRtzzMlaJ+nInff8J+WaFDmtvtU39m447cOk2x25Ra
 pdu+xrXUcrCIMbFICumyOLQbhIut5ynYrNRpgbMHFYmkCEMXJwCMJGGlwx/JS0F5rQknQ05InC6
 Wm/q6iYGo9ta935e/LaDw0p+dfp+KUaGDpOSp3PZm9tm2xkZP9f20WNmnsPou73CrVjsxGu/jON
 8AA==
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624

blk_mode_t and fop_flags_t are both plain 'unsigned int __bitwise' flag
typedefs, exactly like the gfp_t, slab_flags_t and fmode_t that already
live in <linux/types.h>. Move them there so they are available
everywhere without having to drag in a subsystem header.

Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 include/linux/blkdev.h | 2 --
 include/linux/fs.h     | 2 --
 include/linux/types.h  | 2 ++
 3 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 9e95bdb8b323..cee548184a7b 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -126,8 +126,6 @@ struct blk_integrity {
 	unsigned char				pi_tuple_size;
 };
 
-typedef unsigned int __bitwise blk_mode_t;
-
 /* open for reading */
 #define BLK_OPEN_READ		((__force blk_mode_t)(1 << 0))
 /* open for writing */
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 6da44573ce45..1c8fe40ad9a4 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1921,8 +1921,6 @@ struct dir_context {
 struct io_uring_cmd;
 struct offset_ctx;
 
-typedef unsigned int __bitwise fop_flags_t;
-
 struct file_operations {
 	struct module *owner;
 	fop_flags_t fop_flags;
diff --git a/include/linux/types.h b/include/linux/types.h
index 608050dbca6a..ef026585420b 100644
--- a/include/linux/types.h
+++ b/include/linux/types.h
@@ -163,6 +163,8 @@ typedef u32 dma_addr_t;
 typedef unsigned int __bitwise gfp_t;
 typedef unsigned int __bitwise slab_flags_t;
 typedef unsigned int __bitwise fmode_t;
+typedef unsigned int __bitwise blk_mode_t;
+typedef unsigned int __bitwise fop_flags_t;
 
 #ifdef CONFIG_PHYS_ADDR_T_64BIT
 typedef u64 phys_addr_t;

-- 
2.47.3


