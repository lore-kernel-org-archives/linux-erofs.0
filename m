Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B135606A9BB
	for <linux-erofs@archiver.kernel.org>; Tue, 10 Nov 2026 09:17:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BW8cSBu5
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4jP1J50qfGz30V0;
	Tue, 10 Nov 2026 20:17:09 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2600:3c04:e001:324:0:1991:8:25"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1794302229;
	cv=none; b=klcPLu6Z+6CdcKs7ZeNXaZncBU0pkX5e9rBul9DgG9W5soo5yTCiacdlR3rRFRWOVAIiNsE7EU0ASk4042RGZaL5LEkh+Wjgxy5wZxjtYRBOqScZTUhAawgZZn+oTwpOlGqOjw9CB86UpNpnBCOAkoXmr6IvGUSD9QBcoubfORrs0vJgTcymrlZBg9vQ2HfPPhXRAoeAhrJBkxYUNiBMKA61EqCpkVKuaBUcb5/kfnMzlHYDCX5vYXBjbxLYljYWhXOAUPEN0BExpVnW+UcZ+SIX9+LDYta2cIOchaVBYNpR8eHjX8/kNkoHSJnadyOxF65FggAKUy6KHeWjRHh+0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1794302229; c=relaxed/relaxed;
	bh=ZmsVWE65gHf0tYCZOotZ2fbgGfTg77o991kqs+Fgm8I=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=mI1Dc8HJrrLbSKVGeJtb/nCACfXlVEfTw4NxOkHlrACmLNodP/ovPTDpAMRFLWuKBu0CC6poYJ4/LhiDt7ZRC0i+Udlh7wG+jkeqMt+zn7nvli4Pjrpoinv8h1mYsrwCSv1pBQ7uLJBjgl/h8is5+YB7oqxSR1quzK298DkOLZpB9DVOQ0+MlkdwSiv68J+bxoU9WinMTqm9JKwQUL0wtD0gGXkBCYc3/03BHmY6QtyFp/X/1CkdgNQHf7zFsl2vs0hJUvpl76dUAVx4y81xvmqypjViY623hvZbWloEPFbqYdPDPMNgwR3ACpuhQ6mdPUyBoAQ7/fAdwZhOX7VU7w==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BW8cSBu5; dkim-atps=neutral; spf=pass (client-ip=2600:3c04:e001:324:0:1991:8:25; helo=tor.source.kernel.org; envelope-from=brauner@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BW8cSBu5;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=2600:3c04:e001:324:0:1991:8:25; helo=tor.source.kernel.org; envelope-from=brauner@kernel.org; receiver=lists.ozlabs.org)
Received: from tor.source.kernel.org (tor.source.kernel.org [IPv6:2600:3c04:e001:324:0:1991:8:25])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4jP1J42xnYz308H;
	Tue, 10 Nov 2026 20:17:08 +1100 (AEDT)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 5851463803;
	Tue, 10 Nov 2026 09:17:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 977E81F008A3;
	Tue, 10 Nov 2026 09:16:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794302226;
	bh=ZmsVWE65gHf0tYCZOotZ2fbgGfTg77o991kqs+Fgm8I=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=BW8cSBu5u5r410tEcT+zMEpXHphJlFpdpAvRKAvEiKkqyi0xID6vk2b0Tbjr4F3K7
	 awaBsefdY+MBphndwr9KbPvoSGcCvsFqAgttwi2fLxH3+R18Qt4275it2lfQHkFKW3
	 UWJSti38mAmdmLS3tX3vRlC5H3kzbz/lg2YywjKPfSIrMY163nLZvxRzgh12Gfu740
	 fCVYcWuwLy19s6iKyC6ZAEcLuBFbK0G08kyGDUPlYe/7HLPPSEk9rvbQ36ZpaFxa7H
	 vhskSHci2E1kOmUw3DCi+DzAu6HlXgBa1yUahbo2TZ2iHpM1c2csxa56tO5nlkWHht
	 owe5/3f9zcJNw==
From: Christian Brauner <brauner@kernel.org>
Date: Tue, 10 Nov 2026 10:14:26 +0100
Subject: [PATCH RFC 10/41] nullfs: use fc_init_pseudo()
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
Message-Id: <20261110-work-loop-pseudo-v1-10-4c998976c6c7@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=901; i=brauner@kernel.org;
 h=from:subject:message-id; bh=sE5h4xDpaVEC2u2QAThbBNjL9uzfl1yRVOrJAX0MUt4=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWR9ejD//EYdt1/rJsiFfvkoZ/8qOqx4q8M6HwH1m6/ZZ
 AI224nydZSyMIhxMciKKbI4tJuEyy3nqdhslKkBM4eVCWQIAxenAEykdCnDPxurz9VH1LyPmPhq
 vwyuY532xsvTcZ32qt+q1sFHglVuuzD8D18Z213yU2Sl5aU3uX8PWyTKlr/7O0218syUZaL+TwX
 WcgEA
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

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/nullfs.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/nullfs.c b/fs/nullfs.c
index 319c2f5c5a67..2fe24cb97160 100644
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


