From: chao@kernel.org (Chao Yu)
Date: Wed, 19 Sep 2018 23:27:27 +0800
Subject: [PATCH 5/6] staging: erofs: add some comments for xattr subsystem
In-Reply-To: <1537336150-90604-5-git-send-email-gaoxiang25@huawei.com>
References: <1537336150-90604-1-git-send-email-gaoxiang25@huawei.com>
 <1537336150-90604-5-git-send-email-gaoxiang25@huawei.com>
Message-ID: <27fe857b-6f9a-6944-cc2d-750aca0fdb07@kernel.org>

On 2018/9/19 13:49, Gao Xiang wrote:
> As Dan Carpenter pointed out, it is better to document what
> return values of these callbacks in `struct xattr_iter_handlers'
> mean and why it->ofs is increased regardless of success or
> failure in `xattr_foreach'.
> 
> Suggested-by: Dan Carpenter <dan.carpenter at oracle.com>
> Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>
> ---

Reviewed-by: Chao Yu <yuchao0 at huawei.com>

Thanks,
