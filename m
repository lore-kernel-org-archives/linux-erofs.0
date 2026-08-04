Return-Path: <linux-erofs+bounces-4136-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5A0E9C55184
	for <linux-erofs@archiver.kernel.org>; Tue,  4 Aug 2026 15:55:22 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hDyml6hLRz2yH5;
	Wed, 05 Aug 2026 01:55:19 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=pass smtp.remote-ip="2a01:111:f403:c100::f" arc.chain=microsoft.com
ARC-Seal: i=2; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1785858919;
	cv=pass; b=d1XyarwLdL7Qr4bXL7+5gSbWNMh2/r4wCvB8erI91Mf08WS3EEchiaUTLEN9PE4/CjW2c4LLsl0G7WjWuwEV9NO5YFEFZc7V9DimtixYBCK6kGaNQ0Dgt9HW60jlx4L48RCBhcMGb9526aAdfwLI89NjwTd1FiUdimuSiPUBRxUgihiBgPl/gaghvkQDQax+F9shmQ4BQDQB9h1zjmlMq3A1wUfw3c2AqhOQP68II23i5wRcoswYtrUAwMi2CgC/1E/jNBl7grBNp7iKknbwQ5oftrET5WUJA6xV6Fgymn04chD+Q7qvtNIWRhyvSJdC9JqhuEdpeexjxx2D6Oikng==
ARC-Message-Signature: i=2; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1785858919; c=relaxed/relaxed;
	bh=0j2Id9ERfJxCszgoWFNojB+fTW9ByhgCGEhsvKWrZpQ=;
	h=Content-Type:Date:Message-Id:Subject:Cc:To:From:References:
	 In-Reply-To:MIME-Version; b=CxN/fQCNdzy+uDeNwL85ZDsq04C8TasVg5UvpIUH2m+TOHxfrwFzTbL9acR/tv1ZgVw0dqM7XjlU1iKjuycRxU4uh1mtUWZHQo1c+wr0sF7Ykp9hM65TCPevJCJjUw0y2gKYV0eFi2cV1MORVTmqkHobAM3beJRjqrgTMtqeRKutHLQ1PFsZXiu/lqxSZmWIMus+8fcCJJM6vNVuoPvIFJdf/XhlACLBIBh/yKwo+OHSDOdqTQAiGnWxMZ3Usg7Dzwx/T8/HQ7Fe5OG7evsF0YdsvS1U7FxqVjVVFe0GGlroK67iLM4oG13I7P0rAZqAe2T5pxSAgRcbQfWlX6Dy4A==
ARC-Authentication-Results: i=2; lists.ozlabs.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; dkim=pass (2048-bit key; unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=pZaQXMO4; dkim-atps=neutral; spf=pass (client-ip=2a01:111:f403:c100::f; helo=bl2pr02cu003.outbound.protection.outlook.com; envelope-from=ziy@nvidia.com; receiver=lists.ozlabs.org) smtp.mailfrom=nvidia.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=pZaQXMO4;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=nvidia.com (client-ip=2a01:111:f403:c100::f; helo=bl2pr02cu003.outbound.protection.outlook.com; envelope-from=ziy@nvidia.com; receiver=lists.ozlabs.org)
Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazlp17011000f.outbound.protection.outlook.com [IPv6:2a01:111:f403:c100::f])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange secp256r1 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hDymk3g6Vz2y1Y
	for <linux-erofs@lists.ozlabs.org>; Wed, 05 Aug 2026 01:55:17 +1000 (AEST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fjKz1NGFAvbUVgBBZYWjizs/Y5UN0j7f/r5XPhHj3a604NNnoY146i5N/9Hx7gf5ckKqEsJCWAQPU4TYnsw3FhwuU+T78nYVMhnqRkgrHkBYET1SO4PN4s7MWGlAxwmU7mBy8u6Lfa6bKzPn7zxu2pucxcmwUkW/FqjwrHFqLm0Bvn3D0IOd6l5s79HGllb7RQQs9SkE2MLkUnaNUL0gQcQBsgm+3Y569gnT99GLQiqdBoZ5x5CEj8oh05BfVPBLpW9CgGiQGb1+EbLQ8pGL+osZ/HXSb4pt0CqCHe8hI06cSxCrSPnzJsgp2r6XQQWz1DnzQYqFn0LOgQQ3XYgoOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0j2Id9ERfJxCszgoWFNojB+fTW9ByhgCGEhsvKWrZpQ=;
 b=dm4lU8NDX8WcDaCOx2HAKMQKxccHByrNcXbFgV37QNOmuswFfbtAO/qvSje7GOy43XwumKLyd9hFrZg6K11eM6lYsgClLFyc/0T4dPw2Mg14by5pZ5irf2bxwt5JSd360tmYM/jrM7seHV6hHiYfr/tsMEf7supBpMpoUp073HcpiAJypNjii5qYF2eYL8N0xxpig05P2SObFcMG73HdQNKzZhHH9XHF7Hruz/7BcA+hVl+bZH/koVADaIemdpUFTtMShm+pGF+jZYyqA4BG+bPSU1bPSYx4cYcqpch9afMXA0Tn46z10JdbXCwTptbe5+zxIrr/SntKfgBZ6lbQug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0j2Id9ERfJxCszgoWFNojB+fTW9ByhgCGEhsvKWrZpQ=;
 b=pZaQXMO4F6rH8bJ5FH462rJ5jooYSxfkDUy+zmZyweoeVDTQdLwPYEwbz4oIPg4MDxXPqGNr9uTaWg7EXewGtviQhHYRNpGB7apCQEoyXHBSPmH/ryt62iKLO+oKKlgOhwbHKoFIkUCsBsUHqymbmnj6uRzoE2Gbb38tEixZaglWYg1cmAByoUHUn+z0OispF92axdYjgRjtg6egxi9dlXtgB38L2DTvfkTaZDa3+NtRMpiRV3+8pGLDEctDwXFzHuDBBhncXvqSMBDA5ABtwD+emoSmjWMqH3rH6OCUV6Co7FWxXRzRRaqBuRZ7Yia7hQBjg5JUJrUAf9icnSZ4jQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DS7PR12MB8371.namprd12.prod.outlook.com (2603:10b6:8:e9::18) by
 SN7PR12MB7299.namprd12.prod.outlook.com (2603:10b6:806:2af::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.292.15; Tue, 4 Aug
 2026 15:54:44 +0000
Received: from DS7PR12MB8371.namprd12.prod.outlook.com
 ([fe80::23d7:9e07:1de8:d80a]) by DS7PR12MB8371.namprd12.prod.outlook.com
 ([fe80::23d7:9e07:1de8:d80a%3]) with mapi id 15.21.0270.017; Tue, 4 Aug 2026
 15:54:44 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Tue, 04 Aug 2026 11:54:41 -0400
Message-Id: <DKGA508ERSYM.26RBD4HYM1SL8@nvidia.com>
Subject: Re: [PATCH RFC 07/14] fs/erofs: mm/pagemap: add
 readahead_folio_reverse() to avoid folio->private
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
X-Mailer: aerc 0.21.0
References: <20260731-remove-pg_private-v1-0-142c97ba3562@nvidia.com>
 <20260731-remove-pg_private-v1-7-142c97ba3562@nvidia.com>
 <332rknj4vo3cfhvfhhlf6pvg37s3lbrnzbbnv4swa6gctsiu6a@ndotgokvnglc>
 <DKFGTVA0XD01.OZYNYUOU9FTX@nvidia.com>
 <huzyeqj6a57nbcqc23v6f6rdhkob5552fcwy4mlrsagycqi4rz@ggsapkumc2gq>
In-Reply-To: <huzyeqj6a57nbcqc23v6f6rdhkob5552fcwy4mlrsagycqi4rz@ggsapkumc2gq>
X-ClientProxiedBy: BN9PR03CA0904.namprd03.prod.outlook.com
 (2603:10b6:408:107::9) To DS7PR12MB8371.namprd12.prod.outlook.com
 (2603:10b6:8:e9::18)
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
X-MS-TrafficTypeDiagnostic: DS7PR12MB8371:EE_|SN7PR12MB7299:EE_
X-MS-Office365-Filtering-Correlation-Id: cf74d9aa-ce02-49aa-c9d5-08def240b3f9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|1800799024|376014|23010399003|366016|6133799003|5023799004|11063799006|10067099003|4143699003|56012099006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	o6GeavIl46YcaoH3cidxnsQiTo3/Q85Tz5kcVrLClaEvH5dTX4CHIaqbhBhkoZr80X79b7QedZ0sfL5XTbX0VC/J6U4CBVYuUcpQuB4ujrp1aCZF8nEFdQsSdOxgpmNQG2uPIWeq65/rlUehTkeyq/+9UsF52MUS+e1pBUQrGW6RNEaQwZUrawcfms3Xq/mYTsHskftp00yTcwHhepOQ3Jlf91Ql2cZPO8X562o/DO6oyu1TGHOUHHXVCh2AJ1LmqKvZVmJHkZlLOdRdYDoz3BJQa0U+GWTzjM0beQpRrE/Cf8Hc0COUjGMhqZ749to6Ok5ftmTv4U+t9bOlqYgxYjQjPAjko4/LTf/RhHap/3UM8GDWt25ciX9wlKoa9H9XXDGGNwfCjfNpElyHS3ar9t/D8e2FY6n4IC/JJRkryTpLXESE4pQYJi8Aji8tyPyHj6aicso2DDyPjQAzh8OPFFHmzBLUgC3SeUukSq25fZKxZyo61zEE4IPQD4KjD1eRVTJ9ZO/DNRIqYLfyfRg/oDZvsER98LI5vstovGkhNd1+sIBnd0O86h+bs4L65X/y83tw64yfE5Cu99NY71i9FDr95e3mcQQkEmroPCw9pSYcw9tQs//yBhC6uYZF7CTu7PSn6l2APizNbXFsLI0YxOvviBbpL2Gbrac4y34Y0LI=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB8371.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(376014)(23010399003)(366016)(6133799003)(5023799004)(11063799006)(10067099003)(4143699003)(56012099006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?TUhBYWdKd3lZbUlNKzJvM3FWZVNhYlNudDk0OEl3TDh4ZXhPMDUrUDA4L20y?=
 =?utf-8?B?OS9LNzBNb2IxUVVSWFpzblh3SjZOM2lkZU1LODlPMTZua3lXVmRjcXdic2hv?=
 =?utf-8?B?VDVMZFhVYk52akpWeDFSVVRQK0ZiMHN1OHBsazAvaGlhRTZ3cXdDU2RoMlla?=
 =?utf-8?B?V3I2SjB5TjJIb1NqNG8vMXJaTlRQYVB2ZjBIVWgzQlo5NEs4aEF0bVFXZFYz?=
 =?utf-8?B?MSt4VWIzai9JWXdSdThYQU5xOWdLcHB6NmdVSHBhbVNpcVBiZjhQVWYwcnc5?=
 =?utf-8?B?bXNRSzVxLytYZVZmaTE4UDZJaEl3bExPdk9RWk90N0J3RnhPT2J4ZFgyZi9i?=
 =?utf-8?B?dGZNVUlJdHBZTVB6U01YL3NiRUVhbzMxdW4zSEhJRWMwbENkVkRwUFZ3VEF4?=
 =?utf-8?B?R1c3SlpFWTVoQkJTNVFnN1ZCOHhaczAwbW5uS1Fqb040NE16RnRYVUFrM3VN?=
 =?utf-8?B?aEFFL09aU3REWEo5QXRPblROdFY3V0tYVmtTeTl6dGtPdFVZeHJtdXZXL1BW?=
 =?utf-8?B?WUlFZGduSDhNcU5SZlVJbm9nSmUxRE9MYkNEdURoNERNa09OK2xiV1liTGJw?=
 =?utf-8?B?MVZXeVZpNDlpKzdub1lsKzVTbXNENjJSYnBUNTh4Mzh1UHdaeExIYTBmUlQy?=
 =?utf-8?B?am1tamhqZU9yZEhOdHVzNDJCZ1J5OFcwWk1icHUyNkRFRmhjLzcwWlIzcHNY?=
 =?utf-8?B?NFpaQjZaRzBWK1FYQm84c0EwTDZJUzNpSmNyQlFhaDBzZk5YY0syeWx1Y3Ny?=
 =?utf-8?B?Y2pXSE1jOURIN0dYdENCZEQ0akV4Q3J2bWdndWpra01nN1Mrc1dKVGNMTTBX?=
 =?utf-8?B?bGNHYTFFSW9ZSC82MVFkVTE4NXl3akpFUUxWajVVN0dTS3A1RGFEa3pZY1VF?=
 =?utf-8?B?aUo4R3YxU28wL3hVSTFrU0NNNkw2WE9IY1hHdnlCRmRPYXI4MHZPeS9sOE5U?=
 =?utf-8?B?aXdOUk0vaUdGcENHdHZzcHFOZG5YT1Z4djNIT1ZXRlYyQjRmZ2RaUjVFMFNa?=
 =?utf-8?B?VGpVemROYTRtVWcvTGVnanh6TXNFbmI4em5kbmloMWVseHpwR2NEa0Z4Umts?=
 =?utf-8?B?bGtFTlJrcUxaVGgzUW4wSWt5QUJrK0pMK1FYSHhPWUlDMWtVdDhjTmxUQTFw?=
 =?utf-8?B?Z2F3ODBoNlUzelFWeVFIUFg4VnZKT3ZEUklIK3VteityY0hlZVdtNUlCRW9U?=
 =?utf-8?B?UVVqYzhrSHdvY3RLbDAyQkpRLzl6bmlwNW95cmpmaWJUYXJIRGpJSlN6Ukd5?=
 =?utf-8?B?Q3lSWndMSk10eHA3M1JvRk03YVgvd2phSXEzTms3VDVjRmF3ME9vcHY2NjZ4?=
 =?utf-8?B?R2ozMEVMaVpCWWhjS2xuZytqZUdPVFZ5bjJ1TmRSUmVIdDErOWVvS2FqREcy?=
 =?utf-8?B?N0ZsYU05TDlHMGhzRncyVDBJWithOWhad0N0QWg0Q2daeENHNUxJUjFYOFNB?=
 =?utf-8?B?T2lHV3V5RnRFWTN4RlpYZHVWbUQvTlV1VmhEcHRmaWdVay9ja1p2M0VFc0Qr?=
 =?utf-8?B?NVFFNDJ0VVJPMDN4RFNmY0gxaHloRE5pZWRhYnhybHpJRVloOTJIbkpEbGl5?=
 =?utf-8?B?d0pXb1l0ZzB1UGlWRi85TzNqNEpnNXJ1UEtMTUJPd0taWU1RTDQzN0V0SWkr?=
 =?utf-8?B?YVBnQ3BqNlZTVU4vM1NlSmQyYldsVS9TN0NqT3NpVHp6Yzh4SFdHNjQwY05S?=
 =?utf-8?B?YkJKajcrWU5rbFpZTTVGU1k0UmdDUTN6ZG9wRlF3WlZ1aTJrSFVDSHlNZlZz?=
 =?utf-8?B?VVNCcnZvSUVLREkrVWlENXl5azRLbWxPeW5SbHpFc2hJYjZQQWRMMlAzd0xW?=
 =?utf-8?B?VktmY0xlZEQ1Z1pTem1wQ3U3cFBRQk9XSmMzU3JMR1lranV0ZGsySE5TV1Uz?=
 =?utf-8?B?OUNZNHQ4YjFRYXJFQno3Sy9pbklPd3pKZ3pkNFRZZTRqQWpEMWxkMTlveW83?=
 =?utf-8?B?UHNLdlB4N3Nqa2swN3RtT2k4am1GZEd1aFAyRGpJb3VMVnF5WjAyRndRTXZx?=
 =?utf-8?B?UVdxV3JuSmR6b0FGYk54RnNhSDJhZ29jQXBZOXU4MEE3MHpob20xUm9ac3VN?=
 =?utf-8?B?Wk11M0J6clhrem43NWNRVUNOUllsbklsMkhJQ0hRdm9TSEp2VDdQY0V1U25G?=
 =?utf-8?B?emIwZ0VMNGJtSWxYVVpzcDNIcy9mS0VCRDlkMWkzMWdzbFRTU2ZtSTNndFJ3?=
 =?utf-8?B?WTF4ZTYycXQyTlM0VUFoeDE5bjFWMnUxa25xeng3ald5RXJtRGVzZGlyYjJF?=
 =?utf-8?B?cTc4UjZqUkJPSGpkRXM5WmExWGxXL0VFanB0cG44VGJXRW9CSmNWZm5TWlpV?=
 =?utf-8?Q?ALnys96hgM51T4kz/B?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cf74d9aa-ce02-49aa-c9d5-08def240b3f9
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB8371.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Aug 2026 15:54:44.6311
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QkpQ69aAeRxBqc+A0GV250UUz34xLCB9jwfn3Mg1L4sMgZE8qeg+wuplt3RB8NSq
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7299

On Tue Aug 4, 2026 at 5:32 AM EDT, Jan Kara wrote:
> On Mon 03-08-26 12:56:36, Zi Yan wrote:
>> On Mon Aug 3, 2026 at 5:54 AM EDT, Jan Kara wrote:
>> > On Fri 31-07-26 22:13:30, Zi Yan wrote:
>> >> erofs needs to traverse readahead folios in reverse order to achieve
>> >> maximum performance by
>> >> 1. reading all folios from readahead_folio();
>> >> 2. storing the prior folio pointer in folio->private;
>> >> 3. traverse from the last folio to the first one.
>> >>=20
>> >> Add readahead_folio_reverse() to achieve the same function without us=
ing
>> >> folio->private.
>> >>=20
>> >> It prepares for a future commit that replaces PG_private checks with
>> >> !folio->private checks. After switching the checks, erofs's use of
>> >> folio->private without bumping folio refcount can cause unexpected
>> >> outcomes, e.g., in filemap_release_folio(), try_to_free_buffers() bec=
omes
>> >> reachable.

<snip>

>>=20
>> The below is what I come up with. I did not add a bool to
>> readahead_control, since I think that is the decision of caller of
>> __readahead_advance(). But let me know if you disagree.
>
> The reason why I wanted bool in readahead_control is that if some code
> ends up mixing readahead_folio() with readahead_folio_last() things will
> get confused (because __readahead_advance() really wants to skip the batc=
h
> returned from the *previous* call to readahead_folio[_last]()). With the
> bool in rac, even mixed use will properly advance the state of the
> readahead_control. I don't think mixed use is very realistic (at this
> point at least) so I'm ok with leaving that for later if you don't like i=
t.

Got it. I am trying to figure out your mental model of how the mix of
readahead_folio() and readahead_folio_last() works with the bool inside
ractl. By looking at readahead_folio_last() code, it is almost the same
as readahead_folio() with __readahead_folio() inlined
(__readahead_folio() is only used by readahead_folio(), so the inline
can happen without any issue). As a result, we can get rid of
readahead_folio_last(), add set_readahead_direction() to set the
embedded bool read_from_head, and use readahead_folio() only. This
removes redundant code in readahead_folio_last(). One thing I am not
certain is whether we want to

1. use set_readahead_direction() explicit and warn readahead_folio() if
read_from_head is not initialized, or

2. set read_from_head to true by default, so that only erofs needs to
call set_readahead_direction() to change read_from_head.

The former is less confusing but changes how readahead_folio() works;
the latter is simpler but implicit read_from_head state might confuse
people at some point.

Let me know your thoughts. Thanks.

>
> Also I have some minor comments below.
>
>> diff --git a/fs/erofs/zdata.c b/fs/erofs/zdata.c
>> index b59f2745a8e72..23f423c22ac8c 100644
>> --- a/fs/erofs/zdata.c
>> +++ b/fs/erofs/zdata.c
>> @@ -1908,8 +1908,8 @@ static void z_erofs_readahead(struct readahead_con=
trol *rac)
>>  	trace_erofs_readahead(realinode, readahead_index(rac), nrpages, false)=
;
>>  	z_erofs_pcluster_readmore(&f, rac, true);
>> =20
>> -	/* traverse in reverse order for best metadata I/O performance */
>> -	while ((folio =3D readahead_folio_reverse(rac))) {
>> +	/* traverse from last to first for best metadata I/O performance */
>> +	while ((folio =3D readahead_folio_last(rac))) {
>>  		err =3D z_erofs_scan_folio(&f, folio, true);
>>  		if (err && err !=3D -EINTR)
>>  			erofs_err(realinode->i_sb, "readahead error at folio %lu @ nid %llu"=
,
>> diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
>> index 5ca5aa365f319..2cc3de5594518 100644
>> --- a/include/linux/pagemap.h
>> +++ b/include/linux/pagemap.h
>> @@ -1510,13 +1510,21 @@ void page_cache_async_readahead(struct address_s=
pace *mapping,
>>  	page_cache_async_ra(&ractl, folio, req_count);
>>  }
>> =20
>> +static inline void __readahead_advance(struct readahead_control *rac,
>> +		bool read_from_head)
>> +{
>> +	if (read_from_head)
>> +		rac->_index +=3D rac->_batch_count;
>> +
>> +	rac->_nr_pages -=3D rac->_batch_count;
>> +}
>
> Maybe we can add:
>
> 	rac->_batch_count =3D 0;
>
> as well since after the advance the _batch_count isn't valid anymore? We
> can then also remove it from the callers.

Yes, for __readahead_batch(), _batch_count is zeroed right after. For
__readahead_folio() and readahead_folio_last(), _batch_count is either
zeroed or overwritten by folio_nr_pages() before any use.

>
>> +
>>  static inline struct folio *__readahead_folio(struct readahead_control =
*ractl)
>>  {
>> -	struct folio *folio;
>> +	struct folio *folio =3D NULL;
>
> Not sure why this initialization got here...

Will remove it. It is some leftover during my development. Thank you for
pointing it out.

>
>> =20
>>  	BUG_ON(ractl->_batch_count > ractl->_nr_pages);
>> -	ractl->_nr_pages -=3D ractl->_batch_count;
>> -	ractl->_index +=3D ractl->_batch_count;
>> +	__readahead_advance(ractl, /* read_from_head=3D */ true);
> 				   ^^^^
> This is not really a kernel style :), please delete this comment. I'm ok =
with
> pure false/true here - it is an internal helper used in few places. If
> things get wider use, we tend to switch to 'unsigned flags' with explicit
> flag names to ease code reading. But that's not the case here.

We did this in some MM code. I will delete the comment like you
suggested.

<snip>

>> @@ -1583,11 +1594,10 @@ static inline unsigned int __readahead_batch(str=
uct readahead_control *rac,
>>  {
>>  	unsigned int i =3D 0;
>>  	XA_STATE(xas, &rac->mapping->i_pages, 0);
>> -	struct folio *folio;
>> +	struct folio *folio =3D NULL;
>
> Again not sure why this initialization got here...

Will remove.

--=20
Best Regards,
Yan, Zi


