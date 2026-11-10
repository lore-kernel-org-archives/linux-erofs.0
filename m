Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA2FE6072F5C
	for <linux-erofs@archiver.kernel.org>; Tue, 10 Nov 2026 09:18:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VFBfo7hd
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4jP1JS6Q7qz3bqm;
	Tue, 10 Nov 2026 20:17:28 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2600:3c0a:e001:78e:0:1991:8:25"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1794302248;
	cv=none; b=ee+2opkth8eHb1fMz5F8zvbd4gPppPEpJDwbU76xpsG7G60tDzulyAUCBSOZ/8ACgS0Aag5T1EOoCNouMJHw5ele+fPZxr1+dAzmID1LBq6mv0YTuL17KSfL6fQW9nChR5iYd73P3Xz73aqKqKBD3Att3e69Eup5MOq/LoIGOeqNhgaui6SkyEXIDF2ciq2oUW2MVqu7LFWIQ/bLQP0uOcKNTO303KOKxRjJ8BwDdDvi1nbvLYD7zQGshpmtxmfy2PvLahdI31HHdtPIUFx4HcIMQQuDK4F7pIXrGmZC6ZzkrTTD2Wy+/FDI2SQhNCf9sLLTqrXPRxia3IP9lDkW6A==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1794302248; c=relaxed/relaxed;
	bh=nwdvLDg6bh1u0DzBGVwm7FjMDeBdtqjQseAh0xTl99I=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=CbiRFzO5zFoiLbVMOgeomnnnUJ9qe204LZWLLEOBM3U1752ZBOhIWv62+GdB2qPfNL+DsV8k+LgcZz4qJ0zAC+sQF2KhDDjJja3nY2O+SFwFaUmu/C7DggiuB+qqQh/TdQheUvXYS65SsdMGyDDROgwJWVmiZV9a4pw8MVvace1Ao5xKUOCTm51B9es+mUm7N97jZxNLzwf/sdjSRrZrtVCad3DiR9u+aWE04rwqOFtSMhznWCxNBT8NJh5Dd3vFx8HDQfqaLg2uoQBznkAIt4/VpjzQqaNrndk5JwXP82rNRfKt0trOHlYJ3GYDwppi0qi/fwlVtqvTYIigCinUUQ==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VFBfo7hd; dkim-atps=neutral; spf=pass (client-ip=2600:3c0a:e001:78e:0:1991:8:25; helo=sea.source.kernel.org; envelope-from=brauner@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VFBfo7hd;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=2600:3c0a:e001:78e:0:1991:8:25; helo=sea.source.kernel.org; envelope-from=brauner@kernel.org; receiver=lists.ozlabs.org)
Received: from sea.source.kernel.org (sea.source.kernel.org [IPv6:2600:3c0a:e001:78e:0:1991:8:25])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4jP1JS2PNvz3bqh;
	Tue, 10 Nov 2026 20:17:28 +1100 (AEDT)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A7682455FD;
	Tue, 10 Nov 2026 09:17:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 458491F0089F;
	Tue, 10 Nov 2026 09:17:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794302246;
	bh=nwdvLDg6bh1u0DzBGVwm7FjMDeBdtqjQseAh0xTl99I=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=VFBfo7hdp6CeqpCV/lTJ2YVYrsN+l15aUN/nPrx8Rg7U/JoKUXLTS/O+qt5CD668b
	 Tvg82H2hCyRZdK0y09cJVY58Rhl/zTfH024a37WXVgI61JHTo+hhQ4sAK9pYHF9Jyc
	 DzcnFl9SoR42roIHoSyhOt3f1yUXXQ9XEu4wnL6doNmOxGOTC2UxCXLYIJjUWc61Yf
	 k2GkpKuijQrA44JhQn1HQ4PgE/MbIqiot91NvXxjd/Re5Y7uEX3vLft3JgMtpiT0CH
	 /c90C0EJy51OUlGahyRcvr5j+wOW65ab+AmNA2qoyUDajcckrSrMy8qdO+IXNuXqIq
	 YuNNlKf10iZug==
From: Christian Brauner <brauner@kernel.org>
Date: Tue, 10 Nov 2026 10:14:29 +0100
Subject: [PATCH RFC 13/41] devpts: use fc_init_pseudo()
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
Message-Id: <20261110-work-loop-pseudo-v1-13-4c998976c6c7@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=916; i=brauner@kernel.org;
 h=from:subject:message-id; bh=NbjUJKnUFt4/WnttO8t6CLNMaU7LsVpFd2X5tAMzhrk=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWR9erD4sV7JnhvtkV5xL4MZSyqkM9c3WZr+jvrmFegxf
 8Ze75f/OkpZGMS4GGTFFFkc2k3C5ZbzVGw2ytSAmcPKBDKEgYtTACYyLZeR4ZqalqDRG+1nqwtL
 9i369KNsxlvXLdmFi/l7l0SdtWZQ8GL4X312nsC5iU3+AX+yRU57OepI7oo7eS8qNuHM0k+v58a
 n8QMA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Initialize devpts as a pseudo filesystem. This raises SB_I_PSEUDO and
SB_I_NOEXEC. devpts never holds executables. devpts_fill_super() keeps
clearing SB_I_NODEV for the pty device nodes.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/devpts/inode.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/devpts/inode.c b/fs/devpts/inode.c
index bd1e8eb26edb..47ef12241d92 100644
--- a/fs/devpts/inode.c
+++ b/fs/devpts/inode.c
@@ -13,6 +13,7 @@
 #include <linux/init.h>
 #include <linux/fs.h>
 #include <linux/fs_context.h>
+#include <linux/pseudo_fs.h>
 #include <linux/fs_parser.h>
 #include <linux/sched.h>
 #include <linux/namei.h>
@@ -438,6 +439,7 @@ static int devpts_init_fs_context(struct fs_context *fc)
 		fsi->mount_opts.reserve = true;
 
 	fc->s_fs_info = fsi;
+	fc_init_pseudo(fc);
 	fc->ops = &devpts_context_ops;
 	return 0;
 }

-- 
2.53.0


