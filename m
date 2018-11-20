From: yuchao0@huawei.com (Chao Yu)
Date: Tue, 20 Nov 2018 11:26:33 +0800
Subject: [PATCH chao/erofs-dev rebased v2 06/12] staging: erofs:
 atomic_cond_read_relaxed on ref-locked workgroup
In-Reply-To: <20181114152548.37921-6-gaoxiang25@huawei.com>
References: <20181114152548.37921-1-gaoxiang25@huawei.com>
 <20181114152548.37921-6-gaoxiang25@huawei.com>
Message-ID: <bb15da8f-cf83-e83f-5088-aed05faf97f6@huawei.com>

On 2018/11/14 23:25, Gao Xiang wrote:
> It's better to use atomic_cond_read_relaxed, which is implemented
> in hardware instructions to monitor a variable changes currently
> for ARM64, instead of open-coded busy waiting.
> 
> Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>

Reviewed-by: Chao Yu <yuchao0 at huawei.com>

Thanks,
