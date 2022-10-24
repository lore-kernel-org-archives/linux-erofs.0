Return-Path: <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6487CECAAA1
	for <linux-erofs@archiver.kernel.org>; Mon, 24 Oct 2022 15:10:20 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [IPv6:::1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4Mwz5k4Dy5z3c1K
	for <linux-erofs@archiver.kernel.org>; Tue, 25 Oct 2022 02:10:18 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=lists.ozlabs.org;
	s=201707; t=1666624218;
	bh=udyUzm35RI/f0W3jtWSfwrk7u0Q87rqFbmMiG41Kfcc=;
	h=Subject:To:References:Date:In-Reply-To:List-Id:List-Unsubscribe:
	 List-Archive:List-Post:List-Help:List-Subscribe:From:Reply-To:Cc:
	 From;
	b=NNMllMcZin+SgsO29aRCJHgYtYMdzSu4bDVSb69pGZJ1bROcQXhD+ZtMsJ6KkHM2c
	 MRQETzLXvQUuda6vB6Ga3xAjjrjwPUDfIE5+dFWAXUTFLqUHCL3swby7dnq8yGOlr/
	 e6QgS+jZR2hytXgkbaA5oxFLsdTQFBUd/88y2sgglGywIH5vaQ+qGT+eQ1iNZ4NKd3
	 hDDt3WbSh+dbk/jDqYmaY1HxaDT4lxL4BXsx/sTY/nQpLkr7sbksIzmOt3YzRAHy1+
	 N0nJC3+QUrbW6QbLKXohG/IFzLA9Mg+dbAw0eWE05gDOVmdBTvYiKncz29YRPTQUaD
	 hKjczPmR/ivTQ==
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=huawei.com (client-ip=45.249.212.255; helo=szxga08-in.huawei.com; envelope-from=yangyingliang@huawei.com; receiver=<UNKNOWN>)
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4Mwz5c4phSz2xl5
	for <linux-erofs@lists.ozlabs.org>; Tue, 25 Oct 2022 02:10:09 +1100 (AEDT)
Received: from dggpemm500020.china.huawei.com (unknown [172.30.72.57])
	by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4Mwyzq5YM5z15M0P;
	Mon, 24 Oct 2022 23:05:11 +0800 (CST)
Received: from dggpemm500007.china.huawei.com (7.185.36.183) by
 dggpemm500020.china.huawei.com (7.185.36.49) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 24 Oct 2022 23:10:02 +0800
Received: from [10.174.178.174] (10.174.178.174) by
 dggpemm500007.china.huawei.com (7.185.36.183) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 24 Oct 2022 23:10:01 +0800
Subject: Re: [PATCH v2] kset: fix memory leak when kset_register() returns
 error
To: Greg KH <gregkh@linuxfoundation.org>
References: <20221024121910.1169801-1-yangyingliang@huawei.com>
 <Y1aYuLmlXBRvMP1Z@kroah.com>
 <8281fc72-948a-162d-6e5f-a9fe29d8ee46@huawei.com>
 <Y1am4mjS+obAbUTJ@kroah.com>
Message-ID: <87e4e75b-a26e-6b4b-4799-c56c0b8891c0@huawei.com>
Date: Mon, 24 Oct 2022 23:10:00 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <Y1am4mjS+obAbUTJ@kroah.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [10.174.178.174]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggpemm500007.china.huawei.com (7.185.36.183)
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
From: Yang Yingliang via Linux-erofs <linux-erofs@lists.ozlabs.org>
Reply-To: Yang Yingliang <yangyingliang@huawei.com>
Cc: rafael@kernel.org, qemu-devel@nongnu.org, liushixin2@huawei.com, joseph.qi@linux.alibaba.com, linux-mtd@lists.infradead.org, huangjianan@oppo.com, richard@nod.at, mark@fasheh.com, mst@redhat.com, amd-gfx@lists.freedesktop.org, luben.tuikov@amd.com, yangyingliang@huawei.com, hsiangkao@linux.alibaba.com, somlo@cmu.edu, jlbec@evilplan.org, jaegeuk@kernel.org, linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, alexander.deucher@amd.com, akpm@linux-foundation.org, linux-erofs@lists.ozlabs.org, ocfs2-devel@oss.oracle.com
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs" <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>


On 2022/10/24 22:53, Greg KH wrote:
> On Mon, Oct 24, 2022 at 10:39:44PM +0800, Yang Yingliang wrote:
>> On 2022/10/24 21:52, Greg KH wrote:
>>> On Mon, Oct 24, 2022 at 08:19:10PM +0800, Yang Yingliang wrote:
>>>> Inject fault while loading module, kset_register() may fail.
>>>> If it fails, the name allocated by kobject_set_name() which
>>>> is called before kset_register() is leaked, because refcount
>>>> of kobject is hold in kset_init().
>>>>
>>>> As a kset may be embedded in a larger structure which needs
>>>> be freed in release() function or error path in callers, we
>>>> can not call kset_put() in kset_register(), or it will cause
>>>> double free, so just call kfree_const() to free the name and
>>>> set it to NULL.
>>>>
>>>> With this fix, the callers don't need to care about the name
>>>> freeing and call an extra kset_put() if kset_register() fails.
>>>>
>>>> Suggested-by: Luben Tuikov <luben.tuikov@amd.com>
>>>> Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
>>>> ---
>>>> v1 -> v2:
>>>>     Free name inside of kset_register() instead of calling kset_put()
>>>>     in drivers.
>>>> ---
>>>>    lib/kobject.c | 8 +++++++-
>>>>    1 file changed, 7 insertions(+), 1 deletion(-)
>>>>
>>>> diff --git a/lib/kobject.c b/lib/kobject.c
>>>> index a0b2dbfcfa23..3409a89c81e5 100644
>>>> --- a/lib/kobject.c
>>>> +++ b/lib/kobject.c
>>>> @@ -834,6 +834,9 @@ EXPORT_SYMBOL_GPL(kobj_sysfs_ops);
>>>>    /**
>>>>     * kset_register() - Initialize and add a kset.
>>>>     * @k: kset.
>>>> + *
>>>> + * NOTE: On error, the kset.kobj.name allocated by() kobj_set_name()
>>>> + * which is called before kset_register() in caller need be freed.
>>> This comment doesn't make any sense anymore.  No caller needs to worry
>>> about this, right?
>> With this fix, the name is freed inside of kset_register(), it can not be
>> accessed,
> Agreed.
>
>> if it allocated dynamically, but callers don't know this if no comment here,
>> they may use it in error path (something like to print error message with
>> it),
>> so how about comment like this to tell callers not to use the name:
>>
>> NOTE: On error, the kset.kobj.name allocated by() kobj_set_name()
>> is freed, it can not be used any more.
> Sure, that's a better way to word it.
>
>>>>     */
>>>>    int kset_register(struct kset *k)
>>>>    {
>>>> @@ -844,8 +847,11 @@ int kset_register(struct kset *k)
>>>>    	kset_init(k);
>>>>    	err = kobject_add_internal(&k->kobj);
>>>> -	if (err)
>>>> +	if (err) {
>>>> +		kfree_const(k->kobj.name);
>>>> +		k->kobj.name = NULL;
>>> Why are you setting the name here to NULL?
>> I set it to NULL to avoid accessing bad pointer in callers,
>> if callers use it in error path, current callers won't use this
>> name pointer in error path, so we can remove this assignment?
> Ah, I didn't think about using it on error paths.  Ideally that would
> never happen, but that's good to set just to make it obvious.  How about
> adding a small comment here saying why you are setting it so we all
> remember it in 5 years when we look at the code again.
OK, I can add it in v3.

Thanks,
Yang
>
> thanks,
>
> greg k-h
> .
