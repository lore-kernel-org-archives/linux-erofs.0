From: chao@kernel.org (Chao Yu)
Date: Sat, 11 Aug 2018 22:05:53 +0800
Subject: [PREVIEW] [PATCH v3 2/3] staging: erofs: separate
 erofs_get_meta_page
In-Reply-To: <1533919730-117224-1-git-send-email-gaoxiang25@huawei.com>
References: <cb3eadc7-c71e-6132-5189-ab34e247271b@huawei.com>
 <1533919730-117224-1-git-send-email-gaoxiang25@huawei.com>
Message-ID: <774f9ae4-9fe8-8824-7714-a2042722d211@kernel.org>

On 2018/8/11 0:48, Gao Xiang wrote:
> This patch separates 'erofs_get_meta_page' into 'erofs_get_meta_page'
> and 'erofs_get_meta_page_nofail'. The second one ensures that it
> should not fail under memory pressure and should make best efforts
> if IO errors occur.
> 
> It also adds const variables in order to fulfill 80 character limit.
> 
> Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>

Reviewed-by: Chao Yu <yuchao0 at huawei.com>

Thanks,
