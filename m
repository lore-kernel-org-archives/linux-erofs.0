From: hsiangkao@aol.com (Gao Xiang)
Date: Tue, 14 Aug 2018 00:01:12 +0800
Subject: [PATCH] staging: erofs: change 'unsigned' to 'unsigned int'
In-Reply-To: <20180813151950.GA22144@host.localhost>
References: <20180813151950.GA22144@host.localhost>
Message-ID: <b3b5b35b-8074-958b-28aa-a868536d5a95@aol.com>

Hi Leon,

On 2018/8/13 23:20, Leon Imhof wrote:
> Fix coding style issue "Prefer 'unsigned int' to bare use of 'unsigned'"
> detected by checkpatch.pl
> 
> Signed-off-by: Leon Imhof <leon.imhof at in.tum.de>
> ---

Thanks for the patch, could be better if use `[PATCH v2]' to indicate
that you send a new version of `[PATCH] staging: erofs: add int to usigned'.

Reviewed-by: Gao Xiang <gaoxiang25 at huawei.com>

Thanks,
Gao Xiang

>  drivers/staging/erofs/data.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/staging/erofs/data.c b/drivers/staging/erofs/data.c
> index ac263a180253..2a401216007a 100644
> --- a/drivers/staging/erofs/data.c
> +++ b/drivers/staging/erofs/data.c
> @@ -337,7 +337,7 @@ static int erofs_raw_access_readpage(struct file *file, struct page *page)
>  
>  static int erofs_raw_access_readpages(struct file *filp,
>  	struct address_space *mapping,
> -	struct list_head *pages, unsigned nr_pages)
> +	struct list_head *pages, unsigned int nr_pages)
>  {
>  	erofs_off_t last_block;
>  	struct bio *bio = NULL;
> 
