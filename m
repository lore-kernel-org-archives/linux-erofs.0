Return-Path: <linux-erofs+bounces-4235-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 093F0C5DF70
	for <linux-erofs@archiver.kernel.org>; Sun, 16 Aug 2026 13:07:27 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hNGTT2qhvz2yD8;
	Sun, 16 Aug 2026 23:07:25 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=148.163.156.1
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1786885645;
	cv=none; b=g4gBSfxobGQlRmyD+xr9Zyl6/My4YkmIKsBvBH9WWq99Yd59ZJ0MVtmPs+UOyrqye7fWPxKBsOVBHky9Xc4pc2nr+Ia8kGeaXPKxKTFVQuxDeI8XQ9F1qUJwFJFUtuOZbsbTK3w430GHKT9YI+SmVTiPhC2i4XjFcHXxg4ezVRwFRXPoyKA4vB5eHoQKbYclATeQdPkyplXcmlEveyD8sXhH/8aGtGQi2MeTHbC9BRtOjg7DKQ0eUnI/Yxlf8JfJr7XAsZRvSweED6Lr7/lN5X4k+8aFR0R2+bWgkCt6t+lumVKRoYkStyJ1UHuOajAe7mgz3Tvhol2R8CCKALzzIA==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1786885645; c=relaxed/relaxed;
	bh=O3x8z09z/5qY8lR5GCxQbc4OxO9+aOu3hJ7ywUtZCzw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OMBcoEi0gEV2GUUpKC2Ch8VizDYrBpTzmGC4YemDomb74xdGurDDDf8nP37Ph8a4/Yq8dbvqk0lydiCR85Ary/xYOdSSTZOuPGJrDeIJJ8G9PPhfCsXFHL5C4r7kH3JCh5E1Wf/Mgs7D3fo0UspcvkqwPA0Fjp9wpkfu3JRYVZ4kZKETDdz9R89wurvZcelkA8KFmDbXDDHZoHv8VsCj2BqIAvWglLg2pK78ZQ6KC+FzCryX9WTgUgUxGMz6dFUioMpt5bwn4b/iwJH5K7CL632e3kg6f1tS+FNrcxOzjeLDW+W3xFldm/QmNqJcWtmSOFRZ/SfLW6q/08bNQOpRTg==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; dkim=pass (2048-bit key; unprotected) header.d=ibm.com header.i=@ibm.com header.a=rsa-sha256 header.s=pp1 header.b=CN5VLIaJ; dkim-atps=neutral; spf=pass (client-ip=148.163.156.1; helo=mx0a-001b2d01.pphosted.com; envelope-from=ojaswin@linux.ibm.com; receiver=lists.ozlabs.org) smtp.mailfrom=linux.ibm.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=ibm.com header.i=@ibm.com header.a=rsa-sha256 header.s=pp1 header.b=CN5VLIaJ;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=linux.ibm.com (client-ip=148.163.156.1; helo=mx0a-001b2d01.pphosted.com; envelope-from=ojaswin@linux.ibm.com; receiver=lists.ozlabs.org)
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hNGTS5g3xz2xft
	for <linux-erofs@lists.ozlabs.org>; Sun, 16 Aug 2026 23:07:24 +1000 (AEST)
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67GB1fjj619428;
	Sun, 16 Aug 2026 13:07:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=O3x8z09z/5qY8lR5G
	CxQbc4OxO9+aOu3hJ7ywUtZCzw=; b=CN5VLIaJHqg9bftEy4hcbliaTNROO2f3M
	yUXCTpB/NljH0RRoseUhVGA7hEZ/HjmYJs+eQxPsYDL4r2DZYqSQGb1OB/TToy2a
	96g67RLRSJfbs7zW0hrNw41ZPV/y/JPqqde3DlXQbeQlwmS6Gh/klhvKhC14XK/F
	lkS41DrJBH69XE9RSGPYCAg3omThbaWhylmVDPHOVhnxJ+PC+o7wtY29mVGy3MT7
	j3cIEiHAnEPrqLYhUzCOuiFijiqQZ5BJykcPa5TxbPASBqFxxhdRHKFiJjwzwEsh
	rPywqnzOPnkwH1hnzMMzPv93qbTDx5z6YZIudiPb7nl1YD2wErvUw==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4g2fsqdaay-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sun, 16 Aug 2026 13:07:21 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 67GCuIIQ021375;
	Sun, 16 Aug 2026 13:07:20 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 4g354y1a5q-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sun, 16 Aug 2026 13:07:20 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 67GD7I1Y30671382
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 16 Aug 2026 13:07:18 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8C0DA20049;
	Sun, 16 Aug 2026 13:07:18 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 2FFCB20040;
	Sun, 16 Aug 2026 13:07:15 +0000 (GMT)
Received: from li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com (unknown [9.39.17.50])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Sun, 16 Aug 2026 13:07:14 +0000 (GMT)
From: Ojaswin Mujoo <ojaswin@linux.ibm.com>
To: linux-erofs@lists.ozlabs.org
Cc: Gao Xiang <xiang@kernel.org>, Chao Yu <chao@kernel.org>,
        Yue Hu <zbestahu@gmail.com>, Jeffle Xu <jefflexu@linux.alibaba.com>,
        Sandeep Dhavale <dhavale@google.com>,
        Hongbo Li <hongbohbli@tencent.com>, Chunhai Guo <guochunhai@vivo.com>,
        linux-kernel@vger.kernel.org, Shirisha G <shirisha@linux.ibm.com>
Subject: [PATCH 1/1] erofs: fix unused pcluster_pools for higher page sizes
Date: Sun, 16 Aug 2026 18:37:09 +0530
Message-ID: <808f25346aeac628aa9968f786fdbba09366fd76.1786884312.git.ojaswin@linux.ibm.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <cover.1786884312.git.ojaswin@linux.ibm.com>
References: <cover.1786884312.git.ojaswin@linux.ibm.com>
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
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODE2MDEwMyBTYWx0ZWRfX8joBcYdqrP//
 F2ObEYvnpsuSzAsWR5bIxEs2Q/AKgjdPZ0KoUmIJbVz4dKcYWzoGuppHofUxYm8qXsJPJbz1gEB
 UIruLd6FezXxII6IAOygEnnxWIcHTBnnsV7r/VYbkA/LwbN9cRzwZAJKBHx470x011Lrc2s2m8a
 JXJ2m854WmBVVUyc7FLjeKYvM7dFgh4cSd7AcEnXL47STbNq2dwXRWOjHs4YclFXktkyNC9+gAo
 yzlS/tRLNmSFKX5WBfzEC8n9Xti8C77M89Axxug9jgAYx1o8NvSP9sEpvHtELxEN6HBUN/5WAPG
 08CRylE6ZiH+00ug6w1n/Du48asUZcWo/POPM7qjrIclX7uBIExTIinuhjlyCimWN0a9Y53Wsm4
 w/SugjgxYaVXMTdmJC2xblZoRHiMRfk/DGTBYPdNr/xpxJlMC97WyJsplkHBx27kg1Rukn6n/Ey
 iJNK/nsL3lgQ86J6zBw==
X-Proofpoint-ORIG-GUID: 4CDJiDd-9pqYqwAFq3vEdoWuLddS3uxD
X-Proofpoint-Spam-Info: AW1haW4tMjYwODE2MDEwMyBTYWx0ZWRfX+9nk5L0l1bCy
 na7NyOyuOKV5GnL5YJTojlPDi6iHvOvfkcLFy5+BfUaxCzXF9OgHmOQay1RH0xDR/01vbP/Jszz
 tSI3cbm//1Gihgx9MdQbABPeQ0Z0i8k=
X-Authority-Analysis: v=2.4 cv=DJe/JSNb c=1 sm=1 tr=0 ts=6a81b609 cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=Sv0fKeRqtYgA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=uAbxVGIbfxUO_5tXvNgY:22 a=VnNF1IyMAAAA:8 a=ejRqyOJfSNhr-pxtSPoA:9
X-Proofpoint-GUID: PutnbgkwCSXqOwUWVYVrl69BoIzsWjEc
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-16_03,2026-08-12_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 impostorscore=0 spamscore=0 clxscore=1011 bulkscore=0
 suspectscore=0 malwarescore=0 phishscore=0 adultscore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608160103

pcluster_pool[] hardcodes {1,4,16,64,128,Z_EROFS_PCLUSTER_MAX_PAGES+1},
but the assumption of Z_EROFS_PCLUSTER_MAX_PAGES == 256 is only right
for 4k page sizes. For higher page sizes like 16k or 64k, This results
in us ending up with clusters bigger than what we will ever use, since
we only support upto 1MB of compressed data. For example, on 64k page
size we will only ever use clusters with nrpages= 1, 4 and 17.

This patch fixes the allocation for such higher pages sizes by adding
some compile time checks.

Below are the clusters created right after boot on a 64KB page size
machine

$cat /proc/slabinfo | grep pcluster | cut -d" " -f1:

Before the patch:

erofs_pcluster-1
erofs_pcluster-4
erofs_pcluster-16
erofs_pcluster-17
erofs_pcluster-64
erofs_pcluster-128


After the patch:

erofs_pcluster-1
erofs_pcluster-4
erofs_pcluster-17

Fixes: 9f6cc76e6ff0 ("erofs: introduce physical cluster slab pools")
Reported-by: Shirisha G <shirisha@linux.ibm.com>
Signed-off-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>
---
 fs/erofs/zdata.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/fs/erofs/zdata.c b/fs/erofs/zdata.c
index 602ba8b7cc79..5c2c22ed64d0 100644
--- a/fs/erofs/zdata.c
+++ b/fs/erofs/zdata.c
@@ -128,7 +128,17 @@ struct z_erofs_pcluster_slab {
 #define _PCLP(n) { .maxpages = n }
 
 static struct z_erofs_pcluster_slab pcluster_pool[] __read_mostly = {
-	_PCLP(1), _PCLP(4), _PCLP(16), _PCLP(64), _PCLP(128),
+	_PCLP(1),
+	_PCLP(4),
+#if Z_EROFS_PCLUSTER_MAX_PAGES > 16
+	_PCLP(16),
+#endif
+#if Z_EROFS_PCLUSTER_MAX_PAGES > 64
+	_PCLP(64),
+#endif
+#if Z_EROFS_PCLUSTER_MAX_PAGES > 128
+	_PCLP(128),
+#endif
 	_PCLP(Z_EROFS_PCLUSTER_MAX_PAGES + 1)
 };
 
-- 
2.55.0


