Return-Path: <linux-erofs+bounces-4072-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D9940C55178
	for <linux-erofs@archiver.kernel.org>; Sat,  1 Aug 2026 02:17:33 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hBmmT6kcgz2ygs;
	Sat, 01 Aug 2026 12:17:29 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=pass smtp.remote-ip="2a01:111:f403:c110::3" arc.chain=microsoft.com
ARC-Seal: i=2; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1785550649;
	cv=pass; b=V00PfWuOx+j/Tfzlp93pGBz8bG3gE2HtRbORMdUfwnxU0NZQPLo+uv+DtFF8h4T5RPj9eeVpySpViCiJAXMD1D8NE/FOThzFfhlZgzmTZnsX8OuL7t69vVNQv3fxkJaslE7ZftrAzfku0BZ04uuLFdmobxYj6A5MitygLrHlvEwo4rL7DpjMU9kBLgSYyOCrbBn1Me3RsC9cBOB3irFsHz7lawLKY8awn4cN0gPs4EcWj5RepE+0SeBpaJZYlbEhKAOrzQ8EueaIlzxIcQH8yrgTJ5ozqze1XnTFvpD3DyI5LfBvvm/ptSH0WjhRR+NiLxzsLESK0vvd0TfPBI56Ng==
ARC-Message-Signature: i=2; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1785550649; c=relaxed/relaxed;
	bh=EEncI6jDgQ8oag3wg6GEeAFOusIKNSMwKpxUqu0FYrQ=;
	h=From:Date:Subject:Content-Type:Message-Id:References:In-Reply-To:
	 To:Cc:MIME-Version; b=c78/gXlJ4nmnvWLERlcO47mHSoSzUmAhK1VsfpSmjOZreYxyUjgo/8aeNHQafKtnHnQ0eiJ+w6HLuLnVV2Ns/jEnBwGWmPIxSM3vEGM9DUSPSbMgBLFG/2mkj9WV7plX5ONH0PLRwzlrq4/mlO4eO0xHxIqolIoCmMd5sldK76/3ZkYcYBn8APPlCHWjVf+/u9vi+KIjGWyL1HkbgCdlePAEKPtfM7i0nkRkKQH8fK86xRtmo0FcYOLmycQNYFHgF4RYF5zlP3bZhJBMNQ5cEs8Yb0u80CXTWI0qnNv/9j/MhWo9aTE78OZ1BOPA988spEbYOUmXiLC8lD/wBZ9lrA==
ARC-Authentication-Results: i=2; lists.ozlabs.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; dkim=pass (2048-bit key; unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=rj86P/nd; dkim-atps=neutral; spf=pass (client-ip=2a01:111:f403:c110::3; helo=bn8pr05cu002.outbound.protection.outlook.com; envelope-from=ziy@nvidia.com; receiver=lists.ozlabs.org) smtp.mailfrom=nvidia.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=rj86P/nd;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=nvidia.com (client-ip=2a01:111:f403:c110::3; helo=bn8pr05cu002.outbound.protection.outlook.com; envelope-from=ziy@nvidia.com; receiver=lists.ozlabs.org)
Received: from BN8PR05CU002.outbound.protection.outlook.com (mail-eastus2azlp170110003.outbound.protection.outlook.com [IPv6:2a01:111:f403:c110::3])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange secp256r1 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hBmmT1qvlz2xF8
	for <linux-erofs@lists.ozlabs.org>; Sat, 01 Aug 2026 12:17:29 +1000 (AEST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dUuEEGl2IUJrJD2EqhZcKaEY9wKyXYI7bHbk4HQ1g95Y75vXx0DAdo2YCT11UyqhdMuTBNpXeDITAHkNZqaGvayPzqUrqvUPhCfIieDHgq7l1J17gpsR4E30s/1XpYd50TXW24COyNFvX+E2hLP614Y8j8598iDatWN4kO8X2GSC8jcH6hzrfkFLhWR0X6r0iqQJUtg6ypbxMNYzPZEGuoFXuLMMdjBrQbBeMI02JPvsvq/zm2n+xyBkzxWWKpAbilLopdkjWXFrGSF14tgBZcQq154q8peKIMKAKyYhWH+P8QPmsOuu/uAD+R86yr8aOy30L7o1h1OFCROhmvt+iw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EEncI6jDgQ8oag3wg6GEeAFOusIKNSMwKpxUqu0FYrQ=;
 b=qH5xlpZVQ50RrDAadrjzD3+bU0mXoBL/EILGHIXgh/tyQoGAjdKFDSi2gHalrbk2Tj+BvFtAXM8DVwJSHrHROtp+HiU5v2ISA/oc4OAsNBpA3XvOapAcrroqt/nkR9T3HWsljkRtHc/S3nGt66vEnP1mJ7ygTpEAljbZrZrFigB7amFrL4aYnUroZ/PuCif8u1XJCkgkfSD+0q2PbX4k4bikFI7VInlsLX+JOrNKh1bPecG1Laxfv51Ar6LxzM3ZXaAjiBnuN7C20sUaSyl1fOGeC/j1ksNi9NWLe/+mEerNahWBuExXzs/PGYlMJ2NEFiWTScpKax5XUDNqWX6ZuA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EEncI6jDgQ8oag3wg6GEeAFOusIKNSMwKpxUqu0FYrQ=;
 b=rj86P/ndf2e5ZbvU76BVAWF8xdEfSpqTIMtFJx92fBmAOCpImX1afvJM0bDdN+ThdL3Tvk6ipz/qK2++H7KnlQRibaeyxv5rkQ7bcIaxKM2qkfG7PNU096++FBkwRz5pASkuAonetcJyzvn2XDF95sxtIY3ylWNSkbYl+pCcn2sSci9xKjn7CAHTq5eCcQUAdvipTigQdYTF98OWcifB7YbSWGLbvgDvDaeJRC9huSTYH6XSTAmPKmeeRomGGlpN0WqRIW8sPd4DBizn4zuNf3YEFLq2VckHjbycs+je8mHwrSO6EBWSVPFct8rBV5nd3nqUoMUswrggb2JWLFK+sQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by PH8PR12MB7373.namprd12.prod.outlook.com (2603:10b6:510:217::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.270.16; Sat, 1 Aug
 2026 02:17:12 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0270.015; Sat, 1 Aug 2026
 02:17:12 +0000
From: Zi Yan <ziy@nvidia.com>
Date: Fri, 31 Jul 2026 22:13:31 -0400
Subject: [PATCH RFC 08/14] fs/erofs: use folio_attach/detach_private()
 instead of direct assignment
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260731-remove-pg_private-v1-8-142c97ba3562@nvidia.com>
References: <20260731-remove-pg_private-v1-0-142c97ba3562@nvidia.com>
In-Reply-To: <20260731-remove-pg_private-v1-0-142c97ba3562@nvidia.com>
To: David Hildenbrand <david@kernel.org>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Muchun Song <muchun.song@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, 
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
 Gregory Price <gourry@gourry.net>, 
 Ying Huang <ying.huang@linux.alibaba.com>, 
 Alistair Popple <apopple@nvidia.com>, Johannes Weiner <hannes@cmpxchg.org>, 
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
 Kairui Song <kasong@tencent.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Zi Yan <ziy@nvidia.com>, Gao Xiang <xiang@kernel.org>, 
 Chao Yu <chao@kernel.org>, Yue Hu <zbestahu@gmail.com>, 
 Jeffle Xu <jefflexu@linux.alibaba.com>, 
 Sandeep Dhavale <dhavale@google.com>, Hongbo Li <hongbohbli@tencent.com>, 
 Chunhai Guo <guochunhai@vivo.com>, linux-erofs@lists.ozlabs.org
X-Mailer: b4 0.14.3
X-ClientProxiedBy: IA1P220CA0001.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:208:461::15) To IA0PR12MB8374.namprd12.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|PH8PR12MB7373:EE_
X-MS-Office365-Filtering-Correlation-Id: ef79e80b-cbc1-4a07-5bab-08deef72ff5b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|1800799024|23010399003|366016|11063799006|56012099006|10067099003|18002099003|22082099003|921020;
X-Microsoft-Antispam-Message-Info:
	DYPBZ1LECW4V6HIl14lPv6xElU7H7dGN5vgbu7r9jCi+KStPs2KKfiQ8NP8z9whP1WjIL984USM+c4Dcswg2ei8hHBrSC3yQvIsgkA9Ldg2Cm44RIFuudCoGv/vgFPaMEn9/16Jv/jBPSq6rG54RYE4nR7Cz9xVM4jwi8Nn6j+KKztuQG25s/2fpDTB9WMdhs/Nks/NRF5nozMUJdahWJmW89FcpaLU9heLn3cDJpnEznRS8DNYRLDcYKIMkTE249FwiMAt5Pw7IsMMW0ocULYoyh1Vv5GMRtiQ4wt9cNG7RGPngb8e9liLle+T/0a/IccrXSri3zo88a/Ee+oP+6pznkhfrvJK6eniJVSXHI7e/Gq2ecYYqdTsdX9QjheDD5qL8YagfHfghZahFn5qi+QX2xp9PFuQyom78iaIPbMDIgpk89fNkjhYwE0/Dtzb7u7SZt2Gf5FnV8N/AVkYq3Ih/cDpRc+fQEAULe4sd3gG6QHVkBDyBuTkjyio1wOiV4KjtFyDrelfuELRhQUL34jepE44a2DnZauxHZuFnsWbeSbdHtH9L8xZQ3T+7VdLkMhaKcktCHXh0Wjs2EjlmxmKSV6Id32fmZEuX4QwFww85jgJB8XX++e0SoytLFsfRUvg0yg2GsmS0l7SV4lWi/FcegAnCDdYsbyAm4SsUNGA1hHSGwTJfqQn07rLiEcpMx4P0LPMePccVRaasqmC4+Q==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(23010399003)(366016)(11063799006)(56012099006)(10067099003)(18002099003)(22082099003)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?b0FzOTFkQjBqSXVaYU5vSldYTmtTeVNKR3lGT2xBb04vYzhEK0RCVEEvdC9I?=
 =?utf-8?B?N2tPSEkzcjZBalRCc0FOandwUmlUUUdtWEtuT1BId0NuWWQ1N0J6cXhleEFS?=
 =?utf-8?B?QkJMN3p2QmtZcDRpalM4Nm5tTjdxME03QmZsZDUwd0dwWDNwK25yMzV4NFRV?=
 =?utf-8?B?NUpNUG5ld0tja09ETlFlOUl6NnVtbU1GWm9qcTlPZ0l6YzNDOVNXRGdub2pl?=
 =?utf-8?B?SGgwOWNYVWlJN2lCNXlvYmZmemwvQkhMNkRYNm5ZcUxibTVna2NCbjgyVFpD?=
 =?utf-8?B?RXAxNVpSR0xpSXh0WUZGNDc0b2E1d2UxVVFUMUsxVWthRm1uRkUzeElUWkRS?=
 =?utf-8?B?U2U3c0loRFpkU3lvK001d0hyZXNqYVdNWjhPN2NwcE8wL3hqbWhBRXBzRWNu?=
 =?utf-8?B?SDhsOVZkdUhhaTlrL3ZyOWtlYjFpV1cwRzBISlE4ZTl6VGFoTVNwekFWMzRa?=
 =?utf-8?B?TWJPNmhia1VLSWhFekhvRzhHRVB1T2o4M2w2U0JZbWEzUkVVR3BqamtKUFBM?=
 =?utf-8?B?aUVieStDQW9QQ0xQZmFBTjJXblB0aFVnZ0NTMXpnbDIybmYxaEhQTEZXaUZo?=
 =?utf-8?B?Y2JwWFZyN2hiMVUxQWtTQjZIQzdZMXRRSElBRzFJQ0xoNkdIZnUwTFRzeEhN?=
 =?utf-8?B?TUVmU0NocUgySTdyVmQxZVFMN2JHRVNobkE5cmJyd3hEdmwxQ002N1hpUW5l?=
 =?utf-8?B?cmJvanN0dko4ZURJV3JLSWs4ZTZDMUE5cExFYzVIUnNXNXV5VTZHUktCaHFr?=
 =?utf-8?B?R3JXeHcySUtER1pRUHloQUd2cVdHd0RPZ0FjcGhHOHBuclFvam5FYWM0cU9S?=
 =?utf-8?B?T2IvRGl5NE4raGJIZHVmSHBZdVZuclp1em9MK2JlNG5tRmFuRjhZRGVWNG9S?=
 =?utf-8?B?ZTJqVTlLMTcySm1pVkFYMmNrblh1RW5oL0pPVnIrR0o1MFZDcm1YMHVNcmxz?=
 =?utf-8?B?MXFMUmpyU3hFMHhNNmhsWGRDN2Zoc2p3TitsUVFYdVJ0WDhzNExrcGdXd3kx?=
 =?utf-8?B?VE4vb2dGZ0R1dC9zMHAzaFhaMzI3S0F2a2tDRnlySTdQckNMc21jY3pwR21P?=
 =?utf-8?B?M2Z5TGNPYlB4bEJzRW0ySjNxdklDT0dBK25nT0NvUlp4bmhCM1pUVnB5TlNM?=
 =?utf-8?B?SHE0N3JET29BalpuRDZDdDNHc3hpb3VKcnoxNDZJTjZxYWlLKzBXVkNTOEs5?=
 =?utf-8?B?V3FIT3ErcFpxaytsRE5LT0pvcXhoemVCL1BnMEcxWlRDSEJUa00xcm9iUFZ1?=
 =?utf-8?B?cVZMeEFiZWo2cjhpdVc0SjJ4QVg2Wno4K3R4bEttWlZoVG5BNnNyemJIYUJO?=
 =?utf-8?B?QlBkNysvQTEzY1FzWWNjcWVaVHVVS2JyWGV4T1dsdWpoV09jbjN0N2FVMmVN?=
 =?utf-8?B?N0xLK1M1NStWcW82QkFGclJXK0JpZHYzdlJmS3Q1Uk9uQ2lrQ0xiWW4vVFlo?=
 =?utf-8?B?UjZxMG05ZkpIUzYxYTJGT3Q1QXM5MkFEZ0V3UVRyeHNGekNFTGZ4eDIwZTZR?=
 =?utf-8?B?c3pPZmpTMGhSQS9kN05Ca2hadnFPbmcrWXlQWkk2VnIyL0RyaVZlMS9hOXdH?=
 =?utf-8?B?Y1dzVGFTMVprMDRtYzVDWVlxcUprS2pKT0FZWlNIQVVFKzEvclFkRUg2RVR2?=
 =?utf-8?B?ODFWR21hVFZLc1FiYmk2R0dLTjV5V0RkVWwveVV6Y0IwSEJTNE9LZWExdG5a?=
 =?utf-8?B?ZjF5aEp2cyt6WGhKc0k3M3BXcFJVZGpJSXl0Z2tJaDZjOVZsNjhlSllHcGtr?=
 =?utf-8?B?Z1RWa2xsM2x1YjNwYTNMdmdLWEhCME5UcjlXVG1LTFhsN3ZDV1hkenJ5MnhC?=
 =?utf-8?B?M0tWQVBUc3d1bVdQcEVZNnArZHh0SEd1ZzdFQXh1SGc4Tnc4anBpQkdFNGlU?=
 =?utf-8?B?cVdUcXdYZ1d3VkJiZXgwOU5IUzc4TUx1VXAvcHB5K3E5OGtjNHU2V3pOMHRm?=
 =?utf-8?B?My9qQkhTQzZvcGlCNlZiTWdxUVNlNGxsNDB3U0NrME0yajdqNVl2MFNsR2xF?=
 =?utf-8?B?TDZzaTl3OVhyUVg2bjFZTnJaWW5veXJOWjlDdEF2Uk0vcXRvYTNjeXVtMUtv?=
 =?utf-8?B?V0IrVnc2VHJSNnkwK0s0THdIZ1FaYXpSTWNpdjM0UWtGL3BiTTNvR1p6bE50?=
 =?utf-8?B?NGVlM0pkUDcrNHo5N3Y1Q25PWW9YaERKWXVsUGJsVHExbjZKQ0kyQllzOHdz?=
 =?utf-8?B?OVVCMHd3cXV6b0dFTU9qdWFVb3VMZzlNL0xMUjhBNjQyQis2NGFkOHRETUFX?=
 =?utf-8?B?dzlwWTNzeGtwN1JxcTNSb3Y4N3d2ZlR3dkR5VGM1VWVPMXJjYk05amNDUzB4?=
 =?utf-8?Q?0MVLxJUP2pMHxIUJCz?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ef79e80b-cbc1-4a07-5bab-08deef72ff5b
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Aug 2026 02:17:12.3449
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: k2pknUau9t9GPASVywterpQNPIWNNQMzO1INHwAscrs7AFxf0Gq/9bjtbdaGQESe
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB7373

erofs_onelinefolio_init/split/end() use folio->private without setting
PG_private or increase folio refcount and it works. But after PG_private is
replaced by checking folio->private in a future commit, it can break
folio_expected_ref_count(), since the folio has private data without
elevated refcount. Change it now.

It prepares for a future commit that removes PG_private.

No funtional change intended.

Assisted-by: Claude:claude-opus-4-8
Assisted-by: Codex:gpt-5
Signed-off-by: Zi Yan <ziy@nvidia.com>
To: Gao Xiang <xiang@kernel.org>
To: Chao Yu <chao@kernel.org>
Cc: Yue Hu <zbestahu@gmail.com>
Cc: Jeffle Xu <jefflexu@linux.alibaba.com>
Cc: Sandeep Dhavale <dhavale@google.com>
Cc: Hongbo Li <hongbohbli@tencent.com>
Cc: Chunhai Guo <guochunhai@vivo.com>
Cc: linux-erofs@lists.ozlabs.org
Cc: linux-kernel@vger.kernel.org
---
 fs/erofs/data.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/erofs/data.c b/fs/erofs/data.c
index 9aa48c8d67d12..356665f025fb9 100644
--- a/fs/erofs/data.c
+++ b/fs/erofs/data.c
@@ -263,7 +263,8 @@ void erofs_onlinefolio_init(struct folio *folio)
 		void *v;
 	} u = { .o = ATOMIC_INIT(1) };
 
-	folio->private = u.v;	/* valid only if file-backed folio is locked */
+	/* valid only if file-backed folio is locked */
+	folio_attach_private(folio, u.v);
 }
 
 void erofs_onlinefolio_split(struct folio *folio)
@@ -284,7 +285,7 @@ void erofs_onlinefolio_end(struct folio *folio, int err, bool dirty)
 
 	if (v & (BIT(EROFS_ONLINEFOLIO_DIRTY) - 1))
 		return;
-	folio->private = 0;
+	folio_detach_private(folio);
 	if (v & BIT(EROFS_ONLINEFOLIO_DIRTY))
 		flush_dcache_folio(folio);
 	folio_end_read(folio, !(v & BIT(EROFS_ONLINEFOLIO_EIO)));

-- 
2.53.0


