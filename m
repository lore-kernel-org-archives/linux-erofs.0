Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DF54606A332
	for <linux-erofs@archiver.kernel.org>; Sat, 14 Nov 2026 13:11:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=S1xIy3Kr
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4jRZG51C4Pz3dWC;
	Sun, 15 Nov 2026 00:09:17 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=172.234.252.31
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1794661757;
	cv=none; b=SkwE4hgBSGSwHcOPk94y45fRNwDNpMJBHpR3R05o3KLxxnUq8J+0s80Bbqqqe2nXkcDwSnlUHe5kj1QGv22E995WMsr88NXhI/sgXcf4l5lfQ6gWudavMItPSw0Nt5wWTJhRQ9UwgTyJ8QeRZ99Q8S1Xp5/eg4rS6PT/jWL66Ri+9aTLiQgfJ82tJ6sPt+WMT/IwUy2dFfY5ufwX4hdTiboAqxJoBoY46OD848u+kXZm/uX3iPQv0wvfq57JMkRji2xyJs7hw0L5amT9LUmRnvl52lv1xNITFFIN6PJPtKDzuXaHyDl1FufCgiyjc0NgbdGK7mfzF2urpB9J43Qg0g==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1794661757; c=relaxed/relaxed;
	bh=Wp6UiJ6JxspVcAI8vmdp5Pu91b6oGaOfKwkx6Df5sII=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=P3Kn53cORzMyUi7q7W1E6WIn5lH2nakHeDzjr0xGya/KlxI6Ssplb+KGkulKRy+oSZpKRrA+qpEhpk9HS4z8h+Wjm7A7c+J941ry97f9tqQRAXZROXORHXYWCyQO5Io3D84Q3a/sGDZDifGT+CJhZXdsuGOKLavsFsnHxWT7MPIOQBpP2H7EbugcZc8KaR62Pb4OsUB0HEzz1WwAPVUOZ+Bh62j5/QJvNDQjFUACVWD9atf7+cWuHOOQh61LZ8P1VQGSrTs/MhAXDxMwFKgc0iHpcgDe0I+qywuFTPwYuAbgunL1od9Cccdpb3bi2bkhP8fxKGkeWNJiOLa7IA/VQw==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=S1xIy3Kr; dkim-atps=neutral; spf=pass (client-ip=172.234.252.31; helo=sea.source.kernel.org; envelope-from=brauner@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=S1xIy3Kr;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=172.234.252.31; helo=sea.source.kernel.org; envelope-from=brauner@kernel.org; receiver=lists.ozlabs.org)
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4jRZG44H40z3dW9;
	Sun, 15 Nov 2026 00:09:16 +1100 (AEDT)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 1150A44DE7;
	Sat, 14 Nov 2026 13:09:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6EAE1F000C6;
	Sat, 14 Nov 2026 13:09:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794661755;
	bh=Wp6UiJ6JxspVcAI8vmdp5Pu91b6oGaOfKwkx6Df5sII=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=S1xIy3KriPdoEMTc9dfCxcd8nJZzA6/xLqEC9Ek691tlamme55qJphgP6kTqiLd8a
	 gyYuU7lALuiqsRc4AVPgbXVJK+NhDA4+7zujFjgM6QpBfN5IckM0YEqdbXktr/nw+h
	 Lnumd0/GdHt+C2cs+wHroPF9ZZbqkOvPvOycnwePXHaTKKv61dbwr0kOr8R12Yy/jy
	 TYX37go2jAbTDcgIHhVHfyn/x159FhwjUbvk3VQiFEIoyIL4VPg8k6GDEkPS6GbBRx
	 Ui3KnXYZa0I+MODr9/kXlFNPNu8LZjXuuuvEb5jTNLwqAqpbCB3xy60OP18fpqthQb
	 IPWYjaZ1+0aPw==
From: Christian Brauner <brauner@kernel.org>
Date: Sat, 14 Nov 2026 14:02:12 +0100
Subject: [PATCH RFC v2 31/42] usb: gadget: f_fs: use fc_init_pseudo()
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
Message-Id: <20261114-work-loop-pseudo-v2-31-98639a2286fb@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=957; i=brauner@kernel.org;
 h=from:subject:message-id; bh=FyQs9iBDL23rPU6G39Bge4Pz9tDFD7sQ36KmSfY2Fy4=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWT9iOks7Sk79l9iocNp1bT+iXKvo16xtz4Sff5U18j3x
 bKqSoVtHaUsDGJcDLJiiiwO7Sbhcst5KjYbZWrAzGFlAhnCwMUpABNhm8PwT/HM2d+nJ4VPen1g
 xROh7Qu3d08LePFy7v6VZ58HB2m7M05hZPgQxrBA0Vj22KJ71q0c77YLbm9fvFXYWin18eItfPY
 MCcwA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Initialize functionfs as a pseudo filesystem. This raises SB_I_PSEUDO and
also SB_I_NOEXEC and SB_I_NODEV. functionfs never holds executables or
device nodes.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 drivers/usb/gadget/function/f_fs.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/usb/gadget/function/f_fs.c b/drivers/usb/gadget/function/f_fs.c
index c64a268e98a43..a6b3788399a56 100644
--- a/drivers/usb/gadget/function/f_fs.c
+++ b/drivers/usb/gadget/function/f_fs.c
@@ -15,6 +15,7 @@
 /* #define VERBOSE_DEBUG */
 
 #include <linux/blkdev.h>
+#include <linux/pseudo_fs.h>
 #include <linux/dma-buf.h>
 #include <linux/dma-fence.h>
 #include <linux/dma-resv.h>
@@ -2166,6 +2167,7 @@ static int ffs_fs_init_fs_context(struct fs_context *fc)
 	ctx->no_disconnect = false;
 
 	fc->fs_private = ctx;
+	fc_init_pseudo(fc);
 	fc->ops = &ffs_fs_context_ops;
 	return 0;
 }

-- 
2.53.0


