From: gongchen4@huawei.com (gongchen)
Date: Wed, 7 Nov 2018 10:19:05 +0800
Subject: [PATCH] staging: erofs: fix `trace_erofs_readpage' position
In-Reply-To: <20181019132446.19982-1-gaoxiang25@huawei.com>
References: <20181019132446.19982-1-gaoxiang25@huawei.com>
Message-ID: <3e53b184-8874-5351-15dd-fd7470419039@huawei.com>

On 2018/10/19 21:24, Gao Xiang wrote:
> `trace_erofs_readpage' should be placed in .readpage()
> rather than in the internal `z_erofs_do_read_page'.
> 
> Fixes: 284db12cfda3 ("staging: erofs: add trace points for reading zipped data")
> Cc: Chen Gong <gongchen4 at huawei.com>
> Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>

  Reviewed-by: Chen Gong <gongchen4 at huawei.com>

> ---
>  drivers/staging/erofs/unzip_vle.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/staging/erofs/unzip_vle.c b/drivers/staging/erofs/unzip_vle.c
> index 79d3ba62b298..94ceb391f607 100644
> --- a/drivers/staging/erofs/unzip_vle.c
> +++ b/drivers/staging/erofs/unzip_vle.c
> @@ -597,8 +597,6 @@ static int z_erofs_do_read_page(struct z_erofs_vle_frontend *fe,
>  	unsigned int cur, end, spiltted, index;
>  	int err = 0;
>  
> -	trace_erofs_readpage(page, false);
> -
>  	/* register locked file pages as online pages in pack */
>  	z_erofs_onlinepage_init(page);
>  
> @@ -1287,6 +1285,8 @@ static int z_erofs_vle_normalaccess_readpage(struct file *file,
>  	int err;
>  	LIST_HEAD(pagepool);
>  
> +	trace_erofs_readpage(page, false);
> +
>  #if (EROFS_FS_ZIP_CACHE_LVL >= 2)
>  	f.cachedzone_la = (erofs_off_t)page->index << PAGE_SHIFT;
>  #endif
> 
