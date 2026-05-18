Return-Path: <linux-erofs+bounces-3413-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 33987CD343F
	for <linux-erofs@archiver.kernel.org>; Mon, 18 May 2026 05:58:10 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4gJnCY1Qzpz3dRR;
	Mon, 18 May 2026 15:58:01 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=185.125.188.120
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1779083881;
	cv=none; b=TsmuL0Sd9nWGrJ6KH7skd30KNclXR10BZb1ebfw+rX7Y0xdHTSfvCcCMGerAjbSKJfMqQTFiHL9YpgNG6aSCRV2loZUPoeBauiXcZEf0oFDRbvk8NYuVN9Uibpk/nOMvQugn3ZX8fxh/C1jSAa/TA4CHsIfvYZxK+nbULMN8bTj4qa3lim+jOGsd6cD9MO4AeIROClOtyod/6WRUA5bv5Ujyop6vHXidpugCulMDnLDMuq5xX1kOomGib+6DY4aMoo3+13BH1rt6T9dFy+SjXMg9/ysdJqyNxowjtnP6M/w+FELKUzgJxSuHgwLLhvNlxNaL3IetGBc949KVsUktdQ==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1779083881; c=relaxed/relaxed;
	bh=5zHUgAdevqUgcmdtpj2MuXNRgqlONo24CO8MVJlLQfA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n5jMcMEM4cfOwSE5FWecM6DIBTXy6+Ys1SbIU/MQyWC67AYDsMNtFAQwug8b4y4FhfWEddOTokPcC9yfqHVc3Wsorgd2zP6guG5ONuTWdbSL8kNfs+XGugwkDKOND0NILiwaucUT5l6hzUqauFz7mu+JK/253ritY7DvdriAZaDCqR8gQL6vHuxxdkWQv85mSVs3o6IeuvOs647VT5BAEbYdZd4yMwvLVO90GjWKIhteXABwiV/fQTg7IronoEepWTL6W75ALSpOphEMvWScjNb4757RZuaQJ5ww/m8QSgKScFVK61A99Mb7lu3mEifcGFnDxJoomnteydWuR9jQ7w==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=reject dis=none) header.from=canonical.com; dkim=pass (4096-bit key; unprotected) header.d=canonical.com header.i=@canonical.com header.a=rsa-sha256 header.s=20251003 header.b=Gdrq+G9p; dkim-atps=neutral; spf=pass (client-ip=185.125.188.120; helo=smtp-relay-canonical-0.canonical.com; envelope-from=heinrich.schuchardt@canonical.com; receiver=lists.ozlabs.org) smtp.mailfrom=canonical.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=reject dis=none) header.from=canonical.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (4096-bit key; unprotected) header.d=canonical.com header.i=@canonical.com header.a=rsa-sha256 header.s=20251003 header.b=Gdrq+G9p;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=canonical.com (client-ip=185.125.188.120; helo=smtp-relay-canonical-0.canonical.com; envelope-from=heinrich.schuchardt@canonical.com; receiver=lists.ozlabs.org)
Received: from smtp-relay-canonical-0.canonical.com (smtp-relay-canonical-0.canonical.com [185.125.188.120])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4gJnCS4ZLkz3dRP
	for <linux-erofs@lists.ozlabs.org>; Mon, 18 May 2026 15:57:54 +1000 (AEST)
Received: from LT03 (dynamic-046-114-109-175.46.114.pool.telefonica.de [46.114.109.175])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-canonical-0.canonical.com (Postfix) with ESMTPSA id 9B11C416F0;
	Mon, 18 May 2026 05:57:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
	s=20251003; t=1779083872;
	bh=5zHUgAdevqUgcmdtpj2MuXNRgqlONo24CO8MVJlLQfA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version;
	b=Gdrq+G9pQDqNAFesWmx6KXchQ9EUuzY/rVlBFPYB7DyVNv29kVF6Ymce1LgsdwyF4
	 B1HLUnEdNgop4KPJUJB+6SKVsfAWNkOx3nIoZ25srMpEtCyekqoTOCJgDpkdRLmiaw
	 nGNGXXIIb0JDSFD9pIYKlL1511Y9Yno4EXNqkJ+g+ov7++aJy26CL39sc3jvgv7OCV
	 dknXl1IUE/+2KIHNBZkDMqm6P43ML/up4b58aSC9vvaduRRlFeQASnpZuiPv1CxLKh
	 evK9RHqjuL2Mkv5hRP2L3eVie+eXkxhjfZkNmhssFH8RJlJe9Q7e+g6feGPntH3xrl
	 3ZSKWm+XIzT2aZZvPns5FhQ4LfrOy/AYbjVhAdkXtC/KqYsGnKKv3hSIbQuRD5HSQ/
	 CmGdh9UvqrW0v29ENdv81n86CLjDsaipwE3lMrij+GJE4iF2hIKI5sK5+Nzps9E7Uk
	 vKmD5IPfVYrQDS5AeSvT87YRJHRsYPQfcccSD5NLz/b/8yvYj7z4FLzGJbhVMYS9sM
	 yMZjV1KWGs0UQuJw5Hp7SAB2Oq1IVeDLUcdCfnVgWxrWl+VlAnEHYWomE/86gCGaCM
	 fN0Snf2oy8Uj3Zcye9Wb2ZSG8G5SAT+PLSyD/9sNRVpdERVA91Unr8dbNsnHnFCngm
	 0KxcsQrtGeNngxxyhsEVWYqk=
From: Heinrich Schuchardt <heinrich.schuchardt@canonical.com>
To: Tom Rini <trini@konsulko.com>
Cc: Simon Glass <sjg@chromium.org>,
	Huang Jianan <jnhuang95@gmail.com>,
	Quentin Schulz <quentin.schulz@cherry.de>,
	Tony Dinh <mibodhi@gmail.com>,
	=?UTF-8?q?Timo=20tp=20Prei=C3=9Fl?= <t.preissl@proton.me>,
	Francois Berder <fberder@outlook.fr>,
	Andrew Goodbody <andrew.goodbody@linaro.org>,
	Daniel Palmer <daniel@thingy.jp>,
	Varadarajan Narayanan <varadarajan.narayanan@oss.qualcomm.com>,
	Sughosh Ganu <sughosh.ganu@arm.com>,
	Ilias Apalodimas <ilias.apalodimas@linaro.org>,
	Peng Fan <peng.fan@nxp.com>,
	Marek Vasut <marek.vasut+renesas@mailbox.org>,
	u-boot@lists.denx.de,
	linux-erofs@lists.ozlabs.org,
	Heinrich Schuchardt <heinrich.schuchardt@canonical.com>
Subject: [PATCH 2/9] fs: print change date in directory listing for FAT
Date: Mon, 18 May 2026 07:57:21 +0200
Message-ID: <20260518055728.178507-3-heinrich.schuchardt@canonical.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260518055728.178507-1-heinrich.schuchardt@canonical.com>
References: <20260518055728.178507-1-heinrich.schuchardt@canonical.com>
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
Content-Transfer-Encoding: 8bit

fs_ls_generic() displays file sizes but no timestamps. The FAT
filesystem stores a change date in every directory entry and already
populates fs_dirent::change_time in fat_readdir(). Print the date
alongside the file size for filesystems that provide it.

Add a u32 capability bitmap (caps) to struct fstype_info. Each bit
documents a property that the filesystem's readdir() implementation
guarantees:

  FS_CAP_DATE  BIT(0)  change_time in fs_dirent is valid

fs_ls_generic() tests FS_CAP_DATE once before the loop to select a
consistent output format for the entire listing:

  12345678  2024-03-15 09:30  filename.txt    (FAT)
  12345678   filename.txt                     (ext4, squashfs, ...)

Set FS_CAP_DATE for FAT. fat2rtc() loses the __maybe_unused annotation
since it is now called unconditionally outside XPL builds. The attr,
create_time, change_time, and access_time fields that were previously
only populated under CONFIG_EFI_LOADER are now populated whenever
CONFIG_XPL_BUILD is not set.

Extending the feature to another filesystem requires only adding
.caps = FS_CAP_DATE to its fstype_info entry and ensuring its readdir()
fills in fs_dirent::change_time.

Signed-off-by: Heinrich Schuchardt <heinrich.schuchardt@canonical.com>
---
 fs/fat/fat.c |  2 +-
 fs/fs.c      | 38 +++++++++++++++++++++++++++++++++++---
 2 files changed, 36 insertions(+), 4 deletions(-)

diff --git a/fs/fat/fat.c b/fs/fat/fat.c
index c1ccf30771a..7443f5952af 100644
--- a/fs/fat/fat.c
+++ b/fs/fat/fat.c
@@ -1539,7 +1539,7 @@ int fat_readdir(struct fs_dir_stream *dirs, struct fs_dirent **dentp)
 
 	memset(dent, 0, sizeof(*dent));
 	strcpy(dent->name, dir->itr.name);
-	if (CONFIG_IS_ENABLED(EFI_LOADER)) {
+	if (!IS_ENABLED(CONFIG_XPL_BUILD)) {
 		dent->attr = dir->itr.dent->attr;
 		fat2rtc(le16_to_cpu(dir->itr.dent->cdate),
 			le16_to_cpu(dir->itr.dent->ctime), &dent->create_time);
diff --git a/fs/fs.c b/fs/fs.c
index fe62b71c83c..f8e4794c10e 100644
--- a/fs/fs.c
+++ b/fs/fs.c
@@ -38,6 +38,11 @@ static int fs_dev_part;
 static struct disk_partition fs_partition;
 static int fs_type = FS_TYPE_ANY;
 
+/*
+ * define FS_CAP_DATE - readdir() populates fs_dirent::change_time
+ */
+#define FS_CAP_DATE	BIT(0)
+
 struct fstype_info {
 	int fstype;
 	char *name;
@@ -50,6 +55,10 @@ struct fstype_info {
 	 * filesystem.
 	 */
 	bool null_dev_desc_ok;
+#if !IS_ENABLED(CONFIG_XPL_BUILD)
+	/* Capability flags (FS_CAP_*) */
+	u32 caps;
+#endif
 	int (*probe)(struct blk_desc *fs_dev_desc,
 		     struct disk_partition *fs_partition);
 	int (*ls)(const char *dirname);
@@ -98,10 +107,19 @@ static inline int fs_ls_unsupported(const char *dirname)
 	return -1;
 }
 
+/* Forward declaration - defined after fstypes[] */
+static struct fstype_info *fs_get_info(int fstype);
+
 /* generic implementation of ls in terms of opendir/readdir/closedir */
 __maybe_unused
 static int fs_ls_generic(const char *dirname)
 {
+#if !IS_ENABLED(CONFIG_XPL_BUILD)
+	struct fstype_info *info = fs_get_info(fs_type);
+	bool has_date = !!(info->caps & FS_CAP_DATE);
+#else
+	bool has_date = false;
+#endif
 	struct fs_dir_stream *dirs;
 	struct fs_dirent *dent;
 	int nfiles = 0, ndirs = 0;
@@ -112,15 +130,26 @@ static int fs_ls_generic(const char *dirname)
 
 	while ((dent = fs_readdir(dirs))) {
 		if (dent->type == FS_DT_DIR) {
-			printf("            %s/\n", dent->name);
+			printf("          ");
 			ndirs++;
 		} else if (dent->type == FS_DT_LNK) {
-			printf("    <SYM>   %s\n", dent->name);
+			printf("    <SYM> ");
 			nfiles++;
 		} else {
-			printf(" %8lld   %s\n", dent->size, dent->name);
+			printf(" %8lld ", dent->size);
 			nfiles++;
 		}
+		if (has_date)
+			printf("%04d-%02d-%02d %02d:%02d ",
+			       dent->change_time.tm_year,
+			       dent->change_time.tm_mon,
+			       dent->change_time.tm_mday,
+			       dent->change_time.tm_hour,
+			       dent->change_time.tm_min);
+		if (dent->type == FS_DT_DIR)
+			printf("%s/\n", dent->name);
+		else
+			printf("%s\n", dent->name);
 	}
 
 	fs_closedir(dirs);
@@ -196,6 +225,9 @@ static struct fstype_info fstypes[] = {
 		.fstype = FS_TYPE_FAT,
 		.name = "fat",
 		.null_dev_desc_ok = false,
+#if !IS_ENABLED(CONFIG_XPL_BUILD)
+		.caps = FS_CAP_DATE,
+#endif
 		.probe = fat_set_blk_dev,
 		.close = fat_close,
 		.ls = fs_ls_generic,
-- 
2.53.0


