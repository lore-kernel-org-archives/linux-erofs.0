From: yuchao0@huawei.com (Chao Yu)
Date: Tue, 7 May 2019 09:41:41 +0800
Subject: [PATCH] staging: erofs: set sb->s_root to NULL when failing from
 __getname()
In-Reply-To: <1557140462-22578-1-git-send-email-cgxu519@gmail.com>
References: <1557140462-22578-1-git-send-email-cgxu519@gmail.com>
Message-ID: <564fc539-4a73-6f43-f869-272b8d7d1781@huawei.com>

On 2019/5/6 19:01, Chengguang Xu wrote:
> Set sb->s_root to NULL when failing from __getname(),
> so that we can avoid double dput and unnecessary operations
> in generic_shutdown_super().
> 
> Signed-off-by: Chengguang Xu <cgxu519 at gmail.com>

Reviewed-by: Chao Yu <yuchao0 at huawei.com>

Thanks,
