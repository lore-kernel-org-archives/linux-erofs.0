Return-Path: <linux-erofs+bounces-4474-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E1CB4C61DD3
	for <linux-erofs@archiver.kernel.org>; Fri,  4 Sep 2026 06:37:31 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4hbmwp1Lcjz2y2K;
	Fri, 04 Sep 2026 16:37:30 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=fail smtp.remote-ip=3.75.33.185
ARC-Seal: i=2; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1788503850;
	cv=fail; b=EY7CEOJWuKnNWlp7MGGxrc6YEANR5DJXfYCqavaNDq4yAZa9IPtypd+c0qIyUSE4/U1jZxnnzCpQzNlW/OeNJ3oNCXa2CyYNRZXhUmwICTbsTxIbyg0DLNbMMw1BeaiQnwbiwBjchqXyhwqZDnIp68JRHW20dfycJObw3WLL4JMkRCPTsbdgol7RAwyX7C9yKUuRISZsPl2OioDChnq0WIpn4zPX153/+W2Jc89tT2t7JKgAxmYLeXLTjBoy4MPf83yimRwoSJu6qdA324E8wVOiUBlWXdefO4biZR3dA/tBcGlCyMChBbK6spHmifl/0MV9wA/kbmbJVV7vWzf8pQ==
ARC-Message-Signature: i=2; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1788503850; c=relaxed/relaxed;
	bh=lxwB0KWZUzvFKIqugvyd7O/7zDghDTWFuQ1oqZt32lY=;
	h=Subject:From:To:CC:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=dutSpWvT5Z0bLkyt2+Wc9eZF6PbhwVeLRLwRBLafwUcbLK+pll4AvoScsptfZ2dOqFExGs5PxskISYiVIXmeHnuWBHJrj4RxFS7dmMH7DU8NfG8A5vNWb/5VvGTqLPda3kGXUb6kQVZaN1dFX3EcIoolRgybenCARb0J9rvRL91v0FZ0K+3wanmkMSMTppQu43T3YiPoDT93j4gXHOfX+5ts5cCelDKopuo0oRxg5a7jLGC56DnH3VidklcU1a3uA9M+6TJaw/MWKqmzkMwnRSmLHsfYk2jGiakupBGQokO+BWmMNgL75WvbuFYvPEeJC3tXanANGvj9cgdsuY9G7g==
ARC-Authentication-Results: i=2; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.de; dkim=pass (2048-bit key; unprotected) header.d=amazon.de header.i=@amazon.de header.a=rsa-sha256 header.s=amazoncorp2 header.b=k0ZBUOPF; dkim-atps=neutral; spf=pass (client-ip=3.75.33.185; helo=fra-out-007.esa.eu-central-1.outbound.mail-perimeter.amazon.com; envelope-from=prvs=700866dee=waltju@amazon.de; receiver=lists.ozlabs.org) smtp.mailfrom=amazon.de
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.de
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=amazon.de header.i=@amazon.de header.a=rsa-sha256 header.s=amazoncorp2 header.b=k0ZBUOPF;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=amazon.de (client-ip=3.75.33.185; helo=fra-out-007.esa.eu-central-1.outbound.mail-perimeter.amazon.com; envelope-from=prvs=700866dee=waltju@amazon.de; receiver=lists.ozlabs.org)
Received: from fra-out-007.esa.eu-central-1.outbound.mail-perimeter.amazon.com (fra-out-007.esa.eu-central-1.outbound.mail-perimeter.amazon.com [3.75.33.185])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4hbmwj4n1Zz2xlJ
	for <linux-erofs@lists.ozlabs.org>; Fri, 04 Sep 2026 16:37:23 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazoncorp2;
  t=1788503846; x=1820039846;
  h=from:to:cc:date:message-id:references:in-reply-to:
   mime-version:subject;
  bh=lxwB0KWZUzvFKIqugvyd7O/7zDghDTWFuQ1oqZt32lY=;
  b=k0ZBUOPFcQGN/Q7Mf4F1REdn4W2j1sZ74tqvLU8+yTcy24bvfWqqeZCV
   TGOlXl4pzzaRbu9281vGBQg6ydxKb/S2vajeKso8hRqO2us/TZLVaF6YJ
   fg6Q9rytZDx50q84AXH4Ei8iS4P49deyU/0HBDNGS7VvHKltksmWHduGu
   nPE9LWCCZ8lyDZ9XE1+44vOBZX3adhGTHK9wcha2hcK+pmexHcKbk8Y4e
   aZjgM4RM69fdnQvc/iln0C93cjIwFPTTPGhSxIYGBzGfkvUn4ie8gqMY2
   hpN+AfKGO5r+R2wkk9ZJq/sB4TBtn5tpHZwRDuSWrw2F8nH8Q9IB4essx
   A==;
X-CSE-ConnectionGUID: R6tkSL7PRi2X5zuk0kO15Q==
X-CSE-MsgGUID: eCdIPCMZQsaQ4koDMHFd5Q==
X-Amazon-filename: image001.png, image002.png, image003.png, image004.png
X-IronPort-AV: E=Sophos;i="6.25,260,1779148800"; 
   d="png'150?scan'150,208,217,150";a="18959188"
Subject: Re: [PATCH] erofs: disable LZ4 rolling decompression for now
Thread-Topic: [PATCH] erofs: disable LZ4 rolling decompression for now
Received: from ip-10-6-6-97.eu-central-1.compute.internal (HELO smtpout.naws.eu-central-1.prod.farcaster.email.amazon.dev) ([10.6.6.97])
  by internal-fra-out-007.esa.eu-central-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Sep 2026 06:37:00 +0000
Received: from EX19MTAEUA001.ant.amazon.com [54.240.197.233:15597]
 by smtpin.naws.eu-central-1.prod.farcaster.email.amazon.dev [10.0.28.57:2525] with esmtp (Farcaster)
 id aa9d41f3-3238-4b50-813e-e25fc5b1963d; Fri, 4 Sep 2026 06:36:59 +0000 (UTC)
X-Farcaster-Flow-ID: aa9d41f3-3238-4b50-813e-e25fc5b1963d
Received: from EX19EXOEUC001.ant.amazon.com (10.252.51.133) by
 EX19MTAEUA001.ant.amazon.com (10.252.50.192) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.45;
 Fri, 4 Sep 2026 06:36:59 +0000
Received: from FR5P281CU006.outbound.protection.outlook.com (10.252.50.44) by
 EX19EXOEUC001.ant.amazon.com (10.252.51.133) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.45
 via Frontend Transport; Fri, 4 Sep 2026 06:36:59 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=H00DOKXeWwN9WwGHuY8LYZAs0bTLvPQmZ86C/5MLsV9pHxnhqMN27Sns6k5ppXC14S2giWWZnWioKMngpLtM1VGKnIh/PuXi3oMiyKHTpCIP7aWl0ZOReQAQjUX1M38FcvpwvQoTAIo/AQ7oSXD2ai/AVZDgoPYSwrws/qdmn38uRPzqneBcOAqormv/56xThjMefp0G1uhTRAX7l+x8ejy1OiIrOP7hRrXYx75q4kcrNccYfcFbS5HLab8Gd+UDcS2mFQN4/yzmfVW78CC/jmfTkSp0A6isE4G2fE5GVowB0K16SmWhGbaVDcn8ureovpdq2KUt0sGYvBruEQsViQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vWG6aSHSW3LTBKqMO/22npuAKNiAukvdYRdAALxcC4c=;
 b=WoLsB1Z5EAHwANpWa3sPz/c5Fg4Ahi0q/HvC6bVKgeSnn8Vofs/C4M0d1vY7jHpq3CB9UHD1PIHpogOU7RBKkMTOa//iwlteGO/gGsA0yP8ZD80i8zdD0e01f3Gj3zYCpGLY/qT3rHR+IH+ukRZOI1BKVXQkJyAtq5vJCu7SIs+XFKnwhNEAgaUKi0hTBawuJNzlb3AK4oCzkelAzwUXCpkMtdF2zps53IEq89YVRZG8N94+UsaLE5HY8i9xwRVSEOQkSjGl/w+u1My4FVoXBWX/5PX+ltmHwZ+FDj8i0E5KyaARioLxuTBFpgbC/n+R5DKuifNGs6SjoVifbHroiw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amazon.de; dmarc=pass action=none header.from=amazon.de;
 dkim=pass header.d=amazon.de; arc=none
Received: from BEZP281MB2102.DEUP281.PROD.OUTLOOK.COM (2603:10a6:b10:53::8) by
 FR4P281MB3562.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10:d8::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.360.13; Fri, 4 Sep 2026 06:36:34 +0000
Received: from BEZP281MB2102.DEUP281.PROD.OUTLOOK.COM
 ([fe80::a74c:626:53d3:acc2]) by BEZP281MB2102.DEUP281.PROD.OUTLOOK.COM
 ([fe80::a74c:626:53d3:acc2%7]) with mapi id 15.21.0360.008; Fri, 4 Sep 2026
 06:36:34 +0000
From: "Walther, Jens-Uwe" <waltju@amazon.de>
To: Gao Xiang <xiang@kernel.org>, "linux-erofs@lists.ozlabs.org"
	<linux-erofs@lists.ozlabs.org>
CC: Yann Collet <yann.collet.73@gmail.com>, Gao Xiang <xiang@kernel.org>,
	"Berning, Sam" <bernings@amazon.com>, "Garcia, Arnaldo" <agarrcia@amazon.com>
Thread-Index: AQHdO7DO+7Vyu5BxiEiHmYTM6AI9Dra88cQAgAEFhwY=
Date: Fri, 4 Sep 2026 06:36:34 +0000
Message-ID: <BEZP281MB2102B46608D0ECC718BF6568D2B52@BEZP281MB2102.DEUP281.PROD.OUTLOOK.COM>
References: <20260903142841.4465-1-xiang@kernel.org>
 <apmK6FGQUsqZN-YJ@XiangdeMacBook-Pro.local>
In-Reply-To: <apmK6FGQUsqZN-YJ@XiangdeMacBook-Pro.local>
Accept-Language: en-US
Content-Language: en-GB
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
x-ms-reactions: allow
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amazon.de;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BEZP281MB2102:EE_|FR4P281MB3562:EE_
x-ms-office365-filtering-correlation-id: 5f60ac80-05ec-4a83-4632-08df0a4edd2c
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|6049299003|376014|10070799003|23010399003|38070700021|4013099003|4053099003|11063799006|10067099003|56012099006|6133799003|18002099003|22082099003|8096899003|4143699003;
x-microsoft-antispam-message-info: Sx0XOZfvw9dIBOi6S9g7g8i1tm7PMnMUEi1jFxHFyMEM+1S5lVKJBXHTs9K9hoDWW3LSEVu2ZNUlS8VSAAuTyfZ+D+c4o/zBwHSdzv8wDZWm1FS4xSqbmXj04uCkaJKbV7P/zc8kK6+Xw8qkGgGUlSMdPkOuwWfqYAEyj+aZdgrq9YobDAfNA+STWUaXhgJg9t8hxW0Ih6FkHFZoYICgEBVhGxpuxFMJxDQ6WmS9SwqSjOD9vOWdyKgDfZV7qd22fSYf0G8iZYT2QyQqvJLcTgvDEx+w/xxFgF3C149sWgQfA7YuIDlwz9sAofFX0anhiWbDg5UJnHCO3QB2D0dhOOAVLZEEn26MmzjCu/Xw1kK1ymq/83UsLeKsVDxgpRSHhVx/CT4NPkdROJoBvToaKo0LpoCth6oHYWyki1wUCrsKE7+OEp0rR7OS+ggBmj7pv4ZWAZTr+eXwa5+2/akPaQOYlX3fO3F3wd8XBrUxAPPZV9cPlL7xRSil/FSqpgasJn9WLo0gWVmrsiBdQfZ8EetOzW1VhGy58753EymNQvMbkH4CJe5elUCtCNLkYpM5cDOvoBG3tinxkAg5B71pOW/8/QwqgmJgV91AGmJm7IovyAiV+gVaTOlNn5f3lK7YzYkS9qIfe5NZ3Iy7Q/AJf1Zv4caCPiFl/gizVCXUvqdpX1qJ8z7IRLUbZhtU4O6D
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BEZP281MB2102.DEUP281.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(6049299003)(376014)(10070799003)(23010399003)(38070700021)(4013099003)(4053099003)(11063799006)(10067099003)(56012099006)(6133799003)(18002099003)(22082099003)(8096899003)(4143699003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 2
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?KnrNu4pq8/PYBWDDbKdry3DspY4w+bzvczYglv7s6XqfvAIuI4y9y6hdPs6B?=
 =?us-ascii?Q?1s4rfOAFy7x4aAmyXDaZItOkPkXZi7xxPq+5uEg/iCE1BUzDOpz8wG2jnqVA?=
 =?us-ascii?Q?fWVNn4PnvtnqLlbQn7pkRlsvny7YN1i+GB6hiLgzdZeeAKoNeDAuVCMzWEHx?=
 =?us-ascii?Q?jkX1JijKH50dIjG/dpwEYsMhZu+9+/pG83WIzbl0nzVp8O62pYpDCO/MRgbk?=
 =?us-ascii?Q?Bj7PpDz/ryOGt57bXDMRqBsdZDqoAt5qOx05yBY2aOSwozCp9sTdttgKbkDI?=
 =?us-ascii?Q?5nciRY3jyy2anAnlhwS+UqYyH/iyso+hlneaY/k9IDWUPjnQ4G9VE6KBSJV7?=
 =?us-ascii?Q?j8Gb+RihqM6mnmtvt2ANP8fIQL2XgxpD6xvJsAuSpYgjBvbVMaGcNhoVjMw7?=
 =?us-ascii?Q?3yj8HmJPcuW35IkC+gQA8y/R2PCiaO8iKAegZ6HjGjyZhqT4XDbxb8arlUBP?=
 =?us-ascii?Q?q5iOXFm09ppwQ3AW6uQLUWYn1+m2npds2csUKk8zsCdiomwChnby/LSVfw4B?=
 =?us-ascii?Q?Xbnq3L++4P2zZJdDQdGOTB8I0XXRUJ0vnMHP3cEVmRnC5HAapGLSVyNx4oZf?=
 =?us-ascii?Q?NzawDbveP+Xrm+Q6cw/OYF2Thqwv/ODAo+9JVH+9TMnZOeXqSB1V9QwOAzcu?=
 =?us-ascii?Q?Od8hi52RUZANqjqODsze25s6QZf+BaCxUbcBAKZp4P9lp7Y83kdHtq39g25/?=
 =?us-ascii?Q?mYYoa3eTw07Xsq5uzA6q7/FmrXLxdxttlibkyqtkpGszmKOC4TKvkG32o9TO?=
 =?us-ascii?Q?fqp1RPb+CViUUDUwrnCtu2w7NIRDye5KqQDhEhMVlT5DLqRWWmGDlc2KNRGd?=
 =?us-ascii?Q?FpCAh97G8P6gL5VQ7aQhuRCuOt7K0CMzqEf2Z/aVq7c5YxXBsI3cqHvd8wcd?=
 =?us-ascii?Q?yEk5e57rnRCvzUdUUuO4+9F8bRLZf+TYbZx7acMfKAZ3WXt2n1I1Uvro+CH6?=
 =?us-ascii?Q?C5XXlAmrt2ItHfMmR73zPjvYUjG1nfy7aqaFlXaHKTZXXnmuTo07Wq68TcH8?=
 =?us-ascii?Q?yI+5k5St2P57WNSdRhAbRGQE1P54yGc8swv9WbvAJV/hixxUud4Zkg8icdXP?=
 =?us-ascii?Q?jtsWiXGONyvEky9inomplLNQBXRxK7k/UHaaa6ZtXFEMk333H4OXlELgjeNl?=
 =?us-ascii?Q?2VDHBypJOCYzbx37oPm1dlLyNKQ3YKw5A+nYsiq2Emd0LxBx/XdLo1qugRro?=
 =?us-ascii?Q?mVJmCcu45673rabrJlm4yxBVnJ6+6AWH+aLeFZcst97F7uoPbg7B0CgQzsw5?=
 =?us-ascii?Q?M0ICeOEUc3sNeQeifkemRp+iIr75kVgznb5oTYsQ+0fuMpNJpzY8iRzSL6lp?=
 =?us-ascii?Q?AoBIMv7iaSeNSEfAEllPI+1mcizvUpm1IQos2XHmmwgPWdEL/glBTDxlw1AA?=
 =?us-ascii?Q?oN8Fa0xot+arf7KMYizHrurJCHSY9/chkPRAOIqdAQlalxeFEctbvQ5/SPpM?=
 =?us-ascii?Q?cSBS6MkbwWCIBHdFevc1o7OT4YIB4RlkDwBI3NIyZMckZZF65/ueUQpTMRpC?=
 =?us-ascii?Q?JXyTnsnrKyJL0CUIClseABNcmri0ScK82iGa2Vxgy+37563ck125PZjoF5GB?=
 =?us-ascii?Q?iFmcQyDv5iUD+pggnD7RCLcs7r1eUBIA3BorEfmsOA9FU7BXf5a5nqqhZIaI?=
 =?us-ascii?Q?vvhzEkgwWhhrUGPiWX1ngeyXfi9FMbBRG+0GMG2iegP02AFLuhVUKDj7lf8S?=
 =?us-ascii?Q?d3Wlx71bSA7rk1sR/ZnuUfnl8zcOrH9XvBcCjGZ8qraXI4uGaV62dazRuzWO?=
 =?us-ascii?Q?PQ/3gf/VxkQz296pX9ODBc//BoribhbDBMlBEkcrVX5DDdVXoPgYNtL0dKZ0?=
x-ms-exchange-antispam-messagedata-1: 7xWFAcoc/F6ZWw==
Content-Type: multipart/related;
	boundary="_007_BEZP281MB2102B46608D0ECC718BF6568D2B52BEZP281MB2102DEUP_";
	type="multipart/alternative"
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
X-Exchange-RoutingPolicyChecked: L2yWAeqT1S+Zd1XspJ1mySNpwOhgXmzY9pdfagd0bV6VxljWXFcvVaDb2FKsaXL97cF0dYSpXVydGYM/M4QikVU2CZxlL0ptqKzg+ybDfggIlqXGzPaTy5pkqPmt4PCYFYxTlxl4eCDIdYlp3KxTeqW67LX/3E+Wk5MucR+R7ZpXZJLPbfjAMmMrQAzAJfD3HqjQXgVNQq6wee0rqFeSwVXFaVAZ+SdP9wWEldex2lYdMlhoN8m1mPOZyygX+cKJ19SUO52zu3MA4QHFymN9lKLb7PHPwPoJ3t/f//lUFGJDj8iBtVzS8c4CNXh6LfcnL3lBxL56pOstIDEUAvwvqg==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BEZP281MB2102.DEUP281.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: 5f60ac80-05ec-4a83-4632-08df0a4edd2c
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Sep 2026 06:36:34.4174
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5280104a-472d-4538-9ccf-1e1d0efe8b1b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: nvP0phXm+gpPmuwtXT8bMT0Vb7lr7LIrR+KqMRuX0zwxthk/2xwHJQrjptCwVGwFCcE9aAiAd2ile5bFQlKYIw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: FR4P281MB3562
X-OriginatorOrg: amazon.de

--_007_BEZP281MB2102B46608D0ECC718BF6568D2B52BEZP281MB2102DEUP_
Content-Type: multipart/alternative;
	boundary="_000_BEZP281MB2102B46608D0ECC718BF6568D2B52BEZP281MB2102DEUP_"

--_000_BEZP281MB2102B46608D0ECC718BF6568D2B52BEZP281MB2102DEUP_
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Thank you very much!
I will involve to our Bottlerocket team to take care during my annual leave=
 which starts today in the afternoon.

Best regards
Jens-Uwe Walther
Senior Specialist TAM Containers
AWS Enterprise Support
[CKA badge]<https://www.credly.com/badges/b4f55949-4357-4062-93a9-6d0f0f5f3=
833/linked_in>[CKAD badge]<https://www.credly.com/badges/85b75f03-91d4-4887=
-8150-cfb9ea39d272> [CKS: Certified Kubernetes Security Specialist] <https:=
//www.credly.com/badges/c26e3b3c-cfc7-46d7-8b7b-7a7a59045c60/>
e: waltju@amazon.com<mailto:waltju@amazon.com> m: +49 152 38870547
[cid:image004.png@01D9D4D4.4DF69060]<http://www.aws.amazon.com/>
From: Gao Xiang <xiang@kernel.org>
Date: Thursday, 3. September 2026 at 16:58
To: linux-erofs@lists.ozlabs.org <linux-erofs@lists.ozlabs.org>
Cc: Walther, Jens-Uwe <waltju@amazon.de>; Yann Collet <yann.collet.73@gmail=
.com>; Gao Xiang <xiang@kernel.org>
Subject: RE: [EXTERNAL] [PATCH] erofs: disable LZ4 rolling decompression fo=
r now

CAUTION: This email originated from outside of the organization. Do not cli=
ck links or open attachments unless you can confirm the sender and know the=
 content is safe.



BTW, this issue can be reproducible with the image in the attachment
and the following steps (at least on my local VM):

 echo 4 > /proc/sys/vm/drop_caches
 mkdir mnt mnt2
 mount foo.erofs mnt
 cp mnt/seq mnt2/
 while true; do echo 1 > /proc/sys/vm/drop_caches; sleep 1; done &
 while true; do echo 2 > /proc/sys/vm/drop_caches; sleep 1; done &
 stress -p16 -l0 mnt mnt2 -d $(pwd)/baddump   # erofs-utils/contrib/stress



Amazon Web Services EMEA SARL
38 avenue John F. Kennedy, L-1855 Luxembourg
Sitz der Gesellschaft: L-1855 Luxemburg
eingetragen im Luxemburgischen Handelsregister unter R.C.S. B186284

Amazon Web Services EMEA SARL, Niederlassung Deutschland
Anni-Albers-Str. 21, D-80807 Muenchen
Sitz der Zweigniederlassung: Muenchen
eingetragen im Handelsregister des Amtsgerichts Muenchen unter HRB 242240
USt-ID DE317013094

--_000_BEZP281MB2102B46608D0ECC718BF6568D2B52BEZP281MB2102DEUP_
Content-Type: text/html; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

<html>
<head>
<meta http-equiv=3D"Content-Type" content=3D"text/html; charset=3Dus-ascii">
</head>
<body>
<div style=3D"direction: ltr; font-family: Aptos, Arial, Helvetica, sans-se=
rif; font-size: 12pt; color: rgb(0, 0, 0);">
Thank you very much!</div>
<div style=3D"direction: ltr; font-family: Aptos, Arial, Helvetica, sans-se=
rif; font-size: 12pt; color: rgb(0, 0, 0);">
I will involve to our Bottlerocket team to take care during my annual leave=
 which starts today in the afternoon.</div>
<div style=3D"direction: ltr; font-family: Aptos, Arial, Helvetica, sans-se=
rif; font-size: 12pt; color: rgb(0, 0, 0);">
<br>
</div>
<div id=3D"ms-outlook-mobile-signature" dir=3D"ltr">
<div class=3D"MsoNormal" style=3D"color: black;">Best regards</div>
<div class=3D"MsoNormal" style=3D"text-align: left; color: black;"><b>Jens-=
Uwe Walther</b></div>
<div class=3D"MsoNormal" style=3D"text-align: left; color: black;"><i>Senio=
r Specialist TAM Containers</i></div>
<div class=3D"MsoNormal" style=3D"text-align: left; color: black;">AWS Ente=
rprise Support</div>
<div class=3D"MsoNormal" style=3D"text-align: left;"><span style=3D"color: =
black;"><a href=3D"https://www.credly.com/badges/b4f55949-4357-4062-93a9-6d=
0f0f5f3833/linked_in" title=3D"https://www.credly.com/badges/b4f55949-4357-=
4062-93a9-6d0f0f5f3833/linked_in" data-outlook-id=3D"f97761b4-9e21-4b76-977=
5-0ed420936759" style=3D"color: black;"><b><img src=3D"cid:image001.png@01D=
9D4D4.4DF69060" alt=3D"CKA badge" id=3D"Picture_x0020_4" width=3D"54" heigh=
t=3D"54" style=3D"width: 0.5729in; height: 0.5729in;"></b></a></span><span =
style=3D"color: blue;"><a href=3D"https://www.credly.com/badges/85b75f03-91=
d4-4887-8150-cfb9ea39d272" title=3D"https://www.credly.com/badges/85b75f03-=
91d4-4887-8150-cfb9ea39d272" data-outlook-id=3D"8e764ecf-3478-4a09-9dfc-cd9=
9ff56ccd6" style=3D"color: blue;"><b><img src=3D"cid:image002.png@01D9D4D4.=
4DF69060" alt=3D"CKAD badge" id=3D"Picture_x0020_3" width=3D"54" height=3D"=
51" style=3D"width: 0.5625in; height: 0.5416in;"></b></a></span><span style=
=3D"color: black;">&nbsp;</span><span style=3D"color: rgb(0, 0, 0);"><a hre=
f=3D"https://www.credly.com/badges/c26e3b3c-cfc7-46d7-8b7b-7a7a59045c60/" t=
itle=3D"https://www.credly.com/badges/c26e3b3c-cfc7-46d7-8b7b-7a7a59045c60/=
" data-outlook-id=3D"33dd878e-cc8e-4016-a1e4-ba4653daf52f" style=3D"color: =
rgb(0, 0, 0);"><img src=3D"cid:image003.png@01D9D4D4.4DF69060" alt=3D"CKS: =
Certified Kubernetes Security Specialist" id=3D"Picture_x0020_2" width=3D"4=
8" height=3D"48" style=3D"width: 0.5104in; height: 0.5104in;"></a></span></=
div>
<div class=3D"MsoNormal" style=3D"text-align: left;"><span style=3D"color: =
black;">e: </span>
<span style=3D"color: rgb(5, 99, 193);"><a href=3D"mailto:waltju@amazon.com=
" title=3D"mailto:waltju@amazon.com" data-outlook-id=3D"ceb1270b-1174-487e-=
9eff-90d85ab35fb0" style=3D"color: rgb(5, 99, 193);">waltju@amazon.com</a><=
/span><span style=3D"color: black;">&nbsp;m:&nbsp;+49
 152 38870547</span></div>
<div class=3D"MsoNormal" style=3D"direction: ltr; text-align: left; font-si=
ze: 10pt; color: rgb(5, 99, 193);">
<a href=3D"http://www.aws.amazon.com/" title=3D"http://www.aws.amazon.com/"=
 data-outlook-id=3D"8eb98e53-8aa3-43a5-9e35-10fb2fb42de8" style=3D"color: r=
gb(5, 99, 193);"><b><img src=3D"cid:image004.png@01D9D4D4.4DF69060" id=3D"P=
icture_x0020_1" width=3D"72" height=3D"42" style=3D"width: 0.7604in; height=
: 0.4479in;"></b></a></div>
</div>
<div id=3D"mail-editor-reference-message-container">
<div style=3D"padding: 3pt 0in 0in; border-width: 1pt medium medium; border=
-style: solid none none; border-color: rgb(181, 196, 223) currentcolor curr=
entcolor;">
<div style=3D"text-align: left; font-family: Aptos; font-size: 12pt; color:=
 black;">
<b>From: </b>Gao Xiang &lt;xiang@kernel.org&gt;<br>
<b>Date: </b>Thursday, 3. September 2026 at 16:58<br>
<b>To: </b>linux-erofs@lists.ozlabs.org &lt;linux-erofs@lists.ozlabs.org&gt=
;<br>
<b>Cc: </b>Walther, Jens-Uwe &lt;waltju@amazon.de&gt;; Yann Collet &lt;yann=
.collet.73@gmail.com&gt;; Gao Xiang &lt;xiang@kernel.org&gt;<br>
<b>Subject: </b>RE: [EXTERNAL] [PATCH] erofs: disable LZ4 rolling decompres=
sion for now<br>
<br>
</div>
</div>
<div id=3D"mail-editor-reference-message-body">
<div class=3D"ms-outlook-mobile-reference-message skipProofing">
<meta name=3D"Generator" content=3D"Microsoft Exchange Server">
</div>
<div class=3D"PlainText" style=3D"font-size: 11pt;">CAUTION: This email ori=
ginated from outside of the organization. Do not click links or open attach=
ments unless you can confirm the sender and know the content is safe.<br>
<br>
<br>
<br>
BTW, this issue can be reproducible with the image in the attachment<br>
and the following steps (at least on my local VM):<br>
<br>
&nbsp;echo 4 &gt; /proc/sys/vm/drop_caches<br>
&nbsp;mkdir mnt mnt2<br>
&nbsp;mount foo.erofs mnt<br>
&nbsp;cp mnt/seq mnt2/<br>
&nbsp;while true; do echo 1 &gt; /proc/sys/vm/drop_caches; sleep 1; done &a=
mp;<br>
&nbsp;while true; do echo 2 &gt; /proc/sys/vm/drop_caches; sleep 1; done &a=
mp;<br>
&nbsp;stress -p16 -l0 mnt mnt2 -d $(pwd)/baddump&nbsp;&nbsp; # erofs-utils/=
contrib/stress<br>
</div>
</div>
</div>
<br><br><br>Amazon Web Services EMEA SARL<br>38 avenue John F. Kennedy, L-1=
855 Luxembourg<br>Sitz der Gesellschaft: L-1855 Luxemburg<br>eingetragen im=
 Luxemburgischen Handelsregister unter R.C.S. B186284<br><br>Amazon Web Ser=
vices EMEA SARL, Niederlassung Deutschland<br>Anni-Albers-Str. 21, D-80807 =
Muenchen<br>Sitz der Zweigniederlassung: Muenchen<br>eingetragen im Handels=
register des Amtsgerichts Muenchen unter HRB 242240<br>USt-ID DE317013094
</body>
</html>

--_000_BEZP281MB2102B46608D0ECC718BF6568D2B52BEZP281MB2102DEUP_--

--_007_BEZP281MB2102B46608D0ECC718BF6568D2B52BEZP281MB2102DEUP_
Content-Type: image/png; name="image001.png"
Content-Description: image001.png
Content-Disposition: inline; filename="image001.png"; size=5216;
	creation-date="Fri, 04 Sep 2026 06:33:56 GMT";
	modification-date="Fri, 04 Sep 2026 06:33:56 GMT"
Content-ID: <image001.png@01D9D4D4.4DF69060>
Content-Transfer-Encoding: base64

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
ekHoBbN7pv8Hbe64mj8KnqcAAAAASUVORK5CYII=

--_007_BEZP281MB2102B46608D0ECC718BF6568D2B52BEZP281MB2102DEUP_
Content-Type: image/png; name="image002.png"
Content-Description: image002.png
Content-Disposition: inline; filename="image002.png"; size=5563;
	creation-date="Fri, 04 Sep 2026 06:33:56 GMT";
	modification-date="Fri, 04 Sep 2026 06:33:56 GMT"
Content-ID: <image002.png@01D9D4D4.4DF69060>
Content-Transfer-Encoding: base64

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

--_007_BEZP281MB2102B46608D0ECC718BF6568D2B52BEZP281MB2102DEUP_
Content-Type: image/png; name="image003.png"
Content-Description: image003.png
Content-Disposition: inline; filename="image003.png"; size=7022;
	creation-date="Fri, 04 Sep 2026 06:33:56 GMT";
	modification-date="Fri, 04 Sep 2026 06:33:56 GMT"
Content-ID: <image003.png@01D9D4D4.4DF69060>
Content-Transfer-Encoding: base64

iVBORw0KGgoAAAANSUhEUgAAAEkAAABJCAYAAABxcwvcAAAAAXNSR0IArs4c6QAAAAlwSFlzAAAW
JQAAFiUBSVIk8AAAABl0RVh0U29mdHdhcmUATWljcm9zb2Z0IE9mZmljZX/tNXEAABruSURBVHhe
xZwHmFRlloZP5W6SiAooAgISJChGxHFUDIg5B9Q1jY9ZcVydWXUwrGEN6+ioOyLqOEaM6KgjimLA
rBgwgQJKBgFBJHRX3u/9b93u6upbHYjneeqB7rrhv+c/4TvfObejeYltZFmdzNuELzP22ucZm/tL
zjpvHrZDdo3avjtELR4NbeTVmUU35gp+W523f32ctufeT9vsxXmriJtTyqJfs/b+lKx175iyY38X
s8MGxaxlYuMpa6MoCeW88FHanv9QylmUs3gsZC0SZgn9i7SQQsLhvM37JW+3jU05JR63Z8wO3S3m
vtvQskGVtKJKypFinvsgbXNkOQlZTigcstaVZtu0D9v0BXkLSQc5BYBttwzbnCU5y2TN5i3N2y3P
Je0ZlFWwrMr4hlPWBlESynmx4FazUE7MZCnydX322zlqZx4Qt5k/Z+1PDyWtTYuQYWnH/z7uFPXg
6yl779usRaS9eUtQlixLSsYNsawNoaz1qqSV1Yo5civcZdYiz3JkOBaRcvaXcobvHbPtOkec98xY
kLVi2yCd9OoUsVtOr7TJP2btiXdS9u53WadcrPDmZ1P27PsZKTNqh+wSUzxbf5a1XpREtkI5z0o5
M38uKEcPF9FzYDnD94pZ3y6ecnzZWhmNwJ3NmVXI0vjZlx26R2yH7lLWT1LW27IsKYtrzV6cs5ue
Ttkz7xKz4rKsaE1cW5dxa50qCeW8/EnannkvbT8urFUO1jN0x6idtE/M+pUox3+YzduErFUlruYF
7i30c6ns0E3K6lZpXxYsyylLusSFb3omqU1JuQB/yK6xdaqsdaKkKpTzqaecGShHV8UtUM4BKEdu
1b9rXcspVUCrCilJn6UrctZSyiI2lZOBsqyBsqwvZnhu+H5BWTPl0jdiWe9l7ITfx+zgXYSzChlz
bSxrrZRUlcrbSwrIxIYZC3OecvRsZKgDBnoxZ8A2DSvHXzzBHBhANiO+8HNjsmOPiO3Yo9I+n5Gx
x99O2wfCVljWTMGK659K2tPvpaSsuFNWbC1A6RopqRrlfJIpWI6nHGIEytlvh4gsJ27byzWaI2kp
Z3XSC+qpdN4yik1N0JO7xU49ou4zaVrGxrwjZU31lPWT4uH1T6KstB0vN1xTZTVLSUkt/pVJaXvq
3YxNm5+VckJOOcg+23vKwRXWRF7/IqOHygkzhRz6Hqf7HL2HInkzZJeeUePzKcqSZX34vZcNf5SV
X/9ktTY1YicoaQzbOWaxZiyzSUrKZD2EjFtNl3Iw3bDzqzVXzmrBgx+lFB5gnuo1gjAuhjXy7zO6
1y8r8rb1ZmGVJ2Hr1iHc5PiyqxTF59MfMopZUpYsi/USEq57QpalbOhilgI8j9GYNKqkKXOySrNJ
+3Z2TsANdwg5PDOkf8ROlOXspLjQVCH7seCJ32Tsm1lZ+/nXvFWnzKiwuTaxCHzEv3OV3keNyzml
tdB3W7ULCwaEbe/+URvUO+LW0Zjs2kvK0ueTgrI+wg21XJR1zeNJGyv0P/KEhHXr2PAzNKikuSoL
/nh/tdvRti1DKhfytr8C8tF7xJSKm66cpTp/7Icpe/WzjAOVCIqgmC0O0D4fwb9kpXghKFGmwA5M
X5BTWZMRyAzbYcJEFL5NQdy7SVF8Jk3L2rNC6x9OyViFnmfyTzm79IFqu//iStu8TS0uK1V+g0p6
eELKFmq3wTA5BVI+HTYNNVlBPOxT76bsMcWH+SpWwT8NpfZyloHRUPz6CsUSfMR9+v4E5KaF+F16
RmzitxkHWAnsm7YKyeXzLjOOOFyptYyUVRIZ7HPhEAIpF2WhUUXp+8Z5D3zDf1Q0aO2UGbeqKP3k
h6y1FP5ppwWtK+IK68E9sa6RjyXtzckZ+8+jEralXLKcsGFXPFxl4z7Luk1HeK7WWttHCvAXKLtG
yzhHWSUB+RcvzzvFhEN5S6a93eQG//40Y1tskiyr/fGfp13VDnpu19pb+LpSULESfGW99XXWpsyp
sr8ovgzeLviR/ndsUqRerYIwAsqfqFz+52U5m780Z122CFZyWSX9MC9XwC15O3NozFkPNEfbVmHb
tHXIcMW4zj7v4Lpm+uibKbvrpZRbwCby+w3Be+I2y1bl7dIHq+3yoxMuZhbLXS8mbczElNuwdMZs
+eqcy25t5CWPvKXd1w4CaZqtpClzs273yS6De0cdOOy8ecil1JVVKEA0xvi0ozWOGhx33wHa7nwx
ZZuopMDnN4SCnJVqoS3kgim5DJkYyHKYaBQCPYX28wr2bbVe1tqutdk5ByXs5H3iLoA//Gba8VdT
5+YEhIOdtUFLAoi1k9V0kgKQsw5M2JDto3bHCymXygnCLAD3o2qfrxjhK6ix9Lyuv2dDAYgUyfeO
S0k5AqcqT0g2rbXO5VLQvgK8lxyRsE7CXkhnudcmLbAss++lpGYF7l9+E8ATwaVQ5Ej5zQpxhYv0
2DJi95xXKQyTtEe1C2QsFkgM8zEUAXFjSi4XEjOQk8t7m5vK5BU/43bqvnURPIEe/PVbVc6tf6XI
QZRcKoGWBBLGx2W11nOrYNB2rkx2lnbq9S+zznoI6n5xu6HcLGgjCA/cP5f31v2rnuNwYapSBfEd
IaGH2M/v5uRsyW959zz9AtiKQCVN1UkpBThu4zOHQQvy/LrKpVKK0iuPTzgEjo9vLGGjgB1kVzaO
oA6PVU76dgnbi5+YQ/7fz8s2Q0kK2iiohaAQ6LacgKSp3kHGKKZju5BtVfD3jaUk7tuhrReLsKq0
XA2OvZz03jriMjEQZ4qMI0jqWRIXpehkRzpsEnYxKUjAGX9/JVmTATmG9IosFO4Y/WpKuyP4IJJ/
hrLMx6qf8nKBY0VZUA9O/jFnXVW0Hqom5OOiZOGRWOgw0bsLl+VVRkTc71cok5I5+4oLZyPYuBc/
zkgJeRF6MUvqHm99JdzWNmyn7Rd35RMbh/AMVbrm3YIk918UcZivVCicwX4LdM9p86Vc3aO0LKyn
JCpyShF02q1DqCzB/upnafthXt6Zs79PXJybXPtEtW0vsm2zNhFbVW32ph4C5N5PvyN+UcOdKMri
lUkZFyx33paMmRSU8Gqx1wRGt94s5Nxm+F5xAdeQTVH2WSXmgMD6i+IHhe6WKpHufy3tshX807WP
V9sdZ1fWeUjQ/leq0UDlQ3eq73asq4vaWfOXZvXJq+jO6bp1DaOektAmOIjg16dzsBVlFdFJ/Zhp
sZCCeejlCpbnH1ILMsdMVPZTsUxRS4HMvxSbWNqArmHbZ0DUxqrwpEUUi+ZdKieeYF1vfZ1xLOdm
giL83FKXpeD+dnbW9uwnV9G1Dtwp6jorx9+8yl2TSr/OuvSUNCWgkkP4YIn0UUiB1WTdM/T8jSoJ
v8QaWGgf+WuQfKaaDvAFF10s7CY7DSx44LWULCnk3BWFd5dZEyRZCGAvIhCGWw0sUC0AvRX6tBZu
Wa0HhaXESv/r2IS7Jt3eaiWHVcmQtZdl7bxtxKoUbKGQX9ccAdbZXi5H2s8W3M1fG+v5elbOvp6Z
FSiun6t6bx121scmTFU83rNf3WPqnfG9yhFOoKQgPQbJBJkuGa10T/xC+LqTK+xexatp8836Hxi3
3+umH32fsQ++U+yQ4vYfGLNj9oiKyAuLV8rJdcIOpKIgHhJXIk5gdX7R2nOrsMtAbXTMDJUQXAtX
GiIrZD245LUnJWo6wMXrxnjI1hMmBytpW2E/usjEP9y6VOooiZpmjkAVD99JMaG9AnepsJufT8/W
i1UeWeYdDfq+8VTdtSA9t4o4V/Jl117e/4hBvhB0fQFaIN061v5ucJ/apRLDigU6tlgIA6VYjd99
KhcnMZU2BbbiWWWFK6tz6hPmjO5PZdHMQZ270UhcIn/3QGTY7UqpTJOlEeASJR1TaAYCZC6Hrdem
XBZbC/A8AIe43xcu7teI/oPxe/e7Oleq/dmLKzrCv00BQHI5UD/gsJT2gMRjtgCg3Fvxq1gg/0hS
MxaYLRLzAfoGGvhSR0nfyx9Jw8h2ZeIR6btax/hWw7EsGaU99EbKuSG+Xaxf/4FjupsPE+qrvwm/
cbjHwz4t5GqB/It+Tab3yyX/qg4OKM4Rc0uVxDHE3/FfZN0xhJyySsIfeTgU0EvBLEiorEstDCVU
y0Qh4iZMTmvmiKrby0ZkqWWrciouo3aE6NYRo6sUV8KOZWRWwCe+MsoWBGLoFyyKGML/mUsiOLN5
KBlcQ9E9SS4PYcY1WA+NTUIBcYv+XT0zLDzMdGWvICGpcD/uS1I6fFDtUTWWlNUiAX1U/gTBrlsE
+JrOIyMxDVIqKKpDWzUJtGKCKQvmASk0+3f1evT9tBDiDUGc2aP9B0YUyFUWqMFJgN6jT8Tg1VEW
rSmY0U+FlfoJJgAuYRu4xrkHx+12kWgfi1FkuoQC9hV9N2AbXUOk26TpGbXC1Q8s6d4CDcCBQdJD
HRmyKTXcNJUnNf6ug2uUxMPDzrGLXUUhtKyorwkUuWwlOCRYgdARR+wec1iJSZKLDos7Au6CQ+IC
fULVWh/YZo++EXtBuIgimQ4KVscu7i4lgdQvVsW+XPdBiX95NGlXHpdwhSqKQhkI1nTSkJjbELIc
SzpORBps6ptfBbsum7tU1+U5SrstEHIg+yU6f642cIna7X5zoEZJ08VJQ7eCkcANQYLJ81BB3RyU
izXtKrL9pqerXasZkwclg3nIFsS8G59K2agLK13Kp76itUQXpmVl2N4Q3nlJAxd/GBq3+6TUcw+K
22ApDjrjix/Tjr/aUvUhceXmZ5M24cZWri4jBOCKYLMThND7aP2A4lKh97ZaFUBKz1EZwPv3UrKa
NN1jQCjN6imJG/tdhHIgkpqoNCj7C/H6YyF77K2UnTIkLrdMqq4yu/iwhHsAlAu7efMZFW4Wabw6
tvTPYjKBD6dmFAPCDjRSlnA8MQZ3ZbEQ/gBIyhSGIihVbjq1wj6TWx2kTsnMRRmHb7ZThUCDYM++
QvCqCEoF+2f9PEctQKk9qo/qw1Ao45IDcWm3AlSpsSQ4bSwEUMWEWZAEO1khu8n/R2sn4WTeVilB
zfbfY6ptJ2EalMLD3fNyyikS8IfbXjcmaewelvbkRC+tYlG3akALxeCqWMnIx6rdgxMvmFG6/qlq
56KgbGBLe8VCGImlK8y5Od0PlBwkWHs5ToC1UPas0nqmKov74pSESwCisAbqFkw6SMAefIJuwu8/
VkAO6yLQuMQtpp+/npVy5xBEaS8juB5lD53cNyd7P/uT0hz3gSwL7DJ7ccadhwK+m51yFoaljVNh
zBpI87gnuM6zOv0fulYWiVWWAkrOIS6VmwPYWrGYpFWlWQR6e3Bk4CunJHafgEeMoBQJohQ4zm8u
QisUiw8BLjo04Yri4sX5bKUrWbRABwN1gqMkCj/75YxPU/A933Fdnxfifmyifz4/c7wPR2qAqA4g
zj30Rrpedxd6xa8tg4yADaDGnLXIa8EDPqGrnZJwNdIui8Kvywnmjr/Shyut3PD1HXuElbrL9hbc
ZbGYoEq87E3X4AtQfSYjqy0ZSkGhTMbAd3UsoUP825C0JnyVFf7yQGWNkvz2EQCPwahSAczRTbhB
sWCBSpKgIU4WgKKLBd7nTvW88POTFcwf0iQtx1HBU/b83789V2R2COrkPOEfIABcFFNzgFpa2JRK
XIO5I7DcQSLmKB9I/28IvB4l2FE89ACgDCqpKJ4Z67ng3irHLhCocc1ioS6MRtIeI6BkdvAuBZxE
PQbO6FgIgDQesRpi1WL9i+bBUTCLmGS5wFeqXAAl59K3I+twjR4dZdICbgxbAQQpXBcIn81enHYP
xn1RChtBKgdQVijewDudIiA6+rWkG1/+TnzSFQ9Xu8GJxqZC/HWxbuLfz7+aXaJBEOIPABjMRaDn
Z5+pJPz4MCL6q0oGClZOxhKueqRawK12rI+dJq4QN3AVAjO/C9qpUiWxSwx5jlXGgXbFUgno7DTf
kd5bV5KJPOqWXt4KbQx4COXOWJi1q46v0OySF6jdwIT+gzsxZsiAPHirqULcIv2n4bPchqigFRMJ
yOU7QCZdXZIFVgc6Z44qCrjCnQBaLFQRQ8MNXnzCf1EcsKCf2DuGHsBTADisqjFFoUzmjPbYLiJ2
MeZgAYj3F6HZ84XC//p80lEz9MSwKsdOSqmUCGcPi1sbpfmFsjLGfNqLXyJxFPf6h4qR9IcfmqIo
rdraagN6qZgFWQMvkoqxXBfET5wlGaBINoK4RG0YbSUFYNrsrqMXdBDlBUrCNSC+9hkQczEEgVm8
66WkI+MbGqOht87uXCgwST22RA1PkPRv4qwY+yOjXiErwZIBbiiSeW0f3+Cem6muA7t47emws+a9
NTyGfCccwygN6/xK2Il/Owm6bB7AgXE81zhIA6Z0cNlsMh2UCk0EPow5oxg/RnEvhsdQYJSKnKJx
4jeqqqVlyClmoem37S5EXBqkYSyHaQcZLK2f47z9hJS7419J21uBFbxz29hqVzwyw43C4KhJEFTc
9ylQt5a7YfITBUKZnmNXT79jtf1jRAtHyzCEcc1JFc4CKT1YF4MOB2kd3QVZSAAs5tIjE1JSeZti
3SgIwXMYm+YD4Qfq/0b07jgBVBqb1J/UkkAGZ2RnaYc/+UFNRpnZcrkYAQxyvpzwgARVaIdiBs8/
Hm6beEEMAzLA/aAkXA2gg89T+oC8IfkPF4WCULyySSwUK31V779B3gMiEUBgRhU/6ZsOCe7AbORR
u3tFa7mJX5oDdKKxvCDhXgeqkwIuAm3jUZu01GDFMK/Ac7fnFQbiwv9oqr61yoLb9JJLJxWV5WZ9
AJtHDo7aDU+mAgtFlNNVTB9mTJG4UqbeWzw3MYRZRcyaoIhlMc1LicID0uQko1Cj8UCMHFMiEeBB
693l/qBrYmEXUTmcy9ixFzvL51zKHqZMGnrB8PUv0jbqlbSzHGLuDackXBauURL/4d0MhkdfUqzB
Om7QsPg/RoQ1/hcMLg8Wr0y9NVeDFb5L+uwAsYT+2pn7x22QTJab+TOWR6sBAOZyL+HIinCtH6QY
OPVjNFeEAs4XXqInT9uI7+HCwVytFRpOVHFLrUYWIr7AQzE8WvwCaDFLQTLapn3IzVeWExiLW8Qq
8Ny/KeaeuHfUFc6+1PEpBqDYSQDbouUqUDUoftc5FYGTrijmD+rOglX86Q1/moTgh9J92aGbV0Ig
3viw938ebC91Rvbq7/3cviieEPT991BoJJTKcMUu/xpgG8Qva4qnWsB6jAqWK3hxRZqadEoIbAM1
4Vs6P1lHSZBXtGXOvpshCArNrFpDKbtQNVmQ4Me8N0vQx6/v0gDXA+qowg9tLAHHrRItw7PgNrv1
CjvauJzcLhjy1Uz1EHV8IpZ3CaKU0awXndm1y49JuIFNXObhCWmX/YZsH3wjdumbWasd3QEozagi
LUepbAjFsT3RwiA+MOIyeQfFcpC4d/HEO7HBWBwG0lUJp1QCUxj10reqpMdM9BqAvFNGoRc0U0iW
uUoDnZc/mHRZrHItXnRZV0rE7cBz1wxPKKsFZzQ6tX/V/AHNBDDU6fvFNA4YbAhl8/wIBUVAHu1h
gh9DEKPOrwx8dWHv/jHx0nm7XTdlNrEJw/rrSh/1roMlLRMOO0Pz3fDtQYIbXqvXJ8BpzDUM6h22
C8qEFM4vqyTS5bXyzzP/VuUAHd2HOwUQ/3Rs8Pw2lC03H/1q2rXI/SbketNGwIUJhRB0x/wuamxy
OSGTUdSTzdoKD109nORUfqUNVocMXl5xfNz+XHiB+Cm9bNeva9oVrUHCuDLA717hDZhC10PbQFoi
o9FROWGvqF1xXPlBfF4iZOSHOEQ7e+SJFfWmSJoUk4oP2lcB+7T9cm4cmdR+m/pd1FM9S1rF/jln
DU24GQKyBmmVc9anosBVNBngfy46NO7qw3ICPw7P7qZxpdALDo25Pl1j0vgRugJkGNU/SBizvEb+
fP9FlS6oBwllBkgZRVFpl6ODG1tcU76n7IEH+6PqNqZXysmylbzGpTpGQiYbonFlyrGmSJOURCPv
amWKM++sqpl5xqKIWeWEUofvT7tzdU2rqikLas4xfgvsVrWpti2TxbgesYoKAlYSToopOl6xqD88
FHz3JimJUztoNGWkFHXJ6GpX30CV9O2SEvVafjcoOv2pEq4BuiWjYI0g9uYEdxRCjYZbEes4Hzsm
kwYV2cWP++B4XtLxAC+EG9DAf+elKZvSZCVxsd1Fw549LGZ3v6xuqhQFwqaah5MOEmJSRkqJ6i4U
sdRt/WVhTKbRfCAuOGvQ6SjMQQfXDvFKDL7zOykMb3Ef3vHF9X0+K6WHbmi6ljbXA4qnZFzqssuO
joumadZjN/+v3px5QEL8Mg1Ir/jEzx8cUenwUamMUSaB+UuK3jhNYI3yBmUcqYKV3hw4DHIOjmnp
Si9WwCtxDMQ/9AoDYcQ3NoNsi3i9taQ9KWYAS4UhuHp4/Y1iSJT6E8oYRUK6nVQYEGuKBfnHNE+l
hbMYap+xsMoR6rwJyUsvt55Rt3HMy8K0ZlAkQ6HnqK9f7F7Me/PhbyT5gvXAGEKINQRIuc45oncn
iIrBGuGdjh6ctf5FFo0iAcCL1D+DH4ISpkOyJrJGSsKfrxEAozVDhntdw0//7Jyy00WNIIzC3KMW
NQ8KLQw16zMFDS2S48NlJlZKz2OodU9Np4z9IOOU/zdRyqMuqKxhLJjZ/GhqzsUh2AbqMlL/msga
KYkbMT90oXAJf9+IhYzSm0EMQvGu6z818UZlTatmpRbIoOj6EK7LO7ls1KRpOXtclO6pomLfUfv8
Eb0cRBxaIU4dwFj6t1Gas561Wj2cDmS6o12VbW4V3B85nP68htvJJIpHDKQ39w8pNPUBBoiYg4Bb
rhYYGZfX8geI4WTAi7KKwhUijxi4NrJWSuLGf5afE3yZGoGou1IkHK8qwEezyEHKiOvrr2exEdC8
L2tTsGbeW7tS79nCUwMV+quheamonLWVtVYSjN91Ao1n31PlenaQ827yREEY4EZWopj0mlTrVpgp
4J2T8QrcbhjXlSjeNEmLhBeHmvJKfGOrWmslcQMmVS/Tjl0tkp+5IYSaChf8u9o9BPL1JbiVN7rj
QSzuu0rp/qZTIfKD8Vtz17JOlMRNIdppyTAbyTA5O8iCGZ1pKvxv7uI5Hq7LjelISRS63O9CFa6l
A/Brcm3/nHWmJC7ISzfECAIoL7LAkzfWCl+bxfvnundh9CTMZ9NZWdM/KlNuLf8Pk3GR8T4aG6kA
AAAASUVORK5CYII=

--_007_BEZP281MB2102B46608D0ECC718BF6568D2B52BEZP281MB2102DEUP_
Content-Type: image/png; name="image004.png"
Content-Description: image004.png
Content-Disposition: inline; filename="image004.png"; size=3073;
	creation-date="Fri, 04 Sep 2026 06:33:57 GMT";
	modification-date="Fri, 04 Sep 2026 06:33:57 GMT"
Content-ID: <image004.png@01D9D4D4.4DF69060>
Content-Transfer-Encoding: base64

iVBORw0KGgoAAAANSUhEUgAAAEkAAAArCAYAAAA0T6WNAAAAGXRFWHRTb2Z0d2FyZQBBZG9iZSBJ
bWFnZVJlYWR5ccllPAAAAyhpVFh0WE1MOmNvbS5hZG9iZS54bXAAAAAAADw/eHBhY2tldCBiZWdp
bj0i77u/IiBpZD0iVzVNME1wQ2VoaUh6cmVTek5UY3prYzlkIj8+IDx4OnhtcG1ldGEgeG1sbnM6
eD0iYWRvYmU6bnM6bWV0YS8iIHg6eG1wdGs9IkFkb2JlIFhNUCBDb3JlIDUuNi1jMDY3IDc5LjE1
Nzc0NywgMjAxNS8wMy8zMC0yMzo0MDo0MiAgICAgICAgIj4gPHJkZjpSREYgeG1sbnM6cmRmPSJo
dHRwOi8vd3d3LnczLm9yZy8xOTk5LzAyLzIyLXJkZi1zeW50YXgtbnMjIj4gPHJkZjpEZXNjcmlw
dGlvbiByZGY6YWJvdXQ9IiIgeG1sbnM6eG1wPSJodHRwOi8vbnMuYWRvYmUuY29tL3hhcC8xLjAv
IiB4bWxuczp4bXBNTT0iaHR0cDovL25zLmFkb2JlLmNvbS94YXAvMS4wL21tLyIgeG1sbnM6c3RS
ZWY9Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC9zVHlwZS9SZXNvdXJjZVJlZiMiIHhtcDpD
cmVhdG9yVG9vbD0iQWRvYmUgUGhvdG9zaG9wIENDIDIwMTUgKE1hY2ludG9zaCkiIHhtcE1NOklu
c3RhbmNlSUQ9InhtcC5paWQ6NEVDNjI3Rjk4Q0U4MTFFNzg4OENBMzVDRjZFM0ZEQzYiIHhtcE1N
OkRvY3VtZW50SUQ9InhtcC5kaWQ6NEVDNjI3RkE4Q0U4MTFFNzg4OENBMzVDRjZFM0ZEQzYiPiA8
eG1wTU06RGVyaXZlZEZyb20gc3RSZWY6aW5zdGFuY2VJRD0ieG1wLmlpZDo0RUM2MjdGNzhDRTgx
MUU3ODg4Q0EzNUNGNkUzRkRDNiIgc3RSZWY6ZG9jdW1lbnRJRD0ieG1wLmRpZDo0RUM2MjdGODhD
RTgxMUU3ODg4Q0EzNUNGNkUzRkRDNiIvPiA8L3JkZjpEZXNjcmlwdGlvbj4gPC9yZGY6UkRGPiA8
L3g6eG1wbWV0YT4gPD94cGFja2V0IGVuZD0iciI/Plj3kGsAAAheSURBVHja7FoLkE9VGL//tR67
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

--_007_BEZP281MB2102B46608D0ECC718BF6568D2B52BEZP281MB2102DEUP_--


