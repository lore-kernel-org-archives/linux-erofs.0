From: gaoxiang25@huawei.com (Gao Xiang)
Date: Tue, 3 Jul 2018 17:44:19 +0800
Subject: [PATCH 11/11] erofs: support tracepoint
In-Reply-To: <20180622020131.65525-11-yuchao0@huawei.com>
References: <20180622020131.65525-1-yuchao0@huawei.com>
 <20180622020131.65525-11-yuchao0@huawei.com>
Message-ID: <ad8b5812-699e-9c99-3d76-02fa65635c6c@huawei.com>

Hi Chao,

On 2018/6/22 10:01, Chao Yu wrote:
> Add tracepoints for ->readpage{,s}, ->lookup.
> 
> Signed-off-by: Chao Yu <yuchao0 at huawei.com> ---

Very useful feature (I could use it for the new unzip implementation :) )

>  fs/erofs/data.c              |   8 +++
>  fs/erofs/namei.c             |   5 ++
>  fs/erofs/super.c             |   2 +
>  fs/erofs/unzip.c             |  10 +++-
>  include/trace/events/erofs.h | 109 +++++++++++++++++++++++++++++++++++
>  5 files changed, 133 insertions(+), 1 deletion(-)
>  create mode 100644 include/trace/events/erofs.h
> 
> +	trace_erofs_readpage(page, true);
> +
>  	bio = erofs_read_raw_page(NULL, page->mapping,
>  		page, &last_block, 1, false);
>  
> @@ -354,6 +359,9 @@ static int erofs_raw_access_readpages(struct file *filp,
>  	erofs_off_t last_block;
>  	struct bio *bio = NULL;
>  	gfp_t gfp = readahead_gfp_mask(mapping);
> +	struct page *page = list_last_entry(pages, struct page, lru);
> +
> +	trace_erofs_readpages(mapping->host, page, nr_pages, true);
>  
>  	for (; nr_pages; --nr_pages) {
>  		struct page *page = list_entry(pages->prev, struct page, lru);

minor, how about remove the in-loop 'page' defination?

Reviewed-by: Gao Xiang <gaoxiang25 at huawei.com>

Thanks,
Gao Xiang

> diff --git a/fs/erofs/namei.c b/fs/erofs/namei.c
> index e30294b279d1..b701d9ba52a6 100644
> --- a/fs/erofs/namei.c
> +++ b/fs/erofs/namei.c
