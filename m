Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FC08606A33E
	for <linux-erofs@archiver.kernel.org>; Sat, 14 Nov 2026 13:11:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OPYvZMcK
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4jRZFz0KXGz3dVf;
	Sun, 15 Nov 2026 00:09:11 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2600:3c04:e001:324:0:1991:8:25"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1794661750;
	cv=none; b=SlJnp/z0uPDoER+4rSiGI728Zq9K6ZOhBV9NsAOW7l26mpdhW6Bx25PuaLruyVnUyCmD2D5cR3G9FljMX7qQIki1rFEYkesVg0uDtd2ai4rnOBk/4BvVHEjJ+uhs9u+oAOqUCyLzLt6QCiIrs5hNzlBERvH0/ABS3kpl2KfC1rUEA7sbr0OwwT4rdKd0xBQ5+yCLzRq+Kn4lP+CYZtNI8MYNxTvNTvY43nwXGVjgrwUQhSi1vQaDGP7GNYNkP9jo9mDL53obdnMQvcRy54SOx4zjEx9i9+RvCAwNtoGJyivGY6rAm6DkTFsi2nImeq0fQNWQsQncXnTn2YptuwwF2w==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1794661750; c=relaxed/relaxed;
	bh=id4PRLDY8xxqmv09Cy60S/mO+ESr2mIJ65uM2WRQC7s=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=j4vRAFnw7vO21jCh+9SsKS5KQ3Nz4ldWm1usuxgzh9Svv1VaL1BcpN6HMhUDA8blZD6hG0DjQD8xAAaJZ4Hj8V4GJnAReLBVn7J6VWuAo8lhRKEJsPMFEwE8cX5sT0HFWUkqfa9sEPyFxrMDnDm28I6vTxgl9d3L/wVYgmqDRuCAPyNcjgDVOhKAvio7ZNX8BqXByymTNtjE/b9g6zwwhg0K0tHaCaHb6TCvvawl0jEd9+5b1OGaAZ0WX00/SiMCmXSqXuy3IzFxQlgxH0Ak4083nFm88EWqed9J780u1oMJIDL8eMZWtIXXxmGChdU4Dsok3FyQJqAFjDFNdzASpQ==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OPYvZMcK; dkim-atps=neutral; spf=pass (client-ip=2600:3c04:e001:324:0:1991:8:25; helo=tor.source.kernel.org; envelope-from=brauner@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OPYvZMcK;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=2600:3c04:e001:324:0:1991:8:25; helo=tor.source.kernel.org; envelope-from=brauner@kernel.org; receiver=lists.ozlabs.org)
Received: from tor.source.kernel.org (tor.source.kernel.org [IPv6:2600:3c04:e001:324:0:1991:8:25])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4jRZFy2ghJz3dT6;
	Sun, 15 Nov 2026 00:09:10 +1100 (AEDT)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 7F3536254F;
	Sat, 14 Nov 2026 13:09:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C84511F000C4;
	Sat, 14 Nov 2026 13:09:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794661748;
	bh=id4PRLDY8xxqmv09Cy60S/mO+ESr2mIJ65uM2WRQC7s=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=OPYvZMcKo2pLKQPLfKiB+xqQT7JtU6u/nMFLT+5hYzH3QWTCFPRoRS6r/Oow1VAkL
	 3HYR/sSwpSruxS71lTMziygx7APu494xsLge+qXN+aS/Fp3Yr+SysKiJDxgm9fV8FL
	 LLLNw7kLSad5h56STuFO2hVPqf8d8oG5y+9btaqGaQCPkoLOjBnZy2HRlufPRIqJR9
	 JAGDmN3jPQZ4ZGCu2z1obHGmPT84ifLV2wmvOlYzT12//tpCLC91vE73DnFUFErjrE
	 jtHCCp7HwPDe37nSYEBsn4aY5ZIWlVvyOmtxOFVyVhXkm5TyApjftkdHnhTF0e2OJb
	 Th1bcZaPa1Qrw==
From: Christian Brauner <brauner@kernel.org>
Date: Sat, 14 Nov 2026 14:02:11 +0100
Subject: [PATCH RFC v2 30/42] powerpc/spufs: use fc_init_pseudo()
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
Message-Id: <20261114-work-loop-pseudo-v2-30-98639a2286fb@kernel.org>
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
 "Christian Brauner (Amutable)" <brauner@kernel.org>
X-Mailer: b4 0.17-dev-ce4c1
X-Developer-Signature: v=1; a=openpgp-sha256; l=1161; i=brauner@kernel.org;
 h=from:subject:message-id; bh=IfUgpka9O6kutLnlSG4nrBix3fgpTd+0l8aZ7VY9Wl0=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWT9iOmwtup7dlAk4P1lb2Nu/V0Xay46TjCe9C/9OFdZk
 KnsNdfKjlIWBjEuBlkxRRaHdpNwueU8FZuNMjVg5rAygQxh4OIUgIkw7GT4n/qCU/F0TKjhPQ87
 jwlLc8VsP+cYLxcU+LHbRm/KCV2pdEaGPWc5jk092LJ1wpFjdg3lNRW7ODKTlXubs7L6rYTlL85
 gAwA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Initialize spufs as a pseudo filesystem. This raises SB_I_PSEUDO and
also SB_I_NOEXEC and SB_I_NODEV. spufs never holds executables or
device nodes.

SB_I_NOEXEC also refuses PROT_EXEC mappings. The spufs files that can
be mapped expose local store and problem state areas of the SPU,
nothing the PPU executes.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 arch/powerpc/platforms/cell/spufs/inode.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/powerpc/platforms/cell/spufs/inode.c b/arch/powerpc/platforms/cell/spufs/inode.c
index f066d9c7344d3..54b45932aecd2 100644
--- a/arch/powerpc/platforms/cell/spufs/inode.c
+++ b/arch/powerpc/platforms/cell/spufs/inode.c
@@ -11,6 +11,7 @@
 #include <linux/file.h>
 #include <linux/fs.h>
 #include <linux/fs_context.h>
+#include <linux/pseudo_fs.h>
 #include <linux/fs_parser.h>
 #include <linux/fsnotify.h>
 #include <linux/backing-dev.h>
@@ -741,6 +742,7 @@ static int spufs_init_fs_context(struct fs_context *fc)
 
 	fc->fs_private = ctx;
 	fc->s_fs_info = sbi;
+	fc_init_pseudo(fc);
 	fc->ops = &spufs_context_ops;
 	return 0;
 

-- 
2.53.0


