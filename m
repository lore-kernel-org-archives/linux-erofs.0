From: hsiangkao@aol.com (Gao Xiang)
Date: Fri, 12 Apr 2019 23:35:08 +0800
Subject: [PATCH] staging: erofs: fix unexpected out-of-bound data access
In-Reply-To: <20190412150633.GA20776@infradead.org>
References: <20190411105555.133551-1-gaoxiang25@huawei.com>
 <20190412150633.GA20776@infradead.org>
Message-ID: <a34cb628-ca2f-0497-2a51-5d1ddf318650@aol.com>

Hi Christoph,

On 2019/4/12 23:06, Christoph Hellwig wrote:
>> +++ b/drivers/staging/erofs/data.c
>> @@ -304,7 +304,7 @@ static inline struct bio *erofs_read_raw_page(struct bio *bio,
>>  	*last_block = current_block;
>>  
>>  	/* shift in advance in case of it followed by too many gaps */
>> -	if (unlikely(bio->bi_vcnt >= bio->bi_max_vecs)) {
>> +	if (bio->bi_iter.bi_size >= bio->bi_max_vecs * PAGE_SIZE) {
> 
> This is still a very odd check.  bi_max_vecs * PAGE_SIZE is rather
> arbitrary? and more importantly bi_max_vecs is not really a public
> field, in fact this is the only place every using it outside the
> core block layer.
> 
> I think the logic in this function should be reworked to what we
> do elsewhere in the kernel, that is just add to the bio until
> bio_add_page fails, in which case you submit the bio and start
> a new one.  Then once you are done with your operation just submit
> the bio.  Which unless I'm missing something is what the code does,
> except for the goto loop obsfucation that is trying to hide it.
> 
> So why not something like:
> 
> 
> diff --git a/drivers/staging/erofs/data.c b/drivers/staging/erofs/data.c
> index 0714061ba888..122714e19079 100644
> --- a/drivers/staging/erofs/data.c
> +++ b/drivers/staging/erofs/data.c
> @@ -296,20 +296,9 @@ static inline struct bio *erofs_read_raw_page(struct bio *bio,
>  		}
>  	}
>  
> -	err = bio_add_page(bio, page, PAGE_SIZE, 0);
> -	/* out of the extent or bio is full */
> -	if (err < PAGE_SIZE)
> +	if (bio_add_page(bio, page, PAGE_SIZE, 0) != PAGE_SIZE)
>  		goto submit_bio_retry;

Thanks for your kindly reply. I think it doesn't work for the current logic
since nblocks also indicates the block(page) distance of end of map_blocks
bound (see my explanation in the email [1])...

[1] https://lore.kernel.org/lkml/cb392476-a00e-09ce-fa6b-9e088242ecc6 at huawei.com/

and
 nblocks = min(distance to the end of mapping, nr of remaining pages to read, BIO_MAX_PAGES)
 bio->bi_max_vecs = nblocks (which is the worst case if pages cannot be merged)
 

Currently I think a patch is needed to fix for linux-5.1, iomap is in consideration
as well months ago [2]. However it needs to be done later and with some careful tests.

[2] https://lore.kernel.org/lkml/c742194d-4207-e7b9-b679-c1f207961f17 at huawei.com/

So I think let's fix it as it is in linux-5.1, and I will turn into iomap in my free time.

Thanks,
Gao Xiang

> -
>  	*last_block = current_block;
> -
> -	/* shift in advance in case of it followed by too many gaps */
> -	if (unlikely(bio->bi_vcnt >= bio->bi_max_vecs)) {
> -		/* err should reassign to 0 after submitting */
> -		err = 0;
> -		goto submit_bio_out;
> -	}
> -
>  	return bio;
>  
>  err_out:
> @@ -323,9 +312,7 @@ static inline struct bio *erofs_read_raw_page(struct bio *bio,
>  
>  	/* if updated manually, continuous pages has a gap */
>  	if (bio)
> -submit_bio_out:
>  		__submit_bio(bio, REQ_OP_READ, 0);
> -
>  	return unlikely(err) ? ERR_PTR(err) : NULL;
>  }
>  
> @@ -387,8 +374,7 @@ static int erofs_raw_access_readpages(struct file *filp,
>  	}
>  	DBG_BUGON(!list_empty(pages));
>  
> -	/* the rare case (end in gaps) */
> -	if (unlikely(bio))
> +	if (bio)
>  		__submit_bio(bio, REQ_OP_READ, 0);
>  	return 0;
>  }
> 
>>  		/* err should reassign to 0 after submitting */
>>  		err = 0;
>>  		goto submit_bio_out;
>> -- 
>> 2.17.1
>>
> ---end quoted text---
> _______________________________________________
> devel mailing list
> devel at linuxdriverproject.org
> http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel
> 
