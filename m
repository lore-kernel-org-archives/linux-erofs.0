Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40CA760858CE
	for <linux-erofs@archiver.kernel.org>; Mon, 16 Nov 2026 11:11:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=oFIEwLKD
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4jSlWM27x1z3ckP;
	Mon, 16 Nov 2026 22:09:51 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2600:3c0a:e001:78e:0:1991:8:25"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1794827391;
	cv=none; b=U1PU5UHBHJWmbSXCEFG5ysYXwxnFseTy+MUIVbxjZ7BpxYVYcNvu6nHaeSirvLPA4QBqJxYmeOw25Fm4G9Wy+Z0yYMvA3G2ZeNBQJNSWQa4ajib5/UKPCDmUHWAxu9BqRZcCuj/hho8J3SN+FCV7KRoD6jz29r0su2K+bf0DgqfcRkJ1xM+Zqp/ZqwUswVdbinuquUHAvvzs+9824KVhm/Ntlf9k8fCF2XUSEn3ZCwE6JpGg4awpgy96mMrqK40DDhhrbzHrHO6V9D7MKhbEYOcE8ut2mq217uk67uBdGdfSwpnUPxPvJoxeex0h6m+yJInDVTuH9ii8cMn2D/vL4A==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1794827391; c=relaxed/relaxed;
	bh=id4PRLDY8xxqmv09Cy60S/mO+ESr2mIJ65uM2WRQC7s=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=oiFE9IWZLiIcDeTVteS/BqBPU/1jy8EbzmtnXWxQIzOC3ufFQdUaw4vsyZAxv/P5voIellWO9Zp2NgxWrKBxrnEEYSfVaooU63iFycNs49X4WVKEXE0B7Z4Te7mHv66FQvqKaS97rc9CztycLgvOfOlfEkyprj9j35B3eyaEM147C5A1eaWHo2q9DQKyvIDSV6vII+NPSJcsWM/MIg4GxTb47z1zWBRtzAqeJOED2jwHUJmCHx1bcHOPRIk9h0Dj+kIz+Odffglta0nlxsbtOdEW7q2VI4LI73qP6VN9ru35+1RUy0aXHrNE6D4iBml/5BkZUaF/JkxSRK5uCLH/6A==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=oFIEwLKD; dkim-atps=neutral; spf=pass (client-ip=2600:3c0a:e001:78e:0:1991:8:25; helo=sea.source.kernel.org; envelope-from=brauner@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=oFIEwLKD;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=2600:3c0a:e001:78e:0:1991:8:25; helo=sea.source.kernel.org; envelope-from=brauner@kernel.org; receiver=lists.ozlabs.org)
Received: from sea.source.kernel.org (sea.source.kernel.org [IPv6:2600:3c0a:e001:78e:0:1991:8:25])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4jSlWL53fGz3cgx;
	Mon, 16 Nov 2026 22:09:50 +1100 (AEDT)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 134C443C84;
	Mon, 16 Nov 2026 11:09:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 451AC1F000CC;
	Mon, 16 Nov 2026 11:09:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794827389;
	bh=id4PRLDY8xxqmv09Cy60S/mO+ESr2mIJ65uM2WRQC7s=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=oFIEwLKDMkGdxOt/DDlVAriXa/3JhjU6B0wnumVBLhZbrKad6BNjyN32ljVZe1gr2
	 evSiKb98KYiK7ox0NLucJoulMze+sd3HtzyZ/Phmkxks/AbKfj8BC1no0C9EH7ohN3
	 WQMFdiKsZiXF4sj6E2AcrSrWMXjOjOyhtElSwZvxW5uxffrEIpX/hWkpl+FofkZOLx
	 b2aRFRpLcgHXUzQNqoClVFfyUUZQ+h9kK+k31gD/lsiHRjzSHuUqTUFbozUt5OYusI
	 G8Q6nJwUvut37/TzsrYXpAmX9f8vZm1SSdPUv+Ge/ufOtx/LttiTnVQr4RWG/x7ZZT
	 n5AYYwK7BC2Ig==
From: Christian Brauner <brauner@kernel.org>
Date: Mon, 16 Nov 2026 12:05:03 +0100
Subject: [PATCH RFC v3 30/44] powerpc/spufs: use fc_init_pseudo()
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
Message-Id: <20261116-work-loop-pseudo-v3-30-8cbbea1cf34f@kernel.org>
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
 "Christian Brauner (Amutable)" <brauner@kernel.org>
X-Mailer: b4 0.17-dev-ce4c1
X-Developer-Signature: v=1; a=openpgp-sha256; l=1161; i=brauner@kernel.org;
 h=from:subject:message-id; bh=IfUgpka9O6kutLnlSG4nrBix3fgpTd+0l8aZ7VY9Wl0=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWT9etyY0bbQpb9/stRd2wNcz8MesFWKZlzUZtZQfdaTZ
 /NkW8OzjlIWBjEuBlkxRRaHdpNwueU8FZuNMjVg5rAygQxh4OIUgIncd2FkuM13RtqwR3sRb/7u
 73H9Vgmqz68LeQWvbp3DZuV3SdfelZHho4jyyh1BXWnl1lUZlWu/W/+8XHi6s7LFRtpfibX7ThQ
 TAA==
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Initialize spufs as a pseudo filesystem. This raises SB_I_PSEUDO and
also SB_I_NOEXEC and SB_I_NODEV. spufs never holds executables or
device nodes.

SB_I_NOEXEC also refuses PROT_EXEC mappings. The spufs files that can
be mapped expose local store and problem state areas of the SPU,
nothing the PPU executes.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 arch/powerpc/platforms/cell/spufs/inode.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/powerpc/platforms/cell/spufs/inode.c b/arch/powerpc/platforms/cell/spufs/inode.c
index f066d9c7344d3..54b45932aecd2 100644
--- a/arch/powerpc/platforms/cell/spufs/inode.c
+++ b/arch/powerpc/platforms/cell/spufs/inode.c
@@ -11,6 +11,7 @@
 #include <linux/file.h>
 #include <linux/fs.h>
 #include <linux/fs_context.h>
+#include <linux/pseudo_fs.h>
 #include <linux/fs_parser.h>
 #include <linux/fsnotify.h>
 #include <linux/backing-dev.h>
@@ -741,6 +742,7 @@ static int spufs_init_fs_context(struct fs_context *fc)
 
 	fc->fs_private = ctx;
 	fc->s_fs_info = sbi;
+	fc_init_pseudo(fc);
 	fc->ops = &spufs_context_ops;
 	return 0;
 

-- 
2.53.0


