Return-Path: <linux-erofs+bounces-2409-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0B5ABEFD20A
	for <linux-erofs@archiver.kernel.org>; Wed, 25 Feb 2026 08:46:14 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4fLSqS4VCQz3dWX;
	Wed, 25 Feb 2026 19:46:12 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=113.46.200.224
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1772009172;
	cv=none; b=F77aasr8ngmSIzlYXFiQS5KPs6AIg8kNhpqYTDXrpYs1zuFjs5ZUcBvF74jgonU3WtRaR/7l1nvzbXloAF3tqZawQizIoC89hEbppS/UJwvo1/MFn9OzQ+41dn3/c/6WobBk6J+CWnLJEdnaI3xYvuEdxKxFZCV5ngN8W0naCnV2ohxFL6SvfEIdcXqXubA9tGx0tmCE3fX54uSMkbi78R5/0VtybBhG5zv8gg+fp4/kMs2jbbzxuIQ4inGzg1Y7ShXBYqhM03YX3eQBgq3SAPET1KPPl8xWZ7C9Dj7s7j4sbuZUPbyZSZPn92FNiVqRtfBafuRnFFdjG6QoxR4rfQ==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1772009172; c=relaxed/relaxed;
	bh=2MnjEdq9rwZSUdNCPtfh+v9MeGFfbf16ue4PSvI1qYc=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=f0Z2w4hJZQngPdXjfzg3+XHcwm4lsRTjqrFqgTNd5zvNunlAdWE+NBXlYOxgb+IUbcEuQ6mlHOYnpKszZcUgV97NZ9D5OONX2hroHkBTYAGikqXW9TfEYm1JVIJTQuRz0N8m1vWGMIGQKf9yzrNd5p73aHvto2OzaKFgRGunCE7FIwPuOhP2pNcs88CR1FvtT3PJmu0dwUA6NnzgVkd/YP0H4/Pjxx9fquyEnCEAZeWWQXgCdhiI4k0q89A8YOf3uDL5RWMNvnDVnynYw2ohg/ABgsyqGAJPWOjzJFmZNU/gCiDPkaSaM33M448LEInYr32VIgcAXZelFDsBWoLhoA==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; dkim=pass (1024-bit key; unprotected) header.d=huawei.com header.i=@huawei.com header.a=rsa-sha256 header.s=dkim header.b=iRbTUvl9; dkim-atps=neutral; spf=pass (client-ip=113.46.200.224; helo=canpmsgout09.his.huawei.com; envelope-from=zhaoyifan28@huawei.com; receiver=lists.ozlabs.org) smtp.mailfrom=huawei.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=huawei.com header.i=@huawei.com header.a=rsa-sha256 header.s=dkim header.b=iRbTUvl9;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=huawei.com (client-ip=113.46.200.224; helo=canpmsgout09.his.huawei.com; envelope-from=zhaoyifan28@huawei.com; receiver=lists.ozlabs.org)
Received: from canpmsgout09.his.huawei.com (canpmsgout09.his.huawei.com [113.46.200.224])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4fLSqN56nWz3dWS
	for <linux-erofs@lists.ozlabs.org>; Wed, 25 Feb 2026 19:46:06 +1100 (AEDT)
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=2MnjEdq9rwZSUdNCPtfh+v9MeGFfbf16ue4PSvI1qYc=;
	b=iRbTUvl9tOtPLH3YPGLuA5axxJJA2hONza6Q7JFlB7Yp9XV0/rjPKSSqQAig5YwvTGMC4QjmL
	VcZJ1tToMz2OoAZQL++QkCC2JDoF1iS6UMLV/2cR4rNWjP3x+QOpMc3CjLLP7yn8xqLBz2jBpV5
	i6YihMFwNLXwQFyAdgXhmGU=
Received: from mail.maildlp.com (unknown [172.19.163.214])
	by canpmsgout09.his.huawei.com (SkyGuard) with ESMTPS id 4fLSjh6t50z1cyQ3;
	Wed, 25 Feb 2026 16:41:12 +0800 (CST)
Received: from kwepemr100010.china.huawei.com (unknown [7.202.195.125])
	by mail.maildlp.com (Postfix) with ESMTPS id 8799B4056C;
	Wed, 25 Feb 2026 16:45:59 +0800 (CST)
Received: from huawei.com (10.50.159.234) by kwepemr100010.china.huawei.com
 (7.202.195.125) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.36; Wed, 25 Feb
 2026 16:45:59 +0800
From: Yifan Zhao <zhaoyifan28@huawei.com>
To: <linux-erofs@lists.ozlabs.org>
CC: <hsiangkao@linux.alibaba.com>, <jingrui@huawei.com>,
	<wayne.ma@huawei.com>, <zhukeqian1@huawei.com>, <zhaoyifan28@huawei.com>
Subject: [PATCH] erofs-utils: dump: add missing compat features and separate feature display
Date: Wed, 25 Feb 2026 16:46:02 +0800
Message-ID: <20260225084602.553324-1-zhaoyifan28@huawei.com>
X-Mailer: git-send-email 2.47.3
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
Content-Type: text/plain
X-Originating-IP: [10.50.159.234]
X-ClientProxiedBy: kwepems100001.china.huawei.com (7.221.188.238) To
 kwepemr100010.china.huawei.com (7.202.195.125)

Add three missing EROFS_FEATURE_COMPAT_* entries to feature_lists:
- EROFS_FEATURE_COMPAT_SHARED_EA_IN_METABOX
- EROFS_FEATURE_COMPAT_PLAIN_XATTR_PFX
- EROFS_FEATURE_COMPAT_ISHARE_XATTRS

Also separate the feature output into two lines:
'Filesystem features(compat)' and 'Filesystem features(incompat)'
for better readability.

Signed-off-by: Yifan Zhao <zhaoyifan28@huawei.com>
---
 dump/main.c | 22 +++++++++++++++++-----
 1 file changed, 17 insertions(+), 5 deletions(-)

diff --git a/dump/main.c b/dump/main.c
index 8422bb9..1c4e8b2 100644
--- a/dump/main.c
+++ b/dump/main.c
@@ -96,6 +96,9 @@ static struct erofsdump_feature feature_lists[] = {
 	{  true,    0, EROFS_FEATURE_COMPAT_SB_CHKSUM, "sb_csum" },
 	{  true,    0, EROFS_FEATURE_COMPAT_MTIME, "mtime" },
 	{  true,    0, EROFS_FEATURE_COMPAT_XATTR_FILTER, "xattr_filter" },
+	{  true,    0, EROFS_FEATURE_COMPAT_SHARED_EA_IN_METABOX, "shared_ea_in_metabox" },
+	{  true,    0, EROFS_FEATURE_COMPAT_PLAIN_XATTR_PFX, "plain_xattr_pfx" },
+	{  true,    0, EROFS_FEATURE_COMPAT_ISHARE_XATTRS, "ishare_xattrs" },
 	{ false, 504U, EROFS_FEATURE_INCOMPAT_LZ4_0PADDING, "lz4_0padding" },
 	{ false, 513U, EROFS_FEATURE_INCOMPAT_COMPR_CFGS, "compr_cfgs" },
 	{ false, 513U, EROFS_FEATURE_INCOMPAT_BIG_PCLUSTER, "big_pcluster" },
@@ -675,12 +678,21 @@ static void erofsdump_show_superblock(void)
 			g_sbi.inos | 0ULL);
 	fprintf(stdout, "Filesystem created:                           %s",
 			ctime(&time));
-	fprintf(stdout, "Filesystem features:                          ");
+	fprintf(stdout, "Filesystem features(compat):                  ");
 	for (i = 0; i < ARRAY_SIZE(feature_lists); i++) {
-		u32 feat = le32_to_cpu(feature_lists[i].compat ?
-				       g_sbi.feature_compat :
-				       g_sbi.feature_incompat);
-		if (feat & feature_lists[i].flag) {
+		if (!feature_lists[i].compat)
+			continue;
+		if (le32_to_cpu(g_sbi.feature_compat) & feature_lists[i].flag) {
+			fprintf(stdout, "%s ", feature_lists[i].name);
+			if (feature_lists[i].lkver > minkver)
+				minkver = feature_lists[i].lkver;
+		}
+	}
+	fprintf(stdout, "\nFilesystem features(incompat):                ");
+	for (i = 0; i < ARRAY_SIZE(feature_lists); i++) {
+		if (feature_lists[i].compat)
+			continue;
+		if (le32_to_cpu(g_sbi.feature_incompat) & feature_lists[i].flag) {
 			fprintf(stdout, "%s ", feature_lists[i].name);
 			if (feature_lists[i].lkver > minkver)
 				minkver = feature_lists[i].lkver;
-- 
2.47.3


