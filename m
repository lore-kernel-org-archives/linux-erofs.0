Return-Path: <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9E435C4345F
	for <linux-erofs@archiver.kernel.org>; Mon, 15 Apr 2024 12:37:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=lists.ozlabs.org;
	s=201707; t=1713184620;
	bh=MUIz2WXcd1HYxzmp7vhIzFMOBXygnNNbAKk+U02jfs0=;
	h=To:Subject:Date:List-Id:List-Unsubscribe:List-Archive:List-Post:
	 List-Help:List-Subscribe:From:Reply-To:Cc:From;
	b=JeNxQl0WS4CFrv4wTi40hcoEi3JIHliKynQzidCmjr3GF8y73E4WIJ6P/Vtj0fbtP
	 9ngsDk5n9EIiiyQAbCTNWwNcdpcs/MlMUijCHcJzj5NcXn4aPfyIrBCvPXEDcaODas
	 jnHObug/3Rn9gYE0JGIV5Tb8ltjeTARNqus1JeVrEYXrixPKlJHcN+vDJVi9IocHwk
	 k8CW2JDTLtM9+gVxNxJkABoRxs5DY152LlkvKn1thxjYHAz1gi/NEccMuFuJ6C13iR
	 FapZJNqG1HWO5njoe8tvvUgjs/StkjLxDNMnrw/4YR8TPrWAWAJv0yEJZ05gROLCqe
	 j7s7eVDO25YFg==
Received: from boromir.ozlabs.org (localhost [IPv6:::1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4VJ6B41tKwz3dWV
	for <linux-erofs@archiver.kernel.org>; Mon, 15 Apr 2024 22:37:00 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=huawei.com (client-ip=45.249.212.191; helo=szxga05-in.huawei.com; envelope-from=libaokun1@huawei.com; receiver=lists.ozlabs.org)
X-Greylist: delayed 1167 seconds by postgrey-1.37 at boromir; Mon, 15 Apr 2024 22:36:49 AEST
Received: from szxga05-in.huawei.com (szxga05-in.huawei.com [45.249.212.191])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4VJ69s6Zrcz3d4F
	for <linux-erofs@lists.ozlabs.org>; Mon, 15 Apr 2024 22:36:49 +1000 (AEST)
Received: from mail.maildlp.com (unknown [172.19.163.44])
	by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4VJ5gr4LxTz1hwSk;
	Mon, 15 Apr 2024 20:14:16 +0800 (CST)
Received: from dggpeml500021.china.huawei.com (unknown [7.185.36.21])
	by mail.maildlp.com (Postfix) with ESMTPS id C694014011F;
	Mon, 15 Apr 2024 20:17:12 +0800 (CST)
Received: from huawei.com (10.175.127.227) by dggpeml500021.china.huawei.com
 (7.185.36.21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.35; Mon, 15 Apr
 2024 20:17:12 +0800
To: <linux-erofs@lists.ozlabs.org>
Subject: [PATCH] erofs: set SB_NODEV sb_flags when mounting with fsid
Date: Mon, 15 Apr 2024 20:17:46 +0800
Message-ID: <20240415121746.1207242-1-libaokun1@huawei.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.175.127.227]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggpeml500021.china.huawei.com (7.185.36.21)
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
From: Baokun Li via Linux-erofs <linux-erofs@lists.ozlabs.org>
Reply-To: Baokun Li <libaokun1@huawei.com>
Cc: brauner@kernel.org, yangerkun@huawei.com, linux-kernel@vger.kernel.org, huyue2@coolpad.com, viro@zeniv.linux.org.uk
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs" <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>

When erofs_kill_sb() is called in block dev based mode, s_bdev may not have
been initialised yet, and if CONFIG_EROFS_FS_ONDEMAND is enabled, it will
be mistaken for fscache mode, and then attempt to free an anon_dev that has
never been allocated, triggering the following warning:

============================================
ida_free called for id=0 which is not allocated.
WARNING: CPU: 14 PID: 926 at lib/idr.c:525 ida_free+0x134/0x140
Modules linked in:
CPU: 14 PID: 926 Comm: mount Not tainted 6.9.0-rc3-dirty #630
RIP: 0010:ida_free+0x134/0x140
Call Trace:
 <TASK>
 erofs_kill_sb+0x81/0x90
 deactivate_locked_super+0x35/0x80
 get_tree_bdev+0x136/0x1e0
 vfs_get_tree+0x2c/0xf0
 do_new_mount+0x190/0x2f0
 [...]
============================================

To avoid this problem, add SB_NODEV to fc->sb_flags after successfully
parsing the fsid, and then the superblock inherits this flag when it is
allocated, so that the sb_flags can be used to distinguish whether it is
in block dev based mode when calling erofs_kill_sb().

Signed-off-by: Baokun Li <libaokun1@huawei.com>
---
 fs/erofs/super.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/fs/erofs/super.c b/fs/erofs/super.c
index b21bd8f78dc1..7539ce7d64bc 100644
--- a/fs/erofs/super.c
+++ b/fs/erofs/super.c
@@ -520,6 +520,7 @@ static int erofs_fc_parse_param(struct fs_context *fc,
 		ctx->fsid = kstrdup(param->string, GFP_KERNEL);
 		if (!ctx->fsid)
 			return -ENOMEM;
+		fc->sb_flags |= SB_NODEV;
 		break;
 	case Opt_domain_id:
 		kfree(ctx->domain_id);
@@ -706,9 +707,7 @@ static int erofs_fc_fill_super(struct super_block *sb, struct fs_context *fc)
 
 static int erofs_fc_get_tree(struct fs_context *fc)
 {
-	struct erofs_fs_context *ctx = fc->fs_private;
-
-	if (IS_ENABLED(CONFIG_EROFS_FS_ONDEMAND) && ctx->fsid)
+	if (fc->sb_flags & SB_NODEV)
 		return get_tree_nodev(fc, erofs_fc_fill_super);
 
 	return get_tree_bdev(fc, erofs_fc_fill_super);
@@ -801,7 +800,7 @@ static void erofs_kill_sb(struct super_block *sb)
 {
 	struct erofs_sb_info *sbi;
 
-	if (erofs_is_fscache_mode(sb))
+	if (sb->s_flags & SB_NODEV)
 		kill_anon_super(sb);
 	else
 		kill_block_super(sb);
-- 
2.31.1

