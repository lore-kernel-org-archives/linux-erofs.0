From: gaoxiang25@huawei.com (Gao Xiang)
Date: Fri, 22 Mar 2019 11:25:31 +0800
Subject: [PATCH 1/3] staging: erofs: fix error handling when failed to
 read compresssed data
In-Reply-To: <20190319135501.28712-1-gaoxiang25@huawei.com>
References: <20190319135501.28712-1-gaoxiang25@huawei.com>
Message-ID: <8966fa2c-5357-c472-ebb7-a3f3abcf60e8@huawei.com>

ping?

Hi Chao,
could you take some time looking into this series?

Thanks,
Gao Xiang

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
> ---
> 
> This series focus on fixing error handling when failed to read
> compresssed data due to previous incomplete paths.
> 
> In addition, the last 2 patches add IO error fault injection
> for reading paths, which I have used to test the first patch as well.
> 
> Thanks,
> Gao Xiang
> 
>  drivers/staging/erofs/unzip_vle.c | 41 ++++++++++++++++++++++++++-------------
>  1 file changed, 28 insertions(+), 13 deletions(-)
> 
> diff --git a/drivers/staging/erofs/unzip_vle.c b/drivers/staging/erofs/unzip_vle.c
> index 8715bc50e09c..3416d3f10324 100644
> --- a/drivers/staging/erofs/unzip_vle.c
> +++ b/drivers/staging/erofs/unzip_vle.c
> @@ -972,6 +972,7 @@ static int z_erofs_vle_unzip(struct super_block *sb,
>  	overlapped = false;
>  	compressed_pages = grp->compressed_pages;
>  
> +	err = 0;
>  	for (i = 0; i < clusterpages; ++i) {
>  		unsigned int pagenr;
>  
> @@ -981,26 +982,39 @@ static int z_erofs_vle_unzip(struct super_block *sb,
>  		DBG_BUGON(!page);
>  		DBG_BUGON(!page->mapping);
>  
> -		if (z_erofs_is_stagingpage(page))
> -			continue;
> +		if (!z_erofs_is_stagingpage(page)) {
>  #ifdef EROFS_FS_HAS_MANAGED_CACHE
> -		if (page->mapping == MNGD_MAPPING(sbi)) {
> -			DBG_BUGON(!PageUptodate(page));
> -			continue;
> -		}
> +			if (page->mapping == MNGD_MAPPING(sbi)) {
> +				if (unlikely(!PageUptodate(page)))
> +					err = -EIO;
> +				continue;
> +			}
>  #endif
>  
> -		/* only non-head page could be reused as a compressed page */
> -		pagenr = z_erofs_onlinepage_index(page);
> +			/*
> +			 * only if non-head page can be selected
> +			 * for inplace decompression
> +			 */
> +			pagenr = z_erofs_onlinepage_index(page);
>  
> -		DBG_BUGON(pagenr >= nr_pages);
> -		DBG_BUGON(pages[pagenr]);
> -		++sparsemem_pages;
> -		pages[pagenr] = page;
> +			DBG_BUGON(pagenr >= nr_pages);
> +			DBG_BUGON(pages[pagenr]);
> +			++sparsemem_pages;
> +			pages[pagenr] = page;
> +
> +			overlapped = true;
> +		}
>  
> -		overlapped = true;
> +		/* PG_error needs checking for inplaced and staging pages */
> +		if (unlikely(PageError(page))) {
> +			DBG_BUGON(PageUptodate(page));
> +			err = -EIO;
> +		}
>  	}
>  
> +	if (unlikely(err))
> +		goto out;
> +
>  	llen = (nr_pages << PAGE_SHIFT) - work->pageofs;
>  
>  	if (z_erofs_vle_workgrp_fmt(grp) == Z_EROFS_VLE_WORKGRP_FMT_PLAIN) {
> @@ -1194,6 +1208,7 @@ pickup_page_for_submission(struct z_erofs_vle_workgroup *grp,
>  	if (page->mapping == mc) {
>  		WRITE_ONCE(grp->compressed_pages[nr], page);
>  
> +		ClearPageError(page);
>  		if (!PagePrivate(page)) {
>  			/*
>  			 * impossible to be !PagePrivate(page) for
> 
