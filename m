From: hsiangkao@aol.com (Gao Xiang)
Date: Sun, 19 May 2019 17:50:40 +0800
Subject: [Patch v2] staging: erofs: fix Warning Use BUG_ON instead of if
 condition followed by BUG
In-Reply-To: <20190519093440.GA16838@hari-Inspiron-1545>
References: <20190519093440.GA16838@hari-Inspiron-1545>
Message-ID: <b32e6bca-60ec-2004-f1d6-16d2b8a478ae@aol.com>



On 2019/5/19 ??5:34, Hariprasad Kelam wrote:
> fix below warning reported by  coccicheck
> 
> drivers/staging/erofs/unzip_pagevec.h:74:2-5: WARNING: Use BUG_ON
> instead of if condition followed by BUG.
> 
> Signed-off-by: Hariprasad Kelam <hariprasad.kelam at gmail.com>
> -----
> Changes in v2:
>   - replace BUG_ON with  DBG_BUGON
> -----
> ---
>  drivers/staging/erofs/unzip_pagevec.h | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/drivers/staging/erofs/unzip_pagevec.h b/drivers/staging/erofs/unzip_pagevec.h
> index f37d8fd..7938ee3 100644
> --- a/drivers/staging/erofs/unzip_pagevec.h
> +++ b/drivers/staging/erofs/unzip_pagevec.h
> @@ -70,8 +70,7 @@ z_erofs_pagevec_ctor_next_page(struct z_erofs_pagevec_ctor *ctor,
>  			return tagptr_unfold_ptr(t);
>  	}
>  

I'd like to delete this line

> -	if (unlikely(nr >= ctor->nr))
> -		BUG();
> +	DBG_BUGON(nr >= ctor->nr);
>  

and this line.. I have already sent a new patch based on your v1 patch,
could you please check it out if it is acceptable for you? :)

Thanks,
Gao Xiang

>  	return NULL;
>  }
> 
