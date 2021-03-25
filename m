Return-Path: <SRS0=kahm=IX=lists.ozlabs.org=linux-erofs-bounces+linux-erofs=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 537DDC433DB
	for <linux-erofs@archiver.kernel.org>; Thu, 25 Mar 2021 07:11:25 +0000 (UTC)
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 4A21761A27
	for <linux-erofs@archiver.kernel.org>; Thu, 25 Mar 2021 07:11:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4A21761A27
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Received: from boromir.ozlabs.org (localhost [IPv6:::1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4F5bqt74f1z30J6
	for <linux-erofs@archiver.kernel.org>; Thu, 25 Mar 2021 18:11:22 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org;
	dkim=fail reason="signature verification failed" (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20161025 header.b=PnUiACrH;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized)
 smtp.mailfrom=gmail.com (client-ip=2607:f8b0:4864:20::42f;
 helo=mail-pf1-x42f.google.com; envelope-from=zbestahu@gmail.com;
 receiver=<UNKNOWN>)
Authentication-Results: lists.ozlabs.org; dkim=pass (2048-bit key;
 unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256
 header.s=20161025 header.b=PnUiACrH; dkim-atps=neutral
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com
 [IPv6:2607:f8b0:4864:20::42f])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
 (No client certificate requested)
 by lists.ozlabs.org (Postfix) with ESMTPS id 4F5bqq417hz2ysh
 for <linux-erofs@lists.ozlabs.org>; Thu, 25 Mar 2021 18:11:18 +1100 (AEDT)
Received: by mail-pf1-x42f.google.com with SMTP id c204so1096367pfc.4
 for <linux-erofs@lists.ozlabs.org>; Thu, 25 Mar 2021 00:11:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20161025;
 h=from:to:cc:subject:date:message-id:mime-version
 :content-transfer-encoding;
 bh=oe6nREtlXO3tav0DHg4KkK1IYtnrvguu/l3h920mzVQ=;
 b=PnUiACrHB9QmlDQd41YOaHfwCS3aMUFIPrkckG/+w6kSuN7smRBe8qE9Sw9bQHiQBh
 p8Ef+Qw9ggQIKodRcrodLve4UZd+ZtOasy/Sn2zHATxRJmW8aCxYWLfKFGPq233OjAFS
 CQ2pannwwhLBCSbIq/jnEC/c945VLrAVBFc83IK0rcJptwX99wVSRTHBeA+us7PPISgE
 gFYeSEysTtAYLpu7UaeRCBwTFG8n3WHX5u8fH8N873oVVkDRT9o6PSH+PqSiAU8or4dB
 1Y5uVt+zB7bIzna6qD8rGZ6I7mvYKdqrsyZulHpfKMX3vZE1cEcvWQIGmFHCctF0rHWN
 uT+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
 :content-transfer-encoding;
 bh=oe6nREtlXO3tav0DHg4KkK1IYtnrvguu/l3h920mzVQ=;
 b=Mnrk2/J/m+rCkiO40Kcqa7jvkMFRFtXG1O9tMvAo8kcytkADvFajmhg0EPafN/gIuC
 JvJ7Ld7tQ/7KjmfX7jxycAK71R/TS0VBoojLWa76Az0KZklvEAR4D2hPQu9+QP0VZLEe
 xTittLWX+CiLdIuTgXrMpZhaRePiiTRk/4Nvqj3anulvHFbx4e+pKJPMp3IltvhxOZCK
 oVpS8yJlPEiuBl/jAdo4cFl0qqm+XutTbzJHxIlJjfK/caarJNhn2QI6pwvZrRiz/6K3
 u+AcOYIfu/B6c3/N5ihIxf4yvTbmF29vFQaoTjcqK3yQh3mloa408LdpQB9C0lBQ8zwI
 WLcw==
X-Gm-Message-State: AOAM531cEMGoHTtMIMmbmpuvIxmgTGN9YkD62r7Krt+chzWyiV8t0lCX
 bkqt8dZ+PEzDWTPGTtvNQoA=
X-Google-Smtp-Source: ABdhPJx0VemFa+fZ/Jo9BLsyQg3V5vTwqfc+6LhBApVqGK3tImoz7KsBSWW3EmKJGKJFo54/Zldo9w==
X-Received: by 2002:a65:53c8:: with SMTP id z8mr5104242pgr.340.1616656273540; 
 Thu, 25 Mar 2021 00:11:13 -0700 (PDT)
Received: from tj.ccdomain.com ([103.220.76.197])
 by smtp.gmail.com with ESMTPSA id 190sm4415094pgh.61.2021.03.25.00.11.11
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 25 Mar 2021 00:11:12 -0700 (PDT)
From: Yue Hu <zbestahu@gmail.com>
To: xiang@kernel.org,
	chao@kernel.org
Subject: [PATCH] erofs: don't use erofs_map_blocks() any more
Date: Thu, 25 Mar 2021 15:10:08 +0800
Message-Id: <20210325071008.573-1-zbestahu@gmail.com>
X-Mailer: git-send-email 2.29.2.windows.3
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
Cc: huyue2@yulong.com, linux-erofs@lists.ozlabs.org, zbestahu@163.com
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs"
 <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>

From: Yue Hu <huyue2@yulong.com>

Currently, erofs_map_blocks() will be called only from
erofs_{bmap, read_raw_page} which are all for uncompressed files.
So, the compression branch in erofs_map_blocks() is pointless. Let's
remove it and use erofs_map_blocks_flatmode() directly. Also update
related comments.

Signed-off-by: Yue Hu <huyue2@yulong.com>
---
 fs/erofs/data.c     | 19 ++-----------------
 fs/erofs/internal.h |  6 ++----
 2 files changed, 4 insertions(+), 21 deletions(-)

diff --git a/fs/erofs/data.c b/fs/erofs/data.c
index 1249e74..ebac756 100644
--- a/fs/erofs/data.c
+++ b/fs/erofs/data.c
@@ -109,21 +109,6 @@ static int erofs_map_blocks_flatmode(struct inode *inode,
 	return err;
 }
 
-int erofs_map_blocks(struct inode *inode,
-		     struct erofs_map_blocks *map, int flags)
-{
-	if (erofs_inode_is_data_compressed(EROFS_I(inode)->datalayout)) {
-		int err = z_erofs_map_blocks_iter(inode, map, flags);
-
-		if (map->mpage) {
-			put_page(map->mpage);
-			map->mpage = NULL;
-		}
-		return err;
-	}
-	return erofs_map_blocks_flatmode(inode, map, flags);
-}
-
 static inline struct bio *erofs_read_raw_page(struct bio *bio,
 					      struct address_space *mapping,
 					      struct page *page,
@@ -159,7 +144,7 @@ static inline struct bio *erofs_read_raw_page(struct bio *bio,
 		erofs_blk_t blknr;
 		unsigned int blkoff;
 
-		err = erofs_map_blocks(inode, &map, EROFS_GET_BLOCKS_RAW);
+		err = erofs_map_blocks_flatmode(inode, &map, EROFS_GET_BLOCKS_RAW);
 		if (err)
 			goto err_out;
 
@@ -318,7 +303,7 @@ static sector_t erofs_bmap(struct address_space *mapping, sector_t block)
 			return 0;
 	}
 
-	if (!erofs_map_blocks(inode, &map, EROFS_GET_BLOCKS_RAW))
+	if (!erofs_map_blocks_flatmode(inode, &map, EROFS_GET_BLOCKS_RAW))
 		return erofs_blknr(map.m_pa);
 
 	return 0;
diff --git a/fs/erofs/internal.h b/fs/erofs/internal.h
index 30e63b7..db8c847 100644
--- a/fs/erofs/internal.h
+++ b/fs/erofs/internal.h
@@ -289,7 +289,7 @@ static inline unsigned int erofs_inode_datalayout(unsigned int value)
 extern const struct address_space_operations z_erofs_aops;
 
 /*
- * Logical to physical block mapping, used by erofs_map_blocks()
+ * Logical to physical block mapping
  *
  * Different with other file systems, it is used for 2 access modes:
  *
@@ -336,7 +336,7 @@ struct erofs_map_blocks {
 	struct page *mpage;
 };
 
-/* Flags used by erofs_map_blocks() */
+/* Flags used by erofs_map_blocks_flatmode() */
 #define EROFS_GET_BLOCKS_RAW    0x0001
 
 /* zmap.c */
@@ -358,8 +358,6 @@ static inline int z_erofs_map_blocks_iter(struct inode *inode,
 /* data.c */
 struct page *erofs_get_meta_page(struct super_block *sb, erofs_blk_t blkaddr);
 
-int erofs_map_blocks(struct inode *, struct erofs_map_blocks *, int);
-
 /* inode.c */
 static inline unsigned long erofs_inode_hash(erofs_nid_t nid)
 {
-- 
1.9.1

