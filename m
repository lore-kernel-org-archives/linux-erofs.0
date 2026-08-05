Return-Path: <linux-erofs+bounces-4143-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 66842C55ABF
	for <linux-erofs@archiver.kernel.org>; Wed,  5 Aug 2026 11:43:18 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hFT7S3GXWz2yLY;
	Wed, 05 Aug 2026 21:43:16 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=pass smtp.remote-ip="2a01:111:f403:c107::1" arc.chain=microsoft.com
ARC-Seal: i=2; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1785930196;
	cv=pass; b=HD7bKUOynwNW2cita8iQRaqa3zWn8JRT/xrr4K967f6k+fdTWb9KvBgdtDKaj10jXfQk95lfzDFr9dzxXVFd9UmJlqyWMN1mEqKFr9zgtEB47ABa0OZVb+VaK4K0DeVyrvfSGp02SKHrONM0nYhCNWEE5rsVhsZaIrUHyjfH6d36BfPTcUeC56x37i1kJ7fnFva/A2nd7JQX3EvrGaMRldilmJypUue9aXVH6+Hz+Xpt6HW0RdJir5hcmK9cUbv51zS1XOCpWhn494m+Ue3qhGJzoZMgHM+gT1soqTMcW/jkIdr7QqyFCdBMowCGRqoZtrlF5ZLoo3pX2w7P9Piyiw==
ARC-Message-Signature: i=2; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1785930196; c=relaxed/relaxed;
	bh=Q8tXROnhtzWgEtAv1OeMz+DF3v0IIxHXQX+EH+skMVQ=;
	h=Content-Type:Date:Message-Id:Cc:To:From:Subject:References:
	 In-Reply-To:MIME-Version; b=hoQpIx4IKrWrosS6G0CtW+bC8NKmPnqLVRKEOdxAD6Wx4U1CLO1N4DxhFREWmkHU4SXJajLsBshG7PT5vhgisJUkNnZIWHU6WziZbUQfZTGY0R01N5Onp0becCLhh0zi6mVPLSGpt32EJIHsTsOPrXFuVGj1AXzuaVTK/JTt4lyp83ZdnqYgXYj1H4CwWwceO9VbAQfSKo7VpU3BID55EnpdtZ5ijzlfN+BHDBjzFyhVRVu+j3D56c5DJhvJ1ZdC4UZawW09SloR5R0MQAvys6l2aQX7QvgeEzrPWsYFPhdnVp7SIF4JFWRFO7C6iwIjMv9UP+L7Bpv1rZR5Fbyk7w==
ARC-Authentication-Results: i=2; lists.ozlabs.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; dkim=pass (2048-bit key; unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=XwFiOdZa; dkim-atps=neutral; spf=pass (client-ip=2a01:111:f403:c107::1; helo=ph8pr06cu001.outbound.protection.outlook.com; envelope-from=ziy@nvidia.com; receiver=lists.ozlabs.org) smtp.mailfrom=nvidia.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=XwFiOdZa;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=nvidia.com (client-ip=2a01:111:f403:c107::1; helo=ph8pr06cu001.outbound.protection.outlook.com; envelope-from=ziy@nvidia.com; receiver=lists.ozlabs.org)
Received: from PH8PR06CU001.outbound.protection.outlook.com (mail-westus3azlp170120001.outbound.protection.outlook.com [IPv6:2a01:111:f403:c107::1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange secp256r1 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hFT7Q3STwz2xpn
	for <linux-erofs@lists.ozlabs.org>; Wed, 05 Aug 2026 21:43:13 +1000 (AEST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fzooYuxINBgfDP4nShN+MHUJesRm+LM1rNd4KTS2Be4hF3U033YWk15adD2YoJ3AiGGfhRsPUa4+mtNf7f2MNzNUQcYeeb3AzelrBjnxT/rdSFddfyxpWEqD8xE4V4HM3CcVLYfG3+VWcEpucwZzwrmYRs6j6xUbzEJ2hE3XAY2tNOaOVjzLR2mk5xipbpz5u6lkNzbWKAgHzo784Bt6wEbSyI0IqeJYlRdOL1AhwgI1Lntd/xY1Q5yQaOKQgkZahHvo6ouFyddcvGFxJV8cbTrOBVkpiItlTpD5cMIzB4eO+UryDQEPImESSEpDH69IDAnEDUPXaT2j5FqQCZY2UA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Q8tXROnhtzWgEtAv1OeMz+DF3v0IIxHXQX+EH+skMVQ=;
 b=WvpRxJf0cBbXGvJkoNXlYjYmfJGak0p+Cs6RV3uX75cLqn69mMn/gLNWB69y4x/Re2cOcMpKbweZYizOEXgx4t0GXLIZi40GTu4b2Lh4wAhQMFxZp4aitZYkdrC9jB2KdFL2WAhbftmC/WQPNaf9/31dCW8pheMUE4zKvS57mGCRW64ISKN3HNSZRFi3qjZx7K0CKg0SIWpE8csg0rIuS/uiXN+l3lYPf+sxlwcBq9aUKR1S8ceXK7ZGgHbene9zEQUR+e4EbnQaVcYHUPjjLtGEahh1KNfyLhYt8rZ5w4LeXi2p6KygCE7Dg4cXPAXuXC5hlTLP6yrxzvF4Gl3H3g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Q8tXROnhtzWgEtAv1OeMz+DF3v0IIxHXQX+EH+skMVQ=;
 b=XwFiOdZakfzGH8xqDM+934AdSCoayRkSboBYoOsPEv9ihw+T2hyrtp1D/KUVqaJUbrefbJuRh6E5crYK3jXFrO5VxbZzalTs3isSoKRBgOVlRopFp/nMszHXNfdAQpik4GDlTyWH0nW8QLiUEun5K4qhxpAdnK08u13OW5jI6O6hisC/UGJbUNzOR/x//2GdxI5caOd1Jw+evE0BTNWihobzF73KXLNLbFLRjui12TnwQlNlJYwDiIel7SFekx3ZOvT1Eo9OYhI0wze8Foxna5m9ToBUXZcdMmVLFJe9LiYuuF7Gu3RUqLuB4rCMzAOH5Xb46Fc/DhKeSYEIUEAxLw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by LV3PR12MB9142.namprd12.prod.outlook.com (2603:10b6:408:198::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.270.18; Wed, 5 Aug
 2026 11:42:39 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0292.018; Wed, 5 Aug 2026
 11:42:38 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Wed, 05 Aug 2026 07:42:37 -0400
Message-Id: <DKGZEK0AQP6R.1RTQEY44OQD65@nvidia.com>
Cc: "David Hildenbrand" <david@kernel.org>, "Matthew Wilcox (Oracle)"
 <willy@infradead.org>, "Andrew Morton" <akpm@linux-foundation.org>, "Muchun
 Song" <muchun.song@linux.dev>, "Lorenzo Stoakes" <ljs@kernel.org>, "Liam R.
 Howlett" <liam@infradead.org>, "Vlastimil Babka" <vbabka@kernel.org>, "Mike
 Rapoport" <rppt@kernel.org>, "Suren Baghdasaryan" <surenb@google.com>,
 "Michal Hocko" <mhocko@suse.com>, "Baolin Wang"
 <baolin.wang@linux.alibaba.com>, "Nico Pache" <nico.pache@linux.dev>, "Ryan
 Roberts" <ryan.roberts@arm.com>, "Dev Jain" <dev.jain@arm.com>, "Barry
 Song" <baohua@kernel.org>, "Lance Yang" <lance.yang@linux.dev>, "Usama
 Arif" <usama.arif@linux.dev>, "Gregory Price" <gourry@gourry.net>, "Ying
 Huang" <ying.huang@linux.alibaba.com>, "Alistair Popple"
 <apopple@nvidia.com>, "Johannes Weiner" <hannes@cmpxchg.org>, "Qi Zheng"
 <qi.zheng@linux.dev>, "Shakeel Butt" <shakeel.butt@linux.dev>, "Kairui
 Song" <kasong@tencent.com>, <linux-mm@kvack.org>,
 <linux-kernel@vger.kernel.org>, "Gao Xiang" <xiang@kernel.org>, "Chao Yu"
 <chao@kernel.org>, "Yue Hu" <zbestahu@gmail.com>, "Jeffle Xu"
 <jefflexu@linux.alibaba.com>, "Sandeep Dhavale" <dhavale@google.com>,
 "Hongbo Li" <hongbohbli@tencent.com>, "Chunhai Guo" <guochunhai@vivo.com>,
 <linux-erofs@lists.ozlabs.org>, <linux-fsdevel@vger.kernel.org>
To: "Jan Kara" <jack@suse.cz>
From: "Zi Yan" <ziy@nvidia.com>
Subject: Re: [PATCH RFC 07/14] fs/erofs: mm/pagemap: add
 readahead_folio_reverse() to avoid folio->private
X-Mailer: aerc 0.21.0
References: <20260731-remove-pg_private-v1-0-142c97ba3562@nvidia.com>
 <20260731-remove-pg_private-v1-7-142c97ba3562@nvidia.com>
 <332rknj4vo3cfhvfhhlf6pvg37s3lbrnzbbnv4swa6gctsiu6a@ndotgokvnglc>
 <DKFGTVA0XD01.OZYNYUOU9FTX@nvidia.com>
 <huzyeqj6a57nbcqc23v6f6rdhkob5552fcwy4mlrsagycqi4rz@ggsapkumc2gq>
 <DKGA508ERSYM.26RBD4HYM1SL8@nvidia.com>
 <2evaxdu6cobpnzzer3y7fsrqvmtmhj7gm3e5buebdaw564igx6@7bs5enipxnpx>
 <DKGBQHP25RE0.3NKUQSDULAQSX@nvidia.com>
 <ivg5x7hjo4tmpd34i6wrd5cp2v56c3vorwru7h6kqxnqlcpte7@lvd7xa4ncwxu>
In-Reply-To: <ivg5x7hjo4tmpd34i6wrd5cp2v56c3vorwru7h6kqxnqlcpte7@lvd7xa4ncwxu>
X-ClientProxiedBy: MN0PR04CA0002.namprd04.prod.outlook.com
 (2603:10b6:208:52d::13) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
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
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|LV3PR12MB9142:EE_
X-MS-Office365-Filtering-Correlation-Id: 5ce06ff3-f5f6-47da-36b8-08def2e6a6b7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|23010399003|376014|1800799024|366016|56012099006|4143699003|5023799004|11063799006|10067099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	5pcg7hjAwzLk3sKKuyfkYeoxJG0hhBCvORcAfBPd02sZsAq3hWQPYUsg+vgQy49RihLtV97ksHFGPt9iZyxpTFQRebMGe+i61kepjc8jQS8oIDG/oWrAPVRo6v7UHhcm4zKubhze9476b7I6f4VD8rYpeaGpg/ryksTv0UP11yFpqdRFt7Vb2Z0c36JSEReoPChfJquWuynbVr3ZBLIAbM9v68ZwnNIYINHyl6Je3qwDNprWBS/1uVNKas4x3EeMq5l/dCEsKpsXsGbxOA/jsqzMEbvB8fp7aobfVFrBM7QAzk+jNibpT0zRaxFBFexTs9xY6JFQq7EKVLfma08+wlpkwm5qHndCE2JptM+my0/nkbU5dwOcdRhRJXdP2ndAucqoZPAZfIXZcTiNedM2MCJc434zzGW0QC1rSuod7oW566V+/LFKyoJDEAwTiTvkyxBSryF84+9qNW6NZ4QY7vR0ctb/OqYgSb/vvJrCVe/KJAjVY9/LiMYxbTAufaeTY5WDsFpx5bChe+fQCHqObqdQx1nHml2RCpG+R9+nQwozelEuV8eY3AKnn+YJZaYStjNEPboSABIIBtCXeOgIOOkrcfY9zaphah3qJvEPbNWImoUPFtlkeeGrU1zRRreEbx3jNkw/pwcU7d7YKCSSVonDy8fvpkHa7qUOcQUHF4g=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(23010399003)(376014)(1800799024)(366016)(56012099006)(4143699003)(5023799004)(11063799006)(10067099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?OEFyeHp5R0FvQnkzdkJIOHE0SW9JZkZCbmE4Mm8vMnJaUEtZZE1VSVV5VU03?=
 =?utf-8?B?Mmp2QVdjcXlTZnloQjMrOW5ZNStpVFVoWERZdXJRK2NhcDNFcHhxekFHeldB?=
 =?utf-8?B?NUdCdG1SR2JKNzhSSk9CbEt2YmIzOVZxYS8vUjVVdVdJMi8zKzQ5em10dmJV?=
 =?utf-8?B?bmV6ZS85eDlabHZjYUpBcWZWRUxsYmJPOTRpNXJKNHR5L2ZlMmYvWUk5ZnNr?=
 =?utf-8?B?eE9DRDVoMWFJeUV0MjZhTDRoSVkvdzRBaDRnVVlHMEYzN1VTeW1sTFY3dVZG?=
 =?utf-8?B?MWNFL1lPd0hjajdlWGhTbytaUlBXdHZ6M1JvSnVwMG4ySFdrbElXWnE3SVp0?=
 =?utf-8?B?TDB1RTVZV1pXdVpBVHo1anZ6Z2dTc1dXeDZPS3doVmFvUnZrUjBoK3d0Ujkz?=
 =?utf-8?B?TDN2TjFQT2RUZjdnc1ZQQlJFVWhIa25CMFB1WXZyT1h0c3ZsV3VrQjZQdk9t?=
 =?utf-8?B?UFBicS9HcXVJREFvV2xZend1LzE1Umx4NmdKUVFQWWZWMGVCb201MnNrbG9Y?=
 =?utf-8?B?aUxGTmd3eEtUc1RxRzY2YmhSS2Y4Q0ZqTTBnY2RIOVVkbHdSMGROVFU2V1F5?=
 =?utf-8?B?YTJJVk92dURYN1J3cmhPOUpxYUlWa0dMSVRMczBtWWJTVnp3azdrQWlEbURz?=
 =?utf-8?B?aG94Y1ZoMHVUZXNSZzFqL29TVE14TFFsZkwzSFFmZ0tJVE5YR211amJqaU94?=
 =?utf-8?B?ZkVrcC8wY1ZpdE8vN0Vic2JoUSs0UlNxSklXSXVFQjhEQkZ0Z0J1WEpjc2Z2?=
 =?utf-8?B?TkU0YklrcnJnbFhDSlhFNitxOXJ1NGpQT1lmRFV1WEpJb2FYMFpKR0lwT2k1?=
 =?utf-8?B?WDlKZzVYeXA3SktiNU9FMXpiZ0VmTkNrT3o0YXpaT3R4MlJjQkQ0bk9YNkE2?=
 =?utf-8?B?Y1J1c0lNMXRlOTh2OFdCU3pmc1ovc2t3TE1lcG9ZZEROd25VSEk2UE9vY2Qz?=
 =?utf-8?B?QW9nK3NuRXpZdlFXSW9HYkxmK0w2VVdreDJsNzhpZG5RTFhsUU5ZZTZXMzQ3?=
 =?utf-8?B?WmJMbGNOazI3YmtnNDhudkR4NWZFYmhuK1d1bVN5NmdqWEhjSGxGMnltU2Nq?=
 =?utf-8?B?aFAwVVJ6aGNKZW9LWlpCVFZnZmJ4NUpDeGFXczBycEJwdUV4MWhTV0xMeDhu?=
 =?utf-8?B?T0pBekUyOFdFMzZBSW0zSjN5VG9RakVKVmxCSzFqdzd2dE9rdFp3VlVTOGhp?=
 =?utf-8?B?K2FRSGhsbEhkanFKMUlSQ0ZoeUdzWmw2eEZmWXBzZ1dLTWNYYXE2K01PMGVJ?=
 =?utf-8?B?bFZSSXlxNTlRRTVlbG1nRVpsb0V6V3dlTVpPYlVXS05SM0taRDlLREVhaTlF?=
 =?utf-8?B?VVlxVnRDaHVuWVhmSUI4dHFNSkpSYWtRZkk5R0VKTzF0TnNGVFhYTURBcmFV?=
 =?utf-8?B?aW9kTDQrWXBHSTVVZE1RK3BjN3g3ZnJBcE42NG42ME1rNU9Na3YxekdSMG9m?=
 =?utf-8?B?dVRiNk1pYjBHYkNYWWRaRm9LbDgwbTZZZVUrRXU3YUdlS1BlWVBIK3hZS2ZQ?=
 =?utf-8?B?QVZDYmlmQks1SWFGeGZUNXhXaEpDWk9BSW9YVmdzN0MzSnhJdGQ0S2JEVFl5?=
 =?utf-8?B?dzFydmhjZmZvSVdGMkVXRUhnbzFwYlRCSVdFU1RzOFhRYzhoTjdSaVV1YjNZ?=
 =?utf-8?B?QVl6MUszeVBBcE5DajVYV2cvdTZWM3lrNThkTTBJbENiTU82RHRLUXJBVVpv?=
 =?utf-8?B?R0d0VFVEOGhXRVJQb1hnaGFzWkluajlxclpFV2RmRlZZZnE3bVZNejdFQXFn?=
 =?utf-8?B?WkJRYXhVdVhPSnZPOWwrckZId3p2QUZBd1M2bjU0Z3ZSbkQrQktIVDdFbDQ3?=
 =?utf-8?B?azVSWW44cmNTLzhRNnVNV0M1a1VHWU9ETkRhYmY0RC9tZlNhNXJDUFQ5UnZT?=
 =?utf-8?B?bXFTZ2pYNlZYcGptUk5sd2x0TVdwU2g0U0pYS1ZxMldTNzlmU2gvRWRCVE5o?=
 =?utf-8?B?dldRMlozVDFzTE5SbEkwaG80dkRkSGd5VzFqT05xVGJkRGVBYTUzOEtmZ3Ns?=
 =?utf-8?B?V0QzUStRcU56YjJWaDU5T05ScnVBWEcwaUxyYXlkTkd0V0dVWTI4TFRSWUJE?=
 =?utf-8?B?SXgxem5FQ1ZGbmFNcTN6RDArVXRoQ1pQMjNNZ2IyVGY1Q0lvZ0pJaVJxR3dq?=
 =?utf-8?B?dEZ1djNpeVlPZ1NPL21oNU9FNE8rMk1oSjdQdWdUMFBsVGpTVSt6ODRycFoy?=
 =?utf-8?B?WjZkRWEyNC9YN0J6MjV3Y1BFeGx1QWIzdUpYNFlpYlZoNWIrZXBaUml5L2w5?=
 =?utf-8?B?UTR6TjhVR0NzelNDdVd3WWtwQnM5RUJKeUtCMUk2czZYYTl0VFZBOVJJWS9W?=
 =?utf-8?Q?4097320iasubhFD1Dz?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5ce06ff3-f5f6-47da-36b8-08def2e6a6b7
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Aug 2026 11:42:38.8299
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ycGubgkmt6Bk23RwlcSpW/P/8wBBBAozictGVAXAhqQD4+Tg+pcQEX6wrUPsCpx2
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR12MB9142

On Wed Aug 5, 2026 at 5:25 AM EDT, Jan Kara wrote:
> On Tue 04-08-26 13:09:46, Zi Yan wrote:
>> On Tue Aug 4, 2026 at 1:04 PM EDT, Jan Kara wrote:
>> > On Tue 04-08-26 11:54:41, Zi Yan wrote:
>> >> On Tue Aug 4, 2026 at 5:32 AM EDT, Jan Kara wrote:
>> >> > On Mon 03-08-26 12:56:36, Zi Yan wrote:
>> >> >> On Mon Aug 3, 2026 at 5:54 AM EDT, Jan Kara wrote:
>> >> >> > On Fri 31-07-26 22:13:30, Zi Yan wrote:
>> >> >> >> erofs needs to traverse readahead folios in reverse order to ac=
hieve
>> >> >> >> maximum performance by
>> >> >> >> 1. reading all folios from readahead_folio();
>> >> >> >> 2. storing the prior folio pointer in folio->private;
>> >> >> >> 3. traverse from the last folio to the first one.
>> >> >> >>=20
>> >> >> >> Add readahead_folio_reverse() to achieve the same function with=
out using
>> >> >> >> folio->private.
>> >> >> >>=20
>> >> >> >> It prepares for a future commit that replaces PG_private checks=
 with
>> >> >> >> !folio->private checks. After switching the checks, erofs's use=
 of
>> >> >> >> folio->private without bumping folio refcount can cause unexpec=
ted
>> >> >> >> outcomes, e.g., in filemap_release_folio(), try_to_free_buffers=
() becomes
>> >> >> >> reachable.
>> >>=20
>> >> <snip>
>> >>=20
>> >> >>=20
>> >> >> The below is what I come up with. I did not add a bool to
>> >> >> readahead_control, since I think that is the decision of caller of
>> >> >> __readahead_advance(). But let me know if you disagree.
>> >> >
>> >> > The reason why I wanted bool in readahead_control is that if some c=
ode
>> >> > ends up mixing readahead_folio() with readahead_folio_last() things=
 will
>> >> > get confused (because __readahead_advance() really wants to skip th=
e batch
>> >> > returned from the *previous* call to readahead_folio[_last]()). Wit=
h the
>> >> > bool in rac, even mixed use will properly advance the state of the
>> >> > readahead_control. I don't think mixed use is very realistic (at th=
is
>> >> > point at least) so I'm ok with leaving that for later if you don't =
like it.
>> >>=20
>> >> Got it. I am trying to figure out your mental model of how the mix of
>> >> readahead_folio() and readahead_folio_last() works with the bool insi=
de
>> >> ractl. By looking at readahead_folio_last() code, it is almost the sa=
me
>> >> as readahead_folio() with __readahead_folio() inlined
>> >> (__readahead_folio() is only used by readahead_folio(), so the inline
>> >> can happen without any issue). As a result, we can get rid of
>> >> readahead_folio_last(), add set_readahead_direction() to set the
>> >> embedded bool read_from_head, and use readahead_folio() only. This
>> >> removes redundant code in readahead_folio_last(). One thing I am not
>> >> certain is whether we want to
>> >>=20
>> >> 1. use set_readahead_direction() explicit and warn readahead_folio() =
if
>> >> read_from_head is not initialized, or
>> >>=20
>> >> 2. set read_from_head to true by default, so that only erofs needs to
>> >> call set_readahead_direction() to change read_from_head.
>> >>=20
>> >> The former is less confusing but changes how readahead_folio() works;
>> >> the latter is simpler but implicit read_from_head state might confuse
>> >> people at some point.
>> >
>> > My idea was: readahead_folio() will call __readahead_advance() and the=
n set
>> > rac->forward =3D true. readahead_folio_last() will call __readahead_ad=
vance()
>> > and set rac->forward =3D false. __readahead_advance() advances from be=
ginning
>> > / end based on rac->_forward value.
>>=20
>> Got it. I can do that. Just to be clear, it should be that
>> readahead_folio() first sets rac->forward =3D true, then calls
>> __readahead_advance(), since __readahead_advance() advances based on
>> rac->forward, right? readahead_folio_last() as well.
>
> No. I wrote "and then set" which means after and that is what I really
> wanted to say. You still don't seem to be understanding the logic of hand=
ling
> the _batch_count. _batch_count is the length of the returned batch.
> __readahead_advance() updates _index and _nr_pages to remove the folios
> returned in the last batch from the range. So _forward needs to contain
> whether the last returned batch was taken from the beginning or the end o=
f
> the range and __readahead_advance() uses it to update current range
> accordingly (before we go and return the next batch). We cannot clobber
> _forward before calling __readahead_advance(). I hope things are clearer
> now.

Got it. Sorry I made some assumption instead of asking my question, so I
misinterpret your words. My question is who sets the initial value of
_forward? So that __readahead_advance() can update _index and _nr_pages
correctly at the first time __readahead_folio() is called?

__readahead_folio() does:

1. update _nr_pages and _index,
2. return NULL if _nr_pages is 0 and set _batch_count to 0,
3. return folio using xa_load and set _batch_count to folio_nr_pages().

after the change:

1. call __readahead_advance() to update _index, _nr_pages, and
_batch_count based on _forward,
2. update _forward to true, since it is __readahead_folio()
3. return NULL or folio based on _nr_pages.

Then the first time __readahead_folio() is called, who sets _forward to
make 1 work correctly?

Thanks.


--=20
Best Regards,
Yan, Zi


