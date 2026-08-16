Return-Path: <linux-erofs+bounces-4230-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A5D19C5DF67
	for <linux-erofs@archiver.kernel.org>; Sun, 16 Aug 2026 02:00:13 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hMzgb4CjVz2xlv;
	Sun, 16 Aug 2026 12:00:11 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=157.180.15.194
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1786845611;
	cv=none; b=G+ihPbcnNjI1XsY99quM8IvBQt4HJN9EwLDwtVq/89Ff0vY6uiN/yc+FBYQmAzdt1EyYDyKq7fmnPBLCfVJdhBvuleugUnody6b/30Dchqk+KuufwRrfxEyKPPzJT2Pbc64L3fJPdvABZ19BvwTO7D1luGMhdBJLZ8xMb4oH+BRh+zCQOnp330dPqUyyMJTWoTt5LrJTLL+sqp5GFLYIlK7t4XMxBPLe48HKoLfyz7QgE0PxFGNPHuA4O2cDxDxrus0ZHDh2sgy+SlnUyET+d50irbZ6YgOAN1V8LG9hUvKuARgkebcsdcqeBgBB8Iqh37S/1u9XnpmRWf9FSVwVWg==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1786845611; c=relaxed/relaxed;
	bh=gWQXs5fmIWtU2tjXrYXfAcuUwCKxCwdQuj+zUyUIJKM=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=a0AqqlzI3zTWVfrJYXfyYLpcfTdpgdbxExz386R62LvhhHj7XRM2gqdTz+jsKnXvqOOR57cTRiBc0x/RpGTxmm0zA7mguksB1uY42MwSMH9YCEdzcxcBrZ9l0aABOomDgKnYXIWVKDEeBs5MrDm57TJHyYltpusrjOmQQbAoxKob71Ry47/lw0nOPn2R+ToE0JWyPYkYU/mumJFyO88NDvWcFzNIHJmq5cAP7lhpWv/a+2ytiNPDqfJe68EzX3TuXNQNE4rKZpbGQmsj9njh6Srz0rIqEU6H63hYp1O7kwBrcjFyEEuqHYJa7oVPz/gYjgsjBkwID8QkzVN9ajJN3A==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=envs.net; dkim=pass (4096-bit key; secure) header.d=envs.net header.i=@envs.net header.a=rsa-sha256 header.s=modoboa header.b=qA6lTlFz; dkim-atps=neutral; spf=pass (client-ip=157.180.15.194; helo=mail.envs.net; envelope-from=xtex@envs.net; receiver=lists.ozlabs.org) smtp.mailfrom=envs.net
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=envs.net
Authentication-Results: lists.ozlabs.org;
	dkim=pass (4096-bit key; secure) header.d=envs.net header.i=@envs.net header.a=rsa-sha256 header.s=modoboa header.b=qA6lTlFz;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=envs.net (client-ip=157.180.15.194; helo=mail.envs.net; envelope-from=xtex@envs.net; receiver=lists.ozlabs.org)
Received: from mail.envs.net (mail.envs.net [157.180.15.194])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hMzgS5h7tz2yLY
	for <linux-erofs@lists.ozlabs.org>; Sun, 16 Aug 2026 12:00:02 +1000 (AEST)
Received: from localhost (mail.envs.net [127.0.0.1])
	by mail.envs.net (Postfix) with ESMTP id 597A31C00D6;
	Sun, 16 Aug 2026 01:59:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=envs.net; s=modoboa;
	t=1786845597; bh=gWQXs5fmIWtU2tjXrYXfAcuUwCKxCwdQuj+zUyUIJKM=;
	h=From:Date:Subject:To:Cc:From;
	b=qA6lTlFzJQTefYwWi+xGilguVwKIwGhjT8Vq+A5yzLt9V1BxOLA6VhH158v88pRDg
	 GqR0jlbT21bavcUpbmQIwScgzDA6NsymON4iSE4H2oqLeFIGCSYognhMm2VvBzJ0wA
	 w2l4nPfjIbk8dD1xVf3pg2zOdIRbmyxeCuSyJJLnetCxl2hKEnU2lR+EczIZHNTW4I
	 i/hMtLufhWwDoSsjs86Br4thf8yWkJmqueNK5SGYU9988S8wilbHSCRXh+L+bLch/U
	 RUYXynPH2nO48U063GhwJ665fyImKTxxfXkjRNgAF8/T/RYkAQUbSgAdt28oGmMelW
	 aVVhsruGVr9GClpDkKNCVB8btzzAv7l9oVbBgKGF6gkl6QnxuysMi2S4EB7tUl7/V7
	 CUqYWawYw/QqWuih67IfCpNDUlXlngFfFbAy81ICtC63EQiQ35ZL9AVzRmxcst0f3R
	 hpHpd8KenogcD4ETYv4PN6aerCxOeEt9XvP7MJ8i2xQB6rCJrClVn5pw8u4MWO5YFO
	 N/ThdQSpjTao2gUu4Zeenb8VJdTAohi1hQM9uBzW+wMGl7HlCTKTwjwjH96qlXcUqA
	 7S66hUOiyRO+9XcwiiFykSZwZt5/QVJiuC/882dmU1yQSbhzVMecvnHKq7kBzEBT3H
	 WE8ilJItm3UR3Avs/K3niCXw=
X-Virus-Scanned: Debian amavisd-new at mail.envs.net
Received: from mail.envs.net ([127.0.0.1])
	by localhost (mail.envs.net [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id CEQZmUPLVZe6; Sun, 16 Aug 2026 01:59:52 +0000 (UTC)
Received: from [192.168.0.106] (unknown [120.230.214.2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mail.envs.net (Postfix) with ESMTPSA;
	Sun, 16 Aug 2026 01:59:51 +0000 (UTC)
From: Bingwu Zhang <xtex@envs.net>
Date: Sun, 16 Aug 2026 10:00:12 +0800
Subject: [PATCH] erofs: remove erofs_dev_context->rwsem
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
Message-Id: <20260816-erofs-remove-rwsem-v1-1-78b60b855fa6@astrafall.org>
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/yXMQQ6CMBBG4auQWTtJacRUr0JcVPoDYwI1M4omh
 Ltbcfkt3lvJoAKjS7WSYhGTPBfUh4q6Mc4DWFIxeedPLtRHhubeWDHlBaxvw8RNdOfgU5NicFT
 Ch6KXzz5tr3/b63ZH9/ydaNu+vl6SNXYAAAA=
X-Change-ID: 20260814-erofs-remove-rwsem-5a0982d5da80
To: Gao Xiang <xiang@kernel.org>, Chao Yu <chao@kernel.org>, 
 Yue Hu <zbestahu@gmail.com>, Jeffle Xu <jefflexu@linux.alibaba.com>, 
 Sandeep Dhavale <dhavale@google.com>, Hongbo Li <hongbohbli@tencent.com>, 
 Chunhai Guo <guochunhai@vivo.com>
Cc: linux-erofs@lists.ozlabs.org, linux-kernel@vger.kernel.org, 
 Bingwu Zhang <xtex@astrafall.org>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openssh-sha256; t=1786845640; l=3227;
 i=xtex@astrafall.org; h=from:subject:message-id;
 bh=AvjOtrYNb3uWIOXdgsBc2lWvyD8IHYCLActrdVEWmCk=;
 b=U1NIU0lHAAAAAQAAADMAAAALc3NoLWVkMjU1MTkAAAAgL1erbbl1jNM9AtzeLFJ5FKVqr/ylJ
 MBUj5+W9IwwCl4AAAAGcGF0YXR0AAAAAAAAAAZzaGE1MTIAAABTAAAAC3NzaC1lZDI1NTE5AAAA
 QM7Wa15Sy4qoRwY4MyxCtHbq00O0SmQQR1V1bpMPifrZQD7rygSlR5LflG4w2C0MQn8EfiHC+lX
 ezgo7lCmGlAM=
X-Developer-Key: i=xtex@astrafall.org; a=openssh;
 fpr=SHA256:IEYEjkZlkUTr5U9GiDAmZU/4eZus2t2RsxusyhQqwao

From: Bingwu Zhang <xtex@astrafall.org>

devs->tree is only modified in initialization and
destruction code paths and will never be concurrent
with data reading. Thus there is no need to guard
idr_alloc/idr_find with a rwsem.

Signed-off-by: Bingwu Zhang <xtex@astrafall.org>
---
 fs/erofs/data.c     | 9 +--------
 fs/erofs/internal.h | 1 -
 fs/erofs/super.c    | 5 -----
 3 files changed, 1 insertion(+), 14 deletions(-)

diff --git a/fs/erofs/data.c b/fs/erofs/data.c
index 9aa48c8d67d1..49d62eac6eb4 100644
--- a/fs/erofs/data.c
+++ b/fs/erofs/data.c
@@ -216,21 +216,15 @@ int erofs_map_dev(struct super_block *sb, struct erofs_map_dev *map)
 	erofs_fill_from_devinfo(map, sb, &EROFS_SB(sb)->dif0);
 	map->m_bdev = sb->s_bdev;	/* use s_bdev for the primary device */
 	if (map->m_deviceid) {
-		down_read(&devs->rwsem);
 		dif = idr_find(&devs->tree, map->m_deviceid - 1);
-		if (!dif) {
-			up_read(&devs->rwsem);
+		if (!dif)
 			return -ENODEV;
-		}
 		if (devs->flatdev) {
 			map->m_pa += erofs_pos(sb, dif->uniaddr);
-			up_read(&devs->rwsem);
 			return 0;
 		}
 		erofs_fill_from_devinfo(map, sb, dif);
-		up_read(&devs->rwsem);
 	} else if (devs->extra_devices && !devs->flatdev) {
-		down_read(&devs->rwsem);
 		idr_for_each_entry(&devs->tree, dif, id) {
 			if (!dif->uniaddr)
 				continue;
@@ -243,7 +237,6 @@ int erofs_map_dev(struct super_block *sb, struct erofs_map_dev *map)
 				break;
 			}
 		}
-		up_read(&devs->rwsem);
 	}
 	return 0;
 }
diff --git a/fs/erofs/internal.h b/fs/erofs/internal.h
index 57bd21859c65..811c160035ce 100644
--- a/fs/erofs/internal.h
+++ b/fs/erofs/internal.h
@@ -65,7 +65,6 @@ struct erofs_mount_opts {
 
 struct erofs_dev_context {
 	struct idr tree;
-	struct rw_semaphore rwsem;
 
 	unsigned int extra_devices;
 	bool flatdev;
diff --git a/fs/erofs/super.c b/fs/erofs/super.c
index 9d8f862f309f..12ecdd4b85ac 100644
--- a/fs/erofs/super.c
+++ b/fs/erofs/super.c
@@ -215,7 +215,6 @@ static int erofs_scan_devices(struct super_block *sb,
 
 	sbi->device_id_mask = roundup_pow_of_two(ondisk_extradevs + 1) - 1;
 	pos = le16_to_cpu(dsb->devt_slotoff) * EROFS_DEVT_SLOT_SIZE;
-	down_read(&sbi->devs->rwsem);
 	if (sbi->devs->extra_devices) {
 		idr_for_each_entry(&sbi->devs->tree, dif, id) {
 			err = erofs_init_device(&buf, sb, dif, &pos);
@@ -242,7 +241,6 @@ static int erofs_scan_devices(struct super_block *sb,
 				break;
 		}
 	}
-	up_read(&sbi->devs->rwsem);
 	erofs_put_metabuf(&buf);
 	return err;
 }
@@ -489,9 +487,7 @@ static int erofs_fc_parse_param(struct fs_context *fc,
 			kfree(dif);
 			return -ENOMEM;
 		}
-		down_write(&sbi->devs->rwsem);
 		ret = idr_alloc(&sbi->devs->tree, dif, 0, 0, GFP_KERNEL);
-		up_write(&sbi->devs->rwsem);
 		if (ret < 0) {
 			kfree(dif->path);
 			kfree(dif);
@@ -850,7 +846,6 @@ static int erofs_init_fs_context(struct fs_context *fc)
 	fc->s_fs_info = sbi;
 
 	idr_init(&sbi->devs->tree);
-	init_rwsem(&sbi->devs->rwsem);
 	erofs_default_options(sbi);
 	fc->ops = &erofs_context_ops;
 	return 0;

---
base-commit: 3eb40771c00a8488fa6ed2cc1fe203477908bf38
change-id: 20260814-erofs-remove-rwsem-5a0982d5da80

Best regards,
--  
Bingwu Zhang <xtex@astrafall.org>


