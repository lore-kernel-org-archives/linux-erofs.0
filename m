Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C007F606A320
	for <linux-erofs@archiver.kernel.org>; Thu, 19 Nov 2026 01:59:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=sony.com header.i=@sony.com header.a=rsa-sha256 header.s=p1 header.b=Usm1oLMD
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4jVM8Y6J88z2xkr;
	Thu, 19 Nov 2026 12:59:09 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=fail smtp.remote-ip=185.132.183.11
ARC-Seal: i=2; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1795053549;
	cv=fail; b=QKZrSbbsR0eBm8igjUSBrhUz9NjA00RrXF2N4nrnJfBihH46GHfl0cMQ8gSY4QTZtwJKnvQ6aguM9WsRRm0nELOfNm8QXfhSyaVWvsNGDdvEdFSu3rgumQsBTJvGbTsC0lR8FyiIRwQu8AuynImllsaomSXlnpKpOz+n7fALrrtjrnLervbZikDOJKnQoUHn8kfGU/0sllXijCejsoa79bhHxdpJYusBA5NsdrQC53j5FfOt2o6aZziNIxjMJMg0rsNYcYh9YtN3B38pAbycmCcOf5puF1ufFfJi0xLP5VpA4r7TbHM6flZfwdXXh4XpbOhbJhP1OKJS4gRa6hX2xw==
ARC-Message-Signature: i=2; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1795053549; c=relaxed/relaxed;
	bh=X+RkMqpwMb6IsFw/yohiEI0vH+3yfG3/dLccQdCfXWg=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 MIME-Version:Content-Type; b=KI+LZKbMZ1+PImH3AwfVMPHCcXD/l9sNRs10gBYyk7kYm6F0GG2vzFTT5oMbSaiPsy62BHLhsFnVQYhgWi46yKbLIjpfN84+KfPwiU47rMU3xHpMsDYZm6GMMNoD3Wg3ruyNIEhiGJxv1M6YCOnHhvWYZBzbLOAiqROymw55tDH6YL3jrDfxzh+P5odNF6SsoW3M72x+caWDJBAbn0TDa24UbkKslTCDQ1FIEuEqem0gaweJaEfKNa/0UPHhlgsqLwbbjkatGrgF/hmyW7690CWGMaYGnFOq6uMzOYR3e9dbE/f+cffWi3Df+j3yY9Qma9mqwrbNN8ZZtxATa908Pg==
ARC-Authentication-Results: i=2; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=sony.com; dkim=pass (2048-bit key; unprotected) header.d=sony.com header.i=@sony.com header.a=rsa-sha256 header.s=p1 header.b=Usm1oLMD; dkim-atps=neutral; spf=pass (client-ip=185.132.183.11; helo=mx07-001d1705.pphosted.com; envelope-from=friendy.su@sony.com; receiver=lists.ozlabs.org) smtp.mailfrom=sony.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=sony.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=sony.com header.i=@sony.com header.a=rsa-sha256 header.s=p1 header.b=Usm1oLMD;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=sony.com (client-ip=185.132.183.11; helo=mx07-001d1705.pphosted.com; envelope-from=friendy.su@sony.com; receiver=lists.ozlabs.org)
Received: from mx07-001d1705.pphosted.com (mx07-001d1705.pphosted.com [185.132.183.11])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4jVM8X4grqz2xN4
	for <linux-erofs@lists.ozlabs.org>; Thu, 19 Nov 2026 12:59:06 +1100 (AEDT)
Received: from pps.filterd (m0209325.ppops.net [127.0.0.1])
	by mx08-001d1705.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6AJ19bi91854315;
	Thu, 19 Nov 2026 01:58:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sony.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=p1; bh=X+RkMqp
	wMb6IsFw/yohiEI0vH+3yfG3/dLccQdCfXWg=; b=Usm1oLMDQiLQq7DuF45PSBN
	sO5p1+GZzysNsVuCwyebC+ndH4H6vnyh7yR+XEA4P/CWjsIBldj4EvBSLE68KgOt
	UdPOMYsnzOsvwaMCZH+Tr8WwkNwJgjOg9tpzE04TdPhoMZczf1Xgwe0l+8oHxgta
	K6AF6V2noOdkc9dxuY7YHMKTnpXRKgPvLDuQCjOucYCVc15S0MoYC4d/+2o2r9WX
	AV+gkhBvjutUvG5gILj5BZlPIgkRPn3eb4EUNfT9Jjs2sAthFX1onJQQ2YOapcA8
	tJ8YRIKp7WMBh6AutAODBc0Mt2TBl8I27+wtU7sL++8u4Pz/1dglQE6zICW2pWw=
	=
Received: from seypr02cu001.outbound.protection.outlook.com (mail-koreacentralazon11013047.outbound.protection.outlook.com [40.107.44.47])
	by mx08-001d1705.pphosted.com (PPS) with ESMTPS id 4j0yua1m9g-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=OK);
	Thu, 19 Nov 2026 01:58:34 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qK7CatRAyrBeDjoEvMu+W2FJKCy1K94c/hJdGx855AE3CryAjwphB7GzTiGYoLy9UXUMcRtDO+2ks01OCVw4t98U/T2zMQ1S6FfsEG49aJ877ls6UhxKrl+1ZQXwo8WA26Nt1x3bt3KB+rs8xVQuu8XvslwJMObZwD2eG0c5VgpB1HeKPJvM1w4tY3EJEWS+9jKxCbfV64adCNwt2f14XsxshMHaWOUT1wT/wKd/2fKvVVrkaObqbtONlkyTCJIUqw2a/E13Skw0MWeY77ScD3rw6lY9OM7e0IWEfSB1n3B+9xKg5o4xRgRihAUQwC+wwMzzxnMULW2YUtciNcmySA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cbKEU3W7q6a6iolBOeYU6J0KeO8teIL0P82DIzhpczQ=;
 b=vb27G8Dfe+BBN1Ju4Vqb9m6ai2oSSrJXJ5lNGzB0Hti+1DN0PO0b7G82g3cnoJ0cZZ8+jT49mICp+caeyxl+vxQBafLgk1vtdQvCyxFfmffqhOpl3p/oI4iUz0LN//d9lBihGx25BitYmZHqxNpM7qFBtHuLVYTyzN6LLQ3TwE2S3U0nh4dmo17L6N9EXrQQw8mL/gZy47z7oG1W0RE1NvtLbcuIcwlWWPjvAwefZ5MEf1oZG6A7eqHuTEbM31i1eWgGLn+jTgVVuNg9Ad2jWIxs+kj8/Cipy3HUITra68QpK987Zu4ODNSvan++TkejWbYhlOaAizXmOVgSeRlovA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=sony.com; dmarc=pass action=none header.from=sony.com;
 dkim=pass header.d=sony.com; arc=none
Received: from TYZPR04MB4128.apcprd04.prod.outlook.com (2603:1096:400:27::5)
 by SEYPR04MB8973.apcprd04.prod.outlook.com (2603:1096:101:2d9::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.639.10; Thu, 19 Nov
 2026 01:58:14 +0000
Received: from TYZPR04MB4128.apcprd04.prod.outlook.com
 ([fe80::20b9:f878:c46b:6553]) by TYZPR04MB4128.apcprd04.prod.outlook.com
 ([fe80::20b9:f878:c46b:6553%4]) with mapi id 15.21.0639.010; Thu, 19 Nov 2026
 01:58:13 +0000
From: "Friendy.Su@sony.com" <Friendy.Su@sony.com>
To: Gao Xiang <xiang@kernel.org>
CC: "bluce.lee@aliyun.com" <bluce.lee@aliyun.com>,
        "jnhuang95@gmail.com"
	<jnhuang95@gmail.com>,
        "hudsonzhu@tencent.com" <hudsonzhu@tencent.com>,
        "zhaoyifan28@huawei.com" <zhaoyifan28@huawei.com>,
        "linux-erofs@lists.ozlabs.org" <linux-erofs@lists.ozlabs.org>,
        "Daniel.Palmer@sony.com" <Daniel.Palmer@sony.com>,
        "Yuezhang.Mo@sony.com"
	<Yuezhang.Mo@sony.com>
Subject: Re: [PATCH v1] erofs-utils: tests: add test for fanotify
 FAN_PRE_ACCESS event
Thread-Topic: [PATCH v1] erofs-utils: tests: add test for fanotify
 FAN_PRE_ACCESS event
Thread-Index: AQHdaE/aHyA2Rzhm3kKZPXP4YBkgWrcVz4IXgB4BcBmAAJjwAIAAWDa1
Date: Thu, 19 Nov 2026 01:58:13 +0000
Message-ID:
 <TYZPR04MB4128147306CBDF3282E2BF07FD792@TYZPR04MB4128.apcprd04.prod.outlook.com>
References: <20261030091713.101900-1-friendy.su@sony.com>
 <TY0PR04MB61915C09A76E5B2F432EE7A5FD6D2@TY0PR04MB6191.apcprd04.prod.outlook.com>
 <TYZPR04MB412848968AB5079D30B4D979FD7A2@TYZPR04MB4128.apcprd04.prod.outlook.com>
 <av4Nllpo8_mERWXp@MacBookPro.fritz.box>
In-Reply-To: <av4Nllpo8_mERWXp@MacBookPro.fritz.box>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
authentication-results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=sony.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: TYZPR04MB4128:EE_|SEYPR04MB8973:EE_
x-ms-office365-filtering-correlation-id: 22f14a00-e31e-47c1-df45-08df45e0920f
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|376014|10070799003|366016|1800799024|23010399003|38070700021|10067099003|11063799006|4143699003|56012099006|261022105027099003|261022075727099003|261009223027099003|261026121527099003|261026140227099003|261028144727099003|22082099003|18002099003;
x-microsoft-antispam-message-info:
 srMT0Gq3SBQJz/L61MR1195DpMETCifdgEW6Li5GTNmubBcoPlCf4T8jDqLcJF70B7Mw9BT5GpeviSfOiaSYsHgwtDEbw89mZchelt4lbGYq8bTkOzgYZKmg/pjAZgPcN00EdF5jIQQoYkknXP0pLi535RcOODjp5oBxbitDPeYS412r+MYhEA+5WK1kezu8GKC6DQoQahPSG6YPIiveplkFIVwwwgXqKLnl+ePAtl8DBBjjkjTbXLqflVI0OVTKzu97nr9mTYIMBjqWOSnBbcLcIEyyw153J3735rETeq4hAEoc+4bXFPwrGE5XkibPD7xtpXMJO32WPCkHuCbU4Cow6ceNJb18Q7NVcyEN5iKrvdRXOweDNCjuMchhiEBcH6voiNjn7TOS4HvIbF9CXlD2MlBJ6t9zvWBIRm6sEez3w1Otg6NdaQM129LrC/4Bqlg8YeJE2/SxR6sRmOSjh64pVY60ekF5CZpgNicFleSZI+hs45TBwDV+ljzu08uo7R5p2UIM+R8m9MpuXzlzJQRAoplS1ZeIzPhM6v1f8IjbGnunOBubjaSqRwsfi1dXKj7SfRKmwyEki5G25hZOsbepFQ60IcS/XuMJDso1hzxgj/nPQyRED0+sx4ekc8A/sqOQB2TG42Woz5Rd/2un17mzNHwewxsXJXshfgT0GhtlU9MLQqIvQZw6y/2SMIE+qJdnnRXrG70wbeanM++xm2/g2y0My0C1oczeia4sJlc=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TYZPR04MB4128.apcprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(10070799003)(366016)(1800799024)(23010399003)(38070700021)(10067099003)(11063799006)(4143699003)(56012099006)(261022105027099003)(261022075727099003)(261009223027099003)(261026121527099003)(261026140227099003)(261028144727099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?cm1pbkRIb3V0aGhKWVliWGdBNlJRR3dqMmREbGh3SXFzckVQRnU3NTlnWGV6?=
 =?utf-8?B?R1dNa0ZXZU9XeG5xYmlNZEhaN2JQQVdYb1BYbDB4dkxZSlk3U281WWs0bW1h?=
 =?utf-8?B?eVpkVVFhTkFIbE9rUVdaWDQ3N21FZk1ReEtPdDdWc1dFZWIrTXZHOWV6MEpQ?=
 =?utf-8?B?Z0kyU1dyR2plSFlNME53SXh0K09IUUM3akdWSUErMDB2SkFLL25kc1ovM1Aw?=
 =?utf-8?B?cjQwZ3J5V2JKMlU5ZHFKaHkzWVRhbWdKZEYvMU5Bb2QrS0p2djJ2TmJ5d0xU?=
 =?utf-8?B?YWlHSUdxODkxR1pIT0FUNEc1U1haWmwvOCtSS2dFN2JCcWRNOTJjTm5jMFVw?=
 =?utf-8?B?TGIrVFYxT1ZCTlRvbFlNSG5tMnp0OHZxYXdmNWo5dURHUXJFMGlqbHBjdVdQ?=
 =?utf-8?B?NnV2VUlVeVRpOFNxVG5lSnBwS01PUE1nelY3dldGU0IyVXlOaWhxUVhQSTh5?=
 =?utf-8?B?cksvT0N2RnVpR21yK2ZRREZBakN5bDNTVmtHcnBQeTAwVVc4NUNGVWpyU3JP?=
 =?utf-8?B?RWc2V3F0NXRsbjZpTlhPdEVUZFMrb2JOUTY4UTlqN2pzT3NleE9RUHFsVjIy?=
 =?utf-8?B?a25aZ2k5Tm91TmVrZXgwbm5oQnpaWVFYcjBOeUt4ejZnOVQ3QkVLdHI3YWNh?=
 =?utf-8?B?Njh1OW1RNSs4M2ZIc2dPak4xQXIzYnQrMC9Ud3p6T3ZWTkV5L1FpVzZaVWQ1?=
 =?utf-8?B?MUl6N09iVzU2aXVNNWJWU3ZNUTBlUWorTCtVdXpqdWp5aHhhY2VMS1NqVmVL?=
 =?utf-8?B?SDFBak5mY056WmlRRDhDd2N2M1BtUFViTklxSFJtSHR4WDFTeXJaeUx6TE1C?=
 =?utf-8?B?WGR6UmcyaHJiK2tIaVZpMktxbERjK09BTU9zOURobnI3akVnMGFGako2aGpu?=
 =?utf-8?B?ZUVaRTFTMWNyYzIzL2FPM25WSDRKOUUzT0V3cHVXQkVRY0p0ZUtJcnpqRi95?=
 =?utf-8?B?RjViR1hLWmorK2J0MzcrQU5JT2VSRWNCQ2F0dXYzeHUwL2diNDJKMFBuMnRi?=
 =?utf-8?B?Qk1aakN1b2RQaHEyWld0NGFRM2dXWEFqVmExRGc4WGtCWTUrc295UHBIU0Vi?=
 =?utf-8?B?Q2VwNWtOTERGdzAyUVoxZG51UUxUcXhwRUxUQ3RQU1REcUlWbStmY0E1UWpO?=
 =?utf-8?B?eFYxUG5hQ0lrZzZKMkNLdHdaWnhYUjRYYjRySlE0Y3RJTURtRThpa1NsV1dC?=
 =?utf-8?B?Q01FTVM0bmhjcGdtUzFTVEFJanczbjFRV0EybGswQWkyQXpOT2dQVi9qZWpl?=
 =?utf-8?B?dFlkZHFKWUVwMlA5NERsR05jY204ZjNiRFdobTI5TUNhUGZhbEdFYkxuQXo1?=
 =?utf-8?B?RS9TQ2cySzFqcnV4QzZ1V21ldnFLWEx1UHg0bDFZMjRDbGZtTmJsbzhXWVd6?=
 =?utf-8?B?dk8xRFh6Z2xrSnFZUmFrRHpydlo3cTYramNuM0FPWnJzTWVTWFNFY0gyMXNQ?=
 =?utf-8?B?UFhHWnNRcTNFbTc0b0k4QUlRSnVTK3FxY2lpZVl1TkJXTnhMQzhDTlZPVVhZ?=
 =?utf-8?B?UzJ3UUN4Nnp3ajhJK1FrQ3ZpRWtQU2dlb3AzOE5mSFlWNkNVYkV3UXRjUU8x?=
 =?utf-8?B?NitJZ25xWjl2bkEwZDZCNGhyWmVNTDBFUHFrWFVVWDZlZFE3YVFyakVpQ0p0?=
 =?utf-8?B?d0daU0VvTkw4cmx3NkVmeGlMSU4xMjFDbHZXWkM1cnRkOXJ5dzEraFREdU9x?=
 =?utf-8?B?M01UUVBoUk84QXByUW1WbXk2azExSHJLcW9qNTAwMVBuUnhUbUUzL0ljU1ZQ?=
 =?utf-8?B?Y0haZ3YyMGs5WldkMEZvT2RXY1pmTVZKMTZ4K0plei95YUJGa21kQTMzSkUz?=
 =?utf-8?B?TTE4N0xVS1VpQjg0UDNqaTJmUi9QYVUwa1g3Ynd0SlpZTU8yQzNCRG9yVXNj?=
 =?utf-8?B?aHkrYlBhV2pRQmdna0xtV3N4R3JCMVdJdE5sOTUvdFRQYU1xcVJobHZqN3FF?=
 =?utf-8?B?akhHWUpISG9la29tL0FFVENieHBybzJJYndJWjlHdVFYWjQ5V1ZOK1JHSUU2?=
 =?utf-8?B?VUNwTHF4U0NsS05Ma3p4aklwODVxeld0VlBPL3hrSGh3bC9XWVhjNVRLRFlC?=
 =?utf-8?B?OU1aMTBOZ2VIRHlXcFE2c3pJak45NnFVcXk2Zk1Cb3lKdWVkV3JhMkR3MGhv?=
 =?utf-8?B?NjNHVHgxM1I1cDYvanFVU0JEK2ZhczhZKzZiNmhoQjk4WER4Qk5vS09MeDBQ?=
 =?utf-8?B?MW1wZko2NTJiNWxiaWpFcFQ3SWZjWk0vNk05RVZVZXc4OE5NTDlXbzU0NkpO?=
 =?utf-8?B?YW0yNEtaL2Y0ZWprUzNCYXdpSlA5ZTFSNklvNUlYYnUrdWY1UTlSZkVmMTdO?=
 =?utf-8?B?djRxWERJU1hMa0ErdzBhN25FSXI5dUgwdUI2cGNCZTdPK0dobzNNRlJURUtE?=
 =?utf-8?Q?qYzpKvmZaReuA6KI=3D?=
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
	jtBJ2UbEFSo371vP35FJrhp9zgkwOCrV4TyMJic6RLAW+042uQwWdlXA7IbzBSYyiT0l6AY46p7/s1MYGLwlrXqVdFVock7ZVJicWpcYS7W3fCc672/TBiQU1L9V/bUnIboLZqVykUXGmLLhoxn4O0CgjYxWPK+oRTbcPXyiE/bTqhV2OS2shQuNWlEM9ciQ4JAdKdcgu2SXRaUG19S5m46XMrl+MggnaMAJRbwqDFfm2tWNraEEgqnZYQeuqqbqE5l4hafIOjAbrSKINPOlvHbfHiMalcs2d+7S8G7sqwr4mjAT/Kd76bN9EjkWDwp9Uc/gWIgMhAif/QaSq7pmTw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	jB2Y0S0E6EF5c+m0cCvgZEjAnrk6G8DdOFynE3EIXw1ouDQSQOAuad39TpeE7KTxXWPmozKKwiW4Ri51kAgVO6WH/aOmYLpitrFLIivp2uWZ+ssBmwddKuERO8afhFl9gkuKvbFNgMghY7sO18l3ulk7Ry5QKB6i7+SKGQLDRh+7+KDwVwL4in4a/Ou9IyI7XBNtb+CiGPnG34Tcd2mdJ5BJuSNFVo8MLbmZl+zJlmVr63tKBgLjjaP+7BRqLhuRSJKe7U7uYvQqA+B6iP3D5nn7IynhW8eL9mWzLnikEPLy29pS86Nyp4JpE0V0nAs8698Kbbifw7+QK6bDG89Pf+RvBCOdtsB2ODE+NS1qy/EAmcapp4wTcgp0RVQvNl+jSsA7LgJVOU8h76CGrYO4hyX9QiG0iIDSsNs0EUhUWQ6DTEt/KN0KpMZmN+wGgc0nFuNYSte8Ehhv1hBRjzwAATdY+ScQEHTCWT2OWsukuPr8l20jX5IqQ4OpYrMCuoLXCkddpDLGRZxqDS75KNwd7eCSiMKHB1pNCTcojZxEAPoL9WynuwuKgilYPEEvb4qZrd9AsYnAc4UB/iekzx8j9K5cAwvCzINxW0y0KbIpM+PsPEs0tr00F7oWhaRG3/tD
X-OriginatorOrg: sony.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TYZPR04MB4128.apcprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 22f14a00-e31e-47c1-df45-08df45e0920f
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Nov 2026 01:58:13.5078
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 66c65d8a-9158-4521-a2d8-664963db48e4
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: povfoq9ERMlFTd3xprD/SO5rMu3XvacZkmNk5b3GBfxJ4H40qTp6w9KMsUt4gBz4FvLGvFjSzRgQBd6aEOk/gw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SEYPR04MB8973
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTE5MDAwNyBTYWx0ZWRfX2S1Ci7q8sc9h
 eY/4KyKuAy3kPGeUERBVezi6zVTXlSkrhwUE5v/+ed6YNtgeV7sd92K8K0Wqwx2z9Xd5UwaKOHp
 c8Y25TttqbwrGDAVn11RfW8BVHwa9dmaPYt54aAzZ5rjECxRNcdxNQGrIVkqPliKooJOS/8x+GN
 a2+i8WVEEvPCvjdKtXbFKjZisMjVm6Jki0GSVswHnlk03imHnQLnYs5FNPnT7a83AaT8kMwFUqz
 LBBaQjz679iRAxSf+RwN3iXX0r/tEeDU/uoGKb1A11yH2nXGxpZkPnT3XUzJQwyQUN8a0ZXrIg6
 u3/tJM5yT1E4d8jnmtphXpZuo2zV5oGY2qnVt3bk3vXOXwD0JC4dyi/NwR91IMD1b2eUPTjiVdb
 Pl0k5tsOAaxr19mVgVvOPwDC3ov2vmiam4ix8x3cDC3XIXEEgcj9KX206kpy+QTuDwHhb+0RuMU
 bWc3pIXIX1iqUgD9wZg==
X-Proofpoint-GUID: WKqVTlAilTA_aX8WuRhRSZeDHBN_hPXw
X-Proofpoint-ORIG-GUID: WKqVTlAilTA_aX8WuRhRSZeDHBN_hPXw
X-Authority-Analysis: v=2.4 cv=VfBir1p9 c=1 sm=1 tr=0 ts=6afe57ca cx=c_pps
 a=gryDuBz/WEQtBOO2OGARxA==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=zJRp6_cAMcgA:10 a=7j0FZ4iXMVMA:10 a=xR56lInIT_wA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=KAb5x4SsHD3PzxGk7EmX:22 a=FGjXJT7Bex8XaPnzAX5M:22
 a=VwQbUJbxAAAA:8 a=nTg3QbKWAAAA:8 a=pGLkceISAAAA:8 a=GvQkQWPkAAAA:8
 a=i0EeH86SAAAA:8 a=voM4FWlXAAAA:8 a=z6gsHLkEAAAA:8 a=Bj90jaK72LekJOHGxAoA:9
 a=QEXdDO2ut3YA:10 a=IC2XNlieTeVoXbcui8wp:22
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTE5MDAwNyBTYWx0ZWRfX2Z1k0uMr/cTd
 Xd9rJ3N6Szq8HxLLCn1WMcSieIKd+3WTH7vmLsHop+dmJ+gx3P4btDW2lIqA2Ayxa0o8xTn4YFT
 h5pskEMVIqviYG8CGu1xG42JmzyupiSlfn1KBL14AIZYg+XCZ6Xj
X-Sony-Outbound-GUID: WKqVTlAilTA_aX8WuRhRSZeDHBN_hPXw
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-19_01,2026-11-16_01,2025-10-01_01
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Oh, Thanks. :)


________________________________________
From: Gao Xiang <xiang@kernel.org>
Sent: Thursday, November 19, 2026 4:41
To: Su, Friendy
Cc: xiang@kernel.org; bluce.lee@aliyun.com; jnhuang95@gmail.com; hudsonzhu@=
tencent.com; zhaoyifan28@huawei.com; linux-erofs@lists.ozlabs.org; Palmer, =
Daniel (SGC); Mo, Yuezhang
Subject: Re: [PATCH v1] erofs-utils: tests: add test for fanotify FAN_PRE_A=
CCESS event

Hi Friendy, On Wed, Nov 18, 2026 at 11:=E2=80=8A35:=E2=80=8A39AM +0000, Fri=
endy.=E2=80=8ASu@=E2=80=8Asony.=E2=80=8Acom wrote: > Hi, > > How about this=
 patch ? Thanks for the ping. I don't forget this one, but let's wait until=
 there is no more urgent fixes for this cycle, so I


Hi Friendy,

On Wed, Nov 18, 2026 at 11:35:39AM +0000, Friendy.Su@sony.com wrote:
> Hi,
>
> How about this patch ?

Thanks for the ping.

I don't forget this one, but let's wait until there is no more
urgent fixes for this cycle, so I can merge this feature then
for the next cycle.

Thanks,
Gao Xiang



