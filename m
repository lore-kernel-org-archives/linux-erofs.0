Return-Path: <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4D21DCD1284
	for <linux-erofs@archiver.kernel.org>; Tue,  2 Apr 2024 09:16:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=lists.ozlabs.org;
	s=201707; t=1712049365;
	bh=RlIrpgpqHEjV0p4qxgX2gTnTbXGWfN/CKHJsnbImAz4=;
	h=To:Subject:Date:List-Id:List-Unsubscribe:List-Archive:List-Post:
	 List-Help:List-Subscribe:From:Reply-To:Cc:From;
	b=Rglh7S4scGOrKeFjppGElHhpzIsWVEtqvDXQvbj6Xw1QPPmI0k8B1ZwwH1JFN+fMG
	 uKe2avjfv430KfMnT0PePqtUbnuadfS0Fw6LR7vZM6dQTSORDAwKB80t3/CMhWXR/R
	 Hae5hO7tpZZD6VuFpfHLlL1UWDKwrSPIsHtO8UmLRI5EkhPMb8u/tMZgK+jmts1fGt
	 qWkYF6Cyt+qmG/dLGcSKI5jSObJv96DbXbeo4fUEoq56rX+1VWI/vQvpip9QWcLo9v
	 oYSEcryik+x+6TEEoOgpToURXJ32f07k8Y6OQ6kIoOO2vJnwSdU52NdeG61AMiOBi3
	 SD+2TP/J83BDg==
Received: from boromir.ozlabs.org (localhost [IPv6:::1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4V82LF5gRtz3dV6
	for <linux-erofs@archiver.kernel.org>; Tue,  2 Apr 2024 20:16:05 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=vivo.com header.i=@vivo.com header.a=rsa-sha256 header.s=selector2 header.b=kSwqfM4/;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=vivo.com (client-ip=2a01:111:f403:2011::700; helo=apc01-tyz-obe.outbound.protection.outlook.com; envelope-from=guochunhai@vivo.com; receiver=lists.ozlabs.org)
Received: from APC01-TYZ-obe.outbound.protection.outlook.com (mail-tyzapc01on20700.outbound.protection.outlook.com [IPv6:2a01:111:f403:2011::700])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4V82L572NFz3cZR
	for <linux-erofs@lists.ozlabs.org>; Tue,  2 Apr 2024 20:15:56 +1100 (AEDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ieiLTl66zt/1A0qAOZCAEfkVMY7wuqkD9zdDDyK0rL6K6+ZDUjnUTTsPBUfzPaxFrUPUS8lDssjEC1Fb6R49IKUcPmBrbv77WS1Up0uDePPwenL6akb+zTxPhNzvJFllgpP0vlQFLhMQq7bwH+Bo6vDksUlMOd3quTunTf5GFuOlHBqweMVRon9jz4cOSqe0dPk38QjSYk/tBDHobD8hN3ZXMUq1EZBxT9E5uqm9k8HBkmjxGMkpQ9vG1sxBdscYHWuUGCtrp1goqdXwOPpYY9rnalGeLyKJA1TIvq1247Vb29KZvBsstb5gAX8FEFOqyZETnI+82yndmxdnLJkf3g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RlIrpgpqHEjV0p4qxgX2gTnTbXGWfN/CKHJsnbImAz4=;
 b=XjnP4baLjLSRv4hz2L8wiM7KVwW0+g8gPUxdUZRj8vGU+aPIgt79o92hmCP28JNuFugr1gnOZ1Apaq4NV1f1JAfZXcRLR/pC0KtR0UriiHYsZFYCrzfzmb+fpfBjSankQBQ2SjI26pBS/FdXsjwIRe+/wFech9X6shLqTF2to/o/A66j4pTLSZbZzXtyxwYj0hPTqRbP82HVzgQUqo93kNpREThSQAhg3stDGUd0Z7jbZcbWTVwFD6V+c4Dz3GpXrjOeU2jOZlHD0lMvjT+aq3Z1Tf5Uowuh74CfnNubhcTH6AV4JAyf3Tlc2lX1uVEU49PPAPchiKOe6qyAOD4EYg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
Received: from TYZPR06MB7096.apcprd06.prod.outlook.com (2603:1096:405:b5::13)
 by SEZPR06MB6873.apcprd06.prod.outlook.com (2603:1096:101:18e::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.45; Tue, 2 Apr
 2024 09:15:34 +0000
Received: from TYZPR06MB7096.apcprd06.prod.outlook.com
 ([fe80::9eb4:3582:34e4:a83d]) by TYZPR06MB7096.apcprd06.prod.outlook.com
 ([fe80::9eb4:3582:34e4:a83d%6]) with mapi id 15.20.7409.042; Tue, 2 Apr 2024
 09:15:34 +0000
To: xiang@kernel.org
Subject: [PATCH v2] erofs: do not use pagepool in z_erofs_gbuf_growsize()
Date: Tue,  2 Apr 2024 03:27:57 -0600
Message-Id: <20240402092757.2635257-1-guochunhai@vivo.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI2PR01CA0032.apcprd01.prod.exchangelabs.com
 (2603:1096:4:192::18) To TYZPR06MB7096.apcprd06.prod.outlook.com
 (2603:1096:405:b5::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: TYZPR06MB7096:EE_|SEZPR06MB6873:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 	RhThV8f+YPjCxLcAC3uDAUNNHCe1ydEDHmyjRGKUyCPa8Wmq/2OuropD6KVg/eLlxWRwy5dnuW9TFWbekpOtnnmuqVOYQrMhhu1KoHoew+9NZnCMknMIl9ATFjV/HDUT1PTCDL6PNV6IDgX9IOHjcpB8xS7q5zcYgEMwXLWmNeteMTPptSyfChN/0uguqtW+41JNEUiqsG7RSqoTOzm8FelWWWw7ELSpPSghEwbCSryNT9zVmCvfTqgRd5Of+lO47tUwPeDL00/tstiJt7asKdiZgj8ArSSVKZkK6h81GPQcuqoR0NALv429mp3Buj2tgoLpMFajzL2+M5dB8E3zoTPUZttA3/UJ12Ub5Idl2ROdGr7W6RiULk1rgx8uwWKiprfxj0TcLxPY/N9qJDS31QP/+tV8CAFM+Jt+eEh3+qonb2S95YvsGpO0LFdXzYs78/gzs8iQTE09LOzkvzGyTq1PRhOphPefN7zvVmfFk2VytLV5SV0KQEWJh9sLOIIuqpeTMUpogEIUeGZEC/mlBXvErzoh32W1CmGvl1e0DLfVo02Azujj8WEPNOrvt2M1o6fUjmCDyK04ac1T0bBcTMBBIjE7wm044zch8XnXIbJM9jmLsXPh+yTbaMTQGX6CyeN5ghXV9E3vTRs+1zNUxpLvqK/WdHq4BwhMMV+7TBfT6iWraJpGUY5haOtijGEOXZyj9FXp88DLStMdel8Rnw==
X-Forefront-Antispam-Report: 	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TYZPR06MB7096.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(366007)(52116005)(376005)(38350700005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 	=?us-ascii?Q?jUtMNeWkYohk7ltAZHCX0+kPmUfkuCyDeOUIsRXXCMoe1M3aOrrcYiK4iMiD?=
 =?us-ascii?Q?nQDL6BYZ3Bq0k88MPKZth9s9rG6yokRQd+SyLRHxaYBC819FlObuf6CMYDqg?=
 =?us-ascii?Q?kpT+zow9yVg2i8Kgvlc4UYvfd+m+9+urRM/wxsSVEWLsTuRphiCPWbNnyOzH?=
 =?us-ascii?Q?SYQmtKWUgfylqBjSk+gVHiT5QE51xHQabh0e2j7pT/DGwj31R/NVB4meKQ2r?=
 =?us-ascii?Q?DYoYZbYk+HgbLwPuSFuR+BN4AuaBLCFCp13LEkF5wJ5AYDH4K3lXbXiI+wky?=
 =?us-ascii?Q?0bD2+N/Pt32zmjTmXxwqEPKJyf/+HHpTzaQ5zrt9lehbPeG35H+ZKT8YcMt8?=
 =?us-ascii?Q?LL6EuvXHeeKSFNDdfqlvPmPHSROWwxyVh8P2iZfx1P0e+3Y4cB06Vbti+uVk?=
 =?us-ascii?Q?glYUGxMNwG8YcFLgjpJdGumA8A5q+4a+os8IdRPtNz6yzolxiPmLvWZQO333?=
 =?us-ascii?Q?HZX1nl6Vx/dVZPZDmXtwpefgCVnnxw54d4B1IFS6+cdlOYowB2n354WSY1dg?=
 =?us-ascii?Q?avCoEKXSZgp4lTtNLw/xnPIGlfvlKrqD7usRJ/IXaC4ZmZwND21LRfDST3tZ?=
 =?us-ascii?Q?XmL++W2hz/G20gCrZlvsiMUAt2L2r71+p10A7nSyku2y6oXjViEIQJJkWIvw?=
 =?us-ascii?Q?0tI8D2VVGlWywrRJ3CxOnJNhTuOpgH/JinKFgArEgUz9tMvLvTcFpdqLL5FR?=
 =?us-ascii?Q?pyb1Fv7RoNKSrcWQoWK+tEOH5IyK7lXYppUee94z3JKM297la3Ki72OCD71p?=
 =?us-ascii?Q?Mfbk01x4ihtkNWDvpqXhgJ8BMdnxlPGZhvpq+Q2MwKF2Y4aB9fkmhNTqGm+N?=
 =?us-ascii?Q?TVwwrS6Jkx4J0mdYUdpjxvc9SFFlGsK/AEbxDfuJHnmGnWBLac7hlRGczSva?=
 =?us-ascii?Q?gJCO5ExH+yWWSm/kK9diyhjnNfVba0O+MPSKqlyY24j3pb2J8QfHRNyqeXOt?=
 =?us-ascii?Q?dqPUoM1TJ1pD0AgWyOOBaZiU6JY9Sz5KBBNRqAv7XxhTcrbIX+TKWQBvPXeK?=
 =?us-ascii?Q?xq1PPN0TiN3vfbVhuTSv2cQIP37NDzQXfNJeDK4XWlqewr8ASPVFV9f6Q4Uj?=
 =?us-ascii?Q?OnPjkMls/cqzQnrRgaq7SKiK207phT+55iN7vg7V7F2+EB00t64HFzvDySVp?=
 =?us-ascii?Q?UVf998bUH3iwZHigssgvXJGCSmbVq/18OdsAxyXSBg5rmW2nd2QRzYmTGsxy?=
 =?us-ascii?Q?YFu3CdjoiK48om/AKzJ3KyPB+Fsnzu34AWCiOWQwICZgv1/IUPPa+Ug/qge9?=
 =?us-ascii?Q?xgWfpSmyc2HxaREbQ4BeCYOmXTEzeXMMV52sGOtoURmOf26lU/lBeDLBay1m?=
 =?us-ascii?Q?qN7FKNLumDanGJaRkD3c90F75PnLsnz5uAVJD4OIbaidRj0WOQqkbWCqcbOh?=
 =?us-ascii?Q?amjTBTzFDxCe6cCybxNoKr1KTVcMh93BkdQd8PP84luOURnKaNaO5i52QafN?=
 =?us-ascii?Q?RB4hBASK9XkdDApkUkEasywC9dOWCORQp+Uopd7lQcUnWMuFVgsL06jMQYn/?=
 =?us-ascii?Q?5928+2w8CF0ZI0v6l3MEUOfO5kH8i2gLLcxHIpdeD5Y/f/FIFgGMP13lIKnA?=
 =?us-ascii?Q?DAZOv6ocVVA2ibgKhxO2oeO5oEgW89okFZNnCsj6?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 31527505-0411-469e-571f-08dc52f573ad
X-MS-Exchange-CrossTenant-AuthSource: TYZPR06MB7096.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Apr 2024 09:15:34.3015
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KmYmPI5FkCPYQJ6poFYzgkP8KRgTxQG1aDmU/nl8B72nr4C2FEuDMpYoQtlZGqEVTJZhfnbw4demoSJAb6oT1g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SEZPR06MB6873
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
From: Chunhai Guo via Linux-erofs <linux-erofs@lists.ozlabs.org>
Reply-To: Chunhai Guo <guochunhai@vivo.com>
Cc: huyue2@coolpad.com, Chunhai Guo <guochunhai@vivo.com>, linux-erofs@lists.ozlabs.org
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs" <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>

Let's use alloc_pages_bulk_array() for simplicity and get rid of
unnecessary pagepool.

Signed-off-by: Chunhai Guo <guochunhai@vivo.com>
---
 fs/erofs/zutil.c | 67 ++++++++++++++++++++++--------------------------
 1 file changed, 31 insertions(+), 36 deletions(-)

diff --git a/fs/erofs/zutil.c b/fs/erofs/zutil.c
index e13806681763..9687cad8be96 100644
--- a/fs/erofs/zutil.c
+++ b/fs/erofs/zutil.c
@@ -60,63 +60,58 @@ void z_erofs_put_gbuf(void *ptr) __releases(gbuf->lock)
 int z_erofs_gbuf_growsize(unsigned int nrpages)
 {
 	static DEFINE_MUTEX(gbuf_resize_mutex);
-	struct page *pagepool = NULL;
-	int delta, ret, i, j;
+	struct page **tmp_pages = NULL;
+	struct z_erofs_gbuf *gbuf;
+	void *ptr, *old_ptr;
+	int last, i, j;
 
 	mutex_lock(&gbuf_resize_mutex);
-	delta = nrpages - z_erofs_gbuf_nrpages;
-	ret = 0;
 	/* avoid shrinking gbufs, since no idea how many fses rely on */
-	if (delta <= 0)
-		goto out;
+	if (nrpages <= z_erofs_gbuf_nrpages) {
+		mutex_unlock(&gbuf_resize_mutex);
+		return 0;
+	}
 
 	for (i = 0; i < z_erofs_gbuf_count; ++i) {
-		struct z_erofs_gbuf *gbuf = &z_erofs_gbufpool[i];
-		struct page **pages, **tmp_pages;
-		void *ptr, *old_ptr = NULL;
-
-		ret = -ENOMEM;
+		gbuf = &z_erofs_gbufpool[i];
 		tmp_pages = kcalloc(nrpages, sizeof(*tmp_pages), GFP_KERNEL);
 		if (!tmp_pages)
-			break;
-		for (j = 0; j < nrpages; ++j) {
-			tmp_pages[j] = erofs_allocpage(&pagepool, GFP_KERNEL);
-			if (!tmp_pages[j])
-				goto free_pagearray;
-		}
+			goto out;
+
+		for (j = 0; j < gbuf->nrpages; ++j)
+			tmp_pages[j] = gbuf->pages[j];
+		do {
+			last = j;
+			j = alloc_pages_bulk_array(GFP_KERNEL, nrpages,
+						   tmp_pages);
+			if (last == j)
+				goto out;
+		} while (j != nrpages);
+
 		ptr = vmap(tmp_pages, nrpages, VM_MAP, PAGE_KERNEL);
 		if (!ptr)
-			goto free_pagearray;
+			goto out;
 
-		pages = tmp_pages;
 		spin_lock(&gbuf->lock);
+		kfree(gbuf->pages);
+		gbuf->pages = tmp_pages;
 		old_ptr = gbuf->ptr;
 		gbuf->ptr = ptr;
-		tmp_pages = gbuf->pages;
-		gbuf->pages = pages;
-		j = gbuf->nrpages;
 		gbuf->nrpages = nrpages;
 		spin_unlock(&gbuf->lock);
-		ret = 0;
-		if (!tmp_pages) {
-			DBG_BUGON(old_ptr);
-			continue;
-		}
-
 		if (old_ptr)
 			vunmap(old_ptr);
-free_pagearray:
-		while (j)
-			erofs_pagepool_add(&pagepool, tmp_pages[--j]);
-		kfree(tmp_pages);
-		if (ret)
-			break;
 	}
 	z_erofs_gbuf_nrpages = nrpages;
-	erofs_release_pages(&pagepool);
 out:
+	if (i < z_erofs_gbuf_count && tmp_pages) {
+		for (j = 0; j < nrpages; ++j)
+			if (tmp_pages[j] && tmp_pages[j] != gbuf->pages[j])
+				__free_page(tmp_pages[j]);
+		kfree(tmp_pages);
+	}
 	mutex_unlock(&gbuf_resize_mutex);
-	return ret;
+	return i < z_erofs_gbuf_count ? -ENOMEM : 0;
 }
 
 int __init z_erofs_gbuf_init(void)
-- 
2.25.1

