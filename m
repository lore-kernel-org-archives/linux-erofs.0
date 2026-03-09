Return-Path: <linux-erofs+bounces-2548-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 64274F41812
	for <linux-erofs@archiver.kernel.org>; Mon,  9 Mar 2026 16:39:22 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4fV2lp6zmHz3cB3;
	Tue, 10 Mar 2026 03:39:18 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=pass smtp.remote-ip="2a01:111:f403:c105::5" arc.chain=microsoft.com
ARC-Seal: i=2; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1773074358;
	cv=pass; b=MfSLciP26QuzT9zU9Uvkm80MZ6j8Z4q7Cf90Lo6MGGAMOhowOS0f1aAA3vE9hLmNOOrfrm3H8W44Sm8rh+hVUNlc0JS38dFzwlfZSDqd+3o1ZmDMdmJiAW9iwRAebvZ3ZUie+ymmKzo8upsKj+cT89nWSxzqsivmnv1dQ/oIE3eNq7ECcndQGNv+ftyqKg45BBfbc1geUicTwNvhasgWAJi3ivW1UJpVFAhhuOyp9edbOKL3w9Gk47el8yJuph48ry301BlzMHRK02d2kb9M6jBXCRtGsDV7KjQ/zVSb5UazPjQCF+uDwxM8ZW+yyTSNF3LaAjh0Ps47BYV1Fc5Y6g==
ARC-Message-Signature: i=2; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1773074358; c=relaxed/relaxed;
	bh=2ZEa4Md6K9ngNQn8nCxwxSfS6pNZu+FBHensqT0iJ0w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=kYi+3ZInigIKP5N3MRC14ZQtc834O9kWPktpdYoUkibNYmNuemcPI32CDcVIakKBkxbZ33Tsuot6buZzDcQtzOoKYHafNX973J5bxz6TDowNYM6YRIOJlgTx6tSmwfRQGlbmT0bh/D6qLwVvK5dBMm9Bd53QO6gNrmp7SE/eXe+X7RHxmXd+rrN15h1xFCEw8qACSPHFTHjdCwCiot2r9A/1khXt1k2MUZYEYXeMZas2aghd+qM8NzXoLDiQWvLWgT2uCewCnMOHXDi42lT5LempfvhyBJQMNTXlzir+27rpnjAixDXKMtt/YDjycRWEmpLH/iseC36KvHkpNkSsQg==
ARC-Authentication-Results: i=2; lists.ozlabs.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; dkim=pass (2048-bit key; unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=NW1SbliW; dkim-atps=neutral; spf=pass (client-ip=2a01:111:f403:c105::5; helo=ch5pr02cu005.outbound.protection.outlook.com; envelope-from=lkarpinski@nvidia.com; receiver=lists.ozlabs.org) smtp.mailfrom=nvidia.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=NW1SbliW;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=nvidia.com (client-ip=2a01:111:f403:c105::5; helo=ch5pr02cu005.outbound.protection.outlook.com; envelope-from=lkarpinski@nvidia.com; receiver=lists.ozlabs.org)
Received: from CH5PR02CU005.outbound.protection.outlook.com (mail-northcentralusazlp170120005.outbound.protection.outlook.com [IPv6:2a01:111:f403:c105::5])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange secp256r1 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4fV2lp3PnYz3c9l
	for <linux-erofs@lists.ozlabs.org>; Tue, 10 Mar 2026 03:39:18 +1100 (AEDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=H3/VmECLHugbw56fIXlY/vmzExEaWbXc0sPySBuPHrh6UoNsUCUxAwP+TdNPgQNy+X0rqSTBUsG7UXZ8gTzstd9xvwqNiCJYkufd5valhzv4kf2i2BYy/mUOW2+ECFdmKhpOC3IzNe8trudmtU90jq4Dt7jKACdVQJK2VzLrYYHwj93IuA2XeWDsU24apvHgc/SSQ5xTtxtXbqPM3cj/1S8Pbn7njCu+09Q9cI+XlhXpDUSYCiWR2KEN5F6rcONpkVYMypteqfb2u04DxlskneZP8H0Cjf/JvbTdKEKQki+pqU1UoV4+excn5+s1+d7sBLN4fZYw+cTqmsN5y1sJZw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2ZEa4Md6K9ngNQn8nCxwxSfS6pNZu+FBHensqT0iJ0w=;
 b=hwz4vDxMynW6MXvMWprstZkmOLbTp/tbTin2DXbdjDoYIAf2KQu3lpc0vy+eOTqVsZngh+Z8x+qk55WaLY3G3TOGNlIDVY/8oA6Yf961EucOefeSkPSFIy4mSTvJN7twueP+H2usHUo8nAEBtNGG7ViXYQZpk/hDs9Deha6hI60uQxWgBMVgaDCEEd3mUmIt28LS/UXCoBeGgdRWeZOPNeNxe6FRfRihO806aWl2KCYG5SnXrNRC5QGxeQPN5WgDFtIpVM4T217lPL3j/b6r+nyQ9ltiaD/CUzTdRLTYtjxMfDALED359CcCt3iFzR0EojV85RdzR4TqsVohuFuezA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2ZEa4Md6K9ngNQn8nCxwxSfS6pNZu+FBHensqT0iJ0w=;
 b=NW1SbliWeHNkIVIkN90LL0X0vQEpMtiXUAMtdhZQKQtFFmPQiDWoc91vq3EcaYt94UOPd8IRkpLBZfW0av9dsnHPoZ1MUTmdQ6Y24lU9MaUX2PpJzjcS5WgX8fMicfLmUtu3Fw8XWR8WsNdOqqFZrHU+u1rnTW/iHA+J4OCGTo3O1NsAL6DVmEf0+KgEE18A92lzThXxZKa8EYwQvzLpSMGy2l+3lSizd0Dc0J1dR/wY+SHQwNwPzD9ws4HZXo3zPkqfszBJP581sEZaTCG4zRQ8hx5p6ibE8HKfb/5o1bf6prm5orKFemXYSAdLzGy6GcPlwFrXwSZ+Su/RCK6bSA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DS0PR12MB8502.namprd12.prod.outlook.com (2603:10b6:8:15b::16)
 by LV8PR12MB9417.namprd12.prod.outlook.com (2603:10b6:408:204::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9700.11; Mon, 9 Mar
 2026 16:38:55 +0000
Received: from DS0PR12MB8502.namprd12.prod.outlook.com
 ([fe80::3533:c307:cf11:3d1a]) by DS0PR12MB8502.namprd12.prod.outlook.com
 ([fe80::3533:c307:cf11:3d1a%5]) with mapi id 15.20.9700.010; Mon, 9 Mar 2026
 16:38:53 +0000
From: Lucas Karpinski <lkarpinski@nvidia.com>
To: linux-erofs@lists.ozlabs.org
Cc: jcalmels@nvidia.com,
	Lucas Karpinski <lkarpinski@nvidia.com>
Subject: [PATCH v2 3/5] erofs-utils: lib: preserve primarydevice_blocks if already larger
Date: Mon,  9 Mar 2026 12:38:19 -0400
Message-ID: <20260309-merge-fs-v2-3-2dd0ef53db4d@nvidia.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20260309-merge-fs-v2-0-2dd0ef53db4d@nvidia.com>
References: <20260309-merge-fs-v2-0-2dd0ef53db4d@nvidia.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BL1P221CA0024.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:208:2c5::31) To DS0PR12MB8502.namprd12.prod.outlook.com
 (2603:10b6:8:15b::16)
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
X-MS-TrafficTypeDiagnostic: DS0PR12MB8502:EE_|LV8PR12MB9417:EE_
X-MS-Office365-Filtering-Correlation-Id: 00d1169b-1a5f-47a4-9154-08de7dfa558a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	eQ97eSgkKbtSxU+pOnX8jeLcbN9N7ONHbNjxxiJSv3ohlDyYNC6chy4VlY+6v2SObefp0K8aQpuSqVA2CpFlE5r6n6J+VS2c8ydv9K4YHIRk2B764HFFMuBNIOQoS/J8XceB0+9M85iv23nI0GSa1J/wz0iGcOMDwweGL+m4FGBih8o1cLIMC9UdQwIKCR5b5tl2EhnWOH4paMpotX08eXA6ms+oZncRI0Ey1RtiAYwhoqX8mWLOUPCAr1sMl8oxgbjgIupw+HNsXk5wC+83oSRO3jjyle3VTosNVs4goBdekmVRDEIqxLvjWogMGHEYr2Q5a2XQL+yTt84FFzafzIpPJyqCTrP/e6pjBdZGv9GUxhHiOBnh0TBfFHgAufeS6sRQcwkBMGSjx9fZJQ889SS9ModsQZqCjTgSOcZv6WwRQx68u4NUpOYMFOdN3QTN0jprXhyAuDNVNKr6MI2Gy25Q5+fW8m0nUkUBzFXrRkCxqxgaOv0bI1G3uNQjZJD3Dl5kXL5vHADBj/9dtv2ODLCdcharAkPxzGprjWH0zF86U1B+YNYJYJ2R2Q+s0FXJlGgqItVmUEUmkLo3D3QxmIdpAc9VkfaZ42aixZamfbxCy7zUcSJVUe905/UTREcVwco5JHornCqVZOITe3hKJtHFo8u8eiKxrWz9/QB3P1SGMg8LLvhn+Xad65zMqjWXzPsP31r3JchHAqHdjaYOY+EheC4yZsAINVSMbfUqGD4=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR12MB8502.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?MDI2eFRrUXQxMmpGeVpvWmlYbWc5a0IwQzBxZWRpVVZWOGpwdXVuSmlTSVc1?=
 =?utf-8?B?ZGd0M0hlblhVRXU5bzlTYnpqOElRQ1JhaEV6ZU05S3ZJYUFLajBKeGpPMkZK?=
 =?utf-8?B?VHR1YTFyb2dTNkpzU2FKd3ltdEs4aWYxU0sveUhPdFNmRVRLU1dmcDNWbG1s?=
 =?utf-8?B?ZEsrZ1ErUUlLS2FPOXRXZ0VqcGREM3FOMXNaQkcyTnVGQTRRWFdic3V2azB5?=
 =?utf-8?B?KzFsSUFMVEYxblBYN0ZzOEpFOVViY05QeFhrZW96a3dkV2VEVzdzV3E4L2xl?=
 =?utf-8?B?U0dkNEQ2VmYzOVluWkltUnhMYUp2WTlycGJycFBmWS9lUzFRaVAzL2VKcTBZ?=
 =?utf-8?B?Mm5aQlhwNmQwdW1tWThuZHVieFBmVWlTL20raUZRc2sxYzlzd2NUNTF2TWdo?=
 =?utf-8?B?YWQxQ0ZUbmpFSXJ1Y1Z6WnNVTHVZM1diY0hUNUg2V1J1VGNmVHg2NEFCenFT?=
 =?utf-8?B?Mk1jL0VFa054THJOSWNxN1ZrcDY1d3oxS2JRdWRBY3JqYnZQanNlVmpsZGU2?=
 =?utf-8?B?MElhcndDaFppMXdyeGxrWkpmekl0Qm5vS2Z1SmdQQ1UrcDYzc09VaytNdDZI?=
 =?utf-8?B?YWI2VXpUbXhjTkMxS3E3bDVyVUJxVXd3N3ZCZStlaVAzY2xoTTBDUVIvdita?=
 =?utf-8?B?UWUyaDBaMGhqZjhoUEZoOWlSZnpDeWZqOWVXOFpCK2dPK2U0SW9EQnBGOFRF?=
 =?utf-8?B?cWVIOUQ2MEtwNVJkOWUvRGg1NXpQWTJEZ1FzbTZDQWZxRk5nRzd1aElFSUFi?=
 =?utf-8?B?NnFOSHRaRG80MWtDbG5pSnM5R0pOTTgySUtXOFo4V1RsRTAzNnhmcjVHcGlO?=
 =?utf-8?B?TklmcmhYU2lxMFpFZjgwREJzYXVYMzZham01M3I4ZTlCaHh1c2JtL2gwcHZh?=
 =?utf-8?B?V053VEZlbTRyWFc4WFA2bFF5WjZGYXFuQ20xNVdEQ2lQMVVNdkR2dGJHM0pG?=
 =?utf-8?B?Q2Zlbzl2dFJlSTZIZngyUExqcVE2VU12a0laSHk5eGF5QnpheFRXdVE0V0p4?=
 =?utf-8?B?YUwzMEFjNEYzN1pGbU1razJEcFRnVFRzSG1CMUJIN1ZVaXBWYmVrcUt5Nzlz?=
 =?utf-8?B?c0ZoOWJJc1hvWlh2bm5yWWsyQ0wzQzNjUFBBWjhXWnlJTWt2RHlJclpBeWVS?=
 =?utf-8?B?cVFHa2hLSCsvUU5BbU9KREFyMnFTT3RhVTZ0TFdROE9XdjdsSXplZEVyUmNx?=
 =?utf-8?B?bFl5STV1cnM1ZW5FMWp5QytiMTNnUVB1SEFDd2FLTnlIbHl4RlozSXVZSlVS?=
 =?utf-8?B?RnFDdGRoSjR1WDI2ZXZNMUhidm01aWdGelhHWEVFNnpWZFZRVERraUwzNUM4?=
 =?utf-8?B?U2lxclkvRGNXdyt2VllPSnh4UjJxYWRwcUlzTWVmT0d0LzhGMDhob3V0YkpO?=
 =?utf-8?B?aFBXV2Fpd3cxbHI2MXF6clV2V2wvdlhkSGhzOThpMVl2ZFFQUncveW54aUw3?=
 =?utf-8?B?UTU4djJseDd4YVgvZERJd01WWndiQnY1b2pSTU9jYmRBZDQ4RFhBNTRpb1g5?=
 =?utf-8?B?QnFJKzlIb0tBZjZzbjlXTHZzVndnYUdTc3VJOGpxMytLZG4xUy9JbTZpOE41?=
 =?utf-8?B?Q2VvYTd6SFFsZTJseTF2NndCZTBZL0JWVDY2Q2x3ZS92TVY5RlphUzJ6REVX?=
 =?utf-8?B?Z0VUMDdiaUhGQ25uelVyYlh1VDlkYXRQU0NZZ2dmb3RIMjFoN0hwbTZnb1hS?=
 =?utf-8?B?ay9mUG81L0V1bExCV0FqQlBjVTJwYzJQSUg5TUthN2NDUVdYVStCV2xVUTNy?=
 =?utf-8?B?ajY4NUE4a1piRnNBcC8rVEQvY0Vhb2EzUVVtb3JDWUY3eXlIRjdVVE1pS3A1?=
 =?utf-8?B?QXg4MzBhZG02WWUyOVdUS2ZTT0xSdC82dHg1Rk1XdUhWMUFxc29lOHg5aUxr?=
 =?utf-8?B?cG9TdTdja0ZLVHdzZDRycHBFbW5PM3NjaUxlRUIzMndyYmR3OTJJY2h4R0dH?=
 =?utf-8?B?QWE1eGtJMmIxaEpSNW1ZTGxmdEJKNEpGZ3FWU3BDQ05jQUcvR1dqNXVkVCtD?=
 =?utf-8?B?bmw5YmpKZG1rV1ZRK2ZEU2ZXRDk3OWhKTUFMNU42K2JvcjhkYkRlajhrNHNG?=
 =?utf-8?B?MFgrRTNPdFo4ejB5WXBLRldpbEJCWWtFYit3aFY4bjhGRUIyMmtjSytTbmpK?=
 =?utf-8?B?TUMvcndpWkZWOExTWHdxdE8rSUc4L2Eycy9zK29FNTlkbFNaTWhXKzROODZq?=
 =?utf-8?B?ZEFRb3ZrODNzU3JJUFcvOXhZUWdNYnZYS21wbG0yem9WajRmK3BQZXk4Q3VE?=
 =?utf-8?B?UURaVjdRcUJYZ0daUEtwZUExNFYxMFBzZmxyQ3J0c25YUkdDZGRrYVpSNzIz?=
 =?utf-8?B?SVpGRnJZQVAyRjJLTUp3MEwvcVUvdm9NbDhpZStmOFFualZKL2NXdz09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 00d1169b-1a5f-47a4-9154-08de7dfa558a
X-MS-Exchange-CrossTenant-AuthSource: DS0PR12MB8502.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Mar 2026 16:38:46.5772
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OOcbeledy+yhLVw4merOizXHxaEa5LrKzyUONqy/7Oa54j5l2MLeov1iRXzQjCR2kNPDJrzwuIZDBQCuc+akSw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR12MB9417

Change erofs_importer_flush_all() to use max(). This allows callers to
pre-allocate space for data beyond the metadata region.

Signed-off-by: Lucas Karpinski <lkarpinski@nvidia.com>
---
 lib/importer.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/lib/importer.c b/lib/importer.c
index 26c86a0..56c8ea8 100644
--- a/lib/importer.c
+++ b/lib/importer.c
@@ -126,8 +126,9 @@ int erofs_importer_flush_all(struct erofs_importer *im)
 
 	fsalignblks = im->params->fsalignblks ?
 		roundup_pow_of_two(im->params->fsalignblks) : 1;
-	sbi->primarydevice_blocks = roundup(erofs_mapbh(sbi->bmgr, NULL),
-					    fsalignblks);
+	sbi->primarydevice_blocks = max_t(erofs_blk_t, sbi->primarydevice_blocks,
+					  roundup(erofs_mapbh(sbi->bmgr, NULL),
+						  fsalignblks));
 	err = erofs_write_device_table(sbi);
 	if (err)
 		return err;

-- 
Git-155)

