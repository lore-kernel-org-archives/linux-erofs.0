Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75117606E58E
	for <linux-erofs@archiver.kernel.org>; Tue, 10 Nov 2026 09:21:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WqGsamIv
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4jP1MF2DBTz3dJw;
	Tue, 10 Nov 2026 20:19:53 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=172.105.4.254
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1794302393;
	cv=none; b=MtJqNa/qrsGFB055xyZ+BMpoMsZqQiPcpVRnYlHs15u9p/w/AwXXLvixG6+WpyS3iNYBMNy1Tdp/cQY4nnPp+bUmQBxYzletQQX2l7h5EgE+F7DC2O9jNEcOwSQe4PjWAaYrDST/J/cNmAIvmhDFoOdNznEc1NEMhTkweZiiR8bxIYvLfmnUoz9fDYGOiKfPZouG210kK9BvzSQEXxXAN4nTEp5YJauiJG1NgniFB7ijkji3kAKwMScZ7BwNNvdlvEZnh6e2zBNu8xwzMNc4nT5qbDCCP23odDPi7nPLbNZgWXYVaOsMR9lj7fpt3peXMaOkwt4bEm8nR/h5A0pcxw==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1794302393; c=relaxed/relaxed;
	bh=lnImahtJn5lfCdVuO4byE9DJbFXiWtZ50f1CyF0t2Q8=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=MoQaJtxnZ1sGs5bNvQWqRcRlVjL9EFxp19TFihbnCzG2g0fv6WH3koeJjVVvyB3+mAheQ1Xkk685aSgPA9kANo8jw7nPNAuVoZn2n6wkkGxu0k6+k0j1DRsD92FUbg06b8bJGb7O4HgYfae1bEZac58hbIPInXS3zqxv5DpnTCWh5/GE9h5xXqUEM+lgUj5WydXPlAqHvsYqtYHa9D1DAL38O7IcB7EstZTze0M/IBkg9LVBD3sh4+hZsoa/XuD7MezefwSPhiqp1HhDPTHg9FV/Tgjp2embkIQ5oOre3N57Apdkbuj2hhXlUiqqbRFZJaZV/wQlrGPMUUXNFg2AKQ==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WqGsamIv; dkim-atps=neutral; spf=pass (client-ip=172.105.4.254; helo=tor.source.kernel.org; envelope-from=brauner@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WqGsamIv;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=172.105.4.254; helo=tor.source.kernel.org; envelope-from=brauner@kernel.org; receiver=lists.ozlabs.org)
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4jP1MD1WBzz3dHR;
	Tue, 10 Nov 2026 20:19:52 +1100 (AEDT)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 4FA0563819;
	Tue, 10 Nov 2026 09:19:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3DA11F0089F;
	Tue, 10 Nov 2026 09:19:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794302390;
	bh=lnImahtJn5lfCdVuO4byE9DJbFXiWtZ50f1CyF0t2Q8=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=WqGsamIv3dtdaZQphHLu2DsjqE2y3/FcP3C64OYa+8HjMiTSq+RUo0e7SVbClrF0O
	 Rn64RbDtjIQ3O+Vwx+jQosyxP133oDpbH9LaXZygD1MM6NsgOa8bfIBMBWinhY4voF
	 I9LMB4dtUD9EnoSvdxBHOJx1kUnEZi+cO6zl0AnUxitmo0r0cS4AhTxoDqU/IE3/8N
	 uJ4rAQbKeN2qr/1Nlrm7L9UeP+8U9vKXU8KBqCqhmY0R54patPnEALsIObSrmc3hKW
	 Bz6GWE9fyD5MsVicN0uDrDB/5zSB2xN3jmDYfNnm8pkYJ/yFyaHVRy4YEgK/zJNLVt
	 IxoVCfI/XEEcA==
From: Christian Brauner <brauner@kernel.org>
Date: Tue, 10 Nov 2026 10:14:50 +0100
Subject: [PATCH RFC 34/41] loop: refuse files on pseudo filesystems as
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
Message-Id: <20261110-work-loop-pseudo-v1-34-4c998976c6c7@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2497; i=brauner@kernel.org;
 h=from:subject:message-id; bh=chnbD225AeAwL2r22LyY9vS4RRPeXQFSJ1x6B/QmHi8=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWR9erD71lG1GUFqk8J3zhE9HKjc6rfqomb6Dp9nHvd2b
 viaPiNickcpC4MYF4OsmCKLQ7tJuNxynorNRpkaMHNYmUCGMHBxCsBE7v5lZPgek5sy6Z/MydVb
 5OSibJ/WcXMc/DFdcI1ZQY3Sv+l7b1ow/OHYs+VfAseimIV2yX857n1k8RKW83f7u2n9y0MtbJd
 Ss1gB
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Currently loop accepts any regular file that implements ->read_iter() as
a backing file and any that also implements ->write_iter() as a writable
one. That includes files on procfs, sysfs and other pseudo filesystems.
For example, /proc/kcore attaches read-only as a loop device the size of
the kernel's virtual address space, 64 PiB with 5-level paging. sysfs
attributes attach read-write as 4096 byte loop devices. Writing a block
to the loop device of /sys/kernel/mm/transparent_hugepage/enabled
changes the THP setting.

That's not just nonsensical, it can be abused. Loop calls ->read_iter()
and ->write_iter() of the backing file directly from its worker which
runs with kernel credentials. But pseudo files enforce part of their
access rules at read and write time against current. Dozens of sysfs
->show() and ->store() methods call capable(). Behind a loop device all
of these checks are done against the loop worker instead of the task
that opened the file. And setting up a loop device requires no
capabilities, only access to the device nodes. So on v7.4-rc1:

- uid 0 without any capabilities can't write to /sys/kernel/reboot/mode
  as mode_store() requires CAP_SYS_BOOT. Writing "warm" through a loop
  device works.

- uid 0 without any capabilities can't read the files in
  /sys/firmware/dmi/entries/*/ as dmi_sysfs_attr_show() requires
  CAP_SYS_ADMIN. Reading them through a loop device works.

- An unprivileged container that was handed a loop device can't change
  gro_flush_timeout of its own network devices as
  gro_flush_timeout_store() requires CAP_NET_ADMIN in the initial user
  namespace. Writing it through a loop device works.

The same goes for hard_offline_page, the md and sd attributes, rfkill
and others.

Refuse files on pseudo filesystems as loop backing files. Note that
file_is_pseudo() looks through overlayfs so stacking overlayfs on top of
sysfs doesn't get around this.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 drivers/block/loop.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/block/loop.c b/drivers/block/loop.c
index c96e35c3ef42..1482580a1979 100644
--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -537,6 +537,9 @@ static int loop_check_backing_file(struct file *file)
 	if ((file->f_mode & FMODE_WRITE) && !file->f_op->write_iter)
 		return -EINVAL;
 
+	if (file_is_pseudo(file))
+		return -EINVAL;
+
 	return 0;
 }
 

-- 
2.53.0


