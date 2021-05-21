Return-Path: <SRS0=oztu=KQ=lists.ozlabs.org=linux-erofs-bounces+linux-erofs=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BDC92C433ED
	for <linux-erofs@archiver.kernel.org>; Fri, 21 May 2021 01:15:17 +0000 (UTC)
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 4987361355
	for <linux-erofs@archiver.kernel.org>; Fri, 21 May 2021 01:15:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4987361355
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Received: from boromir.ozlabs.org (localhost [IPv6:::1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4FmTDg6vGwz300S
	for <linux-erofs@archiver.kernel.org>; Fri, 21 May 2021 11:15:15 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized)
 smtp.mailfrom=huawei.com (client-ip=45.249.212.32; helo=szxga06-in.huawei.com;
 envelope-from=yuchao0@huawei.com; receiver=<UNKNOWN>)
Received: from szxga06-in.huawei.com (szxga06-in.huawei.com [45.249.212.32])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by lists.ozlabs.org (Postfix) with ESMTPS id 4FmTDZ39bKz2yWw
 for <linux-erofs@lists.ozlabs.org>; Fri, 21 May 2021 11:15:07 +1000 (AEST)
Received: from dggems701-chm.china.huawei.com (unknown [172.30.72.59])
 by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4FmT9k1rJDzmWpV;
 Fri, 21 May 2021 09:12:42 +0800 (CST)
Received: from dggemx753-chm.china.huawei.com (10.0.44.37) by
 dggems701-chm.china.huawei.com (10.3.19.178) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Fri, 21 May 2021 09:14:59 +0800
Received: from [10.136.110.154] (10.136.110.154) by
 dggemx753-chm.china.huawei.com (10.0.44.37) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Fri, 21 May 2021 09:14:58 +0800
Subject: Re: [PATCH -next] erofs: fix error return code in
 erofs_read_superblock()
To: Gao Xiang <xiang@kernel.org>, Dan Carpenter <dan.carpenter@oracle.com>,
 Wei Yongjun <weiyongjun1@huawei.com>
References: <20210519141657.3062715-1-weiyongjun1@huawei.com>
 <20210520053226.GB1955@kadam>
 <20210520084023.GA5720@hsiangkao-HP-ZHAN-66-Pro-G1>
From: Chao Yu <yuchao0@huawei.com>
Message-ID: <9f96b12f-b05b-c118-4391-448f780702ff@huawei.com>
Date: Fri, 21 May 2021 09:14:58 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20210520084023.GA5720@hsiangkao-HP-ZHAN-66-Pro-G1>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.136.110.154]
X-ClientProxiedBy: dggemx704-chm.china.huawei.com (10.1.199.51) To
 dggemx753-chm.china.huawei.com (10.0.44.37)
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
Cc: Hulk Robot <hulkci@huawei.com>, linux-erofs@lists.ozlabs.org,
 kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs"
 <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>

On 2021/5/20 16:40, Gao Xiang wrote:
> Hi Yongjun and Dan,
> 
> On Thu, May 20, 2021 at 08:32:26AM +0300, Dan Carpenter wrote:
>> On Wed, May 19, 2021 at 02:16:57PM +0000, Wei Yongjun wrote:
>>> 'ret' will be overwritten to 0 if erofs_sb_has_sb_chksum() return true,
>>> thus 0 will return in some error handling cases. Fix to return negative
>>> error code -EINVAL instead of 0.
>>>
>>> Reported-by: Hulk Robot <hulkci@huawei.com>
>>> Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
>>
>> You need to add Fixes tags to bug fix patches and you need to ensure
>> that the authors of the Fixes commit are CC'd so they can review your
>> fix.  get_maintainer.pl will add the author automatically, but normally
>> I like to put them in the To header to make sure they see it.
>>
>> Fixes: b858a4844cfb ("erofs: support superblock checksum")
> 
> The commit and the tag look good to me (sorry for a bit delay on this),
> 
> Fixes: b858a4844cfb ("erofs: support superblock checksum")
> Cc: stable <stable@vger.kernel.org> # 5.5+
> Reviewed-by: Gao Xiang <xiang@kernel.org>

Reviewed-by: Chao Yu <yuchao0@huawei.com>

Thanks,

> 
> (will apply to dev-test for a while and then to -next.)
> 
> Thanks,
> Gao Xiang
> 
> .
> 
