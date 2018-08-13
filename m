From: gaoxiang25@huawei.com (Gao Xiang)
Date: Mon, 13 Aug 2018 21:06:11 +0800
Subject: [PATCH] staging: erofs: add int to usigned
In-Reply-To: <20180813120913.GA19522@host.localhost>
References: <20180813120913.GA19522@host.localhost>
Message-ID: <c578c1b8-a66f-ece7-3bf9-0629d399eaaf@huawei.com>

Hi Leon,

On 2018/8/13 20:09, Leon Imhof wrote:
> Fix coding style issue "Prefer 'unsigned int' to bare use of 'unsigned'"
> detected by checkpatch.pl
> 
> Signed-off-by: Leon Imhof <leon.imhof at in.tum.de>

Looks fine,

Reviewed-by: Gao Xiang <gaoxiang25 at huawei.com>

(BTW, could you fix the title of this commit? Thanks.)

> ---
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
