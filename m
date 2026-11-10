Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EBFE606A33C
	for <linux-erofs@archiver.kernel.org>; Tue, 10 Nov 2026 09:21:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Bev5vsoQ
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4jP1Lz1bt1z3d8d;
	Tue, 10 Nov 2026 20:19:39 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2600:3c04:e001:324:0:1991:8:25"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1794302379;
	cv=none; b=Sp60+24aoTfCO15O7I/9xCblj/SXd/er8dmwUXk6Is91Of2ktOnmTXkHL2vrrDwZW8nPoRMnFfhvtrZ4xO3Wvi6WVLLeJ/OcVTkKxOgOW+Hm02nJuKz+YZUj/550froeAG1P7z5RLmmIMWZ6D68BPXwq2GdS0Vc9V7QTxAJ9hH1JSvK8fgO76Yte9sNg5/P0pv4hU9PO1iN1v2UNTyHXwOhKRKeazIVl3I9Giqp53i7DZfHP7PpasKz4PjVc6opcBj5PhxSQYkEXQb7TTbRq9+meCBqFz6zPTaqiS/ZE6rsicmAZ6y54ajytOLolofYqS7t1DBinrIyAcc8rYImG2w==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1794302379; c=relaxed/relaxed;
	bh=6F6bixX9VLJl6u/N0LxDxdpy5DWNAw9MIo1FfuiWwlg=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=bu/ZZV5Uy0iNBirEHXsZadDA2KM5+z8hxmjFY6DC0VFInbRQEUXZISmylSY3g9I9mdRIj2Yr7Wa/gFkx4mtD7H9doKckCofZxGmheguIoaB1Lg6LSXIWwttyJQ91Fg1XfsZOIh9OJ6WidzoSjRZM4DNhzdNW8oAJg8QZtVd8KTeWsHIvkTq0vO4gPmxHaJ7DTTGsub+lbPOYIlNPZUspd1eto8dUdQeXUvkL8g0AOylbLtDx6YXyj2IADGPWJFnaAlpfzz+A2Nt4cl0RwMbGxV+oBAQqtJ0Zs0ALgigLoHqu8LZI+Cd3NW94oWnNNEfYsIXqI0xiTEw68CGQvC/bfA==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Bev5vsoQ; dkim-atps=neutral; spf=pass (client-ip=2600:3c04:e001:324:0:1991:8:25; helo=tor.source.kernel.org; envelope-from=brauner@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Bev5vsoQ;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=2600:3c04:e001:324:0:1991:8:25; helo=tor.source.kernel.org; envelope-from=brauner@kernel.org; receiver=lists.ozlabs.org)
Received: from tor.source.kernel.org (tor.source.kernel.org [IPv6:2600:3c04:e001:324:0:1991:8:25])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4jP1Ly4Mctz3d17;
	Tue, 10 Nov 2026 20:19:38 +1100 (AEDT)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id B8C0063823;
	Tue, 10 Nov 2026 09:19:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F84A1F008A3;
	Tue, 10 Nov 2026 09:19:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794302376;
	bh=6F6bixX9VLJl6u/N0LxDxdpy5DWNAw9MIo1FfuiWwlg=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=Bev5vsoQXMD/2z11W7fF7gnr2WOAFCcu91VLKw23i7E0hkqCe1dVrhYy0+KtPJYmF
	 7SwxXGH2SnKEaJ3Gz1JJnuTNJfiSNXCHsVfu0NtJiKPNIwpXKj4acpNvaSgQsC1nOn
	 v9D9W8uBh3avkK864v96nnYuhV8CQ/YD06yiqjObPD/ts1Fa3Yra+s2JNGu1CbzXmf
	 lPoZDKOPKjIY0m0OaT8lZr1lUKx7GexmZFGHwmRV5+QIhPZ8mbIcDCb3vCEt/G7Jt7
	 jjMDsVbCi3OviaEyzsMqCkhdh4WJddoN0LSF4ef8DVIGv0E0SDkQwiCi9hK2AdSt56
	 Gfxo6evUdhVLw==
From: Christian Brauner <brauner@kernel.org>
Date: Tue, 10 Nov 2026 10:14:48 +0100
Subject: [PATCH RFC 32/41] usb: gadget: gadgetfs: use fc_init_pseudo()
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
Message-Id: <20261110-work-loop-pseudo-v1-32-4c998976c6c7@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=980; i=brauner@kernel.org;
 h=from:subject:message-id; bh=HoqM8TovkVWXxEHW73GnjomtfEF10WO79IJ99ILFhZo=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWR9erDTyDeb75KLVcD+3CmXFA8amrwrV9AreTDj+7Lby
 8T6ktIfdpSyMIhxMciKKbI4tJuEyy3nqdhslKkBM4eVCWQIAxenAExkdS8jw7y61UWZSuzH/CUD
 K7cIZcU05XC2Bbk5/nEKXnZy8lbXBob/3nwJfl+n25nnXWg+epP78Jz1HcW8OwRzuVKbKsKnfvB
 hBAA=
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
index 7f6d8460152f..8490e5d0351e 100644
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


