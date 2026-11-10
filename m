Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27AAB6072F6A
	for <linux-erofs@archiver.kernel.org>; Tue, 10 Nov 2026 09:18:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ZazHNZp9
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4jP1Jb2mRdz3bsC;
	Tue, 10 Nov 2026 20:17:35 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2600:3c0a:e001:78e:0:1991:8:25"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1794302255;
	cv=none; b=QPCu1C86wEJ404cqcMRqIAqgLa4wGz6gwjmuA1HxeAQO6ffiaCtv1uufM4PjpekCYh7OGVAxRJod3Z4hKzEUjvZPO8CYnOEOwemZ9xgTCNlWydA4DWtv0JopBfWBwNb/yTRPwPQUiBgC/YG1MDTqqzG7P9Ii3iaJKyYCrGOZEKwFn+ZaRYVIs7vtxJ9/Xho3JtcwDD5eE7hLf25+wqK/OUrUNy/n3KBSwTxHyV012BIow7R/HeHyU1n1cgoeWKti8FbpOCMBE//jS1BX27EMhjqm3cUKWY4RESoDL9olltlRvoZ3SdpVoOuW8lr3jdYtHo9xCnRVqzBaqQSh/BA2Sw==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1794302255; c=relaxed/relaxed;
	bh=is6/oCzWlYT0dy5hhdJaeL3p/9SOujmsKB1o+eMmEtY=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=gFwGfsxqLEpgtJbXMh/fljoAq5Ng26ICJZB4cifh/gZUIztdxqAr17eRvpBodWtEsJP34jAZ60EwyT8LahFV4ChKSd3IwH36X9u+pTGjGSAhVfFzWMU8UZ/oWV/qgToDbkJWO/EqWckUND1zwEO7hS6jAK79CIbIZ/Gn/558cv4pCfPjMbRU+tVvagCUtNFdVhHdb3ymav2hh3o+PQJoNSQC2+oQxk3CxAZDGBBu3PxuE75GwuENAznJ2V+79BjbYiwl+DhNUCimZbZFrDiY5VWmxj2fmtxVleQGcoe3Ad37vPsoi1M0dTSOqnw00Lqx+8GJkms9lXhcEyZoi7ZyQg==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ZazHNZp9; dkim-atps=neutral; spf=pass (client-ip=2600:3c0a:e001:78e:0:1991:8:25; helo=sea.source.kernel.org; envelope-from=brauner@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ZazHNZp9;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=2600:3c0a:e001:78e:0:1991:8:25; helo=sea.source.kernel.org; envelope-from=brauner@kernel.org; receiver=lists.ozlabs.org)
Received: from sea.source.kernel.org (sea.source.kernel.org [IPv6:2600:3c0a:e001:78e:0:1991:8:25])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4jP1JZ5wl5z3bqh;
	Tue, 10 Nov 2026 20:17:34 +1100 (AEDT)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 5531D4166B;
	Tue, 10 Nov 2026 09:17:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0867E1F008A3;
	Tue, 10 Nov 2026 09:17:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794302253;
	bh=is6/oCzWlYT0dy5hhdJaeL3p/9SOujmsKB1o+eMmEtY=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=ZazHNZp9OYbLw5mOghlT7zT71BJtkKFeTeYcEEEKzzDfsXiViM/CU7Z8cqPuBHNmQ
	 e9Qsk2tN4gY4RJ80Z+UUxi9qzyvuPPNm8ps8zOEOpz7rLmAYJ6n7ctVBBlUT6hriyl
	 KooXsFO8OBY87qPing6B2f+iBZiovte1ZeeWe7o4pK+dmJB9iSNS/HlIBxl0Amx46b
	 gPvb9WPdxrBx6TvqW3glbSTH9bY6q5ObY70N6N4qYVjM2ZhX+jdcQ4SzRPts34JoOG
	 w3dAqOx+U6EfK5Jcx8iiCprAhcZ+V/vGt/hia8DQYE5ftDBbr0PZ3CyxQdoj/Bvs3n
	 V978BIl4Z9EIQ==
From: Christian Brauner <brauner@kernel.org>
Date: Tue, 10 Nov 2026 10:14:30 +0100
Subject: [PATCH RFC 14/41] debugfs: use fc_init_pseudo()
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
Message-Id: <20261110-work-loop-pseudo-v1-14-4c998976c6c7@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1035; i=brauner@kernel.org;
 h=from:subject:message-id; bh=MkToblHF88kh8NI/b687M2tj3J3ly45eToQK3A7xE2E=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWR9erDEXWDJqs8a6Uaz4h5pdum8snm92LRlGYv8/rrdx
 ++tihfu7yhlYRDjYpAVU2RxaDcJl1vOU7HZKFMDZg4rE8gQBi5OAZjIXgeG/7nTnxz5dOX1QYaX
 PAb8ovMeP3CTevdb7d/7G5YRbf0/Nn1l+O/6l1t14a8Lqh23G9cePX75b+SKyohL6acucmz+3vh
 s+zYeAA==
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

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/debugfs/inode.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/debugfs/inode.c b/fs/debugfs/inode.c
index b4915551ad31..f163f0bc5703 100644
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


