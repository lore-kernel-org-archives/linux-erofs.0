From: yuchao0@huawei.com (Chao Yu)
Date: Wed, 14 Aug 2019 17:22:20 +0800
Subject: [PATCH RESEND 1/2] staging: erofs: introduce EFSCORRUPTED and
 more logs
In-Reply-To: <20190814043208.15591-1-gaoxiang25@huawei.com>
References: <20190814042525.4925-2-gaoxiang25@huawei.com>
 <20190814043208.15591-1-gaoxiang25@huawei.com>
Message-ID: <db0e0d1d-9018-5c2c-93d0-b718e7e6853c@huawei.com>

On 2019/8/14 12:32, Gao Xiang wrote:
> Previously, EROFS uses EIO to indicate that filesystem is
> corrupted as well, but other filesystems tend to use
> EUCLEAN instead, let's follow what others do right now.
> 
> Also, add some more prints to the syslog.
> 
> Suggested-by: Pavel Machek <pavel at denx.de>
> Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>

Reviewed-by: Chao Yu <yuchao0 at huawei.com>

Thanks,
