From: hsiangkao@aol.com (Gao Xiang)
Date: Thu, 11 Oct 2018 07:09:43 +0800
Subject: [PATCH] clean erofs_lookup()
In-Reply-To: <20181010190116.GG32577@ZenIV.linux.org.uk>
References: <20181010190116.GG32577@ZenIV.linux.org.uk>
Message-ID: <a267e4b0-887e-6de9-38db-7ca9a5518b72@aol.com>

Hi Alexander,

On 2018/10/11 3:01, Al Viro wrote:
> 	d_splice_alias() does the right thing when given
> ERR_PTR(-E...) for inode.  No need for gotos, multiple
> returns, etc. in there.

That is correct :) Thanks for your patch and attention.

Once in the first version we used "d_add" rather than "d_splice_alias"
because I think no need to support disconnect dentries / export in the near future.

But We changed into "d_splice_alias" later, however it seems more redundant logics there...

Reviewed-by: Gao Xiang <gaoxiang25 at huawei.com>

Thanks,
Gao Xiang

> 
> Signed-off-by: Al Viro <viro at zeniv.linux.org.uk>
> ---
> diff --git a/drivers/staging/erofs/namei.c b/drivers/staging/erofs/namei.c
> index 546a47156101..8cf0617d4ea0 100644
> --- a/drivers/staging/erofs/namei.c
> +++ b/drivers/staging/erofs/namei.c
> @@ -223,18 +223,13 @@ static struct dentry *erofs_lookup(struct inode *dir,
>  	if (err == -ENOENT) {
>  		/* negative dentry */
>  		inode = NULL;
> -		goto negative_out;
> -	} else if (unlikely(err))
> -		return ERR_PTR(err);
> -
> -	debugln("%s, %s (nid %llu) found, d_type %u", __func__,
> -		dentry->d_name.name, nid, d_type);
> -
> -	inode = erofs_iget(dir->i_sb, nid, d_type == EROFS_FT_DIR);
> -	if (IS_ERR(inode))
> -		return ERR_CAST(inode);
> -
> -negative_out:
> +	} else if (unlikely(err)) {
> +		inode = ERR_PTR(err);
> +	} else {
> +		debugln("%s, %s (nid %llu) found, d_type %u", __func__,
> +			dentry->d_name.name, nid, d_type);
> +		inode = erofs_iget(dir->i_sb, nid, d_type == EROFS_FT_DIR);
> +	}
>  	return d_splice_alias(inode, dentry);
>  }
>  
> 
