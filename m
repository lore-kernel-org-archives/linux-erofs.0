Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C9E8607C040
	for <linux-erofs@archiver.kernel.org>; Tue, 10 Nov 2026 09:20:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=DuW47WKH
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4jP1Kw0Y2wz3cQr;
	Tue, 10 Nov 2026 20:18:44 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=172.234.252.31
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1794302324;
	cv=none; b=dUidXHc3V+4sUaG/rbPB3Z9SV0QNv443Tlu46Z7NWxYiCYO+8QHut35u9Hea5sP/odbv8DAWYgeAqIasFYtNbE0j1xmYIdrNsoY4Cy6JDfYQO++L2/800FWMjOnOfHo6WjwE/u0fkWgom9ex4JOuQ5a2aB4ebLezHNnjC/ZK1qDcuzagdUS7Y/a6AhZBLRFoLgUXN1WaQcKDjekxV3LhLfdnqEsP5SDFZgOlzC8mrS0xfZYxLaCfEdzfgDf+NXzqke8kuI6S7vWzKbiP9hqfrQKxb/VCB/6ONG4vvTtlvScp5m7kuWccy8BfC5IISazaqI2YDUSvHLnuoWXO+SdS1A==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1794302324; c=relaxed/relaxed;
	bh=uO5ZhnwfrBSeMm3rjJlHHLu0PoUagP/7+NgvInBYUDY=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=VdtoLIDQ1Yik7Xh/PO4vvwhebxIsspZEUfJaldev2SV6fo7oBFSGBC/RY5c97ST8Rzm603fLl5WC0+/AxrdWlLpFBOZglkBv+5tnU9ISKB8KLC+TZu96G9pmJuoNEia3CMl5m7ILTEFHXChl+laBmvGbw8qa3SGH0oL9lZ/5QWxuoXXxaKK2lXWEW/UDiEMA2srPZ234bg6kL9OrLm/uAV1qKz1fbog0UJV/bAC6v0hRCLVDj6HFUiSEhoZVvibyZqsCopzXeQyvS6bTOr+zgPapzOFZDskCSXWrsVUsDPcU83z5B5VyAtHBRTag0KjaG8+laYUMa7gEdGs3Tunu+Q==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=DuW47WKH; dkim-atps=neutral; spf=pass (client-ip=172.234.252.31; helo=sea.source.kernel.org; envelope-from=brauner@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=DuW47WKH;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=172.234.252.31; helo=sea.source.kernel.org; envelope-from=brauner@kernel.org; receiver=lists.ozlabs.org)
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4jP1Kv3hxVz30Wd;
	Tue, 10 Nov 2026 20:18:43 +1100 (AEDT)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id E3D354135B;
	Tue, 10 Nov 2026 09:18:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 751691F008A5;
	Tue, 10 Nov 2026 09:18:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794302321;
	bh=uO5ZhnwfrBSeMm3rjJlHHLu0PoUagP/7+NgvInBYUDY=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=DuW47WKH0NVzTMh/ahwIWKCilxMxR/d9WzG6ER2dp1mTlW6J1MydE1ZvojfSEZmpM
	 uq0lOj+04qYr2LzZD3LTyEm/+Q92gXEaWwvE/iC7G1ulkggahwu88Ns7v4dd7rnO1G
	 naiygZWzOW8Ejr8jN4j4xWgI+lP7+fWJ/2fBG3q7EDC++MqGUBA1hoyiSEnV+fZYuw
	 hy1tvAOwTNHmlUDoF9ANy8eJuZMUnkycIQm0mbN+PVarFn8O73zcdijbpCI2OxpOxD
	 vHWGX2o5WnjZZ/WfXN04GoN3Kndnr2IYwMYmuMbejP3d/XSHugkw6zesVSwCCkxyfH
	 te+Gj4JjZD/Gw==
From: Christian Brauner <brauner@kernel.org>
Date: Tue, 10 Nov 2026 10:14:40 +0100
Subject: [PATCH RFC 24/41] efivarfs: use fc_init_pseudo()
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
Message-Id: <20261110-work-loop-pseudo-v1-24-4c998976c6c7@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=866; i=brauner@kernel.org;
 h=from:subject:message-id; bh=RLuH3jkZQnaQmTSPi6KhFuQtT0Hgw2AWtcSWTkbVq0M=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWR9erDe5Gh9x1THa+rmx4Rlvmxo+ui4+yFfq7/v4xonh
 odTCnlVO0pZGMS4GGTFFFkc2k3C5ZbzVGw2ytSAmcPKBDKEgYtTACYiNoPhv8tvZb6ttrc2vz+u
 s+BZwas9Hb/lZN55FfU3872JMM9paGFkmF2qMIfj7/yA36ELzpv87npr17nsS9Y0JvUP+ZZnWlY
 l8gIA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Initialize efivarfs as a pseudo filesystem. This raises SB_I_PSEUDO and
also SB_I_NOEXEC and SB_I_NODEV. efivarfs never holds executables or
device nodes.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/efivarfs/super.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/efivarfs/super.c b/fs/efivarfs/super.c
index 12746ced6dc6..e598d42c5f42 100644
--- a/fs/efivarfs/super.c
+++ b/fs/efivarfs/super.c
@@ -8,6 +8,7 @@
 #include <linux/efi.h>
 #include <linux/fs.h>
 #include <linux/fs_context.h>
+#include <linux/pseudo_fs.h>
 #include <linux/fs_parser.h>
 #include <linux/module.h>
 #include <linux/pagemap.h>
@@ -554,6 +555,7 @@ static int efivarfs_init_fs_context(struct fs_context *fc)
 	}
 
 	fc->s_fs_info = sfi;
+	fc_init_pseudo(fc);
 	fc->ops = &efivarfs_context_ops;
 
 	return 0;

-- 
2.53.0


