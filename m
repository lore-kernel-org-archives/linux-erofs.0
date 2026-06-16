Return-Path: <linux-erofs+bounces-3644-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 07120CD98DA
	for <linux-erofs@archiver.kernel.org>; Tue, 16 Jun 2026 14:09:17 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4gfpkz51R6z3c3v;
	Wed, 17 Jun 2026 00:09:15 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=172.234.252.31
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1781618955;
	cv=none; b=MX6rYvNACmDc0x/CvISIHk8RAFX0Gx/h4J5Bw/DMBPe50DgLb1fhfkvCtGaGFkXDF/NWZBCeDHR5OHUNWuh7ikDzr/q1AZa/cnJZDyLLx+/H55tFA1MqgcBSsdHNgMJsE9POWut0pOOhn/4cZoGTgDTBz4m8gGS0TKt1li+0nlyohDxbV2pgzDQf7eM1zlwwHXB7j5pvJat/yjIB7xzeDb8uWnIK2yWp6eaEsTJvpts/0c0IEpuUjha2U482XuBIo2TYiIziD9tKyjxChlzKOC9Qmi8Gh7fbkszrEoFOoG/jVKCEkAPUyBbcFwXhjjMKQd3UIknAHtOWKO+n5PXE7A==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1781618955; c=relaxed/relaxed;
	bh=XwlYHCXEjgOfBd9eMDiRNWEu85T7O7itSinaXNxPYa0=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=g9YXDUarpH1ezMGQ+xBsipJFzoO8cQS7sce2430029MeNwYA35aYVoGGZx8ErEKNyIiZVohN5yo7AH7tuINQS5ix1DCh7YihtA9NTyhKL0X8nZ/M/5i6TZSu75aMd908JcTCxeVMdb4hJmFAg6OJdFbxhjP0HJ7PFMtTBJF0dLbPUCYXJzxGvauMuP9TiLGy9nlu3oRWKoPz3I/dVDDDhsnksjeJb/zxPaYUY5s5tnN7yGEFFe1IzHlQ8ATOxbQApSgeUq0kuqAh6bM8nZjJTfax+GQkembb58pVZKYt+zcAEYez89OFIUf0Sqy8yZsnPN0HloOdyXMxZOzos6X7/w==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Y8TQODWF; dkim-atps=neutral; spf=pass (client-ip=172.234.252.31; helo=sea.source.kernel.org; envelope-from=brauner@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Y8TQODWF;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=172.234.252.31; helo=sea.source.kernel.org; envelope-from=brauner@kernel.org; receiver=lists.ozlabs.org)
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4gfpky5TPyz2yv0
	for <linux-erofs@lists.ozlabs.org>; Wed, 17 Jun 2026 00:09:14 +1000 (AEST)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 3F2F8438DB;
	Tue, 16 Jun 2026 14:09:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0D4E1F00A3A;
	Tue, 16 Jun 2026 14:09:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781618953;
	bh=XwlYHCXEjgOfBd9eMDiRNWEu85T7O7itSinaXNxPYa0=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=Y8TQODWF+48JAbRxowOyxKTpW1leNmA3ssR1Z0UPIJWpiv9O2uXDVTneST3naTvrM
	 4KDRzktedgORUun6XI06jlQ12vXro1Mi6YyfLphuWxwkFuOTlHoltifJNLTuN472mJ
	 KAo/ZX2JT6PSCVWmZsGmj8nuVSdGiXu4oOawkfqEN9WTnRCdpJI4HupKiXr0tbMscc
	 rff7IWjKUkLtdS7AMaOmapYbtV/kcVCQetg42wuITzOd/inL03S0L2pZJAI0tNFmB1
	 8Mfh738rihlNQsJTK3XkQpCrrVvwXyK2pwiBDEhlPG3yxJNa4Tf8d0+2k7mhDAvMVE
	 n/oDlsPW+0cmA==
From: Christian Brauner <brauner@kernel.org>
Date: Tue, 16 Jun 2026 16:08:26 +0200
Subject: [PATCH RFC v2 10/18] btrfs: open via dedicated fs bdev helpers
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
Message-Id: <20260616-work-super-bdev_holder_global-v2-10-7df6b864028e@kernel.org>
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
 "Christian Brauner (Amutable)" <brauner@kernel.org>, 
 syzbot@syzkaller.appspotmail.com
X-Mailer: b4 0.16-dev-4090c
X-Developer-Signature: v=1; a=openpgp-sha256; l=4154; i=brauner@kernel.org;
 h=from:subject:message-id; bh=WAS9v0eXyVZhv6xmqXDDzRmVWFkX855PUkKhakPqLu4=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWQZRtw7OLVr6p+VW3/mZXMa7HkUX1DuszZep79hKlvAb
 OOWVxl+HaUsDGJcDLJiiiwO7Sbhcst5KjYbZWrAzGFlAhnCwMUpABNRfMnw38WNaeKu6wHf/6oe
 lWMRbZyerGmwY1foFS+hPF698PlfrjH8d/4ocOz//MUl7NNfJ+38qNVecMvfcnvO0T1pS1+9jfF
 /ygcA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624

Route the device opens through fs_bdev_file_open_by_path() so each device
is registered against the superblock, and convert the matching releases
to fs_bdev_file_release().

The temporary identification opens that only read the superblock and
close again pass a NULL holder and keep using bdev_fput().

On the close path the superblock is taken from bdev_file->private_data
(the holder set at open) rather than device->fs_info->sb: a mount that
fails before btrfs_init_devices_late() runs leaves device->fs_info NULL,
which close_fs_devices() would otherwise dereference.

Tested-by: syzbot@syzkaller.appspotmail.com
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/btrfs/volumes.c | 29 ++++++++++++++++++++---------
 1 file changed, 20 insertions(+), 9 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 2d9e2ca09c5f..02abbfce5ea3 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -480,7 +480,12 @@ btrfs_get_bdev_and_sb(const char *device_path, blk_mode_t flags, void *holder,
 	struct block_device *bdev;
 	int ret;
 
-	*bdev_file = bdev_file_open_by_path(device_path, flags, holder, &fs_holder_ops);
+	if (holder)
+		*bdev_file = fs_bdev_file_open_by_path(device_path, flags,
+						       holder, holder);
+	else
+		*bdev_file = bdev_file_open_by_path(device_path, flags, NULL,
+						    NULL);
 
 	if (IS_ERR(*bdev_file)) {
 		ret = PTR_ERR(*bdev_file);
@@ -495,7 +500,7 @@ btrfs_get_bdev_and_sb(const char *device_path, blk_mode_t flags, void *holder,
 	if (holder) {
 		ret = set_blocksize(*bdev_file, BTRFS_BDEV_BLOCKSIZE);
 		if (ret) {
-			bdev_fput(*bdev_file);
+			fs_bdev_file_release(*bdev_file, holder);
 			goto error;
 		}
 	}
@@ -503,7 +508,10 @@ btrfs_get_bdev_and_sb(const char *device_path, blk_mode_t flags, void *holder,
 	*disk_super = btrfs_read_disk_super(bdev, 0, false);
 	if (IS_ERR(*disk_super)) {
 		ret = PTR_ERR(*disk_super);
-		bdev_fput(*bdev_file);
+		if (holder)
+			fs_bdev_file_release(*bdev_file, holder);
+		else
+			bdev_fput(*bdev_file);
 		goto error;
 	}
 
@@ -727,7 +735,7 @@ static int btrfs_open_one_device(struct btrfs_fs_devices *fs_devices,
 
 error_free_page:
 	btrfs_release_disk_super(disk_super);
-	bdev_fput(bdev_file);
+	fs_bdev_file_release(bdev_file, holder);
 
 	return -EINVAL;
 }
@@ -1087,7 +1095,7 @@ static void __btrfs_free_extra_devids(struct btrfs_fs_devices *fs_devices,
 			continue;
 
 		if (device->bdev_file) {
-			bdev_fput(device->bdev_file);
+			fs_bdev_file_release(device->bdev_file, device->bdev_file->private_data);
 			device->bdev = NULL;
 			device->bdev_file = NULL;
 			fs_devices->open_devices--;
@@ -1127,10 +1135,12 @@ void btrfs_free_extra_devids(struct btrfs_fs_devices *fs_devices)
 /* Release a device that was made unfreezable for a membership change. */
 void btrfs_release_device_allow_freeze(struct file *bdev_file)
 {
+	struct super_block *sb = bdev_file->private_data;
+
 	/* Yield before allow (strand-safe); file still open for the allow (UAF-safe). */
 	bdev_yield_claim(bdev_file);
 	bdev_allow_freeze(file_bdev(bdev_file));
-	bdev_fput(bdev_file);
+	fs_bdev_file_release(bdev_file, sb);
 }
 
 static void btrfs_close_bdev(struct btrfs_device *device, bool allow_freeze)
@@ -1147,7 +1157,8 @@ static void btrfs_close_bdev(struct btrfs_device *device, bool allow_freeze)
 	if (allow_freeze)
 		btrfs_release_device_allow_freeze(device->bdev_file);
 	else
-		bdev_fput(device->bdev_file);
+		fs_bdev_file_release(device->bdev_file,
+				     device->bdev_file->private_data);
 }
 
 static void btrfs_close_one_device(struct btrfs_device *device)
@@ -2894,8 +2905,8 @@ struct file *btrfs_open_device_deny_freeze(const char *path,
 		return ERR_PTR(ret);
 	}
 
-	bdev_file = bdev_file_open_by_dev(file_bdev(probe_file)->bd_dev,
-					  BLK_OPEN_WRITE, sb, &fs_holder_ops);
+	bdev_file = fs_bdev_file_open_by_dev(file_bdev(probe_file)->bd_dev,
+					     BLK_OPEN_WRITE, sb, sb);
 	if (IS_ERR(bdev_file))
 		bdev_allow_freeze(file_bdev(probe_file));
 	bdev_fput(probe_file);

-- 
2.47.3


