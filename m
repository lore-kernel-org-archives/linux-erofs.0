Return-Path: <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 38CC6ECAAD3
	for <linux-erofs@archiver.kernel.org>; Thu, 15 Sep 2022 03:30:06 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [IPv6:::1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4MSjPn3ZkXz3bcv
	for <linux-erofs@archiver.kernel.org>; Thu, 15 Sep 2022 13:30:05 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=linux.alibaba.com (client-ip=47.90.199.8; helo=out199-8.us.a.mail.aliyun.com; envelope-from=jefflexu@linux.alibaba.com; receiver=<UNKNOWN>)
Received: from out199-8.us.a.mail.aliyun.com (out199-8.us.a.mail.aliyun.com [47.90.199.8])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4MSjPg4Qk2z30DP
	for <linux-erofs@lists.ozlabs.org>; Thu, 15 Sep 2022 13:29:59 +1000 (AEST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R111e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046051;MF=jefflexu@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0VPqzoJh_1663212590;
Received: from 30.221.129.91(mailfrom:jefflexu@linux.alibaba.com fp:SMTPD_---0VPqzoJh_1663212590)
          by smtp.aliyun-inc.com;
          Thu, 15 Sep 2022 11:29:52 +0800
Message-ID: <a986a33a-b03f-0a36-fad7-9c2afe3f2a48@linux.alibaba.com>
Date: Thu, 15 Sep 2022 11:29:50 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.13.0
Subject: Re: [PATCH V3 4/6] erofs: introduce fscache-based domain
Content-Language: en-US
To: Jia Zhu <zhujia.zj@bytedance.com>, linux-erofs@lists.ozlabs.org,
 xiang@kernel.org, chao@kernel.org, linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org, yinxin.x@bytedance.com, huyue2@coolpad.com
References: <20220914105041.42970-1-zhujia.zj@bytedance.com>
 <20220914105041.42970-5-zhujia.zj@bytedance.com>
 <YyHVQGftl/0Bf4kW@B-P7TQMD6M-0146.lan>
From: JeffleXu <jefflexu@linux.alibaba.com>
In-Reply-To: <YyHVQGftl/0Bf4kW@B-P7TQMD6M-0146.lan>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
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
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs" <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>



On 9/14/22 9:21 PM, Gao Xiang wrote:
>> @@ -518,7 +614,13 @@ void erofs_fscache_unregister_fs(struct super_block *sb)
>>  	struct erofs_sb_info *sbi = EROFS_SB(sb);
>>  
>>  	erofs_fscache_unregister_cookie(sbi->s_fscache);
>> -	fscache_relinquish_volume(sbi->volume, NULL, false);
>>  	sbi->s_fscache = NULL;
>> +
>> +	if (sbi->domain)
>> +		erofs_fscache_domain_put(sbi->domain);
>> +	else
>> +		fscache_relinquish_volume(sbi->volume, NULL, false);
>> +
> 
> How about using one helper and pass in sb directly instead?
> 

Then this helper has only one caller...


-- 
Thanks,
Jingbo
