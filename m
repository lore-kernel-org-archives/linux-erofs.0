Return-Path: <linux-erofs+bounces-1671-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C7330EE645A
	for <linux-erofs@archiver.kernel.org>; Wed, 31 Dec 2025 20:42:43 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4dhMN21tPxz2xS6;
	Thu, 01 Jan 2026 07:42:42 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=115.124.30.118
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1767213762;
	cv=none; b=CsoC5SyR4OeDzjX0KW+tYkA2SDiqITcJxMdTOzeVwY3J3k2AQjE1Jgmhf14050JKZ3OxbIwWK3fDrLScpj8i6UUgtV8vbYM7O5G2HwOoNayXOyg+hDlnQgNosa13QBQCA6K0unzlZPNxSLC18mtacI73C+tvFSgougPFAu0M3CcR45bZY/hwAWIpabedW/zi42ymSr5zeTMS9tEd07gF2HRa451bEYa7GfYyDgAXnM9kdV5q1EVAZEEogB+N9fxFWXvUfW5jrdFJjh7wY+XfLImErCetIZiA/cPBmS97GhqPD1ziiItih3UmrdXA4Y9PIDnuI7kvtEyO0MNUNcCeCQ==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1767213762; c=relaxed/relaxed;
	bh=Bw8yz9UYkEEoUZSlDqyPzOJKY0KLWNDhlh8GnINWqQ4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Qj3Knat23FUAQemFMVRxHWvT1pRmIs7ZorHKpiiTStlUC9f/So8SWADzR2fu7H5X87mkawpOnMbLOJ/JFS6PCmHL43FmEZ/NK8R5k7Vk6PyLbUsBIzzCBlJmp4rSQSEoEC8JnfRH6adl6A9S/hg74EhXoIa9YgqfARoN5sENvFdQbtMfA/VsiB7ODn2MtBDy5MScYezqwUOd/f8TXxijqkfrSIJvAoizVmS7ap9kIc3+OHDbE/+9tPfZ7exM1AJY8L6LWBGDc9BguF57amDpL8h4ZKd+o8elG0rsMX8NYRuo61Rg5YMDPROFNcptn7YACrS1ng2URGSbtTDDftfkIw==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=UU/y0haa; dkim-atps=neutral; spf=pass (client-ip=115.124.30.118; helo=out30-118.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org) smtp.mailfrom=linux.alibaba.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=UU/y0haa;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=linux.alibaba.com (client-ip=115.124.30.118; helo=out30-118.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org)
Received: from out30-118.freemail.mail.aliyun.com (out30-118.freemail.mail.aliyun.com [115.124.30.118])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4dhMMy6D6Sz2xKx
	for <linux-erofs@lists.ozlabs.org>; Thu, 01 Jan 2026 07:42:37 +1100 (AEDT)
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1767213752; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=Bw8yz9UYkEEoUZSlDqyPzOJKY0KLWNDhlh8GnINWqQ4=;
	b=UU/y0haaZCQ/Tq5wY+7Xr053S9qUiACdrDpR3AEq0NlxFKWH78nrJO84EnyCdJcNSEjpn57qQZ+TJzMUD5zs9JLWhz+yYF0KSRoz/0gtbO4UTAAtCt0oMN84Xb+PXWFBM4/BE00Ke7fu+18UEQXawLG51qdW3fX5b6ysGVoqCJw=
Received: from x31i01179.sqa.na131.tbsite.net(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0Ww21VLm_1767213745 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 01 Jan 2026 04:42:30 +0800
From: Gao Xiang <hsiangkao@linux.alibaba.com>
To: linux-erofs@lists.ozlabs.org
Cc: LKML <linux-kernel@vger.kernel.org>,
	Gao Xiang <hsiangkao@linux.alibaba.com>,
	Amir Goldstein <amir73il@gmail.com>,
	Alexander Larsson <alexl@redhat.com>,
	Christian Brauner <brauner@kernel.org>,
	Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH] erofs: don't bother with s_stack_depth increasing for now
Date: Thu,  1 Jan 2026 04:42:25 +0800
Message-ID: <20251231204225.2752893-1-hsiangkao@linux.alibaba.com>
X-Mailer: git-send-email 2.43.5
X-Mailing-List: linux-erofs@lists.ozlabs.org
List-Id: <linux-erofs.lists.ozlabs.org>
List-Help: <mailto:linux-erofs+help@lists.ozlabs.org>
List-Owner: <mailto:linux-erofs+owner@lists.ozlabs.org>
List-Post: <mailto:linux-erofs@lists.ozlabs.org>
List-Subscribe: <mailto:linux-erofs+subscribe@lists.ozlabs.org>,
  <mailto:linux-erofs+subscribe-digest@lists.ozlabs.org>,
  <mailto:linux-erofs+subscribe-nomail@lists.ozlabs.org>
List-Unsubscribe: <mailto:linux-erofs+unsubscribe@lists.ozlabs.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Previously, commit d53cd891f0e4 ("erofs: limit the level of fs stacking
for file-backed mounts") bumped `s_stack_depth` by one to avoid kernel
stack overflow, but it breaks composefs mounts, which need erofs+ovl^2
sometimes (and such setups are already used in production for quite long
time) since `s_stack_depth` can be 3 (i.e., FILESYSTEM_MAX_STACK_DEPTH
needs to change from 2 to 3).

After a long discussion on GitHub issues [1] about possible solutions,
it seems there is no need to support nesting file-backed mounts as one
conclusion (especially when increasing FILESYSTEM_MAX_STACK_DEPTH to 3).
So let's disallow this right now, since there is always a way to use
loopback devices as a fallback.

Then, I started to wonder about an alternative EROFS quick fix to
address the composefs mounts directly for this cycle: since EROFS is the
only fs to support file-backed mounts and other stacked fses will just
bump up `FILESYSTEM_MAX_STACK_DEPTH`, just check that `s_stack_depth`
!= 0 and the backing inode is not from EROFS instead.

At least it works for all known file-backed mount use cases (composefs,
containerd, and Android APEX for some Android vendors), and the fix is
self-contained.

Let's defer increasing FILESYSTEM_MAX_STACK_DEPTH for now.

Fixes: d53cd891f0e4 ("erofs: limit the level of fs stacking for file-backed mounts")
Closes: https://github.com/coreos/fedora-coreos-tracker/issues/2087 [1]
Closes: https://lore.kernel.org/r/CAFHtUiYv4+=+JP_-JjARWjo6OwcvBj1wtYN=z0QXwCpec9sXtg@mail.gmail.com
Cc: Amir Goldstein <amir73il@gmail.com>
Cc: Alexander Larsson <alexl@redhat.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
---
 fs/erofs/super.c | 18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff --git a/fs/erofs/super.c b/fs/erofs/super.c
index 937a215f626c..0cf41ed7ced8 100644
--- a/fs/erofs/super.c
+++ b/fs/erofs/super.c
@@ -644,14 +644,20 @@ static int erofs_fc_fill_super(struct super_block *sb, struct fs_context *fc)
 		 * fs contexts (including its own) due to self-controlled RO
 		 * accesses/contexts and no side-effect changes that need to
 		 * context save & restore so it can reuse the current thread
-		 * context.  However, it still needs to bump `s_stack_depth` to
-		 * avoid kernel stack overflow from nested filesystems.
+		 * context.
+		 * However, we still need to prevent kernel stack overflow due
+		 * to filesystem nesting: just ensure that s_stack_depth is 0
+		 * to disallow mounting EROFS on stacked filesystems.
+		 * Note: s_stack_depth is not incremented here for now, since
+		 * EROFS is the only fs supporting file-backed mounts for now.
+		 * It MUST change if another fs plans to support them, which
+		 * may also require adjusting FILESYSTEM_MAX_STACK_DEPTH.
 		 */
 		if (erofs_is_fileio_mode(sbi)) {
-			sb->s_stack_depth =
-				file_inode(sbi->dif0.file)->i_sb->s_stack_depth + 1;
-			if (sb->s_stack_depth > FILESYSTEM_MAX_STACK_DEPTH) {
-				erofs_err(sb, "maximum fs stacking depth exceeded");
+			inode = file_inode(sbi->dif0.file);
+			if (inode->i_sb->s_op == &erofs_sops ||
+			    inode->i_sb->s_stack_depth) {
+				erofs_err(sb, "file-backed mounts cannot be applied to stacked fses");
 				return -ENOTBLK;
 			}
 		}
-- 
2.43.5


