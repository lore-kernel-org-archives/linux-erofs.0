Return-Path: <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 323DAC43334
	for <linux-erofs@archiver.kernel.org>; Tue, 26 Jul 2022 05:23:07 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [IPv6:::1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4LsQKj5mkpz3bZY
	for <linux-erofs@archiver.kernel.org>; Tue, 26 Jul 2022 15:23:05 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=lists.ozlabs.org;
	s=201707; t=1658812985;
	bh=ZLc970s389r/cBG+Tk6HiktCaenz0z1leWM65Yqb4cM=;
	h=To:Subject:Date:In-Reply-To:References:List-Id:List-Unsubscribe:
	 List-Archive:List-Post:List-Help:List-Subscribe:From:Reply-To:Cc:
	 From;
	b=V4F5X7LsDA7oKX2rqmi/38vAGRWjPLPGXdvFiXKrirPFcV6VvOPwdFKCoQsiIHhYc
	 inozMkO+bdVbe8tQW2b/HqnLoTahV0WmA0C0E0oXTAo99vj8wb+XZPNI5hs57e2W29
	 a85fwoRwcWLQbGO2bkPvNIPlRS8tGB7qfu01MMaAmJM5hnsNH0VXNYRtS6Dm6us2iQ
	 YNO4d+oGYd0CVjIayb7T9Hr5EHuCp2zrxtWIb6OgeWpXD4fm1bvZwZUt2kcc73D6o7
	 HxYNQEuL2rEC9u+6uL2zxkP1btWUNUJbXvN3hjXI1yUhQm1upU99mAFV9n+YvOyWgY
	 SeN8Bg86qbX4A==
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=suse.com (client-ip=195.135.220.28; helo=smtp-out1.suse.de; envelope-from=wqu@suse.com; receiver=<UNKNOWN>)
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=fLk6TudH;
	dkim-atps=neutral
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4LsQKS3DRnz3bsy
	for <linux-erofs@lists.ozlabs.org>; Tue, 26 Jul 2022 15:22:52 +1000 (AEST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 6155A34B51;
	Tue, 26 Jul 2022 05:22:46 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 6788913A12;
	Tue, 26 Jul 2022 05:22:44 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA
	id eDLEDiR632IFOwAAMHmgww
	(envelope-from <wqu@suse.com>); Tue, 26 Jul 2022 05:22:44 +0000
To: u-boot@lists.denx.de
Subject: [PATCH v2 3/8] fs: btrfs: fix a crash if specified range is beyond file size
Date: Tue, 26 Jul 2022 13:22:11 +0800
Message-Id: <c4ffb7fcc552dda16491d47f07b5c3a418fc4f69.1658812744.git.wqu@suse.com>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <cover.1658812744.git.wqu@suse.com>
References: <cover.1658812744.git.wqu@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-BeenThere: linux-erofs@lists.ozlabs.org
X-Mailman-Version: 2.1.29
Precedence: list
List-Id: Development of Linux EROFS file system <linux-erofs.lists.ozlabs.org>
List-Unsubscribe: <https://lists.ozlabs.org/options/linux-erofs>,
 <mailto:linux-erofs-request@lists.ozlabs.org?subject=unsubscribe>
List-Archive: <http://lists.ozlabs.org/pipermail/linux-erofs/>
List-Post: <mailto:linux-erofs@lists.ozlabs.org>
List-Help: <mailto:linux-erofs-request@lists.ozlabs.org?subject=help>
List-Subscribe: <https://lists.ozlabs.org/listinfo/linux-erofs>,
 <mailto:linux-erofs-request@lists.ozlabs.org?subject=subscribe>
From: Qu Wenruo via Linux-erofs <linux-erofs@lists.ozlabs.org>
Reply-To: Qu Wenruo <wqu@suse.com>
Cc: trini@konsulko.com, joaomarcos.costa@bootlin.com, marek.behun@nic.cz, thomas.petazzoni@bootlin.com, miquel.raynal@bootlin.com, linux-erofs@lists.ozlabs.org, linux-btrfs@vger.kernel.org
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs" <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>

[BUG]
When try to read a range beyond file size, btrfs driver will cause
crash/segfault:

 => load host 0 $kernel_addr_r 5k_file 0 0x2000
 SEGFAULT

[CAUSE]
In btrfs_read(), if @len is 0, we will truncated it to file end, but if
file end is beyond our file size, this truncation will underflow @len,
making it -3K in this case.

And later that @len is used to memzero the output buffer, resulting
above crash.

[FIX]
Just error out if @offset is already beyond our file size.

Now it will fail properly with correct error message:

 => load host 0 $kernel_addr_r 5m_origin 0 0x2000
 BTRFS: Read range beyond file size, offset 8192 file size 5120

 Failed to load '5m_origin'

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/btrfs.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/btrfs/btrfs.c b/fs/btrfs/btrfs.c
index 9145727058d4..bf9e1f2f17cf 100644
--- a/fs/btrfs/btrfs.c
+++ b/fs/btrfs/btrfs.c
@@ -252,6 +252,12 @@ int btrfs_read(const char *file, void *buf, loff_t offset, loff_t len,
 		return ret;
 	}
 
+	if (offset >= real_size) {
+		error("Read range beyond file size, offset %llu file size %llu",
+			offset, real_size);
+		return -EINVAL;
+	}
+
 	/*
 	 * If the length is 0 (meaning read the whole file) or the range is
 	 * beyond file size, truncate it to the end of the file.
-- 
2.37.0

