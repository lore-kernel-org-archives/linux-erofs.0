Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FEDC60781E6
	for <linux-erofs@archiver.kernel.org>; Mon, 16 Nov 2026 11:09:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=YvkLPRy/
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4jSlTC4YD8z3c2V;
	Mon, 16 Nov 2026 22:07:59 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=172.234.252.31
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1794827279;
	cv=none; b=BqNBdCc6v0Z4KgHsK2jXczpn8ZklqmYrMEFj9YebFmbFgKojAh0QwqQ809s02iWtAhSDbunW+Y0zdRegX70RcekvPD6DreBLy2J9cjFFld344cH9dpfAdrha7gMdOhRBKUqcEUo3M1Kf9rG2GXj4pthreuNYwntKS94GkzBu8TiI5qnm55hsEzvmarpmQL4L0rP+OOM/49iVnDawR4EwbqXZj9eRp3D9EaDoTDNf6SJQPv7nRKuZNQwZ+AkK5VxMfpStVkwuH/ZN0eNpxWwSIypECiE6iPd+InWz7VqI4C3pjrtfCAz0IqHoUZY3StBL/tmpSnDRX5kGShMRnUBPeg==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1794827279; c=relaxed/relaxed;
	bh=PqfeLGmjk4y0+kxRkxjSur2IdVXjx1oPYJuREevbBc0=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=g/EGJtPd8XUz9ioAx3E/+UpOeL452G8adHT3zYxWxIXv431B5XM5cGo1H77lrNSXLl3BSxBUjPjfw8t5KickPu7dYx7fqGgzW9nyRmFmi6scUvRSPxAPL8PvEhFjBdfR+cc4NiIgXfqDQxrn3+BVTxywnkYLK5a9W7tBpuLN67JDMRTUh+vze4F+UzgBabZ9bfbgv3bQxTcd4Dh4Ftmkn6FFQYFuAT//VyXHyHIGcH+u2+Cms010FMecuafO/Cf6W3fP9oXKEwFmRKMHgGI1i/TVSosLp2mUJnrolAQ8p+MM8fA4jbRZmhfbmnZ+PR/l5Zk1VaIYzUR+xQ7XHLWsWg==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=YvkLPRy/; dkim-atps=neutral; spf=pass (client-ip=172.234.252.31; helo=sea.source.kernel.org; envelope-from=brauner@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=YvkLPRy/;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=172.234.252.31; helo=sea.source.kernel.org; envelope-from=brauner@kernel.org; receiver=lists.ozlabs.org)
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4jSlTC0Dmrz3bTf;
	Mon, 16 Nov 2026 22:07:59 +1100 (AEDT)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 83C1F41A97;
	Mon, 16 Nov 2026 11:07:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88D961F000C5;
	Mon, 16 Nov 2026 11:07:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794827277;
	bh=PqfeLGmjk4y0+kxRkxjSur2IdVXjx1oPYJuREevbBc0=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=YvkLPRy/TdN3pcwscLXBhpcduUBjYfqgxZuCJwXsSL+UDnogKKD+92Xz/+diWB7NI
	 0mqTTOVlCiRH9R0uBfT3YiIB2BmI3UU7ll0jcE3kk2lC7TLroBC6Pkv/qkjCb2pKNw
	 zDc5Qqdo1HgBsZBD3BoeHwLBK/Raft20V7BmIejOzs9J/6v/WXVyn+g9CQ2gGm+AqX
	 J1BdMMjoyxnVFZYvSfydNC+8KMf09MmPJr+eYY10D9OpdtxnRAAZVeQJdaGrm0Le+R
	 4Rzjk+4/AJ7X87jNNtb5qnMUVnAQtEquA0JDBGjIxtZx98uV2qTRkccJqkx7xTRA3w
	 c7AFtct/ZdTHA==
From: Christian Brauner <brauner@kernel.org>
Date: Mon, 16 Nov 2026 12:04:48 +0100
Subject: [PATCH RFC v3 15/44] tracefs: use fc_init_pseudo()
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
Message-Id: <20261116-work-loop-pseudo-v3-15-8cbbea1cf34f@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1157; i=brauner@kernel.org;
 h=from:subject:message-id; bh=jWsk7jA40wU8aE/ukx0Eq/KUmnvJ+ql3poj8uK0lOp0=;
 b=kA0DAAoWkcYbwGV43KIByyZiAGr643Cha2aEDzogEHXFHDf4ItcyB4+yUL4ANkviCVs/P6sGm
 4h1BAAWCgAdFiEEQIc0Vx6nDHizMmkokcYbwGV43KIFAmr643AACgkQkcYbwGV43KI/pwEA638U
 1d15U79N804Xlrmzg1WVT0YbKUtsgjGXa9iRx+MA/RH2I1+OACZjxtKr5OTHN7a/GnbvmGcfgyl
 DomehAAUO
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

Reviewed-by: Alexander Mikhalitsyn <alex@amutable.com>
Reviewed-by: Chris Down <chris@chrisdown.name>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/tracefs/inode.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/tracefs/inode.c b/fs/tracefs/inode.c
index 5020365ca7048..e04febd868eb4 100644
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


