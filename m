Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C866606DA34
	for <linux-erofs@archiver.kernel.org>; Tue, 10 Nov 2026 09:21:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=cqE1KvWE
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4jP1Lq5s0Lz3bV5;
	Tue, 10 Nov 2026 20:19:31 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2600:3c0a:e001:78e:0:1991:8:25"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1794302371;
	cv=none; b=b8Vy9B4z0o1H9+oW+o8WTkqKcAQ3pooTyY03mA2bbYmjxfpDoDLfsmbRsaIdHYJ5DKu6j1/6jMUnx63BoyGAvM6C39eIqJ53q4HtQEM1MlFeFCUzm6R6t3lS0/ygxWSyIgsUxHXTHTKSEMn1DYK9Xk8hdAJriSc39L/jLxBzDhfa2iY+15Sk14E/v+TGi2CUmToEKub+zCKp0moBbxzoMVfAqCcPZu4YzekAIHXMYK4Gdajr6vNGW32el0tcOzZaK8UaZrRc4KGUiWy+ZR2ru+fvT9VKUWOhf+CcNrvNKwAVShOs2b+qI9SDlnbDweyei5WYIXJPWbc4YiCQuxKPUQ==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1794302371; c=relaxed/relaxed;
	bh=61GGJusgpyzZ+uPz/Xbu5aYUeDmjAfN/VZVh7aWKvTU=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=JR9ou0zq9d3QHjBXhDP7hFHn74kPoN1gdxqz4c5lqx3r3FCwq46vgwmPcKJozlxCA9y5zl88new46eqKEO44xLldpUBTfLh1BSQQiProQtnMtwybTNPRGe5L/uBeArzSFzAkFlFDt/6LNIYLaAAqpXS2V2rupCT96ic2jqT000YNRYB6IglJDf31dhTtrAF1JF5bEn7YhlFj+n9NzvdaIFTQeA+YpooxxaTf8QImI7muHHxDrSEYHzWcaTyHS3pjjAPLigsaT4gcLZDJwMDPb3ikP5l+HNdaixiAdcw9ruZAJUNky0dW9c7Tp2KNxCtQJFhf6PtGZhShkVYaSNxJPQ==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=cqE1KvWE; dkim-atps=neutral; spf=pass (client-ip=2600:3c0a:e001:78e:0:1991:8:25; helo=sea.source.kernel.org; envelope-from=brauner@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=cqE1KvWE;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=2600:3c0a:e001:78e:0:1991:8:25; helo=sea.source.kernel.org; envelope-from=brauner@kernel.org; receiver=lists.ozlabs.org)
Received: from sea.source.kernel.org (sea.source.kernel.org [IPv6:2600:3c0a:e001:78e:0:1991:8:25])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4jP1Lq1pzKz30WT;
	Tue, 10 Nov 2026 20:19:31 +1100 (AEDT)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id BB1F743B22;
	Tue, 10 Nov 2026 09:19:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BAF11F0089F;
	Tue, 10 Nov 2026 09:19:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794302369;
	bh=61GGJusgpyzZ+uPz/Xbu5aYUeDmjAfN/VZVh7aWKvTU=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=cqE1KvWEqfCGk9TU1/lVh6ReyYZK8xzJKhSLwmR1cLY0RyRyETFTNmRX/CBtNbGFm
	 AmuFU6adAiumck8an+GpWWAeHBHqTxVKqL/rOi4J9iHi/mWcjTVLhL+WnDXPLpVbqc
	 yNZwiqRepbCcz+qfyuBGhyN5+Hq+js5kBs4E3JLsZlH6qW37IQzTV15bwwycAzfttl
	 5KH5f71aAWWbWtMYVn2+pgetQgDmUXbkZvrrt3OqlCUUpM/yVT8GMncN9mcbx9GAj6
	 7GM+h1AIZhoDOm6jyzSEu1Y46hB8cYzaIFJvf0HAlzzReo76KuwOVqRDN7hOswsejZ
	 ZJtnzm0RI4l6w==
From: Christian Brauner <brauner@kernel.org>
Date: Tue, 10 Nov 2026 10:14:47 +0100
Subject: [PATCH RFC 31/41] usb: gadget: f_fs: use fc_init_pseudo()
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
Message-Id: <20261110-work-loop-pseudo-v1-31-4c998976c6c7@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=955; i=brauner@kernel.org;
 h=from:subject:message-id; bh=Ax5jIfHABzRtvx1V7vJnXeFPM8kck0XZoDkmZlrhKu4=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWR9erAjdtX2CfKp++Zticm3SYuW8v6aMj1ObN8qo7eS1
 x8t/6ib21HKwiDGxSArpsji0G4SLrecp2KzUaYGzBxWJpAhDFycAjARrwpGhs3ZDExxtr2C+4r8
 vRsu23RvyHzNtz1BoT1I0k34U0vwB4Z/1tUpv1Njvs9dubSC+cKR5tMG9m/4Jj97kF74bYvUGf5
 udgA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Initialize functionfs as a pseudo filesystem. This raises SB_I_PSEUDO and
also SB_I_NOEXEC and SB_I_NODEV. functionfs never holds executables or
device nodes.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 drivers/usb/gadget/function/f_fs.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/usb/gadget/function/f_fs.c b/drivers/usb/gadget/function/f_fs.c
index c64a268e98a4..a6b3788399a5 100644
--- a/drivers/usb/gadget/function/f_fs.c
+++ b/drivers/usb/gadget/function/f_fs.c
@@ -15,6 +15,7 @@
 /* #define VERBOSE_DEBUG */
 
 #include <linux/blkdev.h>
+#include <linux/pseudo_fs.h>
 #include <linux/dma-buf.h>
 #include <linux/dma-fence.h>
 #include <linux/dma-resv.h>
@@ -2166,6 +2167,7 @@ static int ffs_fs_init_fs_context(struct fs_context *fc)
 	ctx->no_disconnect = false;
 
 	fc->fs_private = ctx;
+	fc_init_pseudo(fc);
 	fc->ops = &ffs_fs_context_ops;
 	return 0;
 }

-- 
2.53.0


