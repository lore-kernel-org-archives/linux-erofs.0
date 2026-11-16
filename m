Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F0DC606AB7E
	for <linux-erofs@archiver.kernel.org>; Mon, 16 Nov 2026 11:06:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kXBXegK7
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4jSlRC5Nj2z2yMK;
	Mon, 16 Nov 2026 22:06:15 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2600:3c0a:e001:78e:0:1991:8:25"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1794827175;
	cv=none; b=migmMg8s616HsN59j+sEmiZpsSQUdVjJIq0b+QThTJfY/1zEwWIR8g3X89NAXPZHcXjprHkXkxXtlNq0dtYeCVBmfLJOfGW6LqBjqODTgTE22glGY3X/rEwa6Gjdq5NoR/LVbBn4388xdjllnlYH5wZiiscYOsCZzeQqkzqOs+BKP7tJLMz0CZD4xgnpBLJM3PbLT3InCw7J5xR+xzwgf9dXlt3Fk4zfyxVZTHP9EK/OAY8GdLgEr6XoNfpd9bXPHRTSdLV8g86O6KVk6jv2a9QuHRRIotmUSpKiHTNud5p49zHu2rXOEeXH5MM6SZI4xuHP1ttIQchhvYNZ/dAz1w==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1794827175; c=relaxed/relaxed;
	bh=H9E1u11sECBJWFTmloDJmZ13PYN0Kwn0d7kmiA3OBRM=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=WfygP/cIjC5y0sIqPRlX2L1iuVr1+m20AkStj3rYWek7YOXKtwIc81VrBfs4w5QRabSVEdXfoP2PP2h63cUJSZLvj0TZDTYeEAQvRFtUjf6kSL11goo1wc/BDOFN8Lm9oPgAj05MywhHWBi0j7PsQRlZN29iv/uGZhRB71rZijt0yUuS3YR1nszw5kUIhNUCiCPT1JMOKkQdzUd3gHw8dS1lUDDYg3zH/WGnz3rWRSUIGbAmgbNGbsYWlzdnS09QJtFjI7+FdovbIaBpmP9M8SGzjB34vHZ8OgLXuSRNEUr4aMgv385omTbb19wj07aRIu2BUX0Km7IBk/obqwesvQ==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kXBXegK7; dkim-atps=neutral; spf=pass (client-ip=2600:3c0a:e001:78e:0:1991:8:25; helo=sea.source.kernel.org; envelope-from=brauner@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kXBXegK7;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=2600:3c0a:e001:78e:0:1991:8:25; helo=sea.source.kernel.org; envelope-from=brauner@kernel.org; receiver=lists.ozlabs.org)
Received: from sea.source.kernel.org (sea.source.kernel.org [IPv6:2600:3c0a:e001:78e:0:1991:8:25])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4jSlRB6kgQz2xf8;
	Mon, 16 Nov 2026 22:06:14 +1100 (AEDT)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 5719846263;
	Mon, 16 Nov 2026 11:06:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E916E1F000C5;
	Mon, 16 Nov 2026 11:06:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794827173;
	bh=H9E1u11sECBJWFTmloDJmZ13PYN0Kwn0d7kmiA3OBRM=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=kXBXegK7dC1dL/bZ9+nDwuLsEdWqEdkGm3v8QYa4xbauZMWbuGG7TJof+GlVspgc6
	 FrsnozDmBgYNMx5PleVEdEj2kZOxs0GZRkgg5V0hZc5AB3JrL5tiIO0h1vvhhokZG0
	 r5PLjrDcCnZ3+X5jM6ZwF5fzae5BhkGDz/vxX/H+//UMQhBi+YsjA2sgBohg411S3f
	 RN15M3gCu2W0VEVkAPsWZOa8JJoL2By17j+phnGfheP6VMWIuS9AUGqX9gr9kFKR/l
	 67+V1J8Lq73Ymyu3xj3kOn/Rf1GEfYGbirIZghea1NE/yTr0T0Dq2uoKqDapAJl18F
	 AxXY+14O7YRpA==
From: Christian Brauner <brauner@kernel.org>
Date: Mon, 16 Nov 2026 12:04:34 +0100
Subject: [PATCH RFC v3 01/44] loop: refuse backing files that aren't open
 for reading
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
Message-Id: <20261116-work-loop-pseudo-v3-1-8cbbea1cf34f@kernel.org>
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
 "Christian Brauner (Amutable)" <brauner@kernel.org>, stable@vger.kernel.org, 
 Alexander Mikhalitsyn <alex@amutable.com>, 
 Chris Down <chris@chrisdown.name>
X-Mailer: b4 0.17-dev-ce4c1
X-Developer-Signature: v=1; a=openpgp-sha256; l=1877; i=brauner@kernel.org;
 h=from:subject:message-id; bh=VBI+uMCHtIBDpXye3IfyuEMYz0sbcx7ROCm69jjOsKw=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWT9ehy/1dSsii0m7V7enfhfyQ9t559yePWxhStUzHL59
 E16H/9XdJSyMIhxMciKKbI4tJuEyy3nqdhslKkBM4eVCWQIAxenAExkexojw+QQwXjlawZzkoPn
 qlueuOPxgnWa9MKE0D0SQYo37ztI+TH8j9bMlUzVqnrt+1BljeVHrpWttpeFOvw6ujdOmSEYuUC
 KAQA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

loop_configure() takes any file as long as it implements ->read_iter().
Loop itself never checked whether the file was actually opened for
reading. Buffered I/O went through vfs_iter_read() which refuses files
without FMODE_READ. Direct I/O has called ->read_iter() of the backing
file directly ever since loop grew support for it.

Since commit f2fed441c69b ("loop: stop using vfs_iter_{read,write} for
buffered I/O") buffered I/O calls ->read_iter() directly as well. That
commit was about O_DIRECT handling and the FMODE_READ check went away
as a side effect.

So whoever can set up a loop device can read a file it was only allowed
to open for writing. Open the file O_WRONLY, configure a loop device
with it and read the contents through the loop device.

Refuse backing files that aren't open for reading. Loop always reads
from its backing file so a write-only backing file never made sense in
the first place.

Fixes: bc07c10a3603 ("block: loop: support DIO & AIO")
Fixes: f2fed441c69b ("loop: stop using vfs_iter_{read,write} for buffered I/O")
Cc: stable@vger.kernel.org
Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Alexander Mikhalitsyn <alex@amutable.com>
Reviewed-by: Chris Down <chris@chrisdown.name>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 drivers/block/loop.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/block/loop.c b/drivers/block/loop.c
index a3325ceab484a..c96e35c3ef423 100644
--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -528,6 +528,9 @@ static void loop_assign_backing_file(struct loop_device *lo, struct file *file)
 
 static int loop_check_backing_file(struct file *file)
 {
+	if (!(file->f_mode & FMODE_READ))
+		return -EBADF;
+
 	if (!file->f_op->read_iter)
 		return -EINVAL;
 

-- 
2.53.0


