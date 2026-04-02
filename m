Return-Path: <linux-erofs+bounces-3177-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 47A5FCC6B03
	for <linux-erofs@archiver.kernel.org>; Thu,  2 Apr 2026 06:46:40 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4fmXSt6rPqz2yYK;
	Thu, 02 Apr 2026 17:46:38 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=pass smtp.remote-ip="2a01:111:f403:c40f::6" arc.chain=microsoft.com
ARC-Seal: i=2; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1775112398;
	cv=pass; b=V6NmgYYYkYyDZm2oHE7RTZ8zUBuC7k1NTN/fOdqCsFAjQZ7WeUP18mwQlb3GKeWXOYPVcJLNF3FymZYC/VuQnhoWcItHk11mhroPlwg/ztn8TZIc7chDM1zW9HWwn5MsAJAOT3JBuxQ4+b8hlIOpw9soDNxwJMrLaieG8KnaA3IwMDOOnmskOC5irxEBpqOioEAogF4r71h7a76aKoR2sEmhWFWhIi55jMXYFGyLOdg+AgoxlWl9xeJUiVXaG3FIRSw5clQ2FGEicKfiVXa8k3ChANwMmebh4JQr8OrF3ZBg3RXHC1Nj+iQiVnJ+T1BUSiPaSyrOJ3e/nk5UQnMQ1A==
ARC-Message-Signature: i=2; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1775112398; c=relaxed/relaxed;
	bh=nBDwNbLqInncMcvfnC5MecZZNosrgnXD+FkRGipp3bI=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=LMxpBHRtLhktCPmDO8DanGp9avEj6Z5b37+qfYei78nPt7IdiboxMCdBP0JWwtMZ0PPL1bA0xRxxnftuD039Qt1obHTFQedCjXPv6M0x5uy5HMOJy/FjPww1I9c/tE2OyjXy3e0qy4BznhDooLkKke15SvoJyq9mPl31/w4sbbkNyXmJtuVCBJ2gyr05RJSHyq7pANR4JBztuCcEazAhXfb0zb+wqlqQaP3h4JX9ElialQL9tl3DKTqMC8lUwcsePUmP6mMKY1PzdgHpLdCnULr2fgZnJP8Drx+oBQxPmXN6OLk10WQYtAk446DwaR+/3kZTjE4rSFfJjF3Sht1ugg==
ARC-Authentication-Results: i=2; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com; dkim=pass (2048-bit key; unprotected) header.d=vivo.com header.i=@vivo.com header.a=rsa-sha256 header.s=selector2 header.b=SUAghZLA; dkim-atps=neutral; spf=pass (client-ip=2a01:111:f403:c40f::6; helo=seypr02cu001.outbound.protection.outlook.com; envelope-from=guochunhai@vivo.com; receiver=lists.ozlabs.org) smtp.mailfrom=vivo.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=vivo.com header.i=@vivo.com header.a=rsa-sha256 header.s=selector2 header.b=SUAghZLA;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=vivo.com (client-ip=2a01:111:f403:c40f::6; helo=seypr02cu001.outbound.protection.outlook.com; envelope-from=guochunhai@vivo.com; receiver=lists.ozlabs.org)
Received: from SEYPR02CU001.outbound.protection.outlook.com (mail-koreacentralazlp170130006.outbound.protection.outlook.com [IPv6:2a01:111:f403:c40f::6])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange secp256r1 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4fmXSt2tCYz2xln
	for <linux-erofs@lists.ozlabs.org>; Thu, 02 Apr 2026 17:46:38 +1100 (AEDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KQXYcMPpVEnDPLsPTlKBAH/GCGIAY4kybyL5LC4f/MHtvKD6YSO3jgj0iWKNEgxfODks2PP5Y/dhi3RGddsUP1dA5wWE/WdiTmWSDUSwYaO8mUBEGdpxe2Rq3vihpclv5NgookzUXP96CTxMkXAy0vnWMfd5pKnR6Oyo+OjY8u64+fvqpro9OdUWy4uMSG2wqaMp4kN5skXMk3syM50m88oilDIZv4lkBlWMBea9/4VWGq4ZetCv1iy5Otfw4a+eLusWJ+3UpRNGBSMBzBKxhJnKp0fHcGhXG9nDKxWpqGSjE4srOO9BU9lyPMZDSOqS8+aeuHxbTlsjmAtDojz78w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nBDwNbLqInncMcvfnC5MecZZNosrgnXD+FkRGipp3bI=;
 b=bd+B9hhfjv4XKs439x5MU/JC2dcwUZe2C2AUSw7wr2yM5ZhiY8wth33hb2nw8FFtPKsTsO5+wsxm5F2lpwb68LSjrWFKb6ctLmfH+J+rms47Qq7nPepHMOPHHkwayM6eXOnGNYgVFpEtA1c4XRRoMYlFOum+UN6Qs2ThfaE4UMQYqxvGsar9hJbRMXNe1OS79q2CMqzix3/+lsnKynq9k77m6hTk7vwKUm/NyPI64Gk8FcG4Ci3sLm6HR8kdmaEeJN9MIQBAu32Wkt+uP4pRm3FxnF22+9XXK93+1NQdog9hpp58OamE9aPCiXRp0A3ojSd2JxkI8nspfwKXx1tYUQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nBDwNbLqInncMcvfnC5MecZZNosrgnXD+FkRGipp3bI=;
 b=SUAghZLAdHdJ7QdEZzBsqhg2kOP2alaCAoWof9Hu8PYMmtzYFoj6Cl4T5UimVe1/4niXm81Sr9dZF2NFygMFFUM8W6vC4tkUunYVu3xyd+UoSVxLC0NDsthDx2MZRjsEUqJaXRJAHS2OOOa8eNWRBmbDw74IsqUwqjKqsJdWbMVCHHsfDssMmh6eRQ29RE4gACYlIo81E3ven6pXj5cHsMTFfk+FH7a+yIBv3P3Q+Qanqs5/iYet1Rm21Lq40mu2lDS3zMFshrpJP1E4jVwGWN3e0fVoSTotDFEiOzNQ/TDKsQDuan4BwQt1g2Kte2dog3fyZxYKw8AHEk0EAyiucw==
Received: from SE3PR06MB8257.apcprd06.prod.outlook.com (2603:1096:101:2ee::17)
 by TY0PR06MB5596.apcprd06.prod.outlook.com (2603:1096:400:31f::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.18; Thu, 2 Apr
 2026 06:46:13 +0000
Received: from SE3PR06MB8257.apcprd06.prod.outlook.com
 ([fe80::881c:180e:661d:eb93]) by SE3PR06MB8257.apcprd06.prod.outlook.com
 ([fe80::881c:180e:661d:eb93%5]) with mapi id 15.20.9769.016; Thu, 2 Apr 2026
 06:46:13 +0000
From: Chunhai Guo <guochunhai@vivo.com>
To: Zhan Xusheng <zhanxusheng1024@gmail.com>, Gao Xiang <xiang@kernel.org>
CC: "linux-erofs@lists.ozlabs.org" <linux-erofs@lists.ozlabs.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Zhan Xusheng
	<zhanxusheng@xiaomi.com>
Subject: Re: [PATCH] erofs: include the trailing NUL in FS_IOC_GETFSLABEL
Thread-Topic: [PATCH] erofs: include the trailing NUL in FS_IOC_GETFSLABEL
Thread-Index: AQHcwZ69BkMQaKrWa0Oa3/BND2h8TbXLVYuA
Date: Thu, 2 Apr 2026 06:46:13 +0000
Message-ID: <3b4edabf-64ff-4d27-862e-b226872242cd@vivo.com>
References: <20260401061342.40166-1-zhanxusheng@xiaomi.com>
In-Reply-To: <20260401061342.40166-1-zhanxusheng@xiaomi.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SE3PR06MB8257:EE_|TY0PR06MB5596:EE_
x-ms-office365-filtering-correlation-id: 3e887994-bc84-4758-8ad6-08de90838875
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|376014|1800799024|56012099003|22082099003|18002099003|38070700021;
x-microsoft-antispam-message-info:
 e1HOlwttP45xMInZRyEy42UqoDB53tM2kYKBilwxTa+a7y78TbuRlQHcBbj+ooysIqtdm0T7jAJ/IPhwr1u65qG8aiUJIKqZN8MMeWfX3LT0SBVzjNyyvFiNy6I32P8EaFn1pqJwzrVnAcsb015tEKujhbKZWKbZQs9aWOTyWQwr5dHQ+mZTHZWr76oH3yHzDR2pWkw/3ZfoCCncl7cPOm5lsBUTuXaT/yC0afhJekvrpVYEd9e40zwZYuH+PiFDM3Mc8EnEnBSG5SKpfxPcXg0hnU1BMfmR9au/duDCfwnHTv/N9QdkYuqZGUhAw0A0N1oUw5qsDY48EqTLbkoQ2PPVc1F1VGh9yG7fj7gH9W0OzPPFmQ8rbfqknZwZmEUA3MOrmotUYUX1FjsIO3leKoI2b6lf3EetFoB9Ql8YU2VPRbYHgzjIQXURRhP7rr+SVWWxmy5KoQ7h2iCqfaxq+tUkZWdDzw1BQ1DiyDdJWc6uUMNTZAt7ECoWwQMqfPIBDOw1u3WE1XlewThxhzMuQsfSpasTv9qt2Pw0bggLASSH4EhbnqXxpyQ0fasFESVKfSU0csSCEkdDc2MuFS2+GzKXiQ4eXzqI8vPj+APRiP4RFjlUsCwzty3kPK6ZXx5YknGqhDUutMhZz+Gig5ZqHSgWvYhbgNui55aKVIj/O5FUp1LEbxQRIZqJTRyI1FeP8UR+hCh2MKfjkemFDUpM7Nv9Li314cPCWTfP7pd3tkAZtJpBq6T9cSe7w0yj9ul2LARPkHGhpztoEu+/XA2KY63LBZy5AcWuWCB62wK0KnQ=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SE3PR06MB8257.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(56012099003)(22082099003)(18002099003)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?MjcxN1dMNE5CaDV3enUvRmZZU001MFRoaXdiTHdTWEFuVFF3ZlNXanJYd1F4?=
 =?utf-8?B?L3lLcThsdEl5Qyt4dVFkaHpsNHlBTGVRU2xYOUtVd05pOUtEMUlxK2NjWVdm?=
 =?utf-8?B?ZTJBR3Jma01nSEprUFRBQkJuamJwVklBeEJkWUZwMzhwajU4OHVEL0xQNjRu?=
 =?utf-8?B?R1N1MzQ2Ky9KNjlRbVdCQ3NLalZjR2g5eGFjQnZhNHhIZ2c0WEc1Q3dRTnZu?=
 =?utf-8?B?NGl1TG84bkNNb09lYit6Q3JJYVRpZUN4dmgzR3B6TlMycHNtVlR2TG81UUcv?=
 =?utf-8?B?STJGOUJQbTI1Q2xxQm1ScWpXWG95K1dCQkZYeDFBUXdWQXA5QXhOSjcrUThT?=
 =?utf-8?B?WUpGblFMZXBrT21lbXVuRXhQZXNRRVVmSUwrdVhBTmtEN3JUcUpBcWNmbkpX?=
 =?utf-8?B?N0syU0F0Z1BEUldrZG9qbHl6Vjl6YmxHUzRwTmRUbTJCaW82RUc4bGkvQk1r?=
 =?utf-8?B?My9YNzI0MDlmNjBkTVgrY0hEbGFhck1PeXVYNnNmdUdHWmZ5T3FjMWowVE05?=
 =?utf-8?B?WDZSSndvelJOOW1FczNWT2ZpbGpUbk9waHJzVkpkQWRGT3RtZldSRG55bHZp?=
 =?utf-8?B?MGtLOXFzb3NmalV0U1YwZXlTYzM2cmRSRTk1T05kU0NzV3BCMFhzMmdWVlhK?=
 =?utf-8?B?SGRBT0JXRC85TDBHWDF6ZjJqSG5BTm0vbUVPaEJZbjhYRTNuNzg5UEZNNi8w?=
 =?utf-8?B?SUVXWlBhNmcvZmlhc2U5SXBERWUxT3NFVlZqZUpWajIydmJlLzM0T2ErNXVK?=
 =?utf-8?B?NmJNTFkzWWlwaW1Vb3hMZS9Rbmh2SHQ4cGZmVEJoNHBBbTd4ZFJWRHE4Mi9C?=
 =?utf-8?B?clhaeWhMSmNQdU80MklNTVZ1V2RpWkJiRzJzbjQreTd1R0V6UlhLN2N3NHVL?=
 =?utf-8?B?WHlYdTF0ZUNydVZPTE1MeHc3ZVVOV3BHVFFJMlVKSUswM3FkQ2R0S0ZTbmNN?=
 =?utf-8?B?QWdnbk44WjNIanFPWnZhd3ZUckxKNElVaDVxRHdTVzBNWTdSSU43dGxpSkRN?=
 =?utf-8?B?NUg1Y2toVnFyZkVLeVlTOGd5Y1RoalhLQU9QbW5CcWVWTWtla3ZZVnd3My9k?=
 =?utf-8?B?dDZLZW83a1NydS9sK3JUOW9PWkgvOW9FUXNpUTdndHlHd1BHUGFLRXZkY2xr?=
 =?utf-8?B?bFlOQWk3SFZPMFlrenRwKzRjaDZ2aitnc0NSTm9DOFlZeC9FMU04aHRLZ25K?=
 =?utf-8?B?ekp3c0QweSt3UDluUVBBUW1rY21Ld2lmMVpXcjdyV1JSdlRCZWxydUYzbkxj?=
 =?utf-8?B?WHJmdGVzMUlUWGRJR09NZW80eFlia0wvZHZZbWw2Sk0zdFdNREdUTElVbFVR?=
 =?utf-8?B?SUplMFoxRVl5RHlwRlZEdXdIeGw3VXJEN0xvVjYrUEh5bUxHa3AvSjVGcFJz?=
 =?utf-8?B?WkdQUm5qSnhOcEloZFUwRWcveGRjR1VaWTAzUnh3eXNwQWVnRHpqK0ZhdG0v?=
 =?utf-8?B?UTRnY2UxWXJ5ZTRSYVFkY1NJUFl4aTRZQmxnK3FRdmZyY3VTb1dvbEswQ0xI?=
 =?utf-8?B?UVZMTkUveFFtVDlDdlZEQUJXWVkxa29BSkhsWUVCWUoxTlQyY1gveTVic0tT?=
 =?utf-8?B?L3RFbXFOcHJ2Mmk2QlovQ3hKNEp4UTNVNzVFVWRCVXg2TlpxU3lxeTFQT0dO?=
 =?utf-8?B?M2kyb2h6VTd4S3FNbHdScU1zMlZHRzFwVGVidW1uQUJSeE5yQ2RsdHhraTAv?=
 =?utf-8?B?UnFXK2dndDVNcy9oY1M0dlo4bllsb2FLdmZIVFVha0Jwa0ZldG40SDFUV0xF?=
 =?utf-8?B?V283bWI0VGpIdmpFQVNDb3NtMksyVzZVc25VWGdGclVjYW53RFNsNGpvenlY?=
 =?utf-8?B?cWE5OXV4VDFTOGFzMlJRNmJmbi9iMEk2eFBUZXBEb2VrTlRwYTM3aFdOYS8r?=
 =?utf-8?B?L1dwSWh0bVcrd1FKUTh6RTNEcFRZYmtiR0ozUjhIVXFkT3lWMDh4c1oxQkxE?=
 =?utf-8?B?YUJUeCtRdGNBVllDeTVwOWR1dVNsWVlGQldzQndVb0JKQ1dDUG0raTJpek9D?=
 =?utf-8?B?RVErMUNLTW1yaytxM1E2L1J3L0VWcTR4emhLTHY0UmprYWdJRGp5dmVyZWNm?=
 =?utf-8?B?OTFuQlNtRVViSFVGaTMwczA0b2d2S0p6NUpKZlhEK3l1b1UzcmdKaDRnNklo?=
 =?utf-8?B?QzNhdHc3WWE5ODUvWXlSSTdNclQ3Q1V1OEJnSW0wOHk2TFM4NG5NbWVIYWlC?=
 =?utf-8?B?RzY2ak9IUEhsc0pVcE9YT2VOM216QTh0L2JFMkY3SVJXMmFKUjRFcVAzUi9m?=
 =?utf-8?B?c2Y3bDFaL2RMaGlpYm1kYWMweGNwU1RpMEN2bGNtZ0NLVE5EdFlucVM1dzVi?=
 =?utf-8?Q?H91Gl0flAmfT2vQQiE?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <4F0BEF316CDF5E44A30FD544AE282380@apcprd06.prod.outlook.com>
Content-Transfer-Encoding: base64
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
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SE3PR06MB8257.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3e887994-bc84-4758-8ad6-08de90838875
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Apr 2026 06:46:13.7622
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: edVaumyQXeRuBsGU2V/VGfxP82DKiAfUzXix8EogJ5F+D57fOXR72JaJGriUv6wFXL7hl8dnVK66eDfVt1bpJQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TY0PR06MB5596

T24gNC8xLzIwMjYgMjoxMyBQTSwgWmhhbiBYdXNoZW5nIHdyb3RlOg0KPiBlcm9mc19pb2N0bF9n
ZXRfdm9sdW1lX2xhYmVsKCkgcGFzc2VzIHN0cmxlbihzYmktPnZvbHVtZV9uYW1lKSBhcw0KPiB0
aGUgbGVuZ3RoIHRvIGNvcHlfdG9fdXNlcigpLCB3aGljaCBjb3BpZXMgdGhlIGxhYmVsIHN0cmlu
ZyB3aXRob3V0DQo+IHRoZSB0cmFpbGluZyBOVUwgYnl0ZS4gIFNpbmNlIEZTX0lPQ19HRVRGU0xB
QkVMIGNhbGxlcnMgZXhwZWN0IGENCj4gTlVMLXRlcm1pbmF0ZWQgc3RyaW5nIGluIHRoZSBGU0xB
QkVMX01BWC1zaXplZCBidWZmZXIgYW5kIG1heSBub3QNCj4gcHJlLXplcm8gdGhlIGJ1ZmZlciwg
dGhpcyBjYW4gY2F1c2UgdXNlcnNwYWNlIHRvIHJlYWQgcGFzdCB0aGUgbGFiZWwNCj4gaW50byB1
bmluaXRpYWxpc2VkIHN0YWNrIG1lbW9yeS4NCj4NCj4gRml4IHRoaXMgYnkgdXNpbmcgc3RybGVu
KCkgKyAxIHRvIGluY2x1ZGUgdGhlIE5VTCB0ZXJtaW5hdG9yLA0KPiBjb25zaXN0ZW50IHdpdGgg
aG93IGV4dDQgYW5kIHhmcyBpbXBsZW1lbnQgRlNfSU9DX0dFVEZTTEFCRUwuDQo+DQo+IFNpZ25l
ZC1vZmYtYnk6IFpoYW4gWHVzaGVuZyA8emhhbnh1c2hlbmdAeGlhb21pLmNvbT4NCj4NClJldmll
d2VkLWJ5OiBDaHVuaGFpIEd1byA8Z3VvY2h1bmhhaUB2aXZvLmNvbT4NCg0KDQpUaGFua3MsDQoN
Cg0K

