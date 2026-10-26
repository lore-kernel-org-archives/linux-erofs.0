Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D9B960A2602
	for <linux-erofs@archiver.kernel.org>; Mon, 26 Oct 2026 09:22:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=sPryl71z
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4jCp7B3rnGz2xRm;
	Mon, 26 Oct 2026 20:22:30 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2607:f8b0:4864:20::433"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1793006550;
	cv=none; b=eBBP+tMS/ZpNNw+JmNKm94S3ZwwLv16ucPjwQb6P6geOYYdqmO/kLNTG7fD1yYESiRM1yWf1/ebE5MymqeCEcNhjjAHVHb8Rx3SoGf44r5VqVJX/5il0rOe33+vddjq+Z7a/aMju62wCdb+CkzKKG0bvLbYvya2ZegTP368TfL9VDFaPJFrh8Md5cP4sU1gM1l14vWkNVitoHqmRt9galmhhoE9fiOkRi5Riws/o1Y7sWLnNJe2xK+DIhwVnRN/SVch+Nf2KDslT//LLXJSmzkSQX67zvt34F9+lVWUd5bRF5cS3mZ1GjXyxp4ciF5hGOau5oub+rHCYCWAuO5h9tA==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1793006550; c=relaxed/relaxed;
	bh=KLAz+LSoKYpUFYpmLED3+ouddRavFyctHlwqyoedBik=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LCjSggcvswIfiseEZt9SEcegM3mHM/vOHunLClkz1SbDnpq7pyPoZxKtGVYPzwA80MAqL69MvDvK+o400z5QvYCjPBtyoALmMUltVM9BMjTSQlExipyZGoNsBwELrkGGXosu/F+ZrYIBB9Rl5zemq1KOy/ivpsl0RxXPYAa65pDaCnjXOw0Xkg91FQ8CDR0Q1duYyxi9m579LMcSIfidceNMkj6ggbrTZ5LLlOG08Zm4EY/UPo4lxhxW5TVV2Q14O4V9x6aeecStgqtK1uXGaSj5YHHKiUUA/mVfxqb/udtDdcU93mQ8uP00M5f/XeiiU2Tw8vzw4jq7/Fh0rfh7rQ==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=gmail.com; dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=sPryl71z; dkim-atps=neutral; spf=pass (client-ip=2607:f8b0:4864:20::433; helo=mail-pf1-x433.google.com; envelope-from=zhanxusheng1024@gmail.com; receiver=lists.ozlabs.org) smtp.mailfrom=gmail.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=sPryl71z;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=gmail.com (client-ip=2607:f8b0:4864:20::433; helo=mail-pf1-x433.google.com; envelope-from=zhanxusheng1024@gmail.com; receiver=lists.ozlabs.org)
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4jCp7908F1z2xN4
	for <linux-erofs@lists.ozlabs.org>; Mon, 26 Oct 2026 20:22:28 +1100 (AEDT)
Received: by mail-pf1-x433.google.com with SMTP id d2e1a72fcca58-8a05effaf8dso1801903b3a.2
        for <linux-erofs@lists.ozlabs.org>; Mon, 26 Oct 2026 02:22:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1793006546; x=1793611346; darn=lists.ozlabs.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=KLAz+LSoKYpUFYpmLED3+ouddRavFyctHlwqyoedBik=;
        b=sPryl71zlXpe19uFxl9AngUXuI6CQ0Tpeb+NLEi87t8sVF8G81gOGtnha5RJr1vx6I
         xCXvwAjDtad3DhbEz7sCrE4r/rb4vKqObgt1prV/BEXikS543YCf7XYG26EB3k9qImJF
         wXSr8RxACoy+SysQLghHWfQKWSK4ULJPOUE6M2Kg5B1JpI8AGLYM10Lrohjt28lY+rS9
         QQ+SA/KAEWHT3EeF1rrDZbwcxAniucseYy/0NQS1erKTLGDeGVDHRsJuGjkfW/ssUDPy
         OXLNT6mUzUlzLt2BFx7+si7f860M8/Bo15xyVsSkthI6ALSD/83ObW9garoq542Zd9bd
         CxfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793006546; x=1793611346;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=KLAz+LSoKYpUFYpmLED3+ouddRavFyctHlwqyoedBik=;
        b=L7FrKZ6IYoz5qBYCiEwv+VMzB2f7REVvGB6psGv6L4PtZGsMSQE2HgVfdVOOK/FfgC
         POmaKd5kDFJP6mtTmYdQnWke88j+/EAHd6pyA3CBhiwkTy0hGkcSnNqOA/AnbPWIaqkk
         5A0nIemOxXub6yz0GfOlFNmSBeHr0PxfhsNKRgAozALG9uANl4zzQC2J+jx9bd0tMjK6
         TzakVXIpi6v1dXxU0M9RRoPVNGBhD52HPs4FHCp0vHQXBNuSOmlzmmDbNQ+lpucxwMxL
         ylMjIqbsn/X78MzbgQ6+89VbByr0u3IYwEb6nhSZq4EWLb9O5ua9KXVttVsU6PdT7Tub
         u8rg==
X-Forwarded-Encrypted: i=1; AKwUvBwSUSgqPwlv2cP1gnH0v0G8KiqiPvOxMUvvOMJeC0rEmSkNOx2Bqijz7HB3axSaBa3J0EMfBdVm/FSvhQ==@lists.ozlabs.org
X-Gm-Message-State: AFq9FYIb54zKvYdjfVclb3veR8LXoB4G3Im1X/f+PgMlpkKpKegWRmjq
	FUeVrTdW13l68fTJHcBBaTOO5cyjyoK07c35dnX2B8RiDMC+VvJ0vBqs
X-Gm-Gg: AYBFou24WG/JNudKwbuMEu+eJJkU33fF9cEmRJQ+FdvL30E7/0Je8zx/msKTrFquZZK
	6WXZXrCOCfkB3Ph8IFGzVNQFO70xJsYxtJZUyGZyF4fdjoG1dC2nJ1EWltJc0CVag5muWl//DBu
	PHHCh5yhykwSjBeJdQayuq6y604BbA+0X6B+ohlm0hW/FU7e9xKVmtfF1TVy8LyOBv4uvxJfvmV
	o4Irc8ipSHnpw00s0AphcHAIs0fFy/xqUzhFrkjMi6tIyqq+cxZxNejeROV+eGieRMiaCu+XvQ6
	oghaCfuPYnxi2o3p2M7Mv+8geRBuWJVlLErmTRLOvz3p8dXQcZdYIxvyhILPyWRHNqA1Ra0rIeA
	n2zOEl/VB+6WD/x4bT8XClb/D5X8l6XZxcFGwx0/imHK4u4nYX95ckkJEJRbs2uV09qBaZcTsIx
	Y/9DIRSWrJ/A4BTKaBD681Zxpdlsruu17e5Utu9r1PtUrA2oFC44z2xX7sFL8BpALlYn5Z1JhRd
	25zuhJ3JeFTrGs4pThzHAV8GCwTzNFvkyK+ldx7W4hDiX8+Ozv6ynio7a5nqOLPhxT6B+EvHw==
X-Received: by 2002:a05:6a00:98d:b0:89f:fdb7:a9df with SMTP id d2e1a72fcca58-8a364b4c9b1mr4646584b3a.5.1793006545834;
        Mon, 26 Oct 2026 02:22:25 -0700 (PDT)
Received: from osman.mioffice.cn ([43.224.245.178])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8a36b37145fsm1055887b3a.22.2026.10.26.02.22.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Oct 2026 02:22:24 -0700 (PDT)
From: Zhan Xusheng <zhanxusheng1024@gmail.com>
To: xiang@kernel.org
Cc: chao@kernel.org,
	zbestahu@gmail.com,
	jefflexu@163.com,
	dhavale@google.com,
	hongbohbli@tencent.com,
	guochunhai@vivo.com,
	giuseppe@scrivano.org,
	linux-erofs@lists.ozlabs.org,
	linux-kernel@vger.kernel.org,
	zhanxusheng@xiaomi.com
Subject: [PATCH v2] erofs: don't reuse a superblock for a mount that passes device=
Date: Mon, 26 Oct 2026 17:22:17 +0800
Message-ID: <20261026092217.2129604-1-zhanxusheng1024@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <at8UCyjlHgxxBAaf@MacBookPro>
References: <at8UCyjlHgxxBAaf@MacBookPro>
X-Mailing-List: linux-erofs@lists.ozlabs.org
List-Id: <linux-erofs.lists.ozlabs.org>
List-Help: <mailto:linux-erofs+help@lists.ozlabs.org>
List-Owner: <mailto:linux-erofs+owner@lists.ozlabs.org>
List-Post: <mailto:linux-erofs@lists.ozlabs.org>
List-Subscribe: <mailto:linux-erofs+subscribe@lists.ozlabs.org>,
  <mailto:linux-erofs+subscribe-digest@lists.ozlabs.org>,
  <mailto:linux-erofs+subscribe-nomail@lists.ozlabs.org>
Precedence: list
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Zhan Xusheng <zhanxusheng@xiaomi.com>

superblock_share together with device= is rejected in
erofs_fc_fill_super():

	if (test_opt(&sbi->opt, SUPERBLOCK_SHARE) &&
	    sbi->devs->extra_devices)
		return -EINVAL;

but extra_devices is kept in sbi->devs, not in sbi->opt, and
erofs_sb_share_test_super() compares only the backing inode, the
fsoffset and sbi->opt.  So once the image is mounted with
superblock_share, a second mount with superblock_share,device= matches
that superblock and get_tree_super() reuses it without calling
fill_super() at all.

The same command line therefore either fails with -EINVAL or succeeds
with device= quietly dropped, depending on whether a compatible mount
already exists.

Refuse to match a context that brought device= options, so that it gets
a superblock of its own and fill_super() decides as it does today.

Only the incoming context can be tested: a shared superblock may have
extra_devices set itself, because erofs_scan_devices() fills the device
table from the image when no device= was given.

Fixes: cd4108319bb3 ("erofs: reuse superblock for file-backed mounts")
Signed-off-by: Zhan Xusheng <zhanxusheng@xiaomi.com>
---
v2: fold the check into the return statement and drop the comment
    (Gao Xiang)
v1: https://lore.kernel.org/all/20261021083826.1870937-1-zhanxusheng1024@gmail.com/

 fs/erofs/super.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/erofs/super.c b/fs/erofs/super.c
index 16fa3b853f1b..8ca44b1c0bd1 100644
--- a/fs/erofs/super.c
+++ b/fs/erofs/super.c
@@ -827,7 +827,8 @@ static int erofs_sb_share_test_super(struct super_block *sb,
 		return 0;
 	return file_inode(sbi->dif0.file) == file_inode(new_sbi->dif0.file) &&
 	       sbi->dif0.fsoff == new_sbi->dif0.fsoff &&
-	       !memcmp(&sbi->opt, &new_sbi->opt, sizeof(sbi->opt));
+	       !memcmp(&sbi->opt, &new_sbi->opt, sizeof(sbi->opt)) &&
+	       !new_sbi->devs->extra_devices;
 }
 
 static int erofs_file_get_tree(struct fs_context *fc)

base-commit: 52dceb88082b4c7983d1c8c7de1c181f018055ac
-- 
2.43.0


