Return-Path: <SRS0=sOyE=FN=lists.ozlabs.org=linux-erofs-bounces+linux-erofs=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4B4FC433FE
	for <linux-erofs@archiver.kernel.org>; Wed,  9 Dec 2020 02:56:38 +0000 (UTC)
Received: from lists.ozlabs.org (lists.ozlabs.org [203.11.71.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 30F442388B
	for <linux-erofs@archiver.kernel.org>; Wed,  9 Dec 2020 02:56:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 30F442388B
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Received: from bilbo.ozlabs.org (lists.ozlabs.org [IPv6:2401:3900:2:1::3])
	by lists.ozlabs.org (Postfix) with ESMTP id 4CrMBr2lFmzDqlJ
	for <linux-erofs@archiver.kernel.org>; Wed,  9 Dec 2020 13:56:36 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized)
 smtp.mailfrom=huawei.com (client-ip=45.249.212.35; helo=szxga07-in.huawei.com;
 envelope-from=yuchao0@huawei.com; receiver=<UNKNOWN>)
Authentication-Results: lists.ozlabs.org;
 dmarc=none (p=none dis=none) header.from=huawei.com
Received: from szxga07-in.huawei.com (szxga07-in.huawei.com [45.249.212.35])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by lists.ozlabs.org (Postfix) with ESMTPS id 4CrMBk2HKYzDqgp
 for <linux-erofs@lists.ozlabs.org>; Wed,  9 Dec 2020 13:56:29 +1100 (AEDT)
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.58])
 by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4CrM9z2SZLz7BgZ;
 Wed,  9 Dec 2020 10:55:51 +0800 (CST)
Received: from [10.136.114.67] (10.136.114.67) by smtp.huawei.com
 (10.3.19.213) with Microsoft SMTP Server (TLS) id 14.3.487.0; Wed, 9 Dec 2020
 10:56:20 +0800
Subject: Re: [PATCH v3] erofs: avoiding using generic_block_bmap
To: Gao Xiang <hsiangkao@redhat.com>, Huang Jianan <huangjianan@oppo.com>
References: <20201208131108.7607-1-huangjianan@oppo.com>
 <c71fe6a9-06ba-3871-6e0b-104f58df1df7@oppo.com>
 <20201209024415.GA33948@xiangao.remote.csb>
From: Chao Yu <yuchao0@huawei.com>
Message-ID: <fd9d991d-c048-500f-ca52-f186c42974b1@huawei.com>
Date: Wed, 9 Dec 2020 10:56:20 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20201209024415.GA33948@xiangao.remote.csb>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.136.114.67]
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
Cc: guoweichao@oppo.com, linux-erofs@lists.ozlabs.org, zhangshiming@oppo.com,
 linux-kernel@vger.kernel.org
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs"
 <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>

On 2020/12/9 10:44, Gao Xiang wrote:
> Hi Jianan and Chao,
> 
> On Wed, Dec 09, 2020 at 10:34:54AM +0800, Huang Jianan wrote:
>>
>> 在 2020/12/8 21:11, Huang Jianan 写道:
> 
> ...
> 
>>> -
>>>    static sector_t erofs_bmap(struct address_space *mapping, sector_t block)
>>>    {
>>>    	struct inode *inode = mapping->host;
>>> +	struct erofs_map_blocks map = {
>>> +		.m_la = blknr_to_addr(iblock),
>>
>> Sorry for my mistake, it should be:
>>
>> .m_la = blknr_to_addr(block),
>>
> 
> Sigh, since my ro_fsstress doesn't cover bmap interface... I mean do we need
> to add some testcase for this? (But it needs to be fixed anyway, plus this patch
> looks good to me....)
> 
> Hi Chao,
> could you kindly leave some free slot for this patch and
> 
> erofs: force inplace I/O under low memory scenario
> https://lore.kernel.org/r/20201208054600.16302-1-hsiangkao@aol.com

Will review soon. :)

Thanks,

> 
> Since I'd like to merge these all for 5.11-rc1 (so we could have more time to
> test until the next LTS version), since 5.10 is a LTS version, I tend to not
> introduce any big modification (so in the past months, "erofs: force inplace
> I/O under low memory scenario" never upstreamed at all.)
> 
> Thanks,
> Gao Xiang
> 
> 
> .
> 
