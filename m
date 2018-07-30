From: yuchao0@huawei.com (Chao Yu)
Date: Mon, 30 Jul 2018 14:58:49 +0800
Subject: [PATCH] staging: erofs: use the wrapped PTR_ERR_OR_ZERO instead
 of open code
In-Reply-To: <1532915461-2512-1-git-send-email-gaoxiang25@huawei.com>
References: <20180729053757.34195-1-hsiangkao@aol.com>
 <1532915461-2512-1-git-send-email-gaoxiang25@huawei.com>
Message-ID: <74f9e641-88c4-d544-2963-00e6f67e5d83@huawei.com>

On 2018/7/30 9:51, Gao Xiang wrote:
> Just clean up and logic doesn't change.
> 
> Link: https://lists.01.org/pipermail/kbuild-all/2018-July/050766.html
> Fixes: d72d1ce60174 ("staging: erofs: add namei functions")
> Reported-by: kbuild test robot <lkp at intel.com>
> Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>

Reviewed-by: Chao Yu <yuchao0 at huawei.com>
Thanks,
