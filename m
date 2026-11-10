Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8AC4606EEC6
	for <linux-erofs@archiver.kernel.org>; Tue, 10 Nov 2026 09:22:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=aZVzmHBN
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4jP1N23xZwz3dWD;
	Tue, 10 Nov 2026 20:20:34 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=172.105.4.254
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1794302434;
	cv=none; b=WzwZ1UOXsbeoXw/uv0O8JVedRQ/nOrp0hqjOXobo80qVHXO4+BQKEk8dRF+6dJ5f3UIZ+F/mRAXklKgGP8VLBRBj+UeRngnb/sgWbPGlX83vm0eMLvZPytQmobBDoYOcNNa8otDX85WtEtCjCdoHfEZt7BG2oIAf2EJy7J58RJt2UGbYuuBor9A76TyNpHeuVCKmgIvydBfZNPnCcBsa0ZXblXddxpUdc93IuQNzDPqso+nsLoVXkxpJrvF6xZKfbBJ2k8JcSM9x0KDQf7rJDQ6RPKPkxWUUS7aeMwQOgRd2SUyjLZoiOGHgOU5+DefvURfTtCGXRJKvPLT8ddmnxQ==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1794302434; c=relaxed/relaxed;
	bh=YJdQfmNRZIjJZmJ7eXlopktH5jFS//yu5Pe53ZYQ028=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=bqtaODcpZCx40/oodHvJwcLBlXaUhbzwwuudzhijIrtkEGWI7xZbq8fsxsf6aT3Cf6+yuxZf8CUyMDgUGI9Jm71MOn+mgqvgHc1F9Sbzc46kNElxOwRSDqXxTK38EYUJfdzcxJdBfCvvkwN7F1C3GjrJJmU66HoyLLTExgaOZE+sy8D9ZUr8rf9yvQQvHWgO0+UFRakuJKmEu9hmsPH9u2A23AWHs9kjgelKleIE2PAeleExpQLfYYtaSr/Y4WEJ6uPFxp/AfWHIoeCQMCJY1wxykNuLMEx/aOKustiaZ2GEpreIxxAx4ukxT4/NoHE2kxz9bMgpnUuO1JIEBtq6bA==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=aZVzmHBN; dkim-atps=neutral; spf=pass (client-ip=172.105.4.254; helo=tor.source.kernel.org; envelope-from=brauner@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=aZVzmHBN;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=172.105.4.254; helo=tor.source.kernel.org; envelope-from=brauner@kernel.org; receiver=lists.ozlabs.org)
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4jP1N1401mz3dVr;
	Tue, 10 Nov 2026 20:20:33 +1100 (AEDT)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id AAEFE63825;
	Tue, 10 Nov 2026 09:20:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24AA31F008A6;
	Tue, 10 Nov 2026 09:20:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794302431;
	bh=YJdQfmNRZIjJZmJ7eXlopktH5jFS//yu5Pe53ZYQ028=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=aZVzmHBNuwJ61+F1e2oV+4dv4gNlfmbtkL/jYHqJnnAR8nxpapvLT1jaqObFS3Kt6
	 Ta83UhzRz8CvexZ0ysKoa1MoO3Zu6STABRZGed6dESQ7WUcbM2CZMcu26UAdqYXcUi
	 jGRxcd1PuvngpWsUZ9wdr1xrWLiH+HYWR1UJUrQbfn+O+Yx9/8C2d+1m8jfwdUrWlh
	 x7irI9TSUWj+2x5RTqa6GOQ9Qm8DWqqbMA4ng0XxJzOZmiUTRMHuCfCm4DvyHXloD3
	 13saqaue/D0rL6M4JYSaME0ZwZWtpV6O8u9WPkmcnvoBepeZUJpTLw5Bl66Aroqny1
	 QozwErkn3D9Og==
From: Christian Brauner <brauner@kernel.org>
Date: Tue, 10 Nov 2026 10:14:56 +0100
Subject: [PATCH RFC 40/41] erofs: refuse files on pseudo filesystems as
 backing files
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
Message-Id: <20261110-work-loop-pseudo-v1-40-4c998976c6c7@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1370; i=brauner@kernel.org;
 h=from:subject:message-id; bh=NydLncApPlv7Xb4803UYyRsruwye9LOqDMcupA3ko3I=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWR9enCotFA5svjs32+5V/jKOVd3VfaxP+2o4TjJ9eAot
 9K2J1P4O0pZGMS4GGTFFFkc2k3C5ZbzVGw2ytSAmcPKBDKEgYtTACbydB0jw66Sm4EFNRm7ox68
 2SVYs2OfsAHnhYkt+fUvbmadaZ28QICR4WLbxMemdRPmu/26Zds+2yJaate+vNkOVz78PC+SI7H
 SjgcA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

File-backed mounts take any regular file as the image and the same goes
for the extra devices of such a mount. erofs reads them with the
credentials of the mounter so this doesn't hand out anything the mounter
couldn't read anyway. But files on pseudo filesystems aren't images.
Refuse them just like loop does.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/erofs/super.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/fs/erofs/super.c b/fs/erofs/super.c
index ce05557bd998..980d5fc2b576 100644
--- a/fs/erofs/super.c
+++ b/fs/erofs/super.c
@@ -158,7 +158,8 @@ static int erofs_init_device(struct erofs_buf *buf, struct super_block *sb,
 		if (!erofs_is_fileio_mode(sbi)) {
 			dif->dax_dev = fs_dax_get_by_bdev(file_bdev(file),
 					&dif->dax_part_off, NULL, NULL);
-		} else if (!S_ISREG(file_inode(file)->i_mode)) {
+		} else if (!S_ISREG(file_inode(file)->i_mode) ||
+			   file_is_pseudo(file)) {
 			fput(file);
 			return -EINVAL;
 		}
@@ -835,6 +836,9 @@ static int erofs_file_get_tree(struct fs_context *fc)
 {
 	struct erofs_sb_info *sbi = fc->s_fs_info;
 
+	if (file_is_pseudo(sbi->dif0.file))
+		return invalfc(fc, "source is on a pseudo filesystem");
+
 	if (!test_opt(&sbi->opt, SUPERBLOCK_SHARE))
 		return get_tree_nodev(fc, erofs_fc_fill_super);
 

-- 
2.53.0


