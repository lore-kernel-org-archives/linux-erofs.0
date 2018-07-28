From: yuchao0@huawei.com (Chao Yu)
Date: Sat, 28 Jul 2018 18:43:07 +0800
Subject: [PATCH] staging: erofs: fix a compile warning of
 Z_EROFS_VLE_VMAP_ONSTACK_PAGES
In-Reply-To: <1532761832-6964-1-git-send-email-gaoxiang25@huawei.com>
References: <1532607728-103372-26-git-send-email-gaoxiang25@huawei.com>
 <1532761832-6964-1-git-send-email-gaoxiang25@huawei.com>
Message-ID: <5d62c752-f6bf-c6a8-b57d-7497c3a5df17@huawei.com>

On 2018/7/28 15:10, Gao Xiang wrote:
> There is a type mismatch in the definition of
> Z_EROFS_VLE_VMAP_ONSTACK_PAGES, let's fix it.
> 
> Link: https://lists.01.org/pipermail/kbuild-all/2018-July/050707.html
> Reported-by: kbuild test robot <lkp at intel.com>
> Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>

Reviewed-by: Chao Yu <yuchao0 at huawei.com>

Thanks,
