From: yuchao0@huawei.com (Chao Yu)
Date: Mon, 24 Jun 2019 15:33:15 +0800
Subject: [PATCH v3 3/8] staging: erofs: move per-CPU buffers
 implementation to utils.c
In-Reply-To: <20190624072258.28362-4-hsiangkao@aol.com>
References: <20190624072258.28362-1-hsiangkao@aol.com>
 <20190624072258.28362-4-hsiangkao@aol.com>
Message-ID: <3ab4064f-042e-1838-6e32-5fb7087f4dc1@huawei.com>

On 2019/6/24 15:22, Gao Xiang wrote:
> From: Gao Xiang <gaoxiang25 at huawei.com>
> 
> This patch moves per-CPU buffers to utils.c in order for
> the upcoming generic decompression framework to use it.
> 
> Note that I tried to use generic per-CPU buffer or
> per-CPU page approaches to clean up further, but obvious
> performanace regression (about 2% for sequential read) was
> observed.
> 
> Therefore let's leave it as it is instead, just move
> to utils.c and I'll try to dig into the root cause later.
> 
> Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>

Reviewed-by: Chao Yu <yuchao0 at huawei.com>

Thanks,
