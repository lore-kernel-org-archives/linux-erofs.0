Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83488606A31E
	for <linux-erofs@archiver.kernel.org>; Mon, 23 Nov 2026 20:53:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=MkypE2ro
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4jYJ7k2xshz2y7p;
	Tue, 24 Nov 2026 07:53:38 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=pass smtp.remote-ip="2a01:111:f403:c105::7" arc.chain=microsoft.com
ARC-Seal: i=2; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1795467218;
	cv=pass; b=Dhf2ra/RoWE1DggY9WXsvkm8Z3NkbyivXd4+RlbwOThT4zHGw0OyyvbGwfhI7z0IfhZV3oMDNxbzi6uCLINEpE4O/t+x5vPHxbDBlnhVNrcT2/wMe6GrAVGWyJEL7wnoXaGT/+AJECpnXkDn552yYGWPczWhqCpzqfCtN2Ky5aJKgNI+YKdPQLfy7IPequ2adgO9sjpatGYBwytcCYfUP6m1KIehPlfxy9derAe4Tk1TZkhs3O9ufamXtE7bSn8o51QXSQoByWaA+BYs+8/I1EPqLMcOL6j+uLfBprM5Q+GA27tbxbjDbhv/2l2X4i0s7jGI0G6jpzIu0SRlVhFJaA==
ARC-Message-Signature: i=2; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1795467218; c=relaxed/relaxed;
	bh=lc5AXtjIZTwpMmxhIrbUVcnPfZdSJ6AlZp757AeH+3g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Ju3CsSuvunnrv1uyBN3RxNL7pVIzJzMEkmgHxJD8Zj9igvAVMiCnL972zc1s3JQ3I81yoCVkm3Uia55q+CbY2JXIP8MeymliMTVJ51psJS7SJKWNuSMkx47yU2htY6WO9j2lqVOt5yqrmpcIVXwk3cqzqcpgeu1/9/XFFuFJNZqorQJUKdLFL0ENSSBUVzZK3FtJdrr4ex9NFoBR5HYZ4rKYYpWxxxHESZBZWDpUzyE7QGu/M+tlEOuO21q9rUxT/7h9o6QQTVGXvMkE9pIrr5vbcFr4yKA7kkb2uaUAu5pweMdyUNgpR52LykRzKaFMvAUTbAqOGTbjB0JfENJ/9g==
ARC-Authentication-Results: i=2; lists.ozlabs.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; dkim=pass (2048-bit key; unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=MkypE2ro; dkim-atps=neutral; spf=pass (client-ip=2a01:111:f403:c105::7; helo=ch4pr04cu002.outbound.protection.outlook.com; envelope-from=lkarpinski@nvidia.com; receiver=lists.ozlabs.org) smtp.mailfrom=nvidia.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=MkypE2ro;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=nvidia.com (client-ip=2a01:111:f403:c105::7; helo=ch4pr04cu002.outbound.protection.outlook.com; envelope-from=lkarpinski@nvidia.com; receiver=lists.ozlabs.org)
Received: from CH4PR04CU002.outbound.protection.outlook.com (mail-northcentralusazlp170130007.outbound.protection.outlook.com [IPv6:2a01:111:f403:c105::7])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange secp256r1 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4jYJ7h3hPRz2xdb
	for <linux-erofs@lists.ozlabs.org>; Tue, 24 Nov 2026 07:53:35 +1100 (AEDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gz4EZC09/G356h4Gvx7QiZ9VtqYFim6xwzJh4oQuJ9avp+ObB9IYHG5gDhyD4XgwnkDaiJAFeyVpRUey6jg1ETusCo9IbElLzd5jz7ncFNg6EexCOFVFnoq6QaGWbgctdUUEfN3H641XvO7XS/r7ouqs6xbiCQW1fc12oOcj86jeMqxg/8P/2ROy+TtMawQwHQG/bZinnVL5KhkoS33wtmnf+08Aq1Cis3dgLLcmnkxC1r2s/+qtQePkCKyrm3zwdi5gltjCB8fkmJburwlWr7YlKvZwUnUYUqlRRhqX0FkK7pOzlkh2AXGx32rs2GQyY7GjtKjguWlCMLsYMr8uMA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lc5AXtjIZTwpMmxhIrbUVcnPfZdSJ6AlZp757AeH+3g=;
 b=YD1NkT0/58MlLcUu6PJpRGR+hSouepOe7drw2VYohYXf8+eZZWFi8UEn1SWWTtfke06SLGtbzi3E7296iNhlTXoEmv5qVvM7+hlgkfQAv4Jw5osR5TJOh7hw9N/xGkI/lDPMvmwMkm88zlEbaKlz9AFYWvGu1Y4VsevYf/uL2dYQ0Did842oRHL44Tw1VrBIbECpDW96ZWF0RH/J4c/shWQaVZBgJ2Dkk7kD+Te6Ey/qnwarNHXyDmIaV37RfTs2xLCKDZQ13qZu2kfsKJcxwvmKiopcdmNZxrAWuwWOHFCrhGDHgDKJ/iVb53WyKbC87ymL8u+gYhvY1+d5yTMwdg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lc5AXtjIZTwpMmxhIrbUVcnPfZdSJ6AlZp757AeH+3g=;
 b=MkypE2ro1gyA95j8dBajUahgoX28aLuJ57Yhi/fx6h3bPSYAWjvBm7AdJpMd5vBvFUWRUJ1do9cxTYj9FCGngZ618MjqvyUtc0USwqwxZs79kyYNTvdrUZDk0ROVhwdtIo2tqVJc1diTlzBouZDJ5oGRQvtOZ1oqP1YQ945WAK93to8O7Yanjr7ai7r2bJ13OHegIaIjlUlsarabc4nCEbxGXJv7Rmy75rqmG+VlUY+P/7x61Mmluzkdae2xnYY4Kb/Qk+UWle9P3+vLeRJdcUPZvjUIHJ952IROosgb6u67w93UWpYQyxk7qGCYUNP/qVTqjVYOr6k/O4fRfsnS4g==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from PH0PR12MB999112.namprd12.prod.outlook.com
 (2603:10b6:510:38c::12) by SN7PR12MB7882.namprd12.prod.outlook.com
 (2603:10b6:806:348::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.639.12; Mon, 23 Nov
 2026 20:53:19 +0000
Received: from PH0PR12MB999112.namprd12.prod.outlook.com
 ([fe80::3c97:f642:2ba7:1a5f]) by PH0PR12MB999112.namprd12.prod.outlook.com
 ([fe80::3c97:f642:2ba7:1a5f%6]) with mapi id 15.21.0639.012; Mon, 23 Nov 2026
 20:53:19 +0000
From: Lucas Karpinski <lkarpinski@nvidia.com>
To: linux-erofs@lists.ozlabs.org
Cc: jcalmels@nvidia.com,
	Lucas Karpinski <lkarpinski@nvidia.com>
Subject: [PATCH 2/2] erofs-utils: rebuild: copy compressed file data in full-data mode
Date: Mon, 23 Nov 2026 15:52:56 -0500
Message-ID: <20261123-compressed_inodes-v1-2-045d0b3e3f31@nvidia.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261123-compressed_inodes-v1-1-045d0b3e3f31@nvidia.com>
References: <20261123-compressed_inodes-v1-1-045d0b3e3f31@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: PH0PR12MB999112:EE_|SN7PR12MB7882:EE_
X-MS-Office365-Filtering-Correlation-Id: b99b8903-9fcd-4c1d-56da-08df49a3cdc1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|23010399003|376014|261022105027099003|261022115727099003|261026140227099003|261022113327099003|261022075727099003|261026121527099003|261026130827099003|261026135527099003|261021135927099003|10067099003|261021123027099003|261021121427099003|261021130227099003|261021133027099003|261102123227099003|261028144727099003|261009223027099003|3023799007|22082099003|18002099003|56012099006|5023799004|11063799006;
X-Microsoft-Antispam-Message-Info:
	DxeuDqHKGiKzsgtGrxNCuw4S9ZYX9o9C6CKCAePuk84ngKGF5eSnRf0Oa7CHiDt/75AiqHafw/PYSy+At4HKaIB7pT2nM6mNQfMmTJ8rb/GCanbVbol/9e8yOD2XvaQSyExu9KuYRJ43EYnCChaFyAbDsKkJsBTFKol8Wi4YgMz2DNo8qMzfji1hexa0mlkpN21bq6PfbB41DmTHq4ERrrX1dHdc8Or/lE+mkmV92p6dledn72wepN/i3Og8quCmyL+jcZMWYx+F46CSG61XDg7k4MsNefyPZcFKdscV5gW1VrBoSTzkTzB3F5bEeFNg0pD+DcfiIXRW2LBtm7poXGOqRGvWxFmNx3LLCtdZPpIE/VdNmqiit/kGrEm/kgKwYI7/DMlgqBYUca6/zOtdFUQauI7TNHoWfn88yqr83GOOE1+cIrXdFKSgtRuIKQFOLfAjSaf0HNhBT53bKvahT8NS3iBPK8OmqitzthVvJeFxxf4jLNLblvz7bFBm8kvmXWGGCijrTgCPVos9x6I864UJzUOptEkh2Gjk9VsHfTOTiXjc7j1gICb5TOCSEe6dCVkH/tPirmieAwFAZPjETo/HF495Y33exqdmFzqXvNN7ehvYYLzxAe2U0Y4IoigtZ8QHy+H/qxekyYa24D37FA==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR12MB999112.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(23010399003)(376014)(261022105027099003)(261022115727099003)(261026140227099003)(261022113327099003)(261022075727099003)(261026121527099003)(261026130827099003)(261026135527099003)(261021135927099003)(10067099003)(261021123027099003)(261021121427099003)(261021130227099003)(261021133027099003)(261102123227099003)(261028144727099003)(261009223027099003)(3023799007)(22082099003)(18002099003)(56012099006)(5023799004)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Q3RhbEtuaHRPbG16QU1QenV1WU9COXlBTmdwZ09yNlRDd0Ntd0dIWGpUVkV1?=
 =?utf-8?B?TTcvRm9RbjRocFZjc2xCbUdVVHQ2aXp1cGpNaCtFUXQzdmRxNnI3dFYva3NN?=
 =?utf-8?B?Z3E4eVpIQlJBd1A3WWpnYUxPWG1KQUoxZld5ZlRNenA3QWxJeXVtRGxudmpM?=
 =?utf-8?B?dUg0aTVxZWNKdlRtR3pndXpMOGNXODRUemZDQkJST2VqQlJzMTM3ZHJxdnll?=
 =?utf-8?B?Z2hlUkI1WjZ4NWliVklDTkJSQWpRenRJTzgxVlBjK2xjR3d2QWo4TGNPb01m?=
 =?utf-8?B?TEFKZlJIMjRBOXVjNUR0OUhGb043Q1ZIanNSN25hYjQrakg4MG8wNG50TWZp?=
 =?utf-8?B?bktLYTIyQzlsR3JobEpXOHBiaDlVbzJtaDE3R3dPVnFVNUxqemlPUlRuUGNY?=
 =?utf-8?B?MzFtcDh6ZlE3OTRTV1BpR01PNWZac0FlZkRWMjVHekVMMzBJTjBWaEZ5cHVB?=
 =?utf-8?B?dmpRVTZuZE5qaU03UlBHN1VRa2hKa3VPSU9sMHUrd2RIdDY0SkNhdVpHSzFR?=
 =?utf-8?B?S2tJWFpNSlRETGZpeXp1OCtWWDI0OW9CK0txRERPeTF2eGxPM1ErNVhBSHBW?=
 =?utf-8?B?MGtyZ1hNZFlwYlZKNXJRcnNRWG11MFVHbkdBR2F1cERxc1hYUEUveSs5WVBx?=
 =?utf-8?B?emxVVkQ2Q1g3Wk16VjY5OVBPc2llbVA3akZQdHVneEQxNklsMkdNY3Bnb2dL?=
 =?utf-8?B?eThPMkR4Sm5iWGVxSmM1R2tVZlgvWTBtaUFjRjRtTk1UUzQ5aU5rVDRVWjJj?=
 =?utf-8?B?bnlZNUREWktualY4RjlZQWhmblFlYXlMVWpkUUVjc2RuOVhCOHVTSGd0THkz?=
 =?utf-8?B?bFF5K25pc3g0TEZtNWw5M0EraWxFeFYzaVRHUlRCVE9MQVdWWng3Z2RZREhD?=
 =?utf-8?B?dXZlMWpmb1NEQ3FqdHNQeVpsTkhGNFoycktsYW9KdFA5a0dwZTFUckpWaWVH?=
 =?utf-8?B?YWxBMHRtVUI5a3B4NDRRUHNVNVJkdkhKOE5aeHBtNnJRZi9NdmU2NVlHckVw?=
 =?utf-8?B?eHdvOGdLZEpJSUdEb1ErRUlUc3BDQzVOK2xURlFuUGg0dzFrTmRQL3hPOEp2?=
 =?utf-8?B?ZjBhT0xRN0pBTFY4SldjamJGVzBLUmFEUkdnUTBWeW55RVVFL1o2VGE5S3Y0?=
 =?utf-8?B?cTdWRk9YdEtzNE1XaHdQYW9DVTVXTzVycDBidkt6R1Vtd3BaSy8waWVLbVhy?=
 =?utf-8?B?NmNyRmNPcDZMMzZPWkR4OGJXVjNaeFR5cmsvbkZpdCsrN3JFV2xQcnlnc3dH?=
 =?utf-8?B?SThRNnJva2JhbDR1bDh5dDB3OUU1Q3hNcnByM1lUV2oxdEthandiWHAzaXdN?=
 =?utf-8?B?WldhVTc1NG83eFFnL0t1aTgwNUdQY3oveU5mL0dyMmJuLy8zeE1nSThUcjZl?=
 =?utf-8?B?eHZ0Y1Zyb1FDSW56bTZHOXBiY1BKSmhIRFo4dlVTYjBiT21vR0RKdkluYmFn?=
 =?utf-8?B?Vkc1RG1DWVZCZEVEcVBmWTExdUYxaGgzbXNpTWd3RFpnY2Juek1xbU5nUnRE?=
 =?utf-8?B?TUdVWmFNN0gzYTExa3A4amN1SVJvQkpjR0l0ZTNPSGwrVWtQZEdaZWQzYW4w?=
 =?utf-8?B?WWNTZ1g1VlJ6T1FvRUNYTDBCSTk1RmQ2cEZMZTlmTVpvV3JTbTVLSVlscWFR?=
 =?utf-8?B?L2RONUhmK0o5ZUpKZ3VrSU5HVXlRaXpRMnE3TXFRVGlucU8xL1NhMkFlWWJD?=
 =?utf-8?B?a3JlTDJ6VEpjMHBRSW4xZUJ6M0MzU0ZUdjRsQm80d01oQlgwbnJuKytPbDh2?=
 =?utf-8?B?R0dXVGhSaCtBN3hhTEpYWGFzZWFNQ1pmNWJCSFViY0hjSW4xbGRkUUNxc2Uv?=
 =?utf-8?B?WU5IUm9uNktOdm51SjhnanlLeWZ3b0FDU25aQWU5Vnp3UUVBNWVMZGx6Y3Bv?=
 =?utf-8?B?T1FMNFlpU2tyeWc1RG5lUmduazVDSEVjeWlhekFFY3oxSWdaYUlWRDYxamlu?=
 =?utf-8?B?by9BTXdpZm1lVGxrVWFSdmtnS0dGaVRkbmxUM0I3V0hSUUdGdFRIUjdvWFdV?=
 =?utf-8?B?cGNDZ0QzNGs1cGxqeXZFaVRiRDlaa2s0MGtZKzQvb1ZSRWo5ekw1TU8xVHBz?=
 =?utf-8?B?a3E3aUkwUE8xekNOWndjN1ZCeWg1NEhrTXFvN0l1SWpNemFVY1U1VFJ4QkFC?=
 =?utf-8?B?UkVMNWRhaDl0QTYycVlnY2dsa3R6MVVkVmZTUFBJVG9rT0VlUTIvcEhHVld0?=
 =?utf-8?B?dGFiNjNoZjZ6UzFUZkdmVjN4LzF5MVBmZ1lUdWoyRTZabTdnSDlwN01WalJ2?=
 =?utf-8?B?VWNhNzB4Qmo5Q2haRUk4MVpnZnR1TWo2c1I0clpRUGhtNTRXNmkwUWw4dk9L?=
 =?utf-8?B?R0RMYzJheHgyM3Y0MGFoSXE2TXV5eWE5MSt1azNkcWl5Tzk4RlJxdz09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b99b8903-9fcd-4c1d-56da-08df49a3cdc1
X-MS-Exchange-CrossTenant-AuthSource: PH0PR12MB999112.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Nov 2026 20:53:19.1907
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4f/UjdeWhv+JhzkBSOlQZLxTJyXE1LmbRLwNpnLEDC9HN2yMKTP0QudGpCHcrRLfMxlyAar6Ka0js5N17+Zx4A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7882
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Add a dedicated full-data entry point that reuses compressed extent
loading, copies encoded data into destination blocks, and prepares
metadata using the relocated addresses.

Requires compatible destination compression settings and fragment-backed
files remain unsupported.

Assisted-by: ChatGPT:gpt-6.1-sol
Signed-off-by: Lucas Karpinski <lkarpinski@nvidia.com>
---
 lib/compress.c         | 105 +++++++++++++++++++++++++++++++++++++++++++++++++
 lib/liberofs_rebuild.h |   5 +++
 lib/rebuild.c          |  14 +++----
 man/mkfs.erofs.1       |   4 ++
 4 files changed, 119 insertions(+), 9 deletions(-)

diff --git a/lib/compress.c b/lib/compress.c
index bd2c6a8..cb17b91 100644
--- a/lib/compress.c
+++ b/lib/compress.c
@@ -26,6 +26,7 @@
 #include "liberofs_compress.h"
 #include "liberofs_fragments.h"
 #include "liberofs_metabox.h"
+#include "liberofs_rebuild.h"
 #include "erofs/decompress.h"
 
 #define Z_EROFS_DESTBUF_SZ	(Z_EROFS_PCLUSTER_MAX_SIZE + EROFS_MAX_BLOCK_SIZE * 2)
@@ -2496,6 +2497,58 @@ int z_erofs_compress_exit(struct erofs_sb_info *sbi)
 	return 0;
 }
 
+static int z_erofs_rebuild_copy_data(struct erofs_sb_info *dst,
+		struct erofs_inode *inode, struct list_head *extents)
+{
+	struct erofs_sb_info *src = inode->sbi;
+	struct erofs_buffer_head *bh = NULL;
+	struct z_erofs_extent_item *ei;
+	erofs_off_t total = 0, pos = 0;
+	unsigned int bs = erofs_blksiz(dst);
+	int err = 0;
+
+	list_for_each_entry(ei, extents, list)
+		if (!ei->e.inlined)
+			total += round_up(ei->e.plen, bs);
+	if (total) {
+		bh = erofs_balloc(dst->bmgr, DATA, total, 0);
+		if (IS_ERR(bh))
+			return PTR_ERR(bh);
+		erofs_mapbh(NULL, bh->block);
+		pos = erofs_btell(bh, false);
+	}
+
+	list_for_each_entry(ei, extents, list) {
+		erofs_off_t off;
+
+		if (!ei->e.inlined) {
+			for (off = 0; off < ei->e.plen; off += bs) {
+				char buf[EROFS_MAX_BLOCK_SIZE] = {};
+				unsigned int len = min_t(u64, bs, ei->e.plen - off);
+
+				err = erofs_dev_read(src, ei->e.device_id, buf,
+						     ei->e.pstart + off, len);
+				if (err)
+					goto out;
+				err = erofs_dev_write(dst, 0, buf, pos + off, bs);
+				if (err)
+					goto out;
+			}
+		}
+		ei->e.pstart = pos;
+		ei->e.device_id = 0;
+		if (!ei->e.inlined)
+			pos += round_up(ei->e.plen, bs);
+	}
+	inode->u.i_blocks = erofs_blknr(dst, total);
+	erofs_dbg("copied compressed data for %s (%llu bytes)",
+		  inode->i_srcpath, total | 0ULL);
+out:
+	if (bh)
+		erofs_bdrop(bh, !!err);
+	return err;
+}
+
 static int z_erofs_rebuild_load_extents(struct erofs_sb_info *dst_sbi,
 		struct erofs_inode *inode, struct list_head *extents)
 {
@@ -2644,3 +2697,55 @@ out:
 	}
 	return err;
 }
+
+int z_erofs_rebuild_write_full_data(struct erofs_sb_info *dst_sbi,
+				   struct erofs_inode *inode)
+{
+	struct erofs_sb_info *src_sbi = inode->sbi;
+	struct z_erofs_extent_item *ei;
+	unsigned int algs = 0;
+	bool partial = false;
+	LIST_HEAD(extents);
+	int err;
+
+	err = z_erofs_rebuild_load_extents(dst_sbi, inode, &extents);
+	if (err)
+		goto out;
+	list_for_each_entry(ei, &extents, list) {
+		if (!ei->e.raw)
+			algs |= BIT(ei->e.algofmt);
+		partial |= ei->e.partial;
+	}
+	/* The lcluster-index layout can describe at most two algorithms. */
+	inode->z_algorithmtype[0] = algs ? ffs_long(algs) : 0;
+	algs &= algs - 1;
+	inode->z_algorithmtype[1] = algs ? ffs_long(algs) : 0;
+	algs &= algs - 1;
+	if (algs) {
+		err = -EOPNOTSUPP;
+		goto out;
+	}
+	err = z_erofs_rebuild_copy_data(dst_sbi, inode, &extents);
+	if (err)
+		goto out;
+	inode->z_advise &= Z_EROFS_ADVISE_INTERLACED_PCLUSTER;
+	inode->fragment_size = 0;
+	inode->fragmentoff = 0;
+	if (partial)
+		erofs_sb_set_dedupe(dst_sbi);
+	if (inode->idata_size) {
+		inode->z_advise |= Z_EROFS_ADVISE_INLINE_PCLUSTER;
+		erofs_sb_set_ztailpacking(dst_sbi);
+	}
+	inode->sbi = dst_sbi;
+	inode->z_lclusterbits = dst_sbi->blkszbits;
+	err = z_erofs_prepare_layout(inode, &extents, !partial, false);
+	inode->sbi = src_sbi;
+out:
+	if (err) {
+		free(inode->idata);
+		inode->idata = NULL;
+		z_erofs_rebuild_free_extents(&extents);
+	}
+	return err;
+}
diff --git a/lib/liberofs_rebuild.h b/lib/liberofs_rebuild.h
index 6459dbd..7b45e92 100644
--- a/lib/liberofs_rebuild.h
+++ b/lib/liberofs_rebuild.h
@@ -10,6 +10,11 @@ enum erofs_rebuild_datamode {
 	EROFS_REBUILD_DATA_FULL,
 };
 
+int z_erofs_rebuild_load_metadata(struct erofs_sb_info *dst,
+				 struct erofs_inode *inode);
+int z_erofs_rebuild_write_full_data(struct erofs_sb_info *dst,
+				   struct erofs_inode *inode);
+
 struct erofs_dentry *erofs_rebuild_get_dentry(struct erofs_inode *pwd,
 		char *path, bool aufs, bool *whout, bool *opq, bool to_head);
 
diff --git a/lib/rebuild.c b/lib/rebuild.c
index e83fd52..d35f36b 100644
--- a/lib/rebuild.c
+++ b/lib/rebuild.c
@@ -316,15 +316,13 @@ err:
 static int erofs_rebuild_write_blob_index(struct erofs_sb_info *dst_sb,
 					  struct erofs_inode *inode)
 {
-	int z_erofs_rebuild_load_metadata(struct erofs_sb_info *dst_sb,
-					  struct erofs_inode *inode);
-
 	if (is_inode_layout_compression(inode))
 		return z_erofs_rebuild_load_metadata(dst_sb, inode);
 	return erofs_rebuild_load_chunk_index(dst_sb, inode);
 }
 
-static int erofs_rebuild_write_full_data(struct erofs_inode *inode)
+static int erofs_rebuild_write_full_data(struct erofs_sb_info *dst_sbi,
+					struct erofs_inode *inode)
 {
 	struct erofs_sb_info *src_sbi = inode->sbi;
 	int err = 0;
@@ -382,9 +380,7 @@ static int erofs_rebuild_write_full_data(struct erofs_inode *inode)
 			  inode->i_srcpath);
 		err = -EOPNOTSUPP;
 	} else if (is_inode_layout_compression(inode)) {
-		erofs_err("compressed files not yet supported: %s",
-			  inode->i_srcpath);
-		err = -EOPNOTSUPP;
+		err = z_erofs_rebuild_write_full_data(dst_sbi, inode);
 	}
 	return err;
 }
@@ -435,7 +431,7 @@ static int erofs_rebuild_update_inode(struct erofs_sb_info *dst_sb,
 		else if (datamode == EROFS_REBUILD_DATA_RESVSP)
 			inode->datasource = EROFS_INODE_DATA_SOURCE_RESVSP;
 		else if (datamode == EROFS_REBUILD_DATA_FULL)
-			err = erofs_rebuild_write_full_data(inode);
+			err = erofs_rebuild_write_full_data(dst_sb, inode);
 		else
 			err = -EOPNOTSUPP;
 		break;
@@ -635,7 +631,7 @@ int erofs_rebuild_load_tree(struct erofs_inode *root, struct erofs_sb_info *sbi,
 		return ret;
 	}
 
-	if (mode == EROFS_REBUILD_DATA_BLOB_INDEX) {
+	if (mode != EROFS_REBUILD_DATA_RESVSP) {
 		if (erofs_sb_has_ztailpacking(sbi))
 			erofs_sb_set_ztailpacking(dst_sbi);
 		if (erofs_sb_has_dedupe(sbi))
diff --git a/man/mkfs.erofs.1 b/man/mkfs.erofs.1
index 65ec807..1098b22 100644
--- a/man/mkfs.erofs.1
+++ b/man/mkfs.erofs.1
@@ -525,6 +525,10 @@ image layers.
 \fB\-\-clean=data\fR: Import complete file data from all source images into
 the destination image, producing a fully self-contained EROFS image that does
 not depend on external blob devices.
+Compressed file data is copied without decompression or recompression.
+As with blob-index rebuilds, specify destination compression settings
+compatible with the source images, such as the same \fB\-z\fR and \fB\-C\fR
+options used to create them. Fragment-backed files are not supported.
 .TP
 .I rvsp mode
 \fB\-\-clean=rvsp\fR or \fB\-\-incremental=rvsp\fR: Reserve space for file

-- 
Git-157)

