Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F6AB606A321
	for <linux-erofs@archiver.kernel.org>; Mon, 23 Nov 2026 20:53:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=kmH/7YSv
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4jYJ7k4W0vz2xdb;
	Tue, 24 Nov 2026 07:53:38 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=pass smtp.remote-ip="2a01:111:f403:c10d::3" arc.chain=microsoft.com
ARC-Seal: i=2; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1795467218;
	cv=pass; b=NYeCVB5XO+TtyefyWFctHJcZM9QudVmh01S8MEDZNoUN8Hr1teKzPAaFh1LirJf5mYB8UkA+k56k56FPe/LQWxZu1Iy3tQhBptLJrz4uTXNmfinyO8jogYSluC3Sow7yZa52D13IVEYJ2Tg2zPcC8mVWJeFlgwqLte4ER7S4H5/accDuv7FXs2kklUpQKLgbDJrxxowNGt850rXpQ4K5Z9s2+M6T0sGakVXWMrw2JUOK3MZ1HXegvOf4/HuehC7fjezi5ExAFTJEEm+Tfc+gtQIlLGL6G0itV0eiMSSinkpv8TrVRbrUKTbWHMwNQJic09xeX6UEp5TmhnRltyeGBg==
ARC-Message-Signature: i=2; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1795467218; c=relaxed/relaxed;
	bh=4viZOk3AHXaa44cIKNMKTjk9IW9/qR2YUF4VcbUvTX0=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=aGIJbd3r9Cg2D1LGK5raTQeY7C0rdfbenSV7ktYM0NGwiRMkWLEQGaIubgkoIoUg8m5JEs0EiJBUoC/mKTrwsBr9hOpvsWlVxe6mtgvw0j5v8dWMnM3uAq1MiCeGI1k0Ec8OvERkdOvk0jDTEo2CUhEXF1ToIBDFNSNsDzN6zNhq+BNQmYzLwBqVc/mQCerqw8QQdYurDRGWbt28RBpZonRCSXBpyA1Omb6s9vsjq4vT7jSetDgO8O7XOtLhZngmIipu54P5PJwD4vjkNJhNkwW+3SA9LSf41hhc5mY8TrUz7GxammQmZ5xPovDUrZOgs0T6bfd+mkHzm56txJtzBg==
ARC-Authentication-Results: i=2; lists.ozlabs.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; dkim=pass (2048-bit key; unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=kmH/7YSv; dkim-atps=neutral; spf=pass (client-ip=2a01:111:f403:c10d::3; helo=sn4pr0501cu005.outbound.protection.outlook.com; envelope-from=lkarpinski@nvidia.com; receiver=lists.ozlabs.org) smtp.mailfrom=nvidia.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=kmH/7YSv;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=nvidia.com (client-ip=2a01:111:f403:c10d::3; helo=sn4pr0501cu005.outbound.protection.outlook.com; envelope-from=lkarpinski@nvidia.com; receiver=lists.ozlabs.org)
Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazlp170110003.outbound.protection.outlook.com [IPv6:2a01:111:f403:c10d::3])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange secp256r1 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4jYJ7j5vyqz2xyh
	for <linux-erofs@lists.ozlabs.org>; Tue, 24 Nov 2026 07:53:37 +1100 (AEDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pzlZ98zVhJColBGVl3cG5QVNHDX2t/MWDlzp7LIsBdBGHbRDyFenTiErRXOHy8rkSBh+hmA8IuFHzFFxCW7r0KTGRTFqBVMaatje8730vpNocaT1vDsEfdim2k47OKGUCFIOZbp/yzDWVEH0sHpFT6nX2aoHT+EGkih8ADaqbW6QDP1sn7/nD86J9E4r5Q8a8efE0KS2/ql82Z1ELbZQRbok1RuADQxHuI/T6jtPm40ZS7TSl9qxslGib/E8xawMrYOqKlkF30CWKBiHm2wNxrPmx7d9ziSozyNDM5eT8gUUHxdNIUazHhQ8WZH4Th+NCz2DjiwSLFHLKyhQezmTtg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4viZOk3AHXaa44cIKNMKTjk9IW9/qR2YUF4VcbUvTX0=;
 b=w+qMkiGl/EPNKzXTAFCr52iUe27+3H8enks4IMYb/KlzHUf98tPI+miogmMobwNO/MpFDQMSPCmCjtC/vozt6ba88KOXGbYR/62AvBceJ27ilUhmIRsECpV3jlYuMtgaBjmv8SqRheO0X6Om4jlbo3mADqQEwNslMZxBTgSm2OT2HBeoO6b2Ror7RhvUWdWkEPsZl4C6MIB4d6UuZC4PGjeq8Kq+oXp8MH3R0TAnSxRghOjUkwvy0o44a4KPKg56P+H7lTopnjGfql99NkAoL7PfAHiHGLcQwnuDqnmiCm6sgBCRrhZbPYVPQVL9kJFXAgZq/bODPSdNbkZ+AVCrfQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4viZOk3AHXaa44cIKNMKTjk9IW9/qR2YUF4VcbUvTX0=;
 b=kmH/7YSvrGiw9CBHdEfi7ZJRX9UAEshFhGBMU7T8t1Ip0LX7QzMub/zkNyWbfvMgSmTtbKaUij6Sji3ByIhVPpRItRlr3JWJ4Bhh0OIyqJQ7cCVY9c5WZ9cgwx/VyAys8zbY0IBaR9Rb5iaO5HOLLr/L2ZUrc58Cf7yXOc1gn04iseuNGgTBLFhM1ZfjADh0nrNHkx83tXwIAferP6zp/o5MIHWUPkDWBLmUxhO8kaBO+wYXEMKdrf0fVoh3V4uDZNg6K0bs3bP2o/KQc2o/pgVdY32Se//gDbgEfNSWUw/+x++55opQ+7b7Ef9N3fyNi/s4RJIcY9JTFxL8dm62nw==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from PH0PR12MB999112.namprd12.prod.outlook.com
 (2603:10b6:510:38c::12) by PH8PR12MB7159.namprd12.prod.outlook.com
 (2603:10b6:510:229::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.639.12; Mon, 23 Nov
 2026 20:53:15 +0000
Received: from PH0PR12MB999112.namprd12.prod.outlook.com
 ([fe80::3c97:f642:2ba7:1a5f]) by PH0PR12MB999112.namprd12.prod.outlook.com
 ([fe80::3c97:f642:2ba7:1a5f%6]) with mapi id 15.21.0639.012; Mon, 23 Nov 2026
 20:53:15 +0000
From: Lucas Karpinski <lkarpinski@nvidia.com>
To: linux-erofs@lists.ozlabs.org
Cc: jcalmels@nvidia.com,
	Lucas Karpinski <lkarpinski@nvidia.com>
Subject: [PATCH 1/2] erofs-utils: rebuild: extract compressed extent loading
Date: Mon, 23 Nov 2026 15:52:55 -0500
Message-ID: <20261123-compressed_inodes-v1-1-045d0b3e3f31@nvidia.com>
X-Mailer: git-send-email 2.54.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SA1P222CA0085.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:806:35e::28) To PH0PR12MB999112.namprd12.prod.outlook.com
 (2603:10b6:510:38c::12)
X-Mailing-List: linux-erofs@lists.ozlabs.org
List-Id: <linux-erofs.lists.ozlabs.org>
List-Help: <mailto:linux-erofs+help@lists.ozlabs.org>
List-Owner: <mailto:linux-erofs+owner@lists.ozlabs.org>
List-Post: <mailto:linux-erofs@lists.ozlabs.org>
List-Subscribe: <mailto:linux-erofs+subscribe@lists.ozlabs.org>,
  <mailto:linux-erofs+subscribe-digest@lists.ozlabs.org>,
  <mailto:linux-erofs+subscribe-nomail@lists.ozlabs.org>
Precedence: list
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR12MB999112:EE_|PH8PR12MB7159:EE_
X-MS-Office365-Filtering-Correlation-Id: 21fa9157-4668-4fc1-5411-08df49a3cbc0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|366016|1800799024|376014|261028144727099003|261021135927099003|261021130227099003|261021123027099003|261021121427099003|261021133027099003|261102123227099003|261026121527099003|261026130827099003|261026135527099003|261022113327099003|261022075727099003|261022105027099003|261026140227099003|261022115727099003|5023799004|11063799006|10067099003|56012099006|18002099003|261009223027099003;
X-Microsoft-Antispam-Message-Info:
	CRCblzCRYp7rzmlFn8xiDCt856BljRKmhtluPf5U1mgyglxijf/puXfqjqcK397zZIPpQqxQJDTdu2/q5GmlMRk9b55H/DjgK5dBvQvFkP3FOL1xE+AAnGgdpRFkKJM7eFB2RrvshUq6ZduVSfPouDlwRShRX857I91gc+p+rVZaRiG4Oc+XoEv+TqSspdsWbAnnydlm446SVbEjISDXFxF02+iZeMYcegBPYI2qqcAvQ0tAcIW71gJrLwSw14ajWFvx4SRIXXfOxCbXDM+oGD1+4Rx69SK1bE+5ucV1NvQyKVOmtq/8ALwqvOwoWnCWh5f5/cXVhNJ4G8Gmn8sjWskmOpbu2NF+ZPV12vhpBpYu8qhjmRkiEX9mT2ouDqh+eww86VFswg+2FY1LF1eEQV1A/Z8zBTU/e5nEJJaX0JWrcyY2R6T5UpAEwZXu1qUQnwBU+Fkw06LWtse5cItgv63p/zlaKVa+DGwSjSCOzdrNPO/cbNTHIFJotfeQRgoVvUPhU2ctZuicVieFnNUZLlaKjYniW3bSKt8trl6XbTYNUAllgGeYHX2JGF4rNvz2wXcOIMwlSNhYEruelPkUccywP034NDdeBA10/HrgBaFarWS9unDa7Y1WjMzb7He+8sl5PqNE3A54pN+Tsrmz2FfJ7TNw05g95XYKoQITBBo=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR12MB999112.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(1800799024)(376014)(261028144727099003)(261021135927099003)(261021130227099003)(261021123027099003)(261021121427099003)(261021133027099003)(261102123227099003)(261026121527099003)(261026130827099003)(261026135527099003)(261022113327099003)(261022075727099003)(261022105027099003)(261026140227099003)(261022115727099003)(5023799004)(11063799006)(10067099003)(56012099006)(18002099003)(261009223027099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?bWtMa3RKSTNLWDV1UFN5d2xhOFhocGt1a3BHWmZRcHZkbXl3WEFQcm4vQ05N?=
 =?utf-8?B?cjFjZzU2TU8vZ0x1M1FQZVczbHM0VkJNNEVvUmRpcENCU1NLOHNod3JYTlV6?=
 =?utf-8?B?U3I1RDF2cWJ2cWZrOFZmYTJaMnBnYzIxdDY1T016bWpoa2RqWHV4d0NEaG1x?=
 =?utf-8?B?S0dkUEQwN21BazJMdWR0djMzZ1RYempoVFp1OE9ibmtITVlvRXdTRWFDaDJI?=
 =?utf-8?B?SDdhei81VnRYbVNFdXlkYmIxem0zNlNWcmVHeW1Uc3lLZ3hELzBjT2JIODh1?=
 =?utf-8?B?WFFUS3ZnakRDaHN5eEgvV3A2eTBsVUFjaG5GbFRzcTRZaTZiNnJCdzlwbHRw?=
 =?utf-8?B?SkpIYW8xeTdUb2dhbmpzTDdNZEpKYWNoWjNhNnpPekpXdHVQbTh3Nk50VytH?=
 =?utf-8?B?Y0VvNGZmeG9PMENnT3kvVkExUG54cTVpcGl3UzB4TUFBSE50Z2llZEtnbzUy?=
 =?utf-8?B?Vm4vczhuenJ5TVJYVjY2bDdXUm1TZjFNVUFzTWNHelJNM09jUjVJemFOWEYr?=
 =?utf-8?B?VmZKM2RENlRPQllJdjNmTkRUVXRZVEFTb2dUU0JGNFpDaEh0aHRDRHNiK3dL?=
 =?utf-8?B?NWs2U016YzJqOWY1NmtrYWJaZ2gxV0twd2M3TXBob1ZtVWxvRWlNRVhBc1N6?=
 =?utf-8?B?UlZUV1BpSzB1OE1sUnMzd2laQjBSd0lPWXRzR3JLS3plNjJIRFVBdGJNVVFj?=
 =?utf-8?B?WitJKzBuTDhXVUpMdFBIZEtGdU01bUIrZjZ1UXhqWElEN2o5TlV5bFRTQWRu?=
 =?utf-8?B?MmpRSGV0eUlaK0FsbUUrQ0FyZHdZMDcwWGpGT201SE53cld4TFlxTzJVdWgx?=
 =?utf-8?B?cGJ5Nk1mVkVMR285eXN4VGxOcXA1WFpLUGQ0QTBkUWdOcHg5OE9CNm51RDc1?=
 =?utf-8?B?ZTg2cklGaE5qamQwWU5OWnFDYkc2NDVMZjZnVVAyK3hudVRrKzR0azg1VFls?=
 =?utf-8?B?L1dXTHpiNXlHYTY2bmtGY1VLNk5sRnY3eS9LeDN4TVhFWXRQWXc5SDFLTkk5?=
 =?utf-8?B?dHo3TnM0R01NSW10KzM3SlQ5MUJJcVZ1Ujd1UlF5Rm9EQWJ3cjQwWmhDaXFw?=
 =?utf-8?B?bWhEUk5xSDNKSjFhRmRudTlJOGM3Y2JFVDE5M2J6TndOU3hySmhsS2Y3ekEw?=
 =?utf-8?B?OXZyZXYrV1kvWlFSNXFTKytueU9tdG54YUpsQkl5R0IzU0Z4M0Vkb2M2S2RI?=
 =?utf-8?B?R29TYjF2ZUJDTFM3Y0cxeGlJU3FYU3ovUlZHT3dEenZlSk1LR3lFUURhU2Rx?=
 =?utf-8?B?V1cydUZGMjF6a0lRVVpNN2pUSEd0VmFwV3gxay9veVJBWXNHVXo1QmFuOEtt?=
 =?utf-8?B?STJzNHBId2F4Z3prQTNBOERNU2E0SnIvTFZsWW9ERDA1ZUtSSHIxTWpEYkxH?=
 =?utf-8?B?ZFdKdk05ME91dXlXbzhDSFAwb0o4aFN4Sjk5TWVuamtvT3lsT2hYbVNlbXVK?=
 =?utf-8?B?dE0ySnMwY1RJdHFUZE43SXlpd3F6UnRHbkoxSG9HYzgrdHJmWVNIV1NIL1Vm?=
 =?utf-8?B?Rm8yQm9CWFE5Vjk3c2lvR2hpbGszbEtMT2NpdnpjejJIQ3NleHY1Z0k3RE0x?=
 =?utf-8?B?NGpJa2FLTEVFWEFVTXFnS3dHbDFQNmI3MEpBbU5XNXJZbTRMR1B2VlNMcGFD?=
 =?utf-8?B?czVxYzk0b2EybHdxemkvN2xyLzFNVWh1UG4yZEFUcEY1UW9PVzY0RkNIdU9q?=
 =?utf-8?B?bzBicC8zS3BqWGtjUFBkTXZHTFlLWGl4Z2pxRnphNzBjaUxTUnlzTUtWOUlv?=
 =?utf-8?B?UlRuVFB3VGNua0ZxeG9SbFFMbkk4U3laajFGdDhDdjBzN0VSS0J5Uzg1Yisx?=
 =?utf-8?B?K3hRdDFURjNId3ZCYjV1RGd4UjN6M01vQlpEQmE4QkQ2QnBxWHNpMG1QSXI1?=
 =?utf-8?B?T1NQbXpkc2lNR3JleHgvMzRkdlBCVVhjS1krcUhBbFdtU0tIa1J0c1ZSc2hl?=
 =?utf-8?B?c1lZdEFGc1UvbmM2clBqRHA2UVZtZjVyMDh2RVExU1FOTVhsUUoydGc2UlFB?=
 =?utf-8?B?amxQM01icDlqYWVSam5qQXgrejBLZTd4M1B3SjlYeWdNVUV0dWJxK001NjZR?=
 =?utf-8?B?U1FTTnpIQ0E1MEZoeHhGR2RBLzN5by9ta3RoU3ljTk9rZFYvR2hGVTlJcms3?=
 =?utf-8?B?YndyT1FaWUxqZWlTVkI2NUl1UEdzdHNacFpJZTFHWUFiaVZtMnorU1VOUCtZ?=
 =?utf-8?B?c3dzTitQRXhONU1ENzVMNndUUHgrcWRTbml1NnJGRWFBTHVrcVNnK0RGckMz?=
 =?utf-8?B?dXZSdmR2UFVKWW5OckJUQ2lQYldwbXY3UlVVRW9OdnNlLzgvK2J6ZjZ4Z1N3?=
 =?utf-8?B?VnoyajVsS1FmMUdMVk5LUVY0TUFPTkZJYXMxUkw2UnIwMWoxTXJMdz09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 21fa9157-4668-4fc1-5411-08df49a3cbc0
X-MS-Exchange-CrossTenant-AuthSource: PH0PR12MB999112.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Nov 2026 20:53:15.8320
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bsf5D1+rUFz0DuJR8IHr1PmEBwWsTSphgFBSs5TOkkK/aL3HhaNSI3eN8yf5SEFJ8BgMVVZbgatzkYf+rOBDug==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB7159
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Separate source extent discovery from external-device mapping and
metadata layout. As well as make extent-list ownership explicit for
callers.

Assisted-by: ChatGPT:gpt-6.1-sol
Signed-off-by: Lucas Karpinski <lkarpinski@nvidia.com>
---
 lib/compress.c | 93 ++++++++++++++++++++++++++++++++++++++--------------------
 1 file changed, 61 insertions(+), 32 deletions(-)

diff --git a/lib/compress.c b/lib/compress.c
index e764e44..bd2c6a8 100644
--- a/lib/compress.c
+++ b/lib/compress.c
@@ -2496,19 +2496,16 @@ int z_erofs_compress_exit(struct erofs_sb_info *sbi)
 	return 0;
 }
 
-int z_erofs_rebuild_load_metadata(struct erofs_sb_info *dst_sbi,
-				  struct erofs_inode *inode)
+static int z_erofs_rebuild_load_extents(struct erofs_sb_info *dst_sbi,
+		struct erofs_inode *inode, struct list_head *extents)
 {
 	struct erofs_sb_info *sbi = inode->sbi;
 	struct erofs_map_blocks map = {
 		.buf = __EROFS_BUF_INITIALIZER,
 		.m_la = 0,
 	};
-	struct z_erofs_extent_item *ei, *n;
-	erofs_off_t pend = EROFS_NULL_ADDR;
-	bool consecutive = true;
-	LIST_HEAD(extents);
-	int err, device_id = -1;
+	struct z_erofs_extent_item *ei;
+	int err;
 
 	if (sbi->blkszbits != dst_sbi->blkszbits) {
 		erofs_err("filesystem block size mismatch: %d for image %d, target %d",
@@ -2522,7 +2519,7 @@ int z_erofs_rebuild_load_metadata(struct erofs_sb_info *dst_sbi,
 
 		err = erofs_map_blocks(inode, &map, EROFS_GET_BLOCKS_FIEMAP);
 		if (err)
-			goto err_out;
+			goto out;
 
 		mdev = (struct erofs_map_dev) {
 			.m_deviceid = map.m_deviceid,
@@ -2530,23 +2527,21 @@ int z_erofs_rebuild_load_metadata(struct erofs_sb_info *dst_sbi,
 		};
 		err = erofs_map_dev(sbi, &mdev);
 		if (err)
-			goto err_out;
+			goto out;
 
 		raw = (map.m_algorithmformat >= Z_EROFS_COMPRESSION_MAX);
 
 		ei = malloc(sizeof(*ei));
 		if (!ei) {
 			err = -ENOMEM;
-			goto err_out;
+			goto out;
 		}
 
 		if (map.m_flags & __EROFS_MAP_FRAGMENT) {
-			DBG_BUGON(!(inode->z_advise &
-					Z_EROFS_ADVISE_FRAGMENT_PCLUSTER));
+			erofs_err("fragment-backed files are not supported in rebuilds: %s",
+				  inode->i_srcpath);
 			err = -EOPNOTSUPP;
 			goto err_free_ei;
-//			inode->fragment_size = map.m_llen;
-//			DBG_BUGON(inode->fragmentoff != map.m_pa);
 		} else if (map.m_flags & EROFS_MAP_META) {
 			DBG_BUGON(inode->idata_size != map.m_plen);
 			inode->idata = malloc(inode->idata_size);
@@ -2561,8 +2556,8 @@ int z_erofs_rebuild_load_metadata(struct erofs_sb_info *dst_sbi,
 			ei->e = (struct z_erofs_inmem_extent) {
 				.length = map.m_llen,
 				.plen = erofs_blksiz(sbi),
-				.pstart = (pend != EROFS_NULL_ADDR ? pend : 0),
-				.device_id = inode->dev,	/* FIXME! */
+				.pstart = 0,
+				.device_id = 0,
 				.raw = raw,
 				.inlined = true,
 			};
@@ -2575,16 +2570,11 @@ int z_erofs_rebuild_load_metadata(struct erofs_sb_info *dst_sbi,
 				.length = map.m_llen,
 				.plen = map.m_plen,
 				.pstart = mdev.m_pa,
-				.device_id = inode->dev,	/* FIXME! */
+				.device_id = mdev.m_deviceid,
 				.partial = map.m_flags & EROFS_MAP_PARTIAL_REF,
 				.raw = raw,
 				.inlined = false,
 			};
-			if (pend != EROFS_NULL_ADDR && (pend != ei->e.pstart ||
-						device_id != ei->e.device_id))
-				consecutive = false;
-			pend = ei->e.pstart + ei->e.plen;
-			device_id = ei->e.device_id;
 		}
 
 		if (!raw) {
@@ -2595,23 +2585,62 @@ int z_erofs_rebuild_load_metadata(struct erofs_sb_info *dst_sbi,
 			}
 		}
 		init_list_head(&ei->list);
-		list_add_tail(&ei->list, &extents);
+		list_add_tail(&ei->list, extents);
 		map.m_la += map.m_llen;
 	}
-	inode->z_lclusterbits = sbi->blkszbits;
-	err = z_erofs_prepare_layout(inode, &extents, consecutive, false);
-	if (err)
-		goto err_out;
-	return 0;
+	err = 0;
+	goto out;
 
 err_free_ei:
 	free(ei);
-err_out:
-	free(inode->idata);
-	inode->idata = NULL;
-	list_for_each_entry_safe(ei, n, &extents, list) {
+out:
+	erofs_put_metabuf(&map.buf);
+	return err;
+}
+
+static void z_erofs_rebuild_free_extents(struct list_head *extents)
+{
+	struct z_erofs_extent_item *ei, *n;
+
+	list_for_each_entry_safe(ei, n, extents, list) {
 		list_del(&ei->list);
 		free(ei);
 	}
+}
+
+int z_erofs_rebuild_load_metadata(struct erofs_sb_info *dst_sbi,
+				  struct erofs_inode *inode)
+{
+	struct z_erofs_extent_item *ei;
+	erofs_off_t pend = EROFS_NULL_ADDR;
+	bool consecutive = true;
+	LIST_HEAD(extents);
+	int err, device_id = -1;
+
+	err = z_erofs_rebuild_load_extents(dst_sbi, inode, &extents);
+	if (err)
+		goto out;
+
+	/* Translate source mappings into references to the external image. */
+	list_for_each_entry(ei, &extents, list) {
+		if (ei->e.inlined) {
+			ei->e.pstart = pend != EROFS_NULL_ADDR ? pend : 0;
+		} else {
+			if (pend != EROFS_NULL_ADDR &&
+			    (pend != ei->e.pstart || device_id != ei->e.device_id))
+				consecutive = false;
+			pend = ei->e.pstart + ei->e.plen;
+			device_id = ei->e.device_id;
+		}
+		ei->e.device_id = inode->dev; /* FIXME: remap source devices. */
+	}
+	inode->z_lclusterbits = inode->sbi->blkszbits;
+	err = z_erofs_prepare_layout(inode, &extents, consecutive, false);
+out:
+	if (err) {
+		free(inode->idata);
+		inode->idata = NULL;
+		z_erofs_rebuild_free_extents(&extents);
+	}
 	return err;
 }

-- 
Git-157)

