Return-Path: <linux-erofs+bounces-4473-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B166DC624D6
	for <linux-erofs@archiver.kernel.org>; Thu,  3 Sep 2026 23:21:49 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hbbG34FHMz2xlJ;
	Fri, 04 Sep 2026 09:21:47 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=pass smtp.remote-ip="2a01:111:f403:c112::5" arc.chain=microsoft.com
ARC-Seal: i=2; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1788477707;
	cv=pass; b=j1Tn5atMdvW9fattoahBeVxBJSzTQA7VvONtuVPrkOz4ZbXix8zqNScYh3WVODhwsCSiiDLOz4aIPtjgs4f+giLTLTH6eDCMqcDlZpaDKlfRJyD3OyJ1yGUUSj+dZ8C46RK+0KvQocJ9iJfezzDC0ZI3F3D2lrbLk40TTVvXq52HdJhlN9x5c6qFOJwIkVycDvbfWW1eMWXDnWLHoceO6jR8YOKX3bThFKft2KRotvAFAGHk0kTpnaCC3nwBCEpVHgckUqtK/+4/s/piysHKbah1hokY1aXztyOEi/0Xb5h0a/lXsSDhF15N/IU63cDNmZoe7xkc3DtR2AxiFYg7wA==
ARC-Message-Signature: i=2; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1788477707; c=relaxed/relaxed;
	bh=iH+aipZ/FubqWo8EBoxWE2LpyIeY92IX/LnbDJuIPGk=;
	h=Date:From:To:Cc:Subject:Message-ID:Content-Type:
	 Content-Disposition:MIME-Version; b=CtFpVTnZghY41geWgo/ygWPv8dEnP+uBzHbB9RiHIVzV4mJrXi+X2tPkz7vpd+uw0WN2Iv5SxlM3Yo2no3yh2BDTC/DYDAhDN+5xD3nbui4oUzQso1OwbkNKIm7HOLAWCQ77u/R9DmQCWBayw3VPSnNevbHzi++sXq1I7uypMIQ83AzR/KiA9xdi0rrtX6PrhJzucziopTMzQJqJJVYmIbZ2NwtxYh7WnUFemTjxZ3JpDRdZ5knUyr30+NxJ/mjlCR6V6k654/x3U9J3IzXC9wmvAP3Z49uaHvmccb1D1SI+iWktmOEmy1GECWwf/H9NM6cy0L9jRwaPFW1dyNCjpg==
ARC-Authentication-Results: i=2; lists.ozlabs.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; dkim=pass (2048-bit key; unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=AovXoN5T; dkim-atps=neutral; spf=pass (client-ip=2a01:111:f403:c112::5; helo=cy7pr03cu001.outbound.protection.outlook.com; envelope-from=jcalmels@nvidia.com; receiver=lists.ozlabs.org) smtp.mailfrom=nvidia.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=AovXoN5T;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=nvidia.com (client-ip=2a01:111:f403:c112::5; helo=cy7pr03cu001.outbound.protection.outlook.com; envelope-from=jcalmels@nvidia.com; receiver=lists.ozlabs.org)
Received: from CY7PR03CU001.outbound.protection.outlook.com (mail-westcentralusazlp170100005.outbound.protection.outlook.com [IPv6:2a01:111:f403:c112::5])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange secp256r1 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hbbG16Zgdz2xLG
	for <linux-erofs@lists.ozlabs.org>; Fri, 04 Sep 2026 09:21:45 +1000 (AEST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=O7CW3yuG01/Gx3VyWL8WTuNzgAidn1hSF2f5bQV1pfY/mB3PiYFh8oTSw73wcQwxylcgWBtMw57O8Z7JLTDBuTbY30K3JKwcHthEWwlvUkxHn9ZWblxpvp60SUitym+jovpQ5+DlPXbrLUuqc8AkgipQqJckF4hV84dTlU43jnyoEmrqA4PxgAPAYsX1OAkUJpIbWogbyEgb02t19P663sJqbYKHl0LH2OuWegRyKczGrW9800yBuZM4gFI7ZKI9tKWdJAk5y4EnF1KfVSNvLc+q7fE7vLFkPgG/vT76MoLXCzQ2Yha9yyibaPfIfYW1RzOI1U95Teie01nQr5/i8w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iH+aipZ/FubqWo8EBoxWE2LpyIeY92IX/LnbDJuIPGk=;
 b=mIuUCp9btzg+TjugFUqPmsms9BiGpKMsydlbxDFSRskNVqr3RWwImlteIG4jE0RssfxUvH0B6akk4zV0jGPgb4Ma++ll0tzjv+/QjslhY+c3p8tZUxld2vloJzkJVkzD62o6jvV3YFdfSY3axqWTxuyT/FfdnHQw8lB/H39blxJX8IMkxQ6QupuV3Ta0MbNn0n2NWs/29c+GQyyn8IxGJ75LIqAdJ7zqmI7SzJWUY0vPdGTt+YPHNrHA2DaC+yn5SBb9uUW1yh1GbcnDSuN6lOvONDjn/kLRqVdOzRkcV720xlqTVihT6ChaNYVH4vk5SIUR2XAzjismtB4x3PATtg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iH+aipZ/FubqWo8EBoxWE2LpyIeY92IX/LnbDJuIPGk=;
 b=AovXoN5TxArjses9fh9cKsiV+cC4BzhIEW4QClSr8YnbHP+U9kAnrPaWrTEPVVEcPSRiIXLPGtE+En5ltjzWtv5uRC1aJay2ieThdRFYWVCbut2HCfXFM04FDGimPE6ozbjvaeDoUPU3Sz5rN6g0PI8d+aAYIv72B2e+gSKMeeIezYNxFiheC2V9bvtEVzQ1YJLWibVjIgSPekxwxHMzAuWS5RQd/EaumpQBBPjItpiFV5hQn6FXaoeMTcrJuwGyG+a/yb1bzvQHbdUouABg8E7S3yW/6ql0Bzk28sgJFNePNS//NvZ9WHiHjJyRky6GUeEiYYyUSvHfnJBXjuRjbw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH2PR12MB4969.namprd12.prod.outlook.com (2603:10b6:610:68::8)
 by CY5PR12MB6323.namprd12.prod.outlook.com (2603:10b6:930:20::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.360.13; Thu, 3 Sep
 2026 23:21:17 +0000
Received: from CH2PR12MB4969.namprd12.prod.outlook.com
 ([fe80::8317:5a85:3569:fc0f]) by CH2PR12MB4969.namprd12.prod.outlook.com
 ([fe80::8317:5a85:3569:fc0f%3]) with mapi id 15.21.0360.008; Thu, 3 Sep 2026
 23:21:16 +0000
Date: Thu, 3 Sep 2026 16:21:14 -0700
From: Jonathan Calmels <jcalmels@nvidia.com>
To: linux-erofs@lists.ozlabs.org
Cc: Gao Xiang <xiang@kernel.org>, Jonathan Calmels <jcalmels@nvidia.com>
Subject: [PATCH] erofs-utils: lib: refresh device table slots on incremental
 builds
Message-ID: <20260903232109.1198449-1-jcalmels@nvidia.com>
X-Mailer: git-send-email 2.53.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
X-ClientProxiedBy: SJ0PR13CA0194.namprd13.prod.outlook.com
 (2603:10b6:a03:2c3::19) To CH2PR12MB4969.namprd12.prod.outlook.com
 (2603:10b6:610:68::8)
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
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH2PR12MB4969:EE_|CY5PR12MB6323:EE_
X-MS-Office365-Filtering-Correlation-Id: 31702e53-b222-4aa6-b309-08df0a120d72
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|23010399003|376014|1800799024|10067099003|56012099006|11063799006|18002099003;
X-Microsoft-Antispam-Message-Info:
	4aNBK70tCffbDPEMxkUgurNbg+E1io0jAEAOdApJE6ySiS146jjI6fdjYUqRpMi3fH07SDo6hvhEjw1CQe9pC5k38y8CJcGcUeXMWZvZ7todRPVDFySXTXRCe9KqJ4Z3mCvocr5lbhfsNB6xuQQRleGd+1fVDLbRCt/mhFBpYdHOaXh111JJFVnq2ZqVrwaJPNKVihB2qcRROjvTGmJl/GOwkiAuZpTlQhxY1BJwGix+tVXmc2ci/FEyLUGy2ue0tANagI14UDXaYfgvZW6G18ykIS3a6KSr1LyGk8d7Bm2EsceK+v9F0cadI+Mj3LgW0fzuI/5fJZAgyD6D4UoqDJ//3SHE8duEe5AlKWuGd/3HontKqUNOhrJ7rfv9VRMvzGZgQ2OZ8WDjcKKiU6+AZc95Z9sGqU67lW/AmEhMl08IWyg6cm6mdwZ0xdbEuC+AwGq4c1/NfUlQ/mN+Nx+KZA+4ru6Nmdc2pmSu3yMvYgNtQO8BkEjMbReBvQYcmBMMa7SdSE1Uy/0P0KCBqc+6MFnjyzgPtpN/QyhNL5tMkJm+q1r3btH3C3nTKzjMxrF75x58FQ8cnKQeK6Ndhyhkt375iplbOTaFpTtuBnzTHbCBu/glamm1Yd0H8fYmBeApDbv7tVS88qfpx8SUaGMQC/+htBg0uZJmK+QfVqyd0rs=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR12MB4969.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(376014)(1800799024)(10067099003)(56012099006)(11063799006)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?UHpGTDNyNDUrTEdYVXMzY3dqcUo4ZjBlb3hlL25weUh5aFNxNDVYSTlja1JU?=
 =?utf-8?B?NE5yWFRrUjV2cjdJM1FBWUlnM2Jxc2hnRnRaQ3ZaejFIdVlDWUczR0R1UXov?=
 =?utf-8?B?Zkp3ZmdJWHhrVVRLQWxaa0haUGc4R3g5UUtvdGk0OW1PTkV6dmFlSlM1czJh?=
 =?utf-8?B?b3NZQVRudThITzdNMVVYMWYyUVFvcFBxeGwrcGtMb2xKbHBWTnZGK3JlbFNs?=
 =?utf-8?B?ZWIvTWl4U2hHbktpcXhYMmhQNU9vMFM2UGZIY2ZvZnZWa3ZRdkJ3RjRUbXQx?=
 =?utf-8?B?Z2hObENGeVV4WFFqMXpRZlNTRG0vVVpyTzFWa1ZZODgzaHBRYXF2K2xNQjJH?=
 =?utf-8?B?RUljVWpBandKUHFJV0hEaS8vKzNhNkEyRkNoVkF0SnppQlRNMnVaTi9USC83?=
 =?utf-8?B?S0ltQW9jRDlTMUE3b2ZnSVprYjBkRnVDQXBIam9UMU9JbjMzTm02T2pyZTB5?=
 =?utf-8?B?WnBObHcvRkxzZHhNU1NSZ216cGVaOTBVZ3R6NVVyeWFORDR2eG0xeEZxc2Np?=
 =?utf-8?B?T0NmRC8zODFSeGpMbXpLTGl4U0NCVUg4Y0J2di9aaVZTZzBqeGRmVXNPbFFn?=
 =?utf-8?B?TlpCZnhacXVmTjZrU0JSdWEraWx1enRuTTBHRDEwSW9zcnhDaHFCM1dMTTBm?=
 =?utf-8?B?RWxHOUhaUFJVSy90eEJFVlA3cGhYeTQzWDgwdTFXUXdHS1RrK1BGdENUTXJR?=
 =?utf-8?B?dm5MajZTZ01ZUnM2alpFeEVPK0RST0YzYm5SSDVrcFpmV3ZMaGxPMEdBTWFm?=
 =?utf-8?B?OGRSaGZDaXdLSTVzV3JTRFVZR3N0UlNRK1h3RDZlSks2K3lrT0RMNFppK2pP?=
 =?utf-8?B?TUo0VEppUmVnZ2hHd1VGdlk3cnJSZC9SRjhzQ2c1bVo0SGNZNFFlK2JkaEVV?=
 =?utf-8?B?a0dKWXU0RERhc0c3dXhCeVBWeHhzK21oUS9hQ20vSjBucHMvZmtkYksrOTRY?=
 =?utf-8?B?UXlKcEN3Q2hPazdVOEE5RzBJakJKNlpsVy9yM0VrNXhRa094R1pncFJGNWhV?=
 =?utf-8?B?Qk14MnNjeFBPWUlwMG1Nb3RJZk1Nd2RtN1FUYyt1ajhVREFqL1NhN3lGUTBY?=
 =?utf-8?B?NTkrSlBSaGNibGFkbWlha2R1UVVWWlVCOC9iS3M1dzYxWHhHWGdyOWhZNzda?=
 =?utf-8?B?R21FVXFnNjUxcDRERjNNcHR6eTJRRUNweWcxNnhSd3ZxVW0yV21aV1ZHM2ZT?=
 =?utf-8?B?YXFNanNxei80Tmo1VjBZenNXRnZmMkIvQUJFajlGMG1PZEZURGRiNDBnSlZR?=
 =?utf-8?B?cW0wT1M1ZHlXcnRHZlZYRjJzM1J5dUhQUEU3eXB0eXFOUGxNZUhaMkFPN2NG?=
 =?utf-8?B?ZlU4MVlXbzcvSjJSWXpxcWtBdFN2bWhIUlY4a1JJZ0lNTWp3ZkhLSkl3Q3JB?=
 =?utf-8?B?UlR1eFkrS0R6enQ1N2pCeE80Vms4SXdkM1pmbStrRWJ3VkVhZHZDVTJJTlRH?=
 =?utf-8?B?dlhxUC9mRS9kTkxVWTVQUlBEcmdEVnNBUkFLN1dldEY1ajFUTkRVNm9oMlN1?=
 =?utf-8?B?ZHR1YzdtNEwvSWJmUWtQZVZUcC84ZEhWRVB5MmlwVzFjMm1VZ3FtMThTSDRM?=
 =?utf-8?B?MUlmTU1NbkdDRkVBRTVoNzd6WHFvaXdER0F2TjFRRyt5WEFPdlpZckFSbE1H?=
 =?utf-8?B?QmFlOUdEQW9DVE5paHRpOXA0c0dXaHlJY2kzZ09YWlZ5UlBOYjFDcDJvbDhy?=
 =?utf-8?B?WUxDS0JCNjVGWXhmMUM3OHVMampBVGllNHdIbWcxOUptTEVNaENGc0lSdXUz?=
 =?utf-8?B?d1VLVlNWZlZSb3FnYTNZbTd1enNOQXh4UDFld1Qzc3VsV1Nmc3FOWGhBYjV6?=
 =?utf-8?B?VWZVL21lR1cweFJ5KzdrUEg0bUR6UmVzdlpIeE5tWk13d0JMOGdlTTJjSnhQ?=
 =?utf-8?B?Z3lyUExkbElTYVpyRFVVckNoMHNHd0lWUTRjTU9mQW92eXl0dEhZc09IOHZj?=
 =?utf-8?B?L3lKdVh0bVRJU1l5M3dvQUdFNHNFYStZRmw4ZFB0RFFSSW5vZUtkOVd0ZVdY?=
 =?utf-8?B?aHFZZUtmbFppWFZQNldMUFozQi9tcEloOVlFNldBeDNuZ25XSzR5bU1ONk5U?=
 =?utf-8?B?ZEE5cGhXZnBZM0J3R0IyWUxKcG5lL1ZzajZDR201cWt1UDVQWU83ZDBXN3RV?=
 =?utf-8?B?bzJGNllTV2NXVTdQOXk0alJLenVsUWNNQzVvVUh0aURrZUt2NE03dGE2ZkdG?=
 =?utf-8?B?Zld1ZFUwUzRwaThwYjh3eVNtaUoxOTdsSXlQV2dNRnJ1L1REclJwd1JKZE54?=
 =?utf-8?B?RkQzaFBmWTdzU3hweHdYeTFVN1FGUTZLVFJodkNCeENlTk1ZOGtzY3htbWhY?=
 =?utf-8?B?U2RtR2c4QVpweG9Rbk5hakZzb0pxK2pTcnpNNEN5djZuTUhVcDBldz09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 31702e53-b222-4aa6-b309-08df0a120d72
X-MS-Exchange-CrossTenant-AuthSource: CH2PR12MB4969.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Sep 2026 23:21:16.6383
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lrQnre12UqNibpx1B99dgNsIvl4xtYVTc5kzxZzZ3bokbbcGj8yyMGBo04n25fLXwnfDxR8WV45T4gUrBkQW3A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6323

When --incremental=data is run on a merged image, erofs_write_device_table()
leaves unified addresses and total block count stale after the primary device
grows. Fix it by rewriting the slots in place with updated uniaddr value.

Reproducer:

mkfs.erofs -Enoinline_data a.erofs a/
mkfs.erofs -Enoinline_data b.erofs b/
mkfs.erofs merged.erofs a.erofs b.erofs
mkfs.erofs --incremental=data merged.erofs c/

Signed-off-by: Jonathan Calmels <jcalmels@nvidia.com>
---
 include/erofs/internal.h |  6 ++----
 lib/super.c              | 27 +++++++++++++++------------
 2 files changed, 17 insertions(+), 16 deletions(-)

diff --git a/include/erofs/internal.h b/include/erofs/internal.h
index 95f5627..b10e447 100644
--- a/include/erofs/internal.h
+++ b/include/erofs/internal.h
@@ -123,10 +123,8 @@ struct erofs_sb_info {
 	u32 checksum;
 	u16 available_compr_algs;
 	u16 extra_devices;
-	union {
-		u16 devt_slotoff;		/* used for mkfs */
-		u16 device_id_mask;		/* used for others */
-	};
+	u16 devt_slotoff;		/* used for mkfs */
+	u16 device_id_mask;		/* used for others */
 	erofs_nid_t packed_nid;
 	erofs_nid_t metabox_nid;
 
diff --git a/lib/super.c b/lib/super.c
index 9e52dd8..672464c 100644
--- a/lib/super.c
+++ b/lib/super.c
@@ -52,6 +52,7 @@ static int erofs_init_devices(struct erofs_sb_info *sbi,
 
 	sbi->extra_devices = ondisk_extradevs;
 	sbi->device_id_mask = roundup_pow_of_two(ondisk_extradevs + 1) - 1;
+	sbi->devt_slotoff = le16_to_cpu(dsb->devt_slotoff);
 	sbi->devs = calloc(ondisk_extradevs, sizeof(*sbi->devs));
 	if (!sbi->devs)
 		return -ENOMEM;
@@ -424,15 +425,15 @@ int erofs_write_device_table(struct erofs_sb_info *sbi)
 	if (!sbi->extra_devices)
 		goto out;
 	if (!bh) {
-		if (erofs_sb_has_device_table(sbi))
-			return 0;
-		return -EINVAL;
-	}
-
-	pos = erofs_btell(bh, false);
-	if (pos == EROFS_NULL_ADDR) {
-		DBG_BUGON(1);
-		return -EINVAL;
+		if (!erofs_sb_has_device_table(sbi))
+			return -EINVAL;
+		pos = sbi->devt_slotoff * EROFS_DEVT_SLOT_SIZE;
+	} else {
+		pos = erofs_btell(bh, false);
+		if (pos == EROFS_NULL_ADDR) {
+			DBG_BUGON(1);
+			return -EINVAL;
+		}
 	}
 
 	i = 0;
@@ -452,9 +453,11 @@ int erofs_write_device_table(struct erofs_sb_info *sbi)
 		nblocks += sbi->devs[i].blocks;
 	} while (++i < sbi->extra_devices);
 
-	bh->op = &erofs_drop_directly_bhops;
-	erofs_bdrop(bh, false);
-	sbi->bh_devt = NULL;
+	if (bh) {
+		bh->op = &erofs_drop_directly_bhops;
+		erofs_bdrop(bh, false);
+		sbi->bh_devt = NULL;
+	}
 out:
 	sbi->total_blocks = nblocks;
 	return 0;
-- 
2.53.0


