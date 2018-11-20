From: yuchao0@huawei.com (Chao Yu)
Date: Tue, 20 Nov 2018 15:05:19 +0800
Subject: [PATCH chao/erofs-dev rebased v2 11/12] staging: erofs: locked
 before registering for all new workgroups
In-Reply-To: <20181114152919.38560-2-gaoxiang25@huawei.com>
References: <20181114152548.37921-1-gaoxiang25@huawei.com>
 <20181114152919.38560-1-gaoxiang25@huawei.com>
 <20181114152919.38560-2-gaoxiang25@huawei.com>
Message-ID: <e0fa73f0-fa29-637b-5da5-5477ee8aec8a@huawei.com>

On 2018/11/14 23:29, Gao Xiang wrote:
> Let's make sure that the one registering a workgroup will also
> take the primary work lock at first for two reasons:
>   1) There's no need to introduce such a race window (and consequently
>      overhead) between registering and locking, other tasks could break
>      in by chance, and the race seems unnecessary (no benefit at all);
> 
>   2) It's better to take the primary work when a workgroup
>      is registered to apply the cache managed policy, for example,
>      if some other tasks break in, it could turn into the in-place
>      decompression rather than use as the cached decompression.
> 
> Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>

Reviewed-by: Chao Yu <yuchao0 at huawei.com>

Thanks,
