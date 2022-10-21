Return-Path: <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2EFD2C433FE
	for <linux-erofs@archiver.kernel.org>; Fri, 21 Oct 2022 08:25:02 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [IPv6:::1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4MtyFS5vBjz3ds1
	for <linux-erofs@archiver.kernel.org>; Fri, 21 Oct 2022 19:25:00 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=lists.ozlabs.org;
	s=201707; t=1666340700;
	bh=4tpxnqik1XAnrGlJyGCwUtdkI9g+xhisCqPaAlOGh3M=;
	h=Subject:To:References:Date:In-Reply-To:List-Id:List-Unsubscribe:
	 List-Archive:List-Post:List-Help:List-Subscribe:From:Reply-To:Cc:
	 From;
	b=n74bm/aks8+ac98PUWaCMHk7FrpUNrH0+w3XdMdDy2g40Oz2SP5Gep/4N7/vKx3ua
	 wpOmvHkowvBItr2zE3rGM9dxfiH0UhK8DVmivFjjbEmbqDrAT3CAwkQIGZbeIfOccf
	 A7Jobs3y/68IhmTDZlvvoMOExifXhCe4TBWGVvImaAK7P6Qakekov1f1AbcEzFgu+H
	 XubvCkQ4CcuLLfyQiP5chyibbGulRtoHWKCJF+7xJp36nUMazTlh3vwNOdPbutnpMW
	 l0XPq2GBqt1j+70lYtDyuBBwBM0D3FMjl9sF29O1PP6+mnYfGOzgCIwDqgy7nLdyk6
	 qJMev470gqQTQ==
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=huawei.com (client-ip=45.249.212.188; helo=szxga02-in.huawei.com; envelope-from=yangyingliang@huawei.com; receiver=<UNKNOWN>)
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4MtyFM5qjQz3bXn
	for <linux-erofs@lists.ozlabs.org>; Fri, 21 Oct 2022 19:24:55 +1100 (AEDT)
Received: from dggpemm500023.china.huawei.com (unknown [172.30.72.55])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4Mty7v25HnzVj06;
	Fri, 21 Oct 2022 16:20:11 +0800 (CST)
Received: from dggpemm500007.china.huawei.com (7.185.36.183) by
 dggpemm500023.china.huawei.com (7.185.36.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 21 Oct 2022 16:24:25 +0800
Received: from [10.174.178.174] (10.174.178.174) by
 dggpemm500007.china.huawei.com (7.185.36.183) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 21 Oct 2022 16:24:24 +0800
Subject: Re: [PATCH 00/11] fix memory leak while kset_register() fails
To: Greg KH <gregkh@linuxfoundation.org>, Luben Tuikov <luben.tuikov@amd.com>
References: <20221021022102.2231464-1-yangyingliang@huawei.com>
 <d559793a-0ce4-3384-e74e-19855aa31f31@amd.com> <Y1IwLOUGayjT9p6d@kroah.com>
Message-ID: <0591e66f-731a-5f81-fc9d-3a6d80516c65@huawei.com>
Date: Fri, 21 Oct 2022 16:24:23 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <Y1IwLOUGayjT9p6d@kroah.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Originating-IP: [10.174.178.174]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
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
Cc: rafael@kernel.org, qemu-devel@nongnu.org, richard@nod.at, somlo@cmu.edu, mst@redhat.com, linux-kernel@vger.kernel.org, amd-gfx@lists.freedesktop.org, linux-f2fs-devel@lists.sourceforge.net, liushixin2@huawei.com, joseph.qi@linux.alibaba.com, linux-mtd@lists.infradead.org, jlbec@evilplan.org, hsiangkao@linux.alibaba.com, alexander.deucher@amd.com, jaegeuk@kernel.org, akpm@linux-foundation.org, huangjianan@oppo.com, linux-erofs@lists.ozlabs.org, mark@fasheh.com, ocfs2-devel@oss.oracle.com
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs" <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>


On 2022/10/21 13:37, Greg KH wrote:
> On Fri, Oct 21, 2022 at 01:29:31AM -0400, Luben Tuikov wrote:
>> On 2022-10-20 22:20, Yang Yingliang wrote:
>>> The previous discussion link:
>>> https://lore.kernel.org/lkml/0db486eb-6927-927e-3629-958f8f211194@huawei.com/T/
>> The very first discussion on this was here:
>>
>> https://www.spinics.net/lists/dri-devel/msg368077.html
>>
>> Please use this link, and not the that one up there you which quoted above,
>> and whose commit description is taken verbatim from the this link.
>>
>>> kset_register() is currently used in some places without calling
>>> kset_put() in error path, because the callers think it should be
>>> kset internal thing to do, but the driver core can not know what
>>> caller doing with that memory at times. The memory could be freed
>>> both in kset_put() and error path of caller, if it is called in
>>> kset_register().
>> As I explained in the link above, the reason there's
>> a memory leak is that one cannot call kset_register() without
>> the kset->kobj.name being set--kobj_add_internal() returns -EINVAL,
>> in this case, i.e. kset_register() fails with -EINVAL.
>>
>> Thus, the most common usage is something like this:
>>
>> 	kobj_set_name(&kset->kobj, format, ...);
>> 	kset->kobj.kset = parent_kset;
>> 	kset->kobj.ktype = ktype;
>> 	res = kset_register(kset);
>>
>> So, what is being leaked, is the memory allocated in kobj_set_name(),
>> by the common idiom shown above. This needs to be mentioned in
>> the documentation, at least, in case, in the future this is absolved
>> in kset_register() redesign, etc.
> Based on this, can kset_register() just clean up from itself when an
> error happens?  Ideally that would be the case, as the odds of a kset
> being embedded in a larger structure is probably slim, but we would have
> to search the tree to make sure.
I have search the whole tree, the kset used in bus_register() - patch 
#3, kset_create_and_add() - patch #4
__class_register() - patch #5,  fw_cfg_build_symlink() - patch #6 and 
amdgpu_discovery.c - patch #10
is embedded in a larger structure. In these cases, we can not call 
kset_put() in error path in kset_register()
itself.

Thanks,
Yang
>
> thanks,
>
> greg k-h
> .
