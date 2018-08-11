From: chao@kernel.org (Chao Yu)
Date: Sat, 11 Aug 2018 22:42:08 +0800
Subject: [PREVIEW] [PATCH v3 06/10] staging: erofs: fix compression
 mapping beyond EOF
In-Reply-To: <1533931838-47642-6-git-send-email-gaoxiang25@huawei.com>
References: <1533931838-47642-1-git-send-email-gaoxiang25@huawei.com>
 <1533931838-47642-6-git-send-email-gaoxiang25@huawei.com>
Message-ID: <88f19b7f-fe44-097f-125b-36ff70a37da0@kernel.org>

On 2018/8/11 4:10, Gao Xiang wrote:
> Logical address of EOF LTP mapping should start at
> `inode->i_size' rather than `inode->i_size - 1' to
> `m_la(in) + 1 - inode->i_size', fix it.
> 
> Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>

Reviewed-by: Chao Yu <yuchao0 at huawei.com>

Thanks,
