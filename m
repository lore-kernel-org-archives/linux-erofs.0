Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 848E9606AB50
	for <linux-erofs@archiver.kernel.org>; Mon, 16 Nov 2026 11:08:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=i6Pqa6AK
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4jSlSn63yyz3c00;
	Mon, 16 Nov 2026 22:07:37 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2600:3c04:e001:324:0:1991:8:25"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1794827257;
	cv=none; b=T7dtSVl8CQTksHU3pnlaUf5XNqxhGX2PeoztIBYOwlHZ+xcgASegXjxSGs/pXwdXayNYQUzJzbReQ4kacYIKp74vXXReHdPGezJq58qmzTlpUkXI6xjPoi/kz3Qztcfk13DQcNfnPqWq2L8+s/xBQw+zeO8NLV9ME68Zl5lQCBSVU6ssPZ+7KSNLPSlDOsnY2xKi/zyDdj1MLP8TeEJXidnXe4eNSWiqGngITs6OmiijWXA7Y5OVlXYtStsOMNSGiQRQv1x0dO8QcFVnIbpZR7ANzRsInte7Q09DIPcL7ZtnvgRpaCuMtlNh/iq8mGW9OmRs9yHnHR92w2cDtT3L/g==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1794827257; c=relaxed/relaxed;
	bh=unDyG99Rc2/QnFjGnYYD038yieUDExHdgCgrjykz2ZY=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=Eyt5lqaOfD94owyAj2mGq+y+F9Zb21Fmhq+qf0S/OlPUMzIngsYd/d1w5H3q5y3X8ptuZxrs/VeLTUfXMQpy61nuIPFAsRLpfvmfuMSFKzhIjzbuy7Le02RPvWbNZspSBgdeArZJ/vDT/Fv5IsoLDkjznjjW9WwQRDImcBmBnBDUr5IXUmMAZeglbXmC/bRUbNaQNPUiDrn9S3Q/LSnX2+kzBto5EnRqeb1gsyPpqKl/cnlIwnhlPXQOmeyJDyD2UHV52wFaetLfW3QcrUf/bYweHDm7yUJp9L8loUdAah60Qy4bhDOTh9cqvQ+L6e4r/8CiWmWvTeksm7MvwKSY8w==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=i6Pqa6AK; dkim-atps=neutral; spf=pass (client-ip=2600:3c04:e001:324:0:1991:8:25; helo=tor.source.kernel.org; envelope-from=brauner@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=i6Pqa6AK;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=2600:3c04:e001:324:0:1991:8:25; helo=tor.source.kernel.org; envelope-from=brauner@kernel.org; receiver=lists.ozlabs.org)
Received: from tor.source.kernel.org (tor.source.kernel.org [IPv6:2600:3c04:e001:324:0:1991:8:25])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4jSlSn01QSz3bTf;
	Mon, 16 Nov 2026 22:07:36 +1100 (AEDT)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id E389F62957;
	Mon, 16 Nov 2026 11:07:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22F1A1F000C6;
	Mon, 16 Nov 2026 11:07:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794827254;
	bh=unDyG99Rc2/QnFjGnYYD038yieUDExHdgCgrjykz2ZY=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=i6Pqa6AKqSvC4ebvXTzRd7oi7aJBBmSogD2MCZUz+Gnyciubja82o8kqkhXx7dmbJ
	 YZ3OFzxMqg5vhnUqEdYWnGqrDZ2761QlIJx4ugYu46+wc79S1rLXYRAojCd2F8EJPv
	 rWtXzwXgonLmkOAYpmxDxXhGHf+SRv06DZqPMXss0nKRguX50b8hr52CXLrvIrsQJb
	 R/MzhbgN9X3LeDn2FNzkkLWBu7qU92XxamIU3Wyj+KWteLIrApxDfwLHL4PnSlVBp4
	 4nMXDHWmRdwXEYpIJfXlUPY7gsKx2DcnOYAbzXZIfzq7R9duuuzTBHHeDujfTitnZh
	 SUS1JrRQ5cEaw==
From: Christian Brauner <brauner@kernel.org>
Date: Mon, 16 Nov 2026 12:04:45 +0100
Subject: [PATCH RFC v3 12/44] rust_binderfs: use fc_init_pseudo()
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
Message-Id: <20261116-work-loop-pseudo-v3-12-8cbbea1cf34f@kernel.org>
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
 "Christian Brauner (Amutable)" <brauner@kernel.org>
X-Mailer: b4 0.17-dev-ce4c1
X-Developer-Signature: v=1; a=openpgp-sha256; l=1351; i=brauner@kernel.org;
 h=from:subject:message-id; bh=Se/hTFkDp0LtS3ScLeBDxadBnc0o/SVsPeEgiuoeVFc=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWT9epyT8M69m8XXMjpjcWzYNVUegbmXD+1dF+byklHpx
 K5cB/M7HaUsDGJcDLJiiiwO7Sbhcst5KjYbZWrAzGFlAhnCwMUpABPpmcfwP+mi0U8hwxbvvU4l
 Hkm1cav/vpjiVt8euFTLYsOZ/GWeHxgZXjDYxa6vVr+1U1HGOv+SmujnxRGNLG7xKmG5Rrx2IlK
 MAA==
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Initialize binderfs as a pseudo filesystem instead of raising SB_I_NOEXEC
by hand. This adds SB_I_PSEUDO. binderfs_fill_super() keeps clearing
SB_I_NODEV for the binder device nodes.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 drivers/android/binder/rust_binderfs.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/android/binder/rust_binderfs.c b/drivers/android/binder/rust_binderfs.c
index 5f020226720db..04468c5b5c116 100644
--- a/drivers/android/binder/rust_binderfs.c
+++ b/drivers/android/binder/rust_binderfs.c
@@ -3,6 +3,7 @@
 #include <linux/compiler_types.h>
 #include <linux/errno.h>
 #include <linux/fs.h>
+#include <linux/pseudo_fs.h>
 #include <linux/fsnotify.h>
 #include <linux/gfp.h>
 #include <linux/idr.h>
@@ -667,7 +668,6 @@ static int binderfs_fill_super(struct super_block *sb, struct fs_context *fc)
 	 * necessary and safe.
 	 */
 	sb->s_iflags &= ~SB_I_NODEV;
-	sb->s_iflags |= SB_I_NOEXEC;
 	sb->s_magic = RUST_BINDERFS_SUPER_MAGIC;
 	sb->s_op = &binderfs_super_ops;
 	sb->s_time_gran = 1;
@@ -759,6 +759,7 @@ static int binderfs_init_fs_context(struct fs_context *fc)
 	ctx->stats_mode = binderfs_stats_mode_unset;
 
 	fc->fs_private = ctx;
+	fc_init_pseudo(fc);
 	fc->ops = &binderfs_fs_context_ops;
 
 	return 0;

-- 
2.53.0


