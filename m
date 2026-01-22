Return-Path: <linux-erofs+bounces-2147-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E0049D3EE69
	for <linux-erofs@archiver.kernel.org>; Thu, 22 Jan 2026 13:50:34 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4dxjBD2c9Hz30MY;
	Fri, 23 Jan 2026 00:50:28 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=113.46.200.217
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1769089828;
	cv=none; b=jmUQ1JaSCWqBcQ5PqNmuNbOh+q3NT9gHrQvbmMvwNXJRonWJnxdlqjZyAx0HVPxDm9jTz9uTQkYT0H+3V+gUKfIxmDUAoN61CxfKXLPOtPr5qP7UAtzwdCMThtxRzOrFE0Ul3gxTXxORnRTVAxzcgKJTvvRuN2A/vINfwlWqjzWYrIl87WjVNDFS3p7HPXM/VWoDINu1qC5/1vHIacqpOefbaPFXRitEUf2bSg/u5GuuLc0ESSlRPoBYi42z/xtFp8ydGHcBeOthXyhc1PLJ2czUJPLBZDIBGnHy8C5fevB3eJKgCZVHrR2VttI+3pTStmjHOQ6CelSqJ7SYa+0MKg==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1769089828; c=relaxed/relaxed;
	bh=+RJ/lUy/s4IsZLQoItUqmF+7IGRzX6S4ot1reZrnGfM=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TNFOQRUSfXCGM3MmQok93zF41VWWAXULlBfFd/I5H1QbsWoSebxiAJ5Vjpe4DmVKZm4o7OcYeZJ5kfZFKpRYGSGwm61PehCvp27Zy6NYBmbAsPVndW++QkJVn0XbdrX9HjP37VIUgtr8ROxwhb+SlMsdIV8+Qm6IFtPgVAyECdmZGj8rV47sqmHF7R32Gdbq1s519q3m4kxrVripNWdOFnDf6v7wiFugLs2hkZjQ+f9PgBSwJU+8J3LG7YjMhrFGK5gyj+R73CSRwEDFTn//qbRjSWChASPApiW90W051/ojl5zxJcga23qqZ5OcbWZwdK0stlTdWSF+wfMzoEqcxA==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; dkim=pass (1024-bit key; unprotected) header.d=huawei.com header.i=@huawei.com header.a=rsa-sha256 header.s=dkim header.b=oo7DWSfH; dkim-atps=neutral; spf=pass (client-ip=113.46.200.217; helo=canpmsgout02.his.huawei.com; envelope-from=lihongbo22@huawei.com; receiver=lists.ozlabs.org) smtp.mailfrom=huawei.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=huawei.com header.i=@huawei.com header.a=rsa-sha256 header.s=dkim header.b=oo7DWSfH;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=huawei.com (client-ip=113.46.200.217; helo=canpmsgout02.his.huawei.com; envelope-from=lihongbo22@huawei.com; receiver=lists.ozlabs.org)
Received: from canpmsgout02.his.huawei.com (canpmsgout02.his.huawei.com [113.46.200.217])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4dxjB80c1Lz309S
	for <linux-erofs@lists.ozlabs.org>; Fri, 23 Jan 2026 00:50:22 +1100 (AEDT)
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=+RJ/lUy/s4IsZLQoItUqmF+7IGRzX6S4ot1reZrnGfM=;
	b=oo7DWSfHxz0tzaJHOoVC3r/qXviwmoPgLWhb+KrBpatngd5uXVxdOxFIiX4r7+E1CWfIwwNeO
	vnSMQYPXGonhfcr3bHFu86XuLvT+cYaHWTLEo0PjmykNrwAX6AM4cwZh/j4INmQO5J7uVJzMH3h
	Brn7uCrXTZeIwXiYVNBrxHI=
Received: from mail.maildlp.com (unknown [172.19.162.144])
	by canpmsgout02.his.huawei.com (SkyGuard) with ESMTPS id 4dxj5R3tsJzcb0S;
	Thu, 22 Jan 2026 21:46:19 +0800 (CST)
Received: from kwepemr500015.china.huawei.com (unknown [7.202.195.162])
	by mail.maildlp.com (Postfix) with ESMTPS id DC2B240567;
	Thu, 22 Jan 2026 21:50:18 +0800 (CST)
Received: from huawei.com (10.67.174.162) by kwepemr500015.china.huawei.com
 (7.202.195.162) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Thu, 22 Jan
 2026 21:50:18 +0800
From: Hongbo Li <lihongbo22@huawei.com>
To: <hsiangkao@linux.alibaba.com>, <chao@kernel.org>, <brauner@kernel.org>
CC: <hch@lst.de>, <djwong@kernel.org>, <amir73il@gmail.com>,
	<linux-fsdevel@vger.kernel.org>, <linux-erofs@lists.ozlabs.org>,
	<linux-kernel@vger.kernel.org>, <lihongbo22@huawei.com>
Subject: [PATCH v16 05/10] erofs: using domain_id in the safer way
Date: Thu, 22 Jan 2026 13:37:13 +0000
Message-ID: <20260122133718.658056-6-lihongbo22@huawei.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20260122133718.658056-1-lihongbo22@huawei.com>
References: <20260122133718.658056-1-lihongbo22@huawei.com>
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
X-ClientProxiedBy: kwepems200002.china.huawei.com (7.221.188.68) To
 kwepemr500015.china.huawei.com (7.202.195.162)

Either the existing fscache usecase or the upcoming page
cache sharing case, the `domain_id` should be protected as
sensitive information, so we use the safer helpers to allocate,
free and display domain_id.

Signed-off-by: Hongbo Li <lihongbo22@huawei.com>
---
 Documentation/filesystems/erofs.rst | 5 +++--
 fs/erofs/fscache.c                  | 4 ++--
 fs/erofs/super.c                    | 8 ++++----
 3 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/Documentation/filesystems/erofs.rst b/Documentation/filesystems/erofs.rst
index 08194f194b94..40dbf3b6a35f 100644
--- a/Documentation/filesystems/erofs.rst
+++ b/Documentation/filesystems/erofs.rst
@@ -126,8 +126,9 @@ dax={always,never}     Use direct access (no page cache).  See
 dax                    A legacy option which is an alias for ``dax=always``.
 device=%s              Specify a path to an extra device to be used together.
 fsid=%s                Specify a filesystem image ID for Fscache back-end.
-domain_id=%s           Specify a domain ID in fscache mode so that different images
-                       with the same blobs under a given domain ID can share storage.
+domain_id=%s           Specify a trusted domain ID for fscache mode so that
+                       different images with the same blobs, identified by blob IDs,
+                       can share storage within the same trusted domain.
 fsoffset=%llu          Specify block-aligned filesystem offset for the primary device.
 ===================    =========================================================
 
diff --git a/fs/erofs/fscache.c b/fs/erofs/fscache.c
index f4937b025038..a2cc0f3fa9d0 100644
--- a/fs/erofs/fscache.c
+++ b/fs/erofs/fscache.c
@@ -379,7 +379,7 @@ static void erofs_fscache_domain_put(struct erofs_domain *domain)
 		}
 		fscache_relinquish_volume(domain->volume, NULL, false);
 		mutex_unlock(&erofs_domain_list_lock);
-		kfree(domain->domain_id);
+		kfree_sensitive(domain->domain_id);
 		kfree(domain);
 		return;
 	}
@@ -446,7 +446,7 @@ static int erofs_fscache_init_domain(struct super_block *sb)
 	sbi->domain = domain;
 	return 0;
 out:
-	kfree(domain->domain_id);
+	kfree_sensitive(domain->domain_id);
 	kfree(domain);
 	return err;
 }
diff --git a/fs/erofs/super.c b/fs/erofs/super.c
index dca1445f6c92..6fbe9220303a 100644
--- a/fs/erofs/super.c
+++ b/fs/erofs/super.c
@@ -525,8 +525,8 @@ static int erofs_fc_parse_param(struct fs_context *fc,
 			return -ENOMEM;
 		break;
 	case Opt_domain_id:
-		kfree(sbi->domain_id);
-		sbi->domain_id = kstrdup(param->string, GFP_KERNEL);
+		kfree_sensitive(sbi->domain_id);
+		sbi->domain_id = no_free_ptr(param->string);
 		if (!sbi->domain_id)
 			return -ENOMEM;
 		break;
@@ -624,7 +624,7 @@ static void erofs_set_sysfs_name(struct super_block *sb)
 {
 	struct erofs_sb_info *sbi = EROFS_SB(sb);
 
-	if (sbi->domain_id)
+	if (sbi->domain_id && sbi->fsid)
 		super_set_sysfs_name_generic(sb, "%s,%s", sbi->domain_id,
 					     sbi->fsid);
 	else if (sbi->fsid)
@@ -852,7 +852,7 @@ static void erofs_sb_free(struct erofs_sb_info *sbi)
 {
 	erofs_free_dev_context(sbi->devs);
 	kfree(sbi->fsid);
-	kfree(sbi->domain_id);
+	kfree_sensitive(sbi->domain_id);
 	if (sbi->dif0.file)
 		fput(sbi->dif0.file);
 	kfree(sbi->volume_name);
-- 
2.22.0


