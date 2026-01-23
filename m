Return-Path: <linux-erofs+bounces-2196-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CDE1CD6CFAA
	for <linux-erofs@archiver.kernel.org>; Fri, 23 Jan 2026 01:45:36 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4dy13H3VYdz2xKh;
	Fri, 23 Jan 2026 12:45:31 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=113.46.200.220
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1769132731;
	cv=none; b=g4mNMRyNuXXoYEMk+oHCvo/u0YA8gHhjYRp3CClUmHJ2l6Epd8PMGrX6I3TNJe9U4tCiIizJxukSu1/A/p3r19U718fCbN/t97stiZ1oM6kDbGrPu1I4WL7aI9qL6oOvxj+QgEywYi92c7dnTcXbRA81+nbMg+y7Z0Bwgp08C8USE7VgOWLn/EcBieAQ5VYLyjUhafaIiOIgXa9Ou3vm3ScTAZWSiMOdqHDc4EvOd/mk1JQ/ezTuY01EgSysQLyU94ef2D6oE6bPNjyUd/49jI177YhUIMNvbISWJqNTKSOjECKHO3uTqT4El7UBpXfwa8knTGlAfQHh4f4jfwGjFw==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1769132731; c=relaxed/relaxed;
	bh=X2tclZhWoOBbnPRpt4KYODEDqulzqggXkTbvFvdkSDc=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ltUQSrBTXVD0i2zyP0NFCQP+n/81VyzE9+PifcbZFRJHFzP2M6lJhJk1OiAG4i1mUgeeN7MwRQqPdlm5nHgyh5VhYuNS/eLwAroGTKtkA/d6VSfVsAaU7Wz1Vho7Dpe9fQc19iBmydP7O1G/rxZrnQKuOPmAd3WGbEraLAprtHTnOdbVF57g7PWZ0JbBSpMMednSrtVdPmiKbpOoAnNMaFIvw48QwaXQWiRVs/PeF2X8UUq5HZRgSE5f5x8JHo5iBq9bfHE+zaHAOwXeKxXyBBkaM3Xv2jvAvVRiTXmfwisb6NKgR95qR6YONkBy2WJ4WtodlwzTXTjra7dRqUdHqg==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; dkim=pass (1024-bit key; unprotected) header.d=huawei.com header.i=@huawei.com header.a=rsa-sha256 header.s=dkim header.b=PyrjXgwh; dkim-atps=neutral; spf=pass (client-ip=113.46.200.220; helo=canpmsgout05.his.huawei.com; envelope-from=lihongbo22@huawei.com; receiver=lists.ozlabs.org) smtp.mailfrom=huawei.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=huawei.com header.i=@huawei.com header.a=rsa-sha256 header.s=dkim header.b=PyrjXgwh;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=huawei.com (client-ip=113.46.200.220; helo=canpmsgout05.his.huawei.com; envelope-from=lihongbo22@huawei.com; receiver=lists.ozlabs.org)
Received: from canpmsgout05.his.huawei.com (canpmsgout05.his.huawei.com [113.46.200.220])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4dy1396bT9z2yFQ
	for <linux-erofs@lists.ozlabs.org>; Fri, 23 Jan 2026 12:45:24 +1100 (AEDT)
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=X2tclZhWoOBbnPRpt4KYODEDqulzqggXkTbvFvdkSDc=;
	b=PyrjXgwh3oeFedO0IZtiBPyXTRCGepZB/sHrUDQu8DHUBA6xjpY+IVm3leGntWEF0yQjfuM1C
	GOAOihZk5rhBq+iw2hEYiXh6p0G/2Az2gHnlqpjZicpx93dMKt+9VH7fQzQh6iFEItYHkqFoA4+
	lN2IHN+tl9MPpZRn3IFFDcQ=
Received: from mail.maildlp.com (unknown [172.19.162.223])
	by canpmsgout05.his.huawei.com (SkyGuard) with ESMTPS id 4dy0yT3s6fz12LD8;
	Fri, 23 Jan 2026 09:41:21 +0800 (CST)
Received: from kwepemr500015.china.huawei.com (unknown [7.202.195.162])
	by mail.maildlp.com (Postfix) with ESMTPS id E0DB340569;
	Fri, 23 Jan 2026 09:45:18 +0800 (CST)
Received: from huawei.com (10.67.174.162) by kwepemr500015.china.huawei.com
 (7.202.195.162) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Fri, 23 Jan
 2026 09:45:18 +0800
From: Hongbo Li <lihongbo22@huawei.com>
To: <hsiangkao@linux.alibaba.com>, <chao@kernel.org>, <brauner@kernel.org>
CC: <hch@lst.de>, <djwong@kernel.org>, <amir73il@gmail.com>,
	<linux-fsdevel@vger.kernel.org>, <linux-erofs@lists.ozlabs.org>,
	<linux-kernel@vger.kernel.org>, <lihongbo22@huawei.com>
Subject: [PATCH v18 04/10] erofs: add erofs_inode_set_aops helper to set the aops
Date: Fri, 23 Jan 2026 01:31:26 +0000
Message-ID: <20260123013132.662393-5-lihongbo22@huawei.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20260123013132.662393-1-lihongbo22@huawei.com>
References: <20260123013132.662393-1-lihongbo22@huawei.com>
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
X-ClientProxiedBy: kwepems200001.china.huawei.com (7.221.188.67) To
 kwepemr500015.china.huawei.com (7.202.195.162)

Add erofs_inode_set_aops helper to set the inode->i_mapping->a_ops
to make it cleaner.

Signed-off-by: Hongbo Li <lihongbo22@huawei.com>
Reviewed-by: Gao Xiang <hsiangkao@linux.alibaba.com>
---
 fs/erofs/inode.c    | 24 +-----------------------
 fs/erofs/internal.h | 26 ++++++++++++++++++++++++++
 2 files changed, 27 insertions(+), 23 deletions(-)

diff --git a/fs/erofs/inode.c b/fs/erofs/inode.c
index bce98c845a18..202cbbb4eada 100644
--- a/fs/erofs/inode.c
+++ b/fs/erofs/inode.c
@@ -203,7 +203,6 @@ static int erofs_read_inode(struct inode *inode)
 
 static int erofs_fill_inode(struct inode *inode)
 {
-	struct erofs_inode *vi = EROFS_I(inode);
 	int err;
 
 	trace_erofs_fill_inode(inode);
@@ -235,28 +234,7 @@ static int erofs_fill_inode(struct inode *inode)
 	}
 
 	mapping_set_large_folios(inode->i_mapping);
-	if (erofs_inode_is_data_compressed(vi->datalayout)) {
-#ifdef CONFIG_EROFS_FS_ZIP
-		DO_ONCE_LITE_IF(inode->i_blkbits != PAGE_SHIFT,
-			  erofs_info, inode->i_sb,
-			  "EXPERIMENTAL EROFS subpage compressed block support in use. Use at your own risk!");
-		inode->i_mapping->a_ops = &z_erofs_aops;
-#else
-		err = -EOPNOTSUPP;
-#endif
-	} else {
-		inode->i_mapping->a_ops = &erofs_aops;
-#ifdef CONFIG_EROFS_FS_ONDEMAND
-		if (erofs_is_fscache_mode(inode->i_sb))
-			inode->i_mapping->a_ops = &erofs_fscache_access_aops;
-#endif
-#ifdef CONFIG_EROFS_FS_BACKED_BY_FILE
-		if (erofs_is_fileio_mode(EROFS_SB(inode->i_sb)))
-			inode->i_mapping->a_ops = &erofs_fileio_aops;
-#endif
-	}
-
-	return err;
+	return erofs_inode_set_aops(inode, inode, false);
 }
 
 /*
diff --git a/fs/erofs/internal.h b/fs/erofs/internal.h
index ec79e8b44d3b..13b66564057a 100644
--- a/fs/erofs/internal.h
+++ b/fs/erofs/internal.h
@@ -455,6 +455,32 @@ static inline void *erofs_vm_map_ram(struct page **pages, unsigned int count)
 	return NULL;
 }
 
+static inline int erofs_inode_set_aops(struct inode *inode,
+				       struct inode *realinode, bool no_fscache)
+{
+	if (erofs_inode_is_data_compressed(EROFS_I(realinode)->datalayout)) {
+#ifdef CONFIG_EROFS_FS_ZIP
+		DO_ONCE_LITE_IF(realinode->i_blkbits != PAGE_SHIFT,
+			  erofs_info, realinode->i_sb,
+			  "EXPERIMENTAL EROFS subpage compressed block support in use. Use at your own risk!");
+		inode->i_mapping->a_ops = &z_erofs_aops;
+#else
+		return -EOPNOTSUPP;
+#endif
+	} else {
+		inode->i_mapping->a_ops = &erofs_aops;
+#ifdef CONFIG_EROFS_FS_ONDEMAND
+		if (!no_fscache && erofs_is_fscache_mode(realinode->i_sb))
+			inode->i_mapping->a_ops = &erofs_fscache_access_aops;
+#endif
+#ifdef CONFIG_EROFS_FS_BACKED_BY_FILE
+		if (erofs_is_fileio_mode(EROFS_SB(realinode->i_sb)))
+			inode->i_mapping->a_ops = &erofs_fileio_aops;
+#endif
+	}
+	return 0;
+}
+
 int erofs_register_sysfs(struct super_block *sb);
 void erofs_unregister_sysfs(struct super_block *sb);
 int __init erofs_init_sysfs(void);
-- 
2.22.0


