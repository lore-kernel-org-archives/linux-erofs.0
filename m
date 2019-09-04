Return-Path: <SRS0=/jrW=W7=lists.ozlabs.org=linux-erofs-bounces+linux-erofs=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 279D1C3A5A2
	for <linux-erofs@archiver.kernel.org>; Wed,  4 Sep 2019 02:11:18 +0000 (UTC)
Received: from lists.ozlabs.org (lists.ozlabs.org [203.11.71.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id A66FC21897
	for <linux-erofs@archiver.kernel.org>; Wed,  4 Sep 2019 02:11:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A66FC21897
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Received: from bilbo.ozlabs.org (lists.ozlabs.org [IPv6:2401:3900:2:1::3])
	by lists.ozlabs.org (Postfix) with ESMTP id 46NS3l3SHSzDqlR
	for <linux-erofs@archiver.kernel.org>; Wed,  4 Sep 2019 12:11:15 +1000 (AEST)
Authentication-Results: lists.ozlabs.org;
 spf=pass (mailfrom) smtp.mailfrom=huawei.com
 (client-ip=45.249.212.35; helo=huawei.com; envelope-from=gaoxiang25@huawei.com;
 receiver=<UNKNOWN>)
Authentication-Results: lists.ozlabs.org;
 dmarc=none (p=none dis=none) header.from=huawei.com
Received: from huawei.com (szxga07-in.huawei.com [45.249.212.35])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by lists.ozlabs.org (Postfix) with ESMTPS id 46NS2m3s0BzDqlg
 for <linux-erofs@lists.ozlabs.org>; Wed,  4 Sep 2019 12:10:24 +1000 (AEST)
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.58])
 by Forcepoint Email with ESMTP id 60BE85B9F2CE80E7185B;
 Wed,  4 Sep 2019 10:10:20 +0800 (CST)
Received: from architecture4.huawei.com (10.140.130.215) by smtp.huawei.com
 (10.3.19.211) with Microsoft SMTP Server (TLS) id 14.3.439.0; Wed, 4 Sep 2019
 10:10:11 +0800
From: Gao Xiang <gaoxiang25@huawei.com>
To: Chao Yu <yuchao0@huawei.com>, Greg Kroah-Hartman
 <gregkh@linuxfoundation.org>, Christoph Hellwig <hch@lst.de>,
 <devel@driverdev.osuosl.org>
Subject: [PATCH v2 06/25] erofs: use feature_incompat rather than requirements
Date: Wed, 4 Sep 2019 10:08:53 +0800
Message-ID: <20190904020912.63925-7-gaoxiang25@huawei.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190904020912.63925-1-gaoxiang25@huawei.com>
References: <20190901055130.30572-1-hsiangkao@aol.com>
 <20190904020912.63925-1-gaoxiang25@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.140.130.215]
X-CFilter-Loop: Reflected
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
Cc: linux-fsdevel@vger.kernel.org, Miao Xie <miaoxie@huawei.com>,
 linux-erofs@lists.ozlabs.org
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs"
 <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>

As Christoph said [1], "This is only cosmetic, why
not stick to feature_compat and feature_incompat?"

In my thought, requirements means "incompatible"
instead of "feature" though.

[1] https://lore.kernel.org/r/20190902125109.GA9826@infradead.org/
Reported-by: Christoph Hellwig <hch@infradead.org>
Signed-off-by: Gao Xiang <gaoxiang25@huawei.com>
---
 fs/erofs/decompressor.c |  3 ++-
 fs/erofs/erofs_fs.h     | 12 ++++++------
 fs/erofs/internal.h     |  2 +-
 fs/erofs/super.c        | 10 +++++-----
 4 files changed, 14 insertions(+), 13 deletions(-)

diff --git a/fs/erofs/decompressor.c b/fs/erofs/decompressor.c
index df349888f911..555c04730f87 100644
--- a/fs/erofs/decompressor.c
+++ b/fs/erofs/decompressor.c
@@ -129,7 +129,8 @@ static int lz4_decompress(struct z_erofs_decompress_req *rq, u8 *out)
 	support_0padding = false;
 
 	/* decompression inplace is only safe when 0padding is enabled */
-	if (EROFS_SB(rq->sb)->requirements & EROFS_REQUIREMENT_LZ4_0PADDING) {
+	if (EROFS_SB(rq->sb)->feature_incompat &
+	    EROFS_FEATURE_INCOMPAT_LZ4_0PADDING) {
 		support_0padding = true;
 
 		while (!src[inputmargin & ~PAGE_MASK])
diff --git a/fs/erofs/erofs_fs.h b/fs/erofs/erofs_fs.h
index 87d7ae82339a..b2aef3bc377d 100644
--- a/fs/erofs/erofs_fs.h
+++ b/fs/erofs/erofs_fs.h
@@ -11,17 +11,17 @@
 #define EROFS_SUPER_OFFSET      1024
 
 /*
- * Any bits that aren't in EROFS_ALL_REQUIREMENTS should be
- * incompatible with this kernel version.
+ * Any bits that aren't in EROFS_ALL_FEATURE_INCOMPAT should
+ * be incompatible with this kernel version.
  */
-#define EROFS_REQUIREMENT_LZ4_0PADDING	0x00000001
-#define EROFS_ALL_REQUIREMENTS		EROFS_REQUIREMENT_LZ4_0PADDING
+#define EROFS_FEATURE_INCOMPAT_LZ4_0PADDING	0x00000001
+#define EROFS_ALL_FEATURE_INCOMPAT		EROFS_FEATURE_INCOMPAT_LZ4_0PADDING
 
 /* 128-byte erofs on-disk super block */
 struct erofs_super_block {
 	__le32 magic;           /* file system magic number */
 	__le32 checksum;        /* crc32c(super_block) */
-	__le32 features;        /* (aka. feature_compat) */
+	__le32 feature_compat;
 	__u8 blkszbits;         /* support block_size == PAGE_SIZE only */
 	__u8 reserved;
 
@@ -35,7 +35,7 @@ struct erofs_super_block {
 	__le32 xattr_blkaddr;	/* start block address of shared xattr area */
 	__u8 uuid[16];          /* 128-bit uuid for volume */
 	__u8 volume_name[16];   /* volume name */
-	__le32 requirements;    /* (aka. feature_incompat) */
+	__le32 feature_incompat;
 
 	__u8 reserved2[44];
 };
diff --git a/fs/erofs/internal.h b/fs/erofs/internal.h
index 141ea424587d..7ff36f404ec3 100644
--- a/fs/erofs/internal.h
+++ b/fs/erofs/internal.h
@@ -96,7 +96,7 @@ struct erofs_sb_info {
 
 	u8 uuid[16];                    /* 128-bit uuid for volume */
 	u8 volume_name[16];             /* volume name */
-	u32 requirements;
+	u32 feature_incompat;
 
 	unsigned int mount_opt;
 
diff --git a/fs/erofs/super.c b/fs/erofs/super.c
index 6603f0ba8905..6a7ab194783c 100644
--- a/fs/erofs/super.c
+++ b/fs/erofs/super.c
@@ -67,14 +67,14 @@ static void free_inode(struct inode *inode)
 static bool check_layout_compatibility(struct super_block *sb,
 				       struct erofs_super_block *layout)
 {
-	const unsigned int requirements = le32_to_cpu(layout->requirements);
+	const unsigned int feature = le32_to_cpu(layout->feature_incompat);
 
-	EROFS_SB(sb)->requirements = requirements;
+	EROFS_SB(sb)->feature_incompat = feature;
 
 	/* check if current kernel meets all mandatory requirements */
-	if (requirements & (~EROFS_ALL_REQUIREMENTS)) {
-		errln("unidentified requirements %x, please upgrade kernel version",
-		      requirements & ~EROFS_ALL_REQUIREMENTS);
+	if (feature & (~EROFS_ALL_FEATURE_INCOMPAT)) {
+		errln("unidentified incompatible feature %x, please upgrade kernel version",
+		      feature & ~EROFS_ALL_FEATURE_INCOMPAT);
 		return false;
 	}
 	return true;
-- 
2.17.1

