Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6090606DA03
	for <linux-erofs@archiver.kernel.org>; Tue, 10 Nov 2026 09:20:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kTLpHzIi
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4jP1L32f2Cz3cWy;
	Tue, 10 Nov 2026 20:18:51 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=172.105.4.254
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1794302331;
	cv=none; b=PBc0yUBFk5I0zGb7agCDf0TCBI+nUUBw5SypBCUAFmyLfgqm0hOJTrvOM25jY9ZxKtLhu5AlytXYfs3C2s/g4Q1PstrXzhTwPD/wmBUNdVAP1BROo8TgrXSeb9rIwqWfOfHVDhdpwXHCbkGjd8Pph7Jbun9dWvwH6J4tQVDvYL2RizJYhMP2y873jXYlyA7QebDYKLck4pvIZtxGgGvhUsacQ50/q7UxTUUk+kUd33tJ6h2zF2tlIeRSxBEm3tUz60RpbhmeBsMfLnhLTU2/9lJ/OMUFQPQAXVfCJ/o+1whRuQT43IHT9s1EVm/6kGCCSpkzHPY9K/wxKcRPl2Otpw==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1794302331; c=relaxed/relaxed;
	bh=gl42dR2sxHaP3ITJS3b/B04ib5WpCUL9VRtP4KLsRoM=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=V+Ispj60nx2Qy7Lq87chBfiAFILbHs+JdgICS5VYEa/Hd4CIgl6wCxwrj2z5H1kcfkTdb4Nv3KCHxQX17m6WdmS2vZftiGkWIJA3E9oF+ZJQDbgirY6ut7x7hTAbWuPN9UGjItIRTajDyGJNIo5smhZ4A6Uvjw99a+lnRnLzliFkgSySM2crAvv1z3oSJOEeT2Fy/lNSHXZ70/itzvjpNsC1IpZ9J2AjLVEwkJgDb5ORKeLKeDNWPQzy1yIQmhKocV17NF1uUajydM7g/TJ+1+HfyvczB/4kU8i398XriLOwEt7+HF7f8Ds85CngNBwaBTYoZ8Kf/OHePxbT2Sc5CA==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kTLpHzIi; dkim-atps=neutral; spf=pass (client-ip=172.105.4.254; helo=tor.source.kernel.org; envelope-from=brauner@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kTLpHzIi;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=172.105.4.254; helo=tor.source.kernel.org; envelope-from=brauner@kernel.org; receiver=lists.ozlabs.org)
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4jP1L25gM3z30Wd;
	Tue, 10 Nov 2026 20:18:50 +1100 (AEDT)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id DAF6063808;
	Tue, 10 Nov 2026 09:18:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44CC51F008A1;
	Tue, 10 Nov 2026 09:18:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794302328;
	bh=gl42dR2sxHaP3ITJS3b/B04ib5WpCUL9VRtP4KLsRoM=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=kTLpHzIiEoHD/GMs6J5o0BY79JvOwuUY76u4r4LtuPpprEn+sEXP1gtvybcHlSLtT
	 CmJYU8iAHI/ofaZXWihJ5XxShjsnWfKREnaREBGEhVpJuVA8UxIujLE4opfHxMa4l2
	 4bvvQUPUjvQ2EsFdGM14Zv2VXWcqMXokoHGLWd7/ZTwsxC4J9iKJbm5nnnjuBRICkU
	 3Q/oQzewdcDhdx+fyfkGitRE0raCCijhxDU/xYg/eIt2ZjWUYaKm5ljV/gc4aZMDUG
	 Xo7ddzkxLrqw+Yw44oZ3PVfS7jJUGpuyM3cYrfutFlXsGLkg0INiBaZLGiYPLlJfeW
	 ZQQCq/yJeXwMA==
From: Christian Brauner <brauner@kernel.org>
Date: Tue, 10 Nov 2026 10:14:41 +0100
Subject: [PATCH RFC 25/41] pstore: use fc_init_pseudo()
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
Message-Id: <20261110-work-loop-pseudo-v1-25-4c998976c6c7@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=882; i=brauner@kernel.org;
 h=from:subject:message-id; bh=JyexvfbQ5pzTQXeLd6YfvhDNydDQY3kHD9zcB9wbg2k=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWR9erAx2J15TcWtFdu9W+eIHjgye9faLyYyW74GeK1Uu
 /LQcab9to5SFgYxLgZZMUUWh3aTcLnlPBWbjTI1YOawMoEMYeDiFICJ9Nxl+M0aJKtZkDT715G8
 vUqnmxUTdvZHiW417mNNuXFzkjPT9FuMDEfPTDuhOseiqbXY1vy/93S+RZWzPGUXneAoPhv++bH
 pOWYA
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

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/pstore/inode.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/pstore/inode.c b/fs/pstore/inode.c
index cf499ba72702..4658561cf90b 100644
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


