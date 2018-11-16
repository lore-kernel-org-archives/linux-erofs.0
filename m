From: yuchao0@huawei.com (Chao Yu)
Date: Fri, 16 Nov 2018 10:58:43 +0800
Subject: [PATCH chao/erofs-dev rebased v2 04/12] staging: erofs: fix
 `trace_erofs_readpage' position
In-Reply-To: <20181114152548.37921-4-gaoxiang25@huawei.com>
References: <20181114152548.37921-1-gaoxiang25@huawei.com>
 <20181114152548.37921-4-gaoxiang25@huawei.com>
Message-ID: <a5e32218-3525-5013-e9f0-004cfd9f65ab@huawei.com>

On 2018/11/14 23:25, Gao Xiang wrote:
> `trace_erofs_readpage' should be placed in .readpage()
> rather than in the internal `z_erofs_do_read_page'.
> 
> Fixes: 284db12cfda3 ("staging: erofs: add trace points for reading zipped data")
> Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>
> Reviewed-by: Chen Gong <gongchen4 at huawei.com>

Reviewed-by: Chao Yu <yuchao0 at huawei.com>
Thanks,
