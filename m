Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F127606A33F
	for <linux-erofs@archiver.kernel.org>; Fri, 20 Nov 2026 03:23:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=sony.com header.i=@sony.com header.a=rsa-sha256 header.s=p1 header.b=sxSvPPgp
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4jW0zv0h0fz2yDm;
	Fri, 20 Nov 2026 14:23:55 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=fail smtp.remote-ip=185.132.183.11
ARC-Seal: i=2; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1795145035;
	cv=fail; b=jbfw7dJFPTP0J/R+6BwNWjVX8tFEHbhli/gTjLj8epbCHyJ9UrENXUaAyWIo/OwP3uadsGWW9zgGuYuod9NL0HbwK6ewz0LAejaByVbTukCL2cf8WfQ6c4uAdnheX1m6G/aDfiKPowDSNOp5/5539V4YmzZ72Gu1Aq9Qg4kcZS9Cp0SSgHQpSXamnLwP+9Os36wcwGMk/tUEfGPYytlBWeuoZKDDWtlKGg8ep/edzyciec1D35mPzUIxP392QtQTDeN4XeDObHA1L+cjjQc7KCy9iTX3LmiCqcJiowXo9dR38T7mEC7u7QgdMs5Em0gcTGR8cEsZfhxHo3ep15Wdcw==
ARC-Message-Signature: i=2; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1795145035; c=relaxed/relaxed;
	bh=+Tjh1FBalit/mez4CpIGv7sS3iRXKjOgz1woGPlvCxE=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 MIME-Version:Content-Type; b=oXO2jBEFJ+D1Uz9K7jj/skpWH2UVhqgOtM/xRUxZVz8p4yiAcN+A0riX1MkewHUiUGJlsMV6L7i1gcbLFINz2EG2R25Md/ck547HumLb5Hcz0P3WuuvcNA7KLVic2xdEP2MO2tdjkVDmt+jvAqr4FCN+upCrpUiLLgLI4IWqODcm+Sk134H54DUMtN2827ns845B8fjjLWjCc6W6OI3/5bA0urvRXpgXaRBSxhFWCLbXZjnR8MzWZ4ao0XRbZWHdN8OYohwBewARJn7Ug4RGYDltU8taKiLS5nsFHsqH7+ieUMeKm13gzBT3hcHVdVzrQRLwQ/qvbC7oH5VaOy2qdw==
ARC-Authentication-Results: i=2; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=sony.com; dkim=pass (2048-bit key; unprotected) header.d=sony.com header.i=@sony.com header.a=rsa-sha256 header.s=p1 header.b=sxSvPPgp; dkim-atps=neutral; spf=pass (client-ip=185.132.183.11; helo=mx07-001d1705.pphosted.com; envelope-from=friendy.su@sony.com; receiver=lists.ozlabs.org) smtp.mailfrom=sony.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=sony.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=sony.com header.i=@sony.com header.a=rsa-sha256 header.s=p1 header.b=sxSvPPgp;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=sony.com (client-ip=185.132.183.11; helo=mx07-001d1705.pphosted.com; envelope-from=friendy.su@sony.com; receiver=lists.ozlabs.org)
Received: from mx07-001d1705.pphosted.com (mx07-001d1705.pphosted.com [185.132.183.11])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4jW0zt1Fnyz2xpt
	for <linux-erofs@lists.ozlabs.org>; Fri, 20 Nov 2026 14:23:53 +1100 (AEDT)
Received: from pps.filterd (m0209324.ppops.net [127.0.0.1])
	by mx08-001d1705.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6AK0GelE336179;
	Fri, 20 Nov 2026 03:23:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sony.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=p1; bh=+Tjh1FB
	alit/mez4CpIGv7sS3iRXKjOgz1woGPlvCxE=; b=sxSvPPgpiR5tP6R4QIwdG7p
	Hr02PywxHZT8VkQLvD+i1n5EOQDkU7xsFKEIKmTurzGQZBXA0QtZti+onT6+3wRf
	7PCS0GVk6rZqXJumrvqXGxDAk0TuLoSr07MBLRmAtjhH3GyQxAEXzZm7qCepAH0j
	zBHkb9BP8sO6GIl44nUZ7VgObJLzP2QxJYc0PI+a6t9e3upORqA5V8Z1cJ6USAhC
	mBgt9NRuG9WOpYcvcENndlu6wKuXz9hThm9fCDhzkkIE6zTCbzzAaF12mopC2acq
	2pUa/ddWuNqpOkqHy8eM4Lr6V+IHM0oxk25U5iG3Lkc0UQHxh0a5QF7gQhD0AAw=
	=
Received: from typpr03cu001.outbound.protection.outlook.com (mail-japaneastazon11012067.outbound.protection.outlook.com [52.101.126.67])
	by mx08-001d1705.pphosted.com (PPS) with ESMTPS id 4j0yu5k5bd-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=OK);
	Fri, 20 Nov 2026 03:23:39 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=j+PuhsUYaz/SwB+a/t3Pb7PkRSDVjlFiMpK8D55+Yhx6ayk+XWvv+6Gbtih0qjQw+u+9IABveHrNkPJNBjUwvqNBh8wNCyABMFVeSo8MNPQhhpWulBGbvDPJJ3i0Rub0IqVebw5H2KXQItb3h/fHZovHCtM7ZgSr3uzFT7oH62DB7CdF5kvRNDulDwzchepV/PNn9prn65WSLg6AqJldwRfklPeWlRGVfs6AmgyzPjLXaHYaCUA/uAEnYaXgC9PuOHATXo5wsPqD3MZtOClo4Zpe+s53VIJj1lpn1lGGa3JvT0lt/H9UMnTHVbGY9yJTccuZpjugMePeYKP14LwBlA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gC1gIYqJ9pNgxIoIFGEBJCkmlUEKH9E3WTHyVNZ8RA4=;
 b=bX7BHSWMUd1K1hBDf1RrftcIp80Ox9FGfMUlMMQQ2KYesu+PD8aZSaItmievsYZzzV6u8zINqg4mye3SJsN7DMHwf4NJfjnMjXVEXgzYFyQaFlv7Ckyh4464OgXFSGIHzFsJpbZZ9gTmwLCIioB8/++XyUXujM2984mZDBpaP2W0rD6apPFjXEJebN0cUow7ngHIj//lIFh3ZotbPzKRC5+ru5PK5rXFhXOgYp2GDBsIOGEYvZIT5qHzhRPx/+rEOTy69X2um9w6r+eWAK6jqFFWa+r/rX44NAYjdlnJubLPZbT2L0AfwfyPbyzY+cPqlUMtoXy4xHdDDun8lZGETw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=sony.com; dmarc=pass action=none header.from=sony.com;
 dkim=pass header.d=sony.com; arc=none
Received: from TYZPR04MB4128.apcprd04.prod.outlook.com (2603:1096:400:27::5)
 by PUZPR04MB497785.apcprd04.prod.outlook.com (2603:1096:301:c8::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.639.12; Fri, 20 Nov
 2026 03:23:31 +0000
Received: from TYZPR04MB4128.apcprd04.prod.outlook.com
 ([fe80::20b9:f878:c46b:6553]) by TYZPR04MB4128.apcprd04.prod.outlook.com
 ([fe80::20b9:f878:c46b:6553%4]) with mapi id 15.21.0639.011; Fri, 20 Nov 2026
 03:23:30 +0000
From: "Friendy.Su@sony.com" <Friendy.Su@sony.com>
To: Gao Xiang <xiang@kernel.org>
CC: "chao@kernel.org" <chao@kernel.org>, "jack@suse.cz" <jack@suse.cz>,
        "amir73il@gmail.com" <amir73il@gmail.com>,
        "linux-erofs@lists.ozlabs.org"
	<linux-erofs@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>,
        "Yuezhang.Mo@sony.com"
	<Yuezhang.Mo@sony.com>,
        "Daniel.Palmer@sony.com" <Daniel.Palmer@sony.com>
Subject: Re: [PATCH v2] erofs: set SB_I_ALLOW_HSM for bdev-based mounts
Thread-Topic: [PATCH v2] erofs: set SB_I_ALLOW_HSM for bdev-based mounts
Thread-Index: AQHdYpT5uYRh4g5Ytkao5CHS76ViOrc2F/aAgABfxVU=
Date: Fri, 20 Nov 2026 03:23:30 +0000
Message-ID:
 <TYZPR04MB41288855159AFC92FCF3DF8CFD782@TYZPR04MB4128.apcprd04.prod.outlook.com>
References: <20261023021635.2852395-1-friendy.su@sony.com>
 <av9svyT3otgEEDgX@MacBookPro.fritz.box>
In-Reply-To: <av9svyT3otgEEDgX@MacBookPro.fritz.box>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
authentication-results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=sony.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: TYZPR04MB4128:EE_|PUZPR04MB497785:EE_
x-ms-office365-filtering-correlation-id: 1a519900-2bc6-43a6-55e7-08df46b5a65f
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|10070799003|376014|23010399003|1800799024|22082099003|18002099003|4143699003|11063799006|56012099006|261026140227099003|261028144727099003|261026121527099003|261022115727099003|261022075727099003|261009223027099003|261102123227099003|261021121427099003|261022105027099003|38070700021|10067099003;
x-microsoft-antispam-message-info:
 t72OtwuFWP/SYOYqQhbwX/VJVFQh0y9H4Rjw63kOvpbYw3n77ujosPLEAuI+RymbKk24tg2dnTrA+qjrh2hQL0fipZUOYgmE81tvQrIh8TMzXdl40vXpRONHe3uBc7w+8M4s0T/wMH1laKzvYX+b/pT18V9J5h2S3s+Y35ZTPU/yskLAMb7Qs25lcr29MzRnCXdderRShI0y323hBm6D/k/TgrFj8c/uW2wM87Xnj0l21f1oU15PmQjEkJPlrttg8xSKaoH5GXcUgAHftQUMjG8ypaGDd3VTULzgS3wN05KMnPktHgjZR8O+GE/1+9mm3jv76YxLhCq8v2LNoDxZB1NVNiH/DVei/5U7iTv3NzjXjk0HD8DWmF38P7pridCH8a0CDmjCxzDsgy4QcR9/2dOVbcekuopwLGIhcEl7K2t3PDpE1QbSIO2foOvEwcou3UDYHy/5Mu98iMmXhFeCzOIVgOnRsVwo+QAwoAD1LVvVbgOqhp4qvD2eZv46EQwB7JbSaHwQ8xnlVjyEWIp1MJscE4fQOTA3AijLtdO3LCA+Ddab7jqV0Dmh7soaD4LP1CyKDosazHFQwqhIpvPhHTdYQJV2VJU3RacEQCMi4H7EBfCKjJRNSzieqaVKrKXO2bMO2trKQ/vOn1Le5a581qMjCPgXnCAcFQTIekQj1WKI7X/z1QMiCzuk64vJdnDyAJeGTcXef99GJiEzmqz6ojsZ0Bynuu5tXbLQb1vcwH0=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TYZPR04MB4128.apcprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(10070799003)(376014)(23010399003)(1800799024)(22082099003)(18002099003)(4143699003)(11063799006)(56012099006)(261026140227099003)(261028144727099003)(261026121527099003)(261022115727099003)(261022075727099003)(261009223027099003)(261102123227099003)(261021121427099003)(261022105027099003)(38070700021)(10067099003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?V29TRnZQSUdHc2pqMDNkNTgrYVlGcVYwQk5oU2tvRUNMekE4Y0c5VDh5QmZr?=
 =?utf-8?B?MVJ6ZmI4L0dONWVFYXpLa3Foei9jcWdvOUlleWp2NU8ybDU4QUFmTk5ZeStI?=
 =?utf-8?B?bEJUTnd0bmFGYS9RN1dPbGRRRmFURUFsQStlUFArQVFKRk9LcStULzFsWlhS?=
 =?utf-8?B?WlIyQlU1RlRKOXFIam5RYW5ha1lGc0VSYjdmY3hBMUdvZWY5YzMwNzJJTDdI?=
 =?utf-8?B?NVhGMCtzZzNkcEptbVg3SngzalovaHprRmljU09oRnJtQVJhZHdqTWxqRjJP?=
 =?utf-8?B?NWtMM3hyZTZiSlpzTFpFcFFvdThLV2JKSkNrZkN3MVJSRW1hYzFTN3NhL1Mv?=
 =?utf-8?B?TU1yenVqOE1oOG5CVUpMdVBNYVRlVTdaejFaUkNxTTB1d1ZmNHgxOTNlckI0?=
 =?utf-8?B?ZE51LzlQakFYRThsdGZjUHJpT1RkOFNYUFIwQ3p6bWlUOW8vbGlJdXJMdXd3?=
 =?utf-8?B?VjUxN3d5YTkzU09QM3M1ZHI0Z05rL3JhK0dqUDhORHNwNk9pS1lIbnllS1Zo?=
 =?utf-8?B?eEFUUjI5M2RBdU45ZDBLYWUzdUwrMGJSU2RWZ1ZMb0UyMG0zOG9zWUpzaFBC?=
 =?utf-8?B?RmYzOGFTSzNkNkZBTHk2NGFhYzBVODVTWlBhYlhKa3dPZGQyU2FMMTZTcjd2?=
 =?utf-8?B?UWVhQ3EySEYybFhDMUljUER5SzZXN1oxOFF4WUc5dzQ1WUpza1AzT0tLZWpR?=
 =?utf-8?B?bTBFWnEwMWgweDFZNktiZkZjZGU5MnRaRDRsODlua0ZIbms0cFVhRzl1K2do?=
 =?utf-8?B?OWFGM0RUVmtGR1BaeGRxZ0FEWElXK0U4MG40NGNackdkT3hGM2p6Mmc0TS9Y?=
 =?utf-8?B?QUovSE4rNHJFNVR3NkxrbFk4RFduaVYyYzF1Q1NQWFRjRnN0RkxMcXhMekwy?=
 =?utf-8?B?SGJqUWtxaEJaUXZ5YzFpTDNJekppVkJkdkNFeS9aYTUwcUNYdkpLdXdFa0gx?=
 =?utf-8?B?YVZ4OHYxMTdwaC8wUXk0N29MajcyRnVVRGZCcGh4M0lqTDczNTF2eG5EMXV1?=
 =?utf-8?B?N1dEcWZUUnNza2kyczRBZUR4WVNQNGRjNExBVVVlNndVUmxpUDVMNDQzVVdr?=
 =?utf-8?B?RXNxRzlXQ25ZZ1FCbDJ3YitBTnRiYXgvNUJXRy9Xc083eGJrem9jeUM2aUJ2?=
 =?utf-8?B?amdlRGFqRkx2YU41L2RtWWtKR3hxYVZqUUxqZFlaSGw4WXh0UVF4TFZtRkNz?=
 =?utf-8?B?SXB6VXZ5bFZlaVpUMTAxQTVadDNhRTBBS0lTSlFjbzVDSEMrRlpweHRYaUds?=
 =?utf-8?B?UlNVZmN4K2R3VzlMcitQK2loblplNTkzaDQ4cW1Xako0elQ0bXdtMFA4N3FQ?=
 =?utf-8?B?RTRudDVveXdpanQwUVd3dEV6UHpPaWt0QllSaUtHcFhGRnA3eE5sZFkrR0tr?=
 =?utf-8?B?ZzdNeGVuLzlvWSt5eDJBZEtzcmZsaC9PbS9DT05ZR2JZQkMyYno1M0JFazZt?=
 =?utf-8?B?KzRYRkVJSFVpbHNVN21qeDlxTGVpSVhGNHVDUjBnYkd1dFZieGFON1pCUmZJ?=
 =?utf-8?B?MnZIa08rTkVVQS9rejVlQ0QxMksxNHVJTGZZUHFwWllkN0pWK1Q5VzdNanc1?=
 =?utf-8?B?TzI4K0pqQ0QyaTJRSk03Rkl1K0VpRHBhVk0rUUdkRTBvZVo4NVk5SlVneDVT?=
 =?utf-8?B?M254ZmdUMTd6cnVxaGR0aVdNWHprb1hWelVFQ2pGVU5OcGk3M1lkNjhmelBj?=
 =?utf-8?B?SGI4alZORHJFNVhkNUllKytqL3JiRzhkYXdFQWEzWGt2eUZKUHhvaGE5VXFD?=
 =?utf-8?B?cnZvKzlLdGoxb1Z1cjZMdUh3YUplRi81emtMb3BSU25USHN3VHJnV2VNSmRP?=
 =?utf-8?B?ZDVWV0o4ZGV0bWg4SGUvV2lCcWxmdHRrVWFUc0lVSUtMR0JaaEhGMXVmM2NQ?=
 =?utf-8?B?U1VNdzlkemRoTFB1eUtKVE12UWhmNlRWYk5YTEl3eWdhMmMxOXhKcXgxM2N0?=
 =?utf-8?B?czFsOVd5Qm9wWUlFbmpWclNWek9ZYVh5bXJCNzMvNndLQ2h4K0I4ZzhOZExD?=
 =?utf-8?B?QzlxVmlPTVN4UzRUcDhhUjB1UG5qSzRWUWdoeUZvMnVjUVdXSGVHSkZRNEhR?=
 =?utf-8?B?VjFsRVlvOE83NHhJSFcyU0tHaUNYS1RkMWo2NzR0SXpXOFVZMHBjKzFCMDVk?=
 =?utf-8?B?Y3gzOXdJaERWZnlXZ3lRSTRpM0xUWU1QYTRVcUlQWGs2aHdZYVNNd2ZJdGJH?=
 =?utf-8?B?UXFsaXg1VW5JdjRlYWNVRS9OSkphVzZKS0Jaczl0VHh0bU1NNFJrbmFVeWhV?=
 =?utf-8?B?Qko2U3NkcEJFZDZPQWVFb05zTUJXYUNXOHdFNzJJMUlyYkk3S2pRVFNjTjFI?=
 =?utf-8?B?d2pROTRHUkdUODRQRFY0RFBONk41VjNQL2s3cWQrUnJEQnR1Yy9PMUN5eWtS?=
 =?utf-8?Q?aNyBJ/4gr2U6N7ok=3D?=
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
	kDqqHFY9d/23nq6+QrT2dQ8lBGFVdSi05q7nodZqQeSkYKtPlMvCAKJTMeFiJSsHhTvPx1DgXyCkb240rLQgb9HLFMhZesZ9BSl4AoT1YLTNgwrafmKICCWlH5QV/mJv509gNm5OwDP+6sJt0/QzDHLE+hhVsIHXG7jOjHSPWARJENDqHmanalMBYmhSq9cXl6FZ3bmu/g+/2uuLN1k7CTrgpYuAhYv40+Eh9jz0dRtcgO/HF3//gr6Hihm2sMLXXMv/CrGaFAppL7s96nZ2xSpnHWmTzYm7NBJcaktwb1JPYtD9y+qMOSHpNL3+whHz2jK2x2h2xLLE13txzaGu/Q==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	92upxQH6PFBQPlcre6mVy2/PQmQo0z7U1PDWctDuQnyYqjCR1SDuOAA9Gdbt0GJzVs80teoYMAoVuf4LZNYwqpr4oWjhnpUCMz03ocuMaJRxPvPbNsWaFcqRcoeuO51uGQ8J2WmbIa/uA4eusIeujQSvz54nDAnccm4PSTu2+wbeyrsp9Qi10fOXotmh2IwKtT4CsZZiKeOImPD5PlgcDClGGHKgcvFgxlLRjMQDFHN2DCzKvLz5iPLZlH9xYhxnroOhoY0imZK3yRVTj7/wBMjYEUt9i1ESdTMfw+fs2amZT2F2JXj2Cgj5stqKMZ82akIsMKd/V7Z5+miqav2j5Z9/qrzmBY8gTvFBW6dPYx+H9qknAZJikj5vQZR1lRghqmKuVmSzyFC6HjWC8ajoEakw6Op3XnB98FJeGXpzM8i8yHtu4OPazOpAibyHmDWwFq866LVIcAwTDG5xTD3rZUrgGhfPDBH9rFndWl66xh0Qr7JPsmyKCWV/3pYm+F2ph/nwilcBeiMV3WWOlvmvh5w2nO6Q7G85xOu5KcwueX3Le+C1a68xxerJW86GKMgJ9WT+m4sKra32Rj1nhdTdY3Kn7yP2v7kQGzgAdSRFRoMm6FmgUWFGzBJ3Zu9qLq4D
X-OriginatorOrg: sony.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TYZPR04MB4128.apcprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1a519900-2bc6-43a6-55e7-08df46b5a65f
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Nov 2026 03:23:30.2997
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 66c65d8a-9158-4521-a2d8-664963db48e4
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 5r62op+AHD6ne2M78lyB8Dl+fkdP+62F/ulTvqjZeoKmjoyGtfPFcr8+/ngz7iJzl2k5cEprlcXRDyXSw6m1XQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PUZPR04MB497785
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Authority-Analysis: v=2.4 cv=GqnXaU1C c=1 sm=1 tr=0 ts=6affbd3b cx=c_pps
 a=r8c/Pf2WJ4XAUkXt6oqGBw==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=zJRp6_cAMcgA:10 a=7j0FZ4iXMVMA:10 a=xR56lInIT_wA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=KAb5x4SsHD3PzxGk7EmX:22 a=I_Y4LlEPCAdqsIK1J1Zo:22
 a=VwQbUJbxAAAA:8 a=pGLkceISAAAA:8 a=voM4FWlXAAAA:8 a=z6gsHLkEAAAA:8
 a=IVa03Je71_xYgOhgFzgA:9 a=QEXdDO2ut3YA:10 a=IC2XNlieTeVoXbcui8wp:22
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTIwMDAxMyBTYWx0ZWRfX4dEKVRG9vc6r
 uD4P/lGjW8IMjMna2mcf93cEknB1B9qkhKH67bkIL1fAKIm3gQ8F0PO11J6iA+u1NIk11WU93d8
 WBEc1LXYwVXm4YSanQathtrGd8mprPTAoeN2z4LDyAzP9XfjyxOE
X-Proofpoint-GUID: tp6U2o1r4V-HkboHgZqxT0fKGJ9uVmZE
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTIwMDAxMyBTYWx0ZWRfX9ZD8YYr+HoPq
 8W9ENA2sNao6W20shtKs45zwsUIpPhTEK289lvg3/9IORFxgAynKnqFNrdycmYcLb6WwuDO3Lxu
 cQ8B5hqKZtDU3QZ3EJlyIhRQKiL5UXI+E+vyIxtDXWbIxsIMuR+xx0Bd/Y1K+JwCz4aLWZ7A7db
 9uBY+H2Fk1tiWgLpgb/LeD5FRrmtoyV6axMTixecNNJsfajCP0LFM46gCS+kOKYkqnauSO9iFeJ
 sC/wfBp4tzHV5tHdt5AVylDU+e6a42QAWjNhbO//qL7IPFUavNfwh2ZIXyjB869tmlipd5Xxk3R
 SjCMUh4fGcTkSxb0sHFEuts49hA9gvph9s74t/DvwaEpxbzw/o2wV7tWj6soGRjA35KuHe8LPSr
 2lvGrhx4b6ST809mf59aL+tkxnzxXu9zwpgY/FS9msbcnaJKOWGDaWV0RclTaRkHNFRHQkeuzMs
 US/gwseVUWQ5jMuGLfg==
X-Proofpoint-ORIG-GUID: tp6U2o1r4V-HkboHgZqxT0fKGJ9uVmZE
X-Sony-Outbound-GUID: tp6U2o1r4V-HkboHgZqxT0fKGJ9uVmZE
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-20_01,2026-11-19_01,2025-10-01_01
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi,

Thanks for comment.

I have sent patch v3.

Best Regards
Friendy

________________________________________
From: Gao Xiang <xiang@kernel.org>
Sent: Friday, November 20, 2026 5:40
To: Su, Friendy
Cc: xiang@kernel.org; chao@kernel.org; jack@suse.cz; amir73il@gmail.com; li=
nux-erofs@lists.ozlabs.org; linux-kernel@vger.kernel.org; Mo, Yuezhang; Pal=
mer, Daniel (SGC)
Subject: Re: [PATCH v2] erofs: set SB_I_ALLOW_HSM for bdev-based mounts

Hi Friendy, On Fri, Oct 23, 2026 at 10:=E2=80=8A16:=E2=80=8A35AM +0800, Fri=
endy Su wrote: > SB_I_ALLOW_HSM makes erofs support fanotify FAN_PRE_ACCESS=
 event > for bdev-based mounts. file-backed mounts do not support this. > >=
 This is for use case


Hi Friendy,

On Fri, Oct 23, 2026 at 10:16:35AM +0800, Friendy Su wrote:
> SB_I_ALLOW_HSM makes erofs support fanotify FAN_PRE_ACCESS event
> for bdev-based mounts. file-backed mounts do not support this.
>
> This is for use case that erofs file data is not available on
> local block device at mount, but need to be filled at fanotify
> FAN_PRE_ACCESS event handler.
>
> E.g. format erofs to blob mode, meta data on /dev/pmem0, file data
> on blob device /dev/pmem1. The file content in blob device is dummy.
>
> mount as below:
>
> $ sudo mount -o dax,device=3D/dev/pmem1 /dev/pmem0 /mnt/erofs/
>
> In FAN_PRE_ACCESS handler, actual file content is fetched from remote
> then filled into the DAX mounted block device /dev/pmem1.


Set SB_I_ALLOW_HSM to enable fanotify FAN_PRE_ACCESS events for
bdev-backed mounts. File-backed mounts are not supported.

This allows EROFS to handle cases where file data is not available
locally at mount time and needs to be fetched on demand by a
FAN_PRE_ACCESS event handler.

For example, an EROFS image can use blob mode with metadata stored
on /dev/pmem0 and file data on /dev/pmem1, where the latter initially
contains dummy data.

The filesystem can be mounted with:

    mount -o dax,device=3D/dev/pmem1 /dev/pmem0 /mnt/erofs

On receiving a FAN_PRE_ACCESS event, the handler fetches the actual
file data from a remote source and fills the corresponding blocks
on /dev/pmem1 before access proceeds.


>
> Signed-off-by: Friendy Su <friendy.su@sony.com>
> Reviewed-by: Yuezhang Mo <Yuezhang.Mo@sony.com>
> Reviewed-by: Daniel Palmer <daniel.palmer@sony.com>
> ---
>  fs/erofs/super.c | 9 +++++++++
>  1 file changed, 9 insertions(+)
>
> diff --git a/fs/erofs/super.c b/fs/erofs/super.c
> index 0967aace9f7f..be8728b8d116 100644
> --- a/fs/erofs/super.c
> +++ b/fs/erofs/super.c
> @@ -667,6 +667,15 @@ static int erofs_fc_fill_super(struct super_block *s=
b, struct fs_context *fc)
>               errorfc(fc, "FSDAX is not allowed when inode_share is on");
>               return -EINVAL;
>       }
> +     if (!erofs_is_fileio_mode(sbi)) {
> +             /*
> +              * Only enable HSM to support fanotify FAN_PRE_ACCESS event
> +              * under block device backed mounts.
> +              * For file-backed mounts, do not enable since erofs-utils
> +              * has already supported FAN_PRE_ACCESS event on backend im=
age.
> +              */

Could you just change it to

                 * Follow other filesystems by supporting FAN_PRE_ACCESS ev=
ents
                 * only on bdev-backed mount. Don't bother with file-backed=
 mounts.

I hope we could avoid mentioning user-space details
in the kernel codebase directly.

Could you send a new version as I suggested, otherwise
it looks good to me,

Reviewed-by: Gao Xiang <xiang@kernel.org>

Thanks,
Gao Xiang

> +             sb->s_iflags |=3D SB_I_ALLOW_HSM;
> +     }
>
>       sbi->blkszbits =3D PAGE_SHIFT;
>       if (erofs_is_fileio_mode(sbi)) {
> --
> 2.34.1
>
>


