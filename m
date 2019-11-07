Return-Path: <SRS0=nlye=Y7=lists.ozlabs.org=linux-erofs-bounces+linux-erofs=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=0.9 required=3.0 tests=CHARSET_FARAWAY_HEADER,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E43EC5DF61
	for <linux-erofs@archiver.kernel.org>; Thu,  7 Nov 2019 08:54:38 +0000 (UTC)
Received: from lists.ozlabs.org (lists.ozlabs.org [203.11.71.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id EB1BB2077C
	for <linux-erofs@archiver.kernel.org>; Thu,  7 Nov 2019 08:54:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org EB1BB2077C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Received: from bilbo.ozlabs.org (lists.ozlabs.org [IPv6:2401:3900:2:1::3])
	by lists.ozlabs.org (Postfix) with ESMTP id 477xzc0SJVzF6G5
	for <linux-erofs@archiver.kernel.org>; Thu,  7 Nov 2019 19:54:36 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized)
 smtp.mailfrom=huawei.com (client-ip=45.249.212.255; helo=huawei.com;
 envelope-from=gaoxiang25@huawei.com; receiver=<UNKNOWN>)
Authentication-Results: lists.ozlabs.org;
 dmarc=none (p=none dis=none) header.from=huawei.com
Received: from huawei.com (szxga08-in.huawei.com [45.249.212.255])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by lists.ozlabs.org (Postfix) with ESMTPS id 477xzV5K3ZzF68K
 for <linux-erofs@lists.ozlabs.org>; Thu,  7 Nov 2019 19:54:28 +1100 (AEDT)
Received: from DGGEMM401-HUB.china.huawei.com (unknown [172.30.72.54])
 by Forcepoint Email with ESMTP id 8706A3FC484886DFA756
 for <linux-erofs@lists.ozlabs.org>; Thu,  7 Nov 2019 16:54:23 +0800 (CST)
Received: from dggeme762-chm.china.huawei.com (10.3.19.108) by
 DGGEMM401-HUB.china.huawei.com (10.3.20.209) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Thu, 7 Nov 2019 16:54:23 +0800
Received: from architecture4 (10.140.130.215) by
 dggeme762-chm.china.huawei.com (10.3.19.108) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1713.5; Thu, 7 Nov 2019 16:54:22 +0800
Date: Thu, 7 Nov 2019 16:57:00 +0800
From: Gao Xiang <gaoxiang25@huawei.com>
To: "liguifu (C)" <bluce.liguifu@huawei.com>, "Yuchao (T)" <yuchao0@huawei.com>
Subject: Re: =?gbk?B?s7e72A==?= =?gbk?Q?=3A?= [PATCH 2/2] erofs-utils:
 support 128-bit filesystem UUID
Message-ID: <20191107085700.GA169529@architecture4>
References: <84997c2a3a2f4ac8bae1995bb4c4012c@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="gbk"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <84997c2a3a2f4ac8bae1995bb4c4012c@huawei.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Originating-IP: [10.140.130.215]
X-ClientProxiedBy: dggeme719-chm.china.huawei.com (10.1.199.115) To
 dggeme762-chm.china.huawei.com (10.3.19.108)
X-CFilter-Loop: Reflected
X-BeenThere: linux-erofs@lists.ozlabs.org
X-Mailman-Version: 2.1.29
Precedence: list
List-Id: Development of Linux EROFS file system <linux-erofs.lists.ozlabs.org>
List-Unsubscribe: <https://lists.ozlabs.org/options/linux-erofs>,
 <mailto:linux-erofs-request@lists.ozlabs.org?subject=unsubscribe>
List-Archive: <http://lists.ozlabs.org/pipermail/linux-erofs/>
List-Post: <mailto:linux-erofs@lists.ozlabs.org>
List-Help: <mailto:linux-erofs-request@lists.ozlabs.org?subject=help>
List-Subscribe: <https://lists.ozlabs.org/listinfo/linux-erofs>,
 <mailto:linux-erofs-request@lists.ozlabs.org?subject=subscribe>
Cc: "linux-erofs@lists.ozlabs.org" <linux-erofs@lists.ozlabs.org>,
 "miaoxie \(A\)" <miaoxie@huawei.com>
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs"
 <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>

On Thu, Nov 07, 2019 at 07:22:20AM +0000, Gaoxiang (xiang, OS Lab) wrote:
> Gaoxiang (xiang, OS Lab) ½«³·»ØÓÊ¼þ¡°[PATCH 2/2] erofs-utils: support 128-bit filesystem UUID¡±¡£

Oops, it seems our mailing server went wrong since no mail
sent out successfully hours later.

Please ignore this email. :(

Thanks,
Gao Xiang

