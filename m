Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75CAE606A332
	for <linux-erofs@archiver.kernel.org>; Sat, 14 Nov 2026 13:12:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Ty8/r0So
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4jRZGs0jJGz3f15;
	Sun, 15 Nov 2026 00:09:57 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2600:3c0a:e001:78e:0:1991:8:25"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1794661797;
	cv=none; b=l5Wk2feQUpEIOH27/muM4FyCv8lBDIr4kJRIFucsBhjydrpQ+hRyv4X77CTqfZSH39sr02lOODQz/XWTax2R2B8RG5E2AhFrxdHeTBdCc1r6a+xfXJ81L9UQTvYiFsWt2Sp+X14f7oo0oNDyoQE8gwMmB45jSDIi+r8Smda2wfyRcoCvcRs1bZ7KtCCgVhFABDjD7zWZ8kRss2gatTrsKGPisvC70/nCkg1xJss0OGWE0GLA/rBa+BL5WNUc1TrZU9LNT94GzapDKJDthNra2ZRkg8slsA+WySh+ZNyMOM9E3rUQFJNDg54OWaXw0elZCr/frBow2SWZTe31lgBycQ==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1794661797; c=relaxed/relaxed;
	bh=fZyqvTAJYFugTtfLrdTGe2itrOrTKvVMIRQURP2gQHw=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=FT0LsvyhFpd3wtYRGzKrfnxbc0i1yf289g4FOWNeAqntAePqwbnl8OXLXkmCqXt+tS2SJeKf1G6k0J9iO7VJMrrr2Fxd5iVeLClTRpTG/YGai/ug9Za9Ziso9CV/eEyUyQjNpFuNicBrnLJM5jlmG0LEvn9L6JciLyv9zebqqeLN70ODfVHrGdt1OM2p9QIHKyLDdt0XArl5mF5o7K50pwLKLUM7zG/8EAFIcZPfEEo0CW92Yidv6hqYwAeEOZ9p4mMIXSOCIhri8mt1J5einzZbiR8Y/OhpxvI0CQGIsF3aGLssqt21G8e562GycAxj4PZhB1nReCpMFy7pJlNXRw==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Ty8/r0So; dkim-atps=neutral; spf=pass (client-ip=2600:3c0a:e001:78e:0:1991:8:25; helo=sea.source.kernel.org; envelope-from=brauner@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Ty8/r0So;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=2600:3c0a:e001:78e:0:1991:8:25; helo=sea.source.kernel.org; envelope-from=brauner@kernel.org; receiver=lists.ozlabs.org)
Received: from sea.source.kernel.org (sea.source.kernel.org [IPv6:2600:3c0a:e001:78e:0:1991:8:25])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4jRZGr1ympz3dkm;
	Sun, 15 Nov 2026 00:09:56 +1100 (AEDT)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id BFD284657C;
	Sat, 14 Nov 2026 13:09:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FE891F000C4;
	Sat, 14 Nov 2026 13:09:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794661794;
	bh=fZyqvTAJYFugTtfLrdTGe2itrOrTKvVMIRQURP2gQHw=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=Ty8/r0SoMUqxO4LrNlfBZ8jM+8/0m/Yce0IMqMBaJmgGc4ZGWPEqHBehqsfDPy+BR
	 7ef+eIqu+WmvEMZfLPmETCepGidhu2UkGPQ0nTWhjjjuRnwcFNiN6JzDR1fRA1/ugZ
	 Sn6LVjLv9jAcLEQBHwoyMpIdcNUEDbbRAZTR3aGQK3rufuCJq/cnndIhDlgUJy9O2f
	 s8N4jEwp0PEH9JhOgls40BEgYiB1OOpcBsPu5jb0Z8jZteTY7OSFJ5bvMKLOtswjjD
	 pCiBAvVrnmgUx9Fr/vgwDkzbuX+HpQAkfTAlSP6UjZymqEm2v8y36GJ4FGcks7sAfP
	 jVvqXF2NJyHKA==
From: Christian Brauner <brauner@kernel.org>
Date: Sat, 14 Nov 2026 14:02:18 +0100
Subject: [PATCH RFC v2 37/42] target: fileio: refuse files on pseudo
 filesystems as backing files
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
Message-Id: <20261114-work-loop-pseudo-v2-37-98639a2286fb@kernel.org>
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
 Sashiko <sashiko-bot@kernel.org>
X-Mailer: b4 0.17-dev-ce4c1
X-Developer-Signature: v=1; a=openpgp-sha256; l=2129; i=brauner@kernel.org;
 h=from:subject:message-id; bh=xgyzkhEOeMIb5OW3d10L8uW2mAkBVhLOiqNzKM5XfpI=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWT9iJlQ21ua5fP3d++vyX77z2zLm/wtYK6mnmdGnefJJ
 ZPudHDadJSyMIhxMciKKbI4tJuEyy3nqdhslKkBM4eVCWQIAxenAEykWJ3hn07xtqPzj9wUZ7vy
 edLyTyHJHLN7PitM3LpayFxXR3yVlz8jQ7//U8b9N/kvXLob3vlgj1P9psj3Uo6hOtH7Hi5Onjd
 1NgsA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

fd_dev_name can name any file including files on procfs or sysfs. The
initiator then gets to read and write kernel interfaces through the LUN
with kernel credentials. Refuse files on pseudo filesystems just like
loop does by switching to file_check_backing().

Do the same for the protection file. With DIF protection enabled the
fileio backend keeps the protection information in a second file. It is
named like the backing file with ".protection" appended and
fd_init_prot() opens it by path. Whatever that path leads to was taken
without any checks.

Note that the helper only accepts regular files and block devices as
backing file and only regular files as protection file. So far the
backing file could be anything with ->read_iter() and ->write_iter()
including character devices and FIFOs.

Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://lore.kernel.org/all/sashiko-outbox-206765@kernel.org
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 drivers/target/target_core_file.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/target/target_core_file.c b/drivers/target/target_core_file.c
index a5391e57e9aa5..c747cc4a647ff 100644
--- a/drivers/target/target_core_file.c
+++ b/drivers/target/target_core_file.c
@@ -145,8 +145,8 @@ static int fd_configure_device(struct se_device *dev)
 	}
 	fd_dev->fd_file = file;
 
-	if (!file->f_op->read_iter || !file->f_op->write_iter) {
-		pr_err("FILEIO: %s lacks ->read_iter or ->write_iter\n",
+	if (file_check_backing(file, FMODE_READ | FMODE_WRITE, S_IFBLK)) {
+		pr_err("FILEIO: %s can't be used as a backing file\n",
 		       fd_dev->fd_dev_name);
 		ret = -EINVAL;
 		goto fail;
@@ -861,6 +861,12 @@ static int fd_init_prot(struct se_device *dev)
 		ret = PTR_ERR(prot_file);
 		return ret;
 	}
+
+	if (file_check_backing(prot_file, FMODE_READ | FMODE_WRITE, 0)) {
+		pr_err("FILEIO: %s can't be used as a protection file\n", buf);
+		filp_close(prot_file, NULL);
+		return -EINVAL;
+	}
 	fd_dev->fd_prot_file = prot_file;
 
 	return 0;

-- 
2.53.0


