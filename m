Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B79A6071E4D
	for <linux-erofs@archiver.kernel.org>; Tue, 10 Nov 2026 09:18:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HZwAEC7y
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4jP1JL5kNCz3bnq;
	Tue, 10 Nov 2026 20:17:22 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2600:3c04:e001:324:0:1991:8:25"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1794302242;
	cv=none; b=hbsoGRyFqt6Ql7m5U8cj5ORKin8vOgohwK7PZI2ioaTS2tcibeXcvwsSOMLCmcgnFFvTkN5emql2eWxS4G5d4hmbMiV1HdNhr4f2wV0gajjweX5wQ3jk0f4aOSdrOdL9S8/hOiPv/WTlZZk9WqWUEQIkGG03Q/kl4I8S6496kjNIAG7WbhlsPo5yuZ15boUQtA7nmY8dM6MBrS13m5k7wyFbthXdb71yiLXGnmVJa3Mr0N9dQDso8k5002kLIW4doVooSlXxgNI21oRqWnjPmhFiVr3IFANI686mbNO8VTCe58p7vlK5deot+Q4n69JO0w0Oom/vJCKTO2DV+hJU8Q==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1794302242; c=relaxed/relaxed;
	bh=BDssZE8GnxXJphkJa/7u6Kmpiz0qYyZXv4DcRb36RZU=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=EmrA5DVQHlkZf0nZQhvnUNga/dvGOB2rhWwlIlS1pPGYJx3poepAW+GnX9H1VIeC80p8qmtaH3FLXvVMNotKa59z2bNXfaw1Mv+tcYOhNBH+w289/CYBo7emj13GqHEF33wzKzj5lDnpCrGkxE5s3wQMfnICBvOY1Y616Ajb0hmw5hGx/5uX8Tm2A8Agqukx7PJL2hygwbnriRQtYyCIgvzkRt1r7RL/ghAEqIRwErFKyISyclo87EDmX1ifmbW0HKMjqGxNg9Ygl14lPmYkLCPm7Bg66gvBdICATXI0Ip1vyYv5t8ZU8kaYLvrBu89uzDzMAdGOIoIYfzBSd6kmxg==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HZwAEC7y; dkim-atps=neutral; spf=pass (client-ip=2600:3c04:e001:324:0:1991:8:25; helo=tor.source.kernel.org; envelope-from=brauner@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HZwAEC7y;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=2600:3c04:e001:324:0:1991:8:25; helo=tor.source.kernel.org; envelope-from=brauner@kernel.org; receiver=lists.ozlabs.org)
Received: from tor.source.kernel.org (tor.source.kernel.org [IPv6:2600:3c04:e001:324:0:1991:8:25])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4jP1JK6tD6z308H;
	Tue, 10 Nov 2026 20:17:21 +1100 (AEDT)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 1C62E63810;
	Tue, 10 Nov 2026 09:17:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F81D1F008A1;
	Tue, 10 Nov 2026 09:17:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794302239;
	bh=BDssZE8GnxXJphkJa/7u6Kmpiz0qYyZXv4DcRb36RZU=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=HZwAEC7yTB7xRGKnMoMrQZ9sxFhShy/lcUuZ/x28dAQF2zKH4dms8JkefpvImrQ6x
	 XC17RCkuC5DS1kjza0TXcL7CFDfklhb43tkgjYep+m/Ktv9OM8WFbgu+n53zFr0v99
	 oA4dvldcm7IP98DtTd9OniKq7I49xL8jcVtYPn+hdsEuh9403uECXy9gbC3SQ3i3KX
	 69hVJ4ZtgMy9pBNrX3/NQCtI3QLLlYI9QKbR1ljiyee3SOwCPkfnPUCR39DKczXa41
	 B7rewxNEm+xa8FVjYKfML4jkp/JG7IHWJl4xIRYdJ5VcaUC/EIXdXrICC3YYuo9a0Q
	 vQiRwTkVcDJ/A==
From: Christian Brauner <brauner@kernel.org>
Date: Tue, 10 Nov 2026 10:14:28 +0100
Subject: [PATCH RFC 12/41] rust_binderfs: use fc_init_pseudo()
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
Message-Id: <20261110-work-loop-pseudo-v1-12-4c998976c6c7@kernel.org>
References: <20261110-work-loop-pseudo-v1-0-4c998976c6c7@kernel.org>
In-Reply-To: <20261110-work-loop-pseudo-v1-0-4c998976c6c7@kernel.org>
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
 "Christian Brauner (Amutable)" <brauner@kernel.org>
X-Mailer: b4 0.17-dev-ce4c1
X-Developer-Signature: v=1; a=openpgp-sha256; l=1349; i=brauner@kernel.org;
 h=from:subject:message-id; bh=ia59pqse5bfG3zsSypUZSF6rnakCYrHaj4vJVOgAczE=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWR9erBwbu+MRZLWcXVeu3+t3xy2+WPblfNtxmUPzkxuZ
 kvRVVts01HKwiDGxSArpsji0G4SLrecp2KzUaYGzBxWJpAhDFycAjARzmhGhtUeaQcz2VY03m2x
 8X+zz3bz86e+3F0Sc0+/XnSvs/WJ/nKGfybCIVeWvGvzeXz9a3rPAre2kNeaOolzS/+H7js9+Wh
 DJgsA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Initialize binderfs as a pseudo filesystem instead of raising SB_I_NOEXEC
by hand. This adds SB_I_PSEUDO. binderfs_fill_super() keeps clearing
SB_I_NODEV for the binder device nodes.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 drivers/android/binder/rust_binderfs.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/android/binder/rust_binderfs.c b/drivers/android/binder/rust_binderfs.c
index 5f020226720d..04468c5b5c11 100644
--- a/drivers/android/binder/rust_binderfs.c
+++ b/drivers/android/binder/rust_binderfs.c
@@ -3,6 +3,7 @@
 #include <linux/compiler_types.h>
 #include <linux/errno.h>
 #include <linux/fs.h>
+#include <linux/pseudo_fs.h>
 #include <linux/fsnotify.h>
 #include <linux/gfp.h>
 #include <linux/idr.h>
@@ -667,7 +668,6 @@ static int binderfs_fill_super(struct super_block *sb, struct fs_context *fc)
 	 * necessary and safe.
 	 */
 	sb->s_iflags &= ~SB_I_NODEV;
-	sb->s_iflags |= SB_I_NOEXEC;
 	sb->s_magic = RUST_BINDERFS_SUPER_MAGIC;
 	sb->s_op = &binderfs_super_ops;
 	sb->s_time_gran = 1;
@@ -759,6 +759,7 @@ static int binderfs_init_fs_context(struct fs_context *fc)
 	ctx->stats_mode = binderfs_stats_mode_unset;
 
 	fc->fs_private = ctx;
+	fc_init_pseudo(fc);
 	fc->ops = &binderfs_fs_context_ops;
 
 	return 0;

-- 
2.53.0


