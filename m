From: yuchao0@huawei.com (Chao Yu)
Date: Tue, 20 Nov 2018 11:33:47 +0800
Subject: [PATCH chao/erofs-dev rebased v2 07/12] staging: erofs: fix
 `erofs_workgroup_{try_to_freeze, unfreeze}'
In-Reply-To: <20181114152548.37921-7-gaoxiang25@huawei.com>
References: <20181114152548.37921-1-gaoxiang25@huawei.com>
 <20181114152548.37921-7-gaoxiang25@huawei.com>
Message-ID: <cb7c01b5-9596-32e7-df7e-d21ae9eb9a26@huawei.com>

On 2018/11/14 23:25, Gao Xiang wrote:
> There are two minor issues in the current freeze interface:
> 
>    1) Freeze interfaces have not related with CONFIG_DEBUG_SPINLOCK,
>       therefore fix the incorrect conditions;
> 
>    2) For SMP platforms, it should also disable preemption before
>       doing atomic_cmpxchg in case that some high priority tasks
>       preempt between atomic_cmpxchg and disable_preempt, then spin
>       on the locked refcount later.
> 
> Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>

Reviewed-by: Chao Yu <yuchao0 at huawei.com>

Thanks,
