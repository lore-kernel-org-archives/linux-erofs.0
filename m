From: gaoxiang25@huawei.com (Gao Xiang)
Date: Tue, 20 Nov 2018 15:13:31 +0800
Subject: [PATCH chao/erofs-dev rebased v2 10/12] staging: erofs: separate
 into init_once / always
In-Reply-To: <edb56b2b-355a-1c52-de5d-46a388aa401d@huawei.com>
References: <20181114152548.37921-1-gaoxiang25@huawei.com>
 <20181114152919.38560-1-gaoxiang25@huawei.com>
 <edb56b2b-355a-1c52-de5d-46a388aa401d@huawei.com>
Message-ID: <863d5cca-4086-7921-0c6e-d9f3b4869a26@huawei.com>

Hi Chao,

On 2018/11/20 15:00, Chao Yu wrote:
> On 2018/11/14 23:29, Gao Xiang wrote:
>> `z_erofs_vle_workgroup' is heavily generated in the decompression,
>> for example, it resets 32 bytes redundantly for 64-bit platforms
>> even through Z_EROFS_VLE_INLINE_PAGEVECS + Z_EROFS_CLUSTER_MAX_PAGES,
>> default 4, pages are stored in `z_erofs_vle_workgroup'.
>>
>> As an another example, `struct mutex' takes 72 bytes for our kirin
>> 64-bit platforms, it's unnecessary to be reseted at first and
>> be initialized each time.
>>
>> Let's avoid filling all `z_erofs_vle_workgroup' with 0 at first
>> since most fields are reinitialized to meaningful values later,
>> and pagevec is no need to initialized at all.
>>
>> Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>
> In [09/12], it says:
> 
> drivers/staging/erofs/unzip_vle.c: In function ?init_always
> 
> But actually, we introduce it in [10/12].
> 
> So this patch should be relocated to [09/12]?

[09/12] staging: erofs: fix the definition of DBG_BUGON was introduced to
fix [10/12] staging: erofs: separate into init_once / always uninitialized warning...

But actually it is a generic issue if EROFS_FS_DEBUG is off, [10/12] was taken
as an example...

Thanks,
Gao Xiang

> 
> Reviewed-by: Chao Yu <yuchao0 at huawei.com>
> 
> Thanks,
> 
