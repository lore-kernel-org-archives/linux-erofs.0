Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67637606BA16
	for <linux-erofs@archiver.kernel.org>; Sat, 14 Nov 2026 13:08:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=eNMLKdTx
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4jRZCf6Z2Mz3cGg;
	Sun, 15 Nov 2026 00:07:10 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2600:3c04:e001:324:0:1991:8:25"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1794661630;
	cv=none; b=SDY5Dmsx4P88FFeTAnUFSYK8krExg/tiqMuD6EU5YmvgTWSjvmqMYGVyNj2/QzqJEcjf395vp2e3lfUFK3oANGIS78B4SHnX1X11hi8OuNSpZ3sPpG4It9o9O6N0HAOlj8qhTZKPOo7Gt34221Z1i+ry2ZIyyS83HVJn0H9ZyLaq4wUlBi1xkN4GWbglwJJbbkxxMFrxLof9HzxLYQ2miX1wmbW/4v6nUTLF1c4cg2RM22RFytds4ATtHBqFr9Y9Ij1zMl7Hx8N9NVPvTTMclUWkE16bz3/AjsAQUlhplERJ47NOaQfuLzQlKtwnwbG4H7zy86xu4gXUGV41JOyyuA==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1794661630; c=relaxed/relaxed;
	bh=a4DogC3leTMvellKkr9nWRooBo/YpeiaomL5EWz/ARI=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=hceyhKs+0eHP460tR8GL9/LvWQ0zvOaDqxq/NULS5OONTt3tRz7U7Mpu+NziU7MxONUob7+rZEvDfkqMcn6GxydM12FjlcEtsZtlI8tnh/4KU8pGpH3V24MxNIHl1lQxehZ1wn6EXf6Vwdh/7k8N0aR5atrbjPbbCv46/fdZiSCY3+JPZSGmM1aL511KDuJCVIAyttSe5AzLVl7tD04pFk+iKQJeDavZmYpUrQ5agLoTJy0kGHhoikOVnEObX9G0PIChET9UBArddOYjHuTtZpBdJB1zgVhmswNZFoyGJQlEft23D2X6DYGY9BPbv9DoOmjgRrVBFUhDiaP3kLYDnw==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=eNMLKdTx; dkim-atps=neutral; spf=pass (client-ip=2600:3c04:e001:324:0:1991:8:25; helo=tor.source.kernel.org; envelope-from=brauner@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=eNMLKdTx;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=2600:3c04:e001:324:0:1991:8:25; helo=tor.source.kernel.org; envelope-from=brauner@kernel.org; receiver=lists.ozlabs.org)
Received: from tor.source.kernel.org (tor.source.kernel.org [IPv6:2600:3c04:e001:324:0:1991:8:25])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4jRZCf1qBBz3c8g;
	Sun, 15 Nov 2026 00:07:10 +1100 (AEDT)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 62F98626C1;
	Sat, 14 Nov 2026 13:07:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F5541F000C8;
	Sat, 14 Nov 2026 13:07:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794661628;
	bh=a4DogC3leTMvellKkr9nWRooBo/YpeiaomL5EWz/ARI=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=eNMLKdTx3dymmeQj42x/tiPQZlsYxo3BnxO2lle2ggCk5ik4UVoGb9FneQv4f+PfE
	 iPtXg6wJ4NiBYxVUKwrwV6BjjDW1PYcTx9AdLPDNYcRJOa/njeQT1Tui+yB5OKPTPd
	 pBiRmu+dYcCDMMFEP47vr4N9dOso2DnIN4N2dS49BqxUX+8EhXORqAc5k/0HnUrAep
	 9Yh+6V9R/3YLoNJ8Vj+tT9kmqKS6ojGo0ggbD6EZRxvoiqNbm9pHagQWaWsSziNoLX
	 cDNo+Xtyw5HdAJaWdM3yOjBIu3OaQSIdSq32D7VRiuAD0Ykly4nDMli7qT1xKcfmFF
	 gfkjM96ebjM0g==
From: Christian Brauner <brauner@kernel.org>
Date: Sat, 14 Nov 2026 14:01:54 +0100
Subject: [PATCH RFC v2 13/42] devpts: use fc_init_pseudo()
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
Message-Id: <20261114-work-loop-pseudo-v2-13-98639a2286fb@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=974; i=brauner@kernel.org;
 h=from:subject:message-id; bh=/9KDxh8T8EW09H7q8v3DIxE+0d7Rcpp1sL669Qzx9RY=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWT9iCk5MqFtZ8uZ5Vpfmq9aXrFPb+e5ILP/w0bNwh/9p
 jtOP348taOUhUGMi0FWTJHFod0kXG45T8Vmo0wNmDmsTCBDGLg4BWAiuccZGe7P+j9R4cfXIK9F
 kskbJ11+sv2x5N5pR3qFQ697SPMd/n6HkeHec5OmTsUeRsv1nnuXcvV1232cPa9UY1dJ3KG88C2
 nSjgB
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


