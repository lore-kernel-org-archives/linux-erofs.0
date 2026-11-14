Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E210606D28E
	for <linux-erofs@archiver.kernel.org>; Sat, 14 Nov 2026 13:07:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=KyNtY6FC
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4jRZC61QbVz3c7N;
	Sun, 15 Nov 2026 00:06:42 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=172.234.252.31
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1794661602;
	cv=none; b=GcCxijB9vJ6XrBLmEJ14e6srHPetu79spV+X2NunOF07nUj9F1zElYbD6izzfZJcAdw+A5YduM3ro4NZr9x7BTeebBM90DFD/dme25jzQH+fJ7qfmep0ZCYnNOSbbXL2qTHE8rT513VPGgAfpGKvPTNbxLyc5S3mdl5iLV1sWwznqizuqNFQr28sxbGeqRcGNGVhLrhCz2iAuksSfgQsBgFV1ltVQL4Xd6iHKJAqYdJq1XuZju5Zi1hId9upaNPFnHTKjWSnnIwuRXGLMG63/rdEsaCyZ/34bXLDK0l9xDl8TSTLN5sXW5MK6kF9YsCcQveuof/FcB7g5kQAtEnghg==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1794661602; c=relaxed/relaxed;
	bh=Acb/Xrf5UEvLQ3qZblXZEvLF8dI3PWAoA3H4K2Drtr8=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=WH8nH2EH5WDtcf4BPqMScBPu4B3bvMq7g+HD9CHAmpjoSBAPMHyoC6lYeb3c7kUjEhpXUVjmtyK/jMl2DFjnfkeLM4oHmH3GlGW4CgpVsmWoF97oE3GNuODDAjGJ9JdtRSXiBiOwElNu2fcJzIiMpChwmiHc9a1kwZe0J1n0LEFYMh5hAIFWo5+CyDH+WEvTkNqv8RMlO3oXPTHki8ZFatmBBIX3aO/7N1rwoco/PAzHgr0szJ1bM3QUupPGpTPW+xqgXjeUcIxCImVWMzHqCYRhKD0wlbeVpQ5bXEMQ4g3DqMmkX7PTGP68Mvw/u8fo7tCo0gozkJLbQ8r52M4kIQ==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=KyNtY6FC; dkim-atps=neutral; spf=pass (client-ip=172.234.252.31; helo=sea.source.kernel.org; envelope-from=brauner@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=KyNtY6FC;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=172.234.252.31; helo=sea.source.kernel.org; envelope-from=brauner@kernel.org; receiver=lists.ozlabs.org)
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4jRZC53352z3c7M;
	Sun, 15 Nov 2026 00:06:41 +1100 (AEDT)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id E5845464B4;
	Sat, 14 Nov 2026 13:06:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 646751F000C5;
	Sat, 14 Nov 2026 13:06:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794661599;
	bh=Acb/Xrf5UEvLQ3qZblXZEvLF8dI3PWAoA3H4K2Drtr8=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=KyNtY6FCF87BGL6Kw/0+nFiSNhII6bCQoi1XcgNkkdx5QnSLvOmFeUx+1Gzw6qx6W
	 8qfU1kxc4TxMYaN7FiDkUr2M3uz6BLbF+u3v/FDkuwPjs/jbG+c9zGvRkTjFJmEjiL
	 8JS1ZHT8JFf+5Nw1nJtiYKkLg72hoVlMsqVfMy3CtWoGP4sQd8ckfZhFir2N8shzIj
	 rbapZY7d9iip7viefelICnAUIpwFJjRrBSAisiXulqRLGKF7pcgO96Dpzy48VQDU+9
	 fXRynAzshbd784aJhyQ+BI+MHkoqrwcw09i4frlx5HrLz+z7BB29FpUtgvajAYU8kx
	 5ZLHrcpkiH2sQ==
From: Christian Brauner <brauner@kernel.org>
Date: Sat, 14 Nov 2026 14:01:50 +0100
Subject: [PATCH RFC v2 09/42] bpf: use fc_init_pseudo() for bpffs
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
Message-Id: <20261114-work-loop-pseudo-v2-9-98639a2286fb@kernel.org>
References: <20261114-work-loop-pseudo-v2-0-98639a2286fb@kernel.org>
In-Reply-To: <20261114-work-loop-pseudo-v2-0-98639a2286fb@kernel.org>
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
 Alexander Mikhalitsyn <alex@amutable.com>
X-Mailer: b4 0.17-dev-ce4c1
X-Developer-Signature: v=1; a=openpgp-sha256; l=1306; i=brauner@kernel.org;
 h=from:subject:message-id; bh=RMw1xl23FNzYnwkWPo3aqKCop8QxJMPcn/mgOSyUY0w=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWT9iMnP/Sqt8ZKlWW/DquWr7Q+27feurNp59XxZz58a9
 18b4yU7OkpZGMS4GGTFFFkc2k3C5ZbzVGw2ytSAmcPKBDKEgYtTACZyeTYjw/USkxUJXYnv5D+F
 7fy6Msz9i+c5yYvtTRpVx5rmBdWU3mP4n7mJ5axYzdeTT2Z2JT67oLhnXfTECV2TncN/ctca7o3
 3YAQA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Initialize bpffs as a pseudo filesystem instead of raising
SB_I_NOEXEC and SB_I_NODEV by hand. This adds SB_I_PSEUDO.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Alexander Mikhalitsyn <alex@amutable.com>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 kernel/bpf/inode.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/bpf/inode.c b/kernel/bpf/inode.c
index c6f328e4752e1..57cf3775c0766 100644
--- a/kernel/bpf/inode.c
+++ b/kernel/bpf/inode.c
@@ -15,6 +15,7 @@
 #include <linux/namei.h>
 #include <linux/fs.h>
 #include <linux/fs_context.h>
+#include <linux/pseudo_fs.h>
 #include <linux/fs_parser.h>
 #include <linux/kdev_t.h>
 #include <linux/filter.h>
@@ -1197,8 +1198,6 @@ static int bpf_fill_super(struct super_block *sb, struct fs_context *fc)
 	sb->s_magic = BPF_FS_MAGIC;
 	sb->s_op = &bpf_super_ops;
 	sb->s_xattr = bpf_fs_xattr_handlers;
-	sb->s_iflags |= SB_I_NOEXEC;
-	sb->s_iflags |= SB_I_NODEV;
 	sb->s_time_gran = 1;
 
 	inode = bpf_get_inode(sb, NULL, S_IFDIR | 0777);
@@ -1261,6 +1260,7 @@ static int bpf_init_fs_context(struct fs_context *fc)
 	opts->delegate_attachs = 0;
 
 	fc->s_fs_info = opts;
+	fc_init_pseudo(fc);
 	fc->ops = &bpf_context_ops;
 	return 0;
 }

-- 
2.53.0


