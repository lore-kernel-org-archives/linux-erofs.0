From: yuchao0@huawei.com (Chao Yu)
Date: Mon, 30 Jul 2018 10:07:45 +0800
Subject: [PATCH 2/2] staging: erofs: fix conditional uninitialized `pcn'
 in z_erofs_map_blocks_iter
In-Reply-To: <20180729053757.34195-1-hsiangkao@aol.com>
References: <20180729053459.34140-1-hsiangkao@aol.com>
 <20180729053757.34195-1-hsiangkao@aol.com>
Message-ID: <348c0a6e-caaf-b52e-1645-5483a829ce65@huawei.com>

On 2018/7/29 13:37, Gao Xiang via Linux-erofs wrote:
> This patch adds error handling code for
> z_erofs_map_blocks_iter to fix the compiler blame.
> 
> Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>

Reviewed-by: Chao Yu <yuchao0 at huawei.com>

Thanks,
