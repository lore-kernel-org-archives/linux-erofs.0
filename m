From: hsiangkao@aol.com (Gao Xiang)
Date: Sun, 19 May 2019 16:24:25 +0800
Subject: [PATCH] staging: erofs: fix Warning Use BUG_ON instead of if
 condition followed by BUG
In-Reply-To: <20190518173331.GA1069@hari-Inspiron-1545>
References: <20190518173331.GA1069@hari-Inspiron-1545>
Message-ID: <7b074b9d-04f9-781b-4ea3-1a1017eceb38@aol.com>

Hi Hariprasad,

On 2019/5/19 ??1:33, Hariprasad Kelam wrote:
> fix below warning reported by  coccicheck
> 
> drivers/staging/erofs/unzip_pagevec.h:74:2-5: WARNING: Use BUG_ON
> instead of if condition followed by BUG.
> 
> Signed-off-by: Hariprasad Kelam <hariprasad.kelam at gmail.com>
> ---
>  drivers/staging/erofs/unzip_pagevec.h | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/drivers/staging/erofs/unzip_pagevec.h b/drivers/staging/erofs/unzip_pagevec.h
> index f37d8fd..0f61c54 100644
> --- a/drivers/staging/erofs/unzip_pagevec.h
> +++ b/drivers/staging/erofs/unzip_pagevec.h
> @@ -70,8 +70,7 @@ z_erofs_pagevec_ctor_next_page(struct z_erofs_pagevec_ctor *ctor,
>  			return tagptr_unfold_ptr(t);
>  	}
>  
> -	if (unlikely(nr >= ctor->nr))
> -		BUG();
> +	BUG_ON(nr >= ctor->nr);

Thanks for your report. I suggest to use DBG_BUGON for this case, let me
send another version for this case.

Thanks,
Gao Xiang

>  
>  	return NULL;
>  }
> 
