From: cgxu519@gmx.com (cgxu519)
Date: Mon, 17 Sep 2018 21:52:09 +0800
Subject: [PATCH 2/7] staging: erofs: code cleanup for option parsing of
 fault_injection
In-Reply-To: <fac1ec54-8a23-c1c4-d0ea-db6e5e88ef26@kernel.org>
References: <20180912051034.3463-1-cgxu519@gmx.com>
 <20180912051034.3463-3-cgxu519@gmx.com>
 <8402ea38-0918-170e-34d9-ccdaf518bc34@huawei.com>
 <c9b83793-b630-8172-6953-60604c81893a@gmx.com>
 <fac1ec54-8a23-c1c4-d0ea-db6e5e88ef26@kernel.org>
Message-ID: <51baa570-b3aa-e0b4-86d0-27d69940483b@gmx.com>

On 09/14/2018 11:22 PM, Chao Yu wrote:
> On 2018/9/13 13:46, cgxu519 wrote:
>> On 09/13/2018 10:15 AM, Chao Yu wrote:
>>> On 2018/9/12 13:10, Chengguang Xu wrote:
>>>> Define a dummpy function of erofs_build_fault_attr() when macro
>>>> CONFIG_EROFS_FAULT_INJECTION is disabled, so that we don't have to
>>>> check the macro in calling place. Based on above adjustment,
>>>> do proper code cleanup for option parsing of fault_injection.
>>>>
>>>> Signed-off-by: Chengguang Xu <cgxu519 at gmx.com>
>>>> ---
>>>>  ? drivers/staging/erofs/super.c | 33 ++++++++++++++++++++++-----------
>>>>  ? 1 file changed, 22 insertions(+), 11 deletions(-)
>>>>
>>>> diff --git a/drivers/staging/erofs/super.c b/drivers/staging/erofs/super.c
>>>> index 1aec509c805f..14dbb6517b8d 100644
>>>> --- a/drivers/staging/erofs/super.c
>>>> +++ b/drivers/staging/erofs/super.c
>>>> @@ -144,18 +144,33 @@ char *erofs_fault_name[FAULT_MAX] = {
>>>>  ????? [FAULT_KMALLOC]??????? = "kmalloc",
>>>>  ? };
>>>>  ? -static void erofs_build_fault_attr(struct erofs_sb_info *sbi,
>>>> -??????????????????????? unsigned int rate)
>>>> +static int erofs_build_fault_attr(struct erofs_sb_info *sbi,
>>>> +??????????????????? substring_t *args)
>>>>  ? {
>>>>  ????? struct erofs_fault_info *ffi = &sbi->fault_info;
>>>> +??? int rate = 0;
>>>> +
>>>> +??? if (args->from && match_int(args, &rate))
>>>> +??????? return -EINVAL;
>>>>  ? ????? if (rate) {
>>>>  ????????? atomic_set(&ffi->inject_ops, 0);
>>>>  ????????? ffi->inject_rate = rate;
>>>>  ????????? ffi->inject_type = (1 << FAULT_MAX) - 1;
>>>> +??????? set_opt(sbi, FAULT_INJECTION);
>>>>  ????? } else {
>>>>  ????????? memset(ffi, 0, sizeof(struct erofs_fault_info));
>>>> +??????? clear_opt(sbi, FAULT_INJECTION);
>>> Hmmm, if user mounts/remounts image with -o fault_injection=0, user can not
>>> check such info in anywhere, as we skip showing this option due to lack of
>>> EROFS_MOUNT_FAULT_INJECTION bit. How about keeping this bit?
>>>
>> IIUC, the purpose of fault_injection=0 is for disabling fault injection function,
>> so isn't it the same as default? Should we distinguish explicit setting value 0
> IMO, if user set fault_injection=0 during mount, it means user want to enable
> this feature but currently user want to set the rate to zero, later user may
> change it to non-zero. And with EROFS_MOUNT_FAULT_INJECTION being set, user can
> check current rate value via ->show_options.

Hi Chao,

Do you mean user can modify the value without remount? or maybe in the 
future?

Thanks,
Chengguang
