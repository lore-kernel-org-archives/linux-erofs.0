Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18803606A32E
	for <linux-erofs@archiver.kernel.org>; Sat, 14 Nov 2026 13:05:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=efVM9o/h
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4jRZB34bWZz30hq;
	Sun, 15 Nov 2026 00:05:47 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2600:3c04:e001:324:0:1991:8:25"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1794661547;
	cv=none; b=W2JFbspxkwjMWezVdWDSKAGLL1NocEA4R8SY7b/Z5wwmV7qnNj56UOCeKckDfvdAhXBZjhwiknucSwLkyzua39E6CN/7URmNV64K2jIdMot2j103MMeiiVPe01S2YSKP+TLPlFzcQ2NN/VNs6pZCbmhPe49D2V61oc9jJZiXvUDMtGGmnrKi0Y2nT5EcAGFIk1X4pQhaGvIWuQbQMASN5Rjhh9bFdj0jYrvic/GjnrJNptacqieSrHi+GN3CCUEcA9ym5HcZ0uWqRG9juxgA3sI7YSjjYyS71tc8csKwm7BVwfwxtQO6cUzsittZotaesc51IMBRkdpbXVmw+McdFw==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1794661547; c=relaxed/relaxed;
	bh=UFO9l/21W/p57UQi3nxXvGylhBlGyaXo8dkkR6Kzl3g=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=nWY1Zf4c9rSEBRbJb2Y3kb3dlmkZdVG53X5aP8L2kJXaJf7bHv15HCEx2u/BDuo0DpJ3Onv+86RtD3dPjl93+p13dZLMKgQ+GWcmT6io2KkQ95dD+wdrMUDJ6KSoOVXywRmzo6IZOeaf7foE2CHPHV4yy7qkRKGOrzPuLUZE9unrQo9FLJIwTsHknDTWVhi8NDiExoO6YS4uh4lnBzCvcNKcs25cV4f1I9hIlkM4mVY7DXdITKez68qNloxLPuwrfqD+ClXn2UKl/CNK4SNe8E3V6VUXSq+HdDJdfmzetx9ivR5u4YMwO2H74awsGgRDlfd9UdR/0klbXPH7mzzx1w==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=efVM9o/h; dkim-atps=neutral; spf=pass (client-ip=2600:3c04:e001:324:0:1991:8:25; helo=tor.source.kernel.org; envelope-from=brauner@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=efVM9o/h;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=2600:3c04:e001:324:0:1991:8:25; helo=tor.source.kernel.org; envelope-from=brauner@kernel.org; receiver=lists.ozlabs.org)
Received: from tor.source.kernel.org (tor.source.kernel.org [IPv6:2600:3c04:e001:324:0:1991:8:25])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4jRZB25P8Kz2xjv;
	Sun, 15 Nov 2026 00:05:46 +1100 (AEDT)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 8E79A6234A;
	Sat, 14 Nov 2026 13:05:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F1041F000C5;
	Sat, 14 Nov 2026 13:05:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794661544;
	bh=UFO9l/21W/p57UQi3nxXvGylhBlGyaXo8dkkR6Kzl3g=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=efVM9o/ht18LNBayF3D7oOTcXQ+zQCvKSlyCayqwAYKv8bDYhkCN28KsHSlR6cMw8
	 4vF4PVm13UDKS8+oQ2cZQEBkjysVe3A6Nrl6NtQAxof/K3X7FCHiReyLELP5MDb8hQ
	 d2gL2CxDePyruIvRh5R3YjiY7iLYLYQu27gg+QG4usERJo01RD8CffYKDn4Arsbfb0
	 kqmBhVnVPQD8zke3AZtVSBf8thbVIXaf/i5ZGVCckkNQ1RDwJaoqZxxDbFNlrAQ2pS
	 KE4SKdC5qQmh16hHjDsNJDaG6MSH9S9GaVw+gzEFRuyMQOhbFY55PU1Zxdk60HYVRk
	 7XRSI9AN43uWw==
From: Christian Brauner <brauner@kernel.org>
Date: Sat, 14 Nov 2026 14:01:42 +0100
Subject: [PATCH RFC v2 01/42] loop: refuse backing files that aren't open
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
Message-Id: <20261114-work-loop-pseudo-v2-1-98639a2286fb@kernel.org>
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
 "Christian Brauner (Amutable)" <brauner@kernel.org>, stable@vger.kernel.org, 
 Alexander Mikhalitsyn <alex@amutable.com>
X-Mailer: b4 0.17-dev-ce4c1
X-Developer-Signature: v=1; a=openpgp-sha256; l=1829; i=brauner@kernel.org;
 h=from:subject:message-id; bh=RNS20EKOa1D5gB/WqkZbolMxn0bhv9TmaIu0BLZLG3o=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWT9iEk7N/1b6Zufav+udO25utxD3izgpkPn8SDLhSpbn
 xXzJ6mEd5SyMIhxMciKKbI4tJuEyy3nqdhslKkBM4eVCWQIAxenAEyEfwEjwzfdzxP2LSu3zMqd
 fkThvaV5jphdtEzbnRkiz6M9DdgE2Bn+B03SrPulVrXhk4t5hOLZRXPS3k0t/7U6s9oxvnojx4J
 dXAA=
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


