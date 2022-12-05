Return-Path: <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A018FC47089
	for <linux-erofs@archiver.kernel.org>; Mon,  5 Dec 2022 03:53:10 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [IPv6:::1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4NQV5065Hbz30jZ
	for <linux-erofs@archiver.kernel.org>; Mon,  5 Dec 2022 14:53:08 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=lists.ozlabs.org;
	s=201707; t=1670212388;
	bh=os0pbH/0PfRnZNluiRehdPw8JXxQVfTi7K2Xb6j6m9Y=;
	h=To:Subject:Date:List-Id:List-Unsubscribe:List-Archive:List-Post:
	 List-Help:List-Subscribe:From:Reply-To:Cc:From;
	b=Kch9cj5YvlXTsEm0dSdd2s7s2bLbotmbn4JKyQKDhmdmTRExRjek3cMpy1Vb9Z5an
	 zsGQEydAZ+QFUUym+k5VaTmuPICwi4Gz7B9742bFksM+KOCBm51JgsvHPkTApf5i20
	 Z+dyST/siXl74/OzNN+Pw+ORY0r6KsnCxPZh6d793DYr86gKvg1Wi06yYklX4kXEwG
	 Z0sMXZglN65oTiOnKBH0PRQu29d5yUvj+yPt+bZk/PgfNvq2/ZfBIoN/5vfiADRSrk
	 J5lwK2UTetY+D3BtAvdzEyuUK3KBY5xb8Ni/wvRUX7v9y5C+71Y5YLxbvIJ7L8gwQz
	 oxIPCoW+AfG2A==
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=huawei.com (client-ip=45.249.212.255; helo=szxga08-in.huawei.com; envelope-from=chenzhongjin@huawei.com; receiver=<UNKNOWN>)
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4NQV4v5sdGz304s
	for <linux-erofs@lists.ozlabs.org>; Mon,  5 Dec 2022 14:53:03 +1100 (AEDT)
Received: from dggpemm500013.china.huawei.com (unknown [172.30.72.56])
	by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4NQV3t0khVz15N5c;
	Mon,  5 Dec 2022 11:52:10 +0800 (CST)
Received: from ubuntu1804.huawei.com (10.67.175.36) by
 dggpemm500013.china.huawei.com (7.185.36.172) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 5 Dec 2022 11:52:56 +0800
To: <syzbot+6f8cd9a0155b366d227f@syzkaller.appspotmail.com>,
	<linux-erofs@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH -next v3] erofs: Fix pcluster memleak when its block address is zero
Date: Mon, 5 Dec 2022 11:49:57 +0800
Message-ID: <20221205034957.90362-1-chenzhongjin@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.175.36]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggpemm500013.china.huawei.com (7.185.36.172)
X-CFilter-Loop: Reflected
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
From: Chen Zhongjin via Linux-erofs <linux-erofs@lists.ozlabs.org>
Reply-To: Chen Zhongjin <chenzhongjin@huawei.com>
Cc: chenzhongjin@huawei.com, huyue2@coolpad.com
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs" <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>

syzkaller reported a memleak:
https://syzkaller.appspot.com/bug?id=62f37ff612f0021641eda5b17f056f1668aa9aed

unreferenced object 0xffff88811009c7f8 (size 136):
  ...
  backtrace:
    [<ffffffff821db19b>] z_erofs_do_read_page+0x99b/0x1740
    [<ffffffff821dee9e>] z_erofs_readahead+0x24e/0x580
    [<ffffffff814bc0d6>] read_pages+0x86/0x3d0
    ...

syzkaller constructed a case: in z_erofs_register_pcluster(),
ztailpacking = false and map->m_pa = zero. This makes pcl->obj.index be
zero although pcl is not a inline pcluster.

Then following path adds refcount for grp, but the refcount won't be put
because pcl is inline.

z_erofs_readahead()
  z_erofs_do_read_page() # for another page
    z_erofs_collector_begin()
      erofs_find_workgroup()
        erofs_workgroup_get()

Since it's illegal for the block address of a pcluster to be zero, add
check here to avoid registering the pcluster which would be leaked.

Fixes: cecf864d3d76 ("erofs: support inline data decompression")
Reported-by: syzbot+6f8cd9a0155b366d227f@syzkaller.appspotmail.com
Signed-off-by: Chen Zhongjin <chenzhongjin@huawei.com>
---
v1 -> v2:
As Gao's advice, we should fail to register pcluster if m_pa is zero.
Maked it this way and changed the commit message.

v2 -> v3:
Slightly fix commit message and add -next tag.
---
 fs/erofs/zdata.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/erofs/zdata.c b/fs/erofs/zdata.c
index b792d424d774..7826634f4f51 100644
--- a/fs/erofs/zdata.c
+++ b/fs/erofs/zdata.c
@@ -488,7 +488,8 @@ static int z_erofs_register_pcluster(struct z_erofs_decompress_frontend *fe)
 	struct erofs_workgroup *grp;
 	int err;
 
-	if (!(map->m_flags & EROFS_MAP_ENCODED)) {
+	if (!(map->m_flags & EROFS_MAP_ENCODED) ||
+		!(map->m_pa >> PAGE_SHIFT)) {
 		DBG_BUGON(1);
 		return -EFSCORRUPTED;
 	}
-- 
2.17.1

