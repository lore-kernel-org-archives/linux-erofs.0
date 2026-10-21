Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCFC7606A319
	for <linux-erofs@archiver.kernel.org>; Wed, 21 Oct 2026 07:35:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=sony.com header.i=@sony.com header.a=rsa-sha256 header.s=p1 header.b=sPhA4aNy
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4j8h0T2H9Wz2xM9;
	Wed, 21 Oct 2026 18:35:53 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=fail smtp.remote-ip=185.132.183.11
ARC-Seal: i=2; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1792568153;
	cv=fail; b=RXcrQotq8GL7NvObftJjSyH7RBY+yDwVHKrivKbONdCx6k3ej8fffvakWnrc0Y2PHOQlmizYarud5Ex2rE+ykkiFV7QU84BEM6ajsA/Dmf00CEcYKgJntooB9lEt+5lB8Zysu1pXimn6/s0oyC1AB1c8fDGgyzPg++yCREaLsMCH1pSOk/hYG93hYRcbgJiIoXV4C/4D6CnzlRYQWMUPnEidlWD2IngLm5ZKlCWzrgCf5OkotRth9eMg7NMVScWuerdMQPoGhL7lx0BLDqz1I8tuP/aKNiEpnS4NQm0OgJevekBqgw0TSqfL9SnzFka8MFuQer3W4rOxRCSJGt61QQ==
ARC-Message-Signature: i=2; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1792568153; c=relaxed/relaxed;
	bh=G8xfMKK98aYesABSsQYuWb6g8cVVV2FBQ2hEXaZBvlU=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 MIME-Version:Content-Type; b=GH4ucKBdQYTNGQjNjOSiN9G5zNfzd48nRcMIvmStWRKpJM+C82zqcA+0xUdT21OEFOEYJB4/xozbaYaY6HJHCAPFcuzlNeFcuCeiikSUN1uFAUlF6D0T1kHd1fRq3+OJHoW3rZgNCgRfGosRfVr4oh5dA1Y2AuejzFnbLvxQaL70Cv11t5l0kdwv23e0YOET/ig8w7Mu+NROJ7GR4GZJiPjyJybvEU1y0tGJuvHpkkxnoFBvx6pT0c8DLFN6dVXlLzuigciK74vr+haTttXv4/Qbk8BNq/w2D/JUu2G5ympgm8576D2acRlEEA1Z4yFKuddmDDln7FGwRzgUZiJJNg==
ARC-Authentication-Results: i=2; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=sony.com; dkim=pass (2048-bit key; unprotected) header.d=sony.com header.i=@sony.com header.a=rsa-sha256 header.s=p1 header.b=sPhA4aNy; dkim-atps=neutral; spf=pass (client-ip=185.132.183.11; helo=mx07-001d1705.pphosted.com; envelope-from=friendy.su@sony.com; receiver=lists.ozlabs.org) smtp.mailfrom=sony.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=sony.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=sony.com header.i=@sony.com header.a=rsa-sha256 header.s=p1 header.b=sPhA4aNy;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=sony.com (client-ip=185.132.183.11; helo=mx07-001d1705.pphosted.com; envelope-from=friendy.su@sony.com; receiver=lists.ozlabs.org)
X-Greylist: delayed 1044 seconds by postgrey-1.37 at boromir; Wed, 21 Oct 2026 18:35:50 AEDT
Received: from mx07-001d1705.pphosted.com (mx07-001d1705.pphosted.com [185.132.183.11])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4j8h0R03swz2xLt
	for <linux-erofs@lists.ozlabs.org>; Wed, 21 Oct 2026 18:35:49 +1100 (AEDT)
Received: from pps.filterd (m0209327.ppops.net [127.0.0.1])
	by mx08-001d1705.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69L5jAsP3205808;
	Wed, 21 Oct 2026 07:18:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sony.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=p1; bh=G8xfMKK
	98aYesABSsQYuWb6g8cVVV2FBQ2hEXaZBvlU=; b=sPhA4aNy6WSDk1jynUM7K+E
	1qNfmSuleeJdP+/4PzP8uu77lluN7pxwWEjnmFzV4dHCZ7Jak3/tQZ8u62r+tvi/
	DZGy+hP7V+yFYndf34fqEuehtWHyS2Z8VHRkkoByxa3YlmJTXKYTOe4DFYR2XnQG
	VaCji6cOXuqayeT8gS/hqirx96yc/j789uvQxdPUB/tmgT8MHxfg+Hzf6VPnp34+
	uw5623mNq7KqCW+Qwor6X0TFWAV+khYcVlOamVgiK9r9+AUYePdUx3C49MRc8ReU
	Kk6RcgkDoJLI8+QSru6UqUzbwfo03BH0bffOdS4OVNnmir8AIjZhkGabZkE9C9Q=
	=
Received: from typpr03cu001.outbound.protection.outlook.com (mail-japaneastazon11012066.outbound.protection.outlook.com [52.101.126.66])
	by mx08-001d1705.pphosted.com (PPS) with ESMTPS id 4hdw4wsv82-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=OK);
	Wed, 21 Oct 2026 07:18:11 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UsAOzLCQCK6BBMbbZn7NInjL7jleRJQA4pX1DfzEsxYMNjkfomJutxSriP7XU/rf4e+Tinn+TyPv4cw8G2EzzNi8Ak6J+h2kukH0hpRhLQZfGZsLXqYADm82pwKUxGA128QdadjkphmbFpB0SV1w5D9vZ7w7RtziaKJ4bJQ0XDvwDYtufO7XGDoHVCRvs7RC8PRveqFxPtzdPiAF3ezTRm2lvhQCCLuUWshh7ADuzezR/GUM5dD7U/gvdnbgOGRB4y/kiGsX90CxSsxbH+4OGVX0u2cP2qBxT1OIpCGdWr2DKgMerwvB5a9h+UT95SBi4V2JqnEWIja+xxoa6ardDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QwfYiUl2w6xvZyQZJonIjB7lrIWX+OJHTQU52/5UQAE=;
 b=uTT7xq6QzmeJaUXNm57qATzKvr9A8AS4rOvfkWTi7ABUrKT4FCdzmqKzq6b+bNY5vqJ/fWtAKN6b8zojbygbPGkCWsk99E+YxeEhFGyCqmvDEtUy+sv+i4+5iy3j4g16FKSRcHu1ulYo2oUxqTx024iBOa42qwBuRC1w0KynmbiKFBnAIBDgffaDv2MWXzw8kqLuNI1/Ing+/jHim2kwtc1xwM69Bi1CjN5JPZs9pvdH6viy5Bp/vZmBSJUiNgs3DC6TzzJXd2ICOFeGe+5tBci3YWSjxT2FyzthXhpQXgil6zYDVnaL6XZl5wK6GbO9M6mY6mhvE4iBo74sySHV2Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=sony.com; dmarc=pass action=none header.from=sony.com;
 dkim=pass header.d=sony.com; arc=none
Received: from TY0PR04MB6191.apcprd04.prod.outlook.com (2603:1096:400:32c::12)
 by KUXPR04MB8962.apcprd04.prod.outlook.com (2603:1096:d10:4f::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.522.19; Wed, 21 Oct
 2026 07:18:06 +0000
Received: from TY0PR04MB6191.apcprd04.prod.outlook.com
 ([fe80::aa83:1e3d:19d1:736]) by TY0PR04MB6191.apcprd04.prod.outlook.com
 ([fe80::aa83:1e3d:19d1:736%6]) with mapi id 15.21.0546.012; Wed, 21 Oct 2026
 07:18:06 +0000
From: "Friendy.Su@sony.com" <Friendy.Su@sony.com>
To: Gao Xiang <xiang@kernel.org>
CC: "chao@kernel.org" <chao@kernel.org>,
        "linux-erofs@lists.ozlabs.org"
	<linux-erofs@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>,
        "Yuezhang.Mo@sony.com"
	<Yuezhang.Mo@sony.com>,
        "Daniel.Palmer@sony.com" <Daniel.Palmer@sony.com>
Subject: Re: [PATCH v1] erofs: enable SB_I_ALLOW_HSM to support fanotify pre
 access event
Thread-Topic: [PATCH v1] erofs: enable SB_I_ALLOW_HSM to support fanotify pre
 access event
Thread-Index: AQHdWJvRBJXrCptv4ESQoyx5nwPYULb3ST8AgAH8ibE=
Date: Wed, 21 Oct 2026 07:18:06 +0000
Message-ID:
 <TY0PR04MB6191A63F6B79E4109D185F41FD9F2@TY0PR04MB6191.apcprd04.prod.outlook.com>
References: <20261010094000.2036805-1-friendy.su@sony.com>
 <asqsNhtlXaEOrEky@XiangdeMacBook-Pro.local>
In-Reply-To: <asqsNhtlXaEOrEky@XiangdeMacBook-Pro.local>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
authentication-results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=sony.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: TY0PR04MB6191:EE_|KUXPR04MB8962:EE_
x-ms-office365-filtering-correlation-id: d51025af-1196-48bc-224e-08df2f4373d5
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|23010399003|1800799024|366016|10070799003|376014|38070700021|4143699003|11063799006|56012099006|10067099003|261009223027099003|22082099003|18002099003|4133799003;
x-microsoft-antispam-message-info:
 F/UJo2GN1iPViYz+lyNu2j/7k8LGGW+rWK992lx2ozqawJx5JYYtUCc6wVVThJM0ApE5n538Q/14Wv5LZUzb04MZ+m7mqJs5H5yqYsgYyObnGx54PafTtmxOLfgPxj9KyEeaZ3sU3DnJNwovXJCqMKzsW17MqC9C/9nVAiIIFJZTYIDdscKZ1/XqIpaytKpIvhq0vTffoOVh8gxJ7JN9FLJXk3NqmeSkpw1w88W1ASOdbWOPdbHIjRx+GaVLv+VDFK1lqiQD5l/e2Pmn5J7Wq8f3tSaroCfS7amLqQfp8Xu+1Kw41ZI5ezPK1xWV+XD4Xbe3VPhU/orNwl5NUA1HdflR7ULSi81Nc988+gcuheoQJlbbA3M4rTwyfVF0wJAFSV65IZ2yA7Gh6ysXbeFhbyVTgFftbnek1ZBPFw/15oRyxoMr8yxDeXrtAJMG2YOWHhR1ddgK+LzTjqGrDcTOOQ9RIfZzHV5rSgf5LGIilB1DnMlWAzcJUIFaRWTNhq+jsUpljB8rj5XsczS68HQlBZAVrDI/blDtJuEQMn0JXavOsbXb4Uq4zYty0riUUvaxEU1LBxr0IeMd1CLUzdLoRjAPPwVNeVoPsJI5d0lv54BchhwMT+XrCpyFMPTR4HGHWx1P2P6MEBbF1C9lwaeDrKcK4u73RmZl1y+xl6wIrQwCAN3MpSD8O7V2tN9IIat8
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TY0PR04MB6191.apcprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(366016)(10070799003)(376014)(38070700021)(4143699003)(11063799006)(56012099006)(10067099003)(261009223027099003)(22082099003)(18002099003)(4133799003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?MXJic3RTcyt2d1Q1TG1mQy9WWjJrVUc5MUZiREU0d0xlYlNqMlBCMml0dUlo?=
 =?utf-8?B?K0FPcEVGeWhWMXcwRitXcmNZTitudUJvVXV0WHgzTmFtLzIvaXF2UHlVMlhD?=
 =?utf-8?B?eVZFWlQyTkUrdW5ZNzRwL3FUbjg1N0JQS0lhYUM4YnJ0bXVJT001YlVoR3ZE?=
 =?utf-8?B?QUtqclVWbXlrL3ZYTmRMVEdKZVFIUCszL0hlQTRUV244RDhiVTBkalFOckJz?=
 =?utf-8?B?eDVGV3JmeEtFM0xRVzB4Ni9WZWxxN1E1NXRhdHF6SXZrZHU5VGdHVEpUQXRl?=
 =?utf-8?B?dVBuWUpwRkZ0cTNzVUk2cDd3RnJsRUwvTDNRQ0l1SFdORVlDa3h5YXBqN1dh?=
 =?utf-8?B?YjVSYXdqZHB0MkNNeHpUYjlobXA0RWs2RWxpSUJiUFNzSDVhUEFHS1dRVVd4?=
 =?utf-8?B?NUxKbGNqOW43ZHJrcHJJRFl5OE90bnBEQW5hUFM4a2J1cUVld3U5UW5YeFdK?=
 =?utf-8?B?QVRxOG9Ydzc0eXFiV3FVNDBPSlRPZnphY2NwaHd2aTdPWVJNMXVaS2lsTklT?=
 =?utf-8?B?dUMxbEJqRWZrSWI2NlkzM2pQTVk0M205K2dnZGFQSWwwVlhPemlyeHFLQklm?=
 =?utf-8?B?bTRzR2d1b0RyNTVjTE8xeThQZGVobW1vNTB3aXZXeVpQTW01VWlnRnB2Ny8x?=
 =?utf-8?B?em5YNGZIRENXL09RbCszVXhJNlU2Q1hzcFc2R0dQZmJsbU8xVHJ3NzQrZnlD?=
 =?utf-8?B?TDRTSlQ0NHRWRG1xRmJ2K0pjbkNqWVYxc3RmSUgyS1QvWkNqNStSejBsaEd3?=
 =?utf-8?B?ZVlZOGlxaitySXB3OExkbHZ5MVhiVXd3RkFDckhhMUd4ajdMZ2xON1BYUStX?=
 =?utf-8?B?ZThQODYweTcrbXE0MUNkT04rTFVzbnc4dHpJaWRzeTdOejErei9PaWdSYmdi?=
 =?utf-8?B?Skp2aFB0NTFkcmJFck1DbWd6N2luV2ZKbzFORHJVWFEwSytIOXQxcjhId1dx?=
 =?utf-8?B?dDZ2Z0hYeUQxcS8vVEswMkM2VFdYaXRzMWxZWU5XdGJHUFFQVEdzZDN0bkds?=
 =?utf-8?B?UDM4d3NoeE1oVFhLZ1JOVmZld2l1QjhNdTdzbHpjVDhtNzBUVThuRkozdmI3?=
 =?utf-8?B?eW5iUkdLRzF4Mk9mdGdCZldXYWhCd25lMGZpT1oyc1dvK2RJbDZCNFBadnZP?=
 =?utf-8?B?V1o1YkJ3SjhKN2JBSW1wcVpWNFJHNmdnTWh2NnRQMFNOTDZWZEhNMDB5RWVv?=
 =?utf-8?B?QktOdWM5amVuaDNWaFFtM1JnaVkxMTNQWGllZ2MxUEttVzFGeS9mb2hZQkZS?=
 =?utf-8?B?Vlp6djZZWjRvbEpvR3VKNElKV3JwMXIrcmhWYTFkR2gxckVxeTZYSnYvTFNo?=
 =?utf-8?B?cXNzMko2OVRtNXMzYW1LVUZTbTZwZ3lNMHJIYVY3eWI4NSs0c1plRTRwQlln?=
 =?utf-8?B?M2pRUnlBTGFCOGdKWkZzRkd2UitOOU91Y2d6TnV6VHRyME9lREd2REhBR0Zy?=
 =?utf-8?B?ODhJZzcyaUMyZHk3ektZb2xoZWNDZE1MRFpmQ29EUzNWaTB0WHNidXNESWJ2?=
 =?utf-8?B?dGg3b29QMFV1OUxvWDhlT2diZTJUVnJRVitwd0kwZklOTTB5N1paNHZFSDVy?=
 =?utf-8?B?c0JmcDBWL1VTS3ROTVV4alNOazd3dFMrSjh3VnRYRU5NREtaRWNMZUVVbFlF?=
 =?utf-8?B?NndsRy9OTUJiVWtQR1FwMmFVcmdSOUZDOHNLRmZZMHBaMUZCWXlMU1J2K1Ux?=
 =?utf-8?B?MmRuMW9hVU1hY2NyY2lXMUR3QWpyelVPN2tnc3Y0MHlvenhpam5PcmlqcGR0?=
 =?utf-8?B?TC9vMjNuUzVMVTFDTVlqMlpXYkh3K1plTE5na1JUanZmbktUamdHMlc3YVB4?=
 =?utf-8?B?b0NBK2F2VGtUNUpTZlNJdDZITGt1Yy9ObThxb1BmRTdBcWIxUGhaUWZsalFZ?=
 =?utf-8?B?RVJBYkZGL1dadkhmVHMvcHNqOHg1d0VLT0Vudzd5Z2ROVzYyM0F5ckMzRVp4?=
 =?utf-8?B?WXBHZFh1UlF3RkRVNzk1T1BJczVacTBTWmdyVkt2VWVBREYzUmMzMmNhblRo?=
 =?utf-8?B?YjVBemoycWo0cUd4TldpT1FtRXhDRUVxU0MwUnh0VFJnWkhhZkR3bFpxRWt1?=
 =?utf-8?B?L28zSDlRbHk0cEJnMU9UYmZNTlpHUGFNdVBUaDU3dCtKaFlEQWRVS1FOTERZ?=
 =?utf-8?B?c1o5Y3Q3TzFhVFlJb1AzNGE2L3hEVDJRSXB5UDRvMlJUTTBQMUlnNDJzVkFQ?=
 =?utf-8?B?QTRIbnBKVGNWVnByRlJMMWY2RjR6SjBTKytFUzAyYTJVVm9tUGhQT3RtWG9v?=
 =?utf-8?B?KzdLc2lpL2NKWTBnRFZKTXEzY3JBQ2U0OVBVUjhZR0FUV3hGaWlxRGR0d2RP?=
 =?utf-8?B?VUc4cStDdktXckhvR0pqQ1kyWGtuckpCVU8wWnRBTTFUYTR0SjdCTGN3Tmpn?=
 =?utf-8?Q?03PDvych2DhU9Ijo=3D?=
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
X-Exchange-RoutingPolicyChecked:
	YzKO0/mbvRISlNCESfDOtu129lqHZoweQyBiMopQcKDNer0hE93kBfDv1SyZonZCJ6pQrBRoal9CUEql/9cdaEfigmJXtrJcpCnL2IGXeCvmThMpA5oYkUeqsNiztsNCb0VkB1icfyyrP1GdrpDktFeOOC2GKzpgPRG+sXTatREbeXqQVm4LKyJuM3eIfdcwiRM1+A0OJrQ6T9nKsWz539/BsSPL23ULFGoaflvn5FGsh0LejKYrAJ6Wa537uD+q92YqZwK8GK0QIv7BIN+haOvfbQURpx51/TUGUlH8YSAYqI9kdqWaFO+sNKsJG90P8Q3tQokaVmMa6DpAWuKEbA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	NVBIYFrEuX+AU1UWDldUzhqAGlVUUzF5N+cfM4Gpgy5lj1c38Z9xo0o97/bDl1NeXQdm6grdGQoLf2x9ql6xji1SRrssfEQC9+NSB1VKkgWuA8PNIruqlvrn0Tl4M49pxxRkMpHUJ2Y1ouWjgmQmocvmkXchL7DR78FNzjTNwib0gXUDPCYotc24y/pNxgKDz8SGR5vN0vi2yXIZWEpnEUITshb+arhv4lzqEZh3FyF4YmoZP5Xc+JGpiPX03CULz86Xzucy5mBVkntn4v9gynDLBNC2WFWVCdd4EATiFjyEtXbHq5VoIzPjrsn252/jFv6KQUJUSCSUSJbyI1jijBbMzbCiB1d4Ul6FIv5d2iTBikOyC2sUZhPL663gYGNVui5vyaUuDKsp9iOHfAXbeBBzgjh5Qk6cq/8VOcFCLjQ4628SNKK+IZ61tzzy2lY4IOxBsML7RdYFtSv92IxaWBH4quyH2T4HCRgxq5wpuwcwbGtJvjNsisxBLaUQCiz5QjctJSyc9WCh4SSlVnYzp18yFiya3ej2CRDcU4ABttfa7jDjar8JLGdiU1svW7tuOxdCPCvJCpY3IIWV7m4moPmWyb24CDl0W/2+U3gmzUuefq3NPcTnrYkfLxIIXkzH
X-OriginatorOrg: sony.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TY0PR04MB6191.apcprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d51025af-1196-48bc-224e-08df2f4373d5
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Oct 2026 07:18:06.2187
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 66c65d8a-9158-4521-a2d8-664963db48e4
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: O3Ajok23vuYcXnEkLFRtMBHlDlMjzNHwmG+NgkKfvhJohK9O3UItmGa8LxeXfQnAhevWO1Br1usJvotKFO4hGQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: KUXPR04MB8962
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Proofpoint-GUID: uJfUFCh0mn7rFyQNP0X6ngeidueC4sBA
X-Authority-Analysis: v=2.4 cv=IdkSymqa c=1 sm=1 tr=0 ts=6ad86733 cx=c_pps
 a=xC75tKMPMVex84EOQo1/1g==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=660iZSQnnn4A:10 a=7j0FZ4iXMVMA:10 a=xR56lInIT_wA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=KAb5x4SsHD3PzxGk7EmX:22 a=b20fedWF67CaGdYoUt4Y:22
 a=VwQbUJbxAAAA:8 a=iOHNgrcOAAAA:20 a=voM4FWlXAAAA:8 a=z6gsHLkEAAAA:8
 a=A1OA0lEPbZMAvFa-fiEA:9 a=QEXdDO2ut3YA:10 a=IC2XNlieTeVoXbcui8wp:22
 a=bA3UWDv6hWIuX7UZL3qL:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDIxMDAyOCBTYWx0ZWRfX/OirJB213su8
 sWkhfZvMJ0FZ9tNHWsb8bh4AtoLz8uz2dqS0vg1y0JD6QDh+b0jTCc5fsXTAuhMQ74EI3PD2eIW
 mBEn/RNiRYt1ZdPz4d0bKfoILgyj9vJeZfF66SjOKFXUqxUadxDgVi5lbM/ZTiCaR6s5AytopPj
 /k2qBRoQQPfmlnp41nGT4tUNsfuoCX+kpTYhT2ScrYPW3cjR3re+pEYqurKdHfwLWUSaVaXsRgT
 d2AawycoqKelXFJlpCPthSp4VQHXqg49ln1B6NRFYJSR9djJzokHuX61aNx7ICl1FFVaVs859gL
 zjjoUaF919IjQLVHI9IoyOEKw5D0aqTmUhC5xuxutB7EYA6oqegfq463aTv6jkvYZViY4+aOugv
 vX//S88+pdNDqfb1pGGqSqyS3r2Rjh4rAqTUbzS3RAImVzoe7Iut0qiU1J9o6RyqPBWvkHZFA+U
 9HRtpsDypLf3VChFaew==
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDIxMDAyOCBTYWx0ZWRfXzG3+KRU3Mpul
 t/MItCWQQkIIZHCp+dGv359Bc/SNJJC1uAWs7nskY4Ep1COetSvdvvTUqdYrYqCuq3heZtC3X2z
 Gj0C1gb6NDLkxMglakVy4vuBeAR2c2qqGRy4Ca/ILwn/MtNzxQwT
X-Proofpoint-ORIG-GUID: uJfUFCh0mn7rFyQNP0X6ngeidueC4sBA
X-Sony-Outbound-GUID: uJfUFCh0mn7rFyQNP0X6ngeidueC4sBA
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-21_02,2026-10-19_02,2025-10-01_01
X-Spam-Status: No, score=-21.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Gao,

Sorry for late reply.

We have considered fanotify in erofs-utils. I think it must be used with=20
file-backend mount. It actually utilizes FAN_PRE_ACCESS on ext4 or xfs.=20
Also file-backend mount can not support DAX mount.

But for our case, file-backend mount can not be used. Firstly, there is no=
=20
ext4 or xfs file system in actual environment to put a sparse erofs image=20
file. We have to mount a normal block device. Secondly, mount must be DAX.

The basic flow is file content is fetched from remote then filled into=20
local erofs file on the DAX mounted block device in FAN_PRE_ACCESS handler.

"/dev/loop0" is just an example, not our actual use case. The actual block=
=20
device is something like /dev/pmem0.

In order to make SB_I_ALLOW_HSM only set under block device backend,=20
we can do like this:

if (!erofs_is_fileio_mode(sbi)) {
        /*
         * Allow HSM to support fanotify pre access event
         */
        sb->s_iflags |=3D SB_I_ALLOW_HSM;
}

How do you think?

Best Regards
Friendy

________________________________________
From: Gao Xiang <xiang@kernel.org>
Sent: Sunday, October 11, 2026 5:20
To: Su, Friendy
Cc: xiang@kernel.org; chao@kernel.org; linux-erofs@lists.ozlabs.org; linux-=
kernel@vger.kernel.org; Mo, Yuezhang; Palmer, Daniel (SGC)
Subject: Re: [PATCH v1] erofs: enable SB_I_ALLOW_HSM to support fanotify pr=
e access event

Hi Friendy, On Sat, Oct 10, 2026 at 05:=E2=80=8A40:=E2=80=8A00PM +0800, Fri=
endy Su wrote: > This patch makes erofs support a use case below: > > erofs=
 file data are not available at local, but need be > filled at fanotify pre=
 access event handler.=E2=80=8A


Hi Friendy,

On Sat, Oct 10, 2026 at 05:40:00PM +0800, Friendy Su wrote:
> This patch makes erofs support a use case below:
>
> erofs file data are not available at local, but need be
> filled at fanotify pre access event handler.
>
> E.g. when format erofs to blob mode, meta data image
> is store locally, blob image size is big so it is stored remotely.
> At erofs mount, a loop device based on a sparse image file is
> used as blob device. The sparse image file size is equal to blob
> image size. Like:
>
> $ sudo mount -o device=3D/dev/loop1 /dev/sdb1 /mnt/erofs/
>
> Then at file access, need retrieve data from remote, then fill
> into sparse image at FAN_PRE_ACCESS event handler.
>
> Signed-off-by: Friendy Su <friendy.su@sony.com>
> Reviewed-by: Yuezhang Mo <Yuezhang.Mo@sony.com>
> Reviewed-by: Daniel Palmer <daniel.palmer@sony.com>
> ---
>  fs/erofs/super.c | 4 ++++
>  1 file changed, 4 insertions(+)
>
> diff --git a/fs/erofs/super.c b/fs/erofs/super.c
> index 0967aace9f7f..b92d3353319d 100644
> --- a/fs/erofs/super.c
> +++ b/fs/erofs/super.c
> @@ -659,6 +659,10 @@ static int erofs_fc_fill_super(struct super_block *s=
b, struct fs_context *fc)
>       sb->s_maxbytes =3D MAX_LFS_FILESIZE;
>       sb->s_op =3D &erofs_sops;
>
> +     /*
> +      * Allow HSM to support fanotify pre access event
> +      */
> +     sb->s_iflags |=3D SB_I_ALLOW_HSM;

Did you notice
https://urldefense.com/v3/__https://git.kernel.org/pub/scm/linux/kernel/git=
/xiang/erofs-utils.git/tree/lib/backends/fanotify.c__;!!O7_YSHcmd9jp3hj_4dE=
AcyQ!3EhQW78Lg9hjdjMscHBj-V19jmMX6nlYdkPVufSmwLJEM5yM0uTCOLuqwilIL3MGLDqMV8=
LkNo1Chg$[git[.]kernel[.]org]
?

I am not sure why EROFS itself needs to set SB_I_ALLOW_HSM because EROFS
is an immutable filesystem, its data should be considered as a golden
one and it shouldn't be partially filled.

Instead, SB_I_ALLOW_HSM should be set on the backing filesystems (ext4,
xfs, ...), and if I understand correctly, combining EROFS file-backed
mounts (pls don't use loop for this) already implements what you said
above.

And this functionality is already released in the latest erofs-utils
and Nydus v3:
https://urldefense.com/v3/__https://github.com/dragonflyoss/nydus/blob/v3/d=
ocs/fanotify.md__;!!O7_YSHcmd9jp3hj_4dEAcyQ!3EhQW78Lg9hjdjMscHBj-V19jmMX6nl=
YdkPVufSmwLJEM5yM0uTCOLuqwilIL3MGLDqMV8IXHHnVqQ$[github[.]com]

Thanks,
Gao Xiang


