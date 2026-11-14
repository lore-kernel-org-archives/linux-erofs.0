Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBAEE606D29A
	for <linux-erofs@archiver.kernel.org>; Sat, 14 Nov 2026 13:10:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hprGHgCq
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4jRZFJ0gnyz3d32;
	Sun, 15 Nov 2026 00:08:36 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2600:3c0a:e001:78e:0:1991:8:25"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1794661716;
	cv=none; b=jCWMrq96R3G8UAImw9ilAFtSXv5K2UBsTJW6BJ2VNOY2p8xA6ipImN0hs2vHsM3MqCdKLakVOD39eonmygAH6NCOJDDMqzDgoZp55lQKizts9ETP9/96OX32bnL04ob8Fz3M1WAThTtxyohbKcIn3Xck1+an0Lq43C9E4oyDLaPrbc6JskjH34m9MmFct09+0B5h9r7dKC4c4EmBqWTyTmiWtlbJos6dM4MloztFtx6yMJcdTmTmUXaymWeyyGsqayEcPo1B8GfOyjhMMPCh6l+ryK8y7gGdLzNeiC+9YD/EE19DijduT6DjE0TVn50zaIiu907R3tzzuaSyl6QDkw==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1794661716; c=relaxed/relaxed;
	bh=Afo8ed/GIRxi34eV1UuvuxN8L56duYS4vlWsPBP1fM0=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=g4ioidWpuktark9WcJ/4yyB2FNMHwQcJP0Mcu4o/BGY/igHeDITTPnXP4aAEo+Ko6vDx3j1bHDMQ3XjP1zlAQxWnRuVTZWZQkCugtVbyR8qV1A5P9arZMcGvd6Ao6Xc+mJB3dtZSHg6sB/4yt1hYS3nC4wUNm2pfmK6pT5hoKkBuzWMyO/IM1o5A8SF6NTcWJTwXogzJ2U817XJNCcGiKN7jIW/C0vd9+u59nG4z5nO5DVClCDLOxuVpbz1cOZYM+2FnqEKRQEnYOpFEY7T7PI31tyB6MYT+o+53jb3HP4GAKoFylG18oQwy4NWlNUM+bACZm3gnefYNElknwCtDkg==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hprGHgCq; dkim-atps=neutral; spf=pass (client-ip=2600:3c0a:e001:78e:0:1991:8:25; helo=sea.source.kernel.org; envelope-from=brauner@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hprGHgCq;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=2600:3c0a:e001:78e:0:1991:8:25; helo=sea.source.kernel.org; envelope-from=brauner@kernel.org; receiver=lists.ozlabs.org)
Received: from sea.source.kernel.org (sea.source.kernel.org [IPv6:2600:3c0a:e001:78e:0:1991:8:25])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4jRZFH1R7Nz3dJD;
	Sun, 15 Nov 2026 00:08:35 +1100 (AEDT)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 4890441144;
	Sat, 14 Nov 2026 13:08:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80A411F000C5;
	Sat, 14 Nov 2026 13:08:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794661713;
	bh=Afo8ed/GIRxi34eV1UuvuxN8L56duYS4vlWsPBP1fM0=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=hprGHgCqljNfHaaRT8wbU+b4CvrLYNHbt2kQUNxd98TIwvCS2ehJO8vBQg6IjA/4E
	 QlB02LLCNgV15vU1lPLmWWEwlLoHBLk24m/bQPCp+Xt2+5fcmhBnJkLr6kL6tImYJl
	 SZ5FGLvBWuN4qnzeJZ1uLhmeUGELgSZ8JHePmJcS8Z1HLYwEkmf3Gob9WB7bFvIcdE
	 //xR/RRXp75B0I1ifA+qvkckh7ZeIvssKgKnFVvHN/TV1+Tdlu+VrMbzl2SBXWGzb4
	 0iiVdJi6+Q0l8uSEtN9rtD9y6ItKjTJePfdM28scvMR66rgWPwX2mkMg+R7tSuzj9r
	 yx06t2VwHiXRQ==
From: Christian Brauner <brauner@kernel.org>
Date: Sat, 14 Nov 2026 14:02:06 +0100
Subject: [PATCH RFC v2 25/42] pstore: use fc_init_pseudo()
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
Message-Id: <20261114-work-loop-pseudo-v2-25-98639a2286fb@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=940; i=brauner@kernel.org;
 h=from:subject:message-id; bh=ohaN/4o3T0nG31Sa4LtDWeOCgaFP7NFffTjYcKqsHS8=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWT9iGl65sDr4L+lP+1LwMR9DJK+pUFszdFFZl9j357yX
 dgmd+5/RykLgxgXg6yYIotDu0m43HKeis1GmRowc1iZQIYwcHEKwETYjjH8Mym/V8LV8ePeaeFT
 x7u9pzw6+Fw+X1xVcs/rnm9zFByPHmP477vQ0tL7dpTko/erzdrX7rRZPvXiz6+/Z64TjvOpv/5
 wLRcA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Initialize pstore as a pseudo filesystem. This raises SB_I_PSEUDO and
also SB_I_NOEXEC and SB_I_NODEV. pstore never holds executables or
device nodes.

Reviewed-by: Alexander Mikhalitsyn <alex@amutable.com>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/pstore/inode.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/pstore/inode.c b/fs/pstore/inode.c
index cf499ba727026..4658561cf90b7 100644
--- a/fs/pstore/inode.c
+++ b/fs/pstore/inode.c
@@ -18,6 +18,7 @@
 #include <linux/ramfs.h>
 #include <linux/fs_parser.h>
 #include <linux/fs_context.h>
+#include <linux/pseudo_fs.h>
 #include <linux/sched.h>
 #include <linux/magic.h>
 #include <linux/pstore.h>
@@ -491,6 +492,7 @@ static int pstore_init_fs_context(struct fs_context *fc)
 	ctx->kmsg_bytes = kmsg_bytes;
 
 	fc->fs_private = ctx;
+	fc_init_pseudo(fc);
 	fc->ops = &pstore_context_ops;
 
 	return 0;

-- 
2.53.0


