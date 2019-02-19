From: gaoxiang25@huawei.com (Gao Xiang)
Date: Tue, 19 Feb 2019 18:24:24 +0800
Subject: [Outreachy Kernel][PATCH v2] staging: erofs: match alignment with
 open parentheses
In-Reply-To: <20190219092525.GA4474@bhanusree-MacBookAir>
References: <20190219092525.GA4474@bhanusree-MacBookAir>
Message-ID: <881c9fe8-7273-c5e3-32b4-b2947b978ffa@huawei.com>

[+cc linux-erofs and staging mailing list]

On 2019/2/19 17:25, Bhanusree Pola wrote:
> Align code with open parantheses to improve the readability.
> Issue found using checkpatch.pl
> 
> Signed-off-by: Bhanusree Pola <bhanusreemahesh at gmail.com>

Reviewed-by: Gao Xiang <gaoxiang25 at huawei.com>

Thanks,
Gao Xiang

> ---
> 
> v2: -modified log message
>     -corrected spelling in subject line
> 
> drivers/staging/erofs/dir.c | 8 ++++----
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
