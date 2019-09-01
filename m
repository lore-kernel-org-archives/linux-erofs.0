Return-Path: <SRS0=Lz2Y=W4=lists.ozlabs.org=linux-erofs-bounces+linux-erofs=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8336BC3A5A4
	for <linux-erofs@archiver.kernel.org>; Sun,  1 Sep 2019 05:52:46 +0000 (UTC)
Received: from lists.ozlabs.org (lists.ozlabs.org [203.11.71.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 02B4321897
	for <linux-erofs@archiver.kernel.org>; Sun,  1 Sep 2019 05:52:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=lists.ozlabs.org header.i=@lists.ozlabs.org header.b="Rxm5KHSV";
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=aol.com header.i=@aol.com header.b="epnKajy9"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 02B4321897
Authentication-Results: mail.kernel.org; dmarc=pass (p=none dis=none) header.from=lists.ozlabs.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Received: from bilbo.ozlabs.org (lists.ozlabs.org [IPv6:2401:3900:2:1::3])
	by lists.ozlabs.org (Postfix) with ESMTP id 46Lj6h0fC2zDqsd
	for <linux-erofs@archiver.kernel.org>; Sun,  1 Sep 2019 15:52:44 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=lists.ozlabs.org;
	s=201707; t=1567317164;
	bh=3m0mJSwuysJlz1PAPPoDPsU9G922+k4e0kWqvHSc8Tg=;
	h=To:Subject:Date:In-Reply-To:References:List-Id:List-Unsubscribe:
	 List-Archive:List-Post:List-Help:List-Subscribe:From:Reply-To:Cc:
	 From;
	b=Rxm5KHSVvs6jw4B/v8mjItq+/CR9g1k9/FRvQ/4T7IDjP1m0XlR5Gy8pZylmeGB2s
	 qMD5XB0Yyf22wbMLaJrOcCYEV3wF2RrC/DgI9kdoWZ3yoB1a1ioqtYyoOIWpkfpg3x
	 gnxlYrmuSTOvqBYyIl5kbGXV121KUocwj0l1OQWmHk92QjurxRJVZZgpYjgYSkG7no
	 iCunEzocBUoqTvK057QLw/Lxgd3w+Az58PQtB0t5EZxprfSifllSu8ppo3Mh+0hMcw
	 h4POFuADbikTLDHzKFeYCOfDi0xDwagkhlESQg2zr6I9ArvoCVREvtUdx6L9+a4QCW
	 E0hNQjr3nZs/w==
Authentication-Results: lists.ozlabs.org;
 spf=pass (mailfrom) smtp.mailfrom=aol.com
 (client-ip=98.137.69.206; helo=sonic312-25.consmr.mail.gq1.yahoo.com;
 envelope-from=hsiangkao@aol.com; receiver=<UNKNOWN>)
Authentication-Results: lists.ozlabs.org;
 dmarc=pass (p=reject dis=none) header.from=aol.com
Authentication-Results: lists.ozlabs.org; dkim=pass (2048-bit key;
 unprotected) header.d=aol.com header.i=@aol.com header.b="epnKajy9"; 
 dkim-atps=neutral
Received: from sonic312-25.consmr.mail.gq1.yahoo.com
 (sonic312-25.consmr.mail.gq1.yahoo.com [98.137.69.206])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by lists.ozlabs.org (Postfix) with ESMTPS id 46Lj6H3938zDqvT
 for <linux-erofs@lists.ozlabs.org>; Sun,  1 Sep 2019 15:52:22 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=aol.com; s=a2048;
 t=1567317139; bh=1sQb/tNo0p576X+fPV8AoiHAB+gWz10qYr1i4knfAXg=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From:Subject;
 b=epnKajy9YyLjCSb0/7QBK5ApfcqBh168Hugbn6iuTCGH7fCblWDDEZ4ixRF75YcAdYQxSwHhEuH/mm672xwy/SM3YDzyE1orKrJCD8Sg6Il6L7j/7zX+mj4qBxpudF1F6Zl9nMRkLrXgYReNciUMBmaYFLunfUcNTdXTkEaSUTUDEdCKSvvjWwCRFku3HqSXpyBb9COoKRlWL5FZOOA++Aw38TgUKpKQmPYmZqP1i40PQ5Fz60ImNEv15G5KJ6xET+qyQ7AFPzG/jkNalto0CneXSqrRrhEtazy7Do7jxlCF7YrxRt/+wBJHqPi3M+bocL9VqeCvAWlQUOto8jphLg==
X-YMail-OSG: VxWNJpIVM1m9Ishr394dGrKLkvR0JqLF5BGY9R4FFEVN.OPh3QAETuIlYNDpKva
 3wqCm38zimTkFwOGygzFznmZrNchRSVcZuSLE72owLJ15c3kIToVTRLNdIIPrVWF.LMjMi2bq9nE
 OF49PpyDYh8T0pDt3suD8fAxKF7VEwGLitAuy.2KlcYSc.tSr4wTODbY09jlCEYsWN6YZ5DShqiI
 .wnDwHlXnMBtdy5N6dOGN8D1XUIxzWXmxl_5bgBIAIWiA55NVrrNQCyxVWmsB2mIcatFYXvgIlqW
 r3NuYKOHaRp.lb1KO.3..tICl.8v.7YAw3DDrh10eMijJBsBgBc_5gAqHZPwzYH_Xq.5Ch.5Y7JT
 HaYE6CUltYdFwtPfzF6e4Avs4hdPZAtZOqTbAHb9ehJ6tZ09pDdaTnBZriRcSrZF0hV4KzsijLwh
 9mi6GHExpPzrsO.P5ck3eefJmMvi3ceHIgP03WyE6XVrrwUAjZUmSGWXnfAo0q5IPkB2IS6L5.OV
 e5JBwTDruYePteFxuE6YfxW9xkgrnbCqvRAbsqMN7mesjBhl9nCsULon0W6O9wMt1Bgr9DlaYK.h
 OEvvJCesHtpOLltIsOBgnjDo7l1TSPYN1JP31jFKd3t0V5gKXR3zZnlDUyEswpSobPTuTiSXFZ5x
 04h415X4N.WnchccGLRji9dcDI_mKhqPoZra.A2rNmYytbYAtKoBGe8IVwKfx9jNogfDcp78UOyl
 IOvSALLuMBtwAyEGMFLjkaEM1N6b5UXfFxXGEEv4f0CuuSzZ5TvdIc1O3Ouxj3c2WXsij0tqGy.s
 HMVtbQtvCaRYvjOaNK6l1Lnu7J.1CiGnWzlZ6sa3Pn__X4RoPL1CnmEwTO9O0co5S7HYLw1hNr3n
 KWiR5LVxf0BElLt4uB0BjSVRPXygOIGsamOq5EmjU3_ubwHW2BWP_yNAJW_w72ZxIrchm0T1E3_u
 whoYvq4M5O_8YZ31FoJrlWaYzk4S6RueZDVJFcZr59jBklrVY2c7NgodSCukpfd3Jg_EP1og0iIU
 v3sjhOP730gu5fSUiLBnnn74g87cFYvorEjEbeAwwDNalV6EXocmC2xGuuv_jZsXy56cIYJpLvUG
 QP1X1.RZYMXMd.eVDoFhJMmEi0wd6bYNwdvX9Fq20apmYKVHzOIfAFfQxMJpvsTLAvYtelBgoLbP
 YWuM2.QGk0cn7kGCYJg2crCZ6GGORlhgyyYSX9SL3Xu4WTIGXygPyzLUYrV2bwADPMSIGP3qisJV
 sKjATMj8plQBWB2hxc3aS5__P8ayabvKwdvwIcrOlfA--
Received: from sonic.gate.mail.ne1.yahoo.com by
 sonic312.consmr.mail.gq1.yahoo.com with HTTP; Sun, 1 Sep 2019 05:52:19 +0000
Received: by smtp406.mail.gq1.yahoo.com (Oath Hermes SMTP Server) with ESMTPA
 ID 426e3b5ec1af9e36f409445c51071a70; 
 Sun, 01 Sep 2019 05:52:18 +0000 (UTC)
To: Christoph Hellwig <hch@infradead.org>, Chao Yu <yuchao0@huawei.com>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 06/21] erofs: kill erofs_{init,exit}_inode_cache
Date: Sun,  1 Sep 2019 13:51:15 +0800
Message-Id: <20190901055130.30572-7-hsiangkao@aol.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190901055130.30572-1-hsiangkao@aol.com>
References: <20190802125347.166018-1-gaoxiang25@huawei.com>
 <20190901055130.30572-1-hsiangkao@aol.com>
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
From: Gao Xiang via Linux-erofs <linux-erofs@lists.ozlabs.org>
Reply-To: Gao Xiang <hsiangkao@aol.com>
Cc: linux-fsdevel@vger.kernel.org, devel@driverdev.osuosl.org,
 linux-erofs@lists.ozlabs.org
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs"
 <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>

From: Gao Xiang <gaoxiang25@huawei.com>

As Christoph said [1] "having this function seems
entirely pointless", let's kill those.

filesystem                              function name
ext2,f2fs,ext4,isofs,squashfs,cifs,...  init_inodecache

In addition, add a necessary "rcu_barrier()" on exit_fs();

[1] https://lore.kernel.org/r/20190829101545.GC20598@infradead.org/
Reported-by: Christoph Hellwig <hch@infradead.org>
Signed-off-by: Gao Xiang <gaoxiang25@huawei.com>
---
 fs/erofs/super.c | 31 ++++++++++++-------------------
 1 file changed, 12 insertions(+), 19 deletions(-)

diff --git a/fs/erofs/super.c b/fs/erofs/super.c
index 6603f0ba8905..0c412de33315 100644
--- a/fs/erofs/super.c
+++ b/fs/erofs/super.c
@@ -23,21 +23,6 @@ static void init_once(void *ptr)
 	inode_init_once(&vi->vfs_inode);
 }
 
-static int __init erofs_init_inode_cache(void)
-{
-	erofs_inode_cachep = kmem_cache_create("erofs_inode",
-					       sizeof(struct erofs_vnode), 0,
-					       SLAB_RECLAIM_ACCOUNT,
-					       init_once);
-
-	return erofs_inode_cachep ? 0 : -ENOMEM;
-}
-
-static void erofs_exit_inode_cache(void)
-{
-	kmem_cache_destroy(erofs_inode_cachep);
-}
-
 static struct inode *alloc_inode(struct super_block *sb)
 {
 	struct erofs_vnode *vi =
@@ -531,9 +516,14 @@ static int __init erofs_module_init(void)
 	erofs_check_ondisk_layout_definitions();
 	infoln("initializing erofs " EROFS_VERSION);
 
-	err = erofs_init_inode_cache();
-	if (err)
+	erofs_inode_cachep = kmem_cache_create("erofs_inode",
+					       sizeof(struct erofs_vnode), 0,
+					       SLAB_RECLAIM_ACCOUNT,
+					       init_once);
+	if (!erofs_inode_cachep) {
+		err = -ENOMEM;
 		goto icache_err;
+	}
 
 	err = erofs_init_shrinker();
 	if (err)
@@ -555,7 +545,7 @@ static int __init erofs_module_init(void)
 zip_err:
 	erofs_exit_shrinker();
 shrinker_err:
-	erofs_exit_inode_cache();
+	kmem_cache_destroy(erofs_inode_cachep);
 icache_err:
 	return err;
 }
@@ -565,7 +555,10 @@ static void __exit erofs_module_exit(void)
 	unregister_filesystem(&erofs_fs_type);
 	z_erofs_exit_zip_subsystem();
 	erofs_exit_shrinker();
-	erofs_exit_inode_cache();
+
+	/* Ensure all RCU free inodes are safe before cache is destroyed. */
+	rcu_barrier();
+	kmem_cache_destroy(erofs_inode_cachep);
 	infoln("successfully finalize erofs");
 }
 
-- 
2.17.1

