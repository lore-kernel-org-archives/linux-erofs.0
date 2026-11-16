Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A0D3606AB55
	for <linux-erofs@archiver.kernel.org>; Mon, 16 Nov 2026 11:12:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=l+BIJEfb
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4jSlXL2gQGz3dL4;
	Mon, 16 Nov 2026 22:10:42 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=172.234.252.31
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1794827442;
	cv=none; b=at2QJAd2E7aXUU05hXj304ymyXPFLrdUg1FAD7ndpdE6tmF/KJQHqTMSYDqnROfr5YIlW+0E46WMeaBVCk8JbEIVAkrSrYFhHP8B4QDf9EcgvdTOybZaGmEhWEZv5qvYgmsZ1r4aznHkmd33GUoMWfgymmDcwEetYEip1lzaE43muJLZkCbDgAjcXmtXo+Nr7DljmZmhaDPzJw7E54q70ES2DQwvx9JZpUhnagopXgz3KG3IC1UWaSrELkLVK+gV6pD6YNybGMN92XiwttmWQ4T3heN+kthRnxeaYpOHE7ytZQGRvd4zuql1t7rQn0kqSAhh6r9ntOTcy7Lo45/52A==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1794827442; c=relaxed/relaxed;
	bh=TMBBwOCxq0RbA3xkr3IQCANlyHiMKhXi962Ec8MHN/8=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=PAwDv3yhLk0WMXuO2C9lol3T7Bmdn2oI/MuWc3JQTQwj37CDV7yxLwZ4/PtBFur9qpQRjgAEX+Ne4OBQbE6/UHbJ7xmiMtxr2cv0iBBhcIZFAF84Px+NM6Z76mltYlwSzD9BsL4QEdettHvU/dU7jjXCK6UbxH50XSOWRBuKwTdYLe7sdYZ5DSa2WLYqnzvcMQjixrxoKT3/steB5lsFWEo+EWL8xlwOtcv8ULr0lmTRDbRlbWlXslov/8JnKOk5N3u/y9ngmQ9pEWy0bPR0Z97VLtnNwMPRTFCt+AJpIrZY5ZqRvyk5XJVn1d9qrx1mi0zCRWQICvZhD1AHb7bfqA==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=l+BIJEfb; dkim-atps=neutral; spf=pass (client-ip=172.234.252.31; helo=sea.source.kernel.org; envelope-from=brauner@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=l+BIJEfb;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=172.234.252.31; helo=sea.source.kernel.org; envelope-from=brauner@kernel.org; receiver=lists.ozlabs.org)
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4jSlXK1VCYz3dK4;
	Mon, 16 Nov 2026 22:10:41 +1100 (AEDT)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id AFAFB462F9;
	Mon, 16 Nov 2026 11:10:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A58D71F000C5;
	Mon, 16 Nov 2026 11:10:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794827439;
	bh=TMBBwOCxq0RbA3xkr3IQCANlyHiMKhXi962Ec8MHN/8=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=l+BIJEfbLhnCAiQ9KjFFbH+KikDuWf7Rh0M/jNYiYLFM3JBoCkTU1QtWjpGfqyuFA
	 CSiogIgrJTCRIfQqExj48VIInR4+j/p1TBSDSDU3KHVkiSv4VTwVuUQsOXXPwbSjGT
	 3yic+O5L+OrlvIDI19sfN+4rh3qdY6Q1ReyaauwTlqsXASNdOse/Fh7GmwTFTBPEMk
	 V7YwmUvz678MdFDVA72s+VOIEk7DPWPvjqCbYbQRAxRHaDgQOErh9yRIemYiG+jRQ/
	 TEIFcXsS9+XxNmw10KCpA2RC6gwbTOP/zd6mhzzP3q8aoDPq5vCZ1BkJL96CD5g30G
	 1pPnYhru7oOKg==
From: Christian Brauner <brauner@kernel.org>
Date: Mon, 16 Nov 2026 12:05:10 +0100
Subject: [PATCH RFC v3 37/44] zloop: refuse zone files on pseudo
 filesystems
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
Message-Id: <20261116-work-loop-pseudo-v3-37-8cbbea1cf34f@kernel.org>
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
 Alexander Mikhalitsyn <alex@amutable.com>, 
 Chris Down <chris@chrisdown.name>
X-Mailer: b4 0.17-dev-ce4c1
X-Developer-Signature: v=1; a=openpgp-sha256; l=1558; i=brauner@kernel.org;
 h=from:subject:message-id; bh=XfUA5+m77vNauXdxpoCEKQvxsNkJs1ZrQCEAfm8XKRY=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWT9etzJVXe0X6Zm0vH193d2OB6eMv+pg2Z/9ALRRoMZX
 vcmSG3X6yhlYRDjYpAVU2RxaDcJl1vOU7HZKFMDZg4rE8gQBi5OAZjI+08M/3QZMiNqd39IqXkk
 99PB+YDugQoTg8Xv32en/V7x56/opmMM//NviaY8nxghcZ4/+eSWhcd/HHTXfr+Mf/LvXWXB0xs
 lLRkB
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

zloop opens its zone files by name below the base directory but a bind
mount can put any file there, including a procfs or sysfs file. Refuse
files on pseudo filesystems as zone files just like loop does by
switching to file_check_backing().

Note that the helper only accepts regular files. So far zloop took
anything with ->read_iter() and ->write_iter() as a zone file. That
includes character devices, FIFOs and block devices if someone put them
where zloop expects a zone file. Zone files are created by zloop itself
and zloop truncates them to size and to reset and finish zones which
only works for regular files. So refuse everything else.

Reviewed-by: Alexander Mikhalitsyn <alex@amutable.com>
Reviewed-by: Chris Down <chris@chrisdown.name>
Tested-by: Chris Down <chris@chrisdown.name>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 drivers/block/zloop.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/block/zloop.c b/drivers/block/zloop.c
index 65634a39b0bfc..6f79b9ddbbe00 100644
--- a/drivers/block/zloop.c
+++ b/drivers/block/zloop.c
@@ -1132,10 +1132,9 @@ static int zloop_init_zone(struct zloop_device *zlo, struct zloop_options *opts,
 		return PTR_ERR(zone->file);
 	}
 
-	if (!zone->file->f_op->read_iter || !zone->file->f_op->write_iter) {
-		ret = -EINVAL;
+	ret = file_check_backing(zone->file, FMODE_READ | FMODE_WRITE, 0);
+	if (ret)
 		goto out_fput;
-	}
 
 	if (zlo->block_size) {
 		ret = zloop_get_block_size(zlo, zone);

-- 
2.53.0


