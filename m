From: yuchao0@huawei.com (Chao Yu)
Date: Tue, 18 Sep 2018 18:56:31 +0800
Subject: [PATCH v2 4/6] staging: erofs: introduce a new helper
 erofs_get_fault_rate()
In-Reply-To: <20180917153426.16880-5-cgxu519@gmx.com>
References: <20180917153426.16880-1-cgxu519@gmx.com>
 <20180917153426.16880-5-cgxu519@gmx.com>
Message-ID: <0b67fdb6-243e-dde9-c8b7-e80a9ba89e55@huawei.com>

On 2018/9/17 23:34, Chengguang Xu wrote:
> Introduce a new helper for getting fault rate, so that we
> don't have to check macro in calling place.
> 
> Signed-off-by: Chengguang Xu <cgxu519 at gmx.com>

Can you fold this patch into [5/6]?

Thanks,
