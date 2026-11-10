Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE2D660792F7
	for <linux-erofs@archiver.kernel.org>; Tue, 10 Nov 2026 09:19:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=n/nPEmY/
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4jP1KW2gmWz3cFD;
	Tue, 10 Nov 2026 20:18:23 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=172.234.252.31
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1794302303;
	cv=none; b=ftXMplT42nUqpS2DL5NXjsBsA+Gfx3kB4llE9uZcrGVLkBnW1GpRNygy3HICP0h1SJZQjaAC352fRkr5RSvSW3gzc3Vl8k1EKgZsLEGxF+d0QgyKSX1Et9CIQRR1e6v6NCfN1wG11yU7jiw10owR3/+n75rUauPd/i88DNip/ihHLNFqygbcUkm8NN3aOVKecCp7db0eJG9y8vfbsvEArGG2ztQ98golmQZCPWiR5eXpXTXiCwsnOwhF6yKzVvb9joznXqjbFb25sXzSpS1Islj0t54tHNkcUgpz3To1f1OhqJoZF7huLw9N0eNjwTuDksw21b1BB4rtWidb7f+XMQ==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1794302303; c=relaxed/relaxed;
	bh=6xLCAE1ljQwjM/z7WMvrquNwq7v8NRQjtdpUDUMIMgw=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=ZM70Ze1d+v2ni/xvT0A04GYfiBUdRavennyd9gBuKV4lGbg/TgAwQLsuGJcDU3tUcE0yzH6nsFTtO5g6JGLH65ZZKKCLS1zmvBFQ5oQfyEANhQqOv6pWv8dpchxeOk+vmf3Wbd8lCA0Tr8orHAx6PE1mcXNgNAA9bAJq1YVye/NT/j/tQoJDPW+eQHXrKODdZE8lQ7i8b6iseBKdfMmLPHGwbNbGELomeQIFG/+nujpjA0WrvYGHa5PamDA+Rb+Z1JOsZ6TTr7+XebhVWP8OOuE1ANwVxr7jnsneOk2rHKMmyJSMi0EBbFPKV4atnuBE/WyjUklS8zXmFl/LkJnrQQ==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=n/nPEmY/; dkim-atps=neutral; spf=pass (client-ip=172.234.252.31; helo=sea.source.kernel.org; envelope-from=brauner@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=n/nPEmY/;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=172.234.252.31; helo=sea.source.kernel.org; envelope-from=brauner@kernel.org; receiver=lists.ozlabs.org)
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4jP1KV5JWNz2yD8;
	Tue, 10 Nov 2026 20:18:22 +1100 (AEDT)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 3F65C42BA9;
	Tue, 10 Nov 2026 09:18:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99DB51F008A2;
	Tue, 10 Nov 2026 09:18:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794302301;
	bh=6xLCAE1ljQwjM/z7WMvrquNwq7v8NRQjtdpUDUMIMgw=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=n/nPEmY/gv4mqB2kXaUIe0isVNNuSFYe4ifWdFJtsRhYXSoI1dEqHjcK8jXDbyzkv
	 ertikRvZXtvN4JZinzjTGl2V2W3t61CK19ISiQm4xZZKjvx6Ilozk7a062A5tyZVek
	 8ONpx6cO+b1cP6f1iIgOK2yxVMDe8jOAVqYq0can3XlRZqUYI7Gp3FGNtEvO8RVw/T
	 f+noE3Lf2FKsSSXSy3unTl1hqIHTI1UMmGoV2c8K2q9ES1gzqhEiirejgIGUZm9nYu
	 NqYxgSkqeO0i1tDzYYX2q1T4FJPsyVEQu1wNublFH2+PjjrVHGb4S/n5iQ5M/xLuTU
	 IGfiSO/ynwQJA==
From: Christian Brauner <brauner@kernel.org>
Date: Tue, 10 Nov 2026 10:14:37 +0100
Subject: [PATCH RFC 21/41] nfsd: use fc_init_pseudo()
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
Message-Id: <20261110-work-loop-pseudo-v1-21-4c998976c6c7@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=896; i=brauner@kernel.org;
 h=from:subject:message-id; bh=O9QykJ0fSa/ei9QzD3DZ9rjO12HqESJ46S14fhxCm3g=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWR9erBm2RVdl2pllcvx587P2/2Nj+HEnjubhYUvT5nG7
 rQvYfmalR2lLAxiXAyyYoosDu0m4XLLeSo2G2VqwMxhZQIZwsDFKQATSZVjZOiTVZZ9M+fcLevt
 JuW1WT9C9YytitQ/n2YJq0v/vW9H2Q5Ghh08Evn7XH9MsUgMSb9yk5f97OVSvTP7v7PqSMtvTvm
 Tyg4A
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Initialize the nfsd filesystem as a pseudo filesystem. This raises
SB_I_PSEUDO and also SB_I_NOEXEC and SB_I_NODEV. It never holds
executables or device nodes.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/nfsd/nfsctl.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/nfsd/nfsctl.c b/fs/nfsd/nfsctl.c
index f32311f2d7cf..ce2666deddbd 100644
--- a/fs/nfsd/nfsctl.c
+++ b/fs/nfsd/nfsctl.c
@@ -9,6 +9,7 @@
 #include <linux/namei.h>
 #include <linux/ctype.h>
 #include <linux/fs_context.h>
+#include <linux/pseudo_fs.h>
 
 #include <linux/sunrpc/cache.h>
 #include <linux/sunrpc/svcsock.h>
@@ -1375,6 +1376,7 @@ static int nfsd_init_fs_context(struct fs_context *fc)
 {
 	put_user_ns(fc->user_ns);
 	fc->user_ns = get_user_ns(fc->net_ns->user_ns);
+	fc_init_pseudo(fc);
 	fc->ops = &nfsd_fs_context_ops;
 	return 0;
 }

-- 
2.53.0


