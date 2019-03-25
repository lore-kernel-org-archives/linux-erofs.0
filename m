From: yuchao0@huawei.com (Chao Yu)
Date: Mon, 25 Mar 2019 09:45:30 +0800
Subject: [PATCH 1/3] staging: erofs: fix error handling when failed to
 read compresssed data
In-Reply-To: <20190319135501.28712-1-gaoxiang25@huawei.com>
References: <20190319135501.28712-1-gaoxiang25@huawei.com>
Message-ID: <6bd02972-7b0b-21e9-7029-ea9dd4b7a048@huawei.com>

On 2019/3/19 21:54, Gao Xiang wrote:
> Complete read error handling paths for all three kinds of
> compressed pages:
> 
>  1) For cache-managed pages, PG_uptodate will be checked since
>     read_endio will unlock and SetPageUptodate for these pages;
> 
>  2) For inplaced pages, read_endio cannot SetPageUptodate directly
>     since it should be used to mark the final decompressed data,
>     PG_error will be set with page locked for IO error instead;
> 
>  3) For staging pages, PG_error is used, which is similar to
>     what we do for inplaced pages.
> 
> Fixes: 3883a79abd02 ("staging: erofs: introduce VLE decompression support")
> Cc: <stable at vger.kernel.org> # 4.19+
> Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>

Reviewed-by: Chao Yu <yuchao0 at huawei.com>

Thanks,
