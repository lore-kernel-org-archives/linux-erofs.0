From: yuchao0@huawei.com (Chao Yu)
Date: Tue, 20 Nov 2018 14:50:52 +0800
Subject: [PATCH chao/erofs-dev rebased v2 09/12] staging: erofs: fix the
 definition of DBG_BUGON
In-Reply-To: <20181114152548.37921-9-gaoxiang25@huawei.com>
References: <20181114152548.37921-1-gaoxiang25@huawei.com>
 <20181114152548.37921-9-gaoxiang25@huawei.com>
Message-ID: <771ce827-1536-0b03-990a-6cb60b14d3bb@huawei.com>

On 2018/11/14 23:25, Gao Xiang wrote:
> It's better not to positively BUG_ON the kernel, however developers
> need a way to locate issues as soon as possible.
> 
> DBG_BUGON is introduced and it could only crash when EROFS_FS_DEBUG
> (EROFS developping feature) is on. It is helpful for developers
> to find and solve bugs quickly.
> 
> Previously, DBG_BUGON is defined as ((void)0) if EROFS_FS_DEBUG is off,
> but some unused variable warnings as follows could occur:
> 
> drivers/staging/erofs/unzip_vle.c: In function ?init_always?:
> drivers/staging/erofs/unzip_vle.c:61:33: warning: unused variable ?work? [-Wunused-variable]
>   struct z_erofs_vle_work *const work =
>                                  ^~~~
> 
> Fix it to #define DBG_BUGON(x) ((void)(x)).
> 
> Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>

Reviewed-by: Chao Yu <yuchao0 at huawei.com>

Thanks,
