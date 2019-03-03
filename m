From: hsiangkao@aol.com (Gao Xiang)
Date: Mon, 4 Mar 2019 07:20:16 +0800
Subject: [PATCH] staging: erofs: dir.c fix "alignment should match open
 parenthesis" issues
In-Reply-To: <20190303223718.31937-1-adamski.dominik@gmail.com>
References: <20190303223718.31937-1-adamski.dominik@gmail.com>
Message-ID: <2224517f-f4cd-538f-0f7c-7a5b64ea536a@aol.com>



On 2019/3/4 6:37, Dominik Adamski wrote:
> Fix checkpatch issues: "CHECK: Alignment should match open parenthesis"
> 
> Signed-off-by: Dominik Adamski <adamski.dominik at gmail.com>
> ---
>  drivers/staging/erofs/dir.c | 8 ++++----

duplicated commit...
https://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git/commit/drivers/staging/erofs/dir.c?h=staging-next&id=cbebe5d05dd7fe2fdd13cff7c4a62f22109f1f95

Thanks,
Gao Xiang

>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/staging/erofs/dir.c b/drivers/staging/erofs/dir.c
> index 833f052f79d0..e1955703ab8f 100644
> --- a/drivers/staging/erofs/dir.c
> +++ b/drivers/staging/erofs/dir.c
> @@ -24,8 +24,8 @@ static const unsigned char erofs_filetype_table[EROFS_FT_MAX] = {
>  };
>  
>  static int erofs_fill_dentries(struct dir_context *ctx,
> -	void *dentry_blk, unsigned int *ofs,
> -	unsigned int nameoff, unsigned int maxsize)
> +			       void *dentry_blk, unsigned int *ofs,
> +			       unsigned int nameoff, unsigned int maxsize)
>  {
>  	struct erofs_dirent *de = dentry_blk;
>  	const struct erofs_dirent *end = dentry_blk + nameoff;
> @@ -104,9 +104,9 @@ static int erofs_readdir(struct file *f, struct dir_context *ctx)
>  		nameoff = le16_to_cpu(de->nameoff);
>  
>  		if (unlikely(nameoff < sizeof(struct erofs_dirent) ||
> -			nameoff >= PAGE_SIZE)) {
> +			     nameoff >= PAGE_SIZE)) {
>  			errln("%s, invalid de[0].nameoff %u",
> -				__func__, nameoff);
> +			      __func__, nameoff);
>  
>  			err = -EIO;
>  			goto skip_this;
> 
