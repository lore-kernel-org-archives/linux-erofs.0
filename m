Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E8016074964
	for <linux-erofs@archiver.kernel.org>; Sat, 14 Nov 2026 13:09:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ISqS1X59
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4jRZDB5lT0z3cPx;
	Sun, 15 Nov 2026 00:07:38 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=172.234.252.31
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1794661658;
	cv=none; b=OW+hfrxMwEDucAWKLRGRVVSq1umUkebZQGw9K1rBXRaIGnSugi3+CH4v3lMp2iw5CgAAT7mhg3Zey8+25hEqgUl2fmhesS9G/9RCiR/lPv/QyI4EoTCFnvsmkWllShv6kKXAGPxcoy0KvcP5/8kCgFzAIWIRCYXWqFWzjykR/7V8PGg8VtYZ5mtOw4o9f3iYwtSJ456Izw8RPzIjezFkc+mdYwQVFrSL+Hqgf2NiCSV6/Gc5Q75Jt9Vd1I28Mx7FHv0MjVl3DidaTxTizYHz04c1TcWg+wEcfzVZRKaYPAxQBgwJOUe7loF0gofM9ZE9dfdauWEhSL7pTVM7Zgvd5A==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1794661658; c=relaxed/relaxed;
	bh=++ggQwwawp+5fpIFwG3B4KdeRqD55EsEpWBb7WM/wus=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=UghXselJJp8X0CkyOa7tBdpAq/P+2PybH/eXlpu9Z4Ir0wWQraafVBedi9KKPo997xxhFQd68RqYrzqKAI0O6H9LtQZYfO99SbcDY96gE4iS77W6mNnOtueMJ2xtaJccNU83YtJYD0QenvP1BvN3k8LjHzMBlQvg6KxIlJ8DyfPN/TR+N7rvsGI07cy+bXvdNrSStPnp+br4uD9DCOQ+yO82MLAIDhR9ytAvFpvVUlsSn+f/Sb92qmpEsGQNzFRChRcJZbRCHnh5CEsTQJcHjtrr5erOSPWMxTLK5xQ3XSAWRNM+yucxLwpj4PkOWt1gOLB/rlE6mMCO2KKYrge2cw==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ISqS1X59; dkim-atps=neutral; spf=pass (client-ip=172.234.252.31; helo=sea.source.kernel.org; envelope-from=brauner@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ISqS1X59;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=172.234.252.31; helo=sea.source.kernel.org; envelope-from=brauner@kernel.org; receiver=lists.ozlabs.org)
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4jRZDB22W2z3cPp;
	Sun, 15 Nov 2026 00:07:38 +1100 (AEDT)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C2CCE464D4;
	Sat, 14 Nov 2026 13:07:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C6731F000C7;
	Sat, 14 Nov 2026 13:07:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794661656;
	bh=++ggQwwawp+5fpIFwG3B4KdeRqD55EsEpWBb7WM/wus=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=ISqS1X59OqSfExtxsOiSjr1wpv0Z7FsnoV/unXwmI2iC0oAeE1CZBnUm2rpLbQChY
	 UlVbIerFORk8Me/5GU683vDPV9tRnmC60uPE2FjWgnWj28UM6HQcw92GM6dJnxpsla
	 EP0uXvdgCUnVRc67H/T1UGcUcSsgA+crZYnm8xvt2wJzIa3kLO4Fm6nJf9PjOQCsNv
	 FSz8gs4T9BgUNPq3f8HpnSRTAiJYTu/lTuBvbPvos8+G1tK0oFpzC1YL2EUS2ey9zn
	 SEWINxYSWGGXxTx69tavZlufHiP8xSylFop7fahaOM11VSh8OruW5Bhgixy7FFv+V+
	 ODZZedD26ol2g==
From: Christian Brauner <brauner@kernel.org>
Date: Sat, 14 Nov 2026 14:01:58 +0100
Subject: [PATCH RFC v2 17/42] securityfs: use fc_init_pseudo()
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
Message-Id: <20261114-work-loop-pseudo-v2-17-98639a2286fb@kernel.org>
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
 "Christian Brauner (Amutable)" <brauner@kernel.org>, 
 Alexander Mikhalitsyn <alex@amutable.com>
X-Mailer: b4 0.17-dev-ce4c1
X-Developer-Signature: v=1; a=openpgp-sha256; l=1094; i=brauner@kernel.org;
 h=from:subject:message-id; bh=FF9e/eJ7LhW9MgInOaUNZ5e/JVsIh5RgAJXPuTh0Dg8=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWT9iKnMnrLSQPUw2yXBp68+bj4dIDU/cEGPtJHXzrJlj
 K0vlnZd7ShlYRDjYpAVU2RxaDcJl1vOU7HZKFMDZg4rE8gQBi5OAZhIwjxGhufubMVtdsLcrI83
 V3z50Gdhay43R1RMqFp4dcnRaZXmXYwMLWe+THc1O5jMduZaU5272ykVxUsi197p3xOIjl0gESb
 NCAA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Initialize securityfs as a pseudo filesystem. This raises SB_I_PSEUDO and
also SB_I_NOEXEC and SB_I_NODEV. securityfs never holds executables or
device nodes.

AppArmor puts a .null device node into securityfs but only ever opens
it via dentry_open() which doesn't care about SB_I_NODEV.

Reviewed-by: Alexander Mikhalitsyn <alex@amutable.com>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 security/inode.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/security/inode.c b/security/inode.c
index 0804023676741..93997a9f16fcb 100644
--- a/security/inode.c
+++ b/security/inode.c
@@ -14,6 +14,7 @@
 #include <linux/kobject.h>
 #include <linux/fs.h>
 #include <linux/fs_context.h>
+#include <linux/pseudo_fs.h>
 #include <linux/mount.h>
 #include <linux/pagemap.h>
 #include <linux/init.h>
@@ -64,6 +65,7 @@ static const struct fs_context_operations securityfs_context_ops = {
 
 static int securityfs_init_fs_context(struct fs_context *fc)
 {
+	fc_init_pseudo(fc);
 	fc->ops = &securityfs_context_ops;
 	return 0;
 }

-- 
2.53.0


