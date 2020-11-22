Return-Path: <SRS0=Ko2R=E4=lists.ozlabs.org=linux-erofs-bounces+linux-erofs=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E35FC56201
	for <linux-erofs@archiver.kernel.org>; Sun, 22 Nov 2020 04:28:32 +0000 (UTC)
Received: from lists.ozlabs.org (lists.ozlabs.org [203.11.71.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 1C4452078D
	for <linux-erofs@archiver.kernel.org>; Sun, 22 Nov 2020 04:28:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=lists.ozlabs.org header.i=@lists.ozlabs.org header.b="mMDkTdMe";
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=aliyun.com header.i=@aliyun.com header.b="EP0HZ5u9"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1C4452078D
Authentication-Results: mail.kernel.org; dmarc=pass (p=none dis=none) header.from=lists.ozlabs.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Received: from bilbo.ozlabs.org (lists.ozlabs.org [IPv6:2401:3900:2:1::3])
	by lists.ozlabs.org (Postfix) with ESMTP id 4Cdy2h5ZKczDqbh
	for <linux-erofs@archiver.kernel.org>; Sun, 22 Nov 2020 15:28:28 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=lists.ozlabs.org;
	s=201707; t=1606019308;
	bh=vxaVR6FXbExa9wveYiHFlmQdW3MsYeP09exzKPW53z4=;
	h=To:Subject:Date:List-Id:List-Unsubscribe:List-Archive:List-Post:
	 List-Help:List-Subscribe:From:Reply-To:From;
	b=mMDkTdMe6m1s1gCkn9ms8tgktEb20RmLhyGHiwA+9EMinj9Bhq2X75/WYEAZtLv5c
	 ggD4u/HLaaaQgyG8FI7wAmHEl6X6t0KNYwwv9HqSJaG1J7quewbLJz+YcNwtp5zjHL
	 RF1UP8o3jhECbdfE0bNQg7+5QyBQk94bveyoitcZSQO9qhN9KXd1b4MWRJCQci99Iw
	 qcXWyWLoeXUtuPY9b0WlIkm3hSuHGinqbB7n5LesbIjbEq5WMq/JcXFg/kMNShJZF9
	 bG1NMyZzJRcXRgO1bHoY+UYIb4gPJzTo4lpL7d7rrTgJmVP1OyCJvp0FtbJqi+qDuA
	 lABCoHYKf3uLQ==
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized)
 smtp.mailfrom=aliyun.com (client-ip=115.124.30.40;
 helo=out30-40.freemail.mail.aliyun.com; envelope-from=bluce.lee@aliyun.com;
 receiver=<UNKNOWN>)
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none)
 header.from=aliyun.com
Authentication-Results: lists.ozlabs.org; dkim=pass (1024-bit key;
 unprotected) header.d=aliyun.com header.i=@aliyun.com header.a=rsa-sha256
 header.s=s1024 header.b=EP0HZ5u9; dkim-atps=neutral
Received: from out30-40.freemail.mail.aliyun.com
 (out30-40.freemail.mail.aliyun.com [115.124.30.40])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by lists.ozlabs.org (Postfix) with ESMTPS id 4Cdy2V29RrzDqWl
 for <linux-erofs@lists.ozlabs.org>; Sun, 22 Nov 2020 15:28:14 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=aliyun.com; s=s1024;
 t=1606019287; h=From:To:Subject:Date:Message-Id;
 bh=LUT2Twj3YUzzlXEycq5TjMg8uHRSSjbsHUDePLlFGxs=;
 b=EP0HZ5u98t330tv9+KHId8XGUmLZX0YO3Fp7SUCbMEhV/q3AT16oSyiaA5Z/de7Rabqvq1avc3ud31E8+iCzz1nfsFvgBDtEuOmstRgaGAwftJMjW3SUqXqXKPFJ9DM9lNLrpzPUxW7NOIL4p9T5RP7HvvFO5ljf1HT/uS24ewM=
X-Alimail-AntiSpam: AC=CONTINUE; BC=0.08646268|-1; CH=green;
 DM=|CONTINUE|false|; DS=CONTINUE|ham_alarm|0.00497426-0.000231295-0.994794;
 FP=0|0|0|0|0|-1|-1|-1; HT=e01e04420; MF=bluce.lee@aliyun.com; NM=1; PH=DS;
 RN=3; RT=3; SR=0; TI=SMTPD_---0UG614zv_1606019286; 
Received: from localhost(mailfrom:bluce.lee@aliyun.com
 fp:SMTPD_---0UG614zv_1606019286) by smtp.aliyun-inc.com(127.0.0.1);
 Sun, 22 Nov 2020 12:28:06 +0800
To: linux-erofs@lists.ozlabs.org
Subject: [PATCH] erofs-utils: stop mkfs when access permission denied
Date: Sun, 22 Nov 2020 12:27:59 +0800
Message-Id: <20201122042759.33623-1-bluce.lee@aliyun.com>
X-Mailer: git-send-email 2.17.1
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
From: Li Guifu via Linux-erofs <linux-erofs@lists.ozlabs.org>
Reply-To: Li Guifu <bluce.lee@aliyun.com>
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs"
 <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>

It would not has the permission to access one file when mkfs.erofs
was not run in the root mode, eg run without sudo, So stop and
exit immediately

Signed-off-by: Li Guifu <bluce.lee@aliyun.com>
---
 lib/inode.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/lib/inode.c b/lib/inode.c
index fee5c96..4641561 100644
--- a/lib/inode.c
+++ b/lib/inode.c
@@ -364,6 +364,7 @@ int erofs_write_file(struct erofs_inode *inode)
 	}
 
 	/* fallback to all data uncompressed */
+	errno = 0;
 	fd = open(inode->i_srcpath, O_RDONLY | O_BINARY);
 	if (fd < 0)
 		return -errno;
@@ -908,7 +909,9 @@ struct erofs_inode *erofs_mkfs_build_tree(struct erofs_inode *dir)
 			if (ret)
 				return ERR_PTR(ret);
 		} else {
-			erofs_write_file(dir);
+			ret = erofs_write_file(dir);
+			if (ret)
+				return ERR_PTR(ret);
 		}
 
 		erofs_prepare_inode_buffer(dir);
@@ -982,10 +985,11 @@ struct erofs_inode *erofs_mkfs_build_tree(struct erofs_inode *dir)
 
 		d->inode = erofs_mkfs_build_tree_from_path(dir, buf);
 		if (IS_ERR(d->inode)) {
+			ret = PTR_ERR(d->inode);
 fail:
 			d->inode = NULL;
 			d->type = EROFS_FT_UNKNOWN;
-			continue;
+			goto err_closedir;
 		}
 
 		d->type = erofs_type_by_mode[d->inode->i_mode >> S_SHIFT];
-- 
2.17.1

