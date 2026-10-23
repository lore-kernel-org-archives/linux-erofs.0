Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C4D2606A319
	for <linux-erofs@archiver.kernel.org>; Fri, 23 Oct 2026 02:32:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=sony.com header.i=@sony.com header.a=rsa-sha256 header.s=p1 header.b=Na8isWUY
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4j9n9q4jW7z2xnv;
	Fri, 23 Oct 2026 13:32:47 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=pass smtp.remote-ip=185.132.183.11 arc.chain=microsoft.com
ARC-Seal: i=2; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1792722767;
	cv=pass; b=b7DwINlQHY03l1PiP34kolEIhZMXzze2Nk8jXfYdPeRNfLbf3xcFRPx9uPeOMOpgdZtkq63PD5epvaAAz5iRuZYi5QZKunES1eHJXU3/0uyKq6AAQpFMDOagv51v1UKB0J/CpQWtsmRcy7sHXHtYX6AkQk9jpvJNG8jn5Ngq51zn4DFgpHOIV6HZGdepEzLjlBO6wn4KtXTZ4AEV2tG1+F8Pj2lDtGuvIN52Mw3TTs2BT8YqU77ErnTjBEvRs5rDMbaQpCZHpJaUEgJqidcKOrx/v2lELWuFMgun60OkUAmSc/rLpYoPKx6MUV6R/qLfF027E9D51oGx2xBz5+Zkmg==
ARC-Message-Signature: i=2; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1792722767; c=relaxed/relaxed;
	bh=GtzgE55cN67hd1jiQIK7BiV2/2X+ObRkWS5aL9Gc4Ug=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=E2BMNSq7TppE0fWmfiDjV84xpU56+p0L+nCeBvKhg85qes2OEJR2hI2JPSGx5FsgUJy8LoNMFqNARSwBqr9JlY0eTq8Mqje1EzLqI86f+UxROEk3CiMyrQRth0nnh8lsPj2Jw7M7DDHBfjWc4dJb+9i5GNrNAJuhQFrCti3jKL69qsCAHmrh4sTALLnBTr099fPWNcx/4SfTwwhGz+bjvJvVuVIZjKUyiZx4J9ebaPPvAG4z/eRhgNP1vCOqKQ3bxZf5DBs/HADgZNoYPV6z6kQWBN//GKaNeC+hCH5k1FAqm7X/qAbCL/XbuPdopBJpTnIMtzBBThFhpUrB5p24Iw==
ARC-Authentication-Results: i=2; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=sony.com; dkim=pass (2048-bit key; unprotected) header.d=sony.com header.i=@sony.com header.a=rsa-sha256 header.s=p1 header.b=Na8isWUY; dkim-atps=neutral; spf=pass (client-ip=185.132.183.11; helo=mx07-001d1705.pphosted.com; envelope-from=friendy.su@sony.com; receiver=lists.ozlabs.org) smtp.mailfrom=sony.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=sony.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=sony.com header.i=@sony.com header.a=rsa-sha256 header.s=p1 header.b=Na8isWUY;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=sony.com (client-ip=185.132.183.11; helo=mx07-001d1705.pphosted.com; envelope-from=friendy.su@sony.com; receiver=lists.ozlabs.org)
Received: from mx07-001d1705.pphosted.com (mx07-001d1705.pphosted.com [185.132.183.11])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4j9n9p0hGyz2xSl
	for <linux-erofs@lists.ozlabs.org>; Fri, 23 Oct 2026 13:32:44 +1100 (AEDT)
Received: from pps.filterd (m0209326.ppops.net [127.0.0.1])
	by mx08-001d1705.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69N1G3g53222804;
	Fri, 23 Oct 2026 02:32:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sony.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=p1; bh=GtzgE55
	cN67hd1jiQIK7BiV2/2X+ObRkWS5aL9Gc4Ug=; b=Na8isWUYHIt+6AfCPonsS0z
	rxJzHJDL1d9iC4B67TD3OTbESHQmdashj/YBSkg9FecZPabIsJqyIeh8Y2SVW9EN
	43jYyQF3aby/GeuBcofBz4S84zMz0ZgjyzOJcqktikFTxbfCOG7tC7lVHK/FW0bF
	n7cXf6175SbCYYhAyejV9yyLtENcTXWt6cAJudmJfNOzSVfirR7uCFlF7GnpotNQ
	oGo3PDnuxoj0gAr1B6FG/1HyWWwuij7UhQ5eGmWZpVkjpTRFq5Jf8VnEHWaAuK8F
	w3Ycy698C7z9KeldRx+WeK+92JNwO+DbvoP/z708IS/Sx7pupRnDQhwDa/NcKOg=
	=
Received: from typpr03cu001.outbound.protection.outlook.com (mail-japaneastazon11012041.outbound.protection.outlook.com [52.101.126.41])
	by mx08-001d1705.pphosted.com (PPS) with ESMTPS id 4hdw4ycf0j-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=OK);
	Fri, 23 Oct 2026 02:32:29 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KLKm20nCf9D2TunMMaVjDMtLqkm1v0sHUVxlPqerdKE3V/Ed3T2+istOPMse4jPcbRSL0+Soum+6iGL5pQJeK0kYoLwqs7AtFvA//4EXgpQFLQ2UFHHRvYPMp1dWXC2BAj1LPC0H+/DKwaeQ5hmwnKn9JEmYW/dlDH9zaGMHQ2Kq9JopR7kkKvaSTwuOzYZ67Udx5tLYCs3DlflRNUd4uKwAaSLUGBPUpJpLv5uypzB1+emI2PFBkskMuImsNrFb0R7R4Nh+OPtHqJx+lODRJtxJJ+oi9cTGYqgHz+kDIVT0Ue13Qo/ZL2/Vn+Hnm+/1hLVEIWCHoZRX6s3ZcPzs+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GtzgE55cN67hd1jiQIK7BiV2/2X+ObRkWS5aL9Gc4Ug=;
 b=SkFFn4f3gWbrPQUIbIAtrBNJNd61G4/t3A88GGTyPBQf4cxqGRuiV3QkTr7IIAumIYxeV5tlXXq+Fu9iWIgJ9Z3HsgsUMDfG2HsE1SQ2bSuhduo7b/dzZduIeIZxy+TVij7N8ULtRY8DtkML7ogNMUK6elgyQfLW5xS/EKPq9ts/8XoS86oHKaPR5DIqCAP1OL/LW4O/hT8MgMjAanBv5d8uV1XuCTjka1HjQYJOeWBH04dPvY9kytHhDwVw+KyWWsD+zoYf5FOmMZRVOtRYbaotSzHYC1zLs6TYnv8UM1qO8K0RkKPFioYuE2Q+AaFA4WCd5hB0wImHThHGNNYvvg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=sony.com; dmarc=pass action=none header.from=sony.com;
 dkim=pass header.d=sony.com; arc=none
Received: from TY0PR04MB6191.apcprd04.prod.outlook.com (2603:1096:400:32c::12)
 by JH0PR04MB7250.apcprd04.prod.outlook.com (2603:1096:990:3e::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.18; Fri, 23 Oct
 2026 02:32:22 +0000
Received: from TY0PR04MB6191.apcprd04.prod.outlook.com
 ([fe80::aa83:1e3d:19d1:736]) by TY0PR04MB6191.apcprd04.prod.outlook.com
 ([fe80::aa83:1e3d:19d1:736%6]) with mapi id 15.21.0546.017; Fri, 23 Oct 2026
 02:32:21 +0000
From: "Friendy.Su@sony.com" <Friendy.Su@sony.com>
To: "xiang@kernel.org" <xiang@kernel.org>,
        "chao@kernel.org"
	<chao@kernel.org>, "jack@suse.cz" <jack@suse.cz>,
        "amir73il@gmail.com"
	<amir73il@gmail.com>
CC: "linux-erofs@lists.ozlabs.org" <linux-erofs@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Yuezhang.Mo@sony.com" <Yuezhang.Mo@sony.com>,
        "Daniel.Palmer@sony.com"
	<Daniel.Palmer@sony.com>
Subject: Re: [PATCH v2] erofs: set SB_I_ALLOW_HSM for bdev-based mounts
Thread-Topic: [PATCH v2] erofs: set SB_I_ALLOW_HSM for bdev-based mounts
Thread-Index: AQHdYpT5uYRh4g5Ytkao5CHS76ViOrcKZ/V+
Date: Fri, 23 Oct 2026 02:32:21 +0000
Message-ID:
 <TY0PR04MB6191A05CCB7E65F910A5B07DFD642@TY0PR04MB6191.apcprd04.prod.outlook.com>
References: <20261023021635.2852395-1-friendy.su@sony.com>
In-Reply-To: <20261023021635.2852395-1-friendy.su@sony.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
authentication-results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=sony.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: TY0PR04MB6191:EE_|JH0PR04MB7250:EE_
x-ms-office365-filtering-correlation-id: ad6ee4a4-8bf1-472a-eaf9-08df30addd86
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|366016|23010399003|10070799003|376014|38070700021|56012099006|11063799006|261022105027099003|261021121427099003|261022075727099003|261009223027099003|22082099003|18002099003|10067099003|261022115727099003;
x-microsoft-antispam-message-info:
 4musVHddSGgEOJdGu0Y0UZsz5j/gHboby5xEuHRTb1llKOQZxjYbKSZ3iJ70Gggq4PEKUSTjnNprn1uR8xDxKJFzW1rtoIzwpGPQLHqkoORqveHPEOe84NvN5z3YC1P2NM2D39GPt0M0hoSod3i4gQcoYfa4D5NpJm0hEutkXjwMurHOZu4s15WStg2rYuHCovKpZPvnWoNc5uQEH+sfPhfG7fuoyp8Ff0qKpYQy2m1Dvl/a/irstgHaWMrb7NYdMS7ag5ciJWxMaED+sT+PL50+YzCM5edgC4Pe53GJe89KIO8lYl71K54huuK/MNCj078jFfySH2CaxCOi3iwmOVXMRqgF3ixrHVoUe6It7h8mdXv44W9C0Ja+oCZ9B7n7nrLBhoHGHYMDhRq/ScSzPJjymKgZVik6vj3xMvTCuFqyEcTWAlw3hYab5uj+EZKqlopvkmwoPu3lEVsV5lAZBcF3aKFdWVdupf3zmRp959baIcDwynni2r76gl/l0txa6GU2f0qFKzA2w/c6YZqnsH/w4jMfUSOQdFdMGyk7ihJm/4Xw0KSUuXHaQgpolC80lWtYAN78gSOj4fl2U+JQogfNLIbDgVNTeAjHIcBqsbgd75KyKNXalvN4+TVW4Nwyf6jq5DuSN1m10+3gBlzphO0inb3mpbMJGcqj10g/zjX4u+ji4EHcP1rm8+6mU0mBBQE6YmrTyCi6Z1gLENrqU1IWmPkC+PWYuvwUVkzX3+A=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TY0PR04MB6191.apcprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(23010399003)(10070799003)(376014)(38070700021)(56012099006)(11063799006)(261022105027099003)(261021121427099003)(261022075727099003)(261009223027099003)(22082099003)(18002099003)(10067099003)(261022115727099003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?95Lp/Wmx1jsr/tI5Dfwj/1gso3TLd/HM2SO65pQ64CXGMoB9/gilBeLpI2?=
 =?iso-8859-1?Q?YNHDv2mLO8QBqZnYAMJRzEBmNgcH0DQ+Z1uBY54SXWnrOApN/2FfCOItgY?=
 =?iso-8859-1?Q?cLPflxCzzTx3ZbszJmDoMiWWvbrT8kshy57jLTx75vL+zR4UJzmeI24Njk?=
 =?iso-8859-1?Q?ehtc+sZcBLdDaIygS862a9HdklNpkU/nlrzR0EnnK9fF8GeatkmRUe7nly?=
 =?iso-8859-1?Q?RHBq4AHFiwU4a+zlGE57wDyoW+YJ7CStRpKX7ViWmBdmov1ZV3ZVjyogTg?=
 =?iso-8859-1?Q?94psdaWjEeRr22npE1sQUMRarcfhArQVZnjr1JSxWZNwsWagWMsAg77U96?=
 =?iso-8859-1?Q?D8cD+r1hT6z7edCMqXqZYthQX363wqEF2EGPW441beX0zm/nRATFm8ZtI8?=
 =?iso-8859-1?Q?ue8CNSjpxkfr9zHJwG1N6ALWAwZWC5uZFTW46L90rJ5Y3qW1GRaykzudeZ?=
 =?iso-8859-1?Q?sr2EILEddaYKsi0Da/HoPxZ6zbITdgDZ/7TqSFEOEE9xe+U4ZrBjZZS3/4?=
 =?iso-8859-1?Q?S6B4SX+sj2L9Mr8lM9hfAdLlO8uUCYBga2OTS/ZTO56EoAiBGzmoI+nvc4?=
 =?iso-8859-1?Q?sYSmyMyigJxwR8G2bYI5YOrJDI++FQovkj3HLEMimBcuQJg3i/iQE6Yez2?=
 =?iso-8859-1?Q?ZPGS7v7YSKpssyoDyqbceKdswsHWZDgdmgrSNsxTUSPPrGwbmJg9kuy1nx?=
 =?iso-8859-1?Q?v5KK5EO+EPizDX6ZR8w8NRhq99j7ufaw/Wv+1s/RepwhKn/y4D3D3OUVBW?=
 =?iso-8859-1?Q?AXBBVLPUeuzlqR0FrAq7gLUFQ7wmQHTOU46LTj+5+XOPG5Z0KpENfb5TXA?=
 =?iso-8859-1?Q?56X2I7du/2oPQKT4azMpruPRzpzCgsOczpDlpwXl6h3wekDii8dEhh/bU2?=
 =?iso-8859-1?Q?CBQFI8Z0mvOknkwf5F1xPeyE4MrMG7ZlyMlApKqv3edVTz6F07YnrskmMk?=
 =?iso-8859-1?Q?cWnis6UQ54q3uSmffglY7BQEjv3zDbr9qJqeR7pmLMh2O28xMHWHQQiEDN?=
 =?iso-8859-1?Q?iZtWsnVCDZYdebdX7xM4t/Btb99V46shGK990t6njIublk29AkbMuDFK8S?=
 =?iso-8859-1?Q?CDu9cFDp5SC1L6lCwsMTAMwwslQel4mzZgb6g4h8+1yLC9Kfd6zeKj3dgi?=
 =?iso-8859-1?Q?to8vJNVqtrxieDuazYbcqFahS4ImPSLeNtOiemnAbJB8Pf4E8EAozUiZ1x?=
 =?iso-8859-1?Q?+28w5qKwJm3qZbbXtGBeEMT6gGisINM74X8NgZvCGEwx41HdtCgT1TnOrS?=
 =?iso-8859-1?Q?x8Esv3GdKJBuzSt4nFSA8SfJrOhjMHdbD6JwscTPeKaKw4o2FTFl3N8cMn?=
 =?iso-8859-1?Q?BuKPQfXZ7C99fKgPzm+SdemXS01OfEAqsaJ6feNgRDyQOpGaUF5uViQQx2?=
 =?iso-8859-1?Q?YQkL3Wzz3T0YFN/Tcyu1XIhn8nZwxpM8c9V1K9gDBQozYaDu/m4xyFqVNT?=
 =?iso-8859-1?Q?6jAFpwpIoDOtUljsACSqNrLLLw8QgAr3DWqJL5vR2M49dgFIIDl7Ddja2L?=
 =?iso-8859-1?Q?EJ7grOiljJyekjS63u+7c7VklmdY6gyEobjzJ4riSml7F7TiMBpqBFKtyT?=
 =?iso-8859-1?Q?geUf9+VNMDvUDWkBxKGfskYl4qD09jso3/aI2YxC74KfF7VW6kHLO0d76c?=
 =?iso-8859-1?Q?t8ilYG5Hi7342wXHYEVCCc3O4OdhbFNqGYSw4gBvy6Cz+Cv+Zya7riU2Wa?=
 =?iso-8859-1?Q?mdRVF0e1bc0JkYYRRF39ayA+g1YUUFZ0XUeKKnJ76Ah9ZUQtM8VTl76PLJ?=
 =?iso-8859-1?Q?ytokTC46h8s3k6tvx1LT7mnzDHQEL0pEQNgVR1sMLK5IVn7AVzw8l5brwA?=
 =?iso-8859-1?Q?IdRDUNp4LnPCjp7RpsF7Owoi/UkMHSs=3D?=
Content-Type: text/plain; charset="iso-8859-1"
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
	MlX6vI5e2BNbvOgnWIKPlO57hnAidGuMS5ZyNrFAmrfzpNz/BtDUKyeHiE6wPprtwbf6AyzEGWp0fjoGixyXXciFVQCK8Z/XpHNE6eOCh/o0Y/GyZ69kfol5WG/6ryaYCtU9Mvo7n515xZNmfpj8IlZjKUOyCa0y3uV8TUR6KhdZGwVakIDedwEaE1HdFI96HD+6ggFCgB1r65FigjmdfyHpRljNRyBRUkWIov9+iJHr9Emnpi6G81JZt06WMPoYC1CJKMHJqrwN2xXvpV6rOkqj+WXQSQkGCrMFsgEGtTlQAsto/Y4aECB9VGha7+MiGeQY0jAiClQBPjxFpbmemA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	EVuCzXKVeSGlGlJCcJu6tO6/1/giZOeTex11h/hMNQx5AdA4sWKF5FCoDWNvod3oV18mC1edh8zcVK57V8Dwsa6TmpnagK1vr7Kii+xA3ZZ1g2VvvwtfZOu/Q/3V9vaHvnSsmXZQ+QtyyEMzwaoqjoi1tsGNb0EfUAOr3kB5Kd/IyjTkpsRKoBw4Cijs9bzxnYEuAwmFfKPgoiBHLdHbG6Y91Q5kWzdXeZnO9idoKwjNHIsEXQrDvKvV/78nVZqepBIe3wK51DFj1BkynE4FSn+u6cJxyReYayv+npfWfvZLi4ixWZthRpYnaCpNpSmkk+Wl5cSZum/qWXbZEw/t48C+GZJPE3uPFwqzLyeCKsufQ7waYEC5TXf+n5SnvSc2yCsc7E9eAhwZEw3e7DejnhyzP1v/nYJRzFZlkq72e+IYhgPgSj/8pM73oJT3lADdrvxJarQQz/QgrtjGoyontoIO0Ipwf/p7wmGdZLKJXAqLHZ7qgfeRkdDHToplHObRm1D3ittxMiA7R1wsXbfAb6dYKW71NgDcMbM4mr4a+l/N/HJ2+uOfBTjdNqKS7ojiA34SCU+LDWNEpvwpproEXpXDMl5J04X56fjOGDEl8WVt86ha/dtcVRV1g8mCypG3
X-OriginatorOrg: sony.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TY0PR04MB6191.apcprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ad6ee4a4-8bf1-472a-eaf9-08df30addd86
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Oct 2026 02:32:21.3824
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 66c65d8a-9158-4521-a2d8-664963db48e4
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: aLts+mb0hDgvUBHako/i6ILBJ+M1gba/bTdvyhqM8FQ1gW4vfoSDtB9LAOLIS3FJG+HwQKdFB2BdCX6/YGSMwQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: JH0PR04MB7250
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDIzMDAwOSBTYWx0ZWRfX29PPT1TSnokY
 GbKVJbVln2JtCidvFzhyRzu1K0lYpKr/o7ViD/RWPOC/FwStAmLaHjgMx98Ji/OnfwhzkIqvsJL
 Ap1WGnpLBzu/RDEwHQvOU7q2ok9L4W+nLoOIdocCKPxVRkCCQgjd1GmLXMjPiGa9cfvmwR7Bu3H
 Mj9YmyoxJzxrOK5TZGAScrjtiEHAztsc471n/ELZ/zpeurSLKXTZU6wWL1MWH6xhyDR4bBlX+1J
 E8HjNPrVOaDpvfDCAi8gsNIf/bHUe5p0B9/z6Xa+1HdZhWfdyp6V3K/Tn71WkfbEpHWQ/FBb1JV
 4L7cIc8B/+SMW/L/gjb+5PYS9jUR0/zBOUDks/vTMZeqCbTooKBRxy0toTd2VwSccwY0zcoflQi
 UEuofWOjjyEpf3cOvVmyh/aNknPpCQlDNOaqU2lhmQ6/oKdTO4/B8v/pPPAKiUSa49ZDYuQZLLq
 1iF44LiXZPmiVN3uFig==
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDIzMDAwOSBTYWx0ZWRfX4Hi4OvH5lfuf
 odyVrsyXbEL3yzB4QhbO2ikP2tH0FyDo1Yeil0rNjXTsjF0CPfEcyY5uc+kCy8fjnoPcTssWGDH
 Ld0px2U/bBvv1iFDtN/W4W3TjTqdTip/AcC/PON8sWWl/dSMGfDl
X-Proofpoint-GUID: VpHTjSodXUKef77uTlPi5X212SUF9F0L
X-Proofpoint-ORIG-GUID: VpHTjSodXUKef77uTlPi5X212SUF9F0L
X-Authority-Analysis: v=2.4 cv=OuzaWC/t c=1 sm=1 tr=0 ts=6adac73e cx=c_pps
 a=asJOei98DcUXs9cTXKz9ZQ==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=8nJEP1OIZ-IA:10
 a=660iZSQnnn4A:10 a=7j0FZ4iXMVMA:10 a=xR56lInIT_wA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=KAb5x4SsHD3PzxGk7EmX:22 a=lmptg-Pxpg44AF-n8Qp9:22
 a=z6gsHLkEAAAA:8 a=VwQbUJbxAAAA:8 a=pGLkceISAAAA:8 a=voM4FWlXAAAA:8
 a=SqQ6MPcMXgqzPSFYyf4A:9 a=wPNLvfGTeEIA:10 a=IC2XNlieTeVoXbcui8wp:22
X-Sony-Outbound-GUID: VpHTjSodXUKef77uTlPi5X212SUF9F0L
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-10-23_01,2026-10-21_02,2025-10-01_01
X-Spam-Status: No, score=-16.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi, Gao=0A=
=0A=
I will send patches for test in erofs-utils.=0A=
=0A=
Best Regards=0A=
Friendy=0A=
=0A=
=0A=
________________________________________=0A=
From: Su, Friendy <Friendy.Su@sony.com>=0A=
Sent: Friday, October 23, 2026 10:16=0A=
To: xiang@kernel.org; chao@kernel.org; jack@suse.cz; amir73il@gmail.com=0A=
Cc: linux-erofs@lists.ozlabs.org; linux-kernel@vger.kernel.org; Su, Friendy=
; Mo, Yuezhang; Palmer, Daniel (SGC)=0A=
Subject: [PATCH v2] erofs: set SB_I_ALLOW_HSM for bdev-based mounts=0A=
=0A=
SB_I_ALLOW_HSM makes erofs support fanotify FAN_PRE_ACCESS event=0A=
for bdev-based mounts. file-backed mounts do not support this.=0A=
=0A=
This is for use case that erofs file data is not available on=0A=
local block device at mount, but need to be filled at fanotify=0A=
FAN_PRE_ACCESS event handler.=0A=
=0A=
E.g. format erofs to blob mode, meta data on /dev/pmem0, file data=0A=
on blob device /dev/pmem1. The file content in blob device is dummy.=0A=
=0A=
mount as below:=0A=
=0A=
$ sudo mount -o dax,device=3D/dev/pmem1 /dev/pmem0 /mnt/erofs/=0A=
=0A=
In FAN_PRE_ACCESS handler, actual file content is fetched from remote=0A=
then filled into the DAX mounted block device /dev/pmem1.=0A=
=0A=
Signed-off-by: Friendy Su <friendy.su@sony.com>=0A=
Reviewed-by: Yuezhang Mo <Yuezhang.Mo@sony.com>=0A=
Reviewed-by: Daniel Palmer <daniel.palmer@sony.com>=0A=
---=0A=
 fs/erofs/super.c | 9 +++++++++=0A=
 1 file changed, 9 insertions(+)=0A=
=0A=
diff --git a/fs/erofs/super.c b/fs/erofs/super.c=0A=
index 0967aace9f7f..be8728b8d116 100644=0A=
--- a/fs/erofs/super.c=0A=
+++ b/fs/erofs/super.c=0A=
@@ -667,6 +667,15 @@ static int erofs_fc_fill_super(struct super_block *sb,=
 struct fs_context *fc)=0A=
                errorfc(fc, "FSDAX is not allowed when inode_share is on");=
=0A=
                return -EINVAL;=0A=
        }=0A=
+       if (!erofs_is_fileio_mode(sbi)) {=0A=
+               /*=0A=
+                * Only enable HSM to support fanotify FAN_PRE_ACCESS event=
=0A=
+                * under block device backed mounts.=0A=
+                * For file-backed mounts, do not enable since erofs-utils=
=0A=
+                * has already supported FAN_PRE_ACCESS event on backend im=
age.=0A=
+                */=0A=
+               sb->s_iflags |=3D SB_I_ALLOW_HSM;=0A=
+       }=0A=
=0A=
        sbi->blkszbits =3D PAGE_SHIFT;=0A=
        if (erofs_is_fileio_mode(sbi)) {=0A=
--=0A=
2.34.1=0A=
=0A=

