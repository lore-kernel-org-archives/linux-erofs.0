Return-Path: <linux-erofs+bounces-3645-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 44EDFCD98E1
	for <linux-erofs@archiver.kernel.org>; Tue, 16 Jun 2026 14:09:21 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4gfpl36VQCz3c4M;
	Wed, 17 Jun 2026 00:09:19 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2600:3c04:e001:324:0:1991:8:25"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1781618959;
	cv=none; b=S6yDqNHWZCwAReeJ7LLfBAQ3KyW4ZKs1OfsI5fXsgWn0NL9bBBCj+IG58D4YOu2Zjop0Bty+Ei8ATqRMloMPOYza0Vkq2cOO8Taxu687BTNDWBN7blFdoFzb/n+TP+PYnuPKU8QU35jjGuaQIgfD1B2I89Cvvvaw8Sw/DE0etgJepkfvBRXiqYdxiI9u5VPXZO3w8zZh0FoaPeLf+o/S5tcHzEs5duMNYUVUsCitpDv1dmg/nvtfu3YnoMpAriFIETc/f1hBEsdy28PAiwYWGKBuF7hCGf1ySKAmLgZ5ZbPS9DEP8KC8UijXtHN6ryad3Ko98h13tTF11McNMIzhhg==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1781618959; c=relaxed/relaxed;
	bh=Is8R3wvaCq/80vj1DXKU0n4cGeOyh4O2DUMSCyO+wtE=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=lP0vZ2Kt+sSQO7WjCI+f+8GhQa9tYe4nsO7QYKsnDJr2S9e7FQKmxHseiUNrBhvh6F9cTBuRGIrEUM5TWCgcO4FXDv8WJ0UKdKv7K58vcsV1HBsJl0zWaeqhGv2PQK99NEo1CXk5q4/S2JGB+1YZfvgMmCkuFoQ0YuNhy/nRaiZ6423jXqojE0SkOUMBeHTwizQczkATdvIwn+q1TjdP9ai2Dwg3C+si58oiwrJko3a/wFJvAPzArYTxrN15+z7aS/qAeBpHeXFuus2A8R0rjmmenPYf/dOllyDR5eTNUxK1ihcyh3BiDL/bg40u5dR0PX1M1dGrWxNMhnXCXA9/Bg==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WcApXdFf; dkim-atps=neutral; spf=pass (client-ip=2600:3c04:e001:324:0:1991:8:25; helo=tor.source.kernel.org; envelope-from=brauner@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WcApXdFf;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=2600:3c04:e001:324:0:1991:8:25; helo=tor.source.kernel.org; envelope-from=brauner@kernel.org; receiver=lists.ozlabs.org)
Received: from tor.source.kernel.org (tor.source.kernel.org [IPv6:2600:3c04:e001:324:0:1991:8:25])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4gfpl30SNJz2yv0
	for <linux-erofs@lists.ozlabs.org>; Wed, 17 Jun 2026 00:09:19 +1000 (AEST)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 2EB2A600AB;
	Tue, 16 Jun 2026 14:09:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93E671F00A3F;
	Tue, 16 Jun 2026 14:09:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781618956;
	bh=Is8R3wvaCq/80vj1DXKU0n4cGeOyh4O2DUMSCyO+wtE=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=WcApXdFfYYYKjKwwroYDEmWqiKf8LsKq1xZJ/+ThX43fSpdUpzlicaz96+1qaRxSo
	 DlF3HFcwGG/E5T2G/JSXGhneiDFiaJZtUOrfByxmRwpS6eaJ2O4xYIWldm0YG0yTOn
	 sj+gjoCm1wmNH10dqcrAB2NsHTNxP4lwrzomS2+Bd+UM2HqgQbcL4mu1QPeLVrByr/
	 cPqInXaWJvx0zs4gs1FHE1cwUd7Jy7SPgYdhGRm06rGrKazUSEyff9D3uHVMEVM8K3
	 XjSrcKU8XL+GRy0xxsW3cfSbIqcxYF0SoNgPf8W+yflfSUVbX3IGfVHoP4fYqqI6yU
	 DKTo9j2IEaJ6Q==
From: Christian Brauner <brauner@kernel.org>
Date: Tue, 16 Jun 2026 16:08:27 +0200
Subject: [PATCH RFC v2 11/18] ext4: open via dedicated fs bdev helpers
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
Message-Id: <20260616-work-super-bdev_holder_global-v2-11-7df6b864028e@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2024; i=brauner@kernel.org;
 h=from:subject:message-id; bh=mEavDJy+fkdUc8IBWKjs2UM866Kx5OEdydgBKLvNJwI=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWQZRtw/777zxln1Gg6hy+86lq71uK52TVV/ggaDjGXHR
 7P/82UndpSyMIhxMciKKbI4tJuEyy3nqdhslKkBM4eVCWQIAxenAEwk9i3DP0275KOKq+ari5eI
 VrQu8TB8t+OwjVe20bTnVeVnrm6x9Wb4K3nmZUBeQdm864XnxYVXvAw/V/ghdfKEz38CbaVuVpu
 VMgAA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624

Route the external journal device open through fs_bdev_file_open_by_dev()
so it is registered against the superblock, and convert the matching
releases to fs_bdev_file_release().

Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/ext4/super.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 7283108d7609..2b5301a3bcfb 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -5793,7 +5793,7 @@ failed_mount8: __maybe_unused
 	brelse(sbi->s_sbh);
 	if (sbi->s_journal_bdev_file) {
 		invalidate_bdev(file_bdev(sbi->s_journal_bdev_file));
-		bdev_fput(sbi->s_journal_bdev_file);
+		fs_bdev_file_release(sbi->s_journal_bdev_file, sb);
 	}
 out_fail:
 	invalidate_bdev(sb->s_bdev);
@@ -5972,9 +5972,9 @@ static struct file *ext4_get_journal_blkdev(struct super_block *sb,
 	struct ext4_super_block *es;
 	int errno;
 
-	bdev_file = bdev_file_open_by_dev(j_dev,
+	bdev_file = fs_bdev_file_open_by_dev(j_dev,
 		BLK_OPEN_READ | BLK_OPEN_WRITE | BLK_OPEN_RESTRICT_WRITES,
-		sb, &fs_holder_ops);
+		sb, sb);
 	if (IS_ERR(bdev_file)) {
 		ext4_msg(sb, KERN_ERR,
 			 "failed to open journal device unknown-block(%u,%u) %ld",
@@ -6034,7 +6034,7 @@ static struct file *ext4_get_journal_blkdev(struct super_block *sb,
 out_bh:
 	brelse(bh);
 out_bdev:
-	bdev_fput(bdev_file);
+	fs_bdev_file_release(bdev_file, sb);
 	return ERR_PTR(errno);
 }
 
@@ -6073,7 +6073,7 @@ static journal_t *ext4_open_dev_journal(struct super_block *sb,
 out_journal:
 	ext4_journal_destroy(EXT4_SB(sb), journal);
 out_bdev:
-	bdev_fput(bdev_file);
+	fs_bdev_file_release(bdev_file, sb);
 	return ERR_PTR(errno);
 }
 
@@ -7490,7 +7490,7 @@ static void ext4_kill_sb(struct super_block *sb)
 	kill_block_super(sb);
 
 	if (bdev_file)
-		bdev_fput(bdev_file);
+		fs_bdev_file_release(bdev_file, sb);
 }
 
 static struct file_system_type ext4_fs_type = {

-- 
2.47.3


