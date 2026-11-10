Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2883607A60D
	for <linux-erofs@archiver.kernel.org>; Tue, 10 Nov 2026 09:19:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Z/rhUIdt
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4jP1Kf2ztNz3cLH;
	Tue, 10 Nov 2026 20:18:30 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2600:3c0a:e001:78e:0:1991:8:25"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1794302310;
	cv=none; b=Cv3L3Ct6n42Ozaxu9zySJfAA9JI5uLW4Klqj5L0CVnjm3LgfR/U4AQPMCoEqZ1I7hBjwUPypuScjz23NGtSOGQGLJaL480tMKxM/Pal265mw+I8jFXNkcCai0/em2koSbn5bPOM9Zaxjm12UAGUgiq3Z/2yE2AR678l8mp1gLhb8C5SmTgAwoVdmwQhqg0bqyhilHgOljCUqZNz53aL2SctrzuKO/04AEgeFYOVeC3wOfkq+w0QS489AnGIyvSoTCuxCvQmGeKDZ5E8ijEcxu6w/UG7gEcP7Vaf9wcKWBqeygC+Ek7gN+nvyr6SVcWWWYK4OVi2HcBIF261k+jYgMQ==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1794302310; c=relaxed/relaxed;
	bh=BUOTmrjfTp1V3edmG7gNtNzcyR5ppQHZl9FL8hylfFM=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=Nz4znMoTjTxHxq5Web+hlnUFZa6P6d9cNJAZ4Ouw1Jt22wt48oiIafMwkZUq10UdB8MjYQEJ6Ym6jsieCddycQhVti5ry7e9tEbLDTZvMW4VvQ2jglltevHSKwJQdtOal9c9GhOL5BTKgrD36sEfaYyZKsG8ajY4SEZ/pev5hZX8TXMZdnkhmVDWVjZsM5e8zllgWFQvoQ/y8uUUPg2IWrjaQ59wuLZpQ4Tpi9FQqke+gZdO77wxAoLaZgNWuosn3F30K1z5KhJyuGRcns3qA3fdcPkQ8JPegl5qzD8ZYa6drDibL5KvpfN13GRY+vnyvfLomAtoKlgjzxlETeUacw==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Z/rhUIdt; dkim-atps=neutral; spf=pass (client-ip=2600:3c0a:e001:78e:0:1991:8:25; helo=sea.source.kernel.org; envelope-from=brauner@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Z/rhUIdt;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=2600:3c0a:e001:78e:0:1991:8:25; helo=sea.source.kernel.org; envelope-from=brauner@kernel.org; receiver=lists.ozlabs.org)
Received: from sea.source.kernel.org (sea.source.kernel.org [IPv6:2600:3c0a:e001:78e:0:1991:8:25])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4jP1Kd5nHbz2yCr;
	Tue, 10 Nov 2026 20:18:29 +1100 (AEDT)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 4C6CC4248A;
	Tue, 10 Nov 2026 09:18:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACC561F008BD;
	Tue, 10 Nov 2026 09:18:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794302308;
	bh=BUOTmrjfTp1V3edmG7gNtNzcyR5ppQHZl9FL8hylfFM=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=Z/rhUIdtQk+seOQ77LPhWLi0h1HQ2z43OEYnSCV//qvDOQQY0eHazzaAy54GUx8Mx
	 8OK9mCUr3KpEXeTzY4DiLfSk8l4evm0rcg5MG+ZHO1q3f2+gjSfOngnblIK2dDloDP
	 +WK6+GSTNoZaklQDEZGcF/9QgdWYzJPUOnmM9b0SlwKN7qlVlPKvfelGldE5Fl2bZq
	 JX98mYm4OGqMZKkfdmwuQV/pEXKpVF4ZPuDqWxolPUJwv7mAgjzXljkKCK82NenbeL
	 eIEFZnStffm2ZpLfOJ/AEIbn+CZ9LM0bc0AUxEiBMv53oXud1Vog9u11hUGToZKfGe
	 0TNk0TnU30pYw==
From: Christian Brauner <brauner@kernel.org>
Date: Tue, 10 Nov 2026 10:14:38 +0100
Subject: [PATCH RFC 22/41] sunrpc: use fc_init_pseudo() for rpc_pipefs
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
Message-Id: <20261110-work-loop-pseudo-v1-22-4c998976c6c7@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=934; i=brauner@kernel.org;
 h=from:subject:message-id; bh=HtfAKXnCso4ldD33NV35qBTF+UjT1cN7QubZI9DMCIE=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWR9erBWvWPi53s6BltWb/lTc4Zf/LbV2zVLS/PuNTwys
 NpTVK11t6OUhUGMi0FWTJHFod0kXG45T8Vmo0wNmDmsTCBDGLg4BWAic/QYGSYY+3T8qY1dKXP/
 avJlZZapb1UX7tkXkrYvfWun7ZXF048yMlyV0He+V+u+/2+YguYEho8MZedCVq0SsT9y8ZnhI4f
 FWnwA
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

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 net/sunrpc/rpc_pipe.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/sunrpc/rpc_pipe.c b/net/sunrpc/rpc_pipe.c
index 9d349cfbc483..37277a6d2415 100644
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


