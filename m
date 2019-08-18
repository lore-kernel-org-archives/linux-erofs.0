From: chao@kernel.org (Chao Yu)
Date: Sun, 18 Aug 2019 21:17:06 +0800
Subject: [PATCH] staging: erofs: refuse to mount images with malformed
 volume name
In-Reply-To: <20190818102824.22330-1-hsiangkao@aol.com>
References: <20190818102824.22330-1-hsiangkao@aol.com>
Message-ID: <d8bca74f-62db-29c2-1165-48b491ad4118@kernel.org>

On 2019-8-18 18:28, Gao Xiang wrote:
> From: Gao Xiang <gaoxiang25 at huawei.com>
> 
> As Richard reminder [1], A valid volume name should be
> ended in NIL terminator within the length of volume_name.
> 
> Since this field currently isn't really used, let's fix
> it to avoid potential bugs in the future.
> 
> [1] https://lore.kernel.org/r/1133002215.69049.1566119033047.JavaMail.zimbra at nod.at/
> 
> Reported-by: Richard Weinberger <richard at nod.at>
> Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>

Reviewed-by: Chao Yu <yuchao0 at huawei.com>

Thanks,
