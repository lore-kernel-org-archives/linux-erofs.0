From: yuchao0@huawei.com (Chao Yu)
Date: Thu, 27 Jun 2019 17:29:34 +0800
Subject: [PATCH] staging: erofs: Replace kzalloc(struct ..) with
 kzalloc(*ptr)
In-Reply-To: <20190627053115.GA20942@t-1000>
References: <20190627053115.GA20942@t-1000>
Message-ID: <0d39774e-a6b6-3e6f-9baa-1a20e3c990e8@huawei.com>

On 2019/6/27 13:31, Shobhit Kukreti wrote:
> Resolve checkpatch warning:
> Prefer kzalloc(sizeof(*ptr)...) over kzalloc(sizeof(struct ..)
> 
> Signed-off-by: Shobhit Kukreti <shobhitkukreti at gmail.com>

Reviewed-by: Chao Yu <yuchao0 at huawei.com>

Thanks,
