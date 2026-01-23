Return-Path: <linux-erofs+bounces-2212-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A791FD72348
	for <linux-erofs@archiver.kernel.org>; Fri, 23 Jan 2026 08:05:47 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4dy9V21JK5z30hP;
	Fri, 23 Jan 2026 19:05:46 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=113.46.200.219
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1769155546;
	cv=none; b=O7YqoPxUfhk5z2n+wBB2IkwSAo2wDftQ86YPbGdKSr3CHVHRTYyhGRERcCq635njKeoScIStwJdfKUPzGE1GI7wbVDasBu3oKbBY0+deF0ofuUMfFNWb1PqfqF5H+YmPFpL5S9dmnRE1+h5FYpPgGZJzd6dBuWcLMc5T/FKPOKbIPqWFFz18pzyYH5U6Y0BNJkuEjNMQHqmvJPokrOxkdD+WISH8FWjA9FAGPhCE24nbkf/egXv6x/W5pfXws6T4IKPEbcPql2nW+q0Z2oEDFxBdlbiKOcishPSyWCDd+AFxoE7uiGlE1+7ZvHeX900v5r2VHXAQ3TwUQakL6QIqQg==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1769155546; c=relaxed/relaxed;
	bh=N8kBUN8O+wcXEbmTE8rSX4uHp1tFEBs7iyg4eXensaY=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZGaTG4CdddQFn7kDaVvw/bf008xMe4LfsC0UkgBTL+fDbYsGM7X0Sl8BR4BAaIDjG7JBR6RD+W5OrX7G4euyCuNwkjSfSelBmj2qEpuNV0It/5GbERat9vBVSmSQWzfCxVL+R2I79apa9XCfNDi7noBbZCsyBVXiuY9GkjfBF+IjKx3iv/LbRDnJvxvktF1GeSehnGHPJKXRa9sqvDmZQQdqpPc9xlUos8ckSzjtQcEv6Sn0jW5q5/6L/OUJABgJEtbsRPKbnVByLKiyrEFTp0qekq/OggwuLwGYUs83y1BtaBg5l11m6WVKaOFsJhaaqf6ATU/m+xz/MNIQJsLhdg==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; dkim=pass (1024-bit key; unprotected) header.d=huawei.com header.i=@huawei.com header.a=rsa-sha256 header.s=dkim header.b=pz2se/Fi; dkim-atps=neutral; spf=pass (client-ip=113.46.200.219; helo=canpmsgout04.his.huawei.com; envelope-from=lihongbo22@huawei.com; receiver=lists.ozlabs.org) smtp.mailfrom=huawei.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=huawei.com header.i=@huawei.com header.a=rsa-sha256 header.s=dkim header.b=pz2se/Fi;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=huawei.com (client-ip=113.46.200.219; helo=canpmsgout04.his.huawei.com; envelope-from=lihongbo22@huawei.com; receiver=lists.ozlabs.org)
Received: from canpmsgout04.his.huawei.com (canpmsgout04.his.huawei.com [113.46.200.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4dy9Ty6SXqz30T8
	for <linux-erofs@lists.ozlabs.org>; Fri, 23 Jan 2026 19:05:40 +1100 (AEDT)
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=N8kBUN8O+wcXEbmTE8rSX4uHp1tFEBs7iyg4eXensaY=;
	b=pz2se/Fi3OhjcictbMjtROCxS5dsQLgVoiyzg+nD/YKjIZbITmWxTdwjZdQT6PdqpN2CRhq4o
	XmORjPIxhmxzokVND6tdoTzcQ37JFGAszv8rg1CBSGXbs0szBCKgxQER2WBzy17WFA9U7HRaixQ
	YCSalhjsEwWvFxhLcObt6Rc=
Received: from mail.maildlp.com (unknown [172.19.163.0])
	by canpmsgout04.his.huawei.com (SkyGuard) with ESMTPS id 4dy9Pp0tlkz1prL0;
	Fri, 23 Jan 2026 16:02:06 +0800 (CST)
Received: from kwepemr500015.china.huawei.com (unknown [7.202.195.162])
	by mail.maildlp.com (Postfix) with ESMTPS id 046CE40537;
	Fri, 23 Jan 2026 16:05:33 +0800 (CST)
Received: from huawei.com (10.67.174.162) by kwepemr500015.china.huawei.com
 (7.202.195.162) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Fri, 23 Jan
 2026 16:05:32 +0800
From: Hongbo Li <lihongbo22@huawei.com>
To: <brauner@kernel.org>, <chao@kernel.org>, <hsiangkao@linux.alibaba.com>
CC: <lihongbo22@huawei.com>, <amir73il@gmail.com>, <djwong@kernel.org>,
	<hch@lst.de>, <linux-erofs@lists.ozlabs.org>,
	<linux-fsdevel@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v19 04/10] erofs: add erofs_inode_set_aops helper to set the aops
Date: Fri, 23 Jan 2026 07:52:39 +0000
Message-ID: <20260123075239.664330-1-lihongbo22@huawei.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20260123013132.662393-5-lihongbo22@huawei.com>
References: <20260123013132.662393-5-lihongbo22@huawei.com>
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
X-ClientProxiedBy: kwepems500002.china.huawei.com (7.221.188.17) To
 kwepemr500015.china.huawei.com (7.202.195.162)

Add erofs_inode_set_aops helper to set the inode->i_mapping->a_ops
and use IS_ENABLED to make it cleaner.

Signed-off-by: Hongbo Li <lihongbo22@huawei.com>
---
 fs/erofs/inode.c    | 24 +-----------------------
 fs/erofs/internal.h | 22 ++++++++++++++++++++++
 2 files changed, 23 insertions(+), 23 deletions(-)

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
index ec79e8b44d3b..48bc52f95358 100644
--- a/fs/erofs/internal.h
+++ b/fs/erofs/internal.h
@@ -455,6 +455,28 @@ static inline void *erofs_vm_map_ram(struct page **pages, unsigned int count)
 	return NULL;
 }
 
+static inline int erofs_inode_set_aops(struct inode *inode,
+				       struct inode *realinode, bool no_fscache)
+{
+	if (erofs_inode_is_data_compressed(EROFS_I(realinode)->datalayout)) {
+		if (!IS_ENABLED(CONFIG_EROFS_FS_ZIP))
+			return -EOPNOTSUPP;
+		DO_ONCE_LITE_IF(realinode->i_blkbits != PAGE_SHIFT,
+			  erofs_info, realinode->i_sb,
+			  "EXPERIMENTAL EROFS subpage compressed block support in use. Use at your own risk!");
+		inode->i_mapping->a_ops = &z_erofs_aops;
+		return 0;
+	}
+	inode->i_mapping->a_ops = &erofs_aops;
+	if (IS_ENABLED(CONFIG_EROFS_FS_ONDEMAND) && !no_fscache &&
+	    erofs_is_fscache_mode(realinode->i_sb))
+		inode->i_mapping->a_ops = &erofs_fscache_access_aops;
+	if (IS_ENABLED(CONFIG_EROFS_FS_BACKED_BY_FILE) &&
+	    erofs_is_fileio_mode(EROFS_SB(realinode->i_sb)))
+		inode->i_mapping->a_ops = &erofs_fileio_aops;
+	return 0;
+}
+
 int erofs_register_sysfs(struct super_block *sb);
 void erofs_unregister_sysfs(struct super_block *sb);
 int __init erofs_init_sysfs(void);
-- 
2.22.0


