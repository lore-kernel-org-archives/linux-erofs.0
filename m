Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B444606C575
	for <linux-erofs@archiver.kernel.org>; Sat, 14 Nov 2026 13:08:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GFHvRmPz
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4jRZD438T3z3cNj;
	Sun, 15 Nov 2026 00:07:32 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=172.105.4.254
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1794661652;
	cv=none; b=d46CrrOAJXLyTqRUo9RYYAo/1u4dX6ycari/nOqkpmhRROw3SzAKKligGhHMkWJi90SsAydQh9bISR9WbY1FaI135jx6tLadBBHner7cnqQWz7EqSSvnD2C/Fy6KyuityS5pqAZ0IwkiKbvvBgGPU++oQ4XPSZRwsthyEfRnVaBOdOCY1w1qN/1o0X3aniLvvgHXlK6jpCJM2R3QQp+oOsjXVj1eTE0xu9gRnTCFKX+v415DFWLCtBdkQ5jGOa56sB72mOaWIRzA4IJZBVTdf7QhPm8QvRFg4/xA5C64K7vNTvyZUbrCQ6I4k8IU0lV4l6na+LAplsxAjGR8aDr9WQ==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1794661652; c=relaxed/relaxed;
	bh=8Ytkno3jTVi+FFRUdCUqmeMcgBru4oLAHALyh9TN4hQ=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=YvK+idEr9kf1iYwrYERKodas7N/vwT4DCt0rQX+bX0/gon7S71bt++sY/IS5S6M1/GOopoobpYLHcfeUT8/4pbZ29MoTOkpio+DrksUAmscHwH82kYGOH8e4XsXWIWYPnVEoqk0ZpinZElXWWwcod7r3NbDGVyitax9CKxR9aaPRB6DplA+nh7tcLCH/uKbhmafMt94E4Huw+frZz0H11WYlLaxWTNa41Cle5x3Btin+UFb49NxWKzSa9r6JPo9OJNJd0RZZX4uajV745Eu14f2FWP+0FtIQ+LtCvk4mejH4Z6VgZ557MAtob8yWw5Q4EVodtgW+NhJqhjLhcVU+Uw==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GFHvRmPz; dkim-atps=neutral; spf=pass (client-ip=172.105.4.254; helo=tor.source.kernel.org; envelope-from=brauner@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GFHvRmPz;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=172.105.4.254; helo=tor.source.kernel.org; envelope-from=brauner@kernel.org; receiver=lists.ozlabs.org)
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4jRZD35y5hz3cNg;
	Sun, 15 Nov 2026 00:07:31 +1100 (AEDT)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id E81ED62747;
	Sat, 14 Nov 2026 13:07:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE82A1F000C5;
	Sat, 14 Nov 2026 13:07:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794661649;
	bh=8Ytkno3jTVi+FFRUdCUqmeMcgBru4oLAHALyh9TN4hQ=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=GFHvRmPzrl9JT/XnWgZ6mHZe9H02hsU97t3+ppYOuzxqJMSfmYjPWgdxAi/Wgu8V/
	 wrZy1vRHCZdd0bC3qI68hsdNcKgmQ3IfSWbtHayF9hWHqdbEWqPyzLLH8RbYsc2XCZ
	 dXSM6hWaopdLwe6Tk47JXm5nRSuNnbE8q0uiLEKYHIn3zKgz4gm0hCB1eldl8tNsaw
	 9r5Nn1nPEqIl+dH7clVv0JN4xn0WgIG2u28WaYeRfsivii2u6GrnUxXBTzpaIAi0hh
	 87j2TXLbcazLek+XXOfbey7w3PmofUiagXJteCYNZfZvoshvSXFM6Zg0UUYgny94Iv
	 NhCBc31tgKfxA==
From: Christian Brauner <brauner@kernel.org>
Date: Sat, 14 Nov 2026 14:01:57 +0100
Subject: [PATCH RFC v2 16/42] configfs: use fc_init_pseudo()
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
Message-Id: <20261114-work-loop-pseudo-v2-16-98639a2286fb@kernel.org>
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
 Breno Leitao <leitao@debian.org>, Alexander Mikhalitsyn <alex@amutable.com>
X-Mailer: b4 0.17-dev-ce4c1
X-Developer-Signature: v=1; a=openpgp-sha256; l=1052; i=brauner@kernel.org;
 h=from:subject:message-id; bh=Cs6hi+IJv6YL+cABcEV5PmkB4gvNrgirbEkbHavmri4=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWT9iKmo6zy18/cHrrR7f6484D3B9HbNopIHW//r8rL/b
 7n/ouvYt45SFgYxLgZZMUUWh3aTcLnlPBWbjTI1YOawMoEMYeDiFICJyIgzMsxe+XjzPdujcT/X
 dlcLtp6+NiOv++ZaxhfruqUl7wfkfepm+O/nmC3+VkJi2/4AH0tulRslnlL+mWJ/ffz2RXNuXWh
 +jh0A
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


