Return-Path: <linux-erofs+bounces-2455-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4A0D0E9B37D
	for <linux-erofs@archiver.kernel.org>; Mon,  2 Mar 2026 13:04:30 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4fPfK83lzwz2xc8;
	Tue, 03 Mar 2026 00:04:28 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=45.249.212.187
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1772456668;
	cv=none; b=QuhiZoIeWxvTMiNCj3UlQCwET0Ib2SMd/paCWWeKd2KwMDsR4MI1cqyRKBzc6XqqQ4GDg3BRWmqjgRVDtRV/AB+Y0rX/kOCki0dLRSUCDb3CCU5h/eszCddJi5GfvD+zceF0ZK62CYp++fio4a2iCBDtcyiIh3VsWQC9eBOAn9iIPMld/fe259oAr0iQapxNMKKZfa1nYayx/QBSyvaCRu5ubjgJqPI2W7azhqQCBKMlvzKPley6SuC+rn1nOpMQYe3gsCmCI2U38Sx2hcJTVynlY7oA77xBvaTGoqgUFBgzTLyFWqOjolURd0OAZayqGpb1JFrUqo3Nt7DZBf9K1A==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1772456668; c=relaxed/relaxed;
	bh=avu76bliB7xQ8vqxhj7BzW+pWKiXJjn4MA4cHpx9OaU=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=iGhDuQFALP0OIYMCBgh9O0lZOoIMTKY5nQrgRZ4QwBO+fNjgYzS9MvExsCMF1YA12pbzNwXM0Y9N+ig0/KmuI7jHL8h9Cv4GSIoWjy7mCIH+IlVu1V0KLsxLmFJAXkieM7Rq6PHx5v5NFwpEfCgbygHHiHLTAi+4s9UEmmUoOAqFGVQcvFopgp+KnZjhNuW2KaCMGxaVaZQP4wsEnrTUuLv4RV5WQDOgWCyN1f/hd8xEGSUvZW8rk2AMt+PViXl4eRATwdyMyqKd0SlOI8lJakuBEeAshzZ/xnClmg5NUtbvDFZ6c/B2fdHJwpUeHLB9wCPrJnlbt+vFqXsp/5PJYQ==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; dkim=pass (1024-bit key; unprotected) header.d=huawei.com header.i=@huawei.com header.a=rsa-sha256 header.s=dkim header.b=s8y/Pz7M; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.a=rsa-sha256 header.s=dkim header.b=s8y/Pz7M; dkim-atps=neutral; spf=pass (client-ip=45.249.212.187; helo=szxga01-in.huawei.com; envelope-from=lishixian8@huawei.com; receiver=lists.ozlabs.org) smtp.mailfrom=huawei.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=huawei.com header.i=@huawei.com header.a=rsa-sha256 header.s=dkim header.b=s8y/Pz7M;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.a=rsa-sha256 header.s=dkim header.b=s8y/Pz7M;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=huawei.com (client-ip=45.249.212.187; helo=szxga01-in.huawei.com; envelope-from=lishixian8@huawei.com; receiver=lists.ozlabs.org)
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4fPfK60cDvz2xGF
	for <linux-erofs@lists.ozlabs.org>; Tue, 03 Mar 2026 00:04:25 +1100 (AEDT)
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=avu76bliB7xQ8vqxhj7BzW+pWKiXJjn4MA4cHpx9OaU=;
	b=s8y/Pz7MtDQOnBjRw2ghxYhC8dcIm0yaV3kifRYeQ8VpsK0fAI+ksu2UphHrqDfI8wUl0fDMn
	/QiPLvU2hTs7IKQL+Xh/wTjNs7eBypfnubjhG1H6Q2WZKGFTeGX8Y7I8ePlAE/lo26rxe4Bcc3+
	aDtrp4r9fwHeQy0KckAKJbM=
Received: from canpmsgout03.his.huawei.com (unknown [172.19.92.159])
	by szxga01-in.huawei.com (SkyGuard) with ESMTPS id 4fPfJD1GlYz1BG93
	for <linux-erofs@lists.ozlabs.org>; Mon,  2 Mar 2026 21:03:40 +0800 (CST)
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=avu76bliB7xQ8vqxhj7BzW+pWKiXJjn4MA4cHpx9OaU=;
	b=s8y/Pz7MtDQOnBjRw2ghxYhC8dcIm0yaV3kifRYeQ8VpsK0fAI+ksu2UphHrqDfI8wUl0fDMn
	/QiPLvU2hTs7IKQL+Xh/wTjNs7eBypfnubjhG1H6Q2WZKGFTeGX8Y7I8ePlAE/lo26rxe4Bcc3+
	aDtrp4r9fwHeQy0KckAKJbM=
Received: from mail.maildlp.com (unknown [172.19.162.144])
	by canpmsgout03.his.huawei.com (SkyGuard) with ESMTPS id 4fPfBs0gxQzpSwC;
	Mon,  2 Mar 2026 20:59:01 +0800 (CST)
Received: from kwepemp100012.china.huawei.com (unknown [7.202.195.77])
	by mail.maildlp.com (Postfix) with ESMTPS id 495384056A;
	Mon,  2 Mar 2026 21:03:57 +0800 (CST)
Received: from huawei.com (10.50.159.234) by kwepemp100012.china.huawei.com
 (7.202.195.77) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.36; Mon, 2 Mar
 2026 21:03:56 +0800
From: lishixian <lishixian8@huawei.com>
To: <linux-erofs@lists.ozlabs.org>
CC: <hsiangkao@linux.alibaba.com>, <qinbinjuan@huawei.com>,
	<caihaomin@huawei.com>, <caihe@huawei.com>, <wayne.ma@huawei.com>,
	<zhukeqian1@huawei.com>, <jingrui@huawei.com>, <zhaoyifan28@huawei.com>,
	<lishixian8@huawei.com>
Subject: [PATCH] erofs-utils: lib: fix xattr crash in rebuild path when source has xattr
Date: Mon, 2 Mar 2026 21:03:56 +0800
Message-ID: <20260302130356.769479-1-lishixian8@huawei.com>
X-Mailer: git-send-email 2.47.3
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
X-Originating-IP: [10.50.159.234]
X-ClientProxiedBy: kwepems200002.china.huawei.com (7.221.188.68) To
 kwepemp100012.china.huawei.com (7.202.195.77)

When rebuilding from source EROFS images, erofs_read_xattrs_from_disk()
is called for inodes that have xattr. At that point inode->sbi points to
the source image's sbi, which is opened read-only and never gets
erofs_xattr_init(), so sbi->xamgr is NULL. get_xattritem(sbi) then
dereferences xamgr and crashes with SIGSEGV.

Fix by using the build target's xamgr when initializing src's sbi.

Reported-by: Yixiao Chen <489679970@qq.com>
Fixes: https://github.com/erofs/erofs-utils/issues/42
Signed-off-by: lishixian <lishixian8@huawei.com>
Reviewed-by: Yifan Zhao <zhaoyifan28@huawei.com>
---
 lib/rebuild.c | 1 +
 mkfs/main.c   | 1 +
 2 files changed, 2 insertions(+)

diff --git a/lib/rebuild.c b/lib/rebuild.c
index f89a17c..f1e79c1 100644
--- a/lib/rebuild.c
+++ b/lib/rebuild.c
@@ -437,6 +437,7 @@ int erofs_rebuild_load_tree(struct erofs_inode *root, struct erofs_sb_info *sbi,
 		erofs_err("failed to read superblock of %s", fsid);
 		return ret;
 	}
+	sbi->xamgr = g_sbi.xamgr;
 
 	inode.nid = sbi->root_nid;
 	inode.sbi = sbi;
diff --git a/mkfs/main.c b/mkfs/main.c
index b84d1b4..cb0f0cc 100644
--- a/mkfs/main.c
+++ b/mkfs/main.c
@@ -1011,6 +1011,7 @@ static void erofs_rebuild_cleanup(void)
 
 	list_for_each_entry_safe(src, n, &rebuild_src_list, list) {
 		list_del(&src->list);
+		src->xamgr = NULL; /* borrowed from g_sbi, do not free */
 		erofs_put_super(src);
 		erofs_dev_close(src);
 		free(src);
-- 
2.47.3


