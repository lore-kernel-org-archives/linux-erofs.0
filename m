Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16633606CDC1
	for <linux-erofs@archiver.kernel.org>; Sat, 14 Nov 2026 13:06:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=N/ubtL31
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4jRZBj0G8vz3c3K;
	Sun, 15 Nov 2026 00:06:21 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2600:3c0a:e001:78e:0:1991:8:25"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1794661580;
	cv=none; b=HSn1BWmluNKgaoqbfLe9kbI7y8udU1w0POpVIHdAmemTAzLEPvI11ZZ/kmZjO8WuwFe/lOT/hS0zTanGGsKfcb91wODadgMoggTFIPBcaHQwe0BS4rTbz5+DNOLyk8k6X6gBWfuAxwkRcjtlVtFDKu4epOqJp4gjJgHbzC7KFhYxoEia611cqbT8t+tVcDAKT+Ik0t+KGQJ8+V4hDgopHN3BK00Su8Ar0NejWPzQE7Ztx5Oc1pICaw8yIWwprFWqcVWaLz4JHnZ8HXdd0RX8Dsp6NUpbXRUUBBoeeZ667SsWt3WqycgQPRmmsUmSKB0QfstBlGbJ9LQNsdo2h+Oi8w==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1794661580; c=relaxed/relaxed;
	bh=NnRPpMKcN9yVfeXQRaQnGebNudMmHI+DUOfgXRvZF2k=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=jOZfzqhWsZNpxkd2X83dCCRqwfMvGdMtSeB6gna7Hm3PiE3s6EoX2s/I22OY4EQsnV+1KMB4ssjvHY6n0EvP1V4XvShVTku6viy2lokVDdxfJBoXns/yogHM017J9xCrtH7yAQ0kiGho+98P4RQ1v79lyYYLp3E/U+ghAh+zUtoLbH0OVV9XOp5qe0yXrVFjkyTKeMuyODr4KMDGtG1zpwQVwU3owK411y279AwE8ajyliUM815WTLcYYuOkrRytWU46Ie9VEP0UJm/zJVlA/i/YCqfEnZNw+k6yE6+7gCYKGdyvxVFobJqBzoi5X15GR2mjYRPBRAm3IANNIDAq8g==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=N/ubtL31; dkim-atps=neutral; spf=pass (client-ip=2600:3c0a:e001:78e:0:1991:8:25; helo=sea.source.kernel.org; envelope-from=brauner@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=N/ubtL31;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=2600:3c0a:e001:78e:0:1991:8:25; helo=sea.source.kernel.org; envelope-from=brauner@kernel.org; receiver=lists.ozlabs.org)
Received: from sea.source.kernel.org (sea.source.kernel.org [IPv6:2600:3c0a:e001:78e:0:1991:8:25])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4jRZBh1psLz3c3D;
	Sun, 15 Nov 2026 00:06:20 +1100 (AEDT)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B9CC14637D;
	Sat, 14 Nov 2026 13:06:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C0B41F000C5;
	Sat, 14 Nov 2026 13:06:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794661578;
	bh=NnRPpMKcN9yVfeXQRaQnGebNudMmHI+DUOfgXRvZF2k=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=N/ubtL31jom4eCsfCr6WpwL+MzKUK+rWwpFr4vgqMUy06gbO86k3xFL/VlhTtjybt
	 o3d0PDdbLEy9jHXv7T5i3zo1EBRIqVAu/ZacRS1retYyYhxmkcSel3BM1zOn1JXfvT
	 j1dl7rLX/nE/c0hHw7WYlCxm5LtmKhEmBxCBiL0Rx0/pMBD9F5WQlfq+VoGsYrh6sB
	 EoBC//ArgbDcTnWusWXsxEQCVbMy6hCKCNl3yIXPnFUODMjEzsMezuDoTZo4Jytdw+
	 VM9ybNeR637U1rMcm9u8t7d6wvsPa1ke2eVusyEuf1MTwKev4R1WEMPGbBHytx3Eq8
	 fhAsIGxVLYMEg==
From: Christian Brauner <brauner@kernel.org>
Date: Sat, 14 Nov 2026 14:01:47 +0100
Subject: [PATCH RFC v2 06/42] proc: use fc_init_pseudo()
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
Message-Id: <20261114-work-loop-pseudo-v2-6-98639a2286fb@kernel.org>
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
 Alexander Mikhalitsyn <alex@amutable.com>
X-Mailer: b4 0.17-dev-ce4c1
X-Developer-Signature: v=1; a=openpgp-sha256; l=1408; i=brauner@kernel.org;
 h=from:subject:message-id; bh=wvImD7sMv1Zo1NPwHwuuoeuuUg5KPRN98RPqhNbSu40=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWT9iMnpmesutyB8V/b0LVcfp532arap6m4r+hdd5Hsq7
 Xz78q6OjlIWBjEuBlkxRRaHdpNwueU8FZuNMjVg5rAygQxh4OIUgIlIsjMyvFL6nBbm+cmh7cNW
 o+/+y5gDpu7PW1vMKy676K58p8+pVwy/WQr/TZnocHWqxVPTHZNuH104SXi/kiln1+yjJ8vj0nb
 O4QUA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Initialize procfs as a pseudo filesystem instead of raising
SB_I_NOEXEC and SB_I_NODEV by hand. This adds SB_I_PSEUDO.

Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Alexander Mikhalitsyn <alex@amutable.com>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/proc/root.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/proc/root.c b/fs/proc/root.c
index 7fbbe92bf73a7..ca0e75081934f 100644
--- a/fs/proc/root.c
+++ b/fs/proc/root.c
@@ -17,6 +17,7 @@
 #include <linux/bitops.h>
 #include <linux/user_namespace.h>
 #include <linux/fs_context.h>
+#include <linux/pseudo_fs.h>
 #include <linux/mount.h>
 #include <linux/pid_namespace.h>
 #include <linux/fs_parser.h>
@@ -265,8 +266,6 @@ static int proc_fill_super(struct super_block *s, struct fs_context *fc)
 	if (ret)
 		return ret;
 
-	/* User space would break if executables or devices appear on proc */
-	s->s_iflags |= SB_I_NOEXEC | SB_I_NODEV;
 	s->s_flags |= SB_NODIRATIME | SB_NOSUID | SB_NOEXEC;
 	s->s_blocksize = 1024;
 	s->s_blocksize_bits = 10;
@@ -350,6 +349,7 @@ static int proc_init_fs_context(struct fs_context *fc)
 	put_user_ns(fc->user_ns);
 	fc->user_ns = get_user_ns(ctx->pid_ns->user_ns);
 	fc->fs_private = ctx;
+	fc_init_pseudo(fc);
 	fc->ops = &proc_fs_context_ops;
 	return 0;
 }

-- 
2.53.0


