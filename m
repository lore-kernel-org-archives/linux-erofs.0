From: hsiangkao@aol.com (Gao Xiang)
Date: Mon, 3 Sep 2018 12:30:15 +0800
Subject: [PATCH 1/6] staging: erofs: formatting fix in unzip_vle_lz4.c
In-Reply-To: <2ab6d363-1be6-d616-dd66-e81eea6bd31d@huawei.com>
References: <1535642042-5336-1-git-send-email-zemlyanoy@ispras.ru>
 <2ab6d363-1be6-d616-dd66-e81eea6bd31d@huawei.com>
Message-ID: <e145aa67-f37f-4e02-0418-eb72c9bc7e15@aol.com>



On 2018/9/3 9:47, Chao Yu wrote:
> On 2018/8/30 23:13, Pavel Zemlyanoy wrote:
>>
>> This patch does not change the logic, it only
>> corrects the formatting and checkpatch warnings by
>> adding "int" to the unsigned type.
>>
>> The patch fixes 11 warnings of the type:
>> "WARNING: Prefer 'unsigned int' to bare use of 'unsigned'"
>>
>> Signed-off-by: Pavel Zemlyanoy <zemlyanoy at ispras.ru>
> 
> Reviewed-by: Chao Yu <yuchao0 at huawei.com>
> 

Reviewed-by: Gao Xiang <gaoxiang25 at huawei.com>

Thanks,
Gao Xiang

> Thanks,
> 
> _______________________________________________
> devel mailing list
> devel at linuxdriverproject.org
> http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel
> 
