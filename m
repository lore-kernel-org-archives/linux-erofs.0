From: hsiangkao@aol.com (Gao Xiang)
Date: Sun, 10 Mar 2019 15:55:36 +0800
Subject: [PATCH] staging: erofs: add a new line after variable declaration
In-Reply-To: <20190309170853.8297-1-juliobianco@gmail.com>
References: <20190309170853.8297-1-juliobianco@gmail.com>
Message-ID: <cc0fd3b6-ef6d-e588-aa66-a93002fd589e@aol.com>

Hi Julio,

On 2019/3/10 1:08, Julio Bianco wrote:
> Add a new line after variable declaration
>
> Signed-off-by: Julio Bianco <juliobianco at gmail.com>

There is the only place in erofs for this issue?
Could you check and please fix them all if you have some time?

Thanks,
Gao Xiang

> ---
>  drivers/staging/erofs/inode.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/drivers/staging/erofs/inode.c b/drivers/staging/erofs/inode.c
> index 924b8dfc7a8f..1cf1afe2d73a 100644
> --- a/drivers/staging/erofs/inode.c
> +++ b/drivers/staging/erofs/inode.c
> @@ -270,6 +270,7 @@ struct inode *erofs_iget(struct super_block *sb,
>  	if (inode->i_state & I_NEW) {
>  		int err;
>  		struct erofs_vnode *vi = EROFS_V(inode);
> +
>  		vi->nid = nid;
>  
>  		err = fill_inode(inode, isdir);
