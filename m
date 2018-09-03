From: hsiangkao@aol.com (Gao Xiang)
Date: Mon, 3 Sep 2018 12:50:57 +0800
Subject: [PATCH 6/6] staging: erofs: fix 1 warning and 9 checks
In-Reply-To: <3c43c174-c805-32e2-ac8e-504604ef29ab@huawei.com>
References: <1535642042-5336-1-git-send-email-zemlyanoy@ispras.ru>
 <1535642042-5336-6-git-send-email-zemlyanoy@ispras.ru>
 <3c43c174-c805-32e2-ac8e-504604ef29ab@huawei.com>
Message-ID: <617a05b1-fc25-aa6e-c4d6-1aec06f72009@aol.com>



On 2018/9/3 9:49, Chao Yu wrote:
> On 2018/8/30 23:14, Pavel Zemlyanoy wrote:
>> This patch does not change the logic, it only
>> corrects the formatting and checkpatch checks by
>> braces {} should be used on all arms of this statement,
>> unbalanced braces around else statement and warning by
>> braces {} are not necessary for any arm of this statement.
>>
>> The patch fixes 9 checks of type:
>> "Check: braces {} should be used on all arms of this statement";
>> "Check: Unbalanced braces around else statement";
>>
>> and 1 warning of type:
>> "WARNING: braces {} are not necessary for any arm of this statement".
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
