Return-Path: <linux-erofs+bounces-2152-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 13808D3EE69
	for <linux-erofs@archiver.kernel.org>; Thu, 22 Jan 2026 13:50:46 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4dxjBF50Wpz30Lw;
	Fri, 23 Jan 2026 00:50:29 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=113.46.200.223
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1769089829;
	cv=none; b=CPi0eT2v1fi3J94eO8O4s/8WEpU0SRR3cJVNHM++w6TUoAKDN4E8kWhKZtxVdkmkFjADYVg1w8WgjMAat8SrTj1MECFK7uoi3qgtVXUyzryxppiYQSd1jDTL/FD/+Kw+UwQmEjp0cnDO3WWwjWneHFFSNWJI4RHdsi0Y6knvbiAqbAQXzl+ASqDfeaQBZI0pAQUiTthwgUw0N7TJfr0jPf6WFdlcxMl2WsutF8dbQ/mQcjr96yGy6aIGK161cPqgunNekL36iimwsbmH35XDN33JCeojIT3v8DTboBo5rMh2X8wbujyf014MriFzTNsVnumalDvOci9yPhdUeSCt3w==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1769089829; c=relaxed/relaxed;
	bh=VrO1Gh2lwSX3aEb9VUUJD65yCyKiA7UNP2YVeY/Su74=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=iaqEE5jpSLORPunTrgZKyVwEerCHqXeBq42TZnqpW3IiYqbUo5Xy5NjSra1aYAo4TBGZDYWg8xUFubz0EWU5FNPJf/+mX4xtw+8yueXIwo4JOuXZQMx2bdTDSz+QLUIlVxnJ5Z6ma4rDOBbYGh/wb9wW//l50pl4+XECi3XnwBhjm2E6AxxS4BJgHs2Bo31HSq33TLyHrgzw+3CuUhSVk4gSmtyLFTugBTmV7tvF4dHwKsU/dWHOhBXg+e7mo3vE/bQmq2tQB6XAKZ0BVM+6cMSYvk8yA76FnnyPzCV/ICufFSE1m/bQowy0safRKCiX1Y5TCJ4upRxgYJ0WCVtdnA==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; dkim=pass (1024-bit key; unprotected) header.d=huawei.com header.i=@huawei.com header.a=rsa-sha256 header.s=dkim header.b=U3UThz0w; dkim-atps=neutral; spf=pass (client-ip=113.46.200.223; helo=canpmsgout08.his.huawei.com; envelope-from=lihongbo22@huawei.com; receiver=lists.ozlabs.org) smtp.mailfrom=huawei.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=huawei.com header.i=@huawei.com header.a=rsa-sha256 header.s=dkim header.b=U3UThz0w;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=huawei.com (client-ip=113.46.200.223; helo=canpmsgout08.his.huawei.com; envelope-from=lihongbo22@huawei.com; receiver=lists.ozlabs.org)
Received: from canpmsgout08.his.huawei.com (canpmsgout08.his.huawei.com [113.46.200.223])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4dxjBB6Pdcz2yFm
	for <linux-erofs@lists.ozlabs.org>; Fri, 23 Jan 2026 00:50:26 +1100 (AEDT)
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=VrO1Gh2lwSX3aEb9VUUJD65yCyKiA7UNP2YVeY/Su74=;
	b=U3UThz0wysPJ9ZdqJ4aMtzKlpeHrwuhz3ykUZHebb/O8/V5YkPVsZjdQwrRG5axHboapFBqS3
	6oMGswSRek3nsXoA4jrzCG8UNr4vRl1ZWYZqHsJ1zleYeoieASKImdVz8s7IgQ0CgFp53tTdtop
	qe/O1eT0FNMiJajd+ADfsoE=
Received: from mail.maildlp.com (unknown [172.19.163.15])
	by canpmsgout08.his.huawei.com (SkyGuard) with ESMTPS id 4dxj681fJSzmV69;
	Thu, 22 Jan 2026 21:46:56 +0800 (CST)
Received: from kwepemr500015.china.huawei.com (unknown [7.202.195.162])
	by mail.maildlp.com (Postfix) with ESMTPS id 5805140539;
	Thu, 22 Jan 2026 21:50:21 +0800 (CST)
Received: from huawei.com (10.67.174.162) by kwepemr500015.china.huawei.com
 (7.202.195.162) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Thu, 22 Jan
 2026 21:50:20 +0800
From: Hongbo Li <lihongbo22@huawei.com>
To: <hsiangkao@linux.alibaba.com>, <chao@kernel.org>, <brauner@kernel.org>
CC: <hch@lst.de>, <djwong@kernel.org>, <amir73il@gmail.com>,
	<linux-fsdevel@vger.kernel.org>, <linux-erofs@lists.ozlabs.org>,
	<linux-kernel@vger.kernel.org>, <lihongbo22@huawei.com>
Subject: [PATCH v16 10/10] erofs: implement .fadvise for page cache share
Date: Thu, 22 Jan 2026 13:37:18 +0000
Message-ID: <20260122133718.658056-11-lihongbo22@huawei.com>
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

From: Hongzhen Luo <hongzhen@linux.alibaba.com>

This patch implements the .fadvise interface for page cache share.
Similar to overlayfs, it drops those clean, unused pages through
vfs_fadvise().

Signed-off-by: Hongzhen Luo <hongzhen@linux.alibaba.com>
Signed-off-by: Hongbo Li <lihongbo22@huawei.com>
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


