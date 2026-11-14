Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C08A960A261B
	for <linux-erofs@archiver.kernel.org>; Sat, 14 Nov 2026 13:06:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=MpJVcMTY
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4jRZBJ0MjNz3bfV;
	Sun, 15 Nov 2026 00:06:00 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=172.234.252.31
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1794661559;
	cv=none; b=FugSlwm3CxB/XzctZtOBWtPTfVxJ6FBwY1kJtTgH7o6yvW337I5lkUTQYL3yCM2/FmYF3vhO0wQqFVKi7JX56hUrAtRI6Iv2/n/4W3po6XU9jPulqt/JJc1YLSN3QAOBCUaNfwDZ1w1H7S5st4sF4j7lDdeXtMnMjOD6Ximo8v2LGwmIbBvi528NeBFdgphejNYyX1rGG6MEg/1zhxayvt1GbxQhvOpNSLk61o8dj0hcUSmtGx+qRcybyjVyaPyNAZudRrcuI+tIyGTBPehVogVGMrEiqPUzf61VsAQcLweAf91h09DE3W1OpDHJgtSvydLyCHiheB1HMc6zwG0PCg==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1794661559; c=relaxed/relaxed;
	bh=r6ZhD6v1VAC9LFMiPIrPjYVjUm9OFEumnB2zMtz0O/0=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=ZPkKPMbdYaAFkywAw1QJQ/teSye99mdVZcSvGIFmN1HwHUwG6xMcvnXmr4wysW2OPCek/XYHjQ5XlqaPuQqQukF3mrqqwsNFuGc9fSONFI5qyay50khp3mx8QyIOP1DUM/G/GXKrExQk+qdxaEA5xcehQi2NFRt/7Qn+gt3tb7JpE6007VoUMBhD+axSdb2z8iNZS7AssRJKf84GwQ/F7pvI2JS+Lw86XAz9rcNDelUjDhsecmK/XOgxdziv/SvQDa2uP4SHZnmLC0UdZUOnTdTANRAuiU4PurIXSiAp3Wf70ixx3QwDky0IklajjxkRNIDq5Y5YwXdmeOCAU0Zjww==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=MpJVcMTY; dkim-atps=neutral; spf=pass (client-ip=172.234.252.31; helo=sea.source.kernel.org; envelope-from=brauner@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=MpJVcMTY;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=172.234.252.31; helo=sea.source.kernel.org; envelope-from=brauner@kernel.org; receiver=lists.ozlabs.org)
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4jRZBH1tvQz2ynZ;
	Sun, 15 Nov 2026 00:05:59 +1100 (AEDT)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id BDA3240B44;
	Sat, 14 Nov 2026 13:05:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71E051F000C9;
	Sat, 14 Nov 2026 13:05:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794661557;
	bh=r6ZhD6v1VAC9LFMiPIrPjYVjUm9OFEumnB2zMtz0O/0=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=MpJVcMTYApPZc7VozOSSmaXGxWwwgxOxiDGjTzhesY26ZSs/xNhwwdDIDL0zR46b0
	 W24cPjHL9Gyz2tmsdI2SZ1yAOIBcFIhBnPjCrQg2xaMcZtEWnbfvhWfVUXxY1N/Y+1
	 x7BIMwdp4kJhjoQq27aXY340AMvCIq9P2DrFIOyfPVCPJ5xs9RWXl9JHBQYKOWuud8
	 wvITPU/pQjvqn+W9V89fmzuCuW4Cwhv2tpUp3HqbUNBmkJwQ0riUqK0zrXSlsQ65ZJ
	 l3Cj8QQbq5mCnD/EO8LJr58gJzqPZx/uTT9g4OZqsMUvqRomSCrCoZjw8Em01eokpW
	 /XnZdvsBfixeQ==
From: Christian Brauner <brauner@kernel.org>
Date: Sat, 14 Nov 2026 14:01:44 +0100
Subject: [PATCH RFC v2 03/42] target: fileio: check that the backing file
 supports ->{read,write}_iter
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
Message-Id: <20261114-work-loop-pseudo-v2-3-98639a2286fb@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1460; i=brauner@kernel.org;
 h=from:subject:message-id; bh=+p5P27LAsW3o7uyqtxsmCGm9+GYqGVB9cSFLMBczGcU=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWT9iMncq/F3Gqdfy3ml2pz6Cf16VQLrWpz9Pe6Ltv6/x
 ysXsqqio5SFQYyLQVZMkcWh3SRcbjlPxWajTA2YOaxMIEMYuDgFYCI7fzMyTDnBc2fvPj7dwBbt
 Y32T7r5v36qWePZ+2WHraW+0ZwvH32H4H/HwwN1Nz2oWldU/1cn9XNqxx+bkkusBpYfP2X5oK3x
 8nh0A
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

With fd_async_io=1 the fileio backend calls ->read_iter() and
->write_iter() of the backing file directly. The synchronous path goes
through vfs_iter_read() and vfs_iter_write() which check for them but
the aio path doesn't. So a backing file without them calls a NULL
pointer on its first I/O.

Refuse such files when configuring the device. On the synchronous path
every read or write that needed the missing method failed with EINVAL
anyway.

Fixes: 769031c92c8b ("scsi: target: target/file: Add support of direct and async I/O")
Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 drivers/target/target_core_file.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/target/target_core_file.c b/drivers/target/target_core_file.c
index ab9824a4852f1..a5391e57e9aa5 100644
--- a/drivers/target/target_core_file.c
+++ b/drivers/target/target_core_file.c
@@ -144,6 +144,14 @@ static int fd_configure_device(struct se_device *dev)
 		goto fail;
 	}
 	fd_dev->fd_file = file;
+
+	if (!file->f_op->read_iter || !file->f_op->write_iter) {
+		pr_err("FILEIO: %s lacks ->read_iter or ->write_iter\n",
+		       fd_dev->fd_dev_name);
+		ret = -EINVAL;
+		goto fail;
+	}
+
 	/*
 	 * If using a block backend with this struct file, we extract
 	 * fd_dev->fd_[block,dev]_size from struct block_device.

-- 
2.53.0


