Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EA0C606C67A
	for <linux-erofs@archiver.kernel.org>; Tue, 10 Nov 2026 09:16:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=CjYzYxSG
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4jP1HQ5yJcz2yR1;
	Tue, 10 Nov 2026 20:16:34 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=172.105.4.254
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1794302194;
	cv=none; b=D8DNNnyxSRfDFMuLpyoHsF5u0Jcmv3PD6jamfbJbox0FUj8wAj5X9yJRk00RMIpof8FLpNceRvB12c8mvZjzFzMS2vT4Wjj5hgiipBDzOYuGGpaeQaqR4G66Tb6UjDf0iW2rOgnAYG2+lLR3o3pSYgAybC4zX17PJR5NZhhaEwxuEWeSrr4T7HI4pgdq5XrTcF2GWAvxB97o3QXSurlpq7SfsOBFMzoCZ/jZn2FkWx4zQmGi+GV/kT+wNgeODgG9pAd3eUtytHHVkkhgmqvg8GqDwsWJwvUeBjIWPKXPmiwJAyLfl4Leb7/KcIIwpkAT9L5+0dpyc8hDKyFkTFGCtg==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1794302194; c=relaxed/relaxed;
	bh=eGG9W0yWfKzRivIQZoE53ERZFH3qHATHiSAlm/rfViI=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=JQqr/bCzs//hD7eTa3ncHozVBCG79B3Ytq+SdYKdRMQwkuScu/ivlfSrU7aRbtJPm2+JDWAM31ZWEDv8HjT0IUOUIFnVS65n5LfU9hgezg4z34p8FuE1oNO7hgjVttv1M1gyyIA7/CTlBrL7v+DrFMzmfRymDUTu/clvbovdJhcwsEgKWfW809kGJY0Pi/zPdIBzWpfPEUDxcyOykMvMpl7j2v8IS/AxaX//TpAu5tLCagA7qnA4jKc4bSdW5U4jROXfI+xkGsZoRYnns/wRfOQ3r1gvGrXCOxsmlggdaPYIFr729T30VjirS+xXSZq1Iwhlp7zKNSNufgnJP1OpcQ==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=CjYzYxSG; dkim-atps=neutral; spf=pass (client-ip=172.105.4.254; helo=tor.source.kernel.org; envelope-from=brauner@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=CjYzYxSG;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=172.105.4.254; helo=tor.source.kernel.org; envelope-from=brauner@kernel.org; receiver=lists.ozlabs.org)
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4jP1HP6w5mz2xfK;
	Tue, 10 Nov 2026 20:16:33 +1100 (AEDT)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 1686F611CD;
	Tue, 10 Nov 2026 09:16:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8126C1F00902;
	Tue, 10 Nov 2026 09:16:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794302191;
	bh=eGG9W0yWfKzRivIQZoE53ERZFH3qHATHiSAlm/rfViI=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=CjYzYxSG4MF/PYOuhfPotw8YsrgHpqEMmvVsealc1nZYA5sYB8ePEA/BT0law6L4c
	 H4DwOy7PJ6PWOuylSpgYpzMq2zQGYiIT8+FEalpf9CzWwtAbdti5C3COkrTAoZVyOC
	 98zYnncAcJul/uKitX7mc2xPlqIIYPds4N05d66Wgi6oSv9azb1TV2yyF+MJgyG+uT
	 +q4Aq0251HvqT0ZVS0wHPkEhV8CPEhOZQuBNIukUVbH00aNshGt3HqKek36mnvJebH
	 4omkN8WkJOC0ohRp48kohw45G0TEI0wyMWnb2yC/I1jgI5cFhMlDgFavrTXU4YWzSj
	 7d78+YdkJ4mOA==
From: Christian Brauner <brauner@kernel.org>
Date: Tue, 10 Nov 2026 10:14:21 +0100
Subject: [PATCH RFC 05/41] kernfs: use fc_init_pseudo()
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
Message-Id: <20261110-work-loop-pseudo-v1-5-4c998976c6c7@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1308; i=brauner@kernel.org;
 h=from:subject:message-id; bh=oxvnYqP+iDvCdTKHYHpfovNIFRCjsigYBDc/6gG4KoE=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWR9ejDzzd/Z9nGXbsVbBqjycnSqNVW8nKT5dary583xR
 9dNDt3g2VHKwiDGxSArpsji0G4SLrecp2KzUaYGzBxWJpAhDFycAjCRjaGMDOv3/hK7rKMoLKFw
 cJvq3Wdf7eI+x+zYPCvtnPsBx+pD2VMYGd6l2F1wrJl6IHntnnLtfb/v/1wpEWL5tkZ74nuPD8z
 fDFkB
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Initialize all kernfs based filesystems as pseudo filesystems in
kernfs_get_tree() instead of raising SB_I_NOEXEC and SB_I_NODEV by hand
in kernfs_fill_super(). This adds SB_I_PSEUDO for sysfs, cgroupfs and
resctrl.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/kernfs/mount.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/kernfs/mount.c b/fs/kernfs/mount.c
index a0be784bfb06..6b60d212b003 100644
--- a/fs/kernfs/mount.c
+++ b/fs/kernfs/mount.c
@@ -8,6 +8,7 @@
  */
 
 #include <linux/fs.h>
+#include <linux/pseudo_fs.h>
 #include <linux/mount.h>
 #include <linux/init.h>
 #include <linux/magic.h>
@@ -298,8 +299,6 @@ static int kernfs_fill_super(struct super_block *sb, struct kernfs_fs_context *k
 	struct dentry *root;
 
 	info->sb = sb;
-	/* Userspace would break if executables or devices appear on sysfs */
-	sb->s_iflags |= SB_I_NOEXEC | SB_I_NODEV;
 	sb->s_blocksize = PAGE_SIZE;
 	sb->s_blocksize_bits = PAGE_SHIFT;
 	sb->s_magic = kfc->magic;
@@ -388,6 +387,7 @@ int kernfs_get_tree(struct fs_context *fc)
 	info->ns = kfc->ns_tag;
 	INIT_LIST_HEAD(&info->node);
 
+	fc_init_pseudo(fc);
 	fc->s_fs_info = info;
 	sb = sget_fc(fc, kernfs_test_super, kernfs_set_super);
 	if (IS_ERR(sb))

-- 
2.53.0


