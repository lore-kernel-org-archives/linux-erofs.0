Return-Path: <linux-erofs+bounces-3635-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 09230CD98E1
	for <linux-erofs@archiver.kernel.org>; Tue, 16 Jun 2026 14:08:44 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4gfpkL3fCxz3c4M;
	Wed, 17 Jun 2026 00:08:42 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=172.105.4.254
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1781618922;
	cv=none; b=oIn45Inj7JyBtGObOsEaJP5W2pWNrXolCkTKmc6Ft4bbs2IqMMq1hZNjEQ8dJWhFsAZilrLW2gV+w8A4S9BsVWCpf2uC1So8UUi6cK2ShjGyRzdYzXSECXNzOwBkqJkzTAx9eZSnQrffQJzHrj40rBSYOcwhI7AcYaUhfG7RgJKZ4mTBD1dDnQvOn20OWSVWofvF/WCCPr/zx45Y7K+isztzXWuvN6zQ5qHG3Z8OCImBqDKgwj2Hgt4RSZPxHabw6+JExWknGIgQOeqb/zqLf5MFNGujeih3n9eGRTFWTx98xiwEC317SDMJUCDM7BWsUnTgyhhNvZgskeVSFyHvLg==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1781618922; c=relaxed/relaxed;
	bh=AeeZi/hxbgHmb/F0VfPB/7qCPnOkVDs6Bdia00DiCdc=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=UVLvkxYo3sziTeeBOPLZVoL9QuwXWQvaWGGh7OeEvYqn8DrpXEhcBliye4nKXM4BIfOJmyqm4pl13i6A1FYKHwH1NQHVG9mngSG/TQ4wmhSRNjSZOgHL3pCOClOGwMgYaR2Hdz5/ca9CXLw4HHMled0TOjejreBzj3LuuOCu3U91uCfBRFNosuvYeyN/K15GUn8NSxa9L9SEQUUfcHp2CZfEHXkRpstSZHlHHOcwu7ZB1tzDsY3cmfxEViH/Je+fJRPsNFalvJWP/theZoCeFkB/TuYyupJnyEDM2+w+E319qo6+2/r8t03qyTWjBGVo5Ac7xzt5HFb1AZhObPmT/Q==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kySEtXA+; dkim-atps=neutral; spf=pass (client-ip=172.105.4.254; helo=tor.source.kernel.org; envelope-from=brauner@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kySEtXA+;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=172.105.4.254; helo=tor.source.kernel.org; envelope-from=brauner@kernel.org; receiver=lists.ozlabs.org)
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4gfpkK1yLkz2yv0
	for <linux-erofs@lists.ozlabs.org>; Wed, 17 Jun 2026 00:08:41 +1000 (AEST)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 6448A60128;
	Tue, 16 Jun 2026 14:08:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9C5D1F00A3D;
	Tue, 16 Jun 2026 14:08:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781618919;
	bh=AeeZi/hxbgHmb/F0VfPB/7qCPnOkVDs6Bdia00DiCdc=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=kySEtXA+i2Sy19y3C7hyItYnoGUU0IRW9m/qLUgWLY0CT/JoqcLQwor8hbb/bur8x
	 QSTZSCimCT+fi9+I/xfLsyabbeYThwQZoNLNVU3qJQMOTG79ogMINMGHm19HYM35KV
	 SEqtHSLSBZGHGcyaluIsbjrpHn53ZAdR+WoOuRglqqFjOpeQkO3RFqgyj4EDFXdKU0
	 sMeX6RJJ9MwG76DnNcWigWoF0cQPg2ASRAa2Fh2ogixt4Sv7GUmdbSHVnHSRMFB3mu
	 QKPu3jbhyIMzqD6sasUJF8vzoAKtIE0DS+69xmHaF4ujtbTzhvtE7vrUisorRvOt8l
	 xeEg8KRn9KVQQ==
From: Christian Brauner <brauner@kernel.org>
Date: Tue, 16 Jun 2026 16:08:17 +0200
Subject: [PATCH RFC v2 01/18] xfs: fix the error unwind in
 xfs_open_devices()
X-Mailing-List: linux-erofs@lists.ozlabs.org
List-Id: <linux-erofs.lists.ozlabs.org>
List-Help: <mailto:linux-erofs+help@lists.ozlabs.org>
List-Owner: <mailto:linux-erofs+owner@lists.ozlabs.org>
List-Post: <mailto:linux-erofs@lists.ozlabs.org>
List-Subscribe: <mailto:linux-erofs+subscribe@lists.ozlabs.org>,
  <mailto:linux-erofs+subscribe-digest@lists.ozlabs.org>,
  <mailto:linux-erofs+subscribe-nomail@lists.ozlabs.org>
List-Unsubscribe: <mailto:linux-erofs+unsubscribe@lists.ozlabs.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260616-work-super-bdev_holder_global-v2-1-7df6b864028e@kernel.org>
References: <20260616-work-super-bdev_holder_global-v2-0-7df6b864028e@kernel.org>
In-Reply-To: <20260616-work-super-bdev_holder_global-v2-0-7df6b864028e@kernel.org>
To: Jan Kara <jack@suse.cz>
Cc: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>, 
 Alexander Viro <viro@zeniv.linux.org.uk>, linux-block@vger.kernel.org, 
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
 Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org, 
 Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>, 
 linux-btrfs@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>, 
 linux-ext4@vger.kernel.org, Gao Xiang <xiang@kernel.org>, 
 linux-erofs@lists.ozlabs.org, 
 "Christian Brauner (Amutable)" <brauner@kernel.org>
X-Mailer: b4 0.16-dev-4090c
X-Developer-Signature: v=1; a=openpgp-sha256; l=1654; i=brauner@kernel.org;
 h=from:subject:message-id; bh=+c5vJQdoUivvVsn514PbmmH2DGT2hz4x522TzvMxmoE=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWQZRtzrE3XdWnvZxYvtzt2P9e9PnRV1uDvZsPaZWH7J6
 X1rgjRvdJSyMIhxMciKKbI4tJuEyy3nqdhslKkBM4eVCWQIAxenAEykbxMjw72E5nfrd6W+STto
 cv74grrpL8wvlBxWFmo+8mrZ8/UbKn4xMmw+l6cao/5He1rRkoSJd+TND37Z8eVKRdPe8KCIaaV
 Xo3gA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624

Since the rt and log block devices are closed in xfs_free_buftarg() the
buftarg owns the device file. The error unwind does not respect that:
when the log buftarg allocation fails, out_free_rtdev_targ frees the rt
buftarg - releasing rtdev_file - and then falls through to
out_close_rtdev and releases it a second time.

The unwind also leaves mp->m_rtdev_targp and mp->m_ddev_targp pointing
to the freed buftargs. The failed mount continues into
deactivate_locked_super() -> xfs_kill_sb() -> xfs_mount_free(), which
frees them again.

Clear the buftarg pointers once the unwind freed them and clear
rtdev_file once the rt buftarg owns it, so nothing is released twice.

Reachable when a buftarg allocation fails after the data buftarg was
set up: an I/O error in sync_blockdev() or an allocation failure in
xfs_init_buftarg() while mounting with external rt and log devices.

Fixes: 41233576e9a4 ("xfs: close the RT and log block devices in xfs_free_buftarg")
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/xfs/xfs_super.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index eac7f9503805..8531d526fc44 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -534,8 +534,11 @@ xfs_open_devices(
  out_free_rtdev_targ:
 	if (mp->m_rtdev_targp)
 		xfs_free_buftarg(mp->m_rtdev_targp);
+	mp->m_rtdev_targp = NULL;
+	rtdev_file = NULL;	/* released by xfs_free_buftarg() */
  out_free_ddev_targ:
 	xfs_free_buftarg(mp->m_ddev_targp);
+	mp->m_ddev_targp = NULL;
  out_close_rtdev:
 	 if (rtdev_file)
 		bdev_fput(rtdev_file);

-- 
2.47.3


