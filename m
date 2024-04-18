Return-Path: <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CF4B4C4345F
	for <linux-erofs@archiver.kernel.org>; Thu, 18 Apr 2024 06:13:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=lists.ozlabs.org;
	s=201707; t=1713420807;
	bh=F93ceq1L6TshXZvLyqlWXo2/2ll3aZUB4ZmJuxKsuAc=;
	h=Date:Subject:To:References:In-Reply-To:List-Id:List-Unsubscribe:
	 List-Archive:List-Post:List-Help:List-Subscribe:From:Reply-To:Cc:
	 From;
	b=ZIPeg2w2fdqPLvks0M5+EN459D3vnjK4IVaqL6d2yZss1bpw5uITYGBxVfXHHXkpd
	 Xq8F357/hAvG9GSOHzN4BA8k8u5tH9y80MS5mWAX8x/GNDnhSvIxjfQkj+DmsX4ooN
	 BEK6BlvND9dvf0G1JVlPjieEyghUKn/Ea067sRKfqMawBTpy9TcTBzw5HZX39aCVLR
	 onbo37PRp8PL2CsRPc8ilgJcwEH5OA+bu4iqFLQz3gOdtX+rIaxDyQMF3TPttUe8jL
	 mK4a2FynVRX046yFiFa3E2BiJWMKWUkEMVMT849nT605FNb4ZMyhRQemGysA6l1ybm
	 XBBEXKT2Zy3Ng==
Received: from boromir.ozlabs.org (localhost [IPv6:::1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4VKnX727T2z3cT2
	for <linux-erofs@archiver.kernel.org>; Thu, 18 Apr 2024 16:13:27 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=huawei.com (client-ip=45.249.212.187; helo=szxga01-in.huawei.com; envelope-from=libaokun1@huawei.com; receiver=lists.ozlabs.org)
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4VKnWy2kSZz3btX
	for <linux-erofs@lists.ozlabs.org>; Thu, 18 Apr 2024 16:13:15 +1000 (AEST)
Received: from mail.maildlp.com (unknown [172.19.163.48])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4VKnRt5TK1ztXX7;
	Thu, 18 Apr 2024 14:09:46 +0800 (CST)
Received: from dggpeml500021.china.huawei.com (unknown [7.185.36.21])
	by mail.maildlp.com (Postfix) with ESMTPS id 5F579180073;
	Thu, 18 Apr 2024 14:12:40 +0800 (CST)
Received: from [10.174.177.174] (10.174.177.174) by
 dggpeml500021.china.huawei.com (7.185.36.21) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Thu, 18 Apr 2024 14:12:39 +0800
Message-ID: <48b21671-19ae-0dbd-96cd-7300fd600c9b@huawei.com>
Date: Thu, 18 Apr 2024 14:12:39 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.1.2
Subject: Re: [PATCH v2] erofs: reliably distinguish block based and fscache
 mode
Content-Language: en-US
To: Jingbo Xu <jefflexu@linux.alibaba.com>
References: <20240417065513.3409744-1-libaokun1@huawei.com>
 <71e66b02-9c2b-4981-83e1-8af72d6c0975@linux.alibaba.com>
 <7fdf4bff-2d3d-bdc0-5446-caa58aeca314@huawei.com>
 <fb65c7d0-c348-409e-b977-07616d28b279@linux.alibaba.com>
In-Reply-To: <fb65c7d0-c348-409e-b977-07616d28b279@linux.alibaba.com>
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
Cc: brauner@kernel.org, yangerkun@huawei.com, linux-kernel@vger.kernel.org, huyue2@coolpad.com, viro@zeniv.linux.org.uk, linux-erofs@lists.ozlabs.org
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs" <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>

On 2024/4/18 13:50, Jingbo Xu wrote:
>
> On 4/18/24 11:36 AM, Baokun Li wrote:
>> On 2024/4/18 10:16, Jingbo Xu wrote:
>>> Hi Baokun,
>>>
>>> Thanks for catching this and move forward fixing this!
>> Hi Jingbo，
>>
>> Thanks for your review！
>>
>>> On 4/17/24 2:55 PM, Baokun Li wrote:
>>>> When erofs_kill_sb() is called in block dev based mode, s_bdev may
>>>> not have
>>>> been initialised yet, and if CONFIG_EROFS_FS_ONDEMAND is enabled, it
>>>> will
>>>> be mistaken for fscache mode, and then attempt to free an anon_dev
>>>> that has
>>>> never been allocated, triggering the following warning:
>>>>
>>>> ============================================
>>>> ida_free called for id=0 which is not allocated.
>>>> WARNING: CPU: 14 PID: 926 at lib/idr.c:525 ida_free+0x134/0x140
>>>> Modules linked in:
>>>> CPU: 14 PID: 926 Comm: mount Not tainted 6.9.0-rc3-dirty #630
>>>> RIP: 0010:ida_free+0x134/0x140
>>>> Call Trace:
>>>>    <TASK>
>>>>    erofs_kill_sb+0x81/0x90
>>>>    deactivate_locked_super+0x35/0x80
>>>>    get_tree_bdev+0x136/0x1e0
>>>>    vfs_get_tree+0x2c/0xf0
>>>>    do_new_mount+0x190/0x2f0
>>>>    [...]
>>>> ============================================
>>>>
>>>> Instead of allocating the erofs_sb_info in fill_super() allocate it
>>>> during erofs_get_tree() and ensure that erofs can always have the info
>>>> available during erofs_kill_sb().
>>> I'm not sure if allocating erofs_sb_info in erofs_init_fs_context() will
>>> be better, as I see some filesystems (e.g. autofs) do this way.  Maybe
>>> another potential advantage of doing this way is that erofs_fs_context
>>> is not needed anymore and we can use sbi directly.
>> Yes, except for some extra memory usage when remounting,
>> this idea sounds great. Let me send a version of v3 to get rid
>> of erofs_fs_context.
> I'm not sure if Gao Xaing also prefers this.  I think it would be better
> to wait and listen for his thoughts before we sending v3.
  Okay, there's no rush on this.
>>>> Signed-off-by: Christian Brauner <brauner@kernel.org>
>>>> Signed-off-by: Baokun Li <libaokun1@huawei.com>
>>>> ---
>>>> Changes since v1:
>>>>     Allocate and initialise fc->s_fs_info in erofs_fc_get_tree()
>>>> instead of
>>>>     modifying fc->sb_flags.
>>>>
>>>> V1:
>>>> https://lore.kernel.org/r/20240415121746.1207242-1-libaokun1@huawei.com/
>>>>
>>>>    fs/erofs/super.c | 51 ++++++++++++++++++++++++++----------------------
>>>>    1 file changed, 28 insertions(+), 23 deletions(-)
>>>>
>>>> diff --git a/fs/erofs/super.c b/fs/erofs/super.c
>>>> index b21bd8f78dc1..4104280be2ea 100644
>>>> --- a/fs/erofs/super.c
>>>> +++ b/fs/erofs/super.c
>>>> @@ -581,8 +581,7 @@ static const struct export_operations
>>>> erofs_export_ops = {
>>>>    static int erofs_fc_fill_super(struct super_block *sb, struct
>>>> fs_context *fc)
>>>>    {
>>>>        struct inode *inode;
>>>> -    struct erofs_sb_info *sbi;
>>>> -    struct erofs_fs_context *ctx = fc->fs_private;
>>>> +    struct erofs_sb_info *sbi = EROFS_SB(sb);
>>>>        int err;
>>>>          sb->s_magic = EROFS_SUPER_MAGIC;
>>>> @@ -590,19 +589,6 @@ static int erofs_fc_fill_super(struct
>>>> super_block *sb, struct fs_context *fc)
>>>>        sb->s_maxbytes = MAX_LFS_FILESIZE;
>>>>        sb->s_op = &erofs_sops;
>>>>    -    sbi = kzalloc(sizeof(*sbi), GFP_KERNEL);
>>>> -    if (!sbi)
>>>> -        return -ENOMEM;
>>>> -
>>>> -    sb->s_fs_info = sbi;
>>>> -    sbi->opt = ctx->opt;
>>>> -    sbi->devs = ctx->devs;
>>>> -    ctx->devs = NULL;
>>>> -    sbi->fsid = ctx->fsid;
>>>> -    ctx->fsid = NULL;
>>>> -    sbi->domain_id = ctx->domain_id;
>>>> -    ctx->domain_id = NULL;
>>>> -
>>>>        sbi->blkszbits = PAGE_SHIFT;
>>>>        if (erofs_is_fscache_mode(sb)) {
>>>>            sb->s_blocksize = PAGE_SIZE;
>>>> @@ -704,11 +690,32 @@ static int erofs_fc_fill_super(struct
>>>> super_block *sb, struct fs_context *fc)
>>>>        return 0;
>>>>    }
>>>>    -static int erofs_fc_get_tree(struct fs_context *fc)
>>>> +static void erofs_ctx_to_info(struct fs_context *fc)
>>>>    {
>>>>        struct erofs_fs_context *ctx = fc->fs_private;
>>>> +    struct erofs_sb_info *sbi = fc->s_fs_info;
>>>> +
>>>> +    sbi->opt = ctx->opt;
>>>> +    sbi->devs = ctx->devs;
>>>> +    ctx->devs = NULL;
>>>> +    sbi->fsid = ctx->fsid;
>>>> +    ctx->fsid = NULL;
>>>> +    sbi->domain_id = ctx->domain_id;
>>>> +    ctx->domain_id = NULL;
>>>> +}
>>> I'm not sure if abstracting this logic into a seperate helper really
>>> helps understanding the code as the logic itself is quite simple and
>>> easy to be understood. Usually it's a hint of over-abstraction when a
>>> simple helper has only one caller.
>>>
>> Static functions that have only one caller are compiled inline, so we
>> don't have to worry about how that affects the code.
>>
>> The reason these codes are encapsulated in a separate function is so
>> that the code reader understands that these codes are integrated
>> as a whole, and that we shouldn't have to move one or two of these
>> lines individually.
>>
>> But after we get rid of erofs_fs_context, those won't be needed
>> anymore.
> Yeah, I understand. It's only coding style concerns.
>
>
>
Okay, thanks！

-- 
With Best Regards,
Baokun Li
