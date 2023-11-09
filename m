Return-Path: <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 35492C4167B
	for <linux-erofs@archiver.kernel.org>; Thu,  9 Nov 2023 12:14:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=lists.ozlabs.org;
	s=201707; t=1699532081;
	bh=cWlERthZkFluDqgzovAJew6EH6I4A0e1oLoOETNAnyU=;
	h=To:Subject:Date:List-Id:List-Unsubscribe:List-Archive:List-Post:
	 List-Help:List-Subscribe:From:Reply-To:Cc:From;
	b=LHuiqvYS+e2vStLZiqnZIKPq2UXvKN3JP1fqARPxVu9lHZp4vbO4ZPf8QneroNeLG
	 RAhIl3perXpEAORQN94DKb+nWFbX9qvOdbp8z4wLONn7hcFt+tHvpLR3utZGkc27wm
	 hD1SxqZZIFBCuuiQO2Ey02AeLHBarM7U+TeBen8Ifva6DBdQsGkAQrzd0IAaGhwutA
	 XTorj1BW2+PUT1Qp7fItI473IQ7DiNAgRynCjc8ecyOtq0IBnGCbzebbMWwZCFEI3S
	 nYp3liI0dHlhdsPCbZEYmfgahja5qBQjidABgTdt9PHSaM+eDI+v7eHBe4cIRSDDNz
	 hv2nwVk62tvcw==
Received: from boromir.ozlabs.org (localhost [IPv6:::1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4SR19F4ZNsz3cTS
	for <linux-erofs@archiver.kernel.org>; Thu,  9 Nov 2023 23:14:41 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=huawei.com (client-ip=45.249.212.187; helo=szxga01-in.huawei.com; envelope-from=wozizhi@huawei.com; receiver=lists.ozlabs.org)
X-Greylist: delayed 1212 seconds by postgrey-1.37 at boromir; Thu, 09 Nov 2023 23:14:32 AEDT
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4SR1943SL1z2yVG
	for <linux-erofs@lists.ozlabs.org>; Thu,  9 Nov 2023 23:14:28 +1100 (AEDT)
Received: from dggpemm500020.china.huawei.com (unknown [172.30.72.53])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4SR0dK0KNgzmXH1;
	Thu,  9 Nov 2023 19:50:29 +0800 (CST)
Received: from localhost.localdomain (10.175.104.67) by
 dggpemm500020.china.huawei.com (7.185.36.49) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.31; Thu, 9 Nov 2023 19:53:41 +0800
To: <xiang@kernel.org>, <chao@kernel.org>
Subject: [PATCH -next V2] erofs: code clean up for function erofs_read_inode()
Date: Fri, 10 Nov 2023 03:48:21 +0800
Message-ID: <20231109194821.1719430-1-wozizhi@huawei.com>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.175.104.67]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggpemm500020.china.huawei.com (7.185.36.49)
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
From: WoZ1zh1 via Linux-erofs <linux-erofs@lists.ozlabs.org>
Reply-To: WoZ1zh1 <wozizhi@huawei.com>
Cc: yangerkun@huawei.com, linux-erofs@lists.ozlabs.org, linux-kernel@vger.kernel.org
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs" <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>

Because variables "die" and "copied" only appear in case
EROFS_INODE_LAYOUT_EXTENDED, move them from the outer space into this
case. Also, call "kfree(copied)" earlier to avoid double free in the
"error_out" branch. Some cleanups, no logic changes.

Signed-off-by: WoZ1zh1 <wozizhi@huawei.com>
---
 fs/erofs/inode.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/erofs/inode.c b/fs/erofs/inode.c
index b8ad05b4509d..a388c93eec34 100644
--- a/fs/erofs/inode.c
+++ b/fs/erofs/inode.c
@@ -19,7 +19,6 @@ static void *erofs_read_inode(struct erofs_buf *buf,
 	erofs_blk_t blkaddr, nblks = 0;
 	void *kaddr;
 	struct erofs_inode_compact *dic;
-	struct erofs_inode_extended *die, *copied = NULL;
 	unsigned int ifmt;
 	int err;
 
@@ -53,6 +52,8 @@ static void *erofs_read_inode(struct erofs_buf *buf,
 
 	switch (erofs_inode_version(ifmt)) {
 	case EROFS_INODE_LAYOUT_EXTENDED:
+		struct erofs_inode_extended *die, *copied = NULL;
+
 		vi->inode_isize = sizeof(struct erofs_inode_extended);
 		/* check if the extended inode acrosses block boundary */
 		if (*ofs + vi->inode_isize <= sb->s_blocksize) {
@@ -98,6 +99,7 @@ static void *erofs_read_inode(struct erofs_buf *buf,
 			inode->i_rdev = 0;
 			break;
 		default:
+			kfree(copied);
 			goto bogusimode;
 		}
 		i_uid_write(inode, le32_to_cpu(die->i_uid));
@@ -117,7 +119,6 @@ static void *erofs_read_inode(struct erofs_buf *buf,
 			/* fill chunked inode summary info */
 			vi->chunkformat = le16_to_cpu(die->i_u.c.format);
 		kfree(copied);
-		copied = NULL;
 		break;
 	case EROFS_INODE_LAYOUT_COMPACT:
 		vi->inode_isize = sizeof(struct erofs_inode_compact);
@@ -197,7 +198,6 @@ static void *erofs_read_inode(struct erofs_buf *buf,
 	err = -EFSCORRUPTED;
 err_out:
 	DBG_BUGON(1);
-	kfree(copied);
 	erofs_put_metabuf(buf);
 	return ERR_PTR(err);
 }
-- 
2.39.2

