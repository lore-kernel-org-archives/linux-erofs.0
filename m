Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C433B6078860
	for <linux-erofs@archiver.kernel.org>; Tue, 10 Nov 2026 09:19:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GU5e1n38
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4jP1KN2Cvjz3cHb;
	Tue, 10 Nov 2026 20:18:16 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=172.234.252.31
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1794302296;
	cv=none; b=nRSNynvzNP98gWaqN/+UzKNo/tqYMshk3L3/8KEkU5wLZlxxA7zwz+meqUsrniQx3T67HntAMxKy0ao2dTgN5sWs1adAEL4PBmjM3yQewA+JxczAFoZPNLHzOcV1LKMRuFSLFw5lelxnE+K0CA4bZACRHh6fmOd73LTJGkjljmvCijBgklC4MXxQ8Ozz8it8V5MEMzebGpqV4ePT6g9iKYjdZD6BwNRCrFi+9F/bDik+ocfwA8Wb8rpYe7H3TxNtb8+t3eP9ro02CXLdaLV2HVjvhSMadMX/5pjyQfb6BKc4kGlOmb69+tVfHxlSXaA5PCK7pZlyQ7zgJAnvFYYY4g==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1794302296; c=relaxed/relaxed;
	bh=pmz9jtGW0ywIGdBu3NtUNt6417QseUuUlLq+Fyk/468=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=cnGLU//O60iWlloxMY6QZ6Ig4o8+HqJLVX7Z9HELfVHQm295W+vrbh6cXUFRqDrO274cJ7sKaCH5Qjr9EGR4vkPgG/dG+o8yOCZtV3U1kq7lwtfGJFVO6kxaStp7km+CnFSq18qG9cp/LC9l9HUL5xsi+zhG3Ms5LD/Ov3/z6mQ6CVJ7gHLsDeeJgxhZlk4mME7/A3ABMtaqkXWECe7IMlQpkhzUafceAXsVyFVhZUY4rOcfennf3WTGcGlQHH1LbY0mttqA5hl5T/WhUseauAcR5hEh2uW2IWEzXjgGLH7OmUR5/128fUUhxcKh94CkvepOxz4jsnt7K/MnrD1OFA==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GU5e1n38; dkim-atps=neutral; spf=pass (client-ip=172.234.252.31; helo=sea.source.kernel.org; envelope-from=brauner@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GU5e1n38;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=172.234.252.31; helo=sea.source.kernel.org; envelope-from=brauner@kernel.org; receiver=lists.ozlabs.org)
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4jP1KM5Sh3z3cFD;
	Tue, 10 Nov 2026 20:18:15 +1100 (AEDT)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 45B8340942;
	Tue, 10 Nov 2026 09:18:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE9521F008A1;
	Tue, 10 Nov 2026 09:18:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794302294;
	bh=pmz9jtGW0ywIGdBu3NtUNt6417QseUuUlLq+Fyk/468=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=GU5e1n38Lz1+Pvtlp7ASXPOHCHk1tuIpx5t08Oh+PNxIh+4HMt2Bb5r94Whq3GWlo
	 vECtZ0duG5TPPJDG1ybdWsZsjAOMuPW/Hb9SEcHwoBF8ATO9BDk3/jhbKvQrg3nc5L
	 1FQsP8KdRKjEyM/BeO40ervx/1NH/WjEJwBb2dvNJPa1GvI7Agf8ZAOGTuuFGlrw7z
	 D4QQjfoUytG04RFCySWSZrW4de4972Y7Kl9IuLxvGElxSqCx/Kci+Zh1lbu+K45JKy
	 ntgiJAxTVhCEzFNboe8IF1iAKS/5NRv9CmLgmQlqgdr6yjLdjFnSiOaCzyVTXMbBQg
	 iNtELDfUm8+4g==
From: Christian Brauner <brauner@kernel.org>
Date: Tue, 10 Nov 2026 10:14:36 +0100
Subject: [PATCH RFC 20/41] apparmor: use fc_init_pseudo() for apparmorfs
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
Message-Id: <20261110-work-loop-pseudo-v1-20-4c998976c6c7@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=975; i=brauner@kernel.org;
 h=from:subject:message-id; bh=eM74gHkw1JzhCTiSqpoG3xHbWPNk16urIeNgeqxQRac=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWR9erD6usJ7lpTrW3d7tqQWr39pN+HRX+O0+aeqRP44P
 Ht3WOOFS0cpC4MYF4OsmCKLQ7tJuNxynorNRpkaMHNYmUCGMHBxCsBFvBkZDujeP1XSFJdyYUFQ
 s2Z8R5AFc4DNtoZ3s+yre146fp5mxMjQc+SfqFrmzJ/TQj/NlTx9oGXNEve39ZbnKwSC7mx/vmg
 eJwA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Initialize apparmorfs as a pseudo filesystem. This raises SB_I_PSEUDO and
also SB_I_NOEXEC and SB_I_NODEV. apparmorfs never holds executables or
device nodes.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 security/apparmor/apparmorfs.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/security/apparmor/apparmorfs.c b/security/apparmor/apparmorfs.c
index a99366467217..351ea3a7120e 100644
--- a/security/apparmor/apparmorfs.c
+++ b/security/apparmor/apparmorfs.c
@@ -21,6 +21,7 @@
 #include <linux/rcupdate.h>
 #include <linux/fs.h>
 #include <linux/fs_context.h>
+#include <linux/pseudo_fs.h>
 #include <linux/poll.h>
 #include <linux/zstd.h>
 #include <linux/string.h>
@@ -263,6 +264,7 @@ static const struct fs_context_operations apparmorfs_context_ops = {
 
 static int apparmorfs_init_fs_context(struct fs_context *fc)
 {
+	fc_init_pseudo(fc);
 	fc->ops = &apparmorfs_context_ops;
 	return 0;
 }

-- 
2.53.0


