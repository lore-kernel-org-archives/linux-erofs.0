Return-Path: <linux-erofs+bounces-4015-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CEC93C5321C
	for <linux-erofs@archiver.kernel.org>; Mon, 27 Jul 2026 10:48:59 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4h7wLv5W0Dz2yj1;
	Mon, 27 Jul 2026 20:48:55 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2a00:1450:4864:20::42a"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1785149335;
	cv=none; b=RoTj4EpgFLpz8Jnc3vZRDqq5SyGiCsQtkCAH3/2tAXp5xtlVtBuY+OOQn7kMpIcdNWAEVCvD3IISC1do2iTkkjbjIGubn1SKApIhAxmJPPjR1a/lLNSyx8J0Ir+kKPksU5ZfBchFQu0GCIVxDVwi3W6uI4hPy+4fgogv2K3kHSFj4s71FmV3bvlyM3ZQCMl6K45r6sVyDwGG4oFSjcqIsRhiD5oEt1CQiN39GO6W7HXsDwsKfDlPKc5MZPDjmYDlVi7jVf6B/aM4gvm7Oyo7EnGkaC26ysB5n6E/3LLyhObLcWLqnSgwy1YXvmoa4vMyhkxdUkbgo7Q9m0v2Usy02w==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1785149335; c=relaxed/relaxed;
	bh=neqsEsWHuKT6LwcChvXBKjF2Wl4AED5GjZjnD9EI9lc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SA9Xd6IkUwAAIUi5xdcg+NHHmPmg58EKbr+ou6l7M61v0egfLHghYQ4KxNbg55RvmlqXrJeukY+Ceb2vj15zLaicSUnWzj2XIhUvCg91SoPh09PXj9BDK27JfGrfYtxm9HxbPDnVgeGWoFli+E/FRlOJcQBhk29wKOq+RXlxDNpSr6q7bw/s3FQmiVk3nE19b1qxepKnfotleh+7EjBd7OFypFBHelry8EaA22AwowMFmTnkJgxfHISiP2VOFAjiQj9XFCvIDpaVQSvQj5SkgG8qetgaIMcsq/1kRKVBX00T4AIM0JOFiJ773RqGwaxvsNrvN7ghGxUXPJpm3Tw7yg==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=gmail.com; dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=N8SAYiib; dkim-atps=neutral; spf=pass (client-ip=2a00:1450:4864:20::42a; helo=mail-wr1-x42a.google.com; envelope-from=ericcurtin17@gmail.com; receiver=lists.ozlabs.org) smtp.mailfrom=gmail.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=N8SAYiib;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=gmail.com (client-ip=2a00:1450:4864:20::42a; helo=mail-wr1-x42a.google.com; envelope-from=ericcurtin17@gmail.com; receiver=lists.ozlabs.org)
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4h7wLt59CKz2yjp
	for <linux-erofs@lists.ozlabs.org>; Mon, 27 Jul 2026 20:48:54 +1000 (AEST)
Received: by mail-wr1-x42a.google.com with SMTP id ffacd0b85a97d-47f97d310caso1757770f8f.2
        for <linux-erofs@lists.ozlabs.org>; Mon, 27 Jul 2026 03:48:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785149331; x=1785754131; darn=lists.ozlabs.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=neqsEsWHuKT6LwcChvXBKjF2Wl4AED5GjZjnD9EI9lc=;
        b=N8SAYiibQnHIABQ8aemk1pkvelZkr3UwMr6/25kluTqG0UPdKz+wINpBBrIQvsqdfq
         s18zZ5m2wZy4vNWxzhUgYmRshwfsU+CfJ3MyukQb+/VbchqxeQuUP+bHL9gTRnzCZoeC
         lnD2erok8fZDLMD7A7/3VjbRkN0qClf7aw/VIIEm3oQnSkSHhB5vPxVyhc4Ly65HzngF
         wAQx9RzPh+nXGf3zRO5Hh1dYFQelwjryqoGrybEEK+u8/H4UtljTnA+Imygx2lIBgta+
         9Dp1kiFXBeg4dLnSZuAoyxJpFuL0q/wbpWY7Y65h+itTeRHbIPT4rG4DvNA1aZkg8RMV
         yKww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785149331; x=1785754131;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=neqsEsWHuKT6LwcChvXBKjF2Wl4AED5GjZjnD9EI9lc=;
        b=riwvXDmWLWqALWKdc51AGGCXCART4qRlcQKIbak03yRJ1cQ2QMZb3yxhyhCN7mj4bV
         8vEzrDtOg0e1s5tBbTssoxe+ltHI9zHcze0+/VYqnz9tJln1nIq8Gdpus1q0O34cmGYf
         owZISGPhX4Hj0FerSVwCyBs8U8V/4WgL0D70uI+aOSVOn6J3GoE+Mr4nzZEWYqd3RPP3
         CgL/iAf3BcRNK2Les04HFMLIF3jHUtSOnfnCpqwKuT6h/y4tJ07jcjlRzv2+6NXyJ9c4
         Lh4tFnqTv4dq0WTYcHmE/99dHUbt6I6XR+fwWwgVA6vluL6uOZO0LNVRW8hHtYroDhyJ
         SCDg==
X-Forwarded-Encrypted: i=1; AHgh+Rr4cKQ9I38E74xIWAJQ+10FTWDWXIzaxGyZDzhYEDjrq2Q4XzEqiDQfne1Iad7ZVCIp3ibcH+Fo6VoIBg==@lists.ozlabs.org
X-Gm-Message-State: AOJu0Yyw/A/ptdxrxCsu38WTtU6+hNtIEtdhGT+LTV1MC1d8zbsBXfe0
	6uzC98BPu8wmwUWmRGHoNpIhN6fMWXBoZMOw+KV82OjydNASjFAkKVzN
X-Gm-Gg: AR+sD1059nWUExm1GSVhZdHmyhYTt5uFpncr+teQ7W/3nmhEQ7h6ykFFXFq1216YuaV
	uxBWPfr2RQhObG9+vYnQ4xpQaxNIsDL3tskZfahFLXcQDkgr/Esdpj2DyDGFJUOnyWZrHOddOHh
	pDlDd0tONkvrEfQTYAJ26MqNN+k/jXOdELQcstEBNbeiV5aZePw1gs3tdNtaByfU8b+I349uUG1
	zFqkVpPaPsR8XEVUkJIffZSSYdZIy/xo8DQFZG/QpLzDEgFj2VmWSG7NT6hN10xtxdajiHRvHiM
	ZeSe/u8rSVhrR0r4aRdVEE2hDyrYTnevJxQ7O7SDHIfh/GhD3I9DVWks6fpUXjAP79koHMFstuf
	+dAaIVUmg1R4OiLsREHz4MYYPlz5W7/8TAgD5ekTVFQsZfm9kTJv+RoaPcBmZsI6WbyJLAldwtu
	rWoZw1Hw==
X-Received: by 2002:a5d:5d09:0:b0:472:7dce:d8c7 with SMTP id ffacd0b85a97d-47f9fe9e8bbmr10201283f8f.36.1785149330834;
        Mon, 27 Jul 2026 03:48:50 -0700 (PDT)
Received: from spark.Home ([2001:8a0:7280:4000:53fe:effd:424:fa7e])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47f85b9a659sm49056188f8f.6.2026.07.27.03.48.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jul 2026 03:48:49 -0700 (PDT)
From: Eric Curtin <ericcurtin17@gmail.com>
To: Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>
Cc: Jan Kara <jack@suse.cz>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Eric Biggers <ebiggers@kernel.org>,
	"Theodore Y . Ts'o" <tytso@mit.edu>,
	Gao Xiang <xiang@kernel.org>,
	Chao Yu <chao@kernel.org>,
	fsverity@lists.linux.dev,
	linux-erofs@lists.ozlabs.org,
	linux-fsdevel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Eric Curtin <ericcurtin17@gmail.com>
Subject: [RFC PATCH v2 2/4] erofs: use fs_context source_file for file-backed mounts when given
Date: Mon, 27 Jul 2026 11:48:43 +0100
Message-ID: <20260727104845.2607444-3-ericcurtin17@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260727-gepaukt-eislauf-waran-7c03f0e47609@brauner>
References: <20260727-gepaukt-eislauf-waran-7c03f0e47609@brauner>
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

erofs_fc_get_tree() falls back to filp_open(fc->source, ...) itself
when get_tree_bdev_flags() reports the source isn't a block device.
That is the only way to reach erofs's file-backed mount support today,
which means an in-kernel caller that already opened and validated (e.g.
fsverity-checked) that exact file has no way to make erofs mount it: it
can only hand over the path again and trust erofs's independent lookup
to land on the same file, which it has no way to guarantee.

Check fc->source_file first and use it directly when set, taking a
reference and skipping the independent filp_open(fc->source) entirely
(fc->source is unset in this case). This has no effect on the existing
path-based fsconfig()/mount(2) flow, since userspace has no way to set
fc->source_file (see the previous patch); it only enables in-kernel
callers such as the following init/do_mounts.c change.

Signed-off-by: Eric Curtin <ericcurtin17@gmail.com>
---
 fs/erofs/super.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/fs/erofs/super.c b/fs/erofs/super.c
index 802add6652fd..b6cd4fde3ca2 100644
--- a/fs/erofs/super.c
+++ b/fs/erofs/super.c
@@ -799,6 +799,25 @@ static int erofs_fc_get_tree(struct fs_context *fc)
 	if (IS_ENABLED(CONFIG_EROFS_FS_ONDEMAND) && sbi->fsid)
 		return get_tree_nodev(fc, erofs_fc_fill_super);
 
+	/*
+	 * An in-kernel caller (see path_mount_file()) has handed us the
+	 * exact, already-open file to mount, rather than a path for us to
+	 * resolve ourselves: use it directly instead of independently
+	 * re-opening fc->source (which isn't set in this case), so that
+	 * whatever the caller validated about this file - e.g. an fsverity
+	 * digest - is guaranteed to still apply to what actually gets
+	 * mounted.
+	 */
+	if (fc->source_file) {
+		if (!IS_ENABLED(CONFIG_EROFS_FS_BACKED_BY_FILE))
+			return invalf(fc, "File-backed mounts not supported");
+		if (!S_ISREG(file_inode(fc->source_file)->i_mode) ||
+		    !fc->source_file->f_mapping->a_ops->read_folio)
+			return invalf(fc, "Source file is not a plain, read-foliable file");
+		sbi->dif0.file = get_file(fc->source_file);
+		return get_tree_nodev(fc, erofs_fc_fill_super);
+	}
+
 	ret = get_tree_bdev_flags(fc, erofs_fc_fill_super,
 		IS_ENABLED(CONFIG_EROFS_FS_BACKED_BY_FILE) ?
 			GET_TREE_BDEV_QUIET_LOOKUP : 0);
-- 
2.43.0


