From: chao@kernel.org (Chao Yu)
Date: Mon, 19 Aug 2019 22:57:42 +0800
Subject: [PATCH 5/6] staging: erofs: detect potential multiref due to
 corrupted images
In-Reply-To: <20190819103426.87579-6-gaoxiang25@huawei.com>
References: <20190819080218.GA42231@138>
 <20190819103426.87579-1-gaoxiang25@huawei.com>
 <20190819103426.87579-6-gaoxiang25@huawei.com>
Message-ID: <f302710e-0c7f-8695-d692-be0c01c431ea@kernel.org>

On 2019-8-19 18:34, Gao Xiang wrote:
> As reported by erofs-utils fuzzer, currently, multiref
> (ondisk deduplication) hasn't been supported for now,
> we should forbid it properly.
> 
> Fixes: 3883a79abd02 ("staging: erofs: introduce VLE decompression support")
> Cc: <stable at vger.kernel.org> # 4.19+
> Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>
> ---
>  drivers/staging/erofs/zdata.c | 16 ++++++++++++++--
>  1 file changed, 14 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/staging/erofs/zdata.c b/drivers/staging/erofs/zdata.c
> index aae2f2b8353f..5b6fef5181af 100644
> --- a/drivers/staging/erofs/zdata.c
> +++ b/drivers/staging/erofs/zdata.c
> @@ -816,8 +816,16 @@ static int z_erofs_decompress_pcluster(struct super_block *sb,
>  			pagenr = z_erofs_onlinepage_index(page);
>  
>  		DBG_BUGON(pagenr >= nr_pages);
> -		DBG_BUGON(pages[pagenr]);
>  
> +		/*
> +		 * currently EROFS doesn't support multiref(dedup),
> +		 * so here erroring out one multiref page.
> +		 */
> +		if (unlikely(pages[pagenr])) {
> +			DBG_BUGON(1);
> +			SetPageError(pages[pagenr]);
> +			z_erofs_onlinepage_endio(pages[pagenr]);

Should set err meanwhile?

> +		}
>  		pages[pagenr] = page;
>  	}
>  	z_erofs_pagevec_ctor_exit(&ctor, true);
> @@ -849,7 +857,11 @@ static int z_erofs_decompress_pcluster(struct super_block *sb,
>  			pagenr = z_erofs_onlinepage_index(page);
>  
>  			DBG_BUGON(pagenr >= nr_pages);
> -			DBG_BUGON(pages[pagenr]);
> +			if (unlikely(pages[pagenr])) {
> +				DBG_BUGON(1);
> +				SetPageError(pages[pagenr]);
> +				z_erofs_onlinepage_endio(pages[pagenr]);
> +			}
>  			pages[pagenr] = page;
>  
>  			overlapped = true;
> 
