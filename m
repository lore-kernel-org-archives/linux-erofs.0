From: yuchao0@huawei.com (Chao Yu)
Date: Fri, 12 Apr 2019 17:28:39 +0800
Subject: [PATCH] staging: erofs: fix unexpected out-of-bound data access
In-Reply-To: <20190411105555.133551-1-gaoxiang25@huawei.com>
References: <20190411105555.133551-1-gaoxiang25@huawei.com>
Message-ID: <0332f6b3-9705-50d2-6e1e-639d3e8e915f@huawei.com>

On 2019/4/11 18:55, Gao Xiang wrote:
> Unexpected out-of-bound data will be read in erofs_read_raw_page
> after commit 07173c3ec276 ("block: enable multipage bvecs") since
> one iovec could have multiple pages.
> 
> Let's fix as what Ming's pointed out in the previous email.

It will be better to add link address of discussion thread in your commit
message, since discussion includes more details about how this issue happens.

> 
> Suggested-by: Ming Lei <ming.lei at redhat.com>
> Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>

Reviewed-by: Chao Yu <yuchao0 at huawei.com>

Thanks,

> ---
> 
> It should be fixed from linux-5.1-rc after multi-page bvec feature.
> 
> Thanks,
> Gao Xiang
> 
>  drivers/staging/erofs/data.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/staging/erofs/data.c b/drivers/staging/erofs/data.c
> index 0714061ba888..c64ec76643d4 100644
> --- a/drivers/staging/erofs/data.c
> +++ b/drivers/staging/erofs/data.c
> @@ -304,7 +304,7 @@ static inline struct bio *erofs_read_raw_page(struct bio *bio,
>  	*last_block = current_block;
>  
>  	/* shift in advance in case of it followed by too many gaps */
> -	if (unlikely(bio->bi_vcnt >= bio->bi_max_vecs)) {
> +	if (bio->bi_iter.bi_size >= bio->bi_max_vecs * PAGE_SIZE) {
>  		/* err should reassign to 0 after submitting */
>  		err = 0;
>  		goto submit_bio_out;
> 
