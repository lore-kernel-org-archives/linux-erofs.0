Return-Path: <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0D75BC433F5
	for <linux-erofs@archiver.kernel.org>; Tue, 21 Dec 2021 14:28:49 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [IPv6:::1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4JJJjW2pPlz2yp0
	for <linux-erofs@archiver.kernel.org>; Wed, 22 Dec 2021 01:28:47 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=lists.ozlabs.org;
	s=201707; t=1640096927;
	bh=8R/YZNx5T0lGVJ/lTtulFUVMJuZmEza15lfVi4DdwHM=;
	h=Date:Subject:To:List-Id:List-Unsubscribe:List-Archive:List-Post:
	 List-Help:List-Subscribe:From:Reply-To:Cc:From;
	b=HPxpoWfev6ARHYT7RE1JbG0yyEkL+47OJTLE3vhjfLsPgSkf54KGTyFL5T81kC5Bb
	 lgUQdL3oMX2O0XmZ+5tLE5dG6zzhgB82690lJHHYjZocGaXpVrffz9aX+j9T0j1LdW
	 LLlPYxna490Mkk5m+HB8SoMQfJWjNmDin8kWE2pIIRzDfGCglgLTgxwkQYenXSwvyO
	 DyH32lDLtCECS/Io4PVS9BdfhtPL+LBoBCy9t64MSMkDsNEUF5oA5ZxsMtD1a7F+sl
	 y7jBVrgaPoLsXGW5sbFWvCvzJGomN7c7q47+L4kmyF0AvrCdoVXYJeJcoEA93fB0vf
	 prMeJse7FhwOQ==
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized)
 smtp.mailfrom=flex--zhangkelvin.bounces.google.com
 (client-ip=2607:f8b0:4864:20::a49; helo=mail-vk1-xa49.google.com;
 envelope-from=3ketbyqskc3ytbuhaeyfpchaiiafy.wigfchor-ylizmfcmnm.itfuvm.ila@flex--zhangkelvin.bounces.google.com;
 receiver=<UNKNOWN>)
Authentication-Results: lists.ozlabs.org; dkim=pass (2048-bit key;
 unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256
 header.s=20210112 header.b=TUMxsUvw; dkim-atps=neutral
Received: from mail-vk1-xa49.google.com (mail-vk1-xa49.google.com
 [IPv6:2607:f8b0:4864:20::a49])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
 (No client certificate requested)
 by lists.ozlabs.org (Postfix) with ESMTPS id 4JJJjN47vcz2xsj
 for <linux-erofs@lists.ozlabs.org>; Wed, 22 Dec 2021 01:28:39 +1100 (AEDT)
Received: by mail-vk1-xa49.google.com with SMTP id
 g4-20020ac5c1c4000000b00312a2a1de20so2413984vkk.12
 for <linux-erofs@lists.ozlabs.org>; Tue, 21 Dec 2021 06:28:39 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
 bh=8R/YZNx5T0lGVJ/lTtulFUVMJuZmEza15lfVi4DdwHM=;
 b=bNkMOXtmbCrBN0qTcfRUluqXS61n0rjd6PQ0Q9cT2+/yj0dkYCsPY0rzifmK9rGvet
 27qAfuokSNZ3lthzgeWbGe989H58NTahtpEtyEj1pkhW5nWlKffHGIVVx8Dkj/tbTedD
 YQGujw95dAiVFcU7WCD2hOHcZeV3+6s07oAbVAXV1ElpE1yYYuEbz804eeyY225LdQ0y
 dQSO5L+EfWK2JLKpki7sjCFPScIGSZS6erO/ImSuf5Y4eabTXRsv5ngi1sapKqauJmPy
 V8RdgKJca58RxhMENsRTAP0RM9F9PPByreJBvKL8ASOF2KBtRhSL8NPEbzM788eusVbG
 hl1Q==
X-Gm-Message-State: AOAM5337OSpLSFBAIx5jkBCDxmSQWap6qx+BvITMKGEmUJWEQt0u+jt+
 vLwTFywq50MyPW4rIsnP+nu9wVGBGia0Q4rhkLPnGqEbJjv63KkIGZP9Kg6LMPN8wpadyaXg+7P
 ImaSIhXwlzA/kzMxp0xm/fhQc7jGbXcM9wSqUCAgjqziq2vwAD65jdL4Ho1tJKTuJBxC61+9jMX
 9+eVeoW0g=
X-Google-Smtp-Source: ABdhPJxYZ/AG6IdrENotBMq3aJhMKQrFgwmjP7QyT/mAFfxW35qv87Qxv4h58y0KmK0tSWJua1/5EvF4eGi7hsDlkA==
X-Received: from zhangkelvin-big.c.googlers.com
 ([fda3:e722:ac3:cc00:14:4d90:c0a8:1f4a])
 (user=zhangkelvin job=sendgmr) by 2002:a05:6122:50e:: with SMTP id
 x14mr1339573vko.7.1640096913683; Tue, 21 Dec 2021 06:28:33 -0800 (PST)
Date: Tue, 21 Dec 2021 06:28:28 -0800
Message-Id: <20211221142829.4123631-1-zhangkelvin@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.34.1.307.g9b7440fafd-goog
Subject: [PATCH v1 1/2] Add some comments about const-ness around iterate API
To: linux-erofs mailing list <linux-erofs@lists.ozlabs.org>,
 Miao Xie <miaoxie@huawei.com>, Fang Wei <fangwei1@huawei.com>
Content-Type: text/plain; charset="UTF-8"
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
From: Kelvin Zhang via Linux-erofs <linux-erofs@lists.ozlabs.org>
Reply-To: Kelvin Zhang <zhangkelvin@google.com>
Cc: Kelvin Zhang <zhangkelvin@google.com>
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs"
 <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>

Change-Id: I297a56ba14a37ef5eced95330a5b09109378ca44
Signed-off-by: Kelvin Zhang <zhangkelvin@google.com>
---
 include/erofs/dir.h | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/include/erofs/dir.h b/include/erofs/dir.h
index 77656ca..59bd40d 100644
--- a/include/erofs/dir.h
+++ b/include/erofs/dir.h
@@ -39,6 +39,14 @@ typedef int (*erofs_readdir_cb)(struct erofs_dir_context *);
  * the callback context. |de_namelen| is the exact dirent name length.
  */
 struct erofs_dir_context {
+	/* During execution of |erofs_iterate_dir|, the function needs
+	 * to read the values inside |erofs_inode* dir|. So it is important
+	 * that the callback function does not modify stuct pointed by
+	 * |dir|. It is OK to repoint |dir| to other objects.
+	 * Unfortunately, it's not possible to enforce this restriction
+	 * with const keyword, as |erofs_iterate_dir| needs to modify
+	 * struct pointed by |dir|.
+	 */
 	struct erofs_inode *dir;
 	erofs_readdir_cb cb;
 	erofs_nid_t pnid;		/* optional */
-- 
2.34.1.307.g9b7440fafd-goog

