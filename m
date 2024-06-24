Return-Path: <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A9959C2BD09
	for <linux-erofs@archiver.kernel.org>; Mon, 24 Jun 2024 11:59:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=lists.ozlabs.org;
	s=201707; t=1719230393;
	bh=61z+3dCgpcfqej7gnKm5yhX9dUg+psvG2gkVra1l5uI=;
	h=Date:Subject:To:References:In-Reply-To:List-Id:List-Unsubscribe:
	 List-Archive:List-Post:List-Help:List-Subscribe:From:Reply-To:Cc:
	 From;
	b=PKMC9ouQeG+ubaHr44/hgiripjwOPh6Wxw5BA49+1n++Se16hRSXyVVejIcp7OHdu
	 F8AeAiGiskZquwXP6l4tyLlhd5+sXJBGig876lRXhmRo59KcjPNhtL6kpPaLjZOdrs
	 AmY72H55M4v05uHoJ/a/Y0WINghZ3drWc/ywQoRAMMTQh4wIVObBUdamDfhRGauHb2
	 bM49164h0hArVU3rjHC9NIUb2uRkNijf3D/T8yuuYzzZ6WAy95aSx0V8SZxfLhOMPW
	 eIOkvO4f7cy0RGj1PYNHloleOyuBaL62DYmqJma79cJ3Ih46PwwQr1gwgxc3ylYK7e
	 kuWxwyA5OM0Xg==
Received: from boromir.ozlabs.org (localhost [IPv6:::1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4W762x1fYrz3cVG
	for <linux-erofs@archiver.kernel.org>; Mon, 24 Jun 2024 21:59:53 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=huawei.com (client-ip=45.249.212.187; helo=szxga01-in.huawei.com; envelope-from=lihongbo22@huawei.com; receiver=lists.ozlabs.org)
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4W762f32qsz3cRs
	for <linux-erofs@lists.ozlabs.org>; Mon, 24 Jun 2024 21:59:35 +1000 (AEST)
Received: from mail.maildlp.com (unknown [172.19.163.174])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4W75wv04jxzZcGG;
	Mon, 24 Jun 2024 19:54:39 +0800 (CST)
Received: from dggpeml500022.china.huawei.com (unknown [7.185.36.66])
	by mail.maildlp.com (Postfix) with ESMTPS id B2CDB1400D6;
	Mon, 24 Jun 2024 19:59:00 +0800 (CST)
Received: from [10.67.111.104] (10.67.111.104) by
 dggpeml500022.china.huawei.com (7.185.36.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Mon, 24 Jun 2024 19:59:00 +0800
Message-ID: <3f542dc9-2686-43af-a915-2bfede803771@huawei.com>
Date: Mon, 24 Jun 2024 19:58:59 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] cachefiles: support query cachefiles ondemand feature
To: Gao Xiang <hsiangkao@linux.alibaba.com>, <xiang@kernel.org>,
	<chao@kernel.org>, <huyue2@coolpad.com>, <jefflexu@linux.alibaba.com>,
	<dhavale@google.com>, <dhowells@redhat.com>
References: <20240621061808.1585253-1-lihongbo22@huawei.com>
 <20240621061808.1585253-3-lihongbo22@huawei.com>
 <c4748d68-b61f-4935-815b-f4d3af77f890@linux.alibaba.com>
 <1fe0f4e5-37b0-4bbd-bcd3-9764f65660e8@huawei.com>
 <f148e340-26c5-44ce-887f-076c2c76137c@linux.alibaba.com>
 <88888ec4-1e45-477a-8084-2c122c0bfda2@linux.alibaba.com>
Content-Language: en-US
In-Reply-To: <88888ec4-1e45-477a-8084-2c122c0bfda2@linux.alibaba.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.67.111.104]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggpeml500022.china.huawei.com (7.185.36.66)
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
From: Hongbo Li via Linux-erofs <linux-erofs@lists.ozlabs.org>
Reply-To: Hongbo Li <lihongbo22@huawei.com>
Cc: netfs@lists.linux.dev, linux-erofs@lists.ozlabs.org
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs" <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>



On 2024/6/21 18:42, Gao Xiang wrote:
> Hi,
> 
> On 2024/6/21 18:06, Gao Xiang wrote:
>>
>>
>> On 2024/6/21 17:37, Hongbo Li wrote:
>>>
>>>
>>> On 2024/6/21 17:14, Gao Xiang wrote:
>>>>
>>>>
>>>> On 2024/6/21 14:18, Hongbo Li wrote:
>>>>> Erofs over fscache need CONFIG_CACHEFILES_ONDEMAND in cachefiles
>>>>> module. We cannot know whether it is supported from userspace, so
>>>>> we export this feature to user by sysfs interface.
>>>>>
>>>>> [Before]
>>>>> $ cat /sys/fs/cachefiles/features/cachefiles_ondemand
>>>>> cat: /sys/fs/cachefiles/features/cachefiles_ondemand: No such file 
>>>>> or directory
>>>>>
>>>>> [After]
>>>>> $ cat /sys/fs/cachefiles/features/cachefiles_ondemand
>>>>> supported
>>>>>
>>>>> Signed-off-by: Hongbo Li <lihongbo22@huawei.com>
>>>>
>>>> I don't think such sysfs is needed, you could just use
>>>> `bind ondemand` to check if it is supported:
>>>> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/fs/cachefiles/daemon.c?h=v6.9#n780
>>>>
>>> Thanks for reply!
>>> `bind ondemand` can check if it is supported, but it requires a more 
>>> complicated procedure for user to implement. For example, a serial of 
>>> system call (open, ioctl, close) are need.The containerd snapshotter 
>>> daemon relies on these feature, only use a simple check method is 
>>> usable in product environment. The snapshotter developers may know 
>>> how cachefiles works, but for snapshotter users, a simple way to 
>>> check whether snapshotter can be launched is useful. Even though they 
>>> do not know how cachefiles works.
>>
>> I don't think it needs to be considered as long as userspace
>> has a way to check since you could wrap up these as a helper
>> (I will do in the official erofs-utils later or if you have
>> some interest you could help too) and even some erofs-utils
>> binary for this.
>>
>> sysfs maintainence just for some random feature doesn't
>> sound good to me (similar to ext4/xfs on-disk features) and
>> even if works, you cannot use this way for 5.19~6.10
>> upstream kernels.
> 
> Anyway, I know userspace folks always would like to have a
> simple kernel way to check if a feature is supported for a
> kernel, but (many years later) my current thought is that
> the simplist way to check this is to introduce a simple
> helper to try.  You cannot list every kernel features you
> concerned as some sysfs file and in time properly, or you
> could cause some inconsistency.
> 
> Anyway, that is my personal thought, having another detailed
> list for all features users care about along with the real
> implementaions seems unnecessary.
Thanks for explaining!
Maybe the way of showing the features in erofs now seems not
quite reasonable. It only output the "supported" string from
sysfs. What suggestions do you have for this?

Thanks,
Hongbo
> 
> Thanks,
> Gao Xiang
