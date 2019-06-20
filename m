From: yuchao0@huawei.com (Chao Yu)
Date: Thu, 20 Jun 2019 17:22:48 +0800
Subject: [PATCH] staging: erofs: remove needless CONFIG_EROFS_FS_SECURITY
In-Reply-To: <8a45f678-15cc-be9a-282f-49b251f127a9@huawei.com>
References: <20190620083004.2488-1-zbestahu@gmail.com>
 <8a45f678-15cc-be9a-282f-49b251f127a9@huawei.com>
Message-ID: <fdc23da6-90eb-e3f0-448a-5df1494f4190@huawei.com>

On 2019/6/20 16:32, Gao Xiang wrote:
> Hi Yue,
> 
> On 2019/6/20 16:30, Yue Hu wrote:
>> From: Yue Hu <huyue2 at yulong.com>
>>
>> erofs_xattr_security_handler is already marked __maybe_unused, no need
>> to add CONFIG_EROFS_FS_SECURITY condition.

CONFIG_EROFS_FS_SECURITY is used as a control switch of erofs security labels
feature, but __maybe_unused is to avoid unneeded compiler warning on unused
variable, so I think we can't remove it.

Thanks,

>>
>> Signed-off-by: Yue Hu <huyue2 at yulong.com>
>> ---
>>  drivers/staging/erofs/xattr.c | 2 --
>>  1 file changed, 2 deletions(-)
>>
>> diff --git a/drivers/staging/erofs/xattr.c b/drivers/staging/erofs/xattr.c
>> index df40654..06024ac 100644
>> --- a/drivers/staging/erofs/xattr.c
>> +++ b/drivers/staging/erofs/xattr.c
>> @@ -499,13 +499,11 @@ static int erofs_xattr_generic_get(const struct xattr_handler *handler,
>>  	.get	= erofs_xattr_generic_get,
>>  };
>>  
>> -#ifdef CONFIG_EROFS_FS_SECURITY
>>  const struct xattr_handler __maybe_unused erofs_xattr_security_handler = {
>>  	.prefix	= XATTR_SECURITY_PREFIX,
>>  	.flags	= EROFS_XATTR_INDEX_SECURITY,
>>  	.get	= erofs_xattr_generic_get,
>>  };
>> -#endif
> 
> Thanks for your patch.
> 
> In that case...erofs_xattr_security_handler could be compiled into .rodata section?
> I am not sure...
> 
> Thanks,
> Gao Xiang
> 
>>  
>>  const struct xattr_handler *erofs_xattr_handlers[] = {
>>  	&erofs_xattr_user_handler,
>>
> .
> 
