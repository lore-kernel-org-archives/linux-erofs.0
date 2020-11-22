Return-Path: <SRS0=Ko2R=E4=lists.ozlabs.org=linux-erofs-bounces+linux-erofs=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A49FEC5519F
	for <linux-erofs@archiver.kernel.org>; Sun, 22 Nov 2020 08:55:31 +0000 (UTC)
Received: from lists.ozlabs.org (lists.ozlabs.org [203.11.71.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 7334B2084C
	for <linux-erofs@archiver.kernel.org>; Sun, 22 Nov 2020 08:55:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=lists.ozlabs.org header.i=@lists.ozlabs.org header.b="mmjwFHsn";
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=aliyun.com header.i=@aliyun.com header.b="VX1r5/oJ"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7334B2084C
Authentication-Results: mail.kernel.org; dmarc=pass (p=none dis=none) header.from=lists.ozlabs.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Received: from bilbo.ozlabs.org (lists.ozlabs.org [IPv6:2401:3900:2:1::3])
	by lists.ozlabs.org (Postfix) with ESMTP id 4Cf3ym1QbMzDqZX
	for <linux-erofs@archiver.kernel.org>; Sun, 22 Nov 2020 19:55:28 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=lists.ozlabs.org;
	s=201707; t=1606035328;
	bh=FrqiybJ34a+YDWI59pSUJal2NJ46bAfvSU2DR+R8loo=;
	h=To:Subject:Date:In-Reply-To:References:List-Id:List-Unsubscribe:
	 List-Archive:List-Post:List-Help:List-Subscribe:From:Reply-To:
	 From;
	b=mmjwFHsnwuuM71YdtH3phLtZHKJNX04Wa1/IiYQAc5WfOZRnLarv0pfTM5tU55aCL
	 P8V1u+bxSBuerwCvDmgA1O9l6uYzI3v2gBDpzt4aITRXE95ZRp7TgYqnSj7vLPb21u
	 uzf8S10zgn5ngp6SM0vjyt2cOYu11j/lqfy1h00QbUlzalVtnfcuUqFEiaHuEGmY9W
	 U7M9KrDcWs7OdZy8OADDtiL3mu6HjKRzNHHGMqLElpHMNG4/HUiUD0b0k4fQbNP8G4
	 bsfKNXCRM4q5mZouv5ZeMSDwgaeoRR6/oyh91ehPcTGDcddUTsRKZVZC9qLQPypIbU
	 BsixMCQlVVJnQ==
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized)
 smtp.mailfrom=aliyun.com (client-ip=115.124.30.27;
 helo=out30-27.freemail.mail.aliyun.com; envelope-from=bluce.lee@aliyun.com;
 receiver=<UNKNOWN>)
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none)
 header.from=aliyun.com
Authentication-Results: lists.ozlabs.org; dkim=pass (1024-bit key;
 unprotected) header.d=aliyun.com header.i=@aliyun.com header.a=rsa-sha256
 header.s=s1024 header.b=VX1r5/oJ; dkim-atps=neutral
Received: from out30-27.freemail.mail.aliyun.com
 (out30-27.freemail.mail.aliyun.com [115.124.30.27])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by lists.ozlabs.org (Postfix) with ESMTPS id 4Cf3yX2sczzDqXr
 for <linux-erofs@lists.ozlabs.org>; Sun, 22 Nov 2020 19:55:15 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=aliyun.com; s=s1024;
 t=1606035307; h=From:To:Subject:Date:Message-Id;
 bh=MfVSJsMbFlMAIlOIs5rVY+yebELK/v2CfVRGBagG/jY=;
 b=VX1r5/oJJv5VKhlbPMnrJLVEE0MDJVvlCW9PEe2MawBseEgIyjw7KulvPJ832sluXAJyOWyrpOSgKIEsdrZwQWW/fW+hSySMpj+SmnK8tjXkTewFXLcCTAWA4EJGM+5bZQwtgh+x55i/UULpCdtbjz4G+l5fOaPFeAAF0N/kJ6o=
X-Alimail-AntiSpam: AC=CONTINUE; BC=0.08235136|-1; CH=green;
 DM=|CONTINUE|false|;
 DS=CONTINUE|ham_system_inform|0.0540586-0.000491844-0.94545;
 FP=0|0|0|0|0|-1|-1|-1; HT=e01e04395; MF=bluce.lee@aliyun.com; NM=1; PH=DS;
 RN=3; RT=3; SR=0; TI=SMTPD_---0UG7IzDE_1606035305; 
Received: from localhost(mailfrom:bluce.lee@aliyun.com
 fp:SMTPD_---0UG7IzDE_1606035305) by smtp.aliyun-inc.com(127.0.0.1);
 Sun, 22 Nov 2020 16:55:05 +0800
To: linux-erofs@lists.ozlabs.org
Subject: [PATCH v2] erofs-utils: stop build tree if file fails to open
Date: Sun, 22 Nov 2020 16:55:03 +0800
Message-Id: <20201122085503.35139-1-bluce.lee@aliyun.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201122042759.33623-1-bluce.lee@aliyun.com>
References: <20201122042759.33623-1-bluce.lee@aliyun.com>
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

stop and exit immediately if it fails to open a file, e.g mkfs.erofs
doesn't run under the root user (e.g. run without sudo.)

Signed-off-by: Li Guifu <bluce.lee@aliyun.com>
---
 lib/inode.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/lib/inode.c b/lib/inode.c
index fee5c96..eb2e0f2 100644
--- a/lib/inode.c
+++ b/lib/inode.c
@@ -908,7 +908,9 @@ struct erofs_inode *erofs_mkfs_build_tree(struct erofs_inode *dir)
 			if (ret)
 				return ERR_PTR(ret);
 		} else {
-			erofs_write_file(dir);
+			ret = erofs_write_file(dir);
+			if (ret)
+				return ERR_PTR(ret);
 		}
 
 		erofs_prepare_inode_buffer(dir);
@@ -982,10 +984,11 @@ struct erofs_inode *erofs_mkfs_build_tree(struct erofs_inode *dir)
 
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

