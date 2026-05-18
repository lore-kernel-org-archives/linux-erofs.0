Return-Path: <linux-erofs+bounces-3410-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3234CCD4F50
	for <linux-erofs@archiver.kernel.org>; Mon, 18 May 2026 05:58:01 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4gJnCW3jf5z3dRW;
	Mon, 18 May 2026 15:57:59 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=185.125.188.120
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1779083879;
	cv=none; b=kIh8NnPqW1ZPItCD0qKgNYQHh0K8Je4a4VekN/JBO3E9Ae0Catjrskn+Eh6urE/0Bp2qEXXAA3kCTAryFRqyjN2V7I5TgXpyF9KHoCrgKq0jLxJsKmeUTmHFFyI7Yjfc9rpr5PurxEW1jHNBizaaKMH8urqokTfDD2qSr/Cx/hK0kjYRCA9571uBBfdCdIz6BTASPlfK9J5izV3YtijStXomDD7dO5ox+Wfqc/GjcqdEEVCcxXgz7oDqsXu7YK0yrKldgmQrKB6YmTlKxVeYQXPsQTDvywoOkp0vEaCSjHt1T9U5cFhGzEkzdCjkuyNbivT/n2UAxdeyoh4SgnrGUA==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1779083879; c=relaxed/relaxed;
	bh=ZHFBD2/sqEw9xpJcKE8cdnHV7auLGJSwUvjfJFOe0Tc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Yr98mgZzQ06L4ScnUJE0X0EAi9JZWrSxb649vqk4TyEmcgEbCbHVBo/d7OZ90eWuE3Fz8BPBV9RxBQie04a0VRcXRE300XuZLnKtTmZHNJCMFyS0WTofn/oey5Xf4kO09aLy5Vhpf2EwGUJRBS5ob7L/O7AhAPBSBoKx0+SJVN8MJofYIWK55Dbl+3vg4nIvpS8yZsI58zsRH/cZU0FGoWCKMCiSHSAkHpxxhp8iXbsIehjfFk4w1lXG+l/gXWOpMRjtJPgYMO+b+Mdx85i4Aiin1y/14c3xQxk4DHKFQojwXLyEiYm1ccteUNzt5U6hFJUy/IMqE/rULcx8/phS9g==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=reject dis=none) header.from=canonical.com; dkim=pass (4096-bit key; unprotected) header.d=canonical.com header.i=@canonical.com header.a=rsa-sha256 header.s=20251003 header.b=r8cJO79y; dkim-atps=neutral; spf=pass (client-ip=185.125.188.120; helo=smtp-relay-canonical-0.canonical.com; envelope-from=heinrich.schuchardt@canonical.com; receiver=lists.ozlabs.org) smtp.mailfrom=canonical.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=reject dis=none) header.from=canonical.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (4096-bit key; unprotected) header.d=canonical.com header.i=@canonical.com header.a=rsa-sha256 header.s=20251003 header.b=r8cJO79y;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=canonical.com (client-ip=185.125.188.120; helo=smtp-relay-canonical-0.canonical.com; envelope-from=heinrich.schuchardt@canonical.com; receiver=lists.ozlabs.org)
Received: from smtp-relay-canonical-0.canonical.com (smtp-relay-canonical-0.canonical.com [185.125.188.120])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4gJnCS4VvSz3dRJ
	for <linux-erofs@lists.ozlabs.org>; Mon, 18 May 2026 15:57:54 +1000 (AEST)
Received: from LT03 (dynamic-046-114-109-175.46.114.pool.telefonica.de [46.114.109.175])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-canonical-0.canonical.com (Postfix) with ESMTPSA id C50264169F;
	Mon, 18 May 2026 05:57:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
	s=20251003; t=1779083871;
	bh=ZHFBD2/sqEw9xpJcKE8cdnHV7auLGJSwUvjfJFOe0Tc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version;
	b=r8cJO79yDUUyy692JX9u891ulpEWKw/UNz0m8iuemGgP2ib1N9/vo1nFj1IYlPbJC
	 RSys4bRXoS/LxHA1iN/rlEM+v9m4AeBX4OZzyGZ/maPzERx/mP49H2HfnKQWh7zz+a
	 dR+5Azu9Z/vOosVswT7d9SCtdV0z0pvJXPE6qLh5zDklFjh1lL6CJZ6+b1Ri8Vhxf4
	 o4MywqllpqNg6YU/GC9z1fvDkrgYBlvd7ErxBEdRfR2beBSNEOP0v6zEoMhq8CjU64
	 ai4Gzt9H4JezgWcDw3aXzTP8USfciC1h2XQjLangQ/e8dy5gPLLaZa9z2GgRQO5IPd
	 cOm9+8Q5o4X7PqcxtHEV6bnGjyF2Fik+OAh6kM0aUPGbM1DU1GXCUBUbYSL9yhSgll
	 slFNDWYadLu0zH/PjfXQMJY2vhR4+3CBNNQU8rvCGZw++eOTNFDi+/ajw50gQioYk5
	 bJUT+kU4MwJCFvJmKaXPKF290jtFH8Ri2I1EARmazuFkFwWh0pWJm3U0LnYuuNVApT
	 q4biid57V/yU6DSO+yNvHvJcXmu65U1CZwwvgXJTYdlsPdjVKR5BzOvvo8TkMI006o
	 xznUfhCqPYF2TzBN8CmLJ+GPRrFROGPasn1fdCMMIKeYB92PkFEavfAoKvzG4Hmnht
	 6XQuNSP+lKe0+3wIacMij8wg=
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
Subject: [PATCH 1/9] fs: move struct fstype_info definition to top of file
Date: Mon, 18 May 2026 07:57:20 +0200
Message-ID: <20260518055728.178507-2-heinrich.schuchardt@canonical.com>
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

Structure definitions should precede code using them.

Signed-off-by: Heinrich Schuchardt <heinrich.schuchardt@canonical.com>
---
 fs/fs.c | 86 ++++++++++++++++++++++++++++-----------------------------
 1 file changed, 43 insertions(+), 43 deletions(-)

diff --git a/fs/fs.c b/fs/fs.c
index 8ea50a6c13c..fe62b71c83c 100644
--- a/fs/fs.c
+++ b/fs/fs.c
@@ -38,6 +38,49 @@ static int fs_dev_part;
 static struct disk_partition fs_partition;
 static int fs_type = FS_TYPE_ANY;
 
+struct fstype_info {
+	int fstype;
+	char *name;
+	/*
+	 * Is it legal to pass NULL as .probe()'s  fs_dev_desc parameter? This
+	 * should be false in most cases. For "virtual" filesystems which
+	 * aren't based on a U-Boot block device (e.g. sandbox), this can be
+	 * set to true. This should also be true for the dummy entry at the end
+	 * of fstypes[], since that is essentially a "virtual" (non-existent)
+	 * filesystem.
+	 */
+	bool null_dev_desc_ok;
+	int (*probe)(struct blk_desc *fs_dev_desc,
+		     struct disk_partition *fs_partition);
+	int (*ls)(const char *dirname);
+	int (*exists)(const char *filename);
+	int (*size)(const char *filename, loff_t *size);
+	int (*read)(const char *filename, void *buf, loff_t offset,
+		    loff_t len, loff_t *actread);
+	int (*write)(const char *filename, void *buf, loff_t offset,
+		     loff_t len, loff_t *actwrite);
+	void (*close)(void);
+	int (*uuid)(char *uuid_str);
+	/*
+	 * Open a directory stream.  On success return 0 and directory
+	 * stream pointer via 'dirsp'.  On error, return -errno.  See
+	 * fs_opendir().
+	 */
+	int (*opendir)(const char *filename, struct fs_dir_stream **dirsp);
+	/*
+	 * Read next entry from directory stream.  On success return 0
+	 * and directory entry pointer via 'dentp'.  On error return
+	 * -errno.  See fs_readdir().
+	 */
+	int (*readdir)(struct fs_dir_stream *dirs, struct fs_dirent **dentp);
+	/* see fs_closedir() */
+	void (*closedir)(struct fs_dir_stream *dirs);
+	int (*unlink)(const char *filename);
+	int (*mkdir)(const char *dirname);
+	int (*ln)(const char *filename, const char *target);
+	int (*rename)(const char *old_path, const char *new_path);
+};
+
 void fs_set_type(int type)
 {
 	fs_type = type;
@@ -147,49 +190,6 @@ static inline int fs_rename_unsupported(const char *old_path,
 	return -1;
 }
 
-struct fstype_info {
-	int fstype;
-	char *name;
-	/*
-	 * Is it legal to pass NULL as .probe()'s  fs_dev_desc parameter? This
-	 * should be false in most cases. For "virtual" filesystems which
-	 * aren't based on a U-Boot block device (e.g. sandbox), this can be
-	 * set to true. This should also be true for the dummy entry at the end
-	 * of fstypes[], since that is essentially a "virtual" (non-existent)
-	 * filesystem.
-	 */
-	bool null_dev_desc_ok;
-	int (*probe)(struct blk_desc *fs_dev_desc,
-		     struct disk_partition *fs_partition);
-	int (*ls)(const char *dirname);
-	int (*exists)(const char *filename);
-	int (*size)(const char *filename, loff_t *size);
-	int (*read)(const char *filename, void *buf, loff_t offset,
-		    loff_t len, loff_t *actread);
-	int (*write)(const char *filename, void *buf, loff_t offset,
-		     loff_t len, loff_t *actwrite);
-	void (*close)(void);
-	int (*uuid)(char *uuid_str);
-	/*
-	 * Open a directory stream.  On success return 0 and directory
-	 * stream pointer via 'dirsp'.  On error, return -errno.  See
-	 * fs_opendir().
-	 */
-	int (*opendir)(const char *filename, struct fs_dir_stream **dirsp);
-	/*
-	 * Read next entry from directory stream.  On success return 0
-	 * and directory entry pointer via 'dentp'.  On error return
-	 * -errno.  See fs_readdir().
-	 */
-	int (*readdir)(struct fs_dir_stream *dirs, struct fs_dirent **dentp);
-	/* see fs_closedir() */
-	void (*closedir)(struct fs_dir_stream *dirs);
-	int (*unlink)(const char *filename);
-	int (*mkdir)(const char *dirname);
-	int (*ln)(const char *filename, const char *target);
-	int (*rename)(const char *old_path, const char *new_path);
-};
-
 static struct fstype_info fstypes[] = {
 #if CONFIG_IS_ENABLED(FS_FAT)
 	{
-- 
2.53.0


