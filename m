Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6844A60A6F44
	for <linux-erofs@archiver.kernel.org>; Mon, 16 Nov 2026 11:10:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BELkQgA+
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4jSlVg2Mp7z3cPq;
	Mon, 16 Nov 2026 22:09:15 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2600:3c0a:e001:78e:0:1991:8:25"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1794827355;
	cv=none; b=aQrTlJc2gQ5n3TGAPAj9v2U+HkH9bM1zWKkAVFxedCyLxU43BLZHR3WH04AmmMT5toEF6ev3HY+HII6DROf3q8YJI4WrEU0TodkY/T66ds5T1le4E/PQmDjTWoBgHfaeQucMP0336Jt6WOaZ/gY4JBVsrFwJDDz/c5zLzWhjhTUkVcwvWbhCw4VHUoU92e4grODU5xz7kjjzcXX84JJ2QGnAjRTH4c+BtpZvd8UKyRrdddKWppFWxXEZspoF82NKSpAeSvhCyn5CpMyo3rkzbiyUE2GiuN8pH9J1j6VQA72k2q90l41a/de4Kmi6/Z4d+2wROyKDsrJBg7cVL9J+fA==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1794827355; c=relaxed/relaxed;
	bh=zqQjJrWkVR/wq94sPR8zCRWE0M9y3ORxEXNcQuokekg=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=XabKJTT2mo7k09JkKn3lZiclwi7jtaK+0lGlEmTqs0T1LHzw0z/NypdE7b9t9ydyAp3FL5ZK6pd7l3OnnzeDP/QVI+mRA1jVbXllwyxAtr7S1muBWED8JofiBm8nA46H06c84E/ZnAkOcuOhq3CCoHcK8CbW4qIqm4WCgnFJ73uUKIFfCJev89xV1pUtEkHpEXAV3d22SHfMeQYfF+ZNP5/J0/9LXQNAAblwXY+Rppt0aohcYeOz0cg4e7Wgom4Ct0WBkeVzayv7Ki1zTj8zsVRijYAelenIaREUIcdgztpGuA93MnkffSuQJ45KydB69geUdZMrB2Lk7CSpTeMlMw==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BELkQgA+; dkim-atps=neutral; spf=pass (client-ip=2600:3c0a:e001:78e:0:1991:8:25; helo=sea.source.kernel.org; envelope-from=brauner@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BELkQgA+;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=2600:3c0a:e001:78e:0:1991:8:25; helo=sea.source.kernel.org; envelope-from=brauner@kernel.org; receiver=lists.ozlabs.org)
Received: from sea.source.kernel.org (sea.source.kernel.org [IPv6:2600:3c0a:e001:78e:0:1991:8:25])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4jSlVf5NTsz3cKQ;
	Mon, 16 Nov 2026 22:09:14 +1100 (AEDT)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 3F85640457;
	Mon, 16 Nov 2026 11:09:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED8211F0092B;
	Mon, 16 Nov 2026 11:09:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794827353;
	bh=zqQjJrWkVR/wq94sPR8zCRWE0M9y3ORxEXNcQuokekg=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=BELkQgA+1uhP4Yh9mY7YTRzmVX1Lt6+NxihYMNiPBnr7kADNw+IhI4iJNZo9qPEG0
	 otvwqWTd3K9hOd4IXPaoimQcgiIHh86c/pl6qJ58qQN+csCVnEbW9PlDtFNCdb/8sg
	 C0f5dm2DnFAB0E7ryhBkhEN4ByuTq2ZHxVh8CovZfQu/3ab/bryqauF8nv8lmMSpr2
	 cXY9HkSOS/eE6IVhvXbI3OnPyyB9ONBOUBa0bRSQfuj0Omm7mW25GibIsbr6SOgLKf
	 bV7Jc68+9XNGqZGg4DoS4vuA98Nss3pthAqpMpPE7+XTwcwxOHz10gzVDbOQrH1VPK
	 2VuLPWB7ZXGhw==
From: Christian Brauner <brauner@kernel.org>
Date: Mon, 16 Nov 2026 12:04:58 +0100
Subject: [PATCH RFC v3 25/44] pstore: use fc_init_pseudo()
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
Message-Id: <20261116-work-loop-pseudo-v3-25-8cbbea1cf34f@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=988; i=brauner@kernel.org;
 h=from:subject:message-id; bh=F18L4eFsLQ57uPzxhAOtLLc2F28lfm+14r18Ia/k+iY=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWT9elx9uNrhsNOttDk/Oo9/9Wm5fyW2mvmB2a3prhvLl
 PfOcBN16ChlYRDjYpAVU2RxaDcJl1vOU7HZKFMDZg4rE8gQBi5OAZjIek+GvwKyx797zJhxcr7K
 hzzhg1u3mpTerPKdujXVdJ8P5+7T6g4M/7Oy/t5WclW2T37im9i/syLTfkoh0+HUry9PxXeqXLx
 TyAMA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Initialize pstore as a pseudo filesystem. This raises SB_I_PSEUDO and
also SB_I_NOEXEC and SB_I_NODEV. pstore never holds executables or
device nodes.

Reviewed-by: Alexander Mikhalitsyn <alex@amutable.com>
Reviewed-by: Chris Down <chris@chrisdown.name>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/pstore/inode.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/pstore/inode.c b/fs/pstore/inode.c
index cf499ba727026..4658561cf90b7 100644
--- a/fs/pstore/inode.c
+++ b/fs/pstore/inode.c
@@ -18,6 +18,7 @@
 #include <linux/ramfs.h>
 #include <linux/fs_parser.h>
 #include <linux/fs_context.h>
+#include <linux/pseudo_fs.h>
 #include <linux/sched.h>
 #include <linux/magic.h>
 #include <linux/pstore.h>
@@ -491,6 +492,7 @@ static int pstore_init_fs_context(struct fs_context *fc)
 	ctx->kmsg_bytes = kmsg_bytes;
 
 	fc->fs_private = ctx;
+	fc_init_pseudo(fc);
 	fc->ops = &pstore_context_ops;
 
 	return 0;

-- 
2.53.0


