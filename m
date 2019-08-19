From: chao@kernel.org (Chao Yu)
Date: Mon, 19 Aug 2019 22:43:25 +0800
Subject: [PATCH 2/6] staging: erofs: cannot set EROFS_V_Z_INITED_BIT if
 fill_inode_lazy fails
In-Reply-To: <20190819103426.87579-3-gaoxiang25@huawei.com>
References: <20190819080218.GA42231@138>
 <20190819103426.87579-1-gaoxiang25@huawei.com>
 <20190819103426.87579-3-gaoxiang25@huawei.com>
Message-ID: <22896e81-3474-2cc3-8023-744814f99549@kernel.org>

On 2019-8-19 18:34, Gao Xiang wrote:
> As reported by erofs-utils fuzzer, unsupported compressed
> clustersize will make fill_inode_lazy fail, for such case
> we cannot set EROFS_V_Z_INITED_BIT since we need return
> failure for each z_erofs_map_blocks_iter().
> 
> Fixes: 152a333a5895 ("staging: erofs: add compacted compression indexes support")
> Cc: <stable at vger.kernel.org> # 5.3+
> Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>

Reviewed-by: Chao Yu <yuchao0 at huawei.com>

Thanks,
