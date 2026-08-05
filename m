Return-Path: <linux-erofs+bounces-4145-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4C45EC55ABA
	for <linux-erofs@archiver.kernel.org>; Wed,  5 Aug 2026 13:51:45 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hFWzg0M7Wz2ySW;
	Wed, 05 Aug 2026 23:51:43 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=pass smtp.remote-ip="2a01:111:f403:c10d::3" arc.chain=microsoft.com
ARC-Seal: i=2; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1785937902;
	cv=pass; b=niNwT6jOENE4cxT/4Z4QbgO6blBcsxmoa1sF/NPW3+Vabi/cGYliHS9ih3deL2HrPJV7dSrKsZJwXHmT/v36tz/yCz9bJ42HXl+1/YmaMfNu/Iy6mlgtnNgfZjPyuoRFLwX+B4QEFiVEc15LZ/CPvxTLzav7a6F/jVMXVD4emdr2GqQ4wDQ5o4qIJVTQHD1JQMqqJSiR436wZ2MO09g+qlCM3r1o6t/9vHfvtiKREvNscaqa+mqQepMPKUPL4oAVi6FKkBXyizf84AoUu/7yJXcC/EJxALrVYryZ3eAEBMSMbzrzeY2x8fFRu2Fe2z/F7m9A7AlzcC0ywHwz5ZJ8XQ==
ARC-Message-Signature: i=2; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1785937902; c=relaxed/relaxed;
	bh=Nz2Re53Ace72dDj82JFm4uiEJHQKAUBPQr1ZKu/TRxA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=naV/waZ/VTLX4Y2sWcuZJU+hJxFFPsI512BbPv2axrQ4Wl45VVuoTCnWppEShTbAiGVfJg7hKNIfB769aSDYNbKRpy62SsHt7YIBXZ2lKAdZahgnENNplvGvWV9vXKYZSxHZkRrsBiDEZptbHLXVzkHwBP6WQDkBLPr3qtcA6YyEDUyiBaL4G9Z/lgYrvZeO5cGsG6W+T8bTamPzsNF5gJ7Un0OrdIMbLzoMC99Rmx30hCv73bhfcb1tb/8Gvrrduf0146+wWOd97Jas0RkbT+1vvoBu+KSuDIMZJkArnKnipdHHPdJYvKl9aa4czEdrWXBBD7KcvHkhSV0otSLTbA==
ARC-Authentication-Results: i=2; lists.ozlabs.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; dkim=pass (2048-bit key; unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=Ma+sJDkp; dkim-atps=neutral; spf=pass (client-ip=2a01:111:f403:c10d::3; helo=sn4pr0501cu005.outbound.protection.outlook.com; envelope-from=ziy@nvidia.com; receiver=lists.ozlabs.org) smtp.mailfrom=nvidia.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=Ma+sJDkp;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=nvidia.com (client-ip=2a01:111:f403:c10d::3; helo=sn4pr0501cu005.outbound.protection.outlook.com; envelope-from=ziy@nvidia.com; receiver=lists.ozlabs.org)
Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazlp170110003.outbound.protection.outlook.com [IPv6:2a01:111:f403:c10d::3])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange secp256r1 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hFWzd3LGmz2xqM
	for <linux-erofs@lists.ozlabs.org>; Wed, 05 Aug 2026 23:51:40 +1000 (AEST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pxcY2oe0URBFIcWGURtnHS9hpSB4q8VoT4TqVrG6zd5ZlnYBduSX/lultsYI3I6hs1xS6NoXq0U8FFbiCokNMwAlD38IPYBWqlW+aIduU8SUG8HUq2bZc2XkQuvHza7/xXkFgUObc6IbXXnE0hn7EuaU3KmdQFjLwsAtW8O8oNqGMEeY+qT4vLV8amK2gMb4y1ijDJUojfiniM6OYaLFA4cf6bRL5njRyydec5LFgIrJIGSlyLyigQRo060Li0ol5qx9PCVufZA2spKfOG75M8l4ZrKvKGgsTZS4pQoeFf1+5jTKMVsbelg9iUzhYy5oNztW1uUnG1/so2MwhhgjHQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Nz2Re53Ace72dDj82JFm4uiEJHQKAUBPQr1ZKu/TRxA=;
 b=RFNEwlOQiPG5vJVVJDrGVH0hbnEc8LmNkYkCB2ljVzLuLaEqWwGqu676hWHPPJT+jZuKH1BS5X8JyJrqiOWkWRMPk8ud2i+EfCLC8zHqixaqMgjQ6HehmpAGz0gfIVGwnScRzmdfKyvBaEqyuOicnNgIA61QmcrV5r0x9TCJp8+7VtWog6pij2Pn4SYY3/dd4GcV/kFfJQis8RqUlblxC+Vz6WLJGFeEHM18ezRQUIt/qD30jZzIWV556WNBfjQEYNw4HjNCg6ikS42OOLt5ILNAIlyGKSX/aytUMT/PRAi1pRbHQEFryPbJH1COC7ydhZgEMeJOzAPWmPIFinKIhg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Nz2Re53Ace72dDj82JFm4uiEJHQKAUBPQr1ZKu/TRxA=;
 b=Ma+sJDkp7Msz7r8HWsJOFou74uawbE2e62y6ktUJfnF7RGYKAeQMSvpTd8AzX3uMOeK/AoZ4XpzGS1XGZSesckAPjfTIko85p6F981en0qQQHpNGck/mx4wxPWi0fNv/xFQ+yhipZtQo3ZsAKLTNN8V9aXVXwYohy652SSrmDvBlNOjgoj1e+ghJuMF5x4PKnZnKKpj1nPhHqVzkRjSLtW11KW0k5kB+ohh2iejVINlvwfsO+zTmbY1MhT2JzFkJMIHFJCnFggvlSgVkTu7VHFsW/GGLQYCZiqSAtscKfvngIPz3Wf457jhMRa2yB3HgXB39yua70jK10DDnyZKF3Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by PH0PR12MB7958.namprd12.prod.outlook.com (2603:10b6:510:285::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.292.19; Wed, 5 Aug
 2026 13:51:09 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0292.018; Wed, 5 Aug 2026
 13:51:08 +0000
From: Zi Yan <ziy@nvidia.com>
To: Jan Kara <jack@suse.cz>
Cc: David Hildenbrand <david@kernel.org>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Muchun Song <muchun.song@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>,
 Gregory Price <gourry@gourry.net>, Ying Huang <ying.huang@linux.alibaba.com>,
 Alistair Popple <apopple@nvidia.com>, Johannes Weiner <hannes@cmpxchg.org>,
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>,
 Kairui Song <kasong@tencent.com>, <linux-mm@kvack.org>,
 <linux-kernel@vger.kernel.org>, Gao Xiang <xiang@kernel.org>,
 Chao Yu <chao@kernel.org>, Yue Hu <zbestahu@gmail.com>,
 Jeffle Xu <jefflexu@linux.alibaba.com>, Sandeep Dhavale <dhavale@google.com>,
 Hongbo Li <hongbohbli@tencent.com>, Chunhai Guo <guochunhai@vivo.com>,
 <linux-erofs@lists.ozlabs.org>, <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH RFC 07/14] fs/erofs: mm/pagemap: add
 readahead_folio_reverse() to avoid folio->private
Date: Wed, 05 Aug 2026 09:51:06 -0400
X-Mailer: MailMate (3.0r7024)
Message-ID: <4932E65F-E4DA-4040-B673-F470002A8DB5@nvidia.com>
In-Reply-To: <DKGZEK0AQP6R.1RTQEY44OQD65@nvidia.com>
References: <20260731-remove-pg_private-v1-0-142c97ba3562@nvidia.com>
 <20260731-remove-pg_private-v1-7-142c97ba3562@nvidia.com>
 <332rknj4vo3cfhvfhhlf6pvg37s3lbrnzbbnv4swa6gctsiu6a@ndotgokvnglc>
 <DKFGTVA0XD01.OZYNYUOU9FTX@nvidia.com>
 <huzyeqj6a57nbcqc23v6f6rdhkob5552fcwy4mlrsagycqi4rz@ggsapkumc2gq>
 <DKGA508ERSYM.26RBD4HYM1SL8@nvidia.com>
 <2evaxdu6cobpnzzer3y7fsrqvmtmhj7gm3e5buebdaw564igx6@7bs5enipxnpx>
 <DKGBQHP25RE0.3NKUQSDULAQSX@nvidia.com>
 <ivg5x7hjo4tmpd34i6wrd5cp2v56c3vorwru7h6kqxnqlcpte7@lvd7xa4ncwxu>
 <DKGZEK0AQP6R.1RTQEY44OQD65@nvidia.com>
Content-Type: text/plain
X-MS-Reactions: disallow
X-ClientProxiedBy: MN0P222CA0022.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:208:531::29) To IA0PR12MB8374.namprd12.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|PH0PR12MB7958:EE_
X-MS-Office365-Filtering-Correlation-Id: c84537fd-08e5-4985-438a-08def2f89a34
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|23010399003|7416014|366016|6133799003|22082099003|18002099003|5023799004|11063799006|56012099006|10067099003|4143699003;
X-Microsoft-Antispam-Message-Info:
	5pjnZmImJfRXWXvF2cr1QLwqUH6nM8d7EP/wvRzqDkro/j18z4cmb/+04+Wr8YyEKX3MTLOR/+4hHZgwEfJc85yEGgC6EhYCW7KobGBZUaff6EkuHCsvY45zcgdXOBbJtyWFIciMdF5hdrMsEhHdiHIai75riie5TCDaslcKQzxA5AXbZqrKIn1KTJgXmtf14cJTIUx2/jBowku1TtkM//frNYeREfnXzXmdXPLlkuE0IEzEfN9THSqU0gHjgIX+imbRbuxbWuNi4o054+K4n0FNrKDZ1Cg4E4H5gfXarBQBHImCa0vAYcBvYJsz0eiN3CtHmxncKTDNHFX4nKdwail2u5TZvZEYtE/yoqansMB7ASXSlrbAYe2aRElyzvFhiM1Aco9rzD0C5bFkKRIbNflZ08zkQub56pSdiER8mQi+JWqgXqWVSARQpIypFEaKqFi/gdPqjvMcVTZNWghW6f0VIbqKboDKQamh2h6L89Pfsd0MDOPrmDdHMG2D6FcNF+3yuf2g2TIPdlrq0uUrz3wioYW+Der1C2KWDN/q8ZvixX9fEcftTN3hTbbfizDEyifuE8HRFr8AdVBVYgsI2A79XAVbe8Avbv9Cs4oJ46/mR508rOj9Y50fUS6eDVUU4VzUEYQ0ELN+IO6hmiQA3hcynYjCjB9uZEM45luiCSA=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(23010399003)(7416014)(366016)(6133799003)(22082099003)(18002099003)(5023799004)(11063799006)(56012099006)(10067099003)(4143699003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?CNnuixnr9cG6Sf9ppwtGeN6b+dR8+Qh62mZ8kCNCmqMF6TzHU/1tytzCYm4r?=
 =?us-ascii?Q?DPWSiMHux4oYgpdREnL/gLwFTx/rikEkf6hPQ+PzP4hXK5RCmozsx+NDkF6P?=
 =?us-ascii?Q?ixj4+lGoGqcDdBFeSqR+v15i5AzJHBgBze/8kofxoSUUNIQHJi6DbaNEitYi?=
 =?us-ascii?Q?hjD1S3pQrlTinVkrWxfLtEhdoG+3Cc8nAB5PQBpnCxSXYH2uUuViVXm5KAZP?=
 =?us-ascii?Q?jx58uIZzDRnRpfBk6z6MG+3GwmARYX7bPgZhoTsythcx5Pst/ALpQ9p7Sjw1?=
 =?us-ascii?Q?XbQ4MoQjuNyG/BkQKRByOSO5BgpHCF7v94IZNiMOGj6OJ3CHuF1N3oYQgEfo?=
 =?us-ascii?Q?Wein+c/CoPOUqPOYSK2h6N/DrfrknkQlu65cVw/PnT6wFvj0iTZ6fsD4Yffe?=
 =?us-ascii?Q?BQtUDXTK8fbSWsBdCddxzd+U4hgAkNT0GkfwZluv+aPBHFbUiEpqw84JW2Hk?=
 =?us-ascii?Q?pC4Imu4shsB/1PJY028wS2MmEImCGV+Qq8Rv8lc4IR+uNbwVWQawo4yd7dVD?=
 =?us-ascii?Q?I+QwZ9XFgqma9TawnGGDivpWNo9OCmW5DQoT3xC8rpDWCG4ZjDuzNm0Gm/m8?=
 =?us-ascii?Q?uP9u9kYmklIaWI/+BRngm+bv6dXr/fKWdY3nBkiAW8GcZZPglrJl59VZj8EG?=
 =?us-ascii?Q?Pia0s8ENJaGJRzOStpI6R/3PF34E4/IuI3WfL3tzmW71E/Ep5V1nK3LQ2XSk?=
 =?us-ascii?Q?PCq1YeNAQp4C72chvuG/UJ0lig+U1joZmcf4w9U6S/hHZTWz/aeU9wz8bRki?=
 =?us-ascii?Q?HXK5au9hTlzUpqK2eBsMmRwsxxM6/Nn0jK9nJRzh59TGgyBavEuVCREk/lme?=
 =?us-ascii?Q?g7vsqiF5iGADBMrVC5HmpWketcjcUfwd0KKH+1l93QbE6prhQalFAf0AE+Fe?=
 =?us-ascii?Q?zHw8gWXdwMEVVnoakDeaCdXTVvzsYfiBa/qhh2HXuKRvvCYG7+RuDe5bw0TA?=
 =?us-ascii?Q?XKY54M0jQKzx7dbh1uqI4hDu23+iwW4mJNDpGb5Db2mvXncQEtGB82Cv1PH4?=
 =?us-ascii?Q?SC1AYuqB/M1oNWQnbU08vyt4FHRb/iTgxmqsPVO7PRv+/RT9wMinQqLW5127?=
 =?us-ascii?Q?DPIKoz7ejTlE1frlbGa1o+gyZhLBCmNyPd6sQvysUrfbFnfpcoXEdWSRF/38?=
 =?us-ascii?Q?dHBxnSpsbME+cV4dtu5wUqDbkWwCODvaO8u3YfaIvwPW2qBEm/JiwrW5yQxh?=
 =?us-ascii?Q?GmjOt5AYK9Gipw/5Z8v04Z3zz8jV8Bs6G9UI5e5rWwosMvBs/7I3Mhnv8fFw?=
 =?us-ascii?Q?xJJ50GrNSc5XWq+8um3NkHA946g3GMh/+XAEYzrZoU5DsU8Tns8rpRH7zehY?=
 =?us-ascii?Q?RGAbmh/ChURki/2hHkD08ImaS63aOkB7Js1zV4846u9h92etMKArHHcBtsiT?=
 =?us-ascii?Q?tbfFoN+QAU4Yf6iM30/ZrhB7PzevVdnCdTb/z6TWpM0UqyiREc6sJXMiB0EM?=
 =?us-ascii?Q?x5pIwdfIff7ZiNH+5gfBads5xkr9JG3wwjIsEvYxzmEgejsafXPoRdbEkSNM?=
 =?us-ascii?Q?rHIkQbE81cghsoGBRvUFtKjTGYULVXMN6+JpPzyh6bF+pc+tkVi9gznznHWq?=
 =?us-ascii?Q?JsgwfGaDOKl+jvgKEZk/WwCaOPKc1j4re3mBI4qpRYRxdxeKqAIagWCQyEOw?=
 =?us-ascii?Q?GySGXpCq5099UQzNwYZpaCyC3sQ/JJPf2bAD0vcifQzw/qsZd6y/jUC/pol7?=
 =?us-ascii?Q?K1Mj+uMsqeF8lzHovk3wVVf1tkXU1vJaZkw1LS8SxBBB42zSCIv6rB92ppAd?=
 =?us-ascii?Q?zinmoSaWYg=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c84537fd-08e5-4985-438a-08def2f89a34
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Aug 2026 13:51:08.8038
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JBvopJ33uPwVVpgJnNot70wWd1LFSWsTlfxTOzTUA7dUFBEi5YYp7K2sTjQK7/wJ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB7958

On 5 Aug 2026, at 7:42, Zi Yan wrote:

> On Wed Aug 5, 2026 at 5:25 AM EDT, Jan Kara wrote:
>> On Tue 04-08-26 13:09:46, Zi Yan wrote:
>>> On Tue Aug 4, 2026 at 1:04 PM EDT, Jan Kara wrote:
>>>> On Tue 04-08-26 11:54:41, Zi Yan wrote:
>>>>> On Tue Aug 4, 2026 at 5:32 AM EDT, Jan Kara wrote:
>>>>>> On Mon 03-08-26 12:56:36, Zi Yan wrote:
>>>>>>> On Mon Aug 3, 2026 at 5:54 AM EDT, Jan Kara wrote:
>>>>>>>> On Fri 31-07-26 22:13:30, Zi Yan wrote:
>>>>>>>>> erofs needs to traverse readahead folios in reverse order to achieve
>>>>>>>>> maximum performance by
>>>>>>>>> 1. reading all folios from readahead_folio();
>>>>>>>>> 2. storing the prior folio pointer in folio->private;
>>>>>>>>> 3. traverse from the last folio to the first one.
>>>>>>>>>
>>>>>>>>> Add readahead_folio_reverse() to achieve the same function without using
>>>>>>>>> folio->private.
>>>>>>>>>
>>>>>>>>> It prepares for a future commit that replaces PG_private checks with
>>>>>>>>> !folio->private checks. After switching the checks, erofs's use of
>>>>>>>>> folio->private without bumping folio refcount can cause unexpected
>>>>>>>>> outcomes, e.g., in filemap_release_folio(), try_to_free_buffers() becomes
>>>>>>>>> reachable.
>>>>>
>>>>> <snip>
>>>>>
>>>>>>>
>>>>>>> The below is what I come up with. I did not add a bool to
>>>>>>> readahead_control, since I think that is the decision of caller of
>>>>>>> __readahead_advance(). But let me know if you disagree.
>>>>>>
>>>>>> The reason why I wanted bool in readahead_control is that if some code
>>>>>> ends up mixing readahead_folio() with readahead_folio_last() things will
>>>>>> get confused (because __readahead_advance() really wants to skip the batch
>>>>>> returned from the *previous* call to readahead_folio[_last]()). With the
>>>>>> bool in rac, even mixed use will properly advance the state of the
>>>>>> readahead_control. I don't think mixed use is very realistic (at this
>>>>>> point at least) so I'm ok with leaving that for later if you don't like it.
>>>>>
>>>>> Got it. I am trying to figure out your mental model of how the mix of
>>>>> readahead_folio() and readahead_folio_last() works with the bool inside
>>>>> ractl. By looking at readahead_folio_last() code, it is almost the same
>>>>> as readahead_folio() with __readahead_folio() inlined
>>>>> (__readahead_folio() is only used by readahead_folio(), so the inline
>>>>> can happen without any issue). As a result, we can get rid of
>>>>> readahead_folio_last(), add set_readahead_direction() to set the
>>>>> embedded bool read_from_head, and use readahead_folio() only. This
>>>>> removes redundant code in readahead_folio_last(). One thing I am not
>>>>> certain is whether we want to
>>>>>
>>>>> 1. use set_readahead_direction() explicit and warn readahead_folio() if
>>>>> read_from_head is not initialized, or
>>>>>
>>>>> 2. set read_from_head to true by default, so that only erofs needs to
>>>>> call set_readahead_direction() to change read_from_head.
>>>>>
>>>>> The former is less confusing but changes how readahead_folio() works;
>>>>> the latter is simpler but implicit read_from_head state might confuse
>>>>> people at some point.
>>>>
>>>> My idea was: readahead_folio() will call __readahead_advance() and then set
>>>> rac->forward = true. readahead_folio_last() will call __readahead_advance()
>>>> and set rac->forward = false. __readahead_advance() advances from beginning
>>>> / end based on rac->_forward value.
>>>
>>> Got it. I can do that. Just to be clear, it should be that
>>> readahead_folio() first sets rac->forward = true, then calls
>>> __readahead_advance(), since __readahead_advance() advances based on
>>> rac->forward, right? readahead_folio_last() as well.
>>
>> No. I wrote "and then set" which means after and that is what I really
>> wanted to say. You still don't seem to be understanding the logic of handling
>> the _batch_count. _batch_count is the length of the returned batch.
>> __readahead_advance() updates _index and _nr_pages to remove the folios
>> returned in the last batch from the range. So _forward needs to contain
>> whether the last returned batch was taken from the beginning or the end of
>> the range and __readahead_advance() uses it to update current range
>> accordingly (before we go and return the next batch). We cannot clobber
>> _forward before calling __readahead_advance(). I hope things are clearer
>> now.
>
> Got it. Sorry I made some assumption instead of asking my question, so I
> misinterpret your words. My question is who sets the initial value of
> _forward? So that __readahead_advance() can update _index and _nr_pages
> correctly at the first time __readahead_folio() is called?
>
> __readahead_folio() does:
>
> 1. update _nr_pages and _index,
> 2. return NULL if _nr_pages is 0 and set _batch_count to 0,
> 3. return folio using xa_load and set _batch_count to folio_nr_pages().
>
> after the change:
>
> 1. call __readahead_advance() to update _index, _nr_pages, and
> _batch_count based on _forward,
> 2. update _forward to true, since it is __readahead_folio()
> 3. return NULL or folio based on _nr_pages.
>
> Then the first time __readahead_folio() is called, who sets _forward to
> make 1 work correctly?

Never mind. Codex answered this:

The first-call initialization is not a problem: DEFINE_READAHEAD()
zero-initializes omitted fields, and _batch_count starts as zero,
so the first advance is a no-op.

I will fix my patch. Thanks.

Best Regards,
Yan, Zi

