From: gaoxiang25@huawei.com (Gao Xiang)
Date: Tue, 13 Nov 2018 08:02:40 +0800
Subject: [PATCH 2/3] staging: erofs: unzip_vle.c: Constant in comparison
 on right side
In-Reply-To: <1542055439-24444-3-git-send-email-sicilia.cristian@gmail.com>
References: <1542055439-24444-1-git-send-email-sicilia.cristian@gmail.com>
 <1542055439-24444-3-git-send-email-sicilia.cristian@gmail.com>
Message-ID: <8e50cc41-5204-c64c-9b63-964e16334622@huawei.com>



On 2018/11/13 4:43, Cristian Sicilia wrote:
> Comparisons should place the constant
> on the right side of the test.
> 
> Signed-off-by: Cristian Sicilia <sicilia.cristian at gmail.com>

Reviewed-by: Gao Xiang <gaoxiang25 at huawei.com>

Thanks,
Gao Xiang

> ---
>  drivers/staging/erofs/unzip_vle.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/staging/erofs/unzip_vle.c b/drivers/staging/erofs/unzip_vle.c
> index 1ffeeaa..35add4e 100644
> --- a/drivers/staging/erofs/unzip_vle.c
> +++ b/drivers/staging/erofs/unzip_vle.c
> @@ -250,8 +250,8 @@ static inline bool try_to_claim_workgroup(
>  retry:
>  	if (grp->next == Z_EROFS_VLE_WORKGRP_NIL) {
>  		/* type 1, nil workgroup */
> -		if (Z_EROFS_VLE_WORKGRP_NIL != cmpxchg(&grp->next,
> -			Z_EROFS_VLE_WORKGRP_NIL, *owned_head))
> +		if (cmpxchg(&grp->next, Z_EROFS_VLE_WORKGRP_NIL,
> +			    *owned_head) != Z_EROFS_VLE_WORKGRP_NIL)
>  			goto retry;
>  
>  		*owned_head = grp;
> @@ -262,8 +262,8 @@ static inline bool try_to_claim_workgroup(
>  		 * be careful that its submission itself is governed
>  		 * by the original owned chain.
>  		 */
> -		if (Z_EROFS_VLE_WORKGRP_TAIL != cmpxchg(&grp->next,
> -			Z_EROFS_VLE_WORKGRP_TAIL, *owned_head))
> +		if (cmpxchg(&grp->next, Z_EROFS_VLE_WORKGRP_TAIL,
> +			    *owned_head) != Z_EROFS_VLE_WORKGRP_TAIL)
>  			goto retry;
>  
>  		*owned_head = Z_EROFS_VLE_WORKGRP_TAIL;
> 
