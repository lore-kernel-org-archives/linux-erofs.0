From: yuchao0@huawei.com (Chao Yu)
Date: Tue, 13 Aug 2019 11:09:51 +0800
Subject: [PATCH 2/3] staging: erofs: remove incomplete cleancache
In-Reply-To: <20190813023054.73126-2-gaoxiang25@huawei.com>
References: <20190813023054.73126-1-gaoxiang25@huawei.com>
 <20190813023054.73126-2-gaoxiang25@huawei.com>
Message-ID: <b61abcf2-25cf-5c5f-09be-758e0ac4f16d@huawei.com>

On 2019/8/13 10:30, Gao Xiang wrote:
> cleancache was not fully implemented in EROFS.
> In addition, it's tend to remove the whole cleancache in
> related attempt [1].
> 
> [1] https://lore.kernel.org/linux-fsdevel/20190527103207.13287-3-jgross at suse.com/
> Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>

Reviewed-by: Chao Yu <yuchao0 at huawei.com>

Thanks,
