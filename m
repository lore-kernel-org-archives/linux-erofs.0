From: yuchao0@huawei.com (Chao Yu)
Date: Wed, 31 Jul 2019 15:46:16 +0800
Subject: [PATCH 10/22] staging: erofs: kill sbi->dev_name
In-Reply-To: <20190729065159.62378-11-gaoxiang25@huawei.com>
References: <20190729065159.62378-1-gaoxiang25@huawei.com>
 <20190729065159.62378-11-gaoxiang25@huawei.com>
Message-ID: <a453b60f-40f4-4ebd-ee49-75ea52034b97@huawei.com>

On 2019/7/29 14:51, Gao Xiang wrote:
> As Al said, "the only use of sbi->dev_name is debugging
> printks and all of those have sb->s_id available, with
> device name stored in there.  Which makes the whole
> thing bloody weird".
> 
> sbi->dev_name was used for our debugging use and it's
> better to just use s_id in community and delete
> the whole erofs_mount_private stuff.
> 
> Suggested-by: Al Viro <viro at zeniv.linux.org.uk>
> Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>

Reviewed-by: Chao Yu <yuchao0 at huawei.com>

Thanks,
