Return-Path: <linux-erofs+bounces-4494-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 11DA7C79FAC
	for <linux-erofs@archiver.kernel.org>; Tue,  8 Sep 2026 02:57:10 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hf7rh2x3Cz2xdb;
	Tue, 08 Sep 2026 12:57:08 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=pass smtp.remote-ip="2a01:111:f403:c112::5" arc.chain=microsoft.com
ARC-Seal: i=2; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1788836228;
	cv=pass; b=CrwzxqhcqKQgzHAVMrpfp5CGAzIIDfp7sdkLfenkza3mz5HDSru+4BW2kJIVOPbWucJtgnGIBxJdjg3PX0hja243eo1ZjE+gmCnXF9f/PuOIOlp3RMhNvcopBC0x9B3AIr7UdBsV6IZZiz2yk5U3ExiCBygUJhm1TrDyi2rN7CQw+6HKR0dXafVCoSyCGh60VLNG6hS0lHt/ln0sAIfbhpb4pH9Qvpuo0znjNAROq3T4fM/yZtBpUotRtW4Xrw6KWD1fWfRtxmbCq2GQ52AVRUCdrS7pPyili96Ns8alskAFeqZmH9csNJPizO5KOInkXXhFpVutjyVTZBjlrF0i+A==
ARC-Message-Signature: i=2; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1788836228; c=relaxed/relaxed;
	bh=TdNRyqMDkb3BmGbYVJZS1+iB76Ykn6dxm/qTa4UIFcE=;
	h=From:Date:Subject:Content-Type:Message-Id:References:In-Reply-To:
	 To:Cc:MIME-Version; b=e1y782hdA9nbYLGb3xAeMXYe7zc+TSo89ARcfA0HTH8xCiUizRbkotV9EMXlmVsZiw3DfUnxL9q4H29f9fWiPrmwKaydhgE9PGLojXv6xQcOtTTW7YaocswO/HsjBGif+RjxCqLvEqbzScHikNv66gAezT8pQNeb/wdUFafkygb89eX9b2HWDNtpVjQxb/RtBPkeDLEnZnb+iDi299P8oZRZV9OOC03kdPGc8GtOaOLoG4m9+IVNdST1W4G5RzKNDdbtfOGQ17jgT8poBXGC39c5PjHfDWcDE608zYqtTm1u/Tw4wo1A45baERQ3hCgULdcrpCf9voBRGVfmjmOu5w==
ARC-Authentication-Results: i=2; lists.ozlabs.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; dkim=pass (2048-bit key; unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=UTX5adrn; dkim-atps=neutral; spf=pass (client-ip=2a01:111:f403:c112::5; helo=cy7pr03cu001.outbound.protection.outlook.com; envelope-from=ziy@nvidia.com; receiver=lists.ozlabs.org) smtp.mailfrom=nvidia.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=UTX5adrn;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=nvidia.com (client-ip=2a01:111:f403:c112::5; helo=cy7pr03cu001.outbound.protection.outlook.com; envelope-from=ziy@nvidia.com; receiver=lists.ozlabs.org)
Received: from CY7PR03CU001.outbound.protection.outlook.com (mail-westcentralusazlp170100005.outbound.protection.outlook.com [IPv6:2a01:111:f403:c112::5])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange secp256r1 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hf7rg2pDSz2ygp
	for <linux-erofs@lists.ozlabs.org>; Tue, 08 Sep 2026 12:57:07 +1000 (AEST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KL41QZJR11aFmKrH3jutgImdYlIfe3FhYo0d0uhwFTcZvoFK5omxZjoGez8xdyjf0T4IhBA5OMdptART/mexFaMg+IWjrtmMNlqo7jsuGCrokV4E6qqSRBM4LV8bgiEGIcCKRlyMtZ9cL/JAlaqE+uFsO9nrcQ3QKYsOw5MBd+MAzcbMOvyeHqezS1PcVkw+aeMk9DmAqL3BkbP2tklfIE0jKHiotlzRKjOA9c2VzlfNsV8xCw5jEP19MMNuBeX51cT9arOZ407UgP8ds2ELViJAb7BNVIK7UktvAznHK/oTb2uzpFDFkA5guD0teBJRvLyJET5vntKLX88mWJPSLw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TdNRyqMDkb3BmGbYVJZS1+iB76Ykn6dxm/qTa4UIFcE=;
 b=wyAr7vGjuRISKu0s7lRXt0bUou+e8m61bnESSM/8eNTwYdLG1zAvzIQiXZoBBFO75m0Hf2yfsCFFkswZudxZapfhYfmQnsZHd7mG/zzhsboDFC9Nc7iOPnlklO3yftf9GkDvGdV1n4Y0sY77MWI8koVMbIUq1USZE2NXFpzixW3bqRI6CQWq5vIF63tiHNUVQPtasGzjwUs+NCGtJp5+ie2kLlkBzWyOP4RW/atXAJyHRVNqoByC5zecn/blfvp/9XVr6CQnbLeFX2Hh9I1nMwpD9fg2UBHGJnLqzn5hRZjLYJptIZ76fkmqXg+djoczjoeXPjp/60VCCnlHHnguCA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TdNRyqMDkb3BmGbYVJZS1+iB76Ykn6dxm/qTa4UIFcE=;
 b=UTX5adrnk48FjVAqNjba7kXWn9QuYJDnfacrJfYEf/5HvcTR7qAJOv2C/XHRKo7u8VozMy15f3ymNBHaRrQ3i7D4L4HpnTLo0WqYjIcOfMfLAffcHlD7x32MGynDBiE9gbmNcNHnbl8ucUAXJY1WlEqIBfXqzlONs9SfwKTYmQ+Qb2H6SM+itfE5WtKmQ2o/r5M3U/AfH6ETJi0ACZXiXaaiN+dAzGUqO1god67kDeKRyGGoDJVofN2Yvm/9JV5LUJvhfbZkGgQnpjhORv+np5p8Ay3ognOv0wR/riQKzS7Ue8Ftm5RSUgshiRPaDQhE2eKoGUuwlJAQn8a+b2m4aA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by DM6PR12MB4435.namprd12.prod.outlook.com (2603:10b6:5:2a6::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.15; Tue, 8 Sep
 2026 02:56:37 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0382.014; Tue, 8 Sep 2026
 02:56:36 +0000
From: Zi Yan <ziy@nvidia.com>
Date: Mon, 07 Sep 2026 22:56:14 -0400
Subject: [PATCH v3 07/14] erofs: mm/pagemap: add readahead_folio_last() to
 avoid folio->private
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260907-remove-pg_private-v3-7-6ae22f9d9272@nvidia.com>
References: <20260907-remove-pg_private-v3-0-6ae22f9d9272@nvidia.com>
In-Reply-To: <20260907-remove-pg_private-v3-0-6ae22f9d9272@nvidia.com>
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
 Chao Yu <chao@kernel.org>, Jan Kara <jack@suse.cz>, 
 Yue Hu <zbestahu@gmail.com>, Jeffle Xu <jefflexu@linux.alibaba.com>, 
 Sandeep Dhavale <dhavale@google.com>, Hongbo Li <hongbohbli@tencent.com>, 
 Chunhai Guo <guochunhai@vivo.com>, linux-erofs@lists.ozlabs.org, 
 linux-fsdevel@vger.kernel.org
X-Mailer: b4 0.15.2
X-ClientProxiedBy: YQZPR01CA0090.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:84::27) To IA0PR12MB8374.namprd12.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|DM6PR12MB4435:EE_
X-MS-Office365-Filtering-Correlation-Id: c69e0301-0161-410f-3540-08df0d54cc1c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|366016|23010399003|1800799024|921020|10067099003|56012099006|11063799006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	Aqe6NclWX0d6nOQVg5a0CrN6uKh+O1ETv6f2tnAmIwPylA6pDmJLiaicrqN80GRLJYo1Dc7+9E4xzWOoXWNtMofdFpeKT+BP3itg2svljYr9zwW6fnRco/3MB4rGw/KUc1q/TaMVN3/Mzz026mMRbhaWdWr5pG4Ar8utzZyJf7Qt0DEt/xWdS93qbXQpzxsXQpQNFYoZYG7c7AZLj0uiCbFkQ39XvDQ5z7jaQ44PMmKOQsqHrTD5CnZUsu69cqAg+oGXKO/DgC21uYSbqRay9hPsV2jXqRHn8q1IllGUpba85dV17CuOoNSr487J+74DSSu2P2auaRSq1luDvIbjfDcmygYEtDXFQQBUy39VMqcV+sCMZCkt6c/9rLSWqZ5jAtK6reyXCM3IAnIgdLVbVZmio1sm+48CQlU4bos+ynANxSVm/WD6Dso7pol2YBpTjBc5LMgCMvSADdWHii1VCE/QClc2xwd4GQ6kxGY6+tQ7rTnvrH2cASja5CMxCghkN72qPZQI0t9sC+J4rr4PyD0hO7eJhHTqOmvULPWKJv1/AK++v6w/qL7P9XKLoQTG0X3Aa/GSvarMtHGw3U6d6jxT3x7PU+4uyZRY8QlwjEEcvQEA0hkcDgXWH6pq2ovVQwYmATRNsPoxVQPFfaoe9XmRTWEx7+3WQi4lMPLsjbNafeEiCwcth4D9+/SLzYejAqQqh0eajeT3PFsMInbshA==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(23010399003)(1800799024)(921020)(10067099003)(56012099006)(11063799006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?NWJ3OHkwb1pDQ2tHQkpiMTA3WXNla2FSbjBHSk53STBINk5UaDBOalEvSi9p?=
 =?utf-8?B?ZFpTRGZrcDhlMlJRbzAwZWVWc1ZVQUhJVWFmUFRQSXdaYnJpd2lKaWdKR01L?=
 =?utf-8?B?Yzh1RWV5NDlMaEgwYTh3WCtqeHQ0MS80YkJQMk9CK0pBZEZYRkJuakkzQ1Qv?=
 =?utf-8?B?Tm9kNlJxWUpXQ3hzUWdZNlJBWmZ1WENYSWFRTWptQ3Frek9vSmVJK1cyWno0?=
 =?utf-8?B?V0tSZ3p4T1JaMGZBUHI4eGcvOGg3SEhLMWxFeFB1SWxncTVSU3hCOUM4Yms2?=
 =?utf-8?B?ZG9kTE13WXZWbDFRUTRHRVhCcDgrNHpaMWQ2TXk5TW1GUHpNV1FqYkJya2hW?=
 =?utf-8?B?ZEVPdVNLSUx6eTM0REg2SExxUzdDOWZDdUhJNkd3R1ZyRTJvd2xkWE1OWXR1?=
 =?utf-8?B?VTl3N2F4MkFmV2FtVWhBbEpOOXBhWXRmQ2VzK2I1eVJmSWRCZUhpWS90NDlF?=
 =?utf-8?B?MWxiYnRIVWVJMndSckNPbkEyYVpNcythbmJmM1IwY0IyM0RGMGJNWXFFOGhp?=
 =?utf-8?B?TFFFNGJyV0dwY0dTL1c2bms1a1lxbHl6TWE1Y2wxR2lUV0hoT0NhWHg1RGYx?=
 =?utf-8?B?UnlPMGF3S1REZCs3eUZiV0g4UnhIOCt1ako2czhiWW9nakFkeFFoUG5WOTQx?=
 =?utf-8?B?aE5rdkIwZGE5aGFOdjVIbHpnM0hVYXZlZVVETXVzVk42enVWVmxsU3NVdnlv?=
 =?utf-8?B?K0xOUWR3emNWak5oNjR2Z25heXlmNUJkc09TS2g3Wi8ycW9xSlJlUWRMUE9V?=
 =?utf-8?B?bXlIMFBCSkQ0cWtUUlBpK2VGaWkxUzZSU2wxNmNnM3k1NWVFUUxkdFhVMmdo?=
 =?utf-8?B?aWZQYVhrZXlZR0UyakVTaklUWnhMM1V5NUZob3JTRW04WXdlRUJUU0lhR2Nm?=
 =?utf-8?B?Vk5SakJCZVdSTXNzZXVIVzhhbEhsQW1nbXBKSUJDR2tDZEs3TXZxN2tUa1pj?=
 =?utf-8?B?OTlJb2FVQ3oxRk1KdStOTnZxQUptV3BaeGRLQ082MVpaOEJaR1dMT2tOaFdL?=
 =?utf-8?B?TnFFcy9FZEJDVUZWZEhkR3lhcHpPdjNSNTZvVWhjcG1HRzRGaFRFQlRFQnM5?=
 =?utf-8?B?ZGFCSVRWWXFRU3VhTU1QbUIzOGMzWWtPaTdrRkk0Rm5uZUlBRWN2VDNpSjVG?=
 =?utf-8?B?dzZ6UXlCWW9Db0FlUUFCV2lEZEhvTUlNNE82V1doazdManVhcEdFUkxtOVNq?=
 =?utf-8?B?VUU5RzUvbGpnRUtCV2dTWmx4ZG0vSzBKYnRzQ3dTQmNaYXhldzZCcHZCbXlm?=
 =?utf-8?B?OG1jaGo3K2lGNmtyRjQ2KzNhdWhWbWk3bk5ockxmUERxUFcwZllRMWRTTCtn?=
 =?utf-8?B?UlVTaEpWNWZ6QUV2ME4yRnZFdmVOUG5NTkdLLzZhNEtST3NYZVg4YjA1a3l0?=
 =?utf-8?B?ZnBnbXZHZkd3U05GY0U3S2ZaQS9xTDFEalZIVi9DWnlmdEFQMXR4Ujh5UzJs?=
 =?utf-8?B?K3krc1RBZFIycERQdkk1dXk1K1pSZE80aDc1SXB5WkdkcTQvSnZxU2grQm9R?=
 =?utf-8?B?QkkwajRCd3Y0VWZuSEkreW9YNitxampaNStUTVdnUE1NYmh6NXFZTWpBbEtE?=
 =?utf-8?B?UmdCTW9obUNwdmJoUVlKNkc3SkxiT2NGMTJNYXdZY0RMWVlOdXBjNDNWajlk?=
 =?utf-8?B?VG5FdVhPZTRoOFdxd0Z5NDM4UmZGSEFkekFUcmltc2ZlVys1ZVI4VW9TVjZt?=
 =?utf-8?B?Mi9MeS9TMEdsYVphU1puSmR1ZStrNVNKZU94Wm5MRWdBYldJSGx3dkZoeDlG?=
 =?utf-8?B?YzB4RTVuNVpjZkJDenJWSTlNS2Z0aG5wRW0rZjV1c0VyNlZyQXFEeUV3VXZv?=
 =?utf-8?B?SFNIZk1wTHdSV1pZV3YzS3I5dGRuMzVoY2pCVDlhSEhpd3ZjeHExdHZ0UkJy?=
 =?utf-8?B?MUpUNXVBRDg0a3Q4R2pFcFBNMHE0MkRVeDdvdVdxV2x2RUhaSk9mUUpIZzVy?=
 =?utf-8?B?anFDdTVDaW1xZHBXdlRTcWdEcnUzOTZvVEt6YlZHYlVLWVh2Y0w0aFlma0lP?=
 =?utf-8?B?OE5ua21hNFJhQUV1NDk2N2hvUWFIYnZDL2U4dnBVS25GSURHdHU1YlEzdW16?=
 =?utf-8?B?dTUwVHpxak9hVXJlb251eCtnUG9WbWpBd3hubXJMa1ByTHBGRlNKcTZtcnFN?=
 =?utf-8?B?ZGE2cFRpd3BScHd0N1BaYWRGSW5EUzJiK0pKdWtkbXpOMDlCTlpUaEwyRzEz?=
 =?utf-8?B?QTRHdm1Kc2svaXBSMUl6WXh5SjZJakd5aUcxNi9qV0JKbGlLblVob3ZkNGtn?=
 =?utf-8?B?QnRveGtCN1kySGg4bU1HRndYb1AvNVdqbHlMTzVBN2FoTWFmcUk2QU54L1Vi?=
 =?utf-8?Q?3O3JRBoeklz/EhtTSJ?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c69e0301-0161-410f-3540-08df0d54cc1c
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Sep 2026 02:56:36.3885
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Nl2CYef3LNoJ2tUh/5eCicjMKAaZRcVuLMSyMqBwnUQizYRTPO5brmfEQChiNMeT
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4435

erofs needs to traverse readahead folios in reverse order to achieve
maximum performance by
1. reading all folios from readahead_folio();
2. storing the prior folio pointer in folio->private;
3. traverse from the last folio to the first one.

Add readahead_folio_last() to achieve the same function without using
folio->private. __readahead_advance() helper shares readahead_control
adjustment code among __readahead_folio(), readahead_folio_last(), and
__readahead_batch() by checking new private member, _forward, of
readahead_control.

It prepares for a future commit that replaces PG_private checks with
!folio->private checks. After switching the checks, erofs's use of
folio->private without bumping folio refcount can cause unexpected
outcomes, e.g., in filemap_release_folio(), try_to_free_buffers() becomes
reachable.

No functional change intended.

Assisted-by: Claude:claude-opus-4-8
Assisted-by: Codex:gpt-5
Signed-off-by: Zi Yan <ziy@nvidia.com>
To: Gao Xiang <xiang@kernel.org>
To: Chao Yu <chao@kernel.org>
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>
To: Jan Kara <jack@suse.cz>
Cc: Yue Hu <zbestahu@gmail.com>
Cc: Jeffle Xu <jefflexu@linux.alibaba.com>
Cc: Sandeep Dhavale <dhavale@google.com>
Cc: Hongbo Li <hongbohbli@tencent.com>
Cc: Chunhai Guo <guochunhai@vivo.com>
Cc: linux-erofs@lists.ozlabs.org
Cc: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org
Cc: linux-mm@kvack.org
---
 fs/erofs/zdata.c        | 13 +++---------
 include/linux/pagemap.h | 56 ++++++++++++++++++++++++++++++++++++++++++-------
 2 files changed, 51 insertions(+), 18 deletions(-)

diff --git a/fs/erofs/zdata.c b/fs/erofs/zdata.c
index e1e25ca0d1904..78fd7d980e957 100644
--- a/fs/erofs/zdata.c
+++ b/fs/erofs/zdata.c
@@ -1898,21 +1898,14 @@ static void z_erofs_readahead(struct readahead_control *rac)
 	struct inode *realinode = erofs_real_inode(sharedinode, &need_iput);
 	Z_EROFS_DEFINE_FRONTEND(f, realinode, sharedinode, readahead_pos(rac));
 	unsigned int nrpages = readahead_count(rac);
-	struct folio *head = NULL, *folio;
+	struct folio *folio;
 	int err;
 
 	trace_erofs_readahead(realinode, readahead_index(rac), nrpages, false);
 	z_erofs_pcluster_readmore(&f, rac, true);
-	while ((folio = readahead_folio(rac))) {
-		folio->private = head;
-		head = folio;
-	}
-
-	/* traverse in reverse order for best metadata I/O performance */
-	while (head) {
-		folio = head;
-		head = folio_get_private(folio);
 
+	/* traverse from last to first for best metadata I/O performance */
+	while ((folio = readahead_folio_last(rac))) {
 		err = z_erofs_scan_folio(&f, folio, true);
 		if (err && err != -EINTR)
 			erofs_err(realinode->i_sb, "readahead error at folio %lu @ nid %llu",
diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
index 939f3a5e973f6..2257df004305e 100644
--- a/include/linux/pagemap.h
+++ b/include/linux/pagemap.h
@@ -1415,6 +1415,7 @@ struct readahead_control {
 	bool dropbehind;
 	bool _workingset;
 	unsigned long _pflags;
+	bool _forward;
 };
 
 #define DEFINE_READAHEAD(ractl, f, r, m, i)				\
@@ -1479,18 +1480,25 @@ void page_cache_async_readahead(struct address_space *mapping,
 	page_cache_async_ra(&ractl, folio, req_count);
 }
 
+static inline void __readahead_advance(struct readahead_control *rac)
+{
+	if (rac->_forward)
+		rac->_index += rac->_batch_count;
+
+	rac->_nr_pages -= rac->_batch_count;
+	rac->_batch_count = 0;
+}
+
 static inline struct folio *__readahead_folio(struct readahead_control *ractl)
 {
 	struct folio *folio;
 
 	BUG_ON(ractl->_batch_count > ractl->_nr_pages);
-	ractl->_nr_pages -= ractl->_batch_count;
-	ractl->_index += ractl->_batch_count;
+	__readahead_advance(ractl);
+	ractl->_forward = true;
 
-	if (!ractl->_nr_pages) {
-		ractl->_batch_count = 0;
+	if (!ractl->_nr_pages)
 		return NULL;
-	}
 
 	folio = xa_load(&ractl->mapping->i_pages, ractl->_index);
 	VM_BUG_ON_FOLIO(!folio_test_locked(folio), folio);
@@ -1516,6 +1524,39 @@ static inline struct folio *readahead_folio(struct readahead_control *ractl)
 	return folio;
 }
 
+/**
+ * readahead_folio_last - Get the next folio to read, from the tail.
+ * @ractl: The current readahead request.
+ *
+ * Like readahead_folio(), but walks the range back-to-front. The folio is
+ * returned locked with its refcount dropped; the caller unlocks it once I/O
+ * completes. Compound folios are returned once, at their head index.
+ *
+ * Context: The folio is locked.
+ * Return: A pointer to the next folio, or %NULL when done.
+ */
+static inline struct folio *readahead_folio_last(struct readahead_control *ractl)
+{
+	struct folio *folio;
+
+	/* Drop the previously returned batch from the remaining range. */
+	__readahead_advance(ractl);
+	ractl->_forward = false;
+
+	if (!ractl->_nr_pages)
+		return NULL;
+
+	/* xa_load() follows sibling entries, so a tail index returns the head */
+	folio = xa_load(&ractl->mapping->i_pages,
+			ractl->_index + ractl->_nr_pages - 1);
+	VM_WARN_ON_ONCE_FOLIO(!folio_test_locked(folio), folio);
+
+	ractl->_batch_count = folio_nr_pages(folio);
+
+	folio_put(folio);
+	return folio;
+}
+
 static inline unsigned int __readahead_batch(struct readahead_control *rac,
 		struct page **array, unsigned int array_sz)
 {
@@ -1524,9 +1565,8 @@ static inline unsigned int __readahead_batch(struct readahead_control *rac,
 	struct folio *folio;
 
 	BUG_ON(rac->_batch_count > rac->_nr_pages);
-	rac->_nr_pages -= rac->_batch_count;
-	rac->_index += rac->_batch_count;
-	rac->_batch_count = 0;
+	__readahead_advance(rac);
+	rac->_forward = true;
 
 	xas_set(&xas, rac->_index);
 	rcu_read_lock();

-- 
2.53.0


