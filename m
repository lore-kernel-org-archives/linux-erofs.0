From: gaoxiang25@huawei.com (Gao Xiang)
Date: Mon, 5 Nov 2018 13:30:11 +0800
Subject: [PATCH v2 2/2] staging: erofs: Modify Alignment
In-Reply-To: <ab1426b48b16317bd787f0f15dbd9ffaaacf6c72.1541394756.git.digholebhagyashri@example.com>
References: <3db6ea6f3a7b1fab94e5dacc1ec4a026e38548c2.1541394756.git.digholebhagyashri@example.com>
 <ab1426b48b16317bd787f0f15dbd9ffaaacf6c72.1541394756.git.digholebhagyashri@example.com>
Message-ID: <16a42518-c147-e368-2232-15c3cb110093@huawei.com>

Hi Bhagyashri,

On 2018/11/5 13:14, Bhagyashri P. Dighole wrote:
> Found alignment issue using checkpatch.
> Matched alignment with parenthesis of page struct.
> 
> Signed-off-by: Bhagyashri P. Dighole <digholebhagyashri at gmail.com>
> ---
>  drivers/staging/erofs/data.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/staging/erofs/data.c b/drivers/staging/erofs/data.c
> index a671ad4..a62be35 100644
> --- a/drivers/staging/erofs/data.c
> +++ b/drivers/staging/erofs/data.c
> @@ -40,7 +40,7 @@ static inline void read_endio(struct bio *bio)
>  
>  /* prio -- true is used for dir */
>  struct page *__erofs_get_meta_page(struct super_block *sb,
> -	erofs_blk_t blkaddr, bool prio, bool nofail)
> +				   erofs_blk_t blkaddr, bool prio, bool nofail)
>  {
>  	struct inode *const bd_inode = sb->s_bdev->bd_inode;
>  	struct address_space *const mapping = bd_inode->i_mapping;
> -- 2.7.4

Ditto, the similar case as I mentioned in the previous commit
"staging: erofs: Modify conditional check"...Could you please fix them all
(at least in the per-file range)?

Thanks,
Gao Xiang
