Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC0A86070535
	for <linux-erofs@archiver.kernel.org>; Sat, 14 Nov 2026 13:07:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=B5R+VehV
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4jRZCN52kHz3c9b;
	Sun, 15 Nov 2026 00:06:56 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=172.105.4.254
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1794661616;
	cv=none; b=MCCPJd4X0DYGZoEKSqlLHbnKtrDFbGFfzfKRmuEJOAQfUtzmc41lPFPHignbZBS7LuxXxF2GwSqWMwIkVaahFmcfTyf6hqiPRIcR2s8K83XE6FHVPc0JXUElyuvW+y/Ssbq9ttT6hW1RSJ2mkq9WUqAlb6mnKGdmcgviuscYoVNO5JMhYJ5gK2KwZrqmEfJ4zjvkUIR+BPuzVuvUGqH+cXtgRZbQ8PRGltgGVbiMnGsdXKkXajc5zovu/nHEtpOAtnPUM45lOz+7Xf1a0CnKs2RjfS0CCzX153hvtA+zBKvK/FAjpORFv1ypz9JsWNSntiFpFdy15pju1aBeBe8TTg==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1794661616; c=relaxed/relaxed;
	bh=8y8pXf9gqPkO0k+nFwDQgqQWegc2AhC+X3hgAZH1228=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=JM5i0FIBBd7xKpgeQHUVXTJ1b3Z94ThemouVPO845mCPB5tC3xt8M/U/QDZqu4rGy8qf5bdfnAEnGg/xy0sLNTBX/EuQrFqzrNnz3LsOGwxkqZx4ap9T3yxuMsQPQpVbTQbCGxgpzI23bS3wx6sQt7ljep3ybcLstbBPoQCJgTBH/dohpj0hCHxEKL+WLlmCSSzxp7UEKbLv+dBKk0445pll0Wd9slNJS3jBqjtX09WkgaFhT4U+DklkzDc5PTWUQW3HnIMavPfiwBg8K+3DnkGH81C9HllTmb0CDoYSmosCO0tzWcLnp17hrqSxZzqAwd/cQnnbKfVcFZ0F7SkR4A==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=B5R+VehV; dkim-atps=neutral; spf=pass (client-ip=172.105.4.254; helo=tor.source.kernel.org; envelope-from=brauner@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=B5R+VehV;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=172.105.4.254; helo=tor.source.kernel.org; envelope-from=brauner@kernel.org; receiver=lists.ozlabs.org)
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4jRZCN0sN7z3c5h;
	Sun, 15 Nov 2026 00:06:56 +1100 (AEDT)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 3DE6162735;
	Sat, 14 Nov 2026 13:06:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BBF41F000C7;
	Sat, 14 Nov 2026 13:06:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794661613;
	bh=8y8pXf9gqPkO0k+nFwDQgqQWegc2AhC+X3hgAZH1228=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=B5R+VehVMngHGkPJ+s+XCxCJk9zQ0LC7k6UXqHAShVZfpeoRqUg78BQ7bxRu8GlAD
	 WdMibaUsC9iUvWMP2hws/2BFYatPqexWuE9PFUYpNXfs17z8TPKaMR3KI1gjZl5Mnl
	 /Fz1BNMtpr6tKnVS4YUWMtua7imiZs/WVybR/slxP2/6c4NeMSaFbFW03UveloX83w
	 bloyxEP1CwgxzJhggCCH4avN2sqVGjEop/4+8+fo3dQ2Ct6Hy3Yk+axQFpEPcREsb7
	 6eE/CUZP2j/EJwm8/wqLSZliWiYmarFcEeb16/e8YxAeIXf5mDMA8PrhWHUlpyGftP
	 eNEzfbz2E2NXQ==
From: Christian Brauner <brauner@kernel.org>
Date: Sat, 14 Nov 2026 14:01:52 +0100
Subject: [PATCH RFC v2 11/42] failfs: use fc_init_pseudo()
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
Message-Id: <20261114-work-loop-pseudo-v2-11-98639a2286fb@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=964; i=brauner@kernel.org;
 h=from:subject:message-id; bh=+YmkYomMv7q82ZkVNjPSlbDFCXb6mSuwmV5/K0rj7TE=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWT9iClyMcjWu162797F+6nGyX7T79pU2b1sj5/HbyXVV
 j91tmRBRykLgxgXg6yYIotDu0m43HKeis1GmRowc1iZQIYwcHEKwETUFjL8j3kb8ePr+3DTG01h
 yyxksq+/uSp6i+9pjNCSuwde8WmXKDD8T53u92/NqW5mF7kOZ/1135j/K0wrXL5609X2JzskVe+
 FcwIA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Initialize failfs as a pseudo filesystem instead of raising
SB_I_NOEXEC and SB_I_NODEV by hand. This adds SB_I_PSEUDO.

Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/failfs.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/failfs.c b/fs/failfs.c
index 437cdc981c2de..f03334f361c0e 100644
--- a/fs/failfs.c
+++ b/fs/failfs.c
@@ -3,6 +3,7 @@
 #include <linux/fs.h>
 #include <linux/fs/super_types.h>
 #include <linux/fs_context.h>
+#include <linux/pseudo_fs.h>
 #include <linux/fs_struct.h>
 #include <linux/magic.h>
 #include <linux/mount.h>
@@ -132,7 +133,7 @@ static int failfs_init_fs_context(struct fs_context *fc)
 	fc->ops		= &failfs_context_ops;
 	fc->global	= true;
 	fc->sb_flags	|= SB_NOUSER;
-	fc->s_iflags	|= SB_I_NOEXEC | SB_I_NODEV;
+	fc_init_pseudo(fc);
 	return 0;
 }
 

-- 
2.53.0


