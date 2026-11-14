Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D615606F6C7
	for <linux-erofs@archiver.kernel.org>; Sat, 14 Nov 2026 13:10:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WeNGCImV
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4jRZF81nZbz3d95;
	Sun, 15 Nov 2026 00:08:28 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=172.234.252.31
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1794661708;
	cv=none; b=MrzZ62wsIrBC/CyV8MpPYIHMvFXfmHlOYRb6ijMc/DjzuNliSEWJUTWuadcHR5AjsBnXXPEYrHPLE9PG2JK0w52jA/L4Ip2hgRzgQPch7tXd1Rjma6AN5r33Jt6cyz79VQLQeJdFjz5/4NFbnsQHsHaJjzuv6vpKuXNu0pCAtpIbrvmpyPL5kbMwrStoopuoyvQNcLQAJ/eGFQwkb5FZwoC40ABkXOfMmTgUwwdmxIC4V3jo3Tiv/X+P+nAPenZruvJHM3tJsn3SnI5k+vvs9Jlc2NEi9wP97LxqDbiDSWoKQnNntDBFJSL+7D/HxjEtIu26Gf0GUlu1ft1p0fPSag==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1794661708; c=relaxed/relaxed;
	bh=65YvxNKLucMRpYw1FJVCDVm75IlqsZ0/PV8GwJXc1Cg=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=e3TcLp3QVJn9SflVxdOlHuxeCSSLwSLJS7saiF8BXDuu3kV8Q3fhJDCDIbNPGUhfyVDBMo3f6BZfsqxVVizYD/Yb29/qvo4zlG7LxgrgWr7WPPC0bgsKWos7Um5rsynj7sWwIXQGtdtNzdYp13e7OrgfGCYgfFQ34OY/jivLNhgvLU/iMZltHRnLG4z0ZebcutDylkhl06yjohmEcPp2py7u4DKd2Gf7Qod4Lmf0Dv60R4ws5dnY2fQWLpVVn4m2i0yGz/fgDgOZhiSYHJ6vES5uaNieQcw5ugONfg74nL2blTuqipdnFUVtPQtE2nw7vjIJ/lL5T9m99mwvROE9vA==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WeNGCImV; dkim-atps=neutral; spf=pass (client-ip=172.234.252.31; helo=sea.source.kernel.org; envelope-from=brauner@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WeNGCImV;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=172.234.252.31; helo=sea.source.kernel.org; envelope-from=brauner@kernel.org; receiver=lists.ozlabs.org)
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4jRZF74nFTz2yb9;
	Sun, 15 Nov 2026 00:08:27 +1100 (AEDT)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 2A1754135A;
	Sat, 14 Nov 2026 13:08:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 780FE1F000CE;
	Sat, 14 Nov 2026 13:08:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794661706;
	bh=65YvxNKLucMRpYw1FJVCDVm75IlqsZ0/PV8GwJXc1Cg=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=WeNGCImVr8p7F8Uli86lXrcXcfJcXXznRaJ3ysXgWVWZ+J7qA0GAbUGY1fIKmINzD
	 Gq0TzUSohC0rcSFwgj1YbJpSzLekANRgSJWblc3JmmjY5rfokTtd8Gk9jL+gnxkZgT
	 4+wocUPn+rNI91e8pLzzUTNjDm+8ueFQcqxvqz59WUo1LF78rr/MQUPWyv9vCtF0MO
	 WOAUe4WdgY8nZL3LH08OuHHlMKXJGnRXtdR2lA/Lm4R0Jw4Sg256wkbSmrYt+j5HCg
	 mTSFDIPBWkEk4eVPeI+ryhW2jC/6smQaaaQZ+zk4OTzgM+AIxj8Ie3NyT5lv/+pHem
	 sh1wJsF9nDAxQ==
From: Christian Brauner <brauner@kernel.org>
Date: Sat, 14 Nov 2026 14:02:05 +0100
Subject: [PATCH RFC v2 24/42] efivarfs: use fc_init_pseudo()
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
Message-Id: <20261114-work-loop-pseudo-v2-24-98639a2286fb@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=924; i=brauner@kernel.org;
 h=from:subject:message-id; bh=WuyzjhSjL7aXRZxi4H+U5QfhpdKUXYV3897MSDhz8qA=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWT9iGlUe3TDrZdvVhVT2mR3k3we9/eJDiu6538yOSXAr
 Hyo0qCwo5SFQYyLQVZMkcWh3SRcbjlPxWajTA2YOaxMIEMYuDgFYCJ3ahgZ1rM7x73c6uLQZetU
 O/epajfjD835024Vs10pq1pRdPDiVEaGNQXHTYyVl0ebeNRMbl02gWFxsDZvQuTKh6s+L1DpTtf
 mBwA=
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

Reviewed-by: Alexander Mikhalitsyn <alex@amutable.com>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/efivarfs/super.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/efivarfs/super.c b/fs/efivarfs/super.c
index 12746ced6dc63..e598d42c5f42c 100644
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


