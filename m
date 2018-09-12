From: dan.carpenter@oracle.com (Dan Carpenter)
Date: Wed, 12 Sep 2018 12:16:31 +0300
Subject: [PATCH 4/7] staging: erofs: return -EINVAL when specifying fault
 rate to 0
In-Reply-To: <20180912051034.3463-5-cgxu519@gmx.com>
References: <20180912051034.3463-1-cgxu519@gmx.com>
 <20180912051034.3463-5-cgxu519@gmx.com>
Message-ID: <20180912091631.xgxx5zj457z7srlo@mwanda>

On Wed, Sep 12, 2018@01:10:31PM +0800, Chengguang Xu wrote:
> Set fault rate to 0 is useless and confusable, so add check to
> avoid it.
> 

I would have assumed setting rate to zero just disabled it.

regards,
dan carpenter
