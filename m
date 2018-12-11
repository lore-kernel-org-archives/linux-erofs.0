From: gaoxiang25@huawei.com (Gao Xiang)
Date: Tue, 11 Dec 2018 19:19:28 +0800
Subject: [PATCH 1/5] drivers: staging: erofs: Fix alignment.
In-Reply-To: <20181211105443.21826-2-aaron.strahlberger@posteo.de>
References: <0ed9f3e7-9081-4a8a-06b0-e5ad14e2c872@huawei.com>
 <20181211105443.21826-1-aaron.strahlberger@posteo.de>
 <20181211105443.21826-2-aaron.strahlberger@posteo.de>
Message-ID: <cea109b4-b4df-aa9b-2d52-e8eca6b00e4c@huawei.com>

Hi Aaron,

On 2018/12/11 18:54, Aaron Strahlberger wrote:
> Fix of 17 `CHECK: Alignment should match open parenthesis` checkpatch.pl
> issues.
> 
> Signed-off-by: Aaron Strahlberger <aaron.strahlberger at posteo.de>
> Signed-off-by: Julius Wiedmann <julius.wiedmann at fau.de>
> Signed-off-by: Dominik Huber <domi250 at gmx.de>
> 
> LocalWords:  Alighnment

What's this?

> ---
>  drivers/staging/erofs/data.c | 42 ++++++++++++++++++------------------
>  drivers/staging/erofs/dir.c  |  8 +++----
>  2 files changed, 25 insertions(+), 25 deletions(-)
> 
> diff --git a/drivers/staging/erofs/data.c b/drivers/staging/erofs/data.c
> index 6384f73e5418..d1c0a7be6eb8 100644
> --- a/drivers/staging/erofs/data.c
> +++ b/drivers/staging/erofs/data.c
> @@ -40,7 +40,7 @@ static inline void read_endio(struct bio *bio)
>  
>  /* prio -- true is used for dir */
>  struct page *__erofs_get_meta_page(struct super_block *sb,
> -	erofs_blk_t blkaddr, bool prio, bool nofail)
> +				   erofs_blk_t blkaddr, bool prio, bool nofail)
> 

It seems your styling fix of data.c has been fixed in the latest staging-tree for a month,
could you have some time to take a look at the Greg's staging-tree again?

https://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git/tree/drivers/staging/erofs/data.c?h=staging-next#n42

...

> diff --git a/drivers/staging/erofs/dir.c b/drivers/staging/erofs/dir.c
> index d1cb0d78ab84..49a4e7730df0 100644
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
> @@ -101,9 +101,9 @@ static int erofs_readdir(struct file *f, struct dir_context *ctx)
>  		nameoff = le16_to_cpu(de->nameoff);
>  
>  		if (unlikely(nameoff < sizeof(struct erofs_dirent) ||
> -			nameoff >= PAGE_SIZE)) {
> +			     nameoff >= PAGE_SIZE)) {
>  			errln("%s, invalid de[0].nameoff %u",
> -				__func__, nameoff);
> +			      __func__, nameoff);

Here is the only valid modification after I use "git am -k -3" to apply this on the latest staging tree...

Thanks,
Gao Xiang

>  
>  			err = -EIO;
>  			goto skip_this;
> -- 2.19.2
