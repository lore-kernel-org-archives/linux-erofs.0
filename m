Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1B0C606D7B8
	for <linux-erofs@archiver.kernel.org>; Mon, 16 Nov 2026 11:06:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mmCSykMY
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4jSlRV3lS8z2y7r;
	Mon, 16 Nov 2026 22:06:30 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2600:3c0a:e001:78e:0:1991:8:25"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1794827190;
	cv=none; b=K1f2VLIR6CiTW0yIURSWZJr2CqHUfiWz/IRl1RTm+3WiY4aNEtGfe2yhNhUT0DciJiTLeAJGyDrPH4MdWuf5JBTL8rZ0t7Jp6smXV/Mv5HLI/cq88FngwHMV2Atl2qEiw7ptzT3qhQK2hlwFgxbkn6cQ3AJ+Ko4JaDu64GezGZVJnkW5AwjB3YRuvTh/L1g6k4QZlneu3807rMBBKv2qznwEzX7/Ft6B5//XX4/G4eeeseZQwWd1O/E2Brj5vL1DAUfKrPE89c4jW0MnGi8ovlylfUSv7gFRDeNNJaVsqDL0PUC+/lSurYJhUkYviXzIPuVJX3YrRBRHPKI3tcy3CA==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1794827190; c=relaxed/relaxed;
	bh=V+osxLoh40BKAExDHaAgHTnjFjsOBXyAUQavRmbvZdM=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=QtvNltXHYeMP6Yl9Kpr6ED7RRtYZ6QXs/s6sdvqjjXd4no4V+VmT6pSOQE5kQPLpLZl6uridJlips5c5cBRiSiiJ0h11eezBmLgK+loHvLa2ibyO9oFEFlQDejTUpqmtUg4mnXcXLdT2irp9dKB4gKb6FskrIhYnNPvD0zU0a9snUKIbxwgcNUIdfrzIdm7evqkNpvce4rPO9cSbTucDwtuaKYDBCQw5S1ayiFFSU6U0D+j4fyts7v8CZZYl3hAfDwdM9kqmFX10uAhqNts6RyYMfErditj5wdELbr8HXKbThXm67IPkhzRid3i0b5sFCQEj6/jpX6Ju1QANyny87A==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mmCSykMY; dkim-atps=neutral; spf=pass (client-ip=2600:3c0a:e001:78e:0:1991:8:25; helo=sea.source.kernel.org; envelope-from=brauner@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mmCSykMY;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=2600:3c0a:e001:78e:0:1991:8:25; helo=sea.source.kernel.org; envelope-from=brauner@kernel.org; receiver=lists.ozlabs.org)
Received: from sea.source.kernel.org (sea.source.kernel.org [IPv6:2600:3c0a:e001:78e:0:1991:8:25])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4jSlRT5kr0z2xf8;
	Mon, 16 Nov 2026 22:06:29 +1100 (AEDT)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 28F4643DD9;
	Mon, 16 Nov 2026 11:06:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3410E1F000C6;
	Mon, 16 Nov 2026 11:06:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794827188;
	bh=V+osxLoh40BKAExDHaAgHTnjFjsOBXyAUQavRmbvZdM=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=mmCSykMYbLbUMgfAzsTRriPXLKntVd5F4h0335Zci+KFp7/M6E26jCvFFmFm6/FOh
	 ZimtlOfuTCf0AKdMb7DArxCbNTGAd0e0/CO69vZW620lEXfAn1pqfCoje10jxhSc1J
	 cSFCUZF5FEkl71fXKb5wgdAjz1AWCWq6VhUkPeo06V02hbI/WxzaCyHgNvxkzI3sLo
	 2GdAQUK0Zyr6xa2Qe+qIUwF/i/vhwqVU6IgGnQbVzU/wiykqChN6i8GKS5TT8NvnN7
	 zLrxUiks7eYGPstb/dmbg814Xp6NJSPByht4od2BBPOlpnQ+JR68HmJS8oj1md4KvV
	 tKiRrZHSvNGsg==
From: Christian Brauner <brauner@kernel.org>
Date: Mon, 16 Nov 2026 12:04:36 +0100
Subject: [PATCH RFC v3 03/44] target: fileio: check that the backing file
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
Message-Id: <20261116-work-loop-pseudo-v3-3-8cbbea1cf34f@kernel.org>
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
 "Christian Brauner (Amutable)" <brauner@kernel.org>, 
 Chris Down <chris@chrisdown.name>
X-Mailer: b4 0.17-dev-ce4c1
X-Developer-Signature: v=1; a=openpgp-sha256; l=1508; i=brauner@kernel.org;
 h=from:subject:message-id; bh=tSA3soIyhcve68q21MuFcaunaKBcO2eetu56IE80bMc=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWT9epzEXGTe+sJUZYufjwnje3Vtz4w3241//XLYb7Dlz
 clNJz9d7ShlYRDjYpAVU2RxaDcJl1vOU7HZKFMDZg4rE8gQBi5OAZiIxk9Ght6dlz/J/z+mfrBJ
 vHbFY9ZvJotOF860Pjt95QXHWeof7qkzMlxf+8bzxp25H/hkNDaErSk2OqtYfjKAI+ps4N2d1nc
 PbGMBAA==
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
Reviewed-by: Chris Down <chris@chrisdown.name>
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


