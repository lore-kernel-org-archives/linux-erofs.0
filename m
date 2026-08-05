Return-Path: <linux-erofs+bounces-4139-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E89CAC55838
	for <linux-erofs@archiver.kernel.org>; Wed,  5 Aug 2026 02:37:35 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hFF1p0Zhhz2xnp;
	Wed, 05 Aug 2026 12:37:34 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=pass smtp.remote-ip="2a01:111:f403:c111::9" arc.chain=microsoft.com
ARC-Seal: i=2; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1785897454;
	cv=pass; b=V3pfGRhJNA5HsiannlIRicDYrhk5ZXhUURPjbONDtYpIRKLpVTh7QlbqDUGVrYj4gqzzkT9UK5//VhTgAAnAK/2apo7XzR5vNzjSP84a4pW9XpwYXmaOXHy9y+JF4toO25qJyV0p7hw4dpGTthf1erw+I6EJO+cm3BP4waE3bI1WH2U6UUhEPNLCG89Zi4l8nHIJmSlm+BOlBvH10ogv4oqBBH+GZOR4E3zusZi2M6yfBQnP8qK1QAfjqbF98n70BE8B2nx/sxniGDm7v8mKuGBoV1dbrz+IjB4h1xwoKA4Y3WGJPEBHmZfL1qDmDB5PiSzFrl2GwckAJyvoVKWVzw==
ARC-Message-Signature: i=2; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1785897454; c=relaxed/relaxed;
	bh=obVmZ8GX4bubPaMxSnWrKDXrDHI+xE4qyWDUElMeIFU=;
	h=Content-Type:Date:Message-Id:Subject:Cc:To:From:References:
	 In-Reply-To:MIME-Version; b=mRY6Y4aZP4vvrPHcx6Lto/W9ZrF1hukRtAETHuDXDELDWYsLYkllyCi6cVQcWYQ9CW8K3jsk0V0SONwS2lN51bYlGC6oiaWOYtWef5mCgfiIHm1/+ztq/E1XtKx/jTW8328yQC+HSBQrjxJ7Kvm05KJ7f0jrP26Wq7UnL9nNmo7Zv6we+7wZbHlrWY2CV+ANbaSf+T96vyMkFeT+qc66jUGvK1G/HEQisRBkPp6+GsDskKEzCNtzO2zV6++f8CLDq1zLndQhmH7Hmk8r+OIKCkqkD7k9C8f5pfgF8RIj0tlSYfQoUieU1yeHHH317NQURug7Q3jmp5WYGfXu6xGOxw==
ARC-Authentication-Results: i=2; lists.ozlabs.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; dkim=pass (2048-bit key; unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=lvhyHafc; dkim-atps=neutral; spf=pass (client-ip=2a01:111:f403:c111::9; helo=dm5pr21cu001.outbound.protection.outlook.com; envelope-from=ziy@nvidia.com; receiver=lists.ozlabs.org) smtp.mailfrom=nvidia.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=lvhyHafc;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=nvidia.com (client-ip=2a01:111:f403:c111::9; helo=dm5pr21cu001.outbound.protection.outlook.com; envelope-from=ziy@nvidia.com; receiver=lists.ozlabs.org)
Received: from DM5PR21CU001.outbound.protection.outlook.com (mail-centralusazlp170110009.outbound.protection.outlook.com [IPv6:2a01:111:f403:c111::9])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange secp256r1 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hFF1m2GTBz2xJT
	for <linux-erofs@lists.ozlabs.org>; Wed, 05 Aug 2026 12:37:31 +1000 (AEST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=aPoG99SQzSovKjEpwE2nDeJVanZWHBGH7BebF9wN8DSSQsYAKWDM+rFeJLYJHaG+s+MUTQ8jFJcBZe9VUzBu2/VUdLJwy4UWAhciky/L7lE2QALs8NPsr/92QnGW+jA2R8Rfr/pSpMQL1bdsiw3eCGiYOKCROi9loxrOshTJVCSglF6BKOsz8PW+DTck5ivLtfxQfDVXEgtPxhOm8MoRGgXx+lP9ZC0Pf4t7dPVpsIVn4GPDrPg+QNPR97OJ/GKw+gUfUTGSQ48Ysyf7tUPdKhqww7ewyPQifVXTnEo7cX/yYXVXLlK7DACUhom0yWETVWLlz8TQkWE/4g9P5dE3gw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=obVmZ8GX4bubPaMxSnWrKDXrDHI+xE4qyWDUElMeIFU=;
 b=px8w8+mbamRH4HM2lpKRB5mofPGIyRUCYRYLjEagdAtVEfUXWLsZ+E7WCS1Zxu0rmq25nrLk31QUdGHyymr70YtMVMQf41P5S9GVe9jStHZCsD2K9AwSbBVH3GfL29ukrMpVNsKDDh3MEST7tfRBx69EEUCP+yCCcht7CU8a/zIJl/crcmOaupLhZHPlKH1U0Ezl7P7vqdGlS6JLhCRV+a4AD580GfD+CCGsnXwhLCz4mHlbBPsV/OtlJKPUQxO4VNif0k8zeJLzO1gpiBmERBfhpfzssJmgoAwQMv+pOQ6DLIf7XLetuhX8wBOE2QuX2rpaCIChJRPlRdhOC1NJaQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=obVmZ8GX4bubPaMxSnWrKDXrDHI+xE4qyWDUElMeIFU=;
 b=lvhyHafcsCVmbVVITcjgEqbfftHV2aGVhMynNckoESAlvx/wmrKAzUhFY2viNS1WiS95rBYemhLhWBrpjujSOgIyTobj/XXLvYAZUNfDr+LvXOTl4IIOhhWbHgIXKfp6rjz+/TInBrzWN18SQO7ZX0HGItoXoyrd6dAR/bGwg7zeieiLvctTXf+2jnBudg4ME5N+v5r2Lrm/egHOBCylATvFBtYMgJ+v0l6ddwDh2gF066deLiGW1zBOobBMXzo1qX4O0jui3LYVmH0QeLBGR8TlMaOruawQF5xswL9DPz23ntYpZwpwKHlef3cpvXYl09wJvIxDCwx00sh0IMZMkA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by DS2PR12MB9775.namprd12.prod.outlook.com (2603:10b6:8:2bb::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.270.18; Wed, 5 Aug
 2026 02:37:03 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0292.013; Wed, 5 Aug 2026
 02:37:03 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Tue, 04 Aug 2026 22:37:02 -0400
Message-Id: <DKGNSTN7AO7H.398LXD2M0NIN7@nvidia.com>
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
 <DKGA508ERSYM.26RBD4HYM1SL8@nvidia.com>
 <2evaxdu6cobpnzzer3y7fsrqvmtmhj7gm3e5buebdaw564igx6@7bs5enipxnpx>
 <DKGBQHP25RE0.3NKUQSDULAQSX@nvidia.com>
In-Reply-To: <DKGBQHP25RE0.3NKUQSDULAQSX@nvidia.com>
X-ClientProxiedBy: BL1P223CA0041.NAMP223.PROD.OUTLOOK.COM
 (2603:10b6:208:5b6::12) To IA0PR12MB8374.namprd12.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|DS2PR12MB9775:EE_
X-MS-Office365-Filtering-Correlation-Id: c8a9af6a-bde9-4bbf-ce94-08def29a6ef0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|23010399003|376014|7416014|22082099003|18002099003|4143699003|56012099006|11063799006|5023799004|10067099003;
X-Microsoft-Antispam-Message-Info:
	0x3On7XjfeMU774jh8VPzKkHdvNos7n8/m5qHABaGfkenoT7e1nT3iT7kKsDs8kfD0qzfYWfWXtS5+MQmSexlsiQ1+IJyCY4Dm8lGqb3y1zazkV2zYo2EwQr1wvgABby0hKE+4esuakqN4yI98R/+gsf7ZOTaBcZw/Dm7E/JfeQeWskc7ReVwW7HNz7hmKP18QZb/EItLrC+k3K34djWl7QSydlAi7NZzmT1ZuSaoThUAr/pEvpg6DjAbN+X7WoXYJlfkWH4XSmYUwk4xYn5Nuc84yPJiDk1m8X/1KsKITOqE3r3JqePVEgia+zD8F4isaPu7UV7LMO05US9z+a/U52jeMjILIGb1ynkoBgVFINwPVffnTUU+jxo5GnXesDOmZxawjwZm+4u0xskS7VPRTYw+AtD0rlRGgVr5WHA5CuEPvtrpYJV0nB0HY4FwXsI7i/AGN2THCYkwrQqaV7Q1PU00kLdrozgEbUqCKp3NrFR1lzp/2L0FIylWbVOSKPFj0zWbDXP56LSsvSbmSQjp/pNC/P15ZT9OhyFgVfBWXXcz+eVYjVN7FXT55WYfpbgTeR9r21WkNSDqhy5nnbmEw3UfvK34vIEZq4FIB8EbkgoSQQ00kRNM/stnGbjt8rC5k1xGlYblWUpDd3hF+129eJnUfT9knmqxFxVrkJvGHA=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(23010399003)(376014)(7416014)(22082099003)(18002099003)(4143699003)(56012099006)(11063799006)(5023799004)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Rmh4cDRBblMwdCt4U0xIaVJ0c0VhUExmTi9qaGJjbDdJT1ljZHpIbG1UMnZ1?=
 =?utf-8?B?bi9LM1lrMUxsckF1MnRnaFJRa0RYVTFvR2tTdjFlRURwZ2JUYnJFL1pTZ0dk?=
 =?utf-8?B?Ny9OcEFJUUpXdHk1WUlrcU1QanlUMkJzT3FtNUJhc0w0N1FySmlwN2IvQmFV?=
 =?utf-8?B?Yk5ndlNHQmR6a0IyWSsrYXVwcTFhVjFXVWVjYXRkM3R2Um83dk42TDVQenVq?=
 =?utf-8?B?cmN3UkhwTmVXTVhFUG1NS1FvTXV0OEwvTlJYU0tpZ1Z6cDJpRVJRalB2Z1RC?=
 =?utf-8?B?dmphaDRCeU5VRVJhbXBiT1c4QUdabStQbW9veVdFejViRzcyYnZRd2gwNmpI?=
 =?utf-8?B?Z01DdmFIYVRSNG94Q2pmK1JBeGxpekVrNmxiRWM2QXprdHVscDROeVNaamhz?=
 =?utf-8?B?bEg5U2V3TGNqRkp5T2dub0lqbzJ2c0hLTWJWSHlrQmJVaEI2aFREajZyQlpn?=
 =?utf-8?B?Ykx1Zm5Nc2pOWmJBMUxCQWt4aXJFWkY3RlNEcmVoSVFZaE9tUDBibnRZRjJv?=
 =?utf-8?B?bnk4NEZmSjdDWG1PM1hBOHpjekdIcU5QSDdYQ3lpZTVCd0ttMk9zbzdNcDYr?=
 =?utf-8?B?ZENFZy94YmxWQzZJWGVybXVpZkNkemU1cXl4akttNEVmWHNpMmowN0gxWnFP?=
 =?utf-8?B?aW1tR1V3TWRtaEdwbXJzN3EvQVRIa21mdjhtSGZhMDU0dVBUVVhEOGFieTdS?=
 =?utf-8?B?b3BJMkZmQVY4b1lzSEVSK3F3TE96TmNMb29YKzBvTkt6eENIai8xblJPRkxx?=
 =?utf-8?B?Yk00NVIxa0Y4LzYvZmJmOEJVNCt4NVEyaFE0Y3dmWXppc21jV2xPQ0dXN1Y2?=
 =?utf-8?B?YWprV2JXMkUzMlB5MFVmOHc0YUR3ckdxRG9YWExpUnRlS0p3WXJSYVZ0bER2?=
 =?utf-8?B?U2lsN1UybTVxQ25QeER2Q0R3aVJaM3o4a1VHVWVKblJIU3dFb3F3SVNPR1R6?=
 =?utf-8?B?eVpsTWVSV1RhK3NPVHk2SFdIV3lVVGt4ak5GZzBwL3RhczBuNVc4WG4zNy9v?=
 =?utf-8?B?V1hnMHZ3TzZnZVQ2Qjhubk5vODNNTjg3NWQrOU9OZlROdURRaTRKSEJCekVC?=
 =?utf-8?B?MDdWU2hURFBvYUZkaXIzN2tQd082elNTVnZ2TkJpQW05VFA1d09PN2lDWDRk?=
 =?utf-8?B?V2d6a0tWeUhJYkc3Qm8yaWZWQ2hQVG5hQWxtM09WSmRLZnA2TW9Manl0Zlc0?=
 =?utf-8?B?VWdybkhub2s1d2owTEREcWN0OFZIdXZlZ2loVHBIT0VkaHBtK3JMZWNLMFJz?=
 =?utf-8?B?cXY5WFRzWmZSaEN2eEREQ1VyTnZLZ0tGbThXZzJpSHREN1NjVUpoS0RDbGp2?=
 =?utf-8?B?dWFGdkQzdVB1NkFGcVlrWEpUQUM1OVJ1dkVIZWFjaXA5SXZSaGs4M0dDZ0FO?=
 =?utf-8?B?NlpGU2RZbmg2U2FnYzRSRUdRQ1RCQ0EyUlFaSzBGSjRwZlZJVUZjalJWVGVD?=
 =?utf-8?B?Uy9Ic2pabzVIdVkybDNBa0dwVVhLZ3FwNnVXR0YzQ1NDSktoalI4VExIMWUy?=
 =?utf-8?B?TUQ5NTRKU3pHU1hsMG5jYXNIUGhuYm1CamJwR0xtendRMkZWdVdKWjZ5NVI3?=
 =?utf-8?B?NU84MitJT284dGUyZW52TGhuZnVEaWF2aTNGQWhCWWF2eVZNZFdxLy9lNWwr?=
 =?utf-8?B?MmFyTVVkdzRpNHJzWlRLNmU0R1ZaZ29tTWpzSEIrZ1pqOVZ4WnVqU2ZFeVcr?=
 =?utf-8?B?dWpDdmVxa05FaDI4WkFoWldIbjJUbDY4ZVRVMDZhTFNZTTU5RFVDV002NUxU?=
 =?utf-8?B?Y3IxbjZBTmhiQ09kbWEwZHJJZmI2UTlac1NUNmQxby9QcnZlWm1GV3pFNVpo?=
 =?utf-8?B?VkZUOURocUpXdXpiZjBuQ3hXZUZxeXNGeVQyeEtqVzFMNVQ5OTJIUHc5RzE3?=
 =?utf-8?B?aVhSMm40b2NpOHFoZVRXRkVYOHhmcUN5NDZRREFkcXp6RFFJWGcwSFpyejg2?=
 =?utf-8?B?ZmhpNVJxenlBdVVzWUZLdmVneG5ZbFZpL3NOekkxTzVYL2d5Q0lkVXVhSkNu?=
 =?utf-8?B?aHkrRkh2Q1hRMWdzR2owN3RtdnA4UWhGbVl1VW1LNjc4RmVxRmUrT0tRYTNR?=
 =?utf-8?B?ZjJOeDBYc0xPTC83ZjZ1S1g5YnVHL2ZiNnNmVkxPSkVwd2pUM3NrRkdJUmpR?=
 =?utf-8?B?Zkx3QTNtNnR2VTl6N0xrZ3pBZG5ENTQ5Q2ZjTks4S1RBRkdTZUdlV2lJQXNN?=
 =?utf-8?B?Rm0yNFdJSUxLenFmcGF3UXlnNTEyQzJXVGgrcG85aDJmR3RHWkpoMVlqYURO?=
 =?utf-8?B?YzlsS012TFJCZjAyN3dnU3MrUVVHL1grUUxQUXI0MEY2T0Vyb0Nmc3g4Sldr?=
 =?utf-8?Q?JG0dVob8oBi2KWLdSv?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c8a9af6a-bde9-4bbf-ce94-08def29a6ef0
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Aug 2026 02:37:03.4994
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AVG+vVOIVHEi01EXhwNrLzilW+p0FRQfBuhPf6gsfmQdXUSz9OjYVZpBzaNMHqkW
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS2PR12MB9775

On Tue Aug 4, 2026 at 1:09 PM EDT, Zi Yan wrote:
> On Tue Aug 4, 2026 at 1:04 PM EDT, Jan Kara wrote:
>> On Tue 04-08-26 11:54:41, Zi Yan wrote:
>>> On Tue Aug 4, 2026 at 5:32 AM EDT, Jan Kara wrote:
>>> > On Mon 03-08-26 12:56:36, Zi Yan wrote:
>>> >> On Mon Aug 3, 2026 at 5:54 AM EDT, Jan Kara wrote:
>>> >> > On Fri 31-07-26 22:13:30, Zi Yan wrote:
>>> >> >> erofs needs to traverse readahead folios in reverse order to achi=
eve
>>> >> >> maximum performance by
>>> >> >> 1. reading all folios from readahead_folio();
>>> >> >> 2. storing the prior folio pointer in folio->private;
>>> >> >> 3. traverse from the last folio to the first one.
>>> >> >>=20
>>> >> >> Add readahead_folio_reverse() to achieve the same function withou=
t using
>>> >> >> folio->private.
>>> >> >>=20
>>> >> >> It prepares for a future commit that replaces PG_private checks w=
ith
>>> >> >> !folio->private checks. After switching the checks, erofs's use o=
f
>>> >> >> folio->private without bumping folio refcount can cause unexpecte=
d
>>> >> >> outcomes, e.g., in filemap_release_folio(), try_to_free_buffers()=
 becomes
>>> >> >> reachable.
>>>=20
>>> <snip>
>>>=20
>>> >>=20
>>> >> The below is what I come up with. I did not add a bool to
>>> >> readahead_control, since I think that is the decision of caller of
>>> >> __readahead_advance(). But let me know if you disagree.
>>> >
>>> > The reason why I wanted bool in readahead_control is that if some cod=
e
>>> > ends up mixing readahead_folio() with readahead_folio_last() things w=
ill
>>> > get confused (because __readahead_advance() really wants to skip the =
batch
>>> > returned from the *previous* call to readahead_folio[_last]()). With =
the
>>> > bool in rac, even mixed use will properly advance the state of the
>>> > readahead_control. I don't think mixed use is very realistic (at this
>>> > point at least) so I'm ok with leaving that for later if you don't li=
ke it.
>>>=20
>>> Got it. I am trying to figure out your mental model of how the mix of
>>> readahead_folio() and readahead_folio_last() works with the bool inside
>>> ractl. By looking at readahead_folio_last() code, it is almost the same
>>> as readahead_folio() with __readahead_folio() inlined
>>> (__readahead_folio() is only used by readahead_folio(), so the inline
>>> can happen without any issue). As a result, we can get rid of
>>> readahead_folio_last(), add set_readahead_direction() to set the
>>> embedded bool read_from_head, and use readahead_folio() only. This
>>> removes redundant code in readahead_folio_last(). One thing I am not
>>> certain is whether we want to
>>>=20
>>> 1. use set_readahead_direction() explicit and warn readahead_folio() if
>>> read_from_head is not initialized, or
>>>=20
>>> 2. set read_from_head to true by default, so that only erofs needs to
>>> call set_readahead_direction() to change read_from_head.
>>>=20
>>> The former is less confusing but changes how readahead_folio() works;
>>> the latter is simpler but implicit read_from_head state might confuse
>>> people at some point.
>>
>> My idea was: readahead_folio() will call __readahead_advance() and then =
set
>> rac->forward =3D true. readahead_folio_last() will call __readahead_adva=
nce()
>> and set rac->forward =3D false. __readahead_advance() advances from begi=
nning
>> / end based on rac->_forward value.
>
> Got it. I can do that. Just to be clear, it should be that
> readahead_folio() first sets rac->forward =3D true, then calls
> __readahead_advance(), since __readahead_advance() advances based on
> rac->forward, right? readahead_folio_last() as well.

This is revised patch:


diff --git a/fs/erofs/zdata.c b/fs/erofs/zdata.c
index 74520e9102596..23f423c22ac8c 100644
--- a/fs/erofs/zdata.c
+++ b/fs/erofs/zdata.c
@@ -1902,21 +1902,14 @@ static void z_erofs_readahead(struct readahead_cont=
rol *rac)
 	struct inode *realinode =3D erofs_real_inode(sharedinode, &need_iput);
 	Z_EROFS_DEFINE_FRONTEND(f, realinode, sharedinode, readahead_pos(rac));
 	unsigned int nrpages =3D readahead_count(rac);
-	struct folio *head =3D NULL, *folio;
+	struct folio *folio;
 	int err;
=20
 	trace_erofs_readahead(realinode, readahead_index(rac), nrpages, false);
 	z_erofs_pcluster_readmore(&f, rac, true);
-	while ((folio =3D readahead_folio(rac))) {
-		folio->private =3D head;
-		head =3D folio;
-	}
-
-	/* traverse in reverse order for best metadata I/O performance */
-	while (head) {
-		folio =3D head;
-		head =3D folio_get_private(folio);
=20
+	/* traverse from last to first for best metadata I/O performance */
+	while ((folio =3D readahead_folio_last(rac))) {
 		err =3D z_erofs_scan_folio(&f, folio, true);
 		if (err && err !=3D -EINTR)
 			erofs_err(realinode->i_sb, "readahead error at folio %lu @ nid %llu",
diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
index 4e8b2b29f6d3e..cc69d60b2a9d2 100644
--- a/include/linux/pagemap.h
+++ b/include/linux/pagemap.h
@@ -1448,6 +1448,7 @@ struct readahead_control {
 	bool dropbehind;
 	bool _workingset;
 	unsigned long _pflags;
+	bool forward;
 };
=20
 #define DEFINE_READAHEAD(ractl, f, r, m, i)				\
@@ -1512,18 +1513,25 @@ void page_cache_async_readahead(struct address_spac=
e *mapping,
 	page_cache_async_ra(&ractl, folio, req_count);
 }
=20
+static inline void __readahead_advance(struct readahead_control *rac)
+{
+	if (rac->forward)
+		rac->_index +=3D rac->_batch_count;
+
+	rac->_nr_pages -=3D rac->_batch_count;
+	rac->_batch_count =3D 0;
+}
+
 static inline struct folio *__readahead_folio(struct readahead_control *ra=
ctl)
 {
 	struct folio *folio;
=20
 	BUG_ON(ractl->_batch_count > ractl->_nr_pages);
-	ractl->_nr_pages -=3D ractl->_batch_count;
-	ractl->_index +=3D ractl->_batch_count;
+	ractl->forward =3D true;
+	__readahead_advance(ractl);
=20
-	if (!ractl->_nr_pages) {
-		ractl->_batch_count =3D 0;
+	if (!ractl->_nr_pages)
 		return NULL;
-	}
=20
 	folio =3D xa_load(&ractl->mapping->i_pages, ractl->_index);
 	VM_BUG_ON_FOLIO(!folio_test_locked(folio), folio);
@@ -1549,6 +1557,39 @@ static inline struct folio *readahead_folio(struct r=
eadahead_control *ractl)
 	return folio;
 }
=20
+/**
+ * readahead_folio_last - Get the next folio to read, from the tail.
+ * @ractl: The current readahead request.
+ *
+ * Like readahead_folio(), but walks the range back-to-front. The folio is
+ * returned locked with its refcount dropped; the caller unlocks it once I=
/O
+ * completes. Compound folios are returned once, at their head index.
+ *
+ * Context: The folio is locked.
+ * Return: A pointer to the next folio, or %NULL when done.
+ */
+static inline struct folio *readahead_folio_last(struct readahead_control =
*ractl)
+{
+	struct folio *folio;
+
+	/* Shrink the window from the tail down to this folio's head index */
+	ractl->forward =3D false;
+	__readahead_advance(ractl);
+
+	if (!ractl->_nr_pages)
+		return NULL;
+
+	/* xa_load() follows sibling entries, so a tail index returns the head */
+	folio =3D xa_load(&ractl->mapping->i_pages,
+			ractl->_index + ractl->_nr_pages - 1);
+	VM_WARN_ON_ONCE_FOLIO(!folio_test_locked(folio), folio);
+
+	ractl->_batch_count =3D folio_nr_pages(folio);
+
+	folio_put(folio);
+	return folio;
+}
+
 static inline unsigned int __readahead_batch(struct readahead_control *rac=
,
 		struct page **array, unsigned int array_sz)
 {
@@ -1557,9 +1598,8 @@ static inline unsigned int __readahead_batch(struct r=
eadahead_control *rac,
 	struct folio *folio;
=20
 	BUG_ON(rac->_batch_count > rac->_nr_pages);
-	rac->_nr_pages -=3D rac->_batch_count;
-	rac->_index +=3D rac->_batch_count;
-	rac->_batch_count =3D 0;
+	rac->forward =3D true;
+	__readahead_advance(rac);
=20
 	xas_set(&xas, rac->_index);
 	rcu_read_lock();


--=20
Best Regards,
Yan, Zi


