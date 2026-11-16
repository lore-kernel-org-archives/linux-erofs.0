Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BEAA6071B10
	for <linux-erofs@archiver.kernel.org>; Mon, 16 Nov 2026 11:07:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=h7CXi/T8
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4jSlRx3bbyz2yrC;
	Mon, 16 Nov 2026 22:06:53 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2600:3c04:e001:324:0:1991:8:25"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1794827213;
	cv=none; b=GymOPndt6v6bzuE0R5jRGhrqhglX2rP3rgI3O2b7R/ZgQvigkrSnqSVOpfrpd6gaU+Qu5+SDFxcTmtIMqqV4RpqI3EL3RfP/L+g/x6fsEcw0AKWl/t2YqkSHA4fjmaN5yOTfd04TiKcSyJ4ZlZssJBGnWtuJt7h7dTd2Tsc7no57v6/VkIt4AKrNH05qwg/IWLvrOmUTPagyq2WfPJaWnwG4z+uvE/C9gKzV1rIycqTYNnWaOROxcLU13rwexfKspB7Njbkc5iAERY9l8WVVcWBYhIB0YhagYzko0qfnGeSNGioJG1oFXmn23HgMnGrAk8GP/VkkWhCmDeF6J3K9Kw==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1794827213; c=relaxed/relaxed;
	bh=oChNfLTK4rw7xE/V7Z1VAqgEcNGqqiTJ7bEePsgI8+0=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=j38PuEH+kET2rf9RHxVbOGKErrApHySVABdORH9BU5v2LqJ7z4JUK6Er/4Q7fBeTN4+A/EtqO2n7wUJdRnvCFLlh8Ih7jPOATG+GFGL++6p/RrbqyiL3LUAmYcQntDzg8h+drPJFRzxaNW05oZSP9FcsZ5F2Ao4eoJ8PVtButu1VgZVDK6P2+mJfoTs4CYEz4nH4M7xK4sQT+ptATDrpjjlxGs1MkaJkuVnCw3ID3DsM5kBPVUx17NwXCc+29bat7Lo7Ll/K0LCGr2bdpqULyXTq+a6BnOtczvvgw7gyCINNDAWZ9s0FILJQ3DLmmXU/jGZvJKnlAd3B2nC3jNCPpw==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=h7CXi/T8; dkim-atps=neutral; spf=pass (client-ip=2600:3c04:e001:324:0:1991:8:25; helo=tor.source.kernel.org; envelope-from=brauner@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=h7CXi/T8;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=2600:3c04:e001:324:0:1991:8:25; helo=tor.source.kernel.org; envelope-from=brauner@kernel.org; receiver=lists.ozlabs.org)
Received: from tor.source.kernel.org (tor.source.kernel.org [IPv6:2600:3c04:e001:324:0:1991:8:25])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4jSlRw3zT4z2xf8;
	Mon, 16 Nov 2026 22:06:52 +1100 (AEDT)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id AD2A16296A;
	Mon, 16 Nov 2026 11:06:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7387F1F000C9;
	Mon, 16 Nov 2026 11:06:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794827210;
	bh=oChNfLTK4rw7xE/V7Z1VAqgEcNGqqiTJ7bEePsgI8+0=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=h7CXi/T80VNFQe+1pnYyDyh2qBlV6g5249gmpoEK/oFyp3rxtx7XiOHqGFA0b9uRf
	 X2xLH2Skg3D0sBNcTtVcs6zgdHUXzZYHUZGaysiF/lwo8EnuSu959abAX0kFQcge1n
	 Xzw3YR9Um2gylgRrQMFHzZbZ9bBGTBSiwzlLZArzyxBiMKVJuxKyXXmg8B55Dx/aqw
	 8L1DchIEJLV0I/73xS4ZZ8jYy6MCTeYnKUSLkxd482HOnnHGhdbaf6Ie9oFIoUMwbb
	 pArvGYXqIS5HCNxl1IyvDitc72nIjyXgcVrUc6r55xEsqjGWvNqc1YcOEP36u0QQE4
	 PtRiWTT84Yo9w==
From: Christian Brauner <brauner@kernel.org>
Date: Mon, 16 Nov 2026 12:04:39 +0100
Subject: [PATCH RFC v3 06/44] proc: use fc_init_pseudo()
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
Message-Id: <20261116-work-loop-pseudo-v3-6-8cbbea1cf34f@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1502; i=brauner@kernel.org;
 h=from:subject:message-id; bh=O+LGaMZ0N6Bs6+mDguHowtHROzAFu69RKO3s/nDEI6A=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWT9epwa/fyZ5LmIiN+RTC9Pt6wTeMornyQXvpLfz4rhN
 bfymsuTOkpZGMS4GGTFFFkc2k3C5ZbzVGw2ytSAmcPKBDKEgYtTACaSeYfhf36ad/RMx0zJi7NO
 u1Wsfsb31Vrvhsy+F3zdv+dbvOJ6WsXwP/DEsU0Xgo+/9awQ+Do190d6wP2jxqUddSK2PFYrS9i
 VGQA=
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

Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Alexander Mikhalitsyn <alex@amutable.com>
Reviewed-by: Chris Down <chris@chrisdown.name>
Tested-by: Chris Down <chris@chrisdown.name>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/proc/root.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/proc/root.c b/fs/proc/root.c
index 7fbbe92bf73a7..ca0e75081934f 100644
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


