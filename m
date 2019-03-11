From: gaoxiang25@huawei.com (Gao Xiang)
Date: Mon, 11 Mar 2019 17:18:45 +0800
Subject: [PATCH] staging: erofs: fix to handle error path of erofs_vmap()
In-Reply-To: <20190311090047.6652-1-yuchao0@huawei.com>
References: <20190311090047.6652-1-yuchao0@huawei.com>
Message-ID: <64c31dcb-ea01-86b2-f2e4-8b70e9e78a01@huawei.com>


On 2019/3/11 17:00, Chao Yu wrote:
> erofs_vmap() wrapped vmap() and vm_map_ram() to return virtual
> continuous memory, but both of them can failed due to a lot of
> reason, previously, erofs_vmap()'s callers didn't handle them,
> which can potentially cause NULL pointer access, fix it.
> 
> Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>
> Signed-off-by: Chao Yu <yuchao0 at huawei.com>

Fixes: 3883a79abd02 ("staging: erofs: introduce VLE decompression support")
Fixes: 0d40d6e399c1 ("staging: erofs: add a generic z_erofs VLE decompressor")
Cc: <stable at vger.kernel.org> # 4.19+

Thanks,
Gao Xiang

> ---
>  drivers/staging/erofs/unzip_vle.c     | 4 ++++
>  drivers/staging/erofs/unzip_vle_lz4.c | 7 +++++--
>  2 files changed, 9 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/staging/erofs/unzip_vle.c b/drivers/staging/erofs/unzip_vle.c
> index 8715bc50e09c..c7b3b21123c1 100644
> --- a/drivers/staging/erofs/unzip_vle.c
> +++ b/drivers/staging/erofs/unzip_vle.c
> @@ -1029,6 +1029,10 @@ static int z_erofs_vle_unzip(struct super_block *sb,
>  
>  skip_allocpage:
>  	vout = erofs_vmap(pages, nr_pages);
> +	if (!vout) {
> +		err = -ENOMEM;
> +		goto out;
> +	}
>  
>  	err = z_erofs_vle_unzip_vmap(compressed_pages,
>  		clusterpages, vout, llen, work->pageofs, overlapped);
> diff --git a/drivers/staging/erofs/unzip_vle_lz4.c b/drivers/staging/erofs/unzip_vle_lz4.c
> index 48b263a2731a..0daac9b984a8 100644
> --- a/drivers/staging/erofs/unzip_vle_lz4.c
> +++ b/drivers/staging/erofs/unzip_vle_lz4.c
> @@ -136,10 +136,13 @@ int z_erofs_vle_unzip_fast_percpu(struct page **compressed_pages,
>  
>  	nr_pages = DIV_ROUND_UP(outlen + pageofs, PAGE_SIZE);
>  
> -	if (clusterpages == 1)
> +	if (clusterpages == 1) {
>  		vin = kmap_atomic(compressed_pages[0]);
> -	else
> +	} else {
>  		vin = erofs_vmap(compressed_pages, clusterpages);
> +		if (!vin)
> +			return -ENOMEM;
> +	}
>  
>  	preempt_disable();
>  	vout = erofs_pcpubuf[smp_processor_id()].data;
> 
