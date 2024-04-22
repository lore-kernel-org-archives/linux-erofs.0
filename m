Return-Path: <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E4F03C4345F
	for <linux-erofs@archiver.kernel.org>; Mon, 22 Apr 2024 11:32:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=lists.ozlabs.org;
	s=201707; t=1713785521;
	bh=Ecdrrru7BBuHkXBRBA/TMzAeQkyVcDGulmWJRv/WML4=;
	h=Date:Subject:To:References:In-Reply-To:List-Id:List-Unsubscribe:
	 List-Archive:List-Post:List-Help:List-Subscribe:From:Reply-To:Cc:
	 From;
	b=EFrLVTI6H7PDkoSNdbJtGapTMORKATTDnbjKlDQSXnYnw7n+D6a3tkcwQ90zeaIMw
	 Rga2smJc7QJ48sp3bQdOMA7rL/Wj4/JL0CgefcAylV2jEyJBa3FVYnQ41Pf1raDsPx
	 NBUoCnWnCDa8k1UYn0dW7CDPe3XPIHYG1xvJrFVZNbG1QVIJ5Sz0PqBBZTqhZKyAXi
	 r5jOLleJ+3cqckw2BdRTreyROEYWIxqAAubeT3dnFJieVlb7VAav1pBEDkYyNJr/Zf
	 mfVl/z9UAxgUfdIL3Qb5RcyiCrydo5SPqH9I6A1BEv2Dj7PWU4c7JDgMav0KaDBp5Q
	 qx+fnfXIxwQvg==
Received: from boromir.ozlabs.org (localhost [IPv6:::1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4VNNPs4FC3z3cZJ
	for <linux-erofs@archiver.kernel.org>; Mon, 22 Apr 2024 21:32:01 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=huawei.com (client-ip=45.249.212.191; helo=szxga05-in.huawei.com; envelope-from=libaokun1@huawei.com; receiver=lists.ozlabs.org)
Received: from szxga05-in.huawei.com (szxga05-in.huawei.com [45.249.212.191])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4VNNPj27kYz2xQL
	for <linux-erofs@lists.ozlabs.org>; Mon, 22 Apr 2024 21:31:52 +1000 (AEST)
Received: from mail.maildlp.com (unknown [172.19.162.112])
	by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4VNNNS6w6Tz1HBkv;
	Mon, 22 Apr 2024 19:30:48 +0800 (CST)
Received: from dggpeml500021.china.huawei.com (unknown [7.185.36.21])
	by mail.maildlp.com (Postfix) with ESMTPS id 34B421403D1;
	Mon, 22 Apr 2024 19:31:48 +0800 (CST)
Received: from [10.174.177.174] (10.174.177.174) by
 dggpeml500021.china.huawei.com (7.185.36.21) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Mon, 22 Apr 2024 19:31:47 +0800
Message-ID: <4e8dd4f5-29dc-9459-6ba2-f399258952dc@huawei.com>
Date: Mon, 22 Apr 2024 19:31:47 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.1.2
Subject: Re: [PATCH -next v3 1/2] erofs: get rid of erofs_fs_context
Content-Language: en-US
To: Jingbo Xu <jefflexu@linux.alibaba.com>, <linux-erofs@lists.ozlabs.org>
References: <20240419123611.947084-1-libaokun1@huawei.com>
 <20240419123611.947084-2-libaokun1@huawei.com>
 <8d751a33-af11-4aa8-8fad-cc24e825bde7@linux.alibaba.com>
In-Reply-To: <8d751a33-af11-4aa8-8fad-cc24e825bde7@linux.alibaba.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.177.174]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggpeml500021.china.huawei.com (7.185.36.21)
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
From: Baokun Li via Linux-erofs <linux-erofs@lists.ozlabs.org>
Reply-To: Baokun Li <libaokun1@huawei.com>
Cc: brauner@kernel.org, yangerkun@huawei.com, linux-kernel@vger.kernel.org, huyue2@coolpad.com, viro@zeniv.linux.org.uk
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs" <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>

Hi Jingbo,

On 2024/4/22 18:25, Jingbo Xu wrote:
>
> On 4/19/24 8:36 PM, Baokun Li wrote:
>
>> @@ -761,12 +747,15 @@ static void erofs_free_dev_context(struct erofs_dev_context *devs)
>>   
>>   static void erofs_fc_free(struct fs_context *fc)
>>   {
>> -	struct erofs_fs_context *ctx = fc->fs_private;
>> +	struct erofs_sb_info *sbi = fc->s_fs_info;
>> +
>> +	if (!sbi)
>> +		return;
>
> This is the only difference comparing to the original code literally.
> Is there any chance that fc->s_fs_info can be NULL when erofs_fc_free()
> is called?
>
> Otherwise looks good to me.
>
When sget_fc() executes successfully, fc->s_fs_info is set to NULL,
so the following NULL pointer dereference may occur:

do_new_mount
   vfs_get_tree
     erofs_fc_get_tree
       get_tree_bdev
         sget_dev
           sget_fc
             s = alloc_super
             s->s_fs_info = fc->s_fs_info;
             fc->s_fs_info = NULL;
         fill_super
         // return error
         deactivate_locked_super
           kfree(sbi);
   put_fs_context
     sbi = fc->s_fs_info
     kfree(sbi->fsid)

Thank you very much for the review!
-- 
With Best Regards,
Baokun Li
