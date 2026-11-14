Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86D00606A33E
	for <linux-erofs@archiver.kernel.org>; Sat, 14 Nov 2026 13:11:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=dlOT4YO5
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4jRZFr0lQ0z3dTC;
	Sun, 15 Nov 2026 00:09:04 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2600:3c04:e001:324:0:1991:8:25"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1794661743;
	cv=none; b=a+syUV6HFSmWigGNhXQDKwh98Fv2Y6OV6RtUy1+4k/Fi6pIQb9cq5MgxcD+lo4cQB0Ct6sJeAXYXtm7vfHFCTaBLP753YRacXgO9ZG5PlD9r1h+maypTrHIfMPB6pmGYLHzRCCG8r7U9rsc589MCcrsJENRm3i4su1JvcAhl/MeC7RN5+PQ8+IE4AehE6kk1AKS/c2hiOJwd2jUUpdG9rNBwI99RiHmr6DqWvqqkWyOc9tBZ56M+ek7Nrdn91Q2pXSbf5fOZP2cWWMPjLoIyG9y0UHSzVoiXiEB17niN+5h20e1UiSEYGgrZGcadJyp5gl7oapH/lCwNrAJUEOHiRA==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1794661743; c=relaxed/relaxed;
	bh=JUBUitc/wTfMb7cZo0KLtSOkDXoKMBIaahrb6Pvq2WU=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=Tv2O2mQ2QBDYQ6A3mUCKlgt5Y5IqCNx/w40LPHVhuTl6z8/lFffDn0sbBvD1CilE1nagayagV7+SATr852OuQG5hpRh0XpyhmeAzozHz9WRGhg/fhRUnCGhJo2p2LPlFxxDpNGtcTUBAGNlIa5uaLzLinnUTrWUWf0o6J4G3TmeYeb3t1tox4XGLjrdM1LZ/CNz9f74+xvJMjFnxS538cNZvBlMExa/xLD6mvwgL3rvNE7Qqf6uvUBvc5MJNecr73UJBBYLJko21DSzBACIcxMVPFSX5WwUuMfeJXbX6vOvcLgiXVqpVZefZSi3m/5PihB/bvSUHDt0XqCEYrVikaA==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=dlOT4YO5; dkim-atps=neutral; spf=pass (client-ip=2600:3c04:e001:324:0:1991:8:25; helo=tor.source.kernel.org; envelope-from=brauner@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=dlOT4YO5;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=2600:3c04:e001:324:0:1991:8:25; helo=tor.source.kernel.org; envelope-from=brauner@kernel.org; receiver=lists.ozlabs.org)
Received: from tor.source.kernel.org (tor.source.kernel.org [IPv6:2600:3c04:e001:324:0:1991:8:25])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4jRZFq30lKz3dT6;
	Sun, 15 Nov 2026 00:09:03 +1100 (AEDT)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 8C0996252F;
	Sat, 14 Nov 2026 13:09:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C29D71F000C4;
	Sat, 14 Nov 2026 13:08:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794661741;
	bh=JUBUitc/wTfMb7cZo0KLtSOkDXoKMBIaahrb6Pvq2WU=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=dlOT4YO5RUhq//nn1mQfQ7uOlDeSIq5sssMs038ZLPvaS/NPy8Dd9kK6JgIFD36Dz
	 pbaKu0DmFSuCCYRW1H64pQ0+m6nqqsSc1Q9h1ff9ICae4VWI86+QQlpB4OVxciYpOR
	 WS2ftQrfKT4rvIwCLZSKiVCNFlea6iSt69CtGZ7qjcOt9yahpM2SqQayK7CrApgHSF
	 /ZgQ8JKhCJKGzp6iRqEmeIMd+/DRWTit4BCmJyFLKQdTK0auEDWhyzWkLdOk7NBjOR
	 dFLtiah/d1hBHwXdufprCHe9iPnbKhpmiiCOpc4bqTjZ0cGwlKuZ9Vy7R5WvJt/oit
	 calDZWfHw6uKw==
From: Christian Brauner <brauner@kernel.org>
Date: Sat, 14 Nov 2026 14:02:10 +0100
Subject: [PATCH RFC v2 29/42] s390/hypfs: use fc_init_pseudo()
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
Message-Id: <20261114-work-loop-pseudo-v2-29-98639a2286fb@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=900; i=brauner@kernel.org;
 h=from:subject:message-id; bh=EnQ7f/LKwwXo6PyRpnVfj7bCGw1qYUMZQQO6IXtl1m0=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWT9iGnvvPFlftQB7ZsfC97+fWh+Z+EM5e8fnz6omGjy+
 1HN40e5ch2lLAxiXAyyYoosDu0m4XLLeSo2G2VqwMxhZQIZwsDFKQATidZjZFipe7RPJDUn62fQ
 /TkHXz1TvOM0nXPJoowHKhln3kV1Br9jZJiffO/flXWm6T8ffDBjOxkgvOBdhEHUvXZBZanc0td
 ivqwA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Initialize hypfs as a pseudo filesystem. This raises SB_I_PSEUDO and
also SB_I_NOEXEC and SB_I_NODEV. hypfs never holds executables or
device nodes.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 arch/s390/hypfs/inode.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/s390/hypfs/inode.c b/arch/s390/hypfs/inode.c
index 559b011e68800..8662169de477a 100644
--- a/arch/s390/hypfs/inode.c
+++ b/arch/s390/hypfs/inode.c
@@ -12,6 +12,7 @@
 #include <linux/errno.h>
 #include <linux/fs.h>
 #include <linux/fs_context.h>
+#include <linux/pseudo_fs.h>
 #include <linux/fs_parser.h>
 #include <linux/namei.h>
 #include <linux/vfs.h>
@@ -301,6 +302,7 @@ static int hypfs_init_fs_context(struct fs_context *fc)
 	sbi->gid = current_gid();
 
 	fc->s_fs_info = sbi;
+	fc_init_pseudo(fc);
 	fc->ops = &hypfs_context_ops;
 	return 0;
 }

-- 
2.53.0


