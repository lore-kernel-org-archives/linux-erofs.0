From: gaoxiang25@huawei.com (Gao Xiang)
Date: Thu, 27 Jun 2019 14:15:39 +0800
Subject: [PATCH] staging: erofs: Replace kzalloc(struct ..) with
 kzalloc(*ptr)
In-Reply-To: <20190627053115.GA20942@t-1000>
References: <20190627053115.GA20942@t-1000>
Message-ID: <191afe92-57c7-1103-5f4d-77a404f19330@huawei.com>



On 2019/6/27 13:31, Shobhit Kukreti wrote:
> Resolve checkpatch warning:
> Prefer kzalloc(sizeof(*ptr)...) over kzalloc(sizeof(struct ..)
> 
> Signed-off-by: Shobhit Kukreti <shobhitkukreti at gmail.com>

seems a new rule...

Reviewed-by: Gao Xiang <gaoxiang25 at huawei.com>

Thanks,
Gao Xiang
