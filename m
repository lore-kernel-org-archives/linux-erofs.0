From: gaoxiang25@huawei.com (Gao Xiang)
Date: Tue, 18 Sep 2018 21:51:23 +0800
Subject: [PATCH v2 2/6] staging: erofs: code cleanup for option parsing of
 fault_injection
In-Reply-To: <a63378c4-bd21-0d05-1aa8-e1d14b2e013d@gmx.com>
References: <20180917153426.16880-1-cgxu519@gmx.com>
 <20180917153426.16880-3-cgxu519@gmx.com>
 <04998eab-11f2-7d3b-166c-f481a4d5e8a0@huawei.com>
 <a63378c4-bd21-0d05-1aa8-e1d14b2e013d@gmx.com>
Message-ID: <4d7ccb08-7001-b20e-b4ca-207a2981679c@huawei.com>

Hi Chengguang,

On 2018/9/18 18:47, cgxu519 wrote:
> On 09/18/2018 03:07 PM, Gao Xiang wrote:
>> Hi Chengguang,
>>
>> On 2018/9/17 23:34, Chengguang Xu wrote:
>>> Define a dummpy function of erofs_build_fault_attr() when macro
>>> CONFIG_EROFS_FAULT_INJECTION is disabled, so that we don't have to
>>> check the macro in calling place. Based on above adjustment,
>>> do proper code cleanup for option parsing of fault_injection.
>>>
>>> Signed-off-by: Chengguang Xu <cgxu519 at gmx.com>
>>> ---
>>> ? drivers/staging/erofs/super.c | 33 ++++++++++++++++++++-------------
>>> ? 1 file changed, 20 insertions(+), 13 deletions(-)
>>>
>>> diff --git a/drivers/staging/erofs/super.c b/drivers/staging/erofs/super.c
>>> index 9e421536cbdf..7ce2fd3d49f3 100644
>>> --- a/drivers/staging/erofs/super.c
>>> +++ b/drivers/staging/erofs/super.c
>>> @@ -145,10 +145,14 @@ char *erofs_fault_name[FAULT_MAX] = {
>>> ????? [FAULT_KMALLOC]??????? = "kmalloc",
>>> ? };
>>> ? -static void erofs_build_fault_attr(struct erofs_sb_info *sbi,
>>> -??????????????????????? unsigned int rate)
>>> +static int erofs_build_fault_attr(struct erofs_sb_info *sbi,
>>> +??????????????????? substring_t *args)
>>> ? {
>>> ????? struct erofs_fault_info *ffi = &sbi->fault_info;
>>> +??? int rate = 0;
>>> +
>>> +??? if (args->from && match_int(args, &rate))
>>> +??????? return -EINVAL;
>>> ? ????? if (rate) {
>>> ????????? atomic_set(&ffi->inject_ops, 0);
>>> @@ -157,6 +161,15 @@ static void erofs_build_fault_attr(struct erofs_sb_info *sbi,
>>> ????? } else {
>>> ????????? memset(ffi, 0, sizeof(struct erofs_fault_info));
>>> ????? }
>>> +
>>> +??? set_opt(sbi, FAILt_INJECTION);
>> drivers/staging/erofs/super.c: In function ?__erofs_build_fault_attr?:
>> drivers/staging/erofs/internal.h:176:51: error: ?EROFS_MOUNT_FAILt_INJECTION? undeclared (first use in this function)
>> ? #define set_opt(sbi, option) ((sbi)->mount_opt |= EROFS_MOUNT_##option)
>> ??????????????????????????????????????????????????? ^
>> drivers/staging/erofs/super.c:166:2: note: in expansion of macro ?set_opt?
>> ?? set_opt(sbi, FAILt_INJECTION);
>> ?? ^
>> drivers/staging/erofs/internal.h:176:51: note: each undeclared identifier is reported only once for each function it appears in
>> ? #define set_opt(sbi, option) ((sbi)->mount_opt |= EROFS_MOUNT_##option)
>> ??????????????????????????????????????????????????? ^
>> drivers/staging/erofs/super.c:166:2: note: in expansion of macro ?set_opt?
>> ?? set_opt(sbi, FAILt_INJECTION);
>> ?? ^
> 
> Hi Xiang,
> 
> I'm really sorry for that, I'm curious how it passed my building test.
> I deleted all existing config and? binary files and tested with/without INJECTION config this time.

I have no idea either...
No worry about that, just resend your fixed patch.

Thanks,
Gao Xiang

> 
> 
> Thanks,
> Chengguang
> 
> 
> 
