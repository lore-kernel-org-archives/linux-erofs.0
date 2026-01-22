Return-Path: <linux-erofs+bounces-2159-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 71660D3EE86
	for <linux-erofs@archiver.kernel.org>; Thu, 22 Jan 2026 15:47:13 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4dxlmv6c7Fz30BR;
	Fri, 23 Jan 2026 02:47:11 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=113.46.200.217
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1769096831;
	cv=none; b=h38CJ9hXs8ghY5fIJtKfy+WYpDuFxPdLCOItPREZbpefte2o7N17kaOAbk9DMcXvTGgfoYLjjjByWawAdwtFE8dFTVYC3/EySqKzoxt5KNfZigZFojYqC4K7orDMoyLwQ7GtsWz2VFo8eXR33vX3SciA5elcrzm9HofV2u1Vve7Bl/3eKJFyMsCHhzfhDpJSfb7AS1h9+sV8kKKXXSpbcjsxKniSzvehRYX3trcRlLGhrqcu40nHJD2oQrFANqm4OZmq5/9JUS5f/RW3JE4FZtehDBGvmX9Af7ts7LKGOZSvNa7Pft+ZjKdcCaOQL186yZnyXaFOJ+g5cSOjaUO3EA==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1769096831; c=relaxed/relaxed;
	bh=otZzmT6rxktVNDVECk5mC06H07hAnwXYZ9UJTBeZ2EE=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VdbQjBMNw1gYYD6apUQaE0VhZBQYc014YiBnUbXOIVSdKh7XwIi5yNFtZMwa812OrTdPhug5GCKE6iW7bBUTXsphV9D3RrhFLPDCGXf1rT4rVcslbmRvUCjGiaR5GEXW4k0xlakV6uHSgfuK4j+rRROZ43GJ1JGlHx9ITuCsNhaLzEbfVICn5LuOgzQxX9sWTJ3JwGy20mW5lvSxcJ6/0rw+b2A1f7CgpGFzuTJLwThFejLQUKf1NNGhgRroP4nLeS7F7tp9duDo0DYgPpShWbYg8yCZXcPBsXAa/dWVFSROSsMewq4BI/DIYYV/+ObU90Df1iNEoY1Xo51fUP0BaA==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; dkim=pass (1024-bit key; unprotected) header.d=huawei.com header.i=@huawei.com header.a=rsa-sha256 header.s=dkim header.b=oJbF4d0t; dkim-atps=neutral; spf=pass (client-ip=113.46.200.217; helo=canpmsgout02.his.huawei.com; envelope-from=lihongbo22@huawei.com; receiver=lists.ozlabs.org) smtp.mailfrom=huawei.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=huawei.com header.i=@huawei.com header.a=rsa-sha256 header.s=dkim header.b=oJbF4d0t;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=huawei.com (client-ip=113.46.200.217; helo=canpmsgout02.his.huawei.com; envelope-from=lihongbo22@huawei.com; receiver=lists.ozlabs.org)
Received: from canpmsgout02.his.huawei.com (canpmsgout02.his.huawei.com [113.46.200.217])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4dxlms5t7gz308l
	for <linux-erofs@lists.ozlabs.org>; Fri, 23 Jan 2026 02:47:09 +1100 (AEDT)
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=otZzmT6rxktVNDVECk5mC06H07hAnwXYZ9UJTBeZ2EE=;
	b=oJbF4d0t5wRl+Q3D2MEG1XxQ46Sws4p95wCVOUDW01xFXaHTtZLIuDaU1CGP+FYnhHWI9gyc+
	vl1DpAL3wOTCohN8rpHMh58gcD4/VUG36UAoqVqtLr4Wg1E8jI9n820W4N+o3Weae21OVDrRQCJ
	RiDve7yi5NEMgQAYQ4IAnOc=
Received: from mail.maildlp.com (unknown [172.19.162.197])
	by canpmsgout02.his.huawei.com (SkyGuard) with ESMTPS id 4dxlh75CRHzcb0S;
	Thu, 22 Jan 2026 23:43:03 +0800 (CST)
Received: from kwepemr500015.china.huawei.com (unknown [7.202.195.162])
	by mail.maildlp.com (Postfix) with ESMTPS id 383A740363;
	Thu, 22 Jan 2026 23:47:03 +0800 (CST)
Received: from huawei.com (10.67.174.162) by kwepemr500015.china.huawei.com
 (7.202.195.162) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Thu, 22 Jan
 2026 23:47:02 +0800
From: Hongbo Li <lihongbo22@huawei.com>
To: <hsiangkao@linux.alibaba.com>, <chao@kernel.org>, <brauner@kernel.org>
CC: <hch@lst.de>, <djwong@kernel.org>, <amir73il@gmail.com>,
	<linux-fsdevel@vger.kernel.org>, <linux-erofs@lists.ozlabs.org>,
	<linux-kernel@vger.kernel.org>, <lihongbo22@huawei.com>
Subject: [PATCH v17 02/10] erofs: decouple `struct erofs_anon_fs_type`
Date: Thu, 22 Jan 2026 15:33:58 +0000
Message-ID: <20260122153406.660073-3-lihongbo22@huawei.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20260122153406.660073-1-lihongbo22@huawei.com>
References: <20260122153406.660073-1-lihongbo22@huawei.com>
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
Content-Type: text/plain
X-Originating-IP: [10.67.174.162]
X-ClientProxiedBy: kwepems100002.china.huawei.com (7.221.188.206) To
 kwepemr500015.china.huawei.com (7.202.195.162)

From: Gao Xiang <hsiangkao@linux.alibaba.com>

  - Move the `struct erofs_anon_fs_type` to super.c and expose it
    in preparation for the upcoming page cache share feature;

  - Remove the `.owner` field, as they are all internal mounts and
    fully managed by EROFS.  Retaining `.owner` would unnecessarily
    increment module reference counts, preventing the EROFS kernel
    module from being unloaded.

Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
---
 fs/erofs/fscache.c  | 13 -------------
 fs/erofs/internal.h |  2 ++
 fs/erofs/super.c    | 14 ++++++++++++++
 3 files changed, 16 insertions(+), 13 deletions(-)

diff --git a/fs/erofs/fscache.c b/fs/erofs/fscache.c
index 7a346e20f7b7..f4937b025038 100644
--- a/fs/erofs/fscache.c
+++ b/fs/erofs/fscache.c
@@ -3,7 +3,6 @@
  * Copyright (C) 2022, Alibaba Cloud
  * Copyright (C) 2022, Bytedance Inc. All rights reserved.
  */
-#include <linux/pseudo_fs.h>
 #include <linux/fscache.h>
 #include "internal.h"
 
@@ -13,18 +12,6 @@ static LIST_HEAD(erofs_domain_list);
 static LIST_HEAD(erofs_domain_cookies_list);
 static struct vfsmount *erofs_pseudo_mnt;
 
-static int erofs_anon_init_fs_context(struct fs_context *fc)
-{
-	return init_pseudo(fc, EROFS_SUPER_MAGIC) ? 0 : -ENOMEM;
-}
-
-static struct file_system_type erofs_anon_fs_type = {
-	.owner		= THIS_MODULE,
-	.name           = "pseudo_erofs",
-	.init_fs_context = erofs_anon_init_fs_context,
-	.kill_sb        = kill_anon_super,
-};
-
 struct erofs_fscache_io {
 	struct netfs_cache_resources cres;
 	struct iov_iter		iter;
diff --git a/fs/erofs/internal.h b/fs/erofs/internal.h
index f7f622836198..98fe652aea33 100644
--- a/fs/erofs/internal.h
+++ b/fs/erofs/internal.h
@@ -188,6 +188,8 @@ static inline bool erofs_is_fileio_mode(struct erofs_sb_info *sbi)
 	return IS_ENABLED(CONFIG_EROFS_FS_BACKED_BY_FILE) && sbi->dif0.file;
 }
 
+extern struct file_system_type erofs_anon_fs_type;
+
 static inline bool erofs_is_fscache_mode(struct super_block *sb)
 {
 	return IS_ENABLED(CONFIG_EROFS_FS_ONDEMAND) &&
diff --git a/fs/erofs/super.c b/fs/erofs/super.c
index 937a215f626c..f18f43b78fca 100644
--- a/fs/erofs/super.c
+++ b/fs/erofs/super.c
@@ -11,6 +11,7 @@
 #include <linux/fs_parser.h>
 #include <linux/exportfs.h>
 #include <linux/backing-dev.h>
+#include <linux/pseudo_fs.h>
 #include "xattr.h"
 
 #define CREATE_TRACE_POINTS
@@ -936,6 +937,19 @@ static struct file_system_type erofs_fs_type = {
 };
 MODULE_ALIAS_FS("erofs");
 
+#if defined(CONFIG_EROFS_FS_ONDEMAND)
+static int erofs_anon_init_fs_context(struct fs_context *fc)
+{
+	return init_pseudo(fc, EROFS_SUPER_MAGIC) ? 0 : -ENOMEM;
+}
+
+struct file_system_type erofs_anon_fs_type = {
+	.name           = "pseudo_erofs",
+	.init_fs_context = erofs_anon_init_fs_context,
+	.kill_sb        = kill_anon_super,
+};
+#endif
+
 static int __init erofs_module_init(void)
 {
 	int err;
-- 
2.22.0


