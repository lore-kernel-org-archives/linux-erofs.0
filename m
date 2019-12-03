Return-Path: <SRS0=6HAz=ZZ=lists.ozlabs.org=linux-erofs-bounces+linux-erofs=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3C03C432C0
	for <linux-erofs@archiver.kernel.org>; Tue,  3 Dec 2019 01:47:55 +0000 (UTC)
Received: from lists.ozlabs.org (lists.ozlabs.org [203.11.71.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id A0424206ED
	for <linux-erofs@archiver.kernel.org>; Tue,  3 Dec 2019 01:47:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A0424206ED
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Received: from lists.ozlabs.org (lists.ozlabs.org [IPv6:2401:3900:2:1::3])
	by lists.ozlabs.org (Postfix) with ESMTP id 47RlHF0lygzDqN7
	for <linux-erofs@archiver.kernel.org>; Tue,  3 Dec 2019 12:47:53 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized)
 smtp.mailfrom=huawei.com (client-ip=45.249.212.189; helo=huawei.com;
 envelope-from=gaoxiang25@huawei.com; receiver=<UNKNOWN>)
Authentication-Results: lists.ozlabs.org;
 dmarc=none (p=none dis=none) header.from=huawei.com
Received: from huawei.com (szxga03-in.huawei.com [45.249.212.189])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by lists.ozlabs.org (Postfix) with ESMTPS id 47RlGx2zRGzDqM2
 for <linux-erofs@lists.ozlabs.org>; Tue,  3 Dec 2019 12:47:33 +1100 (AEDT)
Received: from DGGEMM403-HUB.china.huawei.com (unknown [172.30.72.55])
 by Forcepoint Email with ESMTP id 9EB5E4E9EF8FF711A278;
 Tue,  3 Dec 2019 09:47:22 +0800 (CST)
Received: from dggeme762-chm.china.huawei.com (10.3.19.108) by
 DGGEMM403-HUB.china.huawei.com (10.3.20.211) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Tue, 3 Dec 2019 09:47:21 +0800
Received: from architecture4 (10.160.196.180) by
 dggeme762-chm.china.huawei.com (10.3.19.108) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1713.5; Tue, 3 Dec 2019 09:47:21 +0800
Date: Tue, 3 Dec 2019 09:52:41 +0800
From: Gao Xiang <gaoxiang25@huawei.com>
To: Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH] erofs: zero out when listxattr is called with no xattr
Message-ID: <20191203015238.GA210859@architecture4>
References: <20191201084040.29275-1-hsiangkao@aol.com>
 <20191202221312.8F590206F0@mail.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20191202221312.8F590206F0@mail.kernel.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Originating-IP: [10.160.196.180]
X-ClientProxiedBy: dggeme703-chm.china.huawei.com (10.1.199.99) To
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
Cc: Miao Xie <miaoxie@huawei.com>, LKML <linux-kernel@vger.kernel.org>,
 stable@vger.kernel.org, linux-erofs@lists.ozlabs.org
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs"
 <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>

Hi Sasha,

On Mon, Dec 02, 2019 at 10:13:11PM +0000, Sasha Levin wrote:
> Hi,
> 
> [This is an automated email]
> 
> This commit has been processed because it contains a "Fixes:" tag,
> fixing commit: cadf1ccf1b00 ("staging: erofs: add error handling for xattr submodule").
> 
> The bot has tested the following trees: v5.4.1, v5.3.14, v4.19.87.
> 
> v5.4.1: Build OK!
> v5.3.14: Failed to apply! Possible dependencies:
>     Unable to calculate
> 
> v4.19.87: Failed to apply! Possible dependencies:
>     Unable to calculate

Because of file movement, I'll backport manually then.

Thanks,
Gao Xiang

> 
> 
> NOTE: The patch will not be queued to stable trees until it is upstream.
> 
> How should we proceed with this patch?
> 
> -- 
> Thanks,
> Sasha
