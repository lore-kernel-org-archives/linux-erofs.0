From: gaoxiang25@huawei.com (Gao Xiang)
Date: Tue, 20 Nov 2018 11:44:52 +0800
Subject: [PATCH chao/erofs-dev rebased v2 05/12] staging: erofs: fix race
 when the managed cache is enabled
In-Reply-To: <278d9ed6-ad51-b50e-3135-6c1049eae44f@huawei.com>
References: <20181114152548.37921-1-gaoxiang25@huawei.com>
 <20181114152548.37921-5-gaoxiang25@huawei.com>
 <278d9ed6-ad51-b50e-3135-6c1049eae44f@huawei.com>
Message-ID: <936a6266-f3ad-0cef-37c1-3d387d78788e@huawei.com>

Hi Chao,

On 2018/11/20 11:24, Chao Yu wrote:
>> +		/*
>> +		 * it's safe to decrease since the workgroup isn't visible
>> +		 * and refcount >= 2 (cannot be freezed).
>> +		 */
>> +		atomic_dec(&grp->refcount);
> How about:
> 
> #define __erofs_workgroup_put(grp)	atomic_dec(&grp->refcount);
> 
> Otherwise, it looks good to me.
> 

OK, I will fix it soon and send the whole next version patchset
including this modification.

Thanks,
Gao Xiang

> Reviewed-by: Chao Yu <yuchao0 at huawei.com>
> 
> Thanks,
> 
