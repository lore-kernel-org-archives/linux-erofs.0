Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05BDE606A31A
	for <linux-erofs@archiver.kernel.org>; Fri, 30 Oct 2026 09:22:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=sony.com header.i=@sony.com header.a=rsa-sha256 header.s=p1 header.b=QGIK6BtE
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4jGFxf41zpz2ySc;
	Fri, 30 Oct 2026 20:22:46 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=pass smtp.remote-ip=185.132.183.11 arc.chain=microsoft.com
ARC-Seal: i=2; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1793352166;
	cv=pass; b=iynwzxe7RoPtALthOJlSAauFkusViD+DiK15Vk6mMcr8Du07l0W7L2kb8Fg+3K4G9cD9tmDmSst7EOlEK3n73F+fO7/WUE37ygLO3HEy4Er1ylVsvx8fN4Y7Pdn1ZeNheeV8EHzTviKEaKIlXHb1w7YIFiKkGXxU3AXXaaR3wrfgZ8/SJPzfHvREv7EqZkY4vdiI5byJ1GvxkWdyjlc+jSBMHsE2bPpgAtuRyJfAIdL6Y8vP9mUqlce8gfYj3/4tmlC7MiWKbJbkkYRe4nOuFvMOcMitFAWpcG6FpAV57lFZXGyQnwaS0+7RO7Qpndqpl9g7Z1joS4Bhv8yoe+SrbA==
ARC-Message-Signature: i=2; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1793352166; c=relaxed/relaxed;
	bh=jQ7s631tnZckzrkThvhxQc686kOpqmB0HR+63ujVO3o=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=ZTyz3lffGMIAW4tuTBdNgZlEBE44yry4YXI9S56ajRrK3E+F3+xkpoFCytc5+nTiWg/lBgUmw/YR+N6QKayXFmMMzxFO9t38eHY8cAtgYi6HViFq1pMgdiNZxkhuDpC2T8kqtpmDhJ2KUHboXT+OHZRDPMkRxdQ5W2CUF7ve7gVPqf+5xoiWRizE46nNSzgieF/9Ww63ZdxqoF6lNVYdZVQCEk0rLogiEj72KEhYbh6xKwBxh9IIJTxLOZaSXpDiY8TyJsne8U4+Rsl8KFekYTlBrRyUIc6BfGAKaEZ6RFFerEINx+Gav2K45i7zc/I/K8PzyrXklKhUgJBYH/p/2A==
ARC-Authentication-Results: i=2; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=sony.com; dkim=pass (2048-bit key; unprotected) header.d=sony.com header.i=@sony.com header.a=rsa-sha256 header.s=p1 header.b=QGIK6BtE; dkim-atps=neutral; spf=pass (client-ip=185.132.183.11; helo=mx07-001d1705.pphosted.com; envelope-from=friendy.su@sony.com; receiver=lists.ozlabs.org) smtp.mailfrom=sony.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=sony.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=sony.com header.i=@sony.com header.a=rsa-sha256 header.s=p1 header.b=QGIK6BtE;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=sony.com (client-ip=185.132.183.11; helo=mx07-001d1705.pphosted.com; envelope-from=friendy.su@sony.com; receiver=lists.ozlabs.org)
Received: from mx07-001d1705.pphosted.com (mx07-001d1705.pphosted.com [185.132.183.11])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4jGFxd0wbWz2yFj
	for <linux-erofs@lists.ozlabs.org>; Fri, 30 Oct 2026 20:22:44 +1100 (AEDT)
Received: from pps.filterd (m0209328.ppops.net [127.0.0.1])
	by mx08-001d1705.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69U8ERYd2982238;
	Fri, 30 Oct 2026 09:22:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sony.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=p1; bh=jQ7s631
	tnZckzrkThvhxQc686kOpqmB0HR+63ujVO3o=; b=QGIK6BtEwfT2CMkF0a9u0WX
	LtmJ7YzS4yq+fP/hJgpRMkiGMcEsa5C63raF6SC2ArXxJI+K7Ra5gev/KTza+fsw
	E+JjFzYOzk6BtorsmWFg6sNqJLCtAmB75VCvn5fx8uzEVzNzDewPyJ9Td+VU9udg
	AyfVDAwweG2gxZ7F7hQ7KPnYzCZZDZho/Nx7JaOqRbLxyNgred3y0g5WPG/E/Gjc
	x/JKfjM96uBU6PIU77WKHNTDPnFAS1dSpcX5005FjZsnkgt+etbGFF/uh3TTicXm
	wYh0FLwagMsvymb+pIEkDMlUJC69AGfj+NWIcZ2rmVNiqsVU4NmQLG6MDv+Hrkw=
	=
Received: from seypr02cu001.outbound.protection.outlook.com (mail-koreacentralazon11013029.outbound.protection.outlook.com [40.107.44.29])
	by mx08-001d1705.pphosted.com (PPS) with ESMTPS id 4hme60rsus-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=OK);
	Fri, 30 Oct 2026 09:22:16 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=y1iLOqb3j38wqhe65s0F5Z9pQxhC5xyQWtyEnRqH4T5NZf5nAyY8PISAGVwt9vYoGSDhAJzcig1SX9suKXkMh4SoXsCaYffu8ue+5nFlCRp8aHIrzvnZAmpvG+Mi2SJkVqp5SluXaVw25zAXYNkPqpPtz6mmIu08bz+hKpmPQTzEGltwMF95wokbbRvwcn0LvyU4RSmeauGInuM7fuEoTd/yU0LyLiASok5T4HVJ83x009gTiSPZVW4SpTX57Nq5do5eHIOSe+II+mlqdeGKrowMTsHtSXw7CHPWY8yflHlw6zWigxvkvChfbarR6SJlKJWdxNi6aAnMGAodqCDmuA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jQ7s631tnZckzrkThvhxQc686kOpqmB0HR+63ujVO3o=;
 b=HrVIVEGvLkUtFCnuMmsEy547tmlZ2Gbkr7zdiYw/ScJeRL0CTYA2AHyKfKJtglVb1+v3gEuhX/FT2G2pQ4FqQBpNLJANQV0YDsBGb2FM8q7gsLIiLnzo5ngCYbV70gfaMqroeZbKliXiOGgVJVVMzs8VBZjXelnXlvF5oJOZqBjzEmNvH28KtfO7PMi8iQKrh9P2nFB4JbzFr8c1nctO+5ib58fq0NoO7GqhbDSnClr001a0JLEFdD3NiqkRZ1NA/A+c+IP/NkOnyCfZDL8g+3cUcb7514McrtHZKI96dk1TElSSwTPc2P8G1Zz8np7MEOWIiCwmt1lVlFrEj2tLgQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=sony.com; dmarc=pass action=none header.from=sony.com;
 dkim=pass header.d=sony.com; arc=none
Received: from TY0PR04MB6191.apcprd04.prod.outlook.com (2603:1096:400:32c::12)
 by OSQPR04MB8874.apcprd04.prod.outlook.com (2603:1096:604:426::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.569.9; Fri, 30 Oct
 2026 09:22:10 +0000
Received: from TY0PR04MB6191.apcprd04.prod.outlook.com
 ([fe80::aa83:1e3d:19d1:736]) by TY0PR04MB6191.apcprd04.prod.outlook.com
 ([fe80::aa83:1e3d:19d1:736%6]) with mapi id 15.21.0569.008; Fri, 30 Oct 2026
 09:22:10 +0000
From: "Friendy.Su@sony.com" <Friendy.Su@sony.com>
To: "xiang@kernel.org" <xiang@kernel.org>,
        "bluce.lee@aliyun.com"
	<bluce.lee@aliyun.com>,
        "jnhuang95@gmail.com" <jnhuang95@gmail.com>,
        "hudsonzhu@tencent.com" <hudsonzhu@tencent.com>,
        "zhaoyifan28@huawei.com"
	<zhaoyifan28@huawei.com>
CC: "linux-erofs@lists.ozlabs.org" <linux-erofs@lists.ozlabs.org>,
        "Daniel.Palmer@sony.com" <Daniel.Palmer@sony.com>,
        "Yuezhang.Mo@sony.com"
	<Yuezhang.Mo@sony.com>
Subject: Re: [PATCH v1] erofs-utils: tests: add test for fanotify
 FAN_PRE_ACCESS event
Thread-Topic: [PATCH v1] erofs-utils: tests: add test for fanotify
 FAN_PRE_ACCESS event
Thread-Index: AQHdaE/aHyA2Rzhm3kKZPXP4YBkgWrcVz4IX
Date: Fri, 30 Oct 2026 09:22:10 +0000
Message-ID:
 <TY0PR04MB61915C09A76E5B2F432EE7A5FD6D2@TY0PR04MB6191.apcprd04.prod.outlook.com>
References: <20261030091713.101900-1-friendy.su@sony.com>
In-Reply-To: <20261030091713.101900-1-friendy.su@sony.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
authentication-results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=sony.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: TY0PR04MB6191:EE_|OSQPR04MB8874:EE_
x-ms-office365-filtering-correlation-id: 613b9681-9052-4c65-dbbd-08df366746b2
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|376014|1800799024|23010399003|10070799003|366016|38070700021|56012099006|11063799006|261009223027099003|261028144727099003|261022115727099003|261021121427099003|261022105027099003|261026121527099003|261022075727099003|261021123027099003|261026140227099003|10067099003|22082099003|18002099003|6133799003|3023799007;
x-microsoft-antispam-message-info:
 6dZlAF8u1hDeobutU2wf1b2lTwT5OO3LTBd6xFIsbPIaZ9QlLwlchL5fj0aeAhlW0bLMcNiU0WS/EgaPbhaRGHZPT1xqEJ+ti1KVxpjTrdQbrm3tJGVW/vqq29dSe8xUrjaA3B8h5lNBY/saQBykAULW4eLwC41rVPTZ4ldEiBa+zXs3R0kGF+RJOjXJrex84RGmVI3z6hxg0nBNgw4fo3yfx0RxTLsHBpirbTiviYx/RpXcA7vwId+dNMonmrsOAXSHNmh0GFD+wwyn06NFjCEOqa5Yg9u45DzOCRmRWhNxwBdMLzbS2ArMtyAloFuGSmr2LQ7C4cApLqHZXfXq+DDg9vjl5AZ+2CyT9YYuHnpoKxSdvmTg22wRdQh8cLSS0zRFa+5JiQqTMPSYBwEOj+GF5C8Gp84gqlqFA9kmrNUn008+KaEyJY8x6KTKPxBzmcm6pyiUHXIZz2D94tAWbTdNaG37vQzKB69tsmTobb7XCeWGKHT8TAgZXD7r94IuDSmtCLilDqf3eTaxV/5UtLjPIfGlhbDptb4Gv1ofOED0PkthsvQVcPJVK2ux4VLIpXSjkUiQ//LHD77uhcVyGDHVdDyfLSzEh6UDKsfFMSi//GoonUeBStOgQXyhcykOLPZs/w89jaRekJQalqnMjnL2bEjDgsz9HGOCf2J/hww=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TY0PR04MB6191.apcprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(23010399003)(10070799003)(366016)(38070700021)(56012099006)(11063799006)(261009223027099003)(261028144727099003)(261022115727099003)(261021121427099003)(261022105027099003)(261026121527099003)(261022075727099003)(261021123027099003)(261026140227099003)(10067099003)(22082099003)(18002099003)(6133799003)(3023799007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?NU2iO18SrCjHSKsAJaecQesUWFe0Uycb5Y3c2R13QEt3ZSK2q3IaDTYkAr8n?=
 =?us-ascii?Q?O5m0zGerRsce+pNbcBMGVJA3N5xVYbYFnBX9qMusDrUyQpTdF19zeCWaoJ63?=
 =?us-ascii?Q?X+WhMUW6qTe/nAnaRR36+RP6oWHtALoS6ATNPlHvrFybFIgRMnxU78/2RR/N?=
 =?us-ascii?Q?hPhTV8Og5rs2/pyfCOEodfeLmH9LUzWMRc+fGvEL89B4RMFVzTyIypRytR0n?=
 =?us-ascii?Q?U7UuFL3IOiizvvWa10WBiSDquW7BuujM5Qn02/eFpsF1TNDMoj784NleYRkr?=
 =?us-ascii?Q?ZY05RmTaVyOoNBm5FQMNhscXrrKy++Je6UEFpYzeGSZwEQCcwcBj+7q+EfBc?=
 =?us-ascii?Q?0xSZ87tAjuNdSDQTzGPAmrDEL1ax+nLfoscUzbXVXjaP28SyWG/X3pDy8/Kj?=
 =?us-ascii?Q?RjDoBtnYf5Ip7z0eN8d1v8OtwVIN3gAJiDCCksuubhGSP1L2152HW/5rQmEK?=
 =?us-ascii?Q?VA5PPlWrRyZAT/dDYrF0WPpv8hhIVba4vD4lOwPkkCKP7v80fF30ymUOQZvY?=
 =?us-ascii?Q?SsRyr1xDGetRiHHZgr+tg1zRjpae0zLy5Z3gEscc7Cshx/Edcgu4+9gbO3uE?=
 =?us-ascii?Q?eOgS8A/5Da0WAEybZO/dEKhOdAVHaXemsu3eg6h5WO1FtPQo3XBPb2GDcehN?=
 =?us-ascii?Q?dCirxFoWcmWeILTLyCylay40VXyG95Qv5htd2hHo10Do4iIWtjIeQXAt3uuU?=
 =?us-ascii?Q?Mw+N3tW+BBr8rXnimmsTI+5bdmzvEMwpX6V2Az0i1/YHcdNV+t7SSiI0BLv6?=
 =?us-ascii?Q?VzqozlcmyvMpVgbbx6tYyDDMBPI04ArpD/DQqvYFhZ3l9NGyZTSrbIs7Pie1?=
 =?us-ascii?Q?7bCo1wCM8O1jwWV1XtHjw8/JBczXAmr8FMuSEW8Qe217VPtZVBpuMXGSWdgM?=
 =?us-ascii?Q?xODt7jx1sHPpMIwbBbOaUi5TB+IROKRLY3nBZutizpWT9uApnbwpeNfyDMN1?=
 =?us-ascii?Q?utf/6HQzmGIGv9qkPNULYgEKq3ATBG6kuPxwui5jhVxn818YVQ/ATU/FDS9u?=
 =?us-ascii?Q?+rG4Nws6ya97GQbEACO6SHY4JfRZjsBHD01CC7w5WXqMl/kC/RNG6Ub/i7/Z?=
 =?us-ascii?Q?YPfNTP8NDGDiELBhVO9svDJT3oKZz0kRiffH0Btn1YpEZWl3y731yXgTBLKN?=
 =?us-ascii?Q?VgC6FqbgYF5nplhA99kOECdyDahONpOKqpMMS/7f3ql7g1PhzPhUvaD3pgu6?=
 =?us-ascii?Q?QQl9P7tWOwUaUurI8+JPchOZ0SlKT63CEgu9UveBKaIrn4wcGbm0Fjw6n82j?=
 =?us-ascii?Q?m+K0vjek//Aa1ry0MBLqu9c4r5MdZV8A6zwHvK06h7ulL6yiAmhfAe0myGjF?=
 =?us-ascii?Q?1+CDYig5JydsqLZJ9Pd6wzqIDycetYeUc3QARMpHwUABFtGdGRbIh3XGJFUG?=
 =?us-ascii?Q?QcjRsW4i5KPcc1tE1XLg/w/kNhfioPnOTtJ3MyY+L9uP58PTLary+kt1A0t7?=
 =?us-ascii?Q?aAcoD+cSvu0mQwfZUSftWkpG17BNETYPzgLTrA98ep2WZOWDYvnxyCuS1wT5?=
 =?us-ascii?Q?cpxJDf3FU/xcoanrMt7xc7lRsCPElUeixh0UHfB7afK0LZ0igqj1q8B1GXSr?=
 =?us-ascii?Q?hkIB1zv2v/d3UYqQA/EXYcgj/AhYIGSGLa20h3ocxzZWtnGj+reTJddaVV/O?=
 =?us-ascii?Q?ya/GBWbAh4TIF+Qm2Bc3ouTfVufrZpd33yt2KrI3u4T24mqHklQV8bMWSHE6?=
 =?us-ascii?Q?F5++hg1mTz3UxmQZAq3r/ZouYzDvGicJptLnu++hAXsWCjhzkipNBVlO5+Wo?=
 =?us-ascii?Q?MjAsgXCAGM0T3dW6u5b3zOJvql2zB38=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
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
	bxTN0fqNvIwOTuHN+G2ERdnLPn3lLcdFg/RI1qCIy2uialfZNItQbN8EXJikGZsEO4EA2PI++567Cg2u0y+WdGsDKhZS6WUZIa1Yg0adfLIUuAlBZNcAsZE0BJahNyrEurgWpN4smhsjQNelRwLTK623AOK3+euXqRqfA2Ab50qnLq0m4j27eBmrBlS8c+lyV7vE6caLGC1Y01qCWcXMqi1P4UTQtq5LZOHENYGpF6QWVWhRYzKJrx//OXis6Q19EmaC+OAOiQAxk3pebXLmOoGEvUgo8izdtX5AuEbSfbO9qMOkzHMGQJ1VNNu/WgvyZ18s78wSpZ2ixx2e/SQqxg==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	i/UVWvRe2yZbvGOEPHGcnsKov14/fIeJUqwXLnwfUCl9A0yj8IrBMLJvdp7djZOIUnQHtsy8FaW89yuR/cENBLLdBzuVBIX97arcMwUdEZTH422g4Rmy99elWkFjTErxdj0t6l919JIOWcVZis1xtpCRgt+qfajlEXCjAgb2IOKqab7P/sEdcVgyOrh2z4OyD34MUPru1op1nHpkezyx3YxLW6fjpXLjZby03rrCj2C5epZA2iL9Vt45wzY6anom3g0XrPV4eUv87KSoPtZU/Ddo/hQmULzFyEg51I1Q/QponnReMIk9WnGudL3ol//vLjymfki+hD3FfJy6C7iKuCgvOjhKLsDtltqe77Go+gi63wfnLg23WXb8/Q1L6SUfVeF3nU3qjxQ/of38+5dMM9TNBOoLgVHkBhf9h6Wp+dEiFs8ucYt/9qjESnPOy1tlPtqfuuYq53GjQblLTqu3JysnPdfpjWfKT4Ko+VfsF0JoqJ6byj7wa8h+7JsZtKXzvTvRB3TMryXy6wb+Cfrc4ems7N++AqCrC715qILB6ASyRWiYrDHsDCD+45u8i7wZW/Kk7/pUBvAmZBewo/qSVTyKu0NU/7lpcp9yOcfyi2RnHMo/Mv8iYNoINNxhKOsu
X-OriginatorOrg: sony.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TY0PR04MB6191.apcprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 613b9681-9052-4c65-dbbd-08df366746b2
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Oct 2026 09:22:10.5327
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 66c65d8a-9158-4521-a2d8-664963db48e4
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: DLJvfCrfVcb1mzey2Go/G0grJh5/RqBU3prXDbGZnpYIBO386af3WvqLgNSx0ZThXoX0xe6D7Z7U4AiuM1wUXw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OSQPR04MB8874
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDMwMDAzNiBTYWx0ZWRfX6aeNbqJwMJcQ
 d0XMmy9DlX52xYUD7f5lLCFzBtvgBsxRbUrBySfpqj0MuEt24GQ4TCXYHVx4/vDWcTeKUF+RtTA
 GJaKztkypHZC8lsP1ioa5PHiCkTYL/l/oGrNsZF6jV3QkNnfwdN2nTsq45QzYcnxMOddeiOawbf
 FSYBrUSa7SBwJQutaYK5G7d7ZclFJc1IT+TTw4Z5pGXdft+O6Km7Vt9cY9QIQG49T32Yzd1oZLV
 g1lf3jkHWRk8kew7M/41KpKz6fpJgldVCT3hmy1qUALeeIPARb5T23TqOkFqIc0QdAiXWtRV/TX
 8ytk+Pvcck58OjNKl9VJtrXfzOsgYEYw6/1g9a/8xbJSwiaxibfXPUdVTBq9cDg3aFDpm8Uvt5x
 XIFKk6feVnKs7e8BsPXUwTLI4ak9vKuJwMpWNba+v51tXLnVZIWeLgAgly9yi7mJLaAWWg3Lbem
 n4KUHcwz0lG66PO8gQg==
X-Authority-Analysis: v=2.4 cv=N428hG9B c=1 sm=1 tr=0 ts=6ae461c9 cx=c_pps
 a=+YeZlyKqbgbo03hKanuxGw==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=660iZSQnnn4A:10 a=7j0FZ4iXMVMA:10 a=xR56lInIT_wA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=KAb5x4SsHD3PzxGk7EmX:22 a=jHItnBwsj8f3cr25iGAb:22
 a=VwQbUJbxAAAA:8 a=z6gsHLkEAAAA:8 a=nTg3QbKWAAAA:8 a=pGLkceISAAAA:8
 a=GvQkQWPkAAAA:8 a=i0EeH86SAAAA:8 a=voM4FWlXAAAA:8 a=QSHWsWSW_gYo7CicXioA:9
 a=CjuIK1q_8ugA:10 a=IC2XNlieTeVoXbcui8wp:22
X-Proofpoint-ORIG-GUID: S_i7vfxaIvBePVY0v5hs1NL1c6vgxjNR
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDMwMDAzNiBTYWx0ZWRfXxxuSNkXPjbVr
 iOS1FDdh8YJbYCK5hMT55/xKI6fX0CCJ3sqxt3miW/qKx3QV9Ozw+GO7E6mjs7g8+CWtnH2vnsX
 3XNavisOqHbSHdWPQXb6cFIrA/q0VwaqN3EyNznw7ZzPSL6hMj8C
X-Proofpoint-GUID: S_i7vfxaIvBePVY0v5hs1NL1c6vgxjNR
X-Sony-Outbound-GUID: S_i7vfxaIvBePVY0v5hs1NL1c6vgxjNR
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-10-30_03,2026-10-21_02,2025-10-01_01
X-Spam-Status: No, score=-20.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1


This is the test for patch "erofs: set SB_I_ALLOW_HSM for bdev-based mounts=
" in kernel.

________________________________________
From: Su, Friendy <Friendy.Su@sony.com>
Sent: Friday, October 30, 2026 17:17
To: xiang@kernel.org; bluce.lee@aliyun.com; jnhuang95@gmail.com; hudsonzhu@=
tencent.com; zhaoyifan28@huawei.com
Cc: linux-erofs@lists.ozlabs.org; Su, Friendy; Palmer, Daniel (SGC); Mo, Yu=
ezhang
Subject: [PATCH v1] erofs-utils: tests: add test for fanotify FAN_PRE_ACCES=
S event

SB_I_ALLOW_HSM is set in kernel for erofs. Add a test to verify 2 cases bel=
ow.

case 1: with bdev-based device, FAN_PRE_ACCESS event is triggered.

 # SCRATCH_DEV=3D/dev/pmem1 make check TESTS=3Derofs/033

PASS: erofs/033
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
1 test passed
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

case 2: with file-backed image, FAN_PRE_ACCESS event fails to mark.

 # SCRATCH_DEV=3Derofs.img make check TESTS=3Derofs/033

fs-monitor not started
PASS: erofs/033
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
1 test passed
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

Signed-off-by: Friendy Su <friendy.su@sony.com>
Reviewed-by: Daniel Palmer <daniel.palmer@sony.com>
Reviewed-by: Yuezhang Mo <Yuezhang.Mo@sony.com>
---
 tests/erofs/033        |  85 +++++++++++++++++++++++
 tests/erofs/033.out    |   2 +
 tests/src/Makefile.am  |   6 +-
 tests/src/fs-monitor.c | 151 +++++++++++++++++++++++++++++++++++++++++
 4 files changed, 243 insertions(+), 1 deletion(-)
 create mode 100755 tests/erofs/033
 create mode 100644 tests/erofs/033.out
 create mode 100644 tests/src/fs-monitor.c

diff --git a/tests/erofs/033 b/tests/erofs/033
new file mode 100755
index 0000000..fab6d56
--- /dev/null
+++ b/tests/erofs/033
@@ -0,0 +1,85 @@
+#!/bin/sh
+# SPDX-License-Identifier: GPL-2.0+
+#
+# 033 - check FAN_PRE_ACCESS fanotify event
+#
+seq=3D`basename $0`
+seqres=3D$RESULT_DIR/$(echo $0 | awk '{print $((NF-1))"/"$NF}' FS=3D"/")
+
+# get standard environment, filters and checks
+. "${srcdir}/common/rc"
+
+cleanup()
+{
+       cd /
+       rm -rf $tmp.*
+}
+
+_require_erofs
+
+# remove previous $seqres.full before test
+rm -f $seqres.full
+
+# real QA test starts here
+echo "QA output created by $seq"
+
+if [ -z $SCRATCH_DEV ]; then
+       SCRATCH_DEV=3D$tmp/erofs_$seq.img
+       rm -f SCRATCH_DEV
+fi
+
+localdir=3D"$tmp/$seq"
+rm -rf $localdir
+mkdir -p $localdir
+
+# create a file for mmap()
+dd if=3D/dev/urandom of=3D$localdir/file-2M bs=3D2M count=3D1 >> $seqre.fu=
ll 2>&1
+
+MKFS_OPTIONS=3D"$MKFS_OPTIONS -x1"
+_scratch_mkfs $localdir >> $seqres.full 2>&1 || _fail "failed to mkfs"
+
+# _scratch_mount always mount with '-o loop', file backed mount
+# can not be tested. So mount with ${MOUNT_PROG} directly.
+#_scratch_mount 2>>$seqres.full
+${MOUNT_PROG} ${SCRATCH_DEV} ${SCRATCH_MNT} 2>>$seqres.full
+
+# start fanotify event monitor
+src/fs-monitor ${SCRATCH_MNT} > $tmp.fsmonitor 2>&1 &
+
+fsmonitor_pid=3D$!
+sleep 1
+
+ps -p ${fsmonitor_pid} > /dev/null
+
+if [ $? -ne 0 ]; then
+       echo "fs-monitor not started" | tee -a $seqres.full >&2
+       if [ ! -f ${SCRATCH_DEV} ]; then
+               echo "fanotify monitor failed to start on non-file-backed i=
mage"
+       fi
+       ${UMOUNT_PROG} ${SCRATCH_MNT}
+       echo Silence is golden
+       status=3D0
+       exit 0
+fi
+
+echo "fs-monitor started" | tee -a $seqres.full >&2
+
+# do mmap(), FAN_PRE_ACCESS event will be triggered
+xfs_io -r -c "mmap -r 0 2M" -c close ${SCRATCH_MNT}/file-2M >> $seqres.ful=
l
+
+sleep 1
+
+# kill fs-monitor process anyway
+kill -TERM ${fsmonitor_pid}
+
+cat $tmp.fsmonitor >>$seqres.full
+
+(cat $tmp.fsmonitor | grep -q "FAN_PRE_ACCESS EVENT" > /dev/null) || \
+       echo "No FAN_PRE_ACCESS EVENT"
+
+#_scratch_unmount
+${UMOUNT_PROG} ${SCRATCH_MNT}
+
+echo Silence is golden
+status=3D0
+exit 0
diff --git a/tests/erofs/033.out b/tests/erofs/033.out
new file mode 100644
index 0000000..c5d2914
--- /dev/null
+++ b/tests/erofs/033.out
@@ -0,0 +1,2 @@
+QA output created by 033
+Silence is golden
diff --git a/tests/src/Makefile.am b/tests/src/Makefile.am
index 16de41a..d645539 100644
--- a/tests/src/Makefile.am
+++ b/tests/src/Makefile.am
@@ -3,7 +3,7 @@

 AUTOMAKE_OPTIONS       =3D foreign
 check_PROGRAMS         =3D
-noinst_PROGRAMS                =3D fssum
+noinst_PROGRAMS                =3D fssum fs-monitor

 fssum_CFLAGS =3D -Wall -I$(top_srcdir)/include
 fssum_LDADD =3D $(top_builddir)/lib/liberofs.la
@@ -15,3 +15,7 @@ badlz4_SOURCES =3D badlz4.c
 badlz4_CFLAGS =3D ${liblz4_CFLAGS}
 badlz4_LDADD =3D ${liblz4_LIBS}
 endif
+
+check_PROGRAMS +=3D fs-monitor
+fs_monitor_CFLAGS =3D -Wall -I$(top_srcdir)/include
+fs_monitor_SOURCES =3D fs-monitor.c
diff --git a/tests/src/fs-monitor.c b/tests/src/fs-monitor.c
new file mode 100644
index 0000000..07b7a2a
--- /dev/null
+++ b/tests/src/fs-monitor.c
@@ -0,0 +1,151 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Partly copied from https://git.kernel.org/pub/scm/linux/kernel/git/torv=
alds/linux.git/tree/samples/fanotify/fs-monitor.c
+ */
+
+#include <errno.h>
+#include <err.h>
+#include <stdlib.h>
+#include <stdio.h>
+#include <fcntl.h>
+#include <sys/fanotify.h>
+#include <sys/types.h>
+#include <unistd.h>
+#include <fcntl.h>
+#include <poll.h>
+
+static void handle_pre_access_event(int fd,
+              struct fanotify_event_metadata *event)
+{
+       struct fanotify_event_info_header *info;
+       struct fanotify_event_info_range *range;
+       struct fanotify_response response;
+       int off;
+
+
+       for (off =3D sizeof(*event) ; off < event->event_len;
+            off +=3D info->len) {
+               info =3D (struct fanotify_event_info_header *)
+                       ((char *) event + off);
+
+               switch (info->info_type) {
+               case FAN_EVENT_INFO_TYPE_RANGE:
+                       range =3D (struct fanotify_event_info_range *) info=
;
+
+                       printf("FAN_PRE_ACCESS event range: \n");
+                       printf("offset =3D 0x%llx, count =3D 0x%llx\n",
+                                       range->offset, range->count);
+
+                       response.fd =3D event->fd;
+                        response.response =3D FAN_ALLOW;
+                       if (write(fd, &response, sizeof(response)) < 0)
+                                       perror("Send FAN_PRE_ACCESS respons=
e failed");
+
+                       break;
+               default:
+                       printf("\tUnknown info type=3D%d len=3D%d:\n",
+                              info->info_type, info->len);
+                       break;
+               }
+
+               fflush(stdout);
+       }
+}
+
+static void handle_notifications(int fd, char *buffer, int len)
+{
+       struct fanotify_event_metadata *event =3D
+               (struct fanotify_event_metadata *) buffer;
+
+       for (; FAN_EVENT_OK(event, len); event =3D FAN_EVENT_NEXT(event, le=
n)) {
+
+               if (event->mask =3D=3D FAN_PRE_ACCESS) {
+
+                       /* This msg will be checked in test case */
+                       printf("FAN_PRE_ACCESS EVENT (len=3D%d)\n", event->=
event_len);
+
+                       handle_pre_access_event(fd, event);
+               }
+
+               /* TODO: Add more event handler here */
+
+               printf("---\n\n");
+               fflush(stdout);
+       }
+
+}
+
+int main(int argc, char **argv)
+{
+       int fd, poll_num, opt, nfds;
+       int check =3D 0;
+       char buffer[BUFSIZ];
+       struct pollfd fds[1];
+
+       if (argc < 2) {
+               printf("Missing path argument\n");
+               return 1;
+       }
+
+       while ((opt =3D getopt(argc, argv, "c")) !=3D -1) {
+               switch (opt) {
+               case 'c':
+                       check =3D 1;
+                       break;
+               default:
+                       fprintf(stderr, "Usage: %s [-c] path\n",
+                               argv[0]);
+                       exit(EXIT_FAILURE);
+               }
+       }
+
+       fd =3D fanotify_init(FAN_CLOEXEC | FAN_CLASS_PRE_CONTENT | FAN_NONB=
LOCK,
+                        O_RDONLY);
+       if (check)
+               exit(fd < 0);
+
+       if (fd < 0) {
+               perror("fanotify_init");
+               errx(1, "fanotify_init");
+       }
+
+       if (fanotify_mark(fd, FAN_MARK_ADD | FAN_MARK_FILESYSTEM,
+                          FAN_PRE_ACCESS, AT_FDCWD, argv[optind])) {
+               perror("fanotify_mark");
+               errx(1, "fanotify_mark");
+       }
+
+       printf("fanotify active\n");
+       fflush(stdout);
+
+       fds[0].fd =3D fd;
+        fds[0].events =3D POLLIN;
+
+       nfds =3D 1;
+
+       while (1) {
+               poll_num =3D poll(fds, nfds, -1);
+                if (poll_num =3D=3D -1) {
+                        if (errno =3D=3D EINTR)    /* Interrupted by a sig=
nal */
+                                continue;      /* Restart poll() */
+
+                        perror("poll");                /* Unexpected error=
 */
+                        exit(EXIT_FAILURE);
+                }
+
+               if (poll_num > 0) {
+
+                        if (fds[0].revents & POLLIN) {
+                               int n =3D read(fd, buffer, sizeof(buffer));
+                               if (n =3D=3D -1 && errno !=3D EAGAIN) {
+                                       perror("read");
+                                       exit(EXIT_FAILURE);
+                               }
+
+                               handle_notifications(fd, buffer, n);
+                       }
+               }
+       }
+
+       return 0;
+}
--
2.34.1


