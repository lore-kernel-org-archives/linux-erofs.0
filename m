Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EFE660A2603
	for <linux-erofs@archiver.kernel.org>; Wed, 18 Nov 2026 11:36:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=sony.com header.i=@sony.com header.a=rsa-sha256 header.s=p1 header.b=rnoTILM5
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4jV01J4TCXz2xlY;
	Wed, 18 Nov 2026 22:36:36 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=pass smtp.remote-ip=185.132.183.11 arc.chain=microsoft.com
ARC-Seal: i=2; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1795001796;
	cv=pass; b=UUkrtIdW0ILcvULEyGBo4GGf3+sAVsS+y/kAOr6jyJ9Ye14id/5ga0JVuQHQcSGAh1ep4KmZ+QQ6vz85CxHT7xuCYstZXYmQ8l/QT6/wjMzGQxiMcrOR1T9TzESDQ7XmoG1uNt3U6ngdIE8A2MbcfV/JVnnpNKTtwbYFvn8fot4RY1eE3nc8NcQa59tD6cCq92cyqYyJj7Kj47Cfov3EfeNWFCOvGVt+vA8oJ90BlAuF+c8l1lZcD0hTvBi0WJk74MS4+RYL4hZUCGr+KNoOu8Irgd8/BiLSwiVMwSVHCgqH2CzlXCs7/CDJWCKEojnrVMutYet/4aUTPkEt0YCjtw==
ARC-Message-Signature: i=2; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1795001796; c=relaxed/relaxed;
	bh=FtlE8zmd9yp5H1PBiBTploh6yzs2+uhWLSuHJWn5nTo=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=j6miPLE8iJ6nOUUFJXx1GJdag5amc18A/R1mjsTV6DeDNj1asjYJ/912zZo14TlUtFcQqQ0wvZTQR7r7o6fmy0WzY7lwSjjn2afKIQ9ohs86M+M3okqRzo8IE2lGR9odn5ZQ2KnwdzB7/Rvinb77OPtR/+ZOXcH87l4bQ6Gnnkx3rZUK9g1tibkz+FhKQuX0omaifdh8a+sVe9uzWXr2T4toW7cuvzdFmPWugWui+KM9q5TxdxPTh4sqUvaAnKBBMMuCymhIZTGLslZi5tvRvObDzy5QamHlJ2no3F8JkeUOVWYfIu4cWfAY3VjmxDkDzvc1OoWyH37b0HktTjcfKg==
ARC-Authentication-Results: i=2; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=sony.com; dkim=pass (2048-bit key; unprotected) header.d=sony.com header.i=@sony.com header.a=rsa-sha256 header.s=p1 header.b=rnoTILM5; dkim-atps=neutral; spf=pass (client-ip=185.132.183.11; helo=mx07-001d1705.pphosted.com; envelope-from=friendy.su@sony.com; receiver=lists.ozlabs.org) smtp.mailfrom=sony.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=sony.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=sony.com header.i=@sony.com header.a=rsa-sha256 header.s=p1 header.b=rnoTILM5;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=sony.com (client-ip=185.132.183.11; helo=mx07-001d1705.pphosted.com; envelope-from=friendy.su@sony.com; receiver=lists.ozlabs.org)
Received: from mx07-001d1705.pphosted.com (mx07-001d1705.pphosted.com [185.132.183.11])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4jV01G5tF7z2xSl
	for <linux-erofs@lists.ozlabs.org>; Wed, 18 Nov 2026 22:36:33 +1100 (AEDT)
Received: from pps.filterd (m0209326.ppops.net [127.0.0.1])
	by mx08-001d1705.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6AIBKq8O342223;
	Wed, 18 Nov 2026 11:35:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sony.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=p1; bh=FtlE8zm
	d9yp5H1PBiBTploh6yzs2+uhWLSuHJWn5nTo=; b=rnoTILM56YWOQujtnN4Ycb9
	Ju2/jSI5fc/DWV0hXy8s5b7DBa0Kucgwgu7tuWHn5Op5bLAITCezeSdiM2ZUzl/f
	Ze/U6NtFiVnXg2u9COtkaCOIso53Sq+uMJx01idFlMsB6lRfLiZnQwnDiH6ySeeH
	jiC9KZF0a/Uu2qX6tbVUT+FtRea+FoyUEuC426KcWdQXz/k7Nt1LHKC5pM1kOATK
	mxLY9zVLvd2IigbUnrtw8CLVW7YtHNA3mW9J/jM7O3jQaiHPWvMGsbxB8uMZoZWQ
	nE8NzVjwSsI1NB2mn8irNddMQzDFY4evw9ybwi0/fkzovZkv62hN/HxP6/Gp8wQ=
	=
Received: from typpr03cu001.outbound.protection.outlook.com (mail-japaneastazon11012071.outbound.protection.outlook.com [52.101.126.71])
	by mx08-001d1705.pphosted.com (PPS) with ESMTPS id 4j0yu80w5u-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=OK);
	Wed, 18 Nov 2026 11:35:50 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jRD8jJ21iMM8o2acSJ8ANhPX/He9qYog0SPDWqFtiUlMJn9yS3JFoi52jl/E5yKe2rUMZ4wAPTcNz8SHIZ3aO6rA9q2mIyIyw4AVBG/IlhTivLBPLGDuBZsDNJee8mAvAKlNdqwyYNcLNv3+AoTcG2FpS83RzssncpgvJn+afWoqSs1FV5KbG0+Ox7vDqMQkntTQdMQDFkIrjU281NyWYtWmsMNS/hvOVP7U/B2C3v/oTmckxbM497whpNMgN0D9HiXHinD8kS/AEN9C5exDUJmjwcrbEeVHE4KjIy5d6YiGzcmIq0OuB7TCZAPF8Ei1pe6ofqVH2vrdJ2KsE3vATg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FtlE8zmd9yp5H1PBiBTploh6yzs2+uhWLSuHJWn5nTo=;
 b=Ez4iprFX4ftqs9HmkD9tWbncDSCeEdkY+vx4GM4LRBYitc4UsNAJXxFCE0o1dQQdyFxg1GAjfnfbIVwUf21hMlMJ7CPslo2nIKceCCR3qi0v0bqBF3rv/TtTgBwn+bWQP9ZQB8sEj31Kl2vLmBIerpLlFLGiRFrBe9mrgjJzI6dI3OH1xeDGtSss/0E4qvZT+deutTjwCxwXkc3uy21a5ZJhzavgksqw/onFsM5pbLbD7e0l+xC/sw3tylciSWO4piXx/+e5C7KV981Chl49N6NNhrruonTvIX4m0W1vtmfyCMEM4u7MJFsSK4adaagXBvF03ye38Mc7FiRKqiZLPA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=sony.com; dmarc=pass action=none header.from=sony.com;
 dkim=pass header.d=sony.com; arc=none
Received: from TYZPR04MB4128.apcprd04.prod.outlook.com (2603:1096:400:27::5)
 by KL1PR04MB7772.apcprd04.prod.outlook.com (2603:1096:820:137::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.13; Wed, 18 Nov
 2026 11:35:40 +0000
Received: from TYZPR04MB4128.apcprd04.prod.outlook.com
 ([fe80::20b9:f878:c46b:6553]) by TYZPR04MB4128.apcprd04.prod.outlook.com
 ([fe80::20b9:f878:c46b:6553%4]) with mapi id 15.21.0615.013; Wed, 18 Nov 2026
 11:35:39 +0000
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
Thread-Index: AQHdaE/aHyA2Rzhm3kKZPXP4YBkgWrcVz4IXgB4BcBk=
Date: Wed, 18 Nov 2026 11:35:39 +0000
Message-ID:
 <TYZPR04MB412848968AB5079D30B4D979FD7A2@TYZPR04MB4128.apcprd04.prod.outlook.com>
References: <20261030091713.101900-1-friendy.su@sony.com>
 <TY0PR04MB61915C09A76E5B2F432EE7A5FD6D2@TY0PR04MB6191.apcprd04.prod.outlook.com>
In-Reply-To:
 <TY0PR04MB61915C09A76E5B2F432EE7A5FD6D2@TY0PR04MB6191.apcprd04.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
authentication-results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=sony.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: TYZPR04MB4128:EE_|KL1PR04MB7772:EE_
x-ms-office365-filtering-correlation-id: 1e4f4f03-a3be-4b8e-4697-08df4568125a
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|376014|23010399003|10070799003|366016|6133799003|18002099003|22082099003|261009223027099003|3023799007|11063799006|56012099006|4143699003|261026121527099003|261102123227099003|10067099003|261028144727099003|261026140227099003|261022115727099003|261021121427099003|261022105027099003|261022075727099003|261021123027099003|38070700021;
x-microsoft-antispam-message-info:
 G6M65m2avtG4QJbP/LPXMgwCiptyL7xPbJUhfPiZozXAnq71TaCkTZYRKtO2QrbzFTY5SPNImXbBLTf4zmeEljGzI57onQmEShZ3QKSotL0ZXmRblztMXBFQhQwrZ7ziQlM/D7aNEQYXXAcrRKfErheJb+0nge6+fASgQXKlEkp3MB9MFpzO8OLj9+JR4FC9+7lX18ZKqbN4/HtOxmkamjre2hpeqhKdP183p9a+52bwtXPDSAfbBQy7GaxhwtPo9Ff6iu7wwn9SWnjC5HPaJ+/fijLOKktTixIF2kNfpuKh9NOEvcON0FHYBu/r3WYUCyOdOpiRSqHtp5DkQ6Ni/zsWB1c9kLBnJgvIJOfdjppqjvDiT/kAmLhymn6ocK/743aU+/IzXFUboErdtRLPQVwwVD6cYxr/Gn6kvUCyW7DDxEbQBf3FUpy+QPuOomXBz2U0rV3aItZDXOv3uTftyJnU6KB1rLpWNwTd4weAnQwkMsTYiF7IPLn/lYZFzHjVTRF0T8X0csIzrjJpsoykKAl7OSGa+20oRrlgxkhO11Dp2WCMQQxzr0Bj+w2xTTBeb/tRJ061XcELQ86IYbhFgsR6gUd2sUqF2qvJyhiYXTX3dCLtMWF6CINKVxkzJi5O9fOr78m9plKTfmNiRQeYIA+siKzod8a60DLmd+7QLSA=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TYZPR04MB4128.apcprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(23010399003)(10070799003)(366016)(6133799003)(18002099003)(22082099003)(261009223027099003)(3023799007)(11063799006)(56012099006)(4143699003)(261026121527099003)(261102123227099003)(10067099003)(261028144727099003)(261026140227099003)(261022115727099003)(261021121427099003)(261022105027099003)(261022075727099003)(261021123027099003)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?Mu0DY6R3iqGfFj7I9Y0rvB3gNC0CF0FqOSd2bKBa9ztNcUfD0UT2l1J8Ngyz?=
 =?us-ascii?Q?0k81eZykTBRWASdjFnlGEcYhLB+Yz9dC3XVRKGXZ/BdDsFOJcGHXuYNmeG31?=
 =?us-ascii?Q?7x7JEWeUwUIiKSSU2lfY100AvGyJHwML6I3sbNITqID+qoe15xSfJQyqOD7n?=
 =?us-ascii?Q?I+OXQXhNFR9YpyxR0aKKC6WL6dHl/r+dmRyW3YpFr8Ev5K3WEbD0lHAeGMlE?=
 =?us-ascii?Q?Qh7egVRBIkjenmjhzs/RM4wOJxMrNc/yPQXE6G6A3Nt41aYQt1tWW6BzzDLX?=
 =?us-ascii?Q?4LyCqfVIPHdBgGnFDQ1KNwf8RTf2CRIsP8sATEio/lvXadwJprwaN7w8u/VV?=
 =?us-ascii?Q?+9dMhaTdTjt4hss1TtyoLnR7jBZJ6olYvYy8KB9diFlcmvYYIpQB7SD2tZuW?=
 =?us-ascii?Q?0TkO3neD3j0jzffaMCAKTkDcnBMmg5TtOh6I1fMTD8bKViDv6e9wcJVuRK2g?=
 =?us-ascii?Q?S+n8ifnQvDy78BDipurfOPOkYw9geAVlfxZPxD2cvHRgIqi97QwWv/EwZDjR?=
 =?us-ascii?Q?JtzPLiMdOMb/lRvOm3yZ5sVtyjXjeGNGp9/h+Vxx2iqJETWVvizWsC+gPBJ/?=
 =?us-ascii?Q?T+CgJqWcxim75yAHJQ0oF/2JmHqw8n6FapnQORy6vCPAnWeFXSEfKLjEwWnQ?=
 =?us-ascii?Q?Zcd0ivCufpcNvpT/6+ptBdKLsnl5Zw1uMoPOxDaTKxqdat4QWCK44/KoCf6a?=
 =?us-ascii?Q?bUfkRMdsVXs4W8RDmZRI8E2WS9cwYwA0aJREXA8eZPEyDqlUsmr8piK7SZat?=
 =?us-ascii?Q?XrOzFuK7C6Um57X1UsDZEWTfjkoTNJ0tM5A+470VixIKg3lGMzxjeYXYby48?=
 =?us-ascii?Q?VtIszC+A4X6Vhnd36pifF/lnezWCNp5w0YzYGLlVMhABtcuDkRIrqQlc9Ztf?=
 =?us-ascii?Q?vhYnnojDNd4olIVyHz3yhg7sc/SJZgFoXySHKa15tHBLiUvNZAxUMAo3n/oq?=
 =?us-ascii?Q?W6/VySINsA1DfIHvN5siY3Cn60cex5igWJtj82rNQbdtTlKPfOw8TM6udNcO?=
 =?us-ascii?Q?U93c9n5xAcnxm5XOJaE6OAHLvCV0AYo0dYVJI4LGy0YalG0hK/EfqoBUeA7A?=
 =?us-ascii?Q?Yw5sKx7IrespZQSI2rd+tfMakS681gaCeztJfp+2yIS7jyXrqZ1AyLeQj6C6?=
 =?us-ascii?Q?Z0AG8z8d2Me1adn9Yw4L6b5QSqM02MFw1s7vgA4vauFkm4m8KlraBndDJrEw?=
 =?us-ascii?Q?6KD7+iJxQxpV9CktLucQ6oPS20AQMofR9RPRo4nDDze77OvzTCtXkGpBdyj6?=
 =?us-ascii?Q?F2OFSWkduN22hC/ZcfJOvL6tyNd5DdQTI6ZjPXmKQEDf4hFye8BcUJtHBT49?=
 =?us-ascii?Q?AABWe8DhEB4cEZbylR2aZpSefgWFsQwfXGaYBNQGs7tOhnIjW7YT61qcXdMv?=
 =?us-ascii?Q?07I0mWQ2AkixQpvoVZAaUo65WLW2KAbFdOIjNnfPMwOefHKhFLMhm79D2bUQ?=
 =?us-ascii?Q?pX/wyAH2p9W+PfVCoAOwinllT7eweEFz++66pe+1pYeU0VOkTMVtqXxYgW/C?=
 =?us-ascii?Q?WKa2ng/EoQVbdG//ftiHVmKStLyDOjqd5zWbwgknnCLLhnUSh3PL2AIHjUxf?=
 =?us-ascii?Q?HU9HUhizI1bVUK9VOxMyXyg98k6QNbPUHpSHVW9weFTYn3oMSBbgm299ny7C?=
 =?us-ascii?Q?hqc7KototJQHqVNuAFe79bh0vtr7c7ZDYgS9JTbqv8Q0oFml1yjxnLpTFUae?=
 =?us-ascii?Q?vTzUfynQLKekFJPYkSOJlYljz1G7nPUvE1EskoslTXnE4Qsha+yAqOMwQq9o?=
 =?us-ascii?Q?yiqPB9pQZLPolXo6tLuEHPeJ8CXF20Y=3D?=
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
	U9VBV2jFS7j0jm/Y1nEtRGH9iRRrRdk6CEss4yL9bvM8YoDCdifAqDIrkhb38v3vfywYkbYd/MyKVZmLFrGAgeGxP2xcO3tuEVb8//OIU/zHCzeoQYJmWsOKUVeSPQ5JsaAJ9f5IcpB/6qGbB4ufwq3Kj9vgUjeTTPX4U3VKzgQAe+U7iceR2G/wZbIHbJbMqyUNFR3rXZOFSo/70kjB9mMUtKXObgozC1a4bT6CgmLDKttDfKWIItCKoxe+Xaz1tZn64Bd3603Lr1Ilu+lVpG03DZOVl6NmK2d0EIWjDWKg8Ul6O/Wei+u8xo5WcDfnyYT2j2BnFYB/0rHHMIA9Pg==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	pTf840uefIqfwa2fKAJBuRXNmsfm1pRTM3ivKh5nTmZD7ZFVQ5KXDcLGz5nO/31gtxs/1Q4tORrPrfEskV1gSIU1wRSUf/87bw0NciOP6ywrhpMsNwG7ttFEUCfqGTiNV6E5MpxR7ncdsyCw2gYybjYFBiS7ICH/pWvkGaztgaM38+x748VQTA8XBszVGPg8O9BuebrWb7wucGNbnzAGqvCyaO1/6wYfAnY3j4nNtKzhoarITo6OG45NJYbHWzz3e2alghga0Sw4WTy4ag3os6aUHJ0MMw/dL/YUJbaNzlxAYj623hcM0v7ALCwUeqC8wI5jPAmNmquppelCeu38pd3HdvpLB5DhcwJmF8skcsVe0SnxIAKRV25mNPvbKwvvQKUABmb8O/m4zeh9QAFtRx2mP86YazPkd5wWehIEQ0zR/b9FzhLl2w9N72OJQ5fsF1IT7icC0lcYTXByxzcnqABHzRW/geoXd+ZNKkniS202t95pwI/M+C7kf+AbVaA1HaaOvyUGu25bYXmUPSKZr9T2ZnKKATIx8E2DU4RAS9WS3RNeN6Jje29VKwPZKZ6a6Koy4lD+SZgwtAOXlrpLzH3Dmf2ED/IDckv8j2F8dUHhF2igLVaz1pBbGoNga1Nk
X-OriginatorOrg: sony.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TYZPR04MB4128.apcprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1e4f4f03-a3be-4b8e-4697-08df4568125a
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Nov 2026 11:35:39.6604
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 66c65d8a-9158-4521-a2d8-664963db48e4
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /q+0RWJ1sKmq2+MDmj2HgMRiR6yoMbC9q1T9sK2AuUB/nhovI+fY60OPeOBnSOk+hUJs0BAJousYSSe/R/242g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: KL1PR04MB7772
X-Authority-Analysis: v=2.4 cv=XdAcX455 c=1 sm=1 tr=0 ts=6afd8d96 cx=c_pps
 a=ACj0lxkRrF7ianJMw1vTbQ==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=zJRp6_cAMcgA:10 a=7j0FZ4iXMVMA:10 a=xR56lInIT_wA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=KAb5x4SsHD3PzxGk7EmX:22 a=lmptg-Pxpg44AF-n8Qp9:22
 a=VwQbUJbxAAAA:8 a=z6gsHLkEAAAA:8 a=nTg3QbKWAAAA:8 a=pGLkceISAAAA:8
 a=GvQkQWPkAAAA:8 a=i0EeH86SAAAA:8 a=voM4FWlXAAAA:8 a=QSHWsWSW_gYo7CicXioA:9
 a=CjuIK1q_8ugA:10 a=IC2XNlieTeVoXbcui8wp:22
X-Proofpoint-ORIG-GUID: CPzjlXVab_O89K3P2iYaVHtzrnvCMn-d
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTE4MDA0NCBTYWx0ZWRfX7yYkVZjvpydj
 vAT20QfB3JsOlPR1aewdAx6/IqF2A9gwmfqMFhmWT7WChz9I95aqGys9kvEQKLbR+22oVxrrugR
 YDgU8q4cjobSwUsS/WIVkBgOd5uMHNtuRwQazDnLo3iAI7qPnurmrM5o4t+sDwonQTbiKO1Da0f
 p7A+8tpWfLdpUDymwyX6PXk1SNapoM5ayZaMh7Fsmc3aOiBaDRgJcDDVul3AljSVbL47absYNvM
 nUC+TRW5hkBInaFoQ9WMVZ2aq6iZ9BffeWzRZ2M6+Tdd79m7Wnal4CWfJsuTV9V71Sqkfdah1L6
 YoLmiQaf4T+A90upi+SaHyg3Ob+1E+1uGA3IKcCeELIGvQXV8JIHzAKU3xy3TVUw5cBMznorW3/
 aJmh0i8TVI6B3/6bUKJB7PsX0nmKyg3k9lhS6qWGLnaI+R9WZSNsKpSLzyQpJnb45OvhkXs0Lq4
 D+YpW5sit0JXqT4FR4g==
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTE4MDA0NCBTYWx0ZWRfX1rx0bkFnVt4j
 6ayyKqZHRiZ5lCS7ipXRv5k8gE8P+7OF83F1HgKA9UleAssee4WVUnqTm13VOAvAu+5OSGack9W
 +Gl9B+1mfbA81Xbh0Gp0gLJrMEQyKTOxrNjnuRMnE6LFCvt63vnV
X-Proofpoint-GUID: CPzjlXVab_O89K3P2iYaVHtzrnvCMn-d
X-Sony-Outbound-GUID: CPzjlXVab_O89K3P2iYaVHtzrnvCMn-d
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-18_03,2026-11-16_01,2025-10-01_01
X-Spam-Status: No, score=-20.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi,

How about this patch ?

________________________________________
From: Su, Friendy <Friendy.Su@sony.com>
Sent: Friday, October 30, 2026 17:22
To: xiang@kernel.org; bluce.lee@aliyun.com; jnhuang95@gmail.com; hudsonzhu@=
tencent.com; zhaoyifan28@huawei.com
Cc: linux-erofs@lists.ozlabs.org; Palmer, Daniel (SGC); Mo, Yuezhang
Subject: Re: [PATCH v1] erofs-utils: tests: add test for fanotify FAN_PRE_A=
CCESS event


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


