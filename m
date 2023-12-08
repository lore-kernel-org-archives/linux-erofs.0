Return-Path: <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4A3EFC4167B
	for <linux-erofs@archiver.kernel.org>; Fri,  8 Dec 2023 07:44:55 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [IPv6:::1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4SmjpY68gRz3dBg
	for <linux-erofs@archiver.kernel.org>; Fri,  8 Dec 2023 18:44:53 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=linux.alibaba.com (client-ip=115.124.30.99; helo=out30-99.freemail.mail.aliyun.com; envelope-from=hsiangkao@linux.alibaba.com; receiver=lists.ozlabs.org)
Received: from out30-99.freemail.mail.aliyun.com (out30-99.freemail.mail.aliyun.com [115.124.30.99])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4SmjpR1fFFz3cVg
	for <linux-erofs@lists.ozlabs.org>; Fri,  8 Dec 2023 18:44:43 +1100 (AEDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R151e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045176;MF=hsiangkao@linux.alibaba.com;NM=1;PH=DS;RN=5;SR=0;TI=SMTPD_---0Vy2OseO_1702021475;
Received: from 30.25.236.68(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0Vy2OseO_1702021475)
          by smtp.aliyun-inc.com;
          Fri, 08 Dec 2023 15:44:37 +0800
Message-ID: <8bdc5203-2356-4a7a-8f26-39fa4b2e2a46@linux.alibaba.com>
Date: Fri, 8 Dec 2023 15:44:33 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/5] erofs: refine z_erofs_transform_plain() for sub-page
 block support
From: Gao Xiang <hsiangkao@linux.alibaba.com>
To: Yue Hu <zbestahu@gmail.com>
References: <20231206091057.87027-1-hsiangkao@linux.alibaba.com>
 <20231206091057.87027-5-hsiangkao@linux.alibaba.com>
 <20231208132031.00003b8d.zbestahu@gmail.com>
 <9ced71c9-4460-4907-abb9-21b517a883c7@linux.alibaba.com>
In-Reply-To: <9ced71c9-4460-4907-abb9-21b517a883c7@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
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
Cc: huyue2@coolpad.com, linux-erofs@lists.ozlabs.org, LKML <linux-kernel@vger.kernel.org>, zhangwen@coolpad.com
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs" <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>



On 2023/12/8 15:34, Gao Xiang wrote:
> 
> 

...

>> min_t(unsigned int, ,)?
>>
>> ../include/linux/minmax.h:21:28: error: comparison of distinct pointer types lacks a cast [-Werror]
>>    (!!(sizeof((typeof(x) *)1 == (typeof(y) *)1)))
> 
> What compiler version are you using? I didn't find any error
> and
> https://lore.kernel.org/linux-erofs/202312080122.iCCXzSuE-lkp@intel.com
> 
> also didn't report this.

Did you test against the latest kernel codebase?

> 
> Thanks,
> Gao Xiang
