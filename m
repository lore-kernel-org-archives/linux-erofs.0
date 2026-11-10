Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEDE4607696F
	for <linux-erofs@archiver.kernel.org>; Tue, 10 Nov 2026 09:19:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=dmhfQG5W
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4jP1K74Ph7z3cC5;
	Tue, 10 Nov 2026 20:18:03 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2600:3c04:e001:324:0:1991:8:25"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1794302283;
	cv=none; b=hsQgkmRvo34BXNa9LUbtZS2wdlyA0t+FH5U3Sede3uW9H/lms4omaHrVy5ewNrS1lQuN+5Ecz7s3RELNPl/rpao2Aqcb8GSgqhEQ4ZAn5OcxjwPIEnmQc2r7FjtXoQkYlEl0HTa2K4Cv//5YN7JAAfOfKa9c2tyrLHxUc5aB+bqdbSL+Y9IPhH+qFMEub+TJDCQzB8IgN1hIBp/8/62DmSEBn3QoanPLbvz8MsLiK1vniMcdsRtkcy2zGgNLZ+rF5Ed+Oj9JqvbYWVKpHQOd2bpuR/hUOuokIjHLi60pbhlHcKdNVzGUcVXB37ENS+U+2rSRo9Ex/kp73U9arHYbNA==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1794302283; c=relaxed/relaxed;
	bh=8foKI6JmuMCwlgA1vbndmP56m7vz0lsh+SJERlRxyTw=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=K2P09kq12jbRg38yV+8nksKHDIw8L/51XbNUWBNQqE7kK2uWZ6XxOnIuSq3weB95ch0jfehBFKc1pT17GZtXyHF++rQtgmK3VTjWUjGtd3gydCpThmwutO7kwY4xXFJn/4gjh/mwUXuzPf8o+BxyLMtdjYmbIiIhbXav/+YQZHTYV9clv3gHoPT2O5EUZvgzJMMQU/fCF9EPKoY04Kk0rNsYC1HBwBWsnOCgttWeuebsj+jJ5931AxcXy8evF/3UvEaK85ZUmLaNnxmPoth/1L+MctsKhonoBgwLz2jcVNn4dT1sOQqd5dHbe7mAkkz7vSjIK71i1XWj4SZfTohlAg==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=dmhfQG5W; dkim-atps=neutral; spf=pass (client-ip=2600:3c04:e001:324:0:1991:8:25; helo=tor.source.kernel.org; envelope-from=brauner@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=dmhfQG5W;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=2600:3c04:e001:324:0:1991:8:25; helo=tor.source.kernel.org; envelope-from=brauner@kernel.org; receiver=lists.ozlabs.org)
Received: from tor.source.kernel.org (tor.source.kernel.org [IPv6:2600:3c04:e001:324:0:1991:8:25])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4jP1K659NTz3c8Q;
	Tue, 10 Nov 2026 20:18:02 +1100 (AEDT)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D4C0F636E5;
	Tue, 10 Nov 2026 09:18:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D7F41F008A1;
	Tue, 10 Nov 2026 09:17:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794302280;
	bh=8foKI6JmuMCwlgA1vbndmP56m7vz0lsh+SJERlRxyTw=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=dmhfQG5Wa9F1vl+Ncla7LH9qR2Pb19MWVA960fv/qPgnC3PfvrweEc5lpNq7tg5cv
	 X5jebb+YDcv3+oNILPlH9pzpQZuHd5gXnfWtjGHFm2sCmt+GLljdrB8ed3e2EDVoxW
	 6qwLDDuejmnmabFf6S4yipLYILlMtcgi/B3PaMm2jtiYlDVjoc2AfZI3TB5b25URyB
	 9JqF6aBLQhF8lrePFMLHHrz/X2m11imH2EHUNar9GCgoanthwCkg9zDKmfEF8OQXN7
	 FbpquhbOcx9HJMB4de2od2c6Rsbmt4mVOK3tjcZbRaBQ7AHeFHK8pVFWivdn0ZmDS9
	 s18yL7iJzQ1pg==
From: Christian Brauner <brauner@kernel.org>
Date: Tue, 10 Nov 2026 10:14:34 +0100
Subject: [PATCH RFC 18/41] selinux: use fc_init_pseudo() for selinuxfs
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
Message-Id: <20261110-work-loop-pseudo-v1-18-4c998976c6c7@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1631; i=brauner@kernel.org;
 h=from:subject:message-id; bh=G6GyKhtPUuEHs5LrXzW88WAPZ6YLQCvHyquwK5OU8Mc=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWR9erCSv4OpQlCv+sKCEKYLJnl7XiQuW3g/KvNGSuDNm
 Z9Edkzu6yhlYRDjYpAVU2RxaDcJl1vOU7HZKFMDZg4rE8gQBi5OAZhIwRJGho3heV555heiU9OC
 joYteqa/h+mn21yLC5/8Vn9e8++ltjrDfz95yYxJLSHu6Y6WLBnlx5eIrDRyi2Wcy6Ybt7PmXsR
 WHgA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Initialize selinuxfs as a pseudo filesystem. This raises SB_I_PSEUDO and
SB_I_NOEXEC. selinuxfs never holds executables. SB_I_NOEXEC also
refuses PROT_EXEC mappings but the status and policy files are only
ever mapped for reading.

But selinuxfs needs device nodes. The kernel replaces file descriptors
with /sys/fs/selinux/null on exec via dentry_open() which doesn't care
about SB_I_NODEV. Android init however opens /sys/fs/selinux/null by
path as /dev/null doesn't exist yet at that point. So clear SB_I_NODEV
again in sel_fill_super().

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 security/selinux/selinuxfs.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/security/selinux/selinuxfs.c b/security/selinux/selinuxfs.c
index 310e19efff1d..d7ae853b6d68 100644
--- a/security/selinux/selinuxfs.c
+++ b/security/selinux/selinuxfs.c
@@ -18,6 +18,7 @@
 #include <linux/vmalloc.h>
 #include <linux/fs.h>
 #include <linux/fs_context.h>
+#include <linux/pseudo_fs.h>
 #include <linux/hex.h>
 #include <linux/mount.h>
 #include <linux/mutex.h>
@@ -1852,6 +1853,9 @@ static int sel_fill_super(struct super_block *sb, struct fs_context *fc)
 		/* last one */ {"", NULL, 0}
 	};
 
+	/* Android init opens the null device below by path. */
+	sb->s_iflags &= ~SB_I_NODEV;
+
 	ret = selinux_fs_info_create(sb);
 	if (ret)
 		goto err;
@@ -1955,6 +1959,7 @@ static const struct fs_context_operations sel_context_ops = {
 
 static int sel_init_fs_context(struct fs_context *fc)
 {
+	fc_init_pseudo(fc);
 	fc->ops = &sel_context_ops;
 	return 0;
 }

-- 
2.53.0


