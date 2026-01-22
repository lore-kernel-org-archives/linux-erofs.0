Return-Path: <linux-erofs+bounces-2165-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AD903D3EE89
	for <linux-erofs@archiver.kernel.org>; Thu, 22 Jan 2026 15:47:25 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4dxlmy6mK1z2yFm;
	Fri, 23 Jan 2026 02:47:14 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=113.46.200.223
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1769096834;
	cv=none; b=d21mMBC6hdopIavAezfkOkeXdz1MPKM9yqkKobd3qTMLcu1p+hMipkarq7oaw+aNqBMRyo2v2sTNa1iXmVu+iYp7ZtFL15h9JAIvgOy2RRMYFYSdqbjVFHv4dByFbpVd4+UXzAYHAGnZ5wpvYXLaC4R5SmpvmFDtQL2vDJy5nHxGK+75+IbarP0nQPyJU6KFq6YQ1VM1fKn7dTUONNgHzaLqI37Kh8QY1nLJ/fS++EwA8d5XL9eMCarL+EbNq/Bmv6fv62SmRRXTZGfXwYmLD0IUv6I1x8j//peZ4h0KbnN91nXIs4CniBYyDarLhhuXI7nUpnG+6K7gtWb1UaNjAA==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1769096834; c=relaxed/relaxed;
	bh=QqSfxPfujpN7eymI2ZrcsWZPzRbFHZJFWOBUz2J8E8c=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=g3v6HbsBeCjDGEyk560M7/pG/sGpkPqeP6dXwJVcJpnFfHTQSLLPYcNbxsCn3ciuUubnuPJpnlFkBui9S/rBEjmR8iQNvx8ZYu2XfHElX40acvB9olCVZPFWpQhU2ryZ7XfOFMeGVwgok2X0ejh4l/EIH2tnaE5Qv+XmSIgRauNLYtfO+6Xu6IRKlef9h8xLnjPr0az9jav6Kikt0Rb3C3BZB8c0ujr+8W0YYfhkc5SRdspGpavBEPa3ExyZtbwiUcjKJCZ553fTaVrH15sxWKIoSXCaNo1VQchMAS/uayvbzSgrwmedP7xKONPXHcq10hTgcZKqNdqSxYBwL2wHUw==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; dkim=pass (1024-bit key; unprotected) header.d=huawei.com header.i=@huawei.com header.a=rsa-sha256 header.s=dkim header.b=wkB/k3UG; dkim-atps=neutral; spf=pass (client-ip=113.46.200.223; helo=canpmsgout08.his.huawei.com; envelope-from=lihongbo22@huawei.com; receiver=lists.ozlabs.org) smtp.mailfrom=huawei.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=huawei.com header.i=@huawei.com header.a=rsa-sha256 header.s=dkim header.b=wkB/k3UG;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=huawei.com (client-ip=113.46.200.223; helo=canpmsgout08.his.huawei.com; envelope-from=lihongbo22@huawei.com; receiver=lists.ozlabs.org)
Received: from canpmsgout08.his.huawei.com (canpmsgout08.his.huawei.com [113.46.200.223])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4dxlms5c0mz2yql
	for <linux-erofs@lists.ozlabs.org>; Fri, 23 Jan 2026 02:47:08 +1100 (AEDT)
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=QqSfxPfujpN7eymI2ZrcsWZPzRbFHZJFWOBUz2J8E8c=;
	b=wkB/k3UG20e+95A8eSbEb5xUp0/zduIobFj4GU0J5jk8Q3varvFOUf3FP9m2Nd/sthsnFWZqy
	YH35fYzD+MQV8oYmQSVuTvWBgyX1JkdcKwNRx5Mg/Ft0jeLoUgeHClcxurVjFtpKSxKfWqfFsT6
	Zhd4BoYeGvOZ2ldyRXULCI4=
Received: from mail.maildlp.com (unknown [172.19.163.127])
	by canpmsgout08.his.huawei.com (SkyGuard) with ESMTPS id 4dxlhq3MHlzmV8f;
	Thu, 22 Jan 2026 23:43:39 +0800 (CST)
Received: from kwepemr500015.china.huawei.com (unknown [7.202.195.162])
	by mail.maildlp.com (Postfix) with ESMTPS id 9A9C3402AB;
	Thu, 22 Jan 2026 23:47:04 +0800 (CST)
Received: from huawei.com (10.67.174.162) by kwepemr500015.china.huawei.com
 (7.202.195.162) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Thu, 22 Jan
 2026 23:47:03 +0800
From: Hongbo Li <lihongbo22@huawei.com>
To: <hsiangkao@linux.alibaba.com>, <chao@kernel.org>, <brauner@kernel.org>
CC: <hch@lst.de>, <djwong@kernel.org>, <amir73il@gmail.com>,
	<linux-fsdevel@vger.kernel.org>, <linux-erofs@lists.ozlabs.org>,
	<linux-kernel@vger.kernel.org>, <lihongbo22@huawei.com>
Subject: [PATCH v17 05/10] erofs: using domain_id in the safer way
Date: Thu, 22 Jan 2026 15:34:01 +0000
Message-ID: <20260122153406.660073-6-lihongbo22@huawei.com>
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

Either the existing fscache usecase or the upcoming page
cache sharing case, the `domain_id` should be protected as
sensitive information, so we use the safer helpers to allocate,
free and display domain_id.

Signed-off-by: Hongbo Li <lihongbo22@huawei.com>
---
 Documentation/filesystems/erofs.rst | 5 +++--
 fs/erofs/fscache.c                  | 6 +++---
 fs/erofs/super.c                    | 8 ++++----
 3 files changed, 10 insertions(+), 9 deletions(-)

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
index f4937b025038..cd7847fd2670 100644
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
@@ -407,7 +407,7 @@ static int erofs_fscache_register_volume(struct super_block *sb)
 	}
 
 	sbi->volume = volume;
-	kfree(name);
+	domain_id ? kfree_sensitive(name) : kfree(name);
 	return ret;
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


