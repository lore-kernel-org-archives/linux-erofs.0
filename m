From: yuchao0@huawei.com (Chao Yu)
Date: Thu, 16 Aug 2018 15:18:45 +0800
Subject: [PATCH] staging: erofs: change 'unsigned' to 'unsigned int'
In-Reply-To: <20180813151950.GA22144@host.localhost>
References: <20180813151950.GA22144@host.localhost>
Message-ID: <d56776c6-583d-e640-4ec4-30b43620dd9d@huawei.com>

On 2018/8/13 23:20, Leon Imhof wrote:
> Fix coding style issue "Prefer 'unsigned int' to bare use of 'unsigned'"
> detected by checkpatch.pl
> 
> Signed-off-by: Leon Imhof <leon.imhof at in.tum.de>

Reviewed-by: Chao Yu <yuchao0 at huawei.com>

> ---

It would be better to indicate this patch is v2 one here and in subject-prefix.

Thanks,

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
