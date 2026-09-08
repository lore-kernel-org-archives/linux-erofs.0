Return-Path: <linux-erofs+bounces-4509-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B20B8C79F82
	for <linux-erofs@archiver.kernel.org>; Tue,  8 Sep 2026 17:06:25 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hfVhb6frfz2y1F;
	Wed, 09 Sep 2026 03:06:23 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=pass smtp.remote-ip="2a01:111:f403:c111::9" arc.chain=microsoft.com
ARC-Seal: i=2; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1788887183;
	cv=pass; b=E6gmQGK+QkX5WhVOG/wrsTObotGdhXJ0XqNjXmtbWZ9quDEGApHmajmrqF/BoFl0XDNH3wXHupuEKCaFs91+hjJ6R+LC3iTZTx1TIpUy2mGsp6jyr3K9dhksuS4KCppp7XvHqqReiVp6CyhGWr1KPVTNigzHT3RBgjLd7pr6LrKd2IYING6CwLnkUh1TNat1mtqFSO2m+Ke60QgyTdCgpao+1rxQSwV54vethVtbeaq60SoXYFFIgKNFweJW2Wk9dcEWi6vr8alsEuvLIsdchxmNE0SB6uRG2V/5rTpQMaIY7xf+vbbKkAmfUCnP4pXrSfI8n7kHao68KXxzFIKZYQ==
ARC-Message-Signature: i=2; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1788887183; c=relaxed/relaxed;
	bh=BcaLX0DLYHv4UqScJlzSiZ1GStIaXVtAtDtoZQtOvS4=;
	h=Content-Type:Date:Message-Id:To:From:Subject:Cc:References:
	 In-Reply-To:MIME-Version; b=TSThPUgzUzvhu5wgNyRNLOCON/SDPQr1UVlL6fZF+fJVUHm/4gQjrjeRA3wlsEtni1g+JgjGPm7zmfyThLc0knpoJ6+QsmyrTmLMPCcWAmYvrBg8jDndJZZgDcvfBN226nhJ95fYapE7C7QxxXhRc1x/dNUow8D1CzJFKycE9yeyCoPDITqHoOingD8Qj0bjE6rNRoah44lQ6riKS6xjmiBApbRnoKWIiJd330hwL+2ZfjPuVno4sMbLXanR5iyt8KoPzeFJdphAw6KbuWAP1O5hLkMEn2zWs4lrxTHv81XIrgIKyl4jtYEGlF5fgX/1/QDUT5KkhKlQ4QNTUkm3Tw==
ARC-Authentication-Results: i=2; lists.ozlabs.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; dkim=pass (2048-bit key; unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=SzQ7B3g5; dkim-atps=neutral; spf=pass (client-ip=2a01:111:f403:c111::9; helo=dm5pr21cu001.outbound.protection.outlook.com; envelope-from=ziy@nvidia.com; receiver=lists.ozlabs.org) smtp.mailfrom=nvidia.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=SzQ7B3g5;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=nvidia.com (client-ip=2a01:111:f403:c111::9; helo=dm5pr21cu001.outbound.protection.outlook.com; envelope-from=ziy@nvidia.com; receiver=lists.ozlabs.org)
Received: from DM5PR21CU001.outbound.protection.outlook.com (mail-centralusazlp170110009.outbound.protection.outlook.com [IPv6:2a01:111:f403:c111::9])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange secp256r1 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hfVhZ31Bkz2xLq
	for <linux-erofs@lists.ozlabs.org>; Wed, 09 Sep 2026 03:06:21 +1000 (AEST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=mFmH3vfYYEnXuB/6E+O6M6ox63u3tJYw6TAZjFhHIcVn2lYuQoFRGe/5sAJtrYKT9vlpgabOrwmhHlCdAmwmlzrcI0dZGfHGwQ4kCh/BIbiTNGw2sRlrFwF1vbKitAY+RR3eIIVjiojeeq6bgBpDUZ2Ugd3NHvoHXl3T5n6+/aH7xn6QfpA/NSS+odyPrHefef71TiupHe3LOGp+3/7+c0lA/LmyEirY/A9+c0du3l4vfWBGZlyK+5CxSPVUPtetAflsjUGyQE0B4NBrsdd5wBpk/GLqhQQOasSohNHwLE4/91MB4TALbf5/Sy7hpLl138jCclLp1kWJG6LiQN4N9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BcaLX0DLYHv4UqScJlzSiZ1GStIaXVtAtDtoZQtOvS4=;
 b=Dp9cGw3h33ALHs7bXd+9duHxQVyv5OalkA0p+U8dh6NFkb2tg9QaFxdzeEVtYuEwo97t3c2YIeUdL0euST9U629UTz+odd0SNZCZ8lBSXLv28I0mVgiVhqIEJ9qqDGsgyoI8bxyLOsm3w0/EZSnPYAbjQ82aPq7BBYuVwpaP22KNIzqkJD9YojStEz7jc0GfeLb/LmwOBzyh2bHWOkeLpthOXM9CB2cNytMmAtxco+uXj94vuxSYbhODnm3hYbqHaZrRwDLnfqFctAdUhxitJKy8Ioy461lC4wv2hL6Gm84xsnSw/G6WYx+cDeKI3f+shMwa891f1QBYJj5oLAI5Ww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BcaLX0DLYHv4UqScJlzSiZ1GStIaXVtAtDtoZQtOvS4=;
 b=SzQ7B3g5SfPC0Kh1yz/gfedgQS6bxOykGVEhC5CctXTSd7Wwc+NbQTsenby0hBvHfnGsgh670xY+ZTtRuK+yxuMkbHBzq4HKZW+nlgHypFvtUA0a6e/ixduMqvEKESO3STyXEQFhD6RTvty+4JjKvxsAZU06172Y76CrnqhkIUUMi4D8VhxKNLYNtXLT0JjONm6c8PZ+wj/daE3KagVbYSwnqfYuJq8FqsTFefqShsA+un9TXnTZME5ia/PLNFNEmyHZAhPusYXeVl/WMzqSYslbcDCLmq4+LaF/7LC+4uz9nYFUCCUkxPDjwrTEDViGGJSjNogyS4cS+S6z39zMrA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by PH7PR12MB8796.namprd12.prod.outlook.com (2603:10b6:510:272::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.7; Tue, 8 Sep 2026
 17:05:47 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0406.005; Tue, 8 Sep 2026
 17:05:47 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Tue, 08 Sep 2026 13:05:45 -0400
Message-Id: <DLA3KHC5R6G3.22TAPOVQ1589Q@nvidia.com>
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
From: "Zi Yan" <ziy@nvidia.com>
Subject: Re: [PATCH v3 07/14] erofs: mm/pagemap: add readahead_folio_last()
 to avoid folio->private
Cc: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>, "Gao Xiang"
 <xiang@kernel.org>, "Chao Yu" <chao@kernel.org>, "Jan Kara" <jack@suse.cz>,
 "Yue Hu" <zbestahu@gmail.com>, "Jeffle Xu" <jefflexu@linux.alibaba.com>,
 "Sandeep Dhavale" <dhavale@google.com>, "Hongbo Li"
 <hongbohbli@tencent.com>, "Chunhai Guo" <guochunhai@vivo.com>,
 <linux-erofs@lists.ozlabs.org>, <linux-fsdevel@vger.kernel.org>
X-Mailer: aerc 0.22.0
References: <20260907-remove-pg_private-v3-0-6ae22f9d9272@nvidia.com>
 <20260907-remove-pg_private-v3-7-6ae22f9d9272@nvidia.com>
 <eefbff2b-d619-496e-a977-52062da90f05@kernel.org>
In-Reply-To: <eefbff2b-d619-496e-a977-52062da90f05@kernel.org>
X-ClientProxiedBy: YQZPR01CA0166.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:8c::10) To IA0PR12MB8374.namprd12.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|PH7PR12MB8796:EE_
X-MS-Office365-Filtering-Correlation-Id: d81ff76a-e855-4187-3f30-08df0dcb6d65
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|23010399003|7416014|1800799024|921020|18002099003|22082099003|4143699003|11063799006|56012099006|10067099003;
X-Microsoft-Antispam-Message-Info:
	1Lb+9cM/CDbXDsBCQTV6CRsbsKZcI0Kg5DQ6eA6K9xX1gBwXk1A4c5JzPCWXS09IN/VmUN0f2uL/7FOaAOCAEyMGGr0Al1W4JbEd6Aueb29IWxbZpbWXBwMALCsa8sopQAEtTaZ9CMgMzZiXMI6IFmilpkKt3r3WPGJ1ZHs4BuuEs4JD4JKOHDuRx/ppQcBXKZQh9ryp+CKAfnp7Xs/mcd3Cy79eVG2fTkFgUUWKTJ3biO1iSBstvR9Wf00f18K5evFHV5RMFf2ar5lt+TVvg7m0sK+ig9gcvSMnslIqpJmQAhccAKkTe1R7MhgYfFUfxkhXQJSuwhKyGLK5Tj58LxEr1cMtTjpyk8DpMdSqcU6XNne3xKADS0APLtrpR6P0K0tpqZ64fmpfZvE3ZxY+mwhTx1Ofoi4V3k6AfhiHg7ydVJhPxRoygG2Vcr/eJw15ZWIfeCY8fappC+LeZudg72MBSMZjYYPF4TeNADLjRCSbwMoytFr7eePZctM3T7CfKTqsHxaBeWQCrNMlpNOyNOMRdj9jg9ck6kUHu0q90XQXD5xYzsy0XgZ3T20nP+axhQrNat+r5zWAkvKnfRDSVuEoF/fYvpWExp2kJ/Jsh52TZkcL5Bpc79OqM34Mz7hYLaOtXZoS4yTnga7JxwxEI4pnVFKHbXnvXRCHHSQcA2u0U0eWMhylg2HDmw4lJ3A0EzTv7XWOWWmCOQX6EVT94w==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(23010399003)(7416014)(1800799024)(921020)(18002099003)(22082099003)(4143699003)(11063799006)(56012099006)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?aVJPR212OXZLWjJNeVMyVzFkaUxYS1h4OXdpekRxa3FRT29lRHBVUy93UDRq?=
 =?utf-8?B?UUIrZ3R1QTl6RWtOR3NVVnZPVUhoMUpPbFBJKzF6L1hjWllyTHkzRmVuU3Vk?=
 =?utf-8?B?c0Z2T2JGL2ZLQllCZFNsT3VzZE4yWXJnNFF3VGlwTkhybzBxcnFlMjlEbkpa?=
 =?utf-8?B?TWQ1bzNPdXdPREJXOVN0VWtrWU9zS2FnQVJkYWIrQTlmU3FBcmgrSm55dFZn?=
 =?utf-8?B?bVN5eGF4YWpZMmh2OEdzSTMzOUJFV2YzZi9WeFZBTmNxVE9ZVE1qWVJOUzMv?=
 =?utf-8?B?cnh5SzkzWFBwWkkvb24xenZvdmdrNWM2QWMyK2R2TU5HVXRuL09hWEg1d2Rx?=
 =?utf-8?B?VEdLZ0ZWdUU0aE5FS2RyWVNJQlpDQ3R3di9UNDdYZDh5Z1V1dmJuNWFsc3Ry?=
 =?utf-8?B?NTg3b3NGZ1NpOU9YeVFGbVMvR0cwTlVJREE4c3dHMU1hYW5WVnV6M1hYVzdN?=
 =?utf-8?B?TUJETDIyK082R3Y4aUludCt1ZEpZaFYva21vbHIzUGp1YTAxdVltVlpRcmRN?=
 =?utf-8?B?QWNLMk84Q3dMNHk3cTZXaHBsd1E5aU5Ec25lcVhIRHJLRDdlTE8wTkRrTlht?=
 =?utf-8?B?ZkNPS3ZzWldVaWIzT2l2elFPRU5mZzVEMmxuR2svaDJERmZ3Z1dmS3NpZTRJ?=
 =?utf-8?B?R20wSm1vcUlOdEpQdjB4SzdkSm9NWlpxenU0cFk3UmZBb2pYQ2tUb21KTnhi?=
 =?utf-8?B?M0JQNnJZRW93aUlFMEJDbGFBbkd0WFpDcG5YaTBQSEtwRFltQjVpS3VjN2Y2?=
 =?utf-8?B?bjNocDZTMFAxYmFPYldWemdnSTJVTUUyRGc3OUpMdUZtc2F6eThjQ2toZFBW?=
 =?utf-8?B?TC9RalpDSW1yWjFHZ2FuVHdjZW9wTUF2R2RhRUhOVHlkSkFkSXNPWVR4d1ZV?=
 =?utf-8?B?amtZaXRtRUxicTZ0eitNeXFQMXJjYUpKcUhDQ3Fob2FGYU10NUtEZXY5QXFP?=
 =?utf-8?B?bGRkbjAwb24xWDdoaEo2TUhPRnFaWG9nbE4wQy9hQVF2UkpIeXdYcTdKb3Fz?=
 =?utf-8?B?OC94NXNHKzZjK0ZhaGIveVNqQUIvUjB1NFZlNWlWZ0lPWkl5ZkxFcFArdnd3?=
 =?utf-8?B?Rzhpb1YwZy85UGdMYjZDSkdpakd0dUtUQUVMQU4xeU1pNmlEbUR5SWJMcmZ1?=
 =?utf-8?B?QlRQMzNTcGVySzN0N1puOVNub0hXaitSc0lmTzB3c3F1VDZiYWFHcXdXbXRT?=
 =?utf-8?B?SHZBbkNLRW5EeEg5U1RwMFU1UU5NWjB4Tk9WUnFEUzZDOTJLYndweXlFRFVa?=
 =?utf-8?B?ekFRU3NkR1E0MWo4MTg5RVFsdS90RFk2Szk5TzVmMEFKaVIzTkpiYk4zS0Y0?=
 =?utf-8?B?ZENNN2VJZ0dEN011TFVma1VZaVNud3FuOFlTZVZrNU9RTFlSQjEyY0R2dVJS?=
 =?utf-8?B?U0ErSkhKMjlmRzlEOXFZTmhIWjNmT3dPNUNUZzFERDNoUGJjLzBXWjZXc0RW?=
 =?utf-8?B?Z2xQQ0xyOEhSQzRQdUxWcUNOQVZOZHRmOE5oMlJubXJTcmEvdEhFZTBtVmpW?=
 =?utf-8?B?cHJRV1lpNTJjVDg0RUx3WnNycXRqSVVPcXlCZUEvekVER1dCc0lLaFFMVE9J?=
 =?utf-8?B?WEYvOWpBZGZGaWFuN2FWWXlxTlVFdFhPS1JpeDlzMmlTU0k2alVWa3I2MXFS?=
 =?utf-8?B?UzlnUTIwcTlaZUxGS3ZMVzJzcEd3WEdrZW11UkFnRWQxWnFQV2k3SDJWMmgy?=
 =?utf-8?B?OUVvaDhrcDJOcjlUU0tyMnZQSitYQ1VPekNSeFViejNPOVJDc3ZJWGZWd1RX?=
 =?utf-8?B?cWVOYm5VSVpQVEdsekZLMmI3TzZFY3YxZkdtQ3dqZDBrcnNvdVpZRHFEOFJM?=
 =?utf-8?B?b2paS0RFbHltVld5aTVlN1FEMWhkSC8vbERyNitIYUxvRng2VERGaDJEczhi?=
 =?utf-8?B?bXBGTXd4R2p1NUxSZFc4U2lBQzJBMi9ldmVTUmZ5S0RnRVNWY0lUanZuZ3cz?=
 =?utf-8?B?UlZ4bTk4dFpOeUNtSGNrejBwVE1pT2dsTkNWdE40cklFNEVxVjFhNER3ZTNV?=
 =?utf-8?B?aVluaDRlT2R5RlN0MW8vUkxCWmQwZzFkKzRmL2p5UTk3eDRRN3h2RElUUzUz?=
 =?utf-8?B?Rk92Rm9Cam1NMU9NWUc2YVVnb3ZrcE43M21aaEJGZnFLSit5U25nZ2RVL3pz?=
 =?utf-8?B?MnFpWVppdXZTMzYxSWFNUnlVNndtWTJGSXZrMUZnWnlUa1htQ0I1MG5LTjVV?=
 =?utf-8?B?L3FwOWtMeURWTFk0aS94K3h4b25GQlVqQTBJSmFJQlorU2dtZ3I5MEVlWCtV?=
 =?utf-8?B?UWtmVlphWk94L3d4YittVnB1K0kxVUxCTWkrTkQ4bEVsRzR6SHN0VmNnSU5m?=
 =?utf-8?Q?waRhyFvc6p29ecq8+H?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d81ff76a-e855-4187-3f30-08df0dcb6d65
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Sep 2026 17:05:47.6063
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HO0vhGqPVK1FRXiJU28rBCoa0MdO9U051gk616AvPWwx+3B0HfiGgIOuCs/aJzzu
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB8796

On Tue Sep 8, 2026 at 12:04 PM EDT, David Hildenbrand (Arm) wrote:
> On 9/8/26 04:56, Zi Yan wrote:
>> erofs needs to traverse readahead folios in reverse order to achieve
>> maximum performance by
>> 1. reading all folios from readahead_folio();
>> 2. storing the prior folio pointer in folio->private;
>> 3. traverse from the last folio to the first one.
>>=20
>> Add readahead_folio_last() to achieve the same function without using
>> folio->private. __readahead_advance() helper shares readahead_control
>> adjustment code among __readahead_folio(), readahead_folio_last(), and
>> __readahead_batch() by checking new private member, _forward, of
>> readahead_control.
>>=20
>> It prepares for a future commit that replaces PG_private checks with
>> !folio->private checks. After switching the checks, erofs's use of
>> folio->private without bumping folio refcount can cause unexpected
>> outcomes, e.g., in filemap_release_folio(), try_to_free_buffers() become=
s
>> reachable.
>
> Ah, I was just about to ask. So it's really about folios never using
> folio->private manually (without the attach/detach).
>
>>=20
>> No functional change intended.
>>=20
>> Assisted-by: Claude:claude-opus-4-8
>> Assisted-by: Codex:gpt-5
>> Signed-off-by: Zi Yan <ziy@nvidia.com>
>> To: Gao Xiang <xiang@kernel.org>
>> To: Chao Yu <chao@kernel.org>
>> To: "Matthew Wilcox (Oracle)" <willy@infradead.org>
>> To: Jan Kara <jack@suse.cz>
>> Cc: Yue Hu <zbestahu@gmail.com>
>> Cc: Jeffle Xu <jefflexu@linux.alibaba.com>
>> Cc: Sandeep Dhavale <dhavale@google.com>
>> Cc: Hongbo Li <hongbohbli@tencent.com>
>> Cc: Chunhai Guo <guochunhai@vivo.com>
>> Cc: linux-erofs@lists.ozlabs.org
>> Cc: linux-kernel@vger.kernel.org
>> Cc: linux-fsdevel@vger.kernel.org
>> Cc: linux-mm@kvack.org
>> ---
>>  fs/erofs/zdata.c        | 13 +++---------
>>  include/linux/pagemap.h | 56 ++++++++++++++++++++++++++++++++++++++++++=
-------
>>  2 files changed, 51 insertions(+), 18 deletions(-)
>>=20
>> diff --git a/fs/erofs/zdata.c b/fs/erofs/zdata.c
>> index e1e25ca0d1904..78fd7d980e957 100644
>> --- a/fs/erofs/zdata.c
>> +++ b/fs/erofs/zdata.c
>> @@ -1898,21 +1898,14 @@ static void z_erofs_readahead(struct readahead_c=
ontrol *rac)
>>  	struct inode *realinode =3D erofs_real_inode(sharedinode, &need_iput);
>>  	Z_EROFS_DEFINE_FRONTEND(f, realinode, sharedinode, readahead_pos(rac))=
;
>>  	unsigned int nrpages =3D readahead_count(rac);
>> -	struct folio *head =3D NULL, *folio;
>> +	struct folio *folio;
>>  	int err;
>> =20
>>  	trace_erofs_readahead(realinode, readahead_index(rac), nrpages, false)=
;
>>  	z_erofs_pcluster_readmore(&f, rac, true);
>> -	while ((folio =3D readahead_folio(rac))) {
>> -		folio->private =3D head;
>> -		head =3D folio;
>> -	}
>> -
>> -	/* traverse in reverse order for best metadata I/O performance */
>> -	while (head) {
>> -		folio =3D head;
>> -		head =3D folio_get_private(folio);
>> =20
>> +	/* traverse from last to first for best metadata I/O performance */
>> +	while ((folio =3D readahead_folio_last(rac))) {
>
> Intuitively, this should be called readahead_folio_reverse /
> readahead_folio_reversed, thinking of list_for_each_entry_reverse()?
>
> 	list_for_each_entry_reverse - iterate backwards over list of given type.
>
> or maybe readahead_folio_backwards (which matches the forward below)
>
> But I'm not a readahead expert :)

Jan suggested the name[1]. It can be readahead_folio_reverse() if you
prefer it, like Jan said.

[1] https://lore.kernel.org/all/332rknj4vo3cfhvfhhlf6pvg37s3lbrnzbbnv4swa6g=
ctsiu6a@ndotgokvnglc/

>
>>  		err =3D z_erofs_scan_folio(&f, folio, true);
>>  		if (err && err !=3D -EINTR)
>>  			erofs_err(realinode->i_sb, "readahead error at folio %lu @ nid %llu"=
,
>> diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
>> index 939f3a5e973f6..2257df004305e 100644
>> --- a/include/linux/pagemap.h
>> +++ b/include/linux/pagemap.h
>> @@ -1415,6 +1415,7 @@ struct readahead_control {
>>  	bool dropbehind;
>>  	bool _workingset;
>>  	unsigned long _pflags;
>> +	bool _forward;
>>  };
>> =20
>>  #define DEFINE_READAHEAD(ractl, f, r, m, i)				\
>> @@ -1479,18 +1480,25 @@ void page_cache_async_readahead(struct address_s=
pace *mapping,
>>  	page_cache_async_ra(&ractl, folio, req_count);
>>  }
>> =20
>> +static inline void __readahead_advance(struct readahead_control *rac)
>> +{
>> +	if (rac->_forward)
>> +		rac->_index +=3D rac->_batch_count;
>
> No expert, but shouldn't we decrement the _index somewhere in the other c=
ase? Or
> where is that done? A comment might help :)

A readahead folio comes from [_index, _index + _nr_pages), so for
last/reverse/backwards case, the code only needs to decrease _nr_pages.

Will add a comment about this.

--=20
Best Regards,
Yan, Zi


