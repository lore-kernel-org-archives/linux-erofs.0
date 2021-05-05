Return-Path: <SRS0=fHce=KA=lists.ozlabs.org=linux-erofs-bounces+linux-erofs=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5316BC433B4
	for <linux-erofs@archiver.kernel.org>; Wed,  5 May 2021 14:26:36 +0000 (UTC)
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id ECE50613BC
	for <linux-erofs@archiver.kernel.org>; Wed,  5 May 2021 14:26:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org ECE50613BC
Authentication-Results: mail.kernel.org; dmarc=pass (p=none dis=none) header.from=lists.ozlabs.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Received: from boromir.ozlabs.org (localhost [IPv6:::1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4FZzY50qPFz2yyl
	for <linux-erofs@archiver.kernel.org>; Thu,  6 May 2021 00:26:33 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=lists.ozlabs.org;
	s=201707; t=1620224793;
	bh=EuFtD4gsBjBOSKdYiYPfre/V3YvrZWs1PHKVDO1TDXs=;
	h=To:Subject:Date:List-Id:List-Unsubscribe:List-Archive:List-Post:
	 List-Help:List-Subscribe:From:Reply-To:From;
	b=av0b5Sak3Ucx6BB7cn2eX2FVnVBoJiSY6kTclKwBglzd+Nj4MmtDTF/2zQ+3DRzcf
	 q+gZ/GdZmkLVGny53c3kup5xhFSsSKU35ZGDTuoi43ix06HkX7ZLBq9arKRV4Q4toh
	 NQEyikZRK5kT1fGCVqUXaAG3kqfJW4PFwX58XhijUm8WkX4w8cszrTTQWliqktjpbu
	 zHIFTx2x9sC5Ird0XjgdAi2/Iwo00MJY+E0B0ny5xxrNjsTJ3x6Vo1xkdfABtopCl9
	 NajK8byA6HktVVmGwkvpP7wOl+ZGC+rr3uWZL1ztfs7sU5x0Y1TrPnnp6BC05LpaKH
	 tpsZaajKGZI2Q==
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized)
 smtp.mailfrom=aliyun.com (client-ip=115.124.30.4;
 helo=out30-4.freemail.mail.aliyun.com; envelope-from=bluce.lee@aliyun.com;
 receiver=<UNKNOWN>)
Authentication-Results: lists.ozlabs.org; dkim=pass (1024-bit key;
 unprotected) header.d=aliyun.com header.i=@aliyun.com header.a=rsa-sha256
 header.s=s1024 header.b=UYe0cLSx; dkim-atps=neutral
Received: from out30-4.freemail.mail.aliyun.com
 (out30-4.freemail.mail.aliyun.com [115.124.30.4])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
 (No client certificate requested)
 by lists.ozlabs.org (Postfix) with ESMTPS id 4FZzY01FKtz2yqC
 for <linux-erofs@lists.ozlabs.org>; Thu,  6 May 2021 00:26:27 +1000 (AEST)
X-Alimail-AntiSpam: AC=CONTINUE; BC=0.1447586|-1; CH=green; DM=|CONTINUE|false|;
 DS=CONTINUE|ham_system_inform|0.31195-0.017242-0.670808; FP=0|0|0|0|0|-1|-1|-1;
 HT=e01e01424; MF=bluce.lee@aliyun.com; NM=1; PH=DS; RN=4; RT=4; SR=0;
 TI=SMTPD_---0UXoeVFy_1620224778; 
Received: from localhost(mailfrom:bluce.lee@aliyun.com
 fp:SMTPD_---0UXoeVFy_1620224778) by smtp.aliyun-inc.com(127.0.0.1);
 Wed, 05 May 2021 22:26:18 +0800
To: linux-erofs@lists.ozlabs.org
Subject: [PATCH v1 1/2] erofs-utils: add list_replace from linux kernel for
 dirs sorted later
Date: Wed,  5 May 2021 22:26:14 +0800
Message-Id: <20210505142615.38306-1-bluce.lee@aliyun.com>
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

A temp list head will be replaced to inode i_subdirs.

Signed-off-by: Li Guifu <bluce.lee@aliyun.com>
---
 include/erofs/list.h | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/include/erofs/list.h b/include/erofs/list.h
index 3572726..7238418 100644
--- a/include/erofs/list.h
+++ b/include/erofs/list.h
@@ -67,6 +67,22 @@ static inline int list_empty(struct list_head *head)
 	return head->next == head;
 }
 
+/**
+ * list_replace - replace old entry by new one
+ * @old : the element to be replaced
+ * @new : the new element to insert
+ *
+ * If @old was empty, it will be overwritten.
+ */
+static inline void list_replace(struct list_head *old,
+				struct list_head *new)
+{
+	new->next = old->next;
+	new->next->prev = new;
+	new->prev = old->prev;
+	new->prev->next = new;
+}
+
 #define list_entry(ptr, type, member) container_of(ptr, type, member)
 
 #define list_first_entry(ptr, type, member)                                    \
-- 
2.17.1

