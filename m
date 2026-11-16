Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA386608067D
	for <linux-erofs@archiver.kernel.org>; Mon, 16 Nov 2026 11:10:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=a0UaCeV2
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4jSlVD48Tpz3cFM;
	Mon, 16 Nov 2026 22:08:52 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=172.234.252.31
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1794827332;
	cv=none; b=DOVkxWtQ6oKPq+Cf5CwZJikKCOZZclA0R3TG+AqN6p6g/KM1mKvrn5dKjtZjo1sr5fZWzIb72c48Ymz1W6LIO4Gz8bFV9CJ1rnLrCj9ESNPUm8dXEU3cQxApDrQf3opjU0RHToGMAKuwkufX+6KOSQNG0k5aU7pwcbnhh0PGj4FZGMgZLLjzV3GItzcqEsL3E3w/4iI42TNJ1mUnYh4Gfs2qjHmAjuXJTSJqTMNFoK1ykbC5ONikp0k9Da8SSk1tQCUXwmi1KOoxsH6VD9rIgW0EBknWtSOskKz4HZtTW3AwOQgVOsOwES3f/bYAcwJTl6PI8SUoBrmGIIGN8KlUqA==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1794827332; c=relaxed/relaxed;
	bh=KgbqG9Caw/hRTAbhKcrEqjiiAiXfjhN0P7+uUEzG5mo=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=VGrDv1Bl7qK+5Jz/tm9KPO9+hYSSz1Hun0dQZRsGk4g5KUq2Iw7X4zdAcY8jPVnJrtDzQxm3k9EiV9WbDWujcY5t1WhzcOn+B7ziEc32jTmP5I3CcRNXRM38r4EBK26ByZNyQyZ6u7gK6HNx4WVom9srO//Iesb+lOLKH81gtAhez0YNYJOb2Pma9PW+8xtGIZBRhPA7tRBCauZpltonwfx1M4JvsDaiJvql337Ds4E/wy8z7JNhXnqPoNEd1VQ7M7HT2dY2Nl5fXOn0eXSncTa+BAkMFZzt2Q/iJG4GnHTpe5+75geeg2D3/W+VXoqYHRzdIwcJFvJEb3mkELH3vg==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=a0UaCeV2; dkim-atps=neutral; spf=pass (client-ip=172.234.252.31; helo=sea.source.kernel.org; envelope-from=brauner@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=a0UaCeV2;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=172.234.252.31; helo=sea.source.kernel.org; envelope-from=brauner@kernel.org; receiver=lists.ozlabs.org)
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4jSlVD08Pmz3c9c;
	Mon, 16 Nov 2026 22:08:52 +1100 (AEDT)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 824CA408B9;
	Mon, 16 Nov 2026 11:08:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 768641F000C5;
	Mon, 16 Nov 2026 11:08:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794827330;
	bh=KgbqG9Caw/hRTAbhKcrEqjiiAiXfjhN0P7+uUEzG5mo=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=a0UaCeV2WV+QFgrwTGF9+hKqhdNQa9dgGmQSp/rRjo/bQXyy72SriaLw6dWnEcymV
	 8DP21DNooZ/yHbfrIGqsgMkSLRPQyEkzc0OzcnwWFeuA4kk3ur891oAbusm+Y5TqgI
	 A9UKuEQLGl22KaXB9J3QM0jgvZ6QZyEhJ1LX5mgmJK+zWSZanNlhUpMAk94F0KldS3
	 ZAEOkyjJa37fqTHwFK10oUMUYuBTYBoT8ldVJlKKulVTVEcQ6KH6VUczbJeY4+jyMO
	 SGxWgT7t/Kx8U0Zx7i/0tMnR4OehS/kQiPQrAND2KNfoR/OUuKG2pj8/dQzNF6kliw
	 coFLuVxRgzfuA==
From: Christian Brauner <brauner@kernel.org>
Date: Mon, 16 Nov 2026 12:04:55 +0100
Subject: [PATCH RFC v3 22/44] sunrpc: use fc_init_pseudo() for rpc_pipefs
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
Message-Id: <20261116-work-loop-pseudo-v3-22-8cbbea1cf34f@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1040; i=brauner@kernel.org;
 h=from:subject:message-id; bh=MpmJ+CmuhOGqFr/rEz4RCZnO8Dm+lCmdYI7UNn+2hFA=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWT9elwRn1592q8/9Ebu9EUG4e+0Z+x4JNaS4GRWxbRWa
 I/o/GkXO0pZGMS4GGTFFFkc2k3C5ZbzVGw2ytSAmcPKBDKEgYtTACZy8hfDbzaJKycFfq3aMa+A
 /w/npnojOb4g9kWmP5bcj73ysOj+316GPxwVXDnXi12WCXs1r75bJrnrxYX8JK+ld+pbrvadl9F
 W5wMA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Initialize rpc_pipefs as a pseudo filesystem. This raises SB_I_PSEUDO and
also SB_I_NOEXEC and SB_I_NODEV. rpc_pipefs never holds executables or
device nodes.

Reviewed-by: Alexander Mikhalitsyn <alex@amutable.com>
Reviewed-by: Chris Down <chris@chrisdown.name>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 net/sunrpc/rpc_pipe.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/sunrpc/rpc_pipe.c b/net/sunrpc/rpc_pipe.c
index 9d349cfbc4831..37277a6d24156 100644
--- a/net/sunrpc/rpc_pipe.c
+++ b/net/sunrpc/rpc_pipe.c
@@ -15,6 +15,7 @@
 #include <linux/pagemap.h>
 #include <linux/mount.h>
 #include <linux/fs_context.h>
+#include <linux/pseudo_fs.h>
 #include <linux/namei.h>
 #include <linux/fsnotify.h>
 #include <linux/kernel.h>
@@ -1181,6 +1182,7 @@ static int rpc_init_fs_context(struct fs_context *fc)
 {
 	put_user_ns(fc->user_ns);
 	fc->user_ns = get_user_ns(fc->net_ns->user_ns);
+	fc_init_pseudo(fc);
 	fc->ops = &rpc_fs_context_ops;
 	return 0;
 }

-- 
2.53.0


