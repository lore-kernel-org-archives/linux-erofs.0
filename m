Return-Path: <linux-erofs+bounces-4290-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 664F5C5DF97
	for <linux-erofs@archiver.kernel.org>; Sun, 23 Aug 2026 13:31:32 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hSZh22KjZz2xrL;
	Sun, 23 Aug 2026 23:31:30 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=fail smtp.remote-ip=198.175.65.20
ARC-Seal: i=2; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1787491890;
	cv=fail; b=d+LR3qmIihehxL71MoxAaX+7Ci8lJtue/NX0PD/FsprVRbkjAe3QYyxrNc6A7tfXgdI2bYsRMv+xUwBORTq5gGiBAzgkjQ5b5wjFl/GMWhkG6agAWjkAFbj4PYz+SPozOjCGDSUl3DcGxGL2mWf8ySSO3xS9uDa4YGpXp5ekgSGC2UgGFQ+UEsFzmUF8JuTfo3gTqrlBnvI6dvnTF1YGDZti847o4x+hyZYFI5O6D49LeRy5+Vn6zZaM+FUp0XpNH+peI4RFeZ5azbweeiftAeyeGJ9NarRQP7hFRl2se2+Wo4ChAMg/K3aqV/etGOpzh6LQfhUqCy+boyLuVGmSqw==
ARC-Message-Signature: i=2; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1787491890; c=relaxed/relaxed;
	bh=PXzfEU6A1PjwCMi+eIRiAQGvxb0mC+2NyMNj7Bt9vqY=;
	h=Date:From:To:CC:Subject:Message-ID:Content-Type:
	 Content-Disposition:MIME-Version; b=f1ICdKJnD386rebHrKeLhQWEktACVe2i+wPCyYgpHW7qZED/548Q9OVA+ADNDQXM7k9xteAcyB8+XqMcQjwWK0QEfsSEUBXf9ZqB1JynU10jXtBXOdh6OvlbEwXDhhRZiC1moQ2pLV8K3dhMTWfqWQUm/vDjqqCsdkZL2qH4Z2ZUysNmGvFUkWn1p6jMAsA4VS2vNWV27U/u6OXSZQVT0ZHatyCISFuZXwISdQucKbDSK5TBQmQKWBZe1DY9HM4CTRvBbLF7L/3RcJGYplE0KtfT32bDXBW92DiOFEYU+2nXm/98wbLcRinA6ZyUPNN8lB0KNJ5NpeTPLsyUadAL4g==
ARC-Authentication-Results: i=2; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=intel.com; dkim=pass (2048-bit key; unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=cMgScxHo; dkim-atps=neutral; spf=pass (client-ip=198.175.65.20; helo=mgamail.intel.com; envelope-from=lkp@intel.com; receiver=lists.ozlabs.org) smtp.mailfrom=intel.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=cMgScxHo;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=intel.com (client-ip=198.175.65.20; helo=mgamail.intel.com; envelope-from=lkp@intel.com; receiver=lists.ozlabs.org)
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hSZgx5wHnz2xnQ
	for <linux-erofs@lists.ozlabs.org>; Sun, 23 Aug 2026 23:31:22 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1787491886; x=1819027886;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=nHCH+q7NM2jNr83OpHmoz8eZkNzdNEYIoHDU1KUoKXw=;
  b=cMgScxHo++FxMpG6szLmvPe8N5ai5BmdXxr9SNZtBJ9Phyhz06Nb6xGF
   VIuBDlvXyd4z/y354Ko3RNHNeAPU+hdBKUNuCnRxQ/8mdp0icoNSuell0
   U1c0BHC/SUSa8+InwShBIrxIWHY5Fg6f6hBlWJDz1UXIyBmbQm97Nj4bJ
   KNryEKO9DGqM7Xu1FauSNjlp1qy5OQy5NqZJB9KmRRngH5cJiw7z52vCF
   vP/CQag6iGv8/XlyDfDT+HhOPkztuCgRQYEFm6koZbWMaZfiCOIHL1IZX
   18y0Zp9AXYi+hqLFiPd/WWPtu3lCjuspQCA9hqRch1wboi4H27RDG+p27
   Q==;
X-CSE-ConnectionGUID: oqwqE++0RuuAD5HqcOOQFQ==
X-CSE-MsgGUID: M7l3tqZpQayZEPfl08uk2Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11883"; a="87727980"
X-IronPort-AV: E=Sophos;i="6.25,238,1779174000"; 
   d="scan'208";a="87727980"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Aug 2026 06:31:16 -0700
X-CSE-ConnectionGUID: qWgsd6hPQqqdqcey2ugr4w==
X-CSE-MsgGUID: hcrmIDnlTnmaM0G0zQEl5Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,238,1779174000"; 
   d="scan'208";a="264142947"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa008.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Aug 2026 06:31:14 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Sun, 23 Aug 2026 06:31:12 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45 via Frontend Transport; Sun, 23 Aug 2026 06:31:12 -0700
Received: from CY7PR03CU001.outbound.protection.outlook.com (40.93.198.29) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Sun, 23 Aug 2026 06:31:11 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=K/t/KoWpUVxCWdfQ+vnlzbjqZL79kuxpIFjlP5SG8pCLgLgZakPYiNwaWFqwK0gkMbVwRwzBRf7ajJ/5WmgiJk86L/ua0u6B+n/V3PYXf/eBjClnPg2s7xPDU/BysF2KQwFVu6CMDnsK7jj3PU6nPpXlB9IHSQRWDy1NsItJFCHp1N7wW4NNjqg6FDRgeYpTxCuDjneh4p+q2THfWkXZaRSp9lkndUYOkUluoJV5yZc/WsLegk3uuQFDAX9ZD5uDK4inYbtP/cgIUOytfnwGv3mpDEc/Num3SvVYRq3ab2QBPWrDj8Ancz7VxY9NM3aj6oAmU2Wsi742XUVpdpZ37w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PXzfEU6A1PjwCMi+eIRiAQGvxb0mC+2NyMNj7Bt9vqY=;
 b=uYQHmXDJfkTO2nAlm5/XWyjPYKBc+D9DfzA2Hh4FDVIVl1zcJcbYnSUoL4R7nD1lNlHRyUrzpTV7JsvlDBJwxrXkWJNjTjhNbRJauPIpeXBGE526U4GBR/8bGI6NA/we14UU4gOn9aPDXTM/h/2wQtJnDsQgaQ9abXfzJIAHnC3Y8aXHAaka0vnS8+MwboJR5fgOs9zwTzbIvyHc/XtpDAEf/AqZr0wJvaTSmEWJSU07ZPXtnlsLCyesoR2hPcp2JsO+1UKXyxDWWUvB9DE4MUiNjjhlAzIOcl+VRaN0xxyfuzAVjLGDEZYh3ZayfN6HZu1heGzlPTF4umecunbpZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ0PR11MB5214.namprd11.prod.outlook.com (2603:10b6:a03:2df::22)
 by BN9PR11MB5241.namprd11.prod.outlook.com (2603:10b6:408:132::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.339.12; Sun, 23 Aug
 2026 13:31:04 +0000
Received: from SJ0PR11MB5214.namprd11.prod.outlook.com
 ([fe80::5926:3836:4212:8640]) by SJ0PR11MB5214.namprd11.prod.outlook.com
 ([fe80::5926:3836:4212:8640%4]) with mapi id 15.21.0339.012; Sun, 23 Aug 2026
 13:31:03 +0000
Date: Sun, 23 Aug 2026 21:30:56 +0800
From: kernel test robot <lkp@intel.com>
To: Gao Xiang <xiang@kernel.org>
CC: <linux-erofs@lists.ozlabs.org>
Subject: [xiang-erofs:dev] BUILD SUCCESS
 f83c7a54e928b1a844cb5b0df50e286c39514f4f
Message-ID: <202608231200.PJqbwXJT-lkp@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
X-ClientProxiedBy: TP0P295CA0004.TWNP295.PROD.OUTLOOK.COM
 (2603:1096:910:2::14) To SJ0PR11MB5214.namprd11.prod.outlook.com
 (2603:10b6:a03:2df::22)
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
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ0PR11MB5214:EE_|BN9PR11MB5241:EE_
X-MS-Office365-Filtering-Correlation-Id: c9c9852f-8f9a-4bd4-c894-08df011ac6ed
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016|23010399003|10067099003|11063799006|56012099006|18002099003;
X-Microsoft-Antispam-Message-Info: iz3Ksk+s2i0EYp6y5NPvxFhlfT14RCzDrMDNtB8IbD+3WsIyJRWELMdFmHAHRV2/7jyDzD1VfZu02HingdCR+17aVaoTjauqmjA8gDYMeo0GRl195S2uF25tftAF9eBBxlgE5LLrPP1xye4QBq4z492zpz6RKzeJctn937yZITi+3ieIvHusun5ZAWhkdni6wwxg/rSOCUpmjRxV7QOjKQKsiWACoAhcyBMFXCXx6a52yjzuI2Z6TNoIDcx91/pQ6XTRsHie0upQcmgOPejdbWFrzjttOyTnAicuNMi3zhWOtG9wv3XGVh+7I7r8k2uwjPjg0AjfYMOUYn4+HcCMWOj0MQBGdF2dTOg6QZ7d+bzgjRC1YUyaMTrIA1a1xcIchHME3TUVqVBryPoYLFwWZH30dUt9Gjme1Bwq6NolzyOrXQbMyr4/8ZVD78ScCFRZC73RyBg/UB6ne30yH47GkKlxd4kDKUwFU9LZGnAMgZfWI3zp0Bs2iY7JbDAmV9VGaNos8719yamiI4oszVgwBkkoU/cq4cFuG7fnIT0kJrTJqgVV6su7pybWN0LO9In/JzlmRJTtSegi+WRV7RuxU7Wq4QVpPfNN4Cl4mLsFPZV0I0ylptMSJlwQshu85ZD8FhwhrBOMUlXqY/XdUCQuwEpjZkSpPlyKmVEjEx8SmNk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR11MB5214.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(23010399003)(10067099003)(11063799006)(56012099006)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?i82IYY966F3h8gFQzJdILFXeYbXs36fkAasTslonm5NVeeC/LaKzL7/lAZ1O?=
 =?us-ascii?Q?8t7m9gs7q7hduRGWnw/0enfrYcAMJA138ddFezVrbVzrXyLQWg5BNTKhAeNg?=
 =?us-ascii?Q?PfB+hPxITmHsSFbE0O3KIsUmfBBb/caqJzJjatUi43+Jic7q0I0w4pZyIlX6?=
 =?us-ascii?Q?w38BcEeDZHv7H9HEjvn7pB7GK2oP9o4osU8Q1VSVRQCL1A9RXfHL1P8FCOJr?=
 =?us-ascii?Q?wrtT2YmG6KHrY1Ufy9DLymkH3yp9IZbHj/Z0FniXbjuZ4txhIZaDp0Otphwu?=
 =?us-ascii?Q?bdtUamEhYYH+hCF2c4Jdie2oU2aU1hGdTScGWbVy1o8oz/R6iSiPfYYh0VcF?=
 =?us-ascii?Q?V6SV6ZBXPAzLuLsGKx1jkJlD9GqN84sdiLUQH/TPszHSgu7+f/HOG0hh0WD5?=
 =?us-ascii?Q?N2PiMN94zjzk+TGd/PjEIW4Zne3Q5Afctbwz3b4HuFgK40SBHodqcjgpY7t1?=
 =?us-ascii?Q?hIfmxNtSWUvFDv3oovPJQRFCPdmES0czsdhSko3V97M6Ub4LJy32UoOCd+78?=
 =?us-ascii?Q?DFum2In5t1OhuHg5eAPRSIzHpPCgd3Nf4qdYIV07zmxxZ+OhFw/eM7IPXFfE?=
 =?us-ascii?Q?UYVM6Ze4kIGZitae6AoLHQsNzzgPrGiNjgYyqUqJCMUU+3jRelESDAH6rUSk?=
 =?us-ascii?Q?Tif8Caa2bqW20q6hPgyhZyxJDofYNNCXPuI98g+VWmxlC3CCjrsN6tUv+qzc?=
 =?us-ascii?Q?1GA6Qvf4HliAUPZyUSCaHW+eTG0bpdgNqWZgsIl4GXyYn6DrpaIKaxkyUWWe?=
 =?us-ascii?Q?aPA04dzR0LcpBXPgSdZNHLiEWUubSHXGgDSN1cLPNKoCU0XYiABkod//0XfD?=
 =?us-ascii?Q?gDZbNLIdNzaWe08VJ6IV3gGSAypamqZUn7th6a+3Mk06oI6gwKqkkzoNoF9r?=
 =?us-ascii?Q?QpOYosXG6/rsXqDTIGaoIXSfXwpN4umn66D6+gSAsHwLPrYeNDbYdiB++0+o?=
 =?us-ascii?Q?4DoRKojIQ1Y8zNogTq/9uvdK0VBifJk6N6dpdZK6vBPur3sqFutKk03zhgLH?=
 =?us-ascii?Q?8rVkC0w9aZkbWu5VE5My6tL9y37B5tfD0XvFNSafmQlRxXGELHmF7wQtDkIo?=
 =?us-ascii?Q?36G6TB185D7FZjynb0AyA3Uo6zS1k2LVtNo+dbp4IdHeTv3r2wXU0AlHVxAx?=
 =?us-ascii?Q?Evt0kTPbte7kgjoBFbUbUmMXYu/Ub+F0THc67f+s8drAVQbsL8w9yJj88tD9?=
 =?us-ascii?Q?cSr1N39Ta+E5OlbBhPTmg9Vl1PgOmExIZ8ZIe8BPmkTpMZdibziC9BucMAa1?=
 =?us-ascii?Q?anbtDAinO/mIvZwT9bVXlpftvpIWPamL+r5ttFV1ommJT+DAUOjHoMsW/Gbu?=
 =?us-ascii?Q?+oJIzt/bJMedOicu5tWSOD29yuUJZpzoNG0B8n73gQiU0gLEHZuTt9g1S3hf?=
 =?us-ascii?Q?aSdMPlhQNrOU05HH1GT1Po1F3K90QtYjcYtg12QOaQea+2vW514KvnYp9Nu5?=
 =?us-ascii?Q?vE8MLhTQBUjVnZjLa8W3L4fp5jEAFlPPIztrg4aInwDXu8/fbTY1YRmb61Ta?=
 =?us-ascii?Q?8xn1nFRWqmDmjncKIY7CjXL2tL5F9KJ8T9bvorFM6rQucUk8SNcPerynAEAW?=
 =?us-ascii?Q?yO6taZ8Rnm52QdoBKgFXhIjuOruFCBs9zsKIN35kFEfImJ6RkXGWsAW4C1WX?=
 =?us-ascii?Q?8h7qjRB1RkfcACfH4ITxGhHu3XpMxzgB3vHmE2en740idFJb1wYlfD443hKv?=
 =?us-ascii?Q?r/5TgnXQhdM58GqU4lBXmzYxfxV/b2SsCxJiR1aHmf8kxBYFZVlsi2Exa26Z?=
 =?us-ascii?Q?h6xp9a36sA=3D=3D?=
X-Exchange-RoutingPolicyChecked: s+8CkoA3eyI1XV3uyxXGAkp25i6aS7M9ZItp0pBa30gb85JNnH+wxpF1zHKyzCW6Jz6xuPoKhF3oGM1ZThVHL1IQt5KLcZwCFWd+LFONvOCHh8u0mqdDqsvEQSlrrjQmmxERA5xtABq/u5hkDIvI42xnhxedSWaMsbgAWAbvYCs0uqnruwiqTJz/ouXx3JGWAzxZjiF0yGafTNBQxS6L4Vsh7XZkt7Sv7BKWOuOs4D+vuJf29ChkZngDfpLzvVvoRIVm+TzV0HIqW0RveTT7pblsdS32KLHHHVTrMX2uHu1crhQPGeHY50DzU3hHpfMfwvst1tnmhptnHpM4gdHxRw==
X-MS-Exchange-CrossTenant-Network-Message-Id: c9c9852f-8f9a-4bd4-c894-08df011ac6ed
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR11MB5214.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Aug 2026 13:31:03.0094
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3+Yi/R0GBtv3bke7Ha2ERKX6ZUOPooZO00H2v3m9C0xMJWvAz9+t2xmfPmv7TN3tDYEd77t0xPhHhkYrvVgG7Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR11MB5241
X-OriginatorOrg: intel.com

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/xiang/erofs.git dev
branch HEAD: f83c7a54e928b1a844cb5b0df50e286c39514f4f  erofs: support large folios in inode_share mode

elapsed time: 1476m

configs tested: 215
configs skipped: 0

The following configs have been built successfully.
More configs may be tested in the coming days.

tested configs:
alpha                            allnoconfig    gcc-16.1.0
alpha                           allyesconfig    gcc-16.1.0
alpha                              defconfig    gcc-16.1.0
arc                             allmodconfig    gcc-16.1.0
arc                             allyesconfig    gcc-16.1.0
arc                nsimosci_hs_smp_defconfig    gcc-16.1.0
arc                  randconfig-001-20260822    gcc-10.5.0
arc                  randconfig-001-20260823    clang-24
arc                  randconfig-002-20260822    gcc-10.5.0
arc                  randconfig-002-20260823    clang-24
arm                  randconfig-001-20260822    gcc-10.5.0
arm                  randconfig-001-20260823    clang-24
arm                  randconfig-002-20260822    gcc-10.5.0
arm                  randconfig-002-20260823    clang-24
arm                  randconfig-003-20260822    gcc-10.5.0
arm                  randconfig-003-20260823    clang-24
arm                  randconfig-004-20260822    gcc-10.5.0
arm                  randconfig-004-20260823    clang-24
arm                        vf610m4_defconfig    gcc-16.1.0
arm64                         randconfig-001    gcc-14.3.0
arm64                randconfig-001-20260822    clang-24
arm64                randconfig-001-20260822    gcc-14.3.0
arm64                randconfig-001-20260823    gcc-15.2.0
arm64                randconfig-002-20260822    clang-24
arm64                randconfig-002-20260822    gcc-14.3.0
arm64                randconfig-002-20260823    gcc-15.2.0
arm64                randconfig-003-20260822    clang-24
arm64                randconfig-003-20260822    gcc-14.3.0
arm64                randconfig-003-20260823    gcc-15.2.0
arm64                randconfig-004-20260822    clang-24
arm64                randconfig-004-20260822    gcc-14.3.0
arm64                randconfig-004-20260823    gcc-15.2.0
csky                            allmodconfig    gcc-16.1.0
csky                 randconfig-001-20260822    clang-24
csky                 randconfig-001-20260822    gcc-14.3.0
csky                 randconfig-001-20260823    gcc-15.2.0
csky                 randconfig-002-20260822    clang-24
csky                 randconfig-002-20260822    gcc-14.3.0
csky                 randconfig-002-20260823    gcc-15.2.0
hexagon              randconfig-001-20260822    gcc-16.1.0
hexagon              randconfig-001-20260823    gcc-16.1.0
hexagon              randconfig-002-20260822    gcc-16.1.0
hexagon              randconfig-002-20260823    gcc-16.1.0
i386                            allmodconfig    gcc-14
i386                buildonly-randconfig-001    clang-22
i386       buildonly-randconfig-001-20260822    clang-22
i386       buildonly-randconfig-001-20260823    gcc-14
i386       buildonly-randconfig-002-20260822    clang-22
i386       buildonly-randconfig-002-20260823    gcc-14
i386       buildonly-randconfig-003-20260822    clang-22
i386       buildonly-randconfig-003-20260823    gcc-14
i386       buildonly-randconfig-004-20260822    clang-22
i386       buildonly-randconfig-004-20260823    gcc-14
i386       buildonly-randconfig-005-20260822    clang-22
i386       buildonly-randconfig-005-20260823    gcc-14
i386       buildonly-randconfig-006-20260822    clang-22
i386       buildonly-randconfig-006-20260823    gcc-14
i386                          randconfig-001    clang-22
i386                 randconfig-001-20260822    clang-22
i386                 randconfig-001-20260823    gcc-14
i386                 randconfig-002-20260822    clang-22
i386                 randconfig-002-20260823    gcc-14
i386                 randconfig-003-20260822    clang-22
i386                 randconfig-003-20260823    gcc-14
i386                 randconfig-004-20260822    clang-22
i386                 randconfig-004-20260823    gcc-14
i386                 randconfig-005-20260822    clang-22
i386                 randconfig-005-20260823    gcc-14
i386                 randconfig-006-20260822    clang-22
i386                 randconfig-006-20260823    gcc-14
i386                 randconfig-007-20260822    clang-22
i386                 randconfig-007-20260823    gcc-14
i386                          randconfig-011    gcc-14
i386                 randconfig-011-20260822    gcc-14
i386                 randconfig-011-20260823    clang-22
i386                 randconfig-012-20260822    gcc-14
i386                 randconfig-012-20260823    clang-22
i386                 randconfig-013-20260822    gcc-14
i386                 randconfig-013-20260823    clang-22
i386                 randconfig-014-20260822    gcc-14
i386                 randconfig-014-20260823    clang-22
i386                 randconfig-015-20260822    gcc-14
i386                 randconfig-015-20260823    clang-22
i386                 randconfig-016-20260822    gcc-14
i386                 randconfig-016-20260823    clang-22
i386                 randconfig-017-20260822    gcc-14
i386                 randconfig-017-20260823    clang-22
loongarch                          defconfig    clang-24
loongarch            randconfig-001-20260822    gcc-16.1.0
loongarch            randconfig-001-20260823    gcc-16.1.0
loongarch            randconfig-002-20260822    gcc-16.1.0
loongarch            randconfig-002-20260823    gcc-16.1.0
m68k                      m5249evb_defconfig    gcc-16.1.0
mips                         eyeq5_defconfig    gcc-16.1.0
nios2                           allmodconfig    gcc-11.5.0
nios2                            allnoconfig    gcc-11.5.0
nios2                randconfig-001-20260822    gcc-16.1.0
nios2                randconfig-001-20260823    gcc-16.1.0
nios2                randconfig-002-20260822    gcc-16.1.0
nios2                randconfig-002-20260823    gcc-16.1.0
parisc                          allmodconfig    gcc-16.1.0
parisc                          allyesconfig    gcc-16.1.0
parisc                             defconfig    gcc-16.1.0
parisc                        randconfig-001    gcc-15.2.0
parisc               randconfig-001-20260822    gcc-15.2.0
parisc               randconfig-001-20260823    gcc-10.5.0
parisc               randconfig-002-20260822    gcc-15.2.0
parisc               randconfig-002-20260823    gcc-10.5.0
powerpc              randconfig-001-20260822    gcc-15.2.0
powerpc              randconfig-001-20260823    gcc-10.5.0
powerpc              randconfig-002-20260822    gcc-15.2.0
powerpc              randconfig-002-20260823    gcc-10.5.0
powerpc                    tqm8560_defconfig    gcc-16.1.0
powerpc64            randconfig-001-20260822    gcc-15.2.0
powerpc64            randconfig-001-20260823    gcc-10.5.0
powerpc64            randconfig-002-20260822    gcc-15.2.0
powerpc64            randconfig-002-20260823    gcc-10.5.0
riscv                         randconfig-001    clang-24
riscv                randconfig-001-20260822    clang-17
riscv                randconfig-001-20260823    clang-24
riscv                randconfig-002-20260822    clang-17
riscv                randconfig-002-20260823    clang-24
s390                 randconfig-001-20260822    clang-17
s390                 randconfig-001-20260823    clang-24
s390                 randconfig-002-20260822    clang-17
s390                 randconfig-002-20260823    clang-24
sh                                 defconfig    gcc-16.1.0
sh                   randconfig-001-20260822    clang-17
sh                   randconfig-001-20260823    clang-24
sh                   randconfig-002-20260822    clang-17
sh                   randconfig-002-20260823    clang-24
sh                         rsk7201_defconfig    gcc-16.1.0
sparc                         randconfig-001    gcc-8.5.0
sparc                randconfig-001-20260822    gcc-8.5.0
sparc                randconfig-001-20260823    gcc-10.5.0
sparc                randconfig-002-20260822    gcc-8.5.0
sparc                randconfig-002-20260823    gcc-10.5.0
sparc64              randconfig-001-20260822    gcc-8.5.0
sparc64              randconfig-001-20260823    gcc-10.5.0
sparc64              randconfig-002-20260822    gcc-8.5.0
sparc64              randconfig-002-20260823    gcc-10.5.0
um                   randconfig-001-20260822    gcc-8.5.0
um                   randconfig-001-20260823    gcc-10.5.0
um                   randconfig-002-20260822    gcc-8.5.0
um                   randconfig-002-20260823    gcc-10.5.0
x86_64              buildonly-randconfig-001    clang-22
x86_64     buildonly-randconfig-001-20260822    clang-22
x86_64     buildonly-randconfig-001-20260823    clang-22
x86_64     buildonly-randconfig-002-20260822    clang-22
x86_64     buildonly-randconfig-002-20260823    clang-22
x86_64     buildonly-randconfig-003-20260822    clang-22
x86_64     buildonly-randconfig-003-20260823    clang-22
x86_64     buildonly-randconfig-004-20260822    clang-22
x86_64     buildonly-randconfig-004-20260823    clang-22
x86_64     buildonly-randconfig-005-20260822    clang-22
x86_64     buildonly-randconfig-005-20260823    clang-22
x86_64     buildonly-randconfig-006-20260822    clang-22
x86_64     buildonly-randconfig-006-20260823    clang-22
x86_64                                 kexec    clang-22
x86_64                        randconfig-001    gcc-14
x86_64               randconfig-001-20260822    gcc-12
x86_64               randconfig-001-20260822    gcc-14
x86_64               randconfig-001-20260823    clang-22
x86_64               randconfig-002-20260822    gcc-12
x86_64               randconfig-002-20260822    gcc-14
x86_64               randconfig-002-20260823    clang-22
x86_64               randconfig-003-20260822    gcc-12
x86_64               randconfig-003-20260822    gcc-14
x86_64               randconfig-003-20260823    clang-22
x86_64               randconfig-004-20260822    gcc-12
x86_64               randconfig-004-20260822    gcc-14
x86_64               randconfig-004-20260823    clang-22
x86_64               randconfig-005-20260822    gcc-12
x86_64               randconfig-005-20260822    gcc-14
x86_64               randconfig-005-20260823    clang-22
x86_64               randconfig-006-20260822    gcc-12
x86_64               randconfig-006-20260822    gcc-14
x86_64               randconfig-006-20260823    clang-22
x86_64                        randconfig-011    clang-22
x86_64               randconfig-011-20260822    clang-22
x86_64               randconfig-011-20260823    clang-22
x86_64               randconfig-012-20260822    clang-22
x86_64               randconfig-012-20260823    clang-22
x86_64               randconfig-013-20260822    clang-22
x86_64               randconfig-013-20260823    clang-22
x86_64               randconfig-014-20260822    clang-22
x86_64               randconfig-014-20260823    clang-22
x86_64               randconfig-015-20260822    clang-22
x86_64               randconfig-015-20260823    clang-22
x86_64               randconfig-016-20260822    clang-22
x86_64               randconfig-016-20260823    clang-22
x86_64                        randconfig-071    gcc-14
x86_64               randconfig-071-20260822    clang-22
x86_64               randconfig-071-20260822    gcc-14
x86_64               randconfig-071-20260823    gcc-14
x86_64               randconfig-072-20260822    clang-22
x86_64               randconfig-072-20260822    gcc-14
x86_64               randconfig-072-20260823    gcc-14
x86_64               randconfig-073-20260822    clang-22
x86_64               randconfig-073-20260822    gcc-14
x86_64               randconfig-073-20260823    gcc-14
x86_64               randconfig-074-20260822    clang-22
x86_64               randconfig-074-20260822    gcc-14
x86_64               randconfig-074-20260823    gcc-14
x86_64               randconfig-075-20260822    clang-22
x86_64               randconfig-075-20260822    gcc-14
x86_64               randconfig-075-20260823    gcc-14
x86_64               randconfig-076-20260822    clang-22
x86_64               randconfig-076-20260822    gcc-14
x86_64               randconfig-076-20260823    gcc-14
x86_64                          rhel-9.4-bpf    gcc-14
xtensa               randconfig-001-20260822    gcc-8.5.0
xtensa               randconfig-001-20260823    gcc-10.5.0
xtensa               randconfig-002-20260822    gcc-8.5.0
xtensa               randconfig-002-20260823    gcc-10.5.0

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

