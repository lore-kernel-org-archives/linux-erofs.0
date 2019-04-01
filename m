From: gregkh@linuxfoundation.org (Greg Kroah-Hartman)
Date: Mon, 1 Apr 2019 13:40:40 +0200
Subject: [PATCH for-4.19 1/2] staging: erofs: fix error handling when
 failed to read compresssed data
In-Reply-To: <20190401065309.68109-1-gaoxiang25@huawei.com>
References: <20190401065309.68109-1-gaoxiang25@huawei.com>
Message-ID: <20190401114040.GC8156@kroah.com>

On Mon, Apr 01, 2019@02:53:08PM +0800, Gao Xiang wrote:
> commit b6391ac73400eff38377a4a7364bd3df5efb5178 upstream.
> 
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
> Reviewed-by: Chao Yu <yuchao0 at huawei.com>
> Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>
> ---
> This series resolves the following conflicts:
> FAILED: patch "[PATCH] staging: erofs: fix error handling when failed to read" failed to apply to 4.19-stable tree
> FAILED: patch "[PATCH] staging: erofs: keep corrupted fs from crashing kernel in" failed to apply to 4.19-stable tree

Thanks for both of these, now queued up.

greg k-h
