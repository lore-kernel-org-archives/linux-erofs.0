From: gaoxiang25@huawei.com (Gao Xiang)
Date: Thu, 22 Nov 2018 19:22:34 +0800
Subject: [PATCH 04/10] staging: erofs: fix
 `erofs_workgroup_{try_to_freeze, unfreeze}'
In-Reply-To: <20181122110534.GD5287@kroah.com>
References: <20181120143425.43637-1-gaoxiang25@huawei.com>
 <20181120143425.43637-5-gaoxiang25@huawei.com>
 <20181122102155.GE3189@kroah.com>
 <ee829ce6-e59e-3ed6-b9a4-16c29c9eb59f@huawei.com>
 <20181122110534.GD5287@kroah.com>
Message-ID: <8d3a4b4f-22be-9ee9-534b-3ecd97c0b53a@huawei.com>

Hi Greg,

On 2018/11/22 19:05, Greg Kroah-Hartman wrote:
> As I said in another email, doing two things with one variable is odd as
> those are two different types of functions.

I think lockref_put_or_lock do the similar thing, it is heavily used in dcache.c, but
1) 0 is special for us, we need lock it on a < 0 value rather than 0.
2) spinlock_t is too large for us because every compressed page will have the structure,
   but the locking rarely happens.

Thanks,
Gao Xiang

> 
> greg k-h
