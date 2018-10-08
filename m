From: gustavo@embeddedor.com (Gustavo A. R. Silva)
Date: Mon, 8 Oct 2018 14:36:32 +0200
Subject: [PATCH] staging: erofs: adds a space around '*'
In-Reply-To: <20181008114518.GA2475@AD01277334>
References: <20181008114518.GA2475@AD01277334>
Message-ID: <61b485f4-539b-0f25-cf3d-574ebb17197c@embeddedor.com>

Hi,

On 10/8/18 1:45 PM, Daeseok Youn wrote:
> fix checkpatch.pl error:
> ERROR: need consistent spacing around '*' (ctx:WxV)
> +                       memcpy(vin + PAGE_SIZE *i, t, PAGE_SIZE);
> 
> Signed-off-by: Daeseok Youn <daeseok.youn at gmail.com>
> ---
>  drivers/staging/erofs/unzip_vle_lz4.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/staging/erofs/unzip_vle_lz4.c b/drivers/staging/erofs/unzip_vle_lz4.c
> index f5b665f..501cfe0 100644
> --- a/drivers/staging/erofs/unzip_vle_lz4.c
> +++ b/drivers/staging/erofs/unzip_vle_lz4.c
> @@ -181,7 +181,7 @@ int z_erofs_vle_unzip_vmap(struct page **compressed_pages,
>  		for (i = 0; i < clusterpages; ++i) {
>  			void *t = kmap_atomic(compressed_pages[i]);
>  
> -			memcpy(vin + PAGE_SIZE *i, t, PAGE_SIZE);
> +			memcpy(vin + PAGE_SIZE * i, t, PAGE_SIZE);
>  			kunmap_atomic(t);
>  		}
>  	} else if (clusterpages == 1)
> 

This exact fix was applied to linux-next some days ago:

commit ea0b2d429bd82ec152d286a0c026ebcaa4154ccc

Make sure you are working from linux-next rather than from mainline.

See this link: https://www.kernel.org/doc/man-pages/linux-next.html

Thanks
--
Gustavo
