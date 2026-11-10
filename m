Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48A64606DA1A
	for <linux-erofs@archiver.kernel.org>; Tue, 10 Nov 2026 09:21:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mYHHEVUH
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4jP1Lj1YPcz3ckc;
	Tue, 10 Nov 2026 20:19:25 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2600:3c0a:e001:78e:0:1991:8:25"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1794302365;
	cv=none; b=b1MYQGpnL1JwpDd4jLY5SeBJwWh6cxiwNydYjNGBD30v3d3xhzkLH81KR6fZyBIEk9/rzfdlEEB6FDiJy+whHecQEQ3FwusrpD17E4mAc0bf564qlVEdMQ/857JBCtcTVBvw7wZ8f2YARupbN11gReia7VEQhx1YchKcl9esqBPxwKi0k4CHzby5FcYgS/e5uQi2pyFbBckq1ome/IQo8xGUnjrI+mVLtqlULtjGP3LAzjFCiOfNSWCKlOIicv4d0qH4r3woG5/6RhwRXBem3KtCcvMOPqNegW2dvrqAKc63DWOMOMkV6AoCs3i3F5yrK69kgMoFnZZGXTuPC0gMog==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1794302365; c=relaxed/relaxed;
	bh=JIdhS4jftRPy5dmxkGvzK/pMKfIiaESXVrYafcc8TvI=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=DnZAc8vEhh5hncXdpQ8XcymopDIgw79/s0uJ6Q7F92n2VbDSPvFPcYnRPtjY2RkbCpFrPq1M2XGwJegbhtR24ICSCEDKU8Hcj1/lJtTFhk93O5vBCFoo1rgOkf/2ZwbFeHBp62/q04WSDhbQ7w9oPeVzUs+DEf6v0GUVeqD7Ynle0AWEMATKVh2YZwPoM77tY+sUbd+/ZxaNOdLH6kTqeBmRfxaBoRkNbj+LO0lCC6E8/snF2IgOilwjXlptraDfe2OxYX2ewO29HaSiZksOBntjweWVtSUC0cSujjdrHH9j4N70hoPtfmUxdXHbjjQMT5QfL7PklnejxT6Nctq4Eg==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mYHHEVUH; dkim-atps=neutral; spf=pass (client-ip=2600:3c0a:e001:78e:0:1991:8:25; helo=sea.source.kernel.org; envelope-from=brauner@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mYHHEVUH;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=2600:3c0a:e001:78e:0:1991:8:25; helo=sea.source.kernel.org; envelope-from=brauner@kernel.org; receiver=lists.ozlabs.org)
Received: from sea.source.kernel.org (sea.source.kernel.org [IPv6:2600:3c0a:e001:78e:0:1991:8:25])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4jP1Lh4YYdz3ckP;
	Tue, 10 Nov 2026 20:19:24 +1100 (AEDT)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 25E2E43908;
	Tue, 10 Nov 2026 09:19:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C363E1F008A2;
	Tue, 10 Nov 2026 09:19:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794302363;
	bh=JIdhS4jftRPy5dmxkGvzK/pMKfIiaESXVrYafcc8TvI=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=mYHHEVUHk7mqBzZMRRcGK3fZI9JsYBE1ZTG0cjDKv2LFlPJXQyDrPAKc8bfKf0tGr
	 20cWdlmj2e6r9qTNntdUZ9fi9cszimzNeELmIamI9OuH+mBqpijs9/s789F34csANJ
	 fgWDE11qgNW8E9wTIgD1km9GI/swk+tLAKgjcvqUYxAEaRLAlzh/ZKAHlBj0Ky1PjG
	 0v/WkxNUgqmlKJXpJY525QsBtQhynnTkAMo0QExBKteka4qwdTE2za1SUpdJj+FcNu
	 WkR6hVqwaMbvytyvpFnjFRkLcYmdydpW0DidQOFfml4GF2k8PUvSil9bGhPenPlkb0
	 TdQ33wkV+qEig==
From: Christian Brauner <brauner@kernel.org>
Date: Tue, 10 Nov 2026 10:14:46 +0100
Subject: [PATCH RFC 30/41] powerpc/spufs: use fc_init_pseudo()
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
Message-Id: <20261110-work-loop-pseudo-v1-30-4c998976c6c7@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1159; i=brauner@kernel.org;
 h=from:subject:message-id; bh=wZMRP8kJpVwewK9De4Tzgbv2SYhdkU5PV6eswxkQBIY=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWR9erDtr+T2Qx2zP0qG7677LHLr7pKfRQf+MM64HrclZ
 SuL9FO7KR2lLAxiXAyyYoosDu0m4XLLeSo2G2VqwMxhZQIZwsDFKQATOWLA8IebTSHoxg9+k5c/
 HuRK8bM3/ZTN6c4W5XKTeHVB/4Zwcyojw/uS1Y6aDdePS9jN2MxSI7BiksRHOZ0gg9pTf6p5VkQ
 e4gIA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Initialize spufs as a pseudo filesystem. This raises SB_I_PSEUDO and
also SB_I_NOEXEC and SB_I_NODEV. spufs never holds executables or
device nodes.

SB_I_NOEXEC also refuses PROT_EXEC mappings. The spufs files that can
be mapped expose local store and problem state areas of the SPU,
nothing the PPU executes.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 arch/powerpc/platforms/cell/spufs/inode.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/powerpc/platforms/cell/spufs/inode.c b/arch/powerpc/platforms/cell/spufs/inode.c
index f066d9c7344d..54b45932aecd 100644
--- a/arch/powerpc/platforms/cell/spufs/inode.c
+++ b/arch/powerpc/platforms/cell/spufs/inode.c
@@ -11,6 +11,7 @@
 #include <linux/file.h>
 #include <linux/fs.h>
 #include <linux/fs_context.h>
+#include <linux/pseudo_fs.h>
 #include <linux/fs_parser.h>
 #include <linux/fsnotify.h>
 #include <linux/backing-dev.h>
@@ -741,6 +742,7 @@ static int spufs_init_fs_context(struct fs_context *fc)
 
 	fc->fs_private = ctx;
 	fc->s_fs_info = sbi;
+	fc_init_pseudo(fc);
 	fc->ops = &spufs_context_ops;
 	return 0;
 

-- 
2.53.0


