Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF3AF606A31A
	for <linux-erofs@archiver.kernel.org>; Wed, 21 Oct 2026 08:43:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=sony.com header.i=@sony.com header.a=rsa-sha256 header.s=p1 header.b=IR+t++XW
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4j8jVK0qyrz2xGg;
	Wed, 21 Oct 2026 19:43:21 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=fail smtp.remote-ip=185.132.183.11
ARC-Seal: i=2; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1792572201;
	cv=fail; b=WjFzVZRHwty49ak9o3zApL0IGk1+mNo3TS/i8w1nsGhxaCxgjAPgfC4PjuhBLHSupt1X60YjFuz58XAn3bLAC4aQ40jRNjNkHAj6VjomBgEWFCLuaG/SpGBpcGXFAQLNrd6x3wuQSTPDvN354orT1xVpszzklvHuIeAfqv4iR6oXa8CAolwnq378zABvpz49KJqivkOnFKKmwUgMSp2EFXGzYL4y59meLOMOTB4W6VoqBzPQEZARpheyVyU+asjB21N1HnVT8lICdz8H/JxvK2BCy7rjuainDygtZWGZB2CQWz4NpokNyl89EJmnYwnoLiE2SFPySHd0XsPcgDnrkg==
ARC-Message-Signature: i=2; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1792572201; c=relaxed/relaxed;
	bh=aK2dgm40HRtc2OvKnLc3HArq/G4ROuhonQwdaP1sVh4=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 MIME-Version:Content-Type; b=Ps2SBIeSEOCztw+xRMn+Z3xQaSR5H9V/QYDgYdvicTwh2V/g2Kuf/mBPMYOzeXQRo4ITRRegmzq60oCDqA7lciC4/HqXcvAu0hPDqwoPrw5Hn15zvt/jrxpBcskJt+1CLqD5Zj9ecKhrDyFOKD1zPH15s4Yu+KEL02h7kovgedPaurlQwAPnuJLban7ZIJuZUif9uqjF9hJ2H3JjQxAMQSQvLvoKdy2MOeN49liUdmGDj5TpLZw1y+Xd+AZsvQE1ZSHhwQeJ+YtOP3/aaI95OJuXj7KWjwT2pQBFZ014SfyWlpElDW957TlYKC/wvb3uKbtkyOwcPYM49dCMVJyKHw==
ARC-Authentication-Results: i=2; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=sony.com; dkim=pass (2048-bit key; unprotected) header.d=sony.com header.i=@sony.com header.a=rsa-sha256 header.s=p1 header.b=IR+t++XW; dkim-atps=neutral; spf=pass (client-ip=185.132.183.11; helo=mx07-001d1705.pphosted.com; envelope-from=friendy.su@sony.com; receiver=lists.ozlabs.org) smtp.mailfrom=sony.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=sony.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=sony.com header.i=@sony.com header.a=rsa-sha256 header.s=p1 header.b=IR+t++XW;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=sony.com (client-ip=185.132.183.11; helo=mx07-001d1705.pphosted.com; envelope-from=friendy.su@sony.com; receiver=lists.ozlabs.org)
Received: from mx07-001d1705.pphosted.com (mx07-001d1705.pphosted.com [185.132.183.11])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4j8jVH0nmTz2xB1
	for <linux-erofs@lists.ozlabs.org>; Wed, 21 Oct 2026 19:43:17 +1100 (AEDT)
Received: from pps.filterd (m0209328.ppops.net [127.0.0.1])
	by mx08-001d1705.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69L5iMEO487296;
	Wed, 21 Oct 2026 08:43:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sony.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=p1; bh=aK2dgm4
	0HRtc2OvKnLc3HArq/G4ROuhonQwdaP1sVh4=; b=IR+t++XWo6emQ6yKMiX/1OE
	gt6+Var/qXc+owpW50SEEGMEj2BDwXsbHNiyRuWwF6CxaD5/vM6QiPB9liLhCVfk
	5a9GwizsgjBOXIzv/NFqfmFyDQhBTFrBsrRdcKzJNCq7B6wberKm283rtfSvfbby
	3ck9F1hWlaFwAuckzf7kWg8Y1Ex3jN3iPs6FX1oG+OwiAp2/rRTzNKZ8+QcTPOiI
	ZSD/JRlDYB+PcNHfi8vLz5BnV4bPVoKg8cSrrL+IfJXdIVShXWB1ofZiOfEen874
	XsvOyUkG68SaWOG+qFn6IIM/VPZUI7FwuXcRJ1e5z4kM608Khcr9kP42O6Y6HIg=
	=
Received: from os8pr02cu002.outbound.protection.outlook.com (mail-japanwestazon11012070.outbound.protection.outlook.com [40.107.75.70])
	by mx08-001d1705.pphosted.com (PPS) with ESMTPS id 4hdw4yhyw5-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=OK);
	Wed, 21 Oct 2026 08:43:08 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=P5AxDJd4bnqhFagGW/HwPmEzivxBSSooW1oN8ZHOPBWvHGpgVTyGps1ijywviQ0DZG+GaQ4iqrTCdVOddQaZg14KudXzkqS3Hvc03bBdH4YxFnRwA9LTYHV6OEm5gshAHt4/k93ftaspeAy+rAGkd+WcpysaCrfmlQf1T3/i9d5VuDR9usubwftfWf6/aSiHiZLItdLwwTvf2ufH50JAsh1uWy8aG5CeM1FF/jZLHwNhoZzTun421iV0PBI6lGdz/4l0AUjkHOddNTpanWeezj7/g8/w+BnRPw9RoVTrD1vF6DKTxCXUod4PqPMQij8wzE/bnvY202pP+u8g40vpvA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LrcIqLrF5RHJFBzfhQ8PD1WjJNd/wJ9kLBbuXTVFxf4=;
 b=GLdDXRtIH1SHwdtYgZNIA5SEn8jEHg/CMGPiYcZi2KxmUK+/Io4R4aquWYGnzTQOHNmVvboMprnDHDoPV3mIJuo+M1gO/b+EAgA+o8hapGG9q/DkWjiJ5mB/3W0ZW/qUEhE+V0SB6Wl0huuWEUi5vylrTvw0ohgKoVaB3OUQjA+3Mzji+fhWqgErWJALwAIVCU2EA30T2qB6IrWKzLef9IEuZXW8/5jJ9cV5qIO3gUSKMz9gLZyfVfWQSEa1IcASEJ/KfnzCQDtTO1BMLpgXT0tQF6VQd4NvwbeQu9uuJ9rP5SdT99t3POPjUF1BhZfkjKlfAWXbD86q2w4gbPlpEQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=sony.com; dmarc=pass action=none header.from=sony.com;
 dkim=pass header.d=sony.com; arc=none
Received: from TY0PR04MB6191.apcprd04.prod.outlook.com (2603:1096:400:32c::12)
 by TYPPR04MB9013.apcprd04.prod.outlook.com (2603:1096:405:317::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.522.19; Wed, 21 Oct
 2026 08:43:03 +0000
Received: from TY0PR04MB6191.apcprd04.prod.outlook.com
 ([fe80::aa83:1e3d:19d1:736]) by TY0PR04MB6191.apcprd04.prod.outlook.com
 ([fe80::aa83:1e3d:19d1:736%6]) with mapi id 15.21.0546.012; Wed, 21 Oct 2026
 08:43:02 +0000
From: "Friendy.Su@sony.com" <Friendy.Su@sony.com>
To: Gao Xiang <xiang@kernel.org>
CC: "chao@kernel.org" <chao@kernel.org>,
        "linux-erofs@lists.ozlabs.org"
	<linux-erofs@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>,
        "Yuezhang.Mo@sony.com"
	<Yuezhang.Mo@sony.com>,
        "Daniel.Palmer@sony.com" <Daniel.Palmer@sony.com>,
        Amir Goldstein <amir73il@gmail.com>, Jan Kara <jack@suse.cz>
Subject: Re: [PATCH v1] erofs: enable SB_I_ALLOW_HSM to support fanotify pre
 access event
Thread-Topic: [PATCH v1] erofs: enable SB_I_ALLOW_HSM to support fanotify pre
 access event
Thread-Index: AQHdWJvRBJXrCptv4ESQoyx5nwPYULb3ST8AgAH8ibGADm7PgIAACnM1
Date: Wed, 21 Oct 2026 08:43:02 +0000
Message-ID:
 <TY0PR04MB619129E92AA946EDDB179AC1FD662@TY0PR04MB6191.apcprd04.prod.outlook.com>
References: <20261010094000.2036805-1-friendy.su@sony.com>
 <asqsNhtlXaEOrEky@XiangdeMacBook-Pro.local>
 <TY0PR04MB6191A63F6B79E4109D185F41FD9F2@TY0PR04MB6191.apcprd04.prod.outlook.com>
 <athyOw_WoXy9-NDR@MacBookPro>
In-Reply-To: <athyOw_WoXy9-NDR@MacBookPro>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
authentication-results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=sony.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: TY0PR04MB6191:EE_|TYPPR04MB9013:EE_
x-ms-office365-filtering-correlation-id: 08053103-46fb-4b8d-6692-08df2f4f517f
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|1800799024|376014|23010399003|10070799003|22082099003|18002099003|4133799003|38070700021|11063799006|261009223027099003|56012099006|10067099003|4143699003;
x-microsoft-antispam-message-info:
 EK6L7svWovHxNNQFgSkGKjXZ824/6Gom6Z2JJr/ArrpU6rj6vPm4KMyRulQ+nZu1tBuXyNZx97M+EOoAnoAJJOsAuAIoErdZ91t19c73sJamvhlWUiQ6xZ9DovTBFjNgpa5dmctgVJyDIL+Cee4LZ8vo873vdruJ9wbrgMrhtfnJMogb3Z6eSEl4mQYJFtSXj+JouDq40rb82oe/v6eA8S6SznEVFYTGWaJQ0UK1AJGUg4Uz6dAj0uwDq3DRkT6k7gBGh/5X7Uhu7TYg7OCcdx48N6s6CkVOz/qVSpaLLO+gzLzf++e5drVgRWXEqP/OevgmhWRhEWhXHnlPkBNgzT2yRh98v2JZcitcE7tAHAUD/hE2ouDzYzmr3Gls8AjKgPoJGhFSAQUkMp6qqlBx6fkSi+2vkvNRrHlQrVH0MJtxbyyNTvddpYi6kGad2BqhbAXutMdQ1tOg7ZX8CyQ2G7UvAW48BhP0KmgCKqrZ4WsnQCJ95Or3+qjYUqimBctZ9focMyxGyP2X7nNDVLnyrwSrjWRgIAU99YToo8zIw4+d+6A4ka131Cl/lIkOTXRO9Hk9e99LQlbVslRHO3+0mRXwb+G4B56YbKFy8P/wMBoMTInpZNKLan/kI9UmjlvcmuZZ/rI98reiKDynkOGdqfjl2wNPj1yior5+lhLYs1A=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TY0PR04MB6191.apcprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(23010399003)(10070799003)(22082099003)(18002099003)(4133799003)(38070700021)(11063799006)(261009223027099003)(56012099006)(10067099003)(4143699003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?clo5VWR5WlRBcjBqZUhZYlppUUh1aWhLZk1xRnRKSVgyNmJXVUovN0tmSUEy?=
 =?utf-8?B?NW9MSVdoeTU4K3RrQVZuNTBpRWtkcCt2QkNNSS9yM0xwTGFwMzNNT0hDMjNJ?=
 =?utf-8?B?SFM5WXNrMWFHQzlqbjVwNGtFOTIvTEhWSkozZzZOYnZWL2V5OE1vbjNuUXFR?=
 =?utf-8?B?WmZnOExKOVJsaUhPNmJ2aE9QTDhFYVk1dDJzcy9WVUU3RUtMNmRRbU54TFlL?=
 =?utf-8?B?a1dBUDZETjFnZUhqVFVtWWhpSFdNNEYrSEJVTHNCZnZraU9rcDdudHNaOFNK?=
 =?utf-8?B?MWtBVW4vd0tDbDFPVlRoSlkxZDRlT085cWJXWjlwY0ZCTmJhaVBJbHRsWDNl?=
 =?utf-8?B?c1R3VWplNkc4ZEFzcndBUkRKendiZU9BSW1YZjZKV05sNDlLODlmRTluRkhO?=
 =?utf-8?B?RlRPT0NUdVVKbHhud3FsTmJWaWdaK3VYbkk3NTJFUXJhS3BpcXFRdVFjdEsr?=
 =?utf-8?B?MFVmZTR2ZHBtRHNIdDJGUEhtdzBwQ3dGQVVEL1hzMUcxYUhjZ2pSaUFvYnhr?=
 =?utf-8?B?V2UvMHFscVJ3S09qOWJuYWpyVXEzQWJZQ3pzWVhkdzQvWXZrN3N2Z1JWNjcx?=
 =?utf-8?B?ekNSRGc5WDluenRYZVdRVnFaVzc1ZW1MaWhYd0IzbkdnUCtLcVBtM2N1SWtY?=
 =?utf-8?B?ODZHSWVsVGV2OVNFQ2FZcStoeWtGZVY2Q054WFFJTXlwTTZseFhUaWFtbXJF?=
 =?utf-8?B?WkVGbHdzb21PR3FpY2pmNnZTdUdMQm9VSVlQTllMOU9UYTJRenVVRUZuVXcz?=
 =?utf-8?B?TElvNXYwczVCbWNLb1VXV29EYlFZOWJndlppbUh3ZHFTbXlhMUUyZVpBRXdW?=
 =?utf-8?B?RnUvc0h5US9FSjVIT2s2c3h4czBudTd1RGR6MUpqL2I1Z25mcldNbS9ZZVFN?=
 =?utf-8?B?eEJkUi9zVERhcWl0NVlLcmlPQ2dZQXN1dlNYOUxzT1RFOXVrbXpqaDJmbmlH?=
 =?utf-8?B?SXcxOWlEOWVDRU5nUlQ5b3dXWEplQTlBMnBQWEp5Z1M4V1hMcG85SnlBVEFO?=
 =?utf-8?B?dFd2LzA4dFpIKzdnMTk5MzArOHA3OTlLZmJ2eUFxemFqbDNFU3pIZXZ5Mkw4?=
 =?utf-8?B?UjRXbFd6cm90TDNTeGFHYW9yNGt2cFB2dU9VNFA0VnVRQS8yejVsTkFnK0Fj?=
 =?utf-8?B?UG8rWnZBUjNlQWhtcXVwb05Jc0ZaRUQvNTc3UXo5Rm91ejlENmIzOVlzSnhD?=
 =?utf-8?B?Nk1wSmlGb3FmVDFiSlQyS1V3cmRDN1Nac2pOZmNubTRQYUYzN2RKWHVmRVlV?=
 =?utf-8?B?eG9peFdmZ1VDUm1wMDJDcVJRYzU5eGFFSlBvNEhpY3BTdGo5Rjl0Ky95aTIw?=
 =?utf-8?B?cEZkcDU3amJiS29ZNXpCMi9LdlpQazVHMU9hbHlGcnR5YWhkNkIrWlN0SlA1?=
 =?utf-8?B?SlNMeFh2QVY3eDNuYnFMNk5IZndrVWIzTU1Nak5FR1pTcEpwc2o1ZjNtR0VV?=
 =?utf-8?B?a2NmOWU2d2kxVkZsYnZLd3ltRS8wYWZ4eEZmSnlXWXBBeFpDd1BIekdxOUda?=
 =?utf-8?B?SnZDWDBXWEJvODkxdk8vcWhPYXlTQllPMUxBdk5GOVNsT2xUMWNZQW52bmM3?=
 =?utf-8?B?b1Z0M2pIbm5DNnlLT0xMRFlmZFJCdTNxeDdNQTVkNno4M1RaaXpKOWJVTVFN?=
 =?utf-8?B?QTBWZEVPdHVPV1Ntci8zajNtTURSeTF6cU14VzlCSU1SakYzTVlqNlVuMjln?=
 =?utf-8?B?UHZMdUxoVnJnWS9OcFVhR2laTFFzY0VyOU5wa1VTVjd5MkhtVHZteXJ1QXFw?=
 =?utf-8?B?Ny9GUG90dTc4RmtmVWxid3AxdE5Wci9oOUNETUFGMnVqaEU1NWp4VjRMVWt0?=
 =?utf-8?B?b0o2bmIwcnpxSG5CNzdESEpjb2c0Sng2MEpSaXdYeVMxUzltcXprUzR2SUlH?=
 =?utf-8?B?b0lscHQrbXo2T0RoVk9sc1NaMDZWMVUydy96SnNMVHJpRGNUckFnZWZ3b2pM?=
 =?utf-8?B?OE1UajVSUHRvZEcxRjhpdlFDbnYvMHlrRWpzYUZUNk44NE5Ba3JzMk1lT1JC?=
 =?utf-8?B?dFNHaElUQ2dETmdwdndZVSt3MnJuU0FXU29vSmVoK0Mvd0IzdHRUa0pGSENl?=
 =?utf-8?B?dCs1VUpaL083NTU4NkE0YU5qWDNoNHIwcU52ZGkwTm9mcG1Nd0ZIMmRrcTRo?=
 =?utf-8?B?R09penlmVzliMnB2MGlyUGZINGxnMlNISUIvenhrbU5GeVFUdkhCbjdYWFMy?=
 =?utf-8?B?KzdFN0F2L1dEYVJTY0pYZWREZzJzOUdBRzI0Z1JEQWJsUU5rL3NWVFlOK1Nq?=
 =?utf-8?B?QXlJK05hRTgyUEh6MWVvcGlPNVR6VkFWRmZkanhOV0VmSDI5dXhZaHd2aTNu?=
 =?utf-8?B?NDhaRk1mbUZWU2VwSi9zeFpva1NXNUQyU216ZTlWa2habGZxWm51bnc4R053?=
 =?utf-8?Q?tuh4ilHurnqEirG8=3D?=
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
	xQO2hGA6RCUVwM6e7Bl8vROYxs4sMarvkRGnzHptbPU3hEWGlBkWey+3+iZ34vwPe/8eh9/J7D79CfxW4ao6t9RejN60iTMIEWOtLFRD4KpghYpVX854Ln2TQ9/FitDNV0z93ZZtNzh+H5WfZbUVB6yWYm4cZhbCy+B4An0HfkqKj7TkJO0Cm51u1fQddvk0PuaVu/UgqJ2TlKtWfvRBRHvj8tF+8pAF2XprhVM1lSsmMOBcJxLrSZmoohwTNwJpz4uzTpk2ZZpdUnzXPz4DcDp133mdO8O8JWGKuGalqQJQze/m13X7l7vOuqYF7iXh4DwF0aNcIor1tWPEveClnA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	19wLv2BpGQ5xrjewppxsYU4dpgoci3d6CMIbh9QqZ2DrXT4mnWrvU77E7Ff3/lRk65enCbwKzLXODsVn9d7Cv792q0dSMTCX2oWLuYyaSjwJzwm52Wj90MBaz2tJ2QKMLT8TiM73NskNhiZqeqjvn6/aSVsJOXh5Ia4Wupg+9vIuBy5q5oiTYO9TSwkRzyYrn8rP71C7o1gNmBi4kon2c0wYEy5rmYUSXb2Qx34/pgFvFhFx+lqICziSm37zyfZbEnNSWfMDSr8QbXZP+QpFUItsRqT9WdmcTg+IFS3yiazZ2dPCtZBiFL30HXxHCz4RsEzJ0GkXKb8wev3XvkxNrYw6U5iCYTASaKuWRmoiPo58yTdSQCU2ikiENWCSDnZ05oQ86w4vbnJ434pXXujl1aiKuKvruZvIdN4b+/fgZ8TZLG4hFUbTNbfTAWBero0nCZt8LKGlViLZyT6WHYKlfnkQfZPshjAcFHmdqjKcL7B2D0Hfh3RNmk1aTUXBYioar8DSocAASrPPNXFUAxzZBH9Caw/pq234UCxzJ1bOCvJrTTwuMjSeltDwL8zhiCAsubIWOg70Mn4hL6KlQhv/lyT6Tbjja9SzbOn2TXtbt6pT+EIbOyW28td6/I0NirvJ
X-OriginatorOrg: sony.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TY0PR04MB6191.apcprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 08053103-46fb-4b8d-6692-08df2f4f517f
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Oct 2026 08:43:02.5767
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 66c65d8a-9158-4521-a2d8-664963db48e4
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Ucf6BNxfyn5we6m++UX8xWD4Rkd9TQjf5X5mNZeNo1x2+j9uJfR8o5ytGOK66DakvlFv0DLR41JLLKkiV2qVkQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYPPR04MB9013
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Authority-Analysis: v=2.4 cv=bqHZl0ai c=1 sm=1 tr=0 ts=6ad87b1c cx=c_pps
 a=WMo9HYg8Dr992rWvOlhhqA==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=660iZSQnnn4A:10 a=7j0FZ4iXMVMA:10 a=xR56lInIT_wA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=KAb5x4SsHD3PzxGk7EmX:22 a=jHItnBwsj8f3cr25iGAb:22
 a=NEAV23lmAAAA:8 a=VwQbUJbxAAAA:8 a=iOHNgrcOAAAA:20 a=voM4FWlXAAAA:8
 a=z6gsHLkEAAAA:8 a=57PknESPhfnYMIdZ0J8A:9 a=QEXdDO2ut3YA:10
 a=IC2XNlieTeVoXbcui8wp:22 a=bA3UWDv6hWIuX7UZL3qL:22
X-Proofpoint-ORIG-GUID: HK_7k1IdqPNgeEjgyDSRTIAgMuGhCVCO
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDIxMDAzNCBTYWx0ZWRfX9ItWnkQOFmbD
 PuXXC0cwO5oXIcTNE8psYBcYXFJ5hIvg8ci7fL5OdyoVutaeSVSHyT0QjaXWYzrt7ApgMZyhnzm
 4kzfakr+LWsWKrkMoqS8d0ij9Mfkwgs711tIrgM+63EoVkFKNY2Y
X-Proofpoint-GUID: HK_7k1IdqPNgeEjgyDSRTIAgMuGhCVCO
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDIxMDAzNCBTYWx0ZWRfX0BDZn3Ar4Km4
 6C5BFlruB2tuzfbygVfrPMhmBU9BDx8YsL2iHfqttSUyyoC77mbM1WDaPYDuX+fiXs4UoLrwGCS
 KcEbxAtI9Xs1W8QpDfcJIitwk+NamVhL9KctxF6GFO6DbyuHDiaXGwIBUatNrviX75LCIxwbo51
 zcwRhnqpOj+b/DoAx8b6EBmbY2JlNIIgy6O0Qnmh94EyPc18iimKM3Sj7dbhS+5KC53eWMv3T70
 gaOwNotUlc9RDQ3HHQSNTeNY8lK+QW2lyw546COhtMlFWIvajOmfAk7el1SZwVSGboESXQSiBKo
 cRA+dHMyUECCPufzGXIHg3o88I/2nxx3Xo4t0VbQkBy/6Zd1U7ASLs3CdAPtbAsmZ91QNzcfEmq
 bR0yuyeNZQScvqbJfkMq+mu7FXns1Nn0Jhte2HmdmW6ACyyzFpLE7obGIb+TXYkEXyEzdOkhQCU
 QMVtsQjSv2pLHK0I8ng==
X-Sony-Outbound-GUID: HK_7k1IdqPNgeEjgyDSRTIAgMuGhCVCO
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

Thanks for your comment.=20

I will send patch v2.

________________________________________
From: Gao Xiang <xiang@kernel.org>
Sent: Wednesday, October 21, 2026 16:05
To: Su, Friendy
Cc: Gao Xiang; chao@kernel.org; linux-erofs@lists.ozlabs.org; linux-kernel@=
vger.kernel.org; Mo, Yuezhang; Palmer, Daniel (SGC); Amir Goldstein; Jan Ka=
ra
Subject: Re: [PATCH v1] erofs: enable SB_I_ALLOW_HSM to support fanotify pr=
e access event

(+cc Amir, Jan) On Wed, Oct 21, 2026 at 07:=E2=80=8A18:=E2=80=8A06AM +0000,=
 Friendy.=E2=80=8ASu@=E2=80=8Asony.=E2=80=8Acom wrote: > Hi Gao, > > Sorry =
for late reply. > > We have considered fanotify in erofs-utils. I think it =
must be used with > file-backend mount. It


(+cc Amir, Jan)

On Wed, Oct 21, 2026 at 07:18:06AM +0000, Friendy.Su@sony.com wrote:
> Hi Gao,
>
> Sorry for late reply.
>
> We have considered fanotify in erofs-utils. I think it must be used with
> file-backend mount. It actually utilizes FAN_PRE_ACCESS on ext4 or xfs.
> Also file-backend mount can not support DAX mount.
>
> But for our case, file-backend mount can not be used. Firstly, there is no
> ext4 or xfs file system in actual environment to put a sparse erofs image
> file. We have to mount a normal block device. Secondly, mount must be DAX.
>
> The basic flow is file content is fetched from remote then filled into
> local erofs file on the DAX mounted block device in FAN_PRE_ACCESS handle=
r.
>
> "/dev/loop0" is just an example, not our actual use case. The actual block
> device is something like /dev/pmem0.
>
> In order to make SB_I_ALLOW_HSM only set under block device backend,
> we can do like this:
>
> if (!erofs_is_fileio_mode(sbi)) {
>         /*
>          * Allow HSM to support fanotify pre access event
>          */

nit: single line /* Allow HSM to support fanotify pre access event */
     according to EROFS code style.

>         sb->s_iflags |=3D SB_I_ALLOW_HSM;
> }

I am fine with that as long as you limits SB_I_ALLOW_HSM **only if**
s_bdev is valid (IOWs, I hope we don't need to bother it with EROFS
SB_I_ALLOW_HSM + file-backed mounts; it aligns with other filesystems).

Also I think it would be better to add a testcase to check the basic
EROFS SB_I_ALLOW_HSM functionality in erofs-utils (see
experimental-tests). You don't need to add support for EROFS
SB_I_ALLOW_HSM directly in erofs-utils; but a basic functionality
testcase for this is needed.


BTW, for your use cases:

> mount must be DAX.

As for virtio-pmem, why not just use userfaultfd on the host for
virtio-pmem lazy pulling? for example,
https://urldefense.com/v3/__https://github.com/firecracker-microvm/firecrac=
ker/issues/5740__;!!O7_YSHcmd9jp3hj_4dEAcyQ!1I4HPp-ti8SbtdVUzxl0B0QuNCpDMYy=
Uh1CGGxNZEvFSg_lZnXaDitDh6Clg2me7wzbPbUl2X5E_vw$

Personally I still don't think monitoring FAN_PRE_ACCESS of EROFS for
this kind of usage is a good idea.

But anyway, it doesn't matter to much if it applies only to bdev/pmem.

>
> How do you think?

Also please just adjust the patch subject to:

erofs: set SB_I_ALLOW_HSM for bdev-based mounts

Adjust the commit message accordingly to your use cases, and
explain file-backed mounts are not your cases in the commit message
as well.

And since it enables SB_I_ALLOW_HSM, it might be better to
Cc fsnotify maintainers in the following versions.

Thanks,
Gao Xiang

>
> Best Regards
> Friendy
>
> ________________________________________
> From: Gao Xiang <xiang@kernel.org>
> Sent: Sunday, October 11, 2026 5:20
> To: Su, Friendy
> Cc: xiang@kernel.org; chao@kernel.org; linux-erofs@lists.ozlabs.org; linu=
x-kernel@vger.kernel.org; Mo, Yuezhang; Palmer, Daniel (SGC)
> Subject: Re: [PATCH v1] erofs: enable SB_I_ALLOW_HSM to support fanotify =
pre access event
>
> Hi Friendy, On Sat, Oct 10, 2026 at 05:=E2=80=8A40:=E2=80=8A00PM +0800, F=
riendy Su wrote: > This patch makes erofs support a use case below: > > ero=
fs file data are not available at local, but need be > filled at fanotify p=
re access event handler.=E2=80=8A
>
>
> Hi Friendy,
>
> On Sat, Oct 10, 2026 at 05:40:00PM +0800, Friendy Su wrote:
> > This patch makes erofs support a use case below:
> >
> > erofs file data are not available at local, but need be
> > filled at fanotify pre access event handler.
> >
> > E.g. when format erofs to blob mode, meta data image
> > is store locally, blob image size is big so it is stored remotely.
> > At erofs mount, a loop device based on a sparse image file is
> > used as blob device. The sparse image file size is equal to blob
> > image size. Like:
> >
> > $ sudo mount -o device=3D/dev/loop1 /dev/sdb1 /mnt/erofs/
> >
> > Then at file access, need retrieve data from remote, then fill
> > into sparse image at FAN_PRE_ACCESS event handler.
> >
> > Signed-off-by: Friendy Su <friendy.su@sony.com>
> > Reviewed-by: Yuezhang Mo <Yuezhang.Mo@sony.com>
> > Reviewed-by: Daniel Palmer <daniel.palmer@sony.com>
> > ---
> >  fs/erofs/super.c | 4 ++++
> >  1 file changed, 4 insertions(+)
> >
> > diff --git a/fs/erofs/super.c b/fs/erofs/super.c
> > index 0967aace9f7f..b92d3353319d 100644
> > --- a/fs/erofs/super.c
> > +++ b/fs/erofs/super.c
> > @@ -659,6 +659,10 @@ static int erofs_fc_fill_super(struct super_block =
*sb, struct fs_context *fc)
> >       sb->s_maxbytes =3D MAX_LFS_FILESIZE;
> >       sb->s_op =3D &erofs_sops;
> >
> > +     /*
> > +      * Allow HSM to support fanotify pre access event
> > +      */
> > +     sb->s_iflags |=3D SB_I_ALLOW_HSM;
>
> Did you notice
> https://urldefense.com/v3/__https://git.kernel.org/pub/scm/linux/kernel/g=
it/xiang/erofs-utils.git/tree/lib/backends/fanotify.c__;!!O7_YSHcmd9jp3hj_4=
dEAcyQ!3EhQW78Lg9hjdjMscHBj-V19jmMX6nlYdkPVufSmwLJEM5yM0uTCOLuqwilIL3MGLDqM=
V8LkNo1Chg$%5Bgit%5B.%5Dkernel%5B.%5Dorg%5D
>?
>
> I am not sure why EROFS itself needs to set SB_I_ALLOW_HSM because EROFS
> is an immutable filesystem, its data should be considered as a golden
> one and it shouldn't be partially filled.
>
> Instead, SB_I_ALLOW_HSM should be set on the backing filesystems (ext4,
> xfs, ...), and if I understand correctly, combining EROFS file-backed
> mounts (pls don't use loop for this) already implements what you said
> above.
>
> And this functionality is already released in the latest erofs-utils
> and Nydus v3:
> https://urldefense.com/v3/__https://github.com/dragonflyoss/nydus/blob/v3=
/docs/fanotify.md__;!!O7_YSHcmd9jp3hj_4dEAcyQ!3EhQW78Lg9hjdjMscHBj-V19jmMX6=
nlYdkPVufSmwLJEM5yM0uTCOLuqwilIL3MGLDqMV8IXHHnVqQ$%5Bgithub%5B.%5Dcom%5D
>
> Thanks,
> Gao Xiang
>
>


