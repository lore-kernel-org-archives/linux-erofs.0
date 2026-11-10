Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3290060A5BC4
	for <linux-erofs@archiver.kernel.org>; Tue, 10 Nov 2026 09:17:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=nXwsv5rT
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4jP1Hq1jmRz3bj7;
	Tue, 10 Nov 2026 20:16:55 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2600:3c04:e001:324:0:1991:8:25"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1794302215;
	cv=none; b=mwhzYidbiM0cwKyCfsyWPugp+4EGR228CELjhWf/HQMMJtaYt1Fl/PiN09LW1YxeenWVCODGd0qCIpZhGdq6DFxz9Gb13DmZH4dRSM3LXZv/9jJ+i3j06VVq69xChScHeYWlW+DAclWO1MGLPxR7FmVkk9mol8izxIxQ+htHLk9BQpN7FyeV184NlOTjvMCq0TO5qXQlFjWvyv6m+ISjS0hev95fYrEPsBmRhej0meRRzZz9UwhNh4f/wzDOudKqbbbCVKuuKqyoLGZVl6acnyjjl8hvTE24a3DsLXnjv8H+a5A92qhcVWIZUGw7VQ3WMLmRoQgK6Cz1VHsGr1Kgzg==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1794302215; c=relaxed/relaxed;
	bh=rTt9ZODnqMGXt2QPWO0j4LWRDHe8dvGNICyHTYt985E=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=QRGKkkbLDLLinGhUat4GdzSrfV61y87CwBYDVU/9unP9vjTo3XFy1pPJukuIP5YqBVKDArzHcE5O8Xc8UaqZUgQw+1LKNLK7nTQkxKcI5Z8/QS7YFLvccEqYTwbMizVMBU/a8CccH4gcS7h/J24r7l+qmybl9RIBagwmJTfRVnM4NmVf9GADNUlQmUDizR9h6gSpBTW6FpEKnoD1v4mRRFDsaBvvdF6tFYh8xdsJtTnds1uQUerndUCdERxZ2K+hI2//GvL/OmSMwujzejsg8IMc5o0ncQ97NKBkKfjnvEA+y/rzqgdWgqC0QZ2GUT3fDNn3/jjNvWmVsZ+MW4P9IQ==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=nXwsv5rT; dkim-atps=neutral; spf=pass (client-ip=2600:3c04:e001:324:0:1991:8:25; helo=tor.source.kernel.org; envelope-from=brauner@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=nXwsv5rT;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=2600:3c04:e001:324:0:1991:8:25; helo=tor.source.kernel.org; envelope-from=brauner@kernel.org; receiver=lists.ozlabs.org)
Received: from tor.source.kernel.org (tor.source.kernel.org [IPv6:2600:3c04:e001:324:0:1991:8:25])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4jP1Hp4WJ9z3bgK;
	Tue, 10 Nov 2026 20:16:54 +1100 (AEDT)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 78A176021E;
	Tue, 10 Nov 2026 09:16:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C49B51F0089F;
	Tue, 10 Nov 2026 09:16:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794302212;
	bh=rTt9ZODnqMGXt2QPWO0j4LWRDHe8dvGNICyHTYt985E=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=nXwsv5rTzvrG122CXPiddOJ0ugXqcsoi/AaGfNNbu7zvGK8mvUz48SAGlBU/zLVkz
	 LooUWqRoN/4S8I3xcJYcAEFNAJv7CmbUQiM+ChF5ZHpfxf63bNo7Z0QdCAiOO59dr1
	 8fhU2KVqLBCjOH3X9bxaSSk/C75cMEo2HD2kESGJ6Y10yT4ZTrwrUuApzZmSmAZkyq
	 7KypYuKqM5Pjoxx7X2T/0YDQPSzhDhTa8yf55w0TWoYWrEVFZ6el7TpOiZWeC8kVq8
	 oCDfcYgrQZNoq58895X8dxus9Cy79YWYO/viOCOJpKnTNCeln3Zt2fAQjdrWaXV2Jd
	 BAdVF5Rtw3JRQ==
From: Christian Brauner <brauner@kernel.org>
Date: Tue, 10 Nov 2026 10:14:24 +0100
Subject: [PATCH RFC 08/41] mqueue: use fc_init_pseudo()
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
Message-Id: <20261110-work-loop-pseudo-v1-8-4c998976c6c7@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1198; i=brauner@kernel.org;
 h=from:subject:message-id; bh=McdhKaZYT4i07Xats25HT8jpBIeYReCKfIiqQkLDh7c=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWR9ejDXp05OOqNfiGfutU+mD244ZPwWu6w2Ner6mY67a
 1N9rz580VHKwiDGxSArpsji0G4SLrecp2KzUaYGzBxWJpAhDFycAjCRz8EM/8zfXf24LmZt6Maf
 748F7bqwrvMdv95q947nnlLsuYdn/j3N8JvF0yvka11ts23/pvzN+To/re7tc+Vlrptwd4bj6ob
 /3vwA
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

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 ipc/mqueue.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/ipc/mqueue.c b/ipc/mqueue.c
index 322c3dd98c44..8bbe32d0881f 100644
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


