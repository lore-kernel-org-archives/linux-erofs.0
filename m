Return-Path: <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E1265C3DA59
	for <linux-erofs@archiver.kernel.org>; Tue, 16 Jul 2024 12:41:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=lists.ozlabs.org;
	s=201707; t=1721133698;
	bh=JOc2QL0GlG8CTcOQi5uj8bth7V5mZgOnE0ctJCvfx6c=;
	h=To:Subject:Date:List-Id:List-Unsubscribe:List-Archive:List-Post:
	 List-Help:List-Subscribe:From:Reply-To:Cc:From;
	b=fHOHZDIrx/GmZAWMqE4dMvpdagcok64ZUGd+qMLy7NMDBiqHc92sYtQjJ+MkPOaxj
	 8MFij5t+UgfoamCzBK5RDFqorOg8xYZ2xcg16+rf5QMBonFi52u7jzKKrHGImrhjTZ
	 /riGPBp7YeoyorJndNqAiju0HPfz2Ykou5SwnKUWvEH5nJFcwXB4I+5yJlRg99ReUz
	 uUHcRHjDzsDIxoV9Bgd2ubtIZZpVPe0kKBojuv1APQJvGD7drtRSH5UUigHLt8ZZdK
	 sWSbpizLpjzF0Vu0GrZ0y8NIXyx9R3fkz2noBk5WaUF926tCAoQx9sf3bzaKPPUS6F
	 UeI9sHhqN/OsQ==
Received: from boromir.ozlabs.org (localhost [IPv6:::1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4WNdwy3Z8rz3dK3
	for <linux-erofs@archiver.kernel.org>; Tue, 16 Jul 2024 22:41:38 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=huawei.com (client-ip=45.249.212.187; helo=szxga01-in.huawei.com; envelope-from=lihongbo22@huawei.com; receiver=lists.ozlabs.org)
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4WNdwr1pRcz3cZF
	for <linux-erofs@lists.ozlabs.org>; Tue, 16 Jul 2024 22:41:28 +1000 (AEST)
Received: from mail.maildlp.com (unknown [172.19.163.174])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4WNdpW0Nc1zxSgK;
	Tue, 16 Jul 2024 20:36:03 +0800 (CST)
Received: from dggpeml500022.china.huawei.com (unknown [7.185.36.66])
	by mail.maildlp.com (Postfix) with ESMTPS id C0ABE14041A;
	Tue, 16 Jul 2024 20:40:53 +0800 (CST)
Received: from huawei.com (10.90.53.73) by dggpeml500022.china.huawei.com
 (7.185.36.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.39; Tue, 16 Jul
 2024 20:40:53 +0800
To: <xiang@kernel.org>, <chao@kernel.org>, <huyue2@coolpad.com>,
	<jefflexu@linux.alibaba.com>, <dhavale@google.com>, <dhowells@redhat.com>
Subject: [PATCH] erofs: support STATX_DIOALIGN
Date: Tue, 16 Jul 2024 20:45:34 +0800
Message-ID: <20240716124534.2358151-1-lihongbo22@huawei.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.90.53.73]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggpeml500022.china.huawei.com (7.185.36.66)
X-BeenThere: linux-erofs@lists.ozlabs.org
X-Mailman-Version: 2.1.29
Precedence: list
List-Id: Development of Linux EROFS file system <linux-erofs.lists.ozlabs.org>
List-Unsubscribe: <https://lists.ozlabs.org/options/linux-erofs>,
 <mailto:linux-erofs-request@lists.ozlabs.org?subject=unsubscribe>
List-Archive: <http://lists.ozlabs.org/pipermail/linux-erofs/>
List-Post: <mailto:linux-erofs@lists.ozlabs.org>
List-Help: <mailto:linux-erofs-request@lists.ozlabs.org?subject=help>
List-Subscribe: <https://lists.ozlabs.org/listinfo/linux-erofs>,
 <mailto:linux-erofs-request@lists.ozlabs.org?subject=subscribe>
From: Hongbo Li via Linux-erofs <linux-erofs@lists.ozlabs.org>
Reply-To: Hongbo Li <lihongbo22@huawei.com>
Cc: netfs@lists.linux.dev, linux-erofs@lists.ozlabs.org
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs" <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>

Add support for STATX_DIOALIGN to erofs, so that direct I/O
alignment restrictions are exposed to userspace in a generic
way.

[Before]
```
./statx_test /mnt/erofs/testfile
statx(/mnt/erofs/testfile) = 0
dio mem align:0
dio offset align:0
```

[After]
```
./statx_test /mnt/erofs/testfile
statx(/mnt/erofs/testfile) = 0
dio mem align:512
dio offset align:512
```

Signed-off-by: Hongbo Li <lihongbo22@huawei.com>
---
 fs/erofs/inode.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/fs/erofs/inode.c b/fs/erofs/inode.c
index 5f6439a63af7..9325a6f0058a 100644
--- a/fs/erofs/inode.c
+++ b/fs/erofs/inode.c
@@ -342,6 +342,25 @@ int erofs_getattr(struct mnt_idmap *idmap, const struct path *path,
 	stat->attributes_mask |= (STATX_ATTR_COMPRESSED |
 				  STATX_ATTR_IMMUTABLE);
 
+	/*
+	 * Return the DIO alignment restrictions if requested.
+	 *
+	 * In erofs, STATX_DIOALIGN is not supported in ondemand mode and
+	 * the compressed file, so in these cases we report no DIO support.
+	 */
+	if ((request_mask & STATX_DIOALIGN) && S_ISREG(inode->i_mode)) {
+		stat->result_mask |= STATX_DIOALIGN;
+		if (!erofs_is_fscache_mode(inode->i_sb) &&
+			!erofs_inode_is_data_compressed(EROFS_I(inode)->datalayout)) {
+			struct block_device *bdev = inode->i_sb->s_bdev;
+			unsigned int bsize = (bdev) ? bdev_logical_block_size(bdev) :
+						i_blocksize(inode);
+
+			stat->dio_mem_align = bsize;
+			stat->dio_offset_align = bsize;
+		}
+	}
+
 	generic_fillattr(idmap, request_mask, inode, stat);
 	return 0;
 }
-- 
2.34.1

