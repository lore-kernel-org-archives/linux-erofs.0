Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71078606B4E8
	for <linux-erofs@archiver.kernel.org>; Mon, 16 Nov 2026 11:08:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WAHd6iSb
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4jSlSW0YWjz30VM;
	Mon, 16 Nov 2026 22:07:23 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2600:3c04:e001:324:0:1991:8:25"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1794827243;
	cv=none; b=SijMfPDD3brU5LfjHCo/8KUvDbO/3pu7J81CZBLyr15L0fmuT8p/NA3lpaoCSBoQqIKgHS/wTIvJjexZg9Ovl9gSvRduhQagOvHnvr8YjprHNbKHmx2QbL+5erluv+nthJhUMVjT5Hjk+9zgSbntwalKAW9klfp8rHaFvchAasWkOuWL09Wfp1+ekS+dX5NDLRJ55yWLlJvmBmYz2fa+BXAkNPKLD/UrMZFOKMzhIyzcbkNHH/B3RF9DCgr7xXupbfqVXN2bEX9+gkRrhOoLs2e5N+bn1aebNBVVzKIITBSp+ll1pKyCdlrhgj5vjxrZDzq05wbQfFfFEdmTPcFBPw==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1794827243; c=relaxed/relaxed;
	bh=CQcOz9pf9yUAnUZyyI8ZqFilBp97onIP4xdHL0RQnuE=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=Isua41SjBU58OUfbcuMcgCpXXhZe/ZPiudG3AwLCsA3AcETqEpH8eXelvhFUaAvUzGjak36MvLQ5qDSQKxQyu6IAH5BfvTA6vDTwmnSwBQnidKGglsRPdChixqEWqP1hl2JqxDBynbCM7pzPJqeR4wiXcSdH/SKmqVk4mseMq5upVzxmrjgUzByksp1W6vzAasg4G0ZpHOn5OWIDILvGcrDpPlDE7UizxZoMdv2OHDEE7pZ4KVJkmWvvcBcotDrRNEYLadiSuhJr7yMe47hLvLsgpORrdIH5fHdSPDLhDkJhGksjiEHQU1P7q57jBNN06qITAZe4WHnx3tilzbPBaA==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WAHd6iSb; dkim-atps=neutral; spf=pass (client-ip=2600:3c04:e001:324:0:1991:8:25; helo=tor.source.kernel.org; envelope-from=brauner@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WAHd6iSb;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=2600:3c04:e001:324:0:1991:8:25; helo=tor.source.kernel.org; envelope-from=brauner@kernel.org; receiver=lists.ozlabs.org)
Received: from tor.source.kernel.org (tor.source.kernel.org [IPv6:2600:3c04:e001:324:0:1991:8:25])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4jSlSV2gYyz30RN;
	Mon, 16 Nov 2026 22:07:22 +1100 (AEDT)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 806126295D;
	Mon, 16 Nov 2026 11:07:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F1991F000C6;
	Mon, 16 Nov 2026 11:07:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794827240;
	bh=CQcOz9pf9yUAnUZyyI8ZqFilBp97onIP4xdHL0RQnuE=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=WAHd6iSbCEtifefZMSqk0cXPnktLAZIBAaCQy60YJ2nJaxqT8DKgVk5VsUN67+gWm
	 z8mxW0ifANULaEn6eoO1YSyCH77pTBjTLQpEuHRCSgNzBdVAIhSKqn4sWkQPFyXdBt
	 tXJ1An451qL0NHQ9VXwP8ewze057R4HqD/VydKBcBWfCdpBT29zz5SWbRmbhPZIy7t
	 krh0rS/lszKzpG2HbfXO42srT3A406priAC+52NrNl/HXbwY35qFpwU2cri/sdCERB
	 F2qr5cKieSSqcVwo+4jbRcbTuZvJ374VxYIuXO00ayF/nT6+GuMDVyrWKkf+vRGeEh
	 HJAAygLW0S83g==
From: Christian Brauner <brauner@kernel.org>
Date: Mon, 16 Nov 2026 12:04:43 +0100
Subject: [PATCH RFC v3 10/44] nullfs: use fc_init_pseudo()
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
Message-Id: <20261116-work-loop-pseudo-v3-10-8cbbea1cf34f@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1090; i=brauner@kernel.org;
 h=from:subject:message-id; bh=r8cREnFKSRz4SaxSdJTVTJtjPA949EUN40oz/vuaT38=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWT9epx17FvHFoV3U5iXzd8/4c/mG66STx2Sspkf5j38u
 eHRZFGGWR2lLAxiXAyyYoosDu0m4XLLeSo2G2VqwMxhZQIZwsDFKQATmR/NyHDKmqvQXFLhWaON
 1Yr9emFz317b8/vF0rgo9uCmt549tVoMf/hXbrBsap/pJMm51TgxM3VdUKfemt6Ay/afb55aob/
 BigkA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Initialize nullfs as a pseudo filesystem instead of raising
SB_I_NOEXEC and SB_I_NODEV by hand. This adds SB_I_PSEUDO.

Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Alexander Mikhalitsyn <alex@amutable.com>
Reviewed-by: Chris Down <chris@chrisdown.name>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/nullfs.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/nullfs.c b/fs/nullfs.c
index 319c2f5c5a671..2fe24cb97160e 100644
--- a/fs/nullfs.c
+++ b/fs/nullfs.c
@@ -2,6 +2,7 @@
 /* Copyright (c) 2026 Christian Brauner <brauner@kernel.org> */
 #include <linux/fs/super_types.h>
 #include <linux/fs_context.h>
+#include <linux/pseudo_fs.h>
 #include <linux/magic.h>
 #include <linux/splice.h>
 #include <linux/uio.h>
@@ -174,7 +175,7 @@ static int nullfs_init_fs_context(struct fs_context *fc)
 {
 	fc->ops		= &nullfs_fs_context_ops;
 	fc->sb_flags	|= SB_NOUSER;
-	fc->s_iflags	|= SB_I_NOEXEC | SB_I_NODEV;
+	fc_init_pseudo(fc);
 	return 0;
 }
 

-- 
2.53.0


