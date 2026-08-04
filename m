Return-Path: <linux-erofs+bounces-4138-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7ACFBC5518F
	for <linux-erofs@archiver.kernel.org>; Tue,  4 Aug 2026 17:10:23 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hF0RK3BB3z2yH5;
	Wed, 05 Aug 2026 03:10:21 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=pass smtp.remote-ip="2a01:111:f403:c111::9" arc.chain=microsoft.com
ARC-Seal: i=2; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1785863421;
	cv=pass; b=M2W5l4sECpMIWotelrBwdWCB7I/VQs7dfWYJyJRnwuCJq1a+3UBzQ2OVdqw3Pt3wD447zxlCs78lgtlzOVmC3rX0FKbgA0AQqAeeDewCo4FQak/dOdCJMILAbV97yzHgmZgZXELac6WFO0KnC7HOm1wEi3ahRDISQ4lq0EfxrgqHEiZoCdzzFoyQLwe6+nfVyUE9BlVtKjxW2z9Sogxd0pB5ZiZabc4MvW+WEnb5d+8e/BV4gzqIt6ODgFJW6Kq66+8/EB7swcibn6PNdO8n/HtEqTtUU9iFBe4Gx7KOfycrHhb7o34GixipwU/va/u3aTBBaqfZMMxyBa2DSbCmjQ==
ARC-Message-Signature: i=2; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1785863421; c=relaxed/relaxed;
	bh=bxYnPNQqmSWeESnueY2FEcMEGz8M3x8w1XfCAVhdjbQ=;
	h=Content-Type:Date:Message-Id:Subject:Cc:To:From:References:
	 In-Reply-To:MIME-Version; b=VrBOfFLTjjZbddeiU1gMNX/u2L1pptK3QU0IKCAwPX6hopcsNKiP8f5g+lvdBh/9F/0G81PRALkMb623Ja/WRkR9l3r2RbeFCWyNMNSqsLBnXevl8zXRSBa2CIs9hRLEoB5hQJICkdZUVW0jxRoBy19wbC9AEeMSd7Zs6spgGNnLERlqFXDDmQx6bCcQ3HH8oWcLxOV/2Y5nDjmEVx9hp9b3dKICBgyu+6q6SDduNDTuCJLVGYkf7ztFA9+5NIP55J2k+ti6YEpih6UGuvE7K0nVZ3OTHwAwnFGtJAPMSOh5OoUjWwlySsnDmocCygqRNRQxr7KvYZzip5FKlQQflA==
ARC-Authentication-Results: i=2; lists.ozlabs.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; dkim=pass (2048-bit key; unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=krlOF4Qx; dkim-atps=neutral; spf=pass (client-ip=2a01:111:f403:c111::9; helo=dm5pr21cu001.outbound.protection.outlook.com; envelope-from=ziy@nvidia.com; receiver=lists.ozlabs.org) smtp.mailfrom=nvidia.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=krlOF4Qx;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=nvidia.com (client-ip=2a01:111:f403:c111::9; helo=dm5pr21cu001.outbound.protection.outlook.com; envelope-from=ziy@nvidia.com; receiver=lists.ozlabs.org)
Received: from DM5PR21CU001.outbound.protection.outlook.com (mail-centralusazlp170110009.outbound.protection.outlook.com [IPv6:2a01:111:f403:c111::9])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange secp256r1 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hF0RH0TNMz2xqM
	for <linux-erofs@lists.ozlabs.org>; Wed, 05 Aug 2026 03:10:18 +1000 (AEST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bZ/8FcT3Q6zDqc7PmYr4q8pfgFJfYMiYVqQGV1+CnE+SdOj5KcduNsNmkRa/I068l4/5tDbwwgNR3DGxno+6AIUiApG7cPjVm/VFrFYXTn8IUjzEKYzuDl+6MT4VDlLA+uS0RagfWes02VXBToB+rMiIHk1SYIcbiK+8y4ongRJpKUtVT8f/c5JBNH3J4oDo2uYTONRes/3m0m/jW9UulAHsGXJENu58MAesHtBEeweB08qnPiIYHPTFGEziJsTQ6vNH2045DkgHYH3TRh1zs/pzLJNx3Qc0/aCzAnUpp2Dr6TByZa0wMfFD8+3AHLg0cbE3ZB7CAPiDXndu1IYBdA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bxYnPNQqmSWeESnueY2FEcMEGz8M3x8w1XfCAVhdjbQ=;
 b=aYmkybBUCA+F59CVWtaZsL3SvdS8INlhRkFd3EQObnn5afmaF5LumXBeGQd+0c+0vY5XoC0YfM+o+K38xeBmA95PPWHyFb63UOh6CVJx+2rLcCziMllp/D9/88/7dZ8rLa0eliIzS23CSJIYOjJd1zwGlsuYwYTiZxlP02xHr387msyGbC0+mnqaDJFUllYlzjtT3a8B2qL+mY5R2OmQpzsmbmNqD8CJ/gIH5xAxjVcELI6ga6J7zAb+i7GGN85FfZpC5cEm9mKfgfsqZc9qdCI1Dbi6GR6tTh4GT3gNRhCWtC+E4n2k/Er2P/k96yDolG0rWEhcvVJJuMSK43/cwQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bxYnPNQqmSWeESnueY2FEcMEGz8M3x8w1XfCAVhdjbQ=;
 b=krlOF4QxMJZegQUJyDE27TykcHBaathCM2NnPfkKbdHfl18L1ByJz1W0iBwhQVSGMyLWMKgNnOsy+FlNvJN2WcPIFfjiwrvWOVTEvxQfR4/0lycBltHmMWqven40z7sV5x0nVoFr67huvGkwCiL9c5AUPKCgxWs96ZgleVpbzWI/R2VCEHJxAC5J8DVMHPbBAYshQNxMLrDWiKtkqsA6PgKVzY8nV91RZaF4L61U7sNMgwG8VB64iCr38u1lO597iTlrGWq+jgwUZqg49E1uh/Jok57UXFFdpbEaZlq4xJ79tJED9vf41yxgHLQzsSCH9xUVRmPlY5TfFnwZJiI6ww==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DS7PR12MB8371.namprd12.prod.outlook.com (2603:10b6:8:e9::18) by
 BL1PR12MB5945.namprd12.prod.outlook.com (2603:10b6:208:398::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.292.16; Tue, 4 Aug
 2026 17:09:49 +0000
Received: from DS7PR12MB8371.namprd12.prod.outlook.com
 ([fe80::23d7:9e07:1de8:d80a]) by DS7PR12MB8371.namprd12.prod.outlook.com
 ([fe80::23d7:9e07:1de8:d80a%3]) with mapi id 15.21.0270.017; Tue, 4 Aug 2026
 17:09:48 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Tue, 04 Aug 2026 13:09:46 -0400
Message-Id: <DKGBQHP25RE0.3NKUQSDULAQSX@nvidia.com>
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
In-Reply-To: <2evaxdu6cobpnzzer3y7fsrqvmtmhj7gm3e5buebdaw564igx6@7bs5enipxnpx>
X-ClientProxiedBy: BL1PR13CA0081.namprd13.prod.outlook.com
 (2603:10b6:208:2b8::26) To DS7PR12MB8371.namprd12.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: DS7PR12MB8371:EE_|BL1PR12MB5945:EE_
X-MS-Office365-Filtering-Correlation-Id: 2a975512-31a5-460d-1803-08def24b309f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|7416014|376014|1800799024|23010399003|22082099003|18002099003|4143699003|5023799004|11063799006|56012099006|10067099003;
X-Microsoft-Antispam-Message-Info:
	ZARgyfms6DfUb8F0jCvMT2HkFcM8S+RblCEnTZUdK5sTzhL6HJjh2nYLmjeBBghS3zekOnTjIS31UDN1xenBZxZiUQj58XHFi6I3cg9oFPdbdnHc3n7iGt9lsf+sy3/Y5sLhVHhI463MxvDq+UqK2R3CruFbZ36+OwIEqsa6YMt6Q7Rlp1wb7VGK95Cr2imAqHYgqPQLim87LG9PfwchAb8PWUZGtmY6PhtMiNOaP5Br+PLuRPHIWuyyiewGgfULHkR2Pv4zf7u1dIJ6PVOpRiRo1nyLGHwiMAlhP8qOdKyN53tAmTO10Yy7Hq0m63+wI4sarmF9UNqVMEt48MGuCS+LcVezFi3L3mjF0nZ1RTil4Nkx1swS0v1pbkQPXQ6ZhttUmI3cEVx4IIkR61qSGfrqJcnslYeWp0GjlgSVi/EBcoCdo/zVTInprgzn42CHh0C9A3/bDTqissFyNeQltmT8A8l/Rubevby9tWXfVASRvWMmxI/uxOqIfmsQcB6060fQZ5kDYmOLR46K0zTVjSekbevtupGfkYI2PpI/M3lmmRPpb7muKl6feOI/Fna2jhXUe1THUtgb3w0wjGYcBvA2MKXBFYdizz0XdBWn2jUSe8uyjquu3HIU8tXm+3blZQde3Y1bI9eZCe+hBrcJEOBYoOuhgaq79bISdAZSZnk=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB8371.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024)(23010399003)(22082099003)(18002099003)(4143699003)(5023799004)(11063799006)(56012099006)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Vm8yOERRZW9XdWQ5dU4yVXhCNEQ1ZzV2VGE2V3F6eTVhSFo2U2UrL2FkUTRx?=
 =?utf-8?B?NFRkZW5ydTZtZm55VmNDY1I1aHFXekdCNVBZaEd2SnNFRjlUSk4rOUZOR01v?=
 =?utf-8?B?Wkh6SHB6ZHdxaEVOV2NZenZuU1dmT0NoOUdHK0NQRXZlbDVOK0JNclc5RXZ2?=
 =?utf-8?B?WGZmaDBOTitFM3FvV3p2bC9taXZveTBxVC9CUWNibG1ueVVKQ0EzZC8vbG10?=
 =?utf-8?B?M1R6djdobjhPRTR1V1RhWDRpc3NWWi90K21laCtjNFMrQmVNbnBBdjlGR0N1?=
 =?utf-8?B?TGJ5bkdXOWJVdWxnb1FOUHZBQWRHZUxqaGdDd1pHUVcvbTlKclNaOFo5SWp5?=
 =?utf-8?B?MjFFdFowVlMzTk96YmZUTWhkd1ExcXZRenBxQllUdndFTElrZjRTRk9meERl?=
 =?utf-8?B?aGs5TndXUExkREYrRlk3ckQxZk1kYjZucUhxQmFGajhJdjBaSkNvcWZsWnNy?=
 =?utf-8?B?Z0U5cUhDNlR2L3dPeU9MM0xiNmxnYjRBV01ES2NkcDJscWh1eGlKSDRpajN0?=
 =?utf-8?B?bTZMWWFOMVU0TzhSeEJJSTVjZmNKaklsdHI5OW1lSWhLMWJOb3dsYndhWVJy?=
 =?utf-8?B?UDhDV3FBQzBaYk8wUWs4OHlHYk5iZnpuUjVVdTVQNysrKzlza3pQMEJtNnNr?=
 =?utf-8?B?MWUvUy8xUmZxQ2tDaTRSbHJuZUc3aWZiRGsxTWVmSXI1Tm53YkVGMU1DVWVC?=
 =?utf-8?B?S1lYUVZFWmJZNVozSlNRWlc4ZTR1R3M0RTIvcmw3Y1dNZlcxN1dFR1drUFNs?=
 =?utf-8?B?bE1KdVB0MDVxaE10TDZ2N2Q3SFoyYzNEZ1plclpMK1pVaGJScS8zbVdRV2Iv?=
 =?utf-8?B?S2w2MDJMdlRvL0VmTVV6V1doTmdsNk1qcFk0UFhsMnJHVDBVbWRCYU1CQmRE?=
 =?utf-8?B?RmdUV2xFY1ZUemtBUDJ4MTViZWVzNEJDTnlLRnRaZ3VLenNBMm5XaDFtdTg3?=
 =?utf-8?B?Y1pkRC9HN3d6UStWVlFlQzlWejR5TlVHRWVzbTFGaEJJVXFHa2g1TXpDNFRx?=
 =?utf-8?B?dlVnenplWG9ibloyMWR0Uy9oQ28zUGlqNWozZGZwemVLcmQxMk1ya2tYL1Yz?=
 =?utf-8?B?OFJPazQzcThVSTlZNXhjNTZITURjYmxBa3BocmR0ZDdmU0NEU2ptR2xlUTAw?=
 =?utf-8?B?Yi9tQjNtb2lJck0xbEZzVzlhNXMwQ3ZLalg0dW1iQTRrcXdjZTh1ZmtrQklm?=
 =?utf-8?B?ZEJZNVhsWGNyZURzK1oxcUdpUDkvaDF4c2tkczNQWHQ5TGJ0TmJUUzNyemY1?=
 =?utf-8?B?RGpQM3NTME03dHk3cWx5TnBjeW1oQi82MG1mdm5mWHMraXcvZkZSclgrL3Fn?=
 =?utf-8?B?a0xCRzVCUjZzSHM5a3gzek5GU0U4QjJTSTlEQWYxcFd6ZEQ0ZWVMb0ppL2xj?=
 =?utf-8?B?V29lU3FPbWtzU1F3aXVhdEw0TlpaMW5VVlhETzZOcDI5Tlh5VE1DbkxJNTJH?=
 =?utf-8?B?TVhHOC9GR3FTbStFZU5DaUZtQU10STJzclZwaTFZWTI0d09MS2tLRFhKdTZS?=
 =?utf-8?B?T0lDSTRxaUVtOFBkRUs2Qy9RMDdWOE04VUVGamdTQUZiUFk2aElSV1N1eDFm?=
 =?utf-8?B?R0ppQ296NDRKNHN0ay83aExiNHJpRjFGenUzSjNEMTdRUi8yVDJvTFBXaVdq?=
 =?utf-8?B?OXVYamwwR0JHdkVaSHllOUFrSHVGTS93M1JicjhWTHduVnpPQ3V0REd2QTdV?=
 =?utf-8?B?WGdLekZJVVJrZkNrY0lnTXpQV2hzSUJDRmFrQ0xRd1pzWk8zME4vOXEwbVhB?=
 =?utf-8?B?TE1KUzZ0bmdkS1V3Nm9GNll2b3o5ZWhtcFFhREFpTTVyUHgvd282cjkwRFRt?=
 =?utf-8?B?RTFqYkRRMHZTUGU3RXYxK05PQnNUNkxTa29JK3JxVllGU3lLeVMyYklEeERZ?=
 =?utf-8?B?L0RITnUrc0FIaEFqOXZPQVNLdCtxdzdlbGwwWHFaVU1EWWk3Y0VsQzZpTU85?=
 =?utf-8?B?ZmJiOUZiNnJocUNWUXB5NUE5MlhZREZHekFnNjV6QU9yQUc1d2lsSlEwc3Ev?=
 =?utf-8?B?YzYxcmhXQTc1aS9LbzBLTGpMLy83TTBCdDlzbURNcjJzNmNRajd2WFZsQ1Ux?=
 =?utf-8?B?Tlh5SmV5STBwV1FkZzJVbVI0Y05Va1g5UmlUVjNrQW50ZGM2QXQ5bUVnaWF3?=
 =?utf-8?B?cXg1QVd0SVIvYzN5U20wdm40NkZhVC85bmNyczY4dUdPZmVML3l1MmUzUGtF?=
 =?utf-8?B?ZkYrS1ZVY1JwOUxONFF1dzVkUUJYTWNwd01zODBQUTlwTEdyMUF3R1ZOTVZP?=
 =?utf-8?B?VElKMjl5QndlUldFRDcydkpaMDJzVmJyTWtiVzNDdlVCVjFhZDJHRnR1ODFx?=
 =?utf-8?Q?IcvmbrSvPTJIbM6GRG?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2a975512-31a5-460d-1803-08def24b309f
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB8371.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Aug 2026 17:09:48.7379
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BMyyt8eoB9jokY5p0pwBISKHYf0eKMNWMe6sdz4xe8viFd8YbLoDvyqWDFoReaTA
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5945

On Tue Aug 4, 2026 at 1:04 PM EDT, Jan Kara wrote:
> On Tue 04-08-26 11:54:41, Zi Yan wrote:
>> On Tue Aug 4, 2026 at 5:32 AM EDT, Jan Kara wrote:
>> > On Mon 03-08-26 12:56:36, Zi Yan wrote:
>> >> On Mon Aug 3, 2026 at 5:54 AM EDT, Jan Kara wrote:
>> >> > On Fri 31-07-26 22:13:30, Zi Yan wrote:
>> >> >> erofs needs to traverse readahead folios in reverse order to achie=
ve
>> >> >> maximum performance by
>> >> >> 1. reading all folios from readahead_folio();
>> >> >> 2. storing the prior folio pointer in folio->private;
>> >> >> 3. traverse from the last folio to the first one.
>> >> >>=20
>> >> >> Add readahead_folio_reverse() to achieve the same function without=
 using
>> >> >> folio->private.
>> >> >>=20
>> >> >> It prepares for a future commit that replaces PG_private checks wi=
th
>> >> >> !folio->private checks. After switching the checks, erofs's use of
>> >> >> folio->private without bumping folio refcount can cause unexpected
>> >> >> outcomes, e.g., in filemap_release_folio(), try_to_free_buffers() =
becomes
>> >> >> reachable.
>>=20
>> <snip>
>>=20
>> >>=20
>> >> The below is what I come up with. I did not add a bool to
>> >> readahead_control, since I think that is the decision of caller of
>> >> __readahead_advance(). But let me know if you disagree.
>> >
>> > The reason why I wanted bool in readahead_control is that if some code
>> > ends up mixing readahead_folio() with readahead_folio_last() things wi=
ll
>> > get confused (because __readahead_advance() really wants to skip the b=
atch
>> > returned from the *previous* call to readahead_folio[_last]()). With t=
he
>> > bool in rac, even mixed use will properly advance the state of the
>> > readahead_control. I don't think mixed use is very realistic (at this
>> > point at least) so I'm ok with leaving that for later if you don't lik=
e it.
>>=20
>> Got it. I am trying to figure out your mental model of how the mix of
>> readahead_folio() and readahead_folio_last() works with the bool inside
>> ractl. By looking at readahead_folio_last() code, it is almost the same
>> as readahead_folio() with __readahead_folio() inlined
>> (__readahead_folio() is only used by readahead_folio(), so the inline
>> can happen without any issue). As a result, we can get rid of
>> readahead_folio_last(), add set_readahead_direction() to set the
>> embedded bool read_from_head, and use readahead_folio() only. This
>> removes redundant code in readahead_folio_last(). One thing I am not
>> certain is whether we want to
>>=20
>> 1. use set_readahead_direction() explicit and warn readahead_folio() if
>> read_from_head is not initialized, or
>>=20
>> 2. set read_from_head to true by default, so that only erofs needs to
>> call set_readahead_direction() to change read_from_head.
>>=20
>> The former is less confusing but changes how readahead_folio() works;
>> the latter is simpler but implicit read_from_head state might confuse
>> people at some point.
>
> My idea was: readahead_folio() will call __readahead_advance() and then s=
et
> rac->forward =3D true. readahead_folio_last() will call __readahead_advan=
ce()
> and set rac->forward =3D false. __readahead_advance() advances from begin=
ning
> / end based on rac->_forward value.

Got it. I can do that. Just to be clear, it should be that
readahead_folio() first sets rac->forward =3D true, then calls
__readahead_advance(), since __readahead_advance() advances based on
rac->forward, right? readahead_folio_last() as well.

--=20
Best Regards,
Yan, Zi


