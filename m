Return-Path: <linux-erofs+bounces-2194-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3B69AD6CFAA
	for <linux-erofs@archiver.kernel.org>; Fri, 23 Jan 2026 01:45:32 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4dy13D4rW9z2yFg;
	Fri, 23 Jan 2026 12:45:28 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=113.46.200.222
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1769132728;
	cv=none; b=J/QpT89yfQVfXhYoktctsQ+opipjmqI02ABRpMG6cceb7oM73fkaIbFbu0CDYzC30zBo+K5JiuFrLafucNWnZyHKhGxTtdammAY9pDl9VFKANGrONGDWtRuYrOOhAOB8dXxnaqGPAtd66y4OS7w0ZhBBJCJrp79rpjg4Gy2pekbZoRbULyKakIDFnXVfho2CY193CrBmyiLEC8Ft/TzJea3MO9ZWtVBc8WAE/K/dy/IvkpDFsum+nR/D0onhYJY2smT3Ub/btUSQ6N9HbV26vi5mqVnpCyYBw6KZroFrt04vhF5UHL2ikwq9k5DWbN58TlD7FwjOeQYSDWAYLt8OCQ==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1769132728; c=relaxed/relaxed;
	bh=pjdMVj5WK0KjkehQa5OTHZ+MCiwfMCyVPXQRCDg124Y=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UsXxp2zUV3o9bLryrF+iPqC4SQzKgDa+0rOfiE9dzjL68z9bLgB2I9k/gwHNzFtR3xQp8csXbCQNEc8XZJ9jVuFpWoIC6+/Xm94pDiIuQH/zB4VurVaj5dmEcs03Np+AeXeaZ5TzU/L10zm/ofkyhDCPKR+SVx68ShL3m+j2ASDYoAT1MG90Cq4Dxuf0vaUi8CL/dOIfW1OiQaBm0s79If0rnmfPBs6SeRHQ2NuuGjkuM2XcWd4u1FcJ8eGAWTUL8XHZ1NSbBCngDOWJ0ywWffZNF+pNbDmKSfqIG0ypThSPgQcDP35/LgQ24JpEsz79EURI0m0foVUhkjVQNBtUBg==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; dkim=pass (1024-bit key; unprotected) header.d=huawei.com header.i=@huawei.com header.a=rsa-sha256 header.s=dkim header.b=uTFxrd8I; dkim-atps=neutral; spf=pass (client-ip=113.46.200.222; helo=canpmsgout07.his.huawei.com; envelope-from=lihongbo22@huawei.com; receiver=lists.ozlabs.org) smtp.mailfrom=huawei.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=huawei.com header.i=@huawei.com header.a=rsa-sha256 header.s=dkim header.b=uTFxrd8I;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=huawei.com (client-ip=113.46.200.222; helo=canpmsgout07.his.huawei.com; envelope-from=lihongbo22@huawei.com; receiver=lists.ozlabs.org)
Received: from canpmsgout07.his.huawei.com (canpmsgout07.his.huawei.com [113.46.200.222])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4dy13B14VCz2yFW
	for <linux-erofs@lists.ozlabs.org>; Fri, 23 Jan 2026 12:45:26 +1100 (AEDT)
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=pjdMVj5WK0KjkehQa5OTHZ+MCiwfMCyVPXQRCDg124Y=;
	b=uTFxrd8IXGqAsUVgSzf8YOFirRCl+3Vri/JQVcixI0RqRwASzkKo/jUAAOd1zf2p8vAHRhNct
	7JRO2KnDibrXmcR1YSb58tPaTU2XzWY8irks5vvRwYuE1ugRbA9HdzpSp+Pa/6cphzU/dMAJn2U
	JzHDdXLMT0jGr7lSzjEguOw=
Received: from mail.maildlp.com (unknown [172.19.163.200])
	by canpmsgout07.his.huawei.com (SkyGuard) with ESMTPS id 4dy0z93hBczLlTR;
	Fri, 23 Jan 2026 09:41:57 +0800 (CST)
Received: from kwepemr500015.china.huawei.com (unknown [7.202.195.162])
	by mail.maildlp.com (Postfix) with ESMTPS id 9F0384055B;
	Fri, 23 Jan 2026 09:45:21 +0800 (CST)
Received: from huawei.com (10.67.174.162) by kwepemr500015.china.huawei.com
 (7.202.195.162) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Fri, 23 Jan
 2026 09:45:20 +0800
From: Hongbo Li <lihongbo22@huawei.com>
To: <hsiangkao@linux.alibaba.com>, <chao@kernel.org>, <brauner@kernel.org>
CC: <hch@lst.de>, <djwong@kernel.org>, <amir73il@gmail.com>,
	<linux-fsdevel@vger.kernel.org>, <linux-erofs@lists.ozlabs.org>,
	<linux-kernel@vger.kernel.org>, <lihongbo22@huawei.com>
Subject: [PATCH v18 10/10] erofs: implement .fadvise for page cache share
Date: Fri, 23 Jan 2026 01:31:32 +0000
Message-ID: <20260123013132.662393-11-lihongbo22@huawei.com>
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

From: Hongzhen Luo <hongzhen@linux.alibaba.com>

This patch implements the .fadvise interface for page cache share.
Similar to overlayfs, it drops those clean, unused pages through
vfs_fadvise().

Signed-off-by: Hongzhen Luo <hongzhen@linux.alibaba.com>
Signed-off-by: Hongbo Li <lihongbo22@huawei.com>
Reviewed-by: Gao Xiang <hsiangkao@linux.alibaba.com>
---
 fs/erofs/ishare.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/erofs/ishare.c b/fs/erofs/ishare.c
index ad53a57dbcbc..ce980320a8b9 100644
--- a/fs/erofs/ishare.c
+++ b/fs/erofs/ishare.c
@@ -151,6 +151,12 @@ static int erofs_ishare_mmap(struct file *file, struct vm_area_struct *vma)
 	return generic_file_readonly_mmap(file, vma);
 }
 
+static int erofs_ishare_fadvise(struct file *file, loff_t offset,
+				loff_t len, int advice)
+{
+	return vfs_fadvise(file->private_data, offset, len, advice);
+}
+
 const struct file_operations erofs_ishare_fops = {
 	.open		= erofs_ishare_file_open,
 	.llseek		= generic_file_llseek,
@@ -159,6 +165,7 @@ const struct file_operations erofs_ishare_fops = {
 	.release	= erofs_ishare_file_release,
 	.get_unmapped_area = thp_get_unmapped_area,
 	.splice_read	= filemap_splice_read,
+	.fadvise	= erofs_ishare_fadvise,
 };
 
 struct inode *erofs_real_inode(struct inode *inode, bool *need_iput)
-- 
2.22.0


