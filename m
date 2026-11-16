Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91C6C606AB4A
	for <linux-erofs@archiver.kernel.org>; Mon, 16 Nov 2026 11:13:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=N0jLVzlU
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4jSlXl4BQkz3dW8;
	Mon, 16 Nov 2026 22:11:03 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=172.234.252.31
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1794827463;
	cv=none; b=c/xJbnGC2p2t7dtzmPRP3RO8aBQnzIXfIJqRTbDjXArr7XR2ytZyjdvscGROOTN0r9XYyNP1jC6Ui4m9IHhkIZY//dDozRNczoPmTSqg9KbxIlY480K4vfpl7X4AO7XnVhF7qEeyNDZvR48EY4AXPQbKl141bcekqc3SS3ZP4u8oWn2ky+gF4DEgr4AGltY82OhjtfaF/AXyRH6Zs7d/hfRix1Z93ORUt3cyf+i+J0pvKO+QpoClD3o+gvNpwtwD8JH4BMc0YwYlnNLV1hXIXmS/EoFQ6x8UXP65cO0G4bt3GTdWItZVViQB3V3cSPR6NmPeT6d+YDMOcxuLXwmVLQ==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1794827463; c=relaxed/relaxed;
	bh=+1Ha5ASlzziEtpwFumlx1jHdeafb0Uk6ledTOHN/+BQ=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=VXX0oBu/irSUrPQHIs43vC1H42rG71Yi2iwW6lR+mqxtcjMjuJ9d5llAvvRY+fEzLUN8gluQ7+6jbW6lyZ91Cx27rM7DP9quJI8OkJW4rcy2G3MIoWLd1TWVwpXDb+gG1UGSoSUDOdeb7ngwOoOsnSgoFNpCnfgomEuyXknq3eNSJmGMFTiKt7Fnx9QCwU6fefPOHN4srdL5iZd1XdJb/1nSYaFOce+uRc8tCeYQ1srJ+vFvMQdQBA/wC8y/LrV2Sv9z5ExytBqcsMw0lIF5VNOKlKacZ+/hgt718BLrPm/le1g5BxB2XoyOS1zUpvQ0G8kjL0Yh3wRMUtXsgjRsHQ==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=N0jLVzlU; dkim-atps=neutral; spf=pass (client-ip=172.234.252.31; helo=sea.source.kernel.org; envelope-from=brauner@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=N0jLVzlU;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=172.234.252.31; helo=sea.source.kernel.org; envelope-from=brauner@kernel.org; receiver=lists.ozlabs.org)
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4jSlXk6Cshz3dRt;
	Mon, 16 Nov 2026 22:11:02 +1100 (AEDT)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 5FCBB462F8;
	Mon, 16 Nov 2026 11:11:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B256B1F000C4;
	Mon, 16 Nov 2026 11:10:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794827461;
	bh=+1Ha5ASlzziEtpwFumlx1jHdeafb0Uk6ledTOHN/+BQ=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=N0jLVzlUI4/sjWNYOt0rXQTtyrgdKf5Y0kTKuip2dZyDj+4g/Ze7OYrLUiUsPPEye
	 CjUN4xKWTGOixjV4KcD/jZgCYY6N/+4Z8JHcT7hLcQcrx8q02xe7tYXpY71+xQEHQi
	 DyFRbLRY7DB9BBOX6LHXYX8dkO5Z1aVdfUmhEIvTLaHSBWeb+l8zD8roBzYXX4rqBT
	 yE74qV89FpLs5TJU9EwHKj4pCX4TE4X3Kq2ekdC7rThFYLz4eNiPgoOfUI1au18Vyn
	 pkNLVmlzaNlj37i5uxQXej7cjjXciz8n3fqCszEa5y6nV+Axoq1qL8ATP7YBXt6Xvi
	 rOa1KxM4tYdvg==
From: Christian Brauner <brauner@kernel.org>
Date: Mon, 16 Nov 2026 12:05:13 +0100
Subject: [PATCH RFC v3 40/44] fuse: refuse files on pseudo filesystems as
 passthrough backing files
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
Message-Id: <20261116-work-loop-pseudo-v3-40-8cbbea1cf34f@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=3093; i=brauner@kernel.org;
 h=from:subject:message-id; bh=Qkr0BYXyDd+I7xUdfK34CTesF8mQyxzVRm4u7QW4pjc=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWT9etz7YYleq5CAw4X4sGW+b2Uz1jbJrH8r5vBSK3KaB
 H95VsCxjlIWBjEuBlkxRRaHdpNwueU8FZuNMjVg5rAygQxh4OIUgImcncTI8K+t9HbCCqNJecsr
 BR3atl39NOkGq5CQkcDVYiVj2Y+rnRkZWv6WG+e4sr/I3r2+LPNhivaEm6fb0rycv4m/V7qxpnQ
 JFwA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

The fuse server can register any regular file as a backing file. procfs
and binfmt_misc files are already refused by the stacking depth check as
both set s_stack_depth to FILESYSTEM_MAX_STACK_DEPTH. sysfs and the
other pseudo filesystems aren't. Reads and writes of the fuse file would
then be done on the pseudo file with the fuse server's credentials.
Refuse files on pseudo filesystems just like loop does.

Note that the backing file is only registered here and opened again for
every fuse file that uses it. Only its path is used and O_PATH file
descriptors are allowed since commit efad7153bf93 ("fuse: allow O_PATH
fd for FUSE_DEV_IOC_BACKING_OPEN"). So pass FMODE_PATH to
file_check_backing() to keep them working.

The file that reads and writes are actually done on is opened in
fuse_passthrough_open() with the flags of the fuse file. So check that
file as well and pass the mode the fuse file was opened with. It has
the same path as the registered file so files on pseudo filesystems are
already refused. But this also makes sure that the backing file
implements ->read_iter() if the fuse file is opened for reading and
->write_iter() if it is opened for writing. Like the other failures to
set up passthrough this fails the open with EIO.

Reviewed-by: Amir Goldstein <amir73il@gmail.com>
Suggested-by: Amir Goldstein <amir73il@gmail.com>
Link: https://lore.kernel.org/all/CAOQ4uxhGxpBtMZ5kfuzR1tQAewiecoX7UjXQRo91QjJHH9T_Yw@mail.gmail.com
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/fuse/backing.c     | 4 ++++
 fs/fuse/passthrough.c | 7 +++++++
 2 files changed, 11 insertions(+)

diff --git a/fs/fuse/backing.c b/fs/fuse/backing.c
index 8c21a8a74efb9..7527f3ecb90dc 100644
--- a/fs/fuse/backing.c
+++ b/fs/fuse/backing.c
@@ -147,6 +147,10 @@ static int fuse_backing_open_file(struct fuse_conn *fc, struct fuse_backing *fb,
 		if (inode->i_sb->s_stack_depth >= fc->max_stack_depth)
 			return -ELOOP;
 
+		err = file_check_backing(file, FMODE_PATH, 0);
+		if (err)
+			return err;
+
 		fb->type = FUSE_BACKING_PATH;
 		fb->path = file->f_path;
 		path_get(&fb->path);
diff --git a/fs/fuse/passthrough.c b/fs/fuse/passthrough.c
index 0ed964c479d96..fc8979ac96a21 100644
--- a/fs/fuse/passthrough.c
+++ b/fs/fuse/passthrough.c
@@ -183,6 +183,7 @@ int fuse_passthrough_open(struct file *file, struct fuse_backing *fb)
 {
 	struct fuse_file *ff = file->private_data;
 	struct file *backing_file;
+	int err;
 
 	if (fb->type == FUSE_BACKING_EXTMAP) {
 		if (fuse_backing_is_dax(fb) != !!IS_DAX(file_inode(file)))
@@ -201,6 +202,12 @@ int fuse_passthrough_open(struct file *file, struct fuse_backing *fb)
 	if (IS_ERR(backing_file))
 		return fuse_EIO("failed to open backing file (%ld)", PTR_ERR(backing_file));
 
+	err = file_check_backing(backing_file, file->f_mode & (FMODE_READ | FMODE_WRITE), 0);
+	if (err) {
+		fput(backing_file);
+		return fuse_EIO("invalid backing file (%d)", err);
+	}
+
 	ff->passthrough = backing_file;
 	ff->cred = get_cred(fb->cred);
 

-- 
2.53.0


