Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6184C607667F
	for <linux-erofs@archiver.kernel.org>; Sat, 14 Nov 2026 13:09:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Ji+nEVur
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4jRZDT2jrjz3cZf;
	Sun, 15 Nov 2026 00:07:53 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2600:3c0a:e001:78e:0:1991:8:25"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1794661673;
	cv=none; b=Itd9El90Fg3eSATpkOmC5u2Si2MSoiDZLSF0MFdpTUcJdXoEdv/VuZoqWLN9/lcODRUqc514znAuDmWDKaZm/oSltLfdvoiqtzWhQS9hFYy6Zj2wXEZKcP8LDnQtK6QnB++pqkwkEeX9frUInFvW6fZycQzmXzz1h4Y+7KrCtprxZxHlplFgm7aohUN7bGzGq3st2XR8EPhMG0Kx3XnMPbechM7XwWu/T6upF14WKz2W384LTAObxttR+l1DubtCeX9nbMP6CvQyisbcpkOOqGPZX7+mCM7/OU1kxoTwBfQ7KD5tCCjMxCNLyigHv4T1Yu39UOJ5j7V1VFlm8I7miA==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1794661673; c=relaxed/relaxed;
	bh=HLEBqcSKp1qX1T09y3XaYhOvlZUW+haNA06sn1fKMTM=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=PAhPHWme3PrRglJIU30yBxM3QP0KUMMYdKvxzOKSwey//jKzRAfkJizDLpHjpC67/1FsnRISFzaZEFSvYtuUn2WWPLqfsgFZhF93qcUTpzk9C9VNgDPmDMjnwkbyR4xPqFff+I8E1Y1HWmaKbxxWU+qXsT/1MfjeN1P7o5o0/8NfqN/yQsGDDT1yu55nZSwwmGL0MGtzCzGj1MC90UVRgbieFtBGg2DkgKY+3bUzP30mH0eb13qxlGg4PhRUaxJ2TeNaqiV9CYiwL9qZAdGCffAmhC15BIdLLl+/9EMwhMuR/hFhFjlUieSsmH54+0aw7AaXjUelc4+vsDbtZzSHGw==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Ji+nEVur; dkim-atps=neutral; spf=pass (client-ip=2600:3c0a:e001:78e:0:1991:8:25; helo=sea.source.kernel.org; envelope-from=brauner@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Ji+nEVur;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=2600:3c0a:e001:78e:0:1991:8:25; helo=sea.source.kernel.org; envelope-from=brauner@kernel.org; receiver=lists.ozlabs.org)
Received: from sea.source.kernel.org (sea.source.kernel.org [IPv6:2600:3c0a:e001:78e:0:1991:8:25])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4jRZDS5BK5z3cZH;
	Sun, 15 Nov 2026 00:07:52 +1100 (AEDT)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 219C04329D;
	Sat, 14 Nov 2026 13:07:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 377B01F000CA;
	Sat, 14 Nov 2026 13:07:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794661671;
	bh=HLEBqcSKp1qX1T09y3XaYhOvlZUW+haNA06sn1fKMTM=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=Ji+nEVurWmAWGlYK/nkfcItaW59n2bZXGZcxHBK4OdfGaK8u3mxnvdkxxHgDIydSr
	 p/UqYko0xoSz4+2DnS47tPHRl2jWXh7tXIePEIQLB3C3jGbWQ9Au7YS1vvY5l7fUr5
	 ph8m8OZcq0Am7xu1jp3h10AkrRPVtHIVmgjmJ4PmRoVOvpEKw36sGP9bQXZx0UwMKH
	 HxikLBXNjHLBDBGgc6E13ZKeQwUfqBkSNN+kiTaJ4yJMSSYs09p0VgPuGTW3tcdwiR
	 GA0Rcmh4JRimAm3px4/WK7WlefYTOW4KsqGKwhhMFZ1acn+6sH08twTlVYAZESB1es
	 3OH10sFCA79yg==
From: Christian Brauner <brauner@kernel.org>
Date: Sat, 14 Nov 2026 14:02:00 +0100
Subject: [PATCH RFC v2 19/42] smack: use fc_init_pseudo() for smackfs
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
Message-Id: <20261114-work-loop-pseudo-v2-19-98639a2286fb@kernel.org>
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
 "Christian Brauner (Amutable)" <brauner@kernel.org>, 
 Casey Schaufler <casey@schaufler-ca.com>, 
 Alexander Mikhalitsyn <alex@amutable.com>
X-Mailer: b4 0.17-dev-ce4c1
X-Developer-Signature: v=1; a=openpgp-sha256; l=1015; i=brauner@kernel.org;
 h=from:subject:message-id; bh=mE4jYSsHEwuAZf3nmG7Zw4WEpYRZ8AUzYrhlfcWNpTk=;
 b=kA0DAAoWkcYbwGV43KIByyZiAGr4XHvIqDUMQ3Y3FWiJAOR/6/2bqf9F3aGnkKR/Ws7txmnIJ
 oh1BAAWCgAdFiEEQIc0Vx6nDHizMmkokcYbwGV43KIFAmr4XHsACgkQkcYbwGV43KJGMAD9GRGB
 jgYj+fXNJRfyU9Ary0JbYVPSrhncPXZR9kWxX5sBAJyDlhh8buWDux0CUa6zjYdeue58XdJanKh
 tYMsz8+gL
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Initialize smackfs as a pseudo filesystem. This raises SB_I_PSEUDO and
also SB_I_NOEXEC and SB_I_NODEV. smackfs never holds executables or
device nodes.

Acked-by: Casey Schaufler <casey@schaufler-ca.com>
Reviewed-by: Alexander Mikhalitsyn <alex@amutable.com>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 security/smack/smackfs.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/security/smack/smackfs.c b/security/smack/smackfs.c
index a72bc7fabea99..4a56bbeaeca37 100644
--- a/security/smack/smackfs.c
+++ b/security/smack/smackfs.c
@@ -25,6 +25,7 @@
 #include <linux/magic.h>
 #include <linux/mount.h>
 #include <linux/fs_context.h>
+#include <linux/pseudo_fs.h>
 #include "smack.h"
 
 #define BEBITS	(sizeof(__be32) * 8)
@@ -2880,6 +2881,7 @@ static const struct fs_context_operations smk_context_ops = {
  */
 static int smk_init_fs_context(struct fs_context *fc)
 {
+	fc_init_pseudo(fc);
 	fc->ops = &smk_context_ops;
 	return 0;
 }

-- 
2.53.0


