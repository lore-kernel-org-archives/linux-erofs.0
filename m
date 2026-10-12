Return-Path: <linux-erofs+bounces-4700-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D6D32CA9EDC
	for <linux-erofs@archiver.kernel.org>; Mon, 12 Oct 2026 14:01:26 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4j3JzR04Dkz30YZ;
	Tue, 13 Oct 2026 01:01:23 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=185.125.188.123
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1791813682;
	cv=none; b=cxPCGj3MTWKp/lzXB37M6HxT69NzigsYKUXdFYuScD2Y0OhaakQJMrRwzQikGBuZoH+RzF62pPsQ0DQGWimfUVekBEzNa//Okp8PnUSjAddSb2ZiEsXfkaB9wBD5nURPCIQXhqVuQYiuC4Wv2p4a9FeaLm5nqfZ6BKI4VwBvRNZjIYSGObszFTs/v1yafLjGTLpZ23q9b4snppJ9GCk1j2JPBjQgZmTr7usuloRP/Vizt+lezMelkYH7NZoZRhh+Lbw9DDbJNIIaVq9uyZGGQNt5QsqUtzambZIM1JfRe2Myc/uzz4RsOYVqVwah46kEvEdXDmsajVg42ozsCFsmGQ==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1791813682; c=relaxed/relaxed;
	bh=vNN6SxAHPYxFU2K/d+U3lBFVdfQBtoFnQVWEgzoNdsI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZUFnD26/xWUiP8lKjqh8uCvErA9jrgDkVcU+lEl2DTajwNeX/6QHdm0a88SnbGiByiuWgZGMwgz2v+p468kRRAvCZ9dEf8cDbghIhSYQrwAs4XgKJH14evZpax98D8KotKEPIYml1boW6J2C1zVJrmQxohDMQ9jeNNU1CTnX2wAg9XCGRU6rOm7CWr5VXwCLkeLs+nlAgdIQdFej5jolTr6V3+AA5++4XcEQLfvB6vamNfDuJ/VxnaYGhq8BZ1NApcGeBSuUadfrRJt2QTwCPUFVWgf1dvilOFnsnUNFePHV6DYwZ/CuOlG8UgX+AjmFxItZN3wL8muWjUSBNPvpoQ==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=reject dis=none) header.from=canonical.com; dkim=pass (4096-bit key; unprotected) header.d=canonical.com header.i=@canonical.com header.a=rsa-sha256 header.s=20251003 header.b=aV6++DoU; dkim-atps=neutral; spf=pass (client-ip=185.125.188.123; helo=smtp-relay-internal-1.canonical.com; envelope-from=heinrich.schuchardt@canonical.com; receiver=lists.ozlabs.org) smtp.mailfrom=canonical.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=reject dis=none) header.from=canonical.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (4096-bit key; unprotected) header.d=canonical.com header.i=@canonical.com header.a=rsa-sha256 header.s=20251003 header.b=aV6++DoU;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=canonical.com (client-ip=185.125.188.123; helo=smtp-relay-internal-1.canonical.com; envelope-from=heinrich.schuchardt@canonical.com; receiver=lists.ozlabs.org)
Received: from smtp-relay-internal-1.canonical.com (smtp-relay-internal-1.canonical.com [185.125.188.123])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4j3JzP4RyHz30Vs
	for <linux-erofs@lists.ozlabs.org>; Tue, 13 Oct 2026 01:01:21 +1100 (AEDT)
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com [209.85.128.70])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id C48693F290
	for <linux-erofs@lists.ozlabs.org>; Mon, 12 Oct 2026 14:01:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
	s=20251003; t=1791813678;
	bh=vNN6SxAHPYxFU2K/d+U3lBFVdfQBtoFnQVWEgzoNdsI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version;
	b=aV6++DoUegAOH4x6Rvb5dDQ4H4BBJhfU5HsgHou6AUS/wf0SVR/7dFIZfsOYPJxbC
	 23k+gat60jEqnzsphvaJT27vq0J3td0ZBVdn8+w8mblYlCzShQonvkj2TG8WpbN+rS
	 COD0iPyeBtkskMDz4zHvpLNHXunHeUWWnKls4UG+SuP4mhnazohAc1dkPAuAP8MaiX
	 8pGlzeK9ImL04rcO/Ed0wqGiHRINth1r5I+oyvnoEC8e7D3lTrnpuB/YfhqbJENxWB
	 BILLfy/7lOmff9PrZfxL8oqsQtt649LY2MtBYr3pzbh0sRbfqIWrUh0YJxkdiklAYA
	 3dJ9fr7WYFUeYlfZgor9yrXCYiLgI8IeQhI4hLEDPaa+onQQIlgBscTsMpmlqrJ5LP
	 KnYh/Vv28CK2GThfgoWuUvDJCWYOq8HvzeX+Uhvz2tP7KClz9PAOAQ5R4u6zPVkilK
	 0uQA0cgT81mfe8bWa4XGi+NRMJOhkCmyRw3vGD8aOsmdKwYjsiZTrGuSZN5VLC+2h9
	 14hNBuQLYuwOVy8UEe2sjVEbN7TsVP97cTxof0+zuaZGoFoizS/r2CtEjz59QS9uEH
	 3NTSwFgil2oDsJo4g4hXJvkSvPsHZdccCWTeYzJ+wFi/NGZXrriURJoK5sdKEkBxRF
	 p52FcbdFwzvs4XJhcbjL65Os=
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-4a01b112fa2so28787265e9.1
        for <linux-erofs@lists.ozlabs.org>; Mon, 12 Oct 2026 07:01:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791813678; x=1792418478;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=vNN6SxAHPYxFU2K/d+U3lBFVdfQBtoFnQVWEgzoNdsI=;
        b=RfceKA4xN9zg2fENk/oSmJ+ipZCd5TVS3igml7N6bN8XYnHGm4XKQnwrETDIJh1m3J
         dM4sky7YdWG1amM4okBE9q6jFpQI4L1YGr6mbFvNDBkkZeoA8ZjTM/E+ni68kf8pF+QE
         rilrvqVYGL3afiwjVfKMbz429v8K9PSsxGVrJ49Dxj4keVGzPKyBtPRKd27lthpVmafQ
         KNGaeQxrAG90akR54sLruI+ji2lcqLcMhbXHNxkA/53jxd/Q5/M61fsyOJK1dXo3tEsN
         7SHojEIJ1dUxBjhX9qPRwObv099rtTdU0Fu1mn+blz5uOnvvszvqbu2i7gZRmJBr1z+g
         YYFA==
X-Forwarded-Encrypted: i=1; AKwUvBz0/seqaVa4jHFeTeXjQXUzZX3ifCYybRjrIEPavfPJEy/9zlY+du7rrEM8wp3+DRH3kf1FfmNHDYReoA==@lists.ozlabs.org
X-Gm-Message-State: AFq9FYIGyxe0GAgFddrIFOFs14djQjaV86xBFEmI0A+szbD58zxFz0Cd
	CKvdH9XwIURzt5Hhj57esqYxQ2wcB8FA6cl3uiwL2gL1UWLUyfAphuXB+7EoCjlxSQXVJInGxRY
	RgxKZkEyvGP9km3A7NaQI7E2zXvX0sl3e0voGIIBMdRxvWHP4coNGp7NVGqFziRAjQrdrOwlr8H
	ampVMfQQ==
X-Gm-Gg: AYBFou0H9lG8WFX9fMSxHGw1v7wEr3ehxfGABHwrVvdqNQNYBRKX+kcTYQBN3FAX0d2
	foMuC9CyQGXKED/Ch1h3oS8gZWSmmF7xqbZJQ+hmExuBHl8em84EiqTR1RqhNsugN0HNASDCgiM
	k11TNkoeaLtMeB9j4ka2K3N82JZra0uGPmuJADQlKQZj6NJ5Wt1IcQWSQ4uPkJDaax35Z0/yJpr
	SI7X/LGAGv4vK55ZFOrCFujUCoSHzZBfkgUNIhk6+tAlAWxjbt+IYFrIbZ7azXbBQHnBDuAwzH2
	Cp0o7m+NSzIVnt+mcY5VE8yJWxMjDlAc1Trg654xS1znUW39tUIlJ4FO1/M75iWv5sx/c6HAUqQ
	gW8i5v6NtwTh9do3I5+4OsdnWoCRCpDlQWrxCr5hqI9px9Yx0wpk0MAU=
X-Received: by 2002:a05:600c:5251:b0:49f:e772:6ddf with SMTP id 5b1f17b1804b1-4a18e4d5a01mr178547015e9.32.1791813677882;
        Mon, 12 Oct 2026 07:01:17 -0700 (PDT)
X-Received: by 2002:a05:600c:5251:b0:49f:e772:6ddf with SMTP id 5b1f17b1804b1-4a18e4d5a01mr178545955e9.32.1791813677203;
        Mon, 12 Oct 2026 07:01:17 -0700 (PDT)
Received: from workstation5 ([2a02:908:1242:30e0:468d:767c:32e6:22fa])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a18bf15691sm284551015e9.6.2026.10.12.07.01.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Oct 2026 07:01:16 -0700 (PDT)
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
Subject: [PATCH 4/9] fs: ext4: don't read time fields in XPL
Date: Mon, 12 Oct 2026 16:00:43 +0200
Message-ID: <20261012140048.214059-5-heinrich.schuchardt@canonical.com>
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

The ext4 readdir implementation populates dent time fields in XML
builds though that information is never used.

Guard the three rtc_to_tm() calls with !IS_ENABLED(CONFIG_XPL_BUILD),
consistent with the FAT driver.

Signed-off-by: Heinrich Schuchardt <heinrich.schuchardt@canonical.com>
---
 fs/ext4/ext4fs.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/fs/ext4/ext4fs.c b/fs/ext4/ext4fs.c
index 3c79a889bc2..abf4a9835bc 100644
--- a/fs/ext4/ext4fs.c
+++ b/fs/ext4/ext4fs.c
@@ -319,9 +319,11 @@ int ext4fs_readdir(struct fs_dir_stream *fs_dirs, struct fs_dirent **dentp)
 		dent->type = FILETYPE_UNKNOWN;
 	}
 
-	rtc_to_tm(fdiro.inode.atime, &dent->access_time);
-	rtc_to_tm(fdiro.inode.ctime, &dent->create_time);
-	rtc_to_tm(fdiro.inode.mtime, &dent->change_time);
+	if (!IS_ENABLED(CONFIG_XPL_BUILD)) {
+		rtc_to_tm(le32_to_cpu(fdiro.inode.atime), &dent->access_time);
+		rtc_to_tm(le32_to_cpu(fdiro.inode.ctime), &dent->create_time);
+		rtc_to_tm(le32_to_cpu(fdiro.inode.mtime), &dent->change_time);
+	}
 
 	dirs->fpos += le16_to_cpu(dirent.direntlen);
 	dent->size = fdiro.inode.size;
-- 
2.55.0


