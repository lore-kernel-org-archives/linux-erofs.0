From: yuchao0@huawei.com (Chao Yu)
Date: Tue, 20 Nov 2018 16:36:37 +0800
Subject: [RFC PATCH v2 chao/erofs-dev 1/5] staging: erofs: rename strange
 variable names in z_erofs_vle_frontend
In-Reply-To: <20181119133106.45183-1-gaoxiang25@huawei.com>
References: <20181119133106.45183-1-gaoxiang25@huawei.com>
Message-ID: <d7448e16-c6d1-4067-1d0b-fbe621d895cd@huawei.com>

On 2018/11/19 21:31, Gao Xiang wrote:
> Previously, 2 members called `initial' and `cachedzone_la' are used
> for applying caching policy (whether the workgroup is at either end),
> which are hard to understand, rename them to `backmost' and `headoffset'.
> 
> Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>

Reviewed-by: Chao Yu <yuchao0 at huawei.com>

Thanks,
