From: yuchao0@huawei.com (Chao Yu)
Date: Tue, 11 Jun 2019 11:01:58 +0800
Subject: [PATCH v2 1/2] staging: erofs: add requirements field in
 superblock
In-Reply-To: <20190611024220.86121-1-gaoxiang25@huawei.com>
References: <20190611024220.86121-1-gaoxiang25@huawei.com>
Message-ID: <9e0cb4bb-6ffe-95fb-c892-e321bc94f14a@huawei.com>

On 2019/6/11 10:42, Gao Xiang wrote:
> There are some backward incompatible features pending
> for months, mainly due to on-disk format expensions.
> 
> However, we should ensure that it cannot be mounted with
> old kernels. Otherwise, it will causes unexpected behaviors.
> 
> Fixes: ba2b77a82022 ("staging: erofs: add super block operations")
> Cc: <stable at vger.kernel.org> # 4.19+
> Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>

Reviewed-by: Chao Yu <yuchao0 at huawei.com>

Thanks,
