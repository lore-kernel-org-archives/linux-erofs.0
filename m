From: chao@kernel.org (Chao Yu)
Date: Sat, 11 Aug 2018 22:05:12 +0800
Subject: [PREVIEW] [PATCH v3 1/3] staging: erofs: introduce erofs_grab_bio
In-Reply-To: <1533919575-116855-1-git-send-email-gaoxiang25@huawei.com>
References: <9162b8da-a914-689a-c20d-2b8d9530d4b7@huawei.com>
 <1533919575-116855-1-git-send-email-gaoxiang25@huawei.com>
Message-ID: <ec9d26b0-4390-e2e8-3b87-1d2ba2ed902b@kernel.org>

On 2018/8/11 0:46, Gao Xiang wrote:
> this patch renames prepare_bio to erofs_grab_bio, and
> adds a nofail option in order to retry in the bio allocator
> under memory pressure.
> 
> Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>

Reviewed-by: Chao Yu <yuchao0 at huawei.com>

Thanks,
