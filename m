Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40A0E606B15C
	for <linux-erofs@archiver.kernel.org>; Tue, 10 Nov 2026 09:18:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hCKnpX2L
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4jP1Jk6JZXz3btg;
	Tue, 10 Nov 2026 20:17:42 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=172.105.4.254
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1794302262;
	cv=none; b=d3dZC3osrB1IlxTg9Mko2Qn2lD/S7Xb/sQ2SgVjLFvGsQQ+2UXxWT1D55IJwCq67TwMq4EeTvv/Xvlv5hBLxuNqkEUkEyR+waYys2alaXN3hLhEq6jBYmCHzXF0CEoQl4sTRRBeiaMrPCjjvo3Em6vAao/d12B0kUcu4tQvpzLgZe05LDXok8/gD7jS8ELCcPnh8z4p08HMXAclyM+yxon9BtqNUry7jXqg9SyNbE83hLmZJCWbzO90NNn6Y/6I68CoJBUiu/MjhegRaiK6s7supXsLhbLwCfcK47d3Ayy5MsqEoc6fzEQCUmaNJdEBhdS7JdHrQJBkC7RxLPLPPvQ==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1794302262; c=relaxed/relaxed;
	bh=h94mIi/imn4D3waXvt8ZAO8zbcvNeSGH9zaPuRN/zFo=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=PAqTMGFo5FFVf2kQGibDjblLfGxAnYsTpfrbcU8TO/6SrOGUjFiOPMsofRvQ5y+ol4TTnaOrv2/dpu6BWKeB2OnA00VPkDS4+TJ7lt+SPf532XVgIkFnxsR3odnqGT91onTLLercufbjiaLrmchvvZHd02zfEWfcvku00On3ZBmWfjOyM4GKXfGHo5oOHP6AVuY4Qiudn6zdZGAOxeleo0Vl07ZeflB5NRulIoZP7AMcS2SBw0zC9USiLIBSytSCIgFt+z2uDAwBTYkmgLbOyoGlG/cDaMJ+iHMZG65EMsfO+qkcp6Pbt8y61M6P9KQqj6bzJ3+1p/AUcU7cQQJvNA==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hCKnpX2L; dkim-atps=neutral; spf=pass (client-ip=172.105.4.254; helo=tor.source.kernel.org; envelope-from=brauner@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hCKnpX2L;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=172.105.4.254; helo=tor.source.kernel.org; envelope-from=brauner@kernel.org; receiver=lists.ozlabs.org)
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4jP1Jk1YdZz3bqh;
	Tue, 10 Nov 2026 20:17:42 +1100 (AEDT)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 575206351D;
	Tue, 10 Nov 2026 09:17:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACD6F1F0089F;
	Tue, 10 Nov 2026 09:17:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794302260;
	bh=h94mIi/imn4D3waXvt8ZAO8zbcvNeSGH9zaPuRN/zFo=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=hCKnpX2LMq/yIBVu+3fedTSWRzmEiUKg05k70/cabSsZyN0V70DQNw0habLh5Rp3N
	 c956FUO8f5KMtGhmwZF6JaNrD5YNWgtZGhi2tRzcc2lZ8L4JIxwL79H0b3tBFB4IaO
	 XmqyiHmmqPdau5vX2eMWUrlPCMnRhkbqwrhqOEqbuhQuSJxQhgZLHlWLkOa387kF87
	 c2QE631FmWh521q0EDzd1BLKeXN0jM2x4hEbJfjU0RuxAt/DbvL2B4RJaNxjRNgwuN
	 sRHkcU5kSCaIM/R/aSWv3TJjb6hXOJ6l+gef1isFdWoX5RRm93+0TI6pGc9yKYqXGJ
	 EIZJjyG5YAQyg==
From: Christian Brauner <brauner@kernel.org>
Date: Tue, 10 Nov 2026 10:14:31 +0100
Subject: [PATCH RFC 15/41] tracefs: use fc_init_pseudo()
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
Message-Id: <20261110-work-loop-pseudo-v1-15-4c998976c6c7@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1051; i=brauner@kernel.org;
 h=from:subject:message-id; bh=nNHku2orMRQhrPcnxhaESkf9+5yEVey8qH80JYuUurA=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWR9erD0RXLTJKNzrh5L9mkY/O9J+HRKY33C443/9A4Lr
 21xrLd+1VHKwiDGxSArpsji0G4SLrecp2KzUaYGzBxWJpAhDFycAjAR+R0M/72Fl4jGuvHt3/5x
 u7NfzPNpdcsMM67cPHfs9ommtv7O3i+MDBdi/75YKJwQsP/1zN8L3y7I88yZX64y724L9xZhYx+
 hQ6wA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Initialize tracefs as a pseudo filesystem. This raises SB_I_PSEUDO and
also SB_I_NOEXEC and SB_I_NODEV. tracefs never holds executables or
device nodes.

SB_I_NOEXEC also refuses PROT_EXEC mappings. The only tracefs files
that can be mapped are the ring buffers and __rb_map_vma() refuses
VM_EXEC already.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/tracefs/inode.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/tracefs/inode.c b/fs/tracefs/inode.c
index 5020365ca704..e04febd868eb 100644
--- a/fs/tracefs/inode.c
+++ b/fs/tracefs/inode.c
@@ -12,6 +12,7 @@
 #include <linux/module.h>
 #include <linux/fs.h>
 #include <linux/fs_context.h>
+#include <linux/pseudo_fs.h>
 #include <linux/fs_parser.h>
 #include <linux/kobject.h>
 #include <linux/namei.h>
@@ -510,6 +511,7 @@ static int tracefs_init_fs_context(struct fs_context *fc)
 	fsi->mode = TRACEFS_DEFAULT_MODE;
 
 	fc->s_fs_info = fsi;
+	fc_init_pseudo(fc);
 	fc->ops = &tracefs_context_ops;
 	return 0;
 }

-- 
2.53.0


