Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD766606B983
	for <linux-erofs@archiver.kernel.org>; Sat, 14 Nov 2026 13:08:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bbvqUTJK
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4jRZCW5lH8z3cC6;
	Sun, 15 Nov 2026 00:07:03 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2600:3c0a:e001:78e:0:1991:8:25"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1794661623;
	cv=none; b=G7IJH+c4OSV5Zi9FOfIJvpIt7ZYh4UBUv/HERiJQfs3mokderVthf7+QMbxhjhn0KSR6ILHg1L7Qm0KhV2sV+YtocXpG2s/U5DTzocviAOidHX6GSQ6oll+qhi8uYfCWMjYg+OeM/jPgpvLPEZeeAoKlfjuYbM4Q/MIhPyVllERbOAK/9Z0sJmlUg3ce9UEzAn9EFKMpBbujM3VPVXQ5sVba4vkQpUV63GPbiUxd6Us5czC99ZPeav1vVYSvWGdLst9xfJPYyq9TLAwMDuJp8I/F2hll8vTT1e+mlMC9PnAkkAHSd/d5KVWepRJwMyplEn0PHUKAluWB/PpGKSrcjw==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1794661623; c=relaxed/relaxed;
	bh=unDyG99Rc2/QnFjGnYYD038yieUDExHdgCgrjykz2ZY=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=DiPvmeYDW+nG4jQnRhcIFNds6jhyOLhaJWGsKNSM5JXmjbCVc30IpkpuVvb4asOr64b+p6Eu0COQNOxHqT6ePUyPpTgW00tQm+xgSW4bkh3B/9uqqPMofM4c4olxl2jFNknOn04hoF3fKuk/Ar4952GBAYEBjY4q3AVFaT55MfX8bDouPgSPFzn8bT0b/SrmFr5RtLFeKwL7AAFurdXq3VPxew3oWmRE5xMfmBTBrWcZ9vBzoCTKO2L9Bcpropmak63SbApIZtQuvQsNlwRAAcrBreats0vxf+YuMiKBNrBznhbp6+vUcEtvAmBQ3lbnC6SLV5ybA354hDb3pPznJg==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bbvqUTJK; dkim-atps=neutral; spf=pass (client-ip=2600:3c0a:e001:78e:0:1991:8:25; helo=sea.source.kernel.org; envelope-from=brauner@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bbvqUTJK;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=2600:3c0a:e001:78e:0:1991:8:25; helo=sea.source.kernel.org; envelope-from=brauner@kernel.org; receiver=lists.ozlabs.org)
Received: from sea.source.kernel.org (sea.source.kernel.org [IPv6:2600:3c0a:e001:78e:0:1991:8:25])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4jRZCV4dHcz3c5h;
	Sun, 15 Nov 2026 00:07:02 +1100 (AEDT)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 0959F4149B;
	Sat, 14 Nov 2026 13:07:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66F5E1F000C4;
	Sat, 14 Nov 2026 13:06:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794661620;
	bh=unDyG99Rc2/QnFjGnYYD038yieUDExHdgCgrjykz2ZY=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=bbvqUTJKtvMzosAC+DFxEgbW2Vt0FzW0cgiaoIw4p06+FQN0Sb1Tv1DIYKxkGIHgF
	 nr/z4/kJVkGC0PVIG0S+X2+IVr9KgB6EEAlRappl1aI/jvUBiq8DuKNlLNE8vxcBA5
	 0JKTxwjjXckE+NeBCr1Bi8VfSd91eEzjplmFXA/4XP/TxEXjCKcLqdTFBZyvuK/4TB
	 XM/3qFzs564jbujRGcQ6pIz5ll5eRxjrkU5c0H0jv1xeSUhUu14iRQDCczLPJNQJAW
	 bobeXvnmondRh0cNkkJpqbnGO+HCtPYOqhf/9OsJt9+WANi8Hptd1u6XdBIoycR1Dw
	 5PqAgnFXrJ7Rg==
From: Christian Brauner <brauner@kernel.org>
Date: Sat, 14 Nov 2026 14:01:53 +0100
Subject: [PATCH RFC v2 12/42] rust_binderfs: use fc_init_pseudo()
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
Message-Id: <20261114-work-loop-pseudo-v2-12-98639a2286fb@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1351; i=brauner@kernel.org;
 h=from:subject:message-id; bh=Se/hTFkDp0LtS3ScLeBDxadBnc0o/SVsPeEgiuoeVFc=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWT9iCn+frwhSzhtu6ttd9fzjo+dooobf9y0jSo35l66+
 IDLR4G0jlIWBjEuBlkxRRaHdpNwueU8FZuNMjVg5rAygQxh4OIUgIkUJzD8lbV+Vvz0VtVGta/L
 t5z8Lnjs6u2MqK7DthlNXFl91kl+LowMq9Zuux269XP8tl+abt/e3Tu14f6n3JqV77gfTzl4Z/J
 bEzYA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Initialize binderfs as a pseudo filesystem instead of raising SB_I_NOEXEC
by hand. This adds SB_I_PSEUDO. binderfs_fill_super() keeps clearing
SB_I_NODEV for the binder device nodes.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 drivers/android/binder/rust_binderfs.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/android/binder/rust_binderfs.c b/drivers/android/binder/rust_binderfs.c
index 5f020226720db..04468c5b5c116 100644
--- a/drivers/android/binder/rust_binderfs.c
+++ b/drivers/android/binder/rust_binderfs.c
@@ -3,6 +3,7 @@
 #include <linux/compiler_types.h>
 #include <linux/errno.h>
 #include <linux/fs.h>
+#include <linux/pseudo_fs.h>
 #include <linux/fsnotify.h>
 #include <linux/gfp.h>
 #include <linux/idr.h>
@@ -667,7 +668,6 @@ static int binderfs_fill_super(struct super_block *sb, struct fs_context *fc)
 	 * necessary and safe.
 	 */
 	sb->s_iflags &= ~SB_I_NODEV;
-	sb->s_iflags |= SB_I_NOEXEC;
 	sb->s_magic = RUST_BINDERFS_SUPER_MAGIC;
 	sb->s_op = &binderfs_super_ops;
 	sb->s_time_gran = 1;
@@ -759,6 +759,7 @@ static int binderfs_init_fs_context(struct fs_context *fc)
 	ctx->stats_mode = binderfs_stats_mode_unset;
 
 	fc->fs_private = ctx;
+	fc_init_pseudo(fc);
 	fc->ops = &binderfs_fs_context_ops;
 
 	return 0;

-- 
2.53.0


