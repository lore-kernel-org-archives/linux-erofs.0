Return-Path: <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B9CBBC00140
	for <linux-erofs@archiver.kernel.org>; Mon, 15 Aug 2022 11:46:17 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [IPv6:::1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4M5stc20sTz3bZ2
	for <linux-erofs@archiver.kernel.org>; Mon, 15 Aug 2022 21:46:16 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=lists.ozlabs.org;
	s=201707; t=1660563976;
	bh=RT0BTzg0LT7QlYZlw1Y7agdMFP6If8NjMFPJKBgrbL0=;
	h=To:Subject:Date:In-Reply-To:References:List-Id:List-Unsubscribe:
	 List-Archive:List-Post:List-Help:List-Subscribe:From:Reply-To:Cc:
	 From;
	b=Mlswgye/mHQZ52rQFJBSqlkpkpsVurRma/SXyVxN4DCeC/evp31D56FU4SN+OSua0
	 yIIhgV+to9Bus2X78b4Vo3EyMFV8iae3yjmDgbFvpZiX1J10j+zJ837VYr6oLpvTAW
	 HJW1ahNyoQef4On8rb0jcpa0bbJQN4WRC8ETUjCct6SID1XzeOrpmSF7BM5yj8Gc7y
	 9tpaDIydkR7Sy+KFs1h8wwFER8p8dezw46FnX0DpUz+LCnYrAJ8dhO8SvZ0fzbptWO
	 3aH0TeI1hO3u6LUurntZArvrw5LHwFkYZ8wd9yijHWZZy6xjevyicH2hamgwnL01d4
	 CK/W5rHKGI2Ug==
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=suse.com (client-ip=195.135.220.28; helo=smtp-out1.suse.de; envelope-from=wqu@suse.com; receiver=<UNKNOWN>)
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=pGLOtxAr;
	dkim-atps=neutral
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4M5stJ0Wyyz3bXg
	for <linux-erofs@lists.ozlabs.org>; Mon, 15 Aug 2022 21:46:00 +1000 (AEST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id A271B352B5;
	Mon, 15 Aug 2022 11:45:57 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 277D713A93;
	Mon, 15 Aug 2022 11:45:53 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA
	id 8OSnN/Ex+mLsGAAAMHmgww
	(envelope-from <wqu@suse.com>); Mon, 15 Aug 2022 11:45:53 +0000
To: u-boot@lists.denx.de
Subject: [PATCH v3 5/8] fs: ext4: rely on _fs_read() to handle leading unaligned block read
Date: Mon, 15 Aug 2022 19:45:16 +0800
Message-Id: <08bd4c42bd1f7a96b17d193cdf7c6d4e68aa265c.1660563403.git.wqu@suse.com>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <cover.1660563403.git.wqu@suse.com>
References: <cover.1660563403.git.wqu@suse.com>
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

Just add ext4_get_blocksize() and a new assert() in ext4fs_read_file().

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
Several cleanup candicate:

1. ext_fs->blksz is never populated, thus it's always 0
   We can not easily grab blocksize just like btrfs in this case.

   Thus we have to go the same calculation in ext4fs_read_file().

2. can not easily cleanup @skipfirst in ext4fs_read_file()
   It seems to screw up with soft link read.
---
 fs/ext4/ext4fs.c | 22 ++++++++++++++++++++++
 fs/fs.c          |  2 +-
 include/ext4fs.h |  1 +
 3 files changed, 24 insertions(+), 1 deletion(-)

diff --git a/fs/ext4/ext4fs.c b/fs/ext4/ext4fs.c
index 4c89152ce4ad..b0568e77a895 100644
--- a/fs/ext4/ext4fs.c
+++ b/fs/ext4/ext4fs.c
@@ -69,6 +69,8 @@ int ext4fs_read_file(struct ext2fs_node *node, loff_t pos,
 	short status;
 	struct ext_block_cache cache;
 
+	assert(IS_ALIGNED(pos, blocksize));
+
 	ext_cache_init(&cache);
 
 	/* Adjust len so it we can't read past the end of the file. */
@@ -259,6 +261,26 @@ int ext4_read_file(const char *filename, void *buf, loff_t offset, loff_t len,
 	return ext4fs_read(buf, offset, len, len_read);
 }
 
+int ext4_get_blocksize(const char *filename)
+{
+	struct ext_filesystem *fs;
+	int log2blksz;
+	int log2_fs_blocksize;
+	loff_t file_len;
+	int ret;
+
+	ret = ext4fs_open(filename, &file_len);
+	if (ret < 0) {
+		printf("** File not found %s **\n", filename);
+		return -1;
+	}
+	fs = get_fs();
+	log2blksz = fs->dev_desc->log2blksz;
+	log2_fs_blocksize = LOG2_BLOCK_SIZE(ext4fs_file->data) - log2blksz;
+
+	return (1 << (log2_fs_blocksize + log2blksz));
+}
+
 int ext4fs_uuid(char *uuid_str)
 {
 	if (ext4fs_root == NULL)
diff --git a/fs/fs.c b/fs/fs.c
index 6d43d616de4b..b26cc8e2e840 100644
--- a/fs/fs.c
+++ b/fs/fs.c
@@ -237,7 +237,7 @@ static struct fstype_info fstypes[] = {
 		.exists = ext4fs_exists,
 		.size = ext4fs_size,
 		.read = ext4_read_file,
-		.get_blocksize = fs_get_blocksize_unsupported,
+		.get_blocksize = ext4_get_blocksize,
 #ifdef CONFIG_CMD_EXT4_WRITE
 		.write = ext4_write_file,
 		.ln = ext4fs_create_link,
diff --git a/include/ext4fs.h b/include/ext4fs.h
index cb5d9cc0a5c0..0f4cf32dcc2a 100644
--- a/include/ext4fs.h
+++ b/include/ext4fs.h
@@ -161,6 +161,7 @@ int ext4fs_probe(struct blk_desc *fs_dev_desc,
 		 struct disk_partition *fs_partition);
 int ext4_read_file(const char *filename, void *buf, loff_t offset, loff_t len,
 		   loff_t *actread);
+int ext4_get_blocksize(const char *filename);
 int ext4_read_superblock(char *buffer);
 int ext4fs_uuid(char *uuid_str);
 void ext_cache_init(struct ext_block_cache *cache);
-- 
2.37.1

