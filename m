From: yuchao0@huawei.com (Chao Yu)
Date: Mon, 16 Jul 2018 11:18:06 +0800
Subject: [PATCH 1/2] erofs: fix match_table with a NULL terminated pattern
In-Reply-To: <1531706300-45908-1-git-send-email-gaoxiang25@huawei.com>
References: <1531158912-84952-1-git-send-email-gaoxiang25@huawei.com>
 <1531706300-45908-1-git-send-email-gaoxiang25@huawei.com>
Message-ID: <e72b2f3d-21d7-5337-863f-e1b47f8338fa@huawei.com>

On 2018/7/16 9:58, Gao Xiang wrote:
> Without a NULL terminated pattern, it could cause memory
> access violation.
> 
> Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>

Reviewed-by: Chao Yu <yuchao0 at huawei.com>

Thanks,
