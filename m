Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D56C606C100
	for <linux-erofs@archiver.kernel.org>; Mon, 16 Nov 2026 11:08:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=SYR9TaGr
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4jSlSw4ynsz3c2L;
	Mon, 16 Nov 2026 22:07:44 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2600:3c0a:e001:78e:0:1991:8:25"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1794827264;
	cv=none; b=cQRj2XSv+CV3BwBF0ZA4hdiDXLqpdVkISps4e4Xl5jtb4K2LmrllfWqHBT/Oq2paPFLyfx4wMfBMbln05Veo+FAU2HB41vzDtsfQsSQExlScr6B8yytw/roktezyUywiK1oiL9Y0BaDtvYEg90Hzh0Cn/wQoM2ob7nE4yZTm4av8flSLtz7xRT/aH+3h2zM6GlzbaTiwuN59+M0LVaFkCLdJ787BrQIrNIJ7vj2iT0XHqn+RbbemANJ5JuD/uR84raTKhmYrNAKAIJQsBjwSlylu8Zf3QRPY2QuibE0i37XykvqPhZisqG0BXlSeR/XP3WPxuMiu4jtXSp5br+vNRA==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1794827264; c=relaxed/relaxed;
	bh=bRo8rafT0SI0ZYIjwSP5s8nuDkHhspwSH2/U5D4Vwdo=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=UGC7QsdoNglUVxzTAm4Ty0sVbeVlTxVuhPFd8OpC9tnJSykmu33GW4H/OmWlBqCXty+aaqvP3dnC2vlpMTPsehUd6PW2k5N1YLQbV9hfpIt0EPHx3E9bXnsXHmDQWBi8a07pevnWD4TddiH5djE8QRNH8f+VSKuMKzlMkN0GTdcV96sCVti8um7NHcuIipNI55UeFGPjQrl6xQopYgYS9gHZ461C8vZxQD85WpknpEF/9MKJCIoTf6EBTQmrdzXZ4CHalXV3g6Ts0b3mfdN9/JBRwuB6qeziFQcimd0H37NWaoWrQj+83mwuJGPyQA5kCPkjTydEfpW35IdDD/SNkA==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=SYR9TaGr; dkim-atps=neutral; spf=pass (client-ip=2600:3c0a:e001:78e:0:1991:8:25; helo=sea.source.kernel.org; envelope-from=brauner@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=SYR9TaGr;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=2600:3c0a:e001:78e:0:1991:8:25; helo=sea.source.kernel.org; envelope-from=brauner@kernel.org; receiver=lists.ozlabs.org)
Received: from sea.source.kernel.org (sea.source.kernel.org [IPv6:2600:3c0a:e001:78e:0:1991:8:25])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4jSlSw0fVWz3bTf;
	Mon, 16 Nov 2026 22:07:44 +1100 (AEDT)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8E70F41B40;
	Mon, 16 Nov 2026 11:07:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22E231F000C8;
	Mon, 16 Nov 2026 11:07:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794827262;
	bh=bRo8rafT0SI0ZYIjwSP5s8nuDkHhspwSH2/U5D4Vwdo=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=SYR9TaGrdGbZIarQmb7FZiAh3aYqeET1aKxpQildzBF54+XkCs3w2hwe012i9YDNn
	 KwplWWfrUqSG6YeiB4M+R0HFxuvky3aQ6H/xSTFl3YsGJUXt6YKVqEho4Ze+G1tUXj
	 1LBnFF1Tjb5B8Wq8WvTQUAgcpvPTABUb9ZbFJurPQxuPY16ScwtILZqX1vzDRAK0zF
	 WYGfVFRgoNgVMFqCXJGrivTUJE7Uqv9I3Kjf3hFqKNQ0l1/yg7xjQvZGT4y6D6g3Hu
	 GlJP4jytTeb5jsL1OPfVY2sB4N+I4DKQZdsAQ/ckyHlMUVC8NaHv6jRpgn76WWmzBp
	 MIF24A6RZBJQg==
From: Christian Brauner <brauner@kernel.org>
Date: Mon, 16 Nov 2026 12:04:46 +0100
Subject: [PATCH RFC v3 13/44] devpts: use fc_init_pseudo()
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
Message-Id: <20261116-work-loop-pseudo-v3-13-8cbbea1cf34f@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1022; i=brauner@kernel.org;
 h=from:subject:message-id; bh=bmgpF+T0PjaM4BszluBOeRyncWOMZk/p8QFUkfXrwyU=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWT9epwbMLfmqPHCfTn5hRfrWbZIf8s8rLk06bC0camwg
 mzGq1XBHaUsDGJcDLJiiiwO7Sbhcst5KjYbZWrAzGFlAhnCwMUpABOpFWRkOPz/xJLoOzVBuYb7
 +QSlfCOaZ5lzMH+rzjNdtcfly5aJtxj+552pNBCM1J7apuA9/7a7a/D7lgk6wf0+3lyc19/OLmz
 iAAA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Initialize devpts as a pseudo filesystem. This raises SB_I_PSEUDO and
SB_I_NOEXEC. devpts never holds executables. devpts_fill_super() keeps
clearing SB_I_NODEV for the pty device nodes.

Reviewed-by: Alexander Mikhalitsyn <alex@amutable.com>
Reviewed-by: Chris Down <chris@chrisdown.name>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/devpts/inode.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/devpts/inode.c b/fs/devpts/inode.c
index bd1e8eb26edb7..47ef12241d92d 100644
--- a/fs/devpts/inode.c
+++ b/fs/devpts/inode.c
@@ -13,6 +13,7 @@
 #include <linux/init.h>
 #include <linux/fs.h>
 #include <linux/fs_context.h>
+#include <linux/pseudo_fs.h>
 #include <linux/fs_parser.h>
 #include <linux/sched.h>
 #include <linux/namei.h>
@@ -438,6 +439,7 @@ static int devpts_init_fs_context(struct fs_context *fc)
 		fsi->mount_opts.reserve = true;
 
 	fc->s_fs_info = fsi;
+	fc_init_pseudo(fc);
 	fc->ops = &devpts_context_ops;
 	return 0;
 }

-- 
2.53.0


