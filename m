Return-Path: <linux-erofs+bounces-4495-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C3378C79F99
	for <linux-erofs@archiver.kernel.org>; Tue,  8 Sep 2026 02:57:14 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hf7rj3xcCz2ygp;
	Tue, 08 Sep 2026 12:57:09 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=pass smtp.remote-ip="2a01:111:f403:c112::5" arc.chain=microsoft.com
ARC-Seal: i=2; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1788836229;
	cv=pass; b=QZSzMQVyY9u22Qlqsy/u0t8WfIGdRecrtjaR67QBorwyPWKb2LjW2OKGIlGZxpCcopHFTT3Xm1AskdejlFP+cT3x3xE8AAIEqF5AxLBm5aN1iqf24hAtuQLrcBFUzXrTCX9cFjVn3vjG965VdEOXBPmw4BNxeVbPHurEJErvUAhIiTu8J74nqH6D/et5xkxJFpipPg9SFi9KeZ8nEx9fs7wbwvSFsSMCO16FHbsAKKt9+s6ex6rpHZqc65NjEocxbKXfFyNuMN27oUu+8r9QRAFDw12nQtHrjrUftRVYeuHQMu/F+mlCjMwlBp5QhnW/iwgSNtt9bR4r0ukpDNQK3g==
ARC-Message-Signature: i=2; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1788836229; c=relaxed/relaxed;
	bh=RxnL1o/ICM0JJhQDdSG6k0d/UX7PPpVBK/DANObKaQI=;
	h=From:Date:Subject:Content-Type:Message-Id:References:In-Reply-To:
	 To:Cc:MIME-Version; b=NNdk8SksNsovzgxRUNuOBOy4qH0Zm3yeC34JQdIdQo/NyT193UY+pPXCxx4NOcFwE5fCKtkw/k3kR+kP88zDuJtfGlSr73Yo/8Fiuzj3bDogYp9XavN1n9EQueW1SVlQXKc3xOhxMp6Dx0cbnC5KVdmM1J4SZERgyZqlYdDjp5CsRPiKyntvup4Q/D3ur5+VNAOxx8edn5wX/ey/SjCMOxk2UIIu7OxU4hJ7iLwXiaveGy7vcUPl0PKFuRjdrMu0DMMNpFagi/h/eMA9SuR0BB6otsWph+x6d3M2bc8g/fvgBleJ8c/DyTmVyujcXQBVADeurHGA/MuOf0fmkqvH3Q==
ARC-Authentication-Results: i=2; lists.ozlabs.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; dkim=pass (2048-bit key; unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=uJeTMkrK; dkim-atps=neutral; spf=pass (client-ip=2a01:111:f403:c112::5; helo=cy7pr03cu001.outbound.protection.outlook.com; envelope-from=ziy@nvidia.com; receiver=lists.ozlabs.org) smtp.mailfrom=nvidia.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=uJeTMkrK;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=nvidia.com (client-ip=2a01:111:f403:c112::5; helo=cy7pr03cu001.outbound.protection.outlook.com; envelope-from=ziy@nvidia.com; receiver=lists.ozlabs.org)
Received: from CY7PR03CU001.outbound.protection.outlook.com (mail-westcentralusazlp170100005.outbound.protection.outlook.com [IPv6:2a01:111:f403:c112::5])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange secp256r1 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hf7rh44DGz2yjN
	for <linux-erofs@lists.ozlabs.org>; Tue, 08 Sep 2026 12:57:08 +1000 (AEST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=p/XdrlSjylUB1y+ly+/8XYRi7kGbHa+FyioHnEn+y+DL2bt/3nqOG1ZASXGw2kAe8S2i0srBnZEX7l0jVFq71RI4i2IQBKbs/iYTr5RAJ/loNjwyNXZwNDelkq0o9zht9Y2Bvd0EEf270ygP2Em78yxRXeSK8NJDJi5m8KqUIelTqdpCGVrjbSwN4xtbR/n4T3a6JbNF1UpR3hP9Bk7uF9zHSNJ0KR1GSxZFTxLA7wFi3rlZKtPiKIHNp8jbB2KwcSJokOKQqaHtybXBoO00bqsEXDQUkVoyev/Zh+twzNzZ/mLW7I64hHuQY8CS3TZRKS5ZADFa+a6FD1cWrjNXGg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RxnL1o/ICM0JJhQDdSG6k0d/UX7PPpVBK/DANObKaQI=;
 b=Ty1ilNkAIujtZDN/QS1ALgD4itHzu530+ZIh0qaVF9vWb+zoZbMZvkh8kbyqtqmjtmyS0lF7Bo7ZDCfqpLILErR7wt6gKyVg3mcMUxLf32CisRLnSEiWxlvfOTN3/wp7KBtwGX7zpwohxX3IMkVtkCdIJ1RqrjAkJk7Z63OswZPv6C5so7LrNkHnlrlUfzq0V7rI8ZDjurufJ8HgUT0kUvdLk84jlF6RYIldTvurO3ez63K6OfuwOyl2fXiPaMVNS1Hh3pv4kMnBKFrLA0ZG45tuvbH661GdBqs3bQquwyC2OBocDEgPtGV+HimlMWzkfgTHieb2p/IZ4A0SjIYNbQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RxnL1o/ICM0JJhQDdSG6k0d/UX7PPpVBK/DANObKaQI=;
 b=uJeTMkrKN4oOSfrgr/noxLTyP9/k/RiTUmhu+KOBMa8Vh2yOWTYs4zlfpEesZ5WZmnKEsUMLWSo9dm7XMQ5UIIk/3R/Ge8inwZa+yWIKelm716rsPbgPHyjbzEkOKNND29Gw7oKMVcT3ARQamp2BMIdrNiIYgWgGwl9fEYg6UTT/Vhd8RCOJ1qjkRi/x29pCIdbJVzZE8A+t4ZvkI2Cyar2ZdR98Nww912P6PpPBltxtm9S62Yk7HxSs+xPez4yPKVEB+I7SU0nhN1pBCvbbOwV3MZQcxhtGh7hsonJ70ejmX2WweTiTk5PxjoG2WahdPQ9SLYZdCnbA5pIl+5XLww==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by DM6PR12MB4435.namprd12.prod.outlook.com (2603:10b6:5:2a6::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.15; Tue, 8 Sep
 2026 02:56:38 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0382.014; Tue, 8 Sep 2026
 02:56:37 +0000
From: Zi Yan <ziy@nvidia.com>
Date: Mon, 07 Sep 2026 22:56:15 -0400
Subject: [PATCH v3 08/14] erofs: use folio_attach/detach_private() instead
 of direct assignment
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260907-remove-pg_private-v3-8-6ae22f9d9272@nvidia.com>
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
 Chao Yu <chao@kernel.org>, Yue Hu <zbestahu@gmail.com>, 
 Jeffle Xu <jefflexu@linux.alibaba.com>, 
 Sandeep Dhavale <dhavale@google.com>, Hongbo Li <hongbohbli@tencent.com>, 
 Chunhai Guo <guochunhai@vivo.com>, linux-erofs@lists.ozlabs.org
X-Mailer: b4 0.15.2
X-ClientProxiedBy: YQBPR0101CA0250.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:66::20) To IA0PR12MB8374.namprd12.prod.outlook.com
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
X-MS-Office365-Filtering-Correlation-Id: f18255e5-a2cf-4b7d-33ec-08df0d54cd06
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|366016|23010399003|1800799024|921020|10067099003|56012099006|11063799006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	aLvUlpuBIIy13vG4Takn733L+Arzks9WGlLnQ1sjT1LC45xy4Kabs9QA5066gAReoxdpwX4YsJK3x6wFROBK3L5MBWS+DbC4dzHR032XF3MUGoNDsRm81CrNBnU9dqR2yjWVeIotTBL039SLNxoF1dZrl4Sq5xyFisGsxA6U7Q9mFoEN5sS7SExokce3mcBHGJa7YuYFWVqpsT9FW9hFEyDqoeC9DjQAsq6Xo8QNfhtY4VP69fioAlgJY1Y3p8RP2Vbc1KE2OkdyAeRa3LLZjfbYDIVooej6xp6lKqxFiMs1+o6I7KQWc2dRjFbWy1k7goj2p1MpqDicj0dX6XBJaVoaUGeE8Xbhb4dW1ykL4qgRPBVdbdS0+1mHe/wP6ZOHUegFshdGF3h+nfzgWIDBYfE9hjijjVuKSEY1rllczy9AdW/U/YHcgqKTOmnLia+Js1Xw7IRYK44P2e5WE234mg5Ojwzddhm8TVxDqm9V2FgyYcYnvVZZc+5H+djxqxvsCDvKxATq/W6zoWXCyy6iU4upfMGsM3gB+PKblhbzICwA05WwmLTSBY8NC01SXED5VfhBLRDFtfnJtYt67WcEJjBr+jyiVsqqYn91VN/rwlkOVX27p4dUqPcKN+rpATWANYSmNtD3H0PFU+OmpUAZROHpdw2Ao944ScPuFR/ZQDKMjT303T0w9aa/kDYal73ZAE25iSu5Now6bXcjXmEH3g==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(23010399003)(1800799024)(921020)(10067099003)(56012099006)(11063799006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?V3VnNU00TktJQk13cUI3SzVXZFFyWTJoVk5sdCsvdWZpOG1HVHFRS3NtUlZV?=
 =?utf-8?B?c3hRT2tGTkxEdVF0MjdLcktFeThEcnpHZE5TN3RpNDY5cm5xdEV1ampkWXI4?=
 =?utf-8?B?RW9lYTluMDU1UDhoNWsxUk5ndDFSWXFYU0lzemY0My9CYzlyd3c2dXYvSWxD?=
 =?utf-8?B?Kytpd0NOWDlnN28xRWxGS01Ybk9RTDBFajBlNnJ1NlYvRTRQV0RWSjQ3R1Fx?=
 =?utf-8?B?U3pLV2gxUzZXNk4rV2JhVVVDNDVoVHdiUTJGL0RRTlBnclNQZEVSZ0ppeEtK?=
 =?utf-8?B?NGJKK3JxT3JOZ3RMQmRIbEN5MGVuUXozQVRmVUNEUnN2SFNZK2tTZVorKzB1?=
 =?utf-8?B?VEtOa2c4SHB1VTJHaGxHR2NlUUx1bVExRmVCN2JLQ25ZQ2cyRFNIQ2dqTnhh?=
 =?utf-8?B?Q2UxOEk2eE11UHpmWWxldldPc2R4MS9tU1ZIUW5XM0l6dFdLa3NYTi80dk5l?=
 =?utf-8?B?TVJIL2EvdVA2bGMyNGR6eHBEblprcmwxY29MZS9xSnE2dUFiZjd4VXJlZStq?=
 =?utf-8?B?VkVIVVpqVVFXUXR1Y1RYaEJrS3JpY3dpTTh6elhjd1JEQWVNcG5pNW1YSUpL?=
 =?utf-8?B?ckIyNTlTa1VyN1JlU0xOd0V2anNQUGJkak0xSzVhRUVHZ1ZINm1RMkRUeHk0?=
 =?utf-8?B?QXU5U1lMVG5xWnFXaEUyNEpWYTQ4eWE4Q05PWmRtRTE4YS9rTG8ycEkwZ1Bq?=
 =?utf-8?B?YXVHNm9BcXdzVXBjeEljWkwwR3hFMWRBNmlUNHB0aFpQMzV6L3JYSDNHMFZE?=
 =?utf-8?B?Rm9CUms0NGUzSCtsdi81M0gvaGRFY1RnbCt6TXp4aHZnV1p2SytONnBkWXdk?=
 =?utf-8?B?WEUyYmpLZFdWSm55ekZ1bGR6ZDBKOHh2WG5ZbGhrSGxXbVVyZHBYMVc4Z3BY?=
 =?utf-8?B?cGZ2dXltVFJ6WGNPck9HQ2pya0hOclpadDRjMXQ5SEJvUVNNRFFrYnlXbGtL?=
 =?utf-8?B?M281OU8vUjEyVFRGMi9rMERjbytvUXpxbmxaMHdLby9abW5VVFlhMCtOaGQw?=
 =?utf-8?B?SWFENmpSWFhpN0tqbkxWRjJabmwrZVhuSTVsczdSUHlhUE1SL1IxcUVjY0sw?=
 =?utf-8?B?M1R6Z2RFeWNTQ0IzRTdHMzFodGxRQ2hScDdTVnJHRXpNNnpnMTNKVFR6blE2?=
 =?utf-8?B?WjJjZ0hNUVBuMEI3WjBlc2JmalczbmF2dkF6clJlc2VZZHZnNkpiMlkvVWZJ?=
 =?utf-8?B?QitpNU5YUnVOZTN1Mnc1WTFEM2FkMWNTWFJaVzJtVUJEQWtXa0pUOC9aYzha?=
 =?utf-8?B?Qi9KZ3RrZHdVdlVFM3RYV1JCd2dEdUVaWFBwdXdlQjZqaTdQZm9HcW5Ebkh1?=
 =?utf-8?B?T3VNRUFYWnV6aExHYkZaaFAxandLc28zQ1pFSEd5eG9ZenlLQ3FLV1pEZGpl?=
 =?utf-8?B?YUJxVEVmUmxpRUhUaTVxdTFwNFJyc3l2RUloK1pSR0dxYkdPdzUzaGFSZFRJ?=
 =?utf-8?B?eThQNzdXZTJwd0lqL25ONXZjTll0ajFpSU9lbXV0NUgwMkprUTgzNHFHK3Zr?=
 =?utf-8?B?YTh2OUp6T2E5OEtVMld6NUNDNXprSXlpM2t1SFZ0Q2t2NWd6eGx3QkhyK2FV?=
 =?utf-8?B?cEJRWEV6bEhneHdEYjFYSmFWRUpoWlJ5OGVlNWZYc0JEbnA2aVRYRzE2TEwy?=
 =?utf-8?B?RVkyN3N0NG41SFVxMXRvdlZIVDZrbGg0aFlGZDdGTi9BU2ZkNlVUeUExQjBy?=
 =?utf-8?B?bldRTmFoNDJyNHdLSHU0UGpjWFJHSkc5eXFmSHFDTHgxK3p6V2tqQjJ6QXNM?=
 =?utf-8?B?SkdER0RUTTBYZHFjYjRrR1NGVjd3RWdKTDVXK1BpVE9uWHFYNFRzc3hHeHlC?=
 =?utf-8?B?MFB5N25NNHV5S0RxSGo2R3EzbHNwZHErVmVUeC9ackR6b1ZpUTFMS2Z6MTdO?=
 =?utf-8?B?YW41RHRYZ1dtcHdSSnNWajhFbmVsVDdYMHl4M2JudnFGbFAzTEY5YkhKRzNV?=
 =?utf-8?B?MHdkckNRYkwzZ3Q2dTl4MTF1L3dmS2FIWTVZT1c3bFR4cExPVDdXeU1lNm9Z?=
 =?utf-8?B?QUhrdjZxT24zdHR2SXF4SEZQZFdwdTIva1hEWXNFNnRYU0lEZ3kxNXY2d2FN?=
 =?utf-8?B?NDdPVlR4a3JoYjBsQm5zV0xnNTFpNmZDOEsvZXNZaU1memRCZ3VhVDFMMzdq?=
 =?utf-8?B?aG1WZDVrMUlVTXpCZ0FWK2JCenNFSmVzYVFVQ1MxOHhla09lNzV5a1dHS3FR?=
 =?utf-8?B?amZsb0JzMU9FSVFlUDY0Y0p6UlJMVGNEUjc5Tks2cFN4S1Y2ejRPRFZFWFFF?=
 =?utf-8?B?NndVZHFCY2lySmU1cUJVa1JUSytsTzVtNHUwbFA4L2V4a1lkNW85S0kzYUhU?=
 =?utf-8?Q?4bY6iVe77Go4ZCVIlu?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f18255e5-a2cf-4b7d-33ec-08df0d54cd06
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Sep 2026 02:56:37.8895
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YP2p1cKXab8zxS47zwsYwrzYzUElbyCS25c3LL+Djk7I2ZRtHw3b1B5+fMd9BwTp
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4435

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


