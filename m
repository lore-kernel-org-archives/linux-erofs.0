Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A183606A33F
	for <linux-erofs@archiver.kernel.org>; Sat, 14 Nov 2026 13:11:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=UVaFfwiA
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4jRZFh3dyNz3dRc;
	Sun, 15 Nov 2026 00:08:56 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2600:3c0a:e001:78e:0:1991:8:25"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1794661736;
	cv=none; b=SnwbcKSBZbxg74d++vu1sbBgDeMlt/wIQmdQcdrytJS8TvVI2Qt3nPER0NHfHo88+fhStCoHFE5jO7NxKp0CAzwKx67LHc+uev54s6NpXc0xdMe+Zv98WFNvmglHwzXKuU+RrebKcymtr9f7SOl1c/VC/TnosBJsF/RceJfC5MZC99CgyTyYY9N/cgXIbiV58e9B09xOUSUJFQ0QR4BMAvxnyEHjtzumM558Z8VIo0gUKHfVytbxUjwN8tnlKHF7o2gWaC6Q+G0adiv4Qu7HRW7MO9i29Hh04Yc1OHc/C8jwwaRpON0Vgmjcw3kqPeMQDLDuUkJeR6+qyx9yawNg8w==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1794661736; c=relaxed/relaxed;
	bh=NVjzjsuRRB2UDEz9oF8zpvzwY092/ejVSFo+HtliIvc=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=LrCPmjH++jChxYa4iUefhAjfwCWuvlN613a2W65shXKYXPBHwwqW3uiuDJTu49/rofPVGFgZgshtysfHHdCxZlJ6VBQHSwY3q5jVYBJEJ35jGndJkvbdXW9bYUOl0BfTZ2Ng4BJSYy4ilENWTaeGNov6eM+s6fehReZkOy0PoBGk1/MR/1dDv8bN5eywZ+pBrotuvg6ZHBXouZj4vU7w8gFKrtJBtYGmBIK9h0/v33FTKo3O6ngqUvoBDfAJyEj9SlvpbQNnUZlsfscsL1RGwLNoM5mP1b+jwDnGqT941sZddIwExJzAl77zbBipnOkNQU7eU6PIpjjSlonMnHMYCQ==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=UVaFfwiA; dkim-atps=neutral; spf=pass (client-ip=2600:3c0a:e001:78e:0:1991:8:25; helo=sea.source.kernel.org; envelope-from=brauner@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=UVaFfwiA;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=2600:3c0a:e001:78e:0:1991:8:25; helo=sea.source.kernel.org; envelope-from=brauner@kernel.org; receiver=lists.ozlabs.org)
Received: from sea.source.kernel.org (sea.source.kernel.org [IPv6:2600:3c0a:e001:78e:0:1991:8:25])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4jRZFg6h7qz3dLn;
	Sun, 15 Nov 2026 00:08:55 +1100 (AEDT)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6BCE543CBA;
	Sat, 14 Nov 2026 13:08:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D93491F000C5;
	Sat, 14 Nov 2026 13:08:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794661734;
	bh=NVjzjsuRRB2UDEz9oF8zpvzwY092/ejVSFo+HtliIvc=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=UVaFfwiA5zRIimVEAgzAS5LMrrD01HUXKaMpbor+Rz5AOd2vHoPXCqbvdwGWBTrIB
	 m5kX7dz7AGGAwjJjuW0l/5mNTBXOF7cquK+ncIk4FTMBAgz4L/swi8yUiHI0e2qgAr
	 6bp+zKbJsJ9HY/cYKdz1lp/ddP0/dfUVi5m/8oneZVxiQWMDTgO2bliKT++Ie3Uv6a
	 8l0UllhuQ7TbovBebBzVOisEiB4Ok49OQ9H6KpFib98QFm6PM9KhfCivOUR1UsxvCZ
	 9aPQWq9qVax1nQI6TBMVoXocUs+GlzxhB7TqjHWemtwD7yZ1EJQ9uSokpve4k0Q1J0
	 aujFNglRVEFlA==
From: Christian Brauner <brauner@kernel.org>
Date: Sat, 14 Nov 2026 14:02:09 +0100
Subject: [PATCH RFC v2 28/42] ocfs2: use fc_init_pseudo() for dlmfs
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
Message-Id: <20261114-work-loop-pseudo-v2-28-98639a2286fb@kernel.org>
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
 "Christian Brauner (Amutable)" <brauner@kernel.org>
X-Mailer: b4 0.17-dev-ce4c1
X-Developer-Signature: v=1; a=openpgp-sha256; l=949; i=brauner@kernel.org;
 h=from:subject:message-id; bh=+FO4Y1ymqMYAnXNVc9VhiJCBK4eGvv0E7gd9oyLRaz4=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWT9iGk7WjSP46SwS3e7d4Kv6MyOb6bppW3Xqv6V7uHTL
 Jc4cvtcRykLgxgXg6yYIotDu0m43HKeis1GmRowc1iZQIYwcHEKwESUxBgZnt04pCb0syGDj0eq
 f4e31jfLPX8LHQNWd/7buu8nC9PpW4wMu0Xb+E2Xc3o2TOOI4xToZ91mWvKBzUnka3RtdNyx738
 4AQ==
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Initialize dlmfs as a pseudo filesystem. This raises SB_I_PSEUDO and
also SB_I_NOEXEC and SB_I_NODEV. dlmfs never holds executables or
device nodes.

Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/ocfs2/dlmfs/dlmfs.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/ocfs2/dlmfs/dlmfs.c b/fs/ocfs2/dlmfs/dlmfs.c
index d3bfcada3e3bf..1789ec96dc130 100644
--- a/fs/ocfs2/dlmfs/dlmfs.c
+++ b/fs/ocfs2/dlmfs/dlmfs.c
@@ -21,6 +21,7 @@
 #include <linux/module.h>
 #include <linux/fs.h>
 #include <linux/fs_context.h>
+#include <linux/pseudo_fs.h>
 #include <linux/pagemap.h>
 #include <linux/types.h>
 #include <linux/slab.h>
@@ -563,6 +564,7 @@ static const struct fs_context_operations dlmfs_context_ops = {
 
 static int dlmfs_init_fs_context(struct fs_context *fc)
 {
+	fc_init_pseudo(fc);
 	fc->ops = &dlmfs_context_ops;
 
 	return 0;

-- 
2.53.0


