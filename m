From: gaoxiang25@huawei.com (Gao Xiang)
Date: Wed, 12 Sep 2018 00:03:49 +0800
Subject: [PATCH] erofs: option validation in remount
In-Reply-To: <02f26520-fcff-437a-63ea-3e909d39f5ba@gmx.com>
References: <20180911105129.3340-1-cgxu519@gmx.com>
 <1819a16e-2bbc-24f9-b683-79d00caf2ea2@huawei.com>
 <02f26520-fcff-437a-63ea-3e909d39f5ba@gmx.com>
Message-ID: <f00620e0-c09e-3bfc-1247-c22b90facdb0@huawei.com>

Hi Chengguang,

On 2018/9/11 23:37, cgxu519 wrote:
> On 09/11/2018 07:08 PM, Gao Xiang wrote:
>> Hi Chengguang,
>>
>> Thanks for your patch.
>>
>> The patch title should be "staging: erofs: " since erofs is still in staging.
> Hi Xiang,
> 
> Thanks for your review. I'll add the tag from next version.
> 
>>
>> The same as your previous patch "erofs: surround fault_injection ralted option
>> parsing using CONFIG_EROFS_FAULT_INJECTION".
>>
>> On 2018/9/11 18:51, Chengguang Xu wrote:
>>> Add option validation in remount. After this patch, remount
>>> can change recognized options, and for unknown options remount
>>> will fail and report error.
>>>
>>> Signed-off-by: Chengguang Xu <cgxu519 at gmx.com>
>>> ---
>>> ? drivers/staging/erofs/super.c | 17 +++++++++++++++++
>>> ? 1 file changed, 17 insertions(+)
>>>
>>> diff --git a/drivers/staging/erofs/super.c b/drivers/staging/erofs/super.c
>>> index 1aec509c805f..8bab077381ad 100644
>>> --- a/drivers/staging/erofs/super.c
>>> +++ b/drivers/staging/erofs/super.c
>>> @@ -625,10 +625,27 @@ static int erofs_show_options(struct seq_file *seq, struct dentry *root)
>>> ? ? static int erofs_remount(struct super_block *sb, int *flags, char *data)
>>> ? {
>>> +??? struct erofs_sb_info *sbi = EROFS_SB(sb);
>>> +??? struct erofs_fault_info *ffi = &sbi->fault_info;
>>> +??? unsigned int orig_mount_opt = sbi->mount_opt;
>>> +??? unsigned int orig_inject_rate = ffi->inject_rate;
>>> +??? int err;
>>> +
>>> ????? BUG_ON(!sb_rdonly(sb));
>>> ? +??? err = parse_options(sb, data);
>>> +??? if (err)
>>> +??????? goto out;
>>> +
>>> ????? *flags |= MS_RDONLY;
>>> ????? return 0;
>>> +
>>> +out:
>>> +??? if (ffi->inject_rate != orig_inject_rate)
>>> +??????? erofs_build_fault_attr(sbi, orig_inject_rate);
>> Currently should be with "#ifdef CONFIG_EROFS_FAULT_INJECTION"?
>> and have you tried to compile without EROFS_FAULT_INJECTION?
> Ah, It must be enabled in my environment.
> However, adding the macro in every calling place seems not convenient,
> I'll try to do some code cleanups, so please hold on this and previous patch for
> a moment, I'll resend those in a patch set.
> 

OK, that is fine. look forword to your next patch. ;)

Thanks,
Gao Xiang

> Thanks,
> Chengguang
> 
