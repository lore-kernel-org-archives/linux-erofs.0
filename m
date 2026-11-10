Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A368360A382A
	for <linux-erofs@archiver.kernel.org>; Tue, 10 Nov 2026 09:16:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ba3Pyp5O
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4jP1Gw0YmJz2yr0;
	Tue, 10 Nov 2026 20:16:08 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=172.234.252.31
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1794302168;
	cv=none; b=NZbzVP5VxHn4VJaN9J/J0143pTShwdoOglBy2c2WKmCiiTU3fRaht560VFVCeDU6DFeEu4UQCStZ+fnFa4/5S6/WOGkIQfm8TrJh4RCba3o9Y2DTu2WmMURNjODdHsq6NEkPlp9MxFtiCCR4lsq2+gPgIuhjLjST/1QVJGIWu2f3XqHmNSU3SE6KJfd6wBpa+bC+I9ItVptN/XJIun0/9/opWFnRrXURaGbMXZLrRnQ6dpaZq5CZM+4+Cxxw6v4brTrmw9dCB6hqkAfAxbbKhMAw8Yytyg9pooYri4m6JTUFO3UTbykkhJAKEaknD6FyfLka/CCtyxY4WRR1yOnryw==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1794302168; c=relaxed/relaxed;
	bh=2Uxnm4Cd0mizACq2HNobDQRQcgrPnhEO2KA80+bveeM=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=c5regH+vePB101vOaf5lMAHSkTAhYnDpA8+mD4qVywR8qQ3xU6pPuBv8l3Z32kedDpUfFF99jxbiVtJ2aHi+/xsUI/J8PILPcnVuIezQP5F1IsHntxIM1qhgf0YhELOelQQsBNh4A8KwfWNxjjludZ/MFNQTunHSUVqpRANMehUzNkI+kgQqvDQhW1Z/wpp1KETocWREERmsCwrRfO+Q2KeHgrj23c85H/QxnsEkIp3clK3ns8NiucwT29xskDpDnzJZ2sRvaOnFug0HjfEJ4Re+FVk+ktJlXPNNPn3N1TKYfbRWASkuwZaam+qXW6xcEYs6WMAvpboKPfkYk2GmBA==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ba3Pyp5O; dkim-atps=neutral; spf=pass (client-ip=172.234.252.31; helo=sea.source.kernel.org; envelope-from=brauner@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ba3Pyp5O;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=172.234.252.31; helo=sea.source.kernel.org; envelope-from=brauner@kernel.org; receiver=lists.ozlabs.org)
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4jP1Gt6vF1z2xfK;
	Tue, 10 Nov 2026 20:16:06 +1100 (AEDT)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 95A4E45731;
	Tue, 10 Nov 2026 09:16:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D92891F008A2;
	Tue, 10 Nov 2026 09:15:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794302164;
	bh=2Uxnm4Cd0mizACq2HNobDQRQcgrPnhEO2KA80+bveeM=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=ba3Pyp5OpjsLWNS18IN6KJmuJFLn691WGOW4O+tQFCTWln2eXYVZ3JE1wBRhcmoW6
	 hLpwpT4jz67cKW4CJB9uIhzhbMhfgiFHlr2CZK53VaqCwK5HM1YqSaiFHCScsFMBkn
	 Q0OzOCwsepsGyP/WRgtRo4+3FcZl8eUfyuWZ7KuL8XDVDG6tcU8rd25pxcEBVszf1y
	 XJvR4c13VrmJU77uH8rLkN68FB+fLrhpSvF6buW7PxoKBBbfZNWSogmUA09LLIYVWc
	 o8T8B1sqCgT2o3NyN+rjS4hlvf0pw7ESlo7MI8nYdimYq23hA2cdZ9j7+asrP+da9o
	 Z/f8j2gHp/WZg==
From: Christian Brauner <brauner@kernel.org>
Date: Tue, 10 Nov 2026 10:14:17 +0100
Subject: [PATCH RFC 01/41] loop: refuse backing files that aren't open for
 reading
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
Message-Id: <20261110-work-loop-pseudo-v1-1-4c998976c6c7@kernel.org>
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
 "Christian Brauner (Amutable)" <brauner@kernel.org>, stable@vger.kernel.org
X-Mailer: b4 0.17-dev-ce4c1
X-Developer-Signature: v=1; a=openpgp-sha256; l=1688; i=brauner@kernel.org;
 h=from:subject:message-id; bh=k5rFTn5qwSY0P1NIV6SDcJMZmh5p3efbZZ8FHYDs+to=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWR9ejBVvfNKBs+f5kIhpoaev8LtD4oXZ1xL0i19ll21p
 i5fZsmkjlIWBjEuBlkxRRaHdpNwueU8FZuNMjVg5rAygQxh4OIUgInc3s/I0OHqXaH2k1fp545n
 UtNUpkUwfzq4/7uEmpjnzfcNZ9bvT2JkeCygm5CxsPhqWqRgSqf6D/8dk2afLnMX1LJ/rjh/3zZ
 BPgA=
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
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 drivers/block/loop.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/block/loop.c b/drivers/block/loop.c
index a3325ceab484..c96e35c3ef42 100644
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


