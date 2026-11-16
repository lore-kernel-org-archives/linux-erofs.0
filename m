Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0F6E606BD17
	for <linux-erofs@archiver.kernel.org>; Mon, 16 Nov 2026 11:08:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=g2frNxrg
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4jSlSd4Sbtz3bkb;
	Mon, 16 Nov 2026 22:07:29 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=172.234.252.31
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1794827249;
	cv=none; b=Jz2PBxWiZ35mgiJNhqRyl763r6T1J0IWW2N6c9Lm6d3EV+IklvlN68Dipicshjk3Vw07zY5nbIHZYK5Gse2TjpbsGO+KWKvr4N1qO5lJtWEkhObVYCPykjcjIb1tUYA002PzPiHnvAg9p7gSFO4i/c+pwDXTz5nfEaXbX051eP91/GrpgQFrt0diKBfRHSzCkXoHR33XCdumd5FTz1Vj8q1rNweb2s0NBl3ffEa9ykvivWEs9hdnVTEo1C7KwAXg8P6N0oAbAkOfU750yX6sAy9++lIQ9LIUZ2oCHxtVZSVQY9h/Ujfaiedpc9eElHRPgCWmf9L1SBZcwa9oyZFC6A==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1794827249; c=relaxed/relaxed;
	bh=WqIZi0cu6VIwI+9lCXiohYR/wzGXA5+EoTR/jNdb16Q=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=d9d/WCSXfxNVKKe/TPXUj5lW7mOlNZV6LW0PYvklUWF2u9d9wvwP1Nd7IvSgZu+WmYjxgcDO0YkBot8GcKOx9QfAqdLLPPsDFcoh//K/cI1HAS1JAxQMZapbncpoZzd703T6oxdoN8uI/nDtrSxdFUbOkQw8JEbAthYcIbLLWA3GDV52lUUqfW6AXDVRm3bb7tK3muNd/fTKxmA7smSJ3vIQlj4G/foZoHuynXJat9T+I81ABU89HlFYkLnsu6pHH8jhW7+BgBdYzwalcWjOJpeFrRGLLsBNA8qgeTP3no3UL4L8QweK5jHzORuX5VdVj8cac6K5tc1053E9v8XMcg==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=g2frNxrg; dkim-atps=neutral; spf=pass (client-ip=172.234.252.31; helo=sea.source.kernel.org; envelope-from=brauner@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=g2frNxrg;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=172.234.252.31; helo=sea.source.kernel.org; envelope-from=brauner@kernel.org; receiver=lists.ozlabs.org)
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4jSlSd0hHPz30RN;
	Mon, 16 Nov 2026 22:07:29 +1100 (AEDT)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8994441B60;
	Mon, 16 Nov 2026 11:07:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEB291F000C4;
	Mon, 16 Nov 2026 11:07:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794827247;
	bh=WqIZi0cu6VIwI+9lCXiohYR/wzGXA5+EoTR/jNdb16Q=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=g2frNxrgZo6gLuMwR6+xhSzuQz+NeN4PVS9PDKJxwGORwkeyKjneTNcs+fOXdfC0l
	 RiANOUi2u3Nw9Vjt5yQENMMlt2EbmVD9lpUujX88ZtQwjdWgVyUWDOMyPVuk5v+kdF
	 5NNRbJZ5dMlswOWW1+VX2aiKkmFocxNzYdlRCv3rX+6xwPv1g4Qcuh+KqAzxmlSL2Y
	 D19MD06Zt7l/6/v1MV+tZrtsA5OEEdLYhuFnRi6vP/WLBwDKdf40fkzIDuPnjMz8xR
	 dzG1nGsc0L2M0llokOCNc/BbiBjwr0VV5fECKZc6IdgZGS5W+/CRlryJSKAc4ThDZ7
	 GHqrx5WtpvCCA==
From: Christian Brauner <brauner@kernel.org>
Date: Mon, 16 Nov 2026 12:04:44 +0100
Subject: [PATCH RFC v3 11/44] failfs: use fc_init_pseudo()
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
Message-Id: <20261116-work-loop-pseudo-v3-11-8cbbea1cf34f@kernel.org>
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
 Chris Down <chris@chrisdown.name>
X-Mailer: b4 0.17-dev-ce4c1
X-Developer-Signature: v=1; a=openpgp-sha256; l=1012; i=brauner@kernel.org;
 h=from:subject:message-id; bh=iq4zyAUpqzVmiSNBanL4il/lHhHkqTjKQJsO807AsZU=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWT9epytN2PB6sVPK4Ls46WOb9KbO+HDinbZW+LiVx6qS
 0YIPZzp0lHKwiDGxSArpsji0G4SLrecp2KzUaYGzBxWJpAhDFycAjAR5wJGho/Kk16y/xT/9GVr
 hPf6HXuyP0gtWSXm85b71oS8V53MAvKMDOtOs7GW7A+SE/Hk3mjdNMUzMG3LLqvcy41pByWaLmw
 u4AQA
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
Reviewed-by: Chris Down <chris@chrisdown.name>
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


