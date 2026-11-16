Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE906606B19C
	for <linux-erofs@archiver.kernel.org>; Mon, 16 Nov 2026 11:07:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jk/FjUy0
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4jSlSC57Zhz30V2;
	Mon, 16 Nov 2026 22:07:07 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2600:3c0a:e001:78e:0:1991:8:25"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1794827227;
	cv=none; b=GbrZyE9atakwIJOnVv4S3GZmu/crxyPgJqC6tKFDDkfn7/e8KtSusJiESo55iubvoBSOi7Hu88Gxfh1qFmhnRs/abcM23VHidnBr7Ob+uuJxGaoTc4/e8Y3h6SSa6zGfBozY4yySS3Y0OYD/dKEmPCROQMdOZAHx8joU+3KrhmhkR6CO33U/iJ2AtiMPs03WgMRt2HawBHl5uIQ8uHefGUPKe1wAscFPKA90jddqi3ohtL25p1CLqQFxflBbduPnhlGfdXAvthDC/TqsBb6mFXMORgVL5XN3q4ZDrGeZqwjk7Kps6F0S0mRDjD/qQqKg+6qhqlmuJxN/RpUDDPDWuA==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1794827227; c=relaxed/relaxed;
	bh=ZjUZ/LbyySofwJKchunYgmcW+hv6mWM9r+0t30zrAC4=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=MsX55JS7H5YAF+3vpsRuBcbVJ5sCEEk1PoIdN72xZ9aDxdiXSNNtWYIG7I0xw7Vssnl8ZKG53cQiaIt4khQTmMJWe2b/UXGU7KGZnJF94ET7+tv7X6C/Br/cy2VukRed1OOGkktHSTcB6dzsFEPKQ2fWw4nt6998Ah+vEK8f7XUEvapheJHlplWRFpwf92ZmihHyfx6y7d9MDQs25drBrbR+w4PFpIfRiuTZEKtRBL+ITi3NBinZqw8f6rohH5fZndCLq9QblwIoSVl5RKHfniGLeo54yI8l0rj64cww41oikp86Iyb2ICPAPWQZvMTFPmBRH/tUYBs8c2BsHRIgKg==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jk/FjUy0; dkim-atps=neutral; spf=pass (client-ip=2600:3c0a:e001:78e:0:1991:8:25; helo=sea.source.kernel.org; envelope-from=brauner@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jk/FjUy0;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=2600:3c0a:e001:78e:0:1991:8:25; helo=sea.source.kernel.org; envelope-from=brauner@kernel.org; receiver=lists.ozlabs.org)
Received: from sea.source.kernel.org (sea.source.kernel.org [IPv6:2600:3c0a:e001:78e:0:1991:8:25])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4jSlSB6zS5z2xf8;
	Mon, 16 Nov 2026 22:07:06 +1100 (AEDT)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 780A64398A;
	Mon, 16 Nov 2026 11:07:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59EBE1F000CC;
	Mon, 16 Nov 2026 11:06:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794827225;
	bh=ZjUZ/LbyySofwJKchunYgmcW+hv6mWM9r+0t30zrAC4=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=jk/FjUy0cS6GgqVt9SsPloY8k3i4CqrkgFOMuEfM9XpfG/P/xdaYstLnK6As2uWUx
	 DEasrHPORlAiJurUDvkuRuudCdX4+089Oc2tRistqib9WEwQ5lBrReoBhl8MhZJbHr
	 l6aBHu8foX0BKN0F6xwxKuR1wHN/HENZS+AdFP226DO8djRCuCN7EcShhykNWGeUfv
	 2qReXmfM4j5HwLrmWLj8INf6brOXbWCkQPlzkcCvyFZ79G4NtpxPZuc+Bt5iZoOrkI
	 QVXW8/XVnBthjiWRTNhaVer+CxRfjJN9ob0t6JGwEOzJgRSBms1wlYdaktJYkpCcpN
	 a/EAYoQOnhFDQ==
From: Christian Brauner <brauner@kernel.org>
Date: Mon, 16 Nov 2026 12:04:41 +0100
Subject: [PATCH RFC v3 08/44] mqueue: use fc_init_pseudo()
X-Mailing-List: linux-erofs@lists.ozlabs.org
List-Id: <linux-erofs.lists.ozlabs.org>
List-Help: <mailto:linux-erofs+help@lists.ozlabs.org>
List-Owner: <mailto:linux-erofs+owner@lists.ozlabs.org>
List-Post: <mailto:linux-erofs@lists.ozlabs.org>
List-Subscribe: <mailto:linux-erofs+subscribe@lists.ozlabs.org>,
  <mailto:linux-erofs+subscribe-digest@lists.ozlabs.org>,
  <mailto:linux-erofs+subscribe-nomail@lists.ozlabs.org>
Precedence: list
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261116-work-loop-pseudo-v3-8-8cbbea1cf34f@kernel.org>
References: <20261116-work-loop-pseudo-v3-0-8cbbea1cf34f@kernel.org>
In-Reply-To: <20261116-work-loop-pseudo-v3-0-8cbbea1cf34f@kernel.org>
To: linux-fsdevel@vger.kernel.org
Cc: Jann Horn <jannh@google.com>, Chris Mason <mason@kernel.org>, 
 Josef Bacik <josef@toxicpanda.com>, Christoph Hellwig <hch@lst.de>, 
 linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-nvme@lists.infradead.org, Alexander Viro <viro@zeniv.linux.org.uk>, 
 Jan Kara <jack@suse.cz>, linux-scsi@vger.kernel.org, 
 target-devel@vger.kernel.org, driver-core@lists.linux.dev, 
 linux-mm@kvack.org, bpf@vger.kernel.org, 
 linux-security-module@vger.kernel.org, selinux@vger.kernel.org, 
 apparmor@lists.ubuntu.com, linux-nfs@vger.kernel.org, 
 netdev@vger.kernel.org, fuse-devel@lists.linux.dev, 
 linux-efi@vger.kernel.org, xen-devel@lists.xenproject.org, 
 ocfs2-devel@lists.linux.dev, linux-s390@vger.kernel.org, 
 linuxppc-dev@lists.ozlabs.org, linux-usb@vger.kernel.org, 
 Amir Goldstein <amir73il@gmail.com>, linux-erofs@lists.ozlabs.org, 
 linux-kselftest@vger.kernel.org, 
 "Christian Brauner (Amutable)" <brauner@kernel.org>, 
 Alexander Mikhalitsyn <alex@amutable.com>, 
 Chris Down <chris@chrisdown.name>
X-Mailer: b4 0.17-dev-ce4c1
X-Developer-Signature: v=1; a=openpgp-sha256; l=1349; i=brauner@kernel.org;
 h=from:subject:message-id; bh=eUpb/5VRc6uGUB6tbJ3+67OknD2n3CMn6o+Ub0d1Knw=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWT9epzhGiew20J0pdn/rc+br7ncYiy+qrz264M7t5VXX
 HtelL34bkcpC4MYF4OsmCKLQ7tJuNxynorNRpkaMHNYmUCGMHBxCsBESi0YGV5Vvm5S2zypdNU1
 0asTlm32TIpeYct0smnHH95QyWeSPuEM/x1bNttw/OG9Ib/orjXbnP81Nr9VO1SydlbPvJgivPC
 LNT8A
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Initialize mqueue as a pseudo filesystem instead of raising
SB_I_NOEXEC and SB_I_NODEV by hand. This adds SB_I_PSEUDO.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Alexander Mikhalitsyn <alex@amutable.com>
Reviewed-by: Chris Down <chris@chrisdown.name>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 ipc/mqueue.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/ipc/mqueue.c b/ipc/mqueue.c
index 322c3dd98c447..8bbe32d0881f2 100644
--- a/ipc/mqueue.c
+++ b/ipc/mqueue.c
@@ -18,6 +18,7 @@
 #include <linux/file.h>
 #include <linux/mount.h>
 #include <linux/fs_context.h>
+#include <linux/pseudo_fs.h>
 #include <linux/namei.h>
 #include <linux/sysctl.h>
 #include <linux/poll.h>
@@ -405,7 +406,6 @@ static int mqueue_fill_super(struct super_block *sb, struct fs_context *fc)
 	struct inode *inode;
 	struct ipc_namespace *ns = sb->s_fs_info;
 
-	sb->s_iflags |= SB_I_NOEXEC | SB_I_NODEV;
 	sb->s_blocksize = PAGE_SIZE;
 	sb->s_blocksize_bits = PAGE_SHIFT;
 	sb->s_magic = MQUEUE_MAGIC;
@@ -457,6 +457,7 @@ static int mqueue_init_fs_context(struct fs_context *fc)
 	put_user_ns(fc->user_ns);
 	fc->user_ns = get_user_ns(ctx->ipc_ns->user_ns);
 	fc->fs_private = ctx;
+	fc_init_pseudo(fc);
 	fc->ops = &mqueue_fs_context_ops;
 	return 0;
 }

-- 
2.53.0


