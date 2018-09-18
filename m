From: yuchao0@huawei.com (Chao Yu)
Date: Tue, 18 Sep 2018 18:57:55 +0800
Subject: [PATCH v2 6/6] staging: erofs: option validation in remount
In-Reply-To: <20180917153426.16880-7-cgxu519@gmx.com>
References: <20180917153426.16880-1-cgxu519@gmx.com>
 <20180917153426.16880-7-cgxu519@gmx.com>
Message-ID: <2e1f90c3-9de1-9e78-7c14-f736f2246d40@huawei.com>

On 2018/9/17 23:34, Chengguang Xu wrote:
> Add option validation in remount. After this patch, remount
> can change recognized options, and for unknown options remount
> will fail and report error.
> 
> Signed-off-by: Chengguang Xu <cgxu519 at gmx.com>

Reviewed-by: Chao Yu <yuchao0 at huawei.com>

Thanks,
