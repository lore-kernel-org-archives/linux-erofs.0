Return-Path: <linux-erofs+bounces-4140-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8D5F3C2A09B
	for <linux-erofs@archiver.kernel.org>; Wed,  5 Aug 2026 02:41:54 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hFF6n0Qzxz2xnp;
	Wed, 05 Aug 2026 12:41:53 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=pass smtp.remote-ip="2a01:111:f403:c100::f" arc.chain=microsoft.com
ARC-Seal: i=2; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1785897712;
	cv=pass; b=d30U0nDdTRxf6NaaJOuTlkb+7lfk+2387Ye3ILGGqalYv4naX+sm8mnQFDLgGV4D9np4HO1rkhuwxjBncwz2Lt8yERFRALkkFIPTpcNtg0Epo0+FkEkSKXRISdXYx6BQsVxoolPzU+H8oB4s2GC4AC2dHm8FDvb9PxfloRkQH6/eiUd+roa3+hcSlyIgwuCdl/RlNjZWg3BZ+hWyVzataaTki2t3URDsrY/7EObdv2fym/HQ6oDXtLDjMIwKlryUpVi5he9mQGsugUbf9BbUt8/zA0jV1fpdtkaUHq6lmuCh3iwWhxa8FCflOgY5mM9ZTYpbZKYP+duGRjzbo3Oqpw==
ARC-Message-Signature: i=2; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1785897712; c=relaxed/relaxed;
	bh=xwCNTh453IS/SaqHkjmJHPYmF+RRv7mWis38Sjru8bc=;
	h=Content-Type:Date:Message-Id:From:Subject:Cc:To:References:
	 In-Reply-To:MIME-Version; b=HrlW3bV51dqzG+x41Nkd3NXzUaEfkMpr8y+GIODsJ69sdyLsPWYPhHwXRzl/2zXrcn7iRtdtqXI4xVTzBsxh+Nve1q7vWRzq2YimPj1SLM6mmQIrj8HoQ+PIPYTWJk0Rwfbtw5bNDbavbwkwqboqN3kp5dHnR91mNlCFY6akO0uULCHXOOw/aHh14WsKesdkj5LcYp9y45jlPBrmsEHOfq81+qC1ogbHq0rM8sRFFUJsVgH5ckos84R0cpjM6sra9Sx+xzt9nFzGJMJdgnHziFxOm85CCTfsTSRLbyxUDL72KBoU4JgHxssrwTGP0aQpbRpeVKXlgo/mY4g1I00gDA==
ARC-Authentication-Results: i=2; lists.ozlabs.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; dkim=pass (2048-bit key; unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=CzKwh5/h; dkim-atps=neutral; spf=pass (client-ip=2a01:111:f403:c100::f; helo=bl2pr02cu003.outbound.protection.outlook.com; envelope-from=ziy@nvidia.com; receiver=lists.ozlabs.org) smtp.mailfrom=nvidia.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=CzKwh5/h;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=nvidia.com (client-ip=2a01:111:f403:c100::f; helo=bl2pr02cu003.outbound.protection.outlook.com; envelope-from=ziy@nvidia.com; receiver=lists.ozlabs.org)
Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazlp17011000f.outbound.protection.outlook.com [IPv6:2a01:111:f403:c100::f])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange secp256r1 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hFF6l6WFZz2xlv
	for <linux-erofs@lists.ozlabs.org>; Wed, 05 Aug 2026 12:41:51 +1000 (AEST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ifvEHSkRoTi8ekbo0jw2mDK/Guoi15tXrsQOJYflZC5ipCZyBiOGL4oQmJn35IgCKzM/DahZAZ70SuMJv11+lkYeOyfNVXO0WpRFBFRdrTDTSVfR1c3RFMa16Vo8wkZNh5Q7wOLjtHfgrfVQA7VF3aUTRqFLcnJySuZBRY2riS+bbxnko3PbE2r6Ac5LgF/3WjjFN7wz/E/JyHWjrZ8N3o2r+xpBFjy4dDilmHIQTAkTfkdSYlp6HuhRarcBo1u2oqzllFcenxjoPHX8Bra3FEaB/YIt7PeRp7dVNWspb0cWXF8QrBB2mNleoiI3u+54z9PmKb60PQniDP7c5Gy1ZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xwCNTh453IS/SaqHkjmJHPYmF+RRv7mWis38Sjru8bc=;
 b=WI09142RNjBQHO2FARpWnqImR6NtS/h1Yh4FYtCRFfnET30eg6ppS6kLcXE2im1y9v39+8UHnlgJ0OnHc/Ts+yfT1Q6932cSxYh91WD0+bXKM3O3SN3sEaOjc5sYXQientZldDQ4cIXj5ovzHnqZab7iDZevprvU0GkDlj1fMsa9MxkRqbbzyf/MSAu60Gn5y8tDnIEoUxJypsOD2/XZqqqQ8vjaXQQzYnohfHmL+PiJPYAstAmlW8vBCSAxqSxmoSmNz72q/Xw+5THk27jzBs4pApxe0asEwa4QZ7rmQTakuYDMHcdYDoiMCRhM62Yk4PGLxf+3HEMOrYCVEEqkow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xwCNTh453IS/SaqHkjmJHPYmF+RRv7mWis38Sjru8bc=;
 b=CzKwh5/hm1/b+bFBrjAXn3u4vwRTzNc9WrK710QxYV7SpjIwudsly83dC0QJzfPVLdMyvcWLNpSCz7XW9VgGHX/RLqfDbfLqzGEGGx7GbFoH7RZ3VDKR3EHSF+XmwVd5OO0ojhSbD+gGK1gDQCOWC5EDmd12Wl/67wfKS5D9JxqQ7N/nDUfjvuLlbnuVnnqNE0BiYtsywoMlFszAUoiL19sKBT/qCTAbEAqzCnjwk6qp9Ry1pxSo0ebiBucqCkDrmlhE72O6bZdG8W68+S3CIbZKKbQzTPYATT4qrIGVO9pbCuHu/0CNMP6/vwlehiP33O0wY9SmaS9AsCs+6XwrUA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by DS2PR12MB9775.namprd12.prod.outlook.com (2603:10b6:8:2bb::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.270.18; Wed, 5 Aug
 2026 02:41:24 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0292.013; Wed, 5 Aug 2026
 02:41:24 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Tue, 04 Aug 2026 22:41:23 -0400
Message-Id: <DKGNW5NWY73G.2E0EH28C37POP@nvidia.com>
From: "Zi Yan" <ziy@nvidia.com>
Subject: Re: [PATCH RFC 08/14] fs/erofs: use folio_attach/detach_private()
 instead of direct assignment
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
 <linux-kernel@vger.kernel.org>, "Chao Yu" <chao@kernel.org>, "Yue Hu"
 <zbestahu@gmail.com>, "Jeffle Xu" <jefflexu@linux.alibaba.com>, "Sandeep
 Dhavale" <dhavale@google.com>, "Hongbo Li" <hongbohbli@tencent.com>,
 "Chunhai Guo" <guochunhai@vivo.com>, <linux-erofs@lists.ozlabs.org>
To: "Gao Xiang" <xiang@kernel.org>
X-Mailer: aerc 0.21.0
References: <20260731-remove-pg_private-v1-0-142c97ba3562@nvidia.com>
 <20260731-remove-pg_private-v1-8-142c97ba3562@nvidia.com>
 <anEnBSAOQE8LyKdI@XiangdeMacBook-Pro.local>
In-Reply-To: <anEnBSAOQE8LyKdI@XiangdeMacBook-Pro.local>
X-ClientProxiedBy: MN2PR08CA0004.namprd08.prod.outlook.com
 (2603:10b6:208:239::9) To IA0PR12MB8374.namprd12.prod.outlook.com
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
X-MS-Office365-Filtering-Correlation-Id: 7aa43771-5e17-4325-5ebf-08def29b0ab1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|23010399003|376014|7416014|22082099003|18002099003|4143699003|56012099006|11063799006|5023799004|10067099003;
X-Microsoft-Antispam-Message-Info:
	Cc72W0amdGdVx0BOjoL2JdTCTAZrI9JVQZ4yX8f1Oldd68HYrW9N3Ce90X2cz/FmQQVbdrrVOojbSSbCVjVTPm8ACGAsnoFZgi/wiTXP1vqF5w15eIr3KnY85aj+KK31WCReJCbcuhJ1hB87A92yEtZbCNIifNA10QBFFkP4FpKV8OA8B2EPggOBBLx7gTcPO065uc07qNWbv6MIt16seWdZXsVBOMwr12Dnkw1CrWI4oedZ0oal9jUAfK1SX+cX/y+N0iqkTJbQlzfN5QJRa7KflDfwcDY2mSASWBrdEryQcZpPGoymfxSJu9awgXNv9RXvgk5pzs91oVAPt5ANogGwQg4H0HVW0vdZe2r7s9dYmVOQvD08GOuyGNxnkAfsB3epAPXMwcOYqljpg6hfZC4zCxBZ2jbTZ+S6gcifobDEYF5O3g/iDi9LTb7RHJDrpJwFCpFh48SYRsI1Ik2x+vFUYbZHKrts+v4qTt+fYtu6/Hjc0ea8BSBJ7PjK2Nf1zgXiNsLN4n0R4hN+sP0N2rmJ1FaF5ilEjPFystLoZVmT07sQlwSV7wCIqlD9la8TqUWUUQPIcewqQdWeMjAYDidBDro8Ml8yrgOdt37sqGVTuNpO3zITIj167F+9QvYRZB/ZnYAD/OhiIH4KGvLQmeQZOH7KWj/jjwcmm5MGon4=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(23010399003)(376014)(7416014)(22082099003)(18002099003)(4143699003)(56012099006)(11063799006)(5023799004)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?NVEzNy9CN3FvaVhLYUZYNklUcjNTMXhEMlc3ekZMZDRDYTQvZ0FGZG81eU5U?=
 =?utf-8?B?Y0hqc21hWU0vbDl1VXNXR1hEMm9LeFFxa0s5MU9WeGg3blFSNU5UbEZvTFRD?=
 =?utf-8?B?blpJWGRHM1E5S2V0SS91YU9qWVBtQUVpL1l3WHFtSVVMQnJLczZubzQ5Z3J2?=
 =?utf-8?B?VHVCS0QxWVdaSzMzTXR1YmFYdld2MnNpU240RTRIYXVsWEw2bEpBVUIxemtV?=
 =?utf-8?B?Q2w1Y1c3OCtwVXB1UDJTOGhNbE5EZ0k0Nllxa3M2d1RxVi9sKytVaGZOZzRE?=
 =?utf-8?B?RnY4TUlKNlRPR0dZdDUvejVSNlQxdmM0T3hBNkM2L0huenJIcEYzeHNxZWRx?=
 =?utf-8?B?cXhVQWRwM1RET0x2NER0bDBEeENSUDAyN3FlMk5oemNkRDZRaTJJUGgxV2M5?=
 =?utf-8?B?QkVmR2YrOFB5a1RaSFRUejZNUFBvOTl0UG5aZ1F4WDd0Rk0wUmtmOWdmbWtS?=
 =?utf-8?B?NTgwNTB0YlFRb0JJY0pNQlZweW9CYUZHZm1aZjRTMkRob013RkRzNWlEQTdB?=
 =?utf-8?B?SnBPSGw1RGZSVXNrN3NRdC9rSVl6U0d3ZDdVMlZDalFpaExnT0s1bzZabWw4?=
 =?utf-8?B?UDMxMzEyRVlXZW5vSmdLUXZqTFlvcnVRMmxCb1krNmhSMEdPRTVDcThrdXk5?=
 =?utf-8?B?TkZCRTFnSGZYdTB6dTZLYWVpOTFYL1lla3M3Y3ljWER6NGtCaTNLNnkvU29m?=
 =?utf-8?B?em05Y1p3eHBQMjdVd2xlNm9GaTExeVZkelJkemErcGpPU1ZGWmFhN3pCYlo4?=
 =?utf-8?B?R1pjYit6R3ZwSENTWWh5ZFh0Qzd0NXY4Z3FVVUdlMjJ4c2oycTN4cUpiRlpE?=
 =?utf-8?B?dnpmS2lpdmN3V3FsSXM5T0RBOUJJbk5ZZDdXbnBTOUVCdHEvUUhpNWpWOVRk?=
 =?utf-8?B?UEwrWWpIVU51VXZtWTBZdGZKL1ZISFI1aUZRUS9xMHEybVU4bzBHODRRRWVB?=
 =?utf-8?B?WUxvRkJyN210S2ZhcElsOFI1YlZrQ1dhWG5VS2I0T1J6MFdXcEpVUzVReno5?=
 =?utf-8?B?VzdBSGU2YnVzMFl1TkI0Z28rS2Ewc3YyZnFyS3hKVm1WZmRTYStRME5YS2FO?=
 =?utf-8?B?bUN6YkErRFRwelRiSU1ENUtkMGpFVjl6OVZKdnFheE1YQXRROHNnUDFuZVc2?=
 =?utf-8?B?VnI4K2FyQmVqR2pWeFo2cFFGWDF3SWswMWVOMzd1S1hWZnBQc1k4aDF0VGV3?=
 =?utf-8?B?d3NYQXNSTzl0c1ViOE1WRHYxeE5GdWFGRHhYYVozSm1JOE8wZlFBbUJ1aGxB?=
 =?utf-8?B?YXBZSUtNQ002Zkl1UmE2b0hLeEZkV3FQRGF3WjFHTW1lZ21KTFZQcnhYejJP?=
 =?utf-8?B?V1FiWTVMSFd4c081SHhqL2VHZ3BjV3lEQlFiTWYreWpySUFCdy8wMkxNYzdB?=
 =?utf-8?B?Z2FPdnNYbUZhemRmRXlOZExVaEhLbFNoYkxiQWlqUWtyN01VVUYrNkhPaHFB?=
 =?utf-8?B?NkI3V3UvZjNJZVBCZzNiRVI2TkF5TUZlZUtmRU1zaHJMQzY5NFZqa1Jmd2Ux?=
 =?utf-8?B?bDNueEk5OTUrVVEwYjdtOHp1NGE0Q3AwY041V0NocmdNcXFtc3kySlJPNlZk?=
 =?utf-8?B?TWczQVptbDQ2RzNBeGthRCtWMXdGcHpkKzY3YnNwajhXN21PdnZjaENvY1Vt?=
 =?utf-8?B?U1FSQzFTcXVEaVYxQkQ0a1BydjExTWxySHVkZlFDdGkvTjh3NGQ2QkdYOVNx?=
 =?utf-8?B?VVlxZnRVb28yLzFCOU9JcXozOGdsVDNnN1c2MTRDYnQ2Yks0MXBaS0VDTEph?=
 =?utf-8?B?OUVSZnhON3JhTFZyNWsva3FzcEs5TGQ3dDRQRE1NajNWODFIdVBFak5iRzM3?=
 =?utf-8?B?ZDV1RWZHSWhLYnVkcmxTMFZER1ZPU0FmTzJvMExNZG54M3VPUjZoRDBhei9z?=
 =?utf-8?B?TkpkM0hoUnBzV3ZyNUc2N3BZNlo1MGZmeVF4SGpFZ0NxRXhpamd2cmJ2OVQy?=
 =?utf-8?B?eS8zZEdZSTFPbGpZSzQ0aEt1YWhydENGZlV3YkN0TjZud0xrS2tDTXkyNXdX?=
 =?utf-8?B?UkJqUFovZm1RUFNKMUN2di92UlZDaXMrMWlEVVdOTWlNY1JaWDFqaFVpL1Ru?=
 =?utf-8?B?NnpNOWhDNTVjRGYzWnRqTEQ2TkttWi9oS0JDWklGWk5XdGRCL21pUndqVTEv?=
 =?utf-8?B?K3ZhVlBkY1NjUDgzeXpnSm8xNmRkYVp5OXB4bFh5RGUxYmRpUm05NGVZL3NV?=
 =?utf-8?B?TVhyU09PeFdTR0oydWJWUmVOVEZ2NlJKZDNZT3FPSmtRQkJpNDZxbGtXcGxD?=
 =?utf-8?B?UjkrenZyTGVoblRIR00rMm5ZKzIwZE5VUzgwaVJsV1V6c1RjdXdMY0RaL2hn?=
 =?utf-8?Q?JwuCdcVwX1EquCrVki?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7aa43771-5e17-4325-5ebf-08def29b0ab1
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Aug 2026 02:41:24.7763
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hLhB59mVjCyqYyFs7SPVVTL23qqIZe3SaDrNr8dNSZsJFv1nrgSKJqQJWn5Osr3m
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS2PR12MB9775

On Mon Aug 3, 2026 at 7:40 PM EDT, Gao Xiang wrote:
> Hi Zi,
>
> On Fri, Jul 31, 2026 at 10:13:31PM -0400, Zi Yan wrote:
>> erofs_onelinefolio_init/split/end() use folio->private without setting
>> PG_private or increase folio refcount and it works. But after PG_private=
 is
>> replaced by checking folio->private in a future commit, it can break
>> folio_expected_ref_count(), since the folio has private data without
>> elevated refcount. Change it now.
>>=20
>> It prepares for a future commit that removes PG_private.
>>=20
>> No funtional change intended.
>>=20
>> Assisted-by: Claude:claude-opus-4-8
>> Assisted-by: Codex:gpt-5
>> Signed-off-by: Zi Yan <ziy@nvidia.com>
>> To: Gao Xiang <xiang@kernel.org>
>> To: Chao Yu <chao@kernel.org>
>> Cc: Yue Hu <zbestahu@gmail.com>
>> Cc: Jeffle Xu <jefflexu@linux.alibaba.com>
>> Cc: Sandeep Dhavale <dhavale@google.com>
>> Cc: Hongbo Li <hongbohbli@tencent.com>
>> Cc: Chunhai Guo <guochunhai@vivo.com>
>> Cc: linux-erofs@lists.ozlabs.org
>> Cc: linux-kernel@vger.kernel.org
>
> It looks fine as long as PG_private flag will be removed in the
> follow-up patches:
>

Hi Gao,

Sashiko spot an issue in this patch[1]. Basically, ->private can be 0 if
I/O completes without any issue or being dirty and it causes
folio_detach_private() not to folio_put(). My fix is to add a bias, 1,
to the counter, so that ->private stays non NULL throughout online folio
process. The revised patch is below. Let me know your thoughts. Thanks.

[1] https://sashiko.dev/#/patchset/20260731-remove-pg_private-v1-0-142c97ba=
3562%40nvidia.com?part=3D8

From d8fadd13fee03e72c03a718af65ed41927ccbcca Mon Sep 17 00:00:00 2001
From: Zi Yan <ziy@nvidia.com>
Date: Thu, 30 Jul 2026 11:04:00 -0400
Subject: [PATCH] erofs: use folio_attach/detach_private() instead of direct
 assignment

erofs_onlinefolio_init/split/end() use folio->private without setting
PG_private or increasing folio refcount and it works. But after PG_private
is replaced by checking folio->private in a future commit, it can break
folio_expected_ref_count(), since the folio has private data without
elevated refcount. Change them to use folio_attach/detach_private().

Furthermore, because folio->private is used to store in-flight I/O counter
and the counter reaches 0 when all I/O completes successfully without error
or being dirty, ->private=3D0 causes folio_detach_private() to not drop the
elevated folio refcount. Solve this issue by using bias=3D1 for the counter=
,
so that ->private stays non NULL throughout every attach-to-detach process.
Add a macro EROFS_ONLINEFOLIO_BIAS=3D1. While at it, fix the comment about
->private bit layout and add EROFS_ONLINEFOLIO_COUNT_MASK.

It prepares for a future commit that removes PG_private.

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
 fs/erofs/data.c | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/fs/erofs/data.c b/fs/erofs/data.c
index 9aa48c8d67d12..81e9dab247e0f 100644
--- a/fs/erofs/data.c
+++ b/fs/erofs/data.c
@@ -251,19 +251,23 @@ int erofs_map_dev(struct super_block *sb, struct erof=
s_map_dev *map)
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
=20
 void erofs_onlinefolio_init(struct folio *folio)
 {
 	union {
 		atomic_t o;
 		void *v;
-	} u =3D { .o =3D ATOMIC_INIT(1) };
+	} u =3D { .o =3D ATOMIC_INIT(1 + EROFS_ONLINEFOLIO_BIAS) };
=20
-	folio->private =3D u.v;	/* valid only if file-backed folio is locked */
+	/* valid only if file-backed folio is locked */
+	folio_attach_private(folio, u.v);
 }
=20
 void erofs_onlinefolio_split(struct folio *folio)
@@ -277,14 +281,14 @@ void erofs_onlinefolio_end(struct folio *folio, int e=
rr, bool dirty)
=20
 	do {
 		orig =3D atomic_read((atomic_t *)&folio->private);
-		DBG_BUGON(orig <=3D 0);
+		DBG_BUGON((orig & EROFS_ONLINEFOLIO_COUNT_MASK) <=3D EROFS_ONLINEFOLIO_B=
IAS);
 		v =3D dirty << EROFS_ONLINEFOLIO_DIRTY;
 		v |=3D (orig - 1) | (!!err << EROFS_ONLINEFOLIO_EIO);
 	} while (atomic_cmpxchg((atomic_t *)&folio->private, orig, v) !=3D orig);
=20
-	if (v & (BIT(EROFS_ONLINEFOLIO_DIRTY) - 1))
+	if ((v & EROFS_ONLINEFOLIO_COUNT_MASK) !=3D EROFS_ONLINEFOLIO_BIAS)
 		return;
-	folio->private =3D 0;
+	folio_detach_private(folio);
 	if (v & BIT(EROFS_ONLINEFOLIO_DIRTY))
 		flush_dcache_folio(folio);
 	folio_end_read(folio, !(v & BIT(EROFS_ONLINEFOLIO_EIO)));
--=20
2.53.0




--=20
Best Regards,
Yan, Zi


