Return-Path: <linux-erofs+bounces-4551-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2646EC88E64
	for <linux-erofs@archiver.kernel.org>; Mon, 14 Sep 2026 02:24:53 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hjprg6rnkz2xns;
	Mon, 14 Sep 2026 12:24:51 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=pass smtp.remote-ip="2a01:111:f403:c112::5" arc.chain=microsoft.com
ARC-Seal: i=2; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1789352691;
	cv=pass; b=oGW7vAfyukrNxuPF5WpxfVwFOWim9V/xsiv6LC8c8vuTfpJezdAMY9uJrH4f+DmHu/0rW5EzSMyfuJINxi2VyM5okyZzClaqvd+ro4pstxrzOE7Qa2epK7WXlJB1e/IO2AiHUeGjhg81sSUYSExOa25qJzzYelJ4UsmaZubBn7UCYVpSdavki4LhwxZgAqWfoOrwqaxzPOcLlXZKO0jSxKNbLJXAix6LKDdJA/XQg7m2P1mDZakotLItwZ5uhC8lvJNeAmrLDEDNzBT+u6dtdM5bh+kuhg0b6/bJGXx7xxmJfKuQmjKTrpJy5bUVZ5j6fdTaZQGOcgJYDRAR2Gyb9A==
ARC-Message-Signature: i=2; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1789352691; c=relaxed/relaxed;
	bh=xVv9wxA/M8gednBaRD1HGziV0QOHZmyR40hMEBPFV00=;
	h=From:Date:Subject:Content-Type:Message-Id:References:In-Reply-To:
	 To:Cc:MIME-Version; b=OsUhbq9Yq77u75wDjMpz+eyxHyvVeWdhaZ77zJUFhwqhy4Kqn1s6Yw+JzKLUZ+fVw+rg4J9C3NeJ7+IhShc1hs6JAeV5moS8STPfShTsevYmyuBZMlwLcQQgXISL+Mj1l+ycdB+Ss6MbVgHsnmAIAOMFI9LEncj/n0nKMPowMMO7Hpic8qbjgDSagrLc5XEz59F5M0MTjgUxw/qnv0riszmKdHx9v7Wc8VBppziYiJmxqu761eZrJ6+3xXh7/FueLqJiKX02IxW04T6eVx76MvCOIFWmXMyMdGzMYGoqfAaWWrx+dizE6NKJvrRYGk4VFm2knHGncJExMbe9AQvfCg==
ARC-Authentication-Results: i=2; lists.ozlabs.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; dkim=pass (2048-bit key; unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=RgvAuRWW; dkim-atps=neutral; spf=pass (client-ip=2a01:111:f403:c112::5; helo=cy7pr03cu001.outbound.protection.outlook.com; envelope-from=ziy@nvidia.com; receiver=lists.ozlabs.org) smtp.mailfrom=nvidia.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=RgvAuRWW;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=nvidia.com (client-ip=2a01:111:f403:c112::5; helo=cy7pr03cu001.outbound.protection.outlook.com; envelope-from=ziy@nvidia.com; receiver=lists.ozlabs.org)
Received: from CY7PR03CU001.outbound.protection.outlook.com (mail-westcentralusazlp170100005.outbound.protection.outlook.com [IPv6:2a01:111:f403:c112::5])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange secp256r1 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hjprd1MqTz2xft
	for <linux-erofs@lists.ozlabs.org>; Mon, 14 Sep 2026 12:24:48 +1000 (AEST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Y4kNAGv4P3i+CApyTQFH7HQYZ/0S5yKKDL7+7LHgyTc2ImMHs+hXb/DdRacxnfUzr6+3SvPCDAjStWCD1IxO5GSgUr6guKG0PWScrt6AwuiVhQUx32E3bs6GY38G2W2vUUH0I6DmbKw8j8KdMaNG4eUrBneusFlj/uPLvBK73RHE2xe+lPk8DJhGAlcRRMuznerXY/ceq5ukJqd334rlMVZF3ZC3l8PUe1AgECIbUGp/XqIDU4dJdUbHvGPG3lcI5F9xYA2A9tXreQYCl3UL39dTy2QeUVyRVRnimOLS1dIOQGkWTqxRNwdXuwQodLf9nTWepKE45havsTQNlSNgPw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xVv9wxA/M8gednBaRD1HGziV0QOHZmyR40hMEBPFV00=;
 b=NGaWiExv13SDw2gFL80ipk6P7zhnllXvouDvJnK5nZ9b6ThRITZIamFPdTssIuwV9jvZMrnzDWWgHjLgCI8v75MVenI3RbMA+KoVsxF1b/aifaGTR8dOBMA2aHF6s4K0/e0LutIK7bjmnY7jtnfYqaPrZJQjSNqVszStZcJRvhihe4O1L13fVDk7O/jH8DYudqaYPApebxKI/N6Z6Vsr5DA0QBZWjpypOf4XePRbKlL6y/GOsq3vFrPFmg2jECmwf5hFIA6mnhVgTz5vVOrBRt1tQjAmMi69zo68Z7rv8QgMA2xN3yhIo9Swk/GLOluFf1tQdWKAmP+EkPj1TCd+6g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xVv9wxA/M8gednBaRD1HGziV0QOHZmyR40hMEBPFV00=;
 b=RgvAuRWWtK+Iul9CpKWeIbk4iCO/+jzOcVeVD35wiMJC6x4aqkDtDG2CqtJvmIqVG+zpby6vdVLpL2yJH7Xt4Il9/jC1Odp1h4BCEh4BK0eA5yyQ0J8+nF9nZBssYF3qDY6DcqdYmutwrJvCViXhPFGo8s7ubErvs2WZfMgZj2yl383Bo99twu1vhcWoaUMqiYCj7Hp5rNSIA22pH7H3/4/lh23w0insMwD8NtfaP98O56054X0W7SsZ2iniDBxMScEUwW9JOFBEg/nVYSUF63sqhD161N8tYIir3/eKqUzUuUstQKYL2QxcizTdaCMV5eV7yVnW0caR7e5FRfIGwg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by DS0PR12MB6486.namprd12.prod.outlook.com (2603:10b6:8:c5::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.12; Mon, 14 Sep
 2026 02:24:21 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0406.007; Mon, 14 Sep 2026
 02:24:21 +0000
From: Zi Yan <ziy@nvidia.com>
Date: Sun, 13 Sep 2026 22:24:06 -0400
Subject: [PATCH v4 08/16] erofs: mm/pagemap: add readahead_folio_last() to
 avoid folio->private
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260913-remove-pg_private-v4-8-848550f7574e@nvidia.com>
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
 Chao Yu <chao@kernel.org>, Jan Kara <jack@suse.cz>, 
 Yue Hu <zbestahu@gmail.com>, Jeffle Xu <jefflexu@linux.alibaba.com>, 
 Sandeep Dhavale <dhavale@google.com>, Hongbo Li <hongbohbli@tencent.com>, 
 Chunhai Guo <guochunhai@vivo.com>, linux-erofs@lists.ozlabs.org, 
 linux-fsdevel@vger.kernel.org
X-Mailer: b4 0.16.0
X-ClientProxiedBy: BLAP220CA0017.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:208:32c::22) To IA0PR12MB8374.namprd12.prod.outlook.com
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
X-MS-Office365-Filtering-Correlation-Id: 3b0577a3-d1f6-4fec-74dd-08df1207493d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|7416014|366016|376014|1800799024|22082099003|18002099003|921020|10067099003|56012099006|11063799006;
X-Microsoft-Antispam-Message-Info:
	LXmdquqRakWVVHTOu2q8VGwFGarhn7aOPvcmKTPzfQvdT6LHGfpqTjDAhKu8hDyUMVCLw7ccnH5iHZOCbSeWr5mccNZsYQl8jFwrbHIp47FRTIJN2W0kGM+SuitZTp3dpWVQZ6m0fqD9CW9kwZooH9lJUNU9SIu3s9kpmIjt6+cSrqm9v5B2aDZMViFfK2KrT6PQJQhpg6B6A6RFIUKiD6LSISyfAG/cKJ2kGXzvF5RhWbwZTjQjr07glltdDaDSwf0vHzfImAHODImyLnqOy+JRfAi8FtfdySN+7UD6Hau08xAFc0wmP+pjsvzKDFG0o79N3XOiyLuHc7HLN3Hqip+C2cZGFumihKswebONkGb/u0lbY7GhkSGLWaz7k2bUUDHqiPijt8bdoy8lVNtMJzzAVXD24bHM/aDAyJ17PEwnfz2+vR5FBP/LxyxjBNUCr+J1EMXWiXHkHPw9wVAO21TFofCE11w2Nzlwbex6G+jjybU097UIoUO4ZdeCSbDswGVuHS9TOYUvPEXfLV3tMIfI7t/GslP48mDMvBgxNjxgCminpR0swe520zA5aKb87DBqB6YQ8UweLDrokz3cDD7mIjMzYO2n6/7+ziLalArSNt1jHx1yOzNphI5MWQkIFvnVNg7q2tqFbNUiKzMijwuZEN1+FJxteD80sDHfYwju5TuKN42SU+sM6/ZGALPJ2xs0g6mbWNNtlbnZiZvGVw==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(7416014)(366016)(376014)(1800799024)(22082099003)(18002099003)(921020)(10067099003)(56012099006)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Q3AvWVV3bU1kVDZXQUFtRHR6YzBodEw3WkRpb011M3hySk0wNVFpZXpGdllS?=
 =?utf-8?B?eXNTbHkyRUdja0hDVGJFMmpQMFBiNWxmdU92b1g4aDA1VGZxRXE3ejlhSy9C?=
 =?utf-8?B?R3JxNHJJbzZNdHVUK2FnVURpUjhvZUZjcklhcUFPYXQ1ZCtRTlpDdGNna29y?=
 =?utf-8?B?em9zbkZKbTd0eWpHZjZMR1UvVjgreS9HeUJQbEFsQUFsK0ZjWGpCWU13UnBa?=
 =?utf-8?B?ci9sdVVVdzBhSHViUkZkaWEzdUJ0dVdZWEVaM3NBZUVDMjN6SWhlekVFMmpI?=
 =?utf-8?B?VVlJSy9GNmptdGRJRUNRYjZuUW9ZKzBBZVRONzFYUFIxaEU3dGxCZU1TT29s?=
 =?utf-8?B?eU1kSkl2SEpCc0dNVDh2WndwK1JwYmNpUU9jVkkwanVjL3hyR3QvUE12QzJv?=
 =?utf-8?B?Uk9zdjExaTJFWVo1TlFlbzlqL0JIajQyRWU2V0EzejBCZWZtQ2J0bEFVWVJq?=
 =?utf-8?B?MnR0cWxuYVphOG4wUmNLMzNNaXBWeEszZ0NnSXFXcUNhUFByVkp0eGdxclhH?=
 =?utf-8?B?SzBTUHNDdmIwaEd5ZmllMzBiYVdxdjlFNG5TUnpyYUE1Y1lQdlhlbWtqeVFU?=
 =?utf-8?B?UUFvWWQxN1VFNW9hOVF0S3dqZ3J4SGZuUlNQVUlYbVFVS1JMWm4zeVF1NGRI?=
 =?utf-8?B?dms1VVFGd3pGekdROGd5dS9lU1pJS0Qrek84clhNZFZzVUNRbmR6Ulg1Nnh5?=
 =?utf-8?B?ZHJWZUMzY2lHZ2xMSzVIRFgwMksxODVZLzlCaGZWWW1xejRlb3VDbTNYbTJY?=
 =?utf-8?B?WU5rVlQxZU9nZEVZSjB6NXNIbmxmSUYrV2pXOC9KbEsxVXh2UDg2MmZROHJY?=
 =?utf-8?B?bjIySlR5Tk5UNVFXcU9qQmRBME9nZCtMQVJGVVNUYmdhNVJ2MWFmSERLM3dM?=
 =?utf-8?B?akEvME1vTU5laUZIWXVPWFljYmZCTG53cTVEMHZ4SFdtQWFuOTJCaldsZlR2?=
 =?utf-8?B?V2FhclpzVDcrVkhYeXFMMmV0WGZTaHJTZjcwU0xId2xIbnppNFp3SU9PLzk2?=
 =?utf-8?B?K1p2TkxmbEFSOVg3L0ZlOElNYW45cXVXZUp6ZU8zcmE0dWlPUUtyTlU3ZVRF?=
 =?utf-8?B?eklzRlFBa3dHQzFWNUQ4ZkVRKzh0L2U5Tno1VkJmU2NrT3dBejFHNm55clIv?=
 =?utf-8?B?L25ZYmJsSlZ1OVU3UjV4dFgvM1l5VkNDcnJxUjNUc2VCSFFVVGFTSzZnNjBp?=
 =?utf-8?B?RnBtQVRBTFl4R3l2Q0VEczRQR2M0ckdMakx4UjFmVHNRUXJZTStQUjBZSSs3?=
 =?utf-8?B?UkVxKy80N1NJR2R0cWNSZmczWUg1NUsvbE9zc0U3ZGRSVFpYUUVpTzRXb2x1?=
 =?utf-8?B?NmZvanl3U3pjZHRIYS9DcEZsTXN2TXhEV3NHSGhtbEN2NHY4Y0kvWnIzK09a?=
 =?utf-8?B?SWxGTEFVc2xKazI3TjdnLzBDazEyODdTK2VIM3VjZFNLbXVUN2crY2l5bURS?=
 =?utf-8?B?emdzakhWZUdvMGthTUF2NkVsVC9LUTltSjA1a280ZFJIMnBxKzlhWDZXT3RX?=
 =?utf-8?B?VElBUEgwUFg4RVN3SHJFVnFkbE4yOTkwbXhpSEFnUnZiOVRqclB6MFR1Ylh6?=
 =?utf-8?B?SzNSZjhYTUcwMUdoUFBZc28vblZtaEpSZ2VjRU1yanljRG9pWTFsQnd6Zjgr?=
 =?utf-8?B?d2RhbFJNUW1vRHIxZFQzTzFmNDJxUzY5QUl0b1g0eUF6QWc3d0RVcUpLZlNV?=
 =?utf-8?B?TXFCMXUzZG1RUGV1dHdBSzI1NHhybzJYODYvaWZwUnpwTExyRUhkZFZBRHUr?=
 =?utf-8?B?TzlTb2cycmMzbndHWENVbzdPeXozcTdoZ09WVzYzVkVBWGJkUmtqbTRReXpT?=
 =?utf-8?B?N2ptY1cwc01DeGNyazUrTDd6Q1J6OHpnNW5hakZlOHBoSVQzWE9xcTYxS3pl?=
 =?utf-8?B?UzRjeUVveUw3RmhVSjRyM0JzOWFySHFoU2R6dmYyUGMwT1NOUElHOFV4a1dW?=
 =?utf-8?B?bXc5RXppbjFyaExhWjVTQ0Z2emVUc2Voa2xMN0lzVHR3L0dIOHBFY056Q2gv?=
 =?utf-8?B?d1h3VlJvZXAxQVUrNXVIeWloV3NET0NyUlFhbGZ5OHdRVmNJUU5RSS9MTnRV?=
 =?utf-8?B?aWlFcGl6OEhmM3pPTldtdWw3TVlCUlpFRTlDYlpZUHJHekM4ZE0xenpHMm03?=
 =?utf-8?B?amJGMUp0ZjhBRnNLUXNQSVZBN3B3TGZYQnVybDFQNXBUODV2S1MwM3RFZXl3?=
 =?utf-8?B?NkowbVVQSkc3RUdPcmUrem43TkRJVDNUK2czakl3M1djNkg5ajRPSm1mRGdq?=
 =?utf-8?B?TzJXSUVMNHE3YlM3RVFIVjQ5VE1rVGhNZjI2QXlpYXVkZXFzRHlnM2xmeVda?=
 =?utf-8?Q?5yMth6Dn8KZg4D5Oj0?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3b0577a3-d1f6-4fec-74dd-08df1207493d
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Sep 2026 02:24:21.3702
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tLclKViQFBsmsz6LxOhuc56yLjJcbwjEednZGh54FN2MeVoXdjx9VioF0SS84/WJ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB6486

erofs needs to traverse readahead folios in reverse order to achieve
maximum performance by
1. reading all folios from readahead_folio();
2. storing the prior folio pointer in folio->private;
3. traverse from the last folio to the first one.

Add readahead_folio_last() to achieve the same function without using
folio->private. __readahead_advance() helper shares readahead_control
adjustment code among __readahead_folio(), readahead_folio_last(), and
__readahead_batch() by checking new private member, _forward, of
readahead_control.

It prepares for a future commit that replaces PG_private checks with
!folio->private checks. After switching the checks, erofs's use of
folio->private without bumping folio refcount can cause unexpected
outcomes, e.g., in filemap_release_folio(), try_to_free_buffers() becomes
reachable.

No functional change intended.

Assisted-by: LLM
To: Gao Xiang <xiang@kernel.org>
To: Chao Yu <chao@kernel.org>
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>
To: Jan Kara <jack@suse.cz>
Cc: Yue Hu <zbestahu@gmail.com>
Cc: Jeffle Xu <jefflexu@linux.alibaba.com>
Cc: Sandeep Dhavale <dhavale@google.com>
Cc: Hongbo Li <hongbohbli@tencent.com>
Cc: Chunhai Guo <guochunhai@vivo.com>
Cc: linux-erofs@lists.ozlabs.org
Cc: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org
Cc: linux-mm@kvack.org
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Zi Yan <ziy@nvidia.com>
---
 fs/erofs/zdata.c        | 13 +++--------
 include/linux/pagemap.h | 60 ++++++++++++++++++++++++++++++++++++++++++-------
 2 files changed, 55 insertions(+), 18 deletions(-)

diff --git a/fs/erofs/zdata.c b/fs/erofs/zdata.c
index e1e25ca0d1904..78fd7d980e957 100644
--- a/fs/erofs/zdata.c
+++ b/fs/erofs/zdata.c
@@ -1898,21 +1898,14 @@ static void z_erofs_readahead(struct readahead_control *rac)
 	struct inode *realinode = erofs_real_inode(sharedinode, &need_iput);
 	Z_EROFS_DEFINE_FRONTEND(f, realinode, sharedinode, readahead_pos(rac));
 	unsigned int nrpages = readahead_count(rac);
-	struct folio *head = NULL, *folio;
+	struct folio *folio;
 	int err;
 
 	trace_erofs_readahead(realinode, readahead_index(rac), nrpages, false);
 	z_erofs_pcluster_readmore(&f, rac, true);
-	while ((folio = readahead_folio(rac))) {
-		folio->private = head;
-		head = folio;
-	}
-
-	/* traverse in reverse order for best metadata I/O performance */
-	while (head) {
-		folio = head;
-		head = folio_get_private(folio);
 
+	/* traverse from last to first for best metadata I/O performance */
+	while ((folio = readahead_folio_last(rac))) {
 		err = z_erofs_scan_folio(&f, folio, true);
 		if (err && err != -EINTR)
 			erofs_err(realinode->i_sb, "readahead error at folio %lu @ nid %llu",
diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
index 939f3a5e973f6..1e3462357aaa4 100644
--- a/include/linux/pagemap.h
+++ b/include/linux/pagemap.h
@@ -1415,6 +1415,7 @@ struct readahead_control {
 	bool dropbehind;
 	bool _workingset;
 	unsigned long _pflags;
+	bool _forward;
 };
 
 #define DEFINE_READAHEAD(ractl, f, r, m, i)				\
@@ -1479,18 +1480,29 @@ void page_cache_async_readahead(struct address_space *mapping,
 	page_cache_async_ra(&ractl, folio, req_count);
 }
 
+/*
+ * Adjust readahead_control to ensure next folio comes from
+ * [_index, _index + _nr_pages) afterwards and reset _batch_count.
+ */
+static inline void __readahead_advance(struct readahead_control *rac)
+{
+	if (rac->_forward)
+		rac->_index += rac->_batch_count;
+
+	rac->_nr_pages -= rac->_batch_count;
+	rac->_batch_count = 0;
+}
+
 static inline struct folio *__readahead_folio(struct readahead_control *ractl)
 {
 	struct folio *folio;
 
 	BUG_ON(ractl->_batch_count > ractl->_nr_pages);
-	ractl->_nr_pages -= ractl->_batch_count;
-	ractl->_index += ractl->_batch_count;
+	__readahead_advance(ractl);
+	ractl->_forward = true;
 
-	if (!ractl->_nr_pages) {
-		ractl->_batch_count = 0;
+	if (!ractl->_nr_pages)
 		return NULL;
-	}
 
 	folio = xa_load(&ractl->mapping->i_pages, ractl->_index);
 	VM_BUG_ON_FOLIO(!folio_test_locked(folio), folio);
@@ -1516,6 +1528,39 @@ static inline struct folio *readahead_folio(struct readahead_control *ractl)
 	return folio;
 }
 
+/**
+ * readahead_folio_last - Get the next folio to read, from the tail.
+ * @ractl: The current readahead request.
+ *
+ * Like readahead_folio(), but walks the range back-to-front. The folio is
+ * returned locked with its refcount dropped; the caller unlocks it once I/O
+ * completes. Compound folios are returned once, at their head index.
+ *
+ * Context: The folio is locked.
+ * Return: A pointer to the next folio, or %NULL when done.
+ */
+static inline struct folio *readahead_folio_last(struct readahead_control *ractl)
+{
+	struct folio *folio;
+
+	/* Drop the previously returned batch from the remaining range. */
+	__readahead_advance(ractl);
+	ractl->_forward = false;
+
+	if (!ractl->_nr_pages)
+		return NULL;
+
+	/* xa_load() follows sibling entries, so a tail index returns the head */
+	folio = xa_load(&ractl->mapping->i_pages,
+			ractl->_index + ractl->_nr_pages - 1);
+	VM_WARN_ON_ONCE_FOLIO(!folio_test_locked(folio), folio);
+
+	ractl->_batch_count = folio_nr_pages(folio);
+
+	folio_put(folio);
+	return folio;
+}
+
 static inline unsigned int __readahead_batch(struct readahead_control *rac,
 		struct page **array, unsigned int array_sz)
 {
@@ -1524,9 +1569,8 @@ static inline unsigned int __readahead_batch(struct readahead_control *rac,
 	struct folio *folio;
 
 	BUG_ON(rac->_batch_count > rac->_nr_pages);
-	rac->_nr_pages -= rac->_batch_count;
-	rac->_index += rac->_batch_count;
-	rac->_batch_count = 0;
+	__readahead_advance(rac);
+	rac->_forward = true;
 
 	xas_set(&xas, rac->_index);
 	rcu_read_lock();

-- 
2.53.0


