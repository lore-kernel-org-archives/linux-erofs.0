Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C1D0606A333
	for <linux-erofs@archiver.kernel.org>; Sat, 14 Nov 2026 13:11:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ahGg+gbK
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4jRZGD07zQz3dWG;
	Sun, 15 Nov 2026 00:09:24 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=172.234.252.31
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1794661763;
	cv=none; b=gjEIfC1XMMsnDW/3Fkgv+XmE6a9pxsP6wYL3PioGIzyZZo3N2RyR/AA3M0g7cucNvds0UGozRfF3cWbwpc9oao2flczHDDMN92ACgkUHqaALSOBv4Q3g/3QMX3LBXUmkUfI08O/A4/7Tkc/PSxMucRUJDgXUNm0HeH+XQTr1/DhZYHi4Xs3MjWNOG3/OliY7ZmqEe3E4TMYynUvB2XIxGdntsK7dDqFu9DeafNO1ooefckRZqLRNTVMRphawEFi8TNSnCT9goGiA518lsGm20OlhfobkxdMnv/SbDgKE0KMlYVyQMCgnTXELqmjdF0QJS3dfjqatvkEpwi7RxzfbHg==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1794661763; c=relaxed/relaxed;
	bh=OdlKWawwdwZpGTfkQNHBk5b32jOSAzRsLtI4xTW1vDQ=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=l+7v74Ul6WXffZL7lf1jfKppoTO3fXQ37pHvDNeQX8YQt4n1HHdzgZsdAJ+Y8m9piUrQYn6fGaSRFQSRd39Vty8Cb4m8pqlpo4kt+yxeh4MOcAcsuTAL/6QzQDSLv0rA8qTmJWxsLRGU5i/ypg2KoSKiZ508qF0IIdGG+WUOnx2A8OOK1jVeV9H33YmigNW+ZZ8I0AdtV0PA7D4/tMRZhL7N810ll7tHXvNZCnbtPGLwx4u9o5jUBLhg/QKHz9VNiJpwaqGWGFcDj2oodx+ppwp7fLU9/DL1395cX4AZ5cAd5XA2OZY1O5g6oZZrkHui4vSgZlIVW2CBvlSkP8y8OQ==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ahGg+gbK; dkim-atps=neutral; spf=pass (client-ip=172.234.252.31; helo=sea.source.kernel.org; envelope-from=brauner@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ahGg+gbK;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=172.234.252.31; helo=sea.source.kernel.org; envelope-from=brauner@kernel.org; receiver=lists.ozlabs.org)
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4jRZGC2w4Nz3dW9;
	Sun, 15 Nov 2026 00:09:23 +1100 (AEDT)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id D370B406B8;
	Sat, 14 Nov 2026 13:09:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BEE61F000C7;
	Sat, 14 Nov 2026 13:09:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794661761;
	bh=OdlKWawwdwZpGTfkQNHBk5b32jOSAzRsLtI4xTW1vDQ=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=ahGg+gbKJXxbgqkOcSvuZjZ7iPlwqVzDb7EoxKqbMYLfnwG2b1ybTE6823Yt3K+6g
	 6pxGQrYoIqiTMRS2KhVum/gBvAKYjwtRqLYJCBO/9ug+3ibc96rUKSQG8oL+uPM/Cp
	 otj/ItmyYhEy+iuvYfxXHkC9TxP25a1aDbikvQC0LaWKFqqkHfvi1rF3sXkQx5MRrH
	 gup6EgTCHwl6mcX33AkMw33YPKcSKfn9nILfmzWaqX+7hRwWvA8CVF1JFBWIvMizqB
	 9iaDWPBWP9dpOG/jN3GKX5YzZjKL84UtGahKm/OO3Hrc5uHtCRmGPTFTPgEI2L+fkM
	 4xc2owYmq/A9A==
From: Christian Brauner <brauner@kernel.org>
Date: Sat, 14 Nov 2026 14:02:13 +0100
Subject: [PATCH RFC v2 32/42] usb: gadget: gadgetfs: use fc_init_pseudo()
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
Message-Id: <20261114-work-loop-pseudo-v2-32-98639a2286fb@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=982; i=brauner@kernel.org;
 h=from:subject:message-id; bh=YWRf7GOro6drmYRPuYvYnNI62ZxquNzo3CA3o8p8z3k=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWT9iOkuXt19v9szNHxy/sSShDNHi+s1AhW1jvfPOLx+v
 43t+vdHOkpZGMS4GGTFFFkc2k3C5ZbzVGw2ytSAmcPKBDKEgYtTACZi95Dhn+K7b5fV2hevnL5D
 2vJ8vvv+x1/kZkmvkvsmunJ/0t+X6ZmMDDeNr0oHP1bwdTnx7e2hwBWKTidX/diQpKYmvejZFYN
 lK7gB
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Initialize gadgetfs as a pseudo filesystem. This raises SB_I_PSEUDO and
also SB_I_NOEXEC and SB_I_NODEV. gadgetfs never holds executables or
device nodes.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 drivers/usb/gadget/legacy/inode.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/usb/gadget/legacy/inode.c b/drivers/usb/gadget/legacy/inode.c
index 7f6d8460152f9..8490e5d0351e1 100644
--- a/drivers/usb/gadget/legacy/inode.c
+++ b/drivers/usb/gadget/legacy/inode.c
@@ -13,6 +13,7 @@
 #include <linux/module.h>
 #include <linux/fs.h>
 #include <linux/fs_context.h>
+#include <linux/pseudo_fs.h>
 #include <linux/pagemap.h>
 #include <linux/uts.h>
 #include <linux/wait.h>
@@ -2223,6 +2224,7 @@ static const struct fs_context_operations gadgetfs_context_ops = {
 
 static int gadgetfs_init_fs_context(struct fs_context *fc)
 {
+	fc_init_pseudo(fc);
 	fc->ops = &gadgetfs_context_ops;
 	return 0;
 }

-- 
2.53.0


