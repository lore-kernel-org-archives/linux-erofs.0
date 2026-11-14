Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AB1D60A6F5A
	for <linux-erofs@archiver.kernel.org>; Sat, 14 Nov 2026 13:07:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=DJFe+GHm
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4jRZBz2zwZz3c5X;
	Sun, 15 Nov 2026 00:06:35 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2600:3c0a:e001:78e:0:1991:8:25"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1794661595;
	cv=none; b=Pok8CFqKwAzuTY3Gtz2JZIVbB6rTWmC76nj4Rg5m5P9s8Nmf/gZwhBUGNAMn1NCu8Vyx+ciG44bjMp8hbS3aCviH7+uLQxoFVdMG4bMZqzABRN+fy94Mr8dytDGgaqF8KoNJXLWb2phQyRO6Pq44s1HaecJk/WT66pYm/FGzhoIott599XKoL4pNL5Lp4HPvqaSNOithPj8f4Z3umbEXsq1EEjMjf5thx0gEJRWQKxD1E9vyovMT9cMXn3qjjq0pUeJLGLRuK7fEINK7Xp4zSK4lhZwdh2kuqkFnmCfFoQ7L9q/Ts6iml9aRuLNG0aG9WZFxyWsk4tS/sFirMn+gfw==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1794661595; c=relaxed/relaxed;
	bh=vEUQcwW4egCFJ1K26houNDRkryaQ/QAvUlLdf7LIxfA=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=dPvcNqnS14V1JNX6pNnCgSLtWOuwsfGuEyJlTS9D0cwkK3GGExZGE8e0oyQPSq0UCdiLuKWrEbTY6TjK1ezEO/wjOrtPUpe1Kkguw8fXK1UlaOVfXjdbcC5t2+RMtfyWtD+LzIwJF2BAyry6N41+aeiaJrDflfXaxheY1jP5o7P2W3LTNjHlf4iGwWdO0GxzMmc5bqjyMNhvasPmOIuvKyn+54CPp3D7qVTht4Fx9uSZIzz4190o/aq6xZksaPEwM7wrVCwQl0AjdG1o0l7nC6r+r/hEvXw3cy8vhyRNa4DYc1VTzMFlmecUbUvtQeYWoQtahDeBGPTosS9yHicZQw==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=DJFe+GHm; dkim-atps=neutral; spf=pass (client-ip=2600:3c0a:e001:78e:0:1991:8:25; helo=sea.source.kernel.org; envelope-from=brauner@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=DJFe+GHm;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=2600:3c0a:e001:78e:0:1991:8:25; helo=sea.source.kernel.org; envelope-from=brauner@kernel.org; receiver=lists.ozlabs.org)
Received: from sea.source.kernel.org (sea.source.kernel.org [IPv6:2600:3c0a:e001:78e:0:1991:8:25])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4jRZBy43P1z3c4l;
	Sun, 15 Nov 2026 00:06:34 +1100 (AEDT)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 0EBD8406EB;
	Sat, 14 Nov 2026 13:06:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C2ED1F000C4;
	Sat, 14 Nov 2026 13:06:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794661592;
	bh=vEUQcwW4egCFJ1K26houNDRkryaQ/QAvUlLdf7LIxfA=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=DJFe+GHm923QnX6Y5soo7AJQ8SdH4x0drSIbnUS2OWssnfwJSQUV2IZe3ob/XB55y
	 HGpRKJon2FGC5GmKiKtWRgG+aMur8IjXtGeM7NDvCjs8HeoWosaYHGhW7xvQNJxHnj
	 V4RGXfeiw/5d9W+tWBHjJSDYHShB/CzKIkoMMvKbF/QdHP9BEN1PAP6X0fpbq+Dajm
	 CXmweTwa8ua3L0aVTYAucEIcFCy3WE3wxr/DXYLuLhhFs+aHqTQXXM/VppEQlnuEaL
	 lTMHA2EAW1JBgJmg/Y9PCfE+UFz0cUy0VBh0Br+5g/y+MUzPdQgQ7kbV5gr8gtumMk
	 0iV1JBfnD/jCA==
From: Christian Brauner <brauner@kernel.org>
Date: Sat, 14 Nov 2026 14:01:49 +0100
Subject: [PATCH RFC v2 08/42] mqueue: use fc_init_pseudo()
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
Message-Id: <20261114-work-loop-pseudo-v2-8-98639a2286fb@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1301; i=brauner@kernel.org;
 h=from:subject:message-id; bh=qF0TT28NFfI9TLhhCqBLUWCBoYJ0XY66UkmFCoZwvwQ=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWT9iMk78utTVQKnnZ/L9apqi1Ijq5VX3P9v+Dhp6pbtz
 hPnh+z92VHKwiDGxSArpsji0G4SLrecp2KzUaYGzBxWJpAhDFycAjCRpqWMDHO2fHNRqMw6vLBd
 svjftwLHIIbl/BEPDSTTuNUk47nebGL4K/l/b+Gahb+vMDEwHLnCfPthSuHM++uyg1evCA3JnNr
 lzgQA
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


