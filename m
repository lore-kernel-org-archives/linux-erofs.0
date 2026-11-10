Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A960606DA08
	for <linux-erofs@archiver.kernel.org>; Tue, 10 Nov 2026 09:17:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=IIsjfWUO
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4jP1HY2hC9z2ySc;
	Tue, 10 Nov 2026 20:16:41 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=172.105.4.254
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1794302201;
	cv=none; b=Ckb0UQlvafr3wLzX6F28k8ZJMhoYxwP+LSHVd0eelWZVnV30vUCQ6aosowy8WNcWfnqz/BXdvKSmhuUaRBllnNChrNjlj1if3+UegMYEppRzEJYILTUnwvyAQxFVl19nAUVKGed1iOorJaANHpuKbpWPCSCQPLFApo/cutFlRlIyDU3f9/73KBONNcjsHbcXbX2WiLd+hyQiSOheR+TfILI7F5LEn0hqNHyY43a2zBVWY63qINnb6Bzkhhaxg1aLSEgJVFKjuyde6eBEL752UvcmlpP0uSxuWMR2veT35Q2pxbtFGpyBTTRAHpzlBvTbHYm17ALGSSCcohyzR0lqaw==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1794302201; c=relaxed/relaxed;
	bh=mLVLyIpRLrs15SgdOEdgXbdYk/BZhN4swU0iCuBOyic=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=ZsaezjibO/sTuittcma1ESuoXFfuIw7zvFJeXUvV67cCZs8MvmBe4/2uRrfi7X2Z4Ge84uPY9IU3558Oi8S9eS8YCNBcS+g9QyC3bTvcT7o7L1V2oB0xWH772bhFRieb4j7mM4927+0yP+qf0EwrJlJbvQOq9rP/DcytjQVXVW+cLbO/BHey9KNf9cWXkcVixgdtBZU57HJl6VLl3rN4sLq4U2tm3LMYpeSMw490WfD0i7FURcZewq6a8x1InreLQ4gVrcS1Aso9nXTt3Z8FUETPwY6LvgxndhlnoEqhzgiNrxmWBcl/C0ioGuiDzkZnY3s+m/AR+tb37kK9lJh7pQ==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=IIsjfWUO; dkim-atps=neutral; spf=pass (client-ip=172.105.4.254; helo=tor.source.kernel.org; envelope-from=brauner@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=IIsjfWUO;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=172.105.4.254; helo=tor.source.kernel.org; envelope-from=brauner@kernel.org; receiver=lists.ozlabs.org)
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4jP1HX3kZqz3bZf;
	Tue, 10 Nov 2026 20:16:40 +1100 (AEDT)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 9D6D5611FB;
	Tue, 10 Nov 2026 09:16:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4050E1F008A1;
	Tue, 10 Nov 2026 09:16:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794302198;
	bh=mLVLyIpRLrs15SgdOEdgXbdYk/BZhN4swU0iCuBOyic=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=IIsjfWUOtMl2CEA++5Jt8EWp6KRTI2HXcARdUBvCdmTdKWE1uX1aMYAXg8Ea/e8Ql
	 Xql4YvlNPt9K9QrXupja0AV8uGJ4ZeQk3gDHw7i85Y4EbqZiDD29w/gu3h4vBD1pOY
	 iAVha3oPB1bPlmff69yHag/xubD/tLzqQTssa1t0tgnGT7QGrFnYsIwcF9XMVmtUiW
	 K1WSiuD3LOVOs5EqoSIS8TpSROn1Jiuyybk5PLeAHpwhWS+d9EjZQcuJHs/HljUe2V
	 MtagQG38QZOlSaCBeycYDsPJbjUtRGiQhZJCiEt9y8RKsVtp69sly7RCCFqaYz3x8K
	 aiwArWlZiPSgQ==
From: Christian Brauner <brauner@kernel.org>
Date: Tue, 10 Nov 2026 10:14:22 +0100
Subject: [PATCH RFC 06/41] proc: use fc_init_pseudo()
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
Message-Id: <20261110-work-loop-pseudo-v1-6-4c998976c6c7@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1267; i=brauner@kernel.org;
 h=from:subject:message-id; bh=gjYrjHbn+wcxnIFNb/oa4teQqFEsQIh0Sk5lJ439ovI=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWR9ejD77u+nlaqnLf4kFGhsen2irk6irPw3z+y/Bi4hN
 TdYuKQPdpSyMIhxMciKKbI4tJuEyy3nqdhslKkBM4eVCWQIAxenAExEgY/hJ+PsE4F/232+vH/y
 jeuV3N6zU727BJZKTjAty7kdyLHqgSYjw3K5k6+bop64Mr3ov9715vvhKE+JtjurFy9306rKeaY
 hyQYA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Initialize procfs as a pseudo filesystem instead of raising
SB_I_NOEXEC and SB_I_NODEV by hand. This adds SB_I_PSEUDO.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/proc/root.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/proc/root.c b/fs/proc/root.c
index 7fbbe92bf73a..ca0e75081934 100644
--- a/fs/proc/root.c
+++ b/fs/proc/root.c
@@ -17,6 +17,7 @@
 #include <linux/bitops.h>
 #include <linux/user_namespace.h>
 #include <linux/fs_context.h>
+#include <linux/pseudo_fs.h>
 #include <linux/mount.h>
 #include <linux/pid_namespace.h>
 #include <linux/fs_parser.h>
@@ -265,8 +266,6 @@ static int proc_fill_super(struct super_block *s, struct fs_context *fc)
 	if (ret)
 		return ret;
 
-	/* User space would break if executables or devices appear on proc */
-	s->s_iflags |= SB_I_NOEXEC | SB_I_NODEV;
 	s->s_flags |= SB_NODIRATIME | SB_NOSUID | SB_NOEXEC;
 	s->s_blocksize = 1024;
 	s->s_blocksize_bits = 10;
@@ -350,6 +349,7 @@ static int proc_init_fs_context(struct fs_context *fc)
 	put_user_ns(fc->user_ns);
 	fc->user_ns = get_user_ns(ctx->pid_ns->user_ns);
 	fc->fs_private = ctx;
+	fc_init_pseudo(fc);
 	fc->ops = &proc_fs_context_ops;
 	return 0;
 }

-- 
2.53.0


