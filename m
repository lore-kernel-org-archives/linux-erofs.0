Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71709607496A
	for <linux-erofs@archiver.kernel.org>; Mon, 16 Nov 2026 11:07:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=C7+P4qkl
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4jSlSM0tL2z30WJ;
	Mon, 16 Nov 2026 22:07:15 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=172.234.252.31
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1794827235;
	cv=none; b=Cq0stk7DO7dyST6hHGwJ0ghcKFGU5eo99TLJKs+mv99I7Q2zBwYBNh8BP80jmVV3Vbsk7Mku0HjHOk4IzJ65hQbu1C7Ywh0l9n32dQsVO6dOBpCj/YWq1vnTY1VG7dN0Tp797BzztQQaEFarc73kXTynrGkrSXtePR+94hmnT1QxoHxHbcHMlp3M9NYva/BNVklgoKCQtq54bQHyf6o6Sw783j5ofXXxjaCKager027WZnNmfhz/LyRRQ4zE5XR4Vj9jUvgs7dUd+Sl9lk8jECcQVGAM/H9f9lXnzba9d2F0NoaX3qv95H3VDPmX7GGGqFEqrZEWd338W0iHknhyxQ==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1794827235; c=relaxed/relaxed;
	bh=jRCDiiiipC02o6v9Jxb1vAxzrNeQQVIjxwNCfj8X/R4=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=Gjd7+/QrNutia0Xw1xOiq8usx0CiCruwiMaoOh5HtIc8wXdrelYcu+fmc8uSZHD9mVpRhcy9HmNufRwQWIF+KZhZ05gWNSDMPoXNfrZKqHWF/4uiHKAbJGAfUws51vsSXjjfJdune9yMMRYPc6VDPjXKtjOwKnQ4pKDfO9cbO5X7+EBXc5+dNzwHbNdS/AuiI3BJwT1v6u5+mJxgkvLkw7nqu8+t48J/xoX5IYENKN2nvxci1MTL+BjVyBnFNHVC5utGRxJwJjGoiczptqrzzXSZlsLFtwVe0dp7wXrb/2p74EaPr4514SylpRbtLFqGQoFcHC88aUDzi/Ll/U6G7g==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=C7+P4qkl; dkim-atps=neutral; spf=pass (client-ip=172.234.252.31; helo=sea.source.kernel.org; envelope-from=brauner@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=C7+P4qkl;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=172.234.252.31; helo=sea.source.kernel.org; envelope-from=brauner@kernel.org; receiver=lists.ozlabs.org)
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4jSlSL2ZQrz30VM;
	Mon, 16 Nov 2026 22:07:14 +1100 (AEDT)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id D61FD462CF;
	Mon, 16 Nov 2026 11:07:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D29B01F000C6;
	Mon, 16 Nov 2026 11:07:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794827232;
	bh=jRCDiiiipC02o6v9Jxb1vAxzrNeQQVIjxwNCfj8X/R4=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=C7+P4qklM2cUtF+D6jKlp4LfRoTf/rU+rRx75wWnpOAGzkO6UhrgQhaB00OBirsz8
	 MACnRyQXR/eVZcJt26EgPAg08QL9RP3fqjgBujz8JgGTsdAq6s9jMDLu5UM1Mt75r+
	 rU31WaAbrxRj4Q6ApcXpA6RdFQWcxEa3jvCp1wjijmBnSknbaFrMtAulRG9Ru5GQZF
	 zR8Eq93DBcHOnp3DGufxmLYRE35gtF+ApgQEwhLP7zupv0zg/x25pZIqY3aeu/K+PA
	 FAWFK2afKgUVLhRHvl9IPfvP5yS5WVqmWxxUWW4EL7jJPW1i1AwQf4WL12FyR6NIWv
	 BlkzcsPlba1iA==
From: Christian Brauner <brauner@kernel.org>
Date: Mon, 16 Nov 2026 12:04:42 +0100
Subject: [PATCH RFC v3 09/44] bpf: use fc_init_pseudo() for bpffs
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
Message-Id: <20261116-work-loop-pseudo-v3-9-8cbbea1cf34f@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1354; i=brauner@kernel.org;
 h=from:subject:message-id; bh=3qR9ut2IuMeJZP39d8v3qoh7r3hSncJsbQL0FQDP6f8=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWT9epypt//Aqrfefw+skXjp+v5VSGefzSdhLhmdSaf2p
 RREVxys7ChlYRDjYpAVU2RxaDcJl1vOU7HZKFMDZg4rE8gQBi5OAZjI23qGf6qa+8+wTP/FfLRk
 17ow1WvfmN8+j+TVqpx9LrukSWfVm2eMDO8aK5/8V8pb+3RdTPOv41Fr5txetXRVRqfdE7V537M
 nGbAAAA==
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Initialize bpffs as a pseudo filesystem instead of raising
SB_I_NOEXEC and SB_I_NODEV by hand. This adds SB_I_PSEUDO.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Alexander Mikhalitsyn <alex@amutable.com>
Reviewed-by: Chris Down <chris@chrisdown.name>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 kernel/bpf/inode.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/bpf/inode.c b/kernel/bpf/inode.c
index c6f328e4752e1..57cf3775c0766 100644
--- a/kernel/bpf/inode.c
+++ b/kernel/bpf/inode.c
@@ -15,6 +15,7 @@
 #include <linux/namei.h>
 #include <linux/fs.h>
 #include <linux/fs_context.h>
+#include <linux/pseudo_fs.h>
 #include <linux/fs_parser.h>
 #include <linux/kdev_t.h>
 #include <linux/filter.h>
@@ -1197,8 +1198,6 @@ static int bpf_fill_super(struct super_block *sb, struct fs_context *fc)
 	sb->s_magic = BPF_FS_MAGIC;
 	sb->s_op = &bpf_super_ops;
 	sb->s_xattr = bpf_fs_xattr_handlers;
-	sb->s_iflags |= SB_I_NOEXEC;
-	sb->s_iflags |= SB_I_NODEV;
 	sb->s_time_gran = 1;
 
 	inode = bpf_get_inode(sb, NULL, S_IFDIR | 0777);
@@ -1261,6 +1260,7 @@ static int bpf_init_fs_context(struct fs_context *fc)
 	opts->delegate_attachs = 0;
 
 	fc->s_fs_info = opts;
+	fc_init_pseudo(fc);
 	fc->ops = &bpf_context_ops;
 	return 0;
 }

-- 
2.53.0


