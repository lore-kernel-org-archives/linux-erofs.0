Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01D9A606A8A0
	for <linux-erofs@archiver.kernel.org>; Sat, 14 Nov 2026 13:08:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ZBduMUGq
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4jRZCp08mcz3cJr;
	Sun, 15 Nov 2026 00:07:18 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=172.105.4.254
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1794661637;
	cv=none; b=dDnVEIHnXjHd2H2Ip5rgEmsPzpnnxm5olWzVaWO9WJ4Sf4HcMKFsnQuqEr4/Arjqn/7jsSKcx+Sn4gfSPChUzWC+7GyMZiAkfCbw8cjM6nkILbRDfguP2aeLfXS0yyzcGQG6GrSKpAOu/yuLvuvJmPKu+LArRRXlLY87ISpP76OFG3pS+XWtvzXrU0+XyucE63F8RaV1hD7AHheH0qd5a/mX96pMDmLaHUxeG31GwZ1pMcgwB09XJKNMPhp8E0ZvpcaXxmaYsSms7vtPWH2tceQOtQHC+f0KR93bkzcZ4oijJQbPgFPQptqLQik29uNDarsSlN8FqSFDldKjVxIffA==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1794661637; c=relaxed/relaxed;
	bh=J9s+j/qnomdsSfV9A9X1jZ68ytQ1y88uXgL9lPJcnQQ=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=MQ0R+LVxYGunFqcI/kingsnUlL3/3bjjQyTZB9j3rhLhehqifwcZfzjny90w1Ssk2iZ2WARISTKGlTT8y3gFkcPHKbgXbW1CD4ALElVp1RnGD3Cgkgv1i7L50kE7N3nqVqoQgxKMn45HH3Nxduf7SPyt9/G/NqJtoFYbHeXXaL6Fwowg1bvdojjiewpz4k/NVNUn5J0YjuTOcbkwvyk23W+SVwYQmJlce8YrmVa1yF5hG1eCPlnGtBnNgetgRdT8ZND2GZp8CaSdtrlbo6hwIQOTqhqUARP8P/rFUQkKU2p8GcDOebRdYU4OykPtuAuZiliPUhS8zejPDZc/0i08AQ==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ZBduMUGq; dkim-atps=neutral; spf=pass (client-ip=172.105.4.254; helo=tor.source.kernel.org; envelope-from=brauner@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ZBduMUGq;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=172.105.4.254; helo=tor.source.kernel.org; envelope-from=brauner@kernel.org; receiver=lists.ozlabs.org)
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4jRZCn35FQz3cC4;
	Sun, 15 Nov 2026 00:07:17 +1100 (AEDT)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 8AA016271C;
	Sat, 14 Nov 2026 13:07:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CB521F000C4;
	Sat, 14 Nov 2026 13:07:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794661635;
	bh=J9s+j/qnomdsSfV9A9X1jZ68ytQ1y88uXgL9lPJcnQQ=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=ZBduMUGqp/qi5659mADzFX9+8wf4kVV3NEMIvBS9gKHs6MAUqEHt8cBzj3ZNgbS6d
	 Nf89OZFMZUZCn2jJ6Mafo9wRMxG9W4SB0eAJp1Mg0VKarsMFlGa9zj428VS1a+b0RY
	 D6CTCLMwH/+Gy7FwbJfcjx3qkCoh6LyEfI7rfX1ekkbjm/2l1cn+9zhnqWbhtfdgam
	 Y+PAnxkHWZsnELKY9cqaxrXaHDYmDIwyumXSSeFQKPXZI1w6p3YqMu2+y/31W4BSbI
	 KTWrP3vhpbirbRroyDnQuVG/W+XGJp6QhDHB9PqcU/GjF+Dz5Sq3c8cIAzqE/bRgNS
	 ehuHrQrWIS4kA==
From: Christian Brauner <brauner@kernel.org>
Date: Sat, 14 Nov 2026 14:01:55 +0100
Subject: [PATCH RFC v2 14/42] debugfs: use fc_init_pseudo()
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
Message-Id: <20261114-work-loop-pseudo-v2-14-98639a2286fb@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1131; i=brauner@kernel.org;
 h=from:subject:message-id; bh=LYVXsmqnxJmzP/zdkj81mpuZ8VVR49+0Ejm2rZDTrDA=;
 b=kA0DAAoWkcYbwGV43KIByyZiAGr4XHWh3hAo/8SIEYNT/j2jncgmX+7HWMmgK6bgfx63CtOSR
 oh1BAAWCgAdFiEEQIc0Vx6nDHizMmkokcYbwGV43KIFAmr4XHUACgkQkcYbwGV43KJ5WQEAzj30
 a+DH4tqF+HU88MmhFrWuShGbUZ/WYvxekVK9nkMBAMzhgdjjYON010GwrBYO16UXD9hyZA5dodO
 zboH1iSQL
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Initialize debugfs as a pseudo filesystem. This raises SB_I_PSEUDO and
also SB_I_NOEXEC and SB_I_NODEV. debugfs never holds executables or
device nodes.

SB_I_NOEXEC also refuses PROT_EXEC mappings. The debugfs files that
can be mapped, kcov, relay channels and powernv's memtrace, map data.

Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: Alexander Mikhalitsyn <alex@amutable.com>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/debugfs/inode.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/debugfs/inode.c b/fs/debugfs/inode.c
index b4915551ad315..f163f0bc5703a 100644
--- a/fs/debugfs/inode.c
+++ b/fs/debugfs/inode.c
@@ -15,6 +15,7 @@
 #include <linux/module.h>
 #include <linux/fs.h>
 #include <linux/fs_context.h>
+#include <linux/pseudo_fs.h>
 #include <linux/fs_parser.h>
 #include <linux/pagemap.h>
 #include <linux/init.h>
@@ -317,6 +318,7 @@ static int debugfs_init_fs_context(struct fs_context *fc)
 	fsi->mode = DEBUGFS_DEFAULT_MODE;
 
 	fc->s_fs_info = fsi;
+	fc_init_pseudo(fc);
 	fc->ops = &debugfs_context_ops;
 	return 0;
 }

-- 
2.53.0


