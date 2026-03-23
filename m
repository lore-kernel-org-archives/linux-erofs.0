Return-Path: <linux-erofs+bounces-2946-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D24DBEC01A2
	for <linux-erofs@archiver.kernel.org>; Mon, 23 Mar 2026 07:55:53 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4ffQTN1t61z2yfs;
	Mon, 23 Mar 2026 18:55:52 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=95.143.211.150
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1774252552;
	cv=none; b=HoS2mNUSK0Zm3RwAPk3poAIgT422JogwmSbSfmuifUla1hKAI0EEhbv7rgTsJaz+94FU7gEMvXW4nea44bviW3qpG+473nybIFFiH5saaDJwp4g9lZKzvtJ/L+OBRgnLelwmHY7JQT9woj7f1kw1HGVP3N0R14+Dd6EOWkeOIl00elTDuLmPgd6gTFsxSTr6t3t4R2zoJfqtkLWxjaiPhqsxSLT2YLg4b/M0OEB0X9ipE9GPpjoasFx6mai+xcJTX5t3xSD3XOeiv6sT1Wz5aAMfOJ2KHyO/KtV0JaW+6ZgLwSVfRSy3yg2GmyeR9ff6vNOv9qplHEhmWif+PM18SQ==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1774252552; c=relaxed/relaxed;
	bh=MFw/vB8P7VLJD61eJATtRx37nqbkMe0J8+xFPuYrJvQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Qai0L5UqWoudRNeL8DqOOnF0EENtI1hn3q8vM5/ldlReUQV8Eakqc4eurwUN/OVXihaaAiROARFNq180H9mX14Ys0fsKQAo8F2bCar4OeBbMSQLNnXy8GiR/hsN9aYs4JYm4c80ARwBei+EEJxGMPr3OfSCPEyW0UYOlu6p65ibNaxD9t+eEmBbssvORfcSEll24jUGb49Im885tvW/z9xUXvwASxjGOXd7BFKEkuEJmVhx5cHR7F41fbRLmooJ1RrTVJrlfJZI14zTYLaOs8v1Ms927o5wlhi6bLK1vaz1FVRbJMWTlI52Kg81KO1qESYhOfXNkKwfXasyLE1f3GQ==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=swemel.ru; dkim=pass (1024-bit key; unprotected) header.d=swemel.ru header.i=@swemel.ru header.a=rsa-sha256 header.s=mail header.b=L4lneEn1; dkim-atps=neutral; spf=pass (client-ip=95.143.211.150; helo=mx.swemel.ru; envelope-from=arefev@swemel.ru; receiver=lists.ozlabs.org) smtp.mailfrom=swemel.ru
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=swemel.ru
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=swemel.ru header.i=@swemel.ru header.a=rsa-sha256 header.s=mail header.b=L4lneEn1;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=swemel.ru (client-ip=95.143.211.150; helo=mx.swemel.ru; envelope-from=arefev@swemel.ru; receiver=lists.ozlabs.org)
Received: from mx.swemel.ru (mx.swemel.ru [95.143.211.150])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4ffQTK1Rgjz2yfl
	for <linux-erofs@lists.ozlabs.org>; Mon, 23 Mar 2026 18:55:49 +1100 (AEDT)
From: Denis Arefev <arefev@swemel.ru>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=swemel.ru; s=mail;
	t=1774252090;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=MFw/vB8P7VLJD61eJATtRx37nqbkMe0J8+xFPuYrJvQ=;
	b=L4lneEn13a7wHcip66v1l2hXTXW+pN7j2AWRig9HY9F1A4XZFDV00ILPxqBos9TTRsjb5d
	Ewo2TErc7WIdziEvQjCh1J0iSjL/TAPavhBkMCc0WAP4XUQKd5tYAOjiQKjnWak3F+2ZTd
	BwHm4SA2zeeBMAy5NvK7tcN2DtRqkuQ=
To: stable@vger.kernel.org,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Gao Xiang <xiang@kernel.org>,
	Chao Yu <chao@kernel.org>,
	Yue Hu <huyue2@coolpad.com>,
	Jeffle Xu <jefflexu@linux.alibaba.com>,
	linux-erofs@lists.ozlabs.org,
	linux-kernel@vger.kernel.org,
	lvc-project@linuxtesting.org,
	Gao Xiang <hsiangkao@linux.alibaba.com>
Subject: [PATCH 6.1 1/1] erofs: enable large folios for iomap mode
Date: Mon, 23 Mar 2026 10:48:06 +0300
Message-ID: <20260323074809.4542-2-arefev@swemel.ru>
In-Reply-To: <20260323074809.4542-1-arefev@swemel.ru>
References: <20260323074809.4542-1-arefev@swemel.ru>
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

From: Jingbo Xu <jefflexu@linux.alibaba.com>                                                                               

commit ce529cc25b184e93397b94a8a322128fc0095cbb upstream. 

Enable large folios for iomap mode.  Then the readahead routine will
pass down large folios containing multiple pages.

Let's enable this for non-compressed format for now, until the
compression part supports large folios later.

When large folios supported, the iomap routine will allocate iomap_page
for each large folio and thus we need iomap_release_folio() and
iomap_invalidate_folio() to free iomap_page when these folios get
reclaimed or invalidated.

Signed-off-by: Jingbo Xu <jefflexu@linux.alibaba.com>
Reviewed-by: Gao Xiang <hsiangkao@linux.alibaba.com>
Reviewed-by: Chao Yu <chao@kernel.org>
Link: https://lore.kernel.org/r/20221130060455.44532-1-jefflexu@linux.alibaba.com
Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
Signed-off-by: Denis Arefev <arefev@swemel.ru>
---
Link: https://syzkaller.appspot.com/bug?id=c6aeabd0c4ad2466f63a274faf2a123103f8fbf7
---
 fs/erofs/data.c  | 2 ++
 fs/erofs/inode.c | 2 ++
 2 files changed, 4 insertions(+)

diff --git a/fs/erofs/data.c b/fs/erofs/data.c
index fe8ac0e163f7..c9526c627dda 100644
--- a/fs/erofs/data.c
+++ b/fs/erofs/data.c
@@ -403,6 +403,8 @@ const struct address_space_operations erofs_raw_access_aops = {
 	.readahead = erofs_readahead,
 	.bmap = erofs_bmap,
 	.direct_IO = noop_direct_IO,
+	.release_folio = iomap_release_folio,
+	.invalidate_folio = iomap_invalidate_folio,
 };
 
 #ifdef CONFIG_FS_DAX
diff --git a/fs/erofs/inode.c b/fs/erofs/inode.c
index ad2a82f2eb4c..e457b8a59ee7 100644
--- a/fs/erofs/inode.c
+++ b/fs/erofs/inode.c
@@ -295,6 +295,8 @@ static int erofs_fill_inode(struct inode *inode)
 		goto out_unlock;
 	}
 	inode->i_mapping->a_ops = &erofs_raw_access_aops;
+	if (!erofs_is_fscache_mode(inode->i_sb))
+		mapping_set_large_folios(inode->i_mapping);
 #ifdef CONFIG_EROFS_FS_ONDEMAND
 	if (erofs_is_fscache_mode(inode->i_sb))
 		inode->i_mapping->a_ops = &erofs_fscache_access_aops;
-- 
2.43.0


