Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8719E606A78F
	for <linux-erofs@archiver.kernel.org>; Mon, 16 Nov 2026 11:10:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hqVGQD92
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4jSlVN4z2dz3cM8;
	Mon, 16 Nov 2026 22:09:00 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2600:3c04:e001:324:0:1991:8:25"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1794827340;
	cv=none; b=RtRejUzPGrq2fhhSYEDsS0BVWUyco43wa4DToFp12H9rF0yLq0cUfFGdHNpgTZ4BZ277LpwrgfpnSX75oupUH6htqZC0N58xW6VAjm8JOFzXvu4xr/bF6m31XAfR6ZEb3YUEdx+/+3HY7/WFCZTx+lZBaYJGiDg9W3lN3kgqzTD/nP3FkehpyQaCNoFa5mhW+ZjUivghaBsBmOvdacPGyN7kln8fv5qbEdgweSw7m1HFNOfvUESpus7lxNFSmL/hk3x0eXaxeV7GqGvgv+O5vJjZOO7SWY+K+LR+xHv6fD+yxEbjSbDJleWNWCZDYKNVVXZTH9IqnEZ2gJKYgpEAcQ==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1794827340; c=relaxed/relaxed;
	bh=ek7FYduULSVbUq5arr3ZrFc9sF73FP4dcX9AYxY+9Ag=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=K+Wy5SeAj1z8jtgDJ4kNBl8Qqcg7h0VtwR3jDqJQ7s+s/oRbyF9q07RChSLmXzoCbEb2YA/7q4huJIjkJ5cIfjEghMF+bfxFlJG/VXnt4fM4fVf08fi66GwxH8mZaf0dGpQXuOBwSAJhTRQ5FpvkE9IC+jiAXNbQeXqYQVxltfx8tqOskuR7ZcJdRfxyfIbpeGUl8SOewe6tEmBigzvPMVEC+kXuUFIA5bOZczlPA3eVU09VJhXezFUWqjPW1eh2tcJZzpFJXEsSOJoneVVf/1WoSgASNBZRchIyGS8vDhk/rTKuGPV3BtkL5pfJb3VKOTE34lVbGnpkCor/78a21g==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hqVGQD92; dkim-atps=neutral; spf=pass (client-ip=2600:3c04:e001:324:0:1991:8:25; helo=tor.source.kernel.org; envelope-from=brauner@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hqVGQD92;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=2600:3c04:e001:324:0:1991:8:25; helo=tor.source.kernel.org; envelope-from=brauner@kernel.org; receiver=lists.ozlabs.org)
Received: from tor.source.kernel.org (tor.source.kernel.org [IPv6:2600:3c04:e001:324:0:1991:8:25])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4jSlVN0kSwz3cC9;
	Mon, 16 Nov 2026 22:09:00 +1100 (AEDT)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 337C5601FA;
	Mon, 16 Nov 2026 11:08:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDB211F000C4;
	Mon, 16 Nov 2026 11:08:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794827337;
	bh=ek7FYduULSVbUq5arr3ZrFc9sF73FP4dcX9AYxY+9Ag=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=hqVGQD92ptf9qqnybXZsjl1lBXLy25LXcD3qck0h3II6D1+uj2w0UCe7AnC8yfuUK
	 DBvlP7U/ezRfWQ8Rs5suLaGriT1BSlssZ9axHhjPhAuXDlS1Y/K2QWswiS2nf0hd15
	 mgNz1M9WUrIByUmgj4LNTVaef0wBQawvbuFhB9JsfbJP+PbGz3/XCoYokswy4kK25Q
	 X2hrdX3tY06xzdGLazSIumYwZqYdKkoPSnb1hfbzQy+wt09vb/IMMve/bJQLAIa6F1
	 vAjADxJuDTMP4T1sHKG0OZOaWsM6OFV3enjzvFavLrjqm3CNNR7zTo5aWyeLsdFncs
	 cnHuExJ0EguVA==
From: Christian Brauner <brauner@kernel.org>
Date: Mon, 16 Nov 2026 12:04:56 +0100
Subject: [PATCH RFC v3 23/44] fuse: use fc_init_pseudo() for fusectl
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
Message-Id: <20261116-work-loop-pseudo-v3-23-8cbbea1cf34f@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=999; i=brauner@kernel.org;
 h=from:subject:message-id; bh=7AmoNzP4UOKW+VKhMYMUlDwuPOwZV6Om3UBU1WIAvFs=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWT9elx50rnV4OoK6YIK/Q26axukqwxsMu5p3Jl8d71vu
 a5nhWt/RykLgxgXg6yYIotDu0m43HKeis1GmRowc1iZQIYwcHEKwEQ6NRj+qb3+utWQ88yGsDn1
 fz35NzrGiu+9VZp3a+fs5gueVgtSwhj+Sh5vPv5J8uPZIynqDy8WReRO0+3vnPshjGGN0vOzJl/
 fMwAA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Initialize fusectl as a pseudo filesystem. This raises SB_I_PSEUDO and
also SB_I_NOEXEC and SB_I_NODEV. fusectl never holds executables or
device nodes.

Reviewed-by: Alexander Mikhalitsyn <alex@amutable.com>
Reviewed-by: Chris Down <chris@chrisdown.name>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/fuse/control.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/fuse/control.c b/fs/fuse/control.c
index 21ffde596d611..4497362e7df06 100644
--- a/fs/fuse/control.c
+++ b/fs/fuse/control.c
@@ -10,6 +10,7 @@
 #include <linux/init.h>
 #include <linux/module.h>
 #include <linux/fs_context.h>
+#include <linux/pseudo_fs.h>
 #include <linux/namei.h>
 
 #define FUSE_CTL_SUPER_MAGIC 0x65735543
@@ -334,6 +335,7 @@ static const struct fs_context_operations fuse_ctl_context_ops = {
 
 static int fuse_ctl_init_fs_context(struct fs_context *fsc)
 {
+	fc_init_pseudo(fsc);
 	fsc->ops = &fuse_ctl_context_ops;
 	return 0;
 }

-- 
2.53.0


