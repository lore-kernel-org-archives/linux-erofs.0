From: dan.carpenter@oracle.com (Dan Carpenter)
Date: Fri, 25 Jan 2019 16:26:14 +0300
Subject: [PATCH 1/2] staging: erofs: use xattr_prefix to wrap up
In-Reply-To: <20190125115103.47250-1-gaoxiang25@huawei.com>
References: <20190125115103.47250-1-gaoxiang25@huawei.com>
Message-ID: <20190125132614.GB1795@kadam>

On Fri, Jan 25, 2019@07:51:03PM +0800, Gao Xiang wrote:
> Let's use xattr_prefix instead of open code.
> No logic changes.
> 
> Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>
> ---
>  drivers/staging/erofs/xattr.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/staging/erofs/xattr.c b/drivers/staging/erofs/xattr.c
> index 1c9498e38f0e..eca65df46133 100644
> --- a/drivers/staging/erofs/xattr.c
> +++ b/drivers/staging/erofs/xattr.c
> @@ -521,7 +521,7 @@ static int xattr_entrylist(struct xattr_iter *_it,
>  		return 1;
>  
>  	/* Note that at least one of 'prefix' and 'name' should be non-NULL */

The comment is sort of confusing now.

> -	prefix = h->prefix != NULL ? h->prefix : h->name;
> +	prefix = xattr_prefix(h);
>  	prefix_len = strlen(prefix);

regards,
dan carpenter
