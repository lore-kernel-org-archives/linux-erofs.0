Return-Path: <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 871D7C43334
	for <linux-erofs@archiver.kernel.org>; Wed, 29 Jun 2022 11:39:08 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [IPv6:::1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4LXzy30S3dz3dR9
	for <linux-erofs@archiver.kernel.org>; Wed, 29 Jun 2022 21:39:07 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=lists.ozlabs.org;
	s=201707; t=1656502747;
	bh=7y0xdegoE/qvJXezDri4FFPx3jPOeWDAMQ91i07uFx8=;
	h=To:Subject:Date:In-Reply-To:References:List-Id:List-Unsubscribe:
	 List-Archive:List-Post:List-Help:List-Subscribe:From:Reply-To:Cc:
	 From;
	b=jRVFoBgYGAP9VvJ8BGjbnuEgmuXrl3xhvHOYpVM6fk1OsRqLuO230zszfnTr/fc4T
	 JV0S2TRpKwBh09xOxlFPSrpA5n8pN3xRRJADEMPP06pvF5NaJuv6z9tBt0rTGOXJtY
	 /U+nIGa5kfdYBBXh2wFQxA6Mc4xYVW8VXLy+ceNoQ92l7ZRCXCrZEIp6fiJbMTrK6E
	 4LWr1N/rvRNzaiQNfsLhwUMOnEPU7LXa9ahEDN4tKgr9pOLkgdKwue0XJtT7vVBxNQ
	 7wz8OrXXKheXw1OwOt8g7aOuPvw3bl7QEr2Cky7LNjv+M84JmzUuyQ73KCefZvqSor
	 P+j+r36+LKBfA==
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=suse.com (client-ip=195.135.220.29; helo=smtp-out2.suse.de; envelope-from=wqu@suse.com; receiver=<UNKNOWN>)
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=qt5GL8bB;
	dkim-atps=neutral
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4LXzxs0tWTz3c9K
	for <linux-erofs@lists.ozlabs.org>; Wed, 29 Jun 2022 21:38:57 +1000 (AEST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 944A71FE7B;
	Wed, 29 Jun 2022 11:38:54 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 55AB2133D1;
	Wed, 29 Jun 2022 11:38:52 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA
	id yBu5CMw5vGLFPwAAMHmgww
	(envelope-from <wqu@suse.com>); Wed, 29 Jun 2022 11:38:52 +0000
To: u-boot@lists.denx.de
Subject: [PATCH 2/8] fs: btrfs: fix a bug which no data get read if the length is not 0
Date: Wed, 29 Jun 2022 19:38:23 +0800
Message-Id: <0c873979cf1c277e7a3a46b8839014990ee1b874.1656502685.git.wqu@suse.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <cover.1656502685.git.wqu@suse.com>
References: <cover.1656502685.git.wqu@suse.com>
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
Cc: trini@konsulko.com, jnhuang95@gmail.com, joaomarcos.costa@bootlin.com, marek.behun@nic.cz, thomas.petazzoni@bootlin.com, miquel.raynal@bootlin.com, linux-erofs@lists.ozlabs.org, linux-btrfs@vger.kernel.org
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs" <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>

[BUG]
When testing with unaligned read, if a specific length is passed in,
btrfs driver will read out nothing:

 => load host 0 $kernel_addr_r 5k_file 0x1000 0
 0 bytes read in 0 ms

But if no length is passed in, it works fine, even if we pass a non-zero
length:

 => load host 0 $kernel_addr_r 5k_file 0 0x1000
 1024 bytes read in 0 ms

[CAUSE]
In btrfs_read() if we have a larger size than our file, we will try to
truncate it using the file size.

However the real file size is not initialized if @len is not zero, thus
we always truncate our length to 0, and cause the problem.

[FIX]
Fix it by just always do the file size check.

In fact btrfs_size() always follow soft link, thus it will return the
real file size correctly.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/btrfs.c | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/fs/btrfs/btrfs.c b/fs/btrfs/btrfs.c
index 741c6e20f533..9145727058d4 100644
--- a/fs/btrfs/btrfs.c
+++ b/fs/btrfs/btrfs.c
@@ -246,16 +246,17 @@ int btrfs_read(const char *file, void *buf, loff_t offset, loff_t len,
 		return -EINVAL;
 	}
 
-	if (!len) {
-		ret = btrfs_size(file, &real_size);
-		if (ret < 0) {
-			error("Failed to get inode size: %s", file);
-			return ret;
-		}
-		len = real_size;
+	ret = btrfs_size(file, &real_size);
+	if (ret < 0) {
+		error("Failed to get inode size: %s", file);
+		return ret;
 	}
 
-	if (len > real_size - offset)
+	/*
+	 * If the length is 0 (meaning read the whole file) or the range is
+	 * beyond file size, truncate it to the end of the file.
+	 */
+	if (!len || len > real_size - offset)
 		len = real_size - offset;
 
 	ret = btrfs_file_read(root, ino, offset, len, buf);
-- 
2.36.1

