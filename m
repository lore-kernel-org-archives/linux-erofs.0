Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA261606A339
	for <linux-erofs@archiver.kernel.org>; Mon, 16 Nov 2026 11:09:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=MAOQF/Rj
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4jSlTp1HFHz3c9Z;
	Mon, 16 Nov 2026 22:08:30 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=172.234.252.31
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1794827310;
	cv=none; b=gbvbmdsfM8QLfLI4mxSOKo3Ng+PK+DjMy009THWI/eVK9dfZRjZ3e0gO2KA7jLYMu51iw3c3aWoMJSxFnGny7xmX09wEGl9dibNzLEmKIvCBZcf0vTT+lE3lNAIem1OJx6aEO9INjpvqrRnXWg3aYX/2taMYo5vuhDpisxvay1cKcdtT9ZVvckaLTQuXNgzf/ebGBMvD5vilCe1bO5OK5eY4+4JoE/BoOHNN8Bow2TO5RE3xi6kP+qt5VHKgt/0z5NPjLk9GPpPckw47t88h/FkKn07JmyZWhbWg+bzZeCSskOGThbFsm9MjYKoH5m3rP+8OYvzy7ICjH2jpGsSdow==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1794827310; c=relaxed/relaxed;
	bh=2Wy+scJ41Y8KmYhleRQezskd7+v4uNRBlIFkKwTMVMA=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=BF79nQ1cP6FH7oZwbQFDlVKkUJ3DoVp20pfG1VcFI3UH9lgYiLREVNPtKhUgGpY5Reu1ZCUlEk3pWrjJTdVqQaE+dyzzMPxKhkfa9MYKXbO3NTl+6NCBBHik1yrKFYV9rLTOE6ODdZPqf2veHmMAbE+PqdZ3zQWlmrfdTc3SMnDvbNVLOl8DYpTqt1qLUekUQsa5Ml+grIe7Ho0MV7vlbBM4rYtOLo9PegmOnejwuBfjjR7VN5VQnSc/Qv4/hRfBFzFY3TWu5l9Qr5TP3NTNp1SN8ubiRylua9l5sqqV4ljEFy7EecVBkj7nGV1vwhYgKApRvFor+W3B6r5GXyiwfg==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=MAOQF/Rj; dkim-atps=neutral; spf=pass (client-ip=172.234.252.31; helo=sea.source.kernel.org; envelope-from=brauner@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=MAOQF/Rj;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=172.234.252.31; helo=sea.source.kernel.org; envelope-from=brauner@kernel.org; receiver=lists.ozlabs.org)
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4jSlTn4Ckrz3c9D;
	Mon, 16 Nov 2026 22:08:29 +1100 (AEDT)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 1A2D2401FA;
	Mon, 16 Nov 2026 11:08:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCA281F000C9;
	Mon, 16 Nov 2026 11:08:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794827308;
	bh=2Wy+scJ41Y8KmYhleRQezskd7+v4uNRBlIFkKwTMVMA=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=MAOQF/Rj2EJww59dNiCxumtdpBg6TrUeioHJXL/bnUNEdpUa+TL9z32jyWcX7tf9f
	 YJlPw0lXLJuN+5nu7TRB/0yUYsrayfVUWBWRn7Xag0vLZsz5NbrTs5CwrGSRxbSogs
	 P/9NyJE2TSHUN6IYMouHl5EjNy6A8TIlTWZwYwJV2xPuUnoIigJD+H7vGh9TSZyMxj
	 4DkMGGlnmERtn/y0Q7vC3yziK9l/XelDpyyOK6XcWMfJfoaMe2RgysYQszYJSpfAbK
	 at3Nt4liC7nM7DMOWTOI39ukPd66Pb8dTLPpdP5tvFSKmeh82o41oMaYOJ0Z8Ld/8g
	 6mMsCjtcCJIUw==
From: Christian Brauner <brauner@kernel.org>
Date: Mon, 16 Nov 2026 12:04:52 +0100
Subject: [PATCH RFC v3 19/44] smack: use fc_init_pseudo() for smackfs
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
Message-Id: <20261116-work-loop-pseudo-v3-19-8cbbea1cf34f@kernel.org>
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
 Casey Schaufler <casey@schaufler-ca.com>, 
 Alexander Mikhalitsyn <alex@amutable.com>, 
 Chris Down <chris@chrisdown.name>
X-Mailer: b4 0.17-dev-ce4c1
X-Developer-Signature: v=1; a=openpgp-sha256; l=1063; i=brauner@kernel.org;
 h=from:subject:message-id; bh=mH75LpQDT6Rg7eXmytbmjrMu8Ad5NprhLDuRN3w7u4E=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWT9elyyYcaRBJX9njuq/Xs+e0qULvo+Ofy7yZPN3Mk2k
 V/3Pt74sqOUhUGMi0FWTJHFod0kXG45T8Vmo0wNmDmsTCBDGLg4BWAix84x/C+c8DbZ9snBwuZV
 Ot+mNXG6qCX6nmf9lubn7/zkwaWjM1gYGfavmm/06upB/mOHiw4kL0t/3hrNdDv19L7DDxzblqU
 v384EAA==
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Initialize smackfs as a pseudo filesystem. This raises SB_I_PSEUDO and
also SB_I_NOEXEC and SB_I_NODEV. smackfs never holds executables or
device nodes.

Acked-by: Casey Schaufler <casey@schaufler-ca.com>
Reviewed-by: Alexander Mikhalitsyn <alex@amutable.com>
Reviewed-by: Chris Down <chris@chrisdown.name>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 security/smack/smackfs.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/security/smack/smackfs.c b/security/smack/smackfs.c
index a72bc7fabea99..4a56bbeaeca37 100644
--- a/security/smack/smackfs.c
+++ b/security/smack/smackfs.c
@@ -25,6 +25,7 @@
 #include <linux/magic.h>
 #include <linux/mount.h>
 #include <linux/fs_context.h>
+#include <linux/pseudo_fs.h>
 #include "smack.h"
 
 #define BEBITS	(sizeof(__be32) * 8)
@@ -2880,6 +2881,7 @@ static const struct fs_context_operations smk_context_ops = {
  */
 static int smk_init_fs_context(struct fs_context *fc)
 {
+	fc_init_pseudo(fc);
 	fc->ops = &smk_context_ops;
 	return 0;
 }

-- 
2.53.0


