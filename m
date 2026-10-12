Return-Path: <linux-erofs+bounces-4697-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 33671CA9EDC
	for <linux-erofs@archiver.kernel.org>; Mon, 12 Oct 2026 14:01:16 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4j3JzG1tYXz30Vv;
	Tue, 13 Oct 2026 01:01:14 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=185.125.188.123
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1791813674;
	cv=none; b=eIL+5NpiRdFpIz5rZYDGRZ0iQZRA7UOSZvySck2weNL5lvjvmzdXKez/RK/LvLedyehdEB0c9aCrMOWuaNuMWOXtxJoFhc7lDKZyZOGmzPkkl3eLhKKmirSRJuCWW0kDAA8O5MvDgvso77K27S95aYdFCdWtQZ8dOf6xwW75OhgbhYBvq34aJ6prPWYeg7qe/uk6uyepSs+XjFGFds9Iy6+xQnp9oo0+8I8iEoKyH3IhUseKgTCGOhpYSkBsomXMdkVTQ/GF7geSbHkbivddwsTHncLCI3+/U2ZTwxgSPJFGnUVHGjAOoqPR42j2AI6qjN8sQ3TLVlqzNrweQjclAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1791813674; c=relaxed/relaxed;
	bh=kuOaJLmxnY7yoVsV4vEGIpHLhEj34y0iyvEaELuk1CE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MBDbVXVN+gwQ2SCNjTpUBvIVCqHK2/QKeSBsqLPHxiCYczV5igRd7L0k/p08CGqLU/6Dr+WhtKVzxGDNQ1BT9IrI7x+ocajYCTKOmkrKs0UUCAXbEK4o1P83loShn+p2whADechxZ6w9M40fTWdI9eSKVDla1rsXjcRu3PyvNSiplO0lgESrzPtfKAZztC2e/VA1+BUP8UnNLSjCcgR2Tn9CVI/7SYvSVZt2Bk5I2oeXTvc5dRTBgcfrLkE2gq4UWY6dRA0C8LJbrQCZCxt+9g0kbiBxtsALWfusoCHPADfsZtgl723LTVSmCBHN1KKw8dnf9233zJ+oanwSUPHJ1w==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=reject dis=none) header.from=canonical.com; dkim=pass (4096-bit key; unprotected) header.d=canonical.com header.i=@canonical.com header.a=rsa-sha256 header.s=20251003 header.b=jJInrhOM; dkim-atps=neutral; spf=pass (client-ip=185.125.188.123; helo=smtp-relay-internal-1.canonical.com; envelope-from=heinrich.schuchardt@canonical.com; receiver=lists.ozlabs.org) smtp.mailfrom=canonical.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=reject dis=none) header.from=canonical.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (4096-bit key; unprotected) header.d=canonical.com header.i=@canonical.com header.a=rsa-sha256 header.s=20251003 header.b=jJInrhOM;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=canonical.com (client-ip=185.125.188.123; helo=smtp-relay-internal-1.canonical.com; envelope-from=heinrich.schuchardt@canonical.com; receiver=lists.ozlabs.org)
Received: from smtp-relay-internal-1.canonical.com (smtp-relay-internal-1.canonical.com [185.125.188.123])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4j3JzF3lDHz30VV
	for <linux-erofs@lists.ozlabs.org>; Tue, 13 Oct 2026 01:01:13 +1100 (AEDT)
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com [209.85.128.71])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id 70DA43F13F
	for <linux-erofs@lists.ozlabs.org>; Mon, 12 Oct 2026 14:01:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
	s=20251003; t=1791813669;
	bh=kuOaJLmxnY7yoVsV4vEGIpHLhEj34y0iyvEaELuk1CE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version;
	b=jJInrhOMBhoPqZJomyjM5Z4s2YI5fIQrWi64tQM5e36ZSxkKV1y2wd3wqyr523/mq
	 ZstC4d70ouK8lXPBVjknP7vpkrjPLRXUj67u7p1zSZITUr5n76r5c2SAMc2Rc8yUYI
	 hBiCwnbWNOx3Oph/gEE1atv0w0SY5KWUS2J1jmsbrcP04z1NVbyyNS82O4KpnUw0C/
	 jFxQ+lHpEgt1wmBqnw6tHgjtYhNnuHM4qIdZy0EOD19aYPIb/FZc/Irb5K03HtdmJM
	 pD12/F93WXX8NzbxNB+VsCgRa2atvz2wAKH98RJzOrRU018sT3Zzdmqi1+xsXIf4Zj
	 lkUpW0kFrPjdSbX2rZ1k2As/Z8UTAKugezDkQaZu31veOQv/O9G/C3AyMNigNleG2C
	 WA5PFmC5WeB439GdVRFaiYzulIvIghVSgFdWx8M0sMWYxZ9b+mfwdcCuVHfE7eHUcI
	 7caQQv4cvkkBPmKUlMt5vEnibxE+CEylC0DZK9GqJsD8bsb+GFAsmemw5W7bc8GCxB
	 Ynt/B1fXXgAZA9zlv5ovqQQBexLpxKBAUv588ZNtY0zIc23oi6PsP/Z5g8Wuis+wGH
	 6CeTlmbw2pUZmR+6Jt8tOUSKW0R96ZhDEAvswbEnuaneUak2970YzV6n9/wuSPcfUQ
	 J0qv7VSKrTCUzu47hm6J4sL0=
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-4a17c024b89so18539115e9.1
        for <linux-erofs@lists.ozlabs.org>; Mon, 12 Oct 2026 07:01:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791813669; x=1792418469;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=kuOaJLmxnY7yoVsV4vEGIpHLhEj34y0iyvEaELuk1CE=;
        b=hmUxctIxtIvLj0MfnkcV2mETpuL5WOP7oRiPMOB1VU06hl0wCKx8+sOhPBEZPmMRkl
         z+Dcnh4MN8ilwP77H4EbZXYMThnyTQjqorTD2GlSsT7M/We4DkqC4NSx2lbPXhEnXHz5
         iN6JGvn+iojTK4DFHPMTBeUW6uUY84jtGQIGYBDxLMbFOZ5evvQlfMfTeR2oTdnOeLCo
         bANhSrPH/ry0w/y47a3+j02rjcCHBfRQtPRpszO2uFkm8/TCjqTVqiiSrGLLptoYGOwA
         FCrHCSyS0hKPCObPyMPbqeVH7ka2rLIIt5hGkZFq+TLI6X9VsOC4sXiEuH4EMQRTxni7
         VWjA==
X-Forwarded-Encrypted: i=1; AKwUvByCk3WcHmPm4QIJjm7nCDVBGZZxCTwJVHMfBBVSiDYpcLhUJ2Hs3KhabPS+v/rBQ6MfV9cXI/NOpnS1+A==@lists.ozlabs.org
X-Gm-Message-State: AFq9FYLzrlRZ5epFG1u4aCFAJlHTVae/HEQBraTBBgNry5J70Wy1XSuf
	L4TQumlC9/6AREH7cG4rWKIeo2dRMgBxwmg7pS/D6W4/Yl1GZxNpQCuOrVF8f2NjXIKreqkDk5I
	E9N9gl9XF33Q/0alH+2wIrbySM5iGwvH8SwIulmWT1OqDDp8fN1N+vGEKOL/xdqYMDFXuX0scAz
	Y2+GDbgq4bOuR1cQ==
X-Gm-Gg: AYBFou2Mk8oO6WLy4jrwROxKLSPNu0/QkKyyjS2qJ1dLf+RrA7fmwVazvwG9H7zq32m
	6s9ztihMIlHUpCowow7zxfwZb1T3CRFt+eZBsvRwa69swE9Vz/lNdp4UnyDhqntMUJDoGM01q4U
	xTROm1M45iryh/quqTxT9UORdIwNPpaTFhUM+J4k+v8sscDstlg/Lj0PZOKmStwj2fbuig4O5an
	9FVaAbCKRktjNFNCWSkJdKvQLW11y8UenJh7DiOiixsNwMSjecDH99HhOZDJKmCOOGvmiq+fdVm
	E0cbrfpNXyzJUyIKSQH2A7UBMkdbvWsOMIkq4KrnrjFUHzr+2oxBYDjYrisY4H7sT0ZaSOlAtS3
	MO7Bn+EXpioYhfHdIdz8s6bs0RdvT61jiiNPBR/zx4pgt2d96vPsqtJA=
X-Received: by 2002:a05:600d:6413:10b0:4a1:88d7:4e6a with SMTP id 5b1f17b1804b1-4a19470eccamr88701545e9.27.1791813668878;
        Mon, 12 Oct 2026 07:01:08 -0700 (PDT)
X-Received: by 2002:a05:600d:6413:10b0:4a1:88d7:4e6a with SMTP id 5b1f17b1804b1-4a19470eccamr88700855e9.27.1791813668274;
        Mon, 12 Oct 2026 07:01:08 -0700 (PDT)
Received: from workstation5 ([2a02:908:1242:30e0:468d:767c:32e6:22fa])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a18bf15691sm284551015e9.6.2026.10.12.07.01.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Oct 2026 07:01:07 -0700 (PDT)
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
Subject: [PATCH 1/9] fs: move struct fstype_info definition to top of file
Date: Mon, 12 Oct 2026 16:00:40 +0200
Message-ID: <20261012140048.214059-2-heinrich.schuchardt@canonical.com>
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

Structure definitions should precede code using them.

Signed-off-by: Heinrich Schuchardt <heinrich.schuchardt@canonical.com>
---
 fs/fs.c | 86 ++++++++++++++++++++++++++++-----------------------------
 1 file changed, 43 insertions(+), 43 deletions(-)

diff --git a/fs/fs.c b/fs/fs.c
index b18ccec8cb4..b647b1cc103 100644
--- a/fs/fs.c
+++ b/fs/fs.c
@@ -39,6 +39,49 @@ static int fs_dev_part;
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
@@ -148,49 +191,6 @@ static inline int fs_rename_unsupported(const char *old_path,
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
2.55.0


