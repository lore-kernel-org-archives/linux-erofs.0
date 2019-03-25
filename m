From: yuchao0@huawei.com (Chao Yu)
Date: Mon, 25 Mar 2019 09:46:03 +0800
Subject: [PATCH 2/3] staging: erofs: introduce erofs_page_is_managed()
In-Reply-To: <20190319135501.28712-2-gaoxiang25@huawei.com>
References: <20190319135501.28712-1-gaoxiang25@huawei.com>
 <20190319135501.28712-2-gaoxiang25@huawei.com>
Message-ID: <402d5225-f2f2-55e9-25b0-1993cbbcf202@huawei.com>

On 2019/3/19 21:55, Gao Xiang wrote:
> 1) In order to clean up unnecessary
>    page->mapping == MNGD_MAPPING(sbi) wrapped by #ifdefs;
> 
> 2) Needed by "staging: erofs: support IO read error injection".
> 
> Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>

Reviewed-by: Chao Yu <yuchao0 at huawei.com>

Thanks,
