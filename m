Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 795CF606FDB4
	for <linux-erofs@archiver.kernel.org>; Mon, 16 Nov 2026 11:10:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=CBYYTwmq
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4jSlV51jhLz3cGY;
	Mon, 16 Nov 2026 22:08:45 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2600:3c0a:e001:78e:0:1991:8:25"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1794827325;
	cv=none; b=X7retol892XicJMc0CH7zajoaCH9422YdUCGDlKXZCL4GplKmk5fefaGHW2hVU/Mc4L0CXwYjT8d12i1/wFuzuSka8sv5UqRVzNX+K+fjCfwep0G4lbanwxes9fFCsuZNUb9hTmy4S1+jQp6dklCm8Uzbda6O7YHyDcOzLs6yVVJM0aNNFSnzILFPWyEfxV8PRw/MXaF8udbF5EWAbcfPuRQlv5OmINvJynQqgwtDm3Igl3bQTTEfCDQUwwwSOj1zfalH98gfvv2Rie/otnHcMqJNA8wxcRGy3fiic1r3OP9buZ+bmtF7Tbrcc92e6h9PmqjvnV+6zAdb+be98tGJA==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1794827325; c=relaxed/relaxed;
	bh=K02XzgiVey8Gk03FTq4yCzsjgwwRpaqpi89MgT4x0oA=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=QvUmUQDlud+SfEQwlHcROc9q4CkugYv+9cZ5oOmo5Ts3ZXm3nj0FHgyLQHGR2yEV5T3OX1CIeXjd5iTqnXUIPpERnsE4XewyBW9UaTUXs3ZudRdv2Xuwks8GFM8xqgRGUCtHP9olDC08LVDNP54s1A+F+FnxhSQ/M7QlcwecpKyYBQcti0xHoyNDO/NHFO9XrhpIhuPxR8iTeb67zrlb5yIVLXxzDF8XAbl+YrZLUwNqZmYkFg17lOOwiEmd/vkMZZ4bB6iOWZhq49wVLhHqNkio40LHtaKmJIjqAX4HSJI8hOQmo70RZCzR0BOT8WTv0ry425xuoVhDd2U/+3tMaw==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=CBYYTwmq; dkim-atps=neutral; spf=pass (client-ip=2600:3c0a:e001:78e:0:1991:8:25; helo=sea.source.kernel.org; envelope-from=brauner@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=CBYYTwmq;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=2600:3c0a:e001:78e:0:1991:8:25; helo=sea.source.kernel.org; envelope-from=brauner@kernel.org; receiver=lists.ozlabs.org)
Received: from sea.source.kernel.org (sea.source.kernel.org [IPv6:2600:3c0a:e001:78e:0:1991:8:25])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4jSlV453CWz3cFM;
	Mon, 16 Nov 2026 22:08:44 +1100 (AEDT)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 13153438FD;
	Mon, 16 Nov 2026 11:08:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D65B61F000C4;
	Mon, 16 Nov 2026 11:08:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794827323;
	bh=K02XzgiVey8Gk03FTq4yCzsjgwwRpaqpi89MgT4x0oA=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=CBYYTwmqvG/X7Q1l09jl1lt6vhCiE5IixemW81zB87kv5VWwVCu+tjT7HIpe5m/Ic
	 rxTmpOcLM7fWrYpsIwJ8v9k3Sf119xYtmjZcCDB7XbSsd4ABWeI+YsnncIXfWZ+/TI
	 xyQQQn1PI1wVSECNnc86kj2hevZ5aF/XcQ3GcJYqC9a2J3KgM2w1fVfu9HwheK/PA8
	 hisUgw9t5Yl5+t7FmbOe624VXKlLm9W5/RFSY8WmooHM6Yob3+/hUP5CSs0+2NwMPt
	 KJfFm8q2GyauIZaZ2VNRQuWbKCc6Y0kY+1prHY800HPVjDEQbg/XtxqDqCAofCoKqG
	 B6ZtxIV9ZkJ9g==
From: Christian Brauner <brauner@kernel.org>
Date: Mon, 16 Nov 2026 12:04:54 +0100
Subject: [PATCH RFC v3 21/44] nfsd: use fc_init_pseudo()
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
Message-Id: <20261116-work-loop-pseudo-v3-21-8cbbea1cf34f@kernel.org>
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
 Chuck Lever <cel@kernel.org>, Chris Down <chris@chrisdown.name>
X-Mailer: b4 0.17-dev-ce4c1
X-Developer-Signature: v=1; a=openpgp-sha256; l=986; i=brauner@kernel.org;
 h=from:subject:message-id; bh=d+yGSgu2S03C9xQeqDtaPfOPhebk0oACv2/eOKg0Vkc=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWT9elyumnaqyWZxzLXpTtpXJb5GHHixO+VpRKQ1z1run
 Tz5M3cVdJSyMIhxMciKKbI4tJuEyy3nqdhslKkBM4eVCWQIAxenAEzkzktGhrd93+pWM9fyhmS/
 MygPf3Z2QtHdrz7etVe7fpe0f5yn2MzI8OdsYFzH1ZNi1otv3d/007j7z8WC0v3yYseyfBnuV32
 aygQA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Initialize the nfsd filesystem as a pseudo filesystem. This raises
SB_I_PSEUDO and also SB_I_NOEXEC and SB_I_NODEV. It never holds
executables or device nodes.

Acked-by: Chuck Lever <cel@kernel.org>
Reviewed-by: Chris Down <chris@chrisdown.name>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/nfsd/nfsctl.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/nfsd/nfsctl.c b/fs/nfsd/nfsctl.c
index f32311f2d7cf9..ce2666deddbd9 100644
--- a/fs/nfsd/nfsctl.c
+++ b/fs/nfsd/nfsctl.c
@@ -9,6 +9,7 @@
 #include <linux/namei.h>
 #include <linux/ctype.h>
 #include <linux/fs_context.h>
+#include <linux/pseudo_fs.h>
 
 #include <linux/sunrpc/cache.h>
 #include <linux/sunrpc/svcsock.h>
@@ -1375,6 +1376,7 @@ static int nfsd_init_fs_context(struct fs_context *fc)
 {
 	put_user_ns(fc->user_ns);
 	fc->user_ns = get_user_ns(fc->net_ns->user_ns);
+	fc_init_pseudo(fc);
 	fc->ops = &nfsd_fs_context_ops;
 	return 0;
 }

-- 
2.53.0


