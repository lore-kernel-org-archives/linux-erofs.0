From: gaoxiang25@huawei.com (Gao Xiang)
Date: Tue, 16 Jul 2019 20:17:30 +0800
Subject: [PATCH v2] staging: erofs: avoid opened loop codes
In-Reply-To: <20190716094422.110805-1-yuchao0@huawei.com>
References: <20190716094422.110805-1-yuchao0@huawei.com>
Message-ID: <e0725b60-c6d2-1590-c974-f79e085e8cb8@huawei.com>



On 2019/7/16 17:44, Chao Yu wrote:
> Use __GFP_NOFAIL to avoid opened loop codes in z_erofs_vle_unzip().
> 
> Signed-off-by: Chao Yu <yuchao0 at huawei.com>

Reviewed-by: Gao Xiang <gaoxiang25 at huawei.com>

Thanks,
Gao Xiang
