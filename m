Return-Path: <linux-erofs+bounces-4510-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 638DBC79F99
	for <linux-erofs@archiver.kernel.org>; Tue,  8 Sep 2026 17:20:12 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hfW0V55YKz2y1F;
	Wed, 09 Sep 2026 03:20:10 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=pass smtp.remote-ip="2a01:111:f403:c007::2" arc.chain=microsoft.com
ARC-Seal: i=2; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1788888010;
	cv=pass; b=DUXTOvFRiE9eaW8FKmnLWf561hsy1ZDfAcSI1V44m/qS+j6oggcyXNEsEP10Krsu0i4PUInplv082dAAmJoXSwqRWq22yXlUO9SkaqGYKkhrP5LLkSkAtUxZ74l2ip/HxFwfIqSB8mUlfbHwp5rHqrcLtjVVpAn3fVzbkSY1xX/QfqplPT7KA8k9o5A6YL+LWC6O/fkrQFdt3k4a3VA8mnDbMZ78FDktUsvrDyunWZvuedS/JxJO8h3iDwTTfcComun6iZFVruCHcOzrjvbUFOcIxcMDy/cAvkDhUEYnFNXlIeZlxT4xEWx3vnBT0GTRMRQC4Zu/+G7yMt/WJdhKQw==
ARC-Message-Signature: i=2; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1788888010; c=relaxed/relaxed;
	bh=8vySYuRBx5ZTNZ6KRFRz/SbhYKKanycrnsZJu2MdRf4=;
	h=Content-Type:Date:Message-Id:From:Subject:Cc:To:References:
	 In-Reply-To:MIME-Version; b=gjot9//6tW1y55ihq7JV01QA7xttObfYGvLyYwJ3TXNvjVdDD1eF2itMl5znCu1VUKErm/iAlFRYE6xoWHw2oQ3tXEmsIZ//lE97XLUmeUu2AKDcNMu2mwlpaUPdhi4XUEdftuq2aKSaTTwU196XJeYV4tTOFP03FO2gLky34+BpczlpnCcclbOWRjb+pGCLox6gX8zcDj0e8uZLcvFjwCReLv658sOEKCRSxIBenIYXiceVi07EBNKk7WHH8TB6nifv6JFep1fxZi5YZTXrOISQEGrkXsj1/jk53okd5+2s5YmdY1BtxVrhqPxCg6KrXNUl0XoXsvB7EhHYHbEWfA==
ARC-Authentication-Results: i=2; lists.ozlabs.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; dkim=pass (2048-bit key; unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=QQKCvXzA; dkim-atps=neutral; spf=pass (client-ip=2a01:111:f403:c007::2; helo=mw6pr02cu001.outbound.protection.outlook.com; envelope-from=ziy@nvidia.com; receiver=lists.ozlabs.org) smtp.mailfrom=nvidia.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=QQKCvXzA;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=nvidia.com (client-ip=2a01:111:f403:c007::2; helo=mw6pr02cu001.outbound.protection.outlook.com; envelope-from=ziy@nvidia.com; receiver=lists.ozlabs.org)
Received: from MW6PR02CU001.outbound.protection.outlook.com (mail-westus2azlp170120002.outbound.protection.outlook.com [IPv6:2a01:111:f403:c007::2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange secp256r1 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hfW0T6XLhz2xLq
	for <linux-erofs@lists.ozlabs.org>; Wed, 09 Sep 2026 03:20:09 +1000 (AEST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hg0mgCfADC7zh7SqpESLrlzWk5lwn0EEj7xvNLQFN/PQnSWYuC9J4duI7Y4BXkCASNx7RQPRR36HhX68KWaAkeUTMuikJZo0tGUJxbKLGX0f135WkZLZ6BW/X+/0VPe0uIabgdWrd1EsPN4S3tkpnqP7TbbxF+CkjUP/C4g+Mfi4d90jX7DOLzAy3YSc7dE3u6Uo/emd2zQeoPqaZuoAnwiW6Tk02f3FkcmNj2DyZIrtXJuYQb/ImK1Ey86pI/0h+krJ37nx1NgCTXq5ZfxS+VREY/4hQj/zUfWQG2kzQT77k0O5SzpigtZtCpKlm7LHla+hLA6dI7JiwKHpMz8pmw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8vySYuRBx5ZTNZ6KRFRz/SbhYKKanycrnsZJu2MdRf4=;
 b=a/fgwD8Wb1GlOdzeYKIiyxwJLxrgTcE1MtjFLMidXatP3zIseniG+Oj406k2abi85h8RS+o2qwIN2NaDuyswXV9VmZhTT9TPKB9X/bK0c30qThdadIqSC/E2645gTGjAYzxC3ChDu8EPoLsL9f1liFlXk7QqUdfkn/2jwgUrtWf2v4++mmvN+KLp0IlENzNtX3w4I2un7vEt8QDqkgwK5cvt33oxGjs3Fn0gF8uUbOmWB55Q4fvbNo3ljBg4P04L4SRiVFPWXw4RetecHlJzOQ5YqiOTjhSykPYneCRBv96kkMoOO6fARDBlVwn0BuPP4PxqUZbR6UeE+2JnkwW/nA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8vySYuRBx5ZTNZ6KRFRz/SbhYKKanycrnsZJu2MdRf4=;
 b=QQKCvXzA3Fg6WOhyZavz18I9URUSfw/U4lBskfD7M2UMOpMDh8POJ2SPs/85lf2VO2Ia8ss3Uol2dSWmZorS379+SYf/Y9WllMLOnRdHU2HTj88/QOc1vEHj0kRHvVhoHQeNb2puSLrK5EZXCbHzbmO0mKFDaV9whsYAUH1I9NMxZNUdM9uNGjvM+tIJvWEaiERf145TFHCMUPqRsET/iU5S2FuP2DHpPIOCsR12NBYDfdFQqeK3PvP/HPI4S8fLnrdo06BK7Xl9lQDDgbh7Tb19eqR96p6yk+f7ImC2vCXtq/sLxYyFECZG9m9cuRGwYP5sZvYuibG+OeDoGk5GqA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by SA1PR12MB6751.namprd12.prod.outlook.com (2603:10b6:806:258::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.15; Tue, 8 Sep
 2026 17:19:41 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0406.005; Tue, 8 Sep 2026
 17:19:40 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Tue, 08 Sep 2026 13:19:38 -0400
Message-Id: <DLA3V43TKTU8.20221CSH8UJ5T@nvidia.com>
From: "Zi Yan" <ziy@nvidia.com>
Subject: Re: [PATCH v3 08/14] erofs: use folio_attach/detach_private()
 instead of direct assignment
Cc: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>, "Gao Xiang"
 <xiang@kernel.org>, "Chao Yu" <chao@kernel.org>, "Yue Hu"
 <zbestahu@gmail.com>, "Jeffle Xu" <jefflexu@linux.alibaba.com>, "Sandeep
 Dhavale" <dhavale@google.com>, "Hongbo Li" <hongbohbli@tencent.com>,
 "Chunhai Guo" <guochunhai@vivo.com>, <linux-erofs@lists.ozlabs.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>, "Matthew Wilcox (Oracle)"
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
 Song" <kasong@tencent.com>
X-Mailer: aerc 0.22.0
References: <20260907-remove-pg_private-v3-0-6ae22f9d9272@nvidia.com>
 <20260907-remove-pg_private-v3-8-6ae22f9d9272@nvidia.com>
 <5b02f5de-00b6-4f8e-9e30-6d0acedafaf4@kernel.org>
In-Reply-To: <5b02f5de-00b6-4f8e-9e30-6d0acedafaf4@kernel.org>
X-ClientProxiedBy: BN9PR03CA0113.namprd03.prod.outlook.com
 (2603:10b6:408:fd::28) To IA0PR12MB8374.namprd12.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|SA1PR12MB6751:EE_
X-MS-Office365-Filtering-Correlation-Id: 2537c3f2-13bf-4caf-9430-08df0dcd5d8e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|23010399003|376014|7416014|921020|56012099006|10067099003|11063799006|4143699003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	nyVyBFMfhC1yK9mDzgK1I6VaCLxikKw5Yp8jpuiZPn2fQnidNyZfIddYc5Y5JG9ky4htJ8SLdCUXw/ZtAq77xtycaWFLVKx+bIDk0sHAHv8ar1fiu3zKbDWGA1nA9iICMNj4mwVfFZm6vRXfN/jznzGwcMXwzRX5nEwTo08/VvxLD02G22vWQFse3WZ0XmWBPr85uMkQ3h0FXxg17kg6aFs1wCw1Mt7l8DuZrOVwuoWR7U++64TSZlcyc7zYUL87OWU/rtUZ16Wh6aMF5OGYT/3BSCiISIKkrRlZ+rE7G0N2+OuUVFb+fOU3OC4Ez+4JJ0Q0mKFLKRL7KMM7Z78wf2ecySXH8Mq1oXlavnf+Rg51JHTHTnxV9YclIjEviMui1p2OfIK4GhxS98LHAnt6qO0YB+4ajwTPDmDbXeULIS5ylm52bpc1jV4/25jjxyXXt9Rr2REIO6thxBvhz5uAKRttOb1uiDtAzwGjyo6wBIeEb6B7RxQVxiqYlor+YyY7n+c94mL3KB2tRxopJ22ds8Otmp/aFKTVbXhK5nMOlcUt1AiDH7E/jxxMsNJQ3l1Q3upJlOu9XiNLDC0yD2CRZfKRRBn8WNzSFWDshT8xN3n/dq68JoHMlRtL338AXjepFdh2dIDGLVOv27QyoOlaTojk+1B/GduBKyglOpHxc1Fu/rgNG/Qd/wBolxH/UjGbKEXJ4Ue8EXGFUiQcpZmiww==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(23010399003)(376014)(7416014)(921020)(56012099006)(10067099003)(11063799006)(4143699003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?SU03MXY2VVhtcHYxRWM0d3pmN21Iem1PUEdYcUdyNGJ3TDRFYTAzSkNmK1N1?=
 =?utf-8?B?TjA3NDBuTXorbXZncklkSC9UYnRNYldqZjVjRlova25aOEl6b1NmQmtNVVhr?=
 =?utf-8?B?VTF6UEFpcU51dFNjUFBCSEljRVJRNFBwcGRqOE8xNXNmQXBRL0pPSFB0RzJY?=
 =?utf-8?B?UUxRajUrb3BpNjhCb1JaT01Od2FGa3pwRjdaV2l0MHJMVlhudGJsR2g2ZjQ4?=
 =?utf-8?B?WFRSdytCaXBXNkFEQWpXc0ZKajJWQ3Zyd3ZyNk1NSXIvMjNhUEdTNytod05H?=
 =?utf-8?B?VThBVTV4VnFlSkdRTGdMOU1ONUFtNnowTEVLVFc1WUdDY2VMWXhZcGowNzg3?=
 =?utf-8?B?K1hsUDZiSkxaQjYweW9wNFFjdTlUNjdUU0NqT0NUWmZpaHdaUldXQmRBMDRq?=
 =?utf-8?B?U1VQZGlHekxDa1Y5dE8rV0d0T05wY2FjQmVwZHpRaUNLUjhud0EvL3VndFpB?=
 =?utf-8?B?NFBYV3dISmdtdVRtWm5oU0NzV3dIbFNSUWxWa2dqaE5vYi9yVDE3N2R6MUlC?=
 =?utf-8?B?WHQwTUZHQ0pZOVNWclFmd3JhdnJvcitBWXVaWUFDNFdsTzhxdVprWVExRXha?=
 =?utf-8?B?NGVXMUEzQzhKTkluY1Vqc0hjOEljRFB4bnBzV1B5a2czL1BMSTJmWEcyZHlZ?=
 =?utf-8?B?eEpHL3FUdnAvQ09EUUkxOVhWdk5kcnlyeGZ2U3dXdmZRTzBRSVRrNGsweDZP?=
 =?utf-8?B?Sno0dm1jL0ZNOHQ3UitJYjNLQ0FoUnNDaFhtLzRJeTlqbWxGNEZOa3VNdGtY?=
 =?utf-8?B?VmJQZ0FJZmVBUTNDcmVkcGdZUE5WR3RuamNOSHh6SVlTbHZhb3JPbFRhUE1I?=
 =?utf-8?B?RDRiME03blRicnRaVVBMR1hOM0E3ZDRkUmFiMldDUmsxeWhmbzg1cHBncGUr?=
 =?utf-8?B?MnFyVkVtTmlSRUFiN3puZHVCN1ZPaFFMT3Q1VzZseS9DMkN4bkthUm5PNWxU?=
 =?utf-8?B?VDRuZStGV3dtUkZsQXRzQlAyc3FVbE9ta3BPK2tDMnZpN01TcUhCYlF2cVNC?=
 =?utf-8?B?QVFTYXNXbktQZHIyZk5UQ1M2QmdXNGZUcURiRmJaOTg1OUloVE1aTHZ0eXND?=
 =?utf-8?B?Zjd1dURXVU52T0JET2k3T0dGbXBVM2pmZWMvK2oyMVVGbW1wRWJzeTg3OTZF?=
 =?utf-8?B?aXA5bzhZWDRwL3hVMUtmb0IycUl1bzBncGI4eTFrYnEyYlRKZEtqaWRZd1Ir?=
 =?utf-8?B?T0hyQXBQbUQvdk9ZVXI3WDB5ZVUxZFlsckR0ckFZVW4vZ2YrL0JuSWlaK1VD?=
 =?utf-8?B?bE96cG1QZTdwazdBNWk5c3FRaWZQbmRQaVFrM3BwS0J5a0RWT2t0d1FiSVA4?=
 =?utf-8?B?dk1XS1BMZGJ0Tldkd0E4cytPbWFSUSt0QzJHVUxSSWlyeHRBblhGMEM4ZDdw?=
 =?utf-8?B?NWZhbGp1d0hTZzFaUmZXc2wyWjMxV0hnRWxBOGhkRXVqMUpkM0p3UnRrd2l0?=
 =?utf-8?B?S2Vod2VSSXpPNmxPZmYyWTgyR09DcExuUHF1S3ZmVWs2S09vMkFUcnVsT1FX?=
 =?utf-8?B?QW9LOTR3S01FNDd0VHlmY2NVZWoxUk5tTnVhYTNJQXd2TTFYKzUrMmRMYmVP?=
 =?utf-8?B?OEtFeXQ0ekMwOFAwVEFxTnRtRzI0V0NuT2JRK2d3ZllRQ2tHMmplQ3lySUNK?=
 =?utf-8?B?ZU9VSi9BakhjTjZ6WmVIdDNPR2ZJeDRmeWxodWNQc1hyc2o4anNnd0Z2cTRK?=
 =?utf-8?B?N0o2KzA3K1phc2dFTVdSSXcyMzJSSlZ1dHA2RTl2L2wzTmgxWHA0c1dUeFI4?=
 =?utf-8?B?UG1uVnBXMWdMKzJJTmljWlN0ekhsVHlKajJMcVFxci9yRmYzNnRzWG9ya0E0?=
 =?utf-8?B?RllPR0pEOEZWcXN0OGk1d2RqQkc2N3BsL2YrMnQ1cEtQWUJJSHJwbjNPbHJz?=
 =?utf-8?B?MWFWMHpGdW01VXNKc1VLNHFvOVoxWGRaMlNGQUN1Y3YzSmxqeDF6SHd3M3F0?=
 =?utf-8?B?RFMyYzkzR21STitldUpmczZHUXBJY29tRG5YZ29JUVZzZnhmL2JwclNCZ2ZN?=
 =?utf-8?B?NW1GWTdPa2JTU1NFT1RMRkJRM3V3S1VyYUxBVXpzVGJFclc2UjR1Z1NnWWxR?=
 =?utf-8?B?UzBWdWxPN0xXNmVBSjZaeUFpZDR6RE4vT3M0RllIVFFObHorbFY0b2hrYkVV?=
 =?utf-8?B?OE8vOThVVEk2dTlScWx4WTNKT2pSQ0dFTUliRUF1Mkp1bURJbFBTblBlN3Ja?=
 =?utf-8?B?QVZQZWh0eEVDanU1SjN5THB0OTBQc1B5M3ZWRDQ3YVdHNEJrbnYzZ0NGYXpy?=
 =?utf-8?B?b1VnVWdJcGlCcUlRZXA1dzFGd3hpVEZ4bWVocURZckVWa2xIZmF4VnByM2Jv?=
 =?utf-8?Q?CcAIw0s5Y+eDU0vaIH?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2537c3f2-13bf-4caf-9430-08df0dcd5d8e
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Sep 2026 17:19:40.0769
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tyal2p7KORlvH/G2nA7k7W+CtaroqK7n8q/cg+gNxgeX3fmtDl7deRlWX4l7fyG6
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB6751

On Tue Sep 8, 2026 at 12:13 PM EDT, David Hildenbrand (Arm) wrote:
> On 9/8/26 04:56, Zi Yan wrote:
>> erofs_onlinefolio_init/split/end() use folio->private without setting
>> PG_private or increasing folio refcount and it works. But after PG_priva=
te
>> is replaced by checking folio->private in a future commit, it can break
>> folio_expected_ref_count(), since the folio has private data without
>> elevated refcount. Change them to use folio_attach/detach_private().
>
> Freezing the folio will properly work I assume, as we'd always freeze wit=
h that
> refcount in mind or remove the reference (detach private) early?

Yes.

>
> I'm thinking of folio_ref_freeze() in __folio_freeze_and_split_unmapped()=
.
>
> Or is the ref only very short-lived either way such that we don't care?

The folios here are locked since they are in the process of
readahead, which requires all folios locked. So they are not reachable
from folio split code. In additio, the private is deatched and ref is
decreased before the folio lock is dropped.


--=20
Best Regards,
Yan, Zi


