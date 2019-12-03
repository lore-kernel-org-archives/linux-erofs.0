Return-Path: <SRS0=6HAz=ZZ=lists.ozlabs.org=linux-erofs-bounces+linux-erofs=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.3 required=3.0 tests=DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF957C432C0
	for <linux-erofs@archiver.kernel.org>; Tue,  3 Dec 2019 14:03:33 +0000 (UTC)
Received: from lists.ozlabs.org (lists.ozlabs.org [203.11.71.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 9DA9B20684
	for <linux-erofs@archiver.kernel.org>; Tue,  3 Dec 2019 14:03:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nyrK+MJK"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9DA9B20684
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Received: from lists.ozlabs.org (lists.ozlabs.org [IPv6:2401:3900:2:1::3])
	by lists.ozlabs.org (Postfix) with ESMTP id 47S3c33HPZzDqWr
	for <linux-erofs@archiver.kernel.org>; Wed,  4 Dec 2019 01:03:31 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized)
 smtp.mailfrom=gmail.com (client-ip=2607:f8b0:4864:20::542;
 helo=mail-pg1-x542.google.com; envelope-from=pratikshinde320@gmail.com;
 receiver=<UNKNOWN>)
Authentication-Results: lists.ozlabs.org;
 dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: lists.ozlabs.org; dkim=pass (2048-bit key;
 unprotected) header.d=gmail.com header.i=@gmail.com header.b="nyrK+MJK"; 
 dkim-atps=neutral
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com
 [IPv6:2607:f8b0:4864:20::542])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
 (No client certificate requested)
 by lists.ozlabs.org (Postfix) with ESMTPS id 47S3bn0PJnzDqSc
 for <linux-erofs@lists.ozlabs.org>; Wed,  4 Dec 2019 01:03:13 +1100 (AEDT)
Received: by mail-pg1-x542.google.com with SMTP id t3so1730333pgl.5
 for <linux-erofs@lists.ozlabs.org>; Tue, 03 Dec 2019 06:03:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20161025;
 h=from:to:cc:subject:date:message-id;
 bh=ByhfT87Zg4y0GfbmEr5+AnqvM51//YzXO/5Fq2o/yAc=;
 b=nyrK+MJK+PYu3IOGYuvxdOEfTcXevqAp7Je7DLZ6nPEGtY1Cxm7jH/Qf+2+lz0CS8o
 dxqZsXjM2H2qPbKIWLyC4uMbfdUQIj9mTWbBBpDBWvgM2qr4Mo81zJ6Pa4NFNaiMLj9R
 6F8jB2NBv6mB0k4Lw5JsfNC/9kwM5GqITtx7iz98D/81xYiitT2xUjxgr+QqQLbP5BiI
 avWaI3rbehH75IUuFPq2iREwydIfSj2/L2qFQ+GXJa5xoulumKb4HFCKZZtqX2bUiJ7X
 SBL7jOQFRY2aGKBkSH5TLVSjEkXLnXW0cX4Mgs4hjddKkr6t5QMVTyHnGlC8l2aHkA9y
 Zztg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:from:to:cc:subject:date:message-id;
 bh=ByhfT87Zg4y0GfbmEr5+AnqvM51//YzXO/5Fq2o/yAc=;
 b=p/ctZKaEwPify749wpiKc+tB2vQBtM+T+QYNXTehBHpzcQtcz/4n38J0Li5wq7l79x
 Av/5lWLMkwsYKMZhHtRSrh+IEY1D+9EN7zfQeutlQ5QYaXOyk3roJIbg7YmrGSofsdkJ
 DQI6BYEwlQcMgaApa5Qly7TMGq76s/eeu2OZE9bejKr+DorbEpDnoMQ1PlCmUJy/YQxH
 WbGJM72EIfVKTEBh8gSC8bHas1J8azQnn2FjubmO301XrsYV+1jnAu3scc0dtFPEVyIu
 Xp6mW+RkALaLHwRMj7K/67lA+oaJbBQgZ2bijqI7Xcd91NXqRc5SNfNV/y95lpfLdmNo
 S/Jw==
X-Gm-Message-State: APjAAAUP5hx3GXymeY3kSfwJHpIreeLDpam076QNARJdeyseiyPxVjln
 3a+ApdGXb/zpan0UzMxV50Sad6Ud
X-Google-Smtp-Source: APXvYqz9aa75SYyMmBojF9vjTw/Tu36QAfQvXnSRaoKFemyBxUpSOukwbXuYihfp/U+kx9pDp7zSsw==
X-Received: by 2002:a62:8202:: with SMTP id w2mr5068910pfd.100.1575381789656; 
 Tue, 03 Dec 2019 06:03:09 -0800 (PST)
Received: from localhost.localdomain ([103.51.95.237])
 by smtp.gmail.com with ESMTPSA id hi2sm3048904pjb.22.2019.12.03.06.03.05
 (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
 Tue, 03 Dec 2019 06:03:08 -0800 (PST)
From: Pratik Shinde <pratikshinde320@gmail.com>
To: linux-erofs@lists.ozlabs.org, bluce.liguifu@huawei.com, miaoxie@huawei.com,
 fangwei1@huawei.com
Subject: [RFC] erofs-utils:code for detecting and tracking holes in
 uncompressed sparse files.
Date: Tue,  3 Dec 2019 19:32:50 +0530
Message-Id: <20191203140250.23793-1-pratikshinde320@gmail.com>
X-Mailer: git-send-email 2.9.3
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
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs"
 <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>

NOTE: The patch is not fully complete yet, with this patch I just want to
present rough idea of what I am trying to achieve.

The patch does following :
1) Detect holes (of size EROFS_BLKSIZ) in uncompressed files.
2) Keep track of holes per file.

In-order to track holes, I used an array of size = (file_size / blocksize)
The array basically tracks number of holes before a particular logical file block.
e.g blks[i] = 10 meaning ith block has 10 holes before it.
If a particular block is a hole we set the index to '-1'.

how read logic will change:
1) currently we simply map read offset to a fs block.
2) with holes in place the calculation of block number would be:

   blkno = start_block + (offset >> block_size_shift) - (number of 
   							 holes before block in which offset falls)

3) If a read offset falls inside a hole (which can be found using above array). We
   fill the user buffer with '\0' on the fly.

through this,block no. lookup would still be performed in constant time.

The biggest problem with this approach is - we have to store the hole tracking
array for every file to the disk.Which doesn't seems to be practical.we can use a linkedlist,
but that will make size of inode variable.

Signed-off-by: Pratik Shinde <pratikshinde320@gmail.com>
---
 lib/inode.c | 67 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 66 insertions(+), 1 deletion(-)

diff --git a/lib/inode.c b/lib/inode.c
index 0e19b11..af31949 100644
--- a/lib/inode.c
+++ b/lib/inode.c
@@ -38,6 +38,61 @@ static unsigned char erofs_type_by_mode[S_IFMT >> S_SHIFT] = {
 
 struct list_head inode_hashtable[NR_INODE_HASHTABLE];
 
+
+#define IS_HOLE(start, end) (roundup(start, EROFS_BLKSIZ) == start &&	\
+		             roundup(end, EROFS_BLKSIZ) == end &&	\
+			    (end - start) % EROFS_BLKSIZ == 0)
+#define HOLE_BLK		-1
+unsigned int erofs_detect_holes(struct erofs_inode *inode, int *blks)
+{
+	int i, fd, st, en;
+	unsigned int nblocks;
+	erofs_off_t data, hole, len;
+
+	nblocks = inode->i_size / EROFS_BLKSIZ;
+	for (i = 0; i < nblocks; i++)
+		blks[i] = 0;
+	fd = open(inode->i_srcpath, O_RDONLY);
+	if (fd < 0) {
+		return -errno;
+	}
+	len = lseek(fd, 0, SEEK_END);
+	if (lseek(fd, 0, SEEK_SET) == -1)
+		return -errno;
+	data = 0;
+	while (data < len) {
+		hole = lseek(fd, data, SEEK_HOLE);
+		if (hole == len)
+			break;
+		data = lseek(fd, hole, SEEK_DATA);
+		if (data < 0 || hole > data) {
+			return -EINVAL;
+		}
+		if (IS_HOLE(hole, data)) {
+			st = hole >> S_SHIFT;
+			en = data >> S_SHIFT;
+			nblocks -= (en - st);
+			for (i = st; i < en; i++)
+				blks[i] = HOLE_BLK;
+		}
+	}
+	return nblocks;
+}
+
+int erofs_fill_holedata(int *blks, unsigned int nblocks) {
+	int i, nholes = 0;
+	for (i = 0; i < nblocks; i++) {
+		if (blks[i] == -1)
+			nholes++;
+		else {
+			blks[i] = nholes;
+			if (nholes >= (i + 1))
+				return -EINVAL;
+		}
+	}
+	return 0;
+}
+
 void erofs_inode_manager_init(void)
 {
 	unsigned int i;
@@ -305,6 +360,7 @@ static bool erofs_file_is_compressible(struct erofs_inode *inode)
 int erofs_write_file(struct erofs_inode *inode)
 {
 	unsigned int nblocks, i;
+	int *blks;
 	int ret, fd;
 
 	if (!inode->i_size) {
@@ -322,7 +378,13 @@ int erofs_write_file(struct erofs_inode *inode)
 	/* fallback to all data uncompressed */
 	inode->datalayout = EROFS_INODE_FLAT_INLINE;
 	nblocks = inode->i_size / EROFS_BLKSIZ;
-
+	blks = malloc(sizeof(int) * nblocks);
+	nblocks = erofs_detect_holes(inode, blks);
+	if (nblocks < 0)
+		return nblocks;
+	if ((ret = erofs_fill_holedata(blks, nblocks)) != 0) {
+		return ret;
+	}
 	ret = __allocate_inode_bh_data(inode, nblocks);
 	if (ret)
 		return ret;
@@ -332,6 +394,8 @@ int erofs_write_file(struct erofs_inode *inode)
 		return -errno;
 
 	for (i = 0; i < nblocks; ++i) {
+		if (blks[i] == HOLE_BLK)
+			continue;
 		char buf[EROFS_BLKSIZ];
 
 		ret = read(fd, buf, EROFS_BLKSIZ);
@@ -962,3 +1026,4 @@ struct erofs_inode *erofs_mkfs_build_tree_from_path(struct erofs_inode *parent,
 	return erofs_mkfs_build_tree(inode);
 }
 
+
-- 
2.9.3

