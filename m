Return-Path: <SRS0=r8Mz=W5=lists.ozlabs.org=linux-erofs-bounces+linux-erofs=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52D40C41514
	for <linux-erofs@archiver.kernel.org>; Mon,  2 Sep 2019 13:47:59 +0000 (UTC)
Received: from lists.ozlabs.org (lists.ozlabs.org [203.11.71.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id DAC07216C8
	for <linux-erofs@archiver.kernel.org>; Mon,  2 Sep 2019 13:47:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DAC07216C8
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Received: from bilbo.ozlabs.org (lists.ozlabs.org [IPv6:2401:3900:2:1::3])
	by lists.ozlabs.org (Postfix) with ESMTP id 46MWcX3RZ8zDqg7
	for <linux-erofs@archiver.kernel.org>; Mon,  2 Sep 2019 23:47:56 +1000 (AEST)
Authentication-Results: lists.ozlabs.org;
 spf=pass (mailfrom) smtp.mailfrom=huawei.com
 (client-ip=45.249.212.188; helo=huawei.com;
 envelope-from=gaoxiang25@huawei.com; receiver=<UNKNOWN>)
Authentication-Results: lists.ozlabs.org;
 dmarc=none (p=none dis=none) header.from=huawei.com
Received: from huawei.com (szxga02-in.huawei.com [45.249.212.188])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by lists.ozlabs.org (Postfix) with ESMTPS id 46MWQd5KG2zDqXX
 for <linux-erofs@lists.ozlabs.org>; Mon,  2 Sep 2019 23:39:20 +1000 (AEST)
Received: from DGGEMM405-HUB.china.huawei.com (unknown [172.30.72.56])
 by Forcepoint Email with ESMTP id 98EC5C1E173A35FF01AC;
 Mon,  2 Sep 2019 21:39:18 +0800 (CST)
Received: from dggeme762-chm.china.huawei.com (10.3.19.108) by
 DGGEMM405-HUB.china.huawei.com (10.3.20.213) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Mon, 2 Sep 2019 21:39:18 +0800
Received: from architecture4 (10.140.130.215) by
 dggeme762-chm.china.huawei.com (10.3.19.108) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1591.10; Mon, 2 Sep 2019 21:39:17 +0800
Date: Mon, 2 Sep 2019 21:38:26 +0800
From: Gao Xiang <gaoxiang25@huawei.com>
To: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 16/21] erofs: kill magic underscores
Message-ID: <20190902133826.GB63268@architecture4>
References: <20190802125347.166018-1-gaoxiang25@huawei.com>
 <20190901055130.30572-1-hsiangkao@aol.com>
 <20190901055130.30572-17-hsiangkao@aol.com>
 <20190902122627.GN15931@infradead.org>
 <20190902123937.GA17916@architecture4>
 <20190902125438.GA17750@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20190902125438.GA17750@infradead.org>
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
Cc: devel@driverdev.osuosl.org, Greg
 Kroah-Hartman <gregkh@linuxfoundation.org>, linux-fsdevel@vger.kernel.org,
 linux-erofs@lists.ozlabs.org
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs"
 <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>

Hi Christoph,

On Mon, Sep 02, 2019 at 05:54:38AM -0700, Christoph Hellwig wrote:
> On Mon, Sep 02, 2019 at 08:39:37PM +0800, Gao Xiang wrote:
> > > 
> > > > +	if (erofs_inode_version(advise) == EROFS_INODE_LAYOUT_V2) {
> > > 
> > > I still need to wade through the old thread - but didn't you say this
> > > wasn't really a new vs old version but a compat vs full inode?  Maybe
> > > the names aren't that suitable either?
> > 
> > Could you kindly give some suggestions for better naming about it?
> > there are all supported by EROFS... (Actually we only mainly use v1...)
> 
> Maybe EROFS_INODE_LAYOUT_COMPACT and EROFS_INODE_LAYOUT_EXTENDED?

Okay, that is fine.

Thanks,
Gao Xiang

