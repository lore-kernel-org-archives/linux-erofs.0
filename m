Return-Path: <linux-erofs+bounces-3504-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 58CB0CD6E64
	for <linux-erofs@archiver.kernel.org>; Tue,  2 Jun 2026 10:10:47 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4gV66G0Bdtz2ytj;
	Tue, 02 Jun 2026 20:10:46 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=172.234.252.31
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1780395045;
	cv=none; b=mWLtcEtExCwiOUQDfPp16hy7SDssoka6jnuZJXZQ7HPlGr/iggsafEDuFT0b+Q3uU6FSXoDQSv9dUJJ1lJYrbP4Tslmj42ypx9PCV+D1hfqPBUG8vmOUIISYeSEsEa/3BvJw0h84Bmsjb+GSdxnNVQVxzeCIFIcirFNGx+HH6XU/WOYv/aEbrt4/eGalnZl6c3WVgnqadjDQD5CUKBMZCjYQd5x+hVeYBMGAxKjkBEVwdSMOTJxamuw1M4jsLW2N2u1a7nH4lHDiz8ET6fTN0yTvwoDGB7GIDEQe8tKoAk7sBlJMV9/v9tWP4gCkkBuhu/ERA/fXLOHjNj+i0NnKLw==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1780395045; c=relaxed/relaxed;
	bh=Rcl0Ij+Ta68yATaT5Q/U3eCvCYbsFeYyob8MpA9JEIY=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=UwHjYo4pNeca+1bRHReJP3TXBB3GgvHQLJlASpG3yueQmMIXML5dEgm+8SH0seXfJHM4h9+za3+WcTElROtsxoNbFpmVqiTo4kPrNra/1aaEKMSB3tyUJuhrXu0cpqddtAiQWqNFSSCnsc5m5AeNCZFn0m1PB8wgbP25YszLtrFH7F200H7f/eQffqvm7cJqYFqcFSuOSeYEUlsgKhLIGRyuNzPChJoXio4qWPm4IyFqKxShhAslL/BVVSPinxCYdlc9iLWeccVifuD++IeeOZr31NNJmU/pYPh/QH/qsr/hLuVdfc24G3OlEOq3924YiF8k3QFY9L2WqkaeR1S2QA==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=IcYRFZ7I; dkim-atps=neutral; spf=pass (client-ip=172.234.252.31; helo=sea.source.kernel.org; envelope-from=brauner@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=IcYRFZ7I;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=172.234.252.31; helo=sea.source.kernel.org; envelope-from=brauner@kernel.org; receiver=lists.ozlabs.org)
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4gV66F290jz2xdh
	for <linux-erofs@lists.ozlabs.org>; Tue, 02 Jun 2026 20:10:45 +1000 (AEST)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C610443B0D;
	Tue,  2 Jun 2026 10:10:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 416B61F00899;
	Tue,  2 Jun 2026 10:10:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780395043;
	bh=Rcl0Ij+Ta68yATaT5Q/U3eCvCYbsFeYyob8MpA9JEIY=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=IcYRFZ7IwF5i2OaH89y2up0aV6PvzsJqfvYMhN8Rb430whUhhGzKxCyO61VhDckN8
	 mdwK5pkZmT3BPZZ2F6YPiiuM867ZBfa6ef0HaJHGqB3X/ozsJJWexF5h8jHXFKML1k
	 oqoumaaaw6e1Hel59xTSQu+iyE3jZQ1A9Q/8NejBaZSDfHP/ifSkh2au0Fjza5xpWa
	 IrW4Vcsz7CnMp80iPim5gTBwbJSF+Z7YZbEOlJszNf7x+wdCisnmSxsc9W66E+6TYr
	 Wa5VA/7TNUf7EzQoU7ZT1PRntyOyrkVstP0XLHkDaECwCp7k0kvPAGxNgmF/kA2UOe
	 BMZza+NotpqGw==
From: Christian Brauner <brauner@kernel.org>
Date: Tue, 02 Jun 2026 12:10:12 +0200
Subject: [PATCH RFC 6/8] ext4: open via dedicated fs bdev helpers
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
Message-Id: <20260602-work-super-bdev_holder_global-v1-6-bb0fd82f3861@kernel.org>
References: <20260602-work-super-bdev_holder_global-v1-0-bb0fd82f3861@kernel.org>
In-Reply-To: <20260602-work-super-bdev_holder_global-v1-0-bb0fd82f3861@kernel.org>
To: Christoph Hellwig <hch@lst.de>, Jan Kara <jack@suse.cz>
Cc: Jens Axboe <axboe@kernel.dk>, Alexander Viro <viro@zeniv.linux.org.uk>, 
 linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-fsdevel@vger.kernel.org, Carlos Maiolino <cem@kernel.org>, 
 linux-xfs@vger.kernel.org, Chris Mason <clm@fb.com>, 
 David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org, 
 Theodore Ts'o <tytso@mit.edu>, linux-ext4@vger.kernel.org, 
 Gao Xiang <xiang@kernel.org>, linux-erofs@lists.ozlabs.org, 
 "Christian Brauner (Amutable)" <brauner@kernel.org>
X-Mailer: b4 0.16-dev-fffa9
X-Developer-Signature: v=1; a=openpgp-sha256; l=1960; i=brauner@kernel.org;
 h=from:subject:message-id; bh=tRD6D2ZvC10l0Swb1mE77uQnFpNR5auwAZCGdQLKj3I=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWTJreHQvVlsv1mBf/ON//MTCj44HOu5eIo74EO/d/ONo
 LLZxpF+HaUsDGJcDLJiiiwO7Sbhcst5KjYbZWrAzGFlAhnCwMUpABPpEGNkuLdt+8Ldt/37WQ7P
 +LFH8YH+sRW3n1wvXqvCWFi/48R+y0ZGhoVLNebPSzimfdyP4ci2z7+/z1hav17yfvESwfglBdm
 TYrgA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624

Route opens through fs_bdev_file_open_by_path() so each external device
is registered against the correct superblock, and convert the matching
releases.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/ext4/super.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 6a77db4d3124..8108d999008e 100644
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
 
@@ -7492,7 +7492,7 @@ static void ext4_kill_sb(struct super_block *sb)
 	kill_block_super(sb);
 
 	if (bdev_file)
-		bdev_fput(bdev_file);
+		fs_bdev_file_release(bdev_file, sb);
 }
 
 static struct file_system_type ext4_fs_type = {

-- 
2.47.3


