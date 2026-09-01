Return-Path: <linux-erofs+bounces-4397-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 83ED8C61DFD
	for <linux-erofs@archiver.kernel.org>; Tue,  1 Sep 2026 02:46:38 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hYqxm1JbKz2yCv;
	Tue, 01 Sep 2026 12:46:36 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=115.124.30.100
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1788230796;
	cv=none; b=hJMzdMxrMczKjUQ69i5B9MLadE1QDbOUuu9JWjRR1KRujP6XIOlaCYVJC7JA47H0Z9Mpx8Iv8iJeISpeFisuyX4kWRyt8hqZACI25eKTqQHOaIFMSSSYtUySTxDADElDjeyxxfzBAAMN5B4RNkOnzKVPqLwW3K1f1Po1W/7zaJkSSBNFB3b9GrxutsCrll0rcv1dzOONDCQm8OBGBThSrTjwjCNREtLqlqIadvlFbpLaLXEq2LxlmhOqUZKLVpJINGr9x+SQQiNOgMpau6V59lzrzowtCumcbQfiMhdN4U84PaTBjKlhQl06OYj3OvRPWMBUM1NEIPo05IYUswkjYg==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1788230796; c=relaxed/relaxed;
	bh=IyaV4kBdlXf7cBkSle+mYaQW1tk/WVCgk/l7xdb2q8w=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=IeUn1aZh5QoWGDFxJmEsS7mOX0GmegKlIg5oKVBOGMGIG6WPG8S7IOsVuV43H97zJqqmhehFSNPhiMC67Io3YpTls/RJYrLzrHPBO0Lxpb7JuyA3fsQzi/qYK72OJBWa8/2DEXJqFuOcQ3KNVHZwYkTzWS0zvmVTZOvQxzNz4R5jgIEK/mcJGBDOgfMfMWveBS/P/Aob3k8u9pyjGcpnCWXrcEwGYZgoY3jGtjQ88/cKTLewCsvceeqto8FQjltXwlyPJSsrcoJ11V4Zya1PLzxZ1hsumZdCq/cLnd7ovROqqkLyst5v5X/4hHCQ6OmFXUxZZ/Du9LY5vB3n51sy+w==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=YK30FSwW; dkim-atps=neutral; spf=pass (client-ip=115.124.30.100; helo=out30-100.freemail.mail.aliyun.com; envelope-from=jefflexu@linux.alibaba.com; receiver=lists.ozlabs.org) smtp.mailfrom=linux.alibaba.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=YK30FSwW;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=linux.alibaba.com (client-ip=115.124.30.100; helo=out30-100.freemail.mail.aliyun.com; envelope-from=jefflexu@linux.alibaba.com; receiver=lists.ozlabs.org)
Received: from out30-100.freemail.mail.aliyun.com (out30-100.freemail.mail.aliyun.com [115.124.30.100])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hYqxj13mTz2xpn
	for <linux-erofs@lists.ozlabs.org>; Tue, 01 Sep 2026 12:46:30 +1000 (AEST)
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1788230784; h=From:To:Subject:Date:Message-Id:MIME-Version;
	bh=IyaV4kBdlXf7cBkSle+mYaQW1tk/WVCgk/l7xdb2q8w=;
	b=YK30FSwW5sgQ6KHWS+pnZre4DJP6Q9P4rmFiK1TzoYGweRG14OZef+up6knJoRsJWZTNbdipeSs4+CTz0h4gJyYHTnD+No+vQsGe4tQw8brETUD7BejS5wUgepqM+ZkSuhWpVKAaG3RxPsBlNjhI0ULhRSokdhMfHeTDg1NR8Is=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R721e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam011083073210;MF=jefflexu@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0XA1RXuA_1788230782;
Received: from localhost(mailfrom:jefflexu@linux.alibaba.com fp:SMTPD_---0XA1RXuA_1788230782 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 01 Sep 2026 10:46:22 +0800
From: Jingbo Xu <jefflexu@linux.alibaba.com>
To: xiang@kernel.org,
	chao@kernel.org,
	linux-erofs@lists.ozlabs.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] erofs: add sysfs feature entry for xattr prefixes
Date: Tue,  1 Sep 2026 10:46:22 +0800
Message-Id: <20260901024622.108319-1-jefflexu@linux.alibaba.com>
X-Mailer: git-send-email 2.19.1.6.gb485710b
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

Let /sys/fs/erofs/features/xattr_prefixes advertise that this kernel
supports the EROFS_FEATURE_INCOMPAT_XATTR_PREFIXES on-disk format.

Signed-off-by: Jingbo Xu <jefflexu@linux.alibaba.com>
---
 fs/erofs/sysfs.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/erofs/sysfs.c b/fs/erofs/sysfs.c
index 6734483a440f..dfcec9376cd5 100644
--- a/fs/erofs/sysfs.c
+++ b/fs/erofs/sysfs.c
@@ -95,6 +95,7 @@ EROFS_ATTR_FEATURE(sb_chksum);
 EROFS_ATTR_FEATURE(ztailpacking);
 EROFS_ATTR_FEATURE(fragments);
 EROFS_ATTR_FEATURE(dedupe);
+EROFS_ATTR_FEATURE(xattr_prefixes);
 EROFS_ATTR_FEATURE(48bit);
 EROFS_ATTR_FEATURE(metabox);
 
@@ -108,6 +109,7 @@ static struct attribute *erofs_feat_attrs[] = {
 	ATTR_LIST(ztailpacking),
 	ATTR_LIST(fragments),
 	ATTR_LIST(dedupe),
+	ATTR_LIST(xattr_prefixes),
 	ATTR_LIST(48bit),
 	ATTR_LIST(metabox),
 	NULL,
-- 
2.19.1.6.gb485710b


