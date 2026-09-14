Return-Path: <linux-erofs+bounces-4553-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6B42AC88E5C
	for <linux-erofs@archiver.kernel.org>; Mon, 14 Sep 2026 02:24:59 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hjprk46hmz2yQJ;
	Mon, 14 Sep 2026 12:24:54 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=pass smtp.remote-ip="2a01:111:f403:c112::5" arc.chain=microsoft.com
ARC-Seal: i=2; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1789352694;
	cv=pass; b=Qs9ES6nun8Bk+oiuSoqPz32MPrwh0+1aVBWNuo2Za0vXdVnFsm7sKAXj/B4Ckx8cSttA5OwNedWfZT4nTHDtP6gzNA0qp4QNC9tzwXiF44uoJNJwrRmX3bWE3+KGhHfeSXo2P0+6jhO8Kvk4NIcvBQ3Uc1AEpeV2yzYCGSbUTLTX3YRdOhu0btcOBcaUsb0QgUKumdzVjE5AYzfGU98/5ELsCFptQ3dVJP4DP3/w2w/e58qWZ13OcpRQGnRtZgjxCw1jK+x/rNhudZbxhkYYzD7wGlt6UNuk8jeAN0ODzI4s1g20OZ1MEnQyX9PS03ihrJdGr6KmOheOuJb8jvLx6w==
ARC-Message-Signature: i=2; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1789352694; c=relaxed/relaxed;
	bh=5oQkgIZB8g4TSzZHu0Etfeypilmex6FsVP2ICiojaz8=;
	h=From:Date:Subject:Content-Type:Message-Id:References:In-Reply-To:
	 To:Cc:MIME-Version; b=nMfm4iU3mrPRLzmiAq/esfF3e05LC5O5pw7kG+XpUlQcyVViFRVSaFB8uwiJ0FeriG7Y5lgv7K5E/LFbeCNDNW3DQTWGcfn6ZUh/KXP4iV1qxj0KP1imDW6JLNGFTHvFQaytDCqxGlXUzbGoojCyJYA/ZbFVj7qZp4neX6RidDhgjwd20FyoNl8bGPC+ef6uSHvX5eHk49YmlzK4n75rECyYa9EmPuUP+YS1Dmbel4HALmp+BCKX0Q/g86y6EOeVMj4PZo6E94aW5u39u+c3V9T+dLzmXEX7LOBCKK0XnQOq6lVAYMoi7Y/LVLd17j4e08zbAY36IxNAtUcWiA8osQ==
ARC-Authentication-Results: i=2; lists.ozlabs.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; dkim=pass (2048-bit key; unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=HHAKigUw; dkim-atps=neutral; spf=pass (client-ip=2a01:111:f403:c112::5; helo=cy7pr03cu001.outbound.protection.outlook.com; envelope-from=ziy@nvidia.com; receiver=lists.ozlabs.org) smtp.mailfrom=nvidia.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=HHAKigUw;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=nvidia.com (client-ip=2a01:111:f403:c112::5; helo=cy7pr03cu001.outbound.protection.outlook.com; envelope-from=ziy@nvidia.com; receiver=lists.ozlabs.org)
Received: from CY7PR03CU001.outbound.protection.outlook.com (mail-westcentralusazlp170100005.outbound.protection.outlook.com [IPv6:2a01:111:f403:c112::5])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange secp256r1 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hjprj48BZz2yWK
	for <linux-erofs@lists.ozlabs.org>; Mon, 14 Sep 2026 12:24:53 +1000 (AEST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pRZmuEgehrC1cz41bokAttP2SMJ60Zp+62B3kcdZ0ORilhcWfmzVyqY1Q/Z5aeqydB1YItreEmbLCCwBd20bDmB0ZigYCInqWek8lGl4nizGhMKlUgxRhZILeVwlI0Bqp22VpU4/wogUUD5eY0Ow9XAvsDDBKujRDD2ZTT8i2OmT39Ibb7UZ9IpTQq1gIfhufd0zvX2wMD7DA8C2pOGdrCFMBBqwqmlZOHt2SKem4swrJDmkNogtUHGPmBtVSm91L9tNT6ajif5rhDI7JAmPu/cyzTR7wM8QBTk98AYEP4zlOdtcMJPky5qAfls7v320QU3XTz+3GtnBo1yfCq7u3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5oQkgIZB8g4TSzZHu0Etfeypilmex6FsVP2ICiojaz8=;
 b=SIUmOOUjp9reMiWY4nCq7sAHMjs0IYOK78WI+hOp/QP9lClx4oFkawNsQpFUfZj/AINBiHsI+RmQGvEduc4hV5+Ov5myTb4d0bMx8JGY35gJHuQ18dp0Vs8uUeNfMqwhOSjkqgrdQMBCr6vvHLj4PMe8SQAeo9wz4wRiQ8Ut0Vxt8LB70JKGdg491cVBzKT2DhUxDCF9GJqXG/3Bf8j0HS5yLAV/FBiTbn/5h8TvJ0P7Hoim/O7LDlYtHdSzqTjdT0DITb639IDfM5pDzfK5FKl/QyMl/e/7wuoUbpCx0wJFphX5YoH9RZzVZtQiAexwAsCwJVr0U9qRfyfz4q5Bgg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5oQkgIZB8g4TSzZHu0Etfeypilmex6FsVP2ICiojaz8=;
 b=HHAKigUwf2NyRqa5aM2Ij4bUzjLKHdvyH6PlKC0MraWmcNba5UHCEcEbXpOSRVDybXMgdJZ5UU8868qs+BMt3U/rDUbIe9l4MKBYMZniPKticDc/BoHRLc8KZUCuWpJUhK/iVjGvrgZhlTmIQqJZQvKWo5uOFKcX3+h7uHtSAGln8ywbhunNHb9SuA9DPKA8xyvWS/DZsNc8owuHilMDoVXl8TaNf4ZtjKH0ffaF2jcDsN/FpXu2NakBb9Aea64mq1cx/7FC9Bb/R3k4gR601dJaLq87IWEPGETEfpwov6x6BaOOyNT51GLNXuicneVWwsL9YwGdyLfloDvwdoiEPA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by DS0PR12MB6486.namprd12.prod.outlook.com (2603:10b6:8:c5::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.12; Mon, 14 Sep
 2026 02:24:22 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0406.007; Mon, 14 Sep 2026
 02:24:22 +0000
From: Zi Yan <ziy@nvidia.com>
Date: Sun, 13 Sep 2026 22:24:07 -0400
Subject: [PATCH v4 09/16] erofs: use folio_attach/detach_private() instead
 of direct assignment
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260913-remove-pg_private-v4-9-848550f7574e@nvidia.com>
References: <20260913-remove-pg_private-v4-0-848550f7574e@nvidia.com>
In-Reply-To: <20260913-remove-pg_private-v4-0-848550f7574e@nvidia.com>
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
X-ClientProxiedBy: BL1P223CA0016.NAMP223.PROD.OUTLOOK.COM
 (2603:10b6:208:2c4::21) To IA0PR12MB8374.namprd12.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|DS0PR12MB6486:EE_
X-MS-Office365-Filtering-Correlation-Id: 6b5d5a0f-e1a6-4725-199e-08df120749c7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|7416014|366016|376014|1800799024|22082099003|18002099003|921020|10067099003|56012099006|11063799006;
X-Microsoft-Antispam-Message-Info:
	gsz+V3hty8/wfORFNw/Zm9vNNPQXcgwUtyW0zE9q+Nmb9u31IIi6lf7avr93nI85wg87rO6z0gIu2FzNx85urfiBMoQkKlSYZjI+65H8mw/f3pRM1Zw0W50DAw1VjLSUN3wggIXSTFKiveobpiZqiWcWaAJIK9AjfyAaRMVcalIrGeJUn2++mrAnsDASVUvrtKKTVfaYUFXEVtp1uzMWUHmuzb2wmtZRirUNT8T4jk6xU7crQTzFNE3gO7dCl5yXGhYLJVlmpbA74Crppog+ZO0VEnyiCb0QXuJN1oXWjzZcbr2ffH+x83ePPU+KICfRTorjau2IGSvTc9TrP+ty4KfgY6WHRSqJZLIVutSx8haCONhH2OP8T9Wl4g2USyI+La2gu3bVHmpRjCwbKrWuQ3tpJqYJV8yDWn/eT8pq0QCqlbEVAE+XGVYd3OnveFJxF5ctc57lHLI5gokiHYP9v2SdD8IoJTmvdWemBYtoB1SkjaW0HMYhcjfNHjaB8iKgSpx0NYycFWjyR0TVXO67/JOhjNvx0Ob+kIt7AzVaD95RdjQNMxAgqFMXvlL+gMss9qRUiCWXF7jJbrOn2Fx94LhwmpaZF/Ve/RXN9b5GlREyndzmraThIMipFSAuqjLvFSPW7eEePqqI8hVQIJXtGfTGP9Jw47cwfStApnJcdT10xdnjF1xccxjc86HY55E+2AarSYqCMaG0TAa1ve0H6w==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(7416014)(366016)(376014)(1800799024)(22082099003)(18002099003)(921020)(10067099003)(56012099006)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?VWREUFdFQzljSVAzMWJ5OE8wbGFVTzFkZmtyeldiQjhPN2xhTmJxZlhTOGV5?=
 =?utf-8?B?enlaQ3Vhby9hbjRkQmJaU1UwbW5nb2lEODJIRkpHZzZIcU84NW1iaHZhZTFl?=
 =?utf-8?B?UkJmRmNEcDBNWDNWWmhkSHdEOERPRlg4Wmxoa0NIeCtpMFl5bzBFUm9SaHBW?=
 =?utf-8?B?aWNPSjNibEhGd1Y0dFBlSDFOSnZNSnEyZDBCYzJDbEJaUjA4WlUrY1REem02?=
 =?utf-8?B?RGtSNDlUU1AxOHRwaHBJTkVTRDNSTVRvczk5R3dXN0FjQ0ZCelRmL0Y4Ynht?=
 =?utf-8?B?bTc1NVlOTWMyS3hXMk1DNkowNmtzQTgvckFvZys5T25sOWtxMWh1UFFpOUpq?=
 =?utf-8?B?cytzUWwzYTE0QUJ2N2FPb28xNjJBWGptVXg0YWl0dHZtelB6YXZSWGxsUGZY?=
 =?utf-8?B?b0RTOS95Qm14NFpjUHJBeW9RS0c5UFFqcnpxT0xUNTVjWDdhSytaV2NVQTRO?=
 =?utf-8?B?UEltTVdHWG0vcDFaUU9yOG9qWHl3T003OGljdy85WllKM0ZESFByS1VRNGJk?=
 =?utf-8?B?TWp0RU5wcncvV2Z2anowcDI5a2xMQzJzL25mSmwwaCs3WHUwNGVvL0JXUWtH?=
 =?utf-8?B?L2JTYUJWVGJHZnRaU0VIdnl1TUN5cVFCOWluSG1LeXEyWWhVOHBUWjBmWlhv?=
 =?utf-8?B?TW1GWTBLdDFRajhaeEEvNjdqUWVJaWI1Ym9vWjAzeTlibHB6NzRaN2ZKdWl2?=
 =?utf-8?B?cmVwL0s0bkNSSXE1clhZM3FvWm83dnNqNEsyUGZKaWlRbEpJLzRTOUQ2QWJw?=
 =?utf-8?B?TWVzV1RpZVlkVTZEalluUjZuOEpXRmxMTC80RXZleDFOYTgvaTFVUzkwWnhs?=
 =?utf-8?B?azhCVjRnMkFkSE5yUENqY1V4ZjVaNm1XS2R1TEVnYU10VnlLZlhVaTJpS3hB?=
 =?utf-8?B?RE9WTnNScGlZMklpVUNmVlJtQ014cDhsMW1MbVkyeDZQQVB2S04yZVN0VW5l?=
 =?utf-8?B?U1VyYmJ1MHg0WTNIQ2ZWaWNhS2hCcXQybC9RWllHRHdJYWo1K1BZdHBBOXBT?=
 =?utf-8?B?aC94TWRteDUwQTNka1NtcTA2K0VybzBXOUt5SCtEZTN5bWJBbll1MjdCbzl1?=
 =?utf-8?B?WktNUm1yblNycFg3SjFGb1ZoWHRCa05sS0lUcXp4bnZReHhuQVlyYkFJYXFn?=
 =?utf-8?B?aXg5Z2lybEtZcWk2SWRRajlCSHhHTW83YkZnTEtIcG9icDNpeS9WdWZlL3Qw?=
 =?utf-8?B?ekVBemUwUHEyU20rd1cwamNhQVk2OElmRndnOEV4akhNSnZydVgwZVRIa0p0?=
 =?utf-8?B?aHhSNlUzY1JIRnJZOXF1Z0xmNmZlTVR0c29zK0dEampETThESzVvWU9hRWVI?=
 =?utf-8?B?eERJd1huQTVzRmMyRFBUeFdoQ0V1ZFc3bzF0SExuRlBIRktiYXlGR28rRE83?=
 =?utf-8?B?cGdPL0hXNUJrQTJJRG9WRnRpVnlFcFZqYVdUSWp1OTdwTExLWlMrVnUvOFRp?=
 =?utf-8?B?VnYyeExnZjMyYjhGY1ZLbW1KSDJWeUlrS1NCenE4OVJOY0tXMDBhaklTTWkr?=
 =?utf-8?B?blZ1THhTVWoxWExyZXdlbU1VREdLS0toSlQzdm1PY0txaE4vSERYMjNZL1FD?=
 =?utf-8?B?S21sdER3dXFBNFpJZWZJWWVnUTZEYVkvS0JKL2s0N1ZKbG5ucmhnbnBCQmVB?=
 =?utf-8?B?UXNjYnNxUkNTTDhOeTlQUUIrODkwbnFMZEVLaVJuUEptSjJNL3k0RXQ5cnpZ?=
 =?utf-8?B?SjhndkJzWVJFb1IyV0FHQjlsU1o4cVJOUkI5NmYxRUpzbVp6R2FJNzB6OGgz?=
 =?utf-8?B?dzB3a3c4RzdiYjdjVURhdGRRQlVJTG5YOHdYaCtEaTRsMm9EMnp0SEJnWUF2?=
 =?utf-8?B?cEdEc0pGNlV2ODJ3UkVaOGhDMUVsU3FSZVBNMFJFNWZGb3JabmQ0b0R2OGZr?=
 =?utf-8?B?Sm4vQ3ZESUwyeXJyNjV5dmlRUDZ5WXdyUlFSYm9VWUxza2tLUDFCenh2TjdH?=
 =?utf-8?B?NStoN1J0eVUwcW5UZXI4Uy9RNnVrdlQ2aEJZUUptUEVXbzlDSy9MOU05bzZX?=
 =?utf-8?B?T2NsVGROSDZ6Q253ci9JWUVDNFBteC9yUTBpbmpsall2Zm9iZTV0b3JLSksv?=
 =?utf-8?B?YktmT0U1WHdXSzRydU15MmFEN0tSM2pUSkMxUktaNExTOTlPQjlWWDJKa1Ru?=
 =?utf-8?B?bHZXMlFjOCtxQS90VTRDb1lKd3ZqWnFzSStGbTFhSmFXTVplZTZ2STkyRTZG?=
 =?utf-8?B?R05TNEtqdmQ4cU1PTTMwVDdSRUtNK1cxWldyTnQrNHVKK25kNXh5OE8yV0l3?=
 =?utf-8?B?N2F4aWVXRk1aR3ZpbG1qeDlvaXFJdXVmOFVaTjRJUmEzempDQlhkeUo5Ykhm?=
 =?utf-8?Q?ZEpmxUiT47cUJVjHlm?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6b5d5a0f-e1a6-4725-199e-08df120749c7
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Sep 2026 02:24:22.2746
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /x3fAVW9z31WTZwfJpYVgtLQ2SIugzlsh32Y/pLrrZnUi5RgbwPVxJlzmOzRrcUz
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB6486

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


