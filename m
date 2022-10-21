Return-Path: <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 682DEC4332F
	for <linux-erofs@archiver.kernel.org>; Fri, 21 Oct 2022 08:06:33 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [IPv6:::1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4Mtxr750bhz3drv
	for <linux-erofs@archiver.kernel.org>; Fri, 21 Oct 2022 19:06:31 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=lists.ozlabs.org;
	s=201707; t=1666339591;
	bh=TbkWa8UpOuwWbaKsXoVj1MqIDQZJ376yxEpng9yYR/s=;
	h=Subject:To:References:Date:In-Reply-To:List-Id:List-Unsubscribe:
	 List-Archive:List-Post:List-Help:List-Subscribe:From:Reply-To:Cc:
	 From;
	b=GrhfRBDsF5P1vxlpqSX1rmNfjfdjBbwT8zZ9j9W0z/LT3o6mlXf5c9EbbTb0rwKXO
	 nBHX9gDB/4Wv6PYkQzLp7UhtROVKgRO4aycy3ICs718zqyIRwPIx4j9uoJv4m1DtyI
	 gyKy5uOuallY6JTGjAyd+HvMV7csahcOtrC0WFH4o+gBKHL/PyIfZD0XDUb+SZbOBm
	 Fx0Pim+MoXKga1GbKDK5RX/cSdrYMUxUi12mMOufhUwiK2HcKnBu2RK57xyMaFf/Hf
	 XakI/mxXHeAQVI3sjqMlwNYJUYMcjcOoQ/LojYitQ/zipxGn3dDPq0c/A82Xs3ZPv4
	 +puhoVil/gElg==
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=huawei.com (client-ip=45.249.212.187; helo=szxga01-in.huawei.com; envelope-from=yangyingliang@huawei.com; receiver=<UNKNOWN>)
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4Mtxr14QmYz2xbK
	for <linux-erofs@lists.ozlabs.org>; Fri, 21 Oct 2022 19:06:22 +1100 (AEDT)
Received: from dggpemm500023.china.huawei.com (unknown [172.30.72.54])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4Mtxjn0wbFzmVCy;
	Fri, 21 Oct 2022 16:01:01 +0800 (CST)
Received: from dggpemm500007.china.huawei.com (7.185.36.183) by
 dggpemm500023.china.huawei.com (7.185.36.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 21 Oct 2022 16:05:20 +0800
Received: from [10.174.178.174] (10.174.178.174) by
 dggpemm500007.china.huawei.com (7.185.36.183) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 21 Oct 2022 16:05:19 +0800
Subject: Re: [PATCH 01/11] kset: fix documentation for kset_register()
To: Luben Tuikov <luben.tuikov@amd.com>, <linux-kernel@vger.kernel.org>,
	<qemu-devel@nongnu.org>, <linux-f2fs-devel@lists.sourceforge.net>,
	<linux-erofs@lists.ozlabs.org>, <ocfs2-devel@oss.oracle.com>,
	<linux-mtd@lists.infradead.org>, <amd-gfx@lists.freedesktop.org>,
	<gregkh@linuxfoundation.org>
References: <20221021022102.2231464-1-yangyingliang@huawei.com>
 <20221021022102.2231464-2-yangyingliang@huawei.com>
 <eb0f1459-7980-4a7b-58f9-652eeccc357e@amd.com>
Message-ID: <10d887c4-7db0-8958-f661-bd52e6c8b4af@huawei.com>
Date: Fri, 21 Oct 2022 16:05:18 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <eb0f1459-7980-4a7b-58f9-652eeccc357e@amd.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [10.174.178.174]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
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
Cc: alexander.deucher@amd.com, mst@redhat.com, richard@nod.at, somlo@cmu.edu, huangjianan@oppo.com, liushixin2@huawei.com, joseph.qi@linux.alibaba.com, jlbec@evilplan.org, jaegeuk@kernel.org, rafael@kernel.org, hsiangkao@linux.alibaba.com, akpm@linux-foundation.org, mark@fasheh.com
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs" <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>


On 2022/10/21 13:34, Luben Tuikov wrote:
> On 2022-10-20 22:20, Yang Yingliang wrote:
>> kset_register() is currently used in some places without calling
>> kset_put() in error path, because the callers think it should be
>> kset internal thing to do, but the driver core can not know what
>> caller doing with that memory at times. The memory could be freed
>> both in kset_put() and error path of caller, if it is called in
>> kset_register().
>>
>> So make the function documentation more explicit about calling
>> kset_put() in the error path of caller.
>>
>> Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
>> ---
>>   lib/kobject.c | 3 +++
>>   1 file changed, 3 insertions(+)
>>
>> diff --git a/lib/kobject.c b/lib/kobject.c
>> index a0b2dbfcfa23..6da04353d974 100644
>> --- a/lib/kobject.c
>> +++ b/lib/kobject.c
>> @@ -834,6 +834,9 @@ EXPORT_SYMBOL_GPL(kobj_sysfs_ops);
>>   /**
>>    * kset_register() - Initialize and add a kset.
>>    * @k: kset.
>> + *
>> + * If this function returns an error, kset_put() must be called to
>> + * properly clean up the memory associated with the object.
>>    */
> And I'd continue the sentence, with " ... with the object,
> for instance the memory for the kset.kobj.name when kobj_set_name(&kset.kobj, format, ...)
> was called before calling kset_register()."
kobject_cleanup() not only frees name, but aslo calls ->release() to 
free another resources.
>
> This makes it clear what we want to make sure is freed, in case of an early error
> from kset_register().

How about like this:

If this function returns an error, kset_put() must be called to clean up the name of
kset object and other memory associated with the object.

>
> Regards,
> Luben
>
>>   int kset_register(struct kset *k)
>>   {
> .
