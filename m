Return-Path: <linux-erofs+bounces-4584-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A96F6C982F1
	for <linux-erofs@archiver.kernel.org>; Mon, 21 Sep 2026 02:29:05 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hp6cF07MBz2yfH;
	Mon, 21 Sep 2026 12:29:01 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=pass smtp.remote-ip="2a01:111:f403:c10d::3" arc.chain=microsoft.com
ARC-Seal: i=2; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1789957740;
	cv=pass; b=UNV0lvtqJWh6HU/l9HNmqGHcZHI2Wk8jgzl0y8NlQx4P4VSuk7MT5/1xGibCjALTQmYcNH1entjkTpxagdOb4oSpujjzbmY15I5LM5kJCWnc9XvH16PQL7Kd3J+83Y/4NuAOYHrjnIz2q/VPEjvyRP97UU9hYhhxRZFzdb+Vy8h9IfKFf0hcwGCaPDX9lD52mvzEJSE4b9gda13dGgXwRPMczcArZTI34JADQzzBtv1ayZT+CWJBgg7UtrKx5VYavoUfAehetUUqD3pWmMtnjUw3BFai8uFFfccV6dD4ZIvwJRuf4xgSeN32W5P7lCORbFymPyfJtmeS2a1BxWoXmw==
ARC-Message-Signature: i=2; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1789957740; c=relaxed/relaxed;
	bh=nPTaaAaUzrdA2lTjP7M/nU3VQaZ7JIh6OoJnL2DeSEw=;
	h=From:Date:Subject:Content-Type:Message-Id:References:In-Reply-To:
	 To:Cc:MIME-Version; b=Wvp0L1oqm5o9Bf7O/E/cB6N1qUdUiYni3wDO+DLlqPl+r0gY5NxFuYWANb5jKMEnA2wcFat/+GUq1C8SNWhV84E4ytXIleqq0EWWy/FliOruMUJTsJz3O8Eblo0tARVHzBbxxxzhjCfODJE6kejcMoFfMtrz5nXfzemzlnZgMWgd8004PpCvgd5j58vJHiltaNiTVdOn1U3ambvWYiW2GgHaXypZgdY6CNk14lHPKN/fmJTTnmLkxr0uMeQPMyulFaZITyL5jDzUEtEq7EPENTTm1VsDQrR5NW1jMI+upuAIm8nGroBK1G/H38VCSyVU6S7wFH/BRPkdy0ZxFFX3nA==
ARC-Authentication-Results: i=2; lists.ozlabs.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; dkim=pass (2048-bit key; unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=oGl2a5j4; dkim-atps=neutral; spf=pass (client-ip=2a01:111:f403:c10d::3; helo=sn4pr0501cu005.outbound.protection.outlook.com; envelope-from=ziy@nvidia.com; receiver=lists.ozlabs.org) smtp.mailfrom=nvidia.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=oGl2a5j4;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=nvidia.com (client-ip=2a01:111:f403:c10d::3; helo=sn4pr0501cu005.outbound.protection.outlook.com; envelope-from=ziy@nvidia.com; receiver=lists.ozlabs.org)
Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazlp170110003.outbound.protection.outlook.com [IPv6:2a01:111:f403:c10d::3])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange secp256r1 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hp6cC6kMYz2xk7
	for <linux-erofs@lists.ozlabs.org>; Mon, 21 Sep 2026 12:28:59 +1000 (AEST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=twtCxW0KDC2SVbQpp5tCPNvO/RoV2jUi7rLHRMSOy08dPgwQEctg3DrgMmupjTzIMCIlV64WXYh75aSmgmcTlKrYEvbcK3dWOewcWXpY2hJjVPDboyjtrOYIHhPGF0Wn8mEcesxkNfiVhTgCfLeV/pfvpr9AhJ52aD5Tg+Pb/bcowxcwtT8IOZ8GkoTh6dbxRrCU7GoLgK3JyWZqweSyVVdam+C5UHQAtisVGY4b/xWiJ9ZKH5Jsw7WuOmMCbTVR7o7fTaz8oJwhcK/TCX3UM2qTJyyk3xKmdF5agrAeH+w9JF9oBQHG/HyanHRIH3qqk0jVXgx7UXCdayI3rBM84w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nPTaaAaUzrdA2lTjP7M/nU3VQaZ7JIh6OoJnL2DeSEw=;
 b=VAhohNB0Tu3lKAOMszzjSDXOkUb1b2pdttHReXUa/MxIzPfMtBsYgKU61y2Y5F5PIxfJED6P++Y2DtIF8WVigz8m1Q6HQRBaTaikht0fDK9uXBgzPQXOXSF7MH+g1ZO+2J11KoPDjQDYwF46dMwdlAUGVFXSNTx+GE5gbS2tAVebLO6/hzorg/dPtAN1KZJ5HZOBDqwJn7Uui5/dvMvC+87dQwhC2KdxRCpe2Wh9K7m0ME9I3W+8Zp4mmIuuVW4D2C4EUi0LacB+OGg0/ZX5jXxQyzRyb/1X+YRhKnZtwQdT48D+JHQVnoQrw3VF2RXZv6fWVAnSGeoCUJeBaGjvUw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nPTaaAaUzrdA2lTjP7M/nU3VQaZ7JIh6OoJnL2DeSEw=;
 b=oGl2a5j4gSKBysQ3nCTzeNsnwJeDz5lsmbvmP7hAM9Pzs6ULv3vIVF19C4w7UFrvdbqZ8v2PF9g+ciNHrDEalF0+X0jD7EaBvuGL8PCcg9JAgFImiNuMGwHH+hGKm9pnBO4D131gNNzr/75JhER/j3cHqDWNJWf9nAt5Z5nG9UeMGeRYDYJl1lhkhApRPDn9qGpx587hYeh7PWGctWtSyfaGAmP12mPP1xnNHVDyeXUoANpkTWqNyIUIRM9Vp2ZcRqgHaGrgIA2k9Af00CWx5kHb1y4qqsq4JTHeOPTrZHOUynSu5jZMSCJa7JioZ3pKyyLxGzidmpmBt8cqoPHPDQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by DM4PR12MB7719.namprd12.prod.outlook.com (2603:10b6:8:101::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.16; Mon, 21 Sep
 2026 02:28:32 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%6]) with mapi id 15.21.0428.014; Mon, 21 Sep 2026
 02:28:32 +0000
From: Zi Yan <ziy@nvidia.com>
Date: Sun, 20 Sep 2026 22:28:05 -0400
Subject: [PATCH v5 09/17] erofs: use folio_attach/detach_private() instead
 of direct assignment
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260920-remove-pg_private-v5-9-bb68b6a21869@nvidia.com>
References: <20260920-remove-pg_private-v5-0-bb68b6a21869@nvidia.com>
In-Reply-To: <20260920-remove-pg_private-v5-0-bb68b6a21869@nvidia.com>
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
X-Mailer: b4 0.16.0
X-ClientProxiedBy: YQBPR0101CA0198.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:67::35) To IA0PR12MB8374.namprd12.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|DM4PR12MB7719:EE_
X-MS-Office365-Filtering-Correlation-Id: 723911d4-99b5-401c-a992-08df178807f3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|23010399003|366016|921020|10067099003|56012099006|11063799006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	PNuyHesrmuj1E9mLlA8pqpzhvhNQQFWZ3LoRMsfWCDx4SPrn74WRL2d2p3WlVvKdJTWu+q4bePe5cUau/oZ3nXMWl1PevQox6Me6ZjGOC6B2nQu6Hfn83S2otmW+J8+POAiQrosGaZ3911rGfW7pC9NjyqOTgDzSTY5ISA/zIk3wxXqGw1yxXNgsbY3n+vxJ7pEMMl/QtTmyhG6CkuEs1ky9oqVlEgiopaKmRCR/KqK/5P9X8+k9RkJy+/BbhhFgoMFsQW/EDbzayVErBNovkhi46EoACM6as7H+ixFStHKqrstX1jws5uW4yjsIDNQmfrGFRvsF67pyu/xtQXJQs1y5YcYWCDHWwwOSMZJHM609P0+PF8RkfOH6gWZrPxJvHHeI5yoCdPcFOPUqFJH2duJ6MA6QKXhyS7U0IWofvCq/L6CIPjA+gxJb3SIRH+J6WDvfSMbbnzA7VvNsNFejEmbJfPZGt68mNtpYu+z/wwG3Rk9nsmWTOQSLFaQaWYcpbdGfjE9+k7Ghmnzw9s4iaSAYTMHNWmGvq47wLuRWwWjPjlkW8CgBQFlXtUzLwy1mKLNmzsXHwKt+q0oHsZP+ohVBK0uaXwnmoka9yfoNcTcGZ85sM05jLxGuEUnLaVDP/95MQEWf7kkDInM7FC3JE7ABRtGG1s7agAHgc6MXT+zPyPACw0veFFzDqFN1UMbBkCOp2qSao5H4ws0k1ZYHsA==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(23010399003)(366016)(921020)(10067099003)(56012099006)(11063799006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?UU1QWkJndG5QM25aemIxYlZwT0VxeXVqcGx5b0RQTko0ZUptcGhIU0VKNjVB?=
 =?utf-8?B?clRIQVRuYWtWVG1aYmMrdnhya0g2eVhIa09pWDczc29CUmgxYU91cGx4c2Y4?=
 =?utf-8?B?V3FWREdIOTRRempRRkpodzRrS2QyTnV4Z1hGUHcvN1VzUmYrTDJldElGWG5R?=
 =?utf-8?B?c3VCallPMkV5U1lMbGhlRjIxTVNnSXVCNUo2clY4dXovNlhWdlFyYTdPbHpN?=
 =?utf-8?B?cnkrRDBwVU0zU0V6VVRRZUdJdXBWQXlvV3MwYmZadVN0cFlJRlZoRFJzN2ww?=
 =?utf-8?B?QjE5TnVRY0dzWmNFaUd2dE9JMXY1Yms1Y0N3V1huNWdITTB3M3pDMTRpQThq?=
 =?utf-8?B?cStFYTBlSUlQTmNxd0dkUWZIeTFLZ3VQU2tZT2NRYitXc1ZLMHdQVkRPSEVC?=
 =?utf-8?B?bmo5bTVJMEh3VVlEYVVIOGZQcjJiQStkc21KK2hrNDVxTU9KNUFlUkFsNmZu?=
 =?utf-8?B?R2p1ODJYOW4vSGZ4NHNWSk03bEFXc1dlaHdtZWdwMXpkWjlzU0ZRejJhYXl6?=
 =?utf-8?B?WngySUQzMFVoeVlKb3FKYm85U00vY1MwTHdXTHQvK0Q2QUJpTnJ4cGlyT1J5?=
 =?utf-8?B?bEkzSVFNSGw5eExWbmNOYkVwZWgzWUdXZE1rQmxUMzBCMVVmNzVoNWxBNlh3?=
 =?utf-8?B?N3g5M3R6OEtJUUJPVlQzM2swQWNIdHhtcllRTVFpZzRtMWkyaUJic0JLS25r?=
 =?utf-8?B?WFRtN21LdjlGdS9xdWp6ZEJvMDFjbUFNQ3dRRDFyMytTRk90MzZkOW42NUsx?=
 =?utf-8?B?ZXoyZG5aUm1GZGF0L3BEUmVYNXFyb0dDOEtKUHRacVhWWG44QndFQjdhTDNW?=
 =?utf-8?B?eFU0bUhKeGdEOGp6ZnppR3dXV2FmSzNFQXBTL0tXSlBnKzhURXlzVHErZDN2?=
 =?utf-8?B?TGVHZ0I1a2lvSm1HNG9WZXJTd1gyZHdTY3YyTmtEUHYvcjB6RjFaeEplRUM0?=
 =?utf-8?B?TUhUTVg5aW1EOVo3Ny9CRGlpZHpGQm1kZFV4NURET2xGUTNmN0JkOEhOQndy?=
 =?utf-8?B?ZmRhVXRpMWRsREdLTG1mczhXTUppVjFNcXBLZXRab0RsSzZEZ1N3MWpBTmwy?=
 =?utf-8?B?NEdjMnlueWVlU2pOY3h4dXNZdHI2cGpqeGdPYUc0T0dMVTVRY0Yxa210NFhC?=
 =?utf-8?B?Rm5EVU8rZnI3b01ncVlDK2p4QjFDRENJSXMvbHNpRmdudUxUOWNNQzZOWDRx?=
 =?utf-8?B?RER2YlNGakgwWDk4emI2TGlxOWVIUDRPUmZIWFk2aTA3TGdRSHlSQWFsMVFO?=
 =?utf-8?B?OHE4RG9zNHh3c2g2cEJhTU9VSnRXVklLSXdsQURYeGVvZ3hYdWZvNUpkWldw?=
 =?utf-8?B?RWVnRWtFeEhRL2ZGcXAzYkhTK0RRZit4TGtlZmVwYk9sQzA4bDdJZ1BuZ0dw?=
 =?utf-8?B?eHRwVVRMNU90QVc3Tm9ReUxPUHRSMWFaMHZwVCs1OGpVMGVPekdvYjBJd0la?=
 =?utf-8?B?QmNuaE56cVVleW5tajNCNkRYYzZKNU4vQWs2T3R5bkp5bUNQUDdlOVMyNU1X?=
 =?utf-8?B?YTJpaUdwSkkxUHFrNjRteFduc3RUb3BZZUFTbjhvbENUNG9YUFcvdXN0eHRJ?=
 =?utf-8?B?aVpOeUNoYzE4STk1M0Mxc3V0T3pTMjh6dUNqTnEwc2JFQUlJc3hSNUVRL1Nl?=
 =?utf-8?B?cWdVcGMxNXBmcmlkYzZWUUkzU0s4NkVISGNLWFkwVVc3MVdJT0JlclZKWTZs?=
 =?utf-8?B?U05KVlJNUVpwTldPeUl2UGxiNy9hamF0MmtsWlVtc0N3blVreVRGemplaDhC?=
 =?utf-8?B?RUR6UkJ2M3ltdGRiM1BBNnpNc0dFK2NseVdTZDZuTDZudGEzM1ZjOXJMVXVW?=
 =?utf-8?B?S0lwbzVON0xUaXJlU3ZUYmZBVnNyU1NkRE5CQTRMTDgzYndZbkxJcWduNzB3?=
 =?utf-8?B?amc1bCtOM3BQZUJUOGpVeFd0V2xFTWF6UTdNMlVEOG5vTFcyNmhpMXVCRHY5?=
 =?utf-8?B?OTFNYjVPNHpMTDlSWXRjbjYvVlJkV3pVWFZlcFowMTRjTlhoNEUyL3A3aTUx?=
 =?utf-8?B?dzZWRGc1UzB6YzkvYjgvaFJZYU5wU1V1bFNCREVkc2N0VXZrV3Q5L2JXNzY2?=
 =?utf-8?B?MTAzSG5ONzBKQmtYa0ErSWpoZkF4ZFE4T3owY1hKaHlqV0lYZEZBWThtZmgw?=
 =?utf-8?B?aXhuL2VBdi9abXI1UzV1K1VsVUNqblM2NWRKZ0xYS0xlUjErYW9Tc0hhRDlD?=
 =?utf-8?B?L0kyTU4rOGFTVVNiM0hxZVhmWEtKcG9NV2R5ZzR3R1czMWQ0WmE3cUE4Ukx2?=
 =?utf-8?B?L205ZmxWVSsvL0JtSXhzWE96Q2VRYkRIQmJWY214U29lTnpyNzUxUE9tWmEx?=
 =?utf-8?Q?cHKEIe3L3jDsclZmmz?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 723911d4-99b5-401c-a992-08df178807f3
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Sep 2026 02:28:32.7682
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FEv9DBxbxwGBBqjDEY/R3i80TptdyJOfLD+0QIDF09x5rcQgHQkB8ZrUySKP1GY0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB7719

erofs_onlinefolio_init/split/end() use folio->private without setting
PG_private or increasing folio refcount and it works. But after PG_private
is replaced by checking folio->private in a future commit, it can break
folio_expected_ref_count(), since the folio has private data without
elevated refcount. Change them to use folio_attach/detach_private().
Folios during this process are locked as they are in the process of
readahead, so no parallel migration/folio split can happen.

Furthermore, because folio->private is used to store in-flight I/O counter
and the counter reaches 0 when all I/O completes successfully without error
or being dirty, ->private=0 causes folio_detach_private() to not drop the
elevated folio refcount. Solve this issue by using bias=1 for the counter,
so that ->private stays non NULL throughout every attach-to-detach process.
Add a macro EROFS_ONLINEFOLIO_BIAS=1. While at it, fix the comment about
->private bit layout and add EROFS_ONLINEFOLIO_COUNT_MASK.

It prepares for a future commit that removes PG_private.

Assisted-by: LLM
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
Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>
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


