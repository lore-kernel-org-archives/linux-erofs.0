Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C6C2606C653
	for <linux-erofs@archiver.kernel.org>; Tue, 10 Nov 2026 09:19:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=AKiKVGQv
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4jP1KF3v0pz3cF4;
	Tue, 10 Nov 2026 20:18:09 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=172.234.252.31
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1794302289;
	cv=none; b=I8uuSLqKFfTXryJJ3RTM89FWLk8KLJRPEDD9CvQBnWt30QfY2HXsPO4Kahxe5T+WXjWsSeJSM4pRj5WpLtskaSam1G/3c4832lAC9ozOs09nN3ZAOnHlAIdhBS+xAvSsbzMX+LE+XQuoKVVS1dr+S6dJJdOf1UpzmEUrCTcOLEJmzjvuDVIg9OLKbvTsvZSvTc+0D+FQSDU0v79Pd+c8MFbYdI++tpdcfpBP5zqDZTISZqVGcfOh/zN8n4GHP8QuDS4NJ9a6igc84ZpWhOksSFfyV6pXC/VYJBUYUjSkceUTXeRLjgLhNh6sF3yY3ySoDj7avPAG+IFw9TeMUCdS+w==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1794302289; c=relaxed/relaxed;
	bh=NCl9sz2+KP+iZeUL45ewnMArN+IoDGg4CzU35zEH9JM=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=CWtJnuA72Z6c2TWpiO23K+imxlJYRlMSdUTQ6D0I1HXON9kwMAxSm9o+hobATDK4mRJKiF07NzbERzFF3mvlgH9Ui5BTn23inZva4jhqd3gakz7rj4dCnfL5xldy/Mqt0LAu0MmII6SydPVudWSOBU2iqwS3d+lJH550r40MuwPRFnsqvc2YEB7IOmu53JNEfFpHkXkhH0bEdNkCpnqq60bQGdaCVMu+7+4VGZG4TVcuP/Rvam/SSURBdkFw1HFVXAggKgqd12Q9DJtjuzwpApohEcltHtu4dw5RzN3oKnuXN6KLY7CrKCTMMmBvf6Yq1sTbKfcJDe6CryZtRWEgSQ==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=AKiKVGQv; dkim-atps=neutral; spf=pass (client-ip=172.234.252.31; helo=sea.source.kernel.org; envelope-from=brauner@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=AKiKVGQv;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=172.234.252.31; helo=sea.source.kernel.org; envelope-from=brauner@kernel.org; receiver=lists.ozlabs.org)
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4jP1KD70DFz3c8Q;
	Tue, 10 Nov 2026 20:18:08 +1100 (AEDT)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 79AAF40AE3;
	Tue, 10 Nov 2026 09:18:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B6791F008A5;
	Tue, 10 Nov 2026 09:18:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794302287;
	bh=NCl9sz2+KP+iZeUL45ewnMArN+IoDGg4CzU35zEH9JM=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=AKiKVGQv0VSeP3wz5if0whUbSvt8YZc7Rh/UCgNkZ5tAH/0Cn0M1DyPvV4tLz3iRR
	 G++AKQ+OJy0M5xoApzZVJUGfdnk89qWIzjAeHEzQ0VsM3A9XZIXAidiDTQzcrQeU+R
	 3rWxkhJkXNAubBNR1QnfHf9O2vWsnxzfQrCYIbzpO8jnSSwVS8AHsMvUUDUcP3yr1C
	 GP65RCivYHVcDBwaFck+SBpAEkBxDBlfFtPEB9HKpyoLRJ7YlEMMxyxLgDLGnXyKsO
	 jMd1X4p2pDleOJUsA8gNdHxO88FTvsmiSbxXo2XRHLCCB0IkrdjNF9sWn589dFrNxg
	 b3gptLSM2NQag==
From: Christian Brauner <brauner@kernel.org>
Date: Tue, 10 Nov 2026 10:14:35 +0100
Subject: [PATCH RFC 19/41] smack: use fc_init_pseudo() for smackfs
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
Message-Id: <20261110-work-loop-pseudo-v1-19-4c998976c6c7@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=905; i=brauner@kernel.org;
 h=from:subject:message-id; bh=A5eRYdoLLChIDmTrXY0x54/6SOLidXbGtpe0eaaqmts=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWR9erDq4LSrtvN2M7bp7Emc1fTAaOdWf5uWkMcflm/7d
 +7rollKKzpKWRjEuBhkxRRZHNpNwuWW81RsNsrUgJnDygQyhIGLUwAm0ufE8E+zd0p+T0Hsa+uF
 Mw++mb+hj4txpnJKwWSB7PycaYbfRW4z/DO+trk2+ZWHe8aRvdM3b9Wd4OG8aVvniUtcPdF/ba1
 FclkB
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

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 security/smack/smackfs.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/security/smack/smackfs.c b/security/smack/smackfs.c
index a72bc7fabea9..4a56bbeaeca3 100644
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


