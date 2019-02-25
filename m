From: yuchao0@huawei.com (Chao Yu)
Date: Mon, 25 Feb 2019 09:36:07 +0800
Subject: [PATCH 2/2] staging: erofs: switch to ->iterate_shared()
In-Reply-To: <20190221023411.2980-2-gaoxiang25@huawei.com>
References: <20190221023411.2980-1-gaoxiang25@huawei.com>
 <20190221023411.2980-2-gaoxiang25@huawei.com>
Message-ID: <9ba14947-f891-33c6-278c-7d75bd07befd@huawei.com>

On 2019/2/21 10:34, Gao Xiang wrote:
> After commit 6192269444eb ("introduce a parallel variant of ->iterate()"),
> readdir can be done without taking exclusive inode lock of course.
> 
> Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>

Reviewed-by: Chao Yu <yuchao0 at huawei.com>

Thanks,
