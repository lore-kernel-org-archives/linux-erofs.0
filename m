From: zhongjiang@huawei.com (zhong jiang)
Date: Wed, 19 Sep 2018 11:16:26 +0800
Subject: [PATCH] staging: erofs: Fix a unused variable 'arg' warning
In-Reply-To: <5b3438ac-f4d4-7f66-4be0-1720c1eada98@gmx.com>
References: <1537323381-23839-1-git-send-email-zhongjiang@huawei.com>
 <5b3438ac-f4d4-7f66-4be0-1720c1eada98@gmx.com>
Message-ID: <5BA1BF8A.1000807@huawei.com>

On 2018/9/19 11:07, cgxu519 wrote:
> On 09/19/2018 10:16 AM, zhong jiang wrote:
>> I find the following warning when compiling the kernel.
>>
>> drivers/staging/erofs/super.c:195:6: warning: unused variable 'arg' [-Wunused-variable]
>>    int arg = 0;
>>
>> Signed-off-by: zhong jiang <zhongjiang at huawei.com>
>> ---
>>   drivers/staging/erofs/super.c | 2 ++
>>   1 file changed, 2 insertions(+)
>>
>> diff --git a/drivers/staging/erofs/super.c b/drivers/staging/erofs/super.c
>> index 6423592..c04313f 100644
>> --- a/drivers/staging/erofs/super.c
>> +++ b/drivers/staging/erofs/super.c
>> @@ -192,7 +192,9 @@ static int parse_options(struct super_block *sb, char *options)
>>   {
>>       substring_t args[MAX_OPT_ARGS];
>>       char *p;
>> +#ifdef CONFIG_EROFS_FAULT_INJECTION
>>       int arg = 0;
>> +#endif
>>         if (!options)
>>           return 0;
>
> Hi,
>
> The fix has already included in my patch series "staging: erofs: option validation for remount and some code cleanups",
> so it will be fixed when the series merge into tree and we do not encourage surrounding the code with macro in option
> parsing for this case.
>
Fine.  Thank you for explaination.

Sincerely,
zhong jiang
> Thanks,
> Chengguang
>
> .
>
