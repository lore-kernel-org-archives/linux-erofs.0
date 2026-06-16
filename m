Return-Path: <linux-erofs+bounces-3640-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0A0FACD98DA
	for <linux-erofs@archiver.kernel.org>; Tue, 16 Jun 2026 14:09:02 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4gfpkh4z4sz3c3l;
	Wed, 17 Jun 2026 00:09:00 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2600:3c04:e001:324:0:1991:8:25"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1781618940;
	cv=none; b=bsRq+Mnc13wSovGVaTR7jVzR1Rv5FFBt6KitbQnnO0RHpdgSRgX2rClkdQ3rCYtNOjzeCr3pIH6uuVWV+3L1zIEI+dR4emocvjsoDjLFMvOW+g4us5HfETbENkwGg4FqfP8pUR9NtQP3I1X40uGcFnCg0B9fdlSI1efTGjNf/V1hOTLRBjGBIMjuIvZfj56K04aU5+Tq/KtaFIM5byF0XlkqfQzPIIKguTCjQfceVl1f3+r1k4JpOgpmZzxnMxHfvEjmG19TAskEDUalIlLTcWnY36vGkg1N+fz7e5wVNdvaWN2WlTO9ApIoozb+W6KT57oOCOJdHf/fzjQ4rAmITQ==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1781618940; c=relaxed/relaxed;
	bh=jyk+CgoW+m5rVgz4pEmy12TufZuRoXjKBOU5hRik7pA=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=ckeudMzVufgbPMtGqR5lKwej0AB55sVhgR8uqQHNLywDXRIrWc4X6wqEgJXvpH4PugQ3h28XoefHc3mcm3AaGc0huQrNi0fw7KqZQEh6xx62z2PPrhgyqb43flEAU/aV0N+7BBdO/BZerIOly0Th1QN4VD3lrEWkrSOBAVRz1/D7PhDVm92ovGSV5qUR7mFdRj1sYkoL1u3xXr4DXxeaKOW5OeugIsmsYcQemTf/YYWuH4qe/I+/qQvWE4LUYeGdzJQxNjqQ2zYttb2eFz4TaLfwPC0mkGYGLdqzsSLPn8YSPA2Vp4+55G8TyMuJxkbki+X4rLKkyq6GZBL4Np9OjQ==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VJ3UaXsz; dkim-atps=neutral; spf=pass (client-ip=2600:3c04:e001:324:0:1991:8:25; helo=tor.source.kernel.org; envelope-from=brauner@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VJ3UaXsz;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=2600:3c04:e001:324:0:1991:8:25; helo=tor.source.kernel.org; envelope-from=brauner@kernel.org; receiver=lists.ozlabs.org)
Received: from tor.source.kernel.org (tor.source.kernel.org [IPv6:2600:3c04:e001:324:0:1991:8:25])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4gfpkh0fjnz2yv0
	for <linux-erofs@lists.ozlabs.org>; Wed, 17 Jun 2026 00:09:00 +1000 (AEST)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 3DBF160122;
	Tue, 16 Jun 2026 14:08:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5E1D1F00AC4;
	Tue, 16 Jun 2026 14:08:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781618938;
	bh=jyk+CgoW+m5rVgz4pEmy12TufZuRoXjKBOU5hRik7pA=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=VJ3UaXszlXPVuZuam+qBXCCDrxZIpxk9S1AdD9ftU8NvHmNH6lPc2+/u4iD9DOhZa
	 1imF35uPSagyWC5SC5hai+K845p0dZgl3IKZEb/O4DIgbCzG9AdNvCJpDkBmTNEOnA
	 Xwy2jP3kp3vAjRd5DxFGY9mljC2uWTexjPthT/Kq/VXgk0LsLWpq9uDSsrzbHcUVel
	 Y4EWfZhXPD39NyxWX8C7JiNKtqz3QVIqHpIpUYph/+xc3PCCsIC+TOZPIfXhVqHaKn
	 RHiR7tvHaVOQ3fskl/lOXLnk82Z9r/Tlcf17ElvpPtPvOVOWphNmLonUUEHjXkV3Dk
	 xm4jU5jZHO4yg==
From: Christian Brauner <brauner@kernel.org>
Date: Tue, 16 Jun 2026 16:08:22 +0200
Subject: [PATCH RFC v2 06/18] ocfs2: don't reset s_dev on dismount
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
Message-Id: <20260616-work-super-bdev_holder_global-v2-6-7df6b864028e@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1104; i=brauner@kernel.org;
 h=from:subject:message-id; bh=qvtFS8Lr84dJBr8irgZxZ3qqnPvYlFg8UNVTahpR3ds=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWQZRtzLYJveuCfB9VyszzyjZfN+vvJYfU5V6e3TP8/Kp
 q/T/17p01HKwiDGxSArpsji0G4SLrecp2KzUaYGzBxWJpAhDFycAjARy1uMDAfVqjjX5ORN+/2s
 eamGMff/tzMUytcJzfNlsLv1/bNviCfD/1J++VB/gTWG7efSHxSYm8QFBh7Sl86Rez83e1GuT6Y
 LDwA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624

ocfs2_dismount_volume() has reset sb->s_dev to zero since the original
merge in ccd979bdbce9 ("[PATCH] OCFS2: The Second Oracle Cluster
Filesystem") as part of scrubbing the super_block. Nothing reads the
field afterwards: all ocfs2-internal uses are mount-time log and trace
prints, and dev_t-keyed superblock lookups skip a dying superblock
anyway - s_root is gone before ->put_super runs and super_lock()
refuses SB_DYING superblocks.

The upcoming device-to-superblock table registers every superblock
under its s_dev. Drop the reset instead of leaving a superblock around
whose s_dev contradicts its registration.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/ocfs2/super.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
index 4870e680c4e5..df9ebff25dab 100644
--- a/fs/ocfs2/super.c
+++ b/fs/ocfs2/super.c
@@ -1882,7 +1882,6 @@ static void ocfs2_dismount_volume(struct super_block *sb, int mnt_err)
 
 	ocfs2_delete_osb(osb);
 	kfree(osb);
-	sb->s_dev = 0;
 	sb->s_fs_info = NULL;
 }
 

-- 
2.47.3


