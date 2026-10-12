Return-Path: <linux-erofs+bounces-4698-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7EF37CA9EC5
	for <linux-erofs@archiver.kernel.org>; Mon, 12 Oct 2026 14:01:19 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4j3JzL0zyhz30WQ;
	Tue, 13 Oct 2026 01:01:18 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=185.125.188.122
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1791813678;
	cv=none; b=EGiDlI6mIbDpmBoh7cDhXzqch9uOtfCYGyv+VLLYiRQYBYeO4tIFs2ETgV9Mjk92icj97AY+CKn+1BvyrTdxg2g8O7SRCIIHe1v8V+J7ID1yNWh94Umov2VW2U9qTy8Q1X5IRpd06GpLK4xSwXymogxGGpO8khtYKr8Rr5k22G3O49lldeZWooivk5pqP1nTqmeVZp5aBt96WFlj3XUCBIPp5vg89APhEv3Ra5vFw1WNboNP3jvDv+kSu5InUmjlv+bJKZ5LP69uxGJ5Qip0EKovLVNPE8EgqEHy9WrGLR0ef2Qb3cB1wU037/IuGrrGytDbpi3YRZHp9gwPr+kx3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1791813678; c=relaxed/relaxed;
	bh=QOsDFRp3TKDVFxqmB41q8YobI+Hs1Pby8cBb0RwFczE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OwjLwnCVZFILHvpEAOG35J4Pzb9fuVuL+h9pmPsDdXWDzZXt/MEHm/ZseT17dsMK1SYwxyhpMO1BIqt3hNez+D4SjYIXW4ODuF2xTnQ8RbsdyuCk16bpSVsE5t/QW1KVQKI4/I3kOlIZCAfwNWBVwN0iZBajCIkqqXAj4RpV0UUDrzyw0TCkzCaw1O4XIzt84Y6xoDRgn8WFzYH1s1sOxaMuT3msueSErTxbdZseBnfLJXHHzFteVoTTeDdnH81xypQubzGe0aEoePtVd6OZRVdLhhFVJm3e5+wMinIP7j94cQoW3FGvBngHoyUU9Qs3UYRzr3eZwPS1qQkNndrUuw==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=reject dis=none) header.from=canonical.com; dkim=pass (4096-bit key; unprotected) header.d=canonical.com header.i=@canonical.com header.a=rsa-sha256 header.s=20251003 header.b=RN7KpRzQ; dkim-atps=neutral; spf=pass (client-ip=185.125.188.122; helo=smtp-relay-internal-0.canonical.com; envelope-from=heinrich.schuchardt@canonical.com; receiver=lists.ozlabs.org) smtp.mailfrom=canonical.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=reject dis=none) header.from=canonical.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (4096-bit key; unprotected) header.d=canonical.com header.i=@canonical.com header.a=rsa-sha256 header.s=20251003 header.b=RN7KpRzQ;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=canonical.com (client-ip=185.125.188.122; helo=smtp-relay-internal-0.canonical.com; envelope-from=heinrich.schuchardt@canonical.com; receiver=lists.ozlabs.org)
Received: from smtp-relay-internal-0.canonical.com (smtp-relay-internal-0.canonical.com [185.125.188.122])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4j3JzK2t5tz30WJ
	for <linux-erofs@lists.ozlabs.org>; Tue, 13 Oct 2026 01:01:17 +1100 (AEDT)
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com [209.85.128.71])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id AF71D3F285
	for <linux-erofs@lists.ozlabs.org>; Mon, 12 Oct 2026 14:01:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
	s=20251003; t=1791813674;
	bh=QOsDFRp3TKDVFxqmB41q8YobI+Hs1Pby8cBb0RwFczE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version;
	b=RN7KpRzQhnZ+eKPsKm9XE3z0ZeU3sPGci3Ay/O2oxP1bNKoASRa4e9aF1cy1hAOHg
	 WbtqCNBYHV1havsCfQlB6xxSHO8mkcUrPtUgfohYYSHle62Uhc5JNmqynznY9+lnmw
	 kHeWIIyFkpqolHT9QP+1+QRk4FpswP6nDgA9AroVF44FXhw1ZFc9TS92mfzEqEzwt5
	 Gc+79wdnCq24mCkrE8N2JgMpRsyfAti6njigMlDx9yKmU0fm9ODPS9LkL0af43RF7y
	 7Uh7r5eAhPSGXWuCAPvqKzTDnaokbcqSou56//Ej2NpfbaG2xUtadI+90PHDr+9zSj
	 lvoNWP6Qwe/SbCAylwRc69mfPCSTVf5ie4c9VZ3g0HVOf5049uWqK27D5/Q/ATDeWF
	 k9j1Q4q8/kOXj/3xji7lFSxEbib7qTvryhISfRvXNDUdM1RogOGRrLunt+7GWvXkjy
	 C2W05rfTnbSMuti24K0tLBdkiMG5weN5We+HCyFarSicykwoAthZhAMUE5eUnIeGW4
	 aOA/JszFHFhvY+bnqPUrOUXCUwGqjc8K3eo6tdp+nF3vujGHO2zCH3AQ2JuYB8CbBN
	 TkKGYCQOoQtSa9y7gPU0GImOZKC1NDba2RHopA3PTDjMrKhlo4yGfHeN+op6Ja0EnR
	 ntOQFIe21+cQKK0SxkgcIBgM=
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-4994d67d0e3so13411035e9.2
        for <linux-erofs@lists.ozlabs.org>; Mon, 12 Oct 2026 07:01:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791813674; x=1792418474;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=QOsDFRp3TKDVFxqmB41q8YobI+Hs1Pby8cBb0RwFczE=;
        b=qBGGLdiaHKUWLdoFTTokyrTo4jbNAPkt5RyEUYrGwPjve20up0uiIPHYRBhk4i7ot9
         8LjWH5Zfk0go7+q5rYfJzrLfkXSLNl0Q5qQKuY+1Oxu9L0/N0PK+55mj9sh/y/0HWKHY
         v24xVELuTUd8EzEOo+t2GtjZPANsTGyX3IJ7ELG4TNRgn1+U4Ekiq87QoVlFsQqCgUbe
         bo14XpQPMk0I6h8DpWGmRr7gazNWB4yETbcmwzNm8/fBIqr9wr4ZIuutMR25ZIkZSj0w
         2UpPaEhTZUX+dv4+REqXWldqlN/1adXxgk8HPot+SKlLwwTjR0ojECkQZBMdv1xdThHN
         EdgA==
X-Forwarded-Encrypted: i=1; AKwUvBwwjdFS20P4HG7cui2xmwF0QN53ojIMtClbylgVJuI3MM6WZ1xtelpduPZW+Y/LClMAgWEy+K49srukXA==@lists.ozlabs.org
X-Gm-Message-State: AFq9FYJFZls9ixWr+p86Iv7YL/aN1ukuMSnLh4jUGQxpxw1lcT6CvvaR
	Qf4oIlk+6LccjXpgpzNfvVoypCr0Dx6GnvG3yEU/cfdlF6jr44Paro2JHwBCJP5pSpB+dAV6iIB
	E6y8ACdGeJdoxsC5hQdyEf9jNzOa+t1naFRyqKdxQNuGwgB5LnOYM89gyJ0Y7+Y8GTRbwn4YOCN
	GARABryA==
X-Gm-Gg: AYBFou0XXTbQINeFBGdqYMCGsuTI2u1CaI31OVF3s0+pYS360hlCkjwFiOs1sci/+qE
	/4duvOrBDVbmnTX8RbaPMkSgk80NyDBr/PjMA+ETcUz84/nnFx3Bpf1q8jqdosnD1VIh7Qx5J3e
	+0bmrXZzw2JwPRJqWM81gDBQezN0ph3ui7GpcvQXr9n/9Rrz7i1/gpKB47ytY8l4xfFeIFdLxf+
	JCZgOsCGdZWGMVRHnA3iRlriINsEbANNq2f27+X4l/yjk+Aa3iIQ5Q4NCOMbCLZysyYiRJ9JDUJ
	TQcXak4rXSl6gQMviJMUnH1vH38RqcJIvXIyzDJgKxsjm09s6Bbf4Utv1slA6xUTGGMfrargtN5
	+W+DlJzfu2SgreybLqLF0X8tIICb779ZttkfTVbd/ehY6YgOSdsIJfpU=
X-Received: by 2002:a05:600c:3b98:b0:499:79b9:e220 with SMTP id 5b1f17b1804b1-4a18e49886amr207510555e9.10.1791813674025;
        Mon, 12 Oct 2026 07:01:14 -0700 (PDT)
X-Received: by 2002:a05:600c:3b98:b0:499:79b9:e220 with SMTP id 5b1f17b1804b1-4a18e49886amr207509665e9.10.1791813673443;
        Mon, 12 Oct 2026 07:01:13 -0700 (PDT)
Received: from workstation5 ([2a02:908:1242:30e0:468d:767c:32e6:22fa])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a18bf15691sm284551015e9.6.2026.10.12.07.01.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Oct 2026 07:01:11 -0700 (PDT)
From: Heinrich Schuchardt <heinrich.schuchardt@canonical.com>
To: Tom Rini <trini@konsulko.com>
Cc: Simon Glass <sjg@chromium.org>,
	Huang Jianan <jnhuang95@gmail.com>,
	Daniel Munic <v-dmunic@microsoft.com>,
	Tony Dinh <mibodhi@gmail.com>,
	Alexey Charkov <alchark@flipper.net>,
	Vincent Jardin <vjardin@free.fr>,
	joaomarcos.costa@bootlin.com,
	Aristo Chen <aristo.chen@canonical.com>,
	u-boot@lists.u-boot-project.org,
	linux-erofs@lists.ozlabs.org,
	Heinrich Schuchardt <heinrich.schuchardt@canonical.com>
Subject: [PATCH 2/9] fs: print change date in directory listing for FAT
Date: Mon, 12 Oct 2026 16:00:41 +0200
Message-ID: <20261012140048.214059-3-heinrich.schuchardt@canonical.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261012140048.214059-1-heinrich.schuchardt@canonical.com>
References: <20261012140048.214059-1-heinrich.schuchardt@canonical.com>
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
index b647b1cc103..ad577c475f5 100644
--- a/fs/fs.c
+++ b/fs/fs.c
@@ -39,6 +39,11 @@ static int fs_dev_part;
 static struct disk_partition fs_partition;
 static int fs_type = FS_TYPE_ANY;
 
+/*/
+ * define FS_CAP_DATE - readdir() populates fs_dirent::change_time
+ */
+#define FS_CAP_DATE	BIT(0)
+
 struct fstype_info {
 	int fstype;
 	char *name;
@@ -51,6 +56,10 @@ struct fstype_info {
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
@@ -99,10 +108,19 @@ static inline int fs_ls_unsupported(const char *dirname)
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
@@ -113,15 +131,26 @@ static int fs_ls_generic(const char *dirname)
 
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
@@ -197,6 +226,9 @@ static struct fstype_info fstypes[] = {
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
2.55.0


