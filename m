Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F134606A31D
	for <linux-erofs@archiver.kernel.org>; Wed, 21 Oct 2026 08:38:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=AR4DxzYp
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4j8jNs1TqDz2xLt;
	Wed, 21 Oct 2026 19:38:37 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2607:f8b0:4864:20::132a"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1792571917;
	cv=none; b=SicS88oj1wVBK6+bLBwSo3iYs1E+5MeSyXjJC6YJ6oGqvAAq/9oVGRTsnNB1u5TWJL9Ic2ms12nBoQpULf2+KaQEA5aKZMzzWbrnD4332kW+fzUUQzAUjpk6lLlTee/nDUOYu0ENSLFJf5+notrOWadfZ4DgPCcKKYUe2/RjtMbyTmIb8VAbNZy8d88hbpEZ9Tae4/qzdgcuZB0wFTeLPwCrfmQpYsRYKRmR5I4jM5OfFGGMy79SmSvjK4u4JN+3PhjsO3PhjR7XploBunPPykrpWhG9hbF4p35DRASob4Rl73eKGaAlWsL3bKkGxC+qP3/xA9k+jT06ROTLOXZ+0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1792571917; c=relaxed/relaxed;
	bh=ezaUw4HbM92qbq50KCeRpsCuDK1ahVr0MqnfbwD+p5c=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=JE4FuO8pwqPjs+TZegZXjl1a5pJZQ/7vMjUPuDBmEJVeW0pGpgqNbzSdalzuuNW9c2xSPjKX6Fo+tArTxhh2aeowM31Icike23SgcIBd/h6jnafgiK1Ryk63/7I3v6b1i0PDAINe2n0ShXKWOo0dHuxth90ghZOmkDRJc6JenQx65FZ9y9zP5UjLLaRkIoPebRZ/iTH7dcsp9U/x9M6SLl8Y3h7JzjTyw3GFueSgwpUkyvqvTp+eWH2W40cwueyHNWe6W3bY5l/wRvGAS/O4NRCwCQ5+y/FCxlXdz1QOHEn1mVndjPJbdoaefhWa27SRwnb2AIfQl/DDu2cbrCtkCA==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=gmail.com; dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=AR4DxzYp; dkim-atps=neutral; spf=pass (client-ip=2607:f8b0:4864:20::132a; helo=mail-dy1-x132a.google.com; envelope-from=zhanxusheng1024@gmail.com; receiver=lists.ozlabs.org) smtp.mailfrom=gmail.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=AR4DxzYp;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=gmail.com (client-ip=2607:f8b0:4864:20::132a; helo=mail-dy1-x132a.google.com; envelope-from=zhanxusheng1024@gmail.com; receiver=lists.ozlabs.org)
Received: from mail-dy1-x132a.google.com (mail-dy1-x132a.google.com [IPv6:2607:f8b0:4864:20::132a])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4j8jNr1lsJz2xKx
	for <linux-erofs@lists.ozlabs.org>; Wed, 21 Oct 2026 19:38:36 +1100 (AEDT)
Received: by mail-dy1-x132a.google.com with SMTP id 5a478bee46e88-36681e85e87so914432eec.1
        for <linux-erofs@lists.ozlabs.org>; Wed, 21 Oct 2026 01:38:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792571913; x=1793176713; darn=lists.ozlabs.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=ezaUw4HbM92qbq50KCeRpsCuDK1ahVr0MqnfbwD+p5c=;
        b=AR4DxzYpLcvYObddBX5TG8M1hX6G1dZayQrP0+iff7OsSJZrTTphUkcsXEyRfkWS3m
         AhTI0X8j1c/Zyjad1P17V+mIk588yra6mcmoq5OquAqeE+sX9Ue2rPkIEjNusqAP4hno
         nQ93F1Wyjyy7Ufcw4X8AmRVIOChuW7c98QxaMpF9p84OijauEYLLg9Kc5sjp+oAGGOJh
         hvXqR/2LgQBvAruYuNUqd0H9KGBNxsrZ6nuUfDJ/h2kTXqOLBls18YCX94jEwwiKkGwp
         anmRbwlihnp0Fs0qxMAAhpqiCa6QukFJR84zGqVjG1hpUiXDRq7WI9s+o9wwqQDp+2aE
         AhBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792571913; x=1793176713;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ezaUw4HbM92qbq50KCeRpsCuDK1ahVr0MqnfbwD+p5c=;
        b=tS9+ZK35IvvuRZ+7yl2R8B/fHciJz3q2EiMsQbS9JKpIKCJAfI3jQE2WPXpJ2RzHk5
         GmHWrCdD2KqDU/deHdE+YaQ8qyC7LEtNu+56AWmPGLkLEswOhG506HD6SbJuaFVg7qVK
         5Takr+a4q92kL9FNHogm6jRSXbmxbogKPbwf6a6IFst/BWMAz3+5K8Lvq+n3zJg47Lhi
         +O/Njl5GuILoNeYYQkr/UtY+nf7q1iKnhAMsLfRZ5/klQGF7e+rXzcvxMyXvCBq/D9/J
         muOvky7E1wEhFx0fqpSIAE6kXI17w6GBvbFkty6sPtFJiVrWMiXtz399LJ/Q4jfr0nA3
         4wrg==
X-Forwarded-Encrypted: i=1; AKwUvBxkXu+g0doJrbDDRNBJEE4FeZfQNgtj65MQiA1wB7UTjMKdgJnYF88MDNeoEbRkN7ew7U2D9fOH772aGA==@lists.ozlabs.org
X-Gm-Message-State: AFq9FYLvUIN+cvndhwydLfCzgVkmwKcfM6g43313l96veyRB6dnPu48p
	0gOdSdOqDoxr6hpFUDmfp0vqGzF4jFInsxpKx1P0SEtLFYA+dp/XKj8I
X-Gm-Gg: AYBFou3bv88d+xs3hZGfzZhzBWhImrhSGMcWQVLZhv1mkiwVi8DNePabKIY3qq9E1S3
	+bDH4OfHGoHTYg810zZBBgx6+yj9WfbJri18R/T7jZLc7Ve5/2bBuDdMps2vpRwBhQdpzBATlF3
	8IsVT5zsE6ByQsqK3z6woAL3UrzfA645kezrxeMxBd4+wHDI0BZ74OAfA+j7TV15+W0462AuAeT
	zuBB635lw2fMXjBU8ZbAUv4VYRjpGxHUNBr9qSQTZvFF2U3sHcebm6fOqDOk6t0TKCwFCMcAo1w
	Nue4qVZ7KJgS5/+0rreRCs71kD3jKZx8x1yrOaQJdoelkkHpxnDmiE+zTNvzQa2QxC9QC7rx1m4
	psbCpcoAzguA5Q1BhbnCH2qZJwD9faYUHhpMY58JlaFqBhrFt00xwGR9K6IlSMc05pZImzrzMFJ
	W+WTuYQ/oQip0Pt1gRpvwg07PPx+X83qPfCiiQNtW5DqQZbJKWW4sRJtnKUBJToVBQIMktCp3rk
	T4fuIQmhcEhxz7liuevyHep5GBxOPuW2nATwpJ8tKQtviwjR1NywM4kw0eFx9drJwtePw7bAg==
X-Received: by 2002:a05:693c:864c:20b0:351:1f56:3a89 with SMTP id 5a478bee46e88-3674e548e2amr2574946eec.23.1792571912854;
        Wed, 21 Oct 2026 01:38:32 -0700 (PDT)
Received: from osman.mioffice.cn ([43.224.245.178])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-367411b4145sm6102203eec.15.2026.10.21.01.38.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Oct 2026 01:38:32 -0700 (PDT)
From: Zhan Xusheng <zhanxusheng1024@gmail.com>
To: Gao Xiang <xiang@kernel.org>,
	Chao Yu <chao@kernel.org>
Cc: Giuseppe Scrivano <giuseppe@scrivano.org>,
	Yue Hu <zbestahu@gmail.com>,
	Jeffle Xu <jefflexu@linux.alibaba.com>,
	Sandeep Dhavale <dhavale@google.com>,
	linux-erofs@lists.ozlabs.org,
	linux-kernel@vger.kernel.org,
	Zhan Xusheng <zhanxusheng@xiaomi.com>
Subject: [PATCH] erofs: don't reuse a superblock for a mount that passes device=
Date: Wed, 21 Oct 2026 16:38:26 +0800
Message-ID: <20261021083826.1870937-1-zhanxusheng1024@gmail.com>
X-Mailer: git-send-email 2.43.0
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
 fs/erofs/super.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/erofs/super.c b/fs/erofs/super.c
index 16fa3b853f1b6..bc9ab5a6234a0 100644
--- a/fs/erofs/super.c
+++ b/fs/erofs/super.c
@@ -825,6 +825,13 @@ static int erofs_sb_share_test_super(struct super_block *sb,
 		return 0;
 	if (!sbi->dif0.file || !new_sbi->dif0.file)
 		return 0;
+	/*
+	 * extra_devices is not part of sbi->opt, so the memcmp below cannot
+	 * see device= options.  @sb may have extra_devices set from the
+	 * on-disk device table, so only the incoming context is tested.
+	 */
+	if (new_sbi->devs->extra_devices)
+		return 0;
 	return file_inode(sbi->dif0.file) == file_inode(new_sbi->dif0.file) &&
 	       sbi->dif0.fsoff == new_sbi->dif0.fsoff &&
 	       !memcmp(&sbi->opt, &new_sbi->opt, sizeof(sbi->opt));

base-commit: 1137aa577a35e2684e8046c3e53f920e79c7cc60
-- 
2.43.0


