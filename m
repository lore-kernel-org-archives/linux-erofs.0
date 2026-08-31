Return-Path: <linux-erofs+bounces-4393-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A9DAAC624A4
	for <linux-erofs@archiver.kernel.org>; Mon, 31 Aug 2026 19:26:35 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hYfB16bnSz2yDs;
	Tue, 01 Sep 2026 05:26:33 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=pass smtp.remote-ip="2a01:111:f403:c105::7" arc.chain=microsoft.com
ARC-Seal: i=2; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1788204393;
	cv=pass; b=gg/jmH27hv4UxNcSS+2RmqVHdGt/FR+C8zF+fqcsa82ucbOKVKg5ERbPmmxozApTlfeswDRocRHC+HEUtmVUjgpCGSW4DVL2zUiITj+3b9pIDy1LWtu4NiRGAQkd3/iqMJOhWYVuUYYvRfigKfZI/p8+nGB4pj5qVOmBYetBGq5DFdwGql9KlKS0atcvztKhqIsA9sPHMqj/wGF4M2hfyQMqw2TjQkGZMmVH0gMrV3I9VmR8NaPh33D/0tWdhH6ZTW6v75nN7bztFv/JDVqyVJyKv1y6SMEIEVgOG8Tlw++rC965DEiMlGpVpDvbGQHPWqWAqD/x9/fAN5J3IM4/rQ==
ARC-Message-Signature: i=2; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1788204393; c=relaxed/relaxed;
	bh=RxnL1o/ICM0JJhQDdSG6k0d/UX7PPpVBK/DANObKaQI=;
	h=From:Date:Subject:Content-Type:Message-Id:References:In-Reply-To:
	 To:Cc:MIME-Version; b=WKe6GGptFa54Mk4YG6LaffbNCKlGt6E+FUh3R6mkmOCpaWfqZerW0ZTZ0c6vu8WohHyCVlmN6YJ/LxzdMxWXwfOpfuIQy3+RZArYRVZu5TzvrOeKtJ2OADH7Y/9G46MV0v5SZOcUeq/mAAav1hq/Tm1Pj8felL9xxxvNetVYZaUyfjEx2r4mkvaAEPh5jVjXE8TJif9AodkUab8IS06yJgQJFIVT9EjvMH1gBZz6r/v4NDC86Q10HO3Sewlq1N6fSLq0/QOnHESee+gL3IFwQ3iDz3ZNVl8F6E+h4jhBx5+T4/SA9uEucUxGe/Z4pv5F7VJ6V2VIXmiEOUWKtp+fnw==
ARC-Authentication-Results: i=2; lists.ozlabs.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; dkim=pass (2048-bit key; unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=soCBs0AI; dkim-atps=neutral; spf=pass (client-ip=2a01:111:f403:c105::7; helo=ch4pr04cu002.outbound.protection.outlook.com; envelope-from=ziy@nvidia.com; receiver=lists.ozlabs.org) smtp.mailfrom=nvidia.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=soCBs0AI;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=nvidia.com (client-ip=2a01:111:f403:c105::7; helo=ch4pr04cu002.outbound.protection.outlook.com; envelope-from=ziy@nvidia.com; receiver=lists.ozlabs.org)
Received: from CH4PR04CU002.outbound.protection.outlook.com (mail-northcentralusazlp170130007.outbound.protection.outlook.com [IPv6:2a01:111:f403:c105::7])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange secp256r1 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hYfB1035Wz2yCt
	for <linux-erofs@lists.ozlabs.org>; Tue, 01 Sep 2026 05:26:32 +1000 (AEST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=sSL5LbE4nHeBU7uKXRFoIJzKcH6yft2yxszKALYuDDlvX4KYyjfsfLlr17Xl+4ZFYVe89At3axbO+k9Wd0DvRkoXCLDUtYQm0tziGiZ5DiVRg/K8yHdL18SdYPE86Jemu1Tzf+YNaEAVdyg60Kg5JIQwmPpcSHt0Ytn4oTxu1clps4hNZ9n4XMlmmO2ggKh+RGN9DAufVZcX6WsQb0uxi21kmuOUvsS+gE90QsJ3VNkqJb96KwAYV4+Z0fVRt6UaRl8LgqjKrV2SliuvDVq/8yOqvtOTnrzQGe/MYl66ddh7WxrF6UFlOR29V7s/0GE4QP4HTQlxAK8cLf1rXz/p/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RxnL1o/ICM0JJhQDdSG6k0d/UX7PPpVBK/DANObKaQI=;
 b=Oq1t2K/JPiU+QGP+/qxFK0TBgGeJG62SQZr/vZ6vtoH+uky+VFFX8SvY14DPEEEELVkgyDRew5J6ShjQL49Xam0b6CBwHAFD1bD4I1qEl8u+FbG5N3DRCm9mpzUAX1+x1pUWF6/erCv2I8MrFVKL41xxjgKSOZ+TkbaYW3SZo+s2HvGz8fGHtojqrvY5iLcIGwDz3RxWgos8LME7vN/b1+M4wdHk6i+fnxqjCVoXbgFhWX6D1/aqrgpCd+mEZnDxnqzpp1vNGrHLD8XoKkJSl08ibwH3QNEKKD5nID9HWGv0hDXYfhlKLX1YczUCV54eBlE6jnafy1nPYZv2gxEucA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RxnL1o/ICM0JJhQDdSG6k0d/UX7PPpVBK/DANObKaQI=;
 b=soCBs0AIqm8UXhXy5Znls8JI3OBp5gw01Y67VLjLczWMmUlgDEPP03GuBU2fbHtco/RZIwGOgc08p9tdBGV/MFAS7r0lxQacSuqV8NsqTCQyRKZMJyxRUomfRj0nMK89tE3LE0Ue6QmoiW9gryrH6170QxLEBqski6c0FatfCqq3LhDEvPxy+BSxezF3i2UYZVnzkLSeZeMyDSMwLSshEmZW8cXoqcRRLtFK29quJAL6Ct290lxA0SWi45gQDs6GDxJLrHO/v6Ub/jU+zFDFlWxTGht8SrZ/o7xKVmPCQKKBhj+YC2qFuFLULJfQDO2j5jiQ9zwY91MYUoTbwtVJSA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by SA1PR12MB8742.namprd12.prod.outlook.com (2603:10b6:806:373::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.360.7; Mon, 31 Aug
 2026 19:25:54 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0360.008; Mon, 31 Aug 2026
 19:25:54 +0000
From: Zi Yan <ziy@nvidia.com>
Date: Mon, 31 Aug 2026 15:25:31 -0400
Subject: [PATCH v2 08/14] erofs: use folio_attach/detach_private() instead
 of direct assignment
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260831-remove-pg_private-v2-8-3668159cd9e8@nvidia.com>
References: <20260831-remove-pg_private-v2-0-3668159cd9e8@nvidia.com>
In-Reply-To: <20260831-remove-pg_private-v2-0-3668159cd9e8@nvidia.com>
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
X-Mailer: b4 0.15.2
X-ClientProxiedBy: YQBP288CA0027.CANP288.PROD.OUTLOOK.COM
 (2603:10b6:c01:9d::13) To IA0PR12MB8374.namprd12.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|SA1PR12MB8742:EE_
X-MS-Office365-Filtering-Correlation-Id: 361f0a3a-f803-4652-7424-08df0795aafc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|366016|1800799024|23010399003|56012099006|10067099003|11063799006|22082099003|18002099003|921020;
X-Microsoft-Antispam-Message-Info:
	wohygzjTx6/d1344MKJ8oO/ZGPY9aGh3/jQ13kv8S7zK0yKyWOynSNdgO3eSsFPPXAuo1h3+PaIGS7dNYfK0eTyk9JAqFbXY9hA1PNf6mmY4jVNw9vTl4AQOZQnmWFT9jW1DOWGG2VKr2I6gRhAsiAV3BQtNI/Pr9IS4zUfIU6OZEWritaV0t1SGqJlkRjSir1ND9qQ0opj2z2WwO+jZuINxoiK+udZP2OcoIAoVRlNLGBhGH/+/xYRxl8PSzTa27v5F2uJJunvXtRRcmyc2OviLvN76l+OlD4iLZLaBJRWrIacxL9Jutini/eRyqCQf3m/8+Ddq9FpRnsc9w1cMei8kfssLT90NVSVmLxrK5TI82T4fiaoUmz6Lqb+5ttL982d1r8Vi/I+PxNaV0+dv2eXSxWJNH3QxRLufKZBftvAYLmTnr3AMhBHGSrWInuZI6mlQO5AKS4Ba0ayLW1Q5j4Cm2kJ6Qt7RFJy0ORC8KL+EFds3JKK2YsItwIfGREHO5XIaa8lYO7bBAjTBLL4rehAxQypaOSJvRDjBl4aBwzlQnyz2vIBAjOt7MF5JMAY81S0bKgXmkvo45lI//Oik4deIKED1tbm/isydI5qw2g/Pvuo74/XfCXXZWZmOe4ws3SpQRSFoe03/A5UKlmGHl2wRsIKpOWpUaS8C52xgMzFsGrI8IoWh/4qGAsYbhJF8m+b66REEuRoSSdZDqCIatg==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(23010399003)(56012099006)(10067099003)(11063799006)(22082099003)(18002099003)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Zm1iOGhnZWhBTWY0Nnl4djdCYVMrVlJOTmZpeTAvY0JQQ0h3T2xkdXg4WHdi?=
 =?utf-8?B?V0s1Ymt3bmRnOWo4dnplQ0hHaHpnWGJ5Y0FkaVpRSUNVUmVBTVNtWGJuU0J3?=
 =?utf-8?B?cDF1OCs2eE1YbS9Ya1U1OE1NS1hPbnUyZm5zS2JnekFUQ3hIN1lCZHJrbWFv?=
 =?utf-8?B?MXVCUmtVWVRpZXFlTnJKc3FxbFhkQkVmV0NKOUVqVkRpVkRwY3l3RzV2bUY4?=
 =?utf-8?B?MnFPaXhoTG1CaHp6Y3RXRmRZcDVCZjBIV1ltK3lCbGZnTVg2Z1JBNW1uTnll?=
 =?utf-8?B?VjBiSmRIaHpIRDM2WU83NDJxMG1CbXgyZGpyUUIxR3F3eVFIdkdwc1dPVW5R?=
 =?utf-8?B?VDN1UDBtYnRmWlMvREZZRVpKRWFFQzFGUno0VVNwVFFtSncwcWtPTUJiQ0k5?=
 =?utf-8?B?ZXE5MEZlRnZVVVQ2NS9TUjNsaklEby84UWFBRGRrTGhLbGxVbXBHZVBxZjhZ?=
 =?utf-8?B?NDhvcVBxdjZrdzlRVUdPQmZSOVRRVVFvNGVmY0RBVWRZVE5nTUZ1SDJObzV0?=
 =?utf-8?B?NVNQZW5OeEV3T2FQL24wbU5MUk9teG4vRjhKZEdlazhhVVZ5SW50aWlPWEhy?=
 =?utf-8?B?aEtadE5TOXB6V1NlM0NpMzdaNXRsVitGNU1hM09BQXdYQkkzSWliMWVBZU4x?=
 =?utf-8?B?NTZsVWFhTjhDcXByaXNLNlFRSVpvYVdwUUFqckZKMTZCUUlRUHpCNlovZVdz?=
 =?utf-8?B?VzVMZEt6Yjd2SjNHL3VYbVNCOUI5SVloU0hCNldJbS9oZHBIdkQwYm9YUDhN?=
 =?utf-8?B?VERNa25LSU5IR2s5V3BXaHVndUZCZ0lyQWpwZm1yb2doRk8xcFdPN2l2eXpi?=
 =?utf-8?B?YThnZE1LM2c0OS80V2JzYWdGZGNqQzZ5dmIwaTJXN05uRGY3MTFiY0U1QzZD?=
 =?utf-8?B?Y3krUlBEdlBkbXA0UzNFMHFwWnhrY0VOVGozR3hRQjFSWjhlQkNnK245OStU?=
 =?utf-8?B?cGVSREtML0h6ZnNwMU9EOFRyMXp0U0tmYzJFVUYvSVdDVUtmOWdXcjFJayt5?=
 =?utf-8?B?R0VwWFk3Y1ZCbG5obVNwMlNBc1g5NEh4TFNFQ2QvdE16Snh3WmZweFppVjQ5?=
 =?utf-8?B?clo5ejZtNGZ3YlRIV0ZXbk81NDRMVWt4Wmc5Mitvcm9WV3RIVy9JVmlLOU1s?=
 =?utf-8?B?Yy84bzNzTkNkYkFmMGtoR0pFdGVPVm5ZNGtyUUlZOXN0SFpEUDZmOEdjdEdo?=
 =?utf-8?B?Qzh5WUFBd3QxcTVxNDEzS2hIS013WWkwZzNsRlJ0QUx1WFVWS1l1YWV2UGZU?=
 =?utf-8?B?R3p3Wi83YzRoaURKaHlCR0NjOHdvbkwzYkVFc1l5N0VZbUlTQlhCZHpUWUQ5?=
 =?utf-8?B?VmdZZHBiRDlQRy9KZkRYMVl3NkcxdW5Fd2l2RThnTXlsWHByN08rMEw3REtv?=
 =?utf-8?B?cXhCWVB4SkFUZzMvVWw0eTdINzJQWUhKYUZ1T1ZHZ29SOGxFTjg5YnBOb0tS?=
 =?utf-8?B?VlVLTkhsek5iS1FWbGlqWUVRa1RadEJibkVrQVh2SDZWaExDZ2MzdktBNjRC?=
 =?utf-8?B?UXVHdjJ4VTVYMmY2YVpxajB5UE1xTSt2a2hoYU00TDVUNDMwd1g2RGdXdTl6?=
 =?utf-8?B?MDR4eUNMQjg2dllraHlqMEI3K0tkTGY4MHZmNngxUU1UeDBXeDFOdnFhcVlr?=
 =?utf-8?B?V2tuZzIrejVIM1dKKy9wQ3BWNE51N1VZK3llVFV4NU1scmZ3QTk0cVVvcGp6?=
 =?utf-8?B?Mm9hcmJ6azF2Q3VBakZLWEd2YTE1bGtDQi9WNFI1NXhGeHBNdWpnQjNMSGZK?=
 =?utf-8?B?SDM4ZGdxbHVCRndsaWpnVmRmTGJleVpWT0VRZ01PMVBnQS8xeEFQalA0RVd0?=
 =?utf-8?B?alJ1NkNRL0NQSTRMU1FMY3pFQVJtcFNoNzJjZWRDZjNXcFgwMkc5UWViMmE2?=
 =?utf-8?B?UURqU0JqaWMvZGJYZXFtVWVqanpwRlNzNjB4MkVLTERkeHBVRjV6N3AyNmVq?=
 =?utf-8?B?SDVrWURSTlE3K2FLc0RNQXpJcGVoT2RoYVVaQjRQTnBzL3h4Rm9hME10WFNy?=
 =?utf-8?B?U3JWcWN1bjJmenRrNkZqcHQ3Z2lwSy9GdVM1N0Y1NmZhRHJRQmpnT0llSXhZ?=
 =?utf-8?B?MkpVMmRJMUZKaGUzQk45M3dUcXF5WngwZ1h0WlJQTDk3VnpUcHBUYUJESGFq?=
 =?utf-8?B?VkRIT3JsRmNPeXRxTUY1TkVHTkJMUGRiQStGOGE1RGVnajlUb1Z1dDBWZi9o?=
 =?utf-8?B?M0NuWldnL0tUN0dtU2tBWDlqblV4NytvSzlqRTI1aWtlK3E3b0R6MENhcEM1?=
 =?utf-8?B?VU1UUzY3OHBRUUNBc3lzRThrWWtpWjR2NGFjb2YrQzc2YjBxNm1PRnhBaWJK?=
 =?utf-8?Q?J1Oe11AQrhUJ3Mk3et?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 361f0a3a-f803-4652-7424-08df0795aafc
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Aug 2026 19:25:51.1302
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Kg4v9lyisokpa4x2ZzKfa7Ot65Vj4wgDGjJ8OYzo8lpPObl0VF0Ca5/HCSS2nioQ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB8742

erofs_onlinefolio_init/split/end() use folio->private without setting
PG_private or increasing folio refcount and it works. But after PG_private
is replaced by checking folio->private in a future commit, it can break
folio_expected_ref_count(), since the folio has private data without
elevated refcount. Change them to use folio_attach/detach_private().

Furthermore, because folio->private is used to store in-flight I/O counter
and the counter reaches 0 when all I/O completes successfully without error
or being dirty, ->private=0 causes folio_detach_private() to not drop the
elevated folio refcount. Solve this issue by using bias=1 for the counter,
so that ->private stays non NULL throughout every attach-to-detach process.
Add a macro EROFS_ONLINEFOLIO_BIAS=1. While at it, fix the comment about
->private bit layout and add EROFS_ONLINEFOLIO_COUNT_MASK.

It prepares for a future commit that removes PG_private.

Assisted-by: Claude:claude-opus-4-8
Assisted-by: Codex:gpt-5
To: Gao Xiang <xiang@kernel.org>
To: Chao Yu <chao@kernel.org>
Cc: Yue Hu <zbestahu@gmail.com>
Cc: Jeffle Xu <jefflexu@linux.alibaba.com>
Cc: Sandeep Dhavale <dhavale@google.com>
Cc: Hongbo Li <hongbohbli@tencent.com>
Cc: Chunhai Guo <guochunhai@vivo.com>
Cc: linux-erofs@lists.ozlabs.org
Cc: linux-kernel@vger.kernel.org
Reviewed-by: Gao Xiang <xiang@kernel.org>
Signed-off-by: Zi Yan <ziy@nvidia.com>
---
 fs/erofs/data.c | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/fs/erofs/data.c b/fs/erofs/data.c
index 0885b1f2fc925..f71c7b51bb720 100644
--- a/fs/erofs/data.c
+++ b/fs/erofs/data.c
@@ -239,19 +239,23 @@ int erofs_map_dev(struct super_block *sb, struct erofs_map_dev *map)
 /*
  * bit 30: I/O error occurred on this folio
  * bit 29: CPU has dirty data in D-cache (needs aliasing handling);
- * bit 0 - 29: remaining parts to complete this folio
+ * bit 0 - 28: remaining parts to complete this folio, biased by 1 so that
+ *	       ->private stays non-NULL while the folio is attached
  */
 #define EROFS_ONLINEFOLIO_EIO		30
 #define EROFS_ONLINEFOLIO_DIRTY		29
+#define EROFS_ONLINEFOLIO_COUNT_MASK	(BIT(EROFS_ONLINEFOLIO_DIRTY) - 1)
+#define EROFS_ONLINEFOLIO_BIAS		1
 
 void erofs_onlinefolio_init(struct folio *folio)
 {
 	union {
 		atomic_t o;
 		void *v;
-	} u = { .o = ATOMIC_INIT(1) };
+	} u = { .o = ATOMIC_INIT(1 + EROFS_ONLINEFOLIO_BIAS) };
 
-	folio->private = u.v;	/* valid only if file-backed folio is locked */
+	/* valid only if file-backed folio is locked */
+	folio_attach_private(folio, u.v);
 }
 
 void erofs_onlinefolio_split(struct folio *folio)
@@ -265,14 +269,14 @@ void erofs_onlinefolio_end(struct folio *folio, int err, bool dirty)
 
 	do {
 		orig = atomic_read((atomic_t *)&folio->private);
-		DBG_BUGON(orig <= 0);
+		DBG_BUGON((orig & EROFS_ONLINEFOLIO_COUNT_MASK) <= EROFS_ONLINEFOLIO_BIAS);
 		v = dirty << EROFS_ONLINEFOLIO_DIRTY;
 		v |= (orig - 1) | (!!err << EROFS_ONLINEFOLIO_EIO);
 	} while (atomic_cmpxchg((atomic_t *)&folio->private, orig, v) != orig);
 
-	if (v & (BIT(EROFS_ONLINEFOLIO_DIRTY) - 1))
+	if ((v & EROFS_ONLINEFOLIO_COUNT_MASK) != EROFS_ONLINEFOLIO_BIAS)
 		return;
-	folio->private = 0;
+	folio_detach_private(folio);
 	if (v & BIT(EROFS_ONLINEFOLIO_DIRTY))
 		flush_dcache_folio(folio);
 	folio_end_read(folio, !(v & BIT(EROFS_ONLINEFOLIO_EIO)));

-- 
2.53.0


