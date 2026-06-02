Return-Path: <linux-erofs+bounces-3503-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CD1E8CD6E57
	for <linux-erofs@archiver.kernel.org>; Tue,  2 Jun 2026 10:10:44 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4gV66C3rFvz2ytJ;
	Tue, 02 Jun 2026 20:10:43 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=172.105.4.254
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1780395043;
	cv=none; b=TY4jQS9+DeoW1dQQ9UfRXkRd/Of+7uMJEK2V5F53IIGnDKYmf9UZpMdq/t/D2XJP4s37cdDPoknI+M7+ir2d6rC4nDHHSKHCsjEGnbdWTBgQbgjGeIFbquf9pPzgLwZ0S1Z+zsjS3t4G6RbZ5bj3KewrC5chhV/mfxAlzWaJ3RdBvUvGTPOA7HE/NJerAF5yBTATug3p4DGAW3HfdmIXleL8wLldvf7Hhxc1pc9G+ewEL4KRVtZeqfd/JNJkq5Oe4AUTYks2PaXXrAbuwpo1xm1C8VvPNyj7sY+yCUpSpi2sagZob1KFE2P6Kz1T+3M9whUiEJai5h1+MNFw5b6Skw==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1780395043; c=relaxed/relaxed;
	bh=Y8/E0TuOj6HisojXfCRnxMPnMP6DVmDM0aSEXinDBTM=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=i1InKWs1FXES7r8ufbDL8P64iPCcJkvQkrtc4bk5fXQq3pYHCvzhmZ6kXwxgUR6mhfBUM6m6voO8b7khQhxQfqC2SHtte1WkklWF2bQK4edOATbPLcP0/l7p1dPKz/AH+WXQvvvh/YSS/LMy0qSiscbmS2voWE3KbkR9bRk/J415coOocI90xVOIwPWBpyOrIIQtirzquGNZyBx4kQPUkeCLc7s4Lxe+Kp3RhXutH1d0Dtq9i2mVM5wqV80gDiii7DTZrt88dd73qDZy7xFFB5FNE0eVYsX630durMawqTaukWIpjfTQwhmPqQ7u7pG0sgpwutt7ir9hA7QGcKZduw==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WQeLmDsh; dkim-atps=neutral; spf=pass (client-ip=172.105.4.254; helo=tor.source.kernel.org; envelope-from=brauner@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WQeLmDsh;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=172.105.4.254; helo=tor.source.kernel.org; envelope-from=brauner@kernel.org; receiver=lists.ozlabs.org)
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4gV66972Qtz2xdh
	for <linux-erofs@lists.ozlabs.org>; Tue, 02 Jun 2026 20:10:41 +1000 (AEST)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 1D8D260138;
	Tue,  2 Jun 2026 10:10:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8751F1F0089E;
	Tue,  2 Jun 2026 10:10:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780395039;
	bh=Y8/E0TuOj6HisojXfCRnxMPnMP6DVmDM0aSEXinDBTM=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=WQeLmDshDmSVqiwu4w+Ps30a/Px9tLvBr3ZxYV1T/pO05z0uG+q/nWeMSnY2qqwjR
	 gw2ssSZPIXMboT49toM2ciEyuYRlRTB1l737ZWecKj2C3FkwtQ+ugiXYQzkNKhHEnG
	 yHZiju/5+pCeXtkRIod6jSckUVYEm8wE/hB4uD43SZDn6PSQuYOMOZBncu3F5X+k3k
	 dVTbvwUtrzvvHw/9vK45zsrglaTmh1dKmYzvuoQuhz5rHKa1n9jVKh/aDr4C7lRqq6
	 lX+Yz/BnuDvINboizgtmr66rq6wr/7UqLMEq1Wmh1M4p5OeSKU1/5DXMSAkHaArDux
	 UN4P2IBbXUBAA==
From: Christian Brauner <brauner@kernel.org>
Date: Tue, 02 Jun 2026 12:10:11 +0200
Subject: [PATCH RFC 5/8] btrfs: open via dedicated fs bdev helpers
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
Message-Id: <20260602-work-super-bdev_holder_global-v1-5-bb0fd82f3861@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=5068; i=brauner@kernel.org;
 h=from:subject:message-id; bh=R6lYGCJCu4lkxrUCRLzgOgiNYkfZrRAWRY4AmVTHu6c=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWTJreGoVd72Q36ffFai5ax5Ytve3U7h2uDTrWvJwMy03
 aVja11sRykLgxgXg6yYIotDu0m43HKeis1GmRowc1iZQIYwcHEKwESaMhgZfm/9Guscvav3GfPp
 9XnP04vnly6w2+cnd8SsfdKL85KmYQy/WeP+PNzAtjHCs67Gm7379v4r8zY/2cj85fBRM4VYfoG
 VDAA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624

Route opens through fs_bdev_file_open_by_path() so each external device
is registered against the correct superblock, and convert the matching
releases.

The temporary identification opens that only read the superblock and close
again pass a NULL holder and are left untouched.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/btrfs/dev-replace.c |  6 +++---
 fs/btrfs/ioctl.c       |  4 ++--
 fs/btrfs/volumes.c     | 26 +++++++++++++++++---------
 3 files changed, 22 insertions(+), 14 deletions(-)

diff --git a/fs/btrfs/dev-replace.c b/fs/btrfs/dev-replace.c
index 8f8fa14886de..463155b0b1ff 100644
--- a/fs/btrfs/dev-replace.c
+++ b/fs/btrfs/dev-replace.c
@@ -247,8 +247,8 @@ static int btrfs_init_dev_replace_tgtdev(struct btrfs_fs_info *fs_info,
 		return -EINVAL;
 	}
 
-	bdev_file = bdev_file_open_by_path(device_path, BLK_OPEN_WRITE,
-					   fs_info->sb, &fs_holder_ops);
+	bdev_file = fs_bdev_file_open_by_path(device_path, BLK_OPEN_WRITE,
+					      fs_info->sb, fs_info->sb);
 	if (IS_ERR(bdev_file)) {
 		btrfs_err(fs_info, "target device %s is invalid!", device_path);
 		return PTR_ERR(bdev_file);
@@ -325,7 +325,7 @@ static int btrfs_init_dev_replace_tgtdev(struct btrfs_fs_info *fs_info,
 	return 0;
 
 error:
-	bdev_fput(bdev_file);
+	fs_bdev_file_release(bdev_file, fs_info->sb);
 	return ret;
 }
 
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index b2e447f5005c..16afa71b98f2 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -2579,7 +2579,7 @@ static long btrfs_ioctl_rm_dev_v2(struct file *file, void __user *arg)
 err_drop:
 	mnt_drop_write_file(file);
 	if (bdev_file)
-		bdev_fput(bdev_file);
+		fs_bdev_file_release(bdev_file, fs_info->sb);
 out:
 	btrfs_put_dev_args_from_path(&args);
 	kfree(vol_args);
@@ -2630,7 +2630,7 @@ static long btrfs_ioctl_rm_dev(struct file *file, void __user *arg)
 
 	mnt_drop_write_file(file);
 	if (bdev_file)
-		bdev_fput(bdev_file);
+		fs_bdev_file_release(bdev_file, fs_info->sb);
 out:
 	btrfs_put_dev_args_from_path(&args);
 out_free:
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index a88e68f90564..6f7d7afb4d66 100644
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
@@ -1082,7 +1090,7 @@ static void __btrfs_free_extra_devids(struct btrfs_fs_devices *fs_devices,
 			continue;
 
 		if (device->bdev_file) {
-			bdev_fput(device->bdev_file);
+			fs_bdev_file_release(device->bdev_file, fs_devices->fs_info->sb);
 			device->bdev = NULL;
 			device->bdev_file = NULL;
 			fs_devices->open_devices--;
@@ -1129,7 +1137,7 @@ static void btrfs_close_bdev(struct btrfs_device *device)
 		invalidate_bdev(device->bdev);
 	}
 
-	bdev_fput(device->bdev_file);
+	fs_bdev_file_release(device->bdev_file, device->fs_info->sb);
 }
 
 static void btrfs_close_one_device(struct btrfs_device *device)
@@ -2820,8 +2828,8 @@ int btrfs_init_new_device(struct btrfs_fs_info *fs_info, const char *device_path
 	if (sb_rdonly(sb) && !fs_devices->seeding)
 		return -EROFS;
 
-	bdev_file = bdev_file_open_by_path(device_path, BLK_OPEN_WRITE,
-					   fs_info->sb, &fs_holder_ops);
+	bdev_file = fs_bdev_file_open_by_path(device_path, BLK_OPEN_WRITE,
+					      fs_info->sb, fs_info->sb);
 	if (IS_ERR(bdev_file))
 		return PTR_ERR(bdev_file);
 
@@ -3045,7 +3053,7 @@ int btrfs_init_new_device(struct btrfs_fs_info *fs_info, const char *device_path
 error_free_device:
 	btrfs_free_device(device);
 error:
-	bdev_fput(bdev_file);
+	fs_bdev_file_release(bdev_file, fs_info->sb);
 	if (locked) {
 		mutex_unlock(&uuid_mutex);
 		up_write(&sb->s_umount);

-- 
2.47.3


