Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAFB9606D7AA
	for <linux-erofs@archiver.kernel.org>; Mon, 16 Nov 2026 11:09:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ThaPefJk
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4jSlTM41ttz3c3x;
	Mon, 16 Nov 2026 22:08:07 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=172.234.252.31
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1794827287;
	cv=none; b=kbLdw74r0Sc9ONuHzCk6V+DnFCFhGDnsDuoGLyQJKJR0ye/cSiB/IkOc2tQ/sqHBjXD9mnBfm9yDP9hnOXfAGoFk/kBsBkCm4rmEr2m4orSDN6ZvQ5FrXAyWyrwNqjQ2tM/0xcSLsG5zXP+OxNg55pRBxXnF7WO2r8q668hsxiM3j5hLD4NbNXlKhiExnmulWSfvBEJihYVTQprnjfOMpS8MZWkCgd4/jTfKIrb5+zx2/O8xlxDoFBFTahQ8nfQXZUMdGNrrVHS+kMZvG0mUQ8zC4ElnDk3m3jgqzJtjtOJs0cgVaxUIEdhjc9KtQTkfo0yV9u+NAVagK9QcMlcyTg==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1794827287; c=relaxed/relaxed;
	bh=/UpKqXd1Q8PiwEiW91lGeEUdsRaeGgHVBpYK/fx91FQ=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=mlqio6+3jpxl/iAx8tjNyRem90QCB8B2Jsei+NL9Ce8kWmB7lYCKWRbEPmuBifXb90HU2Xs/E+2P1LxKlsdV9/A6Pwdu3/qVdS8es0SmMNtxQLxdFV6g2tDAKC9vYtyFR23vpMzT+EZxXTJqv5h+tuI3QGrL0BgCumJo6bmLA6s6FR9ZdnCg2IFr7exEaLuMK28ECN9KmtsvLkOFyDmnpPi+5xMmlytyzI4M3DeLbtAETi7Q+BlOTRkgqfIC+6btUmlTEm9WEo/Z0zdO4uaj71ReZgkxlHtX2JbfvD6JepXlz5fRz++q7vq1VzJXo92GoYdPOEx8D2/tJAGBIMndpQ==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ThaPefJk; dkim-atps=neutral; spf=pass (client-ip=172.234.252.31; helo=sea.source.kernel.org; envelope-from=brauner@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ThaPefJk;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=172.234.252.31; helo=sea.source.kernel.org; envelope-from=brauner@kernel.org; receiver=lists.ozlabs.org)
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4jSlTM0BFWz3bTf;
	Mon, 16 Nov 2026 22:08:07 +1100 (AEDT)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 82E44462CB;
	Mon, 16 Nov 2026 11:08:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E153D1F000C4;
	Mon, 16 Nov 2026 11:07:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794827285;
	bh=/UpKqXd1Q8PiwEiW91lGeEUdsRaeGgHVBpYK/fx91FQ=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=ThaPefJkzYID6A/gJ8BD95JHrrRcoJDueFApgfCzzf6m8AFEdrOPX1V/N0Ou5MSFE
	 3MisKv2jAnh8Lq68niVuDDcQgUlU9KBmq1TWQenImwyQsFWqYvNjMCUA6JECgAVC5Z
	 eCzHZrAVshZEsT9OLL1LKL8EXLhOWYBuwDyPsI88o0Rflk04BSpkmzvraWAQ+wW1P4
	 lJTEA6hSyLJvmV54IXpt4SUS6mx/j+/M7f4C24pf7Qhx12uczYw4UemP32oaW2sS5n
	 2peCadUpW/SatJlkDR04CbDtgimV2EQJ4ss/0BvVQFYbPY9qCuNlO9CEhSFfF6dtOq
	 nUL3+tjJpm9Gg==
From: Christian Brauner <brauner@kernel.org>
Date: Mon, 16 Nov 2026 12:04:49 +0100
Subject: [PATCH RFC v3 16/44] configfs: use fc_init_pseudo()
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
Message-Id: <20261116-work-loop-pseudo-v3-16-8cbbea1cf34f@kernel.org>
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
 Breno Leitao <leitao@debian.org>, Alexander Mikhalitsyn <alex@amutable.com>, 
 Chris Down <chris@chrisdown.name>
X-Mailer: b4 0.17-dev-ce4c1
X-Developer-Signature: v=1; a=openpgp-sha256; l=1100; i=brauner@kernel.org;
 h=from:subject:message-id; bh=arBHZovnHktbx+8dxEhh1iDCO+7a7q/uQBzsyfGCKl8=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWT9elz4yo7/8fTyqPtLu0x0Zv8tjtQzyl68wOHUusK4U
 1piFu/4O0pZGMS4GGTFFFkc2k3C5ZbzVGw2ytSAmcPKBDKEgYtTACayW5nhn4LuCbVth/nnv61W
 jll948YM7hL1TRmv/gSG7k93fv59SRTDP6tHgrPsfflmcXKeOZ47jc/ugU3PlsV14pWbp3dNO/K
 lkwUA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Initialize configfs as a pseudo filesystem. This raises SB_I_PSEUDO and
also SB_I_NOEXEC and SB_I_NODEV. configfs never holds executables or
device nodes.

Reviewed-by: Jan Kara <jack@suse.cz>
Acked-by: Breno Leitao <leitao@debian.org>
Reviewed-by: Alexander Mikhalitsyn <alex@amutable.com>
Reviewed-by: Chris Down <chris@chrisdown.name>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/configfs/mount.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/configfs/mount.c b/fs/configfs/mount.c
index d8cac1cbf3bd5..60ba24e7ae2b9 100644
--- a/fs/configfs/mount.c
+++ b/fs/configfs/mount.c
@@ -13,6 +13,7 @@
 #include <linux/module.h>
 #include <linux/mount.h>
 #include <linux/fs_context.h>
+#include <linux/pseudo_fs.h>
 #include <linux/pagemap.h>
 #include <linux/init.h>
 #include <linux/slab.h>
@@ -106,6 +107,7 @@ static const struct fs_context_operations configfs_context_ops = {
 
 static int configfs_init_fs_context(struct fs_context *fc)
 {
+	fc_init_pseudo(fc);
 	fc->ops = &configfs_context_ops;
 	return 0;
 }

-- 
2.53.0


