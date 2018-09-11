From: chao@kernel.org (Chao Yu)
Date: Wed, 12 Sep 2018 00:50:20 +0800
Subject: [PATCH v2] erofs: surround fault_injection ralted option parsing
 using CONFIG_EROFS_FAULT_INJECTION
In-Reply-To: <20180910235154.3148-1-cgxu519@gmx.com>
References: <20180910235154.3148-1-cgxu519@gmx.com>
Message-ID: <1ccd9caa-0531-5196-1bf3-079fa10d29a6@kernel.org>

On 2018/9/11 7:51, Chengguang Xu wrote:
> It's a little bit strange when fault_injection related
> option fail with -EINVAL which was already disabled
> from config, so surround all fault_injection related option
> parsing code using CONFIG_EROFS_FAULT_INJECTION. Meanwhile,
> slightly change warning message to keep consistency with
> option POSIX_ACL and FS_XATTR.
> 
> Signed-off-by: Chengguang Xu <cgxu519 at gmx.com>

Prefix of patch title should be "staging: erofs: " as Xiang pointed out,
otherwise it looks good to me, you can add:

Reviewed-by: Chao Yu <yuchao0 at huawei.com>

Thanks,
