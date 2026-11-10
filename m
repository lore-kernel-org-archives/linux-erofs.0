Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55A23607E058
	for <linux-erofs@archiver.kernel.org>; Tue, 10 Nov 2026 09:20:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=XU5FYslU
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4jP1LJ3BgBz3cbX;
	Tue, 10 Nov 2026 20:19:04 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2600:3c0a:e001:78e:0:1991:8:25"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1794302344;
	cv=none; b=SU30cK2XZ3k1fagrIvycXHSLqZXhZgFJaLu8U97u49nvAzoyRU2e1U08zZgoU0FUrDieLg+BXGHbPTRvkj2hB+zHU8VVz1B/J6m5aXXd8Xu0fXuuQbBTWPlQFyROj8eiPFAxrO9r2URuZzOgSvaEZ5wE+Xl4vxjgpXNaboJtmWc+6LdA1QtIeh9rTInBdBki+eIf/tTCjOYeLYHIdsH2j6+8y0HnRajX5tN/EsNbqf0fRaS7FZR9JpcrbtJ8D44/H5ZkYbh2X11gpQLlrIhlJk/4dclFbJ8lyi7Yv1GDIXBgo7bQl+e0oYsFDPeAn72rxVQaJ66p62AM1IRWJRJVkQ==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1794302344; c=relaxed/relaxed;
	bh=V9O75TKfTcHeHVPMLenNiZqGn0S/SDcuL2HVenCDHeA=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=lShuO/MsfycW8Ioo6kWj8miJFyzeJjsk4IVajIMlX4/CJzRmHVLIm1ZRf2TPuwkHJPioBjPGRxQUVWVF6d0xGq5as+BI1RPbmoxMjJJUIW9iAF9NN420x1MljqV+cuOu/mntDMhmx6LbQiiShFw+BBpoNrB8Bymmncm3UqXgaS/OZDh/ePhuxHgEDZQ8Kwy4RbOZ+JztTCHe4Dd7BGFVMjDAsA0tVaMVbl2wK2drpv160QU3bCB+2UW7h9jrHJER/aYyxks9LBWbSEIEz3rqro/rWepNJ8FbJOZSex9x7zWZbPGdFqZ4Sc18shw6mEZXBERXXl54Zuw4LFU59d88AQ==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=XU5FYslU; dkim-atps=neutral; spf=pass (client-ip=2600:3c0a:e001:78e:0:1991:8:25; helo=sea.source.kernel.org; envelope-from=brauner@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=XU5FYslU;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=2600:3c0a:e001:78e:0:1991:8:25; helo=sea.source.kernel.org; envelope-from=brauner@kernel.org; receiver=lists.ozlabs.org)
Received: from sea.source.kernel.org (sea.source.kernel.org [IPv6:2600:3c0a:e001:78e:0:1991:8:25])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4jP1LH609Mz3cZQ;
	Tue, 10 Nov 2026 20:19:03 +1100 (AEDT)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 52889435BA;
	Tue, 10 Nov 2026 09:19:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D685E1F008A1;
	Tue, 10 Nov 2026 09:18:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794302342;
	bh=V9O75TKfTcHeHVPMLenNiZqGn0S/SDcuL2HVenCDHeA=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=XU5FYslUu/QycaxvYDsVfiLjksSb23n6kAsx0C4TwSSMJEdkUorbOifqhqCOqU1BZ
	 tmBnCWeUwFgQQ+4ZAkQAk/VjPzQ+RPHW3/AblZyzH50Bb47hCUnqPVxJ/GU4Mc1JiA
	 5FFUIjTt/J8XmL5z4nM4R0/u+A/O7oMn8+99R0NQQoD9YRGpBmk26SOy2wcjejpGHl
	 mr0KKFrE0VjNzX1I+Ubt/meHZXfZj8kp1B2dkcgv3kCLJkAik/ieVBt/S0jkqQRk4B
	 ZyDYntU3Wf2Vq8yKC7h12DmuYinSiJ1I+4nWRIhPcZEmr+7PkRUVFiiLnUd0MB8tP5
	 IiA+GGSFyG75Q==
From: Christian Brauner <brauner@kernel.org>
Date: Tue, 10 Nov 2026 10:14:43 +0100
Subject: [PATCH RFC 27/41] openpromfs: use fc_init_pseudo()
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
Message-Id: <20261110-work-loop-pseudo-v1-27-4c998976c6c7@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=930; i=brauner@kernel.org;
 h=from:subject:message-id; bh=HbK9i4t197PzSxP5CKS5JO7XvQ/k806ZQREmy2rg/1Q=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWR9erB5yxKrdqWdTL6/ROTOpHFZfYk8FvP4V1D53MDzH
 Vaet0xOdJSyMIhxMciKKbI4tJuEyy3nqdhslKkBM4eVCWQIAxenAEyks5eRYePLZ35LS2WzX6Wn
 +D69nf1re86D6lp5E91F/Asahdd+rGb4Z1YXc0BUZ9rZoskiB0RU3Nyq0xSNReXOZtV9XNcYHfC
 bAQA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Initialize openpromfs as a pseudo filesystem. This raises SB_I_PSEUDO and
also SB_I_NOEXEC and SB_I_NODEV. openpromfs never holds executables or
device nodes.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/openpromfs/inode.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/openpromfs/inode.c b/fs/openpromfs/inode.c
index fb8d84bdedfb..6cd02d456bac 100644
--- a/fs/openpromfs/inode.c
+++ b/fs/openpromfs/inode.c
@@ -10,6 +10,7 @@
 #include <linux/string.h>
 #include <linux/fs.h>
 #include <linux/fs_context.h>
+#include <linux/pseudo_fs.h>
 #include <linux/init.h>
 #include <linux/slab.h>
 #include <linux/seq_file.h>
@@ -419,6 +420,7 @@ static const struct fs_context_operations openpromfs_context_ops = {
 
 static int openpromfs_init_fs_context(struct fs_context *fc)
 {
+	fc_init_pseudo(fc);
 	fc->ops = &openpromfs_context_ops;
 	return 0;
 }

-- 
2.53.0


