From: yuchao0@huawei.com (Chao Yu)
Date: Fri, 10 Aug 2018 14:53:30 +0800
Subject: [WIP] [PATCH] staging: erofs: cleanup z_erofs_do_read_page
In-Reply-To: <1533809340-69863-1-git-send-email-gaoxiang25@huawei.com>
References: <1533809340-69863-1-git-send-email-gaoxiang25@huawei.com>
Message-ID: <04b2cf16-eb36-337a-0625-05b90859d355@huawei.com>

On 2018/8/9 18:09, Gao Xiang wrote:
> This patch adds error handing code, and fixes a
> bug when appling caching policy, which can cause
> the ending compressed pack of a request uncached.

Aslo including too many kind of change in one patch, how about splitting this patch?

Thanks,
