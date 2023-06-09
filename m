Return-Path: <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7DE49C7EE37
	for <linux-erofs@archiver.kernel.org>; Fri,  9 Jun 2023 08:51:18 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [IPv6:::1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4Qcvv90x2Vz3f5K
	for <linux-erofs@archiver.kernel.org>; Fri,  9 Jun 2023 18:51:17 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=lists.ozlabs.org;
	s=201707; t=1686300677;
	bh=3ELO6HozUT7Rdc89qBxXaVL8f32CxWD12uEP7WA3h8I=;
	h=To:Subject:Date:In-Reply-To:References:List-Id:List-Unsubscribe:
	 List-Archive:List-Post:List-Help:List-Subscribe:From:Reply-To:Cc:
	 From;
	b=USU+8FY1SypJHJ8TNT55kYqaw+PCfRJbXXSTDIytGtZT9seb1Df36CeGyV8C0g2Ms
	 QnDrI/gvF3PWIQXxFOD5i3WEi2ydqgaYCy2Ax3q2HfhbGQl0V+6CavbdoXt7N8JkfO
	 +f5Jbiyrczbu5RjuJMUwRSmRTVc3n1bhtLMwr1hX3aZ97g+8JzfdB2aJLKXRlc+Sew
	 mR0qkvNVrqOzdK3myQ1fh5h+C35DSyNEbQy/TdhMPlZ+LDwvgkrfOPfn8wUm6d36jL
	 ATwrQ7O2orOGxQ3oI4T9a9def2yb+IOSH9CbhvEIZddVJ0pn5qiFg2T9/A/mRPhN0D
	 EciwPrHlpJ3lg==
Authentication-Results: lists.ozlabs.org; spf=none (no SPF record) smtp.mailfrom=huaweicloud.com (client-ip=14.137.139.154; helo=frasgout12.his.huawei.com; envelope-from=guoxuenan@huaweicloud.com; receiver=<UNKNOWN>)
Received: from frasgout12.his.huawei.com (unknown [14.137.139.154])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4Qcvtw1Fctz3dqq
	for <linux-erofs@lists.ozlabs.org>; Fri,  9 Jun 2023 18:51:03 +1000 (AEST)
Received: from mail02.huawei.com (unknown [172.18.147.229])
	by frasgout12.his.huawei.com (SkyGuard) with ESMTP id 4Qcvd25VW9z9xGXN
	for <linux-erofs@lists.ozlabs.org>; Fri,  9 Jun 2023 16:39:02 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.170])
	by APP2 (Coremail) with SMTP id BqC_BwD3GnXj54Jk9pqGCA--.24524S4;
	Fri, 09 Jun 2023 08:50:52 +0000 (GMT)
To: hsiangkao@linux.alibaba.com,
	jefflexu@linux.alibaba.com,
	linux-erofs@lists.ozlabs.org
Subject: [PATCH 2/4] erofs-utils: lib: unify all identical compressor print function
Date: Fri,  9 Jun 2023 16:50:39 +0800
Message-Id: <20230609085041.14987-3-guoxuenan@huawei.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20230609085041.14987-1-guoxuenan@huawei.com>
References: <20230609085041.14987-1-guoxuenan@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: BqC_BwD3GnXj54Jk9pqGCA--.24524S4
X-Coremail-Antispam: 1UD129KBjvJXoWxJw45JFW5Wr4UAw18Zw4fXwb_yoW7JFW8pr
	15GryrGrWrXr15Aw4rJrs5KFy3Grs7KF1UJw17G3s3J3W5XrZ7XF48tFn5ZFWUGryfZa1v
	vw42vw47Gw4rtF7anT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUBjb4IE77IF4wAFF20E14v26ryj6rWUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28IrcIa0xkI8VA2jI8067AKxVWUXw
	A2048vs2IY020Ec7CjxVAFwI0_JFI_Gr1l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxS
	w2x7M28EF7xvwVC0I7IYx2IY67AKxVWUJVWUCwA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxV
	W8JVWxJwA2z4x0Y4vEx4A2jsIE14v26r1j6r4UM28EF7xvwVC2z280aVCY1x0267AKxVW8
	JVW8Jr1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx
	0E2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWU
	JVW8JwACjcxG0xvY0x0EwIxGrwCF04k20xvY0x0EwIxGrwCF04k20xvEw4C26cxK6c8Ij2
	8IcwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480
	Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_JF0_Jw1lIxkGc2Ij64vIr41lIxAIcVC0I7
	IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Gr0_Cr1lIxAIcVCF04k2
	6cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxV
	AFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x07URuWLUUUUU=
X-CM-SenderInfo: xjxr53hhqd0q5kxd4v5lfo033gof0z/
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
From: Guo Xuenan via Linux-erofs <linux-erofs@lists.ozlabs.org>
Reply-To: Guo Xuenan <guoxuenan@huawei.com>
Cc: jack.qiu@huawei.com
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs" <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>

{dump,fsck}.erofs use the same compressor print function,
available_compressors means which algothrims are currently
supported by binary tools.
supported_compressors including all algothrims that are ready
for erofs.

Signed-off-by: Guo Xuenan <guoxuenan@huawei.com>
---
 fsck/main.c              | 15 +-----------
 include/erofs/compress.h |  3 ++-
 lib/compressor.c         | 51 ++++++++++++++++++++++++++--------------
 mkfs/main.c              | 15 +-----------
 4 files changed, 38 insertions(+), 46 deletions(-)

diff --git a/fsck/main.c b/fsck/main.c
index f816bec..978d198 100644
--- a/fsck/main.c
+++ b/fsck/main.c
@@ -49,19 +49,6 @@ static struct option long_options[] = {
 	{0, 0, 0, 0},
 };
 
-static void print_available_decompressors(FILE *f, const char *delim)
-{
-	unsigned int i = 0;
-	const char *s;
-
-	while ((s = z_erofs_list_available_compressors(i)) != NULL) {
-		if (i++)
-			fputs(delim, f);
-		fputs(s, f);
-	}
-	fputc('\n', f);
-}
-
 static void usage(void)
 {
 	fputs("usage: [options] IMAGE\n\n"
@@ -84,7 +71,7 @@ static void usage(void)
 	      " --no-preserve-owner    extract as yourself\n"
 	      " --no-preserve-perms    apply user's umask when extracting permissions\n"
 	      "\nSupported algorithms are: ", stderr);
-	print_available_decompressors(stderr, ", ");
+	zerofs_print_available_compressors(stderr);
 }
 
 static void erofsfsck_print_version(void)
diff --git a/include/erofs/compress.h b/include/erofs/compress.h
index 08af9e3..714f304 100644
--- a/include/erofs/compress.h
+++ b/include/erofs/compress.h
@@ -22,7 +22,8 @@ int erofs_write_compressed_file(struct erofs_inode *inode, int fd);
 int z_erofs_compress_init(struct erofs_buffer_head *bh);
 int z_erofs_compress_exit(void);
 
-const char *z_erofs_list_available_compressors(unsigned int i);
+void zerofs_print_available_compressors(FILE *f);
+void zerofs_print_supported_compressors(FILE *f, unsigned int mask);
 
 static inline bool erofs_is_packed_inode(struct erofs_inode *inode)
 {
diff --git a/lib/compressor.c b/lib/compressor.c
index 0fa7105..5aee4e0 100644
--- a/lib/compressor.c
+++ b/lib/compressor.c
@@ -10,18 +10,6 @@
 
 #define EROFS_CONFIG_COMPR_DEF_BOUNDARY		(128)
 
-static const struct erofs_compressor *compressors[] = {
-#if LZ4_ENABLED
-#if LZ4HC_ENABLED
-		&erofs_compressor_lz4hc,
-#endif
-		&erofs_compressor_lz4,
-#endif
-#if HAVE_LIBLZMA
-		&erofs_compressor_lzma,
-#endif
-};
-
 /* compressing configuration specified by users */
 static struct erofs_supported_algothrim {
 	int algtype;
@@ -85,9 +73,38 @@ int erofs_compress_destsize(const struct erofs_compress *c,
 	return ret;
 }
 
-const char *z_erofs_list_available_compressors(unsigned int i)
+void zerofs_print_supported_compressors(FILE *f, unsigned int mask)
+{
+	unsigned int i = 0;
+	int comma = false;
+	const char *s;
+
+	while (i < erofs_compressor_num()) {
+		s = erofs_ccfg.compressors[i].name;
+		if (s && (mask & (1 << erofs_ccfg.compressors[i++].algorithmtype))) {
+			if (comma)
+				fputs(", ", f);
+			else
+				comma = true;
+			fputs(s, f);
+		}
+	}
+	fputc('\n', f);
+}
+
+void zerofs_print_available_compressors(FILE *f)
 {
-	return i >= ARRAY_SIZE(compressors) ? NULL : compressors[i]->name;
+	unsigned int i = 0;
+	const char *s;
+
+	while (i < erofs_compressor_num() &&
+			erofs_ccfg.compressors[i].handle.alg &&
+			(s = erofs_ccfg.compressors[i].name)) {
+		if (i++)
+			fputs(", ", f);
+		fputs(s, f);
+	}
+	fputc('\n', f);
 }
 
 int erofs_compressor_setlevel(struct erofs_compress *c, int compression_level)
@@ -120,11 +137,11 @@ int erofs_compressor_init(struct erofs_compress *c, char *alg_name)
 	}
 
 	ret = -EINVAL;
-	for (i = 0; i < ARRAY_SIZE(compressors); ++i) {
-		if (alg_name && strcmp(alg_name, compressors[i]->name))
+	for (i = 0; i < erofs_compressor_num(); ++i) {
+		if (alg_name && strcmp(alg_name, erofs_ccfg.compressors[i].name))
 			continue;
 
-		ret = compressors[i]->init(c);
+		ret = erofs_ccfg.compressors[i].handle.alg->init(c);
 		if (!ret) {
 			DBG_BUGON(!c->alg);
 			return 0;
diff --git a/mkfs/main.c b/mkfs/main.c
index ac208e5..dbd168e 100644
--- a/mkfs/main.c
+++ b/mkfs/main.c
@@ -66,19 +66,6 @@ static struct option long_options[] = {
 	{0, 0, 0, 0},
 };
 
-static void print_available_compressors(FILE *f, const char *delim)
-{
-	unsigned int i = 0;
-	const char *s;
-
-	while ((s = z_erofs_list_available_compressors(i)) != NULL) {
-		if (i++)
-			fputs(delim, f);
-		fputs(s, f);
-	}
-	fputc('\n', f);
-}
-
 static void usage(void)
 {
 	fputs("usage: [options] FILE DIRECTORY\n\n"
@@ -126,7 +113,7 @@ static void usage(void)
 	      " --block-list-file=X   X=block_list file\n"
 #endif
 	      "\nAvailable compressors are: ", stderr);
-	print_available_compressors(stderr, ", ");
+	zerofs_print_available_compressors(stderr);
 }
 
 static unsigned int pclustersize_packed, pclustersize_max;
-- 
2.31.1

